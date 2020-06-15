
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
8010002d:	b8 00 37 10 80       	mov    $0x80103700,%eax
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
8010004c:	68 80 86 10 80       	push   $0x80108680
80100051:	68 e0 d5 10 80       	push   $0x8010d5e0
80100056:	e8 45 4d 00 00       	call   80104da0 <initlock>
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
80100092:	68 87 86 10 80       	push   $0x80108687
80100097:	50                   	push   %eax
80100098:	e8 d3 4b 00 00       	call   80104c70 <initsleeplock>
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
801000e4:	e8 f7 4d 00 00       	call   80104ee0 <acquire>
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
80100162:	e8 39 4e 00 00       	call   80104fa0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 3e 4b 00 00       	call   80104cb0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 7d 27 00 00       	call   80102900 <iderw>
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
80100193:	68 8e 86 10 80       	push   $0x8010868e
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
801001ae:	e8 9d 4b 00 00       	call   80104d50 <holdingsleep>
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
801001c4:	e9 37 27 00 00       	jmp    80102900 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 9f 86 10 80       	push   $0x8010869f
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
801001ef:	e8 5c 4b 00 00       	call   80104d50 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 0c 4b 00 00       	call   80104d10 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
8010020b:	e8 d0 4c 00 00       	call   80104ee0 <acquire>
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
8010025c:	e9 3f 4d 00 00       	jmp    80104fa0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 a6 86 10 80       	push   $0x801086a6
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
80100280:	e8 2b 19 00 00       	call   80101bb0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010028c:	e8 4f 4c 00 00       	call   80104ee0 <acquire>
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
801002c5:	e8 56 45 00 00       	call   80104820 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 e0 ff 11 80    	mov    0x8011ffe0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 e4 ff 11 80    	cmp    0x8011ffe4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 e0 3d 00 00       	call   801040c0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 c5 10 80       	push   $0x8010c520
801002ef:	e8 ac 4c 00 00       	call   80104fa0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 d4 17 00 00       	call   80101ad0 <ilock>
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
8010034d:	e8 4e 4c 00 00       	call   80104fa0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 76 17 00 00       	call   80101ad0 <ilock>
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
801003a9:	e8 e2 2b 00 00       	call   80102f90 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ad 86 10 80       	push   $0x801086ad
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 d9 92 10 80 	movl   $0x801092d9,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 e3 49 00 00       	call   80104dc0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 c1 86 10 80       	push   $0x801086c1
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
8010043a:	e8 f1 63 00 00       	call   80106830 <uartputc>
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
801004ec:	e8 3f 63 00 00       	call   80106830 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 33 63 00 00       	call   80106830 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 27 63 00 00       	call   80106830 <uartputc>
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
80100524:	e8 77 4b 00 00       	call   801050a0 <memmove>
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
80100541:	e8 aa 4a 00 00       	call   80104ff0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 c5 86 10 80       	push   $0x801086c5
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
801005b1:	0f b6 92 f0 86 10 80 	movzbl -0x7fef7910(%edx),%edx
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
8010060f:	e8 9c 15 00 00       	call   80101bb0 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010061b:	e8 c0 48 00 00       	call   80104ee0 <acquire>
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
80100647:	e8 54 49 00 00       	call   80104fa0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 7b 14 00 00       	call   80101ad0 <ilock>

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
8010071f:	e8 7c 48 00 00       	call   80104fa0 <release>
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
801007d0:	ba d8 86 10 80       	mov    $0x801086d8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 c5 10 80       	push   $0x8010c520
801007f0:	e8 eb 46 00 00       	call   80104ee0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 df 86 10 80       	push   $0x801086df
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
80100823:	e8 b8 46 00 00       	call   80104ee0 <acquire>
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
80100888:	e8 13 47 00 00       	call   80104fa0 <release>
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
80100916:	e8 55 41 00 00       	call   80104a70 <wakeup>
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
80100997:	e9 b4 41 00 00       	jmp    80104b50 <procdump>
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
801009c6:	68 e8 86 10 80       	push   $0x801086e8
801009cb:	68 20 c5 10 80       	push   $0x8010c520
801009d0:	e8 cb 43 00 00       	call   80104da0 <initlock>

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
801009f9:	e8 b2 20 00 00       	call   80102ab0 <ioapicenable>
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
80100ab6:	81 ec 6c 04 00 00    	sub    $0x46c,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  // cprintf("before setup\n");
  struct proc *curproc = myproc();
80100abc:	e8 ff 35 00 00       	call   801040c0 <myproc>
80100ac1:	89 c3                	mov    %eax,%ebx
  int advance_q_bu[MAX_PYSC_PAGES];
  struct file* swap_file_bu = 0;
  struct file* temp_swap_file = 0;
  #endif

  begin_op();
80100ac3:	e8 38 29 00 00       	call   80103400 <begin_op>

  if((ip = namei(path)) == 0){
80100ac8:	83 ec 0c             	sub    $0xc,%esp
80100acb:	ff 75 08             	pushl  0x8(%ebp)
80100ace:	e8 5d 18 00 00       	call   80102330 <namei>
80100ad3:	83 c4 10             	add    $0x10,%esp
80100ad6:	85 c0                	test   %eax,%eax
80100ad8:	89 85 b0 fb ff ff    	mov    %eax,-0x450(%ebp)
80100ade:	0f 84 94 05 00 00    	je     80101078 <exec+0x5c8>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae4:	8b b5 b0 fb ff ff    	mov    -0x450(%ebp),%esi
80100aea:	83 ec 0c             	sub    $0xc,%esp
80100aed:	56                   	push   %esi
80100aee:	e8 dd 0f 00 00       	call   80101ad0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100af3:	8d 85 e4 fb ff ff    	lea    -0x41c(%ebp),%eax
80100af9:	6a 34                	push   $0x34
80100afb:	6a 00                	push   $0x0
80100afd:	50                   	push   %eax
80100afe:	56                   	push   %esi
80100aff:	e8 ac 12 00 00       	call   80101db0 <readi>
80100b04:	83 c4 20             	add    $0x20,%esp
80100b07:	83 f8 34             	cmp    $0x34,%eax
80100b0a:	74 24                	je     80100b30 <exec+0x80>
    }
    #endif
    freevm(pgdir);
  }
  if(ip){
    iunlockput(ip);
80100b0c:	83 ec 0c             	sub    $0xc,%esp
80100b0f:	ff b5 b0 fb ff ff    	pushl  -0x450(%ebp)
80100b15:	e8 46 12 00 00       	call   80101d60 <iunlockput>
    end_op();
80100b1a:	e8 51 29 00 00       	call   80103470 <end_op>
80100b1f:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b2a:	5b                   	pop    %ebx
80100b2b:	5e                   	pop    %esi
80100b2c:	5f                   	pop    %edi
80100b2d:	5d                   	pop    %ebp
80100b2e:	c3                   	ret    
80100b2f:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b30:	81 bd e4 fb ff ff 7f 	cmpl   $0x464c457f,-0x41c(%ebp)
80100b37:	45 4c 46 
80100b3a:	75 d0                	jne    80100b0c <exec+0x5c>
  if((pgdir = setupkvm()) == 0)
80100b3c:	e8 ef 71 00 00       	call   80107d30 <setupkvm>
80100b41:	85 c0                	test   %eax,%eax
80100b43:	89 85 ac fb ff ff    	mov    %eax,-0x454(%ebp)
80100b49:	74 c1                	je     80100b0c <exec+0x5c>
  if (curproc->pid > 2){
80100b4b:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80100b4f:	0f 8e 80 04 00 00    	jle    80100fd5 <exec+0x525>
    pg_flt_bu = curproc->num_of_pagefaults_occurs;
80100b55:	8b 83 c8 03 00 00    	mov    0x3c8(%ebx),%eax
80100b5b:	8d 95 68 fe ff ff    	lea    -0x198(%ebp),%edx
80100b61:	8d bd 18 fc ff ff    	lea    -0x3e8(%ebp),%edi
80100b67:	8d 8d e8 fc ff ff    	lea    -0x318(%ebp),%ecx
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
80100b6d:	31 f6                	xor    %esi,%esi
80100b6f:	89 95 b4 fb ff ff    	mov    %edx,-0x44c(%ebp)
80100b75:	89 bd a8 fb ff ff    	mov    %edi,-0x458(%ebp)
    pg_flt_bu = curproc->num_of_pagefaults_occurs;
80100b7b:	89 85 9c fb ff ff    	mov    %eax,-0x464(%ebp)
    pg_mem_bu = curproc->num_of_actual_pages_in_mem;
80100b81:	8b 83 c4 03 00 00    	mov    0x3c4(%ebx),%eax
80100b87:	89 85 98 fb ff ff    	mov    %eax,-0x468(%ebp)
    pg_swp_bu = curproc->num_of_pages_in_swap_file;
80100b8d:	8b 83 c0 03 00 00    	mov    0x3c0(%ebx),%eax
80100b93:	89 85 94 fb ff ff    	mov    %eax,-0x46c(%ebp)
    pg_out_bu = curproc->num_of_pageOut_occured;
80100b99:	8b 83 cc 03 00 00    	mov    0x3cc(%ebx),%eax
80100b9f:	89 85 a0 fb ff ff    	mov    %eax,-0x460(%ebp)
80100ba5:	31 c0                	xor    %eax,%eax
80100ba7:	89 f6                	mov    %esi,%esi
80100ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      mem_pginfo_bu[i] = curproc->ram_pages[i];
80100bb0:	8b bc 03 00 02 00 00 	mov    0x200(%ebx,%eax,1),%edi
      swp_pginfo_bu[i] = curproc->swapped_out_pages[i];
80100bb7:	8b 95 b4 fb ff ff    	mov    -0x44c(%ebp),%edx
      mem_pginfo_bu[i] = curproc->ram_pages[i];
80100bbd:	89 3c 01             	mov    %edi,(%ecx,%eax,1)
80100bc0:	8b bc 03 04 02 00 00 	mov    0x204(%ebx,%eax,1),%edi
80100bc7:	89 7c 01 04          	mov    %edi,0x4(%ecx,%eax,1)
80100bcb:	8b bc 03 08 02 00 00 	mov    0x208(%ebx,%eax,1),%edi
80100bd2:	89 7c 01 08          	mov    %edi,0x8(%ecx,%eax,1)
80100bd6:	8b bc 03 0c 02 00 00 	mov    0x20c(%ebx,%eax,1),%edi
80100bdd:	89 7c 01 0c          	mov    %edi,0xc(%ecx,%eax,1)
80100be1:	8b bc 03 10 02 00 00 	mov    0x210(%ebx,%eax,1),%edi
80100be8:	89 7c 01 10          	mov    %edi,0x10(%ecx,%eax,1)
80100bec:	8b bc 03 14 02 00 00 	mov    0x214(%ebx,%eax,1),%edi
80100bf3:	89 7c 01 14          	mov    %edi,0x14(%ecx,%eax,1)
      swp_pginfo_bu[i] = curproc->swapped_out_pages[i];
80100bf7:	8b bc 03 80 00 00 00 	mov    0x80(%ebx,%eax,1),%edi
80100bfe:	89 3c 02             	mov    %edi,(%edx,%eax,1)
80100c01:	8b bc 03 84 00 00 00 	mov    0x84(%ebx,%eax,1),%edi
80100c08:	89 7c 02 04          	mov    %edi,0x4(%edx,%eax,1)
80100c0c:	8b bc 03 88 00 00 00 	mov    0x88(%ebx,%eax,1),%edi
80100c13:	89 7c 02 08          	mov    %edi,0x8(%edx,%eax,1)
80100c17:	8b bc 03 8c 00 00 00 	mov    0x8c(%ebx,%eax,1),%edi
80100c1e:	89 7c 02 0c          	mov    %edi,0xc(%edx,%eax,1)
80100c22:	8b bc 03 90 00 00 00 	mov    0x90(%ebx,%eax,1),%edi
80100c29:	89 7c 02 10          	mov    %edi,0x10(%edx,%eax,1)
80100c2d:	8b bc 03 94 00 00 00 	mov    0x94(%ebx,%eax,1),%edi
80100c34:	89 7c 02 14          	mov    %edi,0x14(%edx,%eax,1)
      advance_q_bu[i] = curproc->advance_queue[i];//AQ
80100c38:	8b bc b3 80 03 00 00 	mov    0x380(%ebx,%esi,4),%edi
80100c3f:	83 c0 18             	add    $0x18,%eax
80100c42:	8b 95 a8 fb ff ff    	mov    -0x458(%ebp),%edx
80100c48:	89 3c b2             	mov    %edi,(%edx,%esi,4)
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
80100c4b:	83 c6 01             	add    $0x1,%esi
80100c4e:	83 fe 10             	cmp    $0x10,%esi
80100c51:	0f 85 59 ff ff ff    	jne    80100bb0 <exec+0x100>
80100c57:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80100c5d:	8d 93 80 03 00 00    	lea    0x380(%ebx),%edx
80100c63:	8d 8b 00 02 00 00    	lea    0x200(%ebx),%ecx
  p->num_of_pageOut_occured = 0;
80100c69:	c7 83 cc 03 00 00 00 	movl   $0x0,0x3cc(%ebx)
80100c70:	00 00 00 
  p->num_of_pagefaults_occurs = 0;
80100c73:	c7 83 c8 03 00 00 00 	movl   $0x0,0x3c8(%ebx)
80100c7a:	00 00 00 
  p->num_of_actual_pages_in_mem = 0;
80100c7d:	c7 83 c4 03 00 00 00 	movl   $0x0,0x3c4(%ebx)
80100c84:	00 00 00 
  p->num_of_pages_in_swap_file = 0;
80100c87:	c7 83 c0 03 00 00 00 	movl   $0x0,0x3c0(%ebx)
80100c8e:	00 00 00 
80100c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
80100c98:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80100c9e:	c7 80 80 01 00 00 01 	movl   $0x1,0x180(%eax)
80100ca5:	00 00 00 
80100ca8:	83 c0 18             	add    $0x18,%eax
    p->ram_pages[i].aging_counter = p->swapped_out_pages[i].aging_counter = 0;
80100cab:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
80100cb2:	c7 80 70 01 00 00 00 	movl   $0x0,0x170(%eax)
80100cb9:	00 00 00 
80100cbc:	83 c2 04             	add    $0x4,%edx
    p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
80100cbf:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
80100cc6:	c7 80 6c 01 00 00 00 	movl   $0x0,0x16c(%eax)
80100ccd:	00 00 00 
    p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
80100cd0:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
80100cd7:	c7 80 78 01 00 00 00 	movl   $0x0,0x178(%eax)
80100cde:	00 00 00 
    p->advance_queue[i] = -1;//AQ
80100ce1:	c7 42 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%edx)
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80100ce8:	39 c8                	cmp    %ecx,%eax
80100cea:	75 ac                	jne    80100c98 <exec+0x1e8>
    swap_file_bu = curproc->swapFile;
80100cec:	8b 43 7c             	mov    0x7c(%ebx),%eax
    createSwapFile(curproc);
80100cef:	83 ec 0c             	sub    $0xc,%esp
80100cf2:	53                   	push   %ebx
    swap_file_bu = curproc->swapFile;
80100cf3:	89 85 a4 fb ff ff    	mov    %eax,-0x45c(%ebp)
    createSwapFile(curproc);
80100cf9:	e8 02 19 00 00       	call   80102600 <createSwapFile>
80100cfe:	83 c4 10             	add    $0x10,%esp
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d01:	66 83 bd 10 fc ff ff 	cmpw   $0x0,-0x3f0(%ebp)
80100d08:	00 
80100d09:	8b 85 00 fc ff ff    	mov    -0x400(%ebp),%eax
80100d0f:	89 85 a8 fb ff ff    	mov    %eax,-0x458(%ebp)
80100d15:	0f 84 7c 03 00 00    	je     80101097 <exec+0x5e7>
80100d1b:	89 9d b4 fb ff ff    	mov    %ebx,-0x44c(%ebp)
  sz = 0;
80100d21:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d23:	31 f6                	xor    %esi,%esi
80100d25:	8b 9d b0 fb ff ff    	mov    -0x450(%ebp),%ebx
80100d2b:	e9 82 00 00 00       	jmp    80100db2 <exec+0x302>
    if(ph.type != ELF_PROG_LOAD)
80100d30:	83 bd c4 fb ff ff 01 	cmpl   $0x1,-0x43c(%ebp)
80100d37:	75 67                	jne    80100da0 <exec+0x2f0>
    if(ph.memsz < ph.filesz)
80100d39:	8b 85 d8 fb ff ff    	mov    -0x428(%ebp),%eax
80100d3f:	3b 85 d4 fb ff ff    	cmp    -0x42c(%ebp),%eax
80100d45:	0f 82 8e 00 00 00    	jb     80100dd9 <exec+0x329>
80100d4b:	03 85 cc fb ff ff    	add    -0x434(%ebp),%eax
80100d51:	0f 82 82 00 00 00    	jb     80100dd9 <exec+0x329>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100d57:	83 ec 04             	sub    $0x4,%esp
80100d5a:	50                   	push   %eax
80100d5b:	57                   	push   %edi
80100d5c:	ff b5 ac fb ff ff    	pushl  -0x454(%ebp)
80100d62:	e8 39 74 00 00       	call   801081a0 <allocuvm>
80100d67:	83 c4 10             	add    $0x10,%esp
80100d6a:	85 c0                	test   %eax,%eax
80100d6c:	89 c7                	mov    %eax,%edi
80100d6e:	74 69                	je     80100dd9 <exec+0x329>
    if(ph.vaddr % PGSIZE != 0)
80100d70:	8b 85 cc fb ff ff    	mov    -0x434(%ebp),%eax
80100d76:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100d7b:	75 5c                	jne    80100dd9 <exec+0x329>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d7d:	83 ec 0c             	sub    $0xc,%esp
80100d80:	ff b5 d4 fb ff ff    	pushl  -0x42c(%ebp)
80100d86:	ff b5 c8 fb ff ff    	pushl  -0x438(%ebp)
80100d8c:	53                   	push   %ebx
80100d8d:	50                   	push   %eax
80100d8e:	ff b5 ac fb ff ff    	pushl  -0x454(%ebp)
80100d94:	e8 b7 6c 00 00       	call   80107a50 <loaduvm>
80100d99:	83 c4 20             	add    $0x20,%esp
80100d9c:	85 c0                	test   %eax,%eax
80100d9e:	78 39                	js     80100dd9 <exec+0x329>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100da0:	0f b7 85 10 fc ff ff 	movzwl -0x3f0(%ebp),%eax
80100da7:	83 c6 01             	add    $0x1,%esi
80100daa:	39 f0                	cmp    %esi,%eax
80100dac:	0f 8e 5a 02 00 00    	jle    8010100c <exec+0x55c>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100db2:	89 f0                	mov    %esi,%eax
80100db4:	6a 20                	push   $0x20
80100db6:	c1 e0 05             	shl    $0x5,%eax
80100db9:	03 85 a8 fb ff ff    	add    -0x458(%ebp),%eax
80100dbf:	50                   	push   %eax
80100dc0:	8d 85 c4 fb ff ff    	lea    -0x43c(%ebp),%eax
80100dc6:	50                   	push   %eax
80100dc7:	53                   	push   %ebx
80100dc8:	e8 e3 0f 00 00       	call   80101db0 <readi>
80100dcd:	83 c4 10             	add    $0x10,%esp
80100dd0:	83 f8 20             	cmp    $0x20,%eax
80100dd3:	0f 84 57 ff ff ff    	je     80100d30 <exec+0x280>
80100dd9:	8b 9d b4 fb ff ff    	mov    -0x44c(%ebp),%ebx
    if (curproc->pid > 2){
80100ddf:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80100de3:	0f 8f bf 00 00 00    	jg     80100ea8 <exec+0x3f8>
    freevm(pgdir);
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	ff b5 ac fb ff ff    	pushl  -0x454(%ebp)
80100df2:	e8 39 6e 00 00       	call   80107c30 <freevm>
80100df7:	83 c4 10             	add    $0x10,%esp
80100dfa:	e9 0d fd ff ff       	jmp    80100b0c <exec+0x5c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100dff:	89 c6                	mov    %eax,%esi
80100e01:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100e07:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100e0a:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100e0c:	50                   	push   %eax
80100e0d:	ff b5 ac fb ff ff    	pushl  -0x454(%ebp)
80100e13:	e8 b8 6f 00 00       	call   80107dd0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100e18:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e1b:	83 c4 10             	add    $0x10,%esp
80100e1e:	8b 00                	mov    (%eax),%eax
80100e20:	85 c0                	test   %eax,%eax
80100e22:	0f 84 6d 03 00 00    	je     80101195 <exec+0x6e5>
80100e28:	89 fa                	mov    %edi,%edx
80100e2a:	89 df                	mov    %ebx,%edi
80100e2c:	89 d3                	mov    %edx,%ebx
80100e2e:	eb 23                	jmp    80100e53 <exec+0x3a3>
80100e30:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100e33:	89 b4 9d 64 fc ff ff 	mov    %esi,-0x39c(%ebp,%ebx,4)
  for(argc = 0; argv[argc]; argc++) {
80100e3a:	83 c3 01             	add    $0x1,%ebx
    ustack[3+argc] = sp;
80100e3d:	8d 8d 58 fc ff ff    	lea    -0x3a8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100e43:	8b 04 98             	mov    (%eax,%ebx,4),%eax
80100e46:	85 c0                	test   %eax,%eax
80100e48:	0f 84 52 02 00 00    	je     801010a0 <exec+0x5f0>
    if(argc >= MAXARG)
80100e4e:	83 fb 20             	cmp    $0x20,%ebx
80100e51:	74 39                	je     80100e8c <exec+0x3dc>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e53:	83 ec 0c             	sub    $0xc,%esp
80100e56:	50                   	push   %eax
80100e57:	e8 b4 43 00 00       	call   80105210 <strlen>
80100e5c:	f7 d0                	not    %eax
80100e5e:	01 c6                	add    %eax,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e60:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e63:	59                   	pop    %ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e64:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e67:	ff 34 98             	pushl  (%eax,%ebx,4)
80100e6a:	e8 a1 43 00 00       	call   80105210 <strlen>
80100e6f:	83 c0 01             	add    $0x1,%eax
80100e72:	50                   	push   %eax
80100e73:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e76:	ff 34 98             	pushl  (%eax,%ebx,4)
80100e79:	56                   	push   %esi
80100e7a:	ff b5 ac fb ff ff    	pushl  -0x454(%ebp)
80100e80:	e8 0b 71 00 00       	call   80107f90 <copyout>
80100e85:	83 c4 20             	add    $0x20,%esp
80100e88:	85 c0                	test   %eax,%eax
80100e8a:	79 a4                	jns    80100e30 <exec+0x380>
    if (curproc->pid > 2){
80100e8c:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80100e90:	89 fb                	mov    %edi,%ebx
80100e92:	0f 8e ca 01 00 00    	jle    80101062 <exec+0x5b2>
  ip = 0;
80100e98:	c7 85 b0 fb ff ff 00 	movl   $0x0,-0x450(%ebp)
80100e9f:	00 00 00 
80100ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      curproc->num_of_pagefaults_occurs = pg_flt_bu;
80100ea8:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
80100eae:	8d bd 18 fc ff ff    	lea    -0x3e8(%ebp),%edi
80100eb4:	8d 8d e8 fc ff ff    	lea    -0x318(%ebp),%ecx
80100eba:	8d 95 68 fe ff ff    	lea    -0x198(%ebp),%edx
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
80100ec0:	31 f6                	xor    %esi,%esi
80100ec2:	89 bd b4 fb ff ff    	mov    %edi,-0x44c(%ebp)
      curproc->num_of_pagefaults_occurs = pg_flt_bu;
80100ec8:	89 83 c8 03 00 00    	mov    %eax,0x3c8(%ebx)
      curproc->num_of_actual_pages_in_mem = pg_mem_bu;
80100ece:	8b 85 98 fb ff ff    	mov    -0x468(%ebp),%eax
80100ed4:	89 83 c4 03 00 00    	mov    %eax,0x3c4(%ebx)
      curproc->num_of_pages_in_swap_file = pg_swp_bu;
80100eda:	8b 85 94 fb ff ff    	mov    -0x46c(%ebp),%eax
80100ee0:	89 83 c0 03 00 00    	mov    %eax,0x3c0(%ebx)
      curproc->num_of_pageOut_occured = pg_out_bu;
80100ee6:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
80100eec:	89 83 cc 03 00 00    	mov    %eax,0x3cc(%ebx)
80100ef2:	31 c0                	xor    %eax,%eax
80100ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        curproc->ram_pages[i] = mem_pginfo_bu[i];
80100ef8:	8b 3c 01             	mov    (%ecx,%eax,1),%edi
80100efb:	89 bc 03 00 02 00 00 	mov    %edi,0x200(%ebx,%eax,1)
80100f02:	8b 7c 01 04          	mov    0x4(%ecx,%eax,1),%edi
80100f06:	89 bc 03 04 02 00 00 	mov    %edi,0x204(%ebx,%eax,1)
80100f0d:	8b 7c 01 08          	mov    0x8(%ecx,%eax,1),%edi
80100f11:	89 bc 03 08 02 00 00 	mov    %edi,0x208(%ebx,%eax,1)
80100f18:	8b 7c 01 0c          	mov    0xc(%ecx,%eax,1),%edi
80100f1c:	89 bc 03 0c 02 00 00 	mov    %edi,0x20c(%ebx,%eax,1)
80100f23:	8b 7c 01 10          	mov    0x10(%ecx,%eax,1),%edi
80100f27:	89 bc 03 10 02 00 00 	mov    %edi,0x210(%ebx,%eax,1)
80100f2e:	8b 7c 01 14          	mov    0x14(%ecx,%eax,1),%edi
80100f32:	89 bc 03 14 02 00 00 	mov    %edi,0x214(%ebx,%eax,1)
        curproc->swapped_out_pages[i] = swp_pginfo_bu[i];
80100f39:	8b 3c 02             	mov    (%edx,%eax,1),%edi
80100f3c:	89 bc 03 80 00 00 00 	mov    %edi,0x80(%ebx,%eax,1)
80100f43:	8b 7c 02 04          	mov    0x4(%edx,%eax,1),%edi
80100f47:	89 bc 03 84 00 00 00 	mov    %edi,0x84(%ebx,%eax,1)
80100f4e:	8b 7c 02 08          	mov    0x8(%edx,%eax,1),%edi
80100f52:	89 bc 03 88 00 00 00 	mov    %edi,0x88(%ebx,%eax,1)
80100f59:	8b 7c 02 0c          	mov    0xc(%edx,%eax,1),%edi
80100f5d:	89 bc 03 8c 00 00 00 	mov    %edi,0x8c(%ebx,%eax,1)
80100f64:	8b 7c 02 10          	mov    0x10(%edx,%eax,1),%edi
80100f68:	89 bc 03 90 00 00 00 	mov    %edi,0x90(%ebx,%eax,1)
80100f6f:	8b 7c 02 14          	mov    0x14(%edx,%eax,1),%edi
80100f73:	89 bc 03 94 00 00 00 	mov    %edi,0x94(%ebx,%eax,1)
        curproc->advance_queue[i] = advance_q_bu[i];//AQ
80100f7a:	8b bd b4 fb ff ff    	mov    -0x44c(%ebp),%edi
80100f80:	83 c0 18             	add    $0x18,%eax
80100f83:	8b 3c b7             	mov    (%edi,%esi,4),%edi
80100f86:	89 bc b3 80 03 00 00 	mov    %edi,0x380(%ebx,%esi,4)
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
80100f8d:	83 c6 01             	add    $0x1,%esi
80100f90:	83 fe 10             	cmp    $0x10,%esi
80100f93:	0f 85 5f ff ff ff    	jne    80100ef8 <exec+0x448>
      removeSwapFile(curproc);
80100f99:	83 ec 0c             	sub    $0xc,%esp
80100f9c:	53                   	push   %ebx
80100f9d:	e8 5e 14 00 00       	call   80102400 <removeSwapFile>
      curproc->swapFile = swap_file_bu;
80100fa2:	8b 85 a4 fb ff ff    	mov    -0x45c(%ebp),%eax
80100fa8:	89 43 7c             	mov    %eax,0x7c(%ebx)
    freevm(pgdir);
80100fab:	58                   	pop    %eax
80100fac:	ff b5 ac fb ff ff    	pushl  -0x454(%ebp)
80100fb2:	e8 79 6c 00 00       	call   80107c30 <freevm>
  if(ip){
80100fb7:	8b 95 b0 fb ff ff    	mov    -0x450(%ebp),%edx
80100fbd:	83 c4 10             	add    $0x10,%esp
80100fc0:	85 d2                	test   %edx,%edx
80100fc2:	0f 85 44 fb ff ff    	jne    80100b0c <exec+0x5c>
}
80100fc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80100fcb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fd0:	5b                   	pop    %ebx
80100fd1:	5e                   	pop    %esi
80100fd2:	5f                   	pop    %edi
80100fd3:	5d                   	pop    %ebp
80100fd4:	c3                   	ret    
  struct file* swap_file_bu = 0;
80100fd5:	c7 85 a4 fb ff ff 00 	movl   $0x0,-0x45c(%ebp)
80100fdc:	00 00 00 
  uint pg_out_bu = 0, pg_flt_bu = 0, pg_mem_bu = 0, pg_swp_bu = 0;
80100fdf:	c7 85 94 fb ff ff 00 	movl   $0x0,-0x46c(%ebp)
80100fe6:	00 00 00 
80100fe9:	c7 85 98 fb ff ff 00 	movl   $0x0,-0x468(%ebp)
80100ff0:	00 00 00 
80100ff3:	c7 85 9c fb ff ff 00 	movl   $0x0,-0x464(%ebp)
80100ffa:	00 00 00 
80100ffd:	c7 85 a0 fb ff ff 00 	movl   $0x0,-0x460(%ebp)
80101004:	00 00 00 
80101007:	e9 f5 fc ff ff       	jmp    80100d01 <exec+0x251>
8010100c:	8d b7 ff 0f 00 00    	lea    0xfff(%edi),%esi
80101012:	8b 9d b4 fb ff ff    	mov    -0x44c(%ebp),%ebx
80101018:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
8010101e:	8d be 00 20 00 00    	lea    0x2000(%esi),%edi
  iunlockput(ip);
80101024:	83 ec 0c             	sub    $0xc,%esp
80101027:	ff b5 b0 fb ff ff    	pushl  -0x450(%ebp)
8010102d:	e8 2e 0d 00 00       	call   80101d60 <iunlockput>
  end_op();
80101032:	e8 39 24 00 00       	call   80103470 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0){
80101037:	83 c4 0c             	add    $0xc,%esp
8010103a:	57                   	push   %edi
8010103b:	56                   	push   %esi
8010103c:	ff b5 ac fb ff ff    	pushl  -0x454(%ebp)
80101042:	e8 59 71 00 00       	call   801081a0 <allocuvm>
80101047:	83 c4 10             	add    $0x10,%esp
8010104a:	85 c0                	test   %eax,%eax
8010104c:	89 85 b4 fb ff ff    	mov    %eax,-0x44c(%ebp)
80101052:	0f 85 a7 fd ff ff    	jne    80100dff <exec+0x34f>
    if (curproc->pid > 2){
80101058:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
8010105c:	0f 8f 36 fe ff ff    	jg     80100e98 <exec+0x3e8>
    freevm(pgdir);
80101062:	83 ec 0c             	sub    $0xc,%esp
80101065:	ff b5 ac fb ff ff    	pushl  -0x454(%ebp)
8010106b:	e8 c0 6b 00 00       	call   80107c30 <freevm>
80101070:	83 c4 10             	add    $0x10,%esp
80101073:	e9 50 ff ff ff       	jmp    80100fc8 <exec+0x518>
    end_op();
80101078:	e8 f3 23 00 00       	call   80103470 <end_op>
    cprintf("exec: fail\n");
8010107d:	83 ec 0c             	sub    $0xc,%esp
80101080:	68 01 87 10 80       	push   $0x80108701
80101085:	e8 d6 f5 ff ff       	call   80100660 <cprintf>
    return -1;
8010108a:	83 c4 10             	add    $0x10,%esp
8010108d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101092:	e9 90 fa ff ff       	jmp    80100b27 <exec+0x77>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101097:	31 f6                	xor    %esi,%esi
80101099:	bf 00 20 00 00       	mov    $0x2000,%edi
8010109e:	eb 84                	jmp    80101024 <exec+0x574>
801010a0:	89 d8                	mov    %ebx,%eax
801010a2:	89 fb                	mov    %edi,%ebx
801010a4:	89 c7                	mov    %eax,%edi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801010a6:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
801010ad:	89 f2                	mov    %esi,%edx
  ustack[3+argc] = 0;
801010af:	c7 84 bd 64 fc ff ff 	movl   $0x0,-0x39c(%ebp,%edi,4)
801010b6:	00 00 00 00 
  ustack[1] = argc;
801010ba:	89 bd 5c fc ff ff    	mov    %edi,-0x3a4(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
801010c0:	c7 85 58 fc ff ff ff 	movl   $0xffffffff,-0x3a8(%ebp)
801010c7:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801010ca:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
801010cc:	83 c0 0c             	add    $0xc,%eax
801010cf:	29 c6                	sub    %eax,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801010d1:	50                   	push   %eax
801010d2:	51                   	push   %ecx
801010d3:	56                   	push   %esi
801010d4:	ff b5 ac fb ff ff    	pushl  -0x454(%ebp)
  sp -= (3+argc+1) * 4;
801010da:	89 f7                	mov    %esi,%edi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801010dc:	89 95 60 fc ff ff    	mov    %edx,-0x3a0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801010e2:	e8 a9 6e 00 00       	call   80107f90 <copyout>
801010e7:	83 c4 10             	add    $0x10,%esp
801010ea:	85 c0                	test   %eax,%eax
801010ec:	0f 88 66 ff ff ff    	js     80101058 <exec+0x5a8>
  for(last=s=path; *s; s++)
801010f2:	8b 45 08             	mov    0x8(%ebp),%eax
801010f5:	0f b6 10             	movzbl (%eax),%edx
801010f8:	84 d2                	test   %dl,%dl
801010fa:	74 15                	je     80101111 <exec+0x661>
801010fc:	89 c1                	mov    %eax,%ecx
801010fe:	83 c0 01             	add    $0x1,%eax
80101101:	80 fa 2f             	cmp    $0x2f,%dl
80101104:	0f b6 10             	movzbl (%eax),%edx
80101107:	0f 44 c8             	cmove  %eax,%ecx
8010110a:	84 d2                	test   %dl,%dl
8010110c:	75 f0                	jne    801010fe <exec+0x64e>
8010110e:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80101111:	8d 43 6c             	lea    0x6c(%ebx),%eax
80101114:	83 ec 04             	sub    $0x4,%esp
80101117:	6a 10                	push   $0x10
80101119:	ff 75 08             	pushl  0x8(%ebp)
8010111c:	50                   	push   %eax
8010111d:	e8 ae 40 00 00       	call   801051d0 <safestrcpy>
  curproc->pgdir = pgdir;
80101122:	8b 85 ac fb ff ff    	mov    -0x454(%ebp),%eax
  oldpgdir = curproc->pgdir;
80101128:	8b 73 04             	mov    0x4(%ebx),%esi
  if (curproc->pid > 2){
8010112b:	83 c4 10             	add    $0x10,%esp
  curproc->pgdir = pgdir;
8010112e:	89 43 04             	mov    %eax,0x4(%ebx)
  curproc->sz = sz;
80101131:	8b 85 b4 fb ff ff    	mov    -0x44c(%ebp),%eax
80101137:	89 03                	mov    %eax,(%ebx)
  curproc->tf->eip = elf.entry;  // main
80101139:	8b 43 18             	mov    0x18(%ebx),%eax
8010113c:	8b 95 fc fb ff ff    	mov    -0x404(%ebp),%edx
80101142:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101145:	8b 43 18             	mov    0x18(%ebx),%eax
80101148:	89 78 44             	mov    %edi,0x44(%eax)
  if (curproc->pid > 2){
8010114b:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
8010114f:	7e 1b                	jle    8010116c <exec+0x6bc>
    curproc->swapFile = swap_file_bu;
80101151:	8b 85 a4 fb ff ff    	mov    -0x45c(%ebp),%eax
    temp_swap_file = curproc->swapFile;
80101157:	8b 7b 7c             	mov    0x7c(%ebx),%edi
    removeSwapFile(curproc);
8010115a:	83 ec 0c             	sub    $0xc,%esp
    curproc->swapFile = swap_file_bu;
8010115d:	89 43 7c             	mov    %eax,0x7c(%ebx)
    removeSwapFile(curproc);
80101160:	53                   	push   %ebx
80101161:	e8 9a 12 00 00       	call   80102400 <removeSwapFile>
    curproc->swapFile = temp_swap_file;
80101166:	89 7b 7c             	mov    %edi,0x7c(%ebx)
80101169:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(pgdir));
8010116c:	8b 85 ac fb ff ff    	mov    -0x454(%ebp),%eax
80101172:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80101177:	0f 22 d8             	mov    %eax,%cr3
  switchuvm(curproc);
8010117a:	83 ec 0c             	sub    $0xc,%esp
8010117d:	53                   	push   %ebx
8010117e:	e8 3d 67 00 00       	call   801078c0 <switchuvm>
  freevm(oldpgdir);
80101183:	89 34 24             	mov    %esi,(%esp)
80101186:	e8 a5 6a 00 00       	call   80107c30 <freevm>
  return 0;
8010118b:	83 c4 10             	add    $0x10,%esp
8010118e:	31 c0                	xor    %eax,%eax
80101190:	e9 92 f9 ff ff       	jmp    80100b27 <exec+0x77>
  for(argc = 0; argv[argc]; argc++) {
80101195:	8b b5 b4 fb ff ff    	mov    -0x44c(%ebp),%esi
8010119b:	8d 8d 58 fc ff ff    	lea    -0x3a8(%ebp),%ecx
801011a1:	e9 00 ff ff ff       	jmp    801010a6 <exec+0x5f6>
801011a6:	66 90                	xchg   %ax,%ax
801011a8:	66 90                	xchg   %ax,%ax
801011aa:	66 90                	xchg   %ax,%ax
801011ac:	66 90                	xchg   %ax,%ax
801011ae:	66 90                	xchg   %ax,%ax

801011b0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801011b0:	55                   	push   %ebp
801011b1:	89 e5                	mov    %esp,%ebp
801011b3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
801011b6:	68 0d 87 10 80       	push   $0x8010870d
801011bb:	68 00 00 12 80       	push   $0x80120000
801011c0:	e8 db 3b 00 00       	call   80104da0 <initlock>
}
801011c5:	83 c4 10             	add    $0x10,%esp
801011c8:	c9                   	leave  
801011c9:	c3                   	ret    
801011ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801011d0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801011d0:	55                   	push   %ebp
801011d1:	89 e5                	mov    %esp,%ebp
801011d3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801011d4:	bb 34 00 12 80       	mov    $0x80120034,%ebx
{
801011d9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
801011dc:	68 00 00 12 80       	push   $0x80120000
801011e1:	e8 fa 3c 00 00       	call   80104ee0 <acquire>
801011e6:	83 c4 10             	add    $0x10,%esp
801011e9:	eb 10                	jmp    801011fb <filealloc+0x2b>
801011eb:	90                   	nop
801011ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801011f0:	83 c3 18             	add    $0x18,%ebx
801011f3:	81 fb 94 09 12 80    	cmp    $0x80120994,%ebx
801011f9:	73 25                	jae    80101220 <filealloc+0x50>
    if(f->ref == 0){
801011fb:	8b 43 04             	mov    0x4(%ebx),%eax
801011fe:	85 c0                	test   %eax,%eax
80101200:	75 ee                	jne    801011f0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101202:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101205:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010120c:	68 00 00 12 80       	push   $0x80120000
80101211:	e8 8a 3d 00 00       	call   80104fa0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101216:	89 d8                	mov    %ebx,%eax
      return f;
80101218:	83 c4 10             	add    $0x10,%esp
}
8010121b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010121e:	c9                   	leave  
8010121f:	c3                   	ret    
  release(&ftable.lock);
80101220:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101223:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101225:	68 00 00 12 80       	push   $0x80120000
8010122a:	e8 71 3d 00 00       	call   80104fa0 <release>
}
8010122f:	89 d8                	mov    %ebx,%eax
  return 0;
80101231:	83 c4 10             	add    $0x10,%esp
}
80101234:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101237:	c9                   	leave  
80101238:	c3                   	ret    
80101239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101240 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	53                   	push   %ebx
80101244:	83 ec 10             	sub    $0x10,%esp
80101247:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010124a:	68 00 00 12 80       	push   $0x80120000
8010124f:	e8 8c 3c 00 00       	call   80104ee0 <acquire>
  if(f->ref < 1)
80101254:	8b 43 04             	mov    0x4(%ebx),%eax
80101257:	83 c4 10             	add    $0x10,%esp
8010125a:	85 c0                	test   %eax,%eax
8010125c:	7e 1a                	jle    80101278 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010125e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101261:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101264:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101267:	68 00 00 12 80       	push   $0x80120000
8010126c:	e8 2f 3d 00 00       	call   80104fa0 <release>
  return f;
}
80101271:	89 d8                	mov    %ebx,%eax
80101273:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101276:	c9                   	leave  
80101277:	c3                   	ret    
    panic("filedup");
80101278:	83 ec 0c             	sub    $0xc,%esp
8010127b:	68 14 87 10 80       	push   $0x80108714
80101280:	e8 0b f1 ff ff       	call   80100390 <panic>
80101285:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101290 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	83 ec 28             	sub    $0x28,%esp
80101299:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010129c:	68 00 00 12 80       	push   $0x80120000
801012a1:	e8 3a 3c 00 00       	call   80104ee0 <acquire>
  if(f->ref < 1)
801012a6:	8b 43 04             	mov    0x4(%ebx),%eax
801012a9:	83 c4 10             	add    $0x10,%esp
801012ac:	85 c0                	test   %eax,%eax
801012ae:	0f 8e 9b 00 00 00    	jle    8010134f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
801012b4:	83 e8 01             	sub    $0x1,%eax
801012b7:	85 c0                	test   %eax,%eax
801012b9:	89 43 04             	mov    %eax,0x4(%ebx)
801012bc:	74 1a                	je     801012d8 <fileclose+0x48>
    release(&ftable.lock);
801012be:	c7 45 08 00 00 12 80 	movl   $0x80120000,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801012c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012c8:	5b                   	pop    %ebx
801012c9:	5e                   	pop    %esi
801012ca:	5f                   	pop    %edi
801012cb:	5d                   	pop    %ebp
    release(&ftable.lock);
801012cc:	e9 cf 3c 00 00       	jmp    80104fa0 <release>
801012d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
801012d8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
801012dc:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
801012de:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
801012e1:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
801012e4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
801012ea:	88 45 e7             	mov    %al,-0x19(%ebp)
801012ed:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
801012f0:	68 00 00 12 80       	push   $0x80120000
  ff = *f;
801012f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801012f8:	e8 a3 3c 00 00       	call   80104fa0 <release>
  if(ff.type == FD_PIPE)
801012fd:	83 c4 10             	add    $0x10,%esp
80101300:	83 ff 01             	cmp    $0x1,%edi
80101303:	74 13                	je     80101318 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80101305:	83 ff 02             	cmp    $0x2,%edi
80101308:	74 26                	je     80101330 <fileclose+0xa0>
}
8010130a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010130d:	5b                   	pop    %ebx
8010130e:	5e                   	pop    %esi
8010130f:	5f                   	pop    %edi
80101310:	5d                   	pop    %ebp
80101311:	c3                   	ret    
80101312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80101318:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
8010131c:	83 ec 08             	sub    $0x8,%esp
8010131f:	53                   	push   %ebx
80101320:	56                   	push   %esi
80101321:	e8 8a 28 00 00       	call   80103bb0 <pipeclose>
80101326:	83 c4 10             	add    $0x10,%esp
80101329:	eb df                	jmp    8010130a <fileclose+0x7a>
8010132b:	90                   	nop
8010132c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80101330:	e8 cb 20 00 00       	call   80103400 <begin_op>
    iput(ff.ip);
80101335:	83 ec 0c             	sub    $0xc,%esp
80101338:	ff 75 e0             	pushl  -0x20(%ebp)
8010133b:	e8 c0 08 00 00       	call   80101c00 <iput>
    end_op();
80101340:	83 c4 10             	add    $0x10,%esp
}
80101343:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101346:	5b                   	pop    %ebx
80101347:	5e                   	pop    %esi
80101348:	5f                   	pop    %edi
80101349:	5d                   	pop    %ebp
    end_op();
8010134a:	e9 21 21 00 00       	jmp    80103470 <end_op>
    panic("fileclose");
8010134f:	83 ec 0c             	sub    $0xc,%esp
80101352:	68 1c 87 10 80       	push   $0x8010871c
80101357:	e8 34 f0 ff ff       	call   80100390 <panic>
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101360 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	53                   	push   %ebx
80101364:	83 ec 04             	sub    $0x4,%esp
80101367:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010136a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010136d:	75 31                	jne    801013a0 <filestat+0x40>
    ilock(f->ip);
8010136f:	83 ec 0c             	sub    $0xc,%esp
80101372:	ff 73 10             	pushl  0x10(%ebx)
80101375:	e8 56 07 00 00       	call   80101ad0 <ilock>
    stati(f->ip, st);
8010137a:	58                   	pop    %eax
8010137b:	5a                   	pop    %edx
8010137c:	ff 75 0c             	pushl  0xc(%ebp)
8010137f:	ff 73 10             	pushl  0x10(%ebx)
80101382:	e8 f9 09 00 00       	call   80101d80 <stati>
    iunlock(f->ip);
80101387:	59                   	pop    %ecx
80101388:	ff 73 10             	pushl  0x10(%ebx)
8010138b:	e8 20 08 00 00       	call   80101bb0 <iunlock>
    return 0;
80101390:	83 c4 10             	add    $0x10,%esp
80101393:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101395:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101398:	c9                   	leave  
80101399:	c3                   	ret    
8010139a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
801013a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013a5:	eb ee                	jmp    80101395 <filestat+0x35>
801013a7:	89 f6                	mov    %esi,%esi
801013a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013b0 <fileread>:

// Read from file f.
int
fileread(struct file* f, char *addr, int n)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	57                   	push   %edi
801013b4:	56                   	push   %esi
801013b5:	53                   	push   %ebx
801013b6:	83 ec 0c             	sub    $0xc,%esp
801013b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801013bc:	8b 75 0c             	mov    0xc(%ebp),%esi
801013bf:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801013c2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801013c6:	74 60                	je     80101428 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801013c8:	8b 03                	mov    (%ebx),%eax
801013ca:	83 f8 01             	cmp    $0x1,%eax
801013cd:	74 41                	je     80101410 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801013cf:	83 f8 02             	cmp    $0x2,%eax
801013d2:	75 5b                	jne    8010142f <fileread+0x7f>
    ilock(f->ip);
801013d4:	83 ec 0c             	sub    $0xc,%esp
801013d7:	ff 73 10             	pushl  0x10(%ebx)
801013da:	e8 f1 06 00 00       	call   80101ad0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801013df:	57                   	push   %edi
801013e0:	ff 73 14             	pushl  0x14(%ebx)
801013e3:	56                   	push   %esi
801013e4:	ff 73 10             	pushl  0x10(%ebx)
801013e7:	e8 c4 09 00 00       	call   80101db0 <readi>
801013ec:	83 c4 20             	add    $0x20,%esp
801013ef:	85 c0                	test   %eax,%eax
801013f1:	89 c6                	mov    %eax,%esi
801013f3:	7e 03                	jle    801013f8 <fileread+0x48>
      f->off += r;
801013f5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801013f8:	83 ec 0c             	sub    $0xc,%esp
801013fb:	ff 73 10             	pushl  0x10(%ebx)
801013fe:	e8 ad 07 00 00       	call   80101bb0 <iunlock>
    return r;
80101403:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101406:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101409:	89 f0                	mov    %esi,%eax
8010140b:	5b                   	pop    %ebx
8010140c:	5e                   	pop    %esi
8010140d:	5f                   	pop    %edi
8010140e:	5d                   	pop    %ebp
8010140f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101410:	8b 43 0c             	mov    0xc(%ebx),%eax
80101413:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101416:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101419:	5b                   	pop    %ebx
8010141a:	5e                   	pop    %esi
8010141b:	5f                   	pop    %edi
8010141c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010141d:	e9 3e 29 00 00       	jmp    80103d60 <piperead>
80101422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101428:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010142d:	eb d7                	jmp    80101406 <fileread+0x56>
  panic("fileread");
8010142f:	83 ec 0c             	sub    $0xc,%esp
80101432:	68 26 87 10 80       	push   $0x80108726
80101437:	e8 54 ef ff ff       	call   80100390 <panic>
8010143c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101440 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	57                   	push   %edi
80101444:	56                   	push   %esi
80101445:	53                   	push   %ebx
80101446:	83 ec 1c             	sub    $0x1c,%esp
80101449:	8b 75 08             	mov    0x8(%ebp),%esi
8010144c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010144f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101453:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101456:	8b 45 10             	mov    0x10(%ebp),%eax
80101459:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010145c:	0f 84 aa 00 00 00    	je     8010150c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101462:	8b 06                	mov    (%esi),%eax
80101464:	83 f8 01             	cmp    $0x1,%eax
80101467:	0f 84 c3 00 00 00    	je     80101530 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010146d:	83 f8 02             	cmp    $0x2,%eax
80101470:	0f 85 d9 00 00 00    	jne    8010154f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101476:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101479:	31 ff                	xor    %edi,%edi
    while(i < n){
8010147b:	85 c0                	test   %eax,%eax
8010147d:	7f 34                	jg     801014b3 <filewrite+0x73>
8010147f:	e9 9c 00 00 00       	jmp    80101520 <filewrite+0xe0>
80101484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101488:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010148b:	83 ec 0c             	sub    $0xc,%esp
8010148e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101491:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101494:	e8 17 07 00 00       	call   80101bb0 <iunlock>
      end_op();
80101499:	e8 d2 1f 00 00       	call   80103470 <end_op>
8010149e:	8b 45 e0             	mov    -0x20(%ebp),%eax
801014a1:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
801014a4:	39 c3                	cmp    %eax,%ebx
801014a6:	0f 85 96 00 00 00    	jne    80101542 <filewrite+0x102>
        panic("short filewrite");
      i += r;
801014ac:	01 df                	add    %ebx,%edi
    while(i < n){
801014ae:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801014b1:	7e 6d                	jle    80101520 <filewrite+0xe0>
      int n1 = n - i;
801014b3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801014b6:	b8 00 06 00 00       	mov    $0x600,%eax
801014bb:	29 fb                	sub    %edi,%ebx
801014bd:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801014c3:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801014c6:	e8 35 1f 00 00       	call   80103400 <begin_op>
      ilock(f->ip);
801014cb:	83 ec 0c             	sub    $0xc,%esp
801014ce:	ff 76 10             	pushl  0x10(%esi)
801014d1:	e8 fa 05 00 00       	call   80101ad0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801014d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801014d9:	53                   	push   %ebx
801014da:	ff 76 14             	pushl  0x14(%esi)
801014dd:	01 f8                	add    %edi,%eax
801014df:	50                   	push   %eax
801014e0:	ff 76 10             	pushl  0x10(%esi)
801014e3:	e8 c8 09 00 00       	call   80101eb0 <writei>
801014e8:	83 c4 20             	add    $0x20,%esp
801014eb:	85 c0                	test   %eax,%eax
801014ed:	7f 99                	jg     80101488 <filewrite+0x48>
      iunlock(f->ip);
801014ef:	83 ec 0c             	sub    $0xc,%esp
801014f2:	ff 76 10             	pushl  0x10(%esi)
801014f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801014f8:	e8 b3 06 00 00       	call   80101bb0 <iunlock>
      end_op();
801014fd:	e8 6e 1f 00 00       	call   80103470 <end_op>
      if(r < 0)
80101502:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101505:	83 c4 10             	add    $0x10,%esp
80101508:	85 c0                	test   %eax,%eax
8010150a:	74 98                	je     801014a4 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010150c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010150f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101514:	89 f8                	mov    %edi,%eax
80101516:	5b                   	pop    %ebx
80101517:	5e                   	pop    %esi
80101518:	5f                   	pop    %edi
80101519:	5d                   	pop    %ebp
8010151a:	c3                   	ret    
8010151b:	90                   	nop
8010151c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101520:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101523:	75 e7                	jne    8010150c <filewrite+0xcc>
}
80101525:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101528:	89 f8                	mov    %edi,%eax
8010152a:	5b                   	pop    %ebx
8010152b:	5e                   	pop    %esi
8010152c:	5f                   	pop    %edi
8010152d:	5d                   	pop    %ebp
8010152e:	c3                   	ret    
8010152f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101530:	8b 46 0c             	mov    0xc(%esi),%eax
80101533:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101536:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101539:	5b                   	pop    %ebx
8010153a:	5e                   	pop    %esi
8010153b:	5f                   	pop    %edi
8010153c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010153d:	e9 0e 27 00 00       	jmp    80103c50 <pipewrite>
        panic("short filewrite");
80101542:	83 ec 0c             	sub    $0xc,%esp
80101545:	68 2f 87 10 80       	push   $0x8010872f
8010154a:	e8 41 ee ff ff       	call   80100390 <panic>
  panic("filewrite");
8010154f:	83 ec 0c             	sub    $0xc,%esp
80101552:	68 35 87 10 80       	push   $0x80108735
80101557:	e8 34 ee ff ff       	call   80100390 <panic>
8010155c:	66 90                	xchg   %ax,%ax
8010155e:	66 90                	xchg   %ax,%ax

80101560 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	56                   	push   %esi
80101564:	53                   	push   %ebx
80101565:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101567:	c1 ea 0c             	shr    $0xc,%edx
8010156a:	03 15 18 0a 12 80    	add    0x80120a18,%edx
80101570:	83 ec 08             	sub    $0x8,%esp
80101573:	52                   	push   %edx
80101574:	50                   	push   %eax
80101575:	e8 56 eb ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010157a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010157c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010157f:	ba 01 00 00 00       	mov    $0x1,%edx
80101584:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101587:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010158d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101590:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101592:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101597:	85 d1                	test   %edx,%ecx
80101599:	74 25                	je     801015c0 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010159b:	f7 d2                	not    %edx
8010159d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010159f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801015a2:	21 ca                	and    %ecx,%edx
801015a4:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
801015a8:	56                   	push   %esi
801015a9:	e8 22 20 00 00       	call   801035d0 <log_write>
  brelse(bp);
801015ae:	89 34 24             	mov    %esi,(%esp)
801015b1:	e8 2a ec ff ff       	call   801001e0 <brelse>
}
801015b6:	83 c4 10             	add    $0x10,%esp
801015b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015bc:	5b                   	pop    %ebx
801015bd:	5e                   	pop    %esi
801015be:	5d                   	pop    %ebp
801015bf:	c3                   	ret    
    panic("freeing free block");
801015c0:	83 ec 0c             	sub    $0xc,%esp
801015c3:	68 3f 87 10 80       	push   $0x8010873f
801015c8:	e8 c3 ed ff ff       	call   80100390 <panic>
801015cd:	8d 76 00             	lea    0x0(%esi),%esi

801015d0 <balloc>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	57                   	push   %edi
801015d4:	56                   	push   %esi
801015d5:	53                   	push   %ebx
801015d6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801015d9:	8b 0d 00 0a 12 80    	mov    0x80120a00,%ecx
{
801015df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801015e2:	85 c9                	test   %ecx,%ecx
801015e4:	0f 84 87 00 00 00    	je     80101671 <balloc+0xa1>
801015ea:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801015f1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801015f4:	83 ec 08             	sub    $0x8,%esp
801015f7:	89 f0                	mov    %esi,%eax
801015f9:	c1 f8 0c             	sar    $0xc,%eax
801015fc:	03 05 18 0a 12 80    	add    0x80120a18,%eax
80101602:	50                   	push   %eax
80101603:	ff 75 d8             	pushl  -0x28(%ebp)
80101606:	e8 c5 ea ff ff       	call   801000d0 <bread>
8010160b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010160e:	a1 00 0a 12 80       	mov    0x80120a00,%eax
80101613:	83 c4 10             	add    $0x10,%esp
80101616:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101619:	31 c0                	xor    %eax,%eax
8010161b:	eb 2f                	jmp    8010164c <balloc+0x7c>
8010161d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101620:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101622:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101625:	bb 01 00 00 00       	mov    $0x1,%ebx
8010162a:	83 e1 07             	and    $0x7,%ecx
8010162d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010162f:	89 c1                	mov    %eax,%ecx
80101631:	c1 f9 03             	sar    $0x3,%ecx
80101634:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101639:	85 df                	test   %ebx,%edi
8010163b:	89 fa                	mov    %edi,%edx
8010163d:	74 41                	je     80101680 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010163f:	83 c0 01             	add    $0x1,%eax
80101642:	83 c6 01             	add    $0x1,%esi
80101645:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010164a:	74 05                	je     80101651 <balloc+0x81>
8010164c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010164f:	77 cf                	ja     80101620 <balloc+0x50>
    brelse(bp);
80101651:	83 ec 0c             	sub    $0xc,%esp
80101654:	ff 75 e4             	pushl  -0x1c(%ebp)
80101657:	e8 84 eb ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010165c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101663:	83 c4 10             	add    $0x10,%esp
80101666:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101669:	39 05 00 0a 12 80    	cmp    %eax,0x80120a00
8010166f:	77 80                	ja     801015f1 <balloc+0x21>
  panic("balloc: out of blocks");
80101671:	83 ec 0c             	sub    $0xc,%esp
80101674:	68 52 87 10 80       	push   $0x80108752
80101679:	e8 12 ed ff ff       	call   80100390 <panic>
8010167e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101680:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101683:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101686:	09 da                	or     %ebx,%edx
80101688:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010168c:	57                   	push   %edi
8010168d:	e8 3e 1f 00 00       	call   801035d0 <log_write>
        brelse(bp);
80101692:	89 3c 24             	mov    %edi,(%esp)
80101695:	e8 46 eb ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010169a:	58                   	pop    %eax
8010169b:	5a                   	pop    %edx
8010169c:	56                   	push   %esi
8010169d:	ff 75 d8             	pushl  -0x28(%ebp)
801016a0:	e8 2b ea ff ff       	call   801000d0 <bread>
801016a5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801016a7:	8d 40 5c             	lea    0x5c(%eax),%eax
801016aa:	83 c4 0c             	add    $0xc,%esp
801016ad:	68 00 02 00 00       	push   $0x200
801016b2:	6a 00                	push   $0x0
801016b4:	50                   	push   %eax
801016b5:	e8 36 39 00 00       	call   80104ff0 <memset>
  log_write(bp);
801016ba:	89 1c 24             	mov    %ebx,(%esp)
801016bd:	e8 0e 1f 00 00       	call   801035d0 <log_write>
  brelse(bp);
801016c2:	89 1c 24             	mov    %ebx,(%esp)
801016c5:	e8 16 eb ff ff       	call   801001e0 <brelse>
}
801016ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016cd:	89 f0                	mov    %esi,%eax
801016cf:	5b                   	pop    %ebx
801016d0:	5e                   	pop    %esi
801016d1:	5f                   	pop    %edi
801016d2:	5d                   	pop    %ebp
801016d3:	c3                   	ret    
801016d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801016da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801016e0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801016e0:	55                   	push   %ebp
801016e1:	89 e5                	mov    %esp,%ebp
801016e3:	57                   	push   %edi
801016e4:	56                   	push   %esi
801016e5:	53                   	push   %ebx
801016e6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801016e8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801016ea:	bb 54 0a 12 80       	mov    $0x80120a54,%ebx
{
801016ef:	83 ec 28             	sub    $0x28,%esp
801016f2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801016f5:	68 20 0a 12 80       	push   $0x80120a20
801016fa:	e8 e1 37 00 00       	call   80104ee0 <acquire>
801016ff:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101702:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101705:	eb 17                	jmp    8010171e <iget+0x3e>
80101707:	89 f6                	mov    %esi,%esi
80101709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101710:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101716:	81 fb 74 26 12 80    	cmp    $0x80122674,%ebx
8010171c:	73 22                	jae    80101740 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010171e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101721:	85 c9                	test   %ecx,%ecx
80101723:	7e 04                	jle    80101729 <iget+0x49>
80101725:	39 3b                	cmp    %edi,(%ebx)
80101727:	74 4f                	je     80101778 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101729:	85 f6                	test   %esi,%esi
8010172b:	75 e3                	jne    80101710 <iget+0x30>
8010172d:	85 c9                	test   %ecx,%ecx
8010172f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101732:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101738:	81 fb 74 26 12 80    	cmp    $0x80122674,%ebx
8010173e:	72 de                	jb     8010171e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101740:	85 f6                	test   %esi,%esi
80101742:	74 5b                	je     8010179f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101744:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101747:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101749:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010174c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101753:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010175a:	68 20 0a 12 80       	push   $0x80120a20
8010175f:	e8 3c 38 00 00       	call   80104fa0 <release>

  return ip;
80101764:	83 c4 10             	add    $0x10,%esp
}
80101767:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010176a:	89 f0                	mov    %esi,%eax
8010176c:	5b                   	pop    %ebx
8010176d:	5e                   	pop    %esi
8010176e:	5f                   	pop    %edi
8010176f:	5d                   	pop    %ebp
80101770:	c3                   	ret    
80101771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101778:	39 53 04             	cmp    %edx,0x4(%ebx)
8010177b:	75 ac                	jne    80101729 <iget+0x49>
      release(&icache.lock);
8010177d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101780:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101783:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101785:	68 20 0a 12 80       	push   $0x80120a20
      ip->ref++;
8010178a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010178d:	e8 0e 38 00 00       	call   80104fa0 <release>
      return ip;
80101792:	83 c4 10             	add    $0x10,%esp
}
80101795:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101798:	89 f0                	mov    %esi,%eax
8010179a:	5b                   	pop    %ebx
8010179b:	5e                   	pop    %esi
8010179c:	5f                   	pop    %edi
8010179d:	5d                   	pop    %ebp
8010179e:	c3                   	ret    
    panic("iget: no inodes");
8010179f:	83 ec 0c             	sub    $0xc,%esp
801017a2:	68 68 87 10 80       	push   $0x80108768
801017a7:	e8 e4 eb ff ff       	call   80100390 <panic>
801017ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801017b0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	57                   	push   %edi
801017b4:	56                   	push   %esi
801017b5:	53                   	push   %ebx
801017b6:	89 c6                	mov    %eax,%esi
801017b8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801017bb:	83 fa 0b             	cmp    $0xb,%edx
801017be:	77 18                	ja     801017d8 <bmap+0x28>
801017c0:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
801017c3:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801017c6:	85 db                	test   %ebx,%ebx
801017c8:	74 76                	je     80101840 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801017ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017cd:	89 d8                	mov    %ebx,%eax
801017cf:	5b                   	pop    %ebx
801017d0:	5e                   	pop    %esi
801017d1:	5f                   	pop    %edi
801017d2:	5d                   	pop    %ebp
801017d3:	c3                   	ret    
801017d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
801017d8:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
801017db:	83 fb 7f             	cmp    $0x7f,%ebx
801017de:	0f 87 90 00 00 00    	ja     80101874 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
801017e4:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801017ea:	8b 00                	mov    (%eax),%eax
801017ec:	85 d2                	test   %edx,%edx
801017ee:	74 70                	je     80101860 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801017f0:	83 ec 08             	sub    $0x8,%esp
801017f3:	52                   	push   %edx
801017f4:	50                   	push   %eax
801017f5:	e8 d6 e8 ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801017fa:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801017fe:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101801:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101803:	8b 1a                	mov    (%edx),%ebx
80101805:	85 db                	test   %ebx,%ebx
80101807:	75 1d                	jne    80101826 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101809:	8b 06                	mov    (%esi),%eax
8010180b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010180e:	e8 bd fd ff ff       	call   801015d0 <balloc>
80101813:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101816:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101819:	89 c3                	mov    %eax,%ebx
8010181b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010181d:	57                   	push   %edi
8010181e:	e8 ad 1d 00 00       	call   801035d0 <log_write>
80101823:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101826:	83 ec 0c             	sub    $0xc,%esp
80101829:	57                   	push   %edi
8010182a:	e8 b1 e9 ff ff       	call   801001e0 <brelse>
8010182f:	83 c4 10             	add    $0x10,%esp
}
80101832:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101835:	89 d8                	mov    %ebx,%eax
80101837:	5b                   	pop    %ebx
80101838:	5e                   	pop    %esi
80101839:	5f                   	pop    %edi
8010183a:	5d                   	pop    %ebp
8010183b:	c3                   	ret    
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101840:	8b 00                	mov    (%eax),%eax
80101842:	e8 89 fd ff ff       	call   801015d0 <balloc>
80101847:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010184a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010184d:	89 c3                	mov    %eax,%ebx
}
8010184f:	89 d8                	mov    %ebx,%eax
80101851:	5b                   	pop    %ebx
80101852:	5e                   	pop    %esi
80101853:	5f                   	pop    %edi
80101854:	5d                   	pop    %ebp
80101855:	c3                   	ret    
80101856:	8d 76 00             	lea    0x0(%esi),%esi
80101859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101860:	e8 6b fd ff ff       	call   801015d0 <balloc>
80101865:	89 c2                	mov    %eax,%edx
80101867:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010186d:	8b 06                	mov    (%esi),%eax
8010186f:	e9 7c ff ff ff       	jmp    801017f0 <bmap+0x40>
  panic("bmap: out of range");
80101874:	83 ec 0c             	sub    $0xc,%esp
80101877:	68 78 87 10 80       	push   $0x80108778
8010187c:	e8 0f eb ff ff       	call   80100390 <panic>
80101881:	eb 0d                	jmp    80101890 <readsb>
80101883:	90                   	nop
80101884:	90                   	nop
80101885:	90                   	nop
80101886:	90                   	nop
80101887:	90                   	nop
80101888:	90                   	nop
80101889:	90                   	nop
8010188a:	90                   	nop
8010188b:	90                   	nop
8010188c:	90                   	nop
8010188d:	90                   	nop
8010188e:	90                   	nop
8010188f:	90                   	nop

80101890 <readsb>:
{
80101890:	55                   	push   %ebp
80101891:	89 e5                	mov    %esp,%ebp
80101893:	56                   	push   %esi
80101894:	53                   	push   %ebx
80101895:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101898:	83 ec 08             	sub    $0x8,%esp
8010189b:	6a 01                	push   $0x1
8010189d:	ff 75 08             	pushl  0x8(%ebp)
801018a0:	e8 2b e8 ff ff       	call   801000d0 <bread>
801018a5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801018a7:	8d 40 5c             	lea    0x5c(%eax),%eax
801018aa:	83 c4 0c             	add    $0xc,%esp
801018ad:	6a 1c                	push   $0x1c
801018af:	50                   	push   %eax
801018b0:	56                   	push   %esi
801018b1:	e8 ea 37 00 00       	call   801050a0 <memmove>
  brelse(bp);
801018b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801018b9:	83 c4 10             	add    $0x10,%esp
}
801018bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018bf:	5b                   	pop    %ebx
801018c0:	5e                   	pop    %esi
801018c1:	5d                   	pop    %ebp
  brelse(bp);
801018c2:	e9 19 e9 ff ff       	jmp    801001e0 <brelse>
801018c7:	89 f6                	mov    %esi,%esi
801018c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801018d0 <iinit>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	53                   	push   %ebx
801018d4:	bb 60 0a 12 80       	mov    $0x80120a60,%ebx
801018d9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801018dc:	68 8b 87 10 80       	push   $0x8010878b
801018e1:	68 20 0a 12 80       	push   $0x80120a20
801018e6:	e8 b5 34 00 00       	call   80104da0 <initlock>
801018eb:	83 c4 10             	add    $0x10,%esp
801018ee:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801018f0:	83 ec 08             	sub    $0x8,%esp
801018f3:	68 92 87 10 80       	push   $0x80108792
801018f8:	53                   	push   %ebx
801018f9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801018ff:	e8 6c 33 00 00       	call   80104c70 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101904:	83 c4 10             	add    $0x10,%esp
80101907:	81 fb 80 26 12 80    	cmp    $0x80122680,%ebx
8010190d:	75 e1                	jne    801018f0 <iinit+0x20>
  readsb(dev, &sb);
8010190f:	83 ec 08             	sub    $0x8,%esp
80101912:	68 00 0a 12 80       	push   $0x80120a00
80101917:	ff 75 08             	pushl  0x8(%ebp)
8010191a:	e8 71 ff ff ff       	call   80101890 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010191f:	ff 35 18 0a 12 80    	pushl  0x80120a18
80101925:	ff 35 14 0a 12 80    	pushl  0x80120a14
8010192b:	ff 35 10 0a 12 80    	pushl  0x80120a10
80101931:	ff 35 0c 0a 12 80    	pushl  0x80120a0c
80101937:	ff 35 08 0a 12 80    	pushl  0x80120a08
8010193d:	ff 35 04 0a 12 80    	pushl  0x80120a04
80101943:	ff 35 00 0a 12 80    	pushl  0x80120a00
80101949:	68 3c 88 10 80       	push   $0x8010883c
8010194e:	e8 0d ed ff ff       	call   80100660 <cprintf>
}
80101953:	83 c4 30             	add    $0x30,%esp
80101956:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101959:	c9                   	leave  
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <ialloc>:
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101969:	83 3d 08 0a 12 80 01 	cmpl   $0x1,0x80120a08
{
80101970:	8b 45 0c             	mov    0xc(%ebp),%eax
80101973:	8b 75 08             	mov    0x8(%ebp),%esi
80101976:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101979:	0f 86 91 00 00 00    	jbe    80101a10 <ialloc+0xb0>
8010197f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101984:	eb 21                	jmp    801019a7 <ialloc+0x47>
80101986:	8d 76 00             	lea    0x0(%esi),%esi
80101989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101990:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101993:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101996:	57                   	push   %edi
80101997:	e8 44 e8 ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010199c:	83 c4 10             	add    $0x10,%esp
8010199f:	39 1d 08 0a 12 80    	cmp    %ebx,0x80120a08
801019a5:	76 69                	jbe    80101a10 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801019a7:	89 d8                	mov    %ebx,%eax
801019a9:	83 ec 08             	sub    $0x8,%esp
801019ac:	c1 e8 03             	shr    $0x3,%eax
801019af:	03 05 14 0a 12 80    	add    0x80120a14,%eax
801019b5:	50                   	push   %eax
801019b6:	56                   	push   %esi
801019b7:	e8 14 e7 ff ff       	call   801000d0 <bread>
801019bc:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801019be:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801019c0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
801019c3:	83 e0 07             	and    $0x7,%eax
801019c6:	c1 e0 06             	shl    $0x6,%eax
801019c9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801019cd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801019d1:	75 bd                	jne    80101990 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801019d3:	83 ec 04             	sub    $0x4,%esp
801019d6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801019d9:	6a 40                	push   $0x40
801019db:	6a 00                	push   $0x0
801019dd:	51                   	push   %ecx
801019de:	e8 0d 36 00 00       	call   80104ff0 <memset>
      dip->type = type;
801019e3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801019e7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801019ea:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801019ed:	89 3c 24             	mov    %edi,(%esp)
801019f0:	e8 db 1b 00 00       	call   801035d0 <log_write>
      brelse(bp);
801019f5:	89 3c 24             	mov    %edi,(%esp)
801019f8:	e8 e3 e7 ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801019fd:	83 c4 10             	add    $0x10,%esp
}
80101a00:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101a03:	89 da                	mov    %ebx,%edx
80101a05:	89 f0                	mov    %esi,%eax
}
80101a07:	5b                   	pop    %ebx
80101a08:	5e                   	pop    %esi
80101a09:	5f                   	pop    %edi
80101a0a:	5d                   	pop    %ebp
      return iget(dev, inum);
80101a0b:	e9 d0 fc ff ff       	jmp    801016e0 <iget>
  panic("ialloc: no inodes");
80101a10:	83 ec 0c             	sub    $0xc,%esp
80101a13:	68 98 87 10 80       	push   $0x80108798
80101a18:	e8 73 e9 ff ff       	call   80100390 <panic>
80101a1d:	8d 76 00             	lea    0x0(%esi),%esi

80101a20 <iupdate>:
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	56                   	push   %esi
80101a24:	53                   	push   %ebx
80101a25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a28:	83 ec 08             	sub    $0x8,%esp
80101a2b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a2e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a31:	c1 e8 03             	shr    $0x3,%eax
80101a34:	03 05 14 0a 12 80    	add    0x80120a14,%eax
80101a3a:	50                   	push   %eax
80101a3b:	ff 73 a4             	pushl  -0x5c(%ebx)
80101a3e:	e8 8d e6 ff ff       	call   801000d0 <bread>
80101a43:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a45:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101a48:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a4c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a4f:	83 e0 07             	and    $0x7,%eax
80101a52:	c1 e0 06             	shl    $0x6,%eax
80101a55:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101a59:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101a5c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a60:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101a63:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101a67:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101a6b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101a6f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101a73:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101a77:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101a7a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a7d:	6a 34                	push   $0x34
80101a7f:	53                   	push   %ebx
80101a80:	50                   	push   %eax
80101a81:	e8 1a 36 00 00       	call   801050a0 <memmove>
  log_write(bp);
80101a86:	89 34 24             	mov    %esi,(%esp)
80101a89:	e8 42 1b 00 00       	call   801035d0 <log_write>
  brelse(bp);
80101a8e:	89 75 08             	mov    %esi,0x8(%ebp)
80101a91:	83 c4 10             	add    $0x10,%esp
}
80101a94:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a97:	5b                   	pop    %ebx
80101a98:	5e                   	pop    %esi
80101a99:	5d                   	pop    %ebp
  brelse(bp);
80101a9a:	e9 41 e7 ff ff       	jmp    801001e0 <brelse>
80101a9f:	90                   	nop

80101aa0 <idup>:
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	53                   	push   %ebx
80101aa4:	83 ec 10             	sub    $0x10,%esp
80101aa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101aaa:	68 20 0a 12 80       	push   $0x80120a20
80101aaf:	e8 2c 34 00 00       	call   80104ee0 <acquire>
  ip->ref++;
80101ab4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101ab8:	c7 04 24 20 0a 12 80 	movl   $0x80120a20,(%esp)
80101abf:	e8 dc 34 00 00       	call   80104fa0 <release>
}
80101ac4:	89 d8                	mov    %ebx,%eax
80101ac6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101ac9:	c9                   	leave  
80101aca:	c3                   	ret    
80101acb:	90                   	nop
80101acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ad0 <ilock>:
{
80101ad0:	55                   	push   %ebp
80101ad1:	89 e5                	mov    %esp,%ebp
80101ad3:	56                   	push   %esi
80101ad4:	53                   	push   %ebx
80101ad5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101ad8:	85 db                	test   %ebx,%ebx
80101ada:	0f 84 b7 00 00 00    	je     80101b97 <ilock+0xc7>
80101ae0:	8b 53 08             	mov    0x8(%ebx),%edx
80101ae3:	85 d2                	test   %edx,%edx
80101ae5:	0f 8e ac 00 00 00    	jle    80101b97 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101aeb:	8d 43 0c             	lea    0xc(%ebx),%eax
80101aee:	83 ec 0c             	sub    $0xc,%esp
80101af1:	50                   	push   %eax
80101af2:	e8 b9 31 00 00       	call   80104cb0 <acquiresleep>
  if(ip->valid == 0){
80101af7:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101afa:	83 c4 10             	add    $0x10,%esp
80101afd:	85 c0                	test   %eax,%eax
80101aff:	74 0f                	je     80101b10 <ilock+0x40>
}
80101b01:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b04:	5b                   	pop    %ebx
80101b05:	5e                   	pop    %esi
80101b06:	5d                   	pop    %ebp
80101b07:	c3                   	ret    
80101b08:	90                   	nop
80101b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b10:	8b 43 04             	mov    0x4(%ebx),%eax
80101b13:	83 ec 08             	sub    $0x8,%esp
80101b16:	c1 e8 03             	shr    $0x3,%eax
80101b19:	03 05 14 0a 12 80    	add    0x80120a14,%eax
80101b1f:	50                   	push   %eax
80101b20:	ff 33                	pushl  (%ebx)
80101b22:	e8 a9 e5 ff ff       	call   801000d0 <bread>
80101b27:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b29:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b2c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b2f:	83 e0 07             	and    $0x7,%eax
80101b32:	c1 e0 06             	shl    $0x6,%eax
80101b35:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101b39:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b3c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101b3f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101b43:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101b47:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101b4b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101b4f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101b53:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101b57:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101b5b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101b5e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b61:	6a 34                	push   $0x34
80101b63:	50                   	push   %eax
80101b64:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101b67:	50                   	push   %eax
80101b68:	e8 33 35 00 00       	call   801050a0 <memmove>
    brelse(bp);
80101b6d:	89 34 24             	mov    %esi,(%esp)
80101b70:	e8 6b e6 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101b75:	83 c4 10             	add    $0x10,%esp
80101b78:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101b7d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101b84:	0f 85 77 ff ff ff    	jne    80101b01 <ilock+0x31>
      panic("ilock: no type");
80101b8a:	83 ec 0c             	sub    $0xc,%esp
80101b8d:	68 b0 87 10 80       	push   $0x801087b0
80101b92:	e8 f9 e7 ff ff       	call   80100390 <panic>
    panic("ilock");
80101b97:	83 ec 0c             	sub    $0xc,%esp
80101b9a:	68 aa 87 10 80       	push   $0x801087aa
80101b9f:	e8 ec e7 ff ff       	call   80100390 <panic>
80101ba4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101baa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101bb0 <iunlock>:
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	56                   	push   %esi
80101bb4:	53                   	push   %ebx
80101bb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101bb8:	85 db                	test   %ebx,%ebx
80101bba:	74 28                	je     80101be4 <iunlock+0x34>
80101bbc:	8d 73 0c             	lea    0xc(%ebx),%esi
80101bbf:	83 ec 0c             	sub    $0xc,%esp
80101bc2:	56                   	push   %esi
80101bc3:	e8 88 31 00 00       	call   80104d50 <holdingsleep>
80101bc8:	83 c4 10             	add    $0x10,%esp
80101bcb:	85 c0                	test   %eax,%eax
80101bcd:	74 15                	je     80101be4 <iunlock+0x34>
80101bcf:	8b 43 08             	mov    0x8(%ebx),%eax
80101bd2:	85 c0                	test   %eax,%eax
80101bd4:	7e 0e                	jle    80101be4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101bd6:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101bd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101bdc:	5b                   	pop    %ebx
80101bdd:	5e                   	pop    %esi
80101bde:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101bdf:	e9 2c 31 00 00       	jmp    80104d10 <releasesleep>
    panic("iunlock");
80101be4:	83 ec 0c             	sub    $0xc,%esp
80101be7:	68 bf 87 10 80       	push   $0x801087bf
80101bec:	e8 9f e7 ff ff       	call   80100390 <panic>
80101bf1:	eb 0d                	jmp    80101c00 <iput>
80101bf3:	90                   	nop
80101bf4:	90                   	nop
80101bf5:	90                   	nop
80101bf6:	90                   	nop
80101bf7:	90                   	nop
80101bf8:	90                   	nop
80101bf9:	90                   	nop
80101bfa:	90                   	nop
80101bfb:	90                   	nop
80101bfc:	90                   	nop
80101bfd:	90                   	nop
80101bfe:	90                   	nop
80101bff:	90                   	nop

80101c00 <iput>:
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	57                   	push   %edi
80101c04:	56                   	push   %esi
80101c05:	53                   	push   %ebx
80101c06:	83 ec 28             	sub    $0x28,%esp
80101c09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101c0c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101c0f:	57                   	push   %edi
80101c10:	e8 9b 30 00 00       	call   80104cb0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101c15:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101c18:	83 c4 10             	add    $0x10,%esp
80101c1b:	85 d2                	test   %edx,%edx
80101c1d:	74 07                	je     80101c26 <iput+0x26>
80101c1f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101c24:	74 32                	je     80101c58 <iput+0x58>
  releasesleep(&ip->lock);
80101c26:	83 ec 0c             	sub    $0xc,%esp
80101c29:	57                   	push   %edi
80101c2a:	e8 e1 30 00 00       	call   80104d10 <releasesleep>
  acquire(&icache.lock);
80101c2f:	c7 04 24 20 0a 12 80 	movl   $0x80120a20,(%esp)
80101c36:	e8 a5 32 00 00       	call   80104ee0 <acquire>
  ip->ref--;
80101c3b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101c3f:	83 c4 10             	add    $0x10,%esp
80101c42:	c7 45 08 20 0a 12 80 	movl   $0x80120a20,0x8(%ebp)
}
80101c49:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c4c:	5b                   	pop    %ebx
80101c4d:	5e                   	pop    %esi
80101c4e:	5f                   	pop    %edi
80101c4f:	5d                   	pop    %ebp
  release(&icache.lock);
80101c50:	e9 4b 33 00 00       	jmp    80104fa0 <release>
80101c55:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101c58:	83 ec 0c             	sub    $0xc,%esp
80101c5b:	68 20 0a 12 80       	push   $0x80120a20
80101c60:	e8 7b 32 00 00       	call   80104ee0 <acquire>
    int r = ip->ref;
80101c65:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101c68:	c7 04 24 20 0a 12 80 	movl   $0x80120a20,(%esp)
80101c6f:	e8 2c 33 00 00       	call   80104fa0 <release>
    if(r == 1){
80101c74:	83 c4 10             	add    $0x10,%esp
80101c77:	83 fe 01             	cmp    $0x1,%esi
80101c7a:	75 aa                	jne    80101c26 <iput+0x26>
80101c7c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101c82:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101c85:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101c88:	89 cf                	mov    %ecx,%edi
80101c8a:	eb 0b                	jmp    80101c97 <iput+0x97>
80101c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c90:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c93:	39 fe                	cmp    %edi,%esi
80101c95:	74 19                	je     80101cb0 <iput+0xb0>
    if(ip->addrs[i]){
80101c97:	8b 16                	mov    (%esi),%edx
80101c99:	85 d2                	test   %edx,%edx
80101c9b:	74 f3                	je     80101c90 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101c9d:	8b 03                	mov    (%ebx),%eax
80101c9f:	e8 bc f8 ff ff       	call   80101560 <bfree>
      ip->addrs[i] = 0;
80101ca4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101caa:	eb e4                	jmp    80101c90 <iput+0x90>
80101cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101cb0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101cb6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101cb9:	85 c0                	test   %eax,%eax
80101cbb:	75 33                	jne    80101cf0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101cbd:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101cc0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101cc7:	53                   	push   %ebx
80101cc8:	e8 53 fd ff ff       	call   80101a20 <iupdate>
      ip->type = 0;
80101ccd:	31 c0                	xor    %eax,%eax
80101ccf:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101cd3:	89 1c 24             	mov    %ebx,(%esp)
80101cd6:	e8 45 fd ff ff       	call   80101a20 <iupdate>
      ip->valid = 0;
80101cdb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101ce2:	83 c4 10             	add    $0x10,%esp
80101ce5:	e9 3c ff ff ff       	jmp    80101c26 <iput+0x26>
80101cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101cf0:	83 ec 08             	sub    $0x8,%esp
80101cf3:	50                   	push   %eax
80101cf4:	ff 33                	pushl  (%ebx)
80101cf6:	e8 d5 e3 ff ff       	call   801000d0 <bread>
80101cfb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101d01:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101d04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101d07:	8d 70 5c             	lea    0x5c(%eax),%esi
80101d0a:	83 c4 10             	add    $0x10,%esp
80101d0d:	89 cf                	mov    %ecx,%edi
80101d0f:	eb 0e                	jmp    80101d1f <iput+0x11f>
80101d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d18:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101d1b:	39 fe                	cmp    %edi,%esi
80101d1d:	74 0f                	je     80101d2e <iput+0x12e>
      if(a[j])
80101d1f:	8b 16                	mov    (%esi),%edx
80101d21:	85 d2                	test   %edx,%edx
80101d23:	74 f3                	je     80101d18 <iput+0x118>
        bfree(ip->dev, a[j]);
80101d25:	8b 03                	mov    (%ebx),%eax
80101d27:	e8 34 f8 ff ff       	call   80101560 <bfree>
80101d2c:	eb ea                	jmp    80101d18 <iput+0x118>
    brelse(bp);
80101d2e:	83 ec 0c             	sub    $0xc,%esp
80101d31:	ff 75 e4             	pushl  -0x1c(%ebp)
80101d34:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101d37:	e8 a4 e4 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d3c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101d42:	8b 03                	mov    (%ebx),%eax
80101d44:	e8 17 f8 ff ff       	call   80101560 <bfree>
    ip->addrs[NDIRECT] = 0;
80101d49:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101d50:	00 00 00 
80101d53:	83 c4 10             	add    $0x10,%esp
80101d56:	e9 62 ff ff ff       	jmp    80101cbd <iput+0xbd>
80101d5b:	90                   	nop
80101d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d60 <iunlockput>:
{
80101d60:	55                   	push   %ebp
80101d61:	89 e5                	mov    %esp,%ebp
80101d63:	53                   	push   %ebx
80101d64:	83 ec 10             	sub    $0x10,%esp
80101d67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101d6a:	53                   	push   %ebx
80101d6b:	e8 40 fe ff ff       	call   80101bb0 <iunlock>
  iput(ip);
80101d70:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101d73:	83 c4 10             	add    $0x10,%esp
}
80101d76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d79:	c9                   	leave  
  iput(ip);
80101d7a:	e9 81 fe ff ff       	jmp    80101c00 <iput>
80101d7f:	90                   	nop

80101d80 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101d80:	55                   	push   %ebp
80101d81:	89 e5                	mov    %esp,%ebp
80101d83:	8b 55 08             	mov    0x8(%ebp),%edx
80101d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101d89:	8b 0a                	mov    (%edx),%ecx
80101d8b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101d8e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101d91:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101d94:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101d98:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101d9b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101d9f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101da3:	8b 52 58             	mov    0x58(%edx),%edx
80101da6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101da9:	5d                   	pop    %ebp
80101daa:	c3                   	ret    
80101dab:	90                   	nop
80101dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101db0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101db0:	55                   	push   %ebp
80101db1:	89 e5                	mov    %esp,%ebp
80101db3:	57                   	push   %edi
80101db4:	56                   	push   %esi
80101db5:	53                   	push   %ebx
80101db6:	83 ec 1c             	sub    $0x1c,%esp
80101db9:	8b 45 08             	mov    0x8(%ebp),%eax
80101dbc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101dbf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101dc2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101dc7:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101dca:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101dcd:	8b 75 10             	mov    0x10(%ebp),%esi
80101dd0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101dd3:	0f 84 a7 00 00 00    	je     80101e80 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101dd9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ddc:	8b 40 58             	mov    0x58(%eax),%eax
80101ddf:	39 c6                	cmp    %eax,%esi
80101de1:	0f 87 ba 00 00 00    	ja     80101ea1 <readi+0xf1>
80101de7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101dea:	89 f9                	mov    %edi,%ecx
80101dec:	01 f1                	add    %esi,%ecx
80101dee:	0f 82 ad 00 00 00    	jb     80101ea1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101df4:	89 c2                	mov    %eax,%edx
80101df6:	29 f2                	sub    %esi,%edx
80101df8:	39 c8                	cmp    %ecx,%eax
80101dfa:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101dfd:	31 ff                	xor    %edi,%edi
80101dff:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101e01:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e04:	74 6c                	je     80101e72 <readi+0xc2>
80101e06:	8d 76 00             	lea    0x0(%esi),%esi
80101e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e10:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101e13:	89 f2                	mov    %esi,%edx
80101e15:	c1 ea 09             	shr    $0x9,%edx
80101e18:	89 d8                	mov    %ebx,%eax
80101e1a:	e8 91 f9 ff ff       	call   801017b0 <bmap>
80101e1f:	83 ec 08             	sub    $0x8,%esp
80101e22:	50                   	push   %eax
80101e23:	ff 33                	pushl  (%ebx)
80101e25:	e8 a6 e2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101e2a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e2d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101e2f:	89 f0                	mov    %esi,%eax
80101e31:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e36:	b9 00 02 00 00       	mov    $0x200,%ecx
80101e3b:	83 c4 0c             	add    $0xc,%esp
80101e3e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101e40:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101e44:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e47:	29 fb                	sub    %edi,%ebx
80101e49:	39 d9                	cmp    %ebx,%ecx
80101e4b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101e4e:	53                   	push   %ebx
80101e4f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e50:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101e52:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e55:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101e57:	e8 44 32 00 00       	call   801050a0 <memmove>
    brelse(bp);
80101e5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e5f:	89 14 24             	mov    %edx,(%esp)
80101e62:	e8 79 e3 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e67:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101e6a:	83 c4 10             	add    $0x10,%esp
80101e6d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101e70:	77 9e                	ja     80101e10 <readi+0x60>
  }
  return n;
80101e72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e78:	5b                   	pop    %ebx
80101e79:	5e                   	pop    %esi
80101e7a:	5f                   	pop    %edi
80101e7b:	5d                   	pop    %ebp
80101e7c:	c3                   	ret    
80101e7d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101e80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101e84:	66 83 f8 09          	cmp    $0x9,%ax
80101e88:	77 17                	ja     80101ea1 <readi+0xf1>
80101e8a:	8b 04 c5 a0 09 12 80 	mov    -0x7fedf660(,%eax,8),%eax
80101e91:	85 c0                	test   %eax,%eax
80101e93:	74 0c                	je     80101ea1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101e95:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101e98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e9b:	5b                   	pop    %ebx
80101e9c:	5e                   	pop    %esi
80101e9d:	5f                   	pop    %edi
80101e9e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101e9f:	ff e0                	jmp    *%eax
      return -1;
80101ea1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ea6:	eb cd                	jmp    80101e75 <readi+0xc5>
80101ea8:	90                   	nop
80101ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101eb0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101eb0:	55                   	push   %ebp
80101eb1:	89 e5                	mov    %esp,%ebp
80101eb3:	57                   	push   %edi
80101eb4:	56                   	push   %esi
80101eb5:	53                   	push   %ebx
80101eb6:	83 ec 1c             	sub    $0x1c,%esp
80101eb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101ebf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ec2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ec7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101eca:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ecd:	8b 75 10             	mov    0x10(%ebp),%esi
80101ed0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ed3:	0f 84 b7 00 00 00    	je     80101f90 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ed9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101edc:	39 70 58             	cmp    %esi,0x58(%eax)
80101edf:	0f 82 eb 00 00 00    	jb     80101fd0 <writei+0x120>
80101ee5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ee8:	31 d2                	xor    %edx,%edx
80101eea:	89 f8                	mov    %edi,%eax
80101eec:	01 f0                	add    %esi,%eax
80101eee:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ef1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ef6:	0f 87 d4 00 00 00    	ja     80101fd0 <writei+0x120>
80101efc:	85 d2                	test   %edx,%edx
80101efe:	0f 85 cc 00 00 00    	jne    80101fd0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f04:	85 ff                	test   %edi,%edi
80101f06:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101f0d:	74 72                	je     80101f81 <writei+0xd1>
80101f0f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f10:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101f13:	89 f2                	mov    %esi,%edx
80101f15:	c1 ea 09             	shr    $0x9,%edx
80101f18:	89 f8                	mov    %edi,%eax
80101f1a:	e8 91 f8 ff ff       	call   801017b0 <bmap>
80101f1f:	83 ec 08             	sub    $0x8,%esp
80101f22:	50                   	push   %eax
80101f23:	ff 37                	pushl  (%edi)
80101f25:	e8 a6 e1 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101f2a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101f2d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f30:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101f32:	89 f0                	mov    %esi,%eax
80101f34:	b9 00 02 00 00       	mov    $0x200,%ecx
80101f39:	83 c4 0c             	add    $0xc,%esp
80101f3c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f41:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101f43:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101f47:	39 d9                	cmp    %ebx,%ecx
80101f49:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101f4c:	53                   	push   %ebx
80101f4d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f50:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101f52:	50                   	push   %eax
80101f53:	e8 48 31 00 00       	call   801050a0 <memmove>
    log_write(bp);
80101f58:	89 3c 24             	mov    %edi,(%esp)
80101f5b:	e8 70 16 00 00       	call   801035d0 <log_write>
    brelse(bp);
80101f60:	89 3c 24             	mov    %edi,(%esp)
80101f63:	e8 78 e2 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f68:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101f6b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101f6e:	83 c4 10             	add    $0x10,%esp
80101f71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f74:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101f77:	77 97                	ja     80101f10 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101f79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101f7c:	3b 70 58             	cmp    0x58(%eax),%esi
80101f7f:	77 37                	ja     80101fb8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101f81:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101f84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f87:	5b                   	pop    %ebx
80101f88:	5e                   	pop    %esi
80101f89:	5f                   	pop    %edi
80101f8a:	5d                   	pop    %ebp
80101f8b:	c3                   	ret    
80101f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101f94:	66 83 f8 09          	cmp    $0x9,%ax
80101f98:	77 36                	ja     80101fd0 <writei+0x120>
80101f9a:	8b 04 c5 a4 09 12 80 	mov    -0x7fedf65c(,%eax,8),%eax
80101fa1:	85 c0                	test   %eax,%eax
80101fa3:	74 2b                	je     80101fd0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101fa5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fab:	5b                   	pop    %ebx
80101fac:	5e                   	pop    %esi
80101fad:	5f                   	pop    %edi
80101fae:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101faf:	ff e0                	jmp    *%eax
80101fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101fb8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101fbb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101fbe:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101fc1:	50                   	push   %eax
80101fc2:	e8 59 fa ff ff       	call   80101a20 <iupdate>
80101fc7:	83 c4 10             	add    $0x10,%esp
80101fca:	eb b5                	jmp    80101f81 <writei+0xd1>
80101fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fd5:	eb ad                	jmp    80101f84 <writei+0xd4>
80101fd7:	89 f6                	mov    %esi,%esi
80101fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fe0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101fe6:	6a 0e                	push   $0xe
80101fe8:	ff 75 0c             	pushl  0xc(%ebp)
80101feb:	ff 75 08             	pushl  0x8(%ebp)
80101fee:	e8 1d 31 00 00       	call   80105110 <strncmp>
}
80101ff3:	c9                   	leave  
80101ff4:	c3                   	ret    
80101ff5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102000 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	57                   	push   %edi
80102004:	56                   	push   %esi
80102005:	53                   	push   %ebx
80102006:	83 ec 1c             	sub    $0x1c,%esp
80102009:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010200c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102011:	0f 85 85 00 00 00    	jne    8010209c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102017:	8b 53 58             	mov    0x58(%ebx),%edx
8010201a:	31 ff                	xor    %edi,%edi
8010201c:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010201f:	85 d2                	test   %edx,%edx
80102021:	74 3e                	je     80102061 <dirlookup+0x61>
80102023:	90                   	nop
80102024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102028:	6a 10                	push   $0x10
8010202a:	57                   	push   %edi
8010202b:	56                   	push   %esi
8010202c:	53                   	push   %ebx
8010202d:	e8 7e fd ff ff       	call   80101db0 <readi>
80102032:	83 c4 10             	add    $0x10,%esp
80102035:	83 f8 10             	cmp    $0x10,%eax
80102038:	75 55                	jne    8010208f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
8010203a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010203f:	74 18                	je     80102059 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80102041:	8d 45 da             	lea    -0x26(%ebp),%eax
80102044:	83 ec 04             	sub    $0x4,%esp
80102047:	6a 0e                	push   $0xe
80102049:	50                   	push   %eax
8010204a:	ff 75 0c             	pushl  0xc(%ebp)
8010204d:	e8 be 30 00 00       	call   80105110 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80102052:	83 c4 10             	add    $0x10,%esp
80102055:	85 c0                	test   %eax,%eax
80102057:	74 17                	je     80102070 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102059:	83 c7 10             	add    $0x10,%edi
8010205c:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010205f:	72 c7                	jb     80102028 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102061:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80102064:	31 c0                	xor    %eax,%eax
}
80102066:	5b                   	pop    %ebx
80102067:	5e                   	pop    %esi
80102068:	5f                   	pop    %edi
80102069:	5d                   	pop    %ebp
8010206a:	c3                   	ret    
8010206b:	90                   	nop
8010206c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80102070:	8b 45 10             	mov    0x10(%ebp),%eax
80102073:	85 c0                	test   %eax,%eax
80102075:	74 05                	je     8010207c <dirlookup+0x7c>
        *poff = off;
80102077:	8b 45 10             	mov    0x10(%ebp),%eax
8010207a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010207c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102080:	8b 03                	mov    (%ebx),%eax
80102082:	e8 59 f6 ff ff       	call   801016e0 <iget>
}
80102087:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010208a:	5b                   	pop    %ebx
8010208b:	5e                   	pop    %esi
8010208c:	5f                   	pop    %edi
8010208d:	5d                   	pop    %ebp
8010208e:	c3                   	ret    
      panic("dirlookup read");
8010208f:	83 ec 0c             	sub    $0xc,%esp
80102092:	68 d9 87 10 80       	push   $0x801087d9
80102097:	e8 f4 e2 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
8010209c:	83 ec 0c             	sub    $0xc,%esp
8010209f:	68 c7 87 10 80       	push   $0x801087c7
801020a4:	e8 e7 e2 ff ff       	call   80100390 <panic>
801020a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020b0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801020b0:	55                   	push   %ebp
801020b1:	89 e5                	mov    %esp,%ebp
801020b3:	57                   	push   %edi
801020b4:	56                   	push   %esi
801020b5:	53                   	push   %ebx
801020b6:	89 cf                	mov    %ecx,%edi
801020b8:	89 c3                	mov    %eax,%ebx
801020ba:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
801020bd:	80 38 2f             	cmpb   $0x2f,(%eax)
{
801020c0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
801020c3:	0f 84 67 01 00 00    	je     80102230 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
801020c9:	e8 f2 1f 00 00       	call   801040c0 <myproc>
  acquire(&icache.lock);
801020ce:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
801020d1:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
801020d4:	68 20 0a 12 80       	push   $0x80120a20
801020d9:	e8 02 2e 00 00       	call   80104ee0 <acquire>
  ip->ref++;
801020de:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
801020e2:	c7 04 24 20 0a 12 80 	movl   $0x80120a20,(%esp)
801020e9:	e8 b2 2e 00 00       	call   80104fa0 <release>
801020ee:	83 c4 10             	add    $0x10,%esp
801020f1:	eb 08                	jmp    801020fb <namex+0x4b>
801020f3:	90                   	nop
801020f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801020f8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801020fb:	0f b6 03             	movzbl (%ebx),%eax
801020fe:	3c 2f                	cmp    $0x2f,%al
80102100:	74 f6                	je     801020f8 <namex+0x48>
  if(*path == 0)
80102102:	84 c0                	test   %al,%al
80102104:	0f 84 ee 00 00 00    	je     801021f8 <namex+0x148>
  while(*path != '/' && *path != 0)
8010210a:	0f b6 03             	movzbl (%ebx),%eax
8010210d:	3c 2f                	cmp    $0x2f,%al
8010210f:	0f 84 b3 00 00 00    	je     801021c8 <namex+0x118>
80102115:	84 c0                	test   %al,%al
80102117:	89 da                	mov    %ebx,%edx
80102119:	75 09                	jne    80102124 <namex+0x74>
8010211b:	e9 a8 00 00 00       	jmp    801021c8 <namex+0x118>
80102120:	84 c0                	test   %al,%al
80102122:	74 0a                	je     8010212e <namex+0x7e>
    path++;
80102124:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80102127:	0f b6 02             	movzbl (%edx),%eax
8010212a:	3c 2f                	cmp    $0x2f,%al
8010212c:	75 f2                	jne    80102120 <namex+0x70>
8010212e:	89 d1                	mov    %edx,%ecx
80102130:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80102132:	83 f9 0d             	cmp    $0xd,%ecx
80102135:	0f 8e 91 00 00 00    	jle    801021cc <namex+0x11c>
    memmove(name, s, DIRSIZ);
8010213b:	83 ec 04             	sub    $0x4,%esp
8010213e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80102141:	6a 0e                	push   $0xe
80102143:	53                   	push   %ebx
80102144:	57                   	push   %edi
80102145:	e8 56 2f 00 00       	call   801050a0 <memmove>
    path++;
8010214a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
8010214d:	83 c4 10             	add    $0x10,%esp
    path++;
80102150:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80102152:	80 3a 2f             	cmpb   $0x2f,(%edx)
80102155:	75 11                	jne    80102168 <namex+0xb8>
80102157:	89 f6                	mov    %esi,%esi
80102159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80102160:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80102163:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102166:	74 f8                	je     80102160 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102168:	83 ec 0c             	sub    $0xc,%esp
8010216b:	56                   	push   %esi
8010216c:	e8 5f f9 ff ff       	call   80101ad0 <ilock>
    if(ip->type != T_DIR){
80102171:	83 c4 10             	add    $0x10,%esp
80102174:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102179:	0f 85 91 00 00 00    	jne    80102210 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
8010217f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102182:	85 d2                	test   %edx,%edx
80102184:	74 09                	je     8010218f <namex+0xdf>
80102186:	80 3b 00             	cmpb   $0x0,(%ebx)
80102189:	0f 84 b7 00 00 00    	je     80102246 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010218f:	83 ec 04             	sub    $0x4,%esp
80102192:	6a 00                	push   $0x0
80102194:	57                   	push   %edi
80102195:	56                   	push   %esi
80102196:	e8 65 fe ff ff       	call   80102000 <dirlookup>
8010219b:	83 c4 10             	add    $0x10,%esp
8010219e:	85 c0                	test   %eax,%eax
801021a0:	74 6e                	je     80102210 <namex+0x160>
  iunlock(ip);
801021a2:	83 ec 0c             	sub    $0xc,%esp
801021a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801021a8:	56                   	push   %esi
801021a9:	e8 02 fa ff ff       	call   80101bb0 <iunlock>
  iput(ip);
801021ae:	89 34 24             	mov    %esi,(%esp)
801021b1:	e8 4a fa ff ff       	call   80101c00 <iput>
801021b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801021b9:	83 c4 10             	add    $0x10,%esp
801021bc:	89 c6                	mov    %eax,%esi
801021be:	e9 38 ff ff ff       	jmp    801020fb <namex+0x4b>
801021c3:	90                   	nop
801021c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
801021c8:	89 da                	mov    %ebx,%edx
801021ca:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
801021cc:	83 ec 04             	sub    $0x4,%esp
801021cf:	89 55 dc             	mov    %edx,-0x24(%ebp)
801021d2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801021d5:	51                   	push   %ecx
801021d6:	53                   	push   %ebx
801021d7:	57                   	push   %edi
801021d8:	e8 c3 2e 00 00       	call   801050a0 <memmove>
    name[len] = 0;
801021dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801021e0:	8b 55 dc             	mov    -0x24(%ebp),%edx
801021e3:	83 c4 10             	add    $0x10,%esp
801021e6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
801021ea:	89 d3                	mov    %edx,%ebx
801021ec:	e9 61 ff ff ff       	jmp    80102152 <namex+0xa2>
801021f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801021f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801021fb:	85 c0                	test   %eax,%eax
801021fd:	75 5d                	jne    8010225c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
801021ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102202:	89 f0                	mov    %esi,%eax
80102204:	5b                   	pop    %ebx
80102205:	5e                   	pop    %esi
80102206:	5f                   	pop    %edi
80102207:	5d                   	pop    %ebp
80102208:	c3                   	ret    
80102209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102210:	83 ec 0c             	sub    $0xc,%esp
80102213:	56                   	push   %esi
80102214:	e8 97 f9 ff ff       	call   80101bb0 <iunlock>
  iput(ip);
80102219:	89 34 24             	mov    %esi,(%esp)
      return 0;
8010221c:	31 f6                	xor    %esi,%esi
  iput(ip);
8010221e:	e8 dd f9 ff ff       	call   80101c00 <iput>
      return 0;
80102223:	83 c4 10             	add    $0x10,%esp
}
80102226:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102229:	89 f0                	mov    %esi,%eax
8010222b:	5b                   	pop    %ebx
8010222c:	5e                   	pop    %esi
8010222d:	5f                   	pop    %edi
8010222e:	5d                   	pop    %ebp
8010222f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80102230:	ba 01 00 00 00       	mov    $0x1,%edx
80102235:	b8 01 00 00 00       	mov    $0x1,%eax
8010223a:	e8 a1 f4 ff ff       	call   801016e0 <iget>
8010223f:	89 c6                	mov    %eax,%esi
80102241:	e9 b5 fe ff ff       	jmp    801020fb <namex+0x4b>
      iunlock(ip);
80102246:	83 ec 0c             	sub    $0xc,%esp
80102249:	56                   	push   %esi
8010224a:	e8 61 f9 ff ff       	call   80101bb0 <iunlock>
      return ip;
8010224f:	83 c4 10             	add    $0x10,%esp
}
80102252:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102255:	89 f0                	mov    %esi,%eax
80102257:	5b                   	pop    %ebx
80102258:	5e                   	pop    %esi
80102259:	5f                   	pop    %edi
8010225a:	5d                   	pop    %ebp
8010225b:	c3                   	ret    
    iput(ip);
8010225c:	83 ec 0c             	sub    $0xc,%esp
8010225f:	56                   	push   %esi
    return 0;
80102260:	31 f6                	xor    %esi,%esi
    iput(ip);
80102262:	e8 99 f9 ff ff       	call   80101c00 <iput>
    return 0;
80102267:	83 c4 10             	add    $0x10,%esp
8010226a:	eb 93                	jmp    801021ff <namex+0x14f>
8010226c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102270 <dirlink>:
{
80102270:	55                   	push   %ebp
80102271:	89 e5                	mov    %esp,%ebp
80102273:	57                   	push   %edi
80102274:	56                   	push   %esi
80102275:	53                   	push   %ebx
80102276:	83 ec 20             	sub    $0x20,%esp
80102279:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010227c:	6a 00                	push   $0x0
8010227e:	ff 75 0c             	pushl  0xc(%ebp)
80102281:	53                   	push   %ebx
80102282:	e8 79 fd ff ff       	call   80102000 <dirlookup>
80102287:	83 c4 10             	add    $0x10,%esp
8010228a:	85 c0                	test   %eax,%eax
8010228c:	75 67                	jne    801022f5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010228e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102291:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102294:	85 ff                	test   %edi,%edi
80102296:	74 29                	je     801022c1 <dirlink+0x51>
80102298:	31 ff                	xor    %edi,%edi
8010229a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010229d:	eb 09                	jmp    801022a8 <dirlink+0x38>
8010229f:	90                   	nop
801022a0:	83 c7 10             	add    $0x10,%edi
801022a3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801022a6:	73 19                	jae    801022c1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022a8:	6a 10                	push   $0x10
801022aa:	57                   	push   %edi
801022ab:	56                   	push   %esi
801022ac:	53                   	push   %ebx
801022ad:	e8 fe fa ff ff       	call   80101db0 <readi>
801022b2:	83 c4 10             	add    $0x10,%esp
801022b5:	83 f8 10             	cmp    $0x10,%eax
801022b8:	75 4e                	jne    80102308 <dirlink+0x98>
    if(de.inum == 0)
801022ba:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801022bf:	75 df                	jne    801022a0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801022c1:	8d 45 da             	lea    -0x26(%ebp),%eax
801022c4:	83 ec 04             	sub    $0x4,%esp
801022c7:	6a 0e                	push   $0xe
801022c9:	ff 75 0c             	pushl  0xc(%ebp)
801022cc:	50                   	push   %eax
801022cd:	e8 9e 2e 00 00       	call   80105170 <strncpy>
  de.inum = inum;
801022d2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022d5:	6a 10                	push   $0x10
801022d7:	57                   	push   %edi
801022d8:	56                   	push   %esi
801022d9:	53                   	push   %ebx
  de.inum = inum;
801022da:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022de:	e8 cd fb ff ff       	call   80101eb0 <writei>
801022e3:	83 c4 20             	add    $0x20,%esp
801022e6:	83 f8 10             	cmp    $0x10,%eax
801022e9:	75 2a                	jne    80102315 <dirlink+0xa5>
  return 0;
801022eb:	31 c0                	xor    %eax,%eax
}
801022ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022f0:	5b                   	pop    %ebx
801022f1:	5e                   	pop    %esi
801022f2:	5f                   	pop    %edi
801022f3:	5d                   	pop    %ebp
801022f4:	c3                   	ret    
    iput(ip);
801022f5:	83 ec 0c             	sub    $0xc,%esp
801022f8:	50                   	push   %eax
801022f9:	e8 02 f9 ff ff       	call   80101c00 <iput>
    return -1;
801022fe:	83 c4 10             	add    $0x10,%esp
80102301:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102306:	eb e5                	jmp    801022ed <dirlink+0x7d>
      panic("dirlink read");
80102308:	83 ec 0c             	sub    $0xc,%esp
8010230b:	68 e8 87 10 80       	push   $0x801087e8
80102310:	e8 7b e0 ff ff       	call   80100390 <panic>
    panic("dirlink");
80102315:	83 ec 0c             	sub    $0xc,%esp
80102318:	68 b1 8e 10 80       	push   $0x80108eb1
8010231d:	e8 6e e0 ff ff       	call   80100390 <panic>
80102322:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102330 <namei>:

struct inode*
namei(char *path)
{
80102330:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102331:	31 d2                	xor    %edx,%edx
{
80102333:	89 e5                	mov    %esp,%ebp
80102335:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102338:	8b 45 08             	mov    0x8(%ebp),%eax
8010233b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010233e:	e8 6d fd ff ff       	call   801020b0 <namex>
}
80102343:	c9                   	leave  
80102344:	c3                   	ret    
80102345:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102350 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102350:	55                   	push   %ebp
  return namex(path, 1, name);
80102351:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102356:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102358:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010235b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010235e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010235f:	e9 4c fd ff ff       	jmp    801020b0 <namex>
80102364:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010236a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102370 <itoa>:

#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80102370:	55                   	push   %ebp
    char const digit[] = "0123456789";
80102371:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
80102376:	89 e5                	mov    %esp,%ebp
80102378:	57                   	push   %edi
80102379:	56                   	push   %esi
8010237a:	53                   	push   %ebx
8010237b:	83 ec 10             	sub    $0x10,%esp
8010237e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80102381:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
80102388:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
8010238f:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
80102393:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
80102397:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
8010239a:	85 c9                	test   %ecx,%ecx
8010239c:	79 0a                	jns    801023a8 <itoa+0x38>
8010239e:	89 f0                	mov    %esi,%eax
801023a0:	8d 76 01             	lea    0x1(%esi),%esi
        *p++ = '-';
        i *= -1;
801023a3:	f7 d9                	neg    %ecx
        *p++ = '-';
801023a5:	c6 00 2d             	movb   $0x2d,(%eax)
    }
    int shifter = i;
801023a8:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
801023aa:	bf 67 66 66 66       	mov    $0x66666667,%edi
801023af:	90                   	nop
801023b0:	89 d8                	mov    %ebx,%eax
801023b2:	c1 fb 1f             	sar    $0x1f,%ebx
        ++p;
801023b5:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
801023b8:	f7 ef                	imul   %edi
801023ba:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
801023bd:	29 da                	sub    %ebx,%edx
801023bf:	89 d3                	mov    %edx,%ebx
801023c1:	75 ed                	jne    801023b0 <itoa+0x40>
    *p = '\0';
801023c3:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
801023c6:	bb 67 66 66 66       	mov    $0x66666667,%ebx
801023cb:	90                   	nop
801023cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023d0:	89 c8                	mov    %ecx,%eax
801023d2:	83 ee 01             	sub    $0x1,%esi
801023d5:	f7 eb                	imul   %ebx
801023d7:	89 c8                	mov    %ecx,%eax
801023d9:	c1 f8 1f             	sar    $0x1f,%eax
801023dc:	c1 fa 02             	sar    $0x2,%edx
801023df:	29 c2                	sub    %eax,%edx
801023e1:	8d 04 92             	lea    (%edx,%edx,4),%eax
801023e4:	01 c0                	add    %eax,%eax
801023e6:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
801023e8:	85 d2                	test   %edx,%edx
        *--p = digit[i%10];
801023ea:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
801023ef:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
801023f1:	88 06                	mov    %al,(%esi)
    }while(i);
801023f3:	75 db                	jne    801023d0 <itoa+0x60>
    return b;
}
801023f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801023f8:	83 c4 10             	add    $0x10,%esp
801023fb:	5b                   	pop    %ebx
801023fc:	5e                   	pop    %esi
801023fd:	5f                   	pop    %edi
801023fe:	5d                   	pop    %ebp
801023ff:	c3                   	ret    

80102400 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	57                   	push   %edi
80102404:	56                   	push   %esi
80102405:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102406:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
80102409:	83 ec 40             	sub    $0x40,%esp
8010240c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
8010240f:	6a 06                	push   $0x6
80102411:	68 f5 87 10 80       	push   $0x801087f5
80102416:	56                   	push   %esi
80102417:	e8 84 2c 00 00       	call   801050a0 <memmove>
  itoa(p->pid, path+ 6);
8010241c:	58                   	pop    %eax
8010241d:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80102420:	5a                   	pop    %edx
80102421:	50                   	push   %eax
80102422:	ff 73 10             	pushl  0x10(%ebx)
80102425:	e8 46 ff ff ff       	call   80102370 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
8010242a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010242d:	83 c4 10             	add    $0x10,%esp
80102430:	85 c0                	test   %eax,%eax
80102432:	0f 84 88 01 00 00    	je     801025c0 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
80102438:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
8010243b:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
8010243e:	50                   	push   %eax
8010243f:	e8 4c ee ff ff       	call   80101290 <fileclose>

  begin_op();
80102444:	e8 b7 0f 00 00       	call   80103400 <begin_op>
  return namex(path, 1, name);
80102449:	89 f0                	mov    %esi,%eax
8010244b:	89 d9                	mov    %ebx,%ecx
8010244d:	ba 01 00 00 00       	mov    $0x1,%edx
80102452:	e8 59 fc ff ff       	call   801020b0 <namex>
  if((dp = nameiparent(path, name)) == 0)
80102457:	83 c4 10             	add    $0x10,%esp
8010245a:	85 c0                	test   %eax,%eax
  return namex(path, 1, name);
8010245c:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
8010245e:	0f 84 66 01 00 00    	je     801025ca <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
80102464:	83 ec 0c             	sub    $0xc,%esp
80102467:	50                   	push   %eax
80102468:	e8 63 f6 ff ff       	call   80101ad0 <ilock>
  return strncmp(s, t, DIRSIZ);
8010246d:	83 c4 0c             	add    $0xc,%esp
80102470:	6a 0e                	push   $0xe
80102472:	68 fd 87 10 80       	push   $0x801087fd
80102477:	53                   	push   %ebx
80102478:	e8 93 2c 00 00       	call   80105110 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010247d:	83 c4 10             	add    $0x10,%esp
80102480:	85 c0                	test   %eax,%eax
80102482:	0f 84 f8 00 00 00    	je     80102580 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
80102488:	83 ec 04             	sub    $0x4,%esp
8010248b:	6a 0e                	push   $0xe
8010248d:	68 fc 87 10 80       	push   $0x801087fc
80102492:	53                   	push   %ebx
80102493:	e8 78 2c 00 00       	call   80105110 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102498:	83 c4 10             	add    $0x10,%esp
8010249b:	85 c0                	test   %eax,%eax
8010249d:	0f 84 dd 00 00 00    	je     80102580 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801024a3:	8d 45 b8             	lea    -0x48(%ebp),%eax
801024a6:	83 ec 04             	sub    $0x4,%esp
801024a9:	50                   	push   %eax
801024aa:	53                   	push   %ebx
801024ab:	56                   	push   %esi
801024ac:	e8 4f fb ff ff       	call   80102000 <dirlookup>
801024b1:	83 c4 10             	add    $0x10,%esp
801024b4:	85 c0                	test   %eax,%eax
801024b6:	89 c3                	mov    %eax,%ebx
801024b8:	0f 84 c2 00 00 00    	je     80102580 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
801024be:	83 ec 0c             	sub    $0xc,%esp
801024c1:	50                   	push   %eax
801024c2:	e8 09 f6 ff ff       	call   80101ad0 <ilock>

  if(ip->nlink < 1)
801024c7:	83 c4 10             	add    $0x10,%esp
801024ca:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801024cf:	0f 8e 11 01 00 00    	jle    801025e6 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801024d5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801024da:	74 74                	je     80102550 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801024dc:	8d 7d d8             	lea    -0x28(%ebp),%edi
801024df:	83 ec 04             	sub    $0x4,%esp
801024e2:	6a 10                	push   $0x10
801024e4:	6a 00                	push   $0x0
801024e6:	57                   	push   %edi
801024e7:	e8 04 2b 00 00       	call   80104ff0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024ec:	6a 10                	push   $0x10
801024ee:	ff 75 b8             	pushl  -0x48(%ebp)
801024f1:	57                   	push   %edi
801024f2:	56                   	push   %esi
801024f3:	e8 b8 f9 ff ff       	call   80101eb0 <writei>
801024f8:	83 c4 20             	add    $0x20,%esp
801024fb:	83 f8 10             	cmp    $0x10,%eax
801024fe:	0f 85 d5 00 00 00    	jne    801025d9 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80102504:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102509:	0f 84 91 00 00 00    	je     801025a0 <removeSwapFile+0x1a0>
  iunlock(ip);
8010250f:	83 ec 0c             	sub    $0xc,%esp
80102512:	56                   	push   %esi
80102513:	e8 98 f6 ff ff       	call   80101bb0 <iunlock>
  iput(ip);
80102518:	89 34 24             	mov    %esi,(%esp)
8010251b:	e8 e0 f6 ff ff       	call   80101c00 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
80102520:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80102525:	89 1c 24             	mov    %ebx,(%esp)
80102528:	e8 f3 f4 ff ff       	call   80101a20 <iupdate>
  iunlock(ip);
8010252d:	89 1c 24             	mov    %ebx,(%esp)
80102530:	e8 7b f6 ff ff       	call   80101bb0 <iunlock>
  iput(ip);
80102535:	89 1c 24             	mov    %ebx,(%esp)
80102538:	e8 c3 f6 ff ff       	call   80101c00 <iput>
  iunlockput(ip);

  end_op();
8010253d:	e8 2e 0f 00 00       	call   80103470 <end_op>

  return 0;
80102542:	83 c4 10             	add    $0x10,%esp
80102545:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
80102547:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010254a:	5b                   	pop    %ebx
8010254b:	5e                   	pop    %esi
8010254c:	5f                   	pop    %edi
8010254d:	5d                   	pop    %ebp
8010254e:	c3                   	ret    
8010254f:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
80102550:	83 ec 0c             	sub    $0xc,%esp
80102553:	53                   	push   %ebx
80102554:	e8 77 32 00 00       	call   801057d0 <isdirempty>
80102559:	83 c4 10             	add    $0x10,%esp
8010255c:	85 c0                	test   %eax,%eax
8010255e:	0f 85 78 ff ff ff    	jne    801024dc <removeSwapFile+0xdc>
  iunlock(ip);
80102564:	83 ec 0c             	sub    $0xc,%esp
80102567:	53                   	push   %ebx
80102568:	e8 43 f6 ff ff       	call   80101bb0 <iunlock>
  iput(ip);
8010256d:	89 1c 24             	mov    %ebx,(%esp)
80102570:	e8 8b f6 ff ff       	call   80101c00 <iput>
80102575:	83 c4 10             	add    $0x10,%esp
80102578:	90                   	nop
80102579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102580:	83 ec 0c             	sub    $0xc,%esp
80102583:	56                   	push   %esi
80102584:	e8 27 f6 ff ff       	call   80101bb0 <iunlock>
  iput(ip);
80102589:	89 34 24             	mov    %esi,(%esp)
8010258c:	e8 6f f6 ff ff       	call   80101c00 <iput>
    end_op();
80102591:	e8 da 0e 00 00       	call   80103470 <end_op>
    return -1;
80102596:	83 c4 10             	add    $0x10,%esp
80102599:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010259e:	eb a7                	jmp    80102547 <removeSwapFile+0x147>
    dp->nlink--;
801025a0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801025a5:	83 ec 0c             	sub    $0xc,%esp
801025a8:	56                   	push   %esi
801025a9:	e8 72 f4 ff ff       	call   80101a20 <iupdate>
801025ae:	83 c4 10             	add    $0x10,%esp
801025b1:	e9 59 ff ff ff       	jmp    8010250f <removeSwapFile+0x10f>
801025b6:	8d 76 00             	lea    0x0(%esi),%esi
801025b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801025c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025c5:	e9 7d ff ff ff       	jmp    80102547 <removeSwapFile+0x147>
    end_op();
801025ca:	e8 a1 0e 00 00       	call   80103470 <end_op>
    return -1;
801025cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025d4:	e9 6e ff ff ff       	jmp    80102547 <removeSwapFile+0x147>
    panic("unlink: writei");
801025d9:	83 ec 0c             	sub    $0xc,%esp
801025dc:	68 11 88 10 80       	push   $0x80108811
801025e1:	e8 aa dd ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801025e6:	83 ec 0c             	sub    $0xc,%esp
801025e9:	68 ff 87 10 80       	push   $0x801087ff
801025ee:	e8 9d dd ff ff       	call   80100390 <panic>
801025f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801025f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102600 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
80102600:	55                   	push   %ebp
80102601:	89 e5                	mov    %esp,%ebp
80102603:	56                   	push   %esi
80102604:	53                   	push   %ebx

  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102605:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
80102608:	83 ec 14             	sub    $0x14,%esp
8010260b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
8010260e:	6a 06                	push   $0x6
80102610:	68 f5 87 10 80       	push   $0x801087f5
80102615:	56                   	push   %esi
80102616:	e8 85 2a 00 00       	call   801050a0 <memmove>
  itoa(p->pid, path+ 6);
8010261b:	58                   	pop    %eax
8010261c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010261f:	5a                   	pop    %edx
80102620:	50                   	push   %eax
80102621:	ff 73 10             	pushl  0x10(%ebx)
80102624:	e8 47 fd ff ff       	call   80102370 <itoa>

    begin_op();
80102629:	e8 d2 0d 00 00       	call   80103400 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
8010262e:	6a 00                	push   $0x0
80102630:	6a 00                	push   $0x0
80102632:	6a 02                	push   $0x2
80102634:	56                   	push   %esi
80102635:	e8 a6 33 00 00       	call   801059e0 <create>
  iunlock(in);
8010263a:	83 c4 14             	add    $0x14,%esp
    struct inode * in = create(path, T_FILE, 0, 0);
8010263d:	89 c6                	mov    %eax,%esi
  iunlock(in);
8010263f:	50                   	push   %eax
80102640:	e8 6b f5 ff ff       	call   80101bb0 <iunlock>

  p->swapFile = filealloc();
80102645:	e8 86 eb ff ff       	call   801011d0 <filealloc>
  if (p->swapFile == 0)
8010264a:	83 c4 10             	add    $0x10,%esp
8010264d:	85 c0                	test   %eax,%eax
  p->swapFile = filealloc();
8010264f:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
80102652:	74 32                	je     80102686 <createSwapFile+0x86>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
80102654:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
80102657:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010265a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
80102660:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102663:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
8010266a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010266d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
80102671:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102674:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
80102678:	e8 f3 0d 00 00       	call   80103470 <end_op>

    return 0;
}
8010267d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102680:	31 c0                	xor    %eax,%eax
80102682:	5b                   	pop    %ebx
80102683:	5e                   	pop    %esi
80102684:	5d                   	pop    %ebp
80102685:	c3                   	ret    
    panic("no slot for files on /store");
80102686:	83 ec 0c             	sub    $0xc,%esp
80102689:	68 20 88 10 80       	push   $0x80108820
8010268e:	e8 fd dc ff ff       	call   80100390 <panic>
80102693:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026a0 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc* p, char* buffer, uint placeOnFile, uint size)
{
801026a0:	55                   	push   %ebp
801026a1:	89 e5                	mov    %esp,%ebp
801026a3:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
801026a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801026a9:	8b 50 7c             	mov    0x7c(%eax),%edx
801026ac:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
801026af:	8b 55 14             	mov    0x14(%ebp),%edx
801026b2:	89 55 10             	mov    %edx,0x10(%ebp)
801026b5:	8b 40 7c             	mov    0x7c(%eax),%eax
801026b8:	89 45 08             	mov    %eax,0x8(%ebp)

}
801026bb:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
801026bc:	e9 7f ed ff ff       	jmp    80101440 <filewrite>
801026c1:	eb 0d                	jmp    801026d0 <readFromSwapFile>
801026c3:	90                   	nop
801026c4:	90                   	nop
801026c5:	90                   	nop
801026c6:	90                   	nop
801026c7:	90                   	nop
801026c8:	90                   	nop
801026c9:	90                   	nop
801026ca:	90                   	nop
801026cb:	90                   	nop
801026cc:	90                   	nop
801026cd:	90                   	nop
801026ce:	90                   	nop
801026cf:	90                   	nop

801026d0 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
801026d0:	55                   	push   %ebp
801026d1:	89 e5                	mov    %esp,%ebp
801026d3:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
801026d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801026d9:	8b 50 7c             	mov    0x7c(%eax),%edx
801026dc:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
801026df:	8b 55 14             	mov    0x14(%ebp),%edx
801026e2:	89 55 10             	mov    %edx,0x10(%ebp)
801026e5:	8b 40 7c             	mov    0x7c(%eax),%eax
801026e8:	89 45 08             	mov    %eax,0x8(%ebp)
}
801026eb:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
801026ec:	e9 bf ec ff ff       	jmp    801013b0 <fileread>
801026f1:	66 90                	xchg   %ax,%ax
801026f3:	66 90                	xchg   %ax,%ax
801026f5:	66 90                	xchg   %ax,%ax
801026f7:	66 90                	xchg   %ax,%ax
801026f9:	66 90                	xchg   %ax,%ax
801026fb:	66 90                	xchg   %ax,%ax
801026fd:	66 90                	xchg   %ax,%ax
801026ff:	90                   	nop

80102700 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102700:	55                   	push   %ebp
80102701:	89 e5                	mov    %esp,%ebp
80102703:	57                   	push   %edi
80102704:	56                   	push   %esi
80102705:	53                   	push   %ebx
80102706:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102709:	85 c0                	test   %eax,%eax
8010270b:	0f 84 b4 00 00 00    	je     801027c5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102711:	8b 58 08             	mov    0x8(%eax),%ebx
80102714:	89 c6                	mov    %eax,%esi
80102716:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010271c:	0f 87 96 00 00 00    	ja     801027b8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102722:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102727:	89 f6                	mov    %esi,%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102730:	89 ca                	mov    %ecx,%edx
80102732:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102733:	83 e0 c0             	and    $0xffffffc0,%eax
80102736:	3c 40                	cmp    $0x40,%al
80102738:	75 f6                	jne    80102730 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010273a:	31 ff                	xor    %edi,%edi
8010273c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102741:	89 f8                	mov    %edi,%eax
80102743:	ee                   	out    %al,(%dx)
80102744:	b8 01 00 00 00       	mov    $0x1,%eax
80102749:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010274e:	ee                   	out    %al,(%dx)
8010274f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102754:	89 d8                	mov    %ebx,%eax
80102756:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102757:	89 d8                	mov    %ebx,%eax
80102759:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010275e:	c1 f8 08             	sar    $0x8,%eax
80102761:	ee                   	out    %al,(%dx)
80102762:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102767:	89 f8                	mov    %edi,%eax
80102769:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010276a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010276e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102773:	c1 e0 04             	shl    $0x4,%eax
80102776:	83 e0 10             	and    $0x10,%eax
80102779:	83 c8 e0             	or     $0xffffffe0,%eax
8010277c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010277d:	f6 06 04             	testb  $0x4,(%esi)
80102780:	75 16                	jne    80102798 <idestart+0x98>
80102782:	b8 20 00 00 00       	mov    $0x20,%eax
80102787:	89 ca                	mov    %ecx,%edx
80102789:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010278a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010278d:	5b                   	pop    %ebx
8010278e:	5e                   	pop    %esi
8010278f:	5f                   	pop    %edi
80102790:	5d                   	pop    %ebp
80102791:	c3                   	ret    
80102792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102798:	b8 30 00 00 00       	mov    $0x30,%eax
8010279d:	89 ca                	mov    %ecx,%edx
8010279f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801027a0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801027a5:	83 c6 5c             	add    $0x5c,%esi
801027a8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801027ad:	fc                   	cld    
801027ae:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801027b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027b3:	5b                   	pop    %ebx
801027b4:	5e                   	pop    %esi
801027b5:	5f                   	pop    %edi
801027b6:	5d                   	pop    %ebp
801027b7:	c3                   	ret    
    panic("incorrect blockno");
801027b8:	83 ec 0c             	sub    $0xc,%esp
801027bb:	68 98 88 10 80       	push   $0x80108898
801027c0:	e8 cb db ff ff       	call   80100390 <panic>
    panic("idestart");
801027c5:	83 ec 0c             	sub    $0xc,%esp
801027c8:	68 8f 88 10 80       	push   $0x8010888f
801027cd:	e8 be db ff ff       	call   80100390 <panic>
801027d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027e0 <ideinit>:
{
801027e0:	55                   	push   %ebp
801027e1:	89 e5                	mov    %esp,%ebp
801027e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801027e6:	68 aa 88 10 80       	push   $0x801088aa
801027eb:	68 80 c5 10 80       	push   $0x8010c580
801027f0:	e8 ab 25 00 00       	call   80104da0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801027f5:	58                   	pop    %eax
801027f6:	a1 80 2d 12 80       	mov    0x80122d80,%eax
801027fb:	5a                   	pop    %edx
801027fc:	83 e8 01             	sub    $0x1,%eax
801027ff:	50                   	push   %eax
80102800:	6a 0e                	push   $0xe
80102802:	e8 a9 02 00 00       	call   80102ab0 <ioapicenable>
80102807:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010280a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010280f:	90                   	nop
80102810:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102811:	83 e0 c0             	and    $0xffffffc0,%eax
80102814:	3c 40                	cmp    $0x40,%al
80102816:	75 f8                	jne    80102810 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102818:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010281d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102822:	ee                   	out    %al,(%dx)
80102823:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102828:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010282d:	eb 06                	jmp    80102835 <ideinit+0x55>
8010282f:	90                   	nop
  for(i=0; i<1000; i++){
80102830:	83 e9 01             	sub    $0x1,%ecx
80102833:	74 0f                	je     80102844 <ideinit+0x64>
80102835:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102836:	84 c0                	test   %al,%al
80102838:	74 f6                	je     80102830 <ideinit+0x50>
      havedisk1 = 1;
8010283a:	c7 05 60 c5 10 80 01 	movl   $0x1,0x8010c560
80102841:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102844:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102849:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010284e:	ee                   	out    %al,(%dx)
}
8010284f:	c9                   	leave  
80102850:	c3                   	ret    
80102851:	eb 0d                	jmp    80102860 <ideintr>
80102853:	90                   	nop
80102854:	90                   	nop
80102855:	90                   	nop
80102856:	90                   	nop
80102857:	90                   	nop
80102858:	90                   	nop
80102859:	90                   	nop
8010285a:	90                   	nop
8010285b:	90                   	nop
8010285c:	90                   	nop
8010285d:	90                   	nop
8010285e:	90                   	nop
8010285f:	90                   	nop

80102860 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102860:	55                   	push   %ebp
80102861:	89 e5                	mov    %esp,%ebp
80102863:	57                   	push   %edi
80102864:	56                   	push   %esi
80102865:	53                   	push   %ebx
80102866:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102869:	68 80 c5 10 80       	push   $0x8010c580
8010286e:	e8 6d 26 00 00       	call   80104ee0 <acquire>

  if((b = idequeue) == 0){
80102873:	8b 1d 64 c5 10 80    	mov    0x8010c564,%ebx
80102879:	83 c4 10             	add    $0x10,%esp
8010287c:	85 db                	test   %ebx,%ebx
8010287e:	74 67                	je     801028e7 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102880:	8b 43 58             	mov    0x58(%ebx),%eax
80102883:	a3 64 c5 10 80       	mov    %eax,0x8010c564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102888:	8b 3b                	mov    (%ebx),%edi
8010288a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102890:	75 31                	jne    801028c3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102892:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102897:	89 f6                	mov    %esi,%esi
80102899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801028a0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801028a1:	89 c6                	mov    %eax,%esi
801028a3:	83 e6 c0             	and    $0xffffffc0,%esi
801028a6:	89 f1                	mov    %esi,%ecx
801028a8:	80 f9 40             	cmp    $0x40,%cl
801028ab:	75 f3                	jne    801028a0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801028ad:	a8 21                	test   $0x21,%al
801028af:	75 12                	jne    801028c3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801028b1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801028b4:	b9 80 00 00 00       	mov    $0x80,%ecx
801028b9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801028be:	fc                   	cld    
801028bf:	f3 6d                	rep insl (%dx),%es:(%edi)
801028c1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801028c3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801028c6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801028c9:	89 f9                	mov    %edi,%ecx
801028cb:	83 c9 02             	or     $0x2,%ecx
801028ce:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801028d0:	53                   	push   %ebx
801028d1:	e8 9a 21 00 00       	call   80104a70 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801028d6:	a1 64 c5 10 80       	mov    0x8010c564,%eax
801028db:	83 c4 10             	add    $0x10,%esp
801028de:	85 c0                	test   %eax,%eax
801028e0:	74 05                	je     801028e7 <ideintr+0x87>
    idestart(idequeue);
801028e2:	e8 19 fe ff ff       	call   80102700 <idestart>
    release(&idelock);
801028e7:	83 ec 0c             	sub    $0xc,%esp
801028ea:	68 80 c5 10 80       	push   $0x8010c580
801028ef:	e8 ac 26 00 00       	call   80104fa0 <release>

  release(&idelock);
}
801028f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801028f7:	5b                   	pop    %ebx
801028f8:	5e                   	pop    %esi
801028f9:	5f                   	pop    %edi
801028fa:	5d                   	pop    %ebp
801028fb:	c3                   	ret    
801028fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102900 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102900:	55                   	push   %ebp
80102901:	89 e5                	mov    %esp,%ebp
80102903:	53                   	push   %ebx
80102904:	83 ec 10             	sub    $0x10,%esp
80102907:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010290a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010290d:	50                   	push   %eax
8010290e:	e8 3d 24 00 00       	call   80104d50 <holdingsleep>
80102913:	83 c4 10             	add    $0x10,%esp
80102916:	85 c0                	test   %eax,%eax
80102918:	0f 84 c6 00 00 00    	je     801029e4 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010291e:	8b 03                	mov    (%ebx),%eax
80102920:	83 e0 06             	and    $0x6,%eax
80102923:	83 f8 02             	cmp    $0x2,%eax
80102926:	0f 84 ab 00 00 00    	je     801029d7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010292c:	8b 53 04             	mov    0x4(%ebx),%edx
8010292f:	85 d2                	test   %edx,%edx
80102931:	74 0d                	je     80102940 <iderw+0x40>
80102933:	a1 60 c5 10 80       	mov    0x8010c560,%eax
80102938:	85 c0                	test   %eax,%eax
8010293a:	0f 84 b1 00 00 00    	je     801029f1 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102940:	83 ec 0c             	sub    $0xc,%esp
80102943:	68 80 c5 10 80       	push   $0x8010c580
80102948:	e8 93 25 00 00       	call   80104ee0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010294d:	8b 15 64 c5 10 80    	mov    0x8010c564,%edx
80102953:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102956:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010295d:	85 d2                	test   %edx,%edx
8010295f:	75 09                	jne    8010296a <iderw+0x6a>
80102961:	eb 6d                	jmp    801029d0 <iderw+0xd0>
80102963:	90                   	nop
80102964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102968:	89 c2                	mov    %eax,%edx
8010296a:	8b 42 58             	mov    0x58(%edx),%eax
8010296d:	85 c0                	test   %eax,%eax
8010296f:	75 f7                	jne    80102968 <iderw+0x68>
80102971:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102974:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102976:	39 1d 64 c5 10 80    	cmp    %ebx,0x8010c564
8010297c:	74 42                	je     801029c0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010297e:	8b 03                	mov    (%ebx),%eax
80102980:	83 e0 06             	and    $0x6,%eax
80102983:	83 f8 02             	cmp    $0x2,%eax
80102986:	74 23                	je     801029ab <iderw+0xab>
80102988:	90                   	nop
80102989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102990:	83 ec 08             	sub    $0x8,%esp
80102993:	68 80 c5 10 80       	push   $0x8010c580
80102998:	53                   	push   %ebx
80102999:	e8 82 1e 00 00       	call   80104820 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010299e:	8b 03                	mov    (%ebx),%eax
801029a0:	83 c4 10             	add    $0x10,%esp
801029a3:	83 e0 06             	and    $0x6,%eax
801029a6:	83 f8 02             	cmp    $0x2,%eax
801029a9:	75 e5                	jne    80102990 <iderw+0x90>
  }


  release(&idelock);
801029ab:	c7 45 08 80 c5 10 80 	movl   $0x8010c580,0x8(%ebp)
}
801029b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029b5:	c9                   	leave  
  release(&idelock);
801029b6:	e9 e5 25 00 00       	jmp    80104fa0 <release>
801029bb:	90                   	nop
801029bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801029c0:	89 d8                	mov    %ebx,%eax
801029c2:	e8 39 fd ff ff       	call   80102700 <idestart>
801029c7:	eb b5                	jmp    8010297e <iderw+0x7e>
801029c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801029d0:	ba 64 c5 10 80       	mov    $0x8010c564,%edx
801029d5:	eb 9d                	jmp    80102974 <iderw+0x74>
    panic("iderw: nothing to do");
801029d7:	83 ec 0c             	sub    $0xc,%esp
801029da:	68 c4 88 10 80       	push   $0x801088c4
801029df:	e8 ac d9 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801029e4:	83 ec 0c             	sub    $0xc,%esp
801029e7:	68 ae 88 10 80       	push   $0x801088ae
801029ec:	e8 9f d9 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
801029f1:	83 ec 0c             	sub    $0xc,%esp
801029f4:	68 d9 88 10 80       	push   $0x801088d9
801029f9:	e8 92 d9 ff ff       	call   80100390 <panic>
801029fe:	66 90                	xchg   %ax,%ax

80102a00 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102a00:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102a01:	c7 05 74 26 12 80 00 	movl   $0xfec00000,0x80122674
80102a08:	00 c0 fe 
{
80102a0b:	89 e5                	mov    %esp,%ebp
80102a0d:	56                   	push   %esi
80102a0e:	53                   	push   %ebx
  ioapic->reg = reg;
80102a0f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102a16:	00 00 00 
  return ioapic->data;
80102a19:	a1 74 26 12 80       	mov    0x80122674,%eax
80102a1e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102a21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102a27:	8b 0d 74 26 12 80    	mov    0x80122674,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102a2d:	0f b6 15 e0 27 12 80 	movzbl 0x801227e0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a34:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102a37:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a3a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
80102a3d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102a40:	39 c2                	cmp    %eax,%edx
80102a42:	74 16                	je     80102a5a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102a44:	83 ec 0c             	sub    $0xc,%esp
80102a47:	68 f8 88 10 80       	push   $0x801088f8
80102a4c:	e8 0f dc ff ff       	call   80100660 <cprintf>
80102a51:	8b 0d 74 26 12 80    	mov    0x80122674,%ecx
80102a57:	83 c4 10             	add    $0x10,%esp
80102a5a:	83 c3 21             	add    $0x21,%ebx
{
80102a5d:	ba 10 00 00 00       	mov    $0x10,%edx
80102a62:	b8 20 00 00 00       	mov    $0x20,%eax
80102a67:	89 f6                	mov    %esi,%esi
80102a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102a70:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102a72:	8b 0d 74 26 12 80    	mov    0x80122674,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102a78:	89 c6                	mov    %eax,%esi
80102a7a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102a80:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102a83:	89 71 10             	mov    %esi,0x10(%ecx)
80102a86:	8d 72 01             	lea    0x1(%edx),%esi
80102a89:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
80102a8c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
80102a8e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102a90:	8b 0d 74 26 12 80    	mov    0x80122674,%ecx
80102a96:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102a9d:	75 d1                	jne    80102a70 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102a9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102aa2:	5b                   	pop    %ebx
80102aa3:	5e                   	pop    %esi
80102aa4:	5d                   	pop    %ebp
80102aa5:	c3                   	ret    
80102aa6:	8d 76 00             	lea    0x0(%esi),%esi
80102aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ab0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102ab0:	55                   	push   %ebp
  ioapic->reg = reg;
80102ab1:	8b 0d 74 26 12 80    	mov    0x80122674,%ecx
{
80102ab7:	89 e5                	mov    %esp,%ebp
80102ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102abc:	8d 50 20             	lea    0x20(%eax),%edx
80102abf:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102ac3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102ac5:	8b 0d 74 26 12 80    	mov    0x80122674,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102acb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102ace:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102ad1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102ad4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102ad6:	a1 74 26 12 80       	mov    0x80122674,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102adb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102ade:	89 50 10             	mov    %edx,0x10(%eax)
}
80102ae1:	5d                   	pop    %ebp
80102ae2:	c3                   	ret    
80102ae3:	66 90                	xchg   %ax,%ax
80102ae5:	66 90                	xchg   %ax,%ax
80102ae7:	66 90                	xchg   %ax,%ax
80102ae9:	66 90                	xchg   %ax,%ax
80102aeb:	66 90                	xchg   %ax,%ax
80102aed:	66 90                	xchg   %ax,%ax
80102aef:	90                   	nop

80102af0 <init_cow>:



struct spinlock r_cow_lock;

void init_cow(){
80102af0:	55                   	push   %ebp
80102af1:	89 e5                	mov    %esp,%ebp
80102af3:	83 ec 14             	sub    $0x14,%esp
  cprintf("initing cow\n");
80102af6:	68 2a 89 10 80       	push   $0x8010892a
80102afb:	e8 60 db ff ff       	call   80100660 <cprintf>
  memset((void*)pg_ref_counts, 0, sizeof(pg_ref_counts));
80102b00:	83 c4 0c             	add    $0xc,%esp
80102b03:	68 00 e0 00 00       	push   $0xe000
80102b08:	6a 00                	push   $0x0
80102b0a:	68 40 1f 11 80       	push   $0x80111f40
80102b0f:	e8 dc 24 00 00       	call   80104ff0 <memset>
  initlock(&r_cow_lock, "cow lock");
80102b14:	58                   	pop    %eax
80102b15:	5a                   	pop    %edx
80102b16:	68 37 89 10 80       	push   $0x80108937
80102b1b:	68 c0 26 12 80       	push   $0x801226c0
80102b20:	e8 7b 22 00 00       	call   80104da0 <initlock>
  cow_lock = &r_cow_lock;
  cprintf("initing cow end\n");
80102b25:	c7 04 24 40 89 10 80 	movl   $0x80108940,(%esp)
  cow_lock = &r_cow_lock;
80102b2c:	c7 05 40 ff 11 80 c0 	movl   $0x801226c0,0x8011ff40
80102b33:	26 12 80 
  cprintf("initing cow end\n");
80102b36:	e8 25 db ff ff       	call   80100660 <cprintf>
}
80102b3b:	83 c4 10             	add    $0x10,%esp
80102b3e:	c9                   	leave  
80102b3f:	c3                   	ret    

80102b40 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b40:	55                   	push   %ebp
80102b41:	89 e5                	mov    %esp,%ebp
80102b43:	53                   	push   %ebx
80102b44:	83 ec 04             	sub    $0x4,%esp
80102b47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102b4a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102b50:	75 70                	jne    80102bc2 <kfree+0x82>
80102b52:	81 fb 28 2a 13 80    	cmp    $0x80132a28,%ebx
80102b58:	72 68                	jb     80102bc2 <kfree+0x82>
80102b5a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102b60:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b65:	77 5b                	ja     80102bc2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b67:	83 ec 04             	sub    $0x4,%esp
80102b6a:	68 00 10 00 00       	push   $0x1000
80102b6f:	6a 01                	push   $0x1
80102b71:	53                   	push   %ebx
80102b72:	e8 79 24 00 00       	call   80104ff0 <memset>

  if(kmem.use_lock)
80102b77:	8b 15 b4 26 12 80    	mov    0x801226b4,%edx
80102b7d:	83 c4 10             	add    $0x10,%esp
80102b80:	85 d2                	test   %edx,%edx
80102b82:	75 2c                	jne    80102bb0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102b84:	a1 b8 26 12 80       	mov    0x801226b8,%eax
80102b89:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102b8b:	a1 b4 26 12 80       	mov    0x801226b4,%eax
  kmem.freelist = r;
80102b90:	89 1d b8 26 12 80    	mov    %ebx,0x801226b8
  if(kmem.use_lock)
80102b96:	85 c0                	test   %eax,%eax
80102b98:	75 06                	jne    80102ba0 <kfree+0x60>
    release(&kmem.lock);
}
80102b9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b9d:	c9                   	leave  
80102b9e:	c3                   	ret    
80102b9f:	90                   	nop
    release(&kmem.lock);
80102ba0:	c7 45 08 80 26 12 80 	movl   $0x80122680,0x8(%ebp)
}
80102ba7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102baa:	c9                   	leave  
    release(&kmem.lock);
80102bab:	e9 f0 23 00 00       	jmp    80104fa0 <release>
    acquire(&kmem.lock);
80102bb0:	83 ec 0c             	sub    $0xc,%esp
80102bb3:	68 80 26 12 80       	push   $0x80122680
80102bb8:	e8 23 23 00 00       	call   80104ee0 <acquire>
80102bbd:	83 c4 10             	add    $0x10,%esp
80102bc0:	eb c2                	jmp    80102b84 <kfree+0x44>
    panic("kfree");
80102bc2:	83 ec 0c             	sub    $0xc,%esp
80102bc5:	68 23 92 10 80       	push   $0x80109223
80102bca:	e8 c1 d7 ff ff       	call   80100390 <panic>
80102bcf:	90                   	nop

80102bd0 <freerange>:
{
80102bd0:	55                   	push   %ebp
80102bd1:	89 e5                	mov    %esp,%ebp
80102bd3:	56                   	push   %esi
80102bd4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102bd5:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102bd8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102bdb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102be1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102be7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102bed:	39 de                	cmp    %ebx,%esi
80102bef:	72 33                	jb     80102c24 <freerange+0x54>
80102bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102bf8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102bfe:	83 ec 0c             	sub    $0xc,%esp
80102c01:	50                   	push   %eax
80102c02:	e8 39 ff ff ff       	call   80102b40 <kfree>
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102c07:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102c0d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c13:	83 c4 10             	add    $0x10,%esp
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102c16:	c1 e8 0c             	shr    $0xc,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102c19:	39 f3                	cmp    %esi,%ebx
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102c1b:	c6 80 40 1f 11 80 00 	movb   $0x0,-0x7feee0c0(%eax)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102c22:	76 d4                	jbe    80102bf8 <freerange+0x28>
}
80102c24:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c27:	5b                   	pop    %ebx
80102c28:	5e                   	pop    %esi
80102c29:	5d                   	pop    %ebp
80102c2a:	c3                   	ret    
80102c2b:	90                   	nop
80102c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c30 <kinit1>:
{
80102c30:	55                   	push   %ebp
80102c31:	89 e5                	mov    %esp,%ebp
80102c33:	56                   	push   %esi
80102c34:	53                   	push   %ebx
80102c35:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102c38:	83 ec 08             	sub    $0x8,%esp
80102c3b:	68 51 89 10 80       	push   $0x80108951
80102c40:	68 80 26 12 80       	push   $0x80122680
80102c45:	e8 56 21 00 00       	call   80104da0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102c4d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102c50:	c7 05 b4 26 12 80 00 	movl   $0x0,0x801226b4
80102c57:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102c5a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102c60:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102c66:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c6c:	39 de                	cmp    %ebx,%esi
80102c6e:	72 2c                	jb     80102c9c <kinit1+0x6c>
    kfree(p);
80102c70:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102c76:	83 ec 0c             	sub    $0xc,%esp
80102c79:	50                   	push   %eax
80102c7a:	e8 c1 fe ff ff       	call   80102b40 <kfree>
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102c7f:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102c85:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c8b:	83 c4 10             	add    $0x10,%esp
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102c8e:	c1 e8 0c             	shr    $0xc,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102c91:	39 de                	cmp    %ebx,%esi
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102c93:	c6 80 40 1f 11 80 00 	movb   $0x0,-0x7feee0c0(%eax)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102c9a:	73 d4                	jae    80102c70 <kinit1+0x40>
}
80102c9c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c9f:	5b                   	pop    %ebx
80102ca0:	5e                   	pop    %esi
80102ca1:	5d                   	pop    %ebp
80102ca2:	c3                   	ret    
80102ca3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102cb0 <kinit2>:
{
80102cb0:	55                   	push   %ebp
80102cb1:	89 e5                	mov    %esp,%ebp
80102cb3:	56                   	push   %esi
80102cb4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102cb5:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102cb8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102cbb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102cc1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102cc7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102ccd:	39 de                	cmp    %ebx,%esi
80102ccf:	72 33                	jb     80102d04 <kinit2+0x54>
80102cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102cd8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102cde:	83 ec 0c             	sub    $0xc,%esp
80102ce1:	50                   	push   %eax
80102ce2:	e8 59 fe ff ff       	call   80102b40 <kfree>
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102ce7:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102ced:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102cf3:	83 c4 10             	add    $0x10,%esp
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102cf6:	c1 e8 0c             	shr    $0xc,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102cf9:	39 de                	cmp    %ebx,%esi
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102cfb:	c6 80 40 1f 11 80 00 	movb   $0x0,-0x7feee0c0(%eax)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102d02:	73 d4                	jae    80102cd8 <kinit2+0x28>
  kmem.use_lock = 1;
80102d04:	c7 05 b4 26 12 80 01 	movl   $0x1,0x801226b4
80102d0b:	00 00 00 
}
80102d0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d11:	5b                   	pop    %ebx
80102d12:	5e                   	pop    %esi
80102d13:	5d                   	pop    %ebp
80102d14:	c3                   	ret    
80102d15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d20 <kalloc>:
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
  struct run *r;
  if(kmem.use_lock)
80102d20:	a1 b4 26 12 80       	mov    0x801226b4,%eax
80102d25:	85 c0                	test   %eax,%eax
80102d27:	75 1f                	jne    80102d48 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102d29:	a1 b8 26 12 80       	mov    0x801226b8,%eax
  if(r)
80102d2e:	85 c0                	test   %eax,%eax
80102d30:	74 0e                	je     80102d40 <kalloc+0x20>
    kmem.freelist = r->next;
80102d32:	8b 10                	mov    (%eax),%edx
80102d34:	89 15 b8 26 12 80    	mov    %edx,0x801226b8
80102d3a:	c3                   	ret    
80102d3b:	90                   	nop
80102d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102d40:	f3 c3                	repz ret 
80102d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102d48:	55                   	push   %ebp
80102d49:	89 e5                	mov    %esp,%ebp
80102d4b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102d4e:	68 80 26 12 80       	push   $0x80122680
80102d53:	e8 88 21 00 00       	call   80104ee0 <acquire>
  r = kmem.freelist;
80102d58:	a1 b8 26 12 80       	mov    0x801226b8,%eax
  if(r)
80102d5d:	83 c4 10             	add    $0x10,%esp
80102d60:	8b 15 b4 26 12 80    	mov    0x801226b4,%edx
80102d66:	85 c0                	test   %eax,%eax
80102d68:	74 08                	je     80102d72 <kalloc+0x52>
    kmem.freelist = r->next;
80102d6a:	8b 08                	mov    (%eax),%ecx
80102d6c:	89 0d b8 26 12 80    	mov    %ecx,0x801226b8
  if(kmem.use_lock)
80102d72:	85 d2                	test   %edx,%edx
80102d74:	74 16                	je     80102d8c <kalloc+0x6c>
    release(&kmem.lock);
80102d76:	83 ec 0c             	sub    $0xc,%esp
80102d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102d7c:	68 80 26 12 80       	push   $0x80122680
80102d81:	e8 1a 22 00 00       	call   80104fa0 <release>
  return (char*)r;
80102d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102d89:	83 c4 10             	add    $0x10,%esp
}
80102d8c:	c9                   	leave  
80102d8d:	c3                   	ret    
80102d8e:	66 90                	xchg   %ax,%ax

80102d90 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d90:	ba 64 00 00 00       	mov    $0x64,%edx
80102d95:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102d96:	a8 01                	test   $0x1,%al
80102d98:	0f 84 c2 00 00 00    	je     80102e60 <kbdgetc+0xd0>
80102d9e:	ba 60 00 00 00       	mov    $0x60,%edx
80102da3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102da4:	0f b6 d0             	movzbl %al,%edx
80102da7:	8b 0d b4 c5 10 80    	mov    0x8010c5b4,%ecx

  if(data == 0xE0){
80102dad:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102db3:	0f 84 7f 00 00 00    	je     80102e38 <kbdgetc+0xa8>
{
80102db9:	55                   	push   %ebp
80102dba:	89 e5                	mov    %esp,%ebp
80102dbc:	53                   	push   %ebx
80102dbd:	89 cb                	mov    %ecx,%ebx
80102dbf:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102dc2:	84 c0                	test   %al,%al
80102dc4:	78 4a                	js     80102e10 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102dc6:	85 db                	test   %ebx,%ebx
80102dc8:	74 09                	je     80102dd3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102dca:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102dcd:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102dd0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102dd3:	0f b6 82 80 8a 10 80 	movzbl -0x7fef7580(%edx),%eax
80102dda:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102ddc:	0f b6 82 80 89 10 80 	movzbl -0x7fef7680(%edx),%eax
80102de3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102de5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102de7:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102ded:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102df0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102df3:	8b 04 85 60 89 10 80 	mov    -0x7fef76a0(,%eax,4),%eax
80102dfa:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102dfe:	74 31                	je     80102e31 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102e00:	8d 50 9f             	lea    -0x61(%eax),%edx
80102e03:	83 fa 19             	cmp    $0x19,%edx
80102e06:	77 40                	ja     80102e48 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102e08:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102e0b:	5b                   	pop    %ebx
80102e0c:	5d                   	pop    %ebp
80102e0d:	c3                   	ret    
80102e0e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102e10:	83 e0 7f             	and    $0x7f,%eax
80102e13:	85 db                	test   %ebx,%ebx
80102e15:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102e18:	0f b6 82 80 8a 10 80 	movzbl -0x7fef7580(%edx),%eax
80102e1f:	83 c8 40             	or     $0x40,%eax
80102e22:	0f b6 c0             	movzbl %al,%eax
80102e25:	f7 d0                	not    %eax
80102e27:	21 c1                	and    %eax,%ecx
    return 0;
80102e29:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102e2b:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
}
80102e31:	5b                   	pop    %ebx
80102e32:	5d                   	pop    %ebp
80102e33:	c3                   	ret    
80102e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102e38:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102e3b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102e3d:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
    return 0;
80102e43:	c3                   	ret    
80102e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102e48:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102e4b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102e4e:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102e4f:	83 f9 1a             	cmp    $0x1a,%ecx
80102e52:	0f 42 c2             	cmovb  %edx,%eax
}
80102e55:	5d                   	pop    %ebp
80102e56:	c3                   	ret    
80102e57:	89 f6                	mov    %esi,%esi
80102e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102e60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102e65:	c3                   	ret    
80102e66:	8d 76 00             	lea    0x0(%esi),%esi
80102e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e70 <kbdintr>:

void
kbdintr(void)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102e76:	68 90 2d 10 80       	push   $0x80102d90
80102e7b:	e8 90 d9 ff ff       	call   80100810 <consoleintr>
}
80102e80:	83 c4 10             	add    $0x10,%esp
80102e83:	c9                   	leave  
80102e84:	c3                   	ret    
80102e85:	66 90                	xchg   %ax,%ax
80102e87:	66 90                	xchg   %ax,%ax
80102e89:	66 90                	xchg   %ax,%ax
80102e8b:	66 90                	xchg   %ax,%ax
80102e8d:	66 90                	xchg   %ax,%ax
80102e8f:	90                   	nop

80102e90 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102e90:	a1 f4 26 12 80       	mov    0x801226f4,%eax
{
80102e95:	55                   	push   %ebp
80102e96:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102e98:	85 c0                	test   %eax,%eax
80102e9a:	0f 84 c8 00 00 00    	je     80102f68 <lapicinit+0xd8>
  lapic[index] = value;
80102ea0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102ea7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102eaa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ead:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102eb4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102eb7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102eba:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102ec1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102ec4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ec7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102ece:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102ed1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ed4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102edb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102ede:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ee1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102ee8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102eeb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102eee:	8b 50 30             	mov    0x30(%eax),%edx
80102ef1:	c1 ea 10             	shr    $0x10,%edx
80102ef4:	80 fa 03             	cmp    $0x3,%dl
80102ef7:	77 77                	ja     80102f70 <lapicinit+0xe0>
  lapic[index] = value;
80102ef9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102f00:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f03:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f06:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102f0d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f10:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f13:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102f1a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f1d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f20:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102f27:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f2a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f2d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102f34:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f37:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f3a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102f41:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102f44:	8b 50 20             	mov    0x20(%eax),%edx
80102f47:	89 f6                	mov    %esi,%esi
80102f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102f50:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102f56:	80 e6 10             	and    $0x10,%dh
80102f59:	75 f5                	jne    80102f50 <lapicinit+0xc0>
  lapic[index] = value;
80102f5b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102f62:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f65:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102f68:	5d                   	pop    %ebp
80102f69:	c3                   	ret    
80102f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102f70:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102f77:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102f7a:	8b 50 20             	mov    0x20(%eax),%edx
80102f7d:	e9 77 ff ff ff       	jmp    80102ef9 <lapicinit+0x69>
80102f82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f90 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102f90:	8b 15 f4 26 12 80    	mov    0x801226f4,%edx
{
80102f96:	55                   	push   %ebp
80102f97:	31 c0                	xor    %eax,%eax
80102f99:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102f9b:	85 d2                	test   %edx,%edx
80102f9d:	74 06                	je     80102fa5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102f9f:	8b 42 20             	mov    0x20(%edx),%eax
80102fa2:	c1 e8 18             	shr    $0x18,%eax
}
80102fa5:	5d                   	pop    %ebp
80102fa6:	c3                   	ret    
80102fa7:	89 f6                	mov    %esi,%esi
80102fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fb0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102fb0:	a1 f4 26 12 80       	mov    0x801226f4,%eax
{
80102fb5:	55                   	push   %ebp
80102fb6:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102fb8:	85 c0                	test   %eax,%eax
80102fba:	74 0d                	je     80102fc9 <lapiceoi+0x19>
  lapic[index] = value;
80102fbc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102fc3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102fc6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102fc9:	5d                   	pop    %ebp
80102fca:	c3                   	ret    
80102fcb:	90                   	nop
80102fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102fd0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
}
80102fd3:	5d                   	pop    %ebp
80102fd4:	c3                   	ret    
80102fd5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fe0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102fe0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fe1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102fe6:	ba 70 00 00 00       	mov    $0x70,%edx
80102feb:	89 e5                	mov    %esp,%ebp
80102fed:	53                   	push   %ebx
80102fee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102ff1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102ff4:	ee                   	out    %al,(%dx)
80102ff5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ffa:	ba 71 00 00 00       	mov    $0x71,%edx
80102fff:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103000:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103002:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103005:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010300b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010300d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80103010:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80103013:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80103015:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80103018:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010301e:	a1 f4 26 12 80       	mov    0x801226f4,%eax
80103023:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103029:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010302c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103033:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103036:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103039:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103040:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103043:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103046:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010304c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010304f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103055:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103058:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010305e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103061:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103067:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010306a:	5b                   	pop    %ebx
8010306b:	5d                   	pop    %ebp
8010306c:	c3                   	ret    
8010306d:	8d 76 00             	lea    0x0(%esi),%esi

80103070 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103070:	55                   	push   %ebp
80103071:	b8 0b 00 00 00       	mov    $0xb,%eax
80103076:	ba 70 00 00 00       	mov    $0x70,%edx
8010307b:	89 e5                	mov    %esp,%ebp
8010307d:	57                   	push   %edi
8010307e:	56                   	push   %esi
8010307f:	53                   	push   %ebx
80103080:	83 ec 4c             	sub    $0x4c,%esp
80103083:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103084:	ba 71 00 00 00       	mov    $0x71,%edx
80103089:	ec                   	in     (%dx),%al
8010308a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010308d:	bb 70 00 00 00       	mov    $0x70,%ebx
80103092:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103095:	8d 76 00             	lea    0x0(%esi),%esi
80103098:	31 c0                	xor    %eax,%eax
8010309a:	89 da                	mov    %ebx,%edx
8010309c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010309d:	b9 71 00 00 00       	mov    $0x71,%ecx
801030a2:	89 ca                	mov    %ecx,%edx
801030a4:	ec                   	in     (%dx),%al
801030a5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030a8:	89 da                	mov    %ebx,%edx
801030aa:	b8 02 00 00 00       	mov    $0x2,%eax
801030af:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030b0:	89 ca                	mov    %ecx,%edx
801030b2:	ec                   	in     (%dx),%al
801030b3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030b6:	89 da                	mov    %ebx,%edx
801030b8:	b8 04 00 00 00       	mov    $0x4,%eax
801030bd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030be:	89 ca                	mov    %ecx,%edx
801030c0:	ec                   	in     (%dx),%al
801030c1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030c4:	89 da                	mov    %ebx,%edx
801030c6:	b8 07 00 00 00       	mov    $0x7,%eax
801030cb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030cc:	89 ca                	mov    %ecx,%edx
801030ce:	ec                   	in     (%dx),%al
801030cf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030d2:	89 da                	mov    %ebx,%edx
801030d4:	b8 08 00 00 00       	mov    $0x8,%eax
801030d9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030da:	89 ca                	mov    %ecx,%edx
801030dc:	ec                   	in     (%dx),%al
801030dd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030df:	89 da                	mov    %ebx,%edx
801030e1:	b8 09 00 00 00       	mov    $0x9,%eax
801030e6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030e7:	89 ca                	mov    %ecx,%edx
801030e9:	ec                   	in     (%dx),%al
801030ea:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030ec:	89 da                	mov    %ebx,%edx
801030ee:	b8 0a 00 00 00       	mov    $0xa,%eax
801030f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030f4:	89 ca                	mov    %ecx,%edx
801030f6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801030f7:	84 c0                	test   %al,%al
801030f9:	78 9d                	js     80103098 <cmostime+0x28>
  return inb(CMOS_RETURN);
801030fb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801030ff:	89 fa                	mov    %edi,%edx
80103101:	0f b6 fa             	movzbl %dl,%edi
80103104:	89 f2                	mov    %esi,%edx
80103106:	0f b6 f2             	movzbl %dl,%esi
80103109:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010310c:	89 da                	mov    %ebx,%edx
8010310e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103111:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103114:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103118:	89 45 bc             	mov    %eax,-0x44(%ebp)
8010311b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010311f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80103122:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80103126:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103129:	31 c0                	xor    %eax,%eax
8010312b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010312c:	89 ca                	mov    %ecx,%edx
8010312e:	ec                   	in     (%dx),%al
8010312f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103132:	89 da                	mov    %ebx,%edx
80103134:	89 45 d0             	mov    %eax,-0x30(%ebp)
80103137:	b8 02 00 00 00       	mov    $0x2,%eax
8010313c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010313d:	89 ca                	mov    %ecx,%edx
8010313f:	ec                   	in     (%dx),%al
80103140:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103143:	89 da                	mov    %ebx,%edx
80103145:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103148:	b8 04 00 00 00       	mov    $0x4,%eax
8010314d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010314e:	89 ca                	mov    %ecx,%edx
80103150:	ec                   	in     (%dx),%al
80103151:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103154:	89 da                	mov    %ebx,%edx
80103156:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103159:	b8 07 00 00 00       	mov    $0x7,%eax
8010315e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010315f:	89 ca                	mov    %ecx,%edx
80103161:	ec                   	in     (%dx),%al
80103162:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103165:	89 da                	mov    %ebx,%edx
80103167:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010316a:	b8 08 00 00 00       	mov    $0x8,%eax
8010316f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103170:	89 ca                	mov    %ecx,%edx
80103172:	ec                   	in     (%dx),%al
80103173:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103176:	89 da                	mov    %ebx,%edx
80103178:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010317b:	b8 09 00 00 00       	mov    $0x9,%eax
80103180:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103181:	89 ca                	mov    %ecx,%edx
80103183:	ec                   	in     (%dx),%al
80103184:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103187:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010318a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010318d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103190:	6a 18                	push   $0x18
80103192:	50                   	push   %eax
80103193:	8d 45 b8             	lea    -0x48(%ebp),%eax
80103196:	50                   	push   %eax
80103197:	e8 a4 1e 00 00       	call   80105040 <memcmp>
8010319c:	83 c4 10             	add    $0x10,%esp
8010319f:	85 c0                	test   %eax,%eax
801031a1:	0f 85 f1 fe ff ff    	jne    80103098 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801031a7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
801031ab:	75 78                	jne    80103225 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801031ad:	8b 45 b8             	mov    -0x48(%ebp),%eax
801031b0:	89 c2                	mov    %eax,%edx
801031b2:	83 e0 0f             	and    $0xf,%eax
801031b5:	c1 ea 04             	shr    $0x4,%edx
801031b8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031bb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031be:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801031c1:	8b 45 bc             	mov    -0x44(%ebp),%eax
801031c4:	89 c2                	mov    %eax,%edx
801031c6:	83 e0 0f             	and    $0xf,%eax
801031c9:	c1 ea 04             	shr    $0x4,%edx
801031cc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031cf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031d2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801031d5:	8b 45 c0             	mov    -0x40(%ebp),%eax
801031d8:	89 c2                	mov    %eax,%edx
801031da:	83 e0 0f             	and    $0xf,%eax
801031dd:	c1 ea 04             	shr    $0x4,%edx
801031e0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031e3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031e6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801031e9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801031ec:	89 c2                	mov    %eax,%edx
801031ee:	83 e0 0f             	and    $0xf,%eax
801031f1:	c1 ea 04             	shr    $0x4,%edx
801031f4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031f7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031fa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801031fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103200:	89 c2                	mov    %eax,%edx
80103202:	83 e0 0f             	and    $0xf,%eax
80103205:	c1 ea 04             	shr    $0x4,%edx
80103208:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010320b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010320e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103211:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103214:	89 c2                	mov    %eax,%edx
80103216:	83 e0 0f             	and    $0xf,%eax
80103219:	c1 ea 04             	shr    $0x4,%edx
8010321c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010321f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103222:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103225:	8b 75 08             	mov    0x8(%ebp),%esi
80103228:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010322b:	89 06                	mov    %eax,(%esi)
8010322d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103230:	89 46 04             	mov    %eax,0x4(%esi)
80103233:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103236:	89 46 08             	mov    %eax,0x8(%esi)
80103239:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010323c:	89 46 0c             	mov    %eax,0xc(%esi)
8010323f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103242:	89 46 10             	mov    %eax,0x10(%esi)
80103245:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103248:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
8010324b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80103252:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103255:	5b                   	pop    %ebx
80103256:	5e                   	pop    %esi
80103257:	5f                   	pop    %edi
80103258:	5d                   	pop    %ebp
80103259:	c3                   	ret    
8010325a:	66 90                	xchg   %ax,%ax
8010325c:	66 90                	xchg   %ax,%ax
8010325e:	66 90                	xchg   %ax,%ax

80103260 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103260:	8b 0d 48 27 12 80    	mov    0x80122748,%ecx
80103266:	85 c9                	test   %ecx,%ecx
80103268:	0f 8e 8a 00 00 00    	jle    801032f8 <install_trans+0x98>
{
8010326e:	55                   	push   %ebp
8010326f:	89 e5                	mov    %esp,%ebp
80103271:	57                   	push   %edi
80103272:	56                   	push   %esi
80103273:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80103274:	31 db                	xor    %ebx,%ebx
{
80103276:	83 ec 0c             	sub    $0xc,%esp
80103279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103280:	a1 34 27 12 80       	mov    0x80122734,%eax
80103285:	83 ec 08             	sub    $0x8,%esp
80103288:	01 d8                	add    %ebx,%eax
8010328a:	83 c0 01             	add    $0x1,%eax
8010328d:	50                   	push   %eax
8010328e:	ff 35 44 27 12 80    	pushl  0x80122744
80103294:	e8 37 ce ff ff       	call   801000d0 <bread>
80103299:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010329b:	58                   	pop    %eax
8010329c:	5a                   	pop    %edx
8010329d:	ff 34 9d 4c 27 12 80 	pushl  -0x7fedd8b4(,%ebx,4)
801032a4:	ff 35 44 27 12 80    	pushl  0x80122744
  for (tail = 0; tail < log.lh.n; tail++) {
801032aa:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801032ad:	e8 1e ce ff ff       	call   801000d0 <bread>
801032b2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801032b4:	8d 47 5c             	lea    0x5c(%edi),%eax
801032b7:	83 c4 0c             	add    $0xc,%esp
801032ba:	68 00 02 00 00       	push   $0x200
801032bf:	50                   	push   %eax
801032c0:	8d 46 5c             	lea    0x5c(%esi),%eax
801032c3:	50                   	push   %eax
801032c4:	e8 d7 1d 00 00       	call   801050a0 <memmove>
    bwrite(dbuf);  // write dst to disk
801032c9:	89 34 24             	mov    %esi,(%esp)
801032cc:	e8 cf ce ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801032d1:	89 3c 24             	mov    %edi,(%esp)
801032d4:	e8 07 cf ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801032d9:	89 34 24             	mov    %esi,(%esp)
801032dc:	e8 ff ce ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801032e1:	83 c4 10             	add    $0x10,%esp
801032e4:	39 1d 48 27 12 80    	cmp    %ebx,0x80122748
801032ea:	7f 94                	jg     80103280 <install_trans+0x20>
  }
}
801032ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032ef:	5b                   	pop    %ebx
801032f0:	5e                   	pop    %esi
801032f1:	5f                   	pop    %edi
801032f2:	5d                   	pop    %ebp
801032f3:	c3                   	ret    
801032f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032f8:	f3 c3                	repz ret 
801032fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103300 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103300:	55                   	push   %ebp
80103301:	89 e5                	mov    %esp,%ebp
80103303:	56                   	push   %esi
80103304:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80103305:	83 ec 08             	sub    $0x8,%esp
80103308:	ff 35 34 27 12 80    	pushl  0x80122734
8010330e:	ff 35 44 27 12 80    	pushl  0x80122744
80103314:	e8 b7 cd ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80103319:	8b 1d 48 27 12 80    	mov    0x80122748,%ebx
  for (i = 0; i < log.lh.n; i++) {
8010331f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80103322:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80103324:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80103326:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103329:	7e 16                	jle    80103341 <write_head+0x41>
8010332b:	c1 e3 02             	shl    $0x2,%ebx
8010332e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80103330:	8b 8a 4c 27 12 80    	mov    -0x7fedd8b4(%edx),%ecx
80103336:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
8010333a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
8010333d:	39 da                	cmp    %ebx,%edx
8010333f:	75 ef                	jne    80103330 <write_head+0x30>
  }
  bwrite(buf);
80103341:	83 ec 0c             	sub    $0xc,%esp
80103344:	56                   	push   %esi
80103345:	e8 56 ce ff ff       	call   801001a0 <bwrite>
  brelse(buf);
8010334a:	89 34 24             	mov    %esi,(%esp)
8010334d:	e8 8e ce ff ff       	call   801001e0 <brelse>
}
80103352:	83 c4 10             	add    $0x10,%esp
80103355:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103358:	5b                   	pop    %ebx
80103359:	5e                   	pop    %esi
8010335a:	5d                   	pop    %ebp
8010335b:	c3                   	ret    
8010335c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103360 <initlog>:
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	53                   	push   %ebx
80103364:	83 ec 2c             	sub    $0x2c,%esp
80103367:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010336a:	68 80 8b 10 80       	push   $0x80108b80
8010336f:	68 00 27 12 80       	push   $0x80122700
80103374:	e8 27 1a 00 00       	call   80104da0 <initlock>
  readsb(dev, &sb);
80103379:	58                   	pop    %eax
8010337a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010337d:	5a                   	pop    %edx
8010337e:	50                   	push   %eax
8010337f:	53                   	push   %ebx
80103380:	e8 0b e5 ff ff       	call   80101890 <readsb>
  log.size = sb.nlog;
80103385:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103388:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010338b:	59                   	pop    %ecx
  log.dev = dev;
8010338c:	89 1d 44 27 12 80    	mov    %ebx,0x80122744
  log.size = sb.nlog;
80103392:	89 15 38 27 12 80    	mov    %edx,0x80122738
  log.start = sb.logstart;
80103398:	a3 34 27 12 80       	mov    %eax,0x80122734
  struct buf *buf = bread(log.dev, log.start);
8010339d:	5a                   	pop    %edx
8010339e:	50                   	push   %eax
8010339f:	53                   	push   %ebx
801033a0:	e8 2b cd ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
801033a5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
801033a8:	83 c4 10             	add    $0x10,%esp
801033ab:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
801033ad:	89 1d 48 27 12 80    	mov    %ebx,0x80122748
  for (i = 0; i < log.lh.n; i++) {
801033b3:	7e 1c                	jle    801033d1 <initlog+0x71>
801033b5:	c1 e3 02             	shl    $0x2,%ebx
801033b8:	31 d2                	xor    %edx,%edx
801033ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
801033c0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
801033c4:	83 c2 04             	add    $0x4,%edx
801033c7:	89 8a 48 27 12 80    	mov    %ecx,-0x7fedd8b8(%edx)
  for (i = 0; i < log.lh.n; i++) {
801033cd:	39 d3                	cmp    %edx,%ebx
801033cf:	75 ef                	jne    801033c0 <initlog+0x60>
  brelse(buf);
801033d1:	83 ec 0c             	sub    $0xc,%esp
801033d4:	50                   	push   %eax
801033d5:	e8 06 ce ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801033da:	e8 81 fe ff ff       	call   80103260 <install_trans>
  log.lh.n = 0;
801033df:	c7 05 48 27 12 80 00 	movl   $0x0,0x80122748
801033e6:	00 00 00 
  write_head(); // clear the log
801033e9:	e8 12 ff ff ff       	call   80103300 <write_head>
}
801033ee:	83 c4 10             	add    $0x10,%esp
801033f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801033f4:	c9                   	leave  
801033f5:	c3                   	ret    
801033f6:	8d 76 00             	lea    0x0(%esi),%esi
801033f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103400 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103400:	55                   	push   %ebp
80103401:	89 e5                	mov    %esp,%ebp
80103403:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103406:	68 00 27 12 80       	push   $0x80122700
8010340b:	e8 d0 1a 00 00       	call   80104ee0 <acquire>
80103410:	83 c4 10             	add    $0x10,%esp
80103413:	eb 18                	jmp    8010342d <begin_op+0x2d>
80103415:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103418:	83 ec 08             	sub    $0x8,%esp
8010341b:	68 00 27 12 80       	push   $0x80122700
80103420:	68 00 27 12 80       	push   $0x80122700
80103425:	e8 f6 13 00 00       	call   80104820 <sleep>
8010342a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010342d:	a1 40 27 12 80       	mov    0x80122740,%eax
80103432:	85 c0                	test   %eax,%eax
80103434:	75 e2                	jne    80103418 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103436:	a1 3c 27 12 80       	mov    0x8012273c,%eax
8010343b:	8b 15 48 27 12 80    	mov    0x80122748,%edx
80103441:	83 c0 01             	add    $0x1,%eax
80103444:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103447:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010344a:	83 fa 1e             	cmp    $0x1e,%edx
8010344d:	7f c9                	jg     80103418 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010344f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103452:	a3 3c 27 12 80       	mov    %eax,0x8012273c
      release(&log.lock);
80103457:	68 00 27 12 80       	push   $0x80122700
8010345c:	e8 3f 1b 00 00       	call   80104fa0 <release>
      break;
    }
  }
}
80103461:	83 c4 10             	add    $0x10,%esp
80103464:	c9                   	leave  
80103465:	c3                   	ret    
80103466:	8d 76 00             	lea    0x0(%esi),%esi
80103469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103470 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103470:	55                   	push   %ebp
80103471:	89 e5                	mov    %esp,%ebp
80103473:	57                   	push   %edi
80103474:	56                   	push   %esi
80103475:	53                   	push   %ebx
80103476:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103479:	68 00 27 12 80       	push   $0x80122700
8010347e:	e8 5d 1a 00 00       	call   80104ee0 <acquire>
  log.outstanding -= 1;
80103483:	a1 3c 27 12 80       	mov    0x8012273c,%eax
  if(log.committing)
80103488:	8b 35 40 27 12 80    	mov    0x80122740,%esi
8010348e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103491:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80103494:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80103496:	89 1d 3c 27 12 80    	mov    %ebx,0x8012273c
  if(log.committing)
8010349c:	0f 85 1a 01 00 00    	jne    801035bc <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
801034a2:	85 db                	test   %ebx,%ebx
801034a4:	0f 85 ee 00 00 00    	jne    80103598 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801034aa:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
801034ad:	c7 05 40 27 12 80 01 	movl   $0x1,0x80122740
801034b4:	00 00 00 
  release(&log.lock);
801034b7:	68 00 27 12 80       	push   $0x80122700
801034bc:	e8 df 1a 00 00       	call   80104fa0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801034c1:	8b 0d 48 27 12 80    	mov    0x80122748,%ecx
801034c7:	83 c4 10             	add    $0x10,%esp
801034ca:	85 c9                	test   %ecx,%ecx
801034cc:	0f 8e 85 00 00 00    	jle    80103557 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801034d2:	a1 34 27 12 80       	mov    0x80122734,%eax
801034d7:	83 ec 08             	sub    $0x8,%esp
801034da:	01 d8                	add    %ebx,%eax
801034dc:	83 c0 01             	add    $0x1,%eax
801034df:	50                   	push   %eax
801034e0:	ff 35 44 27 12 80    	pushl  0x80122744
801034e6:	e8 e5 cb ff ff       	call   801000d0 <bread>
801034eb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801034ed:	58                   	pop    %eax
801034ee:	5a                   	pop    %edx
801034ef:	ff 34 9d 4c 27 12 80 	pushl  -0x7fedd8b4(,%ebx,4)
801034f6:	ff 35 44 27 12 80    	pushl  0x80122744
  for (tail = 0; tail < log.lh.n; tail++) {
801034fc:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801034ff:	e8 cc cb ff ff       	call   801000d0 <bread>
80103504:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103506:	8d 40 5c             	lea    0x5c(%eax),%eax
80103509:	83 c4 0c             	add    $0xc,%esp
8010350c:	68 00 02 00 00       	push   $0x200
80103511:	50                   	push   %eax
80103512:	8d 46 5c             	lea    0x5c(%esi),%eax
80103515:	50                   	push   %eax
80103516:	e8 85 1b 00 00       	call   801050a0 <memmove>
    bwrite(to);  // write the log
8010351b:	89 34 24             	mov    %esi,(%esp)
8010351e:	e8 7d cc ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103523:	89 3c 24             	mov    %edi,(%esp)
80103526:	e8 b5 cc ff ff       	call   801001e0 <brelse>
    brelse(to);
8010352b:	89 34 24             	mov    %esi,(%esp)
8010352e:	e8 ad cc ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103533:	83 c4 10             	add    $0x10,%esp
80103536:	3b 1d 48 27 12 80    	cmp    0x80122748,%ebx
8010353c:	7c 94                	jl     801034d2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010353e:	e8 bd fd ff ff       	call   80103300 <write_head>
    install_trans(); // Now install writes to home locations
80103543:	e8 18 fd ff ff       	call   80103260 <install_trans>
    log.lh.n = 0;
80103548:	c7 05 48 27 12 80 00 	movl   $0x0,0x80122748
8010354f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103552:	e8 a9 fd ff ff       	call   80103300 <write_head>
    acquire(&log.lock);
80103557:	83 ec 0c             	sub    $0xc,%esp
8010355a:	68 00 27 12 80       	push   $0x80122700
8010355f:	e8 7c 19 00 00       	call   80104ee0 <acquire>
    wakeup(&log);
80103564:	c7 04 24 00 27 12 80 	movl   $0x80122700,(%esp)
    log.committing = 0;
8010356b:	c7 05 40 27 12 80 00 	movl   $0x0,0x80122740
80103572:	00 00 00 
    wakeup(&log);
80103575:	e8 f6 14 00 00       	call   80104a70 <wakeup>
    release(&log.lock);
8010357a:	c7 04 24 00 27 12 80 	movl   $0x80122700,(%esp)
80103581:	e8 1a 1a 00 00       	call   80104fa0 <release>
80103586:	83 c4 10             	add    $0x10,%esp
}
80103589:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010358c:	5b                   	pop    %ebx
8010358d:	5e                   	pop    %esi
8010358e:	5f                   	pop    %edi
8010358f:	5d                   	pop    %ebp
80103590:	c3                   	ret    
80103591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103598:	83 ec 0c             	sub    $0xc,%esp
8010359b:	68 00 27 12 80       	push   $0x80122700
801035a0:	e8 cb 14 00 00       	call   80104a70 <wakeup>
  release(&log.lock);
801035a5:	c7 04 24 00 27 12 80 	movl   $0x80122700,(%esp)
801035ac:	e8 ef 19 00 00       	call   80104fa0 <release>
801035b1:	83 c4 10             	add    $0x10,%esp
}
801035b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035b7:	5b                   	pop    %ebx
801035b8:	5e                   	pop    %esi
801035b9:	5f                   	pop    %edi
801035ba:	5d                   	pop    %ebp
801035bb:	c3                   	ret    
    panic("log.committing");
801035bc:	83 ec 0c             	sub    $0xc,%esp
801035bf:	68 84 8b 10 80       	push   $0x80108b84
801035c4:	e8 c7 cd ff ff       	call   80100390 <panic>
801035c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801035d0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	53                   	push   %ebx
801035d4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801035d7:	8b 15 48 27 12 80    	mov    0x80122748,%edx
{
801035dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801035e0:	83 fa 1d             	cmp    $0x1d,%edx
801035e3:	0f 8f 9d 00 00 00    	jg     80103686 <log_write+0xb6>
801035e9:	a1 38 27 12 80       	mov    0x80122738,%eax
801035ee:	83 e8 01             	sub    $0x1,%eax
801035f1:	39 c2                	cmp    %eax,%edx
801035f3:	0f 8d 8d 00 00 00    	jge    80103686 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
801035f9:	a1 3c 27 12 80       	mov    0x8012273c,%eax
801035fe:	85 c0                	test   %eax,%eax
80103600:	0f 8e 8d 00 00 00    	jle    80103693 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103606:	83 ec 0c             	sub    $0xc,%esp
80103609:	68 00 27 12 80       	push   $0x80122700
8010360e:	e8 cd 18 00 00       	call   80104ee0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103613:	8b 0d 48 27 12 80    	mov    0x80122748,%ecx
80103619:	83 c4 10             	add    $0x10,%esp
8010361c:	83 f9 00             	cmp    $0x0,%ecx
8010361f:	7e 57                	jle    80103678 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103621:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103624:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103626:	3b 15 4c 27 12 80    	cmp    0x8012274c,%edx
8010362c:	75 0b                	jne    80103639 <log_write+0x69>
8010362e:	eb 38                	jmp    80103668 <log_write+0x98>
80103630:	39 14 85 4c 27 12 80 	cmp    %edx,-0x7fedd8b4(,%eax,4)
80103637:	74 2f                	je     80103668 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103639:	83 c0 01             	add    $0x1,%eax
8010363c:	39 c1                	cmp    %eax,%ecx
8010363e:	75 f0                	jne    80103630 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103640:	89 14 85 4c 27 12 80 	mov    %edx,-0x7fedd8b4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103647:	83 c0 01             	add    $0x1,%eax
8010364a:	a3 48 27 12 80       	mov    %eax,0x80122748
  b->flags |= B_DIRTY; // prevent eviction
8010364f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103652:	c7 45 08 00 27 12 80 	movl   $0x80122700,0x8(%ebp)
}
80103659:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010365c:	c9                   	leave  
  release(&log.lock);
8010365d:	e9 3e 19 00 00       	jmp    80104fa0 <release>
80103662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103668:	89 14 85 4c 27 12 80 	mov    %edx,-0x7fedd8b4(,%eax,4)
8010366f:	eb de                	jmp    8010364f <log_write+0x7f>
80103671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103678:	8b 43 08             	mov    0x8(%ebx),%eax
8010367b:	a3 4c 27 12 80       	mov    %eax,0x8012274c
  if (i == log.lh.n)
80103680:	75 cd                	jne    8010364f <log_write+0x7f>
80103682:	31 c0                	xor    %eax,%eax
80103684:	eb c1                	jmp    80103647 <log_write+0x77>
    panic("too big a transaction");
80103686:	83 ec 0c             	sub    $0xc,%esp
80103689:	68 93 8b 10 80       	push   $0x80108b93
8010368e:	e8 fd cc ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103693:	83 ec 0c             	sub    $0xc,%esp
80103696:	68 a9 8b 10 80       	push   $0x80108ba9
8010369b:	e8 f0 cc ff ff       	call   80100390 <panic>

801036a0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	53                   	push   %ebx
801036a4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801036a7:	e8 f4 09 00 00       	call   801040a0 <cpuid>
801036ac:	89 c3                	mov    %eax,%ebx
801036ae:	e8 ed 09 00 00       	call   801040a0 <cpuid>
801036b3:	83 ec 04             	sub    $0x4,%esp
801036b6:	53                   	push   %ebx
801036b7:	50                   	push   %eax
801036b8:	68 c4 8b 10 80       	push   $0x80108bc4
801036bd:	e8 9e cf ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
801036c2:	e8 f9 2b 00 00       	call   801062c0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801036c7:	e8 44 09 00 00       	call   80104010 <mycpu>
801036cc:	89 c2                	mov    %eax,%edx
  asm volatile("lock; xchgl %0, %1" :
801036ce:	b8 01 00 00 00       	mov    $0x1,%eax
801036d3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801036da:	e8 51 0e 00 00       	call   80104530 <scheduler>
801036df:	90                   	nop

801036e0 <mpenter>:
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801036e6:	e8 b5 41 00 00       	call   801078a0 <switchkvm>
  seginit();
801036eb:	e8 00 41 00 00       	call   801077f0 <seginit>
  lapicinit();
801036f0:	e8 9b f7 ff ff       	call   80102e90 <lapicinit>
  mpmain();
801036f5:	e8 a6 ff ff ff       	call   801036a0 <mpmain>
801036fa:	66 90                	xchg   %ax,%ax
801036fc:	66 90                	xchg   %ax,%ax
801036fe:	66 90                	xchg   %ax,%ax

80103700 <main>:
{
80103700:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103704:	83 e4 f0             	and    $0xfffffff0,%esp
80103707:	ff 71 fc             	pushl  -0x4(%ecx)
8010370a:	55                   	push   %ebp
8010370b:	89 e5                	mov    %esp,%ebp
8010370d:	53                   	push   %ebx
8010370e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010370f:	83 ec 08             	sub    $0x8,%esp
80103712:	68 00 00 40 80       	push   $0x80400000
80103717:	68 28 2a 13 80       	push   $0x80132a28
8010371c:	e8 0f f5 ff ff       	call   80102c30 <kinit1>
  kvmalloc();      // kernel page table
80103721:	e8 8a 46 00 00       	call   80107db0 <kvmalloc>
  mpinit();        // detect other processors
80103726:	e8 75 01 00 00       	call   801038a0 <mpinit>
  lapicinit();     // interrupt controller
8010372b:	e8 60 f7 ff ff       	call   80102e90 <lapicinit>
  init_cow();
80103730:	e8 bb f3 ff ff       	call   80102af0 <init_cow>
  seginit();       // segment descriptors
80103735:	e8 b6 40 00 00       	call   801077f0 <seginit>
  picinit();       // disable pic
8010373a:	e8 41 03 00 00       	call   80103a80 <picinit>
  ioapicinit();    // another interrupt controller
8010373f:	e8 bc f2 ff ff       	call   80102a00 <ioapicinit>
  consoleinit();   // console hardware
80103744:	e8 77 d2 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103749:	e8 22 30 00 00       	call   80106770 <uartinit>
  pinit();         // process table
8010374e:	e8 9d 08 00 00       	call   80103ff0 <pinit>
  tvinit();        // trap vectors
80103753:	e8 e8 2a 00 00       	call   80106240 <tvinit>
  binit();         // buffer cache
80103758:	e8 e3 c8 ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010375d:	e8 4e da ff ff       	call   801011b0 <fileinit>
  ideinit();       // disk 
80103762:	e8 79 f0 ff ff       	call   801027e0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103767:	83 c4 0c             	add    $0xc,%esp
8010376a:	68 8a 00 00 00       	push   $0x8a
8010376f:	68 8c c4 10 80       	push   $0x8010c48c
80103774:	68 00 70 00 80       	push   $0x80007000
80103779:	e8 22 19 00 00       	call   801050a0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010377e:	69 05 80 2d 12 80 b0 	imul   $0xb0,0x80122d80,%eax
80103785:	00 00 00 
80103788:	83 c4 10             	add    $0x10,%esp
8010378b:	05 00 28 12 80       	add    $0x80122800,%eax
80103790:	3d 00 28 12 80       	cmp    $0x80122800,%eax
80103795:	76 6c                	jbe    80103803 <main+0x103>
80103797:	bb 00 28 12 80       	mov    $0x80122800,%ebx
8010379c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
801037a0:	e8 6b 08 00 00       	call   80104010 <mycpu>
801037a5:	39 d8                	cmp    %ebx,%eax
801037a7:	74 41                	je     801037ea <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = cow_kalloc();
801037a9:	e8 e2 3b 00 00       	call   80107390 <cow_kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801037ae:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
801037b3:	c7 05 f8 6f 00 80 e0 	movl   $0x801036e0,0x80006ff8
801037ba:	36 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801037bd:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
801037c4:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801037c7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
801037cc:	0f b6 03             	movzbl (%ebx),%eax
801037cf:	83 ec 08             	sub    $0x8,%esp
801037d2:	68 00 70 00 00       	push   $0x7000
801037d7:	50                   	push   %eax
801037d8:	e8 03 f8 ff ff       	call   80102fe0 <lapicstartap>
801037dd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801037e0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801037e6:	85 c0                	test   %eax,%eax
801037e8:	74 f6                	je     801037e0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
801037ea:	69 05 80 2d 12 80 b0 	imul   $0xb0,0x80122d80,%eax
801037f1:	00 00 00 
801037f4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801037fa:	05 00 28 12 80       	add    $0x80122800,%eax
801037ff:	39 c3                	cmp    %eax,%ebx
80103801:	72 9d                	jb     801037a0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103803:	83 ec 08             	sub    $0x8,%esp
80103806:	68 00 00 00 8e       	push   $0x8e000000
8010380b:	68 00 00 40 80       	push   $0x80400000
80103810:	e8 9b f4 ff ff       	call   80102cb0 <kinit2>
  userinit();      // first user process
80103815:	e8 d6 08 00 00       	call   801040f0 <userinit>
  mpmain();        // finish this processor's setup
8010381a:	e8 81 fe ff ff       	call   801036a0 <mpmain>
8010381f:	90                   	nop

80103820 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	57                   	push   %edi
80103824:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103825:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010382b:	53                   	push   %ebx
  e = addr+len;
8010382c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010382f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103832:	39 de                	cmp    %ebx,%esi
80103834:	72 10                	jb     80103846 <mpsearch1+0x26>
80103836:	eb 50                	jmp    80103888 <mpsearch1+0x68>
80103838:	90                   	nop
80103839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103840:	39 fb                	cmp    %edi,%ebx
80103842:	89 fe                	mov    %edi,%esi
80103844:	76 42                	jbe    80103888 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103846:	83 ec 04             	sub    $0x4,%esp
80103849:	8d 7e 10             	lea    0x10(%esi),%edi
8010384c:	6a 04                	push   $0x4
8010384e:	68 d8 8b 10 80       	push   $0x80108bd8
80103853:	56                   	push   %esi
80103854:	e8 e7 17 00 00       	call   80105040 <memcmp>
80103859:	83 c4 10             	add    $0x10,%esp
8010385c:	85 c0                	test   %eax,%eax
8010385e:	75 e0                	jne    80103840 <mpsearch1+0x20>
80103860:	89 f1                	mov    %esi,%ecx
80103862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103868:	0f b6 11             	movzbl (%ecx),%edx
8010386b:	83 c1 01             	add    $0x1,%ecx
8010386e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103870:	39 f9                	cmp    %edi,%ecx
80103872:	75 f4                	jne    80103868 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103874:	84 c0                	test   %al,%al
80103876:	75 c8                	jne    80103840 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010387b:	89 f0                	mov    %esi,%eax
8010387d:	5b                   	pop    %ebx
8010387e:	5e                   	pop    %esi
8010387f:	5f                   	pop    %edi
80103880:	5d                   	pop    %ebp
80103881:	c3                   	ret    
80103882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103888:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010388b:	31 f6                	xor    %esi,%esi
}
8010388d:	89 f0                	mov    %esi,%eax
8010388f:	5b                   	pop    %ebx
80103890:	5e                   	pop    %esi
80103891:	5f                   	pop    %edi
80103892:	5d                   	pop    %ebp
80103893:	c3                   	ret    
80103894:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010389a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801038a0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	57                   	push   %edi
801038a4:	56                   	push   %esi
801038a5:	53                   	push   %ebx
801038a6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801038a9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801038b0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801038b7:	c1 e0 08             	shl    $0x8,%eax
801038ba:	09 d0                	or     %edx,%eax
801038bc:	c1 e0 04             	shl    $0x4,%eax
801038bf:	85 c0                	test   %eax,%eax
801038c1:	75 1b                	jne    801038de <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801038c3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801038ca:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801038d1:	c1 e0 08             	shl    $0x8,%eax
801038d4:	09 d0                	or     %edx,%eax
801038d6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801038d9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801038de:	ba 00 04 00 00       	mov    $0x400,%edx
801038e3:	e8 38 ff ff ff       	call   80103820 <mpsearch1>
801038e8:	85 c0                	test   %eax,%eax
801038ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801038ed:	0f 84 3d 01 00 00    	je     80103a30 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801038f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801038f6:	8b 58 04             	mov    0x4(%eax),%ebx
801038f9:	85 db                	test   %ebx,%ebx
801038fb:	0f 84 4f 01 00 00    	je     80103a50 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103901:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103907:	83 ec 04             	sub    $0x4,%esp
8010390a:	6a 04                	push   $0x4
8010390c:	68 f5 8b 10 80       	push   $0x80108bf5
80103911:	56                   	push   %esi
80103912:	e8 29 17 00 00       	call   80105040 <memcmp>
80103917:	83 c4 10             	add    $0x10,%esp
8010391a:	85 c0                	test   %eax,%eax
8010391c:	0f 85 2e 01 00 00    	jne    80103a50 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103922:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103929:	3c 01                	cmp    $0x1,%al
8010392b:	0f 95 c2             	setne  %dl
8010392e:	3c 04                	cmp    $0x4,%al
80103930:	0f 95 c0             	setne  %al
80103933:	20 c2                	and    %al,%dl
80103935:	0f 85 15 01 00 00    	jne    80103a50 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010393b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103942:	66 85 ff             	test   %di,%di
80103945:	74 1a                	je     80103961 <mpinit+0xc1>
80103947:	89 f0                	mov    %esi,%eax
80103949:	01 f7                	add    %esi,%edi
  sum = 0;
8010394b:	31 d2                	xor    %edx,%edx
8010394d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103950:	0f b6 08             	movzbl (%eax),%ecx
80103953:	83 c0 01             	add    $0x1,%eax
80103956:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103958:	39 c7                	cmp    %eax,%edi
8010395a:	75 f4                	jne    80103950 <mpinit+0xb0>
8010395c:	84 d2                	test   %dl,%dl
8010395e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103961:	85 f6                	test   %esi,%esi
80103963:	0f 84 e7 00 00 00    	je     80103a50 <mpinit+0x1b0>
80103969:	84 d2                	test   %dl,%dl
8010396b:	0f 85 df 00 00 00    	jne    80103a50 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103971:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103977:	a3 f4 26 12 80       	mov    %eax,0x801226f4
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010397c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103983:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103989:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010398e:	01 d6                	add    %edx,%esi
80103990:	39 c6                	cmp    %eax,%esi
80103992:	76 23                	jbe    801039b7 <mpinit+0x117>
    switch(*p){
80103994:	0f b6 10             	movzbl (%eax),%edx
80103997:	80 fa 04             	cmp    $0x4,%dl
8010399a:	0f 87 ca 00 00 00    	ja     80103a6a <mpinit+0x1ca>
801039a0:	ff 24 95 1c 8c 10 80 	jmp    *-0x7fef73e4(,%edx,4)
801039a7:	89 f6                	mov    %esi,%esi
801039a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801039b0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039b3:	39 c6                	cmp    %eax,%esi
801039b5:	77 dd                	ja     80103994 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801039b7:	85 db                	test   %ebx,%ebx
801039b9:	0f 84 9e 00 00 00    	je     80103a5d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801039bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801039c2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801039c6:	74 15                	je     801039dd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801039c8:	b8 70 00 00 00       	mov    $0x70,%eax
801039cd:	ba 22 00 00 00       	mov    $0x22,%edx
801039d2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801039d3:	ba 23 00 00 00       	mov    $0x23,%edx
801039d8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801039d9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801039dc:	ee                   	out    %al,(%dx)
  }
}
801039dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039e0:	5b                   	pop    %ebx
801039e1:	5e                   	pop    %esi
801039e2:	5f                   	pop    %edi
801039e3:	5d                   	pop    %ebp
801039e4:	c3                   	ret    
801039e5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801039e8:	8b 0d 80 2d 12 80    	mov    0x80122d80,%ecx
801039ee:	83 f9 07             	cmp    $0x7,%ecx
801039f1:	7f 19                	jg     80103a0c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801039f3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801039f7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801039fd:	83 c1 01             	add    $0x1,%ecx
80103a00:	89 0d 80 2d 12 80    	mov    %ecx,0x80122d80
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103a06:	88 97 00 28 12 80    	mov    %dl,-0x7fedd800(%edi)
      p += sizeof(struct mpproc);
80103a0c:	83 c0 14             	add    $0x14,%eax
      continue;
80103a0f:	e9 7c ff ff ff       	jmp    80103990 <mpinit+0xf0>
80103a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103a18:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
80103a1c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103a1f:	88 15 e0 27 12 80    	mov    %dl,0x801227e0
      continue;
80103a25:	e9 66 ff ff ff       	jmp    80103990 <mpinit+0xf0>
80103a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103a30:	ba 00 00 01 00       	mov    $0x10000,%edx
80103a35:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103a3a:	e8 e1 fd ff ff       	call   80103820 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103a3f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103a41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103a44:	0f 85 a9 fe ff ff    	jne    801038f3 <mpinit+0x53>
80103a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103a50:	83 ec 0c             	sub    $0xc,%esp
80103a53:	68 dd 8b 10 80       	push   $0x80108bdd
80103a58:	e8 33 c9 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103a5d:	83 ec 0c             	sub    $0xc,%esp
80103a60:	68 fc 8b 10 80       	push   $0x80108bfc
80103a65:	e8 26 c9 ff ff       	call   80100390 <panic>
      ismp = 0;
80103a6a:	31 db                	xor    %ebx,%ebx
80103a6c:	e9 26 ff ff ff       	jmp    80103997 <mpinit+0xf7>
80103a71:	66 90                	xchg   %ax,%ax
80103a73:	66 90                	xchg   %ax,%ax
80103a75:	66 90                	xchg   %ax,%ax
80103a77:	66 90                	xchg   %ax,%ax
80103a79:	66 90                	xchg   %ax,%ax
80103a7b:	66 90                	xchg   %ax,%ax
80103a7d:	66 90                	xchg   %ax,%ax
80103a7f:	90                   	nop

80103a80 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103a80:	55                   	push   %ebp
80103a81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a86:	ba 21 00 00 00       	mov    $0x21,%edx
80103a8b:	89 e5                	mov    %esp,%ebp
80103a8d:	ee                   	out    %al,(%dx)
80103a8e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103a93:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103a94:	5d                   	pop    %ebp
80103a95:	c3                   	ret    
80103a96:	66 90                	xchg   %ax,%ax
80103a98:	66 90                	xchg   %ax,%ax
80103a9a:	66 90                	xchg   %ax,%ax
80103a9c:	66 90                	xchg   %ax,%ax
80103a9e:	66 90                	xchg   %ax,%ax

80103aa0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	57                   	push   %edi
80103aa4:	56                   	push   %esi
80103aa5:	53                   	push   %ebx
80103aa6:	83 ec 0c             	sub    $0xc,%esp
80103aa9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103aac:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103aaf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103ab5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103abb:	e8 10 d7 ff ff       	call   801011d0 <filealloc>
80103ac0:	85 c0                	test   %eax,%eax
80103ac2:	89 03                	mov    %eax,(%ebx)
80103ac4:	74 22                	je     80103ae8 <pipealloc+0x48>
80103ac6:	e8 05 d7 ff ff       	call   801011d0 <filealloc>
80103acb:	85 c0                	test   %eax,%eax
80103acd:	89 06                	mov    %eax,(%esi)
80103acf:	74 3f                	je     80103b10 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)cow_kalloc()) == 0)
80103ad1:	e8 ba 38 00 00       	call   80107390 <cow_kalloc>
80103ad6:	85 c0                	test   %eax,%eax
80103ad8:	89 c7                	mov    %eax,%edi
80103ada:	75 54                	jne    80103b30 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    cow_kfree((char*)p);
  if(*f0)
80103adc:	8b 03                	mov    (%ebx),%eax
80103ade:	85 c0                	test   %eax,%eax
80103ae0:	75 34                	jne    80103b16 <pipealloc+0x76>
80103ae2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103ae8:	8b 06                	mov    (%esi),%eax
80103aea:	85 c0                	test   %eax,%eax
80103aec:	74 0c                	je     80103afa <pipealloc+0x5a>
    fileclose(*f1);
80103aee:	83 ec 0c             	sub    $0xc,%esp
80103af1:	50                   	push   %eax
80103af2:	e8 99 d7 ff ff       	call   80101290 <fileclose>
80103af7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103afa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103afd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103b02:	5b                   	pop    %ebx
80103b03:	5e                   	pop    %esi
80103b04:	5f                   	pop    %edi
80103b05:	5d                   	pop    %ebp
80103b06:	c3                   	ret    
80103b07:	89 f6                	mov    %esi,%esi
80103b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103b10:	8b 03                	mov    (%ebx),%eax
80103b12:	85 c0                	test   %eax,%eax
80103b14:	74 e4                	je     80103afa <pipealloc+0x5a>
    fileclose(*f0);
80103b16:	83 ec 0c             	sub    $0xc,%esp
80103b19:	50                   	push   %eax
80103b1a:	e8 71 d7 ff ff       	call   80101290 <fileclose>
  if(*f1)
80103b1f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103b21:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103b24:	85 c0                	test   %eax,%eax
80103b26:	75 c6                	jne    80103aee <pipealloc+0x4e>
80103b28:	eb d0                	jmp    80103afa <pipealloc+0x5a>
80103b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103b30:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103b33:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103b3a:	00 00 00 
  p->writeopen = 1;
80103b3d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103b44:	00 00 00 
  p->nwrite = 0;
80103b47:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103b4e:	00 00 00 
  p->nread = 0;
80103b51:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103b58:	00 00 00 
  initlock(&p->lock, "pipe");
80103b5b:	68 30 8c 10 80       	push   $0x80108c30
80103b60:	50                   	push   %eax
80103b61:	e8 3a 12 00 00       	call   80104da0 <initlock>
  (*f0)->type = FD_PIPE;
80103b66:	8b 03                	mov    (%ebx),%eax
  return 0;
80103b68:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103b6b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103b71:	8b 03                	mov    (%ebx),%eax
80103b73:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103b77:	8b 03                	mov    (%ebx),%eax
80103b79:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103b7d:	8b 03                	mov    (%ebx),%eax
80103b7f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103b82:	8b 06                	mov    (%esi),%eax
80103b84:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103b8a:	8b 06                	mov    (%esi),%eax
80103b8c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103b90:	8b 06                	mov    (%esi),%eax
80103b92:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103b96:	8b 06                	mov    (%esi),%eax
80103b98:	89 78 0c             	mov    %edi,0xc(%eax)
}
80103b9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103b9e:	31 c0                	xor    %eax,%eax
}
80103ba0:	5b                   	pop    %ebx
80103ba1:	5e                   	pop    %esi
80103ba2:	5f                   	pop    %edi
80103ba3:	5d                   	pop    %ebp
80103ba4:	c3                   	ret    
80103ba5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103bb0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103bb0:	55                   	push   %ebp
80103bb1:	89 e5                	mov    %esp,%ebp
80103bb3:	56                   	push   %esi
80103bb4:	53                   	push   %ebx
80103bb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103bb8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103bbb:	83 ec 0c             	sub    $0xc,%esp
80103bbe:	53                   	push   %ebx
80103bbf:	e8 1c 13 00 00       	call   80104ee0 <acquire>
  if(writable){
80103bc4:	83 c4 10             	add    $0x10,%esp
80103bc7:	85 f6                	test   %esi,%esi
80103bc9:	74 45                	je     80103c10 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103bcb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103bd1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103bd4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103bdb:	00 00 00 
    wakeup(&p->nread);
80103bde:	50                   	push   %eax
80103bdf:	e8 8c 0e 00 00       	call   80104a70 <wakeup>
80103be4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103be7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103bed:	85 d2                	test   %edx,%edx
80103bef:	75 0a                	jne    80103bfb <pipeclose+0x4b>
80103bf1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103bf7:	85 c0                	test   %eax,%eax
80103bf9:	74 35                	je     80103c30 <pipeclose+0x80>
    release(&p->lock);
    cow_kfree((char*)p);
  } else
    release(&p->lock);
80103bfb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103bfe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c01:	5b                   	pop    %ebx
80103c02:	5e                   	pop    %esi
80103c03:	5d                   	pop    %ebp
    release(&p->lock);
80103c04:	e9 97 13 00 00       	jmp    80104fa0 <release>
80103c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103c10:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103c16:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103c19:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103c20:	00 00 00 
    wakeup(&p->nwrite);
80103c23:	50                   	push   %eax
80103c24:	e8 47 0e 00 00       	call   80104a70 <wakeup>
80103c29:	83 c4 10             	add    $0x10,%esp
80103c2c:	eb b9                	jmp    80103be7 <pipeclose+0x37>
80103c2e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103c30:	83 ec 0c             	sub    $0xc,%esp
80103c33:	53                   	push   %ebx
80103c34:	e8 67 13 00 00       	call   80104fa0 <release>
    cow_kfree((char*)p);
80103c39:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103c3c:	83 c4 10             	add    $0x10,%esp
}
80103c3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c42:	5b                   	pop    %ebx
80103c43:	5e                   	pop    %esi
80103c44:	5d                   	pop    %ebp
    cow_kfree((char*)p);
80103c45:	e9 a6 36 00 00       	jmp    801072f0 <cow_kfree>
80103c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c50 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	57                   	push   %edi
80103c54:	56                   	push   %esi
80103c55:	53                   	push   %ebx
80103c56:	83 ec 28             	sub    $0x28,%esp
80103c59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103c5c:	53                   	push   %ebx
80103c5d:	e8 7e 12 00 00       	call   80104ee0 <acquire>
  for(i = 0; i < n; i++){
80103c62:	8b 45 10             	mov    0x10(%ebp),%eax
80103c65:	83 c4 10             	add    $0x10,%esp
80103c68:	85 c0                	test   %eax,%eax
80103c6a:	0f 8e c9 00 00 00    	jle    80103d39 <pipewrite+0xe9>
80103c70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103c73:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103c79:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103c7f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103c82:	03 4d 10             	add    0x10(%ebp),%ecx
80103c85:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c88:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103c8e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103c94:	39 d0                	cmp    %edx,%eax
80103c96:	75 71                	jne    80103d09 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103c98:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103c9e:	85 c0                	test   %eax,%eax
80103ca0:	74 4e                	je     80103cf0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ca2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103ca8:	eb 3a                	jmp    80103ce4 <pipewrite+0x94>
80103caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103cb0:	83 ec 0c             	sub    $0xc,%esp
80103cb3:	57                   	push   %edi
80103cb4:	e8 b7 0d 00 00       	call   80104a70 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103cb9:	5a                   	pop    %edx
80103cba:	59                   	pop    %ecx
80103cbb:	53                   	push   %ebx
80103cbc:	56                   	push   %esi
80103cbd:	e8 5e 0b 00 00       	call   80104820 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103cc2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103cc8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103cce:	83 c4 10             	add    $0x10,%esp
80103cd1:	05 00 02 00 00       	add    $0x200,%eax
80103cd6:	39 c2                	cmp    %eax,%edx
80103cd8:	75 36                	jne    80103d10 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103cda:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103ce0:	85 c0                	test   %eax,%eax
80103ce2:	74 0c                	je     80103cf0 <pipewrite+0xa0>
80103ce4:	e8 d7 03 00 00       	call   801040c0 <myproc>
80103ce9:	8b 40 24             	mov    0x24(%eax),%eax
80103cec:	85 c0                	test   %eax,%eax
80103cee:	74 c0                	je     80103cb0 <pipewrite+0x60>
        release(&p->lock);
80103cf0:	83 ec 0c             	sub    $0xc,%esp
80103cf3:	53                   	push   %ebx
80103cf4:	e8 a7 12 00 00       	call   80104fa0 <release>
        return -1;
80103cf9:	83 c4 10             	add    $0x10,%esp
80103cfc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103d01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d04:	5b                   	pop    %ebx
80103d05:	5e                   	pop    %esi
80103d06:	5f                   	pop    %edi
80103d07:	5d                   	pop    %ebp
80103d08:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103d09:	89 c2                	mov    %eax,%edx
80103d0b:	90                   	nop
80103d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103d10:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103d13:	8d 42 01             	lea    0x1(%edx),%eax
80103d16:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103d1c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103d22:	83 c6 01             	add    $0x1,%esi
80103d25:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103d29:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103d2c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103d2f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103d33:	0f 85 4f ff ff ff    	jne    80103c88 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103d39:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103d3f:	83 ec 0c             	sub    $0xc,%esp
80103d42:	50                   	push   %eax
80103d43:	e8 28 0d 00 00       	call   80104a70 <wakeup>
  release(&p->lock);
80103d48:	89 1c 24             	mov    %ebx,(%esp)
80103d4b:	e8 50 12 00 00       	call   80104fa0 <release>
  return n;
80103d50:	83 c4 10             	add    $0x10,%esp
80103d53:	8b 45 10             	mov    0x10(%ebp),%eax
80103d56:	eb a9                	jmp    80103d01 <pipewrite+0xb1>
80103d58:	90                   	nop
80103d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d60 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	57                   	push   %edi
80103d64:	56                   	push   %esi
80103d65:	53                   	push   %ebx
80103d66:	83 ec 18             	sub    $0x18,%esp
80103d69:	8b 75 08             	mov    0x8(%ebp),%esi
80103d6c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103d6f:	56                   	push   %esi
80103d70:	e8 6b 11 00 00       	call   80104ee0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103d75:	83 c4 10             	add    $0x10,%esp
80103d78:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103d7e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103d84:	75 6a                	jne    80103df0 <piperead+0x90>
80103d86:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
80103d8c:	85 db                	test   %ebx,%ebx
80103d8e:	0f 84 c4 00 00 00    	je     80103e58 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103d94:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103d9a:	eb 2d                	jmp    80103dc9 <piperead+0x69>
80103d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103da0:	83 ec 08             	sub    $0x8,%esp
80103da3:	56                   	push   %esi
80103da4:	53                   	push   %ebx
80103da5:	e8 76 0a 00 00       	call   80104820 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103daa:	83 c4 10             	add    $0x10,%esp
80103dad:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103db3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103db9:	75 35                	jne    80103df0 <piperead+0x90>
80103dbb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103dc1:	85 d2                	test   %edx,%edx
80103dc3:	0f 84 8f 00 00 00    	je     80103e58 <piperead+0xf8>
    if(myproc()->killed){
80103dc9:	e8 f2 02 00 00       	call   801040c0 <myproc>
80103dce:	8b 48 24             	mov    0x24(%eax),%ecx
80103dd1:	85 c9                	test   %ecx,%ecx
80103dd3:	74 cb                	je     80103da0 <piperead+0x40>
      release(&p->lock);
80103dd5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103dd8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103ddd:	56                   	push   %esi
80103dde:	e8 bd 11 00 00       	call   80104fa0 <release>
      return -1;
80103de3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103de6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103de9:	89 d8                	mov    %ebx,%eax
80103deb:	5b                   	pop    %ebx
80103dec:	5e                   	pop    %esi
80103ded:	5f                   	pop    %edi
80103dee:	5d                   	pop    %ebp
80103def:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103df0:	8b 45 10             	mov    0x10(%ebp),%eax
80103df3:	85 c0                	test   %eax,%eax
80103df5:	7e 61                	jle    80103e58 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103df7:	31 db                	xor    %ebx,%ebx
80103df9:	eb 13                	jmp    80103e0e <piperead+0xae>
80103dfb:	90                   	nop
80103dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e00:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103e06:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103e0c:	74 1f                	je     80103e2d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103e0e:	8d 41 01             	lea    0x1(%ecx),%eax
80103e11:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103e17:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103e1d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103e22:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103e25:	83 c3 01             	add    $0x1,%ebx
80103e28:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103e2b:	75 d3                	jne    80103e00 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103e2d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103e33:	83 ec 0c             	sub    $0xc,%esp
80103e36:	50                   	push   %eax
80103e37:	e8 34 0c 00 00       	call   80104a70 <wakeup>
  release(&p->lock);
80103e3c:	89 34 24             	mov    %esi,(%esp)
80103e3f:	e8 5c 11 00 00       	call   80104fa0 <release>
  return i;
80103e44:	83 c4 10             	add    $0x10,%esp
}
80103e47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e4a:	89 d8                	mov    %ebx,%eax
80103e4c:	5b                   	pop    %ebx
80103e4d:	5e                   	pop    %esi
80103e4e:	5f                   	pop    %edi
80103e4f:	5d                   	pop    %ebp
80103e50:	c3                   	ret    
80103e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e58:	31 db                	xor    %ebx,%ebx
80103e5a:	eb d1                	jmp    80103e2d <piperead+0xcd>
80103e5c:	66 90                	xchg   %ax,%ax
80103e5e:	66 90                	xchg   %ax,%ax

80103e60 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e64:	bb d4 2d 12 80       	mov    $0x80122dd4,%ebx
{
80103e69:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103e6c:	68 a0 2d 12 80       	push   $0x80122da0
80103e71:	e8 6a 10 00 00       	call   80104ee0 <acquire>
80103e76:	83 c4 10             	add    $0x10,%esp
80103e79:	eb 17                	jmp    80103e92 <allocproc+0x32>
80103e7b:	90                   	nop
80103e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e80:	81 c3 d0 03 00 00    	add    $0x3d0,%ebx
80103e86:	81 fb d4 21 13 80    	cmp    $0x801321d4,%ebx
80103e8c:	0f 83 de 00 00 00    	jae    80103f70 <allocproc+0x110>
    if(p->state == UNUSED)
80103e92:	8b 43 0c             	mov    0xc(%ebx),%eax
80103e95:	85 c0                	test   %eax,%eax
80103e97:	75 e7                	jne    80103e80 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103e99:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
80103e9e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103ea1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103ea8:	8d 50 01             	lea    0x1(%eax),%edx
80103eab:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103eae:	68 a0 2d 12 80       	push   $0x80122da0
  p->pid = nextpid++;
80103eb3:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80103eb9:	e8 e2 10 00 00       	call   80104fa0 <release>

  // Allocate kernel stack.
  if((p->kstack = cow_kalloc()) == 0){
80103ebe:	e8 cd 34 00 00       	call   80107390 <cow_kalloc>
80103ec3:	83 c4 10             	add    $0x10,%esp
80103ec6:	85 c0                	test   %eax,%eax
80103ec8:	89 43 08             	mov    %eax,0x8(%ebx)
80103ecb:	0f 84 b8 00 00 00    	je     80103f89 <allocproc+0x129>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103ed1:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103ed7:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103eda:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103edf:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103ee2:	c7 40 14 31 62 10 80 	movl   $0x80106231,0x14(%eax)
  p->context = (struct context*)sp;
80103ee9:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103eec:	6a 14                	push   $0x14
80103eee:	6a 00                	push   $0x0
80103ef0:	50                   	push   %eax
80103ef1:	e8 fa 10 00 00       	call   80104ff0 <memset>
  p->context->eip = (uint)forkret;
80103ef6:	8b 43 1c             	mov    0x1c(%ebx),%eax
#if SELECTION!=NONE
 if (p->pid > 2){
80103ef9:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103efc:	c7 40 10 a0 3f 10 80 	movl   $0x80103fa0,0x10(%eax)
 if (p->pid > 2){
80103f03:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80103f07:	7f 07                	jg     80103f10 <allocproc+0xb0>
      #endif
    }
 }
 #endif
  return p;
}
80103f09:	89 d8                	mov    %ebx,%eax
80103f0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f0e:	c9                   	leave  
80103f0f:	c3                   	ret    
    createSwapFile(p);
80103f10:	83 ec 0c             	sub    $0xc,%esp
    p->num_of_actual_pages_in_mem = 0;
80103f13:	c7 83 c4 03 00 00 00 	movl   $0x0,0x3c4(%ebx)
80103f1a:	00 00 00 
    p->num_of_pagefaults_occurs = 0;
80103f1d:	c7 83 c8 03 00 00 00 	movl   $0x0,0x3c8(%ebx)
80103f24:	00 00 00 
    p->num_of_pageOut_occured = 0;
80103f27:	c7 83 cc 03 00 00 00 	movl   $0x0,0x3cc(%ebx)
80103f2e:	00 00 00 
    p->num_of_pages_in_swap_file = 0;
80103f31:	c7 83 c0 03 00 00 00 	movl   $0x0,0x3c0(%ebx)
80103f38:	00 00 00 
    createSwapFile(p);
80103f3b:	53                   	push   %ebx
80103f3c:	e8 bf e6 ff ff       	call   80102600 <createSwapFile>
80103f41:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80103f47:	8d 93 00 02 00 00    	lea    0x200(%ebx),%edx
80103f4d:	83 c4 10             	add    $0x10,%esp
      p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
80103f50:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80103f56:	c7 80 80 01 00 00 01 	movl   $0x1,0x180(%eax)
80103f5d:	00 00 00 
80103f60:	83 c0 18             	add    $0x18,%eax
    for (int i = 0; i < 16; i++){
80103f63:	39 c2                	cmp    %eax,%edx
80103f65:	75 e9                	jne    80103f50 <allocproc+0xf0>
}
80103f67:	89 d8                	mov    %ebx,%eax
80103f69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f6c:	c9                   	leave  
80103f6d:	c3                   	ret    
80103f6e:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
80103f70:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103f73:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103f75:	68 a0 2d 12 80       	push   $0x80122da0
80103f7a:	e8 21 10 00 00       	call   80104fa0 <release>
}
80103f7f:	89 d8                	mov    %ebx,%eax
  return 0;
80103f81:	83 c4 10             	add    $0x10,%esp
}
80103f84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f87:	c9                   	leave  
80103f88:	c3                   	ret    
    p->state = UNUSED;
80103f89:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103f90:	31 db                	xor    %ebx,%ebx
80103f92:	e9 72 ff ff ff       	jmp    80103f09 <allocproc+0xa9>
80103f97:	89 f6                	mov    %esi,%esi
80103f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fa0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103fa6:	68 a0 2d 12 80       	push   $0x80122da0
80103fab:	e8 f0 0f 00 00       	call   80104fa0 <release>

  if (first) {
80103fb0:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80103fb5:	83 c4 10             	add    $0x10,%esp
80103fb8:	85 c0                	test   %eax,%eax
80103fba:	75 04                	jne    80103fc0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103fbc:	c9                   	leave  
80103fbd:	c3                   	ret    
80103fbe:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103fc0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103fc3:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80103fca:	00 00 00 
    iinit(ROOTDEV);
80103fcd:	6a 01                	push   $0x1
80103fcf:	e8 fc d8 ff ff       	call   801018d0 <iinit>
    initlog(ROOTDEV);
80103fd4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103fdb:	e8 80 f3 ff ff       	call   80103360 <initlog>
80103fe0:	83 c4 10             	add    $0x10,%esp
}
80103fe3:	c9                   	leave  
80103fe4:	c3                   	ret    
80103fe5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ff0 <pinit>:
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103ff6:	68 35 8c 10 80       	push   $0x80108c35
80103ffb:	68 a0 2d 12 80       	push   $0x80122da0
80104000:	e8 9b 0d 00 00       	call   80104da0 <initlock>
}
80104005:	83 c4 10             	add    $0x10,%esp
80104008:	c9                   	leave  
80104009:	c3                   	ret    
8010400a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104010 <mycpu>:
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	56                   	push   %esi
80104014:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104015:	9c                   	pushf  
80104016:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104017:	f6 c4 02             	test   $0x2,%ah
8010401a:	75 6b                	jne    80104087 <mycpu+0x77>
  apicid = lapicid();
8010401c:	e8 6f ef ff ff       	call   80102f90 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104021:	8b 35 80 2d 12 80    	mov    0x80122d80,%esi
80104027:	85 f6                	test   %esi,%esi
80104029:	7e 42                	jle    8010406d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010402b:	0f b6 15 00 28 12 80 	movzbl 0x80122800,%edx
80104032:	39 d0                	cmp    %edx,%eax
80104034:	74 30                	je     80104066 <mycpu+0x56>
80104036:	b9 b0 28 12 80       	mov    $0x801228b0,%ecx
  for (i = 0; i < ncpu; ++i) {
8010403b:	31 d2                	xor    %edx,%edx
8010403d:	8d 76 00             	lea    0x0(%esi),%esi
80104040:	83 c2 01             	add    $0x1,%edx
80104043:	39 f2                	cmp    %esi,%edx
80104045:	74 26                	je     8010406d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80104047:	0f b6 19             	movzbl (%ecx),%ebx
8010404a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80104050:	39 c3                	cmp    %eax,%ebx
80104052:	75 ec                	jne    80104040 <mycpu+0x30>
80104054:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010405a:	05 00 28 12 80       	add    $0x80122800,%eax
}
8010405f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104062:	5b                   	pop    %ebx
80104063:	5e                   	pop    %esi
80104064:	5d                   	pop    %ebp
80104065:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80104066:	b8 00 28 12 80       	mov    $0x80122800,%eax
      return &cpus[i];
8010406b:	eb f2                	jmp    8010405f <mycpu+0x4f>
  cprintf("The unknown apicid is %d\n", apicid);
8010406d:	83 ec 08             	sub    $0x8,%esp
80104070:	50                   	push   %eax
80104071:	68 3c 8c 10 80       	push   $0x80108c3c
80104076:	e8 e5 c5 ff ff       	call   80100660 <cprintf>
  panic("unknown apicid\n");
8010407b:	c7 04 24 56 8c 10 80 	movl   $0x80108c56,(%esp)
80104082:	e8 09 c3 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80104087:	83 ec 0c             	sub    $0xc,%esp
8010408a:	68 28 8d 10 80       	push   $0x80108d28
8010408f:	e8 fc c2 ff ff       	call   80100390 <panic>
80104094:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010409a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801040a0 <cpuid>:
cpuid() {
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801040a6:	e8 65 ff ff ff       	call   80104010 <mycpu>
801040ab:	2d 00 28 12 80       	sub    $0x80122800,%eax
}
801040b0:	c9                   	leave  
  return mycpu()-cpus;
801040b1:	c1 f8 04             	sar    $0x4,%eax
801040b4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801040ba:	c3                   	ret    
801040bb:	90                   	nop
801040bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801040c0 <myproc>:
myproc(void) {
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	53                   	push   %ebx
801040c4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801040c7:	e8 44 0d 00 00       	call   80104e10 <pushcli>
  c = mycpu();
801040cc:	e8 3f ff ff ff       	call   80104010 <mycpu>
  p = c->proc;
801040d1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040d7:	e8 74 0d 00 00       	call   80104e50 <popcli>
}
801040dc:	83 c4 04             	add    $0x4,%esp
801040df:	89 d8                	mov    %ebx,%eax
801040e1:	5b                   	pop    %ebx
801040e2:	5d                   	pop    %ebp
801040e3:	c3                   	ret    
801040e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801040ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801040f0 <userinit>:
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	53                   	push   %ebx
801040f4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801040f7:	e8 64 fd ff ff       	call   80103e60 <allocproc>
801040fc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801040fe:	a3 b8 c5 10 80       	mov    %eax,0x8010c5b8
  if((p->pgdir = setupkvm()) == 0)
80104103:	e8 28 3c 00 00       	call   80107d30 <setupkvm>
80104108:	85 c0                	test   %eax,%eax
8010410a:	89 43 04             	mov    %eax,0x4(%ebx)
8010410d:	0f 84 bd 00 00 00    	je     801041d0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104113:	83 ec 04             	sub    $0x4,%esp
80104116:	68 2c 00 00 00       	push   $0x2c
8010411b:	68 60 c4 10 80       	push   $0x8010c460
80104120:	50                   	push   %eax
80104121:	e8 aa 38 00 00       	call   801079d0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104126:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104129:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010412f:	6a 4c                	push   $0x4c
80104131:	6a 00                	push   $0x0
80104133:	ff 73 18             	pushl  0x18(%ebx)
80104136:	e8 b5 0e 00 00       	call   80104ff0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010413b:	8b 43 18             	mov    0x18(%ebx),%eax
8010413e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104143:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104148:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010414b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010414f:	8b 43 18             	mov    0x18(%ebx),%eax
80104152:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104156:	8b 43 18             	mov    0x18(%ebx),%eax
80104159:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010415d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104161:	8b 43 18             	mov    0x18(%ebx),%eax
80104164:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104168:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010416c:	8b 43 18             	mov    0x18(%ebx),%eax
8010416f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104176:	8b 43 18             	mov    0x18(%ebx),%eax
80104179:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104180:	8b 43 18             	mov    0x18(%ebx),%eax
80104183:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010418a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010418d:	6a 10                	push   $0x10
8010418f:	68 7f 8c 10 80       	push   $0x80108c7f
80104194:	50                   	push   %eax
80104195:	e8 36 10 00 00       	call   801051d0 <safestrcpy>
  p->cwd = namei("/");
8010419a:	c7 04 24 88 8c 10 80 	movl   $0x80108c88,(%esp)
801041a1:	e8 8a e1 ff ff       	call   80102330 <namei>
801041a6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801041a9:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
801041b0:	e8 2b 0d 00 00       	call   80104ee0 <acquire>
  p->state = RUNNABLE;
801041b5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801041bc:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
801041c3:	e8 d8 0d 00 00       	call   80104fa0 <release>
}
801041c8:	83 c4 10             	add    $0x10,%esp
801041cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041ce:	c9                   	leave  
801041cf:	c3                   	ret    
    panic("userinit: out of memory?");
801041d0:	83 ec 0c             	sub    $0xc,%esp
801041d3:	68 66 8c 10 80       	push   $0x80108c66
801041d8:	e8 b3 c1 ff ff       	call   80100390 <panic>
801041dd:	8d 76 00             	lea    0x0(%esi),%esi

801041e0 <growproc>:
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	56                   	push   %esi
801041e4:	53                   	push   %ebx
801041e5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801041e8:	e8 23 0c 00 00       	call   80104e10 <pushcli>
  c = mycpu();
801041ed:	e8 1e fe ff ff       	call   80104010 <mycpu>
  p = c->proc;
801041f2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041f8:	e8 53 0c 00 00       	call   80104e50 <popcli>
  if(n > 0){
801041fd:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80104200:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104202:	7f 1c                	jg     80104220 <growproc+0x40>
  } else if(n < 0){
80104204:	75 3a                	jne    80104240 <growproc+0x60>
  switchuvm(curproc);
80104206:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80104209:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010420b:	53                   	push   %ebx
8010420c:	e8 af 36 00 00       	call   801078c0 <switchuvm>
  return 0;
80104211:	83 c4 10             	add    $0x10,%esp
80104214:	31 c0                	xor    %eax,%eax
}
80104216:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104219:	5b                   	pop    %ebx
8010421a:	5e                   	pop    %esi
8010421b:	5d                   	pop    %ebp
8010421c:	c3                   	ret    
8010421d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104220:	83 ec 04             	sub    $0x4,%esp
80104223:	01 c6                	add    %eax,%esi
80104225:	56                   	push   %esi
80104226:	50                   	push   %eax
80104227:	ff 73 04             	pushl  0x4(%ebx)
8010422a:	e8 71 3f 00 00       	call   801081a0 <allocuvm>
8010422f:	83 c4 10             	add    $0x10,%esp
80104232:	85 c0                	test   %eax,%eax
80104234:	75 d0                	jne    80104206 <growproc+0x26>
      return -1;
80104236:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010423b:	eb d9                	jmp    80104216 <growproc+0x36>
8010423d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104240:	83 ec 04             	sub    $0x4,%esp
80104243:	01 c6                	add    %eax,%esi
80104245:	56                   	push   %esi
80104246:	50                   	push   %eax
80104247:	ff 73 04             	pushl  0x4(%ebx)
8010424a:	e8 c1 38 00 00       	call   80107b10 <deallocuvm>
8010424f:	83 c4 10             	add    $0x10,%esp
80104252:	85 c0                	test   %eax,%eax
80104254:	75 b0                	jne    80104206 <growproc+0x26>
80104256:	eb de                	jmp    80104236 <growproc+0x56>
80104258:	90                   	nop
80104259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104260 <sys_get_number_of_free_pages_impl>:
int sys_get_number_of_free_pages_impl(void){
80104260:	55                   	push   %ebp
  for (int i = 0; i < PHYSTOP / PGSIZE; i++){
80104261:	31 c0                	xor    %eax,%eax
  int count = 0;
80104263:	31 d2                	xor    %edx,%edx
int sys_get_number_of_free_pages_impl(void){
80104265:	89 e5                	mov    %esp,%ebp
80104267:	89 f6                	mov    %esi,%esi
80104269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      count++;
80104270:	80 b8 40 1f 11 80 01 	cmpb   $0x1,-0x7feee0c0(%eax)
80104277:	83 da ff             	sbb    $0xffffffff,%edx
  for (int i = 0; i < PHYSTOP / PGSIZE; i++){
8010427a:	83 c0 01             	add    $0x1,%eax
8010427d:	3d 00 e0 00 00       	cmp    $0xe000,%eax
80104282:	75 ec                	jne    80104270 <sys_get_number_of_free_pages_impl+0x10>
  return (PHYSTOP/PGSIZE) - count;
80104284:	29 d0                	sub    %edx,%eax
}
80104286:	5d                   	pop    %ebp
80104287:	c3                   	ret    
80104288:	90                   	nop
80104289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104290 <fork>:
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	57                   	push   %edi
80104294:	56                   	push   %esi
80104295:	53                   	push   %ebx
80104296:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104299:	e8 72 0b 00 00       	call   80104e10 <pushcli>
  c = mycpu();
8010429e:	e8 6d fd ff ff       	call   80104010 <mycpu>
  p = c->proc;
801042a3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042a9:	e8 a2 0b 00 00       	call   80104e50 <popcli>
  if((np = allocproc()) == 0){
801042ae:	e8 ad fb ff ff       	call   80103e60 <allocproc>
801042b3:	85 c0                	test   %eax,%eax
801042b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801042b8:	0f 84 31 02 00 00    	je     801044ef <fork+0x25f>
  if((np->pgdir = cow_copyuvm(curproc->pgdir, curproc->sz)) == 0){ // (np->pid > 2 ? cow_copyuvm : copyuvm)
801042be:	83 ec 08             	sub    $0x8,%esp
801042c1:	ff 33                	pushl  (%ebx)
801042c3:	ff 73 04             	pushl  0x4(%ebx)
801042c6:	e8 35 3b 00 00       	call   80107e00 <cow_copyuvm>
801042cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801042ce:	83 c4 10             	add    $0x10,%esp
801042d1:	85 c0                	test   %eax,%eax
801042d3:	89 42 04             	mov    %eax,0x4(%edx)
801042d6:	0f 84 1f 02 00 00    	je     801044fb <fork+0x26b>
  np->sz = curproc->sz;
801042dc:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
801042de:	8b 7a 18             	mov    0x18(%edx),%edi
801042e1:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->parent = curproc;
801042e6:	89 5a 14             	mov    %ebx,0x14(%edx)
  np->sz = curproc->sz;
801042e9:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
801042eb:	8b 73 18             	mov    0x18(%ebx),%esi
801042ee:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801042f0:	31 f6                	xor    %esi,%esi
801042f2:	89 d7                	mov    %edx,%edi
  np->tf->eax = 0;
801042f4:	8b 42 18             	mov    0x18(%edx),%eax
801042f7:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801042fe:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[i])
80104300:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104304:	85 c0                	test   %eax,%eax
80104306:	74 10                	je     80104318 <fork+0x88>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104308:	83 ec 0c             	sub    $0xc,%esp
8010430b:	50                   	push   %eax
8010430c:	e8 2f cf ff ff       	call   80101240 <filedup>
80104311:	83 c4 10             	add    $0x10,%esp
80104314:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104318:	83 c6 01             	add    $0x1,%esi
8010431b:	83 fe 10             	cmp    $0x10,%esi
8010431e:	75 e0                	jne    80104300 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104320:	83 ec 0c             	sub    $0xc,%esp
80104323:	ff 73 68             	pushl  0x68(%ebx)
80104326:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80104329:	e8 72 d7 ff ff       	call   80101aa0 <idup>
8010432e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104331:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104334:	89 42 68             	mov    %eax,0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104337:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010433a:	6a 10                	push   $0x10
8010433c:	50                   	push   %eax
8010433d:	8d 42 6c             	lea    0x6c(%edx),%eax
80104340:	50                   	push   %eax
80104341:	e8 8a 0e 00 00       	call   801051d0 <safestrcpy>
  pid = np->pid;
80104346:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  if (curproc->pid > 2 && np->pid > 2){
80104349:	83 c4 10             	add    $0x10,%esp
8010434c:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
  pid = np->pid;
80104350:	8b 42 10             	mov    0x10(%edx),%eax
80104353:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (curproc->pid > 2 && np->pid > 2){
80104356:	7e 05                	jle    8010435d <fork+0xcd>
80104358:	83 f8 02             	cmp    $0x2,%eax
8010435b:	7f 3b                	jg     80104398 <fork+0x108>
  acquire(&ptable.lock);
8010435d:	83 ec 0c             	sub    $0xc,%esp
80104360:	89 55 e0             	mov    %edx,-0x20(%ebp)
80104363:	68 a0 2d 12 80       	push   $0x80122da0
80104368:	e8 73 0b 00 00       	call   80104ee0 <acquire>
  np->state = RUNNABLE;
8010436d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104370:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  release(&ptable.lock);
80104377:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
8010437e:	e8 1d 0c 00 00       	call   80104fa0 <release>
  return pid;
80104383:	83 c4 10             	add    $0x10,%esp
}
80104386:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104389:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010438c:	5b                   	pop    %ebx
8010438d:	5e                   	pop    %esi
8010438e:	5f                   	pop    %edi
8010438f:	5d                   	pop    %ebp
80104390:	c3                   	ret    
80104391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104398:	8d 83 e8 01 00 00    	lea    0x1e8(%ebx),%eax
    int last_not_free_in_file = MAX_PYSC_PAGES - 1;
8010439e:	b9 0f 00 00 00       	mov    $0xf,%ecx
801043a3:	eb 12                	jmp    801043b7 <fork+0x127>
801043a5:	8d 76 00             	lea    0x0(%esi),%esi
    while (last_not_free_in_file >= 0 && curproc->swapped_out_pages[last_not_free_in_file].is_free){ last_not_free_in_file--; }
801043a8:	83 e9 01             	sub    $0x1,%ecx
801043ab:	83 e8 18             	sub    $0x18,%eax
801043ae:	83 f9 ff             	cmp    $0xffffffff,%ecx
801043b1:	0f 84 26 01 00 00    	je     801044dd <fork+0x24d>
801043b7:	8b 30                	mov    (%eax),%esi
801043b9:	85 f6                	test   %esi,%esi
801043bb:	75 eb                	jne    801043a8 <fork+0x118>
801043bd:	89 55 d8             	mov    %edx,-0x28(%ebp)
801043c0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    void* pg_buffer = cow_kalloc();
801043c3:	e8 c8 2f 00 00       	call   80107390 <cow_kalloc>
801043c8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801043cb:	8b 55 d8             	mov    -0x28(%ebp),%edx
801043ce:	89 c7                	mov    %eax,%edi
801043d0:	89 5d e0             	mov    %ebx,-0x20(%ebp)
801043d3:	89 f3                	mov    %esi,%ebx
801043d5:	c1 e1 0c             	shl    $0xc,%ecx
801043d8:	89 d6                	mov    %edx,%esi
801043da:	8d 81 00 10 00 00    	lea    0x1000(%ecx),%eax
801043e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
801043e3:	90                   	nop
801043e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      readFromSwapFile(curproc, pg_buffer, i, PGSIZE);
801043e8:	68 00 10 00 00       	push   $0x1000
801043ed:	53                   	push   %ebx
801043ee:	57                   	push   %edi
801043ef:	ff 75 e0             	pushl  -0x20(%ebp)
801043f2:	e8 d9 e2 ff ff       	call   801026d0 <readFromSwapFile>
      writeToSwapFile(np, pg_buffer, i, PGSIZE);
801043f7:	68 00 10 00 00       	push   $0x1000
801043fc:	53                   	push   %ebx
    for (int i = 0; i < last_not_free_in_file * PGSIZE; i += PGSIZE){
801043fd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      writeToSwapFile(np, pg_buffer, i, PGSIZE);
80104403:	57                   	push   %edi
80104404:	56                   	push   %esi
80104405:	e8 96 e2 ff ff       	call   801026a0 <writeToSwapFile>
    for (int i = 0; i < last_not_free_in_file * PGSIZE; i += PGSIZE){
8010440a:	83 c4 20             	add    $0x20,%esp
8010440d:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80104410:	75 d6                	jne    801043e8 <fork+0x158>
80104412:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80104415:	89 f2                	mov    %esi,%edx
    cow_kfree(pg_buffer);
80104417:	83 ec 0c             	sub    $0xc,%esp
8010441a:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010441d:	57                   	push   %edi
8010441e:	e8 cd 2e 00 00       	call   801072f0 <cow_kfree>
80104423:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104426:	83 c4 10             	add    $0x10,%esp
80104429:	b8 80 00 00 00       	mov    $0x80,%eax
8010442e:	66 90                	xchg   %ax,%ax
      np->ram_pages[i] = curproc->ram_pages[i];
80104430:	8b 8c 03 80 01 00 00 	mov    0x180(%ebx,%eax,1),%ecx
80104437:	89 8c 02 80 01 00 00 	mov    %ecx,0x180(%edx,%eax,1)
8010443e:	8b 8c 03 84 01 00 00 	mov    0x184(%ebx,%eax,1),%ecx
80104445:	89 8c 02 84 01 00 00 	mov    %ecx,0x184(%edx,%eax,1)
8010444c:	8b 8c 03 88 01 00 00 	mov    0x188(%ebx,%eax,1),%ecx
80104453:	89 8c 02 88 01 00 00 	mov    %ecx,0x188(%edx,%eax,1)
8010445a:	8b 8c 03 8c 01 00 00 	mov    0x18c(%ebx,%eax,1),%ecx
80104461:	89 8c 02 8c 01 00 00 	mov    %ecx,0x18c(%edx,%eax,1)
80104468:	8b 8c 03 90 01 00 00 	mov    0x190(%ebx,%eax,1),%ecx
8010446f:	89 8c 02 90 01 00 00 	mov    %ecx,0x190(%edx,%eax,1)
80104476:	8b 8c 03 94 01 00 00 	mov    0x194(%ebx,%eax,1),%ecx
8010447d:	89 8c 02 94 01 00 00 	mov    %ecx,0x194(%edx,%eax,1)
      np->swapped_out_pages[i] = curproc->swapped_out_pages[i];
80104484:	8b 0c 03             	mov    (%ebx,%eax,1),%ecx
80104487:	89 0c 02             	mov    %ecx,(%edx,%eax,1)
8010448a:	8b 4c 03 04          	mov    0x4(%ebx,%eax,1),%ecx
8010448e:	89 4c 02 04          	mov    %ecx,0x4(%edx,%eax,1)
80104492:	8b 4c 03 08          	mov    0x8(%ebx,%eax,1),%ecx
80104496:	89 4c 02 08          	mov    %ecx,0x8(%edx,%eax,1)
8010449a:	8b 4c 03 0c          	mov    0xc(%ebx,%eax,1),%ecx
8010449e:	89 4c 02 0c          	mov    %ecx,0xc(%edx,%eax,1)
801044a2:	8b 4c 03 10          	mov    0x10(%ebx,%eax,1),%ecx
801044a6:	89 4c 02 10          	mov    %ecx,0x10(%edx,%eax,1)
801044aa:	8b 4c 03 14          	mov    0x14(%ebx,%eax,1),%ecx
801044ae:	89 4c 02 14          	mov    %ecx,0x14(%edx,%eax,1)
801044b2:	83 c0 18             	add    $0x18,%eax
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
801044b5:	3d 00 02 00 00       	cmp    $0x200,%eax
801044ba:	0f 85 70 ff ff ff    	jne    80104430 <fork+0x1a0>
    np->num_of_actual_pages_in_mem = curproc->num_of_actual_pages_in_mem;
801044c0:	8b 83 c4 03 00 00    	mov    0x3c4(%ebx),%eax
801044c6:	89 82 c4 03 00 00    	mov    %eax,0x3c4(%edx)
    np->num_of_pages_in_swap_file = curproc->num_of_pages_in_swap_file;
801044cc:	8b 83 c0 03 00 00    	mov    0x3c0(%ebx),%eax
801044d2:	89 82 c0 03 00 00    	mov    %eax,0x3c0(%edx)
801044d8:	e9 80 fe ff ff       	jmp    8010435d <fork+0xcd>
801044dd:	89 55 e0             	mov    %edx,-0x20(%ebp)
    void* pg_buffer = cow_kalloc();
801044e0:	e8 ab 2e 00 00       	call   80107390 <cow_kalloc>
801044e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
801044e8:	89 c7                	mov    %eax,%edi
801044ea:	e9 28 ff ff ff       	jmp    80104417 <fork+0x187>
    return -1;
801044ef:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
801044f6:	e9 8b fe ff ff       	jmp    80104386 <fork+0xf6>
    cow_kfree(np->kstack);
801044fb:	83 ec 0c             	sub    $0xc,%esp
801044fe:	ff 72 08             	pushl  0x8(%edx)
80104501:	e8 ea 2d 00 00       	call   801072f0 <cow_kfree>
    np->kstack = 0;
80104506:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    return -1;
80104509:	83 c4 10             	add    $0x10,%esp
8010450c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
    np->kstack = 0;
80104513:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    np->state = UNUSED;
8010451a:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    return -1;
80104521:	e9 60 fe ff ff       	jmp    80104386 <fork+0xf6>
80104526:	8d 76 00             	lea    0x0(%esi),%esi
80104529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104530 <scheduler>:
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	57                   	push   %edi
80104534:	56                   	push   %esi
80104535:	53                   	push   %ebx
80104536:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104539:	e8 d2 fa ff ff       	call   80104010 <mycpu>
8010453e:	8d 78 04             	lea    0x4(%eax),%edi
80104541:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104543:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010454a:	00 00 00 
8010454d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104550:	fb                   	sti    
    acquire(&ptable.lock);
80104551:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104554:	bb d4 2d 12 80       	mov    $0x80122dd4,%ebx
    acquire(&ptable.lock);
80104559:	68 a0 2d 12 80       	push   $0x80122da0
8010455e:	e8 7d 09 00 00       	call   80104ee0 <acquire>
80104563:	83 c4 10             	add    $0x10,%esp
80104566:	8d 76 00             	lea    0x0(%esi),%esi
80104569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80104570:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104574:	75 33                	jne    801045a9 <scheduler+0x79>
      switchuvm(p);
80104576:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104579:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010457f:	53                   	push   %ebx
80104580:	e8 3b 33 00 00       	call   801078c0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104585:	58                   	pop    %eax
80104586:	5a                   	pop    %edx
80104587:	ff 73 1c             	pushl  0x1c(%ebx)
8010458a:	57                   	push   %edi
      p->state = RUNNING;
8010458b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104592:	e8 94 0c 00 00       	call   8010522b <swtch>
      switchkvm();
80104597:	e8 04 33 00 00       	call   801078a0 <switchkvm>
      c->proc = 0;
8010459c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801045a3:	00 00 00 
801045a6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045a9:	81 c3 d0 03 00 00    	add    $0x3d0,%ebx
801045af:	81 fb d4 21 13 80    	cmp    $0x801321d4,%ebx
801045b5:	72 b9                	jb     80104570 <scheduler+0x40>
    release(&ptable.lock);
801045b7:	83 ec 0c             	sub    $0xc,%esp
801045ba:	68 a0 2d 12 80       	push   $0x80122da0
801045bf:	e8 dc 09 00 00       	call   80104fa0 <release>
    sti();
801045c4:	83 c4 10             	add    $0x10,%esp
801045c7:	eb 87                	jmp    80104550 <scheduler+0x20>
801045c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045d0 <sched>:
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	56                   	push   %esi
801045d4:	53                   	push   %ebx
  pushcli();
801045d5:	e8 36 08 00 00       	call   80104e10 <pushcli>
  c = mycpu();
801045da:	e8 31 fa ff ff       	call   80104010 <mycpu>
  p = c->proc;
801045df:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045e5:	e8 66 08 00 00       	call   80104e50 <popcli>
  if(!holding(&ptable.lock))
801045ea:	83 ec 0c             	sub    $0xc,%esp
801045ed:	68 a0 2d 12 80       	push   $0x80122da0
801045f2:	e8 b9 08 00 00       	call   80104eb0 <holding>
801045f7:	83 c4 10             	add    $0x10,%esp
801045fa:	85 c0                	test   %eax,%eax
801045fc:	74 4f                	je     8010464d <sched+0x7d>
  if(mycpu()->ncli != 1)
801045fe:	e8 0d fa ff ff       	call   80104010 <mycpu>
80104603:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010460a:	75 68                	jne    80104674 <sched+0xa4>
  if(p->state == RUNNING)
8010460c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104610:	74 55                	je     80104667 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104612:	9c                   	pushf  
80104613:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104614:	f6 c4 02             	test   $0x2,%ah
80104617:	75 41                	jne    8010465a <sched+0x8a>
  intena = mycpu()->intena;
80104619:	e8 f2 f9 ff ff       	call   80104010 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010461e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104621:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104627:	e8 e4 f9 ff ff       	call   80104010 <mycpu>
8010462c:	83 ec 08             	sub    $0x8,%esp
8010462f:	ff 70 04             	pushl  0x4(%eax)
80104632:	53                   	push   %ebx
80104633:	e8 f3 0b 00 00       	call   8010522b <swtch>
  mycpu()->intena = intena;
80104638:	e8 d3 f9 ff ff       	call   80104010 <mycpu>
}
8010463d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104640:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104646:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104649:	5b                   	pop    %ebx
8010464a:	5e                   	pop    %esi
8010464b:	5d                   	pop    %ebp
8010464c:	c3                   	ret    
    panic("sched ptable.lock");
8010464d:	83 ec 0c             	sub    $0xc,%esp
80104650:	68 8a 8c 10 80       	push   $0x80108c8a
80104655:	e8 36 bd ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010465a:	83 ec 0c             	sub    $0xc,%esp
8010465d:	68 b6 8c 10 80       	push   $0x80108cb6
80104662:	e8 29 bd ff ff       	call   80100390 <panic>
    panic("sched running");
80104667:	83 ec 0c             	sub    $0xc,%esp
8010466a:	68 a8 8c 10 80       	push   $0x80108ca8
8010466f:	e8 1c bd ff ff       	call   80100390 <panic>
    panic("sched locks");
80104674:	83 ec 0c             	sub    $0xc,%esp
80104677:	68 9c 8c 10 80       	push   $0x80108c9c
8010467c:	e8 0f bd ff ff       	call   80100390 <panic>
80104681:	eb 0d                	jmp    80104690 <exit>
80104683:	90                   	nop
80104684:	90                   	nop
80104685:	90                   	nop
80104686:	90                   	nop
80104687:	90                   	nop
80104688:	90                   	nop
80104689:	90                   	nop
8010468a:	90                   	nop
8010468b:	90                   	nop
8010468c:	90                   	nop
8010468d:	90                   	nop
8010468e:	90                   	nop
8010468f:	90                   	nop

80104690 <exit>:
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	57                   	push   %edi
80104694:	56                   	push   %esi
80104695:	53                   	push   %ebx
80104696:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104699:	e8 72 07 00 00       	call   80104e10 <pushcli>
  c = mycpu();
8010469e:	e8 6d f9 ff ff       	call   80104010 <mycpu>
  p = c->proc;
801046a3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046a9:	e8 a2 07 00 00       	call   80104e50 <popcli>
  if(curproc == initproc)
801046ae:	39 1d b8 c5 10 80    	cmp    %ebx,0x8010c5b8
801046b4:	8d 73 28             	lea    0x28(%ebx),%esi
801046b7:	8d 7b 68             	lea    0x68(%ebx),%edi
801046ba:	0f 84 01 01 00 00    	je     801047c1 <exit+0x131>
    if(curproc->ofile[fd]){
801046c0:	8b 06                	mov    (%esi),%eax
801046c2:	85 c0                	test   %eax,%eax
801046c4:	74 12                	je     801046d8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
801046c6:	83 ec 0c             	sub    $0xc,%esp
801046c9:	50                   	push   %eax
801046ca:	e8 c1 cb ff ff       	call   80101290 <fileclose>
      curproc->ofile[fd] = 0;
801046cf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801046d5:	83 c4 10             	add    $0x10,%esp
801046d8:	83 c6 04             	add    $0x4,%esi
  for(fd = 0; fd < NOFILE; fd++){
801046db:	39 fe                	cmp    %edi,%esi
801046dd:	75 e1                	jne    801046c0 <exit+0x30>
  begin_op();
801046df:	e8 1c ed ff ff       	call   80103400 <begin_op>
  iput(curproc->cwd);
801046e4:	83 ec 0c             	sub    $0xc,%esp
801046e7:	ff 73 68             	pushl  0x68(%ebx)
801046ea:	e8 11 d5 ff ff       	call   80101c00 <iput>
  end_op();
801046ef:	e8 7c ed ff ff       	call   80103470 <end_op>
  curproc->cwd = 0;
801046f4:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  removeSwapFile(curproc);
801046fb:	89 1c 24             	mov    %ebx,(%esp)
801046fe:	e8 fd dc ff ff       	call   80102400 <removeSwapFile>
  acquire(&ptable.lock);
80104703:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
8010470a:	e8 d1 07 00 00       	call   80104ee0 <acquire>
  wakeup1(curproc->parent);
8010470f:	8b 53 14             	mov    0x14(%ebx),%edx
80104712:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104715:	b8 d4 2d 12 80       	mov    $0x80122dd4,%eax
8010471a:	eb 10                	jmp    8010472c <exit+0x9c>
8010471c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104720:	05 d0 03 00 00       	add    $0x3d0,%eax
80104725:	3d d4 21 13 80       	cmp    $0x801321d4,%eax
8010472a:	73 1e                	jae    8010474a <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
8010472c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104730:	75 ee                	jne    80104720 <exit+0x90>
80104732:	3b 50 20             	cmp    0x20(%eax),%edx
80104735:	75 e9                	jne    80104720 <exit+0x90>
      p->state = RUNNABLE;
80104737:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010473e:	05 d0 03 00 00       	add    $0x3d0,%eax
80104743:	3d d4 21 13 80       	cmp    $0x801321d4,%eax
80104748:	72 e2                	jb     8010472c <exit+0x9c>
      p->parent = initproc;
8010474a:	8b 0d b8 c5 10 80    	mov    0x8010c5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104750:	ba d4 2d 12 80       	mov    $0x80122dd4,%edx
80104755:	eb 17                	jmp    8010476e <exit+0xde>
80104757:	89 f6                	mov    %esi,%esi
80104759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104760:	81 c2 d0 03 00 00    	add    $0x3d0,%edx
80104766:	81 fa d4 21 13 80    	cmp    $0x801321d4,%edx
8010476c:	73 3a                	jae    801047a8 <exit+0x118>
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
8010477c:	b8 d4 2d 12 80       	mov    $0x80122dd4,%eax
80104781:	eb 11                	jmp    80104794 <exit+0x104>
80104783:	90                   	nop
80104784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104788:	05 d0 03 00 00       	add    $0x3d0,%eax
8010478d:	3d d4 21 13 80       	cmp    $0x801321d4,%eax
80104792:	73 cc                	jae    80104760 <exit+0xd0>
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
801047b7:	68 d7 8c 10 80       	push   $0x80108cd7
801047bc:	e8 cf bb ff ff       	call   80100390 <panic>
    panic("init exiting");
801047c1:	83 ec 0c             	sub    $0xc,%esp
801047c4:	68 ca 8c 10 80       	push   $0x80108cca
801047c9:	e8 c2 bb ff ff       	call   80100390 <panic>
801047ce:	66 90                	xchg   %ax,%ax

801047d0 <yield>:
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	53                   	push   %ebx
801047d4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801047d7:	68 a0 2d 12 80       	push   $0x80122da0
801047dc:	e8 ff 06 00 00       	call   80104ee0 <acquire>
  pushcli();
801047e1:	e8 2a 06 00 00       	call   80104e10 <pushcli>
  c = mycpu();
801047e6:	e8 25 f8 ff ff       	call   80104010 <mycpu>
  p = c->proc;
801047eb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801047f1:	e8 5a 06 00 00       	call   80104e50 <popcli>
  myproc()->state = RUNNABLE;
801047f6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801047fd:	e8 ce fd ff ff       	call   801045d0 <sched>
  release(&ptable.lock);
80104802:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
80104809:	e8 92 07 00 00       	call   80104fa0 <release>
}
8010480e:	83 c4 10             	add    $0x10,%esp
80104811:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104814:	c9                   	leave  
80104815:	c3                   	ret    
80104816:	8d 76 00             	lea    0x0(%esi),%esi
80104819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104820 <sleep>:
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	57                   	push   %edi
80104824:	56                   	push   %esi
80104825:	53                   	push   %ebx
80104826:	83 ec 0c             	sub    $0xc,%esp
80104829:	8b 7d 08             	mov    0x8(%ebp),%edi
8010482c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010482f:	e8 dc 05 00 00       	call   80104e10 <pushcli>
  c = mycpu();
80104834:	e8 d7 f7 ff ff       	call   80104010 <mycpu>
  p = c->proc;
80104839:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010483f:	e8 0c 06 00 00       	call   80104e50 <popcli>
  if(p == 0)
80104844:	85 db                	test   %ebx,%ebx
80104846:	0f 84 87 00 00 00    	je     801048d3 <sleep+0xb3>
  if(lk == 0)
8010484c:	85 f6                	test   %esi,%esi
8010484e:	74 76                	je     801048c6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104850:	81 fe a0 2d 12 80    	cmp    $0x80122da0,%esi
80104856:	74 50                	je     801048a8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104858:	83 ec 0c             	sub    $0xc,%esp
8010485b:	68 a0 2d 12 80       	push   $0x80122da0
80104860:	e8 7b 06 00 00       	call   80104ee0 <acquire>
    release(lk);
80104865:	89 34 24             	mov    %esi,(%esp)
80104868:	e8 33 07 00 00       	call   80104fa0 <release>
  p->chan = chan;
8010486d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104870:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104877:	e8 54 fd ff ff       	call   801045d0 <sched>
  p->chan = 0;
8010487c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104883:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
8010488a:	e8 11 07 00 00       	call   80104fa0 <release>
    acquire(lk);
8010488f:	89 75 08             	mov    %esi,0x8(%ebp)
80104892:	83 c4 10             	add    $0x10,%esp
}
80104895:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104898:	5b                   	pop    %ebx
80104899:	5e                   	pop    %esi
8010489a:	5f                   	pop    %edi
8010489b:	5d                   	pop    %ebp
    acquire(lk);
8010489c:	e9 3f 06 00 00       	jmp    80104ee0 <acquire>
801048a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
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
801048c9:	68 e9 8c 10 80       	push   $0x80108ce9
801048ce:	e8 bd ba ff ff       	call   80100390 <panic>
    panic("sleep");
801048d3:	83 ec 0c             	sub    $0xc,%esp
801048d6:	68 e3 8c 10 80       	push   $0x80108ce3
801048db:	e8 b0 ba ff ff       	call   80100390 <panic>

801048e0 <wait>:
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	56                   	push   %esi
801048e4:	53                   	push   %ebx
  pushcli();
801048e5:	e8 26 05 00 00       	call   80104e10 <pushcli>
  c = mycpu();
801048ea:	e8 21 f7 ff ff       	call   80104010 <mycpu>
  p = c->proc;
801048ef:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801048f5:	e8 56 05 00 00       	call   80104e50 <popcli>
  acquire(&ptable.lock);
801048fa:	83 ec 0c             	sub    $0xc,%esp
801048fd:	68 a0 2d 12 80       	push   $0x80122da0
80104902:	e8 d9 05 00 00       	call   80104ee0 <acquire>
80104907:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010490a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010490c:	bb d4 2d 12 80       	mov    $0x80122dd4,%ebx
80104911:	eb 13                	jmp    80104926 <wait+0x46>
80104913:	90                   	nop
80104914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104918:	81 c3 d0 03 00 00    	add    $0x3d0,%ebx
8010491e:	81 fb d4 21 13 80    	cmp    $0x801321d4,%ebx
80104924:	73 1e                	jae    80104944 <wait+0x64>
      if(p->parent != curproc)
80104926:	39 73 14             	cmp    %esi,0x14(%ebx)
80104929:	75 ed                	jne    80104918 <wait+0x38>
      if(p->state == ZOMBIE){
8010492b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010492f:	74 3f                	je     80104970 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104931:	81 c3 d0 03 00 00    	add    $0x3d0,%ebx
      havekids = 1;
80104937:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010493c:	81 fb d4 21 13 80    	cmp    $0x801321d4,%ebx
80104942:	72 e2                	jb     80104926 <wait+0x46>
    if(!havekids || curproc->killed){
80104944:	85 c0                	test   %eax,%eax
80104946:	0f 84 01 01 00 00    	je     80104a4d <wait+0x16d>
8010494c:	8b 46 24             	mov    0x24(%esi),%eax
8010494f:	85 c0                	test   %eax,%eax
80104951:	0f 85 f6 00 00 00    	jne    80104a4d <wait+0x16d>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104957:	83 ec 08             	sub    $0x8,%esp
8010495a:	68 a0 2d 12 80       	push   $0x80122da0
8010495f:	56                   	push   %esi
80104960:	e8 bb fe ff ff       	call   80104820 <sleep>
    havekids = 0;
80104965:	83 c4 10             	add    $0x10,%esp
80104968:	eb a0                	jmp    8010490a <wait+0x2a>
8010496a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (p->pid > 2){
80104970:	8b 73 10             	mov    0x10(%ebx),%esi
80104973:	83 fe 02             	cmp    $0x2,%esi
80104976:	0f 8e 7e 00 00 00    	jle    801049fa <wait+0x11a>
8010497c:	8d 93 80 00 00 00    	lea    0x80(%ebx),%edx
80104982:	8d 8b 00 02 00 00    	lea    0x200(%ebx),%ecx
          p->num_of_pagefaults_occurs = 0;
80104988:	c7 83 c8 03 00 00 00 	movl   $0x0,0x3c8(%ebx)
8010498f:	00 00 00 
          p->num_of_actual_pages_in_mem = 0;
80104992:	c7 83 c4 03 00 00 00 	movl   $0x0,0x3c4(%ebx)
80104999:	00 00 00 
          p->num_of_pageOut_occured = 0;
8010499c:	c7 83 cc 03 00 00 00 	movl   $0x0,0x3cc(%ebx)
801049a3:	00 00 00 
          p->num_of_pages_in_swap_file = 0;
801049a6:	c7 83 c0 03 00 00 00 	movl   $0x0,0x3c0(%ebx)
801049ad:	00 00 00 
            p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
801049b0:	c7 02 01 00 00 00    	movl   $0x1,(%edx)
801049b6:	c7 82 80 01 00 00 01 	movl   $0x1,0x180(%edx)
801049bd:	00 00 00 
801049c0:	83 c2 18             	add    $0x18,%edx
            p->ram_pages[i].aging_counter = p->swapped_out_pages[i].aging_counter = 0;
801049c3:	c7 42 f0 00 00 00 00 	movl   $0x0,-0x10(%edx)
801049ca:	c7 82 70 01 00 00 00 	movl   $0x0,0x170(%edx)
801049d1:	00 00 00 
            p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
801049d4:	c7 42 ec 00 00 00 00 	movl   $0x0,-0x14(%edx)
801049db:	c7 82 6c 01 00 00 00 	movl   $0x0,0x16c(%edx)
801049e2:	00 00 00 
            p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
801049e5:	c7 42 f8 00 00 00 00 	movl   $0x0,-0x8(%edx)
801049ec:	c7 82 78 01 00 00 00 	movl   $0x0,0x178(%edx)
801049f3:	00 00 00 
          for (int i = 0; i < MAX_PYSC_PAGES; i++){
801049f6:	39 d1                	cmp    %edx,%ecx
801049f8:	75 b6                	jne    801049b0 <wait+0xd0>
        cow_kfree(p->kstack);
801049fa:	83 ec 0c             	sub    $0xc,%esp
801049fd:	ff 73 08             	pushl  0x8(%ebx)
80104a00:	e8 eb 28 00 00       	call   801072f0 <cow_kfree>
        freevm(p->pgdir);
80104a05:	5a                   	pop    %edx
80104a06:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104a09:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104a10:	e8 1b 32 00 00       	call   80107c30 <freevm>
        release(&ptable.lock);
80104a15:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
        p->pid = 0;
80104a1c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104a23:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104a2a:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104a2e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104a35:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104a3c:	e8 5f 05 00 00       	call   80104fa0 <release>
        return pid;
80104a41:	83 c4 10             	add    $0x10,%esp
}
80104a44:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a47:	89 f0                	mov    %esi,%eax
80104a49:	5b                   	pop    %ebx
80104a4a:	5e                   	pop    %esi
80104a4b:	5d                   	pop    %ebp
80104a4c:	c3                   	ret    
      release(&ptable.lock);
80104a4d:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104a50:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104a55:	68 a0 2d 12 80       	push   $0x80122da0
80104a5a:	e8 41 05 00 00       	call   80104fa0 <release>
      return -1;
80104a5f:	83 c4 10             	add    $0x10,%esp
80104a62:	eb e0                	jmp    80104a44 <wait+0x164>
80104a64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104a70 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	53                   	push   %ebx
80104a74:	83 ec 10             	sub    $0x10,%esp
80104a77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104a7a:	68 a0 2d 12 80       	push   $0x80122da0
80104a7f:	e8 5c 04 00 00       	call   80104ee0 <acquire>
80104a84:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a87:	b8 d4 2d 12 80       	mov    $0x80122dd4,%eax
80104a8c:	eb 0e                	jmp    80104a9c <wakeup+0x2c>
80104a8e:	66 90                	xchg   %ax,%ax
80104a90:	05 d0 03 00 00       	add    $0x3d0,%eax
80104a95:	3d d4 21 13 80       	cmp    $0x801321d4,%eax
80104a9a:	73 1e                	jae    80104aba <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
80104a9c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104aa0:	75 ee                	jne    80104a90 <wakeup+0x20>
80104aa2:	3b 58 20             	cmp    0x20(%eax),%ebx
80104aa5:	75 e9                	jne    80104a90 <wakeup+0x20>
      p->state = RUNNABLE;
80104aa7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104aae:	05 d0 03 00 00       	add    $0x3d0,%eax
80104ab3:	3d d4 21 13 80       	cmp    $0x801321d4,%eax
80104ab8:	72 e2                	jb     80104a9c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80104aba:	c7 45 08 a0 2d 12 80 	movl   $0x80122da0,0x8(%ebp)
}
80104ac1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ac4:	c9                   	leave  
  release(&ptable.lock);
80104ac5:	e9 d6 04 00 00       	jmp    80104fa0 <release>
80104aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ad0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	53                   	push   %ebx
80104ad4:	83 ec 10             	sub    $0x10,%esp
80104ad7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104ada:	68 a0 2d 12 80       	push   $0x80122da0
80104adf:	e8 fc 03 00 00       	call   80104ee0 <acquire>
80104ae4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ae7:	b8 d4 2d 12 80       	mov    $0x80122dd4,%eax
80104aec:	eb 0e                	jmp    80104afc <kill+0x2c>
80104aee:	66 90                	xchg   %ax,%ax
80104af0:	05 d0 03 00 00       	add    $0x3d0,%eax
80104af5:	3d d4 21 13 80       	cmp    $0x801321d4,%eax
80104afa:	73 34                	jae    80104b30 <kill+0x60>
    if(p->pid == pid){
80104afc:	39 58 10             	cmp    %ebx,0x10(%eax)
80104aff:	75 ef                	jne    80104af0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104b01:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104b05:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104b0c:	75 07                	jne    80104b15 <kill+0x45>
        p->state = RUNNABLE;
80104b0e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104b15:	83 ec 0c             	sub    $0xc,%esp
80104b18:	68 a0 2d 12 80       	push   $0x80122da0
80104b1d:	e8 7e 04 00 00       	call   80104fa0 <release>
      return 0;
80104b22:	83 c4 10             	add    $0x10,%esp
80104b25:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104b27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b2a:	c9                   	leave  
80104b2b:	c3                   	ret    
80104b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104b30:	83 ec 0c             	sub    $0xc,%esp
80104b33:	68 a0 2d 12 80       	push   $0x80122da0
80104b38:	e8 63 04 00 00       	call   80104fa0 <release>
  return -1;
80104b3d:	83 c4 10             	add    $0x10,%esp
80104b40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b48:	c9                   	leave  
80104b49:	c3                   	ret    
80104b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b50 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	57                   	push   %edi
80104b54:	56                   	push   %esi
80104b55:	53                   	push   %ebx
80104b56:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b59:	bb d4 2d 12 80       	mov    $0x80122dd4,%ebx
{
80104b5e:	83 ec 3c             	sub    $0x3c,%esp
80104b61:	eb 27                	jmp    80104b8a <procdump+0x3a>
80104b63:	90                   	nop
80104b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104b68:	83 ec 0c             	sub    $0xc,%esp
80104b6b:	68 d9 92 10 80       	push   $0x801092d9
80104b70:	e8 eb ba ff ff       	call   80100660 <cprintf>
80104b75:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b78:	81 c3 d0 03 00 00    	add    $0x3d0,%ebx
80104b7e:	81 fb d4 21 13 80    	cmp    $0x801321d4,%ebx
80104b84:	0f 83 a6 00 00 00    	jae    80104c30 <procdump+0xe0>
    if(p->state == UNUSED)
80104b8a:	8b 43 0c             	mov    0xc(%ebx),%eax
80104b8d:	85 c0                	test   %eax,%eax
80104b8f:	74 e7                	je     80104b78 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104b91:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104b94:	ba fa 8c 10 80       	mov    $0x80108cfa,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104b99:	77 11                	ja     80104bac <procdump+0x5c>
80104b9b:	8b 14 85 b0 8d 10 80 	mov    -0x7fef7250(,%eax,4),%edx
      state = "???";
80104ba2:	b8 fa 8c 10 80       	mov    $0x80108cfa,%eax
80104ba7:	85 d2                	test   %edx,%edx
80104ba9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s RAM: %d SWAP: %d PGFAULTS: %d SWAPED_OUT: %d %s", p->pid, state,  p->num_of_actual_pages_in_mem, p->num_of_pages_in_swap_file, p->num_of_pagefaults_occurs, p->num_of_pageOut_occured, p->name);
80104bac:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104baf:	50                   	push   %eax
80104bb0:	ff b3 cc 03 00 00    	pushl  0x3cc(%ebx)
80104bb6:	ff b3 c8 03 00 00    	pushl  0x3c8(%ebx)
80104bbc:	ff b3 c0 03 00 00    	pushl  0x3c0(%ebx)
80104bc2:	ff b3 c4 03 00 00    	pushl  0x3c4(%ebx)
80104bc8:	52                   	push   %edx
80104bc9:	ff 73 10             	pushl  0x10(%ebx)
80104bcc:	68 50 8d 10 80       	push   $0x80108d50
80104bd1:	e8 8a ba ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104bd6:	83 c4 20             	add    $0x20,%esp
80104bd9:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104bdd:	75 89                	jne    80104b68 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104bdf:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104be2:	83 ec 08             	sub    $0x8,%esp
80104be5:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104be8:	50                   	push   %eax
80104be9:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104bec:	8b 40 0c             	mov    0xc(%eax),%eax
80104bef:	83 c0 08             	add    $0x8,%eax
80104bf2:	50                   	push   %eax
80104bf3:	e8 c8 01 00 00       	call   80104dc0 <getcallerpcs>
80104bf8:	83 c4 10             	add    $0x10,%esp
80104bfb:	90                   	nop
80104bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104c00:	8b 17                	mov    (%edi),%edx
80104c02:	85 d2                	test   %edx,%edx
80104c04:	0f 84 5e ff ff ff    	je     80104b68 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104c0a:	83 ec 08             	sub    $0x8,%esp
80104c0d:	83 c7 04             	add    $0x4,%edi
80104c10:	52                   	push   %edx
80104c11:	68 c1 86 10 80       	push   $0x801086c1
80104c16:	e8 45 ba ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104c1b:	83 c4 10             	add    $0x10,%esp
80104c1e:	39 fe                	cmp    %edi,%esi
80104c20:	75 de                	jne    80104c00 <procdump+0xb0>
80104c22:	e9 41 ff ff ff       	jmp    80104b68 <procdump+0x18>
80104c27:	89 f6                	mov    %esi,%esi
80104c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int count = 0;
80104c30:	31 d2                	xor    %edx,%edx
  for (int i = 0; i < PHYSTOP / PGSIZE; i++){
80104c32:	31 c0                	xor    %eax,%eax
80104c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      count++;
80104c38:	80 b8 40 1f 11 80 01 	cmpb   $0x1,-0x7feee0c0(%eax)
80104c3f:	83 da ff             	sbb    $0xffffffff,%edx
  for (int i = 0; i < PHYSTOP / PGSIZE; i++){
80104c42:	83 c0 01             	add    $0x1,%eax
80104c45:	3d 00 e0 00 00       	cmp    $0xe000,%eax
80104c4a:	75 ec                	jne    80104c38 <procdump+0xe8>
  }
  #if SELECTION != NONE
  int currentFree = sys_get_number_of_free_pages_impl();
  int totalFree = PHYSTOP / PGSIZE; //(PHYSTOP-EXTMEM) / PGSIZE ;///verify
  cprintf("%d / %d free page frames in the system\n", currentFree, totalFree);
80104c4c:	83 ec 04             	sub    $0x4,%esp
  return (PHYSTOP/PGSIZE) - count;
80104c4f:	29 d0                	sub    %edx,%eax
  cprintf("%d / %d free page frames in the system\n", currentFree, totalFree);
80104c51:	68 00 e0 00 00       	push   $0xe000
80104c56:	50                   	push   %eax
80104c57:	68 88 8d 10 80       	push   $0x80108d88
80104c5c:	e8 ff b9 ff ff       	call   80100660 <cprintf>
  #endif
}
80104c61:	83 c4 10             	add    $0x10,%esp
80104c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c67:	5b                   	pop    %ebx
80104c68:	5e                   	pop    %esi
80104c69:	5f                   	pop    %edi
80104c6a:	5d                   	pop    %ebp
80104c6b:	c3                   	ret    
80104c6c:	66 90                	xchg   %ax,%ax
80104c6e:	66 90                	xchg   %ax,%ax

80104c70 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	53                   	push   %ebx
80104c74:	83 ec 0c             	sub    $0xc,%esp
80104c77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104c7a:	68 c8 8d 10 80       	push   $0x80108dc8
80104c7f:	8d 43 04             	lea    0x4(%ebx),%eax
80104c82:	50                   	push   %eax
80104c83:	e8 18 01 00 00       	call   80104da0 <initlock>
  lk->name = name;
80104c88:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104c8b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104c91:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104c94:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104c9b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104c9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ca1:	c9                   	leave  
80104ca2:	c3                   	ret    
80104ca3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cb0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	56                   	push   %esi
80104cb4:	53                   	push   %ebx
80104cb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104cb8:	83 ec 0c             	sub    $0xc,%esp
80104cbb:	8d 73 04             	lea    0x4(%ebx),%esi
80104cbe:	56                   	push   %esi
80104cbf:	e8 1c 02 00 00       	call   80104ee0 <acquire>
  while (lk->locked) {
80104cc4:	8b 13                	mov    (%ebx),%edx
80104cc6:	83 c4 10             	add    $0x10,%esp
80104cc9:	85 d2                	test   %edx,%edx
80104ccb:	74 16                	je     80104ce3 <acquiresleep+0x33>
80104ccd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104cd0:	83 ec 08             	sub    $0x8,%esp
80104cd3:	56                   	push   %esi
80104cd4:	53                   	push   %ebx
80104cd5:	e8 46 fb ff ff       	call   80104820 <sleep>
  while (lk->locked) {
80104cda:	8b 03                	mov    (%ebx),%eax
80104cdc:	83 c4 10             	add    $0x10,%esp
80104cdf:	85 c0                	test   %eax,%eax
80104ce1:	75 ed                	jne    80104cd0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104ce3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104ce9:	e8 d2 f3 ff ff       	call   801040c0 <myproc>
80104cee:	8b 40 10             	mov    0x10(%eax),%eax
80104cf1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104cf4:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104cf7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cfa:	5b                   	pop    %ebx
80104cfb:	5e                   	pop    %esi
80104cfc:	5d                   	pop    %ebp
  release(&lk->lk);
80104cfd:	e9 9e 02 00 00       	jmp    80104fa0 <release>
80104d02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d10 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	56                   	push   %esi
80104d14:	53                   	push   %ebx
80104d15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104d18:	83 ec 0c             	sub    $0xc,%esp
80104d1b:	8d 73 04             	lea    0x4(%ebx),%esi
80104d1e:	56                   	push   %esi
80104d1f:	e8 bc 01 00 00       	call   80104ee0 <acquire>
  lk->locked = 0;
80104d24:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104d2a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104d31:	89 1c 24             	mov    %ebx,(%esp)
80104d34:	e8 37 fd ff ff       	call   80104a70 <wakeup>
  release(&lk->lk);
80104d39:	89 75 08             	mov    %esi,0x8(%ebp)
80104d3c:	83 c4 10             	add    $0x10,%esp
}
80104d3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d42:	5b                   	pop    %ebx
80104d43:	5e                   	pop    %esi
80104d44:	5d                   	pop    %ebp
  release(&lk->lk);
80104d45:	e9 56 02 00 00       	jmp    80104fa0 <release>
80104d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d50 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	57                   	push   %edi
80104d54:	56                   	push   %esi
80104d55:	53                   	push   %ebx
80104d56:	31 ff                	xor    %edi,%edi
80104d58:	83 ec 18             	sub    $0x18,%esp
80104d5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104d5e:	8d 73 04             	lea    0x4(%ebx),%esi
80104d61:	56                   	push   %esi
80104d62:	e8 79 01 00 00       	call   80104ee0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104d67:	8b 03                	mov    (%ebx),%eax
80104d69:	83 c4 10             	add    $0x10,%esp
80104d6c:	85 c0                	test   %eax,%eax
80104d6e:	74 13                	je     80104d83 <holdingsleep+0x33>
80104d70:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104d73:	e8 48 f3 ff ff       	call   801040c0 <myproc>
80104d78:	39 58 10             	cmp    %ebx,0x10(%eax)
80104d7b:	0f 94 c0             	sete   %al
80104d7e:	0f b6 c0             	movzbl %al,%eax
80104d81:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104d83:	83 ec 0c             	sub    $0xc,%esp
80104d86:	56                   	push   %esi
80104d87:	e8 14 02 00 00       	call   80104fa0 <release>
  return r;
}
80104d8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d8f:	89 f8                	mov    %edi,%eax
80104d91:	5b                   	pop    %ebx
80104d92:	5e                   	pop    %esi
80104d93:	5f                   	pop    %edi
80104d94:	5d                   	pop    %ebp
80104d95:	c3                   	ret    
80104d96:	66 90                	xchg   %ax,%ax
80104d98:	66 90                	xchg   %ax,%ax
80104d9a:	66 90                	xchg   %ax,%ax
80104d9c:	66 90                	xchg   %ax,%ax
80104d9e:	66 90                	xchg   %ax,%ax

80104da0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104da6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104da9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104daf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104db2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104db9:	5d                   	pop    %ebp
80104dba:	c3                   	ret    
80104dbb:	90                   	nop
80104dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104dc0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104dc0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104dc1:	31 d2                	xor    %edx,%edx
{
80104dc3:	89 e5                	mov    %esp,%ebp
80104dc5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104dc6:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104dc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104dcc:	83 e8 08             	sub    $0x8,%eax
80104dcf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104dd0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104dd6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104ddc:	77 1a                	ja     80104df8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104dde:	8b 58 04             	mov    0x4(%eax),%ebx
80104de1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104de4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104de7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104de9:	83 fa 0a             	cmp    $0xa,%edx
80104dec:	75 e2                	jne    80104dd0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104dee:	5b                   	pop    %ebx
80104def:	5d                   	pop    %ebp
80104df0:	c3                   	ret    
80104df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104df8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104dfb:	83 c1 28             	add    $0x28,%ecx
80104dfe:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104e00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104e06:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104e09:	39 c1                	cmp    %eax,%ecx
80104e0b:	75 f3                	jne    80104e00 <getcallerpcs+0x40>
}
80104e0d:	5b                   	pop    %ebx
80104e0e:	5d                   	pop    %ebp
80104e0f:	c3                   	ret    

80104e10 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	53                   	push   %ebx
80104e14:	83 ec 04             	sub    $0x4,%esp
80104e17:	9c                   	pushf  
80104e18:	5b                   	pop    %ebx
  asm volatile("cli");
80104e19:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104e1a:	e8 f1 f1 ff ff       	call   80104010 <mycpu>
80104e1f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104e25:	85 c0                	test   %eax,%eax
80104e27:	75 11                	jne    80104e3a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104e29:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104e2f:	e8 dc f1 ff ff       	call   80104010 <mycpu>
80104e34:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104e3a:	e8 d1 f1 ff ff       	call   80104010 <mycpu>
80104e3f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104e46:	83 c4 04             	add    $0x4,%esp
80104e49:	5b                   	pop    %ebx
80104e4a:	5d                   	pop    %ebp
80104e4b:	c3                   	ret    
80104e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e50 <popcli>:

void
popcli(void)
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104e56:	9c                   	pushf  
80104e57:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104e58:	f6 c4 02             	test   $0x2,%ah
80104e5b:	75 35                	jne    80104e92 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104e5d:	e8 ae f1 ff ff       	call   80104010 <mycpu>
80104e62:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104e69:	78 34                	js     80104e9f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104e6b:	e8 a0 f1 ff ff       	call   80104010 <mycpu>
80104e70:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104e76:	85 d2                	test   %edx,%edx
80104e78:	74 06                	je     80104e80 <popcli+0x30>
    sti();
}
80104e7a:	c9                   	leave  
80104e7b:	c3                   	ret    
80104e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104e80:	e8 8b f1 ff ff       	call   80104010 <mycpu>
80104e85:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104e8b:	85 c0                	test   %eax,%eax
80104e8d:	74 eb                	je     80104e7a <popcli+0x2a>
  asm volatile("sti");
80104e8f:	fb                   	sti    
}
80104e90:	c9                   	leave  
80104e91:	c3                   	ret    
    panic("popcli - interruptible");
80104e92:	83 ec 0c             	sub    $0xc,%esp
80104e95:	68 d3 8d 10 80       	push   $0x80108dd3
80104e9a:	e8 f1 b4 ff ff       	call   80100390 <panic>
    panic("popcli");
80104e9f:	83 ec 0c             	sub    $0xc,%esp
80104ea2:	68 ea 8d 10 80       	push   $0x80108dea
80104ea7:	e8 e4 b4 ff ff       	call   80100390 <panic>
80104eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104eb0 <holding>:
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	56                   	push   %esi
80104eb4:	53                   	push   %ebx
80104eb5:	8b 75 08             	mov    0x8(%ebp),%esi
80104eb8:	31 db                	xor    %ebx,%ebx
  pushcli();
80104eba:	e8 51 ff ff ff       	call   80104e10 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104ebf:	8b 06                	mov    (%esi),%eax
80104ec1:	85 c0                	test   %eax,%eax
80104ec3:	74 10                	je     80104ed5 <holding+0x25>
80104ec5:	8b 5e 08             	mov    0x8(%esi),%ebx
80104ec8:	e8 43 f1 ff ff       	call   80104010 <mycpu>
80104ecd:	39 c3                	cmp    %eax,%ebx
80104ecf:	0f 94 c3             	sete   %bl
80104ed2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104ed5:	e8 76 ff ff ff       	call   80104e50 <popcli>
}
80104eda:	89 d8                	mov    %ebx,%eax
80104edc:	5b                   	pop    %ebx
80104edd:	5e                   	pop    %esi
80104ede:	5d                   	pop    %ebp
80104edf:	c3                   	ret    

80104ee0 <acquire>:
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	56                   	push   %esi
80104ee4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104ee5:	e8 26 ff ff ff       	call   80104e10 <pushcli>
  if(holding(lk))
80104eea:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104eed:	83 ec 0c             	sub    $0xc,%esp
80104ef0:	53                   	push   %ebx
80104ef1:	e8 ba ff ff ff       	call   80104eb0 <holding>
80104ef6:	83 c4 10             	add    $0x10,%esp
80104ef9:	85 c0                	test   %eax,%eax
80104efb:	0f 85 83 00 00 00    	jne    80104f84 <acquire+0xa4>
80104f01:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104f03:	ba 01 00 00 00       	mov    $0x1,%edx
80104f08:	eb 09                	jmp    80104f13 <acquire+0x33>
80104f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f10:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104f13:	89 d0                	mov    %edx,%eax
80104f15:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104f18:	85 c0                	test   %eax,%eax
80104f1a:	75 f4                	jne    80104f10 <acquire+0x30>
  __sync_synchronize();
80104f1c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104f21:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104f24:	e8 e7 f0 ff ff       	call   80104010 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104f29:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104f2c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104f2f:	89 e8                	mov    %ebp,%eax
80104f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104f38:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104f3e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104f44:	77 1a                	ja     80104f60 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104f46:	8b 48 04             	mov    0x4(%eax),%ecx
80104f49:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104f4c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104f4f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104f51:	83 fe 0a             	cmp    $0xa,%esi
80104f54:	75 e2                	jne    80104f38 <acquire+0x58>
}
80104f56:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f59:	5b                   	pop    %ebx
80104f5a:	5e                   	pop    %esi
80104f5b:	5d                   	pop    %ebp
80104f5c:	c3                   	ret    
80104f5d:	8d 76 00             	lea    0x0(%esi),%esi
80104f60:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104f63:	83 c2 28             	add    $0x28,%edx
80104f66:	8d 76 00             	lea    0x0(%esi),%esi
80104f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104f70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104f76:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104f79:	39 d0                	cmp    %edx,%eax
80104f7b:	75 f3                	jne    80104f70 <acquire+0x90>
}
80104f7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f80:	5b                   	pop    %ebx
80104f81:	5e                   	pop    %esi
80104f82:	5d                   	pop    %ebp
80104f83:	c3                   	ret    
    panic("acquire");
80104f84:	83 ec 0c             	sub    $0xc,%esp
80104f87:	68 f1 8d 10 80       	push   $0x80108df1
80104f8c:	e8 ff b3 ff ff       	call   80100390 <panic>
80104f91:	eb 0d                	jmp    80104fa0 <release>
80104f93:	90                   	nop
80104f94:	90                   	nop
80104f95:	90                   	nop
80104f96:	90                   	nop
80104f97:	90                   	nop
80104f98:	90                   	nop
80104f99:	90                   	nop
80104f9a:	90                   	nop
80104f9b:	90                   	nop
80104f9c:	90                   	nop
80104f9d:	90                   	nop
80104f9e:	90                   	nop
80104f9f:	90                   	nop

80104fa0 <release>:
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	53                   	push   %ebx
80104fa4:	83 ec 10             	sub    $0x10,%esp
80104fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104faa:	53                   	push   %ebx
80104fab:	e8 00 ff ff ff       	call   80104eb0 <holding>
80104fb0:	83 c4 10             	add    $0x10,%esp
80104fb3:	85 c0                	test   %eax,%eax
80104fb5:	74 22                	je     80104fd9 <release+0x39>
  lk->pcs[0] = 0;
80104fb7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104fbe:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104fc5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104fca:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104fd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fd3:	c9                   	leave  
  popcli();
80104fd4:	e9 77 fe ff ff       	jmp    80104e50 <popcli>
    panic("release");
80104fd9:	83 ec 0c             	sub    $0xc,%esp
80104fdc:	68 f9 8d 10 80       	push   $0x80108df9
80104fe1:	e8 aa b3 ff ff       	call   80100390 <panic>
80104fe6:	66 90                	xchg   %ax,%ax
80104fe8:	66 90                	xchg   %ax,%ax
80104fea:	66 90                	xchg   %ax,%ax
80104fec:	66 90                	xchg   %ax,%ax
80104fee:	66 90                	xchg   %ax,%ax

80104ff0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	57                   	push   %edi
80104ff4:	53                   	push   %ebx
80104ff5:	8b 55 08             	mov    0x8(%ebp),%edx
80104ff8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104ffb:	f6 c2 03             	test   $0x3,%dl
80104ffe:	75 05                	jne    80105005 <memset+0x15>
80105000:	f6 c1 03             	test   $0x3,%cl
80105003:	74 13                	je     80105018 <memset+0x28>
  asm volatile("cld; rep stosb" :
80105005:	89 d7                	mov    %edx,%edi
80105007:	8b 45 0c             	mov    0xc(%ebp),%eax
8010500a:	fc                   	cld    
8010500b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010500d:	5b                   	pop    %ebx
8010500e:	89 d0                	mov    %edx,%eax
80105010:	5f                   	pop    %edi
80105011:	5d                   	pop    %ebp
80105012:	c3                   	ret    
80105013:	90                   	nop
80105014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80105018:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010501c:	c1 e9 02             	shr    $0x2,%ecx
8010501f:	89 f8                	mov    %edi,%eax
80105021:	89 fb                	mov    %edi,%ebx
80105023:	c1 e0 18             	shl    $0x18,%eax
80105026:	c1 e3 10             	shl    $0x10,%ebx
80105029:	09 d8                	or     %ebx,%eax
8010502b:	09 f8                	or     %edi,%eax
8010502d:	c1 e7 08             	shl    $0x8,%edi
80105030:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105032:	89 d7                	mov    %edx,%edi
80105034:	fc                   	cld    
80105035:	f3 ab                	rep stos %eax,%es:(%edi)
}
80105037:	5b                   	pop    %ebx
80105038:	89 d0                	mov    %edx,%eax
8010503a:	5f                   	pop    %edi
8010503b:	5d                   	pop    %ebp
8010503c:	c3                   	ret    
8010503d:	8d 76 00             	lea    0x0(%esi),%esi

80105040 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	57                   	push   %edi
80105044:	56                   	push   %esi
80105045:	53                   	push   %ebx
80105046:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105049:	8b 75 08             	mov    0x8(%ebp),%esi
8010504c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010504f:	85 db                	test   %ebx,%ebx
80105051:	74 29                	je     8010507c <memcmp+0x3c>
    if(*s1 != *s2)
80105053:	0f b6 16             	movzbl (%esi),%edx
80105056:	0f b6 0f             	movzbl (%edi),%ecx
80105059:	38 d1                	cmp    %dl,%cl
8010505b:	75 2b                	jne    80105088 <memcmp+0x48>
8010505d:	b8 01 00 00 00       	mov    $0x1,%eax
80105062:	eb 14                	jmp    80105078 <memcmp+0x38>
80105064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105068:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010506c:	83 c0 01             	add    $0x1,%eax
8010506f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80105074:	38 ca                	cmp    %cl,%dl
80105076:	75 10                	jne    80105088 <memcmp+0x48>
  while(n-- > 0){
80105078:	39 d8                	cmp    %ebx,%eax
8010507a:	75 ec                	jne    80105068 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010507c:	5b                   	pop    %ebx
  return 0;
8010507d:	31 c0                	xor    %eax,%eax
}
8010507f:	5e                   	pop    %esi
80105080:	5f                   	pop    %edi
80105081:	5d                   	pop    %ebp
80105082:	c3                   	ret    
80105083:	90                   	nop
80105084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80105088:	0f b6 c2             	movzbl %dl,%eax
}
8010508b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010508c:	29 c8                	sub    %ecx,%eax
}
8010508e:	5e                   	pop    %esi
8010508f:	5f                   	pop    %edi
80105090:	5d                   	pop    %ebp
80105091:	c3                   	ret    
80105092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050a0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	56                   	push   %esi
801050a4:	53                   	push   %ebx
801050a5:	8b 45 08             	mov    0x8(%ebp),%eax
801050a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801050ab:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801050ae:	39 c3                	cmp    %eax,%ebx
801050b0:	73 26                	jae    801050d8 <memmove+0x38>
801050b2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801050b5:	39 c8                	cmp    %ecx,%eax
801050b7:	73 1f                	jae    801050d8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801050b9:	85 f6                	test   %esi,%esi
801050bb:	8d 56 ff             	lea    -0x1(%esi),%edx
801050be:	74 0f                	je     801050cf <memmove+0x2f>
      *--d = *--s;
801050c0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801050c4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801050c7:	83 ea 01             	sub    $0x1,%edx
801050ca:	83 fa ff             	cmp    $0xffffffff,%edx
801050cd:	75 f1                	jne    801050c0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801050cf:	5b                   	pop    %ebx
801050d0:	5e                   	pop    %esi
801050d1:	5d                   	pop    %ebp
801050d2:	c3                   	ret    
801050d3:	90                   	nop
801050d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801050d8:	31 d2                	xor    %edx,%edx
801050da:	85 f6                	test   %esi,%esi
801050dc:	74 f1                	je     801050cf <memmove+0x2f>
801050de:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801050e0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801050e4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801050e7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801050ea:	39 d6                	cmp    %edx,%esi
801050ec:	75 f2                	jne    801050e0 <memmove+0x40>
}
801050ee:	5b                   	pop    %ebx
801050ef:	5e                   	pop    %esi
801050f0:	5d                   	pop    %ebp
801050f1:	c3                   	ret    
801050f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105100 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105103:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105104:	eb 9a                	jmp    801050a0 <memmove>
80105106:	8d 76 00             	lea    0x0(%esi),%esi
80105109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105110 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	57                   	push   %edi
80105114:	56                   	push   %esi
80105115:	8b 7d 10             	mov    0x10(%ebp),%edi
80105118:	53                   	push   %ebx
80105119:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010511c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010511f:	85 ff                	test   %edi,%edi
80105121:	74 2f                	je     80105152 <strncmp+0x42>
80105123:	0f b6 01             	movzbl (%ecx),%eax
80105126:	0f b6 1e             	movzbl (%esi),%ebx
80105129:	84 c0                	test   %al,%al
8010512b:	74 37                	je     80105164 <strncmp+0x54>
8010512d:	38 c3                	cmp    %al,%bl
8010512f:	75 33                	jne    80105164 <strncmp+0x54>
80105131:	01 f7                	add    %esi,%edi
80105133:	eb 13                	jmp    80105148 <strncmp+0x38>
80105135:	8d 76 00             	lea    0x0(%esi),%esi
80105138:	0f b6 01             	movzbl (%ecx),%eax
8010513b:	84 c0                	test   %al,%al
8010513d:	74 21                	je     80105160 <strncmp+0x50>
8010513f:	0f b6 1a             	movzbl (%edx),%ebx
80105142:	89 d6                	mov    %edx,%esi
80105144:	38 d8                	cmp    %bl,%al
80105146:	75 1c                	jne    80105164 <strncmp+0x54>
    n--, p++, q++;
80105148:	8d 56 01             	lea    0x1(%esi),%edx
8010514b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010514e:	39 fa                	cmp    %edi,%edx
80105150:	75 e6                	jne    80105138 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80105152:	5b                   	pop    %ebx
    return 0;
80105153:	31 c0                	xor    %eax,%eax
}
80105155:	5e                   	pop    %esi
80105156:	5f                   	pop    %edi
80105157:	5d                   	pop    %ebp
80105158:	c3                   	ret    
80105159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105160:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80105164:	29 d8                	sub    %ebx,%eax
}
80105166:	5b                   	pop    %ebx
80105167:	5e                   	pop    %esi
80105168:	5f                   	pop    %edi
80105169:	5d                   	pop    %ebp
8010516a:	c3                   	ret    
8010516b:	90                   	nop
8010516c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105170 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	56                   	push   %esi
80105174:	53                   	push   %ebx
80105175:	8b 45 08             	mov    0x8(%ebp),%eax
80105178:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010517b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010517e:	89 c2                	mov    %eax,%edx
80105180:	eb 19                	jmp    8010519b <strncpy+0x2b>
80105182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105188:	83 c3 01             	add    $0x1,%ebx
8010518b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010518f:	83 c2 01             	add    $0x1,%edx
80105192:	84 c9                	test   %cl,%cl
80105194:	88 4a ff             	mov    %cl,-0x1(%edx)
80105197:	74 09                	je     801051a2 <strncpy+0x32>
80105199:	89 f1                	mov    %esi,%ecx
8010519b:	85 c9                	test   %ecx,%ecx
8010519d:	8d 71 ff             	lea    -0x1(%ecx),%esi
801051a0:	7f e6                	jg     80105188 <strncpy+0x18>
    ;
  while(n-- > 0)
801051a2:	31 c9                	xor    %ecx,%ecx
801051a4:	85 f6                	test   %esi,%esi
801051a6:	7e 17                	jle    801051bf <strncpy+0x4f>
801051a8:	90                   	nop
801051a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801051b0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801051b4:	89 f3                	mov    %esi,%ebx
801051b6:	83 c1 01             	add    $0x1,%ecx
801051b9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801051bb:	85 db                	test   %ebx,%ebx
801051bd:	7f f1                	jg     801051b0 <strncpy+0x40>
  return os;
}
801051bf:	5b                   	pop    %ebx
801051c0:	5e                   	pop    %esi
801051c1:	5d                   	pop    %ebp
801051c2:	c3                   	ret    
801051c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801051c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051d0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	56                   	push   %esi
801051d4:	53                   	push   %ebx
801051d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801051d8:	8b 45 08             	mov    0x8(%ebp),%eax
801051db:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801051de:	85 c9                	test   %ecx,%ecx
801051e0:	7e 26                	jle    80105208 <safestrcpy+0x38>
801051e2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801051e6:	89 c1                	mov    %eax,%ecx
801051e8:	eb 17                	jmp    80105201 <safestrcpy+0x31>
801051ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801051f0:	83 c2 01             	add    $0x1,%edx
801051f3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801051f7:	83 c1 01             	add    $0x1,%ecx
801051fa:	84 db                	test   %bl,%bl
801051fc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801051ff:	74 04                	je     80105205 <safestrcpy+0x35>
80105201:	39 f2                	cmp    %esi,%edx
80105203:	75 eb                	jne    801051f0 <safestrcpy+0x20>
    ;
  *s = 0;
80105205:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105208:	5b                   	pop    %ebx
80105209:	5e                   	pop    %esi
8010520a:	5d                   	pop    %ebp
8010520b:	c3                   	ret    
8010520c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105210 <strlen>:

int
strlen(const char *s)
{
80105210:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105211:	31 c0                	xor    %eax,%eax
{
80105213:	89 e5                	mov    %esp,%ebp
80105215:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105218:	80 3a 00             	cmpb   $0x0,(%edx)
8010521b:	74 0c                	je     80105229 <strlen+0x19>
8010521d:	8d 76 00             	lea    0x0(%esi),%esi
80105220:	83 c0 01             	add    $0x1,%eax
80105223:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105227:	75 f7                	jne    80105220 <strlen+0x10>
    ;
  return n;
}
80105229:	5d                   	pop    %ebp
8010522a:	c3                   	ret    

8010522b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010522b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010522f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105233:	55                   	push   %ebp
  pushl %ebx
80105234:	53                   	push   %ebx
  pushl %esi
80105235:	56                   	push   %esi
  pushl %edi
80105236:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105237:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105239:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010523b:	5f                   	pop    %edi
  popl %esi
8010523c:	5e                   	pop    %esi
  popl %ebx
8010523d:	5b                   	pop    %ebx
  popl %ebp
8010523e:	5d                   	pop    %ebp
  ret
8010523f:	c3                   	ret    

80105240 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	53                   	push   %ebx
80105244:	83 ec 04             	sub    $0x4,%esp
80105247:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010524a:	e8 71 ee ff ff       	call   801040c0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010524f:	8b 00                	mov    (%eax),%eax
80105251:	39 d8                	cmp    %ebx,%eax
80105253:	76 1b                	jbe    80105270 <fetchint+0x30>
80105255:	8d 53 04             	lea    0x4(%ebx),%edx
80105258:	39 d0                	cmp    %edx,%eax
8010525a:	72 14                	jb     80105270 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010525c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010525f:	8b 13                	mov    (%ebx),%edx
80105261:	89 10                	mov    %edx,(%eax)
  return 0;
80105263:	31 c0                	xor    %eax,%eax
}
80105265:	83 c4 04             	add    $0x4,%esp
80105268:	5b                   	pop    %ebx
80105269:	5d                   	pop    %ebp
8010526a:	c3                   	ret    
8010526b:	90                   	nop
8010526c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105275:	eb ee                	jmp    80105265 <fetchint+0x25>
80105277:	89 f6                	mov    %esi,%esi
80105279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105280 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	53                   	push   %ebx
80105284:	83 ec 04             	sub    $0x4,%esp
80105287:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010528a:	e8 31 ee ff ff       	call   801040c0 <myproc>

  if(addr >= curproc->sz)
8010528f:	39 18                	cmp    %ebx,(%eax)
80105291:	76 29                	jbe    801052bc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105293:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105296:	89 da                	mov    %ebx,%edx
80105298:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010529a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010529c:	39 c3                	cmp    %eax,%ebx
8010529e:	73 1c                	jae    801052bc <fetchstr+0x3c>
    if(*s == 0)
801052a0:	80 3b 00             	cmpb   $0x0,(%ebx)
801052a3:	75 10                	jne    801052b5 <fetchstr+0x35>
801052a5:	eb 39                	jmp    801052e0 <fetchstr+0x60>
801052a7:	89 f6                	mov    %esi,%esi
801052a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801052b0:	80 3a 00             	cmpb   $0x0,(%edx)
801052b3:	74 1b                	je     801052d0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
801052b5:	83 c2 01             	add    $0x1,%edx
801052b8:	39 d0                	cmp    %edx,%eax
801052ba:	77 f4                	ja     801052b0 <fetchstr+0x30>
    return -1;
801052bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
801052c1:	83 c4 04             	add    $0x4,%esp
801052c4:	5b                   	pop    %ebx
801052c5:	5d                   	pop    %ebp
801052c6:	c3                   	ret    
801052c7:	89 f6                	mov    %esi,%esi
801052c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801052d0:	83 c4 04             	add    $0x4,%esp
801052d3:	89 d0                	mov    %edx,%eax
801052d5:	29 d8                	sub    %ebx,%eax
801052d7:	5b                   	pop    %ebx
801052d8:	5d                   	pop    %ebp
801052d9:	c3                   	ret    
801052da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
801052e0:	31 c0                	xor    %eax,%eax
      return s - *pp;
801052e2:	eb dd                	jmp    801052c1 <fetchstr+0x41>
801052e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801052ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801052f0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	56                   	push   %esi
801052f4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801052f5:	e8 c6 ed ff ff       	call   801040c0 <myproc>
801052fa:	8b 40 18             	mov    0x18(%eax),%eax
801052fd:	8b 55 08             	mov    0x8(%ebp),%edx
80105300:	8b 40 44             	mov    0x44(%eax),%eax
80105303:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105306:	e8 b5 ed ff ff       	call   801040c0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010530b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010530d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105310:	39 c6                	cmp    %eax,%esi
80105312:	73 1c                	jae    80105330 <argint+0x40>
80105314:	8d 53 08             	lea    0x8(%ebx),%edx
80105317:	39 d0                	cmp    %edx,%eax
80105319:	72 15                	jb     80105330 <argint+0x40>
  *ip = *(int*)(addr);
8010531b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010531e:	8b 53 04             	mov    0x4(%ebx),%edx
80105321:	89 10                	mov    %edx,(%eax)
  return 0;
80105323:	31 c0                	xor    %eax,%eax
}
80105325:	5b                   	pop    %ebx
80105326:	5e                   	pop    %esi
80105327:	5d                   	pop    %ebp
80105328:	c3                   	ret    
80105329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105330:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105335:	eb ee                	jmp    80105325 <argint+0x35>
80105337:	89 f6                	mov    %esi,%esi
80105339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105340 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	56                   	push   %esi
80105344:	53                   	push   %ebx
80105345:	83 ec 10             	sub    $0x10,%esp
80105348:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010534b:	e8 70 ed ff ff       	call   801040c0 <myproc>
80105350:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105352:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105355:	83 ec 08             	sub    $0x8,%esp
80105358:	50                   	push   %eax
80105359:	ff 75 08             	pushl  0x8(%ebp)
8010535c:	e8 8f ff ff ff       	call   801052f0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105361:	83 c4 10             	add    $0x10,%esp
80105364:	85 c0                	test   %eax,%eax
80105366:	78 28                	js     80105390 <argptr+0x50>
80105368:	85 db                	test   %ebx,%ebx
8010536a:	78 24                	js     80105390 <argptr+0x50>
8010536c:	8b 16                	mov    (%esi),%edx
8010536e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105371:	39 c2                	cmp    %eax,%edx
80105373:	76 1b                	jbe    80105390 <argptr+0x50>
80105375:	01 c3                	add    %eax,%ebx
80105377:	39 da                	cmp    %ebx,%edx
80105379:	72 15                	jb     80105390 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010537b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010537e:	89 02                	mov    %eax,(%edx)
  return 0;
80105380:	31 c0                	xor    %eax,%eax
}
80105382:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105385:	5b                   	pop    %ebx
80105386:	5e                   	pop    %esi
80105387:	5d                   	pop    %ebp
80105388:	c3                   	ret    
80105389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105390:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105395:	eb eb                	jmp    80105382 <argptr+0x42>
80105397:	89 f6                	mov    %esi,%esi
80105399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053a0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801053a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053a9:	50                   	push   %eax
801053aa:	ff 75 08             	pushl  0x8(%ebp)
801053ad:	e8 3e ff ff ff       	call   801052f0 <argint>
801053b2:	83 c4 10             	add    $0x10,%esp
801053b5:	85 c0                	test   %eax,%eax
801053b7:	78 17                	js     801053d0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801053b9:	83 ec 08             	sub    $0x8,%esp
801053bc:	ff 75 0c             	pushl  0xc(%ebp)
801053bf:	ff 75 f4             	pushl  -0xc(%ebp)
801053c2:	e8 b9 fe ff ff       	call   80105280 <fetchstr>
801053c7:	83 c4 10             	add    $0x10,%esp
}
801053ca:	c9                   	leave  
801053cb:	c3                   	ret    
801053cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801053d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053d5:	c9                   	leave  
801053d6:	c3                   	ret    
801053d7:	89 f6                	mov    %esi,%esi
801053d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053e0 <syscall>:
[SYS_get_number_of_free_pages] sys_get_number_of_free_pages
};

void
syscall(void)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	53                   	push   %ebx
801053e4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801053e7:	e8 d4 ec ff ff       	call   801040c0 <myproc>
801053ec:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801053ee:	8b 40 18             	mov    0x18(%eax),%eax
801053f1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801053f4:	8d 50 ff             	lea    -0x1(%eax),%edx
801053f7:	83 fa 15             	cmp    $0x15,%edx
801053fa:	77 1c                	ja     80105418 <syscall+0x38>
801053fc:	8b 14 85 20 8e 10 80 	mov    -0x7fef71e0(,%eax,4),%edx
80105403:	85 d2                	test   %edx,%edx
80105405:	74 11                	je     80105418 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105407:	ff d2                	call   *%edx
80105409:	8b 53 18             	mov    0x18(%ebx),%edx
8010540c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010540f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105412:	c9                   	leave  
80105413:	c3                   	ret    
80105414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105418:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105419:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010541c:	50                   	push   %eax
8010541d:	ff 73 10             	pushl  0x10(%ebx)
80105420:	68 01 8e 10 80       	push   $0x80108e01
80105425:	e8 36 b2 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010542a:	8b 43 18             	mov    0x18(%ebx),%eax
8010542d:	83 c4 10             	add    $0x10,%esp
80105430:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105437:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010543a:	c9                   	leave  
8010543b:	c3                   	ret    
8010543c:	66 90                	xchg   %ax,%ax
8010543e:	66 90                	xchg   %ax,%ax

80105440 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	56                   	push   %esi
80105444:	53                   	push   %ebx
80105445:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105447:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010544a:	89 d6                	mov    %edx,%esi
8010544c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010544f:	50                   	push   %eax
80105450:	6a 00                	push   $0x0
80105452:	e8 99 fe ff ff       	call   801052f0 <argint>
80105457:	83 c4 10             	add    $0x10,%esp
8010545a:	85 c0                	test   %eax,%eax
8010545c:	78 2a                	js     80105488 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010545e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105462:	77 24                	ja     80105488 <argfd.constprop.0+0x48>
80105464:	e8 57 ec ff ff       	call   801040c0 <myproc>
80105469:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010546c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105470:	85 c0                	test   %eax,%eax
80105472:	74 14                	je     80105488 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80105474:	85 db                	test   %ebx,%ebx
80105476:	74 02                	je     8010547a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105478:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
8010547a:	89 06                	mov    %eax,(%esi)
  return 0;
8010547c:	31 c0                	xor    %eax,%eax
}
8010547e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105481:	5b                   	pop    %ebx
80105482:	5e                   	pop    %esi
80105483:	5d                   	pop    %ebp
80105484:	c3                   	ret    
80105485:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105488:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010548d:	eb ef                	jmp    8010547e <argfd.constprop.0+0x3e>
8010548f:	90                   	nop

80105490 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105490:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105491:	31 c0                	xor    %eax,%eax
{
80105493:	89 e5                	mov    %esp,%ebp
80105495:	56                   	push   %esi
80105496:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105497:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010549a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010549d:	e8 9e ff ff ff       	call   80105440 <argfd.constprop.0>
801054a2:	85 c0                	test   %eax,%eax
801054a4:	78 42                	js     801054e8 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
801054a6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801054a9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801054ab:	e8 10 ec ff ff       	call   801040c0 <myproc>
801054b0:	eb 0e                	jmp    801054c0 <sys_dup+0x30>
801054b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801054b8:	83 c3 01             	add    $0x1,%ebx
801054bb:	83 fb 10             	cmp    $0x10,%ebx
801054be:	74 28                	je     801054e8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
801054c0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801054c4:	85 d2                	test   %edx,%edx
801054c6:	75 f0                	jne    801054b8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
801054c8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
801054cc:	83 ec 0c             	sub    $0xc,%esp
801054cf:	ff 75 f4             	pushl  -0xc(%ebp)
801054d2:	e8 69 bd ff ff       	call   80101240 <filedup>
  return fd;
801054d7:	83 c4 10             	add    $0x10,%esp
}
801054da:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054dd:	89 d8                	mov    %ebx,%eax
801054df:	5b                   	pop    %ebx
801054e0:	5e                   	pop    %esi
801054e1:	5d                   	pop    %ebp
801054e2:	c3                   	ret    
801054e3:	90                   	nop
801054e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801054eb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801054f0:	89 d8                	mov    %ebx,%eax
801054f2:	5b                   	pop    %ebx
801054f3:	5e                   	pop    %esi
801054f4:	5d                   	pop    %ebp
801054f5:	c3                   	ret    
801054f6:	8d 76 00             	lea    0x0(%esi),%esi
801054f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105500 <sys_read>:

int
sys_read(void)
{
80105500:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105501:	31 c0                	xor    %eax,%eax
{
80105503:	89 e5                	mov    %esp,%ebp
80105505:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105508:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010550b:	e8 30 ff ff ff       	call   80105440 <argfd.constprop.0>
80105510:	85 c0                	test   %eax,%eax
80105512:	78 4c                	js     80105560 <sys_read+0x60>
80105514:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105517:	83 ec 08             	sub    $0x8,%esp
8010551a:	50                   	push   %eax
8010551b:	6a 02                	push   $0x2
8010551d:	e8 ce fd ff ff       	call   801052f0 <argint>
80105522:	83 c4 10             	add    $0x10,%esp
80105525:	85 c0                	test   %eax,%eax
80105527:	78 37                	js     80105560 <sys_read+0x60>
80105529:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010552c:	83 ec 04             	sub    $0x4,%esp
8010552f:	ff 75 f0             	pushl  -0x10(%ebp)
80105532:	50                   	push   %eax
80105533:	6a 01                	push   $0x1
80105535:	e8 06 fe ff ff       	call   80105340 <argptr>
8010553a:	83 c4 10             	add    $0x10,%esp
8010553d:	85 c0                	test   %eax,%eax
8010553f:	78 1f                	js     80105560 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105541:	83 ec 04             	sub    $0x4,%esp
80105544:	ff 75 f0             	pushl  -0x10(%ebp)
80105547:	ff 75 f4             	pushl  -0xc(%ebp)
8010554a:	ff 75 ec             	pushl  -0x14(%ebp)
8010554d:	e8 5e be ff ff       	call   801013b0 <fileread>
80105552:	83 c4 10             	add    $0x10,%esp
}
80105555:	c9                   	leave  
80105556:	c3                   	ret    
80105557:	89 f6                	mov    %esi,%esi
80105559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105560:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105565:	c9                   	leave  
80105566:	c3                   	ret    
80105567:	89 f6                	mov    %esi,%esi
80105569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105570 <sys_write>:

int
sys_write(void)
{
80105570:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105571:	31 c0                	xor    %eax,%eax
{
80105573:	89 e5                	mov    %esp,%ebp
80105575:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105578:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010557b:	e8 c0 fe ff ff       	call   80105440 <argfd.constprop.0>
80105580:	85 c0                	test   %eax,%eax
80105582:	78 4c                	js     801055d0 <sys_write+0x60>
80105584:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105587:	83 ec 08             	sub    $0x8,%esp
8010558a:	50                   	push   %eax
8010558b:	6a 02                	push   $0x2
8010558d:	e8 5e fd ff ff       	call   801052f0 <argint>
80105592:	83 c4 10             	add    $0x10,%esp
80105595:	85 c0                	test   %eax,%eax
80105597:	78 37                	js     801055d0 <sys_write+0x60>
80105599:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010559c:	83 ec 04             	sub    $0x4,%esp
8010559f:	ff 75 f0             	pushl  -0x10(%ebp)
801055a2:	50                   	push   %eax
801055a3:	6a 01                	push   $0x1
801055a5:	e8 96 fd ff ff       	call   80105340 <argptr>
801055aa:	83 c4 10             	add    $0x10,%esp
801055ad:	85 c0                	test   %eax,%eax
801055af:	78 1f                	js     801055d0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
801055b1:	83 ec 04             	sub    $0x4,%esp
801055b4:	ff 75 f0             	pushl  -0x10(%ebp)
801055b7:	ff 75 f4             	pushl  -0xc(%ebp)
801055ba:	ff 75 ec             	pushl  -0x14(%ebp)
801055bd:	e8 7e be ff ff       	call   80101440 <filewrite>
801055c2:	83 c4 10             	add    $0x10,%esp
}
801055c5:	c9                   	leave  
801055c6:	c3                   	ret    
801055c7:	89 f6                	mov    %esi,%esi
801055c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801055d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055d5:	c9                   	leave  
801055d6:	c3                   	ret    
801055d7:	89 f6                	mov    %esi,%esi
801055d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055e0 <sys_close>:

int
sys_close(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801055e6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801055e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055ec:	e8 4f fe ff ff       	call   80105440 <argfd.constprop.0>
801055f1:	85 c0                	test   %eax,%eax
801055f3:	78 2b                	js     80105620 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
801055f5:	e8 c6 ea ff ff       	call   801040c0 <myproc>
801055fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801055fd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105600:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105607:	00 
  fileclose(f);
80105608:	ff 75 f4             	pushl  -0xc(%ebp)
8010560b:	e8 80 bc ff ff       	call   80101290 <fileclose>
  return 0;
80105610:	83 c4 10             	add    $0x10,%esp
80105613:	31 c0                	xor    %eax,%eax
}
80105615:	c9                   	leave  
80105616:	c3                   	ret    
80105617:	89 f6                	mov    %esi,%esi
80105619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105625:	c9                   	leave  
80105626:	c3                   	ret    
80105627:	89 f6                	mov    %esi,%esi
80105629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105630 <sys_fstat>:

int
sys_fstat(void)
{
80105630:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105631:	31 c0                	xor    %eax,%eax
{
80105633:	89 e5                	mov    %esp,%ebp
80105635:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105638:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010563b:	e8 00 fe ff ff       	call   80105440 <argfd.constprop.0>
80105640:	85 c0                	test   %eax,%eax
80105642:	78 2c                	js     80105670 <sys_fstat+0x40>
80105644:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105647:	83 ec 04             	sub    $0x4,%esp
8010564a:	6a 14                	push   $0x14
8010564c:	50                   	push   %eax
8010564d:	6a 01                	push   $0x1
8010564f:	e8 ec fc ff ff       	call   80105340 <argptr>
80105654:	83 c4 10             	add    $0x10,%esp
80105657:	85 c0                	test   %eax,%eax
80105659:	78 15                	js     80105670 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010565b:	83 ec 08             	sub    $0x8,%esp
8010565e:	ff 75 f4             	pushl  -0xc(%ebp)
80105661:	ff 75 f0             	pushl  -0x10(%ebp)
80105664:	e8 f7 bc ff ff       	call   80101360 <filestat>
80105669:	83 c4 10             	add    $0x10,%esp
}
8010566c:	c9                   	leave  
8010566d:	c3                   	ret    
8010566e:	66 90                	xchg   %ax,%ax
    return -1;
80105670:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105675:	c9                   	leave  
80105676:	c3                   	ret    
80105677:	89 f6                	mov    %esi,%esi
80105679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105680 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	57                   	push   %edi
80105684:	56                   	push   %esi
80105685:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105686:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105689:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010568c:	50                   	push   %eax
8010568d:	6a 00                	push   $0x0
8010568f:	e8 0c fd ff ff       	call   801053a0 <argstr>
80105694:	83 c4 10             	add    $0x10,%esp
80105697:	85 c0                	test   %eax,%eax
80105699:	0f 88 fb 00 00 00    	js     8010579a <sys_link+0x11a>
8010569f:	8d 45 d0             	lea    -0x30(%ebp),%eax
801056a2:	83 ec 08             	sub    $0x8,%esp
801056a5:	50                   	push   %eax
801056a6:	6a 01                	push   $0x1
801056a8:	e8 f3 fc ff ff       	call   801053a0 <argstr>
801056ad:	83 c4 10             	add    $0x10,%esp
801056b0:	85 c0                	test   %eax,%eax
801056b2:	0f 88 e2 00 00 00    	js     8010579a <sys_link+0x11a>
    return -1;

  begin_op();
801056b8:	e8 43 dd ff ff       	call   80103400 <begin_op>
  if((ip = namei(old)) == 0){
801056bd:	83 ec 0c             	sub    $0xc,%esp
801056c0:	ff 75 d4             	pushl  -0x2c(%ebp)
801056c3:	e8 68 cc ff ff       	call   80102330 <namei>
801056c8:	83 c4 10             	add    $0x10,%esp
801056cb:	85 c0                	test   %eax,%eax
801056cd:	89 c3                	mov    %eax,%ebx
801056cf:	0f 84 ea 00 00 00    	je     801057bf <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
801056d5:	83 ec 0c             	sub    $0xc,%esp
801056d8:	50                   	push   %eax
801056d9:	e8 f2 c3 ff ff       	call   80101ad0 <ilock>
  if(ip->type == T_DIR){
801056de:	83 c4 10             	add    $0x10,%esp
801056e1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056e6:	0f 84 bb 00 00 00    	je     801057a7 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
801056ec:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801056f1:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
801056f4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801056f7:	53                   	push   %ebx
801056f8:	e8 23 c3 ff ff       	call   80101a20 <iupdate>
  iunlock(ip);
801056fd:	89 1c 24             	mov    %ebx,(%esp)
80105700:	e8 ab c4 ff ff       	call   80101bb0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105705:	58                   	pop    %eax
80105706:	5a                   	pop    %edx
80105707:	57                   	push   %edi
80105708:	ff 75 d0             	pushl  -0x30(%ebp)
8010570b:	e8 40 cc ff ff       	call   80102350 <nameiparent>
80105710:	83 c4 10             	add    $0x10,%esp
80105713:	85 c0                	test   %eax,%eax
80105715:	89 c6                	mov    %eax,%esi
80105717:	74 5b                	je     80105774 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105719:	83 ec 0c             	sub    $0xc,%esp
8010571c:	50                   	push   %eax
8010571d:	e8 ae c3 ff ff       	call   80101ad0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105722:	83 c4 10             	add    $0x10,%esp
80105725:	8b 03                	mov    (%ebx),%eax
80105727:	39 06                	cmp    %eax,(%esi)
80105729:	75 3d                	jne    80105768 <sys_link+0xe8>
8010572b:	83 ec 04             	sub    $0x4,%esp
8010572e:	ff 73 04             	pushl  0x4(%ebx)
80105731:	57                   	push   %edi
80105732:	56                   	push   %esi
80105733:	e8 38 cb ff ff       	call   80102270 <dirlink>
80105738:	83 c4 10             	add    $0x10,%esp
8010573b:	85 c0                	test   %eax,%eax
8010573d:	78 29                	js     80105768 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010573f:	83 ec 0c             	sub    $0xc,%esp
80105742:	56                   	push   %esi
80105743:	e8 18 c6 ff ff       	call   80101d60 <iunlockput>
  iput(ip);
80105748:	89 1c 24             	mov    %ebx,(%esp)
8010574b:	e8 b0 c4 ff ff       	call   80101c00 <iput>

  end_op();
80105750:	e8 1b dd ff ff       	call   80103470 <end_op>

  return 0;
80105755:	83 c4 10             	add    $0x10,%esp
80105758:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010575a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010575d:	5b                   	pop    %ebx
8010575e:	5e                   	pop    %esi
8010575f:	5f                   	pop    %edi
80105760:	5d                   	pop    %ebp
80105761:	c3                   	ret    
80105762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105768:	83 ec 0c             	sub    $0xc,%esp
8010576b:	56                   	push   %esi
8010576c:	e8 ef c5 ff ff       	call   80101d60 <iunlockput>
    goto bad;
80105771:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105774:	83 ec 0c             	sub    $0xc,%esp
80105777:	53                   	push   %ebx
80105778:	e8 53 c3 ff ff       	call   80101ad0 <ilock>
  ip->nlink--;
8010577d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105782:	89 1c 24             	mov    %ebx,(%esp)
80105785:	e8 96 c2 ff ff       	call   80101a20 <iupdate>
  iunlockput(ip);
8010578a:	89 1c 24             	mov    %ebx,(%esp)
8010578d:	e8 ce c5 ff ff       	call   80101d60 <iunlockput>
  end_op();
80105792:	e8 d9 dc ff ff       	call   80103470 <end_op>
  return -1;
80105797:	83 c4 10             	add    $0x10,%esp
}
8010579a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010579d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057a2:	5b                   	pop    %ebx
801057a3:	5e                   	pop    %esi
801057a4:	5f                   	pop    %edi
801057a5:	5d                   	pop    %ebp
801057a6:	c3                   	ret    
    iunlockput(ip);
801057a7:	83 ec 0c             	sub    $0xc,%esp
801057aa:	53                   	push   %ebx
801057ab:	e8 b0 c5 ff ff       	call   80101d60 <iunlockput>
    end_op();
801057b0:	e8 bb dc ff ff       	call   80103470 <end_op>
    return -1;
801057b5:	83 c4 10             	add    $0x10,%esp
801057b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057bd:	eb 9b                	jmp    8010575a <sys_link+0xda>
    end_op();
801057bf:	e8 ac dc ff ff       	call   80103470 <end_op>
    return -1;
801057c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057c9:	eb 8f                	jmp    8010575a <sys_link+0xda>
801057cb:	90                   	nop
801057cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057d0 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	57                   	push   %edi
801057d4:	56                   	push   %esi
801057d5:	53                   	push   %ebx
801057d6:	83 ec 1c             	sub    $0x1c,%esp
801057d9:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801057dc:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
801057e0:	76 3e                	jbe    80105820 <isdirempty+0x50>
801057e2:	bb 20 00 00 00       	mov    $0x20,%ebx
801057e7:	8d 7d d8             	lea    -0x28(%ebp),%edi
801057ea:	eb 0c                	jmp    801057f8 <isdirempty+0x28>
801057ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057f0:	83 c3 10             	add    $0x10,%ebx
801057f3:	3b 5e 58             	cmp    0x58(%esi),%ebx
801057f6:	73 28                	jae    80105820 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057f8:	6a 10                	push   $0x10
801057fa:	53                   	push   %ebx
801057fb:	57                   	push   %edi
801057fc:	56                   	push   %esi
801057fd:	e8 ae c5 ff ff       	call   80101db0 <readi>
80105802:	83 c4 10             	add    $0x10,%esp
80105805:	83 f8 10             	cmp    $0x10,%eax
80105808:	75 23                	jne    8010582d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010580a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010580f:	74 df                	je     801057f0 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105811:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105814:	31 c0                	xor    %eax,%eax
}
80105816:	5b                   	pop    %ebx
80105817:	5e                   	pop    %esi
80105818:	5f                   	pop    %edi
80105819:	5d                   	pop    %ebp
8010581a:	c3                   	ret    
8010581b:	90                   	nop
8010581c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105820:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105823:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105828:	5b                   	pop    %ebx
80105829:	5e                   	pop    %esi
8010582a:	5f                   	pop    %edi
8010582b:	5d                   	pop    %ebp
8010582c:	c3                   	ret    
      panic("isdirempty: readi");
8010582d:	83 ec 0c             	sub    $0xc,%esp
80105830:	68 7c 8e 10 80       	push   $0x80108e7c
80105835:	e8 56 ab ff ff       	call   80100390 <panic>
8010583a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105840 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	57                   	push   %edi
80105844:	56                   	push   %esi
80105845:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105846:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105849:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010584c:	50                   	push   %eax
8010584d:	6a 00                	push   $0x0
8010584f:	e8 4c fb ff ff       	call   801053a0 <argstr>
80105854:	83 c4 10             	add    $0x10,%esp
80105857:	85 c0                	test   %eax,%eax
80105859:	0f 88 51 01 00 00    	js     801059b0 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010585f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105862:	e8 99 db ff ff       	call   80103400 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105867:	83 ec 08             	sub    $0x8,%esp
8010586a:	53                   	push   %ebx
8010586b:	ff 75 c0             	pushl  -0x40(%ebp)
8010586e:	e8 dd ca ff ff       	call   80102350 <nameiparent>
80105873:	83 c4 10             	add    $0x10,%esp
80105876:	85 c0                	test   %eax,%eax
80105878:	89 c6                	mov    %eax,%esi
8010587a:	0f 84 37 01 00 00    	je     801059b7 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105880:	83 ec 0c             	sub    $0xc,%esp
80105883:	50                   	push   %eax
80105884:	e8 47 c2 ff ff       	call   80101ad0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105889:	58                   	pop    %eax
8010588a:	5a                   	pop    %edx
8010588b:	68 fd 87 10 80       	push   $0x801087fd
80105890:	53                   	push   %ebx
80105891:	e8 4a c7 ff ff       	call   80101fe0 <namecmp>
80105896:	83 c4 10             	add    $0x10,%esp
80105899:	85 c0                	test   %eax,%eax
8010589b:	0f 84 d7 00 00 00    	je     80105978 <sys_unlink+0x138>
801058a1:	83 ec 08             	sub    $0x8,%esp
801058a4:	68 fc 87 10 80       	push   $0x801087fc
801058a9:	53                   	push   %ebx
801058aa:	e8 31 c7 ff ff       	call   80101fe0 <namecmp>
801058af:	83 c4 10             	add    $0x10,%esp
801058b2:	85 c0                	test   %eax,%eax
801058b4:	0f 84 be 00 00 00    	je     80105978 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801058ba:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801058bd:	83 ec 04             	sub    $0x4,%esp
801058c0:	50                   	push   %eax
801058c1:	53                   	push   %ebx
801058c2:	56                   	push   %esi
801058c3:	e8 38 c7 ff ff       	call   80102000 <dirlookup>
801058c8:	83 c4 10             	add    $0x10,%esp
801058cb:	85 c0                	test   %eax,%eax
801058cd:	89 c3                	mov    %eax,%ebx
801058cf:	0f 84 a3 00 00 00    	je     80105978 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
801058d5:	83 ec 0c             	sub    $0xc,%esp
801058d8:	50                   	push   %eax
801058d9:	e8 f2 c1 ff ff       	call   80101ad0 <ilock>

  if(ip->nlink < 1)
801058de:	83 c4 10             	add    $0x10,%esp
801058e1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801058e6:	0f 8e e4 00 00 00    	jle    801059d0 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801058ec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058f1:	74 65                	je     80105958 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801058f3:	8d 7d d8             	lea    -0x28(%ebp),%edi
801058f6:	83 ec 04             	sub    $0x4,%esp
801058f9:	6a 10                	push   $0x10
801058fb:	6a 00                	push   $0x0
801058fd:	57                   	push   %edi
801058fe:	e8 ed f6 ff ff       	call   80104ff0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105903:	6a 10                	push   $0x10
80105905:	ff 75 c4             	pushl  -0x3c(%ebp)
80105908:	57                   	push   %edi
80105909:	56                   	push   %esi
8010590a:	e8 a1 c5 ff ff       	call   80101eb0 <writei>
8010590f:	83 c4 20             	add    $0x20,%esp
80105912:	83 f8 10             	cmp    $0x10,%eax
80105915:	0f 85 a8 00 00 00    	jne    801059c3 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010591b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105920:	74 6e                	je     80105990 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105922:	83 ec 0c             	sub    $0xc,%esp
80105925:	56                   	push   %esi
80105926:	e8 35 c4 ff ff       	call   80101d60 <iunlockput>

  ip->nlink--;
8010592b:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105930:	89 1c 24             	mov    %ebx,(%esp)
80105933:	e8 e8 c0 ff ff       	call   80101a20 <iupdate>
  iunlockput(ip);
80105938:	89 1c 24             	mov    %ebx,(%esp)
8010593b:	e8 20 c4 ff ff       	call   80101d60 <iunlockput>

  end_op();
80105940:	e8 2b db ff ff       	call   80103470 <end_op>

  return 0;
80105945:	83 c4 10             	add    $0x10,%esp
80105948:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010594a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010594d:	5b                   	pop    %ebx
8010594e:	5e                   	pop    %esi
8010594f:	5f                   	pop    %edi
80105950:	5d                   	pop    %ebp
80105951:	c3                   	ret    
80105952:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105958:	83 ec 0c             	sub    $0xc,%esp
8010595b:	53                   	push   %ebx
8010595c:	e8 6f fe ff ff       	call   801057d0 <isdirempty>
80105961:	83 c4 10             	add    $0x10,%esp
80105964:	85 c0                	test   %eax,%eax
80105966:	75 8b                	jne    801058f3 <sys_unlink+0xb3>
    iunlockput(ip);
80105968:	83 ec 0c             	sub    $0xc,%esp
8010596b:	53                   	push   %ebx
8010596c:	e8 ef c3 ff ff       	call   80101d60 <iunlockput>
    goto bad;
80105971:	83 c4 10             	add    $0x10,%esp
80105974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105978:	83 ec 0c             	sub    $0xc,%esp
8010597b:	56                   	push   %esi
8010597c:	e8 df c3 ff ff       	call   80101d60 <iunlockput>
  end_op();
80105981:	e8 ea da ff ff       	call   80103470 <end_op>
  return -1;
80105986:	83 c4 10             	add    $0x10,%esp
80105989:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010598e:	eb ba                	jmp    8010594a <sys_unlink+0x10a>
    dp->nlink--;
80105990:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105995:	83 ec 0c             	sub    $0xc,%esp
80105998:	56                   	push   %esi
80105999:	e8 82 c0 ff ff       	call   80101a20 <iupdate>
8010599e:	83 c4 10             	add    $0x10,%esp
801059a1:	e9 7c ff ff ff       	jmp    80105922 <sys_unlink+0xe2>
801059a6:	8d 76 00             	lea    0x0(%esi),%esi
801059a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801059b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059b5:	eb 93                	jmp    8010594a <sys_unlink+0x10a>
    end_op();
801059b7:	e8 b4 da ff ff       	call   80103470 <end_op>
    return -1;
801059bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059c1:	eb 87                	jmp    8010594a <sys_unlink+0x10a>
    panic("unlink: writei");
801059c3:	83 ec 0c             	sub    $0xc,%esp
801059c6:	68 11 88 10 80       	push   $0x80108811
801059cb:	e8 c0 a9 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801059d0:	83 ec 0c             	sub    $0xc,%esp
801059d3:	68 ff 87 10 80       	push   $0x801087ff
801059d8:	e8 b3 a9 ff ff       	call   80100390 <panic>
801059dd:	8d 76 00             	lea    0x0(%esi),%esi

801059e0 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	57                   	push   %edi
801059e4:	56                   	push   %esi
801059e5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801059e6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
801059e9:	83 ec 34             	sub    $0x34,%esp
801059ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801059ef:	8b 55 10             	mov    0x10(%ebp),%edx
801059f2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801059f5:	56                   	push   %esi
801059f6:	ff 75 08             	pushl  0x8(%ebp)
{
801059f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801059fc:	89 55 d0             	mov    %edx,-0x30(%ebp)
801059ff:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105a02:	e8 49 c9 ff ff       	call   80102350 <nameiparent>
80105a07:	83 c4 10             	add    $0x10,%esp
80105a0a:	85 c0                	test   %eax,%eax
80105a0c:	0f 84 4e 01 00 00    	je     80105b60 <create+0x180>
    return 0;
  ilock(dp);
80105a12:	83 ec 0c             	sub    $0xc,%esp
80105a15:	89 c3                	mov    %eax,%ebx
80105a17:	50                   	push   %eax
80105a18:	e8 b3 c0 ff ff       	call   80101ad0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105a1d:	83 c4 0c             	add    $0xc,%esp
80105a20:	6a 00                	push   $0x0
80105a22:	56                   	push   %esi
80105a23:	53                   	push   %ebx
80105a24:	e8 d7 c5 ff ff       	call   80102000 <dirlookup>
80105a29:	83 c4 10             	add    $0x10,%esp
80105a2c:	85 c0                	test   %eax,%eax
80105a2e:	89 c7                	mov    %eax,%edi
80105a30:	74 3e                	je     80105a70 <create+0x90>
    iunlockput(dp);
80105a32:	83 ec 0c             	sub    $0xc,%esp
80105a35:	53                   	push   %ebx
80105a36:	e8 25 c3 ff ff       	call   80101d60 <iunlockput>
    ilock(ip);
80105a3b:	89 3c 24             	mov    %edi,(%esp)
80105a3e:	e8 8d c0 ff ff       	call   80101ad0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105a43:	83 c4 10             	add    $0x10,%esp
80105a46:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105a4b:	0f 85 9f 00 00 00    	jne    80105af0 <create+0x110>
80105a51:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105a56:	0f 85 94 00 00 00    	jne    80105af0 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a5f:	89 f8                	mov    %edi,%eax
80105a61:	5b                   	pop    %ebx
80105a62:	5e                   	pop    %esi
80105a63:	5f                   	pop    %edi
80105a64:	5d                   	pop    %ebp
80105a65:	c3                   	ret    
80105a66:	8d 76 00             	lea    0x0(%esi),%esi
80105a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = ialloc(dp->dev, type)) == 0)
80105a70:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105a74:	83 ec 08             	sub    $0x8,%esp
80105a77:	50                   	push   %eax
80105a78:	ff 33                	pushl  (%ebx)
80105a7a:	e8 e1 be ff ff       	call   80101960 <ialloc>
80105a7f:	83 c4 10             	add    $0x10,%esp
80105a82:	85 c0                	test   %eax,%eax
80105a84:	89 c7                	mov    %eax,%edi
80105a86:	0f 84 e8 00 00 00    	je     80105b74 <create+0x194>
  ilock(ip);
80105a8c:	83 ec 0c             	sub    $0xc,%esp
80105a8f:	50                   	push   %eax
80105a90:	e8 3b c0 ff ff       	call   80101ad0 <ilock>
  ip->major = major;
80105a95:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105a99:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80105a9d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105aa1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105aa5:	b8 01 00 00 00       	mov    $0x1,%eax
80105aaa:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80105aae:	89 3c 24             	mov    %edi,(%esp)
80105ab1:	e8 6a bf ff ff       	call   80101a20 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105ab6:	83 c4 10             	add    $0x10,%esp
80105ab9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105abe:	74 50                	je     80105b10 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105ac0:	83 ec 04             	sub    $0x4,%esp
80105ac3:	ff 77 04             	pushl  0x4(%edi)
80105ac6:	56                   	push   %esi
80105ac7:	53                   	push   %ebx
80105ac8:	e8 a3 c7 ff ff       	call   80102270 <dirlink>
80105acd:	83 c4 10             	add    $0x10,%esp
80105ad0:	85 c0                	test   %eax,%eax
80105ad2:	0f 88 8f 00 00 00    	js     80105b67 <create+0x187>
  iunlockput(dp);
80105ad8:	83 ec 0c             	sub    $0xc,%esp
80105adb:	53                   	push   %ebx
80105adc:	e8 7f c2 ff ff       	call   80101d60 <iunlockput>
  return ip;
80105ae1:	83 c4 10             	add    $0x10,%esp
}
80105ae4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ae7:	89 f8                	mov    %edi,%eax
80105ae9:	5b                   	pop    %ebx
80105aea:	5e                   	pop    %esi
80105aeb:	5f                   	pop    %edi
80105aec:	5d                   	pop    %ebp
80105aed:	c3                   	ret    
80105aee:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105af0:	83 ec 0c             	sub    $0xc,%esp
80105af3:	57                   	push   %edi
    return 0;
80105af4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105af6:	e8 65 c2 ff ff       	call   80101d60 <iunlockput>
    return 0;
80105afb:	83 c4 10             	add    $0x10,%esp
}
80105afe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b01:	89 f8                	mov    %edi,%eax
80105b03:	5b                   	pop    %ebx
80105b04:	5e                   	pop    %esi
80105b05:	5f                   	pop    %edi
80105b06:	5d                   	pop    %ebp
80105b07:	c3                   	ret    
80105b08:	90                   	nop
80105b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105b10:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105b15:	83 ec 0c             	sub    $0xc,%esp
80105b18:	53                   	push   %ebx
80105b19:	e8 02 bf ff ff       	call   80101a20 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105b1e:	83 c4 0c             	add    $0xc,%esp
80105b21:	ff 77 04             	pushl  0x4(%edi)
80105b24:	68 fd 87 10 80       	push   $0x801087fd
80105b29:	57                   	push   %edi
80105b2a:	e8 41 c7 ff ff       	call   80102270 <dirlink>
80105b2f:	83 c4 10             	add    $0x10,%esp
80105b32:	85 c0                	test   %eax,%eax
80105b34:	78 1c                	js     80105b52 <create+0x172>
80105b36:	83 ec 04             	sub    $0x4,%esp
80105b39:	ff 73 04             	pushl  0x4(%ebx)
80105b3c:	68 fc 87 10 80       	push   $0x801087fc
80105b41:	57                   	push   %edi
80105b42:	e8 29 c7 ff ff       	call   80102270 <dirlink>
80105b47:	83 c4 10             	add    $0x10,%esp
80105b4a:	85 c0                	test   %eax,%eax
80105b4c:	0f 89 6e ff ff ff    	jns    80105ac0 <create+0xe0>
      panic("create dots");
80105b52:	83 ec 0c             	sub    $0xc,%esp
80105b55:	68 9d 8e 10 80       	push   $0x80108e9d
80105b5a:	e8 31 a8 ff ff       	call   80100390 <panic>
80105b5f:	90                   	nop
    return 0;
80105b60:	31 ff                	xor    %edi,%edi
80105b62:	e9 f5 fe ff ff       	jmp    80105a5c <create+0x7c>
    panic("create: dirlink");
80105b67:	83 ec 0c             	sub    $0xc,%esp
80105b6a:	68 a9 8e 10 80       	push   $0x80108ea9
80105b6f:	e8 1c a8 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105b74:	83 ec 0c             	sub    $0xc,%esp
80105b77:	68 8e 8e 10 80       	push   $0x80108e8e
80105b7c:	e8 0f a8 ff ff       	call   80100390 <panic>
80105b81:	eb 0d                	jmp    80105b90 <sys_open>
80105b83:	90                   	nop
80105b84:	90                   	nop
80105b85:	90                   	nop
80105b86:	90                   	nop
80105b87:	90                   	nop
80105b88:	90                   	nop
80105b89:	90                   	nop
80105b8a:	90                   	nop
80105b8b:	90                   	nop
80105b8c:	90                   	nop
80105b8d:	90                   	nop
80105b8e:	90                   	nop
80105b8f:	90                   	nop

80105b90 <sys_open>:

int
sys_open(void)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	57                   	push   %edi
80105b94:	56                   	push   %esi
80105b95:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105b96:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105b99:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105b9c:	50                   	push   %eax
80105b9d:	6a 00                	push   $0x0
80105b9f:	e8 fc f7 ff ff       	call   801053a0 <argstr>
80105ba4:	83 c4 10             	add    $0x10,%esp
80105ba7:	85 c0                	test   %eax,%eax
80105ba9:	0f 88 1d 01 00 00    	js     80105ccc <sys_open+0x13c>
80105baf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105bb2:	83 ec 08             	sub    $0x8,%esp
80105bb5:	50                   	push   %eax
80105bb6:	6a 01                	push   $0x1
80105bb8:	e8 33 f7 ff ff       	call   801052f0 <argint>
80105bbd:	83 c4 10             	add    $0x10,%esp
80105bc0:	85 c0                	test   %eax,%eax
80105bc2:	0f 88 04 01 00 00    	js     80105ccc <sys_open+0x13c>
    return -1;

  begin_op();
80105bc8:	e8 33 d8 ff ff       	call   80103400 <begin_op>

  if(omode & O_CREATE){
80105bcd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105bd1:	0f 85 a9 00 00 00    	jne    80105c80 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105bd7:	83 ec 0c             	sub    $0xc,%esp
80105bda:	ff 75 e0             	pushl  -0x20(%ebp)
80105bdd:	e8 4e c7 ff ff       	call   80102330 <namei>
80105be2:	83 c4 10             	add    $0x10,%esp
80105be5:	85 c0                	test   %eax,%eax
80105be7:	89 c6                	mov    %eax,%esi
80105be9:	0f 84 ac 00 00 00    	je     80105c9b <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
80105bef:	83 ec 0c             	sub    $0xc,%esp
80105bf2:	50                   	push   %eax
80105bf3:	e8 d8 be ff ff       	call   80101ad0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105bf8:	83 c4 10             	add    $0x10,%esp
80105bfb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105c00:	0f 84 aa 00 00 00    	je     80105cb0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105c06:	e8 c5 b5 ff ff       	call   801011d0 <filealloc>
80105c0b:	85 c0                	test   %eax,%eax
80105c0d:	89 c7                	mov    %eax,%edi
80105c0f:	0f 84 a6 00 00 00    	je     80105cbb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105c15:	e8 a6 e4 ff ff       	call   801040c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105c1a:	31 db                	xor    %ebx,%ebx
80105c1c:	eb 0e                	jmp    80105c2c <sys_open+0x9c>
80105c1e:	66 90                	xchg   %ax,%ax
80105c20:	83 c3 01             	add    $0x1,%ebx
80105c23:	83 fb 10             	cmp    $0x10,%ebx
80105c26:	0f 84 ac 00 00 00    	je     80105cd8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105c2c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105c30:	85 d2                	test   %edx,%edx
80105c32:	75 ec                	jne    80105c20 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105c34:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105c37:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105c3b:	56                   	push   %esi
80105c3c:	e8 6f bf ff ff       	call   80101bb0 <iunlock>
  end_op();
80105c41:	e8 2a d8 ff ff       	call   80103470 <end_op>

  f->type = FD_INODE;
80105c46:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105c4c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105c4f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105c52:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105c55:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105c5c:	89 d0                	mov    %edx,%eax
80105c5e:	f7 d0                	not    %eax
80105c60:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105c63:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105c66:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105c69:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105c6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c70:	89 d8                	mov    %ebx,%eax
80105c72:	5b                   	pop    %ebx
80105c73:	5e                   	pop    %esi
80105c74:	5f                   	pop    %edi
80105c75:	5d                   	pop    %ebp
80105c76:	c3                   	ret    
80105c77:	89 f6                	mov    %esi,%esi
80105c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105c80:	6a 00                	push   $0x0
80105c82:	6a 00                	push   $0x0
80105c84:	6a 02                	push   $0x2
80105c86:	ff 75 e0             	pushl  -0x20(%ebp)
80105c89:	e8 52 fd ff ff       	call   801059e0 <create>
    if(ip == 0){
80105c8e:	83 c4 10             	add    $0x10,%esp
80105c91:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105c93:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105c95:	0f 85 6b ff ff ff    	jne    80105c06 <sys_open+0x76>
      end_op();
80105c9b:	e8 d0 d7 ff ff       	call   80103470 <end_op>
      return -1;
80105ca0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ca5:	eb c6                	jmp    80105c6d <sys_open+0xdd>
80105ca7:	89 f6                	mov    %esi,%esi
80105ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105cb0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105cb3:	85 c9                	test   %ecx,%ecx
80105cb5:	0f 84 4b ff ff ff    	je     80105c06 <sys_open+0x76>
    iunlockput(ip);
80105cbb:	83 ec 0c             	sub    $0xc,%esp
80105cbe:	56                   	push   %esi
80105cbf:	e8 9c c0 ff ff       	call   80101d60 <iunlockput>
    end_op();
80105cc4:	e8 a7 d7 ff ff       	call   80103470 <end_op>
    return -1;
80105cc9:	83 c4 10             	add    $0x10,%esp
80105ccc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105cd1:	eb 9a                	jmp    80105c6d <sys_open+0xdd>
80105cd3:	90                   	nop
80105cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105cd8:	83 ec 0c             	sub    $0xc,%esp
80105cdb:	57                   	push   %edi
80105cdc:	e8 af b5 ff ff       	call   80101290 <fileclose>
80105ce1:	83 c4 10             	add    $0x10,%esp
80105ce4:	eb d5                	jmp    80105cbb <sys_open+0x12b>
80105ce6:	8d 76 00             	lea    0x0(%esi),%esi
80105ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105cf0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105cf0:	55                   	push   %ebp
80105cf1:	89 e5                	mov    %esp,%ebp
80105cf3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105cf6:	e8 05 d7 ff ff       	call   80103400 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105cfb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cfe:	83 ec 08             	sub    $0x8,%esp
80105d01:	50                   	push   %eax
80105d02:	6a 00                	push   $0x0
80105d04:	e8 97 f6 ff ff       	call   801053a0 <argstr>
80105d09:	83 c4 10             	add    $0x10,%esp
80105d0c:	85 c0                	test   %eax,%eax
80105d0e:	78 30                	js     80105d40 <sys_mkdir+0x50>
80105d10:	6a 00                	push   $0x0
80105d12:	6a 00                	push   $0x0
80105d14:	6a 01                	push   $0x1
80105d16:	ff 75 f4             	pushl  -0xc(%ebp)
80105d19:	e8 c2 fc ff ff       	call   801059e0 <create>
80105d1e:	83 c4 10             	add    $0x10,%esp
80105d21:	85 c0                	test   %eax,%eax
80105d23:	74 1b                	je     80105d40 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105d25:	83 ec 0c             	sub    $0xc,%esp
80105d28:	50                   	push   %eax
80105d29:	e8 32 c0 ff ff       	call   80101d60 <iunlockput>
  end_op();
80105d2e:	e8 3d d7 ff ff       	call   80103470 <end_op>
  return 0;
80105d33:	83 c4 10             	add    $0x10,%esp
80105d36:	31 c0                	xor    %eax,%eax
}
80105d38:	c9                   	leave  
80105d39:	c3                   	ret    
80105d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105d40:	e8 2b d7 ff ff       	call   80103470 <end_op>
    return -1;
80105d45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d4a:	c9                   	leave  
80105d4b:	c3                   	ret    
80105d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d50 <sys_mknod>:

int
sys_mknod(void)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
80105d53:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105d56:	e8 a5 d6 ff ff       	call   80103400 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105d5b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d5e:	83 ec 08             	sub    $0x8,%esp
80105d61:	50                   	push   %eax
80105d62:	6a 00                	push   $0x0
80105d64:	e8 37 f6 ff ff       	call   801053a0 <argstr>
80105d69:	83 c4 10             	add    $0x10,%esp
80105d6c:	85 c0                	test   %eax,%eax
80105d6e:	78 60                	js     80105dd0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105d70:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d73:	83 ec 08             	sub    $0x8,%esp
80105d76:	50                   	push   %eax
80105d77:	6a 01                	push   $0x1
80105d79:	e8 72 f5 ff ff       	call   801052f0 <argint>
  if((argstr(0, &path)) < 0 ||
80105d7e:	83 c4 10             	add    $0x10,%esp
80105d81:	85 c0                	test   %eax,%eax
80105d83:	78 4b                	js     80105dd0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105d85:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d88:	83 ec 08             	sub    $0x8,%esp
80105d8b:	50                   	push   %eax
80105d8c:	6a 02                	push   $0x2
80105d8e:	e8 5d f5 ff ff       	call   801052f0 <argint>
     argint(1, &major) < 0 ||
80105d93:	83 c4 10             	add    $0x10,%esp
80105d96:	85 c0                	test   %eax,%eax
80105d98:	78 36                	js     80105dd0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105d9a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105d9e:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
80105d9f:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
80105da3:	50                   	push   %eax
80105da4:	6a 03                	push   $0x3
80105da6:	ff 75 ec             	pushl  -0x14(%ebp)
80105da9:	e8 32 fc ff ff       	call   801059e0 <create>
80105dae:	83 c4 10             	add    $0x10,%esp
80105db1:	85 c0                	test   %eax,%eax
80105db3:	74 1b                	je     80105dd0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105db5:	83 ec 0c             	sub    $0xc,%esp
80105db8:	50                   	push   %eax
80105db9:	e8 a2 bf ff ff       	call   80101d60 <iunlockput>
  end_op();
80105dbe:	e8 ad d6 ff ff       	call   80103470 <end_op>
  return 0;
80105dc3:	83 c4 10             	add    $0x10,%esp
80105dc6:	31 c0                	xor    %eax,%eax
}
80105dc8:	c9                   	leave  
80105dc9:	c3                   	ret    
80105dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105dd0:	e8 9b d6 ff ff       	call   80103470 <end_op>
    return -1;
80105dd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dda:	c9                   	leave  
80105ddb:	c3                   	ret    
80105ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105de0 <sys_chdir>:

int
sys_chdir(void)
{
80105de0:	55                   	push   %ebp
80105de1:	89 e5                	mov    %esp,%ebp
80105de3:	56                   	push   %esi
80105de4:	53                   	push   %ebx
80105de5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105de8:	e8 d3 e2 ff ff       	call   801040c0 <myproc>
80105ded:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105def:	e8 0c d6 ff ff       	call   80103400 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105df4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105df7:	83 ec 08             	sub    $0x8,%esp
80105dfa:	50                   	push   %eax
80105dfb:	6a 00                	push   $0x0
80105dfd:	e8 9e f5 ff ff       	call   801053a0 <argstr>
80105e02:	83 c4 10             	add    $0x10,%esp
80105e05:	85 c0                	test   %eax,%eax
80105e07:	78 77                	js     80105e80 <sys_chdir+0xa0>
80105e09:	83 ec 0c             	sub    $0xc,%esp
80105e0c:	ff 75 f4             	pushl  -0xc(%ebp)
80105e0f:	e8 1c c5 ff ff       	call   80102330 <namei>
80105e14:	83 c4 10             	add    $0x10,%esp
80105e17:	85 c0                	test   %eax,%eax
80105e19:	89 c3                	mov    %eax,%ebx
80105e1b:	74 63                	je     80105e80 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105e1d:	83 ec 0c             	sub    $0xc,%esp
80105e20:	50                   	push   %eax
80105e21:	e8 aa bc ff ff       	call   80101ad0 <ilock>
  if(ip->type != T_DIR){
80105e26:	83 c4 10             	add    $0x10,%esp
80105e29:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105e2e:	75 30                	jne    80105e60 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105e30:	83 ec 0c             	sub    $0xc,%esp
80105e33:	53                   	push   %ebx
80105e34:	e8 77 bd ff ff       	call   80101bb0 <iunlock>
  iput(curproc->cwd);
80105e39:	58                   	pop    %eax
80105e3a:	ff 76 68             	pushl  0x68(%esi)
80105e3d:	e8 be bd ff ff       	call   80101c00 <iput>
  end_op();
80105e42:	e8 29 d6 ff ff       	call   80103470 <end_op>
  curproc->cwd = ip;
80105e47:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105e4a:	83 c4 10             	add    $0x10,%esp
80105e4d:	31 c0                	xor    %eax,%eax
}
80105e4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e52:	5b                   	pop    %ebx
80105e53:	5e                   	pop    %esi
80105e54:	5d                   	pop    %ebp
80105e55:	c3                   	ret    
80105e56:	8d 76 00             	lea    0x0(%esi),%esi
80105e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105e60:	83 ec 0c             	sub    $0xc,%esp
80105e63:	53                   	push   %ebx
80105e64:	e8 f7 be ff ff       	call   80101d60 <iunlockput>
    end_op();
80105e69:	e8 02 d6 ff ff       	call   80103470 <end_op>
    return -1;
80105e6e:	83 c4 10             	add    $0x10,%esp
80105e71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e76:	eb d7                	jmp    80105e4f <sys_chdir+0x6f>
80105e78:	90                   	nop
80105e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105e80:	e8 eb d5 ff ff       	call   80103470 <end_op>
    return -1;
80105e85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e8a:	eb c3                	jmp    80105e4f <sys_chdir+0x6f>
80105e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e90 <sys_exec>:

int
sys_exec(void)
{
80105e90:	55                   	push   %ebp
80105e91:	89 e5                	mov    %esp,%ebp
80105e93:	57                   	push   %edi
80105e94:	56                   	push   %esi
80105e95:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105e96:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105e9c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ea2:	50                   	push   %eax
80105ea3:	6a 00                	push   $0x0
80105ea5:	e8 f6 f4 ff ff       	call   801053a0 <argstr>
80105eaa:	83 c4 10             	add    $0x10,%esp
80105ead:	85 c0                	test   %eax,%eax
80105eaf:	0f 88 87 00 00 00    	js     80105f3c <sys_exec+0xac>
80105eb5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105ebb:	83 ec 08             	sub    $0x8,%esp
80105ebe:	50                   	push   %eax
80105ebf:	6a 01                	push   $0x1
80105ec1:	e8 2a f4 ff ff       	call   801052f0 <argint>
80105ec6:	83 c4 10             	add    $0x10,%esp
80105ec9:	85 c0                	test   %eax,%eax
80105ecb:	78 6f                	js     80105f3c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105ecd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105ed3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105ed6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105ed8:	68 80 00 00 00       	push   $0x80
80105edd:	6a 00                	push   $0x0
80105edf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105ee5:	50                   	push   %eax
80105ee6:	e8 05 f1 ff ff       	call   80104ff0 <memset>
80105eeb:	83 c4 10             	add    $0x10,%esp
80105eee:	eb 2c                	jmp    80105f1c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105ef0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105ef6:	85 c0                	test   %eax,%eax
80105ef8:	74 56                	je     80105f50 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105efa:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105f00:	83 ec 08             	sub    $0x8,%esp
80105f03:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105f06:	52                   	push   %edx
80105f07:	50                   	push   %eax
80105f08:	e8 73 f3 ff ff       	call   80105280 <fetchstr>
80105f0d:	83 c4 10             	add    $0x10,%esp
80105f10:	85 c0                	test   %eax,%eax
80105f12:	78 28                	js     80105f3c <sys_exec+0xac>
  for(i=0;; i++){
80105f14:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105f17:	83 fb 20             	cmp    $0x20,%ebx
80105f1a:	74 20                	je     80105f3c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105f1c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105f22:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105f29:	83 ec 08             	sub    $0x8,%esp
80105f2c:	57                   	push   %edi
80105f2d:	01 f0                	add    %esi,%eax
80105f2f:	50                   	push   %eax
80105f30:	e8 0b f3 ff ff       	call   80105240 <fetchint>
80105f35:	83 c4 10             	add    $0x10,%esp
80105f38:	85 c0                	test   %eax,%eax
80105f3a:	79 b4                	jns    80105ef0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105f3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f44:	5b                   	pop    %ebx
80105f45:	5e                   	pop    %esi
80105f46:	5f                   	pop    %edi
80105f47:	5d                   	pop    %ebp
80105f48:	c3                   	ret    
80105f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105f50:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105f56:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105f59:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105f60:	00 00 00 00 
  return exec(path, argv);
80105f64:	50                   	push   %eax
80105f65:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105f6b:	e8 40 ab ff ff       	call   80100ab0 <exec>
80105f70:	83 c4 10             	add    $0x10,%esp
}
80105f73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f76:	5b                   	pop    %ebx
80105f77:	5e                   	pop    %esi
80105f78:	5f                   	pop    %edi
80105f79:	5d                   	pop    %ebp
80105f7a:	c3                   	ret    
80105f7b:	90                   	nop
80105f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f80 <sys_pipe>:

int
sys_pipe(void)
{
80105f80:	55                   	push   %ebp
80105f81:	89 e5                	mov    %esp,%ebp
80105f83:	57                   	push   %edi
80105f84:	56                   	push   %esi
80105f85:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105f86:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105f89:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105f8c:	6a 08                	push   $0x8
80105f8e:	50                   	push   %eax
80105f8f:	6a 00                	push   $0x0
80105f91:	e8 aa f3 ff ff       	call   80105340 <argptr>
80105f96:	83 c4 10             	add    $0x10,%esp
80105f99:	85 c0                	test   %eax,%eax
80105f9b:	0f 88 ae 00 00 00    	js     8010604f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105fa1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105fa4:	83 ec 08             	sub    $0x8,%esp
80105fa7:	50                   	push   %eax
80105fa8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105fab:	50                   	push   %eax
80105fac:	e8 ef da ff ff       	call   80103aa0 <pipealloc>
80105fb1:	83 c4 10             	add    $0x10,%esp
80105fb4:	85 c0                	test   %eax,%eax
80105fb6:	0f 88 93 00 00 00    	js     8010604f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105fbc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105fbf:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105fc1:	e8 fa e0 ff ff       	call   801040c0 <myproc>
80105fc6:	eb 10                	jmp    80105fd8 <sys_pipe+0x58>
80105fc8:	90                   	nop
80105fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105fd0:	83 c3 01             	add    $0x1,%ebx
80105fd3:	83 fb 10             	cmp    $0x10,%ebx
80105fd6:	74 60                	je     80106038 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105fd8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105fdc:	85 f6                	test   %esi,%esi
80105fde:	75 f0                	jne    80105fd0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105fe0:	8d 73 08             	lea    0x8(%ebx),%esi
80105fe3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105fe7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105fea:	e8 d1 e0 ff ff       	call   801040c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105fef:	31 d2                	xor    %edx,%edx
80105ff1:	eb 0d                	jmp    80106000 <sys_pipe+0x80>
80105ff3:	90                   	nop
80105ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ff8:	83 c2 01             	add    $0x1,%edx
80105ffb:	83 fa 10             	cmp    $0x10,%edx
80105ffe:	74 28                	je     80106028 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80106000:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80106004:	85 c9                	test   %ecx,%ecx
80106006:	75 f0                	jne    80105ff8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80106008:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010600c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010600f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106011:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106014:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106017:	31 c0                	xor    %eax,%eax
}
80106019:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010601c:	5b                   	pop    %ebx
8010601d:	5e                   	pop    %esi
8010601e:	5f                   	pop    %edi
8010601f:	5d                   	pop    %ebp
80106020:	c3                   	ret    
80106021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80106028:	e8 93 e0 ff ff       	call   801040c0 <myproc>
8010602d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106034:	00 
80106035:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80106038:	83 ec 0c             	sub    $0xc,%esp
8010603b:	ff 75 e0             	pushl  -0x20(%ebp)
8010603e:	e8 4d b2 ff ff       	call   80101290 <fileclose>
    fileclose(wf);
80106043:	58                   	pop    %eax
80106044:	ff 75 e4             	pushl  -0x1c(%ebp)
80106047:	e8 44 b2 ff ff       	call   80101290 <fileclose>
    return -1;
8010604c:	83 c4 10             	add    $0x10,%esp
8010604f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106054:	eb c3                	jmp    80106019 <sys_pipe+0x99>
80106056:	66 90                	xchg   %ax,%ax
80106058:	66 90                	xchg   %ax,%ax
8010605a:	66 90                	xchg   %ax,%ax
8010605c:	66 90                	xchg   %ax,%ax
8010605e:	66 90                	xchg   %ax,%ax

80106060 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106060:	55                   	push   %ebp
80106061:	89 e5                	mov    %esp,%ebp
  return fork();
}
80106063:	5d                   	pop    %ebp
  return fork();
80106064:	e9 27 e2 ff ff       	jmp    80104290 <fork>
80106069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106070 <sys_exit>:

int
sys_exit(void)
{
80106070:	55                   	push   %ebp
80106071:	89 e5                	mov    %esp,%ebp
80106073:	83 ec 08             	sub    $0x8,%esp
  exit();
80106076:	e8 15 e6 ff ff       	call   80104690 <exit>
  return 0;  // not reached
}
8010607b:	31 c0                	xor    %eax,%eax
8010607d:	c9                   	leave  
8010607e:	c3                   	ret    
8010607f:	90                   	nop

80106080 <sys_wait>:

int
sys_wait(void)
{
80106080:	55                   	push   %ebp
80106081:	89 e5                	mov    %esp,%ebp
  return wait();
}
80106083:	5d                   	pop    %ebp
  return wait();
80106084:	e9 57 e8 ff ff       	jmp    801048e0 <wait>
80106089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106090 <sys_kill>:

int
sys_kill(void)
{
80106090:	55                   	push   %ebp
80106091:	89 e5                	mov    %esp,%ebp
80106093:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106096:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106099:	50                   	push   %eax
8010609a:	6a 00                	push   $0x0
8010609c:	e8 4f f2 ff ff       	call   801052f0 <argint>
801060a1:	83 c4 10             	add    $0x10,%esp
801060a4:	85 c0                	test   %eax,%eax
801060a6:	78 18                	js     801060c0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801060a8:	83 ec 0c             	sub    $0xc,%esp
801060ab:	ff 75 f4             	pushl  -0xc(%ebp)
801060ae:	e8 1d ea ff ff       	call   80104ad0 <kill>
801060b3:	83 c4 10             	add    $0x10,%esp
}
801060b6:	c9                   	leave  
801060b7:	c3                   	ret    
801060b8:	90                   	nop
801060b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801060c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060c5:	c9                   	leave  
801060c6:	c3                   	ret    
801060c7:	89 f6                	mov    %esi,%esi
801060c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801060d0 <sys_getpid>:

int
sys_getpid(void)
{
801060d0:	55                   	push   %ebp
801060d1:	89 e5                	mov    %esp,%ebp
801060d3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801060d6:	e8 e5 df ff ff       	call   801040c0 <myproc>
801060db:	8b 40 10             	mov    0x10(%eax),%eax
}
801060de:	c9                   	leave  
801060df:	c3                   	ret    

801060e0 <sys_sbrk>:

int
sys_sbrk(void)
{
801060e0:	55                   	push   %ebp
801060e1:	89 e5                	mov    %esp,%ebp
801060e3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801060e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801060e7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801060ea:	50                   	push   %eax
801060eb:	6a 00                	push   $0x0
801060ed:	e8 fe f1 ff ff       	call   801052f0 <argint>
801060f2:	83 c4 10             	add    $0x10,%esp
801060f5:	85 c0                	test   %eax,%eax
801060f7:	78 27                	js     80106120 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801060f9:	e8 c2 df ff ff       	call   801040c0 <myproc>
  if(growproc(n) < 0)
801060fe:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106101:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106103:	ff 75 f4             	pushl  -0xc(%ebp)
80106106:	e8 d5 e0 ff ff       	call   801041e0 <growproc>
8010610b:	83 c4 10             	add    $0x10,%esp
8010610e:	85 c0                	test   %eax,%eax
80106110:	78 0e                	js     80106120 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106112:	89 d8                	mov    %ebx,%eax
80106114:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106117:	c9                   	leave  
80106118:	c3                   	ret    
80106119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106120:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106125:	eb eb                	jmp    80106112 <sys_sbrk+0x32>
80106127:	89 f6                	mov    %esi,%esi
80106129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106130 <sys_sleep>:

int
sys_sleep(void)
{
80106130:	55                   	push   %ebp
80106131:	89 e5                	mov    %esp,%ebp
80106133:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106134:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106137:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010613a:	50                   	push   %eax
8010613b:	6a 00                	push   $0x0
8010613d:	e8 ae f1 ff ff       	call   801052f0 <argint>
80106142:	83 c4 10             	add    $0x10,%esp
80106145:	85 c0                	test   %eax,%eax
80106147:	0f 88 8a 00 00 00    	js     801061d7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010614d:	83 ec 0c             	sub    $0xc,%esp
80106150:	68 e0 21 13 80       	push   $0x801321e0
80106155:	e8 86 ed ff ff       	call   80104ee0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010615a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010615d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106160:	8b 1d 20 2a 13 80    	mov    0x80132a20,%ebx
  while(ticks - ticks0 < n){
80106166:	85 d2                	test   %edx,%edx
80106168:	75 27                	jne    80106191 <sys_sleep+0x61>
8010616a:	eb 54                	jmp    801061c0 <sys_sleep+0x90>
8010616c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106170:	83 ec 08             	sub    $0x8,%esp
80106173:	68 e0 21 13 80       	push   $0x801321e0
80106178:	68 20 2a 13 80       	push   $0x80132a20
8010617d:	e8 9e e6 ff ff       	call   80104820 <sleep>
  while(ticks - ticks0 < n){
80106182:	a1 20 2a 13 80       	mov    0x80132a20,%eax
80106187:	83 c4 10             	add    $0x10,%esp
8010618a:	29 d8                	sub    %ebx,%eax
8010618c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010618f:	73 2f                	jae    801061c0 <sys_sleep+0x90>
    if(myproc()->killed){
80106191:	e8 2a df ff ff       	call   801040c0 <myproc>
80106196:	8b 40 24             	mov    0x24(%eax),%eax
80106199:	85 c0                	test   %eax,%eax
8010619b:	74 d3                	je     80106170 <sys_sleep+0x40>
      release(&tickslock);
8010619d:	83 ec 0c             	sub    $0xc,%esp
801061a0:	68 e0 21 13 80       	push   $0x801321e0
801061a5:	e8 f6 ed ff ff       	call   80104fa0 <release>
      return -1;
801061aa:	83 c4 10             	add    $0x10,%esp
801061ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801061b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801061b5:	c9                   	leave  
801061b6:	c3                   	ret    
801061b7:	89 f6                	mov    %esi,%esi
801061b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
801061c0:	83 ec 0c             	sub    $0xc,%esp
801061c3:	68 e0 21 13 80       	push   $0x801321e0
801061c8:	e8 d3 ed ff ff       	call   80104fa0 <release>
  return 0;
801061cd:	83 c4 10             	add    $0x10,%esp
801061d0:	31 c0                	xor    %eax,%eax
}
801061d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801061d5:	c9                   	leave  
801061d6:	c3                   	ret    
    return -1;
801061d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061dc:	eb f4                	jmp    801061d2 <sys_sleep+0xa2>
801061de:	66 90                	xchg   %ax,%ax

801061e0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801061e0:	55                   	push   %ebp
801061e1:	89 e5                	mov    %esp,%ebp
801061e3:	53                   	push   %ebx
801061e4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801061e7:	68 e0 21 13 80       	push   $0x801321e0
801061ec:	e8 ef ec ff ff       	call   80104ee0 <acquire>
  xticks = ticks;
801061f1:	8b 1d 20 2a 13 80    	mov    0x80132a20,%ebx
  release(&tickslock);
801061f7:	c7 04 24 e0 21 13 80 	movl   $0x801321e0,(%esp)
801061fe:	e8 9d ed ff ff       	call   80104fa0 <release>
  return xticks;
}
80106203:	89 d8                	mov    %ebx,%eax
80106205:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106208:	c9                   	leave  
80106209:	c3                   	ret    
8010620a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106210 <sys_get_number_of_free_pages>:

int sys_get_number_of_free_pages(void){
80106210:	55                   	push   %ebp
80106211:	89 e5                	mov    %esp,%ebp
  return sys_get_number_of_free_pages_impl();
}
80106213:	5d                   	pop    %ebp
  return sys_get_number_of_free_pages_impl();
80106214:	e9 47 e0 ff ff       	jmp    80104260 <sys_get_number_of_free_pages_impl>

80106219 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106219:	1e                   	push   %ds
  pushl %es
8010621a:	06                   	push   %es
  pushl %fs
8010621b:	0f a0                	push   %fs
  pushl %gs
8010621d:	0f a8                	push   %gs
  pushal
8010621f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106220:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106224:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106226:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106228:	54                   	push   %esp
  call trap
80106229:	e8 c2 00 00 00       	call   801062f0 <trap>
  addl $4, %esp
8010622e:	83 c4 04             	add    $0x4,%esp

80106231 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106231:	61                   	popa   
  popl %gs
80106232:	0f a9                	pop    %gs
  popl %fs
80106234:	0f a1                	pop    %fs
  popl %es
80106236:	07                   	pop    %es
  popl %ds
80106237:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106238:	83 c4 08             	add    $0x8,%esp
  iret
8010623b:	cf                   	iret   
8010623c:	66 90                	xchg   %ax,%ax
8010623e:	66 90                	xchg   %ax,%ax

80106240 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106240:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106241:	31 c0                	xor    %eax,%eax
{
80106243:	89 e5                	mov    %esp,%ebp
80106245:	83 ec 08             	sub    $0x8,%esp
80106248:	90                   	nop
80106249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106250:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80106257:	c7 04 c5 22 22 13 80 	movl   $0x8e000008,-0x7fecddde(,%eax,8)
8010625e:	08 00 00 8e 
80106262:	66 89 14 c5 20 22 13 	mov    %dx,-0x7fecdde0(,%eax,8)
80106269:	80 
8010626a:	c1 ea 10             	shr    $0x10,%edx
8010626d:	66 89 14 c5 26 22 13 	mov    %dx,-0x7fecddda(,%eax,8)
80106274:	80 
  for(i = 0; i < 256; i++)
80106275:	83 c0 01             	add    $0x1,%eax
80106278:	3d 00 01 00 00       	cmp    $0x100,%eax
8010627d:	75 d1                	jne    80106250 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010627f:	a1 08 c1 10 80       	mov    0x8010c108,%eax

  initlock(&tickslock, "time");
80106284:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106287:	c7 05 22 24 13 80 08 	movl   $0xef000008,0x80132422
8010628e:	00 00 ef 
  initlock(&tickslock, "time");
80106291:	68 b9 8e 10 80       	push   $0x80108eb9
80106296:	68 e0 21 13 80       	push   $0x801321e0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010629b:	66 a3 20 24 13 80    	mov    %ax,0x80132420
801062a1:	c1 e8 10             	shr    $0x10,%eax
801062a4:	66 a3 26 24 13 80    	mov    %ax,0x80132426
  initlock(&tickslock, "time");
801062aa:	e8 f1 ea ff ff       	call   80104da0 <initlock>
}
801062af:	83 c4 10             	add    $0x10,%esp
801062b2:	c9                   	leave  
801062b3:	c3                   	ret    
801062b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801062ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801062c0 <idtinit>:

void
idtinit(void)
{
801062c0:	55                   	push   %ebp
  pd[0] = size-1;
801062c1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801062c6:	89 e5                	mov    %esp,%ebp
801062c8:	83 ec 10             	sub    $0x10,%esp
801062cb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801062cf:	b8 20 22 13 80       	mov    $0x80132220,%eax
801062d4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801062d8:	c1 e8 10             	shr    $0x10,%eax
801062db:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801062df:	8d 45 fa             	lea    -0x6(%ebp),%eax
801062e2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801062e5:	c9                   	leave  
801062e6:	c3                   	ret    
801062e7:	89 f6                	mov    %esi,%esi
801062e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801062f0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801062f0:	55                   	push   %ebp
801062f1:	89 e5                	mov    %esp,%ebp
801062f3:	57                   	push   %edi
801062f4:	56                   	push   %esi
801062f5:	53                   	push   %ebx
801062f6:	83 ec 2c             	sub    $0x2c,%esp
801062f9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801062fc:	8b 47 30             	mov    0x30(%edi),%eax
801062ff:	83 f8 40             	cmp    $0x40,%eax
80106302:	0f 84 58 01 00 00    	je     80106460 <trap+0x170>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106308:	83 e8 0e             	sub    $0xe,%eax
8010630b:	83 f8 31             	cmp    $0x31,%eax
8010630e:	77 75                	ja     80106385 <trap+0x95>
80106310:	ff 24 85 e0 8f 10 80 	jmp    *-0x7fef7020(,%eax,4)
80106317:	89 f6                	mov    %esi,%esi
80106319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106320:	8b 0d 00 00 00 00    	mov    0x0,%ecx
      }
      else{
        panic("ref count to page is 0 but it was reffed");
      }
    }
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106326:	8b 46 10             	mov    0x10(%esi),%eax
80106329:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010632c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010632f:	0f 20 d2             	mov    %cr2,%edx
80106332:	8b 77 38             	mov    0x38(%edi),%esi
80106335:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80106338:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010633b:	e8 60 dd ff ff       	call   801040a0 <cpuid>
80106340:	8b 5f 34             	mov    0x34(%edi),%ebx
80106343:	89 c6                	mov    %eax,%esi
80106345:	89 5d dc             	mov    %ebx,-0x24(%ebp)
80106348:	8b 5f 30             	mov    0x30(%edi),%ebx
            "eip 0x%x addr 0x%x pte %x pid %d --kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010634b:	e8 70 dd ff ff       	call   801040c0 <myproc>
80106350:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106353:	e8 68 dd ff ff       	call   801040c0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106358:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010635b:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010635e:	83 ec 08             	sub    $0x8,%esp
80106361:	ff 75 e4             	pushl  -0x1c(%ebp)
80106364:	51                   	push   %ecx
80106365:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106366:	8b 55 d8             	mov    -0x28(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106369:	ff 75 e0             	pushl  -0x20(%ebp)
8010636c:	56                   	push   %esi
8010636d:	ff 75 dc             	pushl  -0x24(%ebp)
80106370:	53                   	push   %ebx
            myproc()->pid, myproc()->name, tf->trapno,
80106371:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106374:	52                   	push   %edx
80106375:	ff 70 10             	pushl  0x10(%eax)
80106378:	68 14 8f 10 80       	push   $0x80108f14
8010637d:	e8 de a2 ff ff       	call   80100660 <cprintf>
80106382:	83 c4 30             	add    $0x30,%esp
            tf->err, cpuid(), tf->eip, rcr2(), *pte_ptr, p->pid);
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106385:	e8 36 dd ff ff       	call   801040c0 <myproc>
8010638a:	85 c0                	test   %eax,%eax
8010638c:	8b 5f 38             	mov    0x38(%edi),%ebx
8010638f:	0f 84 1b 03 00 00    	je     801066b0 <trap+0x3c0>
80106395:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106399:	0f 84 11 03 00 00    	je     801066b0 <trap+0x3c0>
8010639f:	0f 20 d1             	mov    %cr2,%ecx
801063a2:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063a5:	e8 f6 dc ff ff       	call   801040a0 <cpuid>
801063aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
801063ad:	8b 47 34             	mov    0x34(%edi),%eax
801063b0:	8b 77 30             	mov    0x30(%edi),%esi
801063b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801063b6:	e8 05 dd ff ff       	call   801040c0 <myproc>
801063bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
801063be:	e8 fd dc ff ff       	call   801040c0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063c3:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801063c6:	8b 55 dc             	mov    -0x24(%ebp),%edx
801063c9:	51                   	push   %ecx
801063ca:	53                   	push   %ebx
801063cb:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
801063cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063cf:	ff 75 e4             	pushl  -0x1c(%ebp)
801063d2:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801063d3:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063d6:	52                   	push   %edx
801063d7:	ff 70 10             	pushl  0x10(%eax)
801063da:	68 9c 8f 10 80       	push   $0x80108f9c
801063df:	e8 7c a2 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801063e4:	83 c4 20             	add    $0x20,%esp
801063e7:	e8 d4 dc ff ff       	call   801040c0 <myproc>
801063ec:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063f3:	e8 c8 dc ff ff       	call   801040c0 <myproc>
801063f8:	85 c0                	test   %eax,%eax
801063fa:	74 1d                	je     80106419 <trap+0x129>
801063fc:	e8 bf dc ff ff       	call   801040c0 <myproc>
80106401:	8b 50 24             	mov    0x24(%eax),%edx
80106404:	85 d2                	test   %edx,%edx
80106406:	74 11                	je     80106419 <trap+0x129>
80106408:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
8010640c:	83 e0 03             	and    $0x3,%eax
8010640f:	66 83 f8 03          	cmp    $0x3,%ax
80106413:	0f 84 e7 01 00 00    	je     80106600 <trap+0x310>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80106419:	e8 a2 dc ff ff       	call   801040c0 <myproc>
8010641e:	85 c0                	test   %eax,%eax
80106420:	74 0b                	je     8010642d <trap+0x13d>
80106422:	e8 99 dc ff ff       	call   801040c0 <myproc>
80106427:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010642b:	74 6b                	je     80106498 <trap+0x1a8>
      yield();
    }
    

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010642d:	e8 8e dc ff ff       	call   801040c0 <myproc>
80106432:	85 c0                	test   %eax,%eax
80106434:	74 19                	je     8010644f <trap+0x15f>
80106436:	e8 85 dc ff ff       	call   801040c0 <myproc>
8010643b:	8b 40 24             	mov    0x24(%eax),%eax
8010643e:	85 c0                	test   %eax,%eax
80106440:	74 0d                	je     8010644f <trap+0x15f>
80106442:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106446:	83 e0 03             	and    $0x3,%eax
80106449:	66 83 f8 03          	cmp    $0x3,%ax
8010644d:	74 3a                	je     80106489 <trap+0x199>
    exit();
}
8010644f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106452:	5b                   	pop    %ebx
80106453:	5e                   	pop    %esi
80106454:	5f                   	pop    %edi
80106455:	5d                   	pop    %ebp
80106456:	c3                   	ret    
80106457:	89 f6                	mov    %esi,%esi
80106459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(myproc()->killed)
80106460:	e8 5b dc ff ff       	call   801040c0 <myproc>
80106465:	8b 70 24             	mov    0x24(%eax),%esi
80106468:	85 f6                	test   %esi,%esi
8010646a:	0f 85 80 01 00 00    	jne    801065f0 <trap+0x300>
    myproc()->tf = tf;
80106470:	e8 4b dc ff ff       	call   801040c0 <myproc>
80106475:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106478:	e8 63 ef ff ff       	call   801053e0 <syscall>
    if(myproc()->killed)
8010647d:	e8 3e dc ff ff       	call   801040c0 <myproc>
80106482:	8b 58 24             	mov    0x24(%eax),%ebx
80106485:	85 db                	test   %ebx,%ebx
80106487:	74 c6                	je     8010644f <trap+0x15f>
}
80106489:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010648c:	5b                   	pop    %ebx
8010648d:	5e                   	pop    %esi
8010648e:	5f                   	pop    %edi
8010648f:	5d                   	pop    %ebp
          exit();
80106490:	e9 fb e1 ff ff       	jmp    80104690 <exit>
80106495:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80106498:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
8010649c:	75 8f                	jne    8010642d <trap+0x13d>
      yield();
8010649e:	e8 2d e3 ff ff       	call   801047d0 <yield>
801064a3:	eb 88                	jmp    8010642d <trap+0x13d>
801064a5:	8d 76 00             	lea    0x0(%esi),%esi
801064a8:	0f 20 d3             	mov    %cr2,%ebx
    struct proc* p = myproc();
801064ab:	e8 10 dc ff ff       	call   801040c0 <myproc>
    pte_t* pte_ptr = public_walkpgdir(p->pgdir, (void *)faulting_addr, 0);
801064b0:	83 ec 04             	sub    $0x4,%esp
    struct proc* p = myproc();
801064b3:	89 c6                	mov    %eax,%esi
    pte_t* pte_ptr = public_walkpgdir(p->pgdir, (void *)faulting_addr, 0);
801064b5:	6a 00                	push   $0x0
801064b7:	53                   	push   %ebx
801064b8:	ff 70 04             	pushl  0x4(%eax)
801064bb:	e8 c0 13 00 00       	call   80107880 <public_walkpgdir>
    if (!(pte_ptr == 0) && (*pte_ptr & PTE_U) && (*pte_ptr & PTE_PG)){
801064c0:	83 c4 10             	add    $0x10,%esp
801064c3:	85 c0                	test   %eax,%eax
801064c5:	0f 84 55 fe ff ff    	je     80106320 <trap+0x30>
801064cb:	8b 08                	mov    (%eax),%ecx
801064cd:	89 ca                	mov    %ecx,%edx
801064cf:	81 e2 04 02 00 00    	and    $0x204,%edx
801064d5:	81 fa 04 02 00 00    	cmp    $0x204,%edx
801064db:	0f 84 2f 01 00 00    	je     80106610 <trap+0x320>
    if (!(pte_ptr == 0) && *pte_ptr & PTE_COW){
801064e1:	f6 c5 08             	test   $0x8,%ch
801064e4:	0f 84 3c fe ff ff    	je     80106326 <trap+0x36>
      acquire(cow_lock);
801064ea:	83 ec 0c             	sub    $0xc,%esp
801064ed:	ff 35 40 ff 11 80    	pushl  0x8011ff40
801064f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801064f6:	e8 e5 e9 ff ff       	call   80104ee0 <acquire>
      char* ref_count = &(pg_ref_counts[PGROUNDDOWN(PTE_ADDR(*pte_ptr)) / PGSIZE]);
801064fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      if (*ref_count == 1){
801064fe:	83 c4 10             	add    $0x10,%esp
      char* ref_count = &(pg_ref_counts[PGROUNDDOWN(PTE_ADDR(*pte_ptr)) / PGSIZE]);
80106501:	8b 18                	mov    (%eax),%ebx
80106503:	89 d9                	mov    %ebx,%ecx
80106505:	c1 e9 0c             	shr    $0xc,%ecx
      if (*ref_count == 1){
80106508:	0f b6 91 40 1f 11 80 	movzbl -0x7feee0c0(%ecx),%edx
8010650f:	80 fa 01             	cmp    $0x1,%dl
80106512:	0f 84 7c 01 00 00    	je     80106694 <trap+0x3a4>
      else if (*ref_count > 1){
80106518:	0f 8e ba 01 00 00    	jle    801066d8 <trap+0x3e8>
        int result = copy_page(p->pgdir, pte_ptr);
8010651e:	83 ec 08             	sub    $0x8,%esp
        (*ref_count)--;
80106521:	83 ea 01             	sub    $0x1,%edx
        int result = copy_page(p->pgdir, pte_ptr);
80106524:	50                   	push   %eax
        (*ref_count)--;
80106525:	88 91 40 1f 11 80    	mov    %dl,-0x7feee0c0(%ecx)
        int result = copy_page(p->pgdir, pte_ptr);
8010652b:	ff 76 04             	pushl  0x4(%esi)
8010652e:	e8 dd 20 00 00       	call   80108610 <copy_page>
        release(cow_lock);
80106533:	59                   	pop    %ecx
80106534:	ff 35 40 ff 11 80    	pushl  0x8011ff40
        int result = copy_page(p->pgdir, pte_ptr);
8010653a:	89 c3                	mov    %eax,%ebx
        release(cow_lock);
8010653c:	e8 5f ea ff ff       	call   80104fa0 <release>
        if (result < 0){
80106541:	83 c4 10             	add    $0x10,%esp
80106544:	85 db                	test   %ebx,%ebx
80106546:	0f 89 03 ff ff ff    	jns    8010644f <trap+0x15f>
          p->killed = 1;
8010654c:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
80106553:	e9 31 ff ff ff       	jmp    80106489 <trap+0x199>
80106558:	90                   	nop
80106559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106560:	e8 3b db ff ff       	call   801040a0 <cpuid>
80106565:	85 c0                	test   %eax,%eax
80106567:	0f 84 f3 00 00 00    	je     80106660 <trap+0x370>
    lapiceoi();
8010656d:	e8 3e ca ff ff       	call   80102fb0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106572:	e8 49 db ff ff       	call   801040c0 <myproc>
80106577:	85 c0                	test   %eax,%eax
80106579:	0f 85 7d fe ff ff    	jne    801063fc <trap+0x10c>
8010657f:	e9 95 fe ff ff       	jmp    80106419 <trap+0x129>
80106584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106588:	e8 d3 02 00 00       	call   80106860 <uartintr>
    lapiceoi();
8010658d:	e8 1e ca ff ff       	call   80102fb0 <lapiceoi>
    break;
80106592:	e9 5c fe ff ff       	jmp    801063f3 <trap+0x103>
80106597:	89 f6                	mov    %esi,%esi
80106599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801065a0:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801065a4:	8b 77 38             	mov    0x38(%edi),%esi
801065a7:	e8 f4 da ff ff       	call   801040a0 <cpuid>
801065ac:	56                   	push   %esi
801065ad:	53                   	push   %ebx
801065ae:	50                   	push   %eax
801065af:	68 c4 8e 10 80       	push   $0x80108ec4
801065b4:	e8 a7 a0 ff ff       	call   80100660 <cprintf>
    lapiceoi();
801065b9:	e8 f2 c9 ff ff       	call   80102fb0 <lapiceoi>
    break;
801065be:	83 c4 10             	add    $0x10,%esp
801065c1:	e9 2d fe ff ff       	jmp    801063f3 <trap+0x103>
801065c6:	8d 76 00             	lea    0x0(%esi),%esi
801065c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
801065d0:	e8 8b c2 ff ff       	call   80102860 <ideintr>
801065d5:	eb 96                	jmp    8010656d <trap+0x27d>
801065d7:	89 f6                	mov    %esi,%esi
801065d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    kbdintr();
801065e0:	e8 8b c8 ff ff       	call   80102e70 <kbdintr>
    lapiceoi();
801065e5:	e8 c6 c9 ff ff       	call   80102fb0 <lapiceoi>
    break;
801065ea:	e9 04 fe ff ff       	jmp    801063f3 <trap+0x103>
801065ef:	90                   	nop
      exit();
801065f0:	e8 9b e0 ff ff       	call   80104690 <exit>
801065f5:	e9 76 fe ff ff       	jmp    80106470 <trap+0x180>
801065fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106600:	e8 8b e0 ff ff       	call   80104690 <exit>
80106605:	e9 0f fe ff ff       	jmp    80106419 <trap+0x129>
8010660a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106610:	8d 96 90 00 00 00    	lea    0x90(%esi),%edx
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
80106616:	31 c0                	xor    %eax,%eax
80106618:	eb 11                	jmp    8010662b <trap+0x33b>
8010661a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106620:	83 c0 01             	add    $0x1,%eax
80106623:	83 c2 18             	add    $0x18,%edx
80106626:	83 f8 10             	cmp    $0x10,%eax
80106629:	74 23                	je     8010664e <trap+0x35e>
        if (PGROUNDDOWN((uint)(p->swapped_out_pages[i].va)) == PGROUNDDOWN(faulting_addr)){
8010662b:	8b 0a                	mov    (%edx),%ecx
8010662d:	31 d9                	xor    %ebx,%ecx
8010662f:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80106635:	75 e9                	jne    80106620 <trap+0x330>
          swap_page_back(p, &(p->swapped_out_pages[i]));
80106637:	8d 04 40             	lea    (%eax,%eax,2),%eax
8010663a:	83 ec 08             	sub    $0x8,%esp
8010663d:	8d 84 c6 80 00 00 00 	lea    0x80(%esi,%eax,8),%eax
80106644:	50                   	push   %eax
80106645:	56                   	push   %esi
80106646:	e8 c5 1e 00 00       	call   80108510 <swap_page_back>
          break;
8010664b:	83 c4 10             	add    $0x10,%esp
      p->num_of_pagefaults_occurs++;
8010664e:	83 86 c8 03 00 00 01 	addl   $0x1,0x3c8(%esi)
      return;
80106655:	e9 f5 fd ff ff       	jmp    8010644f <trap+0x15f>
8010665a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106660:	83 ec 0c             	sub    $0xc,%esp
80106663:	68 e0 21 13 80       	push   $0x801321e0
80106668:	e8 73 e8 ff ff       	call   80104ee0 <acquire>
      wakeup(&ticks);
8010666d:	c7 04 24 20 2a 13 80 	movl   $0x80132a20,(%esp)
      ticks++;
80106674:	83 05 20 2a 13 80 01 	addl   $0x1,0x80132a20
      wakeup(&ticks);
8010667b:	e8 f0 e3 ff ff       	call   80104a70 <wakeup>
      release(&tickslock);
80106680:	c7 04 24 e0 21 13 80 	movl   $0x801321e0,(%esp)
80106687:	e8 14 e9 ff ff       	call   80104fa0 <release>
8010668c:	83 c4 10             	add    $0x10,%esp
8010668f:	e9 d9 fe ff ff       	jmp    8010656d <trap+0x27d>
        *pte_ptr &= (~PTE_COW);
80106694:	80 e7 f7             	and    $0xf7,%bh
80106697:	83 cb 02             	or     $0x2,%ebx
8010669a:	89 18                	mov    %ebx,(%eax)
        release(cow_lock);
8010669c:	a1 40 ff 11 80       	mov    0x8011ff40,%eax
801066a1:	89 45 08             	mov    %eax,0x8(%ebp)
}
801066a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066a7:	5b                   	pop    %ebx
801066a8:	5e                   	pop    %esi
801066a9:	5f                   	pop    %edi
801066aa:	5d                   	pop    %ebp
        release(cow_lock);
801066ab:	e9 f0 e8 ff ff       	jmp    80104fa0 <release>
801066b0:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801066b3:	e8 e8 d9 ff ff       	call   801040a0 <cpuid>
801066b8:	83 ec 0c             	sub    $0xc,%esp
801066bb:	56                   	push   %esi
801066bc:	53                   	push   %ebx
801066bd:	50                   	push   %eax
801066be:	ff 77 30             	pushl  0x30(%edi)
801066c1:	68 68 8f 10 80       	push   $0x80108f68
801066c6:	e8 95 9f ff ff       	call   80100660 <cprintf>
      panic("trap");
801066cb:	83 c4 14             	add    $0x14,%esp
801066ce:	68 be 8e 10 80       	push   $0x80108ebe
801066d3:	e8 b8 9c ff ff       	call   80100390 <panic>
        panic("ref count to page is 0 but it was reffed");
801066d8:	83 ec 0c             	sub    $0xc,%esp
801066db:	68 e8 8e 10 80       	push   $0x80108ee8
801066e0:	e8 ab 9c ff ff       	call   80100390 <panic>
801066e5:	66 90                	xchg   %ax,%ax
801066e7:	66 90                	xchg   %ax,%ax
801066e9:	66 90                	xchg   %ax,%ax
801066eb:	66 90                	xchg   %ax,%ax
801066ed:	66 90                	xchg   %ax,%ax
801066ef:	90                   	nop

801066f0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801066f0:	a1 bc c5 10 80       	mov    0x8010c5bc,%eax
{
801066f5:	55                   	push   %ebp
801066f6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801066f8:	85 c0                	test   %eax,%eax
801066fa:	74 1c                	je     80106718 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801066fc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106701:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106702:	a8 01                	test   $0x1,%al
80106704:	74 12                	je     80106718 <uartgetc+0x28>
80106706:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010670b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010670c:	0f b6 c0             	movzbl %al,%eax
}
8010670f:	5d                   	pop    %ebp
80106710:	c3                   	ret    
80106711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106718:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010671d:	5d                   	pop    %ebp
8010671e:	c3                   	ret    
8010671f:	90                   	nop

80106720 <uartputc.part.0>:
uartputc(int c)
80106720:	55                   	push   %ebp
80106721:	89 e5                	mov    %esp,%ebp
80106723:	57                   	push   %edi
80106724:	56                   	push   %esi
80106725:	53                   	push   %ebx
80106726:	89 c7                	mov    %eax,%edi
80106728:	bb 80 00 00 00       	mov    $0x80,%ebx
8010672d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106732:	83 ec 0c             	sub    $0xc,%esp
80106735:	eb 1b                	jmp    80106752 <uartputc.part.0+0x32>
80106737:	89 f6                	mov    %esi,%esi
80106739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106740:	83 ec 0c             	sub    $0xc,%esp
80106743:	6a 0a                	push   $0xa
80106745:	e8 86 c8 ff ff       	call   80102fd0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010674a:	83 c4 10             	add    $0x10,%esp
8010674d:	83 eb 01             	sub    $0x1,%ebx
80106750:	74 07                	je     80106759 <uartputc.part.0+0x39>
80106752:	89 f2                	mov    %esi,%edx
80106754:	ec                   	in     (%dx),%al
80106755:	a8 20                	test   $0x20,%al
80106757:	74 e7                	je     80106740 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106759:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010675e:	89 f8                	mov    %edi,%eax
80106760:	ee                   	out    %al,(%dx)
}
80106761:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106764:	5b                   	pop    %ebx
80106765:	5e                   	pop    %esi
80106766:	5f                   	pop    %edi
80106767:	5d                   	pop    %ebp
80106768:	c3                   	ret    
80106769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106770 <uartinit>:
{
80106770:	55                   	push   %ebp
80106771:	31 c9                	xor    %ecx,%ecx
80106773:	89 c8                	mov    %ecx,%eax
80106775:	89 e5                	mov    %esp,%ebp
80106777:	57                   	push   %edi
80106778:	56                   	push   %esi
80106779:	53                   	push   %ebx
8010677a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010677f:	89 da                	mov    %ebx,%edx
80106781:	83 ec 0c             	sub    $0xc,%esp
80106784:	ee                   	out    %al,(%dx)
80106785:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010678a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010678f:	89 fa                	mov    %edi,%edx
80106791:	ee                   	out    %al,(%dx)
80106792:	b8 0c 00 00 00       	mov    $0xc,%eax
80106797:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010679c:	ee                   	out    %al,(%dx)
8010679d:	be f9 03 00 00       	mov    $0x3f9,%esi
801067a2:	89 c8                	mov    %ecx,%eax
801067a4:	89 f2                	mov    %esi,%edx
801067a6:	ee                   	out    %al,(%dx)
801067a7:	b8 03 00 00 00       	mov    $0x3,%eax
801067ac:	89 fa                	mov    %edi,%edx
801067ae:	ee                   	out    %al,(%dx)
801067af:	ba fc 03 00 00       	mov    $0x3fc,%edx
801067b4:	89 c8                	mov    %ecx,%eax
801067b6:	ee                   	out    %al,(%dx)
801067b7:	b8 01 00 00 00       	mov    $0x1,%eax
801067bc:	89 f2                	mov    %esi,%edx
801067be:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801067bf:	ba fd 03 00 00       	mov    $0x3fd,%edx
801067c4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801067c5:	3c ff                	cmp    $0xff,%al
801067c7:	74 5a                	je     80106823 <uartinit+0xb3>
  uart = 1;
801067c9:	c7 05 bc c5 10 80 01 	movl   $0x1,0x8010c5bc
801067d0:	00 00 00 
801067d3:	89 da                	mov    %ebx,%edx
801067d5:	ec                   	in     (%dx),%al
801067d6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801067db:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801067dc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801067df:	bb a8 90 10 80       	mov    $0x801090a8,%ebx
  ioapicenable(IRQ_COM1, 0);
801067e4:	6a 00                	push   $0x0
801067e6:	6a 04                	push   $0x4
801067e8:	e8 c3 c2 ff ff       	call   80102ab0 <ioapicenable>
801067ed:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801067f0:	b8 78 00 00 00       	mov    $0x78,%eax
801067f5:	eb 13                	jmp    8010680a <uartinit+0x9a>
801067f7:	89 f6                	mov    %esi,%esi
801067f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106800:	83 c3 01             	add    $0x1,%ebx
80106803:	0f be 03             	movsbl (%ebx),%eax
80106806:	84 c0                	test   %al,%al
80106808:	74 19                	je     80106823 <uartinit+0xb3>
  if(!uart)
8010680a:	8b 15 bc c5 10 80    	mov    0x8010c5bc,%edx
80106810:	85 d2                	test   %edx,%edx
80106812:	74 ec                	je     80106800 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106814:	83 c3 01             	add    $0x1,%ebx
80106817:	e8 04 ff ff ff       	call   80106720 <uartputc.part.0>
8010681c:	0f be 03             	movsbl (%ebx),%eax
8010681f:	84 c0                	test   %al,%al
80106821:	75 e7                	jne    8010680a <uartinit+0x9a>
}
80106823:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106826:	5b                   	pop    %ebx
80106827:	5e                   	pop    %esi
80106828:	5f                   	pop    %edi
80106829:	5d                   	pop    %ebp
8010682a:	c3                   	ret    
8010682b:	90                   	nop
8010682c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106830 <uartputc>:
  if(!uart)
80106830:	8b 15 bc c5 10 80    	mov    0x8010c5bc,%edx
{
80106836:	55                   	push   %ebp
80106837:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106839:	85 d2                	test   %edx,%edx
{
8010683b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010683e:	74 10                	je     80106850 <uartputc+0x20>
}
80106840:	5d                   	pop    %ebp
80106841:	e9 da fe ff ff       	jmp    80106720 <uartputc.part.0>
80106846:	8d 76 00             	lea    0x0(%esi),%esi
80106849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106850:	5d                   	pop    %ebp
80106851:	c3                   	ret    
80106852:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106860 <uartintr>:

void
uartintr(void)
{
80106860:	55                   	push   %ebp
80106861:	89 e5                	mov    %esp,%ebp
80106863:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106866:	68 f0 66 10 80       	push   $0x801066f0
8010686b:	e8 a0 9f ff ff       	call   80100810 <consoleintr>
}
80106870:	83 c4 10             	add    $0x10,%esp
80106873:	c9                   	leave  
80106874:	c3                   	ret    

80106875 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106875:	6a 00                	push   $0x0
  pushl $0
80106877:	6a 00                	push   $0x0
  jmp alltraps
80106879:	e9 9b f9 ff ff       	jmp    80106219 <alltraps>

8010687e <vector1>:
.globl vector1
vector1:
  pushl $0
8010687e:	6a 00                	push   $0x0
  pushl $1
80106880:	6a 01                	push   $0x1
  jmp alltraps
80106882:	e9 92 f9 ff ff       	jmp    80106219 <alltraps>

80106887 <vector2>:
.globl vector2
vector2:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $2
80106889:	6a 02                	push   $0x2
  jmp alltraps
8010688b:	e9 89 f9 ff ff       	jmp    80106219 <alltraps>

80106890 <vector3>:
.globl vector3
vector3:
  pushl $0
80106890:	6a 00                	push   $0x0
  pushl $3
80106892:	6a 03                	push   $0x3
  jmp alltraps
80106894:	e9 80 f9 ff ff       	jmp    80106219 <alltraps>

80106899 <vector4>:
.globl vector4
vector4:
  pushl $0
80106899:	6a 00                	push   $0x0
  pushl $4
8010689b:	6a 04                	push   $0x4
  jmp alltraps
8010689d:	e9 77 f9 ff ff       	jmp    80106219 <alltraps>

801068a2 <vector5>:
.globl vector5
vector5:
  pushl $0
801068a2:	6a 00                	push   $0x0
  pushl $5
801068a4:	6a 05                	push   $0x5
  jmp alltraps
801068a6:	e9 6e f9 ff ff       	jmp    80106219 <alltraps>

801068ab <vector6>:
.globl vector6
vector6:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $6
801068ad:	6a 06                	push   $0x6
  jmp alltraps
801068af:	e9 65 f9 ff ff       	jmp    80106219 <alltraps>

801068b4 <vector7>:
.globl vector7
vector7:
  pushl $0
801068b4:	6a 00                	push   $0x0
  pushl $7
801068b6:	6a 07                	push   $0x7
  jmp alltraps
801068b8:	e9 5c f9 ff ff       	jmp    80106219 <alltraps>

801068bd <vector8>:
.globl vector8
vector8:
  pushl $8
801068bd:	6a 08                	push   $0x8
  jmp alltraps
801068bf:	e9 55 f9 ff ff       	jmp    80106219 <alltraps>

801068c4 <vector9>:
.globl vector9
vector9:
  pushl $0
801068c4:	6a 00                	push   $0x0
  pushl $9
801068c6:	6a 09                	push   $0x9
  jmp alltraps
801068c8:	e9 4c f9 ff ff       	jmp    80106219 <alltraps>

801068cd <vector10>:
.globl vector10
vector10:
  pushl $10
801068cd:	6a 0a                	push   $0xa
  jmp alltraps
801068cf:	e9 45 f9 ff ff       	jmp    80106219 <alltraps>

801068d4 <vector11>:
.globl vector11
vector11:
  pushl $11
801068d4:	6a 0b                	push   $0xb
  jmp alltraps
801068d6:	e9 3e f9 ff ff       	jmp    80106219 <alltraps>

801068db <vector12>:
.globl vector12
vector12:
  pushl $12
801068db:	6a 0c                	push   $0xc
  jmp alltraps
801068dd:	e9 37 f9 ff ff       	jmp    80106219 <alltraps>

801068e2 <vector13>:
.globl vector13
vector13:
  pushl $13
801068e2:	6a 0d                	push   $0xd
  jmp alltraps
801068e4:	e9 30 f9 ff ff       	jmp    80106219 <alltraps>

801068e9 <vector14>:
.globl vector14
vector14:
  pushl $14
801068e9:	6a 0e                	push   $0xe
  jmp alltraps
801068eb:	e9 29 f9 ff ff       	jmp    80106219 <alltraps>

801068f0 <vector15>:
.globl vector15
vector15:
  pushl $0
801068f0:	6a 00                	push   $0x0
  pushl $15
801068f2:	6a 0f                	push   $0xf
  jmp alltraps
801068f4:	e9 20 f9 ff ff       	jmp    80106219 <alltraps>

801068f9 <vector16>:
.globl vector16
vector16:
  pushl $0
801068f9:	6a 00                	push   $0x0
  pushl $16
801068fb:	6a 10                	push   $0x10
  jmp alltraps
801068fd:	e9 17 f9 ff ff       	jmp    80106219 <alltraps>

80106902 <vector17>:
.globl vector17
vector17:
  pushl $17
80106902:	6a 11                	push   $0x11
  jmp alltraps
80106904:	e9 10 f9 ff ff       	jmp    80106219 <alltraps>

80106909 <vector18>:
.globl vector18
vector18:
  pushl $0
80106909:	6a 00                	push   $0x0
  pushl $18
8010690b:	6a 12                	push   $0x12
  jmp alltraps
8010690d:	e9 07 f9 ff ff       	jmp    80106219 <alltraps>

80106912 <vector19>:
.globl vector19
vector19:
  pushl $0
80106912:	6a 00                	push   $0x0
  pushl $19
80106914:	6a 13                	push   $0x13
  jmp alltraps
80106916:	e9 fe f8 ff ff       	jmp    80106219 <alltraps>

8010691b <vector20>:
.globl vector20
vector20:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $20
8010691d:	6a 14                	push   $0x14
  jmp alltraps
8010691f:	e9 f5 f8 ff ff       	jmp    80106219 <alltraps>

80106924 <vector21>:
.globl vector21
vector21:
  pushl $0
80106924:	6a 00                	push   $0x0
  pushl $21
80106926:	6a 15                	push   $0x15
  jmp alltraps
80106928:	e9 ec f8 ff ff       	jmp    80106219 <alltraps>

8010692d <vector22>:
.globl vector22
vector22:
  pushl $0
8010692d:	6a 00                	push   $0x0
  pushl $22
8010692f:	6a 16                	push   $0x16
  jmp alltraps
80106931:	e9 e3 f8 ff ff       	jmp    80106219 <alltraps>

80106936 <vector23>:
.globl vector23
vector23:
  pushl $0
80106936:	6a 00                	push   $0x0
  pushl $23
80106938:	6a 17                	push   $0x17
  jmp alltraps
8010693a:	e9 da f8 ff ff       	jmp    80106219 <alltraps>

8010693f <vector24>:
.globl vector24
vector24:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $24
80106941:	6a 18                	push   $0x18
  jmp alltraps
80106943:	e9 d1 f8 ff ff       	jmp    80106219 <alltraps>

80106948 <vector25>:
.globl vector25
vector25:
  pushl $0
80106948:	6a 00                	push   $0x0
  pushl $25
8010694a:	6a 19                	push   $0x19
  jmp alltraps
8010694c:	e9 c8 f8 ff ff       	jmp    80106219 <alltraps>

80106951 <vector26>:
.globl vector26
vector26:
  pushl $0
80106951:	6a 00                	push   $0x0
  pushl $26
80106953:	6a 1a                	push   $0x1a
  jmp alltraps
80106955:	e9 bf f8 ff ff       	jmp    80106219 <alltraps>

8010695a <vector27>:
.globl vector27
vector27:
  pushl $0
8010695a:	6a 00                	push   $0x0
  pushl $27
8010695c:	6a 1b                	push   $0x1b
  jmp alltraps
8010695e:	e9 b6 f8 ff ff       	jmp    80106219 <alltraps>

80106963 <vector28>:
.globl vector28
vector28:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $28
80106965:	6a 1c                	push   $0x1c
  jmp alltraps
80106967:	e9 ad f8 ff ff       	jmp    80106219 <alltraps>

8010696c <vector29>:
.globl vector29
vector29:
  pushl $0
8010696c:	6a 00                	push   $0x0
  pushl $29
8010696e:	6a 1d                	push   $0x1d
  jmp alltraps
80106970:	e9 a4 f8 ff ff       	jmp    80106219 <alltraps>

80106975 <vector30>:
.globl vector30
vector30:
  pushl $0
80106975:	6a 00                	push   $0x0
  pushl $30
80106977:	6a 1e                	push   $0x1e
  jmp alltraps
80106979:	e9 9b f8 ff ff       	jmp    80106219 <alltraps>

8010697e <vector31>:
.globl vector31
vector31:
  pushl $0
8010697e:	6a 00                	push   $0x0
  pushl $31
80106980:	6a 1f                	push   $0x1f
  jmp alltraps
80106982:	e9 92 f8 ff ff       	jmp    80106219 <alltraps>

80106987 <vector32>:
.globl vector32
vector32:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $32
80106989:	6a 20                	push   $0x20
  jmp alltraps
8010698b:	e9 89 f8 ff ff       	jmp    80106219 <alltraps>

80106990 <vector33>:
.globl vector33
vector33:
  pushl $0
80106990:	6a 00                	push   $0x0
  pushl $33
80106992:	6a 21                	push   $0x21
  jmp alltraps
80106994:	e9 80 f8 ff ff       	jmp    80106219 <alltraps>

80106999 <vector34>:
.globl vector34
vector34:
  pushl $0
80106999:	6a 00                	push   $0x0
  pushl $34
8010699b:	6a 22                	push   $0x22
  jmp alltraps
8010699d:	e9 77 f8 ff ff       	jmp    80106219 <alltraps>

801069a2 <vector35>:
.globl vector35
vector35:
  pushl $0
801069a2:	6a 00                	push   $0x0
  pushl $35
801069a4:	6a 23                	push   $0x23
  jmp alltraps
801069a6:	e9 6e f8 ff ff       	jmp    80106219 <alltraps>

801069ab <vector36>:
.globl vector36
vector36:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $36
801069ad:	6a 24                	push   $0x24
  jmp alltraps
801069af:	e9 65 f8 ff ff       	jmp    80106219 <alltraps>

801069b4 <vector37>:
.globl vector37
vector37:
  pushl $0
801069b4:	6a 00                	push   $0x0
  pushl $37
801069b6:	6a 25                	push   $0x25
  jmp alltraps
801069b8:	e9 5c f8 ff ff       	jmp    80106219 <alltraps>

801069bd <vector38>:
.globl vector38
vector38:
  pushl $0
801069bd:	6a 00                	push   $0x0
  pushl $38
801069bf:	6a 26                	push   $0x26
  jmp alltraps
801069c1:	e9 53 f8 ff ff       	jmp    80106219 <alltraps>

801069c6 <vector39>:
.globl vector39
vector39:
  pushl $0
801069c6:	6a 00                	push   $0x0
  pushl $39
801069c8:	6a 27                	push   $0x27
  jmp alltraps
801069ca:	e9 4a f8 ff ff       	jmp    80106219 <alltraps>

801069cf <vector40>:
.globl vector40
vector40:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $40
801069d1:	6a 28                	push   $0x28
  jmp alltraps
801069d3:	e9 41 f8 ff ff       	jmp    80106219 <alltraps>

801069d8 <vector41>:
.globl vector41
vector41:
  pushl $0
801069d8:	6a 00                	push   $0x0
  pushl $41
801069da:	6a 29                	push   $0x29
  jmp alltraps
801069dc:	e9 38 f8 ff ff       	jmp    80106219 <alltraps>

801069e1 <vector42>:
.globl vector42
vector42:
  pushl $0
801069e1:	6a 00                	push   $0x0
  pushl $42
801069e3:	6a 2a                	push   $0x2a
  jmp alltraps
801069e5:	e9 2f f8 ff ff       	jmp    80106219 <alltraps>

801069ea <vector43>:
.globl vector43
vector43:
  pushl $0
801069ea:	6a 00                	push   $0x0
  pushl $43
801069ec:	6a 2b                	push   $0x2b
  jmp alltraps
801069ee:	e9 26 f8 ff ff       	jmp    80106219 <alltraps>

801069f3 <vector44>:
.globl vector44
vector44:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $44
801069f5:	6a 2c                	push   $0x2c
  jmp alltraps
801069f7:	e9 1d f8 ff ff       	jmp    80106219 <alltraps>

801069fc <vector45>:
.globl vector45
vector45:
  pushl $0
801069fc:	6a 00                	push   $0x0
  pushl $45
801069fe:	6a 2d                	push   $0x2d
  jmp alltraps
80106a00:	e9 14 f8 ff ff       	jmp    80106219 <alltraps>

80106a05 <vector46>:
.globl vector46
vector46:
  pushl $0
80106a05:	6a 00                	push   $0x0
  pushl $46
80106a07:	6a 2e                	push   $0x2e
  jmp alltraps
80106a09:	e9 0b f8 ff ff       	jmp    80106219 <alltraps>

80106a0e <vector47>:
.globl vector47
vector47:
  pushl $0
80106a0e:	6a 00                	push   $0x0
  pushl $47
80106a10:	6a 2f                	push   $0x2f
  jmp alltraps
80106a12:	e9 02 f8 ff ff       	jmp    80106219 <alltraps>

80106a17 <vector48>:
.globl vector48
vector48:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $48
80106a19:	6a 30                	push   $0x30
  jmp alltraps
80106a1b:	e9 f9 f7 ff ff       	jmp    80106219 <alltraps>

80106a20 <vector49>:
.globl vector49
vector49:
  pushl $0
80106a20:	6a 00                	push   $0x0
  pushl $49
80106a22:	6a 31                	push   $0x31
  jmp alltraps
80106a24:	e9 f0 f7 ff ff       	jmp    80106219 <alltraps>

80106a29 <vector50>:
.globl vector50
vector50:
  pushl $0
80106a29:	6a 00                	push   $0x0
  pushl $50
80106a2b:	6a 32                	push   $0x32
  jmp alltraps
80106a2d:	e9 e7 f7 ff ff       	jmp    80106219 <alltraps>

80106a32 <vector51>:
.globl vector51
vector51:
  pushl $0
80106a32:	6a 00                	push   $0x0
  pushl $51
80106a34:	6a 33                	push   $0x33
  jmp alltraps
80106a36:	e9 de f7 ff ff       	jmp    80106219 <alltraps>

80106a3b <vector52>:
.globl vector52
vector52:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $52
80106a3d:	6a 34                	push   $0x34
  jmp alltraps
80106a3f:	e9 d5 f7 ff ff       	jmp    80106219 <alltraps>

80106a44 <vector53>:
.globl vector53
vector53:
  pushl $0
80106a44:	6a 00                	push   $0x0
  pushl $53
80106a46:	6a 35                	push   $0x35
  jmp alltraps
80106a48:	e9 cc f7 ff ff       	jmp    80106219 <alltraps>

80106a4d <vector54>:
.globl vector54
vector54:
  pushl $0
80106a4d:	6a 00                	push   $0x0
  pushl $54
80106a4f:	6a 36                	push   $0x36
  jmp alltraps
80106a51:	e9 c3 f7 ff ff       	jmp    80106219 <alltraps>

80106a56 <vector55>:
.globl vector55
vector55:
  pushl $0
80106a56:	6a 00                	push   $0x0
  pushl $55
80106a58:	6a 37                	push   $0x37
  jmp alltraps
80106a5a:	e9 ba f7 ff ff       	jmp    80106219 <alltraps>

80106a5f <vector56>:
.globl vector56
vector56:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $56
80106a61:	6a 38                	push   $0x38
  jmp alltraps
80106a63:	e9 b1 f7 ff ff       	jmp    80106219 <alltraps>

80106a68 <vector57>:
.globl vector57
vector57:
  pushl $0
80106a68:	6a 00                	push   $0x0
  pushl $57
80106a6a:	6a 39                	push   $0x39
  jmp alltraps
80106a6c:	e9 a8 f7 ff ff       	jmp    80106219 <alltraps>

80106a71 <vector58>:
.globl vector58
vector58:
  pushl $0
80106a71:	6a 00                	push   $0x0
  pushl $58
80106a73:	6a 3a                	push   $0x3a
  jmp alltraps
80106a75:	e9 9f f7 ff ff       	jmp    80106219 <alltraps>

80106a7a <vector59>:
.globl vector59
vector59:
  pushl $0
80106a7a:	6a 00                	push   $0x0
  pushl $59
80106a7c:	6a 3b                	push   $0x3b
  jmp alltraps
80106a7e:	e9 96 f7 ff ff       	jmp    80106219 <alltraps>

80106a83 <vector60>:
.globl vector60
vector60:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $60
80106a85:	6a 3c                	push   $0x3c
  jmp alltraps
80106a87:	e9 8d f7 ff ff       	jmp    80106219 <alltraps>

80106a8c <vector61>:
.globl vector61
vector61:
  pushl $0
80106a8c:	6a 00                	push   $0x0
  pushl $61
80106a8e:	6a 3d                	push   $0x3d
  jmp alltraps
80106a90:	e9 84 f7 ff ff       	jmp    80106219 <alltraps>

80106a95 <vector62>:
.globl vector62
vector62:
  pushl $0
80106a95:	6a 00                	push   $0x0
  pushl $62
80106a97:	6a 3e                	push   $0x3e
  jmp alltraps
80106a99:	e9 7b f7 ff ff       	jmp    80106219 <alltraps>

80106a9e <vector63>:
.globl vector63
vector63:
  pushl $0
80106a9e:	6a 00                	push   $0x0
  pushl $63
80106aa0:	6a 3f                	push   $0x3f
  jmp alltraps
80106aa2:	e9 72 f7 ff ff       	jmp    80106219 <alltraps>

80106aa7 <vector64>:
.globl vector64
vector64:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $64
80106aa9:	6a 40                	push   $0x40
  jmp alltraps
80106aab:	e9 69 f7 ff ff       	jmp    80106219 <alltraps>

80106ab0 <vector65>:
.globl vector65
vector65:
  pushl $0
80106ab0:	6a 00                	push   $0x0
  pushl $65
80106ab2:	6a 41                	push   $0x41
  jmp alltraps
80106ab4:	e9 60 f7 ff ff       	jmp    80106219 <alltraps>

80106ab9 <vector66>:
.globl vector66
vector66:
  pushl $0
80106ab9:	6a 00                	push   $0x0
  pushl $66
80106abb:	6a 42                	push   $0x42
  jmp alltraps
80106abd:	e9 57 f7 ff ff       	jmp    80106219 <alltraps>

80106ac2 <vector67>:
.globl vector67
vector67:
  pushl $0
80106ac2:	6a 00                	push   $0x0
  pushl $67
80106ac4:	6a 43                	push   $0x43
  jmp alltraps
80106ac6:	e9 4e f7 ff ff       	jmp    80106219 <alltraps>

80106acb <vector68>:
.globl vector68
vector68:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $68
80106acd:	6a 44                	push   $0x44
  jmp alltraps
80106acf:	e9 45 f7 ff ff       	jmp    80106219 <alltraps>

80106ad4 <vector69>:
.globl vector69
vector69:
  pushl $0
80106ad4:	6a 00                	push   $0x0
  pushl $69
80106ad6:	6a 45                	push   $0x45
  jmp alltraps
80106ad8:	e9 3c f7 ff ff       	jmp    80106219 <alltraps>

80106add <vector70>:
.globl vector70
vector70:
  pushl $0
80106add:	6a 00                	push   $0x0
  pushl $70
80106adf:	6a 46                	push   $0x46
  jmp alltraps
80106ae1:	e9 33 f7 ff ff       	jmp    80106219 <alltraps>

80106ae6 <vector71>:
.globl vector71
vector71:
  pushl $0
80106ae6:	6a 00                	push   $0x0
  pushl $71
80106ae8:	6a 47                	push   $0x47
  jmp alltraps
80106aea:	e9 2a f7 ff ff       	jmp    80106219 <alltraps>

80106aef <vector72>:
.globl vector72
vector72:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $72
80106af1:	6a 48                	push   $0x48
  jmp alltraps
80106af3:	e9 21 f7 ff ff       	jmp    80106219 <alltraps>

80106af8 <vector73>:
.globl vector73
vector73:
  pushl $0
80106af8:	6a 00                	push   $0x0
  pushl $73
80106afa:	6a 49                	push   $0x49
  jmp alltraps
80106afc:	e9 18 f7 ff ff       	jmp    80106219 <alltraps>

80106b01 <vector74>:
.globl vector74
vector74:
  pushl $0
80106b01:	6a 00                	push   $0x0
  pushl $74
80106b03:	6a 4a                	push   $0x4a
  jmp alltraps
80106b05:	e9 0f f7 ff ff       	jmp    80106219 <alltraps>

80106b0a <vector75>:
.globl vector75
vector75:
  pushl $0
80106b0a:	6a 00                	push   $0x0
  pushl $75
80106b0c:	6a 4b                	push   $0x4b
  jmp alltraps
80106b0e:	e9 06 f7 ff ff       	jmp    80106219 <alltraps>

80106b13 <vector76>:
.globl vector76
vector76:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $76
80106b15:	6a 4c                	push   $0x4c
  jmp alltraps
80106b17:	e9 fd f6 ff ff       	jmp    80106219 <alltraps>

80106b1c <vector77>:
.globl vector77
vector77:
  pushl $0
80106b1c:	6a 00                	push   $0x0
  pushl $77
80106b1e:	6a 4d                	push   $0x4d
  jmp alltraps
80106b20:	e9 f4 f6 ff ff       	jmp    80106219 <alltraps>

80106b25 <vector78>:
.globl vector78
vector78:
  pushl $0
80106b25:	6a 00                	push   $0x0
  pushl $78
80106b27:	6a 4e                	push   $0x4e
  jmp alltraps
80106b29:	e9 eb f6 ff ff       	jmp    80106219 <alltraps>

80106b2e <vector79>:
.globl vector79
vector79:
  pushl $0
80106b2e:	6a 00                	push   $0x0
  pushl $79
80106b30:	6a 4f                	push   $0x4f
  jmp alltraps
80106b32:	e9 e2 f6 ff ff       	jmp    80106219 <alltraps>

80106b37 <vector80>:
.globl vector80
vector80:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $80
80106b39:	6a 50                	push   $0x50
  jmp alltraps
80106b3b:	e9 d9 f6 ff ff       	jmp    80106219 <alltraps>

80106b40 <vector81>:
.globl vector81
vector81:
  pushl $0
80106b40:	6a 00                	push   $0x0
  pushl $81
80106b42:	6a 51                	push   $0x51
  jmp alltraps
80106b44:	e9 d0 f6 ff ff       	jmp    80106219 <alltraps>

80106b49 <vector82>:
.globl vector82
vector82:
  pushl $0
80106b49:	6a 00                	push   $0x0
  pushl $82
80106b4b:	6a 52                	push   $0x52
  jmp alltraps
80106b4d:	e9 c7 f6 ff ff       	jmp    80106219 <alltraps>

80106b52 <vector83>:
.globl vector83
vector83:
  pushl $0
80106b52:	6a 00                	push   $0x0
  pushl $83
80106b54:	6a 53                	push   $0x53
  jmp alltraps
80106b56:	e9 be f6 ff ff       	jmp    80106219 <alltraps>

80106b5b <vector84>:
.globl vector84
vector84:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $84
80106b5d:	6a 54                	push   $0x54
  jmp alltraps
80106b5f:	e9 b5 f6 ff ff       	jmp    80106219 <alltraps>

80106b64 <vector85>:
.globl vector85
vector85:
  pushl $0
80106b64:	6a 00                	push   $0x0
  pushl $85
80106b66:	6a 55                	push   $0x55
  jmp alltraps
80106b68:	e9 ac f6 ff ff       	jmp    80106219 <alltraps>

80106b6d <vector86>:
.globl vector86
vector86:
  pushl $0
80106b6d:	6a 00                	push   $0x0
  pushl $86
80106b6f:	6a 56                	push   $0x56
  jmp alltraps
80106b71:	e9 a3 f6 ff ff       	jmp    80106219 <alltraps>

80106b76 <vector87>:
.globl vector87
vector87:
  pushl $0
80106b76:	6a 00                	push   $0x0
  pushl $87
80106b78:	6a 57                	push   $0x57
  jmp alltraps
80106b7a:	e9 9a f6 ff ff       	jmp    80106219 <alltraps>

80106b7f <vector88>:
.globl vector88
vector88:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $88
80106b81:	6a 58                	push   $0x58
  jmp alltraps
80106b83:	e9 91 f6 ff ff       	jmp    80106219 <alltraps>

80106b88 <vector89>:
.globl vector89
vector89:
  pushl $0
80106b88:	6a 00                	push   $0x0
  pushl $89
80106b8a:	6a 59                	push   $0x59
  jmp alltraps
80106b8c:	e9 88 f6 ff ff       	jmp    80106219 <alltraps>

80106b91 <vector90>:
.globl vector90
vector90:
  pushl $0
80106b91:	6a 00                	push   $0x0
  pushl $90
80106b93:	6a 5a                	push   $0x5a
  jmp alltraps
80106b95:	e9 7f f6 ff ff       	jmp    80106219 <alltraps>

80106b9a <vector91>:
.globl vector91
vector91:
  pushl $0
80106b9a:	6a 00                	push   $0x0
  pushl $91
80106b9c:	6a 5b                	push   $0x5b
  jmp alltraps
80106b9e:	e9 76 f6 ff ff       	jmp    80106219 <alltraps>

80106ba3 <vector92>:
.globl vector92
vector92:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $92
80106ba5:	6a 5c                	push   $0x5c
  jmp alltraps
80106ba7:	e9 6d f6 ff ff       	jmp    80106219 <alltraps>

80106bac <vector93>:
.globl vector93
vector93:
  pushl $0
80106bac:	6a 00                	push   $0x0
  pushl $93
80106bae:	6a 5d                	push   $0x5d
  jmp alltraps
80106bb0:	e9 64 f6 ff ff       	jmp    80106219 <alltraps>

80106bb5 <vector94>:
.globl vector94
vector94:
  pushl $0
80106bb5:	6a 00                	push   $0x0
  pushl $94
80106bb7:	6a 5e                	push   $0x5e
  jmp alltraps
80106bb9:	e9 5b f6 ff ff       	jmp    80106219 <alltraps>

80106bbe <vector95>:
.globl vector95
vector95:
  pushl $0
80106bbe:	6a 00                	push   $0x0
  pushl $95
80106bc0:	6a 5f                	push   $0x5f
  jmp alltraps
80106bc2:	e9 52 f6 ff ff       	jmp    80106219 <alltraps>

80106bc7 <vector96>:
.globl vector96
vector96:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $96
80106bc9:	6a 60                	push   $0x60
  jmp alltraps
80106bcb:	e9 49 f6 ff ff       	jmp    80106219 <alltraps>

80106bd0 <vector97>:
.globl vector97
vector97:
  pushl $0
80106bd0:	6a 00                	push   $0x0
  pushl $97
80106bd2:	6a 61                	push   $0x61
  jmp alltraps
80106bd4:	e9 40 f6 ff ff       	jmp    80106219 <alltraps>

80106bd9 <vector98>:
.globl vector98
vector98:
  pushl $0
80106bd9:	6a 00                	push   $0x0
  pushl $98
80106bdb:	6a 62                	push   $0x62
  jmp alltraps
80106bdd:	e9 37 f6 ff ff       	jmp    80106219 <alltraps>

80106be2 <vector99>:
.globl vector99
vector99:
  pushl $0
80106be2:	6a 00                	push   $0x0
  pushl $99
80106be4:	6a 63                	push   $0x63
  jmp alltraps
80106be6:	e9 2e f6 ff ff       	jmp    80106219 <alltraps>

80106beb <vector100>:
.globl vector100
vector100:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $100
80106bed:	6a 64                	push   $0x64
  jmp alltraps
80106bef:	e9 25 f6 ff ff       	jmp    80106219 <alltraps>

80106bf4 <vector101>:
.globl vector101
vector101:
  pushl $0
80106bf4:	6a 00                	push   $0x0
  pushl $101
80106bf6:	6a 65                	push   $0x65
  jmp alltraps
80106bf8:	e9 1c f6 ff ff       	jmp    80106219 <alltraps>

80106bfd <vector102>:
.globl vector102
vector102:
  pushl $0
80106bfd:	6a 00                	push   $0x0
  pushl $102
80106bff:	6a 66                	push   $0x66
  jmp alltraps
80106c01:	e9 13 f6 ff ff       	jmp    80106219 <alltraps>

80106c06 <vector103>:
.globl vector103
vector103:
  pushl $0
80106c06:	6a 00                	push   $0x0
  pushl $103
80106c08:	6a 67                	push   $0x67
  jmp alltraps
80106c0a:	e9 0a f6 ff ff       	jmp    80106219 <alltraps>

80106c0f <vector104>:
.globl vector104
vector104:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $104
80106c11:	6a 68                	push   $0x68
  jmp alltraps
80106c13:	e9 01 f6 ff ff       	jmp    80106219 <alltraps>

80106c18 <vector105>:
.globl vector105
vector105:
  pushl $0
80106c18:	6a 00                	push   $0x0
  pushl $105
80106c1a:	6a 69                	push   $0x69
  jmp alltraps
80106c1c:	e9 f8 f5 ff ff       	jmp    80106219 <alltraps>

80106c21 <vector106>:
.globl vector106
vector106:
  pushl $0
80106c21:	6a 00                	push   $0x0
  pushl $106
80106c23:	6a 6a                	push   $0x6a
  jmp alltraps
80106c25:	e9 ef f5 ff ff       	jmp    80106219 <alltraps>

80106c2a <vector107>:
.globl vector107
vector107:
  pushl $0
80106c2a:	6a 00                	push   $0x0
  pushl $107
80106c2c:	6a 6b                	push   $0x6b
  jmp alltraps
80106c2e:	e9 e6 f5 ff ff       	jmp    80106219 <alltraps>

80106c33 <vector108>:
.globl vector108
vector108:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $108
80106c35:	6a 6c                	push   $0x6c
  jmp alltraps
80106c37:	e9 dd f5 ff ff       	jmp    80106219 <alltraps>

80106c3c <vector109>:
.globl vector109
vector109:
  pushl $0
80106c3c:	6a 00                	push   $0x0
  pushl $109
80106c3e:	6a 6d                	push   $0x6d
  jmp alltraps
80106c40:	e9 d4 f5 ff ff       	jmp    80106219 <alltraps>

80106c45 <vector110>:
.globl vector110
vector110:
  pushl $0
80106c45:	6a 00                	push   $0x0
  pushl $110
80106c47:	6a 6e                	push   $0x6e
  jmp alltraps
80106c49:	e9 cb f5 ff ff       	jmp    80106219 <alltraps>

80106c4e <vector111>:
.globl vector111
vector111:
  pushl $0
80106c4e:	6a 00                	push   $0x0
  pushl $111
80106c50:	6a 6f                	push   $0x6f
  jmp alltraps
80106c52:	e9 c2 f5 ff ff       	jmp    80106219 <alltraps>

80106c57 <vector112>:
.globl vector112
vector112:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $112
80106c59:	6a 70                	push   $0x70
  jmp alltraps
80106c5b:	e9 b9 f5 ff ff       	jmp    80106219 <alltraps>

80106c60 <vector113>:
.globl vector113
vector113:
  pushl $0
80106c60:	6a 00                	push   $0x0
  pushl $113
80106c62:	6a 71                	push   $0x71
  jmp alltraps
80106c64:	e9 b0 f5 ff ff       	jmp    80106219 <alltraps>

80106c69 <vector114>:
.globl vector114
vector114:
  pushl $0
80106c69:	6a 00                	push   $0x0
  pushl $114
80106c6b:	6a 72                	push   $0x72
  jmp alltraps
80106c6d:	e9 a7 f5 ff ff       	jmp    80106219 <alltraps>

80106c72 <vector115>:
.globl vector115
vector115:
  pushl $0
80106c72:	6a 00                	push   $0x0
  pushl $115
80106c74:	6a 73                	push   $0x73
  jmp alltraps
80106c76:	e9 9e f5 ff ff       	jmp    80106219 <alltraps>

80106c7b <vector116>:
.globl vector116
vector116:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $116
80106c7d:	6a 74                	push   $0x74
  jmp alltraps
80106c7f:	e9 95 f5 ff ff       	jmp    80106219 <alltraps>

80106c84 <vector117>:
.globl vector117
vector117:
  pushl $0
80106c84:	6a 00                	push   $0x0
  pushl $117
80106c86:	6a 75                	push   $0x75
  jmp alltraps
80106c88:	e9 8c f5 ff ff       	jmp    80106219 <alltraps>

80106c8d <vector118>:
.globl vector118
vector118:
  pushl $0
80106c8d:	6a 00                	push   $0x0
  pushl $118
80106c8f:	6a 76                	push   $0x76
  jmp alltraps
80106c91:	e9 83 f5 ff ff       	jmp    80106219 <alltraps>

80106c96 <vector119>:
.globl vector119
vector119:
  pushl $0
80106c96:	6a 00                	push   $0x0
  pushl $119
80106c98:	6a 77                	push   $0x77
  jmp alltraps
80106c9a:	e9 7a f5 ff ff       	jmp    80106219 <alltraps>

80106c9f <vector120>:
.globl vector120
vector120:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $120
80106ca1:	6a 78                	push   $0x78
  jmp alltraps
80106ca3:	e9 71 f5 ff ff       	jmp    80106219 <alltraps>

80106ca8 <vector121>:
.globl vector121
vector121:
  pushl $0
80106ca8:	6a 00                	push   $0x0
  pushl $121
80106caa:	6a 79                	push   $0x79
  jmp alltraps
80106cac:	e9 68 f5 ff ff       	jmp    80106219 <alltraps>

80106cb1 <vector122>:
.globl vector122
vector122:
  pushl $0
80106cb1:	6a 00                	push   $0x0
  pushl $122
80106cb3:	6a 7a                	push   $0x7a
  jmp alltraps
80106cb5:	e9 5f f5 ff ff       	jmp    80106219 <alltraps>

80106cba <vector123>:
.globl vector123
vector123:
  pushl $0
80106cba:	6a 00                	push   $0x0
  pushl $123
80106cbc:	6a 7b                	push   $0x7b
  jmp alltraps
80106cbe:	e9 56 f5 ff ff       	jmp    80106219 <alltraps>

80106cc3 <vector124>:
.globl vector124
vector124:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $124
80106cc5:	6a 7c                	push   $0x7c
  jmp alltraps
80106cc7:	e9 4d f5 ff ff       	jmp    80106219 <alltraps>

80106ccc <vector125>:
.globl vector125
vector125:
  pushl $0
80106ccc:	6a 00                	push   $0x0
  pushl $125
80106cce:	6a 7d                	push   $0x7d
  jmp alltraps
80106cd0:	e9 44 f5 ff ff       	jmp    80106219 <alltraps>

80106cd5 <vector126>:
.globl vector126
vector126:
  pushl $0
80106cd5:	6a 00                	push   $0x0
  pushl $126
80106cd7:	6a 7e                	push   $0x7e
  jmp alltraps
80106cd9:	e9 3b f5 ff ff       	jmp    80106219 <alltraps>

80106cde <vector127>:
.globl vector127
vector127:
  pushl $0
80106cde:	6a 00                	push   $0x0
  pushl $127
80106ce0:	6a 7f                	push   $0x7f
  jmp alltraps
80106ce2:	e9 32 f5 ff ff       	jmp    80106219 <alltraps>

80106ce7 <vector128>:
.globl vector128
vector128:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $128
80106ce9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106cee:	e9 26 f5 ff ff       	jmp    80106219 <alltraps>

80106cf3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $129
80106cf5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106cfa:	e9 1a f5 ff ff       	jmp    80106219 <alltraps>

80106cff <vector130>:
.globl vector130
vector130:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $130
80106d01:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106d06:	e9 0e f5 ff ff       	jmp    80106219 <alltraps>

80106d0b <vector131>:
.globl vector131
vector131:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $131
80106d0d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106d12:	e9 02 f5 ff ff       	jmp    80106219 <alltraps>

80106d17 <vector132>:
.globl vector132
vector132:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $132
80106d19:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106d1e:	e9 f6 f4 ff ff       	jmp    80106219 <alltraps>

80106d23 <vector133>:
.globl vector133
vector133:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $133
80106d25:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106d2a:	e9 ea f4 ff ff       	jmp    80106219 <alltraps>

80106d2f <vector134>:
.globl vector134
vector134:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $134
80106d31:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106d36:	e9 de f4 ff ff       	jmp    80106219 <alltraps>

80106d3b <vector135>:
.globl vector135
vector135:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $135
80106d3d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106d42:	e9 d2 f4 ff ff       	jmp    80106219 <alltraps>

80106d47 <vector136>:
.globl vector136
vector136:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $136
80106d49:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106d4e:	e9 c6 f4 ff ff       	jmp    80106219 <alltraps>

80106d53 <vector137>:
.globl vector137
vector137:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $137
80106d55:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106d5a:	e9 ba f4 ff ff       	jmp    80106219 <alltraps>

80106d5f <vector138>:
.globl vector138
vector138:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $138
80106d61:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106d66:	e9 ae f4 ff ff       	jmp    80106219 <alltraps>

80106d6b <vector139>:
.globl vector139
vector139:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $139
80106d6d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106d72:	e9 a2 f4 ff ff       	jmp    80106219 <alltraps>

80106d77 <vector140>:
.globl vector140
vector140:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $140
80106d79:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106d7e:	e9 96 f4 ff ff       	jmp    80106219 <alltraps>

80106d83 <vector141>:
.globl vector141
vector141:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $141
80106d85:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106d8a:	e9 8a f4 ff ff       	jmp    80106219 <alltraps>

80106d8f <vector142>:
.globl vector142
vector142:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $142
80106d91:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106d96:	e9 7e f4 ff ff       	jmp    80106219 <alltraps>

80106d9b <vector143>:
.globl vector143
vector143:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $143
80106d9d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106da2:	e9 72 f4 ff ff       	jmp    80106219 <alltraps>

80106da7 <vector144>:
.globl vector144
vector144:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $144
80106da9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106dae:	e9 66 f4 ff ff       	jmp    80106219 <alltraps>

80106db3 <vector145>:
.globl vector145
vector145:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $145
80106db5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106dba:	e9 5a f4 ff ff       	jmp    80106219 <alltraps>

80106dbf <vector146>:
.globl vector146
vector146:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $146
80106dc1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106dc6:	e9 4e f4 ff ff       	jmp    80106219 <alltraps>

80106dcb <vector147>:
.globl vector147
vector147:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $147
80106dcd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106dd2:	e9 42 f4 ff ff       	jmp    80106219 <alltraps>

80106dd7 <vector148>:
.globl vector148
vector148:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $148
80106dd9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106dde:	e9 36 f4 ff ff       	jmp    80106219 <alltraps>

80106de3 <vector149>:
.globl vector149
vector149:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $149
80106de5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106dea:	e9 2a f4 ff ff       	jmp    80106219 <alltraps>

80106def <vector150>:
.globl vector150
vector150:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $150
80106df1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106df6:	e9 1e f4 ff ff       	jmp    80106219 <alltraps>

80106dfb <vector151>:
.globl vector151
vector151:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $151
80106dfd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106e02:	e9 12 f4 ff ff       	jmp    80106219 <alltraps>

80106e07 <vector152>:
.globl vector152
vector152:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $152
80106e09:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106e0e:	e9 06 f4 ff ff       	jmp    80106219 <alltraps>

80106e13 <vector153>:
.globl vector153
vector153:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $153
80106e15:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106e1a:	e9 fa f3 ff ff       	jmp    80106219 <alltraps>

80106e1f <vector154>:
.globl vector154
vector154:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $154
80106e21:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106e26:	e9 ee f3 ff ff       	jmp    80106219 <alltraps>

80106e2b <vector155>:
.globl vector155
vector155:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $155
80106e2d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106e32:	e9 e2 f3 ff ff       	jmp    80106219 <alltraps>

80106e37 <vector156>:
.globl vector156
vector156:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $156
80106e39:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106e3e:	e9 d6 f3 ff ff       	jmp    80106219 <alltraps>

80106e43 <vector157>:
.globl vector157
vector157:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $157
80106e45:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106e4a:	e9 ca f3 ff ff       	jmp    80106219 <alltraps>

80106e4f <vector158>:
.globl vector158
vector158:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $158
80106e51:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106e56:	e9 be f3 ff ff       	jmp    80106219 <alltraps>

80106e5b <vector159>:
.globl vector159
vector159:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $159
80106e5d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106e62:	e9 b2 f3 ff ff       	jmp    80106219 <alltraps>

80106e67 <vector160>:
.globl vector160
vector160:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $160
80106e69:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106e6e:	e9 a6 f3 ff ff       	jmp    80106219 <alltraps>

80106e73 <vector161>:
.globl vector161
vector161:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $161
80106e75:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106e7a:	e9 9a f3 ff ff       	jmp    80106219 <alltraps>

80106e7f <vector162>:
.globl vector162
vector162:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $162
80106e81:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106e86:	e9 8e f3 ff ff       	jmp    80106219 <alltraps>

80106e8b <vector163>:
.globl vector163
vector163:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $163
80106e8d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106e92:	e9 82 f3 ff ff       	jmp    80106219 <alltraps>

80106e97 <vector164>:
.globl vector164
vector164:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $164
80106e99:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106e9e:	e9 76 f3 ff ff       	jmp    80106219 <alltraps>

80106ea3 <vector165>:
.globl vector165
vector165:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $165
80106ea5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106eaa:	e9 6a f3 ff ff       	jmp    80106219 <alltraps>

80106eaf <vector166>:
.globl vector166
vector166:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $166
80106eb1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106eb6:	e9 5e f3 ff ff       	jmp    80106219 <alltraps>

80106ebb <vector167>:
.globl vector167
vector167:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $167
80106ebd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106ec2:	e9 52 f3 ff ff       	jmp    80106219 <alltraps>

80106ec7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $168
80106ec9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106ece:	e9 46 f3 ff ff       	jmp    80106219 <alltraps>

80106ed3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $169
80106ed5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106eda:	e9 3a f3 ff ff       	jmp    80106219 <alltraps>

80106edf <vector170>:
.globl vector170
vector170:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $170
80106ee1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106ee6:	e9 2e f3 ff ff       	jmp    80106219 <alltraps>

80106eeb <vector171>:
.globl vector171
vector171:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $171
80106eed:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106ef2:	e9 22 f3 ff ff       	jmp    80106219 <alltraps>

80106ef7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $172
80106ef9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106efe:	e9 16 f3 ff ff       	jmp    80106219 <alltraps>

80106f03 <vector173>:
.globl vector173
vector173:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $173
80106f05:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106f0a:	e9 0a f3 ff ff       	jmp    80106219 <alltraps>

80106f0f <vector174>:
.globl vector174
vector174:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $174
80106f11:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106f16:	e9 fe f2 ff ff       	jmp    80106219 <alltraps>

80106f1b <vector175>:
.globl vector175
vector175:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $175
80106f1d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106f22:	e9 f2 f2 ff ff       	jmp    80106219 <alltraps>

80106f27 <vector176>:
.globl vector176
vector176:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $176
80106f29:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106f2e:	e9 e6 f2 ff ff       	jmp    80106219 <alltraps>

80106f33 <vector177>:
.globl vector177
vector177:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $177
80106f35:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106f3a:	e9 da f2 ff ff       	jmp    80106219 <alltraps>

80106f3f <vector178>:
.globl vector178
vector178:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $178
80106f41:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106f46:	e9 ce f2 ff ff       	jmp    80106219 <alltraps>

80106f4b <vector179>:
.globl vector179
vector179:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $179
80106f4d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106f52:	e9 c2 f2 ff ff       	jmp    80106219 <alltraps>

80106f57 <vector180>:
.globl vector180
vector180:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $180
80106f59:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106f5e:	e9 b6 f2 ff ff       	jmp    80106219 <alltraps>

80106f63 <vector181>:
.globl vector181
vector181:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $181
80106f65:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106f6a:	e9 aa f2 ff ff       	jmp    80106219 <alltraps>

80106f6f <vector182>:
.globl vector182
vector182:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $182
80106f71:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106f76:	e9 9e f2 ff ff       	jmp    80106219 <alltraps>

80106f7b <vector183>:
.globl vector183
vector183:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $183
80106f7d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106f82:	e9 92 f2 ff ff       	jmp    80106219 <alltraps>

80106f87 <vector184>:
.globl vector184
vector184:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $184
80106f89:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106f8e:	e9 86 f2 ff ff       	jmp    80106219 <alltraps>

80106f93 <vector185>:
.globl vector185
vector185:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $185
80106f95:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106f9a:	e9 7a f2 ff ff       	jmp    80106219 <alltraps>

80106f9f <vector186>:
.globl vector186
vector186:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $186
80106fa1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106fa6:	e9 6e f2 ff ff       	jmp    80106219 <alltraps>

80106fab <vector187>:
.globl vector187
vector187:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $187
80106fad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106fb2:	e9 62 f2 ff ff       	jmp    80106219 <alltraps>

80106fb7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $188
80106fb9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106fbe:	e9 56 f2 ff ff       	jmp    80106219 <alltraps>

80106fc3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $189
80106fc5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106fca:	e9 4a f2 ff ff       	jmp    80106219 <alltraps>

80106fcf <vector190>:
.globl vector190
vector190:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $190
80106fd1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106fd6:	e9 3e f2 ff ff       	jmp    80106219 <alltraps>

80106fdb <vector191>:
.globl vector191
vector191:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $191
80106fdd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106fe2:	e9 32 f2 ff ff       	jmp    80106219 <alltraps>

80106fe7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $192
80106fe9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106fee:	e9 26 f2 ff ff       	jmp    80106219 <alltraps>

80106ff3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $193
80106ff5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106ffa:	e9 1a f2 ff ff       	jmp    80106219 <alltraps>

80106fff <vector194>:
.globl vector194
vector194:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $194
80107001:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107006:	e9 0e f2 ff ff       	jmp    80106219 <alltraps>

8010700b <vector195>:
.globl vector195
vector195:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $195
8010700d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107012:	e9 02 f2 ff ff       	jmp    80106219 <alltraps>

80107017 <vector196>:
.globl vector196
vector196:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $196
80107019:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010701e:	e9 f6 f1 ff ff       	jmp    80106219 <alltraps>

80107023 <vector197>:
.globl vector197
vector197:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $197
80107025:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010702a:	e9 ea f1 ff ff       	jmp    80106219 <alltraps>

8010702f <vector198>:
.globl vector198
vector198:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $198
80107031:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107036:	e9 de f1 ff ff       	jmp    80106219 <alltraps>

8010703b <vector199>:
.globl vector199
vector199:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $199
8010703d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107042:	e9 d2 f1 ff ff       	jmp    80106219 <alltraps>

80107047 <vector200>:
.globl vector200
vector200:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $200
80107049:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010704e:	e9 c6 f1 ff ff       	jmp    80106219 <alltraps>

80107053 <vector201>:
.globl vector201
vector201:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $201
80107055:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010705a:	e9 ba f1 ff ff       	jmp    80106219 <alltraps>

8010705f <vector202>:
.globl vector202
vector202:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $202
80107061:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107066:	e9 ae f1 ff ff       	jmp    80106219 <alltraps>

8010706b <vector203>:
.globl vector203
vector203:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $203
8010706d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107072:	e9 a2 f1 ff ff       	jmp    80106219 <alltraps>

80107077 <vector204>:
.globl vector204
vector204:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $204
80107079:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010707e:	e9 96 f1 ff ff       	jmp    80106219 <alltraps>

80107083 <vector205>:
.globl vector205
vector205:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $205
80107085:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010708a:	e9 8a f1 ff ff       	jmp    80106219 <alltraps>

8010708f <vector206>:
.globl vector206
vector206:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $206
80107091:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107096:	e9 7e f1 ff ff       	jmp    80106219 <alltraps>

8010709b <vector207>:
.globl vector207
vector207:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $207
8010709d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801070a2:	e9 72 f1 ff ff       	jmp    80106219 <alltraps>

801070a7 <vector208>:
.globl vector208
vector208:
  pushl $0
801070a7:	6a 00                	push   $0x0
  pushl $208
801070a9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801070ae:	e9 66 f1 ff ff       	jmp    80106219 <alltraps>

801070b3 <vector209>:
.globl vector209
vector209:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $209
801070b5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801070ba:	e9 5a f1 ff ff       	jmp    80106219 <alltraps>

801070bf <vector210>:
.globl vector210
vector210:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $210
801070c1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801070c6:	e9 4e f1 ff ff       	jmp    80106219 <alltraps>

801070cb <vector211>:
.globl vector211
vector211:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $211
801070cd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801070d2:	e9 42 f1 ff ff       	jmp    80106219 <alltraps>

801070d7 <vector212>:
.globl vector212
vector212:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $212
801070d9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801070de:	e9 36 f1 ff ff       	jmp    80106219 <alltraps>

801070e3 <vector213>:
.globl vector213
vector213:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $213
801070e5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801070ea:	e9 2a f1 ff ff       	jmp    80106219 <alltraps>

801070ef <vector214>:
.globl vector214
vector214:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $214
801070f1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801070f6:	e9 1e f1 ff ff       	jmp    80106219 <alltraps>

801070fb <vector215>:
.globl vector215
vector215:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $215
801070fd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107102:	e9 12 f1 ff ff       	jmp    80106219 <alltraps>

80107107 <vector216>:
.globl vector216
vector216:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $216
80107109:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010710e:	e9 06 f1 ff ff       	jmp    80106219 <alltraps>

80107113 <vector217>:
.globl vector217
vector217:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $217
80107115:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010711a:	e9 fa f0 ff ff       	jmp    80106219 <alltraps>

8010711f <vector218>:
.globl vector218
vector218:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $218
80107121:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107126:	e9 ee f0 ff ff       	jmp    80106219 <alltraps>

8010712b <vector219>:
.globl vector219
vector219:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $219
8010712d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107132:	e9 e2 f0 ff ff       	jmp    80106219 <alltraps>

80107137 <vector220>:
.globl vector220
vector220:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $220
80107139:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010713e:	e9 d6 f0 ff ff       	jmp    80106219 <alltraps>

80107143 <vector221>:
.globl vector221
vector221:
  pushl $0
80107143:	6a 00                	push   $0x0
  pushl $221
80107145:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010714a:	e9 ca f0 ff ff       	jmp    80106219 <alltraps>

8010714f <vector222>:
.globl vector222
vector222:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $222
80107151:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107156:	e9 be f0 ff ff       	jmp    80106219 <alltraps>

8010715b <vector223>:
.globl vector223
vector223:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $223
8010715d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107162:	e9 b2 f0 ff ff       	jmp    80106219 <alltraps>

80107167 <vector224>:
.globl vector224
vector224:
  pushl $0
80107167:	6a 00                	push   $0x0
  pushl $224
80107169:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010716e:	e9 a6 f0 ff ff       	jmp    80106219 <alltraps>

80107173 <vector225>:
.globl vector225
vector225:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $225
80107175:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010717a:	e9 9a f0 ff ff       	jmp    80106219 <alltraps>

8010717f <vector226>:
.globl vector226
vector226:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $226
80107181:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107186:	e9 8e f0 ff ff       	jmp    80106219 <alltraps>

8010718b <vector227>:
.globl vector227
vector227:
  pushl $0
8010718b:	6a 00                	push   $0x0
  pushl $227
8010718d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107192:	e9 82 f0 ff ff       	jmp    80106219 <alltraps>

80107197 <vector228>:
.globl vector228
vector228:
  pushl $0
80107197:	6a 00                	push   $0x0
  pushl $228
80107199:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010719e:	e9 76 f0 ff ff       	jmp    80106219 <alltraps>

801071a3 <vector229>:
.globl vector229
vector229:
  pushl $0
801071a3:	6a 00                	push   $0x0
  pushl $229
801071a5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801071aa:	e9 6a f0 ff ff       	jmp    80106219 <alltraps>

801071af <vector230>:
.globl vector230
vector230:
  pushl $0
801071af:	6a 00                	push   $0x0
  pushl $230
801071b1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801071b6:	e9 5e f0 ff ff       	jmp    80106219 <alltraps>

801071bb <vector231>:
.globl vector231
vector231:
  pushl $0
801071bb:	6a 00                	push   $0x0
  pushl $231
801071bd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801071c2:	e9 52 f0 ff ff       	jmp    80106219 <alltraps>

801071c7 <vector232>:
.globl vector232
vector232:
  pushl $0
801071c7:	6a 00                	push   $0x0
  pushl $232
801071c9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801071ce:	e9 46 f0 ff ff       	jmp    80106219 <alltraps>

801071d3 <vector233>:
.globl vector233
vector233:
  pushl $0
801071d3:	6a 00                	push   $0x0
  pushl $233
801071d5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801071da:	e9 3a f0 ff ff       	jmp    80106219 <alltraps>

801071df <vector234>:
.globl vector234
vector234:
  pushl $0
801071df:	6a 00                	push   $0x0
  pushl $234
801071e1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801071e6:	e9 2e f0 ff ff       	jmp    80106219 <alltraps>

801071eb <vector235>:
.globl vector235
vector235:
  pushl $0
801071eb:	6a 00                	push   $0x0
  pushl $235
801071ed:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801071f2:	e9 22 f0 ff ff       	jmp    80106219 <alltraps>

801071f7 <vector236>:
.globl vector236
vector236:
  pushl $0
801071f7:	6a 00                	push   $0x0
  pushl $236
801071f9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801071fe:	e9 16 f0 ff ff       	jmp    80106219 <alltraps>

80107203 <vector237>:
.globl vector237
vector237:
  pushl $0
80107203:	6a 00                	push   $0x0
  pushl $237
80107205:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010720a:	e9 0a f0 ff ff       	jmp    80106219 <alltraps>

8010720f <vector238>:
.globl vector238
vector238:
  pushl $0
8010720f:	6a 00                	push   $0x0
  pushl $238
80107211:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107216:	e9 fe ef ff ff       	jmp    80106219 <alltraps>

8010721b <vector239>:
.globl vector239
vector239:
  pushl $0
8010721b:	6a 00                	push   $0x0
  pushl $239
8010721d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107222:	e9 f2 ef ff ff       	jmp    80106219 <alltraps>

80107227 <vector240>:
.globl vector240
vector240:
  pushl $0
80107227:	6a 00                	push   $0x0
  pushl $240
80107229:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010722e:	e9 e6 ef ff ff       	jmp    80106219 <alltraps>

80107233 <vector241>:
.globl vector241
vector241:
  pushl $0
80107233:	6a 00                	push   $0x0
  pushl $241
80107235:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010723a:	e9 da ef ff ff       	jmp    80106219 <alltraps>

8010723f <vector242>:
.globl vector242
vector242:
  pushl $0
8010723f:	6a 00                	push   $0x0
  pushl $242
80107241:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107246:	e9 ce ef ff ff       	jmp    80106219 <alltraps>

8010724b <vector243>:
.globl vector243
vector243:
  pushl $0
8010724b:	6a 00                	push   $0x0
  pushl $243
8010724d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107252:	e9 c2 ef ff ff       	jmp    80106219 <alltraps>

80107257 <vector244>:
.globl vector244
vector244:
  pushl $0
80107257:	6a 00                	push   $0x0
  pushl $244
80107259:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010725e:	e9 b6 ef ff ff       	jmp    80106219 <alltraps>

80107263 <vector245>:
.globl vector245
vector245:
  pushl $0
80107263:	6a 00                	push   $0x0
  pushl $245
80107265:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010726a:	e9 aa ef ff ff       	jmp    80106219 <alltraps>

8010726f <vector246>:
.globl vector246
vector246:
  pushl $0
8010726f:	6a 00                	push   $0x0
  pushl $246
80107271:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107276:	e9 9e ef ff ff       	jmp    80106219 <alltraps>

8010727b <vector247>:
.globl vector247
vector247:
  pushl $0
8010727b:	6a 00                	push   $0x0
  pushl $247
8010727d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107282:	e9 92 ef ff ff       	jmp    80106219 <alltraps>

80107287 <vector248>:
.globl vector248
vector248:
  pushl $0
80107287:	6a 00                	push   $0x0
  pushl $248
80107289:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010728e:	e9 86 ef ff ff       	jmp    80106219 <alltraps>

80107293 <vector249>:
.globl vector249
vector249:
  pushl $0
80107293:	6a 00                	push   $0x0
  pushl $249
80107295:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010729a:	e9 7a ef ff ff       	jmp    80106219 <alltraps>

8010729f <vector250>:
.globl vector250
vector250:
  pushl $0
8010729f:	6a 00                	push   $0x0
  pushl $250
801072a1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801072a6:	e9 6e ef ff ff       	jmp    80106219 <alltraps>

801072ab <vector251>:
.globl vector251
vector251:
  pushl $0
801072ab:	6a 00                	push   $0x0
  pushl $251
801072ad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801072b2:	e9 62 ef ff ff       	jmp    80106219 <alltraps>

801072b7 <vector252>:
.globl vector252
vector252:
  pushl $0
801072b7:	6a 00                	push   $0x0
  pushl $252
801072b9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801072be:	e9 56 ef ff ff       	jmp    80106219 <alltraps>

801072c3 <vector253>:
.globl vector253
vector253:
  pushl $0
801072c3:	6a 00                	push   $0x0
  pushl $253
801072c5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801072ca:	e9 4a ef ff ff       	jmp    80106219 <alltraps>

801072cf <vector254>:
.globl vector254
vector254:
  pushl $0
801072cf:	6a 00                	push   $0x0
  pushl $254
801072d1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801072d6:	e9 3e ef ff ff       	jmp    80106219 <alltraps>

801072db <vector255>:
.globl vector255
vector255:
  pushl $0
801072db:	6a 00                	push   $0x0
  pushl $255
801072dd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801072e2:	e9 32 ef ff ff       	jmp    80106219 <alltraps>
801072e7:	66 90                	xchg   %ax,%ax
801072e9:	66 90                	xchg   %ax,%ax
801072eb:	66 90                	xchg   %ax,%ax
801072ed:	66 90                	xchg   %ax,%ax
801072ef:	90                   	nop

801072f0 <cow_kfree>:
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc);
int swap_in(struct proc* p, struct pageinfo* pi);
void swap_out(struct proc* p, struct pageinfo* page_to_swap, void* buffer, pde_t* pgdir);

void cow_kfree(char* to_free_kva){
801072f0:	55                   	push   %ebp
801072f1:	89 e5                	mov    %esp,%ebp
801072f3:	56                   	push   %esi
801072f4:	53                   	push   %ebx
801072f5:	8b 75 08             	mov    0x8(%ebp),%esi
  char count;
  int acq = 0;
  if (lapicid() != 0 && !holding(cow_lock)){
801072f8:	e8 93 bc ff ff       	call   80102f90 <lapicid>
801072fd:	8d 9e 00 00 00 80    	lea    -0x80000000(%esi),%ebx
80107303:	c1 eb 0c             	shr    $0xc,%ebx
80107306:	85 c0                	test   %eax,%eax
80107308:	75 36                	jne    80107340 <cow_kfree+0x50>
    acquire(cow_lock);
  }
  // struct proc* p = myproc();
  // if (p != 0 ){ // && p->pid > 2
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
  if (count != 0){
8010730a:	80 ab 40 1f 11 80 01 	subb   $0x1,-0x7feee0c0(%ebx)
80107311:	74 1e                	je     80107331 <cow_kfree+0x41>
  if (acq){
    // cprintf("rel kfree %d\n", myproc()->pid);
    release(cow_lock);
  }
  kfree(to_free_kva);
}
80107313:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107316:	5b                   	pop    %ebx
80107317:	5e                   	pop    %esi
80107318:	5d                   	pop    %ebp
80107319:	c3                   	ret    
8010731a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(cow_lock);
80107320:	83 ec 0c             	sub    $0xc,%esp
80107323:	ff 35 40 ff 11 80    	pushl  0x8011ff40
80107329:	e8 72 dc ff ff       	call   80104fa0 <release>
8010732e:	83 c4 10             	add    $0x10,%esp
  kfree(to_free_kva);
80107331:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107334:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107337:	5b                   	pop    %ebx
80107338:	5e                   	pop    %esi
80107339:	5d                   	pop    %ebp
  kfree(to_free_kva);
8010733a:	e9 01 b8 ff ff       	jmp    80102b40 <kfree>
8010733f:	90                   	nop
  if (lapicid() != 0 && !holding(cow_lock)){
80107340:	83 ec 0c             	sub    $0xc,%esp
80107343:	ff 35 40 ff 11 80    	pushl  0x8011ff40
80107349:	e8 62 db ff ff       	call   80104eb0 <holding>
8010734e:	83 c4 10             	add    $0x10,%esp
80107351:	85 c0                	test   %eax,%eax
80107353:	75 b5                	jne    8010730a <cow_kfree+0x1a>
    acquire(cow_lock);
80107355:	83 ec 0c             	sub    $0xc,%esp
80107358:	ff 35 40 ff 11 80    	pushl  0x8011ff40
8010735e:	e8 7d db ff ff       	call   80104ee0 <acquire>
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
80107363:	0f b6 83 40 1f 11 80 	movzbl -0x7feee0c0(%ebx),%eax
  if (count != 0){
8010736a:	83 c4 10             	add    $0x10,%esp
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
8010736d:	83 e8 01             	sub    $0x1,%eax
  if (count != 0){
80107370:	84 c0                	test   %al,%al
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
80107372:	88 83 40 1f 11 80    	mov    %al,-0x7feee0c0(%ebx)
  if (count != 0){
80107378:	74 a6                	je     80107320 <cow_kfree+0x30>
      release(cow_lock);
8010737a:	a1 40 ff 11 80       	mov    0x8011ff40,%eax
8010737f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80107382:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107385:	5b                   	pop    %ebx
80107386:	5e                   	pop    %esi
80107387:	5d                   	pop    %ebp
      release(cow_lock);
80107388:	e9 13 dc ff ff       	jmp    80104fa0 <release>
8010738d:	8d 76 00             	lea    0x0(%esi),%esi

80107390 <cow_kalloc>:

char* cow_kalloc(){
80107390:	55                   	push   %ebp
80107391:	89 e5                	mov    %esp,%ebp
80107393:	57                   	push   %edi
80107394:	56                   	push   %esi
80107395:	53                   	push   %ebx
80107396:	83 ec 0c             	sub    $0xc,%esp
  char* r = kalloc();
80107399:	e8 82 b9 ff ff       	call   80102d20 <kalloc>
  if (r == 0){
8010739e:	85 c0                	test   %eax,%eax
  char* r = kalloc();
801073a0:	89 c3                	mov    %eax,%ebx
  if (r == 0){
801073a2:	74 28                	je     801073cc <cow_kalloc+0x3c>
801073a4:	8d bb 00 00 00 80    	lea    -0x80000000(%ebx),%edi
    return r;
  }
  int acq = 0;
  // cprintf("kalloc \n");
  if (lapicid() != 0 && !holding(cow_lock)){
801073aa:	e8 e1 bb ff ff       	call   80102f90 <lapicid>
801073af:	89 fe                	mov    %edi,%esi
801073b1:	c1 ee 0c             	shr    $0xc,%esi
801073b4:	85 c0                	test   %eax,%eax
801073b6:	75 28                	jne    801073e0 <cow_kalloc+0x50>
    acq = 1;
    // cprintf("kalloc %d\n", myproc()->pid);
    acquire(cow_lock);
  }
  if (pg_ref_counts[PGROUNDDOWN(V2P(r)) / PGSIZE]++ != 0){ 
801073b8:	0f b6 86 40 1f 11 80 	movzbl -0x7feee0c0(%esi),%eax
801073bf:	8d 50 01             	lea    0x1(%eax),%edx
801073c2:	84 c0                	test   %al,%al
801073c4:	88 96 40 1f 11 80    	mov    %dl,-0x7feee0c0(%esi)
801073ca:	75 69                	jne    80107435 <cow_kalloc+0xa5>
  }
  if (acq){
    release(cow_lock);
  }
  return r;
}
801073cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073cf:	89 d8                	mov    %ebx,%eax
801073d1:	5b                   	pop    %ebx
801073d2:	5e                   	pop    %esi
801073d3:	5f                   	pop    %edi
801073d4:	5d                   	pop    %ebp
801073d5:	c3                   	ret    
801073d6:	8d 76 00             	lea    0x0(%esi),%esi
801073d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if (lapicid() != 0 && !holding(cow_lock)){
801073e0:	83 ec 0c             	sub    $0xc,%esp
801073e3:	ff 35 40 ff 11 80    	pushl  0x8011ff40
801073e9:	e8 c2 da ff ff       	call   80104eb0 <holding>
801073ee:	83 c4 10             	add    $0x10,%esp
801073f1:	85 c0                	test   %eax,%eax
801073f3:	75 c3                	jne    801073b8 <cow_kalloc+0x28>
    acquire(cow_lock);
801073f5:	83 ec 0c             	sub    $0xc,%esp
801073f8:	ff 35 40 ff 11 80    	pushl  0x8011ff40
801073fe:	e8 dd da ff ff       	call   80104ee0 <acquire>
  if (pg_ref_counts[PGROUNDDOWN(V2P(r)) / PGSIZE]++ != 0){ 
80107403:	0f b6 86 40 1f 11 80 	movzbl -0x7feee0c0(%esi),%eax
8010740a:	83 c4 10             	add    $0x10,%esp
8010740d:	8d 50 01             	lea    0x1(%eax),%edx
80107410:	84 c0                	test   %al,%al
80107412:	88 96 40 1f 11 80    	mov    %dl,-0x7feee0c0(%esi)
80107418:	75 1b                	jne    80107435 <cow_kalloc+0xa5>
      release(cow_lock);
8010741a:	83 ec 0c             	sub    $0xc,%esp
8010741d:	ff 35 40 ff 11 80    	pushl  0x8011ff40
80107423:	e8 78 db ff ff       	call   80104fa0 <release>
80107428:	83 c4 10             	add    $0x10,%esp
}
8010742b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010742e:	89 d8                	mov    %ebx,%eax
80107430:	5b                   	pop    %ebx
80107431:	5e                   	pop    %esi
80107432:	5f                   	pop    %edi
80107433:	5d                   	pop    %ebp
80107434:	c3                   	ret    
    cprintf("actual ref count = %d, pg index = %x, pg pa = %x\n", pg_ref_counts[PGROUNDDOWN(V2P(r)) / PGSIZE] - 1, PGROUNDDOWN(V2P(r)) / PGSIZE, V2P(r));
80107435:	0f be c2             	movsbl %dl,%eax
80107438:	57                   	push   %edi
80107439:	56                   	push   %esi
8010743a:	83 e8 01             	sub    $0x1,%eax
8010743d:	50                   	push   %eax
8010743e:	68 b0 90 10 80       	push   $0x801090b0
80107443:	e8 18 92 ff ff       	call   80100660 <cprintf>
    panic("kalloc allocated something with a reference");
80107448:	c7 04 24 e4 90 10 80 	movl   $0x801090e4,(%esp)
8010744f:	e8 3c 8f ff ff       	call   80100390 <panic>
80107454:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010745a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107460 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107460:	55                   	push   %ebp
80107461:	89 e5                	mov    %esp,%ebp
80107463:	57                   	push   %edi
80107464:	56                   	push   %esi
80107465:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107466:	89 d3                	mov    %edx,%ebx
{
80107468:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010746a:	c1 eb 16             	shr    $0x16,%ebx
8010746d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107470:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107473:	8b 06                	mov    (%esi),%eax
80107475:	a8 01                	test   $0x1,%al
80107477:	74 27                	je     801074a0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107479:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010747e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107484:	c1 ef 0a             	shr    $0xa,%edi
}
80107487:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010748a:	89 fa                	mov    %edi,%edx
8010748c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107492:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107495:	5b                   	pop    %ebx
80107496:	5e                   	pop    %esi
80107497:	5f                   	pop    %edi
80107498:	5d                   	pop    %ebp
80107499:	c3                   	ret    
8010749a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)cow_kalloc()) == 0)
801074a0:	85 c9                	test   %ecx,%ecx
801074a2:	74 2c                	je     801074d0 <walkpgdir+0x70>
801074a4:	e8 e7 fe ff ff       	call   80107390 <cow_kalloc>
801074a9:	85 c0                	test   %eax,%eax
801074ab:	89 c3                	mov    %eax,%ebx
801074ad:	74 21                	je     801074d0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801074af:	83 ec 04             	sub    $0x4,%esp
801074b2:	68 00 10 00 00       	push   $0x1000
801074b7:	6a 00                	push   $0x0
801074b9:	50                   	push   %eax
801074ba:	e8 31 db ff ff       	call   80104ff0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801074bf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801074c5:	83 c4 10             	add    $0x10,%esp
801074c8:	83 c8 07             	or     $0x7,%eax
801074cb:	89 06                	mov    %eax,(%esi)
801074cd:	eb b5                	jmp    80107484 <walkpgdir+0x24>
801074cf:	90                   	nop
}
801074d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801074d3:	31 c0                	xor    %eax,%eax
}
801074d5:	5b                   	pop    %ebx
801074d6:	5e                   	pop    %esi
801074d7:	5f                   	pop    %edi
801074d8:	5d                   	pop    %ebp
801074d9:	c3                   	ret    
801074da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801074e0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801074e0:	55                   	push   %ebp
801074e1:	89 e5                	mov    %esp,%ebp
801074e3:	57                   	push   %edi
801074e4:	56                   	push   %esi
801074e5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801074e6:	89 d3                	mov    %edx,%ebx
801074e8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801074ee:	83 ec 1c             	sub    $0x1c,%esp
801074f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801074f4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801074f8:	8b 7d 08             	mov    0x8(%ebp),%edi
801074fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107500:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107503:	8b 45 0c             	mov    0xc(%ebp),%eax
80107506:	29 df                	sub    %ebx,%edi
80107508:	83 c8 01             	or     $0x1,%eax
8010750b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010750e:	eb 15                	jmp    80107525 <mappages+0x45>
    if(*pte & PTE_P)
80107510:	f6 00 01             	testb  $0x1,(%eax)
80107513:	75 45                	jne    8010755a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107515:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107518:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010751b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010751d:	74 31                	je     80107550 <mappages+0x70>
      break;
    a += PGSIZE;
8010751f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107525:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107528:	b9 01 00 00 00       	mov    $0x1,%ecx
8010752d:	89 da                	mov    %ebx,%edx
8010752f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107532:	e8 29 ff ff ff       	call   80107460 <walkpgdir>
80107537:	85 c0                	test   %eax,%eax
80107539:	75 d5                	jne    80107510 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010753b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010753e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107543:	5b                   	pop    %ebx
80107544:	5e                   	pop    %esi
80107545:	5f                   	pop    %edi
80107546:	5d                   	pop    %ebp
80107547:	c3                   	ret    
80107548:	90                   	nop
80107549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107550:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107553:	31 c0                	xor    %eax,%eax
}
80107555:	5b                   	pop    %ebx
80107556:	5e                   	pop    %esi
80107557:	5f                   	pop    %edi
80107558:	5d                   	pop    %ebp
80107559:	c3                   	ret    
      panic("remap");
8010755a:	83 ec 0c             	sub    $0xc,%esp
8010755d:	68 88 91 10 80       	push   $0x80109188
80107562:	e8 29 8e ff ff       	call   80100390 <panic>
80107567:	89 f6                	mov    %esi,%esi
80107569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107570 <print_user_char>:
void print_user_char(pde_t* pgdir, void* uva){
80107570:	55                   	push   %ebp
  cprintf("%x\n", *(char *) P2V(PTE_ADDR(*(walkpgdir(pgdir, uva, 0)))));
80107571:	31 c9                	xor    %ecx,%ecx
void print_user_char(pde_t* pgdir, void* uva){
80107573:	89 e5                	mov    %esp,%ebp
80107575:	83 ec 08             	sub    $0x8,%esp
  cprintf("%x\n", *(char *) P2V(PTE_ADDR(*(walkpgdir(pgdir, uva, 0)))));
80107578:	8b 55 0c             	mov    0xc(%ebp),%edx
8010757b:	8b 45 08             	mov    0x8(%ebp),%eax
8010757e:	e8 dd fe ff ff       	call   80107460 <walkpgdir>
80107583:	8b 00                	mov    (%eax),%eax
80107585:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010758a:	0f be 80 00 00 00 80 	movsbl -0x80000000(%eax),%eax
80107591:	c7 45 08 83 92 10 80 	movl   $0x80109283,0x8(%ebp)
80107598:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010759b:	c9                   	leave  
  cprintf("%x\n", *(char *) P2V(PTE_ADDR(*(walkpgdir(pgdir, uva, 0)))));
8010759c:	e9 bf 90 ff ff       	jmp    80100660 <cprintf>
801075a1:	eb 0d                	jmp    801075b0 <update_age>
801075a3:	90                   	nop
801075a4:	90                   	nop
801075a5:	90                   	nop
801075a6:	90                   	nop
801075a7:	90                   	nop
801075a8:	90                   	nop
801075a9:	90                   	nop
801075aa:	90                   	nop
801075ab:	90                   	nop
801075ac:	90                   	nop
801075ad:	90                   	nop
801075ae:	90                   	nop
801075af:	90                   	nop

801075b0 <update_age>:
void update_age(struct proc* p){
801075b0:	55                   	push   %ebp
801075b1:	89 e5                	mov    %esp,%ebp
801075b3:	57                   	push   %edi
801075b4:	56                   	push   %esi
801075b5:	53                   	push   %ebx
801075b6:	83 ec 0c             	sub    $0xc,%esp
801075b9:	8b 7d 08             	mov    0x8(%ebp),%edi
801075bc:	8b 47 04             	mov    0x4(%edi),%eax
801075bf:	8d 9f 00 02 00 00    	lea    0x200(%edi),%ebx
801075c5:	8d b7 80 03 00 00    	lea    0x380(%edi),%esi
801075cb:	eb 0a                	jmp    801075d7 <update_age+0x27>
801075cd:	8d 76 00             	lea    0x0(%esi),%esi
801075d0:	83 c3 18             	add    $0x18,%ebx
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
801075d3:	39 f3                	cmp    %esi,%ebx
801075d5:	74 32                	je     80107609 <update_age+0x59>
    if (!(pi->is_free)){
801075d7:	8b 13                	mov    (%ebx),%edx
801075d9:	85 d2                	test   %edx,%edx
801075db:	75 f3                	jne    801075d0 <update_age+0x20>
      pi->aging_counter =  pi->aging_counter >> 1;
801075dd:	d1 6b 08             	shrl   0x8(%ebx)
      pte_t* pte = walkpgdir(p->pgdir,(void*) pi->va, 0);
801075e0:	8b 53 10             	mov    0x10(%ebx),%edx
801075e3:	31 c9                	xor    %ecx,%ecx
801075e5:	e8 76 fe ff ff       	call   80107460 <walkpgdir>
      if(!(uint)*pte){
801075ea:	8b 10                	mov    (%eax),%edx
801075ec:	85 d2                	test   %edx,%edx
801075ee:	74 29                	je     80107619 <update_age+0x69>
      if (*pte & PTE_A){
801075f0:	83 e2 20             	and    $0x20,%edx
801075f3:	74 0a                	je     801075ff <update_age+0x4f>
        pi->aging_counter = pi->aging_counter| 0x80000000;//(1<<31);
801075f5:	81 4b 08 00 00 00 80 	orl    $0x80000000,0x8(%ebx)
        *pte &= ~PTE_A;
801075fc:	83 20 df             	andl   $0xffffffdf,(%eax)
801075ff:	83 c3 18             	add    $0x18,%ebx
80107602:	8b 47 04             	mov    0x4(%edi),%eax
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107605:	39 f3                	cmp    %esi,%ebx
80107607:	75 ce                	jne    801075d7 <update_age+0x27>
  lcr3(V2P(p->pgdir));//verify
80107609:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010760e:	0f 22 d8             	mov    %eax,%cr3
}
80107611:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107614:	5b                   	pop    %ebx
80107615:	5e                   	pop    %esi
80107616:	5f                   	pop    %edi
80107617:	5d                   	pop    %ebp
80107618:	c3                   	ret    
        panic("can't find page from NFUA");
80107619:	83 ec 0c             	sub    $0xc,%esp
8010761c:	68 8e 91 10 80       	push   $0x8010918e
80107621:	e8 6a 8d ff ff       	call   80100390 <panic>
80107626:	8d 76 00             	lea    0x0(%esi),%esi
80107629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107630 <count_ones>:
unsigned int count_ones(unsigned int n) { 
80107630:	55                   	push   %ebp
    unsigned int count = 0; 
80107631:	31 c0                	xor    %eax,%eax
unsigned int count_ones(unsigned int n) { 
80107633:	89 e5                	mov    %esp,%ebp
80107635:	8b 55 08             	mov    0x8(%ebp),%edx
    while (n) { 
80107638:	85 d2                	test   %edx,%edx
8010763a:	74 0f                	je     8010764b <count_ones+0x1b>
8010763c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        count += n & 1; 
80107640:	89 d1                	mov    %edx,%ecx
80107642:	83 e1 01             	and    $0x1,%ecx
80107645:	01 c8                	add    %ecx,%eax
    while (n) { 
80107647:	d1 ea                	shr    %edx
80107649:	75 f5                	jne    80107640 <count_ones+0x10>
} 
8010764b:	5d                   	pop    %ebp
8010764c:	c3                   	ret    
8010764d:	8d 76 00             	lea    0x0(%esi),%esi

80107650 <find_page_to_swap_lapa>:
struct pageinfo* find_page_to_swap_lapa(struct proc* p, pde_t* pgdir){
80107650:	55                   	push   %ebp
80107651:	89 e5                	mov    %esp,%ebp
80107653:	57                   	push   %edi
80107654:	56                   	push   %esi
80107655:	53                   	push   %ebx
80107656:	8d 4d a8             	lea    -0x58(%ebp),%ecx
80107659:	8d 7d e8             	lea    -0x18(%ebp),%edi
8010765c:	83 ec 5c             	sub    $0x5c,%esp
8010765f:	8b 45 08             	mov    0x8(%ebp),%eax
80107662:	8d b0 08 02 00 00    	lea    0x208(%eax),%esi
80107668:	eb 10                	jmp    8010767a <find_page_to_swap_lapa+0x2a>
8010766a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107670:	83 c1 04             	add    $0x4,%ecx
80107673:	83 c6 18             	add    $0x18,%esi
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107676:	39 f9                	cmp    %edi,%ecx
80107678:	74 2d                	je     801076a7 <find_page_to_swap_lapa+0x57>
    if (!p->ram_pages[i].is_free){
8010767a:	8b 46 f8             	mov    -0x8(%esi),%eax
    num_of_ones[i]= MAX_UINT;
8010767d:	c7 01 ff ff ff ff    	movl   $0xffffffff,(%ecx)
    if (!p->ram_pages[i].is_free){
80107683:	85 c0                	test   %eax,%eax
80107685:	75 e9                	jne    80107670 <find_page_to_swap_lapa+0x20>
      num_of_ones[i]= count_ones(p->ram_pages[i].aging_counter);
80107687:	8b 06                	mov    (%esi),%eax
    unsigned int count = 0; 
80107689:	31 d2                	xor    %edx,%edx
    while (n) { 
8010768b:	85 c0                	test   %eax,%eax
8010768d:	74 0c                	je     8010769b <find_page_to_swap_lapa+0x4b>
8010768f:	90                   	nop
        count += n & 1; 
80107690:	89 c3                	mov    %eax,%ebx
80107692:	83 e3 01             	and    $0x1,%ebx
80107695:	01 da                	add    %ebx,%edx
    while (n) { 
80107697:	d1 e8                	shr    %eax
80107699:	75 f5                	jne    80107690 <find_page_to_swap_lapa+0x40>
      num_of_ones[i]= count_ones(p->ram_pages[i].aging_counter);
8010769b:	89 11                	mov    %edx,(%ecx)
8010769d:	83 c1 04             	add    $0x4,%ecx
801076a0:	83 c6 18             	add    $0x18,%esi
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
801076a3:	39 f9                	cmp    %edi,%ecx
801076a5:	75 d3                	jne    8010767a <find_page_to_swap_lapa+0x2a>
  cprintf("\n");
801076a7:	83 ec 0c             	sub    $0xc,%esp
  uint min_age_value = 0xFFFFFFFF;
801076aa:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  uint min_num_of_ones = 0xFFFFFFFF;
801076af:	be ff ff ff ff       	mov    $0xffffffff,%esi
  cprintf("\n");
801076b4:	68 d9 92 10 80       	push   $0x801092d9
801076b9:	e8 a2 8f ff ff       	call   80100660 <cprintf>
801076be:	8b 45 08             	mov    0x8(%ebp),%eax
801076c1:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
801076c4:	31 c9                	xor    %ecx,%ecx
  uint min_num_of_ones = 0xFFFFFFFF;
801076c6:	89 7d a4             	mov    %edi,-0x5c(%ebp)
801076c9:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
  struct pageinfo* min_pi = 0;
801076cf:	31 c0                	xor    %eax,%eax
801076d1:	eb 1a                	jmp    801076ed <find_page_to_swap_lapa+0x9d>
801076d3:	90                   	nop
801076d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076d8:	8b 42 08             	mov    0x8(%edx),%eax
801076db:	89 45 a4             	mov    %eax,-0x5c(%ebp)
801076de:	89 d0                	mov    %edx,%eax
    if (!pi->is_free && ((num_of_ones[i] < min_num_of_ones)||(num_of_ones[i] == min_num_of_ones &&  pi->aging_counter < min_age_value))){
801076e0:	89 de                	mov    %ebx,%esi
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
801076e2:	83 c1 01             	add    $0x1,%ecx
801076e5:	83 c2 18             	add    $0x18,%edx
801076e8:	83 f9 10             	cmp    $0x10,%ecx
801076eb:	74 23                	je     80107710 <find_page_to_swap_lapa+0xc0>
    if (!pi->is_free && ((num_of_ones[i] < min_num_of_ones)||(num_of_ones[i] == min_num_of_ones &&  pi->aging_counter < min_age_value))){
801076ed:	8b 1a                	mov    (%edx),%ebx
801076ef:	85 db                	test   %ebx,%ebx
801076f1:	75 ef                	jne    801076e2 <find_page_to_swap_lapa+0x92>
801076f3:	8b 5c 8d a8          	mov    -0x58(%ebp,%ecx,4),%ebx
801076f7:	39 f3                	cmp    %esi,%ebx
801076f9:	72 dd                	jb     801076d8 <find_page_to_swap_lapa+0x88>
801076fb:	75 e5                	jne    801076e2 <find_page_to_swap_lapa+0x92>
801076fd:	8b 7a 08             	mov    0x8(%edx),%edi
80107700:	3b 7d a4             	cmp    -0x5c(%ebp),%edi
80107703:	73 dd                	jae    801076e2 <find_page_to_swap_lapa+0x92>
80107705:	89 7d a4             	mov    %edi,-0x5c(%ebp)
80107708:	eb d4                	jmp    801076de <find_page_to_swap_lapa+0x8e>
8010770a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80107710:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107713:	5b                   	pop    %ebx
80107714:	5e                   	pop    %esi
80107715:	5f                   	pop    %edi
80107716:	5d                   	pop    %ebp
80107717:	c3                   	ret    
80107718:	90                   	nop
80107719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107720 <find_page_to_swap>:
struct pageinfo* find_page_to_swap(struct proc* p, pde_t* pgdir){
80107720:	55                   	push   %ebp
80107721:	89 e5                	mov    %esp,%ebp
80107723:	56                   	push   %esi
80107724:	53                   	push   %ebx
80107725:	8b 5d 08             	mov    0x8(%ebp),%ebx
80107728:	8b 75 0c             	mov    0xc(%ebp),%esi
    update_age(p);
8010772b:	83 ec 0c             	sub    $0xc,%esp
8010772e:	53                   	push   %ebx
8010772f:	e8 7c fe ff ff       	call   801075b0 <update_age>
    pi = find_page_to_swap_lapa(p,pgdir);
80107734:	89 75 0c             	mov    %esi,0xc(%ebp)
80107737:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010773a:	83 c4 10             	add    $0x10,%esp
}
8010773d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107740:	5b                   	pop    %ebx
80107741:	5e                   	pop    %esi
80107742:	5d                   	pop    %ebp
    pi = find_page_to_swap_lapa(p,pgdir);
80107743:	e9 08 ff ff ff       	jmp    80107650 <find_page_to_swap_lapa>
80107748:	90                   	nop
80107749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107750 <find_page_to_swap1>:
struct pageinfo* find_page_to_swap1(struct proc* p, pde_t* pgdir){
80107750:	55                   	push   %ebp
  j = j % 16;
80107751:	99                   	cltd   
80107752:	c1 ea 1c             	shr    $0x1c,%edx
struct pageinfo* find_page_to_swap1(struct proc* p, pde_t* pgdir){
80107755:	89 e5                	mov    %esp,%ebp
80107757:	57                   	push   %edi
80107758:	56                   	push   %esi
80107759:	53                   	push   %ebx
  j = j % 16;
8010775a:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
8010775d:	83 e3 0f             	and    $0xf,%ebx
struct pageinfo* find_page_to_swap1(struct proc* p, pde_t* pgdir){
80107760:	83 ec 14             	sub    $0x14,%esp
  j = j % 16;
80107763:	29 d3                	sub    %edx,%ebx
  cprintf("%d\n", j);
80107765:	53                   	push   %ebx
  for (int i = j; i != (j - 1) % 16; i = (i + 1) % 16){
80107766:	8d 73 ff             	lea    -0x1(%ebx),%esi
  cprintf("%d\n", j);
80107769:	68 d4 8b 10 80       	push   $0x80108bd4
8010776e:	e8 ed 8e ff ff       	call   80100660 <cprintf>
  for (int i = j; i != (j - 1) % 16; i = (i + 1) % 16){
80107773:	89 f0                	mov    %esi,%eax
80107775:	83 c4 10             	add    $0x10,%esp
80107778:	c1 f8 1f             	sar    $0x1f,%eax
8010777b:	c1 e8 1c             	shr    $0x1c,%eax
8010777e:	01 c6                	add    %eax,%esi
80107780:	83 e6 0f             	and    $0xf,%esi
80107783:	29 c6                	sub    %eax,%esi
80107785:	39 f3                	cmp    %esi,%ebx
80107787:	74 57                	je     801077e0 <find_page_to_swap1+0x90>
80107789:	89 df                	mov    %ebx,%edi
8010778b:	eb 17                	jmp    801077a4 <find_page_to_swap1+0x54>
8010778d:	8d 76 00             	lea    0x0(%esi),%esi
80107790:	8d 47 01             	lea    0x1(%edi),%eax
80107793:	99                   	cltd   
80107794:	c1 ea 1c             	shr    $0x1c,%edx
80107797:	01 d0                	add    %edx,%eax
80107799:	83 e0 0f             	and    $0xf,%eax
8010779c:	29 d0                	sub    %edx,%eax
8010779e:	39 f0                	cmp    %esi,%eax
801077a0:	89 c7                	mov    %eax,%edi
801077a2:	74 3c                	je     801077e0 <find_page_to_swap1+0x90>
    cprintf("%d\n", j);
801077a4:	83 ec 08             	sub    $0x8,%esp
801077a7:	53                   	push   %ebx
801077a8:	68 d4 8b 10 80       	push   $0x80108bd4
801077ad:	e8 ae 8e ff ff       	call   80100660 <cprintf>
    if (!p->ram_pages[i].is_free){
801077b2:	8d 14 7f             	lea    (%edi,%edi,2),%edx
801077b5:	8b 45 08             	mov    0x8(%ebp),%eax
801077b8:	83 c4 10             	add    $0x10,%esp
801077bb:	c1 e2 03             	shl    $0x3,%edx
801077be:	8b 8c 10 00 02 00 00 	mov    0x200(%eax,%edx,1),%ecx
801077c5:	85 c9                	test   %ecx,%ecx
801077c7:	75 c7                	jne    80107790 <find_page_to_swap1+0x40>
}
801077c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return &p->ram_pages[i];
801077cc:	8d 84 10 00 02 00 00 	lea    0x200(%eax,%edx,1),%eax
}
801077d3:	5b                   	pop    %ebx
801077d4:	5e                   	pop    %esi
801077d5:	5f                   	pop    %edi
801077d6:	5d                   	pop    %ebp
801077d7:	c3                   	ret    
801077d8:	90                   	nop
801077d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801077e3:	31 c0                	xor    %eax,%eax
}
801077e5:	5b                   	pop    %ebx
801077e6:	5e                   	pop    %esi
801077e7:	5f                   	pop    %edi
801077e8:	5d                   	pop    %ebp
801077e9:	c3                   	ret    
801077ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801077f0 <seginit>:
{
801077f0:	55                   	push   %ebp
801077f1:	89 e5                	mov    %esp,%ebp
801077f3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801077f6:	e8 a5 c8 ff ff       	call   801040a0 <cpuid>
801077fb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107801:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107806:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010780a:	c7 80 78 28 12 80 ff 	movl   $0xffff,-0x7fedd788(%eax)
80107811:	ff 00 00 
80107814:	c7 80 7c 28 12 80 00 	movl   $0xcf9a00,-0x7fedd784(%eax)
8010781b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010781e:	c7 80 80 28 12 80 ff 	movl   $0xffff,-0x7fedd780(%eax)
80107825:	ff 00 00 
80107828:	c7 80 84 28 12 80 00 	movl   $0xcf9200,-0x7fedd77c(%eax)
8010782f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107832:	c7 80 88 28 12 80 ff 	movl   $0xffff,-0x7fedd778(%eax)
80107839:	ff 00 00 
8010783c:	c7 80 8c 28 12 80 00 	movl   $0xcffa00,-0x7fedd774(%eax)
80107843:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107846:	c7 80 90 28 12 80 ff 	movl   $0xffff,-0x7fedd770(%eax)
8010784d:	ff 00 00 
80107850:	c7 80 94 28 12 80 00 	movl   $0xcff200,-0x7fedd76c(%eax)
80107857:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010785a:	05 70 28 12 80       	add    $0x80122870,%eax
  pd[1] = (uint)p;
8010785f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107863:	c1 e8 10             	shr    $0x10,%eax
80107866:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010786a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010786d:	0f 01 10             	lgdtl  (%eax)
}
80107870:	c9                   	leave  
80107871:	c3                   	ret    
80107872:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107880 <public_walkpgdir>:
public_walkpgdir(pde_t *pgdir, const void *va, int alloc){
80107880:	55                   	push   %ebp
80107881:	89 e5                	mov    %esp,%ebp
  return walkpgdir(pgdir, va, alloc);
80107883:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107886:	8b 55 0c             	mov    0xc(%ebp),%edx
80107889:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010788c:	5d                   	pop    %ebp
  return walkpgdir(pgdir, va, alloc);
8010788d:	e9 ce fb ff ff       	jmp    80107460 <walkpgdir>
80107892:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801078a0 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801078a0:	a1 24 2a 13 80       	mov    0x80132a24,%eax
{
801078a5:	55                   	push   %ebp
801078a6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801078a8:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801078ad:	0f 22 d8             	mov    %eax,%cr3
}
801078b0:	5d                   	pop    %ebp
801078b1:	c3                   	ret    
801078b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801078c0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801078c0:	55                   	push   %ebp
801078c1:	89 e5                	mov    %esp,%ebp
801078c3:	57                   	push   %edi
801078c4:	56                   	push   %esi
801078c5:	53                   	push   %ebx
801078c6:	83 ec 1c             	sub    $0x1c,%esp
801078c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
801078cc:	85 db                	test   %ebx,%ebx
801078ce:	0f 84 cb 00 00 00    	je     8010799f <switchuvm+0xdf>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801078d4:	8b 43 08             	mov    0x8(%ebx),%eax
801078d7:	85 c0                	test   %eax,%eax
801078d9:	0f 84 da 00 00 00    	je     801079b9 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801078df:	8b 43 04             	mov    0x4(%ebx),%eax
801078e2:	85 c0                	test   %eax,%eax
801078e4:	0f 84 c2 00 00 00    	je     801079ac <switchuvm+0xec>
    panic("switchuvm: no pgdir");

  pushcli();
801078ea:	e8 21 d5 ff ff       	call   80104e10 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801078ef:	e8 1c c7 ff ff       	call   80104010 <mycpu>
801078f4:	89 c6                	mov    %eax,%esi
801078f6:	e8 15 c7 ff ff       	call   80104010 <mycpu>
801078fb:	89 c7                	mov    %eax,%edi
801078fd:	e8 0e c7 ff ff       	call   80104010 <mycpu>
80107902:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107905:	83 c7 08             	add    $0x8,%edi
80107908:	e8 03 c7 ff ff       	call   80104010 <mycpu>
8010790d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107910:	83 c0 08             	add    $0x8,%eax
80107913:	ba 67 00 00 00       	mov    $0x67,%edx
80107918:	c1 e8 18             	shr    $0x18,%eax
8010791b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107922:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107929:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010792f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107934:	83 c1 08             	add    $0x8,%ecx
80107937:	c1 e9 10             	shr    $0x10,%ecx
8010793a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107940:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107945:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010794c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107951:	e8 ba c6 ff ff       	call   80104010 <mycpu>
80107956:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010795d:	e8 ae c6 ff ff       	call   80104010 <mycpu>
80107962:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107966:	8b 73 08             	mov    0x8(%ebx),%esi
80107969:	e8 a2 c6 ff ff       	call   80104010 <mycpu>
8010796e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107974:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107977:	e8 94 c6 ff ff       	call   80104010 <mycpu>
8010797c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107980:	b8 28 00 00 00       	mov    $0x28,%eax
80107985:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107988:	8b 43 04             	mov    0x4(%ebx),%eax
8010798b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107990:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80107993:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107996:	5b                   	pop    %ebx
80107997:	5e                   	pop    %esi
80107998:	5f                   	pop    %edi
80107999:	5d                   	pop    %ebp
  popcli();
8010799a:	e9 b1 d4 ff ff       	jmp    80104e50 <popcli>
    panic("switchuvm: no process");
8010799f:	83 ec 0c             	sub    $0xc,%esp
801079a2:	68 a8 91 10 80       	push   $0x801091a8
801079a7:	e8 e4 89 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801079ac:	83 ec 0c             	sub    $0xc,%esp
801079af:	68 d3 91 10 80       	push   $0x801091d3
801079b4:	e8 d7 89 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801079b9:	83 ec 0c             	sub    $0xc,%esp
801079bc:	68 be 91 10 80       	push   $0x801091be
801079c1:	e8 ca 89 ff ff       	call   80100390 <panic>
801079c6:	8d 76 00             	lea    0x0(%esi),%esi
801079c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801079d0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801079d0:	55                   	push   %ebp
801079d1:	89 e5                	mov    %esp,%ebp
801079d3:	57                   	push   %edi
801079d4:	56                   	push   %esi
801079d5:	53                   	push   %ebx
801079d6:	83 ec 1c             	sub    $0x1c,%esp
801079d9:	8b 75 10             	mov    0x10(%ebp),%esi
801079dc:	8b 45 08             	mov    0x8(%ebp),%eax
801079df:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801079e2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801079e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801079eb:	77 49                	ja     80107a36 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = cow_kalloc();
801079ed:	e8 9e f9 ff ff       	call   80107390 <cow_kalloc>
  memset(mem, 0, PGSIZE);
801079f2:	83 ec 04             	sub    $0x4,%esp
  mem = cow_kalloc();
801079f5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801079f7:	68 00 10 00 00       	push   $0x1000
801079fc:	6a 00                	push   $0x0
801079fe:	50                   	push   %eax
801079ff:	e8 ec d5 ff ff       	call   80104ff0 <memset>
  // cprintf("init1");
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107a04:	58                   	pop    %eax
80107a05:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107a0b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107a10:	5a                   	pop    %edx
80107a11:	6a 06                	push   $0x6
80107a13:	50                   	push   %eax
80107a14:	31 d2                	xor    %edx,%edx
80107a16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a19:	e8 c2 fa ff ff       	call   801074e0 <mappages>
  // cprintf("init2");
  memmove(mem, init, sz);
80107a1e:	89 75 10             	mov    %esi,0x10(%ebp)
80107a21:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107a24:	83 c4 10             	add    $0x10,%esp
80107a27:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80107a2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a2d:	5b                   	pop    %ebx
80107a2e:	5e                   	pop    %esi
80107a2f:	5f                   	pop    %edi
80107a30:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107a31:	e9 6a d6 ff ff       	jmp    801050a0 <memmove>
    panic("inituvm: more than a page");
80107a36:	83 ec 0c             	sub    $0xc,%esp
80107a39:	68 e7 91 10 80       	push   $0x801091e7
80107a3e:	e8 4d 89 ff ff       	call   80100390 <panic>
80107a43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107a50 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107a50:	55                   	push   %ebp
80107a51:	89 e5                	mov    %esp,%ebp
80107a53:	57                   	push   %edi
80107a54:	56                   	push   %esi
80107a55:	53                   	push   %ebx
80107a56:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107a59:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107a60:	0f 85 91 00 00 00    	jne    80107af7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107a66:	8b 75 18             	mov    0x18(%ebp),%esi
80107a69:	31 db                	xor    %ebx,%ebx
80107a6b:	85 f6                	test   %esi,%esi
80107a6d:	75 1a                	jne    80107a89 <loaduvm+0x39>
80107a6f:	eb 6f                	jmp    80107ae0 <loaduvm+0x90>
80107a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a78:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107a7e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107a84:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107a87:	76 57                	jbe    80107ae0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107a89:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a8c:	8b 45 08             	mov    0x8(%ebp),%eax
80107a8f:	31 c9                	xor    %ecx,%ecx
80107a91:	01 da                	add    %ebx,%edx
80107a93:	e8 c8 f9 ff ff       	call   80107460 <walkpgdir>
80107a98:	85 c0                	test   %eax,%eax
80107a9a:	74 4e                	je     80107aea <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80107a9c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107a9e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107aa1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107aa6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107aab:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107ab1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107ab4:	01 d9                	add    %ebx,%ecx
80107ab6:	05 00 00 00 80       	add    $0x80000000,%eax
80107abb:	57                   	push   %edi
80107abc:	51                   	push   %ecx
80107abd:	50                   	push   %eax
80107abe:	ff 75 10             	pushl  0x10(%ebp)
80107ac1:	e8 ea a2 ff ff       	call   80101db0 <readi>
80107ac6:	83 c4 10             	add    $0x10,%esp
80107ac9:	39 f8                	cmp    %edi,%eax
80107acb:	74 ab                	je     80107a78 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80107acd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107ad0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107ad5:	5b                   	pop    %ebx
80107ad6:	5e                   	pop    %esi
80107ad7:	5f                   	pop    %edi
80107ad8:	5d                   	pop    %ebp
80107ad9:	c3                   	ret    
80107ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107ae0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107ae3:	31 c0                	xor    %eax,%eax
}
80107ae5:	5b                   	pop    %ebx
80107ae6:	5e                   	pop    %esi
80107ae7:	5f                   	pop    %edi
80107ae8:	5d                   	pop    %ebp
80107ae9:	c3                   	ret    
      panic("loaduvm: address should exist");
80107aea:	83 ec 0c             	sub    $0xc,%esp
80107aed:	68 01 92 10 80       	push   $0x80109201
80107af2:	e8 99 88 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107af7:	83 ec 0c             	sub    $0xc,%esp
80107afa:	68 10 91 10 80       	push   $0x80109110
80107aff:	e8 8c 88 ff ff       	call   80100390 <panic>
80107b04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107b0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107b10 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107b10:	55                   	push   %ebp
80107b11:	89 e5                	mov    %esp,%ebp
80107b13:	57                   	push   %edi
80107b14:	56                   	push   %esi
80107b15:	53                   	push   %ebx
80107b16:	83 ec 1c             	sub    $0x1c,%esp
80107b19:	8b 75 0c             	mov    0xc(%ebp),%esi
80107b1c:	8b 7d 08             	mov    0x8(%ebp),%edi
  pte_t *pte;
  uint a, pa;
  #if SELECTION != NONE
  struct proc* p = myproc();
80107b1f:	e8 9c c5 ff ff       	call   801040c0 <myproc>
  #endif
  
  if(newsz >= oldsz)
80107b24:	39 75 10             	cmp    %esi,0x10(%ebp)
  struct proc* p = myproc();
80107b27:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldsz;
80107b2a:	89 f0                	mov    %esi,%eax
  if(newsz >= oldsz)
80107b2c:	0f 83 8f 00 00 00    	jae    80107bc1 <deallocuvm+0xb1>

  a = PGROUNDUP(newsz);
80107b32:	8b 45 10             	mov    0x10(%ebp),%eax
80107b35:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107b3b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107b41:	39 de                	cmp    %ebx,%esi
80107b43:	77 54                	ja     80107b99 <deallocuvm+0x89>
80107b45:	eb 77                	jmp    80107bbe <deallocuvm+0xae>
80107b47:	89 f6                	mov    %esi,%esi
80107b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if ((*pte & PTE_P) != 0){
80107b50:	8b 10                	mov    (%eax),%edx
80107b52:	f6 c2 01             	test   $0x1,%dl
80107b55:	74 38                	je     80107b8f <deallocuvm+0x7f>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107b57:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107b5d:	0f 84 bf 00 00 00    	je     80107c22 <deallocuvm+0x112>
        panic("cow_kfree");
      char *v = P2V(pa);
      cow_kfree(v);
80107b63:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107b66:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107b6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      cow_kfree(v);
80107b6f:	52                   	push   %edx
80107b70:	e8 7b f7 ff ff       	call   801072f0 <cow_kfree>
      #if SELECTION != NONE
      if (p->pid > 2 && pgdir == p->pgdir){
80107b75:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80107b78:	83 c4 10             	add    $0x10,%esp
80107b7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107b7e:	83 79 10 02          	cmpl   $0x2,0x10(%ecx)
80107b82:	7e 05                	jle    80107b89 <deallocuvm+0x79>
80107b84:	39 79 04             	cmp    %edi,0x4(%ecx)
80107b87:	74 47                	je     80107bd0 <deallocuvm+0xc0>
            break;
          }
        }
      }
      #endif
      *pte = 0;
80107b89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107b8f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107b95:	39 de                	cmp    %ebx,%esi
80107b97:	76 25                	jbe    80107bbe <deallocuvm+0xae>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107b99:	31 c9                	xor    %ecx,%ecx
80107b9b:	89 da                	mov    %ebx,%edx
80107b9d:	89 f8                	mov    %edi,%eax
80107b9f:	e8 bc f8 ff ff       	call   80107460 <walkpgdir>
    if(!pte)
80107ba4:	85 c0                	test   %eax,%eax
80107ba6:	75 a8                	jne    80107b50 <deallocuvm+0x40>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107ba8:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107bae:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107bb4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107bba:	39 de                	cmp    %ebx,%esi
80107bbc:	77 db                	ja     80107b99 <deallocuvm+0x89>
    }
  }

  return newsz;
80107bbe:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107bc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bc4:	5b                   	pop    %ebx
80107bc5:	5e                   	pop    %esi
80107bc6:	5f                   	pop    %edi
80107bc7:	5d                   	pop    %ebp
80107bc8:	c3                   	ret    
80107bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bd0:	81 c1 10 02 00 00    	add    $0x210,%ecx
        for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107bd6:	31 d2                	xor    %edx,%edx
80107bd8:	eb 11                	jmp    80107beb <deallocuvm+0xdb>
80107bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107be0:	83 c2 01             	add    $0x1,%edx
80107be3:	83 c1 18             	add    $0x18,%ecx
80107be6:	83 fa 10             	cmp    $0x10,%edx
80107be9:	74 9e                	je     80107b89 <deallocuvm+0x79>
          if (p->ram_pages[i].va == (void*)a){
80107beb:	3b 19                	cmp    (%ecx),%ebx
80107bed:	75 f1                	jne    80107be0 <deallocuvm+0xd0>
            p->num_of_actual_pages_in_mem--;
80107bef:	8b 4d e0             	mov    -0x20(%ebp),%ecx
            p->ram_pages[i].is_free = 1;
80107bf2:	8d 14 52             	lea    (%edx,%edx,2),%edx
80107bf5:	8d 14 d1             	lea    (%ecx,%edx,8),%edx
            p->num_of_actual_pages_in_mem--;
80107bf8:	83 a9 c4 03 00 00 01 	subl   $0x1,0x3c4(%ecx)
            p->ram_pages[i].is_free = 1;
80107bff:	c7 82 00 02 00 00 01 	movl   $0x1,0x200(%edx)
80107c06:	00 00 00 
            p->ram_pages[i].aging_counter = 0XFFFFFFFF;
80107c09:	c7 82 08 02 00 00 ff 	movl   $0xffffffff,0x208(%edx)
80107c10:	ff ff ff 
            p->ram_pages[i].va = 0;
80107c13:	c7 82 10 02 00 00 00 	movl   $0x0,0x210(%edx)
80107c1a:	00 00 00 
            break;
80107c1d:	e9 67 ff ff ff       	jmp    80107b89 <deallocuvm+0x79>
        panic("cow_kfree");
80107c22:	83 ec 0c             	sub    $0xc,%esp
80107c25:	68 1f 92 10 80       	push   $0x8010921f
80107c2a:	e8 61 87 ff ff       	call   80100390 <panic>
80107c2f:	90                   	nop

80107c30 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107c30:	55                   	push   %ebp
80107c31:	89 e5                	mov    %esp,%ebp
80107c33:	57                   	push   %edi
80107c34:	56                   	push   %esi
80107c35:	53                   	push   %ebx
80107c36:	83 ec 0c             	sub    $0xc,%esp
80107c39:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;
  
  if(pgdir == 0)
80107c3c:	85 f6                	test   %esi,%esi
80107c3e:	0f 84 db 00 00 00    	je     80107d1f <freevm+0xef>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
80107c44:	83 ec 04             	sub    $0x4,%esp
80107c47:	6a 00                	push   $0x0
80107c49:	68 00 00 00 80       	push   $0x80000000
80107c4e:	56                   	push   %esi
80107c4f:	e8 bc fe ff ff       	call   80107b10 <deallocuvm>
  #if SELECTION != NONE
  struct proc* p = myproc();
80107c54:	e8 67 c4 ff ff       	call   801040c0 <myproc>
  if (p->pid > 2 && p->pgdir == pgdir){
80107c59:	83 c4 10             	add    $0x10,%esp
80107c5c:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80107c60:	7e 05                	jle    80107c67 <freevm+0x37>
80107c62:	39 70 04             	cmp    %esi,0x4(%eax)
80107c65:	74 4a                	je     80107cb1 <freevm+0x81>
80107c67:	89 f3                	mov    %esi,%ebx
80107c69:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107c6f:	eb 0e                	jmp    80107c7f <freevm+0x4f>
80107c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c78:	83 c3 04             	add    $0x4,%ebx
      p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
      p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
    }
  }
  #endif
  for(i = 0; i < NPDENTRIES; i++){
80107c7b:	39 fb                	cmp    %edi,%ebx
80107c7d:	74 23                	je     80107ca2 <freevm+0x72>
    if(pgdir[i] & PTE_P){
80107c7f:	8b 03                	mov    (%ebx),%eax
80107c81:	a8 01                	test   $0x1,%al
80107c83:	74 f3                	je     80107c78 <freevm+0x48>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107c85:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      cow_kfree(v);
80107c8a:	83 ec 0c             	sub    $0xc,%esp
80107c8d:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107c90:	05 00 00 00 80       	add    $0x80000000,%eax
      cow_kfree(v);
80107c95:	50                   	push   %eax
80107c96:	e8 55 f6 ff ff       	call   801072f0 <cow_kfree>
80107c9b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107c9e:	39 fb                	cmp    %edi,%ebx
80107ca0:	75 dd                	jne    80107c7f <freevm+0x4f>
    }
  }
   cow_kfree((char*)pgdir);
80107ca2:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107ca5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ca8:	5b                   	pop    %ebx
80107ca9:	5e                   	pop    %esi
80107caa:	5f                   	pop    %edi
80107cab:	5d                   	pop    %ebp
   cow_kfree((char*)pgdir);
80107cac:	e9 3f f6 ff ff       	jmp    801072f0 <cow_kfree>
    p->num_of_actual_pages_in_mem = 0;
80107cb1:	c7 80 c4 03 00 00 00 	movl   $0x0,0x3c4(%eax)
80107cb8:	00 00 00 
    p->num_of_pages_in_swap_file = 0;
80107cbb:	c7 80 c0 03 00 00 00 	movl   $0x0,0x3c0(%eax)
80107cc2:	00 00 00 
80107cc5:	8d 90 80 00 00 00    	lea    0x80(%eax),%edx
80107ccb:	05 00 02 00 00       	add    $0x200,%eax
      p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
80107cd0:	c7 02 01 00 00 00    	movl   $0x1,(%edx)
80107cd6:	c7 82 80 01 00 00 01 	movl   $0x1,0x180(%edx)
80107cdd:	00 00 00 
80107ce0:	83 c2 18             	add    $0x18,%edx
      p->ram_pages[i].aging_counter = p->swapped_out_pages[i].aging_counter = 0;
80107ce3:	c7 42 f0 00 00 00 00 	movl   $0x0,-0x10(%edx)
80107cea:	c7 82 70 01 00 00 00 	movl   $0x0,0x170(%edx)
80107cf1:	00 00 00 
      p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
80107cf4:	c7 42 ec 00 00 00 00 	movl   $0x0,-0x14(%edx)
80107cfb:	c7 82 6c 01 00 00 00 	movl   $0x0,0x16c(%edx)
80107d02:	00 00 00 
      p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
80107d05:	c7 42 f8 00 00 00 00 	movl   $0x0,-0x8(%edx)
80107d0c:	c7 82 78 01 00 00 00 	movl   $0x0,0x178(%edx)
80107d13:	00 00 00 
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107d16:	39 c2                	cmp    %eax,%edx
80107d18:	75 b6                	jne    80107cd0 <freevm+0xa0>
80107d1a:	e9 48 ff ff ff       	jmp    80107c67 <freevm+0x37>
    panic("freevm: no pgdir");
80107d1f:	83 ec 0c             	sub    $0xc,%esp
80107d22:	68 29 92 10 80       	push   $0x80109229
80107d27:	e8 64 86 ff ff       	call   80100390 <panic>
80107d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107d30 <setupkvm>:
{
80107d30:	55                   	push   %ebp
80107d31:	89 e5                	mov    %esp,%ebp
80107d33:	56                   	push   %esi
80107d34:	53                   	push   %ebx
  if((pgdir = (pde_t*)cow_kalloc()) == 0)
80107d35:	e8 56 f6 ff ff       	call   80107390 <cow_kalloc>
80107d3a:	85 c0                	test   %eax,%eax
80107d3c:	89 c6                	mov    %eax,%esi
80107d3e:	74 42                	je     80107d82 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107d40:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++){
80107d43:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80107d48:	68 00 10 00 00       	push   $0x1000
80107d4d:	6a 00                	push   $0x0
80107d4f:	50                   	push   %eax
80107d50:	e8 9b d2 ff ff       	call   80104ff0 <memset>
80107d55:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107d58:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107d5b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107d5e:	83 ec 08             	sub    $0x8,%esp
80107d61:	8b 13                	mov    (%ebx),%edx
80107d63:	ff 73 0c             	pushl  0xc(%ebx)
80107d66:	50                   	push   %eax
80107d67:	29 c1                	sub    %eax,%ecx
80107d69:	89 f0                	mov    %esi,%eax
80107d6b:	e8 70 f7 ff ff       	call   801074e0 <mappages>
80107d70:	83 c4 10             	add    $0x10,%esp
80107d73:	85 c0                	test   %eax,%eax
80107d75:	78 19                	js     80107d90 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++){
80107d77:	83 c3 10             	add    $0x10,%ebx
80107d7a:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80107d80:	75 d6                	jne    80107d58 <setupkvm+0x28>
}
80107d82:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107d85:	89 f0                	mov    %esi,%eax
80107d87:	5b                   	pop    %ebx
80107d88:	5e                   	pop    %esi
80107d89:	5d                   	pop    %ebp
80107d8a:	c3                   	ret    
80107d8b:	90                   	nop
80107d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107d90:	83 ec 0c             	sub    $0xc,%esp
80107d93:	56                   	push   %esi
      return 0;
80107d94:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107d96:	e8 95 fe ff ff       	call   80107c30 <freevm>
      return 0;
80107d9b:	83 c4 10             	add    $0x10,%esp
}
80107d9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107da1:	89 f0                	mov    %esi,%eax
80107da3:	5b                   	pop    %ebx
80107da4:	5e                   	pop    %esi
80107da5:	5d                   	pop    %ebp
80107da6:	c3                   	ret    
80107da7:	89 f6                	mov    %esi,%esi
80107da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107db0 <kvmalloc>:
{
80107db0:	55                   	push   %ebp
80107db1:	89 e5                	mov    %esp,%ebp
80107db3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107db6:	e8 75 ff ff ff       	call   80107d30 <setupkvm>
80107dbb:	a3 24 2a 13 80       	mov    %eax,0x80132a24
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107dc0:	05 00 00 00 80       	add    $0x80000000,%eax
80107dc5:	0f 22 d8             	mov    %eax,%cr3
}
80107dc8:	c9                   	leave  
80107dc9:	c3                   	ret    
80107dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107dd0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107dd0:	55                   	push   %ebp
  pte_t *pte;
  pte = walkpgdir(pgdir, uva, 0);
80107dd1:	31 c9                	xor    %ecx,%ecx
{
80107dd3:	89 e5                	mov    %esp,%ebp
80107dd5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107dd8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ddb:	8b 45 08             	mov    0x8(%ebp),%eax
80107dde:	e8 7d f6 ff ff       	call   80107460 <walkpgdir>
  if(pte == 0)
80107de3:	85 c0                	test   %eax,%eax
80107de5:	74 05                	je     80107dec <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107de7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107dea:	c9                   	leave  
80107deb:	c3                   	ret    
    panic("clearpteu");
80107dec:	83 ec 0c             	sub    $0xc,%esp
80107def:	68 3a 92 10 80       	push   $0x8010923a
80107df4:	e8 97 85 ff ff       	call   80100390 <panic>
80107df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107e00 <cow_copyuvm>:

pde_t*
cow_copyuvm(pde_t *pgdir, uint sz)
{
80107e00:	55                   	push   %ebp
80107e01:	89 e5                	mov    %esp,%ebp
80107e03:	57                   	push   %edi
80107e04:	56                   	push   %esi
80107e05:	53                   	push   %ebx
80107e06:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags, newflags;
  if((d = setupkvm()) == 0)
80107e09:	e8 22 ff ff ff       	call   80107d30 <setupkvm>
80107e0e:	85 c0                	test   %eax,%eax
80107e10:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107e13:	0f 84 d8 00 00 00    	je     80107ef1 <cow_copyuvm+0xf1>
    return 0;
  //cprintf("cow : pages = %d\n", 57344 - sys_get_number_of_free_pages_impl());

  // cprintf("cow_copyuvm : pages = %d\n", 57344 - sys_get_number_of_free_pages_impl());
  for(i = 0; i < sz; i += PGSIZE){
80107e19:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80107e1c:	85 db                	test   %ebx,%ebx
80107e1e:	0f 84 dc 00 00 00    	je     80107f00 <cow_copyuvm+0x100>
80107e24:	31 ff                	xor    %edi,%edi
80107e26:	eb 27                	jmp    80107e4f <cow_copyuvm+0x4f>
80107e28:	90                   	nop
80107e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      // cprintf("cow2");
      goto bad;
    }
    // cprintf("cow2");
    // update parents flags
    *pte |= PTE_FLAGS((PTE_W & flags ? PTE_COW : 0));
80107e30:	c1 e3 0a             	shl    $0xa,%ebx
  for(i = 0; i < sz; i += PGSIZE){
80107e33:	81 c7 00 10 00 00    	add    $0x1000,%edi
    *pte |= PTE_FLAGS((PTE_W & flags ? PTE_COW : 0));
80107e39:	81 e3 00 08 00 00    	and    $0x800,%ebx
80107e3f:	0b 1e                	or     (%esi),%ebx
    *pte &= ~PTE_W;
80107e41:	83 e3 fd             	and    $0xfffffffd,%ebx
  for(i = 0; i < sz; i += PGSIZE){
80107e44:	39 7d 0c             	cmp    %edi,0xc(%ebp)
    *pte &= ~PTE_W;
80107e47:	89 1e                	mov    %ebx,(%esi)
  for(i = 0; i < sz; i += PGSIZE){
80107e49:	0f 86 b1 00 00 00    	jbe    80107f00 <cow_copyuvm+0x100>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107e4f:	8b 45 08             	mov    0x8(%ebp),%eax
80107e52:	31 c9                	xor    %ecx,%ecx
80107e54:	89 fa                	mov    %edi,%edx
80107e56:	e8 05 f6 ff ff       	call   80107460 <walkpgdir>
80107e5b:	85 c0                	test   %eax,%eax
80107e5d:	89 c6                	mov    %eax,%esi
80107e5f:	0f 84 db 00 00 00    	je     80107f40 <cow_copyuvm+0x140>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
80107e65:	8b 18                	mov    (%eax),%ebx
80107e67:	f7 c3 01 02 00 00    	test   $0x201,%ebx
80107e6d:	0f 84 c0 00 00 00    	je     80107f33 <cow_copyuvm+0x133>
    pa = PTE_ADDR(*pte);
80107e73:	89 d8                	mov    %ebx,%eax
80107e75:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e7a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    newflags = flags & (~PTE_W);
80107e7d:	89 d8                	mov    %ebx,%eax
80107e7f:	25 fd 0f 00 00       	and    $0xffd,%eax
      newflags |= PTE_COW;
80107e84:	89 c2                	mov    %eax,%edx
80107e86:	80 ce 08             	or     $0x8,%dh
80107e89:	f6 c3 02             	test   $0x2,%bl
80107e8c:	0f 45 c2             	cmovne %edx,%eax
    acquire(cow_lock);
80107e8f:	83 ec 0c             	sub    $0xc,%esp
80107e92:	ff 35 40 ff 11 80    	pushl  0x8011ff40
      newflags |= PTE_COW;
80107e98:	89 45 e0             	mov    %eax,-0x20(%ebp)
    acquire(cow_lock);
80107e9b:	e8 40 d0 ff ff       	call   80104ee0 <acquire>
    release(cow_lock);
80107ea0:	58                   	pop    %eax
    pg_ref_counts[PGROUNDDOWN(pa)/PGSIZE]++;
80107ea1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    release(cow_lock);
80107ea4:	ff 35 40 ff 11 80    	pushl  0x8011ff40
    pg_ref_counts[PGROUNDDOWN(pa)/PGSIZE]++;
80107eaa:	c1 ea 0c             	shr    $0xc,%edx
80107ead:	80 82 40 1f 11 80 01 	addb   $0x1,-0x7feee0c0(%edx)
    release(cow_lock);
80107eb4:	e8 e7 d0 ff ff       	call   80104fa0 <release>
    if(mappages(d, (void*)i, PGSIZE, pa, newflags) < 0) {
80107eb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107ebc:	5a                   	pop    %edx
80107ebd:	59                   	pop    %ecx
80107ebe:	50                   	push   %eax
80107ebf:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107ec2:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107ec7:	ff 75 e4             	pushl  -0x1c(%ebp)
80107eca:	89 fa                	mov    %edi,%edx
80107ecc:	e8 0f f6 ff ff       	call   801074e0 <mappages>
80107ed1:	83 c4 10             	add    $0x10,%esp
80107ed4:	85 c0                	test   %eax,%eax
80107ed6:	0f 89 54 ff ff ff    	jns    80107e30 <cow_copyuvm+0x30>
  lcr3(V2P(pgdir));
  return d;

bad:
  // release(cow_lock);
  freevm(d);
80107edc:	83 ec 0c             	sub    $0xc,%esp
80107edf:	ff 75 dc             	pushl  -0x24(%ebp)
80107ee2:	e8 49 fd ff ff       	call   80107c30 <freevm>
  return 0;
80107ee7:	83 c4 10             	add    $0x10,%esp
80107eea:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
80107ef1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107ef4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ef7:	5b                   	pop    %ebx
80107ef8:	5e                   	pop    %esi
80107ef9:	5f                   	pop    %edi
80107efa:	5d                   	pop    %ebp
80107efb:	c3                   	ret    
80107efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("movl %%cr3,%0" : "=r" (val));
80107f00:	0f 20 d8             	mov    %cr3,%eax
  if (rcr3() != V2P(pgdir)){
80107f03:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107f06:	8d 99 00 00 00 80    	lea    -0x80000000(%ecx),%ebx
80107f0c:	39 c3                	cmp    %eax,%ebx
80107f0e:	74 15                	je     80107f25 <cow_copyuvm+0x125>
80107f10:	0f 20 d8             	mov    %cr3,%eax
    cprintf("old %x new %x\n", rcr3(), V2P(pgdir));
80107f13:	83 ec 04             	sub    $0x4,%esp
80107f16:	53                   	push   %ebx
80107f17:	50                   	push   %eax
80107f18:	68 78 92 10 80       	push   $0x80109278
80107f1d:	e8 3e 87 ff ff       	call   80100660 <cprintf>
80107f22:	83 c4 10             	add    $0x10,%esp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107f25:	0f 22 db             	mov    %ebx,%cr3
}
80107f28:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107f2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f2e:	5b                   	pop    %ebx
80107f2f:	5e                   	pop    %esi
80107f30:	5f                   	pop    %edi
80107f31:	5d                   	pop    %ebp
80107f32:	c3                   	ret    
      panic("copyuvm: page not present");
80107f33:	83 ec 0c             	sub    $0xc,%esp
80107f36:	68 5e 92 10 80       	push   $0x8010925e
80107f3b:	e8 50 84 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107f40:	83 ec 0c             	sub    $0xc,%esp
80107f43:	68 44 92 10 80       	push   $0x80109244
80107f48:	e8 43 84 ff ff       	call   80100390 <panic>
80107f4d:	8d 76 00             	lea    0x0(%esi),%esi

80107f50 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107f50:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107f51:	31 c9                	xor    %ecx,%ecx
{
80107f53:	89 e5                	mov    %esp,%ebp
80107f55:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107f58:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f5b:	8b 45 08             	mov    0x8(%ebp),%eax
80107f5e:	e8 fd f4 ff ff       	call   80107460 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107f63:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107f65:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107f66:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107f68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107f6d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107f70:	05 00 00 00 80       	add    $0x80000000,%eax
80107f75:	83 fa 05             	cmp    $0x5,%edx
80107f78:	ba 00 00 00 00       	mov    $0x0,%edx
80107f7d:	0f 45 c2             	cmovne %edx,%eax
}
80107f80:	c3                   	ret    
80107f81:	eb 0d                	jmp    80107f90 <copyout>
80107f83:	90                   	nop
80107f84:	90                   	nop
80107f85:	90                   	nop
80107f86:	90                   	nop
80107f87:	90                   	nop
80107f88:	90                   	nop
80107f89:	90                   	nop
80107f8a:	90                   	nop
80107f8b:	90                   	nop
80107f8c:	90                   	nop
80107f8d:	90                   	nop
80107f8e:	90                   	nop
80107f8f:	90                   	nop

80107f90 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107f90:	55                   	push   %ebp
80107f91:	89 e5                	mov    %esp,%ebp
80107f93:	57                   	push   %edi
80107f94:	56                   	push   %esi
80107f95:	53                   	push   %ebx
80107f96:	83 ec 1c             	sub    $0x1c,%esp
80107f99:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107f9c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f9f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107fa2:	85 db                	test   %ebx,%ebx
80107fa4:	75 40                	jne    80107fe6 <copyout+0x56>
80107fa6:	eb 70                	jmp    80108018 <copyout+0x88>
80107fa8:	90                   	nop
80107fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107fb0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107fb3:	89 f1                	mov    %esi,%ecx
80107fb5:	29 d1                	sub    %edx,%ecx
80107fb7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107fbd:	39 d9                	cmp    %ebx,%ecx
80107fbf:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107fc2:	29 f2                	sub    %esi,%edx
80107fc4:	83 ec 04             	sub    $0x4,%esp
80107fc7:	01 d0                	add    %edx,%eax
80107fc9:	51                   	push   %ecx
80107fca:	57                   	push   %edi
80107fcb:	50                   	push   %eax
80107fcc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107fcf:	e8 cc d0 ff ff       	call   801050a0 <memmove>
    len -= n;
    buf += n;
80107fd4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107fd7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80107fda:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107fe0:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107fe2:	29 cb                	sub    %ecx,%ebx
80107fe4:	74 32                	je     80108018 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107fe6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107fe8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107feb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107fee:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107ff4:	56                   	push   %esi
80107ff5:	ff 75 08             	pushl  0x8(%ebp)
80107ff8:	e8 53 ff ff ff       	call   80107f50 <uva2ka>
    if(pa0 == 0)
80107ffd:	83 c4 10             	add    $0x10,%esp
80108000:	85 c0                	test   %eax,%eax
80108002:	75 ac                	jne    80107fb0 <copyout+0x20>
  }
  return 0;
}
80108004:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108007:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010800c:	5b                   	pop    %ebx
8010800d:	5e                   	pop    %esi
8010800e:	5f                   	pop    %edi
8010800f:	5d                   	pop    %ebp
80108010:	c3                   	ret    
80108011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108018:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010801b:	31 c0                	xor    %eax,%eax
}
8010801d:	5b                   	pop    %ebx
8010801e:	5e                   	pop    %esi
8010801f:	5f                   	pop    %edi
80108020:	5d                   	pop    %ebp
80108021:	c3                   	ret    
80108022:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108030 <swap_out>:

#if SELECTION != NONE
//  if buffer == 0 then we put buffer <-- kernel_va(page_to_swap->va)  // p2v(phiscal(va))
//  and use buffer to swap out from
//  we assume that if buffer is not 0, it is kernel virtual address
void swap_out(struct proc* p, struct pageinfo* page_to_swap, void* buffer, pde_t* pgdir){
80108030:	55                   	push   %ebp
80108031:	89 e5                	mov    %esp,%ebp
80108033:	57                   	push   %edi
80108034:	56                   	push   %esi
80108035:	53                   	push   %ebx
80108036:	83 ec 1c             	sub    $0x1c,%esp
  // cprintf("SWAP OUT : ");
  // print_user_char(pgdir, page_to_swap->va);
  if (buffer == 0){
80108039:	8b 75 10             	mov    0x10(%ebp),%esi
void swap_out(struct proc* p, struct pageinfo* page_to_swap, void* buffer, pde_t* pgdir){
8010803c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (buffer == 0){
8010803f:	85 f6                	test   %esi,%esi
80108041:	0f 84 f9 00 00 00    	je     80108140 <swap_out+0x110>
  // swap page
  // INV  : cell swapped_out_pages[i] is free iff there isnt a page that is written in offset i * PGSIZE in the swap file
  int index;
  int found = 0;
  int count = 0;
  p->num_of_pages_in_swap_file++;
80108047:	8b 83 c0 03 00 00    	mov    0x3c0(%ebx),%eax
  for (index = 0; index < MAX_PYSC_PAGES; index++){
8010804d:	31 c9                	xor    %ecx,%ecx
  p->num_of_pages_in_swap_file++;
8010804f:	83 c0 01             	add    $0x1,%eax
80108052:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108055:	89 83 c0 03 00 00    	mov    %eax,0x3c0(%ebx)
8010805b:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80108061:	89 c2                	mov    %eax,%edx
80108063:	eb 0e                	jmp    80108073 <swap_out+0x43>
80108065:	8d 76 00             	lea    0x0(%esi),%esi
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80108068:	83 c1 01             	add    $0x1,%ecx
8010806b:	83 c2 18             	add    $0x18,%edx
8010806e:	83 f9 10             	cmp    $0x10,%ecx
80108071:	74 32                	je     801080a5 <swap_out+0x75>
    if (p->swapped_out_pages[index].is_free){
80108073:	8b 3a                	mov    (%edx),%edi
80108075:	85 ff                	test   %edi,%edi
80108077:	74 ef                	je     80108068 <swap_out+0x38>
      p->swapped_out_pages[index].is_free = 0;
80108079:	8d 14 49             	lea    (%ecx,%ecx,2),%edx
      p->swapped_out_pages[index].va = page_to_swap->va;
8010807c:	8b 7d 0c             	mov    0xc(%ebp),%edi
      p->swapped_out_pages[index].is_free = 0;
8010807f:	8d 14 d3             	lea    (%ebx,%edx,8),%edx
80108082:	c7 82 80 00 00 00 00 	movl   $0x0,0x80(%edx)
80108089:	00 00 00 
      p->swapped_out_pages[index].va = page_to_swap->va;
8010808c:	8b 77 10             	mov    0x10(%edi),%esi
      p->swapped_out_pages[index].swap_file_offset = index * PGSIZE;
      found = 1;
8010808f:	bf 01 00 00 00       	mov    $0x1,%edi
      p->swapped_out_pages[index].va = page_to_swap->va;
80108094:	89 b2 90 00 00 00    	mov    %esi,0x90(%edx)
      p->swapped_out_pages[index].swap_file_offset = index * PGSIZE;
8010809a:	89 ce                	mov    %ecx,%esi
8010809c:	c1 e6 0c             	shl    $0xc,%esi
8010809f:	89 b2 84 00 00 00    	mov    %esi,0x84(%edx)
801080a5:	8d b3 00 02 00 00    	lea    0x200(%ebx),%esi
  int count = 0;
801080ab:	31 d2                	xor    %edx,%edx
801080ad:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
  }
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
    if (!p->swapped_out_pages[i].is_free){
      count++;
801080b0:	83 38 01             	cmpl   $0x1,(%eax)
801080b3:	83 d2 00             	adc    $0x0,%edx
801080b6:	83 c0 18             	add    $0x18,%eax
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
801080b9:	39 f0                	cmp    %esi,%eax
801080bb:	75 f3                	jne    801080b0 <swap_out+0x80>
    }
  }
  if (!found){
801080bd:	85 ff                	test   %edi,%edi
801080bf:	0f 84 9f 00 00 00    	je     80108164 <swap_out+0x134>
    cprintf("RAM count : %d , REAL RAM count : %d\n", p->num_of_pages_in_swap_file, count);
    panic("SWAP OUT BALAGAN- no place in swap array\n");
  }
  if (index < 0 || index > 15){
801080c5:	83 f9 10             	cmp    $0x10,%ecx
801080c8:	0f 84 be 00 00 00    	je     8010818c <swap_out+0x15c>
    panic("we have a bug\n");
  }
  int result = writeToSwapFile(p, buffer, index * PGSIZE, PGSIZE);
801080ce:	c1 e1 0c             	shl    $0xc,%ecx
801080d1:	68 00 10 00 00       	push   $0x1000
801080d6:	51                   	push   %ecx
801080d7:	ff 75 10             	pushl  0x10(%ebp)
801080da:	53                   	push   %ebx
801080db:	e8 c0 a5 ff ff       	call   801026a0 <writeToSwapFile>
801080e0:	89 c6                	mov    %eax,%esi


  
  // update flags in PTE
  pte_t* pte_ptr = walkpgdir(pgdir, page_to_swap->va, 0);
801080e2:	8b 45 0c             	mov    0xc(%ebp),%eax
801080e5:	31 c9                	xor    %ecx,%ecx
801080e7:	8b 50 10             	mov    0x10(%eax),%edx
801080ea:	8b 45 14             	mov    0x14(%ebp),%eax
801080ed:	e8 6e f3 ff ff       	call   80107460 <walkpgdir>
  *pte_ptr |= PTE_PG;
  *pte_ptr &= ~PTE_P;
801080f2:	8b 10                	mov    (%eax),%edx
801080f4:	83 e2 fe             	and    $0xfffffffe,%edx
801080f7:	80 ce 02             	or     $0x2,%dh
801080fa:	89 10                	mov    %edx,(%eax)
  // *pte_ptr |= PTE_U;
  cow_kfree(buffer);
801080fc:	58                   	pop    %eax
801080fd:	ff 75 10             	pushl  0x10(%ebp)
80108100:	e8 eb f1 ff ff       	call   801072f0 <cow_kfree>
  // refresh cr3
  lcr3(V2P(p->pgdir));
80108105:	8b 43 04             	mov    0x4(%ebx),%eax
80108108:	05 00 00 00 80       	add    $0x80000000,%eax
8010810d:	0f 22 d8             	mov    %eax,%cr3
  page_to_swap->is_free = 1;
80108110:	8b 45 0c             	mov    0xc(%ebp),%eax
  if (result < 0){
80108113:	83 c4 10             	add    $0x10,%esp
80108116:	85 f6                	test   %esi,%esi
  page_to_swap->is_free = 1;
80108118:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  if (result < 0){
8010811e:	78 5f                	js     8010817f <swap_out+0x14f>
    panic("swap out failed\n");
  }
  p->num_of_pageOut_occured++;
80108120:	83 83 cc 03 00 00 01 	addl   $0x1,0x3cc(%ebx)
  p->num_of_actual_pages_in_mem--;
80108127:	83 ab c4 03 00 00 01 	subl   $0x1,0x3c4(%ebx)
}
8010812e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108131:	5b                   	pop    %ebx
80108132:	5e                   	pop    %esi
80108133:	5f                   	pop    %edi
80108134:	5d                   	pop    %ebp
80108135:	c3                   	ret    
80108136:	8d 76 00             	lea    0x0(%esi),%esi
80108139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    buffer = P2V((PTE_ADDR(*(walkpgdir(pgdir, page_to_swap->va, 0)))));
80108140:	8b 45 0c             	mov    0xc(%ebp),%eax
80108143:	31 c9                	xor    %ecx,%ecx
80108145:	8b 50 10             	mov    0x10(%eax),%edx
80108148:	8b 45 14             	mov    0x14(%ebp),%eax
8010814b:	e8 10 f3 ff ff       	call   80107460 <walkpgdir>
80108150:	8b 00                	mov    (%eax),%eax
80108152:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108157:	05 00 00 00 80       	add    $0x80000000,%eax
8010815c:	89 45 10             	mov    %eax,0x10(%ebp)
8010815f:	e9 e3 fe ff ff       	jmp    80108047 <swap_out+0x17>
    cprintf("RAM count : %d , REAL RAM count : %d\n", p->num_of_pages_in_swap_file, count);
80108164:	51                   	push   %ecx
80108165:	52                   	push   %edx
80108166:	ff 75 e4             	pushl  -0x1c(%ebp)
80108169:	68 34 91 10 80       	push   $0x80109134
8010816e:	e8 ed 84 ff ff       	call   80100660 <cprintf>
    panic("SWAP OUT BALAGAN- no place in swap array\n");
80108173:	c7 04 24 5c 91 10 80 	movl   $0x8010915c,(%esp)
8010817a:	e8 11 82 ff ff       	call   80100390 <panic>
    panic("swap out failed\n");
8010817f:	83 ec 0c             	sub    $0xc,%esp
80108182:	68 96 92 10 80       	push   $0x80109296
80108187:	e8 04 82 ff ff       	call   80100390 <panic>
    panic("we have a bug\n");
8010818c:	83 ec 0c             	sub    $0xc,%esp
8010818f:	68 87 92 10 80       	push   $0x80109287
80108194:	e8 f7 81 ff ff       	call   80100390 <panic>
80108199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801081a0 <allocuvm>:
{
801081a0:	55                   	push   %ebp
801081a1:	89 e5                	mov    %esp,%ebp
801081a3:	57                   	push   %edi
801081a4:	56                   	push   %esi
801081a5:	53                   	push   %ebx
801081a6:	83 ec 1c             	sub    $0x1c,%esp
  struct proc* p = myproc();
801081a9:	e8 12 bf ff ff       	call   801040c0 <myproc>
801081ae:	89 c3                	mov    %eax,%ebx
  if(newsz >= KERNBASE)
801081b0:	8b 45 10             	mov    0x10(%ebp),%eax
801081b3:	85 c0                	test   %eax,%eax
801081b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801081b8:	0f 88 42 01 00 00    	js     80108300 <allocuvm+0x160>
  if(newsz < oldsz)
801081be:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801081c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801081c4:	0f 82 26 01 00 00    	jb     801082f0 <allocuvm+0x150>
  a = PGROUNDUP(oldsz);
801081ca:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801081d0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801081d6:	39 75 10             	cmp    %esi,0x10(%ebp)
801081d9:	0f 86 14 01 00 00    	jbe    801082f3 <allocuvm+0x153>
801081df:	8b 4b 10             	mov    0x10(%ebx),%ecx
801081e2:	eb 13                	jmp    801081f7 <allocuvm+0x57>
801081e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801081e8:	81 c6 00 10 00 00    	add    $0x1000,%esi
801081ee:	39 75 10             	cmp    %esi,0x10(%ebp)
801081f1:	0f 86 fc 00 00 00    	jbe    801082f3 <allocuvm+0x153>
    if (p->pid > 2){
801081f7:	83 f9 02             	cmp    $0x2,%ecx
801081fa:	7e 4a                	jle    80108246 <allocuvm+0xa6>
      if (p->num_of_actual_pages_in_mem >= 16){
801081fc:	8b 83 c4 03 00 00    	mov    0x3c4(%ebx),%eax
80108202:	83 f8 0f             	cmp    $0xf,%eax
80108205:	7e 36                	jle    8010823d <allocuvm+0x9d>
        if (p->num_of_pages_in_swap_file >= 16){
80108207:	83 bb c0 03 00 00 0f 	cmpl   $0xf,0x3c0(%ebx)
8010820e:	0f 8f 04 01 00 00    	jg     80108318 <allocuvm+0x178>
    update_age(p);
80108214:	83 ec 0c             	sub    $0xc,%esp
80108217:	53                   	push   %ebx
80108218:	e8 93 f3 ff ff       	call   801075b0 <update_age>
    pi = find_page_to_swap_lapa(p,pgdir);
8010821d:	59                   	pop    %ecx
8010821e:	5f                   	pop    %edi
8010821f:	ff 75 08             	pushl  0x8(%ebp)
80108222:	53                   	push   %ebx
80108223:	e8 28 f4 ff ff       	call   80107650 <find_page_to_swap_lapa>
        swap_out(p, page_to_swap, 0, pgdir);
80108228:	ff 75 08             	pushl  0x8(%ebp)
8010822b:	6a 00                	push   $0x0
8010822d:	50                   	push   %eax
8010822e:	53                   	push   %ebx
8010822f:	e8 fc fd ff ff       	call   80108030 <swap_out>
80108234:	8b 83 c4 03 00 00    	mov    0x3c4(%ebx),%eax
8010823a:	83 c4 20             	add    $0x20,%esp
      p->num_of_actual_pages_in_mem++;
8010823d:	83 c0 01             	add    $0x1,%eax
80108240:	89 83 c4 03 00 00    	mov    %eax,0x3c4(%ebx)
    mem = cow_kalloc();
80108246:	e8 45 f1 ff ff       	call   80107390 <cow_kalloc>
    if(mem == 0){
8010824b:	85 c0                	test   %eax,%eax
    mem = cow_kalloc();
8010824d:	89 c7                	mov    %eax,%edi
    if(mem == 0){
8010824f:	0f 84 c3 00 00 00    	je     80108318 <allocuvm+0x178>
    memset(mem, 0, PGSIZE);
80108255:	83 ec 04             	sub    $0x4,%esp
80108258:	68 00 10 00 00       	push   $0x1000
8010825d:	6a 00                	push   $0x0
8010825f:	50                   	push   %eax
80108260:	e8 8b cd ff ff       	call   80104ff0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0){
80108265:	58                   	pop    %eax
80108266:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
8010826c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108271:	5a                   	pop    %edx
80108272:	6a 06                	push   $0x6
80108274:	50                   	push   %eax
80108275:	89 f2                	mov    %esi,%edx
80108277:	8b 45 08             	mov    0x8(%ebp),%eax
8010827a:	e8 61 f2 ff ff       	call   801074e0 <mappages>
8010827f:	83 c4 10             	add    $0x10,%esp
80108282:	85 c0                	test   %eax,%eax
80108284:	0f 88 c6 00 00 00    	js     80108350 <allocuvm+0x1b0>
    if (p->pid > 2){
8010828a:	8b 4b 10             	mov    0x10(%ebx),%ecx
8010828d:	83 f9 02             	cmp    $0x2,%ecx
80108290:	0f 8e 52 ff ff ff    	jle    801081e8 <allocuvm+0x48>
80108296:	8d 93 00 02 00 00    	lea    0x200(%ebx),%edx
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
8010829c:	31 c0                	xor    %eax,%eax
8010829e:	eb 0f                	jmp    801082af <allocuvm+0x10f>
801082a0:	83 c0 01             	add    $0x1,%eax
801082a3:	83 c2 18             	add    $0x18,%edx
801082a6:	83 f8 10             	cmp    $0x10,%eax
801082a9:	0f 84 39 ff ff ff    	je     801081e8 <allocuvm+0x48>
        if (p->ram_pages[i].is_free){
801082af:	8b 3a                	mov    (%edx),%edi
801082b1:	85 ff                	test   %edi,%edi
801082b3:	74 eb                	je     801082a0 <allocuvm+0x100>
          p->ram_pages[i].page_index = ++page_counter;
801082b5:	8b 3d c0 c5 10 80    	mov    0x8010c5c0,%edi
          p->ram_pages[i].is_free = 0;
801082bb:	8d 04 40             	lea    (%eax,%eax,2),%eax
801082be:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
          p->ram_pages[i].page_index = ++page_counter;
801082c1:	8d 57 01             	lea    0x1(%edi),%edx
          p->ram_pages[i].is_free = 0;
801082c4:	c7 80 00 02 00 00 00 	movl   $0x0,0x200(%eax)
801082cb:	00 00 00 
          p->ram_pages[i].va = (void *)a;
801082ce:	89 b0 10 02 00 00    	mov    %esi,0x210(%eax)
          p->ram_pages[i].page_index = ++page_counter;
801082d4:	89 15 c0 c5 10 80    	mov    %edx,0x8010c5c0
801082da:	89 90 0c 02 00 00    	mov    %edx,0x20c(%eax)
          p->ram_pages[i].aging_counter = 0XFFFFFFFF;//LAPA
801082e0:	c7 80 08 02 00 00 ff 	movl   $0xffffffff,0x208(%eax)
801082e7:	ff ff ff 
          break;
801082ea:	e9 f9 fe ff ff       	jmp    801081e8 <allocuvm+0x48>
801082ef:	90                   	nop
    return oldsz;
801082f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801082f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801082f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082f9:	5b                   	pop    %ebx
801082fa:	5e                   	pop    %esi
801082fb:	5f                   	pop    %edi
801082fc:	5d                   	pop    %ebp
801082fd:	c3                   	ret    
801082fe:	66 90                	xchg   %ax,%ax
    return 0;
80108300:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80108307:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010830a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010830d:	5b                   	pop    %ebx
8010830e:	5e                   	pop    %esi
8010830f:	5f                   	pop    %edi
80108310:	5d                   	pop    %ebp
80108311:	c3                   	ret    
80108312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          cprintf("allocuvm out of memory\n");
80108318:	83 ec 0c             	sub    $0xc,%esp
8010831b:	68 a7 92 10 80       	push   $0x801092a7
80108320:	e8 3b 83 ff ff       	call   80100660 <cprintf>
          deallocuvm(pgdir, newsz, oldsz);
80108325:	83 c4 0c             	add    $0xc,%esp
80108328:	ff 75 0c             	pushl  0xc(%ebp)
8010832b:	ff 75 10             	pushl  0x10(%ebp)
8010832e:	ff 75 08             	pushl  0x8(%ebp)
80108331:	e8 da f7 ff ff       	call   80107b10 <deallocuvm>
          return 0;
80108336:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010833d:	83 c4 10             	add    $0x10,%esp
}
80108340:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108343:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108346:	5b                   	pop    %ebx
80108347:	5e                   	pop    %esi
80108348:	5f                   	pop    %edi
80108349:	5d                   	pop    %ebp
8010834a:	c3                   	ret    
8010834b:	90                   	nop
8010834c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80108350:	83 ec 0c             	sub    $0xc,%esp
80108353:	68 bf 92 10 80       	push   $0x801092bf
80108358:	e8 03 83 ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010835d:	83 c4 0c             	add    $0xc,%esp
80108360:	ff 75 0c             	pushl  0xc(%ebp)
80108363:	ff 75 10             	pushl  0x10(%ebp)
80108366:	ff 75 08             	pushl  0x8(%ebp)
80108369:	e8 a2 f7 ff ff       	call   80107b10 <deallocuvm>
      cow_kfree(mem);
8010836e:	89 3c 24             	mov    %edi,(%esp)
80108371:	e8 7a ef ff ff       	call   801072f0 <cow_kfree>
      return 0;
80108376:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010837d:	83 c4 10             	add    $0x10,%esp
}
80108380:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108383:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108386:	5b                   	pop    %ebx
80108387:	5e                   	pop    %esi
80108388:	5f                   	pop    %edi
80108389:	5d                   	pop    %ebp
8010838a:	c3                   	ret    
8010838b:	90                   	nop
8010838c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108390 <swap_in>:

// we assume there are at most MAX_PYSC_PAGES in the RAM 
int swap_in(struct proc* p, struct pageinfo* pi){
80108390:	55                   	push   %ebp
80108391:	89 e5                	mov    %esp,%ebp
80108393:	57                   	push   %edi
80108394:	56                   	push   %esi
80108395:	53                   	push   %ebx
  // print_user_char(pgdir, pi->va);
  int found = 0;
  int index;
  int count = 0;
  // cprintf("SWAP IN: va = %d\n", pi->va);
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80108396:	31 db                	xor    %ebx,%ebx
int swap_in(struct proc* p, struct pageinfo* pi){
80108398:	83 ec 1c             	sub    $0x1c,%esp
8010839b:	8b 75 08             	mov    0x8(%ebp),%esi
  pde_t* pgdir = p->pgdir;
8010839e:	8b 46 04             	mov    0x4(%esi),%eax
801083a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint offset = pi->swap_file_offset;
801083a4:	8b 45 0c             	mov    0xc(%ebp),%eax
801083a7:	8b 40 04             	mov    0x4(%eax),%eax
801083aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
801083ad:	8d 86 00 02 00 00    	lea    0x200(%esi),%eax
801083b3:	89 c2                	mov    %eax,%edx
801083b5:	eb 14                	jmp    801083cb <swap_in+0x3b>
801083b7:	89 f6                	mov    %esi,%esi
801083b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for (index = 0; index < MAX_PYSC_PAGES; index++){
801083c0:	83 c3 01             	add    $0x1,%ebx
801083c3:	83 c2 18             	add    $0x18,%edx
801083c6:	83 fb 10             	cmp    $0x10,%ebx
801083c9:	74 19                	je     801083e4 <swap_in+0x54>
    if (p->ram_pages[index].is_free){
801083cb:	8b 3a                	mov    (%edx),%edi
801083cd:	85 ff                	test   %edi,%edi
801083cf:	74 ef                	je     801083c0 <swap_in+0x30>
      found = 1;
      p->ram_pages[index].is_free = 0;
801083d1:	8d 14 5b             	lea    (%ebx,%ebx,2),%edx
      found = 1;
801083d4:	bf 01 00 00 00       	mov    $0x1,%edi
      p->ram_pages[index].is_free = 0;
801083d9:	c7 84 d6 00 02 00 00 	movl   $0x0,0x200(%esi,%edx,8)
801083e0:	00 00 00 00 
801083e4:	8d 8e 80 03 00 00    	lea    0x380(%esi),%ecx
  int count = 0;
801083ea:	31 d2                	xor    %edx,%edx
801083ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    }
  }
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
    if (!p->ram_pages[i].is_free){
      count++;
801083f0:	83 38 01             	cmpl   $0x1,(%eax)
801083f3:	83 d2 00             	adc    $0x0,%edx
801083f6:	83 c0 18             	add    $0x18,%eax
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
801083f9:	39 c1                	cmp    %eax,%ecx
801083fb:	75 f3                	jne    801083f0 <swap_in+0x60>
    }
  }
  if (!found){
801083fd:	85 ff                	test   %edi,%edi
801083ff:	0f 84 d2 00 00 00    	je     801084d7 <swap_in+0x147>
    cprintf("RAM count : %d , REAL RAM count : %d\n", p->num_of_actual_pages_in_mem, count);
    panic("SWAP IN BALAGAN\n");
  }
  void* mem = cow_kalloc();
80108405:	e8 86 ef ff ff       	call   80107390 <cow_kalloc>
  // mem = cow_kalloc();
  if(mem == 0){
8010840a:	85 c0                	test   %eax,%eax
  void* mem = cow_kalloc();
8010840c:	89 c7                	mov    %eax,%edi
  if(mem == 0){
8010840e:	0f 84 ac 00 00 00    	je     801084c0 <swap_in+0x130>
    cprintf("swap in - out of memory\n");
    // deallocuvm(pgdir, newsz, oldsz);
    return -1;
  }

  void* va = pi->va;
80108414:	8b 45 0c             	mov    0xc(%ebp),%eax
  pte_t* pte_ptr = walkpgdir(pgdir, va, 0);
80108417:	31 c9                	xor    %ecx,%ecx
  void* va = pi->va;
80108419:	8b 40 10             	mov    0x10(%eax),%eax
  pte_t* pte_ptr = walkpgdir(pgdir, va, 0);
8010841c:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010841f:	89 c2                	mov    %eax,%edx
80108421:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108424:	e8 37 f0 ff ff       	call   80107460 <walkpgdir>
  *pte_ptr &= ~PTE_PG;
  *pte_ptr |= (PTE_P | PTE_U | PTE_W);

  // updating physical address written in the page table entry
  *pte_ptr = PTE_FLAGS(*pte_ptr);
  *pte_ptr |= PTE_ADDR(V2P(mem));
80108429:	8d 97 00 00 00 80    	lea    -0x80000000(%edi),%edx
8010842f:	8b 08                	mov    (%eax),%ecx
80108431:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80108437:	81 e1 ff 0d 00 00    	and    $0xdff,%ecx
8010843d:	83 ca 07             	or     $0x7,%edx
80108440:	09 ca                	or     %ecx,%edx
80108442:	89 10                	mov    %edx,(%eax)
  #if SELECTION==NFUA
  p->ram_pages[index].aging_counter = 0;//NFUA
  #endif
  #if SELECTION==LAPA
  p->ram_pages[index].aging_counter = 0XFFFFFFFF;
80108444:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
  #endif
  #if SELECTION==AQ
  add_page_index_to_queue(p, index);
  #endif
  p->ram_pages[index].page_index = ++page_counter;
80108447:	8b 1d c0 c5 10 80    	mov    0x8010c5c0,%ebx
  p->ram_pages[index].aging_counter = 0XFFFFFFFF;
8010844d:	8d 14 c6             	lea    (%esi,%eax,8),%edx
  p->ram_pages[index].page_index = ++page_counter;
80108450:	8d 43 01             	lea    0x1(%ebx),%eax
  p->ram_pages[index].aging_counter = 0XFFFFFFFF;
80108453:	c7 82 08 02 00 00 ff 	movl   $0xffffffff,0x208(%edx)
8010845a:	ff ff ff 
  p->ram_pages[index].page_index = ++page_counter;
8010845d:	89 82 0c 02 00 00    	mov    %eax,0x20c(%edx)
80108463:	a3 c0 c5 10 80       	mov    %eax,0x8010c5c0
  p->ram_pages[index].va = va;
80108468:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010846b:	89 82 10 02 00 00    	mov    %eax,0x210(%edx)
  int result = readFromSwapFile(p, mem, offset, PGSIZE);
80108471:	68 00 10 00 00       	push   $0x1000
80108476:	ff 75 e0             	pushl  -0x20(%ebp)
80108479:	57                   	push   %edi
8010847a:	56                   	push   %esi
8010847b:	e8 50 a2 ff ff       	call   801026d0 <readFromSwapFile>

  // clean the struct
  pi->is_free = 1;
80108480:	8b 7d 0c             	mov    0xc(%ebp),%edi
80108483:	c7 07 01 00 00 00    	movl   $0x1,(%edi)
  pi->va = 0;
80108489:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
  pi->swap_file_offset = 0;
80108490:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)

  // refresh rc3
  lcr3(V2P(p->pgdir));
80108497:	8b 7e 04             	mov    0x4(%esi),%edi
8010849a:	8d 97 00 00 00 80    	lea    -0x80000000(%edi),%edx
801084a0:	0f 22 da             	mov    %edx,%cr3

  p->num_of_actual_pages_in_mem++;
801084a3:	83 86 c4 03 00 00 01 	addl   $0x1,0x3c4(%esi)
  p->num_of_pages_in_swap_file--;
801084aa:	83 ae c0 03 00 00 01 	subl   $0x1,0x3c0(%esi)

  if (result < 0){
801084b1:	83 c4 10             	add    $0x10,%esp
801084b4:	85 c0                	test   %eax,%eax
801084b6:	78 3d                	js     801084f5 <swap_in+0x165>
    panic("swap in failed");
  }
  return result;
}
801084b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801084bb:	5b                   	pop    %ebx
801084bc:	5e                   	pop    %esi
801084bd:	5f                   	pop    %edi
801084be:	5d                   	pop    %ebp
801084bf:	c3                   	ret    
    cprintf("swap in - out of memory\n");
801084c0:	83 ec 0c             	sub    $0xc,%esp
801084c3:	68 ec 92 10 80       	push   $0x801092ec
801084c8:	e8 93 81 ff ff       	call   80100660 <cprintf>
    return -1;
801084cd:	83 c4 10             	add    $0x10,%esp
801084d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801084d5:	eb e1                	jmp    801084b8 <swap_in+0x128>
    cprintf("RAM count : %d , REAL RAM count : %d\n", p->num_of_actual_pages_in_mem, count);
801084d7:	50                   	push   %eax
801084d8:	52                   	push   %edx
801084d9:	ff b6 c4 03 00 00    	pushl  0x3c4(%esi)
801084df:	68 34 91 10 80       	push   $0x80109134
801084e4:	e8 77 81 ff ff       	call   80100660 <cprintf>
    panic("SWAP IN BALAGAN\n");
801084e9:	c7 04 24 db 92 10 80 	movl   $0x801092db,(%esp)
801084f0:	e8 9b 7e ff ff       	call   80100390 <panic>
    panic("swap in failed");
801084f5:	83 ec 0c             	sub    $0xc,%esp
801084f8:	68 05 93 10 80       	push   $0x80109305
801084fd:	e8 8e 7e ff ff       	call   80100390 <panic>
80108502:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108510 <swap_page_back>:
 * 3. ram not full - swap in
 * 
 * 
 * */

void swap_page_back(struct proc* p, struct pageinfo* pi_to_swapin){
80108510:	55                   	push   %ebp
80108511:	89 e5                	mov    %esp,%ebp
80108513:	57                   	push   %edi
80108514:	56                   	push   %esi
80108515:	53                   	push   %ebx
80108516:	83 ec 2c             	sub    $0x2c,%esp
80108519:	8b 5d 08             	mov    0x8(%ebp),%ebx
  //   if (!p->swapped_out_pages[i].is_free){
  //     swap++;
  //   }
  // }
  // cprintf("RAM: %d SWAP: %d\n", ram, swap);
  if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file == MAX_PYSC_PAGES){
8010851c:	83 bb c4 03 00 00 10 	cmpl   $0x10,0x3c4(%ebx)
80108523:	74 1b                	je     80108540 <swap_page_back+0x30>
  }
  else{
    #if DEBUG==TRUE
    cprintf("PGFAULT C\n");
    #endif
    swap_in(p, pi_to_swapin);
80108525:	83 ec 08             	sub    $0x8,%esp
80108528:	ff 75 0c             	pushl  0xc(%ebp)
8010852b:	53                   	push   %ebx
8010852c:	e8 5f fe ff ff       	call   80108390 <swap_in>
80108531:	83 c4 10             	add    $0x10,%esp
  }
}
80108534:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108537:	5b                   	pop    %ebx
80108538:	5e                   	pop    %esi
80108539:	5f                   	pop    %edi
8010853a:	5d                   	pop    %ebp
8010853b:	c3                   	ret    
8010853c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file == MAX_PYSC_PAGES){
80108540:	8b 83 c0 03 00 00    	mov    0x3c0(%ebx),%eax
80108546:	83 f8 10             	cmp    $0x10,%eax
80108549:	74 45                	je     80108590 <swap_page_back+0x80>
  else if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file < MAX_PYSC_PAGES){
8010854b:	83 f8 0f             	cmp    $0xf,%eax
8010854e:	7f d5                	jg     80108525 <swap_page_back+0x15>
    update_age(p);
80108550:	83 ec 0c             	sub    $0xc,%esp
    struct pageinfo* page_to_swap = find_page_to_swap(p, p->pgdir);
80108553:	8b 73 04             	mov    0x4(%ebx),%esi
    update_age(p);
80108556:	53                   	push   %ebx
80108557:	e8 54 f0 ff ff       	call   801075b0 <update_age>
    pi = find_page_to_swap_lapa(p,pgdir);
8010855c:	58                   	pop    %eax
8010855d:	5a                   	pop    %edx
8010855e:	56                   	push   %esi
8010855f:	53                   	push   %ebx
80108560:	e8 eb f0 ff ff       	call   80107650 <find_page_to_swap_lapa>
    swap_out(p, page_to_swap, 0, p->pgdir);
80108565:	ff 73 04             	pushl  0x4(%ebx)
80108568:	6a 00                	push   $0x0
8010856a:	50                   	push   %eax
8010856b:	53                   	push   %ebx
8010856c:	e8 bf fa ff ff       	call   80108030 <swap_out>
    swap_in(p, pi_to_swapin);
80108571:	83 c4 18             	add    $0x18,%esp
80108574:	ff 75 0c             	pushl  0xc(%ebp)
80108577:	53                   	push   %ebx
80108578:	e8 13 fe ff ff       	call   80108390 <swap_in>
  else if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file < MAX_PYSC_PAGES){
8010857d:	83 c4 10             	add    $0x10,%esp
}
80108580:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108583:	5b                   	pop    %ebx
80108584:	5e                   	pop    %esi
80108585:	5f                   	pop    %edi
80108586:	5d                   	pop    %ebp
80108587:	c3                   	ret    
80108588:	90                   	nop
80108589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    char* buffer = cow_kalloc();
80108590:	e8 fb ed ff ff       	call   80107390 <cow_kalloc>
    update_age(p);
80108595:	83 ec 0c             	sub    $0xc,%esp
    struct pageinfo* page_to_swap = find_page_to_swap(p, p->pgdir);
80108598:	8b 73 04             	mov    0x4(%ebx),%esi
    char* buffer = cow_kalloc();
8010859b:	89 c7                	mov    %eax,%edi
    update_age(p);
8010859d:	53                   	push   %ebx
8010859e:	e8 0d f0 ff ff       	call   801075b0 <update_age>
    pi = find_page_to_swap_lapa(p,pgdir);
801085a3:	59                   	pop    %ecx
801085a4:	58                   	pop    %eax
801085a5:	56                   	push   %esi
801085a6:	53                   	push   %ebx
801085a7:	e8 a4 f0 ff ff       	call   80107650 <find_page_to_swap_lapa>
    memmove(buffer, page_to_swap->va, PGSIZE);
801085ac:	83 c4 0c             	add    $0xc,%esp
    pi = find_page_to_swap_lapa(p,pgdir);
801085af:	89 c6                	mov    %eax,%esi
    memmove(buffer, page_to_swap->va, PGSIZE);
801085b1:	68 00 10 00 00       	push   $0x1000
801085b6:	ff 70 10             	pushl  0x10(%eax)
801085b9:	57                   	push   %edi
801085ba:	e8 e1 ca ff ff       	call   801050a0 <memmove>
    p->num_of_actual_pages_in_mem--;
801085bf:	83 ab c4 03 00 00 01 	subl   $0x1,0x3c4(%ebx)
    pi = *page_to_swap;
801085c6:	8b 06                	mov    (%esi),%eax
801085c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
801085cb:	8b 46 04             	mov    0x4(%esi),%eax
801085ce:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801085d1:	8b 46 08             	mov    0x8(%esi),%eax
801085d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
801085d7:	8b 46 0c             	mov    0xc(%esi),%eax
801085da:	89 45 dc             	mov    %eax,-0x24(%ebp)
801085dd:	8b 46 10             	mov    0x10(%esi),%eax
801085e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801085e3:	8b 46 14             	mov    0x14(%esi),%eax
801085e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    page_to_swap->is_free = 1;
801085e9:	c7 06 01 00 00 00    	movl   $0x1,(%esi)
    swap_in(p, page_to_swap);
801085ef:	58                   	pop    %eax
801085f0:	5a                   	pop    %edx
801085f1:	56                   	push   %esi
801085f2:	53                   	push   %ebx
801085f3:	e8 98 fd ff ff       	call   80108390 <swap_in>
    swap_out(p, &pi, buffer, p->pgdir);
801085f8:	8d 45 d0             	lea    -0x30(%ebp),%eax
801085fb:	ff 73 04             	pushl  0x4(%ebx)
801085fe:	57                   	push   %edi
801085ff:	50                   	push   %eax
80108600:	53                   	push   %ebx
80108601:	e8 2a fa ff ff       	call   80108030 <swap_out>
  if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file == MAX_PYSC_PAGES){
80108606:	83 c4 20             	add    $0x20,%esp
80108609:	e9 26 ff ff ff       	jmp    80108534 <swap_page_back+0x24>
8010860e:	66 90                	xchg   %ax,%ax

80108610 <copy_page>:
#endif
int copy_page(pde_t* pgdir, pte_t* pte_ptr){
80108610:	55                   	push   %ebp
80108611:	89 e5                	mov    %esp,%ebp
80108613:	57                   	push   %edi
80108614:	56                   	push   %esi
80108615:	53                   	push   %ebx
80108616:	83 ec 0c             	sub    $0xc,%esp
80108619:	8b 75 0c             	mov    0xc(%ebp),%esi
  
  uint pa = PTE_ADDR(*pte_ptr);
8010861c:	8b 3e                	mov    (%esi),%edi
  // release(cow_lock);
  char* mem = cow_kalloc();
8010861e:	e8 6d ed ff ff       	call   80107390 <cow_kalloc>
  uint pa = PTE_ADDR(*pte_ptr);
80108623:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  // acquire(cow_lock);
  if (mem == 0){
80108629:	85 c0                	test   %eax,%eax
8010862b:	74 43                	je     80108670 <copy_page+0x60>
    return -1;
  }

  // cprintf("copying page old pa %x new pa %x\n", pa, V2P(mem));

  memmove(mem, P2V(pa), PGSIZE);
8010862d:	83 ec 04             	sub    $0x4,%esp
80108630:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108636:	89 c3                	mov    %eax,%ebx
80108638:	68 00 10 00 00       	push   $0x1000
8010863d:	57                   	push   %edi

  // *pte_ptr = PTE_ADDR(P2V(mem)) | PTE_U | PTE_W | PTE_P;
  *pte_ptr = PTE_ADDR(V2P(mem)) | PTE_FLAGS(*pte_ptr) | PTE_W | PTE_P | PTE_U;
8010863e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  memmove(mem, P2V(pa), PGSIZE);
80108644:	50                   	push   %eax
  *pte_ptr = PTE_ADDR(V2P(mem)) | PTE_FLAGS(*pte_ptr) | PTE_W | PTE_P | PTE_U;
80108645:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  memmove(mem, P2V(pa), PGSIZE);
8010864b:	e8 50 ca ff ff       	call   801050a0 <memmove>
  *pte_ptr = PTE_ADDR(V2P(mem)) | PTE_FLAGS(*pte_ptr) | PTE_W | PTE_P | PTE_U;
80108650:	8b 06                	mov    (%esi),%eax
  return 0;
80108652:	83 c4 10             	add    $0x10,%esp
  *pte_ptr = PTE_ADDR(V2P(mem)) | PTE_FLAGS(*pte_ptr) | PTE_W | PTE_P | PTE_U;
80108655:	25 ff 0f 00 00       	and    $0xfff,%eax
8010865a:	83 c8 07             	or     $0x7,%eax
8010865d:	09 c3                	or     %eax,%ebx
  return 0;
8010865f:	31 c0                	xor    %eax,%eax
  *pte_ptr = PTE_ADDR(V2P(mem)) | PTE_FLAGS(*pte_ptr) | PTE_W | PTE_P | PTE_U;
80108661:	89 1e                	mov    %ebx,(%esi)
}
80108663:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108666:	5b                   	pop    %ebx
80108667:	5e                   	pop    %esi
80108668:	5f                   	pop    %edi
80108669:	5d                   	pop    %ebp
8010866a:	c3                   	ret    
8010866b:	90                   	nop
8010866c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80108670:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108675:	eb ec                	jmp    80108663 <copy_page+0x53>
