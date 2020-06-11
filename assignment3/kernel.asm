
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
8010002d:	b8 f0 36 10 80       	mov    $0x801036f0,%eax
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
8010004c:	68 00 89 10 80       	push   $0x80108900
80100051:	68 e0 d5 10 80       	push   $0x8010d5e0
80100056:	e8 c5 4d 00 00       	call   80104e20 <initlock>
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
80100092:	68 07 89 10 80       	push   $0x80108907
80100097:	50                   	push   %eax
80100098:	e8 53 4c 00 00       	call   80104cf0 <initsleeplock>
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
801000e4:	e8 77 4e 00 00       	call   80104f60 <acquire>
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
80100162:	e8 b9 4e 00 00       	call   80105020 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 4b 00 00       	call   80104d30 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 6d 27 00 00       	call   801028f0 <iderw>
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
80100193:	68 0e 89 10 80       	push   $0x8010890e
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
801001ae:	e8 1d 4c 00 00       	call   80104dd0 <holdingsleep>
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
801001c4:	e9 27 27 00 00       	jmp    801028f0 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 1f 89 10 80       	push   $0x8010891f
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
801001ef:	e8 dc 4b 00 00       	call   80104dd0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 8c 4b 00 00       	call   80104d90 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
8010020b:	e8 50 4d 00 00       	call   80104f60 <acquire>
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
8010025c:	e9 bf 4d 00 00       	jmp    80105020 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 26 89 10 80       	push   $0x80108926
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
80100280:	e8 1b 19 00 00       	call   80101ba0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010028c:	e8 cf 4c 00 00       	call   80104f60 <acquire>
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
801002c5:	e8 d6 45 00 00       	call   801048a0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 e0 ff 11 80    	mov    0x8011ffe0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 e4 ff 11 80    	cmp    0x8011ffe4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 f0 3d 00 00       	call   801040d0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 c5 10 80       	push   $0x8010c520
801002ef:	e8 2c 4d 00 00       	call   80105020 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 c4 17 00 00       	call   80101ac0 <ilock>
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
8010034d:	e8 ce 4c 00 00       	call   80105020 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 66 17 00 00       	call   80101ac0 <ilock>
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
801003a9:	e8 d2 2b 00 00       	call   80102f80 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 2d 89 10 80       	push   $0x8010892d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 8e 95 10 80 	movl   $0x8010958e,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 63 4a 00 00       	call   80104e40 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 41 89 10 80       	push   $0x80108941
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
8010043a:	e8 11 64 00 00       	call   80106850 <uartputc>
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
801004ec:	e8 5f 63 00 00       	call   80106850 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 53 63 00 00       	call   80106850 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 47 63 00 00       	call   80106850 <uartputc>
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
80100524:	e8 f7 4b 00 00       	call   80105120 <memmove>
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
80100541:	e8 2a 4b 00 00       	call   80105070 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 45 89 10 80       	push   $0x80108945
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
801005b1:	0f b6 92 70 89 10 80 	movzbl -0x7fef7690(%edx),%edx
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
8010060f:	e8 8c 15 00 00       	call   80101ba0 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010061b:	e8 40 49 00 00       	call   80104f60 <acquire>
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
80100647:	e8 d4 49 00 00       	call   80105020 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 6b 14 00 00       	call   80101ac0 <ilock>

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
8010071f:	e8 fc 48 00 00       	call   80105020 <release>
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
801007d0:	ba 58 89 10 80       	mov    $0x80108958,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 c5 10 80       	push   $0x8010c520
801007f0:	e8 6b 47 00 00       	call   80104f60 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 5f 89 10 80       	push   $0x8010895f
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
80100823:	e8 38 47 00 00       	call   80104f60 <acquire>
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
80100888:	e8 93 47 00 00       	call   80105020 <release>
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
80100916:	e8 d5 41 00 00       	call   80104af0 <wakeup>
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
80100997:	e9 34 42 00 00       	jmp    80104bd0 <procdump>
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
801009c6:	68 68 89 10 80       	push   $0x80108968
801009cb:	68 20 c5 10 80       	push   $0x8010c520
801009d0:	e8 4b 44 00 00       	call   80104e20 <initlock>

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
801009f9:	e8 a2 20 00 00       	call   80102aa0 <ioapicenable>
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
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 0f 36 00 00       	call   801040d0 <myproc>
80100ac1:	89 c3                	mov    %eax,%ebx
  struct pageinfo swp_pginfo_bu[MAX_PYSC_PAGES];
  int advance_q_bu[MAX_PYSC_PAGES];
  struct file* swap_file_bu = 0;
  struct file* temp_swap_file = 0;

  begin_op();
80100ac3:	e8 28 29 00 00       	call   801033f0 <begin_op>

  if((ip = namei(path)) == 0){
80100ac8:	83 ec 0c             	sub    $0xc,%esp
80100acb:	ff 75 08             	pushl  0x8(%ebp)
80100ace:	e8 4d 18 00 00       	call   80102320 <namei>
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
80100aee:	e8 cd 0f 00 00       	call   80101ac0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100af3:	8d 85 e4 fb ff ff    	lea    -0x41c(%ebp),%eax
80100af9:	6a 34                	push   $0x34
80100afb:	6a 00                	push   $0x0
80100afd:	50                   	push   %eax
80100afe:	56                   	push   %esi
80100aff:	e8 9c 12 00 00       	call   80101da0 <readi>
80100b04:	83 c4 20             	add    $0x20,%esp
80100b07:	83 f8 34             	cmp    $0x34,%eax
80100b0a:	74 24                	je     80100b30 <exec+0x80>
      curproc->swapFile = swap_file_bu;
    }
    freevm(pgdir);
  }
  if(ip){
    iunlockput(ip);
80100b0c:	83 ec 0c             	sub    $0xc,%esp
80100b0f:	ff b5 b0 fb ff ff    	pushl  -0x450(%ebp)
80100b15:	e8 36 12 00 00       	call   80101d50 <iunlockput>
    end_op();
80100b1a:	e8 41 29 00 00       	call   80103460 <end_op>
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
80100b3c:	e8 3f 73 00 00       	call   80107e80 <setupkvm>
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
80100cf9:	e8 f2 18 00 00       	call   801025f0 <createSwapFile>
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
80100d62:	e8 49 76 00 00       	call   801083b0 <allocuvm>
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
80100d94:	e8 87 6d 00 00       	call   80107b20 <loaduvm>
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
80100dc8:	e8 d3 0f 00 00       	call   80101da0 <readi>
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
80100df2:	e8 79 6f 00 00       	call   80107d70 <freevm>
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
80100e13:	e8 08 71 00 00       	call   80107f20 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100e18:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e1b:	83 c4 10             	add    $0x10,%esp
80100e1e:	8b 00                	mov    (%eax),%eax
80100e20:	85 c0                	test   %eax,%eax
80100e22:	0f 84 5f 03 00 00    	je     80101187 <exec+0x6d7>
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
80100e57:	e8 34 44 00 00       	call   80105290 <strlen>
80100e5c:	f7 d0                	not    %eax
80100e5e:	01 c6                	add    %eax,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e60:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e63:	59                   	pop    %ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e64:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e67:	ff 34 98             	pushl  (%eax,%ebx,4)
80100e6a:	e8 21 44 00 00       	call   80105290 <strlen>
80100e6f:	83 c0 01             	add    $0x1,%eax
80100e72:	50                   	push   %eax
80100e73:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e76:	ff 34 98             	pushl  (%eax,%ebx,4)
80100e79:	56                   	push   %esi
80100e7a:	ff b5 ac fb ff ff    	pushl  -0x454(%ebp)
80100e80:	e8 1b 73 00 00       	call   801081a0 <copyout>
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
80100f9d:	e8 4e 14 00 00       	call   801023f0 <removeSwapFile>
      curproc->swapFile = swap_file_bu;
80100fa2:	8b 85 a4 fb ff ff    	mov    -0x45c(%ebp),%eax
80100fa8:	89 43 7c             	mov    %eax,0x7c(%ebx)
    freevm(pgdir);
80100fab:	58                   	pop    %eax
80100fac:	ff b5 ac fb ff ff    	pushl  -0x454(%ebp)
80100fb2:	e8 b9 6d 00 00       	call   80107d70 <freevm>
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
8010102d:	e8 1e 0d 00 00       	call   80101d50 <iunlockput>
  end_op();
80101032:	e8 29 24 00 00       	call   80103460 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101037:	83 c4 0c             	add    $0xc,%esp
8010103a:	57                   	push   %edi
8010103b:	56                   	push   %esi
8010103c:	ff b5 ac fb ff ff    	pushl  -0x454(%ebp)
80101042:	e8 69 73 00 00       	call   801083b0 <allocuvm>
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
8010106b:	e8 00 6d 00 00       	call   80107d70 <freevm>
80101070:	83 c4 10             	add    $0x10,%esp
80101073:	e9 50 ff ff ff       	jmp    80100fc8 <exec+0x518>
    end_op();
80101078:	e8 e3 23 00 00       	call   80103460 <end_op>
    cprintf("exec: fail\n");
8010107d:	83 ec 0c             	sub    $0xc,%esp
80101080:	68 81 89 10 80       	push   $0x80108981
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
801010e2:	e8 b9 70 00 00       	call   801081a0 <copyout>
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
8010111d:	e8 2e 41 00 00       	call   80105250 <safestrcpy>
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
80101161:	e8 8a 12 00 00       	call   801023f0 <removeSwapFile>
    curproc->swapFile = temp_swap_file;
80101166:	89 7b 7c             	mov    %edi,0x7c(%ebx)
80101169:	83 c4 10             	add    $0x10,%esp
  switchuvm(curproc);
8010116c:	83 ec 0c             	sub    $0xc,%esp
8010116f:	53                   	push   %ebx
80101170:	e8 1b 68 00 00       	call   80107990 <switchuvm>
  freevm(oldpgdir);
80101175:	89 34 24             	mov    %esi,(%esp)
80101178:	e8 f3 6b 00 00       	call   80107d70 <freevm>
  return 0;
8010117d:	83 c4 10             	add    $0x10,%esp
80101180:	31 c0                	xor    %eax,%eax
80101182:	e9 a0 f9 ff ff       	jmp    80100b27 <exec+0x77>
  for(argc = 0; argv[argc]; argc++) {
80101187:	8b b5 b4 fb ff ff    	mov    -0x44c(%ebp),%esi
8010118d:	8d 8d 58 fc ff ff    	lea    -0x3a8(%ebp),%ecx
80101193:	e9 0e ff ff ff       	jmp    801010a6 <exec+0x5f6>
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
801011a0:	55                   	push   %ebp
801011a1:	89 e5                	mov    %esp,%ebp
801011a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
801011a6:	68 8d 89 10 80       	push   $0x8010898d
801011ab:	68 00 00 12 80       	push   $0x80120000
801011b0:	e8 6b 3c 00 00       	call   80104e20 <initlock>
}
801011b5:	83 c4 10             	add    $0x10,%esp
801011b8:	c9                   	leave  
801011b9:	c3                   	ret    
801011ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801011c0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801011c0:	55                   	push   %ebp
801011c1:	89 e5                	mov    %esp,%ebp
801011c3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801011c4:	bb 34 00 12 80       	mov    $0x80120034,%ebx
{
801011c9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
801011cc:	68 00 00 12 80       	push   $0x80120000
801011d1:	e8 8a 3d 00 00       	call   80104f60 <acquire>
801011d6:	83 c4 10             	add    $0x10,%esp
801011d9:	eb 10                	jmp    801011eb <filealloc+0x2b>
801011db:	90                   	nop
801011dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801011e0:	83 c3 18             	add    $0x18,%ebx
801011e3:	81 fb 94 09 12 80    	cmp    $0x80120994,%ebx
801011e9:	73 25                	jae    80101210 <filealloc+0x50>
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
801011fc:	68 00 00 12 80       	push   $0x80120000
80101201:	e8 1a 3e 00 00       	call   80105020 <release>
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
80101215:	68 00 00 12 80       	push   $0x80120000
8010121a:	e8 01 3e 00 00       	call   80105020 <release>
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
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	53                   	push   %ebx
80101234:	83 ec 10             	sub    $0x10,%esp
80101237:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010123a:	68 00 00 12 80       	push   $0x80120000
8010123f:	e8 1c 3d 00 00       	call   80104f60 <acquire>
  if(f->ref < 1)
80101244:	8b 43 04             	mov    0x4(%ebx),%eax
80101247:	83 c4 10             	add    $0x10,%esp
8010124a:	85 c0                	test   %eax,%eax
8010124c:	7e 1a                	jle    80101268 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010124e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101251:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101254:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101257:	68 00 00 12 80       	push   $0x80120000
8010125c:	e8 bf 3d 00 00       	call   80105020 <release>
  return f;
}
80101261:	89 d8                	mov    %ebx,%eax
80101263:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101266:	c9                   	leave  
80101267:	c3                   	ret    
    panic("filedup");
80101268:	83 ec 0c             	sub    $0xc,%esp
8010126b:	68 94 89 10 80       	push   $0x80108994
80101270:	e8 1b f1 ff ff       	call   80100390 <panic>
80101275:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101280 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101280:	55                   	push   %ebp
80101281:	89 e5                	mov    %esp,%ebp
80101283:	57                   	push   %edi
80101284:	56                   	push   %esi
80101285:	53                   	push   %ebx
80101286:	83 ec 28             	sub    $0x28,%esp
80101289:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010128c:	68 00 00 12 80       	push   $0x80120000
80101291:	e8 ca 3c 00 00       	call   80104f60 <acquire>
  if(f->ref < 1)
80101296:	8b 43 04             	mov    0x4(%ebx),%eax
80101299:	83 c4 10             	add    $0x10,%esp
8010129c:	85 c0                	test   %eax,%eax
8010129e:	0f 8e 9b 00 00 00    	jle    8010133f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
801012a4:	83 e8 01             	sub    $0x1,%eax
801012a7:	85 c0                	test   %eax,%eax
801012a9:	89 43 04             	mov    %eax,0x4(%ebx)
801012ac:	74 1a                	je     801012c8 <fileclose+0x48>
    release(&ftable.lock);
801012ae:	c7 45 08 00 00 12 80 	movl   $0x80120000,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801012b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012b8:	5b                   	pop    %ebx
801012b9:	5e                   	pop    %esi
801012ba:	5f                   	pop    %edi
801012bb:	5d                   	pop    %ebp
    release(&ftable.lock);
801012bc:	e9 5f 3d 00 00       	jmp    80105020 <release>
801012c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
801012c8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
801012cc:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
801012ce:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
801012d1:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
801012d4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
801012da:	88 45 e7             	mov    %al,-0x19(%ebp)
801012dd:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
801012e0:	68 00 00 12 80       	push   $0x80120000
  ff = *f;
801012e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801012e8:	e8 33 3d 00 00       	call   80105020 <release>
  if(ff.type == FD_PIPE)
801012ed:	83 c4 10             	add    $0x10,%esp
801012f0:	83 ff 01             	cmp    $0x1,%edi
801012f3:	74 13                	je     80101308 <fileclose+0x88>
  else if(ff.type == FD_INODE){
801012f5:	83 ff 02             	cmp    $0x2,%edi
801012f8:	74 26                	je     80101320 <fileclose+0xa0>
}
801012fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012fd:	5b                   	pop    %ebx
801012fe:	5e                   	pop    %esi
801012ff:	5f                   	pop    %edi
80101300:	5d                   	pop    %ebp
80101301:	c3                   	ret    
80101302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80101308:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
8010130c:	83 ec 08             	sub    $0x8,%esp
8010130f:	53                   	push   %ebx
80101310:	56                   	push   %esi
80101311:	e8 8a 28 00 00       	call   80103ba0 <pipeclose>
80101316:	83 c4 10             	add    $0x10,%esp
80101319:	eb df                	jmp    801012fa <fileclose+0x7a>
8010131b:	90                   	nop
8010131c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80101320:	e8 cb 20 00 00       	call   801033f0 <begin_op>
    iput(ff.ip);
80101325:	83 ec 0c             	sub    $0xc,%esp
80101328:	ff 75 e0             	pushl  -0x20(%ebp)
8010132b:	e8 c0 08 00 00       	call   80101bf0 <iput>
    end_op();
80101330:	83 c4 10             	add    $0x10,%esp
}
80101333:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101336:	5b                   	pop    %ebx
80101337:	5e                   	pop    %esi
80101338:	5f                   	pop    %edi
80101339:	5d                   	pop    %ebp
    end_op();
8010133a:	e9 21 21 00 00       	jmp    80103460 <end_op>
    panic("fileclose");
8010133f:	83 ec 0c             	sub    $0xc,%esp
80101342:	68 9c 89 10 80       	push   $0x8010899c
80101347:	e8 44 f0 ff ff       	call   80100390 <panic>
8010134c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101350 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	53                   	push   %ebx
80101354:	83 ec 04             	sub    $0x4,%esp
80101357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010135a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010135d:	75 31                	jne    80101390 <filestat+0x40>
    ilock(f->ip);
8010135f:	83 ec 0c             	sub    $0xc,%esp
80101362:	ff 73 10             	pushl  0x10(%ebx)
80101365:	e8 56 07 00 00       	call   80101ac0 <ilock>
    stati(f->ip, st);
8010136a:	58                   	pop    %eax
8010136b:	5a                   	pop    %edx
8010136c:	ff 75 0c             	pushl  0xc(%ebp)
8010136f:	ff 73 10             	pushl  0x10(%ebx)
80101372:	e8 f9 09 00 00       	call   80101d70 <stati>
    iunlock(f->ip);
80101377:	59                   	pop    %ecx
80101378:	ff 73 10             	pushl  0x10(%ebx)
8010137b:	e8 20 08 00 00       	call   80101ba0 <iunlock>
    return 0;
80101380:	83 c4 10             	add    $0x10,%esp
80101383:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101385:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101388:	c9                   	leave  
80101389:	c3                   	ret    
8010138a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101390:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101395:	eb ee                	jmp    80101385 <filestat+0x35>
80101397:	89 f6                	mov    %esi,%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013a0 <fileread>:

// Read from file f.
int
fileread(struct file* f, char *addr, int n)
{
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	57                   	push   %edi
801013a4:	56                   	push   %esi
801013a5:	53                   	push   %ebx
801013a6:	83 ec 0c             	sub    $0xc,%esp
801013a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801013ac:	8b 75 0c             	mov    0xc(%ebp),%esi
801013af:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801013b2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801013b6:	74 60                	je     80101418 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801013b8:	8b 03                	mov    (%ebx),%eax
801013ba:	83 f8 01             	cmp    $0x1,%eax
801013bd:	74 41                	je     80101400 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801013bf:	83 f8 02             	cmp    $0x2,%eax
801013c2:	75 5b                	jne    8010141f <fileread+0x7f>
    ilock(f->ip);
801013c4:	83 ec 0c             	sub    $0xc,%esp
801013c7:	ff 73 10             	pushl  0x10(%ebx)
801013ca:	e8 f1 06 00 00       	call   80101ac0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801013cf:	57                   	push   %edi
801013d0:	ff 73 14             	pushl  0x14(%ebx)
801013d3:	56                   	push   %esi
801013d4:	ff 73 10             	pushl  0x10(%ebx)
801013d7:	e8 c4 09 00 00       	call   80101da0 <readi>
801013dc:	83 c4 20             	add    $0x20,%esp
801013df:	85 c0                	test   %eax,%eax
801013e1:	89 c6                	mov    %eax,%esi
801013e3:	7e 03                	jle    801013e8 <fileread+0x48>
      f->off += r;
801013e5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801013e8:	83 ec 0c             	sub    $0xc,%esp
801013eb:	ff 73 10             	pushl  0x10(%ebx)
801013ee:	e8 ad 07 00 00       	call   80101ba0 <iunlock>
    return r;
801013f3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801013f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013f9:	89 f0                	mov    %esi,%eax
801013fb:	5b                   	pop    %ebx
801013fc:	5e                   	pop    %esi
801013fd:	5f                   	pop    %edi
801013fe:	5d                   	pop    %ebp
801013ff:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101400:	8b 43 0c             	mov    0xc(%ebx),%eax
80101403:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101406:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101409:	5b                   	pop    %ebx
8010140a:	5e                   	pop    %esi
8010140b:	5f                   	pop    %edi
8010140c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010140d:	e9 3e 29 00 00       	jmp    80103d50 <piperead>
80101412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101418:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010141d:	eb d7                	jmp    801013f6 <fileread+0x56>
  panic("fileread");
8010141f:	83 ec 0c             	sub    $0xc,%esp
80101422:	68 a6 89 10 80       	push   $0x801089a6
80101427:	e8 64 ef ff ff       	call   80100390 <panic>
8010142c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101430 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	57                   	push   %edi
80101434:	56                   	push   %esi
80101435:	53                   	push   %ebx
80101436:	83 ec 1c             	sub    $0x1c,%esp
80101439:	8b 75 08             	mov    0x8(%ebp),%esi
8010143c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010143f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101443:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101446:	8b 45 10             	mov    0x10(%ebp),%eax
80101449:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010144c:	0f 84 aa 00 00 00    	je     801014fc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101452:	8b 06                	mov    (%esi),%eax
80101454:	83 f8 01             	cmp    $0x1,%eax
80101457:	0f 84 c3 00 00 00    	je     80101520 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010145d:	83 f8 02             	cmp    $0x2,%eax
80101460:	0f 85 d9 00 00 00    	jne    8010153f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101466:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101469:	31 ff                	xor    %edi,%edi
    while(i < n){
8010146b:	85 c0                	test   %eax,%eax
8010146d:	7f 34                	jg     801014a3 <filewrite+0x73>
8010146f:	e9 9c 00 00 00       	jmp    80101510 <filewrite+0xe0>
80101474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101478:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010147b:	83 ec 0c             	sub    $0xc,%esp
8010147e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101481:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101484:	e8 17 07 00 00       	call   80101ba0 <iunlock>
      end_op();
80101489:	e8 d2 1f 00 00       	call   80103460 <end_op>
8010148e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101491:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101494:	39 c3                	cmp    %eax,%ebx
80101496:	0f 85 96 00 00 00    	jne    80101532 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010149c:	01 df                	add    %ebx,%edi
    while(i < n){
8010149e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801014a1:	7e 6d                	jle    80101510 <filewrite+0xe0>
      int n1 = n - i;
801014a3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801014a6:	b8 00 06 00 00       	mov    $0x600,%eax
801014ab:	29 fb                	sub    %edi,%ebx
801014ad:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801014b3:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801014b6:	e8 35 1f 00 00       	call   801033f0 <begin_op>
      ilock(f->ip);
801014bb:	83 ec 0c             	sub    $0xc,%esp
801014be:	ff 76 10             	pushl  0x10(%esi)
801014c1:	e8 fa 05 00 00       	call   80101ac0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801014c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801014c9:	53                   	push   %ebx
801014ca:	ff 76 14             	pushl  0x14(%esi)
801014cd:	01 f8                	add    %edi,%eax
801014cf:	50                   	push   %eax
801014d0:	ff 76 10             	pushl  0x10(%esi)
801014d3:	e8 c8 09 00 00       	call   80101ea0 <writei>
801014d8:	83 c4 20             	add    $0x20,%esp
801014db:	85 c0                	test   %eax,%eax
801014dd:	7f 99                	jg     80101478 <filewrite+0x48>
      iunlock(f->ip);
801014df:	83 ec 0c             	sub    $0xc,%esp
801014e2:	ff 76 10             	pushl  0x10(%esi)
801014e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801014e8:	e8 b3 06 00 00       	call   80101ba0 <iunlock>
      end_op();
801014ed:	e8 6e 1f 00 00       	call   80103460 <end_op>
      if(r < 0)
801014f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801014f5:	83 c4 10             	add    $0x10,%esp
801014f8:	85 c0                	test   %eax,%eax
801014fa:	74 98                	je     80101494 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801014fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801014ff:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101504:	89 f8                	mov    %edi,%eax
80101506:	5b                   	pop    %ebx
80101507:	5e                   	pop    %esi
80101508:	5f                   	pop    %edi
80101509:	5d                   	pop    %ebp
8010150a:	c3                   	ret    
8010150b:	90                   	nop
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101510:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101513:	75 e7                	jne    801014fc <filewrite+0xcc>
}
80101515:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101518:	89 f8                	mov    %edi,%eax
8010151a:	5b                   	pop    %ebx
8010151b:	5e                   	pop    %esi
8010151c:	5f                   	pop    %edi
8010151d:	5d                   	pop    %ebp
8010151e:	c3                   	ret    
8010151f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101520:	8b 46 0c             	mov    0xc(%esi),%eax
80101523:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101526:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101529:	5b                   	pop    %ebx
8010152a:	5e                   	pop    %esi
8010152b:	5f                   	pop    %edi
8010152c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010152d:	e9 0e 27 00 00       	jmp    80103c40 <pipewrite>
        panic("short filewrite");
80101532:	83 ec 0c             	sub    $0xc,%esp
80101535:	68 af 89 10 80       	push   $0x801089af
8010153a:	e8 51 ee ff ff       	call   80100390 <panic>
  panic("filewrite");
8010153f:	83 ec 0c             	sub    $0xc,%esp
80101542:	68 b5 89 10 80       	push   $0x801089b5
80101547:	e8 44 ee ff ff       	call   80100390 <panic>
8010154c:	66 90                	xchg   %ax,%ax
8010154e:	66 90                	xchg   %ax,%ax

80101550 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101550:	55                   	push   %ebp
80101551:	89 e5                	mov    %esp,%ebp
80101553:	56                   	push   %esi
80101554:	53                   	push   %ebx
80101555:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101557:	c1 ea 0c             	shr    $0xc,%edx
8010155a:	03 15 18 0a 12 80    	add    0x80120a18,%edx
80101560:	83 ec 08             	sub    $0x8,%esp
80101563:	52                   	push   %edx
80101564:	50                   	push   %eax
80101565:	e8 66 eb ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010156a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010156c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010156f:	ba 01 00 00 00       	mov    $0x1,%edx
80101574:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101577:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010157d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101580:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101582:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101587:	85 d1                	test   %edx,%ecx
80101589:	74 25                	je     801015b0 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010158b:	f7 d2                	not    %edx
8010158d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010158f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101592:	21 ca                	and    %ecx,%edx
80101594:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101598:	56                   	push   %esi
80101599:	e8 22 20 00 00       	call   801035c0 <log_write>
  brelse(bp);
8010159e:	89 34 24             	mov    %esi,(%esp)
801015a1:	e8 3a ec ff ff       	call   801001e0 <brelse>
}
801015a6:	83 c4 10             	add    $0x10,%esp
801015a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015ac:	5b                   	pop    %ebx
801015ad:	5e                   	pop    %esi
801015ae:	5d                   	pop    %ebp
801015af:	c3                   	ret    
    panic("freeing free block");
801015b0:	83 ec 0c             	sub    $0xc,%esp
801015b3:	68 bf 89 10 80       	push   $0x801089bf
801015b8:	e8 d3 ed ff ff       	call   80100390 <panic>
801015bd:	8d 76 00             	lea    0x0(%esi),%esi

801015c0 <balloc>:
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	57                   	push   %edi
801015c4:	56                   	push   %esi
801015c5:	53                   	push   %ebx
801015c6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801015c9:	8b 0d 00 0a 12 80    	mov    0x80120a00,%ecx
{
801015cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801015d2:	85 c9                	test   %ecx,%ecx
801015d4:	0f 84 87 00 00 00    	je     80101661 <balloc+0xa1>
801015da:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801015e1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801015e4:	83 ec 08             	sub    $0x8,%esp
801015e7:	89 f0                	mov    %esi,%eax
801015e9:	c1 f8 0c             	sar    $0xc,%eax
801015ec:	03 05 18 0a 12 80    	add    0x80120a18,%eax
801015f2:	50                   	push   %eax
801015f3:	ff 75 d8             	pushl  -0x28(%ebp)
801015f6:	e8 d5 ea ff ff       	call   801000d0 <bread>
801015fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015fe:	a1 00 0a 12 80       	mov    0x80120a00,%eax
80101603:	83 c4 10             	add    $0x10,%esp
80101606:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101609:	31 c0                	xor    %eax,%eax
8010160b:	eb 2f                	jmp    8010163c <balloc+0x7c>
8010160d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101610:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101612:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101615:	bb 01 00 00 00       	mov    $0x1,%ebx
8010161a:	83 e1 07             	and    $0x7,%ecx
8010161d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010161f:	89 c1                	mov    %eax,%ecx
80101621:	c1 f9 03             	sar    $0x3,%ecx
80101624:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101629:	85 df                	test   %ebx,%edi
8010162b:	89 fa                	mov    %edi,%edx
8010162d:	74 41                	je     80101670 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010162f:	83 c0 01             	add    $0x1,%eax
80101632:	83 c6 01             	add    $0x1,%esi
80101635:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010163a:	74 05                	je     80101641 <balloc+0x81>
8010163c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010163f:	77 cf                	ja     80101610 <balloc+0x50>
    brelse(bp);
80101641:	83 ec 0c             	sub    $0xc,%esp
80101644:	ff 75 e4             	pushl  -0x1c(%ebp)
80101647:	e8 94 eb ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010164c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101653:	83 c4 10             	add    $0x10,%esp
80101656:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101659:	39 05 00 0a 12 80    	cmp    %eax,0x80120a00
8010165f:	77 80                	ja     801015e1 <balloc+0x21>
  panic("balloc: out of blocks");
80101661:	83 ec 0c             	sub    $0xc,%esp
80101664:	68 d2 89 10 80       	push   $0x801089d2
80101669:	e8 22 ed ff ff       	call   80100390 <panic>
8010166e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101670:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101673:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101676:	09 da                	or     %ebx,%edx
80101678:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010167c:	57                   	push   %edi
8010167d:	e8 3e 1f 00 00       	call   801035c0 <log_write>
        brelse(bp);
80101682:	89 3c 24             	mov    %edi,(%esp)
80101685:	e8 56 eb ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010168a:	58                   	pop    %eax
8010168b:	5a                   	pop    %edx
8010168c:	56                   	push   %esi
8010168d:	ff 75 d8             	pushl  -0x28(%ebp)
80101690:	e8 3b ea ff ff       	call   801000d0 <bread>
80101695:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101697:	8d 40 5c             	lea    0x5c(%eax),%eax
8010169a:	83 c4 0c             	add    $0xc,%esp
8010169d:	68 00 02 00 00       	push   $0x200
801016a2:	6a 00                	push   $0x0
801016a4:	50                   	push   %eax
801016a5:	e8 c6 39 00 00       	call   80105070 <memset>
  log_write(bp);
801016aa:	89 1c 24             	mov    %ebx,(%esp)
801016ad:	e8 0e 1f 00 00       	call   801035c0 <log_write>
  brelse(bp);
801016b2:	89 1c 24             	mov    %ebx,(%esp)
801016b5:	e8 26 eb ff ff       	call   801001e0 <brelse>
}
801016ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016bd:	89 f0                	mov    %esi,%eax
801016bf:	5b                   	pop    %ebx
801016c0:	5e                   	pop    %esi
801016c1:	5f                   	pop    %edi
801016c2:	5d                   	pop    %ebp
801016c3:	c3                   	ret    
801016c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801016ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801016d0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	57                   	push   %edi
801016d4:	56                   	push   %esi
801016d5:	53                   	push   %ebx
801016d6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801016d8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801016da:	bb 54 0a 12 80       	mov    $0x80120a54,%ebx
{
801016df:	83 ec 28             	sub    $0x28,%esp
801016e2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801016e5:	68 20 0a 12 80       	push   $0x80120a20
801016ea:	e8 71 38 00 00       	call   80104f60 <acquire>
801016ef:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801016f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801016f5:	eb 17                	jmp    8010170e <iget+0x3e>
801016f7:	89 f6                	mov    %esi,%esi
801016f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101700:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101706:	81 fb 74 26 12 80    	cmp    $0x80122674,%ebx
8010170c:	73 22                	jae    80101730 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010170e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101711:	85 c9                	test   %ecx,%ecx
80101713:	7e 04                	jle    80101719 <iget+0x49>
80101715:	39 3b                	cmp    %edi,(%ebx)
80101717:	74 4f                	je     80101768 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101719:	85 f6                	test   %esi,%esi
8010171b:	75 e3                	jne    80101700 <iget+0x30>
8010171d:	85 c9                	test   %ecx,%ecx
8010171f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101722:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101728:	81 fb 74 26 12 80    	cmp    $0x80122674,%ebx
8010172e:	72 de                	jb     8010170e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101730:	85 f6                	test   %esi,%esi
80101732:	74 5b                	je     8010178f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101734:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101737:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101739:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010173c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101743:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010174a:	68 20 0a 12 80       	push   $0x80120a20
8010174f:	e8 cc 38 00 00       	call   80105020 <release>

  return ip;
80101754:	83 c4 10             	add    $0x10,%esp
}
80101757:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010175a:	89 f0                	mov    %esi,%eax
8010175c:	5b                   	pop    %ebx
8010175d:	5e                   	pop    %esi
8010175e:	5f                   	pop    %edi
8010175f:	5d                   	pop    %ebp
80101760:	c3                   	ret    
80101761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101768:	39 53 04             	cmp    %edx,0x4(%ebx)
8010176b:	75 ac                	jne    80101719 <iget+0x49>
      release(&icache.lock);
8010176d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101770:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101773:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101775:	68 20 0a 12 80       	push   $0x80120a20
      ip->ref++;
8010177a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010177d:	e8 9e 38 00 00       	call   80105020 <release>
      return ip;
80101782:	83 c4 10             	add    $0x10,%esp
}
80101785:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101788:	89 f0                	mov    %esi,%eax
8010178a:	5b                   	pop    %ebx
8010178b:	5e                   	pop    %esi
8010178c:	5f                   	pop    %edi
8010178d:	5d                   	pop    %ebp
8010178e:	c3                   	ret    
    panic("iget: no inodes");
8010178f:	83 ec 0c             	sub    $0xc,%esp
80101792:	68 e8 89 10 80       	push   $0x801089e8
80101797:	e8 f4 eb ff ff       	call   80100390 <panic>
8010179c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801017a0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	57                   	push   %edi
801017a4:	56                   	push   %esi
801017a5:	53                   	push   %ebx
801017a6:	89 c6                	mov    %eax,%esi
801017a8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801017ab:	83 fa 0b             	cmp    $0xb,%edx
801017ae:	77 18                	ja     801017c8 <bmap+0x28>
801017b0:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
801017b3:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801017b6:	85 db                	test   %ebx,%ebx
801017b8:	74 76                	je     80101830 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801017ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017bd:	89 d8                	mov    %ebx,%eax
801017bf:	5b                   	pop    %ebx
801017c0:	5e                   	pop    %esi
801017c1:	5f                   	pop    %edi
801017c2:	5d                   	pop    %ebp
801017c3:	c3                   	ret    
801017c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
801017c8:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
801017cb:	83 fb 7f             	cmp    $0x7f,%ebx
801017ce:	0f 87 90 00 00 00    	ja     80101864 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
801017d4:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801017da:	8b 00                	mov    (%eax),%eax
801017dc:	85 d2                	test   %edx,%edx
801017de:	74 70                	je     80101850 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801017e0:	83 ec 08             	sub    $0x8,%esp
801017e3:	52                   	push   %edx
801017e4:	50                   	push   %eax
801017e5:	e8 e6 e8 ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801017ea:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801017ee:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801017f1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801017f3:	8b 1a                	mov    (%edx),%ebx
801017f5:	85 db                	test   %ebx,%ebx
801017f7:	75 1d                	jne    80101816 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801017f9:	8b 06                	mov    (%esi),%eax
801017fb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801017fe:	e8 bd fd ff ff       	call   801015c0 <balloc>
80101803:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101806:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101809:	89 c3                	mov    %eax,%ebx
8010180b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010180d:	57                   	push   %edi
8010180e:	e8 ad 1d 00 00       	call   801035c0 <log_write>
80101813:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101816:	83 ec 0c             	sub    $0xc,%esp
80101819:	57                   	push   %edi
8010181a:	e8 c1 e9 ff ff       	call   801001e0 <brelse>
8010181f:	83 c4 10             	add    $0x10,%esp
}
80101822:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101825:	89 d8                	mov    %ebx,%eax
80101827:	5b                   	pop    %ebx
80101828:	5e                   	pop    %esi
80101829:	5f                   	pop    %edi
8010182a:	5d                   	pop    %ebp
8010182b:	c3                   	ret    
8010182c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101830:	8b 00                	mov    (%eax),%eax
80101832:	e8 89 fd ff ff       	call   801015c0 <balloc>
80101837:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010183a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010183d:	89 c3                	mov    %eax,%ebx
}
8010183f:	89 d8                	mov    %ebx,%eax
80101841:	5b                   	pop    %ebx
80101842:	5e                   	pop    %esi
80101843:	5f                   	pop    %edi
80101844:	5d                   	pop    %ebp
80101845:	c3                   	ret    
80101846:	8d 76 00             	lea    0x0(%esi),%esi
80101849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101850:	e8 6b fd ff ff       	call   801015c0 <balloc>
80101855:	89 c2                	mov    %eax,%edx
80101857:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010185d:	8b 06                	mov    (%esi),%eax
8010185f:	e9 7c ff ff ff       	jmp    801017e0 <bmap+0x40>
  panic("bmap: out of range");
80101864:	83 ec 0c             	sub    $0xc,%esp
80101867:	68 f8 89 10 80       	push   $0x801089f8
8010186c:	e8 1f eb ff ff       	call   80100390 <panic>
80101871:	eb 0d                	jmp    80101880 <readsb>
80101873:	90                   	nop
80101874:	90                   	nop
80101875:	90                   	nop
80101876:	90                   	nop
80101877:	90                   	nop
80101878:	90                   	nop
80101879:	90                   	nop
8010187a:	90                   	nop
8010187b:	90                   	nop
8010187c:	90                   	nop
8010187d:	90                   	nop
8010187e:	90                   	nop
8010187f:	90                   	nop

80101880 <readsb>:
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	56                   	push   %esi
80101884:	53                   	push   %ebx
80101885:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101888:	83 ec 08             	sub    $0x8,%esp
8010188b:	6a 01                	push   $0x1
8010188d:	ff 75 08             	pushl  0x8(%ebp)
80101890:	e8 3b e8 ff ff       	call   801000d0 <bread>
80101895:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101897:	8d 40 5c             	lea    0x5c(%eax),%eax
8010189a:	83 c4 0c             	add    $0xc,%esp
8010189d:	6a 1c                	push   $0x1c
8010189f:	50                   	push   %eax
801018a0:	56                   	push   %esi
801018a1:	e8 7a 38 00 00       	call   80105120 <memmove>
  brelse(bp);
801018a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801018a9:	83 c4 10             	add    $0x10,%esp
}
801018ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018af:	5b                   	pop    %ebx
801018b0:	5e                   	pop    %esi
801018b1:	5d                   	pop    %ebp
  brelse(bp);
801018b2:	e9 29 e9 ff ff       	jmp    801001e0 <brelse>
801018b7:	89 f6                	mov    %esi,%esi
801018b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801018c0 <iinit>:
{
801018c0:	55                   	push   %ebp
801018c1:	89 e5                	mov    %esp,%ebp
801018c3:	53                   	push   %ebx
801018c4:	bb 60 0a 12 80       	mov    $0x80120a60,%ebx
801018c9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801018cc:	68 0b 8a 10 80       	push   $0x80108a0b
801018d1:	68 20 0a 12 80       	push   $0x80120a20
801018d6:	e8 45 35 00 00       	call   80104e20 <initlock>
801018db:	83 c4 10             	add    $0x10,%esp
801018de:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801018e0:	83 ec 08             	sub    $0x8,%esp
801018e3:	68 12 8a 10 80       	push   $0x80108a12
801018e8:	53                   	push   %ebx
801018e9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801018ef:	e8 fc 33 00 00       	call   80104cf0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801018f4:	83 c4 10             	add    $0x10,%esp
801018f7:	81 fb 80 26 12 80    	cmp    $0x80122680,%ebx
801018fd:	75 e1                	jne    801018e0 <iinit+0x20>
  readsb(dev, &sb);
801018ff:	83 ec 08             	sub    $0x8,%esp
80101902:	68 00 0a 12 80       	push   $0x80120a00
80101907:	ff 75 08             	pushl  0x8(%ebp)
8010190a:	e8 71 ff ff ff       	call   80101880 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010190f:	ff 35 18 0a 12 80    	pushl  0x80120a18
80101915:	ff 35 14 0a 12 80    	pushl  0x80120a14
8010191b:	ff 35 10 0a 12 80    	pushl  0x80120a10
80101921:	ff 35 0c 0a 12 80    	pushl  0x80120a0c
80101927:	ff 35 08 0a 12 80    	pushl  0x80120a08
8010192d:	ff 35 04 0a 12 80    	pushl  0x80120a04
80101933:	ff 35 00 0a 12 80    	pushl  0x80120a00
80101939:	68 bc 8a 10 80       	push   $0x80108abc
8010193e:	e8 1d ed ff ff       	call   80100660 <cprintf>
}
80101943:	83 c4 30             	add    $0x30,%esp
80101946:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101949:	c9                   	leave  
8010194a:	c3                   	ret    
8010194b:	90                   	nop
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101950 <ialloc>:
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	57                   	push   %edi
80101954:	56                   	push   %esi
80101955:	53                   	push   %ebx
80101956:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101959:	83 3d 08 0a 12 80 01 	cmpl   $0x1,0x80120a08
{
80101960:	8b 45 0c             	mov    0xc(%ebp),%eax
80101963:	8b 75 08             	mov    0x8(%ebp),%esi
80101966:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101969:	0f 86 91 00 00 00    	jbe    80101a00 <ialloc+0xb0>
8010196f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101974:	eb 21                	jmp    80101997 <ialloc+0x47>
80101976:	8d 76 00             	lea    0x0(%esi),%esi
80101979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101980:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101983:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101986:	57                   	push   %edi
80101987:	e8 54 e8 ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010198c:	83 c4 10             	add    $0x10,%esp
8010198f:	39 1d 08 0a 12 80    	cmp    %ebx,0x80120a08
80101995:	76 69                	jbe    80101a00 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101997:	89 d8                	mov    %ebx,%eax
80101999:	83 ec 08             	sub    $0x8,%esp
8010199c:	c1 e8 03             	shr    $0x3,%eax
8010199f:	03 05 14 0a 12 80    	add    0x80120a14,%eax
801019a5:	50                   	push   %eax
801019a6:	56                   	push   %esi
801019a7:	e8 24 e7 ff ff       	call   801000d0 <bread>
801019ac:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801019ae:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801019b0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
801019b3:	83 e0 07             	and    $0x7,%eax
801019b6:	c1 e0 06             	shl    $0x6,%eax
801019b9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801019bd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801019c1:	75 bd                	jne    80101980 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801019c3:	83 ec 04             	sub    $0x4,%esp
801019c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801019c9:	6a 40                	push   $0x40
801019cb:	6a 00                	push   $0x0
801019cd:	51                   	push   %ecx
801019ce:	e8 9d 36 00 00       	call   80105070 <memset>
      dip->type = type;
801019d3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801019d7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801019da:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801019dd:	89 3c 24             	mov    %edi,(%esp)
801019e0:	e8 db 1b 00 00       	call   801035c0 <log_write>
      brelse(bp);
801019e5:	89 3c 24             	mov    %edi,(%esp)
801019e8:	e8 f3 e7 ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801019ed:	83 c4 10             	add    $0x10,%esp
}
801019f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801019f3:	89 da                	mov    %ebx,%edx
801019f5:	89 f0                	mov    %esi,%eax
}
801019f7:	5b                   	pop    %ebx
801019f8:	5e                   	pop    %esi
801019f9:	5f                   	pop    %edi
801019fa:	5d                   	pop    %ebp
      return iget(dev, inum);
801019fb:	e9 d0 fc ff ff       	jmp    801016d0 <iget>
  panic("ialloc: no inodes");
80101a00:	83 ec 0c             	sub    $0xc,%esp
80101a03:	68 18 8a 10 80       	push   $0x80108a18
80101a08:	e8 83 e9 ff ff       	call   80100390 <panic>
80101a0d:	8d 76 00             	lea    0x0(%esi),%esi

80101a10 <iupdate>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	56                   	push   %esi
80101a14:	53                   	push   %ebx
80101a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a18:	83 ec 08             	sub    $0x8,%esp
80101a1b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a1e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a21:	c1 e8 03             	shr    $0x3,%eax
80101a24:	03 05 14 0a 12 80    	add    0x80120a14,%eax
80101a2a:	50                   	push   %eax
80101a2b:	ff 73 a4             	pushl  -0x5c(%ebx)
80101a2e:	e8 9d e6 ff ff       	call   801000d0 <bread>
80101a33:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a35:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101a38:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a3c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a3f:	83 e0 07             	and    $0x7,%eax
80101a42:	c1 e0 06             	shl    $0x6,%eax
80101a45:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101a49:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101a4c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a50:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101a53:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101a57:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101a5b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101a5f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101a63:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101a67:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101a6a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a6d:	6a 34                	push   $0x34
80101a6f:	53                   	push   %ebx
80101a70:	50                   	push   %eax
80101a71:	e8 aa 36 00 00       	call   80105120 <memmove>
  log_write(bp);
80101a76:	89 34 24             	mov    %esi,(%esp)
80101a79:	e8 42 1b 00 00       	call   801035c0 <log_write>
  brelse(bp);
80101a7e:	89 75 08             	mov    %esi,0x8(%ebp)
80101a81:	83 c4 10             	add    $0x10,%esp
}
80101a84:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a87:	5b                   	pop    %ebx
80101a88:	5e                   	pop    %esi
80101a89:	5d                   	pop    %ebp
  brelse(bp);
80101a8a:	e9 51 e7 ff ff       	jmp    801001e0 <brelse>
80101a8f:	90                   	nop

80101a90 <idup>:
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	53                   	push   %ebx
80101a94:	83 ec 10             	sub    $0x10,%esp
80101a97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101a9a:	68 20 0a 12 80       	push   $0x80120a20
80101a9f:	e8 bc 34 00 00       	call   80104f60 <acquire>
  ip->ref++;
80101aa4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101aa8:	c7 04 24 20 0a 12 80 	movl   $0x80120a20,(%esp)
80101aaf:	e8 6c 35 00 00       	call   80105020 <release>
}
80101ab4:	89 d8                	mov    %ebx,%eax
80101ab6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101ab9:	c9                   	leave  
80101aba:	c3                   	ret    
80101abb:	90                   	nop
80101abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ac0 <ilock>:
{
80101ac0:	55                   	push   %ebp
80101ac1:	89 e5                	mov    %esp,%ebp
80101ac3:	56                   	push   %esi
80101ac4:	53                   	push   %ebx
80101ac5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101ac8:	85 db                	test   %ebx,%ebx
80101aca:	0f 84 b7 00 00 00    	je     80101b87 <ilock+0xc7>
80101ad0:	8b 53 08             	mov    0x8(%ebx),%edx
80101ad3:	85 d2                	test   %edx,%edx
80101ad5:	0f 8e ac 00 00 00    	jle    80101b87 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101adb:	8d 43 0c             	lea    0xc(%ebx),%eax
80101ade:	83 ec 0c             	sub    $0xc,%esp
80101ae1:	50                   	push   %eax
80101ae2:	e8 49 32 00 00       	call   80104d30 <acquiresleep>
  if(ip->valid == 0){
80101ae7:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101aea:	83 c4 10             	add    $0x10,%esp
80101aed:	85 c0                	test   %eax,%eax
80101aef:	74 0f                	je     80101b00 <ilock+0x40>
}
80101af1:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101af4:	5b                   	pop    %ebx
80101af5:	5e                   	pop    %esi
80101af6:	5d                   	pop    %ebp
80101af7:	c3                   	ret    
80101af8:	90                   	nop
80101af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b00:	8b 43 04             	mov    0x4(%ebx),%eax
80101b03:	83 ec 08             	sub    $0x8,%esp
80101b06:	c1 e8 03             	shr    $0x3,%eax
80101b09:	03 05 14 0a 12 80    	add    0x80120a14,%eax
80101b0f:	50                   	push   %eax
80101b10:	ff 33                	pushl  (%ebx)
80101b12:	e8 b9 e5 ff ff       	call   801000d0 <bread>
80101b17:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b19:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b1c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b1f:	83 e0 07             	and    $0x7,%eax
80101b22:	c1 e0 06             	shl    $0x6,%eax
80101b25:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101b29:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b2c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101b2f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101b33:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101b37:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101b3b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101b3f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101b43:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101b47:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101b4b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101b4e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b51:	6a 34                	push   $0x34
80101b53:	50                   	push   %eax
80101b54:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101b57:	50                   	push   %eax
80101b58:	e8 c3 35 00 00       	call   80105120 <memmove>
    brelse(bp);
80101b5d:	89 34 24             	mov    %esi,(%esp)
80101b60:	e8 7b e6 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101b65:	83 c4 10             	add    $0x10,%esp
80101b68:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101b6d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101b74:	0f 85 77 ff ff ff    	jne    80101af1 <ilock+0x31>
      panic("ilock: no type");
80101b7a:	83 ec 0c             	sub    $0xc,%esp
80101b7d:	68 30 8a 10 80       	push   $0x80108a30
80101b82:	e8 09 e8 ff ff       	call   80100390 <panic>
    panic("ilock");
80101b87:	83 ec 0c             	sub    $0xc,%esp
80101b8a:	68 2a 8a 10 80       	push   $0x80108a2a
80101b8f:	e8 fc e7 ff ff       	call   80100390 <panic>
80101b94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101b9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101ba0 <iunlock>:
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	56                   	push   %esi
80101ba4:	53                   	push   %ebx
80101ba5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ba8:	85 db                	test   %ebx,%ebx
80101baa:	74 28                	je     80101bd4 <iunlock+0x34>
80101bac:	8d 73 0c             	lea    0xc(%ebx),%esi
80101baf:	83 ec 0c             	sub    $0xc,%esp
80101bb2:	56                   	push   %esi
80101bb3:	e8 18 32 00 00       	call   80104dd0 <holdingsleep>
80101bb8:	83 c4 10             	add    $0x10,%esp
80101bbb:	85 c0                	test   %eax,%eax
80101bbd:	74 15                	je     80101bd4 <iunlock+0x34>
80101bbf:	8b 43 08             	mov    0x8(%ebx),%eax
80101bc2:	85 c0                	test   %eax,%eax
80101bc4:	7e 0e                	jle    80101bd4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101bc6:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101bc9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101bcc:	5b                   	pop    %ebx
80101bcd:	5e                   	pop    %esi
80101bce:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101bcf:	e9 bc 31 00 00       	jmp    80104d90 <releasesleep>
    panic("iunlock");
80101bd4:	83 ec 0c             	sub    $0xc,%esp
80101bd7:	68 3f 8a 10 80       	push   $0x80108a3f
80101bdc:	e8 af e7 ff ff       	call   80100390 <panic>
80101be1:	eb 0d                	jmp    80101bf0 <iput>
80101be3:	90                   	nop
80101be4:	90                   	nop
80101be5:	90                   	nop
80101be6:	90                   	nop
80101be7:	90                   	nop
80101be8:	90                   	nop
80101be9:	90                   	nop
80101bea:	90                   	nop
80101beb:	90                   	nop
80101bec:	90                   	nop
80101bed:	90                   	nop
80101bee:	90                   	nop
80101bef:	90                   	nop

80101bf0 <iput>:
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	57                   	push   %edi
80101bf4:	56                   	push   %esi
80101bf5:	53                   	push   %ebx
80101bf6:	83 ec 28             	sub    $0x28,%esp
80101bf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101bfc:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101bff:	57                   	push   %edi
80101c00:	e8 2b 31 00 00       	call   80104d30 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101c05:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101c08:	83 c4 10             	add    $0x10,%esp
80101c0b:	85 d2                	test   %edx,%edx
80101c0d:	74 07                	je     80101c16 <iput+0x26>
80101c0f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101c14:	74 32                	je     80101c48 <iput+0x58>
  releasesleep(&ip->lock);
80101c16:	83 ec 0c             	sub    $0xc,%esp
80101c19:	57                   	push   %edi
80101c1a:	e8 71 31 00 00       	call   80104d90 <releasesleep>
  acquire(&icache.lock);
80101c1f:	c7 04 24 20 0a 12 80 	movl   $0x80120a20,(%esp)
80101c26:	e8 35 33 00 00       	call   80104f60 <acquire>
  ip->ref--;
80101c2b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101c2f:	83 c4 10             	add    $0x10,%esp
80101c32:	c7 45 08 20 0a 12 80 	movl   $0x80120a20,0x8(%ebp)
}
80101c39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c3c:	5b                   	pop    %ebx
80101c3d:	5e                   	pop    %esi
80101c3e:	5f                   	pop    %edi
80101c3f:	5d                   	pop    %ebp
  release(&icache.lock);
80101c40:	e9 db 33 00 00       	jmp    80105020 <release>
80101c45:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101c48:	83 ec 0c             	sub    $0xc,%esp
80101c4b:	68 20 0a 12 80       	push   $0x80120a20
80101c50:	e8 0b 33 00 00       	call   80104f60 <acquire>
    int r = ip->ref;
80101c55:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101c58:	c7 04 24 20 0a 12 80 	movl   $0x80120a20,(%esp)
80101c5f:	e8 bc 33 00 00       	call   80105020 <release>
    if(r == 1){
80101c64:	83 c4 10             	add    $0x10,%esp
80101c67:	83 fe 01             	cmp    $0x1,%esi
80101c6a:	75 aa                	jne    80101c16 <iput+0x26>
80101c6c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101c72:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101c75:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101c78:	89 cf                	mov    %ecx,%edi
80101c7a:	eb 0b                	jmp    80101c87 <iput+0x97>
80101c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c80:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c83:	39 fe                	cmp    %edi,%esi
80101c85:	74 19                	je     80101ca0 <iput+0xb0>
    if(ip->addrs[i]){
80101c87:	8b 16                	mov    (%esi),%edx
80101c89:	85 d2                	test   %edx,%edx
80101c8b:	74 f3                	je     80101c80 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101c8d:	8b 03                	mov    (%ebx),%eax
80101c8f:	e8 bc f8 ff ff       	call   80101550 <bfree>
      ip->addrs[i] = 0;
80101c94:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101c9a:	eb e4                	jmp    80101c80 <iput+0x90>
80101c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101ca0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101ca6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101ca9:	85 c0                	test   %eax,%eax
80101cab:	75 33                	jne    80101ce0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101cad:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101cb0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101cb7:	53                   	push   %ebx
80101cb8:	e8 53 fd ff ff       	call   80101a10 <iupdate>
      ip->type = 0;
80101cbd:	31 c0                	xor    %eax,%eax
80101cbf:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101cc3:	89 1c 24             	mov    %ebx,(%esp)
80101cc6:	e8 45 fd ff ff       	call   80101a10 <iupdate>
      ip->valid = 0;
80101ccb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101cd2:	83 c4 10             	add    $0x10,%esp
80101cd5:	e9 3c ff ff ff       	jmp    80101c16 <iput+0x26>
80101cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101ce0:	83 ec 08             	sub    $0x8,%esp
80101ce3:	50                   	push   %eax
80101ce4:	ff 33                	pushl  (%ebx)
80101ce6:	e8 e5 e3 ff ff       	call   801000d0 <bread>
80101ceb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101cf1:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101cf4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101cf7:	8d 70 5c             	lea    0x5c(%eax),%esi
80101cfa:	83 c4 10             	add    $0x10,%esp
80101cfd:	89 cf                	mov    %ecx,%edi
80101cff:	eb 0e                	jmp    80101d0f <iput+0x11f>
80101d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d08:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101d0b:	39 fe                	cmp    %edi,%esi
80101d0d:	74 0f                	je     80101d1e <iput+0x12e>
      if(a[j])
80101d0f:	8b 16                	mov    (%esi),%edx
80101d11:	85 d2                	test   %edx,%edx
80101d13:	74 f3                	je     80101d08 <iput+0x118>
        bfree(ip->dev, a[j]);
80101d15:	8b 03                	mov    (%ebx),%eax
80101d17:	e8 34 f8 ff ff       	call   80101550 <bfree>
80101d1c:	eb ea                	jmp    80101d08 <iput+0x118>
    brelse(bp);
80101d1e:	83 ec 0c             	sub    $0xc,%esp
80101d21:	ff 75 e4             	pushl  -0x1c(%ebp)
80101d24:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101d27:	e8 b4 e4 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d2c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101d32:	8b 03                	mov    (%ebx),%eax
80101d34:	e8 17 f8 ff ff       	call   80101550 <bfree>
    ip->addrs[NDIRECT] = 0;
80101d39:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101d40:	00 00 00 
80101d43:	83 c4 10             	add    $0x10,%esp
80101d46:	e9 62 ff ff ff       	jmp    80101cad <iput+0xbd>
80101d4b:	90                   	nop
80101d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d50 <iunlockput>:
{
80101d50:	55                   	push   %ebp
80101d51:	89 e5                	mov    %esp,%ebp
80101d53:	53                   	push   %ebx
80101d54:	83 ec 10             	sub    $0x10,%esp
80101d57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101d5a:	53                   	push   %ebx
80101d5b:	e8 40 fe ff ff       	call   80101ba0 <iunlock>
  iput(ip);
80101d60:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101d63:	83 c4 10             	add    $0x10,%esp
}
80101d66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d69:	c9                   	leave  
  iput(ip);
80101d6a:	e9 81 fe ff ff       	jmp    80101bf0 <iput>
80101d6f:	90                   	nop

80101d70 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	8b 55 08             	mov    0x8(%ebp),%edx
80101d76:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101d79:	8b 0a                	mov    (%edx),%ecx
80101d7b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101d7e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101d81:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101d84:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101d88:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101d8b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101d8f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101d93:	8b 52 58             	mov    0x58(%edx),%edx
80101d96:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d99:	5d                   	pop    %ebp
80101d9a:	c3                   	ret    
80101d9b:	90                   	nop
80101d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101da0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101da0:	55                   	push   %ebp
80101da1:	89 e5                	mov    %esp,%ebp
80101da3:	57                   	push   %edi
80101da4:	56                   	push   %esi
80101da5:	53                   	push   %ebx
80101da6:	83 ec 1c             	sub    $0x1c,%esp
80101da9:	8b 45 08             	mov    0x8(%ebp),%eax
80101dac:	8b 75 0c             	mov    0xc(%ebp),%esi
80101daf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101db2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101db7:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101dba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101dbd:	8b 75 10             	mov    0x10(%ebp),%esi
80101dc0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101dc3:	0f 84 a7 00 00 00    	je     80101e70 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101dc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101dcc:	8b 40 58             	mov    0x58(%eax),%eax
80101dcf:	39 c6                	cmp    %eax,%esi
80101dd1:	0f 87 ba 00 00 00    	ja     80101e91 <readi+0xf1>
80101dd7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101dda:	89 f9                	mov    %edi,%ecx
80101ddc:	01 f1                	add    %esi,%ecx
80101dde:	0f 82 ad 00 00 00    	jb     80101e91 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101de4:	89 c2                	mov    %eax,%edx
80101de6:	29 f2                	sub    %esi,%edx
80101de8:	39 c8                	cmp    %ecx,%eax
80101dea:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ded:	31 ff                	xor    %edi,%edi
80101def:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101df1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101df4:	74 6c                	je     80101e62 <readi+0xc2>
80101df6:	8d 76 00             	lea    0x0(%esi),%esi
80101df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e00:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101e03:	89 f2                	mov    %esi,%edx
80101e05:	c1 ea 09             	shr    $0x9,%edx
80101e08:	89 d8                	mov    %ebx,%eax
80101e0a:	e8 91 f9 ff ff       	call   801017a0 <bmap>
80101e0f:	83 ec 08             	sub    $0x8,%esp
80101e12:	50                   	push   %eax
80101e13:	ff 33                	pushl  (%ebx)
80101e15:	e8 b6 e2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101e1a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e1d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101e1f:	89 f0                	mov    %esi,%eax
80101e21:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e26:	b9 00 02 00 00       	mov    $0x200,%ecx
80101e2b:	83 c4 0c             	add    $0xc,%esp
80101e2e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101e30:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101e34:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e37:	29 fb                	sub    %edi,%ebx
80101e39:	39 d9                	cmp    %ebx,%ecx
80101e3b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101e3e:	53                   	push   %ebx
80101e3f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e40:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101e42:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e45:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101e47:	e8 d4 32 00 00       	call   80105120 <memmove>
    brelse(bp);
80101e4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e4f:	89 14 24             	mov    %edx,(%esp)
80101e52:	e8 89 e3 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e57:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101e5a:	83 c4 10             	add    $0x10,%esp
80101e5d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101e60:	77 9e                	ja     80101e00 <readi+0x60>
  }
  return n;
80101e62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101e65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e68:	5b                   	pop    %ebx
80101e69:	5e                   	pop    %esi
80101e6a:	5f                   	pop    %edi
80101e6b:	5d                   	pop    %ebp
80101e6c:	c3                   	ret    
80101e6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101e70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101e74:	66 83 f8 09          	cmp    $0x9,%ax
80101e78:	77 17                	ja     80101e91 <readi+0xf1>
80101e7a:	8b 04 c5 a0 09 12 80 	mov    -0x7fedf660(,%eax,8),%eax
80101e81:	85 c0                	test   %eax,%eax
80101e83:	74 0c                	je     80101e91 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101e85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101e88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e8b:	5b                   	pop    %ebx
80101e8c:	5e                   	pop    %esi
80101e8d:	5f                   	pop    %edi
80101e8e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101e8f:	ff e0                	jmp    *%eax
      return -1;
80101e91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e96:	eb cd                	jmp    80101e65 <readi+0xc5>
80101e98:	90                   	nop
80101e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ea0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ea0:	55                   	push   %ebp
80101ea1:	89 e5                	mov    %esp,%ebp
80101ea3:	57                   	push   %edi
80101ea4:	56                   	push   %esi
80101ea5:	53                   	push   %ebx
80101ea6:	83 ec 1c             	sub    $0x1c,%esp
80101ea9:	8b 45 08             	mov    0x8(%ebp),%eax
80101eac:	8b 75 0c             	mov    0xc(%ebp),%esi
80101eaf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101eb2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101eb7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101eba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ebd:	8b 75 10             	mov    0x10(%ebp),%esi
80101ec0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ec3:	0f 84 b7 00 00 00    	je     80101f80 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ec9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ecc:	39 70 58             	cmp    %esi,0x58(%eax)
80101ecf:	0f 82 eb 00 00 00    	jb     80101fc0 <writei+0x120>
80101ed5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ed8:	31 d2                	xor    %edx,%edx
80101eda:	89 f8                	mov    %edi,%eax
80101edc:	01 f0                	add    %esi,%eax
80101ede:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ee1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ee6:	0f 87 d4 00 00 00    	ja     80101fc0 <writei+0x120>
80101eec:	85 d2                	test   %edx,%edx
80101eee:	0f 85 cc 00 00 00    	jne    80101fc0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ef4:	85 ff                	test   %edi,%edi
80101ef6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101efd:	74 72                	je     80101f71 <writei+0xd1>
80101eff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f00:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101f03:	89 f2                	mov    %esi,%edx
80101f05:	c1 ea 09             	shr    $0x9,%edx
80101f08:	89 f8                	mov    %edi,%eax
80101f0a:	e8 91 f8 ff ff       	call   801017a0 <bmap>
80101f0f:	83 ec 08             	sub    $0x8,%esp
80101f12:	50                   	push   %eax
80101f13:	ff 37                	pushl  (%edi)
80101f15:	e8 b6 e1 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101f1a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101f1d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f20:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101f22:	89 f0                	mov    %esi,%eax
80101f24:	b9 00 02 00 00       	mov    $0x200,%ecx
80101f29:	83 c4 0c             	add    $0xc,%esp
80101f2c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f31:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101f33:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101f37:	39 d9                	cmp    %ebx,%ecx
80101f39:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101f3c:	53                   	push   %ebx
80101f3d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f40:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101f42:	50                   	push   %eax
80101f43:	e8 d8 31 00 00       	call   80105120 <memmove>
    log_write(bp);
80101f48:	89 3c 24             	mov    %edi,(%esp)
80101f4b:	e8 70 16 00 00       	call   801035c0 <log_write>
    brelse(bp);
80101f50:	89 3c 24             	mov    %edi,(%esp)
80101f53:	e8 88 e2 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f58:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101f5b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101f5e:	83 c4 10             	add    $0x10,%esp
80101f61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f64:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101f67:	77 97                	ja     80101f00 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101f69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101f6c:	3b 70 58             	cmp    0x58(%eax),%esi
80101f6f:	77 37                	ja     80101fa8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101f71:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101f74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f77:	5b                   	pop    %ebx
80101f78:	5e                   	pop    %esi
80101f79:	5f                   	pop    %edi
80101f7a:	5d                   	pop    %ebp
80101f7b:	c3                   	ret    
80101f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101f84:	66 83 f8 09          	cmp    $0x9,%ax
80101f88:	77 36                	ja     80101fc0 <writei+0x120>
80101f8a:	8b 04 c5 a4 09 12 80 	mov    -0x7fedf65c(,%eax,8),%eax
80101f91:	85 c0                	test   %eax,%eax
80101f93:	74 2b                	je     80101fc0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101f95:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101f98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f9b:	5b                   	pop    %ebx
80101f9c:	5e                   	pop    %esi
80101f9d:	5f                   	pop    %edi
80101f9e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101f9f:	ff e0                	jmp    *%eax
80101fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101fa8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101fab:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101fae:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101fb1:	50                   	push   %eax
80101fb2:	e8 59 fa ff ff       	call   80101a10 <iupdate>
80101fb7:	83 c4 10             	add    $0x10,%esp
80101fba:	eb b5                	jmp    80101f71 <writei+0xd1>
80101fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fc5:	eb ad                	jmp    80101f74 <writei+0xd4>
80101fc7:	89 f6                	mov    %esi,%esi
80101fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101fd0:	55                   	push   %ebp
80101fd1:	89 e5                	mov    %esp,%ebp
80101fd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101fd6:	6a 0e                	push   $0xe
80101fd8:	ff 75 0c             	pushl  0xc(%ebp)
80101fdb:	ff 75 08             	pushl  0x8(%ebp)
80101fde:	e8 ad 31 00 00       	call   80105190 <strncmp>
}
80101fe3:	c9                   	leave  
80101fe4:	c3                   	ret    
80101fe5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ff0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	57                   	push   %edi
80101ff4:	56                   	push   %esi
80101ff5:	53                   	push   %ebx
80101ff6:	83 ec 1c             	sub    $0x1c,%esp
80101ff9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101ffc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102001:	0f 85 85 00 00 00    	jne    8010208c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102007:	8b 53 58             	mov    0x58(%ebx),%edx
8010200a:	31 ff                	xor    %edi,%edi
8010200c:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200f:	85 d2                	test   %edx,%edx
80102011:	74 3e                	je     80102051 <dirlookup+0x61>
80102013:	90                   	nop
80102014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 7e fd ff ff       	call   80101da0 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 55                	jne    8010207f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	74 18                	je     80102049 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80102031:	8d 45 da             	lea    -0x26(%ebp),%eax
80102034:	83 ec 04             	sub    $0x4,%esp
80102037:	6a 0e                	push   $0xe
80102039:	50                   	push   %eax
8010203a:	ff 75 0c             	pushl  0xc(%ebp)
8010203d:	e8 4e 31 00 00       	call   80105190 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80102042:	83 c4 10             	add    $0x10,%esp
80102045:	85 c0                	test   %eax,%eax
80102047:	74 17                	je     80102060 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102049:	83 c7 10             	add    $0x10,%edi
8010204c:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010204f:	72 c7                	jb     80102018 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102051:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80102054:	31 c0                	xor    %eax,%eax
}
80102056:	5b                   	pop    %ebx
80102057:	5e                   	pop    %esi
80102058:	5f                   	pop    %edi
80102059:	5d                   	pop    %ebp
8010205a:	c3                   	ret    
8010205b:	90                   	nop
8010205c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80102060:	8b 45 10             	mov    0x10(%ebp),%eax
80102063:	85 c0                	test   %eax,%eax
80102065:	74 05                	je     8010206c <dirlookup+0x7c>
        *poff = off;
80102067:	8b 45 10             	mov    0x10(%ebp),%eax
8010206a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010206c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102070:	8b 03                	mov    (%ebx),%eax
80102072:	e8 59 f6 ff ff       	call   801016d0 <iget>
}
80102077:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010207a:	5b                   	pop    %ebx
8010207b:	5e                   	pop    %esi
8010207c:	5f                   	pop    %edi
8010207d:	5d                   	pop    %ebp
8010207e:	c3                   	ret    
      panic("dirlookup read");
8010207f:	83 ec 0c             	sub    $0xc,%esp
80102082:	68 59 8a 10 80       	push   $0x80108a59
80102087:	e8 04 e3 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
8010208c:	83 ec 0c             	sub    $0xc,%esp
8010208f:	68 47 8a 10 80       	push   $0x80108a47
80102094:	e8 f7 e2 ff ff       	call   80100390 <panic>
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801020a0:	55                   	push   %ebp
801020a1:	89 e5                	mov    %esp,%ebp
801020a3:	57                   	push   %edi
801020a4:	56                   	push   %esi
801020a5:	53                   	push   %ebx
801020a6:	89 cf                	mov    %ecx,%edi
801020a8:	89 c3                	mov    %eax,%ebx
801020aa:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
801020ad:	80 38 2f             	cmpb   $0x2f,(%eax)
{
801020b0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
801020b3:	0f 84 67 01 00 00    	je     80102220 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
801020b9:	e8 12 20 00 00       	call   801040d0 <myproc>
  acquire(&icache.lock);
801020be:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
801020c1:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
801020c4:	68 20 0a 12 80       	push   $0x80120a20
801020c9:	e8 92 2e 00 00       	call   80104f60 <acquire>
  ip->ref++;
801020ce:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
801020d2:	c7 04 24 20 0a 12 80 	movl   $0x80120a20,(%esp)
801020d9:	e8 42 2f 00 00       	call   80105020 <release>
801020de:	83 c4 10             	add    $0x10,%esp
801020e1:	eb 08                	jmp    801020eb <namex+0x4b>
801020e3:	90                   	nop
801020e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801020e8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801020eb:	0f b6 03             	movzbl (%ebx),%eax
801020ee:	3c 2f                	cmp    $0x2f,%al
801020f0:	74 f6                	je     801020e8 <namex+0x48>
  if(*path == 0)
801020f2:	84 c0                	test   %al,%al
801020f4:	0f 84 ee 00 00 00    	je     801021e8 <namex+0x148>
  while(*path != '/' && *path != 0)
801020fa:	0f b6 03             	movzbl (%ebx),%eax
801020fd:	3c 2f                	cmp    $0x2f,%al
801020ff:	0f 84 b3 00 00 00    	je     801021b8 <namex+0x118>
80102105:	84 c0                	test   %al,%al
80102107:	89 da                	mov    %ebx,%edx
80102109:	75 09                	jne    80102114 <namex+0x74>
8010210b:	e9 a8 00 00 00       	jmp    801021b8 <namex+0x118>
80102110:	84 c0                	test   %al,%al
80102112:	74 0a                	je     8010211e <namex+0x7e>
    path++;
80102114:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80102117:	0f b6 02             	movzbl (%edx),%eax
8010211a:	3c 2f                	cmp    $0x2f,%al
8010211c:	75 f2                	jne    80102110 <namex+0x70>
8010211e:	89 d1                	mov    %edx,%ecx
80102120:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80102122:	83 f9 0d             	cmp    $0xd,%ecx
80102125:	0f 8e 91 00 00 00    	jle    801021bc <namex+0x11c>
    memmove(name, s, DIRSIZ);
8010212b:	83 ec 04             	sub    $0x4,%esp
8010212e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80102131:	6a 0e                	push   $0xe
80102133:	53                   	push   %ebx
80102134:	57                   	push   %edi
80102135:	e8 e6 2f 00 00       	call   80105120 <memmove>
    path++;
8010213a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
8010213d:	83 c4 10             	add    $0x10,%esp
    path++;
80102140:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80102142:	80 3a 2f             	cmpb   $0x2f,(%edx)
80102145:	75 11                	jne    80102158 <namex+0xb8>
80102147:	89 f6                	mov    %esi,%esi
80102149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80102150:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80102153:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102156:	74 f8                	je     80102150 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102158:	83 ec 0c             	sub    $0xc,%esp
8010215b:	56                   	push   %esi
8010215c:	e8 5f f9 ff ff       	call   80101ac0 <ilock>
    if(ip->type != T_DIR){
80102161:	83 c4 10             	add    $0x10,%esp
80102164:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102169:	0f 85 91 00 00 00    	jne    80102200 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
8010216f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102172:	85 d2                	test   %edx,%edx
80102174:	74 09                	je     8010217f <namex+0xdf>
80102176:	80 3b 00             	cmpb   $0x0,(%ebx)
80102179:	0f 84 b7 00 00 00    	je     80102236 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010217f:	83 ec 04             	sub    $0x4,%esp
80102182:	6a 00                	push   $0x0
80102184:	57                   	push   %edi
80102185:	56                   	push   %esi
80102186:	e8 65 fe ff ff       	call   80101ff0 <dirlookup>
8010218b:	83 c4 10             	add    $0x10,%esp
8010218e:	85 c0                	test   %eax,%eax
80102190:	74 6e                	je     80102200 <namex+0x160>
  iunlock(ip);
80102192:	83 ec 0c             	sub    $0xc,%esp
80102195:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102198:	56                   	push   %esi
80102199:	e8 02 fa ff ff       	call   80101ba0 <iunlock>
  iput(ip);
8010219e:	89 34 24             	mov    %esi,(%esp)
801021a1:	e8 4a fa ff ff       	call   80101bf0 <iput>
801021a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801021a9:	83 c4 10             	add    $0x10,%esp
801021ac:	89 c6                	mov    %eax,%esi
801021ae:	e9 38 ff ff ff       	jmp    801020eb <namex+0x4b>
801021b3:	90                   	nop
801021b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
801021b8:	89 da                	mov    %ebx,%edx
801021ba:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
801021bc:	83 ec 04             	sub    $0x4,%esp
801021bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
801021c2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801021c5:	51                   	push   %ecx
801021c6:	53                   	push   %ebx
801021c7:	57                   	push   %edi
801021c8:	e8 53 2f 00 00       	call   80105120 <memmove>
    name[len] = 0;
801021cd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801021d0:	8b 55 dc             	mov    -0x24(%ebp),%edx
801021d3:	83 c4 10             	add    $0x10,%esp
801021d6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
801021da:	89 d3                	mov    %edx,%ebx
801021dc:	e9 61 ff ff ff       	jmp    80102142 <namex+0xa2>
801021e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801021e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801021eb:	85 c0                	test   %eax,%eax
801021ed:	75 5d                	jne    8010224c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
801021ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021f2:	89 f0                	mov    %esi,%eax
801021f4:	5b                   	pop    %ebx
801021f5:	5e                   	pop    %esi
801021f6:	5f                   	pop    %edi
801021f7:	5d                   	pop    %ebp
801021f8:	c3                   	ret    
801021f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102200:	83 ec 0c             	sub    $0xc,%esp
80102203:	56                   	push   %esi
80102204:	e8 97 f9 ff ff       	call   80101ba0 <iunlock>
  iput(ip);
80102209:	89 34 24             	mov    %esi,(%esp)
      return 0;
8010220c:	31 f6                	xor    %esi,%esi
  iput(ip);
8010220e:	e8 dd f9 ff ff       	call   80101bf0 <iput>
      return 0;
80102213:	83 c4 10             	add    $0x10,%esp
}
80102216:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102219:	89 f0                	mov    %esi,%eax
8010221b:	5b                   	pop    %ebx
8010221c:	5e                   	pop    %esi
8010221d:	5f                   	pop    %edi
8010221e:	5d                   	pop    %ebp
8010221f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80102220:	ba 01 00 00 00       	mov    $0x1,%edx
80102225:	b8 01 00 00 00       	mov    $0x1,%eax
8010222a:	e8 a1 f4 ff ff       	call   801016d0 <iget>
8010222f:	89 c6                	mov    %eax,%esi
80102231:	e9 b5 fe ff ff       	jmp    801020eb <namex+0x4b>
      iunlock(ip);
80102236:	83 ec 0c             	sub    $0xc,%esp
80102239:	56                   	push   %esi
8010223a:	e8 61 f9 ff ff       	call   80101ba0 <iunlock>
      return ip;
8010223f:	83 c4 10             	add    $0x10,%esp
}
80102242:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102245:	89 f0                	mov    %esi,%eax
80102247:	5b                   	pop    %ebx
80102248:	5e                   	pop    %esi
80102249:	5f                   	pop    %edi
8010224a:	5d                   	pop    %ebp
8010224b:	c3                   	ret    
    iput(ip);
8010224c:	83 ec 0c             	sub    $0xc,%esp
8010224f:	56                   	push   %esi
    return 0;
80102250:	31 f6                	xor    %esi,%esi
    iput(ip);
80102252:	e8 99 f9 ff ff       	call   80101bf0 <iput>
    return 0;
80102257:	83 c4 10             	add    $0x10,%esp
8010225a:	eb 93                	jmp    801021ef <namex+0x14f>
8010225c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102260 <dirlink>:
{
80102260:	55                   	push   %ebp
80102261:	89 e5                	mov    %esp,%ebp
80102263:	57                   	push   %edi
80102264:	56                   	push   %esi
80102265:	53                   	push   %ebx
80102266:	83 ec 20             	sub    $0x20,%esp
80102269:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010226c:	6a 00                	push   $0x0
8010226e:	ff 75 0c             	pushl  0xc(%ebp)
80102271:	53                   	push   %ebx
80102272:	e8 79 fd ff ff       	call   80101ff0 <dirlookup>
80102277:	83 c4 10             	add    $0x10,%esp
8010227a:	85 c0                	test   %eax,%eax
8010227c:	75 67                	jne    801022e5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010227e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102281:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102284:	85 ff                	test   %edi,%edi
80102286:	74 29                	je     801022b1 <dirlink+0x51>
80102288:	31 ff                	xor    %edi,%edi
8010228a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010228d:	eb 09                	jmp    80102298 <dirlink+0x38>
8010228f:	90                   	nop
80102290:	83 c7 10             	add    $0x10,%edi
80102293:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102296:	73 19                	jae    801022b1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102298:	6a 10                	push   $0x10
8010229a:	57                   	push   %edi
8010229b:	56                   	push   %esi
8010229c:	53                   	push   %ebx
8010229d:	e8 fe fa ff ff       	call   80101da0 <readi>
801022a2:	83 c4 10             	add    $0x10,%esp
801022a5:	83 f8 10             	cmp    $0x10,%eax
801022a8:	75 4e                	jne    801022f8 <dirlink+0x98>
    if(de.inum == 0)
801022aa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801022af:	75 df                	jne    80102290 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801022b1:	8d 45 da             	lea    -0x26(%ebp),%eax
801022b4:	83 ec 04             	sub    $0x4,%esp
801022b7:	6a 0e                	push   $0xe
801022b9:	ff 75 0c             	pushl  0xc(%ebp)
801022bc:	50                   	push   %eax
801022bd:	e8 2e 2f 00 00       	call   801051f0 <strncpy>
  de.inum = inum;
801022c2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022c5:	6a 10                	push   $0x10
801022c7:	57                   	push   %edi
801022c8:	56                   	push   %esi
801022c9:	53                   	push   %ebx
  de.inum = inum;
801022ca:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022ce:	e8 cd fb ff ff       	call   80101ea0 <writei>
801022d3:	83 c4 20             	add    $0x20,%esp
801022d6:	83 f8 10             	cmp    $0x10,%eax
801022d9:	75 2a                	jne    80102305 <dirlink+0xa5>
  return 0;
801022db:	31 c0                	xor    %eax,%eax
}
801022dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022e0:	5b                   	pop    %ebx
801022e1:	5e                   	pop    %esi
801022e2:	5f                   	pop    %edi
801022e3:	5d                   	pop    %ebp
801022e4:	c3                   	ret    
    iput(ip);
801022e5:	83 ec 0c             	sub    $0xc,%esp
801022e8:	50                   	push   %eax
801022e9:	e8 02 f9 ff ff       	call   80101bf0 <iput>
    return -1;
801022ee:	83 c4 10             	add    $0x10,%esp
801022f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022f6:	eb e5                	jmp    801022dd <dirlink+0x7d>
      panic("dirlink read");
801022f8:	83 ec 0c             	sub    $0xc,%esp
801022fb:	68 68 8a 10 80       	push   $0x80108a68
80102300:	e8 8b e0 ff ff       	call   80100390 <panic>
    panic("dirlink");
80102305:	83 ec 0c             	sub    $0xc,%esp
80102308:	68 71 91 10 80       	push   $0x80109171
8010230d:	e8 7e e0 ff ff       	call   80100390 <panic>
80102312:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102320 <namei>:

struct inode*
namei(char *path)
{
80102320:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102321:	31 d2                	xor    %edx,%edx
{
80102323:	89 e5                	mov    %esp,%ebp
80102325:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102328:	8b 45 08             	mov    0x8(%ebp),%eax
8010232b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010232e:	e8 6d fd ff ff       	call   801020a0 <namex>
}
80102333:	c9                   	leave  
80102334:	c3                   	ret    
80102335:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102340 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102340:	55                   	push   %ebp
  return namex(path, 1, name);
80102341:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102346:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102348:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010234b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010234e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010234f:	e9 4c fd ff ff       	jmp    801020a0 <namex>
80102354:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010235a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102360 <itoa>:

#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80102360:	55                   	push   %ebp
    char const digit[] = "0123456789";
80102361:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
80102366:	89 e5                	mov    %esp,%ebp
80102368:	57                   	push   %edi
80102369:	56                   	push   %esi
8010236a:	53                   	push   %ebx
8010236b:	83 ec 10             	sub    $0x10,%esp
8010236e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80102371:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
80102378:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
8010237f:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
80102383:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
80102387:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
8010238a:	85 c9                	test   %ecx,%ecx
8010238c:	79 0a                	jns    80102398 <itoa+0x38>
8010238e:	89 f0                	mov    %esi,%eax
80102390:	8d 76 01             	lea    0x1(%esi),%esi
        *p++ = '-';
        i *= -1;
80102393:	f7 d9                	neg    %ecx
        *p++ = '-';
80102395:	c6 00 2d             	movb   $0x2d,(%eax)
    }
    int shifter = i;
80102398:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
8010239a:	bf 67 66 66 66       	mov    $0x66666667,%edi
8010239f:	90                   	nop
801023a0:	89 d8                	mov    %ebx,%eax
801023a2:	c1 fb 1f             	sar    $0x1f,%ebx
        ++p;
801023a5:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
801023a8:	f7 ef                	imul   %edi
801023aa:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
801023ad:	29 da                	sub    %ebx,%edx
801023af:	89 d3                	mov    %edx,%ebx
801023b1:	75 ed                	jne    801023a0 <itoa+0x40>
    *p = '\0';
801023b3:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
801023b6:	bb 67 66 66 66       	mov    $0x66666667,%ebx
801023bb:	90                   	nop
801023bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023c0:	89 c8                	mov    %ecx,%eax
801023c2:	83 ee 01             	sub    $0x1,%esi
801023c5:	f7 eb                	imul   %ebx
801023c7:	89 c8                	mov    %ecx,%eax
801023c9:	c1 f8 1f             	sar    $0x1f,%eax
801023cc:	c1 fa 02             	sar    $0x2,%edx
801023cf:	29 c2                	sub    %eax,%edx
801023d1:	8d 04 92             	lea    (%edx,%edx,4),%eax
801023d4:	01 c0                	add    %eax,%eax
801023d6:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
801023d8:	85 d2                	test   %edx,%edx
        *--p = digit[i%10];
801023da:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
801023df:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
801023e1:	88 06                	mov    %al,(%esi)
    }while(i);
801023e3:	75 db                	jne    801023c0 <itoa+0x60>
    return b;
}
801023e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801023e8:	83 c4 10             	add    $0x10,%esp
801023eb:	5b                   	pop    %ebx
801023ec:	5e                   	pop    %esi
801023ed:	5f                   	pop    %edi
801023ee:	5d                   	pop    %ebp
801023ef:	c3                   	ret    

801023f0 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	57                   	push   %edi
801023f4:	56                   	push   %esi
801023f5:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
801023f6:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
801023f9:	83 ec 40             	sub    $0x40,%esp
801023fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
801023ff:	6a 06                	push   $0x6
80102401:	68 75 8a 10 80       	push   $0x80108a75
80102406:	56                   	push   %esi
80102407:	e8 14 2d 00 00       	call   80105120 <memmove>
  itoa(p->pid, path+ 6);
8010240c:	58                   	pop    %eax
8010240d:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80102410:	5a                   	pop    %edx
80102411:	50                   	push   %eax
80102412:	ff 73 10             	pushl  0x10(%ebx)
80102415:	e8 46 ff ff ff       	call   80102360 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
8010241a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010241d:	83 c4 10             	add    $0x10,%esp
80102420:	85 c0                	test   %eax,%eax
80102422:	0f 84 88 01 00 00    	je     801025b0 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
80102428:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
8010242b:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
8010242e:	50                   	push   %eax
8010242f:	e8 4c ee ff ff       	call   80101280 <fileclose>

  begin_op();
80102434:	e8 b7 0f 00 00       	call   801033f0 <begin_op>
  return namex(path, 1, name);
80102439:	89 f0                	mov    %esi,%eax
8010243b:	89 d9                	mov    %ebx,%ecx
8010243d:	ba 01 00 00 00       	mov    $0x1,%edx
80102442:	e8 59 fc ff ff       	call   801020a0 <namex>
  if((dp = nameiparent(path, name)) == 0)
80102447:	83 c4 10             	add    $0x10,%esp
8010244a:	85 c0                	test   %eax,%eax
  return namex(path, 1, name);
8010244c:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
8010244e:	0f 84 66 01 00 00    	je     801025ba <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
80102454:	83 ec 0c             	sub    $0xc,%esp
80102457:	50                   	push   %eax
80102458:	e8 63 f6 ff ff       	call   80101ac0 <ilock>
  return strncmp(s, t, DIRSIZ);
8010245d:	83 c4 0c             	add    $0xc,%esp
80102460:	6a 0e                	push   $0xe
80102462:	68 7d 8a 10 80       	push   $0x80108a7d
80102467:	53                   	push   %ebx
80102468:	e8 23 2d 00 00       	call   80105190 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010246d:	83 c4 10             	add    $0x10,%esp
80102470:	85 c0                	test   %eax,%eax
80102472:	0f 84 f8 00 00 00    	je     80102570 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
80102478:	83 ec 04             	sub    $0x4,%esp
8010247b:	6a 0e                	push   $0xe
8010247d:	68 7c 8a 10 80       	push   $0x80108a7c
80102482:	53                   	push   %ebx
80102483:	e8 08 2d 00 00       	call   80105190 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102488:	83 c4 10             	add    $0x10,%esp
8010248b:	85 c0                	test   %eax,%eax
8010248d:	0f 84 dd 00 00 00    	je     80102570 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80102493:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102496:	83 ec 04             	sub    $0x4,%esp
80102499:	50                   	push   %eax
8010249a:	53                   	push   %ebx
8010249b:	56                   	push   %esi
8010249c:	e8 4f fb ff ff       	call   80101ff0 <dirlookup>
801024a1:	83 c4 10             	add    $0x10,%esp
801024a4:	85 c0                	test   %eax,%eax
801024a6:	89 c3                	mov    %eax,%ebx
801024a8:	0f 84 c2 00 00 00    	je     80102570 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
801024ae:	83 ec 0c             	sub    $0xc,%esp
801024b1:	50                   	push   %eax
801024b2:	e8 09 f6 ff ff       	call   80101ac0 <ilock>

  if(ip->nlink < 1)
801024b7:	83 c4 10             	add    $0x10,%esp
801024ba:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801024bf:	0f 8e 11 01 00 00    	jle    801025d6 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801024c5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801024ca:	74 74                	je     80102540 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801024cc:	8d 7d d8             	lea    -0x28(%ebp),%edi
801024cf:	83 ec 04             	sub    $0x4,%esp
801024d2:	6a 10                	push   $0x10
801024d4:	6a 00                	push   $0x0
801024d6:	57                   	push   %edi
801024d7:	e8 94 2b 00 00       	call   80105070 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024dc:	6a 10                	push   $0x10
801024de:	ff 75 b8             	pushl  -0x48(%ebp)
801024e1:	57                   	push   %edi
801024e2:	56                   	push   %esi
801024e3:	e8 b8 f9 ff ff       	call   80101ea0 <writei>
801024e8:	83 c4 20             	add    $0x20,%esp
801024eb:	83 f8 10             	cmp    $0x10,%eax
801024ee:	0f 85 d5 00 00 00    	jne    801025c9 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801024f4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801024f9:	0f 84 91 00 00 00    	je     80102590 <removeSwapFile+0x1a0>
  iunlock(ip);
801024ff:	83 ec 0c             	sub    $0xc,%esp
80102502:	56                   	push   %esi
80102503:	e8 98 f6 ff ff       	call   80101ba0 <iunlock>
  iput(ip);
80102508:	89 34 24             	mov    %esi,(%esp)
8010250b:	e8 e0 f6 ff ff       	call   80101bf0 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
80102510:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80102515:	89 1c 24             	mov    %ebx,(%esp)
80102518:	e8 f3 f4 ff ff       	call   80101a10 <iupdate>
  iunlock(ip);
8010251d:	89 1c 24             	mov    %ebx,(%esp)
80102520:	e8 7b f6 ff ff       	call   80101ba0 <iunlock>
  iput(ip);
80102525:	89 1c 24             	mov    %ebx,(%esp)
80102528:	e8 c3 f6 ff ff       	call   80101bf0 <iput>
  iunlockput(ip);

  end_op();
8010252d:	e8 2e 0f 00 00       	call   80103460 <end_op>

  return 0;
80102532:	83 c4 10             	add    $0x10,%esp
80102535:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
80102537:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010253a:	5b                   	pop    %ebx
8010253b:	5e                   	pop    %esi
8010253c:	5f                   	pop    %edi
8010253d:	5d                   	pop    %ebp
8010253e:	c3                   	ret    
8010253f:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
80102540:	83 ec 0c             	sub    $0xc,%esp
80102543:	53                   	push   %ebx
80102544:	e8 07 33 00 00       	call   80105850 <isdirempty>
80102549:	83 c4 10             	add    $0x10,%esp
8010254c:	85 c0                	test   %eax,%eax
8010254e:	0f 85 78 ff ff ff    	jne    801024cc <removeSwapFile+0xdc>
  iunlock(ip);
80102554:	83 ec 0c             	sub    $0xc,%esp
80102557:	53                   	push   %ebx
80102558:	e8 43 f6 ff ff       	call   80101ba0 <iunlock>
  iput(ip);
8010255d:	89 1c 24             	mov    %ebx,(%esp)
80102560:	e8 8b f6 ff ff       	call   80101bf0 <iput>
80102565:	83 c4 10             	add    $0x10,%esp
80102568:	90                   	nop
80102569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102570:	83 ec 0c             	sub    $0xc,%esp
80102573:	56                   	push   %esi
80102574:	e8 27 f6 ff ff       	call   80101ba0 <iunlock>
  iput(ip);
80102579:	89 34 24             	mov    %esi,(%esp)
8010257c:	e8 6f f6 ff ff       	call   80101bf0 <iput>
    end_op();
80102581:	e8 da 0e 00 00       	call   80103460 <end_op>
    return -1;
80102586:	83 c4 10             	add    $0x10,%esp
80102589:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010258e:	eb a7                	jmp    80102537 <removeSwapFile+0x147>
    dp->nlink--;
80102590:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80102595:	83 ec 0c             	sub    $0xc,%esp
80102598:	56                   	push   %esi
80102599:	e8 72 f4 ff ff       	call   80101a10 <iupdate>
8010259e:	83 c4 10             	add    $0x10,%esp
801025a1:	e9 59 ff ff ff       	jmp    801024ff <removeSwapFile+0x10f>
801025a6:	8d 76 00             	lea    0x0(%esi),%esi
801025a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801025b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025b5:	e9 7d ff ff ff       	jmp    80102537 <removeSwapFile+0x147>
    end_op();
801025ba:	e8 a1 0e 00 00       	call   80103460 <end_op>
    return -1;
801025bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025c4:	e9 6e ff ff ff       	jmp    80102537 <removeSwapFile+0x147>
    panic("unlink: writei");
801025c9:	83 ec 0c             	sub    $0xc,%esp
801025cc:	68 91 8a 10 80       	push   $0x80108a91
801025d1:	e8 ba dd ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801025d6:	83 ec 0c             	sub    $0xc,%esp
801025d9:	68 7f 8a 10 80       	push   $0x80108a7f
801025de:	e8 ad dd ff ff       	call   80100390 <panic>
801025e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801025e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025f0 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
801025f0:	55                   	push   %ebp
801025f1:	89 e5                	mov    %esp,%ebp
801025f3:	56                   	push   %esi
801025f4:	53                   	push   %ebx

  char path[DIGITS];
  memmove(path,"/.swap", 6);
801025f5:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
801025f8:	83 ec 14             	sub    $0x14,%esp
801025fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
801025fe:	6a 06                	push   $0x6
80102600:	68 75 8a 10 80       	push   $0x80108a75
80102605:	56                   	push   %esi
80102606:	e8 15 2b 00 00       	call   80105120 <memmove>
  itoa(p->pid, path+ 6);
8010260b:	58                   	pop    %eax
8010260c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010260f:	5a                   	pop    %edx
80102610:	50                   	push   %eax
80102611:	ff 73 10             	pushl  0x10(%ebx)
80102614:	e8 47 fd ff ff       	call   80102360 <itoa>

    begin_op();
80102619:	e8 d2 0d 00 00       	call   801033f0 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
8010261e:	6a 00                	push   $0x0
80102620:	6a 00                	push   $0x0
80102622:	6a 02                	push   $0x2
80102624:	56                   	push   %esi
80102625:	e8 36 34 00 00       	call   80105a60 <create>
  iunlock(in);
8010262a:	83 c4 14             	add    $0x14,%esp
    struct inode * in = create(path, T_FILE, 0, 0);
8010262d:	89 c6                	mov    %eax,%esi
  iunlock(in);
8010262f:	50                   	push   %eax
80102630:	e8 6b f5 ff ff       	call   80101ba0 <iunlock>

  p->swapFile = filealloc();
80102635:	e8 86 eb ff ff       	call   801011c0 <filealloc>
  if (p->swapFile == 0)
8010263a:	83 c4 10             	add    $0x10,%esp
8010263d:	85 c0                	test   %eax,%eax
  p->swapFile = filealloc();
8010263f:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
80102642:	74 32                	je     80102676 <createSwapFile+0x86>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
80102644:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
80102647:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010264a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
80102650:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102653:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
8010265a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010265d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
80102661:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102664:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
80102668:	e8 f3 0d 00 00       	call   80103460 <end_op>

    return 0;
}
8010266d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102670:	31 c0                	xor    %eax,%eax
80102672:	5b                   	pop    %ebx
80102673:	5e                   	pop    %esi
80102674:	5d                   	pop    %ebp
80102675:	c3                   	ret    
    panic("no slot for files on /store");
80102676:	83 ec 0c             	sub    $0xc,%esp
80102679:	68 a0 8a 10 80       	push   $0x80108aa0
8010267e:	e8 0d dd ff ff       	call   80100390 <panic>
80102683:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102690 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc* p, char* buffer, uint placeOnFile, uint size)
{
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102696:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102699:	8b 50 7c             	mov    0x7c(%eax),%edx
8010269c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
8010269f:	8b 55 14             	mov    0x14(%ebp),%edx
801026a2:	89 55 10             	mov    %edx,0x10(%ebp)
801026a5:	8b 40 7c             	mov    0x7c(%eax),%eax
801026a8:	89 45 08             	mov    %eax,0x8(%ebp)

}
801026ab:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
801026ac:	e9 7f ed ff ff       	jmp    80101430 <filewrite>
801026b1:	eb 0d                	jmp    801026c0 <readFromSwapFile>
801026b3:	90                   	nop
801026b4:	90                   	nop
801026b5:	90                   	nop
801026b6:	90                   	nop
801026b7:	90                   	nop
801026b8:	90                   	nop
801026b9:	90                   	nop
801026ba:	90                   	nop
801026bb:	90                   	nop
801026bc:	90                   	nop
801026bd:	90                   	nop
801026be:	90                   	nop
801026bf:	90                   	nop

801026c0 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
801026c0:	55                   	push   %ebp
801026c1:	89 e5                	mov    %esp,%ebp
801026c3:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
801026c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801026c9:	8b 50 7c             	mov    0x7c(%eax),%edx
801026cc:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
801026cf:	8b 55 14             	mov    0x14(%ebp),%edx
801026d2:	89 55 10             	mov    %edx,0x10(%ebp)
801026d5:	8b 40 7c             	mov    0x7c(%eax),%eax
801026d8:	89 45 08             	mov    %eax,0x8(%ebp)
}
801026db:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
801026dc:	e9 bf ec ff ff       	jmp    801013a0 <fileread>
801026e1:	66 90                	xchg   %ax,%ax
801026e3:	66 90                	xchg   %ax,%ax
801026e5:	66 90                	xchg   %ax,%ax
801026e7:	66 90                	xchg   %ax,%ax
801026e9:	66 90                	xchg   %ax,%ax
801026eb:	66 90                	xchg   %ax,%ax
801026ed:	66 90                	xchg   %ax,%ax
801026ef:	90                   	nop

801026f0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801026f0:	55                   	push   %ebp
801026f1:	89 e5                	mov    %esp,%ebp
801026f3:	57                   	push   %edi
801026f4:	56                   	push   %esi
801026f5:	53                   	push   %ebx
801026f6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801026f9:	85 c0                	test   %eax,%eax
801026fb:	0f 84 b4 00 00 00    	je     801027b5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102701:	8b 58 08             	mov    0x8(%eax),%ebx
80102704:	89 c6                	mov    %eax,%esi
80102706:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010270c:	0f 87 96 00 00 00    	ja     801027a8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102712:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102717:	89 f6                	mov    %esi,%esi
80102719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102720:	89 ca                	mov    %ecx,%edx
80102722:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102723:	83 e0 c0             	and    $0xffffffc0,%eax
80102726:	3c 40                	cmp    $0x40,%al
80102728:	75 f6                	jne    80102720 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010272a:	31 ff                	xor    %edi,%edi
8010272c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102731:	89 f8                	mov    %edi,%eax
80102733:	ee                   	out    %al,(%dx)
80102734:	b8 01 00 00 00       	mov    $0x1,%eax
80102739:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010273e:	ee                   	out    %al,(%dx)
8010273f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102744:	89 d8                	mov    %ebx,%eax
80102746:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102747:	89 d8                	mov    %ebx,%eax
80102749:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010274e:	c1 f8 08             	sar    $0x8,%eax
80102751:	ee                   	out    %al,(%dx)
80102752:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102757:	89 f8                	mov    %edi,%eax
80102759:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010275a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010275e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102763:	c1 e0 04             	shl    $0x4,%eax
80102766:	83 e0 10             	and    $0x10,%eax
80102769:	83 c8 e0             	or     $0xffffffe0,%eax
8010276c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010276d:	f6 06 04             	testb  $0x4,(%esi)
80102770:	75 16                	jne    80102788 <idestart+0x98>
80102772:	b8 20 00 00 00       	mov    $0x20,%eax
80102777:	89 ca                	mov    %ecx,%edx
80102779:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010277a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010277d:	5b                   	pop    %ebx
8010277e:	5e                   	pop    %esi
8010277f:	5f                   	pop    %edi
80102780:	5d                   	pop    %ebp
80102781:	c3                   	ret    
80102782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102788:	b8 30 00 00 00       	mov    $0x30,%eax
8010278d:	89 ca                	mov    %ecx,%edx
8010278f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102790:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102795:	83 c6 5c             	add    $0x5c,%esi
80102798:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010279d:	fc                   	cld    
8010279e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801027a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027a3:	5b                   	pop    %ebx
801027a4:	5e                   	pop    %esi
801027a5:	5f                   	pop    %edi
801027a6:	5d                   	pop    %ebp
801027a7:	c3                   	ret    
    panic("incorrect blockno");
801027a8:	83 ec 0c             	sub    $0xc,%esp
801027ab:	68 18 8b 10 80       	push   $0x80108b18
801027b0:	e8 db db ff ff       	call   80100390 <panic>
    panic("idestart");
801027b5:	83 ec 0c             	sub    $0xc,%esp
801027b8:	68 0f 8b 10 80       	push   $0x80108b0f
801027bd:	e8 ce db ff ff       	call   80100390 <panic>
801027c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027d0 <ideinit>:
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
801027d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801027d6:	68 2a 8b 10 80       	push   $0x80108b2a
801027db:	68 80 c5 10 80       	push   $0x8010c580
801027e0:	e8 3b 26 00 00       	call   80104e20 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801027e5:	58                   	pop    %eax
801027e6:	a1 80 2d 12 80       	mov    0x80122d80,%eax
801027eb:	5a                   	pop    %edx
801027ec:	83 e8 01             	sub    $0x1,%eax
801027ef:	50                   	push   %eax
801027f0:	6a 0e                	push   $0xe
801027f2:	e8 a9 02 00 00       	call   80102aa0 <ioapicenable>
801027f7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027fa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801027ff:	90                   	nop
80102800:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102801:	83 e0 c0             	and    $0xffffffc0,%eax
80102804:	3c 40                	cmp    $0x40,%al
80102806:	75 f8                	jne    80102800 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102808:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010280d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102812:	ee                   	out    %al,(%dx)
80102813:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102818:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010281d:	eb 06                	jmp    80102825 <ideinit+0x55>
8010281f:	90                   	nop
  for(i=0; i<1000; i++){
80102820:	83 e9 01             	sub    $0x1,%ecx
80102823:	74 0f                	je     80102834 <ideinit+0x64>
80102825:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102826:	84 c0                	test   %al,%al
80102828:	74 f6                	je     80102820 <ideinit+0x50>
      havedisk1 = 1;
8010282a:	c7 05 60 c5 10 80 01 	movl   $0x1,0x8010c560
80102831:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102834:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102839:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010283e:	ee                   	out    %al,(%dx)
}
8010283f:	c9                   	leave  
80102840:	c3                   	ret    
80102841:	eb 0d                	jmp    80102850 <ideintr>
80102843:	90                   	nop
80102844:	90                   	nop
80102845:	90                   	nop
80102846:	90                   	nop
80102847:	90                   	nop
80102848:	90                   	nop
80102849:	90                   	nop
8010284a:	90                   	nop
8010284b:	90                   	nop
8010284c:	90                   	nop
8010284d:	90                   	nop
8010284e:	90                   	nop
8010284f:	90                   	nop

80102850 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102850:	55                   	push   %ebp
80102851:	89 e5                	mov    %esp,%ebp
80102853:	57                   	push   %edi
80102854:	56                   	push   %esi
80102855:	53                   	push   %ebx
80102856:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102859:	68 80 c5 10 80       	push   $0x8010c580
8010285e:	e8 fd 26 00 00       	call   80104f60 <acquire>

  if((b = idequeue) == 0){
80102863:	8b 1d 64 c5 10 80    	mov    0x8010c564,%ebx
80102869:	83 c4 10             	add    $0x10,%esp
8010286c:	85 db                	test   %ebx,%ebx
8010286e:	74 67                	je     801028d7 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102870:	8b 43 58             	mov    0x58(%ebx),%eax
80102873:	a3 64 c5 10 80       	mov    %eax,0x8010c564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102878:	8b 3b                	mov    (%ebx),%edi
8010287a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102880:	75 31                	jne    801028b3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102882:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102887:	89 f6                	mov    %esi,%esi
80102889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102890:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102891:	89 c6                	mov    %eax,%esi
80102893:	83 e6 c0             	and    $0xffffffc0,%esi
80102896:	89 f1                	mov    %esi,%ecx
80102898:	80 f9 40             	cmp    $0x40,%cl
8010289b:	75 f3                	jne    80102890 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010289d:	a8 21                	test   $0x21,%al
8010289f:	75 12                	jne    801028b3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801028a1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801028a4:	b9 80 00 00 00       	mov    $0x80,%ecx
801028a9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801028ae:	fc                   	cld    
801028af:	f3 6d                	rep insl (%dx),%es:(%edi)
801028b1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801028b3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801028b6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801028b9:	89 f9                	mov    %edi,%ecx
801028bb:	83 c9 02             	or     $0x2,%ecx
801028be:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801028c0:	53                   	push   %ebx
801028c1:	e8 2a 22 00 00       	call   80104af0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801028c6:	a1 64 c5 10 80       	mov    0x8010c564,%eax
801028cb:	83 c4 10             	add    $0x10,%esp
801028ce:	85 c0                	test   %eax,%eax
801028d0:	74 05                	je     801028d7 <ideintr+0x87>
    idestart(idequeue);
801028d2:	e8 19 fe ff ff       	call   801026f0 <idestart>
    release(&idelock);
801028d7:	83 ec 0c             	sub    $0xc,%esp
801028da:	68 80 c5 10 80       	push   $0x8010c580
801028df:	e8 3c 27 00 00       	call   80105020 <release>

  release(&idelock);
}
801028e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801028e7:	5b                   	pop    %ebx
801028e8:	5e                   	pop    %esi
801028e9:	5f                   	pop    %edi
801028ea:	5d                   	pop    %ebp
801028eb:	c3                   	ret    
801028ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801028f0:	55                   	push   %ebp
801028f1:	89 e5                	mov    %esp,%ebp
801028f3:	53                   	push   %ebx
801028f4:	83 ec 10             	sub    $0x10,%esp
801028f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801028fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801028fd:	50                   	push   %eax
801028fe:	e8 cd 24 00 00       	call   80104dd0 <holdingsleep>
80102903:	83 c4 10             	add    $0x10,%esp
80102906:	85 c0                	test   %eax,%eax
80102908:	0f 84 c6 00 00 00    	je     801029d4 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010290e:	8b 03                	mov    (%ebx),%eax
80102910:	83 e0 06             	and    $0x6,%eax
80102913:	83 f8 02             	cmp    $0x2,%eax
80102916:	0f 84 ab 00 00 00    	je     801029c7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010291c:	8b 53 04             	mov    0x4(%ebx),%edx
8010291f:	85 d2                	test   %edx,%edx
80102921:	74 0d                	je     80102930 <iderw+0x40>
80102923:	a1 60 c5 10 80       	mov    0x8010c560,%eax
80102928:	85 c0                	test   %eax,%eax
8010292a:	0f 84 b1 00 00 00    	je     801029e1 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102930:	83 ec 0c             	sub    $0xc,%esp
80102933:	68 80 c5 10 80       	push   $0x8010c580
80102938:	e8 23 26 00 00       	call   80104f60 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010293d:	8b 15 64 c5 10 80    	mov    0x8010c564,%edx
80102943:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102946:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010294d:	85 d2                	test   %edx,%edx
8010294f:	75 09                	jne    8010295a <iderw+0x6a>
80102951:	eb 6d                	jmp    801029c0 <iderw+0xd0>
80102953:	90                   	nop
80102954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102958:	89 c2                	mov    %eax,%edx
8010295a:	8b 42 58             	mov    0x58(%edx),%eax
8010295d:	85 c0                	test   %eax,%eax
8010295f:	75 f7                	jne    80102958 <iderw+0x68>
80102961:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102964:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102966:	39 1d 64 c5 10 80    	cmp    %ebx,0x8010c564
8010296c:	74 42                	je     801029b0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010296e:	8b 03                	mov    (%ebx),%eax
80102970:	83 e0 06             	and    $0x6,%eax
80102973:	83 f8 02             	cmp    $0x2,%eax
80102976:	74 23                	je     8010299b <iderw+0xab>
80102978:	90                   	nop
80102979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102980:	83 ec 08             	sub    $0x8,%esp
80102983:	68 80 c5 10 80       	push   $0x8010c580
80102988:	53                   	push   %ebx
80102989:	e8 12 1f 00 00       	call   801048a0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010298e:	8b 03                	mov    (%ebx),%eax
80102990:	83 c4 10             	add    $0x10,%esp
80102993:	83 e0 06             	and    $0x6,%eax
80102996:	83 f8 02             	cmp    $0x2,%eax
80102999:	75 e5                	jne    80102980 <iderw+0x90>
  }


  release(&idelock);
8010299b:	c7 45 08 80 c5 10 80 	movl   $0x8010c580,0x8(%ebp)
}
801029a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029a5:	c9                   	leave  
  release(&idelock);
801029a6:	e9 75 26 00 00       	jmp    80105020 <release>
801029ab:	90                   	nop
801029ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801029b0:	89 d8                	mov    %ebx,%eax
801029b2:	e8 39 fd ff ff       	call   801026f0 <idestart>
801029b7:	eb b5                	jmp    8010296e <iderw+0x7e>
801029b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801029c0:	ba 64 c5 10 80       	mov    $0x8010c564,%edx
801029c5:	eb 9d                	jmp    80102964 <iderw+0x74>
    panic("iderw: nothing to do");
801029c7:	83 ec 0c             	sub    $0xc,%esp
801029ca:	68 44 8b 10 80       	push   $0x80108b44
801029cf:	e8 bc d9 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801029d4:	83 ec 0c             	sub    $0xc,%esp
801029d7:	68 2e 8b 10 80       	push   $0x80108b2e
801029dc:	e8 af d9 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
801029e1:	83 ec 0c             	sub    $0xc,%esp
801029e4:	68 59 8b 10 80       	push   $0x80108b59
801029e9:	e8 a2 d9 ff ff       	call   80100390 <panic>
801029ee:	66 90                	xchg   %ax,%ax

801029f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801029f0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801029f1:	c7 05 74 26 12 80 00 	movl   $0xfec00000,0x80122674
801029f8:	00 c0 fe 
{
801029fb:	89 e5                	mov    %esp,%ebp
801029fd:	56                   	push   %esi
801029fe:	53                   	push   %ebx
  ioapic->reg = reg;
801029ff:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102a06:	00 00 00 
  return ioapic->data;
80102a09:	a1 74 26 12 80       	mov    0x80122674,%eax
80102a0e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102a11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102a17:	8b 0d 74 26 12 80    	mov    0x80122674,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102a1d:	0f b6 15 e0 27 12 80 	movzbl 0x801227e0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a24:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102a27:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a2a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
80102a2d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102a30:	39 c2                	cmp    %eax,%edx
80102a32:	74 16                	je     80102a4a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102a34:	83 ec 0c             	sub    $0xc,%esp
80102a37:	68 78 8b 10 80       	push   $0x80108b78
80102a3c:	e8 1f dc ff ff       	call   80100660 <cprintf>
80102a41:	8b 0d 74 26 12 80    	mov    0x80122674,%ecx
80102a47:	83 c4 10             	add    $0x10,%esp
80102a4a:	83 c3 21             	add    $0x21,%ebx
{
80102a4d:	ba 10 00 00 00       	mov    $0x10,%edx
80102a52:	b8 20 00 00 00       	mov    $0x20,%eax
80102a57:	89 f6                	mov    %esi,%esi
80102a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102a60:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102a62:	8b 0d 74 26 12 80    	mov    0x80122674,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102a68:	89 c6                	mov    %eax,%esi
80102a6a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102a70:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102a73:	89 71 10             	mov    %esi,0x10(%ecx)
80102a76:	8d 72 01             	lea    0x1(%edx),%esi
80102a79:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
80102a7c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
80102a7e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102a80:	8b 0d 74 26 12 80    	mov    0x80122674,%ecx
80102a86:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102a8d:	75 d1                	jne    80102a60 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102a8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a92:	5b                   	pop    %ebx
80102a93:	5e                   	pop    %esi
80102a94:	5d                   	pop    %ebp
80102a95:	c3                   	ret    
80102a96:	8d 76 00             	lea    0x0(%esi),%esi
80102a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102aa0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102aa0:	55                   	push   %ebp
  ioapic->reg = reg;
80102aa1:	8b 0d 74 26 12 80    	mov    0x80122674,%ecx
{
80102aa7:	89 e5                	mov    %esp,%ebp
80102aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102aac:	8d 50 20             	lea    0x20(%eax),%edx
80102aaf:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102ab3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102ab5:	8b 0d 74 26 12 80    	mov    0x80122674,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102abb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102abe:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102ac1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102ac4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102ac6:	a1 74 26 12 80       	mov    0x80122674,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102acb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102ace:	89 50 10             	mov    %edx,0x10(%eax)
}
80102ad1:	5d                   	pop    %ebp
80102ad2:	c3                   	ret    
80102ad3:	66 90                	xchg   %ax,%ax
80102ad5:	66 90                	xchg   %ax,%ax
80102ad7:	66 90                	xchg   %ax,%ax
80102ad9:	66 90                	xchg   %ax,%ax
80102adb:	66 90                	xchg   %ax,%ax
80102add:	66 90                	xchg   %ax,%ax
80102adf:	90                   	nop

80102ae0 <init_cow>:



struct spinlock r_cow_lock;

void init_cow(){
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
80102ae3:	83 ec 14             	sub    $0x14,%esp
  cprintf("initing cow\n");
80102ae6:	68 aa 8b 10 80       	push   $0x80108baa
80102aeb:	e8 70 db ff ff       	call   80100660 <cprintf>
  memset((void*)pg_ref_counts, 0, sizeof(pg_ref_counts));
80102af0:	83 c4 0c             	add    $0xc,%esp
80102af3:	68 00 e0 00 00       	push   $0xe000
80102af8:	6a 00                	push   $0x0
80102afa:	68 40 1f 11 80       	push   $0x80111f40
80102aff:	e8 6c 25 00 00       	call   80105070 <memset>
  initlock(&r_cow_lock, "cow lock");
80102b04:	58                   	pop    %eax
80102b05:	5a                   	pop    %edx
80102b06:	68 b7 8b 10 80       	push   $0x80108bb7
80102b0b:	68 c0 26 12 80       	push   $0x801226c0
80102b10:	e8 0b 23 00 00       	call   80104e20 <initlock>
  cow_lock = &r_cow_lock;
  cprintf("initing cow end\n");
80102b15:	c7 04 24 c0 8b 10 80 	movl   $0x80108bc0,(%esp)
  cow_lock = &r_cow_lock;
80102b1c:	c7 05 40 ff 11 80 c0 	movl   $0x801226c0,0x8011ff40
80102b23:	26 12 80 
  cprintf("initing cow end\n");
80102b26:	e8 35 db ff ff       	call   80100660 <cprintf>
}
80102b2b:	83 c4 10             	add    $0x10,%esp
80102b2e:	c9                   	leave  
80102b2f:	c3                   	ret    

80102b30 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b30:	55                   	push   %ebp
80102b31:	89 e5                	mov    %esp,%ebp
80102b33:	53                   	push   %ebx
80102b34:	83 ec 04             	sub    $0x4,%esp
80102b37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102b3a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102b40:	75 70                	jne    80102bb2 <kfree+0x82>
80102b42:	81 fb 28 2a 13 80    	cmp    $0x80132a28,%ebx
80102b48:	72 68                	jb     80102bb2 <kfree+0x82>
80102b4a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102b50:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b55:	77 5b                	ja     80102bb2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b57:	83 ec 04             	sub    $0x4,%esp
80102b5a:	68 00 10 00 00       	push   $0x1000
80102b5f:	6a 01                	push   $0x1
80102b61:	53                   	push   %ebx
80102b62:	e8 09 25 00 00       	call   80105070 <memset>

  if(kmem.use_lock)
80102b67:	8b 15 b4 26 12 80    	mov    0x801226b4,%edx
80102b6d:	83 c4 10             	add    $0x10,%esp
80102b70:	85 d2                	test   %edx,%edx
80102b72:	75 2c                	jne    80102ba0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102b74:	a1 b8 26 12 80       	mov    0x801226b8,%eax
80102b79:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102b7b:	a1 b4 26 12 80       	mov    0x801226b4,%eax
  kmem.freelist = r;
80102b80:	89 1d b8 26 12 80    	mov    %ebx,0x801226b8
  if(kmem.use_lock)
80102b86:	85 c0                	test   %eax,%eax
80102b88:	75 06                	jne    80102b90 <kfree+0x60>
    release(&kmem.lock);
}
80102b8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b8d:	c9                   	leave  
80102b8e:	c3                   	ret    
80102b8f:	90                   	nop
    release(&kmem.lock);
80102b90:	c7 45 08 80 26 12 80 	movl   $0x80122680,0x8(%ebp)
}
80102b97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b9a:	c9                   	leave  
    release(&kmem.lock);
80102b9b:	e9 80 24 00 00       	jmp    80105020 <release>
    acquire(&kmem.lock);
80102ba0:	83 ec 0c             	sub    $0xc,%esp
80102ba3:	68 80 26 12 80       	push   $0x80122680
80102ba8:	e8 b3 23 00 00       	call   80104f60 <acquire>
80102bad:	83 c4 10             	add    $0x10,%esp
80102bb0:	eb c2                	jmp    80102b74 <kfree+0x44>
    panic("kfree");
80102bb2:	83 ec 0c             	sub    $0xc,%esp
80102bb5:	68 e7 94 10 80       	push   $0x801094e7
80102bba:	e8 d1 d7 ff ff       	call   80100390 <panic>
80102bbf:	90                   	nop

80102bc0 <freerange>:
{
80102bc0:	55                   	push   %ebp
80102bc1:	89 e5                	mov    %esp,%ebp
80102bc3:	56                   	push   %esi
80102bc4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102bc5:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102bc8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102bcb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102bd1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102bd7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102bdd:	39 de                	cmp    %ebx,%esi
80102bdf:	72 33                	jb     80102c14 <freerange+0x54>
80102be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102be8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102bee:	83 ec 0c             	sub    $0xc,%esp
80102bf1:	50                   	push   %eax
80102bf2:	e8 39 ff ff ff       	call   80102b30 <kfree>
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102bf7:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102bfd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c03:	83 c4 10             	add    $0x10,%esp
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102c06:	c1 e8 0c             	shr    $0xc,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102c09:	39 f3                	cmp    %esi,%ebx
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102c0b:	c6 80 40 1f 11 80 00 	movb   $0x0,-0x7feee0c0(%eax)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102c12:	76 d4                	jbe    80102be8 <freerange+0x28>
}
80102c14:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c17:	5b                   	pop    %ebx
80102c18:	5e                   	pop    %esi
80102c19:	5d                   	pop    %ebp
80102c1a:	c3                   	ret    
80102c1b:	90                   	nop
80102c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c20 <kinit1>:
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	56                   	push   %esi
80102c24:	53                   	push   %ebx
80102c25:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102c28:	83 ec 08             	sub    $0x8,%esp
80102c2b:	68 d1 8b 10 80       	push   $0x80108bd1
80102c30:	68 80 26 12 80       	push   $0x80122680
80102c35:	e8 e6 21 00 00       	call   80104e20 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102c3d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102c40:	c7 05 b4 26 12 80 00 	movl   $0x0,0x801226b4
80102c47:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102c4a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102c50:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102c56:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c5c:	39 de                	cmp    %ebx,%esi
80102c5e:	72 2c                	jb     80102c8c <kinit1+0x6c>
    kfree(p);
80102c60:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102c66:	83 ec 0c             	sub    $0xc,%esp
80102c69:	50                   	push   %eax
80102c6a:	e8 c1 fe ff ff       	call   80102b30 <kfree>
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102c6f:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102c75:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c7b:	83 c4 10             	add    $0x10,%esp
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102c7e:	c1 e8 0c             	shr    $0xc,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102c81:	39 de                	cmp    %ebx,%esi
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102c83:	c6 80 40 1f 11 80 00 	movb   $0x0,-0x7feee0c0(%eax)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102c8a:	73 d4                	jae    80102c60 <kinit1+0x40>
}
80102c8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c8f:	5b                   	pop    %ebx
80102c90:	5e                   	pop    %esi
80102c91:	5d                   	pop    %ebp
80102c92:	c3                   	ret    
80102c93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ca0 <kinit2>:
{
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
80102ca3:	56                   	push   %esi
80102ca4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102ca5:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102ca8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102cab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102cb1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102cb7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102cbd:	39 de                	cmp    %ebx,%esi
80102cbf:	72 33                	jb     80102cf4 <kinit2+0x54>
80102cc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102cc8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102cce:	83 ec 0c             	sub    $0xc,%esp
80102cd1:	50                   	push   %eax
80102cd2:	e8 59 fe ff ff       	call   80102b30 <kfree>
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102cd7:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102cdd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102ce3:	83 c4 10             	add    $0x10,%esp
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102ce6:	c1 e8 0c             	shr    $0xc,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102ce9:	39 de                	cmp    %ebx,%esi
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102ceb:	c6 80 40 1f 11 80 00 	movb   $0x0,-0x7feee0c0(%eax)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102cf2:	73 d4                	jae    80102cc8 <kinit2+0x28>
  kmem.use_lock = 1;
80102cf4:	c7 05 b4 26 12 80 01 	movl   $0x1,0x801226b4
80102cfb:	00 00 00 
}
80102cfe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d01:	5b                   	pop    %ebx
80102d02:	5e                   	pop    %esi
80102d03:	5d                   	pop    %ebp
80102d04:	c3                   	ret    
80102d05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d10 <kalloc>:
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
  struct run *r;
  if(kmem.use_lock)
80102d10:	a1 b4 26 12 80       	mov    0x801226b4,%eax
80102d15:	85 c0                	test   %eax,%eax
80102d17:	75 1f                	jne    80102d38 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102d19:	a1 b8 26 12 80       	mov    0x801226b8,%eax
  if(r)
80102d1e:	85 c0                	test   %eax,%eax
80102d20:	74 0e                	je     80102d30 <kalloc+0x20>
    kmem.freelist = r->next;
80102d22:	8b 10                	mov    (%eax),%edx
80102d24:	89 15 b8 26 12 80    	mov    %edx,0x801226b8
80102d2a:	c3                   	ret    
80102d2b:	90                   	nop
80102d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102d30:	f3 c3                	repz ret 
80102d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102d38:	55                   	push   %ebp
80102d39:	89 e5                	mov    %esp,%ebp
80102d3b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102d3e:	68 80 26 12 80       	push   $0x80122680
80102d43:	e8 18 22 00 00       	call   80104f60 <acquire>
  r = kmem.freelist;
80102d48:	a1 b8 26 12 80       	mov    0x801226b8,%eax
  if(r)
80102d4d:	83 c4 10             	add    $0x10,%esp
80102d50:	8b 15 b4 26 12 80    	mov    0x801226b4,%edx
80102d56:	85 c0                	test   %eax,%eax
80102d58:	74 08                	je     80102d62 <kalloc+0x52>
    kmem.freelist = r->next;
80102d5a:	8b 08                	mov    (%eax),%ecx
80102d5c:	89 0d b8 26 12 80    	mov    %ecx,0x801226b8
  if(kmem.use_lock)
80102d62:	85 d2                	test   %edx,%edx
80102d64:	74 16                	je     80102d7c <kalloc+0x6c>
    release(&kmem.lock);
80102d66:	83 ec 0c             	sub    $0xc,%esp
80102d69:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102d6c:	68 80 26 12 80       	push   $0x80122680
80102d71:	e8 aa 22 00 00       	call   80105020 <release>
  return (char*)r;
80102d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102d79:	83 c4 10             	add    $0x10,%esp
}
80102d7c:	c9                   	leave  
80102d7d:	c3                   	ret    
80102d7e:	66 90                	xchg   %ax,%ax

80102d80 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d80:	ba 64 00 00 00       	mov    $0x64,%edx
80102d85:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102d86:	a8 01                	test   $0x1,%al
80102d88:	0f 84 c2 00 00 00    	je     80102e50 <kbdgetc+0xd0>
80102d8e:	ba 60 00 00 00       	mov    $0x60,%edx
80102d93:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102d94:	0f b6 d0             	movzbl %al,%edx
80102d97:	8b 0d b4 c5 10 80    	mov    0x8010c5b4,%ecx

  if(data == 0xE0){
80102d9d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102da3:	0f 84 7f 00 00 00    	je     80102e28 <kbdgetc+0xa8>
{
80102da9:	55                   	push   %ebp
80102daa:	89 e5                	mov    %esp,%ebp
80102dac:	53                   	push   %ebx
80102dad:	89 cb                	mov    %ecx,%ebx
80102daf:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102db2:	84 c0                	test   %al,%al
80102db4:	78 4a                	js     80102e00 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102db6:	85 db                	test   %ebx,%ebx
80102db8:	74 09                	je     80102dc3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102dba:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102dbd:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102dc0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102dc3:	0f b6 82 00 8d 10 80 	movzbl -0x7fef7300(%edx),%eax
80102dca:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102dcc:	0f b6 82 00 8c 10 80 	movzbl -0x7fef7400(%edx),%eax
80102dd3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102dd5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102dd7:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102ddd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102de0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102de3:	8b 04 85 e0 8b 10 80 	mov    -0x7fef7420(,%eax,4),%eax
80102dea:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102dee:	74 31                	je     80102e21 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102df0:	8d 50 9f             	lea    -0x61(%eax),%edx
80102df3:	83 fa 19             	cmp    $0x19,%edx
80102df6:	77 40                	ja     80102e38 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102df8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102dfb:	5b                   	pop    %ebx
80102dfc:	5d                   	pop    %ebp
80102dfd:	c3                   	ret    
80102dfe:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102e00:	83 e0 7f             	and    $0x7f,%eax
80102e03:	85 db                	test   %ebx,%ebx
80102e05:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102e08:	0f b6 82 00 8d 10 80 	movzbl -0x7fef7300(%edx),%eax
80102e0f:	83 c8 40             	or     $0x40,%eax
80102e12:	0f b6 c0             	movzbl %al,%eax
80102e15:	f7 d0                	not    %eax
80102e17:	21 c1                	and    %eax,%ecx
    return 0;
80102e19:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102e1b:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
}
80102e21:	5b                   	pop    %ebx
80102e22:	5d                   	pop    %ebp
80102e23:	c3                   	ret    
80102e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102e28:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102e2b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102e2d:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
    return 0;
80102e33:	c3                   	ret    
80102e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102e38:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102e3b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102e3e:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102e3f:	83 f9 1a             	cmp    $0x1a,%ecx
80102e42:	0f 42 c2             	cmovb  %edx,%eax
}
80102e45:	5d                   	pop    %ebp
80102e46:	c3                   	ret    
80102e47:	89 f6                	mov    %esi,%esi
80102e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102e50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102e55:	c3                   	ret    
80102e56:	8d 76 00             	lea    0x0(%esi),%esi
80102e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e60 <kbdintr>:

void
kbdintr(void)
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102e66:	68 80 2d 10 80       	push   $0x80102d80
80102e6b:	e8 a0 d9 ff ff       	call   80100810 <consoleintr>
}
80102e70:	83 c4 10             	add    $0x10,%esp
80102e73:	c9                   	leave  
80102e74:	c3                   	ret    
80102e75:	66 90                	xchg   %ax,%ax
80102e77:	66 90                	xchg   %ax,%ax
80102e79:	66 90                	xchg   %ax,%ax
80102e7b:	66 90                	xchg   %ax,%ax
80102e7d:	66 90                	xchg   %ax,%ax
80102e7f:	90                   	nop

80102e80 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102e80:	a1 f4 26 12 80       	mov    0x801226f4,%eax
{
80102e85:	55                   	push   %ebp
80102e86:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102e88:	85 c0                	test   %eax,%eax
80102e8a:	0f 84 c8 00 00 00    	je     80102f58 <lapicinit+0xd8>
  lapic[index] = value;
80102e90:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102e97:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e9a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e9d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102ea4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ea7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102eaa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102eb1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102eb4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102eb7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102ebe:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102ec1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ec4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102ecb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102ece:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ed1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102ed8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102edb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102ede:	8b 50 30             	mov    0x30(%eax),%edx
80102ee1:	c1 ea 10             	shr    $0x10,%edx
80102ee4:	80 fa 03             	cmp    $0x3,%dl
80102ee7:	77 77                	ja     80102f60 <lapicinit+0xe0>
  lapic[index] = value;
80102ee9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102ef0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ef3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ef6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102efd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f00:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f03:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102f0a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f0d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f10:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102f17:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f1a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f1d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102f24:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f27:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f2a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102f31:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102f34:	8b 50 20             	mov    0x20(%eax),%edx
80102f37:	89 f6                	mov    %esi,%esi
80102f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102f40:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102f46:	80 e6 10             	and    $0x10,%dh
80102f49:	75 f5                	jne    80102f40 <lapicinit+0xc0>
  lapic[index] = value;
80102f4b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102f52:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f55:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102f58:	5d                   	pop    %ebp
80102f59:	c3                   	ret    
80102f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102f60:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102f67:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102f6a:	8b 50 20             	mov    0x20(%eax),%edx
80102f6d:	e9 77 ff ff ff       	jmp    80102ee9 <lapicinit+0x69>
80102f72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f80 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102f80:	8b 15 f4 26 12 80    	mov    0x801226f4,%edx
{
80102f86:	55                   	push   %ebp
80102f87:	31 c0                	xor    %eax,%eax
80102f89:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102f8b:	85 d2                	test   %edx,%edx
80102f8d:	74 06                	je     80102f95 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102f8f:	8b 42 20             	mov    0x20(%edx),%eax
80102f92:	c1 e8 18             	shr    $0x18,%eax
}
80102f95:	5d                   	pop    %ebp
80102f96:	c3                   	ret    
80102f97:	89 f6                	mov    %esi,%esi
80102f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fa0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102fa0:	a1 f4 26 12 80       	mov    0x801226f4,%eax
{
80102fa5:	55                   	push   %ebp
80102fa6:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102fa8:	85 c0                	test   %eax,%eax
80102faa:	74 0d                	je     80102fb9 <lapiceoi+0x19>
  lapic[index] = value;
80102fac:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102fb3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102fb6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102fb9:	5d                   	pop    %ebp
80102fba:	c3                   	ret    
80102fbb:	90                   	nop
80102fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102fc0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
}
80102fc3:	5d                   	pop    %ebp
80102fc4:	c3                   	ret    
80102fc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fd0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102fd0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fd1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102fd6:	ba 70 00 00 00       	mov    $0x70,%edx
80102fdb:	89 e5                	mov    %esp,%ebp
80102fdd:	53                   	push   %ebx
80102fde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102fe1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102fe4:	ee                   	out    %al,(%dx)
80102fe5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102fea:	ba 71 00 00 00       	mov    $0x71,%edx
80102fef:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102ff0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102ff2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102ff5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102ffb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102ffd:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80103000:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80103003:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80103005:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80103008:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010300e:	a1 f4 26 12 80       	mov    0x801226f4,%eax
80103013:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103019:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010301c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103023:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103026:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103029:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103030:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103033:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103036:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010303c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010303f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103045:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103048:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010304e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103051:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103057:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010305a:	5b                   	pop    %ebx
8010305b:	5d                   	pop    %ebp
8010305c:	c3                   	ret    
8010305d:	8d 76 00             	lea    0x0(%esi),%esi

80103060 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103060:	55                   	push   %ebp
80103061:	b8 0b 00 00 00       	mov    $0xb,%eax
80103066:	ba 70 00 00 00       	mov    $0x70,%edx
8010306b:	89 e5                	mov    %esp,%ebp
8010306d:	57                   	push   %edi
8010306e:	56                   	push   %esi
8010306f:	53                   	push   %ebx
80103070:	83 ec 4c             	sub    $0x4c,%esp
80103073:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103074:	ba 71 00 00 00       	mov    $0x71,%edx
80103079:	ec                   	in     (%dx),%al
8010307a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010307d:	bb 70 00 00 00       	mov    $0x70,%ebx
80103082:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103085:	8d 76 00             	lea    0x0(%esi),%esi
80103088:	31 c0                	xor    %eax,%eax
8010308a:	89 da                	mov    %ebx,%edx
8010308c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010308d:	b9 71 00 00 00       	mov    $0x71,%ecx
80103092:	89 ca                	mov    %ecx,%edx
80103094:	ec                   	in     (%dx),%al
80103095:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103098:	89 da                	mov    %ebx,%edx
8010309a:	b8 02 00 00 00       	mov    $0x2,%eax
8010309f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030a0:	89 ca                	mov    %ecx,%edx
801030a2:	ec                   	in     (%dx),%al
801030a3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030a6:	89 da                	mov    %ebx,%edx
801030a8:	b8 04 00 00 00       	mov    $0x4,%eax
801030ad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030ae:	89 ca                	mov    %ecx,%edx
801030b0:	ec                   	in     (%dx),%al
801030b1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030b4:	89 da                	mov    %ebx,%edx
801030b6:	b8 07 00 00 00       	mov    $0x7,%eax
801030bb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030bc:	89 ca                	mov    %ecx,%edx
801030be:	ec                   	in     (%dx),%al
801030bf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030c2:	89 da                	mov    %ebx,%edx
801030c4:	b8 08 00 00 00       	mov    $0x8,%eax
801030c9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030ca:	89 ca                	mov    %ecx,%edx
801030cc:	ec                   	in     (%dx),%al
801030cd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030cf:	89 da                	mov    %ebx,%edx
801030d1:	b8 09 00 00 00       	mov    $0x9,%eax
801030d6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030d7:	89 ca                	mov    %ecx,%edx
801030d9:	ec                   	in     (%dx),%al
801030da:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030dc:	89 da                	mov    %ebx,%edx
801030de:	b8 0a 00 00 00       	mov    $0xa,%eax
801030e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030e4:	89 ca                	mov    %ecx,%edx
801030e6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801030e7:	84 c0                	test   %al,%al
801030e9:	78 9d                	js     80103088 <cmostime+0x28>
  return inb(CMOS_RETURN);
801030eb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801030ef:	89 fa                	mov    %edi,%edx
801030f1:	0f b6 fa             	movzbl %dl,%edi
801030f4:	89 f2                	mov    %esi,%edx
801030f6:	0f b6 f2             	movzbl %dl,%esi
801030f9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030fc:	89 da                	mov    %ebx,%edx
801030fe:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103101:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103104:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103108:	89 45 bc             	mov    %eax,-0x44(%ebp)
8010310b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010310f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80103112:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80103116:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103119:	31 c0                	xor    %eax,%eax
8010311b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010311c:	89 ca                	mov    %ecx,%edx
8010311e:	ec                   	in     (%dx),%al
8010311f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103122:	89 da                	mov    %ebx,%edx
80103124:	89 45 d0             	mov    %eax,-0x30(%ebp)
80103127:	b8 02 00 00 00       	mov    $0x2,%eax
8010312c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010312d:	89 ca                	mov    %ecx,%edx
8010312f:	ec                   	in     (%dx),%al
80103130:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103133:	89 da                	mov    %ebx,%edx
80103135:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103138:	b8 04 00 00 00       	mov    $0x4,%eax
8010313d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010313e:	89 ca                	mov    %ecx,%edx
80103140:	ec                   	in     (%dx),%al
80103141:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103144:	89 da                	mov    %ebx,%edx
80103146:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103149:	b8 07 00 00 00       	mov    $0x7,%eax
8010314e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010314f:	89 ca                	mov    %ecx,%edx
80103151:	ec                   	in     (%dx),%al
80103152:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103155:	89 da                	mov    %ebx,%edx
80103157:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010315a:	b8 08 00 00 00       	mov    $0x8,%eax
8010315f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103160:	89 ca                	mov    %ecx,%edx
80103162:	ec                   	in     (%dx),%al
80103163:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103166:	89 da                	mov    %ebx,%edx
80103168:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010316b:	b8 09 00 00 00       	mov    $0x9,%eax
80103170:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103171:	89 ca                	mov    %ecx,%edx
80103173:	ec                   	in     (%dx),%al
80103174:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103177:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010317a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010317d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103180:	6a 18                	push   $0x18
80103182:	50                   	push   %eax
80103183:	8d 45 b8             	lea    -0x48(%ebp),%eax
80103186:	50                   	push   %eax
80103187:	e8 34 1f 00 00       	call   801050c0 <memcmp>
8010318c:	83 c4 10             	add    $0x10,%esp
8010318f:	85 c0                	test   %eax,%eax
80103191:	0f 85 f1 fe ff ff    	jne    80103088 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80103197:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010319b:	75 78                	jne    80103215 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010319d:	8b 45 b8             	mov    -0x48(%ebp),%eax
801031a0:	89 c2                	mov    %eax,%edx
801031a2:	83 e0 0f             	and    $0xf,%eax
801031a5:	c1 ea 04             	shr    $0x4,%edx
801031a8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031ab:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031ae:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801031b1:	8b 45 bc             	mov    -0x44(%ebp),%eax
801031b4:	89 c2                	mov    %eax,%edx
801031b6:	83 e0 0f             	and    $0xf,%eax
801031b9:	c1 ea 04             	shr    $0x4,%edx
801031bc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031bf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031c2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801031c5:	8b 45 c0             	mov    -0x40(%ebp),%eax
801031c8:	89 c2                	mov    %eax,%edx
801031ca:	83 e0 0f             	and    $0xf,%eax
801031cd:	c1 ea 04             	shr    $0x4,%edx
801031d0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031d3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031d6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801031d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801031dc:	89 c2                	mov    %eax,%edx
801031de:	83 e0 0f             	and    $0xf,%eax
801031e1:	c1 ea 04             	shr    $0x4,%edx
801031e4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031e7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031ea:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801031ed:	8b 45 c8             	mov    -0x38(%ebp),%eax
801031f0:	89 c2                	mov    %eax,%edx
801031f2:	83 e0 0f             	and    $0xf,%eax
801031f5:	c1 ea 04             	shr    $0x4,%edx
801031f8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031fb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031fe:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103201:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103204:	89 c2                	mov    %eax,%edx
80103206:	83 e0 0f             	and    $0xf,%eax
80103209:	c1 ea 04             	shr    $0x4,%edx
8010320c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010320f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103212:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103215:	8b 75 08             	mov    0x8(%ebp),%esi
80103218:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010321b:	89 06                	mov    %eax,(%esi)
8010321d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103220:	89 46 04             	mov    %eax,0x4(%esi)
80103223:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103226:	89 46 08             	mov    %eax,0x8(%esi)
80103229:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010322c:	89 46 0c             	mov    %eax,0xc(%esi)
8010322f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103232:	89 46 10             	mov    %eax,0x10(%esi)
80103235:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103238:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
8010323b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80103242:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103245:	5b                   	pop    %ebx
80103246:	5e                   	pop    %esi
80103247:	5f                   	pop    %edi
80103248:	5d                   	pop    %ebp
80103249:	c3                   	ret    
8010324a:	66 90                	xchg   %ax,%ax
8010324c:	66 90                	xchg   %ax,%ax
8010324e:	66 90                	xchg   %ax,%ax

80103250 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103250:	8b 0d 48 27 12 80    	mov    0x80122748,%ecx
80103256:	85 c9                	test   %ecx,%ecx
80103258:	0f 8e 8a 00 00 00    	jle    801032e8 <install_trans+0x98>
{
8010325e:	55                   	push   %ebp
8010325f:	89 e5                	mov    %esp,%ebp
80103261:	57                   	push   %edi
80103262:	56                   	push   %esi
80103263:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80103264:	31 db                	xor    %ebx,%ebx
{
80103266:	83 ec 0c             	sub    $0xc,%esp
80103269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103270:	a1 34 27 12 80       	mov    0x80122734,%eax
80103275:	83 ec 08             	sub    $0x8,%esp
80103278:	01 d8                	add    %ebx,%eax
8010327a:	83 c0 01             	add    $0x1,%eax
8010327d:	50                   	push   %eax
8010327e:	ff 35 44 27 12 80    	pushl  0x80122744
80103284:	e8 47 ce ff ff       	call   801000d0 <bread>
80103289:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010328b:	58                   	pop    %eax
8010328c:	5a                   	pop    %edx
8010328d:	ff 34 9d 4c 27 12 80 	pushl  -0x7fedd8b4(,%ebx,4)
80103294:	ff 35 44 27 12 80    	pushl  0x80122744
  for (tail = 0; tail < log.lh.n; tail++) {
8010329a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010329d:	e8 2e ce ff ff       	call   801000d0 <bread>
801032a2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801032a4:	8d 47 5c             	lea    0x5c(%edi),%eax
801032a7:	83 c4 0c             	add    $0xc,%esp
801032aa:	68 00 02 00 00       	push   $0x200
801032af:	50                   	push   %eax
801032b0:	8d 46 5c             	lea    0x5c(%esi),%eax
801032b3:	50                   	push   %eax
801032b4:	e8 67 1e 00 00       	call   80105120 <memmove>
    bwrite(dbuf);  // write dst to disk
801032b9:	89 34 24             	mov    %esi,(%esp)
801032bc:	e8 df ce ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801032c1:	89 3c 24             	mov    %edi,(%esp)
801032c4:	e8 17 cf ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801032c9:	89 34 24             	mov    %esi,(%esp)
801032cc:	e8 0f cf ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801032d1:	83 c4 10             	add    $0x10,%esp
801032d4:	39 1d 48 27 12 80    	cmp    %ebx,0x80122748
801032da:	7f 94                	jg     80103270 <install_trans+0x20>
  }
}
801032dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032df:	5b                   	pop    %ebx
801032e0:	5e                   	pop    %esi
801032e1:	5f                   	pop    %edi
801032e2:	5d                   	pop    %ebp
801032e3:	c3                   	ret    
801032e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032e8:	f3 c3                	repz ret 
801032ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801032f0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801032f0:	55                   	push   %ebp
801032f1:	89 e5                	mov    %esp,%ebp
801032f3:	56                   	push   %esi
801032f4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
801032f5:	83 ec 08             	sub    $0x8,%esp
801032f8:	ff 35 34 27 12 80    	pushl  0x80122734
801032fe:	ff 35 44 27 12 80    	pushl  0x80122744
80103304:	e8 c7 cd ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80103309:	8b 1d 48 27 12 80    	mov    0x80122748,%ebx
  for (i = 0; i < log.lh.n; i++) {
8010330f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80103312:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80103314:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80103316:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103319:	7e 16                	jle    80103331 <write_head+0x41>
8010331b:	c1 e3 02             	shl    $0x2,%ebx
8010331e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80103320:	8b 8a 4c 27 12 80    	mov    -0x7fedd8b4(%edx),%ecx
80103326:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
8010332a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
8010332d:	39 da                	cmp    %ebx,%edx
8010332f:	75 ef                	jne    80103320 <write_head+0x30>
  }
  bwrite(buf);
80103331:	83 ec 0c             	sub    $0xc,%esp
80103334:	56                   	push   %esi
80103335:	e8 66 ce ff ff       	call   801001a0 <bwrite>
  brelse(buf);
8010333a:	89 34 24             	mov    %esi,(%esp)
8010333d:	e8 9e ce ff ff       	call   801001e0 <brelse>
}
80103342:	83 c4 10             	add    $0x10,%esp
80103345:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103348:	5b                   	pop    %ebx
80103349:	5e                   	pop    %esi
8010334a:	5d                   	pop    %ebp
8010334b:	c3                   	ret    
8010334c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103350 <initlog>:
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	53                   	push   %ebx
80103354:	83 ec 2c             	sub    $0x2c,%esp
80103357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010335a:	68 00 8e 10 80       	push   $0x80108e00
8010335f:	68 00 27 12 80       	push   $0x80122700
80103364:	e8 b7 1a 00 00       	call   80104e20 <initlock>
  readsb(dev, &sb);
80103369:	58                   	pop    %eax
8010336a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010336d:	5a                   	pop    %edx
8010336e:	50                   	push   %eax
8010336f:	53                   	push   %ebx
80103370:	e8 0b e5 ff ff       	call   80101880 <readsb>
  log.size = sb.nlog;
80103375:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103378:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010337b:	59                   	pop    %ecx
  log.dev = dev;
8010337c:	89 1d 44 27 12 80    	mov    %ebx,0x80122744
  log.size = sb.nlog;
80103382:	89 15 38 27 12 80    	mov    %edx,0x80122738
  log.start = sb.logstart;
80103388:	a3 34 27 12 80       	mov    %eax,0x80122734
  struct buf *buf = bread(log.dev, log.start);
8010338d:	5a                   	pop    %edx
8010338e:	50                   	push   %eax
8010338f:	53                   	push   %ebx
80103390:	e8 3b cd ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80103395:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80103398:	83 c4 10             	add    $0x10,%esp
8010339b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
8010339d:	89 1d 48 27 12 80    	mov    %ebx,0x80122748
  for (i = 0; i < log.lh.n; i++) {
801033a3:	7e 1c                	jle    801033c1 <initlog+0x71>
801033a5:	c1 e3 02             	shl    $0x2,%ebx
801033a8:	31 d2                	xor    %edx,%edx
801033aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
801033b0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
801033b4:	83 c2 04             	add    $0x4,%edx
801033b7:	89 8a 48 27 12 80    	mov    %ecx,-0x7fedd8b8(%edx)
  for (i = 0; i < log.lh.n; i++) {
801033bd:	39 d3                	cmp    %edx,%ebx
801033bf:	75 ef                	jne    801033b0 <initlog+0x60>
  brelse(buf);
801033c1:	83 ec 0c             	sub    $0xc,%esp
801033c4:	50                   	push   %eax
801033c5:	e8 16 ce ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801033ca:	e8 81 fe ff ff       	call   80103250 <install_trans>
  log.lh.n = 0;
801033cf:	c7 05 48 27 12 80 00 	movl   $0x0,0x80122748
801033d6:	00 00 00 
  write_head(); // clear the log
801033d9:	e8 12 ff ff ff       	call   801032f0 <write_head>
}
801033de:	83 c4 10             	add    $0x10,%esp
801033e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801033e4:	c9                   	leave  
801033e5:	c3                   	ret    
801033e6:	8d 76 00             	lea    0x0(%esi),%esi
801033e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801033f0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801033f6:	68 00 27 12 80       	push   $0x80122700
801033fb:	e8 60 1b 00 00       	call   80104f60 <acquire>
80103400:	83 c4 10             	add    $0x10,%esp
80103403:	eb 18                	jmp    8010341d <begin_op+0x2d>
80103405:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103408:	83 ec 08             	sub    $0x8,%esp
8010340b:	68 00 27 12 80       	push   $0x80122700
80103410:	68 00 27 12 80       	push   $0x80122700
80103415:	e8 86 14 00 00       	call   801048a0 <sleep>
8010341a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010341d:	a1 40 27 12 80       	mov    0x80122740,%eax
80103422:	85 c0                	test   %eax,%eax
80103424:	75 e2                	jne    80103408 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103426:	a1 3c 27 12 80       	mov    0x8012273c,%eax
8010342b:	8b 15 48 27 12 80    	mov    0x80122748,%edx
80103431:	83 c0 01             	add    $0x1,%eax
80103434:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103437:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010343a:	83 fa 1e             	cmp    $0x1e,%edx
8010343d:	7f c9                	jg     80103408 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010343f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103442:	a3 3c 27 12 80       	mov    %eax,0x8012273c
      release(&log.lock);
80103447:	68 00 27 12 80       	push   $0x80122700
8010344c:	e8 cf 1b 00 00       	call   80105020 <release>
      break;
    }
  }
}
80103451:	83 c4 10             	add    $0x10,%esp
80103454:	c9                   	leave  
80103455:	c3                   	ret    
80103456:	8d 76 00             	lea    0x0(%esi),%esi
80103459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103460 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103460:	55                   	push   %ebp
80103461:	89 e5                	mov    %esp,%ebp
80103463:	57                   	push   %edi
80103464:	56                   	push   %esi
80103465:	53                   	push   %ebx
80103466:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103469:	68 00 27 12 80       	push   $0x80122700
8010346e:	e8 ed 1a 00 00       	call   80104f60 <acquire>
  log.outstanding -= 1;
80103473:	a1 3c 27 12 80       	mov    0x8012273c,%eax
  if(log.committing)
80103478:	8b 35 40 27 12 80    	mov    0x80122740,%esi
8010347e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103481:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80103484:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80103486:	89 1d 3c 27 12 80    	mov    %ebx,0x8012273c
  if(log.committing)
8010348c:	0f 85 1a 01 00 00    	jne    801035ac <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80103492:	85 db                	test   %ebx,%ebx
80103494:	0f 85 ee 00 00 00    	jne    80103588 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010349a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
8010349d:	c7 05 40 27 12 80 01 	movl   $0x1,0x80122740
801034a4:	00 00 00 
  release(&log.lock);
801034a7:	68 00 27 12 80       	push   $0x80122700
801034ac:	e8 6f 1b 00 00       	call   80105020 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801034b1:	8b 0d 48 27 12 80    	mov    0x80122748,%ecx
801034b7:	83 c4 10             	add    $0x10,%esp
801034ba:	85 c9                	test   %ecx,%ecx
801034bc:	0f 8e 85 00 00 00    	jle    80103547 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801034c2:	a1 34 27 12 80       	mov    0x80122734,%eax
801034c7:	83 ec 08             	sub    $0x8,%esp
801034ca:	01 d8                	add    %ebx,%eax
801034cc:	83 c0 01             	add    $0x1,%eax
801034cf:	50                   	push   %eax
801034d0:	ff 35 44 27 12 80    	pushl  0x80122744
801034d6:	e8 f5 cb ff ff       	call   801000d0 <bread>
801034db:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801034dd:	58                   	pop    %eax
801034de:	5a                   	pop    %edx
801034df:	ff 34 9d 4c 27 12 80 	pushl  -0x7fedd8b4(,%ebx,4)
801034e6:	ff 35 44 27 12 80    	pushl  0x80122744
  for (tail = 0; tail < log.lh.n; tail++) {
801034ec:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801034ef:	e8 dc cb ff ff       	call   801000d0 <bread>
801034f4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801034f6:	8d 40 5c             	lea    0x5c(%eax),%eax
801034f9:	83 c4 0c             	add    $0xc,%esp
801034fc:	68 00 02 00 00       	push   $0x200
80103501:	50                   	push   %eax
80103502:	8d 46 5c             	lea    0x5c(%esi),%eax
80103505:	50                   	push   %eax
80103506:	e8 15 1c 00 00       	call   80105120 <memmove>
    bwrite(to);  // write the log
8010350b:	89 34 24             	mov    %esi,(%esp)
8010350e:	e8 8d cc ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103513:	89 3c 24             	mov    %edi,(%esp)
80103516:	e8 c5 cc ff ff       	call   801001e0 <brelse>
    brelse(to);
8010351b:	89 34 24             	mov    %esi,(%esp)
8010351e:	e8 bd cc ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103523:	83 c4 10             	add    $0x10,%esp
80103526:	3b 1d 48 27 12 80    	cmp    0x80122748,%ebx
8010352c:	7c 94                	jl     801034c2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010352e:	e8 bd fd ff ff       	call   801032f0 <write_head>
    install_trans(); // Now install writes to home locations
80103533:	e8 18 fd ff ff       	call   80103250 <install_trans>
    log.lh.n = 0;
80103538:	c7 05 48 27 12 80 00 	movl   $0x0,0x80122748
8010353f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103542:	e8 a9 fd ff ff       	call   801032f0 <write_head>
    acquire(&log.lock);
80103547:	83 ec 0c             	sub    $0xc,%esp
8010354a:	68 00 27 12 80       	push   $0x80122700
8010354f:	e8 0c 1a 00 00       	call   80104f60 <acquire>
    wakeup(&log);
80103554:	c7 04 24 00 27 12 80 	movl   $0x80122700,(%esp)
    log.committing = 0;
8010355b:	c7 05 40 27 12 80 00 	movl   $0x0,0x80122740
80103562:	00 00 00 
    wakeup(&log);
80103565:	e8 86 15 00 00       	call   80104af0 <wakeup>
    release(&log.lock);
8010356a:	c7 04 24 00 27 12 80 	movl   $0x80122700,(%esp)
80103571:	e8 aa 1a 00 00       	call   80105020 <release>
80103576:	83 c4 10             	add    $0x10,%esp
}
80103579:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010357c:	5b                   	pop    %ebx
8010357d:	5e                   	pop    %esi
8010357e:	5f                   	pop    %edi
8010357f:	5d                   	pop    %ebp
80103580:	c3                   	ret    
80103581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103588:	83 ec 0c             	sub    $0xc,%esp
8010358b:	68 00 27 12 80       	push   $0x80122700
80103590:	e8 5b 15 00 00       	call   80104af0 <wakeup>
  release(&log.lock);
80103595:	c7 04 24 00 27 12 80 	movl   $0x80122700,(%esp)
8010359c:	e8 7f 1a 00 00       	call   80105020 <release>
801035a1:	83 c4 10             	add    $0x10,%esp
}
801035a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035a7:	5b                   	pop    %ebx
801035a8:	5e                   	pop    %esi
801035a9:	5f                   	pop    %edi
801035aa:	5d                   	pop    %ebp
801035ab:	c3                   	ret    
    panic("log.committing");
801035ac:	83 ec 0c             	sub    $0xc,%esp
801035af:	68 04 8e 10 80       	push   $0x80108e04
801035b4:	e8 d7 cd ff ff       	call   80100390 <panic>
801035b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801035c0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	53                   	push   %ebx
801035c4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801035c7:	8b 15 48 27 12 80    	mov    0x80122748,%edx
{
801035cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801035d0:	83 fa 1d             	cmp    $0x1d,%edx
801035d3:	0f 8f 9d 00 00 00    	jg     80103676 <log_write+0xb6>
801035d9:	a1 38 27 12 80       	mov    0x80122738,%eax
801035de:	83 e8 01             	sub    $0x1,%eax
801035e1:	39 c2                	cmp    %eax,%edx
801035e3:	0f 8d 8d 00 00 00    	jge    80103676 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
801035e9:	a1 3c 27 12 80       	mov    0x8012273c,%eax
801035ee:	85 c0                	test   %eax,%eax
801035f0:	0f 8e 8d 00 00 00    	jle    80103683 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
801035f6:	83 ec 0c             	sub    $0xc,%esp
801035f9:	68 00 27 12 80       	push   $0x80122700
801035fe:	e8 5d 19 00 00       	call   80104f60 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103603:	8b 0d 48 27 12 80    	mov    0x80122748,%ecx
80103609:	83 c4 10             	add    $0x10,%esp
8010360c:	83 f9 00             	cmp    $0x0,%ecx
8010360f:	7e 57                	jle    80103668 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103611:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103614:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103616:	3b 15 4c 27 12 80    	cmp    0x8012274c,%edx
8010361c:	75 0b                	jne    80103629 <log_write+0x69>
8010361e:	eb 38                	jmp    80103658 <log_write+0x98>
80103620:	39 14 85 4c 27 12 80 	cmp    %edx,-0x7fedd8b4(,%eax,4)
80103627:	74 2f                	je     80103658 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103629:	83 c0 01             	add    $0x1,%eax
8010362c:	39 c1                	cmp    %eax,%ecx
8010362e:	75 f0                	jne    80103620 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103630:	89 14 85 4c 27 12 80 	mov    %edx,-0x7fedd8b4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103637:	83 c0 01             	add    $0x1,%eax
8010363a:	a3 48 27 12 80       	mov    %eax,0x80122748
  b->flags |= B_DIRTY; // prevent eviction
8010363f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103642:	c7 45 08 00 27 12 80 	movl   $0x80122700,0x8(%ebp)
}
80103649:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010364c:	c9                   	leave  
  release(&log.lock);
8010364d:	e9 ce 19 00 00       	jmp    80105020 <release>
80103652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103658:	89 14 85 4c 27 12 80 	mov    %edx,-0x7fedd8b4(,%eax,4)
8010365f:	eb de                	jmp    8010363f <log_write+0x7f>
80103661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103668:	8b 43 08             	mov    0x8(%ebx),%eax
8010366b:	a3 4c 27 12 80       	mov    %eax,0x8012274c
  if (i == log.lh.n)
80103670:	75 cd                	jne    8010363f <log_write+0x7f>
80103672:	31 c0                	xor    %eax,%eax
80103674:	eb c1                	jmp    80103637 <log_write+0x77>
    panic("too big a transaction");
80103676:	83 ec 0c             	sub    $0xc,%esp
80103679:	68 13 8e 10 80       	push   $0x80108e13
8010367e:	e8 0d cd ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103683:	83 ec 0c             	sub    $0xc,%esp
80103686:	68 29 8e 10 80       	push   $0x80108e29
8010368b:	e8 00 cd ff ff       	call   80100390 <panic>

80103690 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	53                   	push   %ebx
80103694:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103697:	e8 14 0a 00 00       	call   801040b0 <cpuid>
8010369c:	89 c3                	mov    %eax,%ebx
8010369e:	e8 0d 0a 00 00       	call   801040b0 <cpuid>
801036a3:	83 ec 04             	sub    $0x4,%esp
801036a6:	53                   	push   %ebx
801036a7:	50                   	push   %eax
801036a8:	68 44 8e 10 80       	push   $0x80108e44
801036ad:	e8 ae cf ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
801036b2:	e8 89 2c 00 00       	call   80106340 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801036b7:	e8 64 09 00 00       	call   80104020 <mycpu>
801036bc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801036be:	b8 01 00 00 00       	mov    $0x1,%eax
801036c3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801036ca:	e8 81 0e 00 00       	call   80104550 <scheduler>
801036cf:	90                   	nop

801036d0 <mpenter>:
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801036d6:	e8 95 42 00 00       	call   80107970 <switchkvm>
  seginit();
801036db:	e8 e0 41 00 00       	call   801078c0 <seginit>
  lapicinit();
801036e0:	e8 9b f7 ff ff       	call   80102e80 <lapicinit>
  mpmain();
801036e5:	e8 a6 ff ff ff       	call   80103690 <mpmain>
801036ea:	66 90                	xchg   %ax,%ax
801036ec:	66 90                	xchg   %ax,%ax
801036ee:	66 90                	xchg   %ax,%ax

801036f0 <main>:
{
801036f0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801036f4:	83 e4 f0             	and    $0xfffffff0,%esp
801036f7:	ff 71 fc             	pushl  -0x4(%ecx)
801036fa:	55                   	push   %ebp
801036fb:	89 e5                	mov    %esp,%ebp
801036fd:	53                   	push   %ebx
801036fe:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801036ff:	83 ec 08             	sub    $0x8,%esp
80103702:	68 00 00 40 80       	push   $0x80400000
80103707:	68 28 2a 13 80       	push   $0x80132a28
8010370c:	e8 0f f5 ff ff       	call   80102c20 <kinit1>
  kvmalloc();      // kernel page table
80103711:	e8 ea 47 00 00       	call   80107f00 <kvmalloc>
  mpinit();        // detect other processors
80103716:	e8 75 01 00 00       	call   80103890 <mpinit>
  lapicinit();     // interrupt controller
8010371b:	e8 60 f7 ff ff       	call   80102e80 <lapicinit>
  init_cow();
80103720:	e8 bb f3 ff ff       	call   80102ae0 <init_cow>
  seginit();       // segment descriptors
80103725:	e8 96 41 00 00       	call   801078c0 <seginit>
  picinit();       // disable pic
8010372a:	e8 41 03 00 00       	call   80103a70 <picinit>
  ioapicinit();    // another interrupt controller
8010372f:	e8 bc f2 ff ff       	call   801029f0 <ioapicinit>
  consoleinit();   // console hardware
80103734:	e8 87 d2 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103739:	e8 52 30 00 00       	call   80106790 <uartinit>
  pinit();         // process table
8010373e:	e8 bd 08 00 00       	call   80104000 <pinit>
  tvinit();        // trap vectors
80103743:	e8 78 2b 00 00       	call   801062c0 <tvinit>
  binit();         // buffer cache
80103748:	e8 f3 c8 ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010374d:	e8 4e da ff ff       	call   801011a0 <fileinit>
  ideinit();       // disk 
80103752:	e8 79 f0 ff ff       	call   801027d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103757:	83 c4 0c             	add    $0xc,%esp
8010375a:	68 8a 00 00 00       	push   $0x8a
8010375f:	68 8c c4 10 80       	push   $0x8010c48c
80103764:	68 00 70 00 80       	push   $0x80007000
80103769:	e8 b2 19 00 00       	call   80105120 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010376e:	69 05 80 2d 12 80 b0 	imul   $0xb0,0x80122d80,%eax
80103775:	00 00 00 
80103778:	83 c4 10             	add    $0x10,%esp
8010377b:	05 00 28 12 80       	add    $0x80122800,%eax
80103780:	3d 00 28 12 80       	cmp    $0x80122800,%eax
80103785:	76 6c                	jbe    801037f3 <main+0x103>
80103787:	bb 00 28 12 80       	mov    $0x80122800,%ebx
8010378c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80103790:	e8 8b 08 00 00       	call   80104020 <mycpu>
80103795:	39 d8                	cmp    %ebx,%eax
80103797:	74 41                	je     801037da <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = cow_kalloc();
80103799:	e8 02 3c 00 00       	call   801073a0 <cow_kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010379e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
801037a3:	c7 05 f8 6f 00 80 d0 	movl   $0x801036d0,0x80006ff8
801037aa:	36 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801037ad:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
801037b4:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801037b7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
801037bc:	0f b6 03             	movzbl (%ebx),%eax
801037bf:	83 ec 08             	sub    $0x8,%esp
801037c2:	68 00 70 00 00       	push   $0x7000
801037c7:	50                   	push   %eax
801037c8:	e8 03 f8 ff ff       	call   80102fd0 <lapicstartap>
801037cd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801037d0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801037d6:	85 c0                	test   %eax,%eax
801037d8:	74 f6                	je     801037d0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
801037da:	69 05 80 2d 12 80 b0 	imul   $0xb0,0x80122d80,%eax
801037e1:	00 00 00 
801037e4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801037ea:	05 00 28 12 80       	add    $0x80122800,%eax
801037ef:	39 c3                	cmp    %eax,%ebx
801037f1:	72 9d                	jb     80103790 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801037f3:	83 ec 08             	sub    $0x8,%esp
801037f6:	68 00 00 00 8e       	push   $0x8e000000
801037fb:	68 00 00 40 80       	push   $0x80400000
80103800:	e8 9b f4 ff ff       	call   80102ca0 <kinit2>
  userinit();      // first user process
80103805:	e8 f6 08 00 00       	call   80104100 <userinit>
  mpmain();        // finish this processor's setup
8010380a:	e8 81 fe ff ff       	call   80103690 <mpmain>
8010380f:	90                   	nop

80103810 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	57                   	push   %edi
80103814:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103815:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010381b:	53                   	push   %ebx
  e = addr+len;
8010381c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010381f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103822:	39 de                	cmp    %ebx,%esi
80103824:	72 10                	jb     80103836 <mpsearch1+0x26>
80103826:	eb 50                	jmp    80103878 <mpsearch1+0x68>
80103828:	90                   	nop
80103829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103830:	39 fb                	cmp    %edi,%ebx
80103832:	89 fe                	mov    %edi,%esi
80103834:	76 42                	jbe    80103878 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103836:	83 ec 04             	sub    $0x4,%esp
80103839:	8d 7e 10             	lea    0x10(%esi),%edi
8010383c:	6a 04                	push   $0x4
8010383e:	68 58 8e 10 80       	push   $0x80108e58
80103843:	56                   	push   %esi
80103844:	e8 77 18 00 00       	call   801050c0 <memcmp>
80103849:	83 c4 10             	add    $0x10,%esp
8010384c:	85 c0                	test   %eax,%eax
8010384e:	75 e0                	jne    80103830 <mpsearch1+0x20>
80103850:	89 f1                	mov    %esi,%ecx
80103852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103858:	0f b6 11             	movzbl (%ecx),%edx
8010385b:	83 c1 01             	add    $0x1,%ecx
8010385e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103860:	39 f9                	cmp    %edi,%ecx
80103862:	75 f4                	jne    80103858 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103864:	84 c0                	test   %al,%al
80103866:	75 c8                	jne    80103830 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103868:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010386b:	89 f0                	mov    %esi,%eax
8010386d:	5b                   	pop    %ebx
8010386e:	5e                   	pop    %esi
8010386f:	5f                   	pop    %edi
80103870:	5d                   	pop    %ebp
80103871:	c3                   	ret    
80103872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103878:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010387b:	31 f6                	xor    %esi,%esi
}
8010387d:	89 f0                	mov    %esi,%eax
8010387f:	5b                   	pop    %ebx
80103880:	5e                   	pop    %esi
80103881:	5f                   	pop    %edi
80103882:	5d                   	pop    %ebp
80103883:	c3                   	ret    
80103884:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010388a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103890 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	57                   	push   %edi
80103894:	56                   	push   %esi
80103895:	53                   	push   %ebx
80103896:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103899:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801038a0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801038a7:	c1 e0 08             	shl    $0x8,%eax
801038aa:	09 d0                	or     %edx,%eax
801038ac:	c1 e0 04             	shl    $0x4,%eax
801038af:	85 c0                	test   %eax,%eax
801038b1:	75 1b                	jne    801038ce <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801038b3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801038ba:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801038c1:	c1 e0 08             	shl    $0x8,%eax
801038c4:	09 d0                	or     %edx,%eax
801038c6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801038c9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801038ce:	ba 00 04 00 00       	mov    $0x400,%edx
801038d3:	e8 38 ff ff ff       	call   80103810 <mpsearch1>
801038d8:	85 c0                	test   %eax,%eax
801038da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801038dd:	0f 84 3d 01 00 00    	je     80103a20 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801038e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801038e6:	8b 58 04             	mov    0x4(%eax),%ebx
801038e9:	85 db                	test   %ebx,%ebx
801038eb:	0f 84 4f 01 00 00    	je     80103a40 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801038f1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801038f7:	83 ec 04             	sub    $0x4,%esp
801038fa:	6a 04                	push   $0x4
801038fc:	68 75 8e 10 80       	push   $0x80108e75
80103901:	56                   	push   %esi
80103902:	e8 b9 17 00 00       	call   801050c0 <memcmp>
80103907:	83 c4 10             	add    $0x10,%esp
8010390a:	85 c0                	test   %eax,%eax
8010390c:	0f 85 2e 01 00 00    	jne    80103a40 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103912:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103919:	3c 01                	cmp    $0x1,%al
8010391b:	0f 95 c2             	setne  %dl
8010391e:	3c 04                	cmp    $0x4,%al
80103920:	0f 95 c0             	setne  %al
80103923:	20 c2                	and    %al,%dl
80103925:	0f 85 15 01 00 00    	jne    80103a40 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010392b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103932:	66 85 ff             	test   %di,%di
80103935:	74 1a                	je     80103951 <mpinit+0xc1>
80103937:	89 f0                	mov    %esi,%eax
80103939:	01 f7                	add    %esi,%edi
  sum = 0;
8010393b:	31 d2                	xor    %edx,%edx
8010393d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103940:	0f b6 08             	movzbl (%eax),%ecx
80103943:	83 c0 01             	add    $0x1,%eax
80103946:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103948:	39 c7                	cmp    %eax,%edi
8010394a:	75 f4                	jne    80103940 <mpinit+0xb0>
8010394c:	84 d2                	test   %dl,%dl
8010394e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103951:	85 f6                	test   %esi,%esi
80103953:	0f 84 e7 00 00 00    	je     80103a40 <mpinit+0x1b0>
80103959:	84 d2                	test   %dl,%dl
8010395b:	0f 85 df 00 00 00    	jne    80103a40 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103961:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103967:	a3 f4 26 12 80       	mov    %eax,0x801226f4
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010396c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103973:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103979:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010397e:	01 d6                	add    %edx,%esi
80103980:	39 c6                	cmp    %eax,%esi
80103982:	76 23                	jbe    801039a7 <mpinit+0x117>
    switch(*p){
80103984:	0f b6 10             	movzbl (%eax),%edx
80103987:	80 fa 04             	cmp    $0x4,%dl
8010398a:	0f 87 ca 00 00 00    	ja     80103a5a <mpinit+0x1ca>
80103990:	ff 24 95 9c 8e 10 80 	jmp    *-0x7fef7164(,%edx,4)
80103997:	89 f6                	mov    %esi,%esi
80103999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801039a0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039a3:	39 c6                	cmp    %eax,%esi
801039a5:	77 dd                	ja     80103984 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801039a7:	85 db                	test   %ebx,%ebx
801039a9:	0f 84 9e 00 00 00    	je     80103a4d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801039af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801039b2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801039b6:	74 15                	je     801039cd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801039b8:	b8 70 00 00 00       	mov    $0x70,%eax
801039bd:	ba 22 00 00 00       	mov    $0x22,%edx
801039c2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801039c3:	ba 23 00 00 00       	mov    $0x23,%edx
801039c8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801039c9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801039cc:	ee                   	out    %al,(%dx)
  }
}
801039cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039d0:	5b                   	pop    %ebx
801039d1:	5e                   	pop    %esi
801039d2:	5f                   	pop    %edi
801039d3:	5d                   	pop    %ebp
801039d4:	c3                   	ret    
801039d5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801039d8:	8b 0d 80 2d 12 80    	mov    0x80122d80,%ecx
801039de:	83 f9 07             	cmp    $0x7,%ecx
801039e1:	7f 19                	jg     801039fc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801039e3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801039e7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801039ed:	83 c1 01             	add    $0x1,%ecx
801039f0:	89 0d 80 2d 12 80    	mov    %ecx,0x80122d80
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801039f6:	88 97 00 28 12 80    	mov    %dl,-0x7fedd800(%edi)
      p += sizeof(struct mpproc);
801039fc:	83 c0 14             	add    $0x14,%eax
      continue;
801039ff:	e9 7c ff ff ff       	jmp    80103980 <mpinit+0xf0>
80103a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103a08:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
80103a0c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103a0f:	88 15 e0 27 12 80    	mov    %dl,0x801227e0
      continue;
80103a15:	e9 66 ff ff ff       	jmp    80103980 <mpinit+0xf0>
80103a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103a20:	ba 00 00 01 00       	mov    $0x10000,%edx
80103a25:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103a2a:	e8 e1 fd ff ff       	call   80103810 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103a2f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103a31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103a34:	0f 85 a9 fe ff ff    	jne    801038e3 <mpinit+0x53>
80103a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103a40:	83 ec 0c             	sub    $0xc,%esp
80103a43:	68 5d 8e 10 80       	push   $0x80108e5d
80103a48:	e8 43 c9 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103a4d:	83 ec 0c             	sub    $0xc,%esp
80103a50:	68 7c 8e 10 80       	push   $0x80108e7c
80103a55:	e8 36 c9 ff ff       	call   80100390 <panic>
      ismp = 0;
80103a5a:	31 db                	xor    %ebx,%ebx
80103a5c:	e9 26 ff ff ff       	jmp    80103987 <mpinit+0xf7>
80103a61:	66 90                	xchg   %ax,%ax
80103a63:	66 90                	xchg   %ax,%ax
80103a65:	66 90                	xchg   %ax,%ax
80103a67:	66 90                	xchg   %ax,%ax
80103a69:	66 90                	xchg   %ax,%ax
80103a6b:	66 90                	xchg   %ax,%ax
80103a6d:	66 90                	xchg   %ax,%ax
80103a6f:	90                   	nop

80103a70 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103a70:	55                   	push   %ebp
80103a71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a76:	ba 21 00 00 00       	mov    $0x21,%edx
80103a7b:	89 e5                	mov    %esp,%ebp
80103a7d:	ee                   	out    %al,(%dx)
80103a7e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103a83:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103a84:	5d                   	pop    %ebp
80103a85:	c3                   	ret    
80103a86:	66 90                	xchg   %ax,%ax
80103a88:	66 90                	xchg   %ax,%ax
80103a8a:	66 90                	xchg   %ax,%ax
80103a8c:	66 90                	xchg   %ax,%ax
80103a8e:	66 90                	xchg   %ax,%ax

80103a90 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	57                   	push   %edi
80103a94:	56                   	push   %esi
80103a95:	53                   	push   %ebx
80103a96:	83 ec 0c             	sub    $0xc,%esp
80103a99:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103a9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103a9f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103aa5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103aab:	e8 10 d7 ff ff       	call   801011c0 <filealloc>
80103ab0:	85 c0                	test   %eax,%eax
80103ab2:	89 03                	mov    %eax,(%ebx)
80103ab4:	74 22                	je     80103ad8 <pipealloc+0x48>
80103ab6:	e8 05 d7 ff ff       	call   801011c0 <filealloc>
80103abb:	85 c0                	test   %eax,%eax
80103abd:	89 06                	mov    %eax,(%esi)
80103abf:	74 3f                	je     80103b00 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)cow_kalloc()) == 0)
80103ac1:	e8 da 38 00 00       	call   801073a0 <cow_kalloc>
80103ac6:	85 c0                	test   %eax,%eax
80103ac8:	89 c7                	mov    %eax,%edi
80103aca:	75 54                	jne    80103b20 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    cow_kfree((char*)p);
  if(*f0)
80103acc:	8b 03                	mov    (%ebx),%eax
80103ace:	85 c0                	test   %eax,%eax
80103ad0:	75 34                	jne    80103b06 <pipealloc+0x76>
80103ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103ad8:	8b 06                	mov    (%esi),%eax
80103ada:	85 c0                	test   %eax,%eax
80103adc:	74 0c                	je     80103aea <pipealloc+0x5a>
    fileclose(*f1);
80103ade:	83 ec 0c             	sub    $0xc,%esp
80103ae1:	50                   	push   %eax
80103ae2:	e8 99 d7 ff ff       	call   80101280 <fileclose>
80103ae7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103aea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103aed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103af2:	5b                   	pop    %ebx
80103af3:	5e                   	pop    %esi
80103af4:	5f                   	pop    %edi
80103af5:	5d                   	pop    %ebp
80103af6:	c3                   	ret    
80103af7:	89 f6                	mov    %esi,%esi
80103af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103b00:	8b 03                	mov    (%ebx),%eax
80103b02:	85 c0                	test   %eax,%eax
80103b04:	74 e4                	je     80103aea <pipealloc+0x5a>
    fileclose(*f0);
80103b06:	83 ec 0c             	sub    $0xc,%esp
80103b09:	50                   	push   %eax
80103b0a:	e8 71 d7 ff ff       	call   80101280 <fileclose>
  if(*f1)
80103b0f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103b11:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103b14:	85 c0                	test   %eax,%eax
80103b16:	75 c6                	jne    80103ade <pipealloc+0x4e>
80103b18:	eb d0                	jmp    80103aea <pipealloc+0x5a>
80103b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103b20:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103b23:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103b2a:	00 00 00 
  p->writeopen = 1;
80103b2d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103b34:	00 00 00 
  p->nwrite = 0;
80103b37:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103b3e:	00 00 00 
  p->nread = 0;
80103b41:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103b48:	00 00 00 
  initlock(&p->lock, "pipe");
80103b4b:	68 b0 8e 10 80       	push   $0x80108eb0
80103b50:	50                   	push   %eax
80103b51:	e8 ca 12 00 00       	call   80104e20 <initlock>
  (*f0)->type = FD_PIPE;
80103b56:	8b 03                	mov    (%ebx),%eax
  return 0;
80103b58:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103b5b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103b61:	8b 03                	mov    (%ebx),%eax
80103b63:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103b67:	8b 03                	mov    (%ebx),%eax
80103b69:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103b6d:	8b 03                	mov    (%ebx),%eax
80103b6f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103b72:	8b 06                	mov    (%esi),%eax
80103b74:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103b7a:	8b 06                	mov    (%esi),%eax
80103b7c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103b80:	8b 06                	mov    (%esi),%eax
80103b82:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103b86:	8b 06                	mov    (%esi),%eax
80103b88:	89 78 0c             	mov    %edi,0xc(%eax)
}
80103b8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103b8e:	31 c0                	xor    %eax,%eax
}
80103b90:	5b                   	pop    %ebx
80103b91:	5e                   	pop    %esi
80103b92:	5f                   	pop    %edi
80103b93:	5d                   	pop    %ebp
80103b94:	c3                   	ret    
80103b95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ba0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	56                   	push   %esi
80103ba4:	53                   	push   %ebx
80103ba5:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103ba8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103bab:	83 ec 0c             	sub    $0xc,%esp
80103bae:	53                   	push   %ebx
80103baf:	e8 ac 13 00 00       	call   80104f60 <acquire>
  if(writable){
80103bb4:	83 c4 10             	add    $0x10,%esp
80103bb7:	85 f6                	test   %esi,%esi
80103bb9:	74 45                	je     80103c00 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103bbb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103bc1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103bc4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103bcb:	00 00 00 
    wakeup(&p->nread);
80103bce:	50                   	push   %eax
80103bcf:	e8 1c 0f 00 00       	call   80104af0 <wakeup>
80103bd4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103bd7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103bdd:	85 d2                	test   %edx,%edx
80103bdf:	75 0a                	jne    80103beb <pipeclose+0x4b>
80103be1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103be7:	85 c0                	test   %eax,%eax
80103be9:	74 35                	je     80103c20 <pipeclose+0x80>
    release(&p->lock);
    cow_kfree((char*)p);
  } else
    release(&p->lock);
80103beb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103bee:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bf1:	5b                   	pop    %ebx
80103bf2:	5e                   	pop    %esi
80103bf3:	5d                   	pop    %ebp
    release(&p->lock);
80103bf4:	e9 27 14 00 00       	jmp    80105020 <release>
80103bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103c00:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103c06:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103c09:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103c10:	00 00 00 
    wakeup(&p->nwrite);
80103c13:	50                   	push   %eax
80103c14:	e8 d7 0e 00 00       	call   80104af0 <wakeup>
80103c19:	83 c4 10             	add    $0x10,%esp
80103c1c:	eb b9                	jmp    80103bd7 <pipeclose+0x37>
80103c1e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103c20:	83 ec 0c             	sub    $0xc,%esp
80103c23:	53                   	push   %ebx
80103c24:	e8 f7 13 00 00       	call   80105020 <release>
    cow_kfree((char*)p);
80103c29:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103c2c:	83 c4 10             	add    $0x10,%esp
}
80103c2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c32:	5b                   	pop    %ebx
80103c33:	5e                   	pop    %esi
80103c34:	5d                   	pop    %ebp
    cow_kfree((char*)p);
80103c35:	e9 d6 36 00 00       	jmp    80107310 <cow_kfree>
80103c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c40 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	57                   	push   %edi
80103c44:	56                   	push   %esi
80103c45:	53                   	push   %ebx
80103c46:	83 ec 28             	sub    $0x28,%esp
80103c49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103c4c:	53                   	push   %ebx
80103c4d:	e8 0e 13 00 00       	call   80104f60 <acquire>
  for(i = 0; i < n; i++){
80103c52:	8b 45 10             	mov    0x10(%ebp),%eax
80103c55:	83 c4 10             	add    $0x10,%esp
80103c58:	85 c0                	test   %eax,%eax
80103c5a:	0f 8e c9 00 00 00    	jle    80103d29 <pipewrite+0xe9>
80103c60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103c63:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103c69:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103c6f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103c72:	03 4d 10             	add    0x10(%ebp),%ecx
80103c75:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c78:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103c7e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103c84:	39 d0                	cmp    %edx,%eax
80103c86:	75 71                	jne    80103cf9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103c88:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103c8e:	85 c0                	test   %eax,%eax
80103c90:	74 4e                	je     80103ce0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103c92:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103c98:	eb 3a                	jmp    80103cd4 <pipewrite+0x94>
80103c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103ca0:	83 ec 0c             	sub    $0xc,%esp
80103ca3:	57                   	push   %edi
80103ca4:	e8 47 0e 00 00       	call   80104af0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ca9:	5a                   	pop    %edx
80103caa:	59                   	pop    %ecx
80103cab:	53                   	push   %ebx
80103cac:	56                   	push   %esi
80103cad:	e8 ee 0b 00 00       	call   801048a0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103cb2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103cb8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103cbe:	83 c4 10             	add    $0x10,%esp
80103cc1:	05 00 02 00 00       	add    $0x200,%eax
80103cc6:	39 c2                	cmp    %eax,%edx
80103cc8:	75 36                	jne    80103d00 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103cca:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103cd0:	85 c0                	test   %eax,%eax
80103cd2:	74 0c                	je     80103ce0 <pipewrite+0xa0>
80103cd4:	e8 f7 03 00 00       	call   801040d0 <myproc>
80103cd9:	8b 40 24             	mov    0x24(%eax),%eax
80103cdc:	85 c0                	test   %eax,%eax
80103cde:	74 c0                	je     80103ca0 <pipewrite+0x60>
        release(&p->lock);
80103ce0:	83 ec 0c             	sub    $0xc,%esp
80103ce3:	53                   	push   %ebx
80103ce4:	e8 37 13 00 00       	call   80105020 <release>
        return -1;
80103ce9:	83 c4 10             	add    $0x10,%esp
80103cec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103cf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cf4:	5b                   	pop    %ebx
80103cf5:	5e                   	pop    %esi
80103cf6:	5f                   	pop    %edi
80103cf7:	5d                   	pop    %ebp
80103cf8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103cf9:	89 c2                	mov    %eax,%edx
80103cfb:	90                   	nop
80103cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103d00:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103d03:	8d 42 01             	lea    0x1(%edx),%eax
80103d06:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103d0c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103d12:	83 c6 01             	add    $0x1,%esi
80103d15:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103d19:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103d1c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103d1f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103d23:	0f 85 4f ff ff ff    	jne    80103c78 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103d29:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103d2f:	83 ec 0c             	sub    $0xc,%esp
80103d32:	50                   	push   %eax
80103d33:	e8 b8 0d 00 00       	call   80104af0 <wakeup>
  release(&p->lock);
80103d38:	89 1c 24             	mov    %ebx,(%esp)
80103d3b:	e8 e0 12 00 00       	call   80105020 <release>
  return n;
80103d40:	83 c4 10             	add    $0x10,%esp
80103d43:	8b 45 10             	mov    0x10(%ebp),%eax
80103d46:	eb a9                	jmp    80103cf1 <pipewrite+0xb1>
80103d48:	90                   	nop
80103d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d50 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103d50:	55                   	push   %ebp
80103d51:	89 e5                	mov    %esp,%ebp
80103d53:	57                   	push   %edi
80103d54:	56                   	push   %esi
80103d55:	53                   	push   %ebx
80103d56:	83 ec 18             	sub    $0x18,%esp
80103d59:	8b 75 08             	mov    0x8(%ebp),%esi
80103d5c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103d5f:	56                   	push   %esi
80103d60:	e8 fb 11 00 00       	call   80104f60 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103d65:	83 c4 10             	add    $0x10,%esp
80103d68:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103d6e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103d74:	75 6a                	jne    80103de0 <piperead+0x90>
80103d76:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
80103d7c:	85 db                	test   %ebx,%ebx
80103d7e:	0f 84 c4 00 00 00    	je     80103e48 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103d84:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103d8a:	eb 2d                	jmp    80103db9 <piperead+0x69>
80103d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d90:	83 ec 08             	sub    $0x8,%esp
80103d93:	56                   	push   %esi
80103d94:	53                   	push   %ebx
80103d95:	e8 06 0b 00 00       	call   801048a0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103d9a:	83 c4 10             	add    $0x10,%esp
80103d9d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103da3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103da9:	75 35                	jne    80103de0 <piperead+0x90>
80103dab:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103db1:	85 d2                	test   %edx,%edx
80103db3:	0f 84 8f 00 00 00    	je     80103e48 <piperead+0xf8>
    if(myproc()->killed){
80103db9:	e8 12 03 00 00       	call   801040d0 <myproc>
80103dbe:	8b 48 24             	mov    0x24(%eax),%ecx
80103dc1:	85 c9                	test   %ecx,%ecx
80103dc3:	74 cb                	je     80103d90 <piperead+0x40>
      release(&p->lock);
80103dc5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103dc8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103dcd:	56                   	push   %esi
80103dce:	e8 4d 12 00 00       	call   80105020 <release>
      return -1;
80103dd3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dd9:	89 d8                	mov    %ebx,%eax
80103ddb:	5b                   	pop    %ebx
80103ddc:	5e                   	pop    %esi
80103ddd:	5f                   	pop    %edi
80103dde:	5d                   	pop    %ebp
80103ddf:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103de0:	8b 45 10             	mov    0x10(%ebp),%eax
80103de3:	85 c0                	test   %eax,%eax
80103de5:	7e 61                	jle    80103e48 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103de7:	31 db                	xor    %ebx,%ebx
80103de9:	eb 13                	jmp    80103dfe <piperead+0xae>
80103deb:	90                   	nop
80103dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103df0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103df6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103dfc:	74 1f                	je     80103e1d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103dfe:	8d 41 01             	lea    0x1(%ecx),%eax
80103e01:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103e07:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103e0d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103e12:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103e15:	83 c3 01             	add    $0x1,%ebx
80103e18:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103e1b:	75 d3                	jne    80103df0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103e1d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103e23:	83 ec 0c             	sub    $0xc,%esp
80103e26:	50                   	push   %eax
80103e27:	e8 c4 0c 00 00       	call   80104af0 <wakeup>
  release(&p->lock);
80103e2c:	89 34 24             	mov    %esi,(%esp)
80103e2f:	e8 ec 11 00 00       	call   80105020 <release>
  return i;
80103e34:	83 c4 10             	add    $0x10,%esp
}
80103e37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e3a:	89 d8                	mov    %ebx,%eax
80103e3c:	5b                   	pop    %ebx
80103e3d:	5e                   	pop    %esi
80103e3e:	5f                   	pop    %edi
80103e3f:	5d                   	pop    %ebp
80103e40:	c3                   	ret    
80103e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e48:	31 db                	xor    %ebx,%ebx
80103e4a:	eb d1                	jmp    80103e1d <piperead+0xcd>
80103e4c:	66 90                	xchg   %ax,%ax
80103e4e:	66 90                	xchg   %ax,%ax

80103e50 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e54:	bb d4 2d 12 80       	mov    $0x80122dd4,%ebx
{
80103e59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103e5c:	68 a0 2d 12 80       	push   $0x80122da0
80103e61:	e8 fa 10 00 00       	call   80104f60 <acquire>
80103e66:	83 c4 10             	add    $0x10,%esp
80103e69:	eb 17                	jmp    80103e82 <allocproc+0x32>
80103e6b:	90                   	nop
80103e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e70:	81 c3 d0 03 00 00    	add    $0x3d0,%ebx
80103e76:	81 fb d4 21 13 80    	cmp    $0x801321d4,%ebx
80103e7c:	0f 83 fe 00 00 00    	jae    80103f80 <allocproc+0x130>
    if(p->state == UNUSED)
80103e82:	8b 43 0c             	mov    0xc(%ebx),%eax
80103e85:	85 c0                	test   %eax,%eax
80103e87:	75 e7                	jne    80103e70 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103e89:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
80103e8e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103e91:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103e98:	8d 50 01             	lea    0x1(%eax),%edx
80103e9b:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103e9e:	68 a0 2d 12 80       	push   $0x80122da0
  p->pid = nextpid++;
80103ea3:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80103ea9:	e8 72 11 00 00       	call   80105020 <release>

  // Allocate kernel stack.
  if((p->kstack = cow_kalloc()) == 0){
80103eae:	e8 ed 34 00 00       	call   801073a0 <cow_kalloc>
80103eb3:	83 c4 10             	add    $0x10,%esp
80103eb6:	85 c0                	test   %eax,%eax
80103eb8:	89 43 08             	mov    %eax,0x8(%ebx)
80103ebb:	0f 84 d8 00 00 00    	je     80103f99 <allocproc+0x149>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103ec1:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103ec7:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103eca:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103ecf:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103ed2:	c7 40 14 b1 62 10 80 	movl   $0x801062b1,0x14(%eax)
  p->context = (struct context*)sp;
80103ed9:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103edc:	6a 14                	push   $0x14
80103ede:	6a 00                	push   $0x0
80103ee0:	50                   	push   %eax
80103ee1:	e8 8a 11 00 00       	call   80105070 <memset>
  p->context->eip = (uint)forkret;
80103ee6:	8b 43 1c             	mov    0x1c(%ebx),%eax

 if (p->pid > 2){
80103ee9:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103eec:	c7 40 10 b0 3f 10 80 	movl   $0x80103fb0,0x10(%eax)
 if (p->pid > 2){
80103ef3:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80103ef7:	7f 07                	jg     80103f00 <allocproc+0xb0>
      p->advance_queue[i] = -1;
      #endif
    }
 }
  return p;
}
80103ef9:	89 d8                	mov    %ebx,%eax
80103efb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103efe:	c9                   	leave  
80103eff:	c3                   	ret    
    createSwapFile(p);
80103f00:	83 ec 0c             	sub    $0xc,%esp
    p->num_of_actual_pages_in_mem = 0;
80103f03:	c7 83 c4 03 00 00 00 	movl   $0x0,0x3c4(%ebx)
80103f0a:	00 00 00 
    p->num_of_pagefaults_occurs = 0;
80103f0d:	c7 83 c8 03 00 00 00 	movl   $0x0,0x3c8(%ebx)
80103f14:	00 00 00 
    p->num_of_pageOut_occured = 0;
80103f17:	c7 83 cc 03 00 00 00 	movl   $0x0,0x3cc(%ebx)
80103f1e:	00 00 00 
    p->num_of_pages_in_swap_file = 0;
80103f21:	c7 83 c0 03 00 00 00 	movl   $0x0,0x3c0(%ebx)
80103f28:	00 00 00 
    createSwapFile(p);
80103f2b:	53                   	push   %ebx
80103f2c:	e8 bf e6 ff ff       	call   801025f0 <createSwapFile>
80103f31:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80103f37:	8d 93 80 03 00 00    	lea    0x380(%ebx),%edx
80103f3d:	8d 8b 00 02 00 00    	lea    0x200(%ebx),%ecx
80103f43:	83 c4 10             	add    $0x10,%esp
80103f46:	8d 76 00             	lea    0x0(%esi),%esi
80103f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
80103f50:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80103f56:	c7 80 80 01 00 00 01 	movl   $0x1,0x180(%eax)
80103f5d:	00 00 00 
80103f60:	83 c0 18             	add    $0x18,%eax
      p->advance_queue[i] = -1;
80103f63:	c7 02 ff ff ff ff    	movl   $0xffffffff,(%edx)
80103f69:	83 c2 04             	add    $0x4,%edx
    for (int i = 0; i < 16; i++){
80103f6c:	39 c8                	cmp    %ecx,%eax
80103f6e:	75 e0                	jne    80103f50 <allocproc+0x100>
}
80103f70:	89 d8                	mov    %ebx,%eax
80103f72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f75:	c9                   	leave  
80103f76:	c3                   	ret    
80103f77:	89 f6                	mov    %esi,%esi
80103f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&ptable.lock);
80103f80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103f83:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103f85:	68 a0 2d 12 80       	push   $0x80122da0
80103f8a:	e8 91 10 00 00       	call   80105020 <release>
}
80103f8f:	89 d8                	mov    %ebx,%eax
  return 0;
80103f91:	83 c4 10             	add    $0x10,%esp
}
80103f94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f97:	c9                   	leave  
80103f98:	c3                   	ret    
    p->state = UNUSED;
80103f99:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103fa0:	31 db                	xor    %ebx,%ebx
80103fa2:	e9 52 ff ff ff       	jmp    80103ef9 <allocproc+0xa9>
80103fa7:	89 f6                	mov    %esi,%esi
80103fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fb0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103fb6:	68 a0 2d 12 80       	push   $0x80122da0
80103fbb:	e8 60 10 00 00       	call   80105020 <release>

  if (first) {
80103fc0:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80103fc5:	83 c4 10             	add    $0x10,%esp
80103fc8:	85 c0                	test   %eax,%eax
80103fca:	75 04                	jne    80103fd0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103fcc:	c9                   	leave  
80103fcd:	c3                   	ret    
80103fce:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103fd0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103fd3:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80103fda:	00 00 00 
    iinit(ROOTDEV);
80103fdd:	6a 01                	push   $0x1
80103fdf:	e8 dc d8 ff ff       	call   801018c0 <iinit>
    initlog(ROOTDEV);
80103fe4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103feb:	e8 60 f3 ff ff       	call   80103350 <initlog>
80103ff0:	83 c4 10             	add    $0x10,%esp
}
80103ff3:	c9                   	leave  
80103ff4:	c3                   	ret    
80103ff5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104000 <pinit>:
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80104006:	68 b5 8e 10 80       	push   $0x80108eb5
8010400b:	68 a0 2d 12 80       	push   $0x80122da0
80104010:	e8 0b 0e 00 00       	call   80104e20 <initlock>
}
80104015:	83 c4 10             	add    $0x10,%esp
80104018:	c9                   	leave  
80104019:	c3                   	ret    
8010401a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104020 <mycpu>:
{
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	56                   	push   %esi
80104024:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104025:	9c                   	pushf  
80104026:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104027:	f6 c4 02             	test   $0x2,%ah
8010402a:	75 6b                	jne    80104097 <mycpu+0x77>
  apicid = lapicid();
8010402c:	e8 4f ef ff ff       	call   80102f80 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104031:	8b 35 80 2d 12 80    	mov    0x80122d80,%esi
80104037:	85 f6                	test   %esi,%esi
80104039:	7e 42                	jle    8010407d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010403b:	0f b6 15 00 28 12 80 	movzbl 0x80122800,%edx
80104042:	39 d0                	cmp    %edx,%eax
80104044:	74 30                	je     80104076 <mycpu+0x56>
80104046:	b9 b0 28 12 80       	mov    $0x801228b0,%ecx
  for (i = 0; i < ncpu; ++i) {
8010404b:	31 d2                	xor    %edx,%edx
8010404d:	8d 76 00             	lea    0x0(%esi),%esi
80104050:	83 c2 01             	add    $0x1,%edx
80104053:	39 f2                	cmp    %esi,%edx
80104055:	74 26                	je     8010407d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80104057:	0f b6 19             	movzbl (%ecx),%ebx
8010405a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80104060:	39 c3                	cmp    %eax,%ebx
80104062:	75 ec                	jne    80104050 <mycpu+0x30>
80104064:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010406a:	05 00 28 12 80       	add    $0x80122800,%eax
}
8010406f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104072:	5b                   	pop    %ebx
80104073:	5e                   	pop    %esi
80104074:	5d                   	pop    %ebp
80104075:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80104076:	b8 00 28 12 80       	mov    $0x80122800,%eax
      return &cpus[i];
8010407b:	eb f2                	jmp    8010406f <mycpu+0x4f>
  cprintf("The unknown apicid is %d\n", apicid);
8010407d:	83 ec 08             	sub    $0x8,%esp
80104080:	50                   	push   %eax
80104081:	68 bc 8e 10 80       	push   $0x80108ebc
80104086:	e8 d5 c5 ff ff       	call   80100660 <cprintf>
  panic("unknown apicid\n");
8010408b:	c7 04 24 d6 8e 10 80 	movl   $0x80108ed6,(%esp)
80104092:	e8 f9 c2 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80104097:	83 ec 0c             	sub    $0xc,%esp
8010409a:	68 a8 8f 10 80       	push   $0x80108fa8
8010409f:	e8 ec c2 ff ff       	call   80100390 <panic>
801040a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801040aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801040b0 <cpuid>:
cpuid() {
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801040b6:	e8 65 ff ff ff       	call   80104020 <mycpu>
801040bb:	2d 00 28 12 80       	sub    $0x80122800,%eax
}
801040c0:	c9                   	leave  
  return mycpu()-cpus;
801040c1:	c1 f8 04             	sar    $0x4,%eax
801040c4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801040ca:	c3                   	ret    
801040cb:	90                   	nop
801040cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801040d0 <myproc>:
myproc(void) {
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	53                   	push   %ebx
801040d4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801040d7:	e8 b4 0d 00 00       	call   80104e90 <pushcli>
  c = mycpu();
801040dc:	e8 3f ff ff ff       	call   80104020 <mycpu>
  p = c->proc;
801040e1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040e7:	e8 e4 0d 00 00       	call   80104ed0 <popcli>
}
801040ec:	83 c4 04             	add    $0x4,%esp
801040ef:	89 d8                	mov    %ebx,%eax
801040f1:	5b                   	pop    %ebx
801040f2:	5d                   	pop    %ebp
801040f3:	c3                   	ret    
801040f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801040fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104100 <userinit>:
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	53                   	push   %ebx
80104104:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80104107:	e8 44 fd ff ff       	call   80103e50 <allocproc>
8010410c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010410e:	a3 b8 c5 10 80       	mov    %eax,0x8010c5b8
  if((p->pgdir = setupkvm()) == 0)
80104113:	e8 68 3d 00 00       	call   80107e80 <setupkvm>
80104118:	85 c0                	test   %eax,%eax
8010411a:	89 43 04             	mov    %eax,0x4(%ebx)
8010411d:	0f 84 bd 00 00 00    	je     801041e0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104123:	83 ec 04             	sub    $0x4,%esp
80104126:	68 2c 00 00 00       	push   $0x2c
8010412b:	68 60 c4 10 80       	push   $0x8010c460
80104130:	50                   	push   %eax
80104131:	e8 6a 39 00 00       	call   80107aa0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104136:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104139:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010413f:	6a 4c                	push   $0x4c
80104141:	6a 00                	push   $0x0
80104143:	ff 73 18             	pushl  0x18(%ebx)
80104146:	e8 25 0f 00 00       	call   80105070 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010414b:	8b 43 18             	mov    0x18(%ebx),%eax
8010414e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104153:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104158:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010415b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010415f:	8b 43 18             	mov    0x18(%ebx),%eax
80104162:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104166:	8b 43 18             	mov    0x18(%ebx),%eax
80104169:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010416d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104171:	8b 43 18             	mov    0x18(%ebx),%eax
80104174:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104178:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010417c:	8b 43 18             	mov    0x18(%ebx),%eax
8010417f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104186:	8b 43 18             	mov    0x18(%ebx),%eax
80104189:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104190:	8b 43 18             	mov    0x18(%ebx),%eax
80104193:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010419a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010419d:	6a 10                	push   $0x10
8010419f:	68 ff 8e 10 80       	push   $0x80108eff
801041a4:	50                   	push   %eax
801041a5:	e8 a6 10 00 00       	call   80105250 <safestrcpy>
  p->cwd = namei("/");
801041aa:	c7 04 24 08 8f 10 80 	movl   $0x80108f08,(%esp)
801041b1:	e8 6a e1 ff ff       	call   80102320 <namei>
801041b6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801041b9:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
801041c0:	e8 9b 0d 00 00       	call   80104f60 <acquire>
  p->state = RUNNABLE;
801041c5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801041cc:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
801041d3:	e8 48 0e 00 00       	call   80105020 <release>
}
801041d8:	83 c4 10             	add    $0x10,%esp
801041db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041de:	c9                   	leave  
801041df:	c3                   	ret    
    panic("userinit: out of memory?");
801041e0:	83 ec 0c             	sub    $0xc,%esp
801041e3:	68 e6 8e 10 80       	push   $0x80108ee6
801041e8:	e8 a3 c1 ff ff       	call   80100390 <panic>
801041ed:	8d 76 00             	lea    0x0(%esi),%esi

801041f0 <growproc>:
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	56                   	push   %esi
801041f4:	53                   	push   %ebx
801041f5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801041f8:	e8 93 0c 00 00       	call   80104e90 <pushcli>
  c = mycpu();
801041fd:	e8 1e fe ff ff       	call   80104020 <mycpu>
  p = c->proc;
80104202:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104208:	e8 c3 0c 00 00       	call   80104ed0 <popcli>
  if(n > 0){
8010420d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80104210:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104212:	7f 1c                	jg     80104230 <growproc+0x40>
  } else if(n < 0){
80104214:	75 3a                	jne    80104250 <growproc+0x60>
  switchuvm(curproc);
80104216:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80104219:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010421b:	53                   	push   %ebx
8010421c:	e8 6f 37 00 00       	call   80107990 <switchuvm>
  return 0;
80104221:	83 c4 10             	add    $0x10,%esp
80104224:	31 c0                	xor    %eax,%eax
}
80104226:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104229:	5b                   	pop    %ebx
8010422a:	5e                   	pop    %esi
8010422b:	5d                   	pop    %ebp
8010422c:	c3                   	ret    
8010422d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104230:	83 ec 04             	sub    $0x4,%esp
80104233:	01 c6                	add    %eax,%esi
80104235:	56                   	push   %esi
80104236:	50                   	push   %eax
80104237:	ff 73 04             	pushl  0x4(%ebx)
8010423a:	e8 71 41 00 00       	call   801083b0 <allocuvm>
8010423f:	83 c4 10             	add    $0x10,%esp
80104242:	85 c0                	test   %eax,%eax
80104244:	75 d0                	jne    80104216 <growproc+0x26>
      return -1;
80104246:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010424b:	eb d9                	jmp    80104226 <growproc+0x36>
8010424d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104250:	83 ec 04             	sub    $0x4,%esp
80104253:	01 c6                	add    %eax,%esi
80104255:	56                   	push   %esi
80104256:	50                   	push   %eax
80104257:	ff 73 04             	pushl  0x4(%ebx)
8010425a:	e8 81 39 00 00       	call   80107be0 <deallocuvm>
8010425f:	83 c4 10             	add    $0x10,%esp
80104262:	85 c0                	test   %eax,%eax
80104264:	75 b0                	jne    80104216 <growproc+0x26>
80104266:	eb de                	jmp    80104246 <growproc+0x56>
80104268:	90                   	nop
80104269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104270 <sys_get_number_of_free_pages_impl>:
int sys_get_number_of_free_pages_impl(void){
80104270:	55                   	push   %ebp
  for (int i = 0; i < PHYSTOP / PGSIZE; i++){
80104271:	31 c0                	xor    %eax,%eax
  int count = 0;
80104273:	31 d2                	xor    %edx,%edx
int sys_get_number_of_free_pages_impl(void){
80104275:	89 e5                	mov    %esp,%ebp
80104277:	89 f6                	mov    %esi,%esi
80104279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      count++;
80104280:	80 b8 40 1f 11 80 01 	cmpb   $0x1,-0x7feee0c0(%eax)
80104287:	83 da ff             	sbb    $0xffffffff,%edx
  for (int i = 0; i < PHYSTOP / PGSIZE; i++){
8010428a:	83 c0 01             	add    $0x1,%eax
8010428d:	3d 00 e0 00 00       	cmp    $0xe000,%eax
80104292:	75 ec                	jne    80104280 <sys_get_number_of_free_pages_impl+0x10>
  return (PHYSTOP/PGSIZE) - count;
80104294:	29 d0                	sub    %edx,%eax
}
80104296:	5d                   	pop    %ebp
80104297:	c3                   	ret    
80104298:	90                   	nop
80104299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042a0 <fork>:
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	57                   	push   %edi
801042a4:	56                   	push   %esi
801042a5:	53                   	push   %ebx
801042a6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801042a9:	e8 e2 0b 00 00       	call   80104e90 <pushcli>
  c = mycpu();
801042ae:	e8 6d fd ff ff       	call   80104020 <mycpu>
  p = c->proc;
801042b3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042b9:	e8 12 0c 00 00       	call   80104ed0 <popcli>
  if((np = allocproc()) == 0){
801042be:	e8 8d fb ff ff       	call   80103e50 <allocproc>
801042c3:	85 c0                	test   %eax,%eax
801042c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801042c8:	0f 84 40 02 00 00    	je     8010450e <fork+0x26e>
  if((np->pgdir = cow_copyuvm(curproc->pgdir, curproc->sz)) == 0){ // (np->pid > 2 ? cow_copyuvm : copyuvm)
801042ce:	83 ec 08             	sub    $0x8,%esp
801042d1:	ff 33                	pushl  (%ebx)
801042d3:	ff 73 04             	pushl  0x4(%ebx)
801042d6:	e8 75 3c 00 00       	call   80107f50 <cow_copyuvm>
801042db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801042de:	83 c4 10             	add    $0x10,%esp
801042e1:	85 c0                	test   %eax,%eax
801042e3:	89 42 04             	mov    %eax,0x4(%edx)
801042e6:	0f 84 2e 02 00 00    	je     8010451a <fork+0x27a>
  np->sz = curproc->sz;
801042ec:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
801042ee:	8b 7a 18             	mov    0x18(%edx),%edi
801042f1:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->parent = curproc;
801042f6:	89 5a 14             	mov    %ebx,0x14(%edx)
  np->sz = curproc->sz;
801042f9:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
801042fb:	8b 73 18             	mov    0x18(%ebx),%esi
801042fe:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104300:	31 f6                	xor    %esi,%esi
80104302:	89 d7                	mov    %edx,%edi
  np->tf->eax = 0;
80104304:	8b 42 18             	mov    0x18(%edx),%eax
80104307:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
8010430e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[i])
80104310:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104314:	85 c0                	test   %eax,%eax
80104316:	74 10                	je     80104328 <fork+0x88>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104318:	83 ec 0c             	sub    $0xc,%esp
8010431b:	50                   	push   %eax
8010431c:	e8 0f cf ff ff       	call   80101230 <filedup>
80104321:	83 c4 10             	add    $0x10,%esp
80104324:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104328:	83 c6 01             	add    $0x1,%esi
8010432b:	83 fe 10             	cmp    $0x10,%esi
8010432e:	75 e0                	jne    80104310 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104330:	83 ec 0c             	sub    $0xc,%esp
80104333:	ff 73 68             	pushl  0x68(%ebx)
80104336:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80104339:	e8 52 d7 ff ff       	call   80101a90 <idup>
8010433e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104341:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104344:	89 42 68             	mov    %eax,0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104347:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010434a:	6a 10                	push   $0x10
8010434c:	50                   	push   %eax
8010434d:	8d 42 6c             	lea    0x6c(%edx),%eax
80104350:	50                   	push   %eax
80104351:	e8 fa 0e 00 00       	call   80105250 <safestrcpy>
  pid = np->pid;
80104356:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  if (curproc->pid > 2 && np->pid > 2){
80104359:	83 c4 10             	add    $0x10,%esp
8010435c:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
  pid = np->pid;
80104360:	8b 42 10             	mov    0x10(%edx),%eax
80104363:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (curproc->pid > 2 && np->pid > 2){
80104366:	7e 05                	jle    8010436d <fork+0xcd>
80104368:	83 f8 02             	cmp    $0x2,%eax
8010436b:	7f 3b                	jg     801043a8 <fork+0x108>
  acquire(&ptable.lock);
8010436d:	83 ec 0c             	sub    $0xc,%esp
80104370:	89 55 e0             	mov    %edx,-0x20(%ebp)
80104373:	68 a0 2d 12 80       	push   $0x80122da0
80104378:	e8 e3 0b 00 00       	call   80104f60 <acquire>
  np->state = RUNNABLE;
8010437d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104380:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  release(&ptable.lock);
80104387:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
8010438e:	e8 8d 0c 00 00       	call   80105020 <release>
  return pid;
80104393:	83 c4 10             	add    $0x10,%esp
}
80104396:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104399:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010439c:	5b                   	pop    %ebx
8010439d:	5e                   	pop    %esi
8010439e:	5f                   	pop    %edi
8010439f:	5d                   	pop    %ebp
801043a0:	c3                   	ret    
801043a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043a8:	8d 83 e8 01 00 00    	lea    0x1e8(%ebx),%eax
    int last_not_free_in_file = MAX_PYSC_PAGES - 1;
801043ae:	b9 0f 00 00 00       	mov    $0xf,%ecx
801043b3:	eb 12                	jmp    801043c7 <fork+0x127>
801043b5:	8d 76 00             	lea    0x0(%esi),%esi
    while (last_not_free_in_file >= 0 && curproc->swapped_out_pages[last_not_free_in_file].is_free){ last_not_free_in_file--; }
801043b8:	83 e9 01             	sub    $0x1,%ecx
801043bb:	83 e8 18             	sub    $0x18,%eax
801043be:	83 f9 ff             	cmp    $0xffffffff,%ecx
801043c1:	0f 84 35 01 00 00    	je     801044fc <fork+0x25c>
801043c7:	8b 30                	mov    (%eax),%esi
801043c9:	85 f6                	test   %esi,%esi
801043cb:	75 eb                	jne    801043b8 <fork+0x118>
801043cd:	89 55 d8             	mov    %edx,-0x28(%ebp)
801043d0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    void* pg_buffer = cow_kalloc();
801043d3:	e8 c8 2f 00 00       	call   801073a0 <cow_kalloc>
801043d8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801043db:	8b 55 d8             	mov    -0x28(%ebp),%edx
801043de:	89 c7                	mov    %eax,%edi
801043e0:	89 5d e0             	mov    %ebx,-0x20(%ebp)
801043e3:	89 f3                	mov    %esi,%ebx
801043e5:	c1 e1 0c             	shl    $0xc,%ecx
801043e8:	89 d6                	mov    %edx,%esi
801043ea:	8d 81 00 10 00 00    	lea    0x1000(%ecx),%eax
801043f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
801043f3:	90                   	nop
801043f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      readFromSwapFile(curproc, pg_buffer, i, PGSIZE);
801043f8:	68 00 10 00 00       	push   $0x1000
801043fd:	53                   	push   %ebx
801043fe:	57                   	push   %edi
801043ff:	ff 75 e0             	pushl  -0x20(%ebp)
80104402:	e8 b9 e2 ff ff       	call   801026c0 <readFromSwapFile>
      writeToSwapFile(np, pg_buffer, i, PGSIZE);
80104407:	68 00 10 00 00       	push   $0x1000
8010440c:	53                   	push   %ebx
    for (int i = 0; i < last_not_free_in_file * PGSIZE; i += PGSIZE){
8010440d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      writeToSwapFile(np, pg_buffer, i, PGSIZE);
80104413:	57                   	push   %edi
80104414:	56                   	push   %esi
80104415:	e8 76 e2 ff ff       	call   80102690 <writeToSwapFile>
    for (int i = 0; i < last_not_free_in_file * PGSIZE; i += PGSIZE){
8010441a:	83 c4 20             	add    $0x20,%esp
8010441d:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80104420:	75 d6                	jne    801043f8 <fork+0x158>
80104422:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80104425:	89 f2                	mov    %esi,%edx
    cow_kfree(pg_buffer);
80104427:	83 ec 0c             	sub    $0xc,%esp
8010442a:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010442d:	57                   	push   %edi
8010442e:	e8 dd 2e 00 00       	call   80107310 <cow_kfree>
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
80104433:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cow_kfree(pg_buffer);
80104436:	83 c4 10             	add    $0x10,%esp
80104439:	b8 80 00 00 00       	mov    $0x80,%eax
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
8010443e:	31 c9                	xor    %ecx,%ecx
      np->ram_pages[i] = curproc->ram_pages[i];
80104440:	8b b4 03 80 01 00 00 	mov    0x180(%ebx,%eax,1),%esi
80104447:	89 b4 02 80 01 00 00 	mov    %esi,0x180(%edx,%eax,1)
8010444e:	8b b4 03 84 01 00 00 	mov    0x184(%ebx,%eax,1),%esi
80104455:	89 b4 02 84 01 00 00 	mov    %esi,0x184(%edx,%eax,1)
8010445c:	8b b4 03 88 01 00 00 	mov    0x188(%ebx,%eax,1),%esi
80104463:	89 b4 02 88 01 00 00 	mov    %esi,0x188(%edx,%eax,1)
8010446a:	8b b4 03 8c 01 00 00 	mov    0x18c(%ebx,%eax,1),%esi
80104471:	89 b4 02 8c 01 00 00 	mov    %esi,0x18c(%edx,%eax,1)
80104478:	8b b4 03 90 01 00 00 	mov    0x190(%ebx,%eax,1),%esi
8010447f:	89 b4 02 90 01 00 00 	mov    %esi,0x190(%edx,%eax,1)
80104486:	8b b4 03 94 01 00 00 	mov    0x194(%ebx,%eax,1),%esi
8010448d:	89 b4 02 94 01 00 00 	mov    %esi,0x194(%edx,%eax,1)
      np->swapped_out_pages[i] = curproc->swapped_out_pages[i];
80104494:	8b 34 03             	mov    (%ebx,%eax,1),%esi
80104497:	89 34 02             	mov    %esi,(%edx,%eax,1)
8010449a:	8b 74 03 04          	mov    0x4(%ebx,%eax,1),%esi
8010449e:	89 74 02 04          	mov    %esi,0x4(%edx,%eax,1)
801044a2:	8b 74 03 08          	mov    0x8(%ebx,%eax,1),%esi
801044a6:	89 74 02 08          	mov    %esi,0x8(%edx,%eax,1)
801044aa:	8b 74 03 0c          	mov    0xc(%ebx,%eax,1),%esi
801044ae:	89 74 02 0c          	mov    %esi,0xc(%edx,%eax,1)
801044b2:	8b 74 03 10          	mov    0x10(%ebx,%eax,1),%esi
801044b6:	89 74 02 10          	mov    %esi,0x10(%edx,%eax,1)
801044ba:	8b 74 03 14          	mov    0x14(%ebx,%eax,1),%esi
801044be:	89 74 02 14          	mov    %esi,0x14(%edx,%eax,1)
      np->advance_queue[i] = curproc->advance_queue[i];
801044c2:	8b b4 8b 80 03 00 00 	mov    0x380(%ebx,%ecx,4),%esi
801044c9:	83 c0 18             	add    $0x18,%eax
801044cc:	89 b4 8a 80 03 00 00 	mov    %esi,0x380(%edx,%ecx,4)
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
801044d3:	83 c1 01             	add    $0x1,%ecx
801044d6:	83 f9 10             	cmp    $0x10,%ecx
801044d9:	0f 85 61 ff ff ff    	jne    80104440 <fork+0x1a0>
    np->num_of_actual_pages_in_mem = curproc->num_of_actual_pages_in_mem;
801044df:	8b 83 c4 03 00 00    	mov    0x3c4(%ebx),%eax
801044e5:	89 82 c4 03 00 00    	mov    %eax,0x3c4(%edx)
    np->num_of_pages_in_swap_file = curproc->num_of_pages_in_swap_file;
801044eb:	8b 83 c0 03 00 00    	mov    0x3c0(%ebx),%eax
801044f1:	89 82 c0 03 00 00    	mov    %eax,0x3c0(%edx)
801044f7:	e9 71 fe ff ff       	jmp    8010436d <fork+0xcd>
801044fc:	89 55 e0             	mov    %edx,-0x20(%ebp)
    void* pg_buffer = cow_kalloc();
801044ff:	e8 9c 2e 00 00       	call   801073a0 <cow_kalloc>
80104504:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104507:	89 c7                	mov    %eax,%edi
80104509:	e9 19 ff ff ff       	jmp    80104427 <fork+0x187>
    return -1;
8010450e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
80104515:	e9 7c fe ff ff       	jmp    80104396 <fork+0xf6>
    cow_kfree(np->kstack);
8010451a:	83 ec 0c             	sub    $0xc,%esp
8010451d:	ff 72 08             	pushl  0x8(%edx)
80104520:	e8 eb 2d 00 00       	call   80107310 <cow_kfree>
    np->kstack = 0;
80104525:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    return -1;
80104528:	83 c4 10             	add    $0x10,%esp
8010452b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
    np->kstack = 0;
80104532:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    np->state = UNUSED;
80104539:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    return -1;
80104540:	e9 51 fe ff ff       	jmp    80104396 <fork+0xf6>
80104545:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104550 <scheduler>:
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	57                   	push   %edi
80104554:	56                   	push   %esi
80104555:	53                   	push   %ebx
80104556:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104559:	e8 c2 fa ff ff       	call   80104020 <mycpu>
8010455e:	8d 78 04             	lea    0x4(%eax),%edi
80104561:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104563:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010456a:	00 00 00 
8010456d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104570:	fb                   	sti    
    acquire(&ptable.lock);
80104571:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104574:	bb d4 2d 12 80       	mov    $0x80122dd4,%ebx
    acquire(&ptable.lock);
80104579:	68 a0 2d 12 80       	push   $0x80122da0
8010457e:	e8 dd 09 00 00       	call   80104f60 <acquire>
80104583:	83 c4 10             	add    $0x10,%esp
80104586:	8d 76 00             	lea    0x0(%esi),%esi
80104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80104590:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104594:	75 33                	jne    801045c9 <scheduler+0x79>
      switchuvm(p);
80104596:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104599:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010459f:	53                   	push   %ebx
801045a0:	e8 eb 33 00 00       	call   80107990 <switchuvm>
      swtch(&(c->scheduler), p->context);
801045a5:	58                   	pop    %eax
801045a6:	5a                   	pop    %edx
801045a7:	ff 73 1c             	pushl  0x1c(%ebx)
801045aa:	57                   	push   %edi
      p->state = RUNNING;
801045ab:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801045b2:	e8 f4 0c 00 00       	call   801052ab <swtch>
      switchkvm();
801045b7:	e8 b4 33 00 00       	call   80107970 <switchkvm>
      c->proc = 0;
801045bc:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801045c3:	00 00 00 
801045c6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045c9:	81 c3 d0 03 00 00    	add    $0x3d0,%ebx
801045cf:	81 fb d4 21 13 80    	cmp    $0x801321d4,%ebx
801045d5:	72 b9                	jb     80104590 <scheduler+0x40>
    release(&ptable.lock);
801045d7:	83 ec 0c             	sub    $0xc,%esp
801045da:	68 a0 2d 12 80       	push   $0x80122da0
801045df:	e8 3c 0a 00 00       	call   80105020 <release>
    sti();
801045e4:	83 c4 10             	add    $0x10,%esp
801045e7:	eb 87                	jmp    80104570 <scheduler+0x20>
801045e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045f0 <sched>:
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	56                   	push   %esi
801045f4:	53                   	push   %ebx
  pushcli();
801045f5:	e8 96 08 00 00       	call   80104e90 <pushcli>
  c = mycpu();
801045fa:	e8 21 fa ff ff       	call   80104020 <mycpu>
  p = c->proc;
801045ff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104605:	e8 c6 08 00 00       	call   80104ed0 <popcli>
  if(!holding(&ptable.lock))
8010460a:	83 ec 0c             	sub    $0xc,%esp
8010460d:	68 a0 2d 12 80       	push   $0x80122da0
80104612:	e8 19 09 00 00       	call   80104f30 <holding>
80104617:	83 c4 10             	add    $0x10,%esp
8010461a:	85 c0                	test   %eax,%eax
8010461c:	74 4f                	je     8010466d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010461e:	e8 fd f9 ff ff       	call   80104020 <mycpu>
80104623:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010462a:	75 68                	jne    80104694 <sched+0xa4>
  if(p->state == RUNNING)
8010462c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104630:	74 55                	je     80104687 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104632:	9c                   	pushf  
80104633:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104634:	f6 c4 02             	test   $0x2,%ah
80104637:	75 41                	jne    8010467a <sched+0x8a>
  intena = mycpu()->intena;
80104639:	e8 e2 f9 ff ff       	call   80104020 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010463e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104641:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104647:	e8 d4 f9 ff ff       	call   80104020 <mycpu>
8010464c:	83 ec 08             	sub    $0x8,%esp
8010464f:	ff 70 04             	pushl  0x4(%eax)
80104652:	53                   	push   %ebx
80104653:	e8 53 0c 00 00       	call   801052ab <swtch>
  mycpu()->intena = intena;
80104658:	e8 c3 f9 ff ff       	call   80104020 <mycpu>
}
8010465d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104660:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104666:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104669:	5b                   	pop    %ebx
8010466a:	5e                   	pop    %esi
8010466b:	5d                   	pop    %ebp
8010466c:	c3                   	ret    
    panic("sched ptable.lock");
8010466d:	83 ec 0c             	sub    $0xc,%esp
80104670:	68 0a 8f 10 80       	push   $0x80108f0a
80104675:	e8 16 bd ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010467a:	83 ec 0c             	sub    $0xc,%esp
8010467d:	68 36 8f 10 80       	push   $0x80108f36
80104682:	e8 09 bd ff ff       	call   80100390 <panic>
    panic("sched running");
80104687:	83 ec 0c             	sub    $0xc,%esp
8010468a:	68 28 8f 10 80       	push   $0x80108f28
8010468f:	e8 fc bc ff ff       	call   80100390 <panic>
    panic("sched locks");
80104694:	83 ec 0c             	sub    $0xc,%esp
80104697:	68 1c 8f 10 80       	push   $0x80108f1c
8010469c:	e8 ef bc ff ff       	call   80100390 <panic>
801046a1:	eb 0d                	jmp    801046b0 <exit>
801046a3:	90                   	nop
801046a4:	90                   	nop
801046a5:	90                   	nop
801046a6:	90                   	nop
801046a7:	90                   	nop
801046a8:	90                   	nop
801046a9:	90                   	nop
801046aa:	90                   	nop
801046ab:	90                   	nop
801046ac:	90                   	nop
801046ad:	90                   	nop
801046ae:	90                   	nop
801046af:	90                   	nop

801046b0 <exit>:
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	57                   	push   %edi
801046b4:	56                   	push   %esi
801046b5:	53                   	push   %ebx
801046b6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801046b9:	e8 d2 07 00 00       	call   80104e90 <pushcli>
  c = mycpu();
801046be:	e8 5d f9 ff ff       	call   80104020 <mycpu>
  p = c->proc;
801046c3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046c9:	e8 02 08 00 00       	call   80104ed0 <popcli>
  if(curproc == initproc)
801046ce:	39 1d b8 c5 10 80    	cmp    %ebx,0x8010c5b8
801046d4:	8d 73 28             	lea    0x28(%ebx),%esi
801046d7:	8d 7b 68             	lea    0x68(%ebx),%edi
801046da:	0f 84 62 01 00 00    	je     80104842 <exit+0x192>
    if(curproc->ofile[fd]){
801046e0:	8b 06                	mov    (%esi),%eax
801046e2:	85 c0                	test   %eax,%eax
801046e4:	74 12                	je     801046f8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
801046e6:	83 ec 0c             	sub    $0xc,%esp
801046e9:	50                   	push   %eax
801046ea:	e8 91 cb ff ff       	call   80101280 <fileclose>
      curproc->ofile[fd] = 0;
801046ef:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801046f5:	83 c4 10             	add    $0x10,%esp
801046f8:	83 c6 04             	add    $0x4,%esi
  for(fd = 0; fd < NOFILE; fd++){
801046fb:	39 fe                	cmp    %edi,%esi
801046fd:	75 e1                	jne    801046e0 <exit+0x30>
  begin_op();
801046ff:	e8 ec ec ff ff       	call   801033f0 <begin_op>
  iput(curproc->cwd);
80104704:	83 ec 0c             	sub    $0xc,%esp
80104707:	ff 73 68             	pushl  0x68(%ebx)
8010470a:	e8 e1 d4 ff ff       	call   80101bf0 <iput>
  end_op();
8010470f:	e8 4c ed ff ff       	call   80103460 <end_op>
  curproc->cwd = 0;
80104714:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  removeSwapFile(curproc);
8010471b:	89 1c 24             	mov    %ebx,(%esp)
8010471e:	e8 cd dc ff ff       	call   801023f0 <removeSwapFile>
  acquire(&ptable.lock);
80104723:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
8010472a:	e8 31 08 00 00       	call   80104f60 <acquire>
  wakeup1(curproc->parent);
8010472f:	8b 53 14             	mov    0x14(%ebx),%edx
80104732:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104735:	b8 d4 2d 12 80       	mov    $0x80122dd4,%eax
8010473a:	eb 10                	jmp    8010474c <exit+0x9c>
8010473c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104740:	05 d0 03 00 00       	add    $0x3d0,%eax
80104745:	3d d4 21 13 80       	cmp    $0x801321d4,%eax
8010474a:	73 1e                	jae    8010476a <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
8010474c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104750:	75 ee                	jne    80104740 <exit+0x90>
80104752:	3b 50 20             	cmp    0x20(%eax),%edx
80104755:	75 e9                	jne    80104740 <exit+0x90>
      p->state = RUNNABLE;
80104757:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010475e:	05 d0 03 00 00       	add    $0x3d0,%eax
80104763:	3d d4 21 13 80       	cmp    $0x801321d4,%eax
80104768:	72 e2                	jb     8010474c <exit+0x9c>
      p->parent = initproc;
8010476a:	8b 0d b8 c5 10 80    	mov    0x8010c5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104770:	ba d4 2d 12 80       	mov    $0x80122dd4,%edx
80104775:	eb 17                	jmp    8010478e <exit+0xde>
80104777:	89 f6                	mov    %esi,%esi
80104779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104780:	81 c2 d0 03 00 00    	add    $0x3d0,%edx
80104786:	81 fa d4 21 13 80    	cmp    $0x801321d4,%edx
8010478c:	73 3a                	jae    801047c8 <exit+0x118>
    if(p->parent == curproc){
8010478e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104791:	75 ed                	jne    80104780 <exit+0xd0>
      if(p->state == ZOMBIE)
80104793:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104797:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010479a:	75 e4                	jne    80104780 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010479c:	b8 d4 2d 12 80       	mov    $0x80122dd4,%eax
801047a1:	eb 11                	jmp    801047b4 <exit+0x104>
801047a3:	90                   	nop
801047a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047a8:	05 d0 03 00 00       	add    $0x3d0,%eax
801047ad:	3d d4 21 13 80       	cmp    $0x801321d4,%eax
801047b2:	73 cc                	jae    80104780 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
801047b4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801047b8:	75 ee                	jne    801047a8 <exit+0xf8>
801047ba:	3b 48 20             	cmp    0x20(%eax),%ecx
801047bd:	75 e9                	jne    801047a8 <exit+0xf8>
      p->state = RUNNABLE;
801047bf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801047c6:	eb e0                	jmp    801047a8 <exit+0xf8>
  curproc->num_of_pages_in_swap_file, curproc->num_of_pagefaults_occurs, curproc->num_of_pageOut_occured,curproc->name);
801047c8:	8d 43 6c             	lea    0x6c(%ebx),%eax
  curproc->state = ZOMBIE;
801047cb:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  cprintf("%d %s RAM: %d SWAP: %d PGFAULTS: %d SWAPED_OUT: %d %s\n", 
801047d2:	50                   	push   %eax
801047d3:	ff b3 cc 03 00 00    	pushl  0x3cc(%ebx)
801047d9:	ff b3 c8 03 00 00    	pushl  0x3c8(%ebx)
801047df:	ff b3 c0 03 00 00    	pushl  0x3c0(%ebx)
801047e5:	ff b3 c4 03 00 00    	pushl  0x3c4(%ebx)
801047eb:	68 57 8f 10 80       	push   $0x80108f57
801047f0:	ff 73 10             	pushl  0x10(%ebx)
801047f3:	68 d0 8f 10 80       	push   $0x80108fd0
801047f8:	e8 63 be ff ff       	call   80100660 <cprintf>
801047fd:	83 c4 20             	add    $0x20,%esp
  int count = 0;
80104800:	31 d2                	xor    %edx,%edx
  for (int i = 0; i < PHYSTOP / PGSIZE; i++){
80104802:	31 c0                	xor    %eax,%eax
80104804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      count++;
80104808:	80 b8 40 1f 11 80 01 	cmpb   $0x1,-0x7feee0c0(%eax)
8010480f:	83 da ff             	sbb    $0xffffffff,%edx
  for (int i = 0; i < PHYSTOP / PGSIZE; i++){
80104812:	83 c0 01             	add    $0x1,%eax
80104815:	3d 00 e0 00 00       	cmp    $0xe000,%eax
8010481a:	75 ec                	jne    80104808 <exit+0x158>
  cprintf("%d / %d free page frames in the system\n", currentFree, totalFree);
8010481c:	83 ec 04             	sub    $0x4,%esp
  return (PHYSTOP/PGSIZE) - count;
8010481f:	29 d0                	sub    %edx,%eax
  cprintf("%d / %d free page frames in the system\n", currentFree, totalFree);
80104821:	68 00 df 00 00       	push   $0xdf00
80104826:	50                   	push   %eax
80104827:	68 08 90 10 80       	push   $0x80109008
8010482c:	e8 2f be ff ff       	call   80100660 <cprintf>
  sched();
80104831:	e8 ba fd ff ff       	call   801045f0 <sched>
  panic("zombie exit");
80104836:	c7 04 24 5e 8f 10 80 	movl   $0x80108f5e,(%esp)
8010483d:	e8 4e bb ff ff       	call   80100390 <panic>
    panic("init exiting");
80104842:	83 ec 0c             	sub    $0xc,%esp
80104845:	68 4a 8f 10 80       	push   $0x80108f4a
8010484a:	e8 41 bb ff ff       	call   80100390 <panic>
8010484f:	90                   	nop

80104850 <yield>:
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	53                   	push   %ebx
80104854:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104857:	68 a0 2d 12 80       	push   $0x80122da0
8010485c:	e8 ff 06 00 00       	call   80104f60 <acquire>
  pushcli();
80104861:	e8 2a 06 00 00       	call   80104e90 <pushcli>
  c = mycpu();
80104866:	e8 b5 f7 ff ff       	call   80104020 <mycpu>
  p = c->proc;
8010486b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104871:	e8 5a 06 00 00       	call   80104ed0 <popcli>
  myproc()->state = RUNNABLE;
80104876:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010487d:	e8 6e fd ff ff       	call   801045f0 <sched>
  release(&ptable.lock);
80104882:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
80104889:	e8 92 07 00 00       	call   80105020 <release>
}
8010488e:	83 c4 10             	add    $0x10,%esp
80104891:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104894:	c9                   	leave  
80104895:	c3                   	ret    
80104896:	8d 76 00             	lea    0x0(%esi),%esi
80104899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048a0 <sleep>:
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	57                   	push   %edi
801048a4:	56                   	push   %esi
801048a5:	53                   	push   %ebx
801048a6:	83 ec 0c             	sub    $0xc,%esp
801048a9:	8b 7d 08             	mov    0x8(%ebp),%edi
801048ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801048af:	e8 dc 05 00 00       	call   80104e90 <pushcli>
  c = mycpu();
801048b4:	e8 67 f7 ff ff       	call   80104020 <mycpu>
  p = c->proc;
801048b9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801048bf:	e8 0c 06 00 00       	call   80104ed0 <popcli>
  if(p == 0)
801048c4:	85 db                	test   %ebx,%ebx
801048c6:	0f 84 87 00 00 00    	je     80104953 <sleep+0xb3>
  if(lk == 0)
801048cc:	85 f6                	test   %esi,%esi
801048ce:	74 76                	je     80104946 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801048d0:	81 fe a0 2d 12 80    	cmp    $0x80122da0,%esi
801048d6:	74 50                	je     80104928 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801048d8:	83 ec 0c             	sub    $0xc,%esp
801048db:	68 a0 2d 12 80       	push   $0x80122da0
801048e0:	e8 7b 06 00 00       	call   80104f60 <acquire>
    release(lk);
801048e5:	89 34 24             	mov    %esi,(%esp)
801048e8:	e8 33 07 00 00       	call   80105020 <release>
  p->chan = chan;
801048ed:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801048f0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801048f7:	e8 f4 fc ff ff       	call   801045f0 <sched>
  p->chan = 0;
801048fc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104903:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
8010490a:	e8 11 07 00 00       	call   80105020 <release>
    acquire(lk);
8010490f:	89 75 08             	mov    %esi,0x8(%ebp)
80104912:	83 c4 10             	add    $0x10,%esp
}
80104915:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104918:	5b                   	pop    %ebx
80104919:	5e                   	pop    %esi
8010491a:	5f                   	pop    %edi
8010491b:	5d                   	pop    %ebp
    acquire(lk);
8010491c:	e9 3f 06 00 00       	jmp    80104f60 <acquire>
80104921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104928:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010492b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104932:	e8 b9 fc ff ff       	call   801045f0 <sched>
  p->chan = 0;
80104937:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010493e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104941:	5b                   	pop    %ebx
80104942:	5e                   	pop    %esi
80104943:	5f                   	pop    %edi
80104944:	5d                   	pop    %ebp
80104945:	c3                   	ret    
    panic("sleep without lk");
80104946:	83 ec 0c             	sub    $0xc,%esp
80104949:	68 70 8f 10 80       	push   $0x80108f70
8010494e:	e8 3d ba ff ff       	call   80100390 <panic>
    panic("sleep");
80104953:	83 ec 0c             	sub    $0xc,%esp
80104956:	68 6a 8f 10 80       	push   $0x80108f6a
8010495b:	e8 30 ba ff ff       	call   80100390 <panic>

80104960 <wait>:
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	56                   	push   %esi
80104964:	53                   	push   %ebx
  pushcli();
80104965:	e8 26 05 00 00       	call   80104e90 <pushcli>
  c = mycpu();
8010496a:	e8 b1 f6 ff ff       	call   80104020 <mycpu>
  p = c->proc;
8010496f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104975:	e8 56 05 00 00       	call   80104ed0 <popcli>
  acquire(&ptable.lock);
8010497a:	83 ec 0c             	sub    $0xc,%esp
8010497d:	68 a0 2d 12 80       	push   $0x80122da0
80104982:	e8 d9 05 00 00       	call   80104f60 <acquire>
80104987:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010498a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010498c:	bb d4 2d 12 80       	mov    $0x80122dd4,%ebx
80104991:	eb 13                	jmp    801049a6 <wait+0x46>
80104993:	90                   	nop
80104994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104998:	81 c3 d0 03 00 00    	add    $0x3d0,%ebx
8010499e:	81 fb d4 21 13 80    	cmp    $0x801321d4,%ebx
801049a4:	73 1e                	jae    801049c4 <wait+0x64>
      if(p->parent != curproc)
801049a6:	39 73 14             	cmp    %esi,0x14(%ebx)
801049a9:	75 ed                	jne    80104998 <wait+0x38>
      if(p->state == ZOMBIE){
801049ab:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801049af:	74 3f                	je     801049f0 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049b1:	81 c3 d0 03 00 00    	add    $0x3d0,%ebx
      havekids = 1;
801049b7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049bc:	81 fb d4 21 13 80    	cmp    $0x801321d4,%ebx
801049c2:	72 e2                	jb     801049a6 <wait+0x46>
    if(!havekids || curproc->killed){
801049c4:	85 c0                	test   %eax,%eax
801049c6:	0f 84 01 01 00 00    	je     80104acd <wait+0x16d>
801049cc:	8b 46 24             	mov    0x24(%esi),%eax
801049cf:	85 c0                	test   %eax,%eax
801049d1:	0f 85 f6 00 00 00    	jne    80104acd <wait+0x16d>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801049d7:	83 ec 08             	sub    $0x8,%esp
801049da:	68 a0 2d 12 80       	push   $0x80122da0
801049df:	56                   	push   %esi
801049e0:	e8 bb fe ff ff       	call   801048a0 <sleep>
    havekids = 0;
801049e5:	83 c4 10             	add    $0x10,%esp
801049e8:	eb a0                	jmp    8010498a <wait+0x2a>
801049ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (p->pid > 2){
801049f0:	8b 73 10             	mov    0x10(%ebx),%esi
801049f3:	83 fe 02             	cmp    $0x2,%esi
801049f6:	0f 8e 7e 00 00 00    	jle    80104a7a <wait+0x11a>
801049fc:	8d 93 80 00 00 00    	lea    0x80(%ebx),%edx
80104a02:	8d 8b 00 02 00 00    	lea    0x200(%ebx),%ecx
          p->num_of_pagefaults_occurs = 0;
80104a08:	c7 83 c8 03 00 00 00 	movl   $0x0,0x3c8(%ebx)
80104a0f:	00 00 00 
          p->num_of_actual_pages_in_mem = 0;
80104a12:	c7 83 c4 03 00 00 00 	movl   $0x0,0x3c4(%ebx)
80104a19:	00 00 00 
          p->num_of_pageOut_occured = 0;
80104a1c:	c7 83 cc 03 00 00 00 	movl   $0x0,0x3cc(%ebx)
80104a23:	00 00 00 
          p->num_of_pages_in_swap_file = 0;
80104a26:	c7 83 c0 03 00 00 00 	movl   $0x0,0x3c0(%ebx)
80104a2d:	00 00 00 
            p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
80104a30:	c7 02 01 00 00 00    	movl   $0x1,(%edx)
80104a36:	c7 82 80 01 00 00 01 	movl   $0x1,0x180(%edx)
80104a3d:	00 00 00 
80104a40:	83 c2 18             	add    $0x18,%edx
            p->ram_pages[i].aging_counter = p->swapped_out_pages[i].aging_counter = 0;
80104a43:	c7 42 f0 00 00 00 00 	movl   $0x0,-0x10(%edx)
80104a4a:	c7 82 70 01 00 00 00 	movl   $0x0,0x170(%edx)
80104a51:	00 00 00 
            p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
80104a54:	c7 42 ec 00 00 00 00 	movl   $0x0,-0x14(%edx)
80104a5b:	c7 82 6c 01 00 00 00 	movl   $0x0,0x16c(%edx)
80104a62:	00 00 00 
            p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
80104a65:	c7 42 f8 00 00 00 00 	movl   $0x0,-0x8(%edx)
80104a6c:	c7 82 78 01 00 00 00 	movl   $0x0,0x178(%edx)
80104a73:	00 00 00 
          for (int i = 0; i < MAX_PYSC_PAGES; i++){
80104a76:	39 d1                	cmp    %edx,%ecx
80104a78:	75 b6                	jne    80104a30 <wait+0xd0>
        cow_kfree(p->kstack);
80104a7a:	83 ec 0c             	sub    $0xc,%esp
80104a7d:	ff 73 08             	pushl  0x8(%ebx)
80104a80:	e8 8b 28 00 00       	call   80107310 <cow_kfree>
        freevm(p->pgdir);
80104a85:	5a                   	pop    %edx
80104a86:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104a89:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104a90:	e8 db 32 00 00       	call   80107d70 <freevm>
        release(&ptable.lock);
80104a95:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
        p->pid = 0;
80104a9c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104aa3:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104aaa:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104aae:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104ab5:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104abc:	e8 5f 05 00 00       	call   80105020 <release>
        return pid;
80104ac1:	83 c4 10             	add    $0x10,%esp
}
80104ac4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ac7:	89 f0                	mov    %esi,%eax
80104ac9:	5b                   	pop    %ebx
80104aca:	5e                   	pop    %esi
80104acb:	5d                   	pop    %ebp
80104acc:	c3                   	ret    
      release(&ptable.lock);
80104acd:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104ad0:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104ad5:	68 a0 2d 12 80       	push   $0x80122da0
80104ada:	e8 41 05 00 00       	call   80105020 <release>
      return -1;
80104adf:	83 c4 10             	add    $0x10,%esp
80104ae2:	eb e0                	jmp    80104ac4 <wait+0x164>
80104ae4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104aea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104af0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	53                   	push   %ebx
80104af4:	83 ec 10             	sub    $0x10,%esp
80104af7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104afa:	68 a0 2d 12 80       	push   $0x80122da0
80104aff:	e8 5c 04 00 00       	call   80104f60 <acquire>
80104b04:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b07:	b8 d4 2d 12 80       	mov    $0x80122dd4,%eax
80104b0c:	eb 0e                	jmp    80104b1c <wakeup+0x2c>
80104b0e:	66 90                	xchg   %ax,%ax
80104b10:	05 d0 03 00 00       	add    $0x3d0,%eax
80104b15:	3d d4 21 13 80       	cmp    $0x801321d4,%eax
80104b1a:	73 1e                	jae    80104b3a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
80104b1c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104b20:	75 ee                	jne    80104b10 <wakeup+0x20>
80104b22:	3b 58 20             	cmp    0x20(%eax),%ebx
80104b25:	75 e9                	jne    80104b10 <wakeup+0x20>
      p->state = RUNNABLE;
80104b27:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b2e:	05 d0 03 00 00       	add    $0x3d0,%eax
80104b33:	3d d4 21 13 80       	cmp    $0x801321d4,%eax
80104b38:	72 e2                	jb     80104b1c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80104b3a:	c7 45 08 a0 2d 12 80 	movl   $0x80122da0,0x8(%ebp)
}
80104b41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b44:	c9                   	leave  
  release(&ptable.lock);
80104b45:	e9 d6 04 00 00       	jmp    80105020 <release>
80104b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b50 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	53                   	push   %ebx
80104b54:	83 ec 10             	sub    $0x10,%esp
80104b57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104b5a:	68 a0 2d 12 80       	push   $0x80122da0
80104b5f:	e8 fc 03 00 00       	call   80104f60 <acquire>
80104b64:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b67:	b8 d4 2d 12 80       	mov    $0x80122dd4,%eax
80104b6c:	eb 0e                	jmp    80104b7c <kill+0x2c>
80104b6e:	66 90                	xchg   %ax,%ax
80104b70:	05 d0 03 00 00       	add    $0x3d0,%eax
80104b75:	3d d4 21 13 80       	cmp    $0x801321d4,%eax
80104b7a:	73 34                	jae    80104bb0 <kill+0x60>
    if(p->pid == pid){
80104b7c:	39 58 10             	cmp    %ebx,0x10(%eax)
80104b7f:	75 ef                	jne    80104b70 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104b81:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104b85:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104b8c:	75 07                	jne    80104b95 <kill+0x45>
        p->state = RUNNABLE;
80104b8e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104b95:	83 ec 0c             	sub    $0xc,%esp
80104b98:	68 a0 2d 12 80       	push   $0x80122da0
80104b9d:	e8 7e 04 00 00       	call   80105020 <release>
      return 0;
80104ba2:	83 c4 10             	add    $0x10,%esp
80104ba5:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104ba7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104baa:	c9                   	leave  
80104bab:	c3                   	ret    
80104bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104bb0:	83 ec 0c             	sub    $0xc,%esp
80104bb3:	68 a0 2d 12 80       	push   $0x80122da0
80104bb8:	e8 63 04 00 00       	call   80105020 <release>
  return -1;
80104bbd:	83 c4 10             	add    $0x10,%esp
80104bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bc8:	c9                   	leave  
80104bc9:	c3                   	ret    
80104bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bd0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	57                   	push   %edi
80104bd4:	56                   	push   %esi
80104bd5:	53                   	push   %ebx
80104bd6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bd9:	bb d4 2d 12 80       	mov    $0x80122dd4,%ebx
{
80104bde:	83 ec 3c             	sub    $0x3c,%esp
80104be1:	eb 27                	jmp    80104c0a <procdump+0x3a>
80104be3:	90                   	nop
80104be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104be8:	83 ec 0c             	sub    $0xc,%esp
80104beb:	68 8e 95 10 80       	push   $0x8010958e
80104bf0:	e8 6b ba ff ff       	call   80100660 <cprintf>
80104bf5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bf8:	81 c3 d0 03 00 00    	add    $0x3d0,%ebx
80104bfe:	81 fb d4 21 13 80    	cmp    $0x801321d4,%ebx
80104c04:	0f 83 a6 00 00 00    	jae    80104cb0 <procdump+0xe0>
    if(p->state == UNUSED)
80104c0a:	8b 43 0c             	mov    0xc(%ebx),%eax
80104c0d:	85 c0                	test   %eax,%eax
80104c0f:	74 e7                	je     80104bf8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104c11:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104c14:	ba 81 8f 10 80       	mov    $0x80108f81,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104c19:	77 11                	ja     80104c2c <procdump+0x5c>
80104c1b:	8b 14 85 68 90 10 80 	mov    -0x7fef6f98(,%eax,4),%edx
      state = "???";
80104c22:	b8 81 8f 10 80       	mov    $0x80108f81,%eax
80104c27:	85 d2                	test   %edx,%edx
80104c29:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s RAM: %d SWAP: %d PGFAULTS: %d SWAPED_OUT: %d %s", p->pid, state,  p->num_of_actual_pages_in_mem, p->num_of_pages_in_swap_file, p->num_of_pagefaults_occurs, p->num_of_pageOut_occured, p->name);
80104c2c:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104c2f:	50                   	push   %eax
80104c30:	ff b3 cc 03 00 00    	pushl  0x3cc(%ebx)
80104c36:	ff b3 c8 03 00 00    	pushl  0x3c8(%ebx)
80104c3c:	ff b3 c0 03 00 00    	pushl  0x3c0(%ebx)
80104c42:	ff b3 c4 03 00 00    	pushl  0x3c4(%ebx)
80104c48:	52                   	push   %edx
80104c49:	ff 73 10             	pushl  0x10(%ebx)
80104c4c:	68 30 90 10 80       	push   $0x80109030
80104c51:	e8 0a ba ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104c56:	83 c4 20             	add    $0x20,%esp
80104c59:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104c5d:	75 89                	jne    80104be8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104c5f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104c62:	83 ec 08             	sub    $0x8,%esp
80104c65:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104c68:	50                   	push   %eax
80104c69:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104c6c:	8b 40 0c             	mov    0xc(%eax),%eax
80104c6f:	83 c0 08             	add    $0x8,%eax
80104c72:	50                   	push   %eax
80104c73:	e8 c8 01 00 00       	call   80104e40 <getcallerpcs>
80104c78:	83 c4 10             	add    $0x10,%esp
80104c7b:	90                   	nop
80104c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104c80:	8b 17                	mov    (%edi),%edx
80104c82:	85 d2                	test   %edx,%edx
80104c84:	0f 84 5e ff ff ff    	je     80104be8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104c8a:	83 ec 08             	sub    $0x8,%esp
80104c8d:	83 c7 04             	add    $0x4,%edi
80104c90:	52                   	push   %edx
80104c91:	68 41 89 10 80       	push   $0x80108941
80104c96:	e8 c5 b9 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104c9b:	83 c4 10             	add    $0x10,%esp
80104c9e:	39 fe                	cmp    %edi,%esi
80104ca0:	75 de                	jne    80104c80 <procdump+0xb0>
80104ca2:	e9 41 ff ff ff       	jmp    80104be8 <procdump+0x18>
80104ca7:	89 f6                	mov    %esi,%esi
80104ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int count = 0;
80104cb0:	31 d2                	xor    %edx,%edx
  for (int i = 0; i < PHYSTOP / PGSIZE; i++){
80104cb2:	31 c0                	xor    %eax,%eax
80104cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      count++;
80104cb8:	80 b8 40 1f 11 80 01 	cmpb   $0x1,-0x7feee0c0(%eax)
80104cbf:	83 da ff             	sbb    $0xffffffff,%edx
  for (int i = 0; i < PHYSTOP / PGSIZE; i++){
80104cc2:	83 c0 01             	add    $0x1,%eax
80104cc5:	3d 00 e0 00 00       	cmp    $0xe000,%eax
80104cca:	75 ec                	jne    80104cb8 <procdump+0xe8>
  }
  int currentFree = sys_get_number_of_free_pages_impl();
  int totalFree = (PHYSTOP-EXTMEM) / PGSIZE ;///verify
  cprintf("%d / %d free page frames in the system\n", currentFree, totalFree);
80104ccc:	83 ec 04             	sub    $0x4,%esp
  return (PHYSTOP/PGSIZE) - count;
80104ccf:	29 d0                	sub    %edx,%eax
  cprintf("%d / %d free page frames in the system\n", currentFree, totalFree);
80104cd1:	68 00 df 00 00       	push   $0xdf00
80104cd6:	50                   	push   %eax
80104cd7:	68 08 90 10 80       	push   $0x80109008
80104cdc:	e8 7f b9 ff ff       	call   80100660 <cprintf>
}
80104ce1:	83 c4 10             	add    $0x10,%esp
80104ce4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ce7:	5b                   	pop    %ebx
80104ce8:	5e                   	pop    %esi
80104ce9:	5f                   	pop    %edi
80104cea:	5d                   	pop    %ebp
80104ceb:	c3                   	ret    
80104cec:	66 90                	xchg   %ax,%ax
80104cee:	66 90                	xchg   %ax,%ax

80104cf0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	53                   	push   %ebx
80104cf4:	83 ec 0c             	sub    $0xc,%esp
80104cf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104cfa:	68 80 90 10 80       	push   $0x80109080
80104cff:	8d 43 04             	lea    0x4(%ebx),%eax
80104d02:	50                   	push   %eax
80104d03:	e8 18 01 00 00       	call   80104e20 <initlock>
  lk->name = name;
80104d08:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104d0b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104d11:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104d14:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104d1b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104d1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d21:	c9                   	leave  
80104d22:	c3                   	ret    
80104d23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d30 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	56                   	push   %esi
80104d34:	53                   	push   %ebx
80104d35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104d38:	83 ec 0c             	sub    $0xc,%esp
80104d3b:	8d 73 04             	lea    0x4(%ebx),%esi
80104d3e:	56                   	push   %esi
80104d3f:	e8 1c 02 00 00       	call   80104f60 <acquire>
  while (lk->locked) {
80104d44:	8b 13                	mov    (%ebx),%edx
80104d46:	83 c4 10             	add    $0x10,%esp
80104d49:	85 d2                	test   %edx,%edx
80104d4b:	74 16                	je     80104d63 <acquiresleep+0x33>
80104d4d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104d50:	83 ec 08             	sub    $0x8,%esp
80104d53:	56                   	push   %esi
80104d54:	53                   	push   %ebx
80104d55:	e8 46 fb ff ff       	call   801048a0 <sleep>
  while (lk->locked) {
80104d5a:	8b 03                	mov    (%ebx),%eax
80104d5c:	83 c4 10             	add    $0x10,%esp
80104d5f:	85 c0                	test   %eax,%eax
80104d61:	75 ed                	jne    80104d50 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104d63:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104d69:	e8 62 f3 ff ff       	call   801040d0 <myproc>
80104d6e:	8b 40 10             	mov    0x10(%eax),%eax
80104d71:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104d74:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104d77:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d7a:	5b                   	pop    %ebx
80104d7b:	5e                   	pop    %esi
80104d7c:	5d                   	pop    %ebp
  release(&lk->lk);
80104d7d:	e9 9e 02 00 00       	jmp    80105020 <release>
80104d82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d90 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	56                   	push   %esi
80104d94:	53                   	push   %ebx
80104d95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104d98:	83 ec 0c             	sub    $0xc,%esp
80104d9b:	8d 73 04             	lea    0x4(%ebx),%esi
80104d9e:	56                   	push   %esi
80104d9f:	e8 bc 01 00 00       	call   80104f60 <acquire>
  lk->locked = 0;
80104da4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104daa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104db1:	89 1c 24             	mov    %ebx,(%esp)
80104db4:	e8 37 fd ff ff       	call   80104af0 <wakeup>
  release(&lk->lk);
80104db9:	89 75 08             	mov    %esi,0x8(%ebp)
80104dbc:	83 c4 10             	add    $0x10,%esp
}
80104dbf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dc2:	5b                   	pop    %ebx
80104dc3:	5e                   	pop    %esi
80104dc4:	5d                   	pop    %ebp
  release(&lk->lk);
80104dc5:	e9 56 02 00 00       	jmp    80105020 <release>
80104dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104dd0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	57                   	push   %edi
80104dd4:	56                   	push   %esi
80104dd5:	53                   	push   %ebx
80104dd6:	31 ff                	xor    %edi,%edi
80104dd8:	83 ec 18             	sub    $0x18,%esp
80104ddb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104dde:	8d 73 04             	lea    0x4(%ebx),%esi
80104de1:	56                   	push   %esi
80104de2:	e8 79 01 00 00       	call   80104f60 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104de7:	8b 03                	mov    (%ebx),%eax
80104de9:	83 c4 10             	add    $0x10,%esp
80104dec:	85 c0                	test   %eax,%eax
80104dee:	74 13                	je     80104e03 <holdingsleep+0x33>
80104df0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104df3:	e8 d8 f2 ff ff       	call   801040d0 <myproc>
80104df8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104dfb:	0f 94 c0             	sete   %al
80104dfe:	0f b6 c0             	movzbl %al,%eax
80104e01:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104e03:	83 ec 0c             	sub    $0xc,%esp
80104e06:	56                   	push   %esi
80104e07:	e8 14 02 00 00       	call   80105020 <release>
  return r;
}
80104e0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e0f:	89 f8                	mov    %edi,%eax
80104e11:	5b                   	pop    %ebx
80104e12:	5e                   	pop    %esi
80104e13:	5f                   	pop    %edi
80104e14:	5d                   	pop    %ebp
80104e15:	c3                   	ret    
80104e16:	66 90                	xchg   %ax,%ax
80104e18:	66 90                	xchg   %ax,%ax
80104e1a:	66 90                	xchg   %ax,%ax
80104e1c:	66 90                	xchg   %ax,%ax
80104e1e:	66 90                	xchg   %ax,%ax

80104e20 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104e26:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104e29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104e2f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104e32:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104e39:	5d                   	pop    %ebp
80104e3a:	c3                   	ret    
80104e3b:	90                   	nop
80104e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e40 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104e40:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104e41:	31 d2                	xor    %edx,%edx
{
80104e43:	89 e5                	mov    %esp,%ebp
80104e45:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104e46:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104e49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104e4c:	83 e8 08             	sub    $0x8,%eax
80104e4f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e50:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104e56:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104e5c:	77 1a                	ja     80104e78 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104e5e:	8b 58 04             	mov    0x4(%eax),%ebx
80104e61:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104e64:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104e67:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104e69:	83 fa 0a             	cmp    $0xa,%edx
80104e6c:	75 e2                	jne    80104e50 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104e6e:	5b                   	pop    %ebx
80104e6f:	5d                   	pop    %ebp
80104e70:	c3                   	ret    
80104e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e78:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104e7b:	83 c1 28             	add    $0x28,%ecx
80104e7e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104e80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104e86:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104e89:	39 c1                	cmp    %eax,%ecx
80104e8b:	75 f3                	jne    80104e80 <getcallerpcs+0x40>
}
80104e8d:	5b                   	pop    %ebx
80104e8e:	5d                   	pop    %ebp
80104e8f:	c3                   	ret    

80104e90 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	53                   	push   %ebx
80104e94:	83 ec 04             	sub    $0x4,%esp
80104e97:	9c                   	pushf  
80104e98:	5b                   	pop    %ebx
  asm volatile("cli");
80104e99:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104e9a:	e8 81 f1 ff ff       	call   80104020 <mycpu>
80104e9f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104ea5:	85 c0                	test   %eax,%eax
80104ea7:	75 11                	jne    80104eba <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104ea9:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104eaf:	e8 6c f1 ff ff       	call   80104020 <mycpu>
80104eb4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104eba:	e8 61 f1 ff ff       	call   80104020 <mycpu>
80104ebf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104ec6:	83 c4 04             	add    $0x4,%esp
80104ec9:	5b                   	pop    %ebx
80104eca:	5d                   	pop    %ebp
80104ecb:	c3                   	ret    
80104ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ed0 <popcli>:

void
popcli(void)
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104ed6:	9c                   	pushf  
80104ed7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104ed8:	f6 c4 02             	test   $0x2,%ah
80104edb:	75 35                	jne    80104f12 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104edd:	e8 3e f1 ff ff       	call   80104020 <mycpu>
80104ee2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104ee9:	78 34                	js     80104f1f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104eeb:	e8 30 f1 ff ff       	call   80104020 <mycpu>
80104ef0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104ef6:	85 d2                	test   %edx,%edx
80104ef8:	74 06                	je     80104f00 <popcli+0x30>
    sti();
}
80104efa:	c9                   	leave  
80104efb:	c3                   	ret    
80104efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104f00:	e8 1b f1 ff ff       	call   80104020 <mycpu>
80104f05:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104f0b:	85 c0                	test   %eax,%eax
80104f0d:	74 eb                	je     80104efa <popcli+0x2a>
  asm volatile("sti");
80104f0f:	fb                   	sti    
}
80104f10:	c9                   	leave  
80104f11:	c3                   	ret    
    panic("popcli - interruptible");
80104f12:	83 ec 0c             	sub    $0xc,%esp
80104f15:	68 8b 90 10 80       	push   $0x8010908b
80104f1a:	e8 71 b4 ff ff       	call   80100390 <panic>
    panic("popcli");
80104f1f:	83 ec 0c             	sub    $0xc,%esp
80104f22:	68 a2 90 10 80       	push   $0x801090a2
80104f27:	e8 64 b4 ff ff       	call   80100390 <panic>
80104f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f30 <holding>:
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	56                   	push   %esi
80104f34:	53                   	push   %ebx
80104f35:	8b 75 08             	mov    0x8(%ebp),%esi
80104f38:	31 db                	xor    %ebx,%ebx
  pushcli();
80104f3a:	e8 51 ff ff ff       	call   80104e90 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104f3f:	8b 06                	mov    (%esi),%eax
80104f41:	85 c0                	test   %eax,%eax
80104f43:	74 10                	je     80104f55 <holding+0x25>
80104f45:	8b 5e 08             	mov    0x8(%esi),%ebx
80104f48:	e8 d3 f0 ff ff       	call   80104020 <mycpu>
80104f4d:	39 c3                	cmp    %eax,%ebx
80104f4f:	0f 94 c3             	sete   %bl
80104f52:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104f55:	e8 76 ff ff ff       	call   80104ed0 <popcli>
}
80104f5a:	89 d8                	mov    %ebx,%eax
80104f5c:	5b                   	pop    %ebx
80104f5d:	5e                   	pop    %esi
80104f5e:	5d                   	pop    %ebp
80104f5f:	c3                   	ret    

80104f60 <acquire>:
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	56                   	push   %esi
80104f64:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104f65:	e8 26 ff ff ff       	call   80104e90 <pushcli>
  if(holding(lk))
80104f6a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104f6d:	83 ec 0c             	sub    $0xc,%esp
80104f70:	53                   	push   %ebx
80104f71:	e8 ba ff ff ff       	call   80104f30 <holding>
80104f76:	83 c4 10             	add    $0x10,%esp
80104f79:	85 c0                	test   %eax,%eax
80104f7b:	0f 85 83 00 00 00    	jne    80105004 <acquire+0xa4>
80104f81:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104f83:	ba 01 00 00 00       	mov    $0x1,%edx
80104f88:	eb 09                	jmp    80104f93 <acquire+0x33>
80104f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f90:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104f93:	89 d0                	mov    %edx,%eax
80104f95:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104f98:	85 c0                	test   %eax,%eax
80104f9a:	75 f4                	jne    80104f90 <acquire+0x30>
  __sync_synchronize();
80104f9c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104fa1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104fa4:	e8 77 f0 ff ff       	call   80104020 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104fa9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104fac:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104faf:	89 e8                	mov    %ebp,%eax
80104fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104fb8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104fbe:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104fc4:	77 1a                	ja     80104fe0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104fc6:	8b 48 04             	mov    0x4(%eax),%ecx
80104fc9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104fcc:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104fcf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104fd1:	83 fe 0a             	cmp    $0xa,%esi
80104fd4:	75 e2                	jne    80104fb8 <acquire+0x58>
}
80104fd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fd9:	5b                   	pop    %ebx
80104fda:	5e                   	pop    %esi
80104fdb:	5d                   	pop    %ebp
80104fdc:	c3                   	ret    
80104fdd:	8d 76 00             	lea    0x0(%esi),%esi
80104fe0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104fe3:	83 c2 28             	add    $0x28,%edx
80104fe6:	8d 76 00             	lea    0x0(%esi),%esi
80104fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104ff0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104ff6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104ff9:	39 d0                	cmp    %edx,%eax
80104ffb:	75 f3                	jne    80104ff0 <acquire+0x90>
}
80104ffd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105000:	5b                   	pop    %ebx
80105001:	5e                   	pop    %esi
80105002:	5d                   	pop    %ebp
80105003:	c3                   	ret    
    panic("acquire");
80105004:	83 ec 0c             	sub    $0xc,%esp
80105007:	68 a9 90 10 80       	push   $0x801090a9
8010500c:	e8 7f b3 ff ff       	call   80100390 <panic>
80105011:	eb 0d                	jmp    80105020 <release>
80105013:	90                   	nop
80105014:	90                   	nop
80105015:	90                   	nop
80105016:	90                   	nop
80105017:	90                   	nop
80105018:	90                   	nop
80105019:	90                   	nop
8010501a:	90                   	nop
8010501b:	90                   	nop
8010501c:	90                   	nop
8010501d:	90                   	nop
8010501e:	90                   	nop
8010501f:	90                   	nop

80105020 <release>:
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	53                   	push   %ebx
80105024:	83 ec 10             	sub    $0x10,%esp
80105027:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010502a:	53                   	push   %ebx
8010502b:	e8 00 ff ff ff       	call   80104f30 <holding>
80105030:	83 c4 10             	add    $0x10,%esp
80105033:	85 c0                	test   %eax,%eax
80105035:	74 22                	je     80105059 <release+0x39>
  lk->pcs[0] = 0;
80105037:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010503e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105045:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010504a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105050:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105053:	c9                   	leave  
  popcli();
80105054:	e9 77 fe ff ff       	jmp    80104ed0 <popcli>
    panic("release");
80105059:	83 ec 0c             	sub    $0xc,%esp
8010505c:	68 b1 90 10 80       	push   $0x801090b1
80105061:	e8 2a b3 ff ff       	call   80100390 <panic>
80105066:	66 90                	xchg   %ax,%ax
80105068:	66 90                	xchg   %ax,%ax
8010506a:	66 90                	xchg   %ax,%ax
8010506c:	66 90                	xchg   %ax,%ax
8010506e:	66 90                	xchg   %ax,%ax

80105070 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	57                   	push   %edi
80105074:	53                   	push   %ebx
80105075:	8b 55 08             	mov    0x8(%ebp),%edx
80105078:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010507b:	f6 c2 03             	test   $0x3,%dl
8010507e:	75 05                	jne    80105085 <memset+0x15>
80105080:	f6 c1 03             	test   $0x3,%cl
80105083:	74 13                	je     80105098 <memset+0x28>
  asm volatile("cld; rep stosb" :
80105085:	89 d7                	mov    %edx,%edi
80105087:	8b 45 0c             	mov    0xc(%ebp),%eax
8010508a:	fc                   	cld    
8010508b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010508d:	5b                   	pop    %ebx
8010508e:	89 d0                	mov    %edx,%eax
80105090:	5f                   	pop    %edi
80105091:	5d                   	pop    %ebp
80105092:	c3                   	ret    
80105093:	90                   	nop
80105094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80105098:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010509c:	c1 e9 02             	shr    $0x2,%ecx
8010509f:	89 f8                	mov    %edi,%eax
801050a1:	89 fb                	mov    %edi,%ebx
801050a3:	c1 e0 18             	shl    $0x18,%eax
801050a6:	c1 e3 10             	shl    $0x10,%ebx
801050a9:	09 d8                	or     %ebx,%eax
801050ab:	09 f8                	or     %edi,%eax
801050ad:	c1 e7 08             	shl    $0x8,%edi
801050b0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801050b2:	89 d7                	mov    %edx,%edi
801050b4:	fc                   	cld    
801050b5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801050b7:	5b                   	pop    %ebx
801050b8:	89 d0                	mov    %edx,%eax
801050ba:	5f                   	pop    %edi
801050bb:	5d                   	pop    %ebp
801050bc:	c3                   	ret    
801050bd:	8d 76 00             	lea    0x0(%esi),%esi

801050c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	57                   	push   %edi
801050c4:	56                   	push   %esi
801050c5:	53                   	push   %ebx
801050c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801050c9:	8b 75 08             	mov    0x8(%ebp),%esi
801050cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801050cf:	85 db                	test   %ebx,%ebx
801050d1:	74 29                	je     801050fc <memcmp+0x3c>
    if(*s1 != *s2)
801050d3:	0f b6 16             	movzbl (%esi),%edx
801050d6:	0f b6 0f             	movzbl (%edi),%ecx
801050d9:	38 d1                	cmp    %dl,%cl
801050db:	75 2b                	jne    80105108 <memcmp+0x48>
801050dd:	b8 01 00 00 00       	mov    $0x1,%eax
801050e2:	eb 14                	jmp    801050f8 <memcmp+0x38>
801050e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050e8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801050ec:	83 c0 01             	add    $0x1,%eax
801050ef:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801050f4:	38 ca                	cmp    %cl,%dl
801050f6:	75 10                	jne    80105108 <memcmp+0x48>
  while(n-- > 0){
801050f8:	39 d8                	cmp    %ebx,%eax
801050fa:	75 ec                	jne    801050e8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801050fc:	5b                   	pop    %ebx
  return 0;
801050fd:	31 c0                	xor    %eax,%eax
}
801050ff:	5e                   	pop    %esi
80105100:	5f                   	pop    %edi
80105101:	5d                   	pop    %ebp
80105102:	c3                   	ret    
80105103:	90                   	nop
80105104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80105108:	0f b6 c2             	movzbl %dl,%eax
}
8010510b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010510c:	29 c8                	sub    %ecx,%eax
}
8010510e:	5e                   	pop    %esi
8010510f:	5f                   	pop    %edi
80105110:	5d                   	pop    %ebp
80105111:	c3                   	ret    
80105112:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105120 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	56                   	push   %esi
80105124:	53                   	push   %ebx
80105125:	8b 45 08             	mov    0x8(%ebp),%eax
80105128:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010512b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010512e:	39 c3                	cmp    %eax,%ebx
80105130:	73 26                	jae    80105158 <memmove+0x38>
80105132:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80105135:	39 c8                	cmp    %ecx,%eax
80105137:	73 1f                	jae    80105158 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80105139:	85 f6                	test   %esi,%esi
8010513b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010513e:	74 0f                	je     8010514f <memmove+0x2f>
      *--d = *--s;
80105140:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105144:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80105147:	83 ea 01             	sub    $0x1,%edx
8010514a:	83 fa ff             	cmp    $0xffffffff,%edx
8010514d:	75 f1                	jne    80105140 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010514f:	5b                   	pop    %ebx
80105150:	5e                   	pop    %esi
80105151:	5d                   	pop    %ebp
80105152:	c3                   	ret    
80105153:	90                   	nop
80105154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80105158:	31 d2                	xor    %edx,%edx
8010515a:	85 f6                	test   %esi,%esi
8010515c:	74 f1                	je     8010514f <memmove+0x2f>
8010515e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105160:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105164:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105167:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010516a:	39 d6                	cmp    %edx,%esi
8010516c:	75 f2                	jne    80105160 <memmove+0x40>
}
8010516e:	5b                   	pop    %ebx
8010516f:	5e                   	pop    %esi
80105170:	5d                   	pop    %ebp
80105171:	c3                   	ret    
80105172:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105180 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105183:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105184:	eb 9a                	jmp    80105120 <memmove>
80105186:	8d 76 00             	lea    0x0(%esi),%esi
80105189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105190 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	57                   	push   %edi
80105194:	56                   	push   %esi
80105195:	8b 7d 10             	mov    0x10(%ebp),%edi
80105198:	53                   	push   %ebx
80105199:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010519c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010519f:	85 ff                	test   %edi,%edi
801051a1:	74 2f                	je     801051d2 <strncmp+0x42>
801051a3:	0f b6 01             	movzbl (%ecx),%eax
801051a6:	0f b6 1e             	movzbl (%esi),%ebx
801051a9:	84 c0                	test   %al,%al
801051ab:	74 37                	je     801051e4 <strncmp+0x54>
801051ad:	38 c3                	cmp    %al,%bl
801051af:	75 33                	jne    801051e4 <strncmp+0x54>
801051b1:	01 f7                	add    %esi,%edi
801051b3:	eb 13                	jmp    801051c8 <strncmp+0x38>
801051b5:	8d 76 00             	lea    0x0(%esi),%esi
801051b8:	0f b6 01             	movzbl (%ecx),%eax
801051bb:	84 c0                	test   %al,%al
801051bd:	74 21                	je     801051e0 <strncmp+0x50>
801051bf:	0f b6 1a             	movzbl (%edx),%ebx
801051c2:	89 d6                	mov    %edx,%esi
801051c4:	38 d8                	cmp    %bl,%al
801051c6:	75 1c                	jne    801051e4 <strncmp+0x54>
    n--, p++, q++;
801051c8:	8d 56 01             	lea    0x1(%esi),%edx
801051cb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801051ce:	39 fa                	cmp    %edi,%edx
801051d0:	75 e6                	jne    801051b8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801051d2:	5b                   	pop    %ebx
    return 0;
801051d3:	31 c0                	xor    %eax,%eax
}
801051d5:	5e                   	pop    %esi
801051d6:	5f                   	pop    %edi
801051d7:	5d                   	pop    %ebp
801051d8:	c3                   	ret    
801051d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051e0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801051e4:	29 d8                	sub    %ebx,%eax
}
801051e6:	5b                   	pop    %ebx
801051e7:	5e                   	pop    %esi
801051e8:	5f                   	pop    %edi
801051e9:	5d                   	pop    %ebp
801051ea:	c3                   	ret    
801051eb:	90                   	nop
801051ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	56                   	push   %esi
801051f4:	53                   	push   %ebx
801051f5:	8b 45 08             	mov    0x8(%ebp),%eax
801051f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801051fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801051fe:	89 c2                	mov    %eax,%edx
80105200:	eb 19                	jmp    8010521b <strncpy+0x2b>
80105202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105208:	83 c3 01             	add    $0x1,%ebx
8010520b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010520f:	83 c2 01             	add    $0x1,%edx
80105212:	84 c9                	test   %cl,%cl
80105214:	88 4a ff             	mov    %cl,-0x1(%edx)
80105217:	74 09                	je     80105222 <strncpy+0x32>
80105219:	89 f1                	mov    %esi,%ecx
8010521b:	85 c9                	test   %ecx,%ecx
8010521d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80105220:	7f e6                	jg     80105208 <strncpy+0x18>
    ;
  while(n-- > 0)
80105222:	31 c9                	xor    %ecx,%ecx
80105224:	85 f6                	test   %esi,%esi
80105226:	7e 17                	jle    8010523f <strncpy+0x4f>
80105228:	90                   	nop
80105229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105230:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105234:	89 f3                	mov    %esi,%ebx
80105236:	83 c1 01             	add    $0x1,%ecx
80105239:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010523b:	85 db                	test   %ebx,%ebx
8010523d:	7f f1                	jg     80105230 <strncpy+0x40>
  return os;
}
8010523f:	5b                   	pop    %ebx
80105240:	5e                   	pop    %esi
80105241:	5d                   	pop    %ebp
80105242:	c3                   	ret    
80105243:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105250 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	56                   	push   %esi
80105254:	53                   	push   %ebx
80105255:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105258:	8b 45 08             	mov    0x8(%ebp),%eax
8010525b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010525e:	85 c9                	test   %ecx,%ecx
80105260:	7e 26                	jle    80105288 <safestrcpy+0x38>
80105262:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105266:	89 c1                	mov    %eax,%ecx
80105268:	eb 17                	jmp    80105281 <safestrcpy+0x31>
8010526a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105270:	83 c2 01             	add    $0x1,%edx
80105273:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105277:	83 c1 01             	add    $0x1,%ecx
8010527a:	84 db                	test   %bl,%bl
8010527c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010527f:	74 04                	je     80105285 <safestrcpy+0x35>
80105281:	39 f2                	cmp    %esi,%edx
80105283:	75 eb                	jne    80105270 <safestrcpy+0x20>
    ;
  *s = 0;
80105285:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105288:	5b                   	pop    %ebx
80105289:	5e                   	pop    %esi
8010528a:	5d                   	pop    %ebp
8010528b:	c3                   	ret    
8010528c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105290 <strlen>:

int
strlen(const char *s)
{
80105290:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105291:	31 c0                	xor    %eax,%eax
{
80105293:	89 e5                	mov    %esp,%ebp
80105295:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105298:	80 3a 00             	cmpb   $0x0,(%edx)
8010529b:	74 0c                	je     801052a9 <strlen+0x19>
8010529d:	8d 76 00             	lea    0x0(%esi),%esi
801052a0:	83 c0 01             	add    $0x1,%eax
801052a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801052a7:	75 f7                	jne    801052a0 <strlen+0x10>
    ;
  return n;
}
801052a9:	5d                   	pop    %ebp
801052aa:	c3                   	ret    

801052ab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801052ab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801052af:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801052b3:	55                   	push   %ebp
  pushl %ebx
801052b4:	53                   	push   %ebx
  pushl %esi
801052b5:	56                   	push   %esi
  pushl %edi
801052b6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801052b7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801052b9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801052bb:	5f                   	pop    %edi
  popl %esi
801052bc:	5e                   	pop    %esi
  popl %ebx
801052bd:	5b                   	pop    %ebx
  popl %ebp
801052be:	5d                   	pop    %ebp
  ret
801052bf:	c3                   	ret    

801052c0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	53                   	push   %ebx
801052c4:	83 ec 04             	sub    $0x4,%esp
801052c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801052ca:	e8 01 ee ff ff       	call   801040d0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801052cf:	8b 00                	mov    (%eax),%eax
801052d1:	39 d8                	cmp    %ebx,%eax
801052d3:	76 1b                	jbe    801052f0 <fetchint+0x30>
801052d5:	8d 53 04             	lea    0x4(%ebx),%edx
801052d8:	39 d0                	cmp    %edx,%eax
801052da:	72 14                	jb     801052f0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801052dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801052df:	8b 13                	mov    (%ebx),%edx
801052e1:	89 10                	mov    %edx,(%eax)
  return 0;
801052e3:	31 c0                	xor    %eax,%eax
}
801052e5:	83 c4 04             	add    $0x4,%esp
801052e8:	5b                   	pop    %ebx
801052e9:	5d                   	pop    %ebp
801052ea:	c3                   	ret    
801052eb:	90                   	nop
801052ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801052f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052f5:	eb ee                	jmp    801052e5 <fetchint+0x25>
801052f7:	89 f6                	mov    %esi,%esi
801052f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105300 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	53                   	push   %ebx
80105304:	83 ec 04             	sub    $0x4,%esp
80105307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010530a:	e8 c1 ed ff ff       	call   801040d0 <myproc>

  if(addr >= curproc->sz)
8010530f:	39 18                	cmp    %ebx,(%eax)
80105311:	76 29                	jbe    8010533c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105313:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105316:	89 da                	mov    %ebx,%edx
80105318:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010531a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010531c:	39 c3                	cmp    %eax,%ebx
8010531e:	73 1c                	jae    8010533c <fetchstr+0x3c>
    if(*s == 0)
80105320:	80 3b 00             	cmpb   $0x0,(%ebx)
80105323:	75 10                	jne    80105335 <fetchstr+0x35>
80105325:	eb 39                	jmp    80105360 <fetchstr+0x60>
80105327:	89 f6                	mov    %esi,%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105330:	80 3a 00             	cmpb   $0x0,(%edx)
80105333:	74 1b                	je     80105350 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80105335:	83 c2 01             	add    $0x1,%edx
80105338:	39 d0                	cmp    %edx,%eax
8010533a:	77 f4                	ja     80105330 <fetchstr+0x30>
    return -1;
8010533c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80105341:	83 c4 04             	add    $0x4,%esp
80105344:	5b                   	pop    %ebx
80105345:	5d                   	pop    %ebp
80105346:	c3                   	ret    
80105347:	89 f6                	mov    %esi,%esi
80105349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105350:	83 c4 04             	add    $0x4,%esp
80105353:	89 d0                	mov    %edx,%eax
80105355:	29 d8                	sub    %ebx,%eax
80105357:	5b                   	pop    %ebx
80105358:	5d                   	pop    %ebp
80105359:	c3                   	ret    
8010535a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105360:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105362:	eb dd                	jmp    80105341 <fetchstr+0x41>
80105364:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010536a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105370 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	56                   	push   %esi
80105374:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105375:	e8 56 ed ff ff       	call   801040d0 <myproc>
8010537a:	8b 40 18             	mov    0x18(%eax),%eax
8010537d:	8b 55 08             	mov    0x8(%ebp),%edx
80105380:	8b 40 44             	mov    0x44(%eax),%eax
80105383:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105386:	e8 45 ed ff ff       	call   801040d0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010538b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010538d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105390:	39 c6                	cmp    %eax,%esi
80105392:	73 1c                	jae    801053b0 <argint+0x40>
80105394:	8d 53 08             	lea    0x8(%ebx),%edx
80105397:	39 d0                	cmp    %edx,%eax
80105399:	72 15                	jb     801053b0 <argint+0x40>
  *ip = *(int*)(addr);
8010539b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010539e:	8b 53 04             	mov    0x4(%ebx),%edx
801053a1:	89 10                	mov    %edx,(%eax)
  return 0;
801053a3:	31 c0                	xor    %eax,%eax
}
801053a5:	5b                   	pop    %ebx
801053a6:	5e                   	pop    %esi
801053a7:	5d                   	pop    %ebp
801053a8:	c3                   	ret    
801053a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801053b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801053b5:	eb ee                	jmp    801053a5 <argint+0x35>
801053b7:	89 f6                	mov    %esi,%esi
801053b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053c0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	56                   	push   %esi
801053c4:	53                   	push   %ebx
801053c5:	83 ec 10             	sub    $0x10,%esp
801053c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801053cb:	e8 00 ed ff ff       	call   801040d0 <myproc>
801053d0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801053d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053d5:	83 ec 08             	sub    $0x8,%esp
801053d8:	50                   	push   %eax
801053d9:	ff 75 08             	pushl  0x8(%ebp)
801053dc:	e8 8f ff ff ff       	call   80105370 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801053e1:	83 c4 10             	add    $0x10,%esp
801053e4:	85 c0                	test   %eax,%eax
801053e6:	78 28                	js     80105410 <argptr+0x50>
801053e8:	85 db                	test   %ebx,%ebx
801053ea:	78 24                	js     80105410 <argptr+0x50>
801053ec:	8b 16                	mov    (%esi),%edx
801053ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053f1:	39 c2                	cmp    %eax,%edx
801053f3:	76 1b                	jbe    80105410 <argptr+0x50>
801053f5:	01 c3                	add    %eax,%ebx
801053f7:	39 da                	cmp    %ebx,%edx
801053f9:	72 15                	jb     80105410 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801053fb:	8b 55 0c             	mov    0xc(%ebp),%edx
801053fe:	89 02                	mov    %eax,(%edx)
  return 0;
80105400:	31 c0                	xor    %eax,%eax
}
80105402:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105405:	5b                   	pop    %ebx
80105406:	5e                   	pop    %esi
80105407:	5d                   	pop    %ebp
80105408:	c3                   	ret    
80105409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105415:	eb eb                	jmp    80105402 <argptr+0x42>
80105417:	89 f6                	mov    %esi,%esi
80105419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105420 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105426:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105429:	50                   	push   %eax
8010542a:	ff 75 08             	pushl  0x8(%ebp)
8010542d:	e8 3e ff ff ff       	call   80105370 <argint>
80105432:	83 c4 10             	add    $0x10,%esp
80105435:	85 c0                	test   %eax,%eax
80105437:	78 17                	js     80105450 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105439:	83 ec 08             	sub    $0x8,%esp
8010543c:	ff 75 0c             	pushl  0xc(%ebp)
8010543f:	ff 75 f4             	pushl  -0xc(%ebp)
80105442:	e8 b9 fe ff ff       	call   80105300 <fetchstr>
80105447:	83 c4 10             	add    $0x10,%esp
}
8010544a:	c9                   	leave  
8010544b:	c3                   	ret    
8010544c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105450:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105455:	c9                   	leave  
80105456:	c3                   	ret    
80105457:	89 f6                	mov    %esi,%esi
80105459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105460 <syscall>:
[SYS_get_number_of_free_pages] sys_get_number_of_free_pages
};

void
syscall(void)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	53                   	push   %ebx
80105464:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105467:	e8 64 ec ff ff       	call   801040d0 <myproc>
8010546c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010546e:	8b 40 18             	mov    0x18(%eax),%eax
80105471:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105474:	8d 50 ff             	lea    -0x1(%eax),%edx
80105477:	83 fa 15             	cmp    $0x15,%edx
8010547a:	77 1c                	ja     80105498 <syscall+0x38>
8010547c:	8b 14 85 e0 90 10 80 	mov    -0x7fef6f20(,%eax,4),%edx
80105483:	85 d2                	test   %edx,%edx
80105485:	74 11                	je     80105498 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105487:	ff d2                	call   *%edx
80105489:	8b 53 18             	mov    0x18(%ebx),%edx
8010548c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010548f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105492:	c9                   	leave  
80105493:	c3                   	ret    
80105494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105498:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105499:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010549c:	50                   	push   %eax
8010549d:	ff 73 10             	pushl  0x10(%ebx)
801054a0:	68 b9 90 10 80       	push   $0x801090b9
801054a5:	e8 b6 b1 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
801054aa:	8b 43 18             	mov    0x18(%ebx),%eax
801054ad:	83 c4 10             	add    $0x10,%esp
801054b0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801054b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054ba:	c9                   	leave  
801054bb:	c3                   	ret    
801054bc:	66 90                	xchg   %ax,%ax
801054be:	66 90                	xchg   %ax,%ax

801054c0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	56                   	push   %esi
801054c4:	53                   	push   %ebx
801054c5:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801054c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801054ca:	89 d6                	mov    %edx,%esi
801054cc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801054cf:	50                   	push   %eax
801054d0:	6a 00                	push   $0x0
801054d2:	e8 99 fe ff ff       	call   80105370 <argint>
801054d7:	83 c4 10             	add    $0x10,%esp
801054da:	85 c0                	test   %eax,%eax
801054dc:	78 2a                	js     80105508 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801054de:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054e2:	77 24                	ja     80105508 <argfd.constprop.0+0x48>
801054e4:	e8 e7 eb ff ff       	call   801040d0 <myproc>
801054e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054ec:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801054f0:	85 c0                	test   %eax,%eax
801054f2:	74 14                	je     80105508 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
801054f4:	85 db                	test   %ebx,%ebx
801054f6:	74 02                	je     801054fa <argfd.constprop.0+0x3a>
    *pfd = fd;
801054f8:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
801054fa:	89 06                	mov    %eax,(%esi)
  return 0;
801054fc:	31 c0                	xor    %eax,%eax
}
801054fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105501:	5b                   	pop    %ebx
80105502:	5e                   	pop    %esi
80105503:	5d                   	pop    %ebp
80105504:	c3                   	ret    
80105505:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105508:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010550d:	eb ef                	jmp    801054fe <argfd.constprop.0+0x3e>
8010550f:	90                   	nop

80105510 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105510:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105511:	31 c0                	xor    %eax,%eax
{
80105513:	89 e5                	mov    %esp,%ebp
80105515:	56                   	push   %esi
80105516:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105517:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010551a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010551d:	e8 9e ff ff ff       	call   801054c0 <argfd.constprop.0>
80105522:	85 c0                	test   %eax,%eax
80105524:	78 42                	js     80105568 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
80105526:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105529:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010552b:	e8 a0 eb ff ff       	call   801040d0 <myproc>
80105530:	eb 0e                	jmp    80105540 <sys_dup+0x30>
80105532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105538:	83 c3 01             	add    $0x1,%ebx
8010553b:	83 fb 10             	cmp    $0x10,%ebx
8010553e:	74 28                	je     80105568 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105540:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105544:	85 d2                	test   %edx,%edx
80105546:	75 f0                	jne    80105538 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105548:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
8010554c:	83 ec 0c             	sub    $0xc,%esp
8010554f:	ff 75 f4             	pushl  -0xc(%ebp)
80105552:	e8 d9 bc ff ff       	call   80101230 <filedup>
  return fd;
80105557:	83 c4 10             	add    $0x10,%esp
}
8010555a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010555d:	89 d8                	mov    %ebx,%eax
8010555f:	5b                   	pop    %ebx
80105560:	5e                   	pop    %esi
80105561:	5d                   	pop    %ebp
80105562:	c3                   	ret    
80105563:	90                   	nop
80105564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105568:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010556b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105570:	89 d8                	mov    %ebx,%eax
80105572:	5b                   	pop    %ebx
80105573:	5e                   	pop    %esi
80105574:	5d                   	pop    %ebp
80105575:	c3                   	ret    
80105576:	8d 76 00             	lea    0x0(%esi),%esi
80105579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105580 <sys_read>:

int
sys_read(void)
{
80105580:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105581:	31 c0                	xor    %eax,%eax
{
80105583:	89 e5                	mov    %esp,%ebp
80105585:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105588:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010558b:	e8 30 ff ff ff       	call   801054c0 <argfd.constprop.0>
80105590:	85 c0                	test   %eax,%eax
80105592:	78 4c                	js     801055e0 <sys_read+0x60>
80105594:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105597:	83 ec 08             	sub    $0x8,%esp
8010559a:	50                   	push   %eax
8010559b:	6a 02                	push   $0x2
8010559d:	e8 ce fd ff ff       	call   80105370 <argint>
801055a2:	83 c4 10             	add    $0x10,%esp
801055a5:	85 c0                	test   %eax,%eax
801055a7:	78 37                	js     801055e0 <sys_read+0x60>
801055a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055ac:	83 ec 04             	sub    $0x4,%esp
801055af:	ff 75 f0             	pushl  -0x10(%ebp)
801055b2:	50                   	push   %eax
801055b3:	6a 01                	push   $0x1
801055b5:	e8 06 fe ff ff       	call   801053c0 <argptr>
801055ba:	83 c4 10             	add    $0x10,%esp
801055bd:	85 c0                	test   %eax,%eax
801055bf:	78 1f                	js     801055e0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
801055c1:	83 ec 04             	sub    $0x4,%esp
801055c4:	ff 75 f0             	pushl  -0x10(%ebp)
801055c7:	ff 75 f4             	pushl  -0xc(%ebp)
801055ca:	ff 75 ec             	pushl  -0x14(%ebp)
801055cd:	e8 ce bd ff ff       	call   801013a0 <fileread>
801055d2:	83 c4 10             	add    $0x10,%esp
}
801055d5:	c9                   	leave  
801055d6:	c3                   	ret    
801055d7:	89 f6                	mov    %esi,%esi
801055d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801055e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055e5:	c9                   	leave  
801055e6:	c3                   	ret    
801055e7:	89 f6                	mov    %esi,%esi
801055e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055f0 <sys_write>:

int
sys_write(void)
{
801055f0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055f1:	31 c0                	xor    %eax,%eax
{
801055f3:	89 e5                	mov    %esp,%ebp
801055f5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055f8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801055fb:	e8 c0 fe ff ff       	call   801054c0 <argfd.constprop.0>
80105600:	85 c0                	test   %eax,%eax
80105602:	78 4c                	js     80105650 <sys_write+0x60>
80105604:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105607:	83 ec 08             	sub    $0x8,%esp
8010560a:	50                   	push   %eax
8010560b:	6a 02                	push   $0x2
8010560d:	e8 5e fd ff ff       	call   80105370 <argint>
80105612:	83 c4 10             	add    $0x10,%esp
80105615:	85 c0                	test   %eax,%eax
80105617:	78 37                	js     80105650 <sys_write+0x60>
80105619:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010561c:	83 ec 04             	sub    $0x4,%esp
8010561f:	ff 75 f0             	pushl  -0x10(%ebp)
80105622:	50                   	push   %eax
80105623:	6a 01                	push   $0x1
80105625:	e8 96 fd ff ff       	call   801053c0 <argptr>
8010562a:	83 c4 10             	add    $0x10,%esp
8010562d:	85 c0                	test   %eax,%eax
8010562f:	78 1f                	js     80105650 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105631:	83 ec 04             	sub    $0x4,%esp
80105634:	ff 75 f0             	pushl  -0x10(%ebp)
80105637:	ff 75 f4             	pushl  -0xc(%ebp)
8010563a:	ff 75 ec             	pushl  -0x14(%ebp)
8010563d:	e8 ee bd ff ff       	call   80101430 <filewrite>
80105642:	83 c4 10             	add    $0x10,%esp
}
80105645:	c9                   	leave  
80105646:	c3                   	ret    
80105647:	89 f6                	mov    %esi,%esi
80105649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105650:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105655:	c9                   	leave  
80105656:	c3                   	ret    
80105657:	89 f6                	mov    %esi,%esi
80105659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105660 <sys_close>:

int
sys_close(void)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105666:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105669:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010566c:	e8 4f fe ff ff       	call   801054c0 <argfd.constprop.0>
80105671:	85 c0                	test   %eax,%eax
80105673:	78 2b                	js     801056a0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105675:	e8 56 ea ff ff       	call   801040d0 <myproc>
8010567a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010567d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105680:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105687:	00 
  fileclose(f);
80105688:	ff 75 f4             	pushl  -0xc(%ebp)
8010568b:	e8 f0 bb ff ff       	call   80101280 <fileclose>
  return 0;
80105690:	83 c4 10             	add    $0x10,%esp
80105693:	31 c0                	xor    %eax,%eax
}
80105695:	c9                   	leave  
80105696:	c3                   	ret    
80105697:	89 f6                	mov    %esi,%esi
80105699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801056a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056a5:	c9                   	leave  
801056a6:	c3                   	ret    
801056a7:	89 f6                	mov    %esi,%esi
801056a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056b0 <sys_fstat>:

int
sys_fstat(void)
{
801056b0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801056b1:	31 c0                	xor    %eax,%eax
{
801056b3:	89 e5                	mov    %esp,%ebp
801056b5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801056b8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801056bb:	e8 00 fe ff ff       	call   801054c0 <argfd.constprop.0>
801056c0:	85 c0                	test   %eax,%eax
801056c2:	78 2c                	js     801056f0 <sys_fstat+0x40>
801056c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056c7:	83 ec 04             	sub    $0x4,%esp
801056ca:	6a 14                	push   $0x14
801056cc:	50                   	push   %eax
801056cd:	6a 01                	push   $0x1
801056cf:	e8 ec fc ff ff       	call   801053c0 <argptr>
801056d4:	83 c4 10             	add    $0x10,%esp
801056d7:	85 c0                	test   %eax,%eax
801056d9:	78 15                	js     801056f0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
801056db:	83 ec 08             	sub    $0x8,%esp
801056de:	ff 75 f4             	pushl  -0xc(%ebp)
801056e1:	ff 75 f0             	pushl  -0x10(%ebp)
801056e4:	e8 67 bc ff ff       	call   80101350 <filestat>
801056e9:	83 c4 10             	add    $0x10,%esp
}
801056ec:	c9                   	leave  
801056ed:	c3                   	ret    
801056ee:	66 90                	xchg   %ax,%ax
    return -1;
801056f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056f5:	c9                   	leave  
801056f6:	c3                   	ret    
801056f7:	89 f6                	mov    %esi,%esi
801056f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105700 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	57                   	push   %edi
80105704:	56                   	push   %esi
80105705:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105706:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105709:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010570c:	50                   	push   %eax
8010570d:	6a 00                	push   $0x0
8010570f:	e8 0c fd ff ff       	call   80105420 <argstr>
80105714:	83 c4 10             	add    $0x10,%esp
80105717:	85 c0                	test   %eax,%eax
80105719:	0f 88 fb 00 00 00    	js     8010581a <sys_link+0x11a>
8010571f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105722:	83 ec 08             	sub    $0x8,%esp
80105725:	50                   	push   %eax
80105726:	6a 01                	push   $0x1
80105728:	e8 f3 fc ff ff       	call   80105420 <argstr>
8010572d:	83 c4 10             	add    $0x10,%esp
80105730:	85 c0                	test   %eax,%eax
80105732:	0f 88 e2 00 00 00    	js     8010581a <sys_link+0x11a>
    return -1;

  begin_op();
80105738:	e8 b3 dc ff ff       	call   801033f0 <begin_op>
  if((ip = namei(old)) == 0){
8010573d:	83 ec 0c             	sub    $0xc,%esp
80105740:	ff 75 d4             	pushl  -0x2c(%ebp)
80105743:	e8 d8 cb ff ff       	call   80102320 <namei>
80105748:	83 c4 10             	add    $0x10,%esp
8010574b:	85 c0                	test   %eax,%eax
8010574d:	89 c3                	mov    %eax,%ebx
8010574f:	0f 84 ea 00 00 00    	je     8010583f <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
80105755:	83 ec 0c             	sub    $0xc,%esp
80105758:	50                   	push   %eax
80105759:	e8 62 c3 ff ff       	call   80101ac0 <ilock>
  if(ip->type == T_DIR){
8010575e:	83 c4 10             	add    $0x10,%esp
80105761:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105766:	0f 84 bb 00 00 00    	je     80105827 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010576c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105771:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105774:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105777:	53                   	push   %ebx
80105778:	e8 93 c2 ff ff       	call   80101a10 <iupdate>
  iunlock(ip);
8010577d:	89 1c 24             	mov    %ebx,(%esp)
80105780:	e8 1b c4 ff ff       	call   80101ba0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105785:	58                   	pop    %eax
80105786:	5a                   	pop    %edx
80105787:	57                   	push   %edi
80105788:	ff 75 d0             	pushl  -0x30(%ebp)
8010578b:	e8 b0 cb ff ff       	call   80102340 <nameiparent>
80105790:	83 c4 10             	add    $0x10,%esp
80105793:	85 c0                	test   %eax,%eax
80105795:	89 c6                	mov    %eax,%esi
80105797:	74 5b                	je     801057f4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105799:	83 ec 0c             	sub    $0xc,%esp
8010579c:	50                   	push   %eax
8010579d:	e8 1e c3 ff ff       	call   80101ac0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801057a2:	83 c4 10             	add    $0x10,%esp
801057a5:	8b 03                	mov    (%ebx),%eax
801057a7:	39 06                	cmp    %eax,(%esi)
801057a9:	75 3d                	jne    801057e8 <sys_link+0xe8>
801057ab:	83 ec 04             	sub    $0x4,%esp
801057ae:	ff 73 04             	pushl  0x4(%ebx)
801057b1:	57                   	push   %edi
801057b2:	56                   	push   %esi
801057b3:	e8 a8 ca ff ff       	call   80102260 <dirlink>
801057b8:	83 c4 10             	add    $0x10,%esp
801057bb:	85 c0                	test   %eax,%eax
801057bd:	78 29                	js     801057e8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
801057bf:	83 ec 0c             	sub    $0xc,%esp
801057c2:	56                   	push   %esi
801057c3:	e8 88 c5 ff ff       	call   80101d50 <iunlockput>
  iput(ip);
801057c8:	89 1c 24             	mov    %ebx,(%esp)
801057cb:	e8 20 c4 ff ff       	call   80101bf0 <iput>

  end_op();
801057d0:	e8 8b dc ff ff       	call   80103460 <end_op>

  return 0;
801057d5:	83 c4 10             	add    $0x10,%esp
801057d8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
801057da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057dd:	5b                   	pop    %ebx
801057de:	5e                   	pop    %esi
801057df:	5f                   	pop    %edi
801057e0:	5d                   	pop    %ebp
801057e1:	c3                   	ret    
801057e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801057e8:	83 ec 0c             	sub    $0xc,%esp
801057eb:	56                   	push   %esi
801057ec:	e8 5f c5 ff ff       	call   80101d50 <iunlockput>
    goto bad;
801057f1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801057f4:	83 ec 0c             	sub    $0xc,%esp
801057f7:	53                   	push   %ebx
801057f8:	e8 c3 c2 ff ff       	call   80101ac0 <ilock>
  ip->nlink--;
801057fd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105802:	89 1c 24             	mov    %ebx,(%esp)
80105805:	e8 06 c2 ff ff       	call   80101a10 <iupdate>
  iunlockput(ip);
8010580a:	89 1c 24             	mov    %ebx,(%esp)
8010580d:	e8 3e c5 ff ff       	call   80101d50 <iunlockput>
  end_op();
80105812:	e8 49 dc ff ff       	call   80103460 <end_op>
  return -1;
80105817:	83 c4 10             	add    $0x10,%esp
}
8010581a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010581d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105822:	5b                   	pop    %ebx
80105823:	5e                   	pop    %esi
80105824:	5f                   	pop    %edi
80105825:	5d                   	pop    %ebp
80105826:	c3                   	ret    
    iunlockput(ip);
80105827:	83 ec 0c             	sub    $0xc,%esp
8010582a:	53                   	push   %ebx
8010582b:	e8 20 c5 ff ff       	call   80101d50 <iunlockput>
    end_op();
80105830:	e8 2b dc ff ff       	call   80103460 <end_op>
    return -1;
80105835:	83 c4 10             	add    $0x10,%esp
80105838:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010583d:	eb 9b                	jmp    801057da <sys_link+0xda>
    end_op();
8010583f:	e8 1c dc ff ff       	call   80103460 <end_op>
    return -1;
80105844:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105849:	eb 8f                	jmp    801057da <sys_link+0xda>
8010584b:	90                   	nop
8010584c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105850 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	57                   	push   %edi
80105854:	56                   	push   %esi
80105855:	53                   	push   %ebx
80105856:	83 ec 1c             	sub    $0x1c,%esp
80105859:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010585c:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105860:	76 3e                	jbe    801058a0 <isdirempty+0x50>
80105862:	bb 20 00 00 00       	mov    $0x20,%ebx
80105867:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010586a:	eb 0c                	jmp    80105878 <isdirempty+0x28>
8010586c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105870:	83 c3 10             	add    $0x10,%ebx
80105873:	3b 5e 58             	cmp    0x58(%esi),%ebx
80105876:	73 28                	jae    801058a0 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105878:	6a 10                	push   $0x10
8010587a:	53                   	push   %ebx
8010587b:	57                   	push   %edi
8010587c:	56                   	push   %esi
8010587d:	e8 1e c5 ff ff       	call   80101da0 <readi>
80105882:	83 c4 10             	add    $0x10,%esp
80105885:	83 f8 10             	cmp    $0x10,%eax
80105888:	75 23                	jne    801058ad <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010588a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010588f:	74 df                	je     80105870 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105891:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105894:	31 c0                	xor    %eax,%eax
}
80105896:	5b                   	pop    %ebx
80105897:	5e                   	pop    %esi
80105898:	5f                   	pop    %edi
80105899:	5d                   	pop    %ebp
8010589a:	c3                   	ret    
8010589b:	90                   	nop
8010589c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
801058a3:	b8 01 00 00 00       	mov    $0x1,%eax
}
801058a8:	5b                   	pop    %ebx
801058a9:	5e                   	pop    %esi
801058aa:	5f                   	pop    %edi
801058ab:	5d                   	pop    %ebp
801058ac:	c3                   	ret    
      panic("isdirempty: readi");
801058ad:	83 ec 0c             	sub    $0xc,%esp
801058b0:	68 3c 91 10 80       	push   $0x8010913c
801058b5:	e8 d6 aa ff ff       	call   80100390 <panic>
801058ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801058c0 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801058c0:	55                   	push   %ebp
801058c1:	89 e5                	mov    %esp,%ebp
801058c3:	57                   	push   %edi
801058c4:	56                   	push   %esi
801058c5:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801058c6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801058c9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801058cc:	50                   	push   %eax
801058cd:	6a 00                	push   $0x0
801058cf:	e8 4c fb ff ff       	call   80105420 <argstr>
801058d4:	83 c4 10             	add    $0x10,%esp
801058d7:	85 c0                	test   %eax,%eax
801058d9:	0f 88 51 01 00 00    	js     80105a30 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
801058df:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801058e2:	e8 09 db ff ff       	call   801033f0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801058e7:	83 ec 08             	sub    $0x8,%esp
801058ea:	53                   	push   %ebx
801058eb:	ff 75 c0             	pushl  -0x40(%ebp)
801058ee:	e8 4d ca ff ff       	call   80102340 <nameiparent>
801058f3:	83 c4 10             	add    $0x10,%esp
801058f6:	85 c0                	test   %eax,%eax
801058f8:	89 c6                	mov    %eax,%esi
801058fa:	0f 84 37 01 00 00    	je     80105a37 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105900:	83 ec 0c             	sub    $0xc,%esp
80105903:	50                   	push   %eax
80105904:	e8 b7 c1 ff ff       	call   80101ac0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105909:	58                   	pop    %eax
8010590a:	5a                   	pop    %edx
8010590b:	68 7d 8a 10 80       	push   $0x80108a7d
80105910:	53                   	push   %ebx
80105911:	e8 ba c6 ff ff       	call   80101fd0 <namecmp>
80105916:	83 c4 10             	add    $0x10,%esp
80105919:	85 c0                	test   %eax,%eax
8010591b:	0f 84 d7 00 00 00    	je     801059f8 <sys_unlink+0x138>
80105921:	83 ec 08             	sub    $0x8,%esp
80105924:	68 7c 8a 10 80       	push   $0x80108a7c
80105929:	53                   	push   %ebx
8010592a:	e8 a1 c6 ff ff       	call   80101fd0 <namecmp>
8010592f:	83 c4 10             	add    $0x10,%esp
80105932:	85 c0                	test   %eax,%eax
80105934:	0f 84 be 00 00 00    	je     801059f8 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010593a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010593d:	83 ec 04             	sub    $0x4,%esp
80105940:	50                   	push   %eax
80105941:	53                   	push   %ebx
80105942:	56                   	push   %esi
80105943:	e8 a8 c6 ff ff       	call   80101ff0 <dirlookup>
80105948:	83 c4 10             	add    $0x10,%esp
8010594b:	85 c0                	test   %eax,%eax
8010594d:	89 c3                	mov    %eax,%ebx
8010594f:	0f 84 a3 00 00 00    	je     801059f8 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
80105955:	83 ec 0c             	sub    $0xc,%esp
80105958:	50                   	push   %eax
80105959:	e8 62 c1 ff ff       	call   80101ac0 <ilock>

  if(ip->nlink < 1)
8010595e:	83 c4 10             	add    $0x10,%esp
80105961:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105966:	0f 8e e4 00 00 00    	jle    80105a50 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
8010596c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105971:	74 65                	je     801059d8 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105973:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105976:	83 ec 04             	sub    $0x4,%esp
80105979:	6a 10                	push   $0x10
8010597b:	6a 00                	push   $0x0
8010597d:	57                   	push   %edi
8010597e:	e8 ed f6 ff ff       	call   80105070 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105983:	6a 10                	push   $0x10
80105985:	ff 75 c4             	pushl  -0x3c(%ebp)
80105988:	57                   	push   %edi
80105989:	56                   	push   %esi
8010598a:	e8 11 c5 ff ff       	call   80101ea0 <writei>
8010598f:	83 c4 20             	add    $0x20,%esp
80105992:	83 f8 10             	cmp    $0x10,%eax
80105995:	0f 85 a8 00 00 00    	jne    80105a43 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010599b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059a0:	74 6e                	je     80105a10 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
801059a2:	83 ec 0c             	sub    $0xc,%esp
801059a5:	56                   	push   %esi
801059a6:	e8 a5 c3 ff ff       	call   80101d50 <iunlockput>

  ip->nlink--;
801059ab:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801059b0:	89 1c 24             	mov    %ebx,(%esp)
801059b3:	e8 58 c0 ff ff       	call   80101a10 <iupdate>
  iunlockput(ip);
801059b8:	89 1c 24             	mov    %ebx,(%esp)
801059bb:	e8 90 c3 ff ff       	call   80101d50 <iunlockput>

  end_op();
801059c0:	e8 9b da ff ff       	call   80103460 <end_op>

  return 0;
801059c5:	83 c4 10             	add    $0x10,%esp
801059c8:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
801059ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059cd:	5b                   	pop    %ebx
801059ce:	5e                   	pop    %esi
801059cf:	5f                   	pop    %edi
801059d0:	5d                   	pop    %ebp
801059d1:	c3                   	ret    
801059d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
801059d8:	83 ec 0c             	sub    $0xc,%esp
801059db:	53                   	push   %ebx
801059dc:	e8 6f fe ff ff       	call   80105850 <isdirempty>
801059e1:	83 c4 10             	add    $0x10,%esp
801059e4:	85 c0                	test   %eax,%eax
801059e6:	75 8b                	jne    80105973 <sys_unlink+0xb3>
    iunlockput(ip);
801059e8:	83 ec 0c             	sub    $0xc,%esp
801059eb:	53                   	push   %ebx
801059ec:	e8 5f c3 ff ff       	call   80101d50 <iunlockput>
    goto bad;
801059f1:	83 c4 10             	add    $0x10,%esp
801059f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
801059f8:	83 ec 0c             	sub    $0xc,%esp
801059fb:	56                   	push   %esi
801059fc:	e8 4f c3 ff ff       	call   80101d50 <iunlockput>
  end_op();
80105a01:	e8 5a da ff ff       	call   80103460 <end_op>
  return -1;
80105a06:	83 c4 10             	add    $0x10,%esp
80105a09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a0e:	eb ba                	jmp    801059ca <sys_unlink+0x10a>
    dp->nlink--;
80105a10:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105a15:	83 ec 0c             	sub    $0xc,%esp
80105a18:	56                   	push   %esi
80105a19:	e8 f2 bf ff ff       	call   80101a10 <iupdate>
80105a1e:	83 c4 10             	add    $0x10,%esp
80105a21:	e9 7c ff ff ff       	jmp    801059a2 <sys_unlink+0xe2>
80105a26:	8d 76 00             	lea    0x0(%esi),%esi
80105a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a35:	eb 93                	jmp    801059ca <sys_unlink+0x10a>
    end_op();
80105a37:	e8 24 da ff ff       	call   80103460 <end_op>
    return -1;
80105a3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a41:	eb 87                	jmp    801059ca <sys_unlink+0x10a>
    panic("unlink: writei");
80105a43:	83 ec 0c             	sub    $0xc,%esp
80105a46:	68 91 8a 10 80       	push   $0x80108a91
80105a4b:	e8 40 a9 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105a50:	83 ec 0c             	sub    $0xc,%esp
80105a53:	68 7f 8a 10 80       	push   $0x80108a7f
80105a58:	e8 33 a9 ff ff       	call   80100390 <panic>
80105a5d:	8d 76 00             	lea    0x0(%esi),%esi

80105a60 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	57                   	push   %edi
80105a64:	56                   	push   %esi
80105a65:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105a66:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105a69:	83 ec 34             	sub    $0x34,%esp
80105a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a6f:	8b 55 10             	mov    0x10(%ebp),%edx
80105a72:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105a75:	56                   	push   %esi
80105a76:	ff 75 08             	pushl  0x8(%ebp)
{
80105a79:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80105a7c:	89 55 d0             	mov    %edx,-0x30(%ebp)
80105a7f:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105a82:	e8 b9 c8 ff ff       	call   80102340 <nameiparent>
80105a87:	83 c4 10             	add    $0x10,%esp
80105a8a:	85 c0                	test   %eax,%eax
80105a8c:	0f 84 4e 01 00 00    	je     80105be0 <create+0x180>
    return 0;
  ilock(dp);
80105a92:	83 ec 0c             	sub    $0xc,%esp
80105a95:	89 c3                	mov    %eax,%ebx
80105a97:	50                   	push   %eax
80105a98:	e8 23 c0 ff ff       	call   80101ac0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105a9d:	83 c4 0c             	add    $0xc,%esp
80105aa0:	6a 00                	push   $0x0
80105aa2:	56                   	push   %esi
80105aa3:	53                   	push   %ebx
80105aa4:	e8 47 c5 ff ff       	call   80101ff0 <dirlookup>
80105aa9:	83 c4 10             	add    $0x10,%esp
80105aac:	85 c0                	test   %eax,%eax
80105aae:	89 c7                	mov    %eax,%edi
80105ab0:	74 3e                	je     80105af0 <create+0x90>
    iunlockput(dp);
80105ab2:	83 ec 0c             	sub    $0xc,%esp
80105ab5:	53                   	push   %ebx
80105ab6:	e8 95 c2 ff ff       	call   80101d50 <iunlockput>
    ilock(ip);
80105abb:	89 3c 24             	mov    %edi,(%esp)
80105abe:	e8 fd bf ff ff       	call   80101ac0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105ac3:	83 c4 10             	add    $0x10,%esp
80105ac6:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105acb:	0f 85 9f 00 00 00    	jne    80105b70 <create+0x110>
80105ad1:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105ad6:	0f 85 94 00 00 00    	jne    80105b70 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105adc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105adf:	89 f8                	mov    %edi,%eax
80105ae1:	5b                   	pop    %ebx
80105ae2:	5e                   	pop    %esi
80105ae3:	5f                   	pop    %edi
80105ae4:	5d                   	pop    %ebp
80105ae5:	c3                   	ret    
80105ae6:	8d 76 00             	lea    0x0(%esi),%esi
80105ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = ialloc(dp->dev, type)) == 0)
80105af0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105af4:	83 ec 08             	sub    $0x8,%esp
80105af7:	50                   	push   %eax
80105af8:	ff 33                	pushl  (%ebx)
80105afa:	e8 51 be ff ff       	call   80101950 <ialloc>
80105aff:	83 c4 10             	add    $0x10,%esp
80105b02:	85 c0                	test   %eax,%eax
80105b04:	89 c7                	mov    %eax,%edi
80105b06:	0f 84 e8 00 00 00    	je     80105bf4 <create+0x194>
  ilock(ip);
80105b0c:	83 ec 0c             	sub    $0xc,%esp
80105b0f:	50                   	push   %eax
80105b10:	e8 ab bf ff ff       	call   80101ac0 <ilock>
  ip->major = major;
80105b15:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105b19:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80105b1d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105b21:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105b25:	b8 01 00 00 00       	mov    $0x1,%eax
80105b2a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80105b2e:	89 3c 24             	mov    %edi,(%esp)
80105b31:	e8 da be ff ff       	call   80101a10 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105b36:	83 c4 10             	add    $0x10,%esp
80105b39:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105b3e:	74 50                	je     80105b90 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105b40:	83 ec 04             	sub    $0x4,%esp
80105b43:	ff 77 04             	pushl  0x4(%edi)
80105b46:	56                   	push   %esi
80105b47:	53                   	push   %ebx
80105b48:	e8 13 c7 ff ff       	call   80102260 <dirlink>
80105b4d:	83 c4 10             	add    $0x10,%esp
80105b50:	85 c0                	test   %eax,%eax
80105b52:	0f 88 8f 00 00 00    	js     80105be7 <create+0x187>
  iunlockput(dp);
80105b58:	83 ec 0c             	sub    $0xc,%esp
80105b5b:	53                   	push   %ebx
80105b5c:	e8 ef c1 ff ff       	call   80101d50 <iunlockput>
  return ip;
80105b61:	83 c4 10             	add    $0x10,%esp
}
80105b64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b67:	89 f8                	mov    %edi,%eax
80105b69:	5b                   	pop    %ebx
80105b6a:	5e                   	pop    %esi
80105b6b:	5f                   	pop    %edi
80105b6c:	5d                   	pop    %ebp
80105b6d:	c3                   	ret    
80105b6e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105b70:	83 ec 0c             	sub    $0xc,%esp
80105b73:	57                   	push   %edi
    return 0;
80105b74:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105b76:	e8 d5 c1 ff ff       	call   80101d50 <iunlockput>
    return 0;
80105b7b:	83 c4 10             	add    $0x10,%esp
}
80105b7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b81:	89 f8                	mov    %edi,%eax
80105b83:	5b                   	pop    %ebx
80105b84:	5e                   	pop    %esi
80105b85:	5f                   	pop    %edi
80105b86:	5d                   	pop    %ebp
80105b87:	c3                   	ret    
80105b88:	90                   	nop
80105b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105b90:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105b95:	83 ec 0c             	sub    $0xc,%esp
80105b98:	53                   	push   %ebx
80105b99:	e8 72 be ff ff       	call   80101a10 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105b9e:	83 c4 0c             	add    $0xc,%esp
80105ba1:	ff 77 04             	pushl  0x4(%edi)
80105ba4:	68 7d 8a 10 80       	push   $0x80108a7d
80105ba9:	57                   	push   %edi
80105baa:	e8 b1 c6 ff ff       	call   80102260 <dirlink>
80105baf:	83 c4 10             	add    $0x10,%esp
80105bb2:	85 c0                	test   %eax,%eax
80105bb4:	78 1c                	js     80105bd2 <create+0x172>
80105bb6:	83 ec 04             	sub    $0x4,%esp
80105bb9:	ff 73 04             	pushl  0x4(%ebx)
80105bbc:	68 7c 8a 10 80       	push   $0x80108a7c
80105bc1:	57                   	push   %edi
80105bc2:	e8 99 c6 ff ff       	call   80102260 <dirlink>
80105bc7:	83 c4 10             	add    $0x10,%esp
80105bca:	85 c0                	test   %eax,%eax
80105bcc:	0f 89 6e ff ff ff    	jns    80105b40 <create+0xe0>
      panic("create dots");
80105bd2:	83 ec 0c             	sub    $0xc,%esp
80105bd5:	68 5d 91 10 80       	push   $0x8010915d
80105bda:	e8 b1 a7 ff ff       	call   80100390 <panic>
80105bdf:	90                   	nop
    return 0;
80105be0:	31 ff                	xor    %edi,%edi
80105be2:	e9 f5 fe ff ff       	jmp    80105adc <create+0x7c>
    panic("create: dirlink");
80105be7:	83 ec 0c             	sub    $0xc,%esp
80105bea:	68 69 91 10 80       	push   $0x80109169
80105bef:	e8 9c a7 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105bf4:	83 ec 0c             	sub    $0xc,%esp
80105bf7:	68 4e 91 10 80       	push   $0x8010914e
80105bfc:	e8 8f a7 ff ff       	call   80100390 <panic>
80105c01:	eb 0d                	jmp    80105c10 <sys_open>
80105c03:	90                   	nop
80105c04:	90                   	nop
80105c05:	90                   	nop
80105c06:	90                   	nop
80105c07:	90                   	nop
80105c08:	90                   	nop
80105c09:	90                   	nop
80105c0a:	90                   	nop
80105c0b:	90                   	nop
80105c0c:	90                   	nop
80105c0d:	90                   	nop
80105c0e:	90                   	nop
80105c0f:	90                   	nop

80105c10 <sys_open>:

int
sys_open(void)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	57                   	push   %edi
80105c14:	56                   	push   %esi
80105c15:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105c16:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105c19:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105c1c:	50                   	push   %eax
80105c1d:	6a 00                	push   $0x0
80105c1f:	e8 fc f7 ff ff       	call   80105420 <argstr>
80105c24:	83 c4 10             	add    $0x10,%esp
80105c27:	85 c0                	test   %eax,%eax
80105c29:	0f 88 1d 01 00 00    	js     80105d4c <sys_open+0x13c>
80105c2f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c32:	83 ec 08             	sub    $0x8,%esp
80105c35:	50                   	push   %eax
80105c36:	6a 01                	push   $0x1
80105c38:	e8 33 f7 ff ff       	call   80105370 <argint>
80105c3d:	83 c4 10             	add    $0x10,%esp
80105c40:	85 c0                	test   %eax,%eax
80105c42:	0f 88 04 01 00 00    	js     80105d4c <sys_open+0x13c>
    return -1;

  begin_op();
80105c48:	e8 a3 d7 ff ff       	call   801033f0 <begin_op>

  if(omode & O_CREATE){
80105c4d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105c51:	0f 85 a9 00 00 00    	jne    80105d00 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105c57:	83 ec 0c             	sub    $0xc,%esp
80105c5a:	ff 75 e0             	pushl  -0x20(%ebp)
80105c5d:	e8 be c6 ff ff       	call   80102320 <namei>
80105c62:	83 c4 10             	add    $0x10,%esp
80105c65:	85 c0                	test   %eax,%eax
80105c67:	89 c6                	mov    %eax,%esi
80105c69:	0f 84 ac 00 00 00    	je     80105d1b <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
80105c6f:	83 ec 0c             	sub    $0xc,%esp
80105c72:	50                   	push   %eax
80105c73:	e8 48 be ff ff       	call   80101ac0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105c78:	83 c4 10             	add    $0x10,%esp
80105c7b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105c80:	0f 84 aa 00 00 00    	je     80105d30 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105c86:	e8 35 b5 ff ff       	call   801011c0 <filealloc>
80105c8b:	85 c0                	test   %eax,%eax
80105c8d:	89 c7                	mov    %eax,%edi
80105c8f:	0f 84 a6 00 00 00    	je     80105d3b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105c95:	e8 36 e4 ff ff       	call   801040d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105c9a:	31 db                	xor    %ebx,%ebx
80105c9c:	eb 0e                	jmp    80105cac <sys_open+0x9c>
80105c9e:	66 90                	xchg   %ax,%ax
80105ca0:	83 c3 01             	add    $0x1,%ebx
80105ca3:	83 fb 10             	cmp    $0x10,%ebx
80105ca6:	0f 84 ac 00 00 00    	je     80105d58 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105cac:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105cb0:	85 d2                	test   %edx,%edx
80105cb2:	75 ec                	jne    80105ca0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105cb4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105cb7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105cbb:	56                   	push   %esi
80105cbc:	e8 df be ff ff       	call   80101ba0 <iunlock>
  end_op();
80105cc1:	e8 9a d7 ff ff       	call   80103460 <end_op>

  f->type = FD_INODE;
80105cc6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105ccc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ccf:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105cd2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105cd5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105cdc:	89 d0                	mov    %edx,%eax
80105cde:	f7 d0                	not    %eax
80105ce0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ce3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105ce6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ce9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105ced:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cf0:	89 d8                	mov    %ebx,%eax
80105cf2:	5b                   	pop    %ebx
80105cf3:	5e                   	pop    %esi
80105cf4:	5f                   	pop    %edi
80105cf5:	5d                   	pop    %ebp
80105cf6:	c3                   	ret    
80105cf7:	89 f6                	mov    %esi,%esi
80105cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105d00:	6a 00                	push   $0x0
80105d02:	6a 00                	push   $0x0
80105d04:	6a 02                	push   $0x2
80105d06:	ff 75 e0             	pushl  -0x20(%ebp)
80105d09:	e8 52 fd ff ff       	call   80105a60 <create>
    if(ip == 0){
80105d0e:	83 c4 10             	add    $0x10,%esp
80105d11:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105d13:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105d15:	0f 85 6b ff ff ff    	jne    80105c86 <sys_open+0x76>
      end_op();
80105d1b:	e8 40 d7 ff ff       	call   80103460 <end_op>
      return -1;
80105d20:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d25:	eb c6                	jmp    80105ced <sys_open+0xdd>
80105d27:	89 f6                	mov    %esi,%esi
80105d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105d30:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105d33:	85 c9                	test   %ecx,%ecx
80105d35:	0f 84 4b ff ff ff    	je     80105c86 <sys_open+0x76>
    iunlockput(ip);
80105d3b:	83 ec 0c             	sub    $0xc,%esp
80105d3e:	56                   	push   %esi
80105d3f:	e8 0c c0 ff ff       	call   80101d50 <iunlockput>
    end_op();
80105d44:	e8 17 d7 ff ff       	call   80103460 <end_op>
    return -1;
80105d49:	83 c4 10             	add    $0x10,%esp
80105d4c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d51:	eb 9a                	jmp    80105ced <sys_open+0xdd>
80105d53:	90                   	nop
80105d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105d58:	83 ec 0c             	sub    $0xc,%esp
80105d5b:	57                   	push   %edi
80105d5c:	e8 1f b5 ff ff       	call   80101280 <fileclose>
80105d61:	83 c4 10             	add    $0x10,%esp
80105d64:	eb d5                	jmp    80105d3b <sys_open+0x12b>
80105d66:	8d 76 00             	lea    0x0(%esi),%esi
80105d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d70 <sys_mkdir>:

int
sys_mkdir(void)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105d76:	e8 75 d6 ff ff       	call   801033f0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105d7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d7e:	83 ec 08             	sub    $0x8,%esp
80105d81:	50                   	push   %eax
80105d82:	6a 00                	push   $0x0
80105d84:	e8 97 f6 ff ff       	call   80105420 <argstr>
80105d89:	83 c4 10             	add    $0x10,%esp
80105d8c:	85 c0                	test   %eax,%eax
80105d8e:	78 30                	js     80105dc0 <sys_mkdir+0x50>
80105d90:	6a 00                	push   $0x0
80105d92:	6a 00                	push   $0x0
80105d94:	6a 01                	push   $0x1
80105d96:	ff 75 f4             	pushl  -0xc(%ebp)
80105d99:	e8 c2 fc ff ff       	call   80105a60 <create>
80105d9e:	83 c4 10             	add    $0x10,%esp
80105da1:	85 c0                	test   %eax,%eax
80105da3:	74 1b                	je     80105dc0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105da5:	83 ec 0c             	sub    $0xc,%esp
80105da8:	50                   	push   %eax
80105da9:	e8 a2 bf ff ff       	call   80101d50 <iunlockput>
  end_op();
80105dae:	e8 ad d6 ff ff       	call   80103460 <end_op>
  return 0;
80105db3:	83 c4 10             	add    $0x10,%esp
80105db6:	31 c0                	xor    %eax,%eax
}
80105db8:	c9                   	leave  
80105db9:	c3                   	ret    
80105dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105dc0:	e8 9b d6 ff ff       	call   80103460 <end_op>
    return -1;
80105dc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dca:	c9                   	leave  
80105dcb:	c3                   	ret    
80105dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105dd0 <sys_mknod>:

int
sys_mknod(void)
{
80105dd0:	55                   	push   %ebp
80105dd1:	89 e5                	mov    %esp,%ebp
80105dd3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105dd6:	e8 15 d6 ff ff       	call   801033f0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105ddb:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105dde:	83 ec 08             	sub    $0x8,%esp
80105de1:	50                   	push   %eax
80105de2:	6a 00                	push   $0x0
80105de4:	e8 37 f6 ff ff       	call   80105420 <argstr>
80105de9:	83 c4 10             	add    $0x10,%esp
80105dec:	85 c0                	test   %eax,%eax
80105dee:	78 60                	js     80105e50 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105df0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105df3:	83 ec 08             	sub    $0x8,%esp
80105df6:	50                   	push   %eax
80105df7:	6a 01                	push   $0x1
80105df9:	e8 72 f5 ff ff       	call   80105370 <argint>
  if((argstr(0, &path)) < 0 ||
80105dfe:	83 c4 10             	add    $0x10,%esp
80105e01:	85 c0                	test   %eax,%eax
80105e03:	78 4b                	js     80105e50 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105e05:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e08:	83 ec 08             	sub    $0x8,%esp
80105e0b:	50                   	push   %eax
80105e0c:	6a 02                	push   $0x2
80105e0e:	e8 5d f5 ff ff       	call   80105370 <argint>
     argint(1, &major) < 0 ||
80105e13:	83 c4 10             	add    $0x10,%esp
80105e16:	85 c0                	test   %eax,%eax
80105e18:	78 36                	js     80105e50 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105e1a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105e1e:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
80105e1f:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
80105e23:	50                   	push   %eax
80105e24:	6a 03                	push   $0x3
80105e26:	ff 75 ec             	pushl  -0x14(%ebp)
80105e29:	e8 32 fc ff ff       	call   80105a60 <create>
80105e2e:	83 c4 10             	add    $0x10,%esp
80105e31:	85 c0                	test   %eax,%eax
80105e33:	74 1b                	je     80105e50 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105e35:	83 ec 0c             	sub    $0xc,%esp
80105e38:	50                   	push   %eax
80105e39:	e8 12 bf ff ff       	call   80101d50 <iunlockput>
  end_op();
80105e3e:	e8 1d d6 ff ff       	call   80103460 <end_op>
  return 0;
80105e43:	83 c4 10             	add    $0x10,%esp
80105e46:	31 c0                	xor    %eax,%eax
}
80105e48:	c9                   	leave  
80105e49:	c3                   	ret    
80105e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105e50:	e8 0b d6 ff ff       	call   80103460 <end_op>
    return -1;
80105e55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e5a:	c9                   	leave  
80105e5b:	c3                   	ret    
80105e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e60 <sys_chdir>:

int
sys_chdir(void)
{
80105e60:	55                   	push   %ebp
80105e61:	89 e5                	mov    %esp,%ebp
80105e63:	56                   	push   %esi
80105e64:	53                   	push   %ebx
80105e65:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105e68:	e8 63 e2 ff ff       	call   801040d0 <myproc>
80105e6d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105e6f:	e8 7c d5 ff ff       	call   801033f0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105e74:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e77:	83 ec 08             	sub    $0x8,%esp
80105e7a:	50                   	push   %eax
80105e7b:	6a 00                	push   $0x0
80105e7d:	e8 9e f5 ff ff       	call   80105420 <argstr>
80105e82:	83 c4 10             	add    $0x10,%esp
80105e85:	85 c0                	test   %eax,%eax
80105e87:	78 77                	js     80105f00 <sys_chdir+0xa0>
80105e89:	83 ec 0c             	sub    $0xc,%esp
80105e8c:	ff 75 f4             	pushl  -0xc(%ebp)
80105e8f:	e8 8c c4 ff ff       	call   80102320 <namei>
80105e94:	83 c4 10             	add    $0x10,%esp
80105e97:	85 c0                	test   %eax,%eax
80105e99:	89 c3                	mov    %eax,%ebx
80105e9b:	74 63                	je     80105f00 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105e9d:	83 ec 0c             	sub    $0xc,%esp
80105ea0:	50                   	push   %eax
80105ea1:	e8 1a bc ff ff       	call   80101ac0 <ilock>
  if(ip->type != T_DIR){
80105ea6:	83 c4 10             	add    $0x10,%esp
80105ea9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105eae:	75 30                	jne    80105ee0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105eb0:	83 ec 0c             	sub    $0xc,%esp
80105eb3:	53                   	push   %ebx
80105eb4:	e8 e7 bc ff ff       	call   80101ba0 <iunlock>
  iput(curproc->cwd);
80105eb9:	58                   	pop    %eax
80105eba:	ff 76 68             	pushl  0x68(%esi)
80105ebd:	e8 2e bd ff ff       	call   80101bf0 <iput>
  end_op();
80105ec2:	e8 99 d5 ff ff       	call   80103460 <end_op>
  curproc->cwd = ip;
80105ec7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105eca:	83 c4 10             	add    $0x10,%esp
80105ecd:	31 c0                	xor    %eax,%eax
}
80105ecf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ed2:	5b                   	pop    %ebx
80105ed3:	5e                   	pop    %esi
80105ed4:	5d                   	pop    %ebp
80105ed5:	c3                   	ret    
80105ed6:	8d 76 00             	lea    0x0(%esi),%esi
80105ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105ee0:	83 ec 0c             	sub    $0xc,%esp
80105ee3:	53                   	push   %ebx
80105ee4:	e8 67 be ff ff       	call   80101d50 <iunlockput>
    end_op();
80105ee9:	e8 72 d5 ff ff       	call   80103460 <end_op>
    return -1;
80105eee:	83 c4 10             	add    $0x10,%esp
80105ef1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ef6:	eb d7                	jmp    80105ecf <sys_chdir+0x6f>
80105ef8:	90                   	nop
80105ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105f00:	e8 5b d5 ff ff       	call   80103460 <end_op>
    return -1;
80105f05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f0a:	eb c3                	jmp    80105ecf <sys_chdir+0x6f>
80105f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f10 <sys_exec>:

int
sys_exec(void)
{
80105f10:	55                   	push   %ebp
80105f11:	89 e5                	mov    %esp,%ebp
80105f13:	57                   	push   %edi
80105f14:	56                   	push   %esi
80105f15:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105f16:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105f1c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105f22:	50                   	push   %eax
80105f23:	6a 00                	push   $0x0
80105f25:	e8 f6 f4 ff ff       	call   80105420 <argstr>
80105f2a:	83 c4 10             	add    $0x10,%esp
80105f2d:	85 c0                	test   %eax,%eax
80105f2f:	0f 88 87 00 00 00    	js     80105fbc <sys_exec+0xac>
80105f35:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105f3b:	83 ec 08             	sub    $0x8,%esp
80105f3e:	50                   	push   %eax
80105f3f:	6a 01                	push   $0x1
80105f41:	e8 2a f4 ff ff       	call   80105370 <argint>
80105f46:	83 c4 10             	add    $0x10,%esp
80105f49:	85 c0                	test   %eax,%eax
80105f4b:	78 6f                	js     80105fbc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105f4d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105f53:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105f56:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105f58:	68 80 00 00 00       	push   $0x80
80105f5d:	6a 00                	push   $0x0
80105f5f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105f65:	50                   	push   %eax
80105f66:	e8 05 f1 ff ff       	call   80105070 <memset>
80105f6b:	83 c4 10             	add    $0x10,%esp
80105f6e:	eb 2c                	jmp    80105f9c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105f70:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105f76:	85 c0                	test   %eax,%eax
80105f78:	74 56                	je     80105fd0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105f7a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105f80:	83 ec 08             	sub    $0x8,%esp
80105f83:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105f86:	52                   	push   %edx
80105f87:	50                   	push   %eax
80105f88:	e8 73 f3 ff ff       	call   80105300 <fetchstr>
80105f8d:	83 c4 10             	add    $0x10,%esp
80105f90:	85 c0                	test   %eax,%eax
80105f92:	78 28                	js     80105fbc <sys_exec+0xac>
  for(i=0;; i++){
80105f94:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105f97:	83 fb 20             	cmp    $0x20,%ebx
80105f9a:	74 20                	je     80105fbc <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105f9c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105fa2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105fa9:	83 ec 08             	sub    $0x8,%esp
80105fac:	57                   	push   %edi
80105fad:	01 f0                	add    %esi,%eax
80105faf:	50                   	push   %eax
80105fb0:	e8 0b f3 ff ff       	call   801052c0 <fetchint>
80105fb5:	83 c4 10             	add    $0x10,%esp
80105fb8:	85 c0                	test   %eax,%eax
80105fba:	79 b4                	jns    80105f70 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105fbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105fbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fc4:	5b                   	pop    %ebx
80105fc5:	5e                   	pop    %esi
80105fc6:	5f                   	pop    %edi
80105fc7:	5d                   	pop    %ebp
80105fc8:	c3                   	ret    
80105fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105fd0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105fd6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105fd9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105fe0:	00 00 00 00 
  return exec(path, argv);
80105fe4:	50                   	push   %eax
80105fe5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105feb:	e8 c0 aa ff ff       	call   80100ab0 <exec>
80105ff0:	83 c4 10             	add    $0x10,%esp
}
80105ff3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ff6:	5b                   	pop    %ebx
80105ff7:	5e                   	pop    %esi
80105ff8:	5f                   	pop    %edi
80105ff9:	5d                   	pop    %ebp
80105ffa:	c3                   	ret    
80105ffb:	90                   	nop
80105ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106000 <sys_pipe>:

int
sys_pipe(void)
{
80106000:	55                   	push   %ebp
80106001:	89 e5                	mov    %esp,%ebp
80106003:	57                   	push   %edi
80106004:	56                   	push   %esi
80106005:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106006:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106009:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010600c:	6a 08                	push   $0x8
8010600e:	50                   	push   %eax
8010600f:	6a 00                	push   $0x0
80106011:	e8 aa f3 ff ff       	call   801053c0 <argptr>
80106016:	83 c4 10             	add    $0x10,%esp
80106019:	85 c0                	test   %eax,%eax
8010601b:	0f 88 ae 00 00 00    	js     801060cf <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106021:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106024:	83 ec 08             	sub    $0x8,%esp
80106027:	50                   	push   %eax
80106028:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010602b:	50                   	push   %eax
8010602c:	e8 5f da ff ff       	call   80103a90 <pipealloc>
80106031:	83 c4 10             	add    $0x10,%esp
80106034:	85 c0                	test   %eax,%eax
80106036:	0f 88 93 00 00 00    	js     801060cf <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010603c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010603f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106041:	e8 8a e0 ff ff       	call   801040d0 <myproc>
80106046:	eb 10                	jmp    80106058 <sys_pipe+0x58>
80106048:	90                   	nop
80106049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80106050:	83 c3 01             	add    $0x1,%ebx
80106053:	83 fb 10             	cmp    $0x10,%ebx
80106056:	74 60                	je     801060b8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80106058:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010605c:	85 f6                	test   %esi,%esi
8010605e:	75 f0                	jne    80106050 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80106060:	8d 73 08             	lea    0x8(%ebx),%esi
80106063:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106067:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010606a:	e8 61 e0 ff ff       	call   801040d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010606f:	31 d2                	xor    %edx,%edx
80106071:	eb 0d                	jmp    80106080 <sys_pipe+0x80>
80106073:	90                   	nop
80106074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106078:	83 c2 01             	add    $0x1,%edx
8010607b:	83 fa 10             	cmp    $0x10,%edx
8010607e:	74 28                	je     801060a8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80106080:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80106084:	85 c9                	test   %ecx,%ecx
80106086:	75 f0                	jne    80106078 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80106088:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010608c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010608f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106091:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106094:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106097:	31 c0                	xor    %eax,%eax
}
80106099:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010609c:	5b                   	pop    %ebx
8010609d:	5e                   	pop    %esi
8010609e:	5f                   	pop    %edi
8010609f:	5d                   	pop    %ebp
801060a0:	c3                   	ret    
801060a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
801060a8:	e8 23 e0 ff ff       	call   801040d0 <myproc>
801060ad:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801060b4:	00 
801060b5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
801060b8:	83 ec 0c             	sub    $0xc,%esp
801060bb:	ff 75 e0             	pushl  -0x20(%ebp)
801060be:	e8 bd b1 ff ff       	call   80101280 <fileclose>
    fileclose(wf);
801060c3:	58                   	pop    %eax
801060c4:	ff 75 e4             	pushl  -0x1c(%ebp)
801060c7:	e8 b4 b1 ff ff       	call   80101280 <fileclose>
    return -1;
801060cc:	83 c4 10             	add    $0x10,%esp
801060cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060d4:	eb c3                	jmp    80106099 <sys_pipe+0x99>
801060d6:	66 90                	xchg   %ax,%ax
801060d8:	66 90                	xchg   %ax,%ax
801060da:	66 90                	xchg   %ax,%ax
801060dc:	66 90                	xchg   %ax,%ax
801060de:	66 90                	xchg   %ax,%ax

801060e0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801060e0:	55                   	push   %ebp
801060e1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801060e3:	5d                   	pop    %ebp
  return fork();
801060e4:	e9 b7 e1 ff ff       	jmp    801042a0 <fork>
801060e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060f0 <sys_exit>:

int
sys_exit(void)
{
801060f0:	55                   	push   %ebp
801060f1:	89 e5                	mov    %esp,%ebp
801060f3:	83 ec 08             	sub    $0x8,%esp
  exit();
801060f6:	e8 b5 e5 ff ff       	call   801046b0 <exit>
  return 0;  // not reached
}
801060fb:	31 c0                	xor    %eax,%eax
801060fd:	c9                   	leave  
801060fe:	c3                   	ret    
801060ff:	90                   	nop

80106100 <sys_wait>:

int
sys_wait(void)
{
80106100:	55                   	push   %ebp
80106101:	89 e5                	mov    %esp,%ebp
  return wait();
}
80106103:	5d                   	pop    %ebp
  return wait();
80106104:	e9 57 e8 ff ff       	jmp    80104960 <wait>
80106109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106110 <sys_kill>:

int
sys_kill(void)
{
80106110:	55                   	push   %ebp
80106111:	89 e5                	mov    %esp,%ebp
80106113:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106116:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106119:	50                   	push   %eax
8010611a:	6a 00                	push   $0x0
8010611c:	e8 4f f2 ff ff       	call   80105370 <argint>
80106121:	83 c4 10             	add    $0x10,%esp
80106124:	85 c0                	test   %eax,%eax
80106126:	78 18                	js     80106140 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106128:	83 ec 0c             	sub    $0xc,%esp
8010612b:	ff 75 f4             	pushl  -0xc(%ebp)
8010612e:	e8 1d ea ff ff       	call   80104b50 <kill>
80106133:	83 c4 10             	add    $0x10,%esp
}
80106136:	c9                   	leave  
80106137:	c3                   	ret    
80106138:	90                   	nop
80106139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106145:	c9                   	leave  
80106146:	c3                   	ret    
80106147:	89 f6                	mov    %esi,%esi
80106149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106150 <sys_getpid>:

int
sys_getpid(void)
{
80106150:	55                   	push   %ebp
80106151:	89 e5                	mov    %esp,%ebp
80106153:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106156:	e8 75 df ff ff       	call   801040d0 <myproc>
8010615b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010615e:	c9                   	leave  
8010615f:	c3                   	ret    

80106160 <sys_sbrk>:

int
sys_sbrk(void)
{
80106160:	55                   	push   %ebp
80106161:	89 e5                	mov    %esp,%ebp
80106163:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106164:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106167:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010616a:	50                   	push   %eax
8010616b:	6a 00                	push   $0x0
8010616d:	e8 fe f1 ff ff       	call   80105370 <argint>
80106172:	83 c4 10             	add    $0x10,%esp
80106175:	85 c0                	test   %eax,%eax
80106177:	78 27                	js     801061a0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106179:	e8 52 df ff ff       	call   801040d0 <myproc>
  if(growproc(n) < 0)
8010617e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106181:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106183:	ff 75 f4             	pushl  -0xc(%ebp)
80106186:	e8 65 e0 ff ff       	call   801041f0 <growproc>
8010618b:	83 c4 10             	add    $0x10,%esp
8010618e:	85 c0                	test   %eax,%eax
80106190:	78 0e                	js     801061a0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106192:	89 d8                	mov    %ebx,%eax
80106194:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106197:	c9                   	leave  
80106198:	c3                   	ret    
80106199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801061a0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801061a5:	eb eb                	jmp    80106192 <sys_sbrk+0x32>
801061a7:	89 f6                	mov    %esi,%esi
801061a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801061b0 <sys_sleep>:

int
sys_sleep(void)
{
801061b0:	55                   	push   %ebp
801061b1:	89 e5                	mov    %esp,%ebp
801061b3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801061b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801061b7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801061ba:	50                   	push   %eax
801061bb:	6a 00                	push   $0x0
801061bd:	e8 ae f1 ff ff       	call   80105370 <argint>
801061c2:	83 c4 10             	add    $0x10,%esp
801061c5:	85 c0                	test   %eax,%eax
801061c7:	0f 88 8a 00 00 00    	js     80106257 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801061cd:	83 ec 0c             	sub    $0xc,%esp
801061d0:	68 e0 21 13 80       	push   $0x801321e0
801061d5:	e8 86 ed ff ff       	call   80104f60 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801061da:	8b 55 f4             	mov    -0xc(%ebp),%edx
801061dd:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801061e0:	8b 1d 20 2a 13 80    	mov    0x80132a20,%ebx
  while(ticks - ticks0 < n){
801061e6:	85 d2                	test   %edx,%edx
801061e8:	75 27                	jne    80106211 <sys_sleep+0x61>
801061ea:	eb 54                	jmp    80106240 <sys_sleep+0x90>
801061ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801061f0:	83 ec 08             	sub    $0x8,%esp
801061f3:	68 e0 21 13 80       	push   $0x801321e0
801061f8:	68 20 2a 13 80       	push   $0x80132a20
801061fd:	e8 9e e6 ff ff       	call   801048a0 <sleep>
  while(ticks - ticks0 < n){
80106202:	a1 20 2a 13 80       	mov    0x80132a20,%eax
80106207:	83 c4 10             	add    $0x10,%esp
8010620a:	29 d8                	sub    %ebx,%eax
8010620c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010620f:	73 2f                	jae    80106240 <sys_sleep+0x90>
    if(myproc()->killed){
80106211:	e8 ba de ff ff       	call   801040d0 <myproc>
80106216:	8b 40 24             	mov    0x24(%eax),%eax
80106219:	85 c0                	test   %eax,%eax
8010621b:	74 d3                	je     801061f0 <sys_sleep+0x40>
      release(&tickslock);
8010621d:	83 ec 0c             	sub    $0xc,%esp
80106220:	68 e0 21 13 80       	push   $0x801321e0
80106225:	e8 f6 ed ff ff       	call   80105020 <release>
      return -1;
8010622a:	83 c4 10             	add    $0x10,%esp
8010622d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80106232:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106235:	c9                   	leave  
80106236:	c3                   	ret    
80106237:	89 f6                	mov    %esi,%esi
80106239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80106240:	83 ec 0c             	sub    $0xc,%esp
80106243:	68 e0 21 13 80       	push   $0x801321e0
80106248:	e8 d3 ed ff ff       	call   80105020 <release>
  return 0;
8010624d:	83 c4 10             	add    $0x10,%esp
80106250:	31 c0                	xor    %eax,%eax
}
80106252:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106255:	c9                   	leave  
80106256:	c3                   	ret    
    return -1;
80106257:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010625c:	eb f4                	jmp    80106252 <sys_sleep+0xa2>
8010625e:	66 90                	xchg   %ax,%ax

80106260 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106260:	55                   	push   %ebp
80106261:	89 e5                	mov    %esp,%ebp
80106263:	53                   	push   %ebx
80106264:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106267:	68 e0 21 13 80       	push   $0x801321e0
8010626c:	e8 ef ec ff ff       	call   80104f60 <acquire>
  xticks = ticks;
80106271:	8b 1d 20 2a 13 80    	mov    0x80132a20,%ebx
  release(&tickslock);
80106277:	c7 04 24 e0 21 13 80 	movl   $0x801321e0,(%esp)
8010627e:	e8 9d ed ff ff       	call   80105020 <release>
  return xticks;
}
80106283:	89 d8                	mov    %ebx,%eax
80106285:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106288:	c9                   	leave  
80106289:	c3                   	ret    
8010628a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106290 <sys_get_number_of_free_pages>:

int sys_get_number_of_free_pages(void){
80106290:	55                   	push   %ebp
80106291:	89 e5                	mov    %esp,%ebp
  return sys_get_number_of_free_pages_impl();
}
80106293:	5d                   	pop    %ebp
  return sys_get_number_of_free_pages_impl();
80106294:	e9 d7 df ff ff       	jmp    80104270 <sys_get_number_of_free_pages_impl>

80106299 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106299:	1e                   	push   %ds
  pushl %es
8010629a:	06                   	push   %es
  pushl %fs
8010629b:	0f a0                	push   %fs
  pushl %gs
8010629d:	0f a8                	push   %gs
  pushal
8010629f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801062a0:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801062a4:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801062a6:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801062a8:	54                   	push   %esp
  call trap
801062a9:	e8 c2 00 00 00       	call   80106370 <trap>
  addl $4, %esp
801062ae:	83 c4 04             	add    $0x4,%esp

801062b1 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801062b1:	61                   	popa   
  popl %gs
801062b2:	0f a9                	pop    %gs
  popl %fs
801062b4:	0f a1                	pop    %fs
  popl %es
801062b6:	07                   	pop    %es
  popl %ds
801062b7:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801062b8:	83 c4 08             	add    $0x8,%esp
  iret
801062bb:	cf                   	iret   
801062bc:	66 90                	xchg   %ax,%ax
801062be:	66 90                	xchg   %ax,%ax

801062c0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801062c0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801062c1:	31 c0                	xor    %eax,%eax
{
801062c3:	89 e5                	mov    %esp,%ebp
801062c5:	83 ec 08             	sub    $0x8,%esp
801062c8:	90                   	nop
801062c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801062d0:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
801062d7:	c7 04 c5 22 22 13 80 	movl   $0x8e000008,-0x7fecddde(,%eax,8)
801062de:	08 00 00 8e 
801062e2:	66 89 14 c5 20 22 13 	mov    %dx,-0x7fecdde0(,%eax,8)
801062e9:	80 
801062ea:	c1 ea 10             	shr    $0x10,%edx
801062ed:	66 89 14 c5 26 22 13 	mov    %dx,-0x7fecddda(,%eax,8)
801062f4:	80 
  for(i = 0; i < 256; i++)
801062f5:	83 c0 01             	add    $0x1,%eax
801062f8:	3d 00 01 00 00       	cmp    $0x100,%eax
801062fd:	75 d1                	jne    801062d0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801062ff:	a1 08 c1 10 80       	mov    0x8010c108,%eax

  initlock(&tickslock, "time");
80106304:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106307:	c7 05 22 24 13 80 08 	movl   $0xef000008,0x80132422
8010630e:	00 00 ef 
  initlock(&tickslock, "time");
80106311:	68 79 91 10 80       	push   $0x80109179
80106316:	68 e0 21 13 80       	push   $0x801321e0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010631b:	66 a3 20 24 13 80    	mov    %ax,0x80132420
80106321:	c1 e8 10             	shr    $0x10,%eax
80106324:	66 a3 26 24 13 80    	mov    %ax,0x80132426
  initlock(&tickslock, "time");
8010632a:	e8 f1 ea ff ff       	call   80104e20 <initlock>
}
8010632f:	83 c4 10             	add    $0x10,%esp
80106332:	c9                   	leave  
80106333:	c3                   	ret    
80106334:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010633a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106340 <idtinit>:

void
idtinit(void)
{
80106340:	55                   	push   %ebp
  pd[0] = size-1;
80106341:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106346:	89 e5                	mov    %esp,%ebp
80106348:	83 ec 10             	sub    $0x10,%esp
8010634b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010634f:	b8 20 22 13 80       	mov    $0x80132220,%eax
80106354:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106358:	c1 e8 10             	shr    $0x10,%eax
8010635b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010635f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106362:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106365:	c9                   	leave  
80106366:	c3                   	ret    
80106367:	89 f6                	mov    %esi,%esi
80106369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106370 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106370:	55                   	push   %ebp
80106371:	89 e5                	mov    %esp,%ebp
80106373:	57                   	push   %edi
80106374:	56                   	push   %esi
80106375:	53                   	push   %ebx
80106376:	83 ec 1c             	sub    $0x1c,%esp
80106379:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010637c:	8b 47 30             	mov    0x30(%edi),%eax
8010637f:	83 f8 40             	cmp    $0x40,%eax
80106382:	0f 84 38 01 00 00    	je     801064c0 <trap+0x150>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106388:	83 e8 0e             	sub    $0xe,%eax
8010638b:	83 f8 31             	cmp    $0x31,%eax
8010638e:	0f 87 0c 02 00 00    	ja     801065a0 <trap+0x230>
80106394:	ff 24 85 4c 92 10 80 	jmp    *-0x7fef6db4(,%eax,4)
8010639b:	90                   	nop
8010639c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801063a0:	0f 20 d3             	mov    %cr2,%ebx

  case T_PGFLT:
  ;
    
    uint faulting_addr = rcr2();
    struct proc* p = myproc();
801063a3:	e8 28 dd ff ff       	call   801040d0 <myproc>
    pte_t* pte_ptr = public_walkpgdir(p->pgdir, (void *)faulting_addr, 0);
801063a8:	83 ec 04             	sub    $0x4,%esp
    struct proc* p = myproc();
801063ab:	89 c6                	mov    %eax,%esi
    pte_t* pte_ptr = public_walkpgdir(p->pgdir, (void *)faulting_addr, 0);
801063ad:	6a 00                	push   $0x0
801063af:	53                   	push   %ebx
801063b0:	ff 70 04             	pushl  0x4(%eax)
801063b3:	e8 98 15 00 00       	call   80107950 <public_walkpgdir>
    if (!(pte_ptr == 0) && (*pte_ptr & PTE_U) && (*pte_ptr & PTE_PG)){
801063b8:	83 c4 10             	add    $0x10,%esp
801063bb:	85 c0                	test   %eax,%eax
801063bd:	0f 84 dd 01 00 00    	je     801065a0 <trap+0x230>
801063c3:	8b 10                	mov    (%eax),%edx
801063c5:	89 d1                	mov    %edx,%ecx
801063c7:	81 e1 04 02 00 00    	and    $0x204,%ecx
801063cd:	81 f9 04 02 00 00    	cmp    $0x204,%ecx
801063d3:	0f 84 57 02 00 00    	je     80106630 <trap+0x2c0>
        }
      }
      p->num_of_pagefaults_occurs++;
      break;
    }
    if (!(pte_ptr == 0) && *pte_ptr & PTE_COW){
801063d9:	80 e6 08             	and    $0x8,%dh
801063dc:	0f 84 be 01 00 00    	je     801065a0 <trap+0x230>
      // cprintf("trap %d\n", p->pid);
      acquire(cow_lock);
801063e2:	83 ec 0c             	sub    $0xc,%esp
801063e5:	ff 35 40 ff 11 80    	pushl  0x8011ff40
801063eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801063ee:	e8 6d eb ff ff       	call   80104f60 <acquire>
      char* ref_count = &(pg_ref_counts[PGROUNDDOWN(PTE_ADDR(*pte_ptr)) / PGSIZE]);
801063f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      if (*ref_count == 1){
801063f6:	83 c4 10             	add    $0x10,%esp
      char* ref_count = &(pg_ref_counts[PGROUNDDOWN(PTE_ADDR(*pte_ptr)) / PGSIZE]);
801063f9:	8b 18                	mov    (%eax),%ebx
801063fb:	89 d9                	mov    %ebx,%ecx
801063fd:	c1 e9 0c             	shr    $0xc,%ecx
      if (*ref_count == 1){
80106400:	0f b6 91 40 1f 11 80 	movzbl -0x7feee0c0(%ecx),%edx
80106407:	80 fa 01             	cmp    $0x1,%dl
8010640a:	0f 84 a4 02 00 00    	je     801066b4 <trap+0x344>
80106410:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        *pte_ptr &= (~PTE_COW);
        // cprintf("rel trap %d\n", p->pid);
        release(cow_lock);
        break;
      }
      else if (*ref_count > 1){
80106413:	0f 8e e1 02 00 00    	jle    801066fa <trap+0x38a>
        (*ref_count)--;
        // cprintf("rel trap %d\n", p->pid);
        release(cow_lock);
80106419:	83 ec 0c             	sub    $0xc,%esp
8010641c:	ff 35 40 ff 11 80    	pushl  0x8011ff40
        (*ref_count)--;
80106422:	83 ea 01             	sub    $0x1,%edx
80106425:	88 91 40 1f 11 80    	mov    %dl,-0x7feee0c0(%ecx)
        release(cow_lock);
8010642b:	e8 f0 eb ff ff       	call   80105020 <release>
        int result = copy_page(p->pgdir, pte_ptr);
80106430:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106433:	59                   	pop    %ecx
80106434:	5b                   	pop    %ebx
80106435:	50                   	push   %eax
80106436:	ff 76 04             	pushl  0x4(%esi)
80106439:	e8 62 24 00 00       	call   801088a0 <copy_page>
        if (result < 0){
8010643e:	83 c4 10             	add    $0x10,%esp
80106441:	85 c0                	test   %eax,%eax
80106443:	79 13                	jns    80106458 <trap+0xe8>
          p->killed = 1;
80106445:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
          exit();
8010644c:	e8 5f e2 ff ff       	call   801046b0 <exit>
80106451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106458:	e8 73 dc ff ff       	call   801040d0 <myproc>
8010645d:	85 c0                	test   %eax,%eax
8010645f:	74 1d                	je     8010647e <trap+0x10e>
80106461:	e8 6a dc ff ff       	call   801040d0 <myproc>
80106466:	8b 50 24             	mov    0x24(%eax),%edx
80106469:	85 d2                	test   %edx,%edx
8010646b:	74 11                	je     8010647e <trap+0x10e>
8010646d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106471:	83 e0 03             	and    $0x3,%eax
80106474:	66 83 f8 03          	cmp    $0x3,%ax
80106478:	0f 84 a2 01 00 00    	je     80106620 <trap+0x2b0>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
8010647e:	e8 4d dc ff ff       	call   801040d0 <myproc>
80106483:	85 c0                	test   %eax,%eax
80106485:	74 0b                	je     80106492 <trap+0x122>
80106487:	e8 44 dc ff ff       	call   801040d0 <myproc>
8010648c:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106490:	74 66                	je     801064f8 <trap+0x188>
      yield();
    }
    

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106492:	e8 39 dc ff ff       	call   801040d0 <myproc>
80106497:	85 c0                	test   %eax,%eax
80106499:	74 19                	je     801064b4 <trap+0x144>
8010649b:	e8 30 dc ff ff       	call   801040d0 <myproc>
801064a0:	8b 40 24             	mov    0x24(%eax),%eax
801064a3:	85 c0                	test   %eax,%eax
801064a5:	74 0d                	je     801064b4 <trap+0x144>
801064a7:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801064ab:	83 e0 03             	and    $0x3,%eax
801064ae:	66 83 f8 03          	cmp    $0x3,%ax
801064b2:	74 35                	je     801064e9 <trap+0x179>
    exit();
}
801064b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064b7:	5b                   	pop    %ebx
801064b8:	5e                   	pop    %esi
801064b9:	5f                   	pop    %edi
801064ba:	5d                   	pop    %ebp
801064bb:	c3                   	ret    
801064bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
801064c0:	e8 0b dc ff ff       	call   801040d0 <myproc>
801064c5:	8b 40 24             	mov    0x24(%eax),%eax
801064c8:	85 c0                	test   %eax,%eax
801064ca:	0f 85 c0 00 00 00    	jne    80106590 <trap+0x220>
    myproc()->tf = tf;
801064d0:	e8 fb db ff ff       	call   801040d0 <myproc>
801064d5:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
801064d8:	e8 83 ef ff ff       	call   80105460 <syscall>
    if(myproc()->killed)
801064dd:	e8 ee db ff ff       	call   801040d0 <myproc>
801064e2:	8b 70 24             	mov    0x24(%eax),%esi
801064e5:	85 f6                	test   %esi,%esi
801064e7:	74 cb                	je     801064b4 <trap+0x144>
}
801064e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064ec:	5b                   	pop    %ebx
801064ed:	5e                   	pop    %esi
801064ee:	5f                   	pop    %edi
801064ef:	5d                   	pop    %ebp
      exit();
801064f0:	e9 bb e1 ff ff       	jmp    801046b0 <exit>
801064f5:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
801064f8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801064fc:	75 94                	jne    80106492 <trap+0x122>
      yield();
801064fe:	e8 4d e3 ff ff       	call   80104850 <yield>
80106503:	eb 8d                	jmp    80106492 <trap+0x122>
80106505:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80106508:	e8 a3 db ff ff       	call   801040b0 <cpuid>
8010650d:	85 c0                	test   %eax,%eax
8010650f:	0f 84 6b 01 00 00    	je     80106680 <trap+0x310>
    lapiceoi();
80106515:	e8 86 ca ff ff       	call   80102fa0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010651a:	e8 b1 db ff ff       	call   801040d0 <myproc>
8010651f:	85 c0                	test   %eax,%eax
80106521:	0f 85 3a ff ff ff    	jne    80106461 <trap+0xf1>
80106527:	e9 52 ff ff ff       	jmp    8010647e <trap+0x10e>
8010652c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106530:	e8 4b 03 00 00       	call   80106880 <uartintr>
    lapiceoi();
80106535:	e8 66 ca ff ff       	call   80102fa0 <lapiceoi>
    break;
8010653a:	e9 19 ff ff ff       	jmp    80106458 <trap+0xe8>
8010653f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106540:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106544:	8b 77 38             	mov    0x38(%edi),%esi
80106547:	e8 64 db ff ff       	call   801040b0 <cpuid>
8010654c:	56                   	push   %esi
8010654d:	53                   	push   %ebx
8010654e:	50                   	push   %eax
8010654f:	68 84 91 10 80       	push   $0x80109184
80106554:	e8 07 a1 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106559:	e8 42 ca ff ff       	call   80102fa0 <lapiceoi>
    break;
8010655e:	83 c4 10             	add    $0x10,%esp
80106561:	e9 f2 fe ff ff       	jmp    80106458 <trap+0xe8>
80106566:	8d 76 00             	lea    0x0(%esi),%esi
80106569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80106570:	e8 db c2 ff ff       	call   80102850 <ideintr>
80106575:	eb 9e                	jmp    80106515 <trap+0x1a5>
80106577:	89 f6                	mov    %esi,%esi
80106579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    kbdintr();
80106580:	e8 db c8 ff ff       	call   80102e60 <kbdintr>
    lapiceoi();
80106585:	e8 16 ca ff ff       	call   80102fa0 <lapiceoi>
    break;
8010658a:	e9 c9 fe ff ff       	jmp    80106458 <trap+0xe8>
8010658f:	90                   	nop
      exit();
80106590:	e8 1b e1 ff ff       	call   801046b0 <exit>
80106595:	e9 36 ff ff ff       	jmp    801064d0 <trap+0x160>
8010659a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
801065a0:	e8 2b db ff ff       	call   801040d0 <myproc>
801065a5:	85 c0                	test   %eax,%eax
801065a7:	8b 5f 38             	mov    0x38(%edi),%ebx
801065aa:	0f 84 22 01 00 00    	je     801066d2 <trap+0x362>
801065b0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801065b4:	0f 84 18 01 00 00    	je     801066d2 <trap+0x362>
801065ba:	0f 20 d1             	mov    %cr2,%ecx
801065bd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801065c0:	e8 eb da ff ff       	call   801040b0 <cpuid>
801065c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
801065c8:	8b 47 34             	mov    0x34(%edi),%eax
801065cb:	8b 77 30             	mov    0x30(%edi),%esi
801065ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801065d1:	e8 fa da ff ff       	call   801040d0 <myproc>
801065d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801065d9:	e8 f2 da ff ff       	call   801040d0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801065de:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801065e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801065e4:	51                   	push   %ecx
801065e5:	53                   	push   %ebx
801065e6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
801065e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801065ea:	ff 75 e4             	pushl  -0x1c(%ebp)
801065ed:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801065ee:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801065f1:	52                   	push   %edx
801065f2:	ff 70 10             	pushl  0x10(%eax)
801065f5:	68 08 92 10 80       	push   $0x80109208
801065fa:	e8 61 a0 ff ff       	call   80100660 <cprintf>
    myproc()->killed = 1;
801065ff:	83 c4 20             	add    $0x20,%esp
80106602:	e8 c9 da ff ff       	call   801040d0 <myproc>
80106607:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010660e:	e8 bd da ff ff       	call   801040d0 <myproc>
80106613:	85 c0                	test   %eax,%eax
80106615:	0f 85 46 fe ff ff    	jne    80106461 <trap+0xf1>
8010661b:	e9 5e fe ff ff       	jmp    8010647e <trap+0x10e>
    exit();
80106620:	e8 8b e0 ff ff       	call   801046b0 <exit>
80106625:	e9 54 fe ff ff       	jmp    8010647e <trap+0x10e>
8010662a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106630:	8d 96 90 00 00 00    	lea    0x90(%esi),%edx
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
80106636:	31 c0                	xor    %eax,%eax
80106638:	eb 11                	jmp    8010664b <trap+0x2db>
8010663a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106640:	83 c0 01             	add    $0x1,%eax
80106643:	83 c2 18             	add    $0x18,%edx
80106646:	83 f8 10             	cmp    $0x10,%eax
80106649:	74 23                	je     8010666e <trap+0x2fe>
        if (PGROUNDDOWN((uint)(p->swapped_out_pages[i].va)) == PGROUNDDOWN(faulting_addr)){
8010664b:	8b 0a                	mov    (%edx),%ecx
8010664d:	31 d9                	xor    %ebx,%ecx
8010664f:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80106655:	75 e9                	jne    80106640 <trap+0x2d0>
          swap_page_back(p, &(p->swapped_out_pages[i]));
80106657:	8d 04 40             	lea    (%eax,%eax,2),%eax
8010665a:	83 ec 08             	sub    $0x8,%esp
8010665d:	8d 84 c6 80 00 00 00 	lea    0x80(%esi,%eax,8),%eax
80106664:	50                   	push   %eax
80106665:	56                   	push   %esi
80106666:	e8 15 21 00 00       	call   80108780 <swap_page_back>
          break;
8010666b:	83 c4 10             	add    $0x10,%esp
      p->num_of_pagefaults_occurs++;
8010666e:	83 86 c8 03 00 00 01 	addl   $0x1,0x3c8(%esi)
      break;
80106675:	e9 de fd ff ff       	jmp    80106458 <trap+0xe8>
8010667a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106680:	83 ec 0c             	sub    $0xc,%esp
80106683:	68 e0 21 13 80       	push   $0x801321e0
80106688:	e8 d3 e8 ff ff       	call   80104f60 <acquire>
      wakeup(&ticks);
8010668d:	c7 04 24 20 2a 13 80 	movl   $0x80132a20,(%esp)
      ticks++;
80106694:	83 05 20 2a 13 80 01 	addl   $0x1,0x80132a20
      wakeup(&ticks);
8010669b:	e8 50 e4 ff ff       	call   80104af0 <wakeup>
      release(&tickslock);
801066a0:	c7 04 24 e0 21 13 80 	movl   $0x801321e0,(%esp)
801066a7:	e8 74 e9 ff ff       	call   80105020 <release>
801066ac:	83 c4 10             	add    $0x10,%esp
801066af:	e9 61 fe ff ff       	jmp    80106515 <trap+0x1a5>
        *pte_ptr &= (~PTE_COW);
801066b4:	80 e7 f7             	and    $0xf7,%bh
        release(cow_lock);
801066b7:	83 ec 0c             	sub    $0xc,%esp
        *pte_ptr &= (~PTE_COW);
801066ba:	83 cb 02             	or     $0x2,%ebx
801066bd:	89 18                	mov    %ebx,(%eax)
        release(cow_lock);
801066bf:	ff 35 40 ff 11 80    	pushl  0x8011ff40
801066c5:	e8 56 e9 ff ff       	call   80105020 <release>
        break;
801066ca:	83 c4 10             	add    $0x10,%esp
801066cd:	e9 86 fd ff ff       	jmp    80106458 <trap+0xe8>
801066d2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801066d5:	e8 d6 d9 ff ff       	call   801040b0 <cpuid>
801066da:	83 ec 0c             	sub    $0xc,%esp
801066dd:	56                   	push   %esi
801066de:	53                   	push   %ebx
801066df:	50                   	push   %eax
801066e0:	ff 77 30             	pushl  0x30(%edi)
801066e3:	68 d4 91 10 80       	push   $0x801091d4
801066e8:	e8 73 9f ff ff       	call   80100660 <cprintf>
      panic("trap");
801066ed:	83 c4 14             	add    $0x14,%esp
801066f0:	68 7e 91 10 80       	push   $0x8010917e
801066f5:	e8 96 9c ff ff       	call   80100390 <panic>
        panic("ref count to page is 0 but it was reffed");
801066fa:	83 ec 0c             	sub    $0xc,%esp
801066fd:	68 a8 91 10 80       	push   $0x801091a8
80106702:	e8 89 9c ff ff       	call   80100390 <panic>
80106707:	66 90                	xchg   %ax,%ax
80106709:	66 90                	xchg   %ax,%ax
8010670b:	66 90                	xchg   %ax,%ax
8010670d:	66 90                	xchg   %ax,%ax
8010670f:	90                   	nop

80106710 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106710:	a1 bc c5 10 80       	mov    0x8010c5bc,%eax
{
80106715:	55                   	push   %ebp
80106716:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106718:	85 c0                	test   %eax,%eax
8010671a:	74 1c                	je     80106738 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010671c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106721:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106722:	a8 01                	test   $0x1,%al
80106724:	74 12                	je     80106738 <uartgetc+0x28>
80106726:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010672b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010672c:	0f b6 c0             	movzbl %al,%eax
}
8010672f:	5d                   	pop    %ebp
80106730:	c3                   	ret    
80106731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106738:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010673d:	5d                   	pop    %ebp
8010673e:	c3                   	ret    
8010673f:	90                   	nop

80106740 <uartputc.part.0>:
uartputc(int c)
80106740:	55                   	push   %ebp
80106741:	89 e5                	mov    %esp,%ebp
80106743:	57                   	push   %edi
80106744:	56                   	push   %esi
80106745:	53                   	push   %ebx
80106746:	89 c7                	mov    %eax,%edi
80106748:	bb 80 00 00 00       	mov    $0x80,%ebx
8010674d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106752:	83 ec 0c             	sub    $0xc,%esp
80106755:	eb 1b                	jmp    80106772 <uartputc.part.0+0x32>
80106757:	89 f6                	mov    %esi,%esi
80106759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106760:	83 ec 0c             	sub    $0xc,%esp
80106763:	6a 0a                	push   $0xa
80106765:	e8 56 c8 ff ff       	call   80102fc0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010676a:	83 c4 10             	add    $0x10,%esp
8010676d:	83 eb 01             	sub    $0x1,%ebx
80106770:	74 07                	je     80106779 <uartputc.part.0+0x39>
80106772:	89 f2                	mov    %esi,%edx
80106774:	ec                   	in     (%dx),%al
80106775:	a8 20                	test   $0x20,%al
80106777:	74 e7                	je     80106760 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106779:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010677e:	89 f8                	mov    %edi,%eax
80106780:	ee                   	out    %al,(%dx)
}
80106781:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106784:	5b                   	pop    %ebx
80106785:	5e                   	pop    %esi
80106786:	5f                   	pop    %edi
80106787:	5d                   	pop    %ebp
80106788:	c3                   	ret    
80106789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106790 <uartinit>:
{
80106790:	55                   	push   %ebp
80106791:	31 c9                	xor    %ecx,%ecx
80106793:	89 c8                	mov    %ecx,%eax
80106795:	89 e5                	mov    %esp,%ebp
80106797:	57                   	push   %edi
80106798:	56                   	push   %esi
80106799:	53                   	push   %ebx
8010679a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010679f:	89 da                	mov    %ebx,%edx
801067a1:	83 ec 0c             	sub    $0xc,%esp
801067a4:	ee                   	out    %al,(%dx)
801067a5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801067aa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801067af:	89 fa                	mov    %edi,%edx
801067b1:	ee                   	out    %al,(%dx)
801067b2:	b8 0c 00 00 00       	mov    $0xc,%eax
801067b7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801067bc:	ee                   	out    %al,(%dx)
801067bd:	be f9 03 00 00       	mov    $0x3f9,%esi
801067c2:	89 c8                	mov    %ecx,%eax
801067c4:	89 f2                	mov    %esi,%edx
801067c6:	ee                   	out    %al,(%dx)
801067c7:	b8 03 00 00 00       	mov    $0x3,%eax
801067cc:	89 fa                	mov    %edi,%edx
801067ce:	ee                   	out    %al,(%dx)
801067cf:	ba fc 03 00 00       	mov    $0x3fc,%edx
801067d4:	89 c8                	mov    %ecx,%eax
801067d6:	ee                   	out    %al,(%dx)
801067d7:	b8 01 00 00 00       	mov    $0x1,%eax
801067dc:	89 f2                	mov    %esi,%edx
801067de:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801067df:	ba fd 03 00 00       	mov    $0x3fd,%edx
801067e4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801067e5:	3c ff                	cmp    $0xff,%al
801067e7:	74 5a                	je     80106843 <uartinit+0xb3>
  uart = 1;
801067e9:	c7 05 bc c5 10 80 01 	movl   $0x1,0x8010c5bc
801067f0:	00 00 00 
801067f3:	89 da                	mov    %ebx,%edx
801067f5:	ec                   	in     (%dx),%al
801067f6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801067fb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801067fc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801067ff:	bb 14 93 10 80       	mov    $0x80109314,%ebx
  ioapicenable(IRQ_COM1, 0);
80106804:	6a 00                	push   $0x0
80106806:	6a 04                	push   $0x4
80106808:	e8 93 c2 ff ff       	call   80102aa0 <ioapicenable>
8010680d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106810:	b8 78 00 00 00       	mov    $0x78,%eax
80106815:	eb 13                	jmp    8010682a <uartinit+0x9a>
80106817:	89 f6                	mov    %esi,%esi
80106819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106820:	83 c3 01             	add    $0x1,%ebx
80106823:	0f be 03             	movsbl (%ebx),%eax
80106826:	84 c0                	test   %al,%al
80106828:	74 19                	je     80106843 <uartinit+0xb3>
  if(!uart)
8010682a:	8b 15 bc c5 10 80    	mov    0x8010c5bc,%edx
80106830:	85 d2                	test   %edx,%edx
80106832:	74 ec                	je     80106820 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106834:	83 c3 01             	add    $0x1,%ebx
80106837:	e8 04 ff ff ff       	call   80106740 <uartputc.part.0>
8010683c:	0f be 03             	movsbl (%ebx),%eax
8010683f:	84 c0                	test   %al,%al
80106841:	75 e7                	jne    8010682a <uartinit+0x9a>
}
80106843:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106846:	5b                   	pop    %ebx
80106847:	5e                   	pop    %esi
80106848:	5f                   	pop    %edi
80106849:	5d                   	pop    %ebp
8010684a:	c3                   	ret    
8010684b:	90                   	nop
8010684c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106850 <uartputc>:
  if(!uart)
80106850:	8b 15 bc c5 10 80    	mov    0x8010c5bc,%edx
{
80106856:	55                   	push   %ebp
80106857:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106859:	85 d2                	test   %edx,%edx
{
8010685b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010685e:	74 10                	je     80106870 <uartputc+0x20>
}
80106860:	5d                   	pop    %ebp
80106861:	e9 da fe ff ff       	jmp    80106740 <uartputc.part.0>
80106866:	8d 76 00             	lea    0x0(%esi),%esi
80106869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106870:	5d                   	pop    %ebp
80106871:	c3                   	ret    
80106872:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106880 <uartintr>:

void
uartintr(void)
{
80106880:	55                   	push   %ebp
80106881:	89 e5                	mov    %esp,%ebp
80106883:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106886:	68 10 67 10 80       	push   $0x80106710
8010688b:	e8 80 9f ff ff       	call   80100810 <consoleintr>
}
80106890:	83 c4 10             	add    $0x10,%esp
80106893:	c9                   	leave  
80106894:	c3                   	ret    

80106895 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106895:	6a 00                	push   $0x0
  pushl $0
80106897:	6a 00                	push   $0x0
  jmp alltraps
80106899:	e9 fb f9 ff ff       	jmp    80106299 <alltraps>

8010689e <vector1>:
.globl vector1
vector1:
  pushl $0
8010689e:	6a 00                	push   $0x0
  pushl $1
801068a0:	6a 01                	push   $0x1
  jmp alltraps
801068a2:	e9 f2 f9 ff ff       	jmp    80106299 <alltraps>

801068a7 <vector2>:
.globl vector2
vector2:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $2
801068a9:	6a 02                	push   $0x2
  jmp alltraps
801068ab:	e9 e9 f9 ff ff       	jmp    80106299 <alltraps>

801068b0 <vector3>:
.globl vector3
vector3:
  pushl $0
801068b0:	6a 00                	push   $0x0
  pushl $3
801068b2:	6a 03                	push   $0x3
  jmp alltraps
801068b4:	e9 e0 f9 ff ff       	jmp    80106299 <alltraps>

801068b9 <vector4>:
.globl vector4
vector4:
  pushl $0
801068b9:	6a 00                	push   $0x0
  pushl $4
801068bb:	6a 04                	push   $0x4
  jmp alltraps
801068bd:	e9 d7 f9 ff ff       	jmp    80106299 <alltraps>

801068c2 <vector5>:
.globl vector5
vector5:
  pushl $0
801068c2:	6a 00                	push   $0x0
  pushl $5
801068c4:	6a 05                	push   $0x5
  jmp alltraps
801068c6:	e9 ce f9 ff ff       	jmp    80106299 <alltraps>

801068cb <vector6>:
.globl vector6
vector6:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $6
801068cd:	6a 06                	push   $0x6
  jmp alltraps
801068cf:	e9 c5 f9 ff ff       	jmp    80106299 <alltraps>

801068d4 <vector7>:
.globl vector7
vector7:
  pushl $0
801068d4:	6a 00                	push   $0x0
  pushl $7
801068d6:	6a 07                	push   $0x7
  jmp alltraps
801068d8:	e9 bc f9 ff ff       	jmp    80106299 <alltraps>

801068dd <vector8>:
.globl vector8
vector8:
  pushl $8
801068dd:	6a 08                	push   $0x8
  jmp alltraps
801068df:	e9 b5 f9 ff ff       	jmp    80106299 <alltraps>

801068e4 <vector9>:
.globl vector9
vector9:
  pushl $0
801068e4:	6a 00                	push   $0x0
  pushl $9
801068e6:	6a 09                	push   $0x9
  jmp alltraps
801068e8:	e9 ac f9 ff ff       	jmp    80106299 <alltraps>

801068ed <vector10>:
.globl vector10
vector10:
  pushl $10
801068ed:	6a 0a                	push   $0xa
  jmp alltraps
801068ef:	e9 a5 f9 ff ff       	jmp    80106299 <alltraps>

801068f4 <vector11>:
.globl vector11
vector11:
  pushl $11
801068f4:	6a 0b                	push   $0xb
  jmp alltraps
801068f6:	e9 9e f9 ff ff       	jmp    80106299 <alltraps>

801068fb <vector12>:
.globl vector12
vector12:
  pushl $12
801068fb:	6a 0c                	push   $0xc
  jmp alltraps
801068fd:	e9 97 f9 ff ff       	jmp    80106299 <alltraps>

80106902 <vector13>:
.globl vector13
vector13:
  pushl $13
80106902:	6a 0d                	push   $0xd
  jmp alltraps
80106904:	e9 90 f9 ff ff       	jmp    80106299 <alltraps>

80106909 <vector14>:
.globl vector14
vector14:
  pushl $14
80106909:	6a 0e                	push   $0xe
  jmp alltraps
8010690b:	e9 89 f9 ff ff       	jmp    80106299 <alltraps>

80106910 <vector15>:
.globl vector15
vector15:
  pushl $0
80106910:	6a 00                	push   $0x0
  pushl $15
80106912:	6a 0f                	push   $0xf
  jmp alltraps
80106914:	e9 80 f9 ff ff       	jmp    80106299 <alltraps>

80106919 <vector16>:
.globl vector16
vector16:
  pushl $0
80106919:	6a 00                	push   $0x0
  pushl $16
8010691b:	6a 10                	push   $0x10
  jmp alltraps
8010691d:	e9 77 f9 ff ff       	jmp    80106299 <alltraps>

80106922 <vector17>:
.globl vector17
vector17:
  pushl $17
80106922:	6a 11                	push   $0x11
  jmp alltraps
80106924:	e9 70 f9 ff ff       	jmp    80106299 <alltraps>

80106929 <vector18>:
.globl vector18
vector18:
  pushl $0
80106929:	6a 00                	push   $0x0
  pushl $18
8010692b:	6a 12                	push   $0x12
  jmp alltraps
8010692d:	e9 67 f9 ff ff       	jmp    80106299 <alltraps>

80106932 <vector19>:
.globl vector19
vector19:
  pushl $0
80106932:	6a 00                	push   $0x0
  pushl $19
80106934:	6a 13                	push   $0x13
  jmp alltraps
80106936:	e9 5e f9 ff ff       	jmp    80106299 <alltraps>

8010693b <vector20>:
.globl vector20
vector20:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $20
8010693d:	6a 14                	push   $0x14
  jmp alltraps
8010693f:	e9 55 f9 ff ff       	jmp    80106299 <alltraps>

80106944 <vector21>:
.globl vector21
vector21:
  pushl $0
80106944:	6a 00                	push   $0x0
  pushl $21
80106946:	6a 15                	push   $0x15
  jmp alltraps
80106948:	e9 4c f9 ff ff       	jmp    80106299 <alltraps>

8010694d <vector22>:
.globl vector22
vector22:
  pushl $0
8010694d:	6a 00                	push   $0x0
  pushl $22
8010694f:	6a 16                	push   $0x16
  jmp alltraps
80106951:	e9 43 f9 ff ff       	jmp    80106299 <alltraps>

80106956 <vector23>:
.globl vector23
vector23:
  pushl $0
80106956:	6a 00                	push   $0x0
  pushl $23
80106958:	6a 17                	push   $0x17
  jmp alltraps
8010695a:	e9 3a f9 ff ff       	jmp    80106299 <alltraps>

8010695f <vector24>:
.globl vector24
vector24:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $24
80106961:	6a 18                	push   $0x18
  jmp alltraps
80106963:	e9 31 f9 ff ff       	jmp    80106299 <alltraps>

80106968 <vector25>:
.globl vector25
vector25:
  pushl $0
80106968:	6a 00                	push   $0x0
  pushl $25
8010696a:	6a 19                	push   $0x19
  jmp alltraps
8010696c:	e9 28 f9 ff ff       	jmp    80106299 <alltraps>

80106971 <vector26>:
.globl vector26
vector26:
  pushl $0
80106971:	6a 00                	push   $0x0
  pushl $26
80106973:	6a 1a                	push   $0x1a
  jmp alltraps
80106975:	e9 1f f9 ff ff       	jmp    80106299 <alltraps>

8010697a <vector27>:
.globl vector27
vector27:
  pushl $0
8010697a:	6a 00                	push   $0x0
  pushl $27
8010697c:	6a 1b                	push   $0x1b
  jmp alltraps
8010697e:	e9 16 f9 ff ff       	jmp    80106299 <alltraps>

80106983 <vector28>:
.globl vector28
vector28:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $28
80106985:	6a 1c                	push   $0x1c
  jmp alltraps
80106987:	e9 0d f9 ff ff       	jmp    80106299 <alltraps>

8010698c <vector29>:
.globl vector29
vector29:
  pushl $0
8010698c:	6a 00                	push   $0x0
  pushl $29
8010698e:	6a 1d                	push   $0x1d
  jmp alltraps
80106990:	e9 04 f9 ff ff       	jmp    80106299 <alltraps>

80106995 <vector30>:
.globl vector30
vector30:
  pushl $0
80106995:	6a 00                	push   $0x0
  pushl $30
80106997:	6a 1e                	push   $0x1e
  jmp alltraps
80106999:	e9 fb f8 ff ff       	jmp    80106299 <alltraps>

8010699e <vector31>:
.globl vector31
vector31:
  pushl $0
8010699e:	6a 00                	push   $0x0
  pushl $31
801069a0:	6a 1f                	push   $0x1f
  jmp alltraps
801069a2:	e9 f2 f8 ff ff       	jmp    80106299 <alltraps>

801069a7 <vector32>:
.globl vector32
vector32:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $32
801069a9:	6a 20                	push   $0x20
  jmp alltraps
801069ab:	e9 e9 f8 ff ff       	jmp    80106299 <alltraps>

801069b0 <vector33>:
.globl vector33
vector33:
  pushl $0
801069b0:	6a 00                	push   $0x0
  pushl $33
801069b2:	6a 21                	push   $0x21
  jmp alltraps
801069b4:	e9 e0 f8 ff ff       	jmp    80106299 <alltraps>

801069b9 <vector34>:
.globl vector34
vector34:
  pushl $0
801069b9:	6a 00                	push   $0x0
  pushl $34
801069bb:	6a 22                	push   $0x22
  jmp alltraps
801069bd:	e9 d7 f8 ff ff       	jmp    80106299 <alltraps>

801069c2 <vector35>:
.globl vector35
vector35:
  pushl $0
801069c2:	6a 00                	push   $0x0
  pushl $35
801069c4:	6a 23                	push   $0x23
  jmp alltraps
801069c6:	e9 ce f8 ff ff       	jmp    80106299 <alltraps>

801069cb <vector36>:
.globl vector36
vector36:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $36
801069cd:	6a 24                	push   $0x24
  jmp alltraps
801069cf:	e9 c5 f8 ff ff       	jmp    80106299 <alltraps>

801069d4 <vector37>:
.globl vector37
vector37:
  pushl $0
801069d4:	6a 00                	push   $0x0
  pushl $37
801069d6:	6a 25                	push   $0x25
  jmp alltraps
801069d8:	e9 bc f8 ff ff       	jmp    80106299 <alltraps>

801069dd <vector38>:
.globl vector38
vector38:
  pushl $0
801069dd:	6a 00                	push   $0x0
  pushl $38
801069df:	6a 26                	push   $0x26
  jmp alltraps
801069e1:	e9 b3 f8 ff ff       	jmp    80106299 <alltraps>

801069e6 <vector39>:
.globl vector39
vector39:
  pushl $0
801069e6:	6a 00                	push   $0x0
  pushl $39
801069e8:	6a 27                	push   $0x27
  jmp alltraps
801069ea:	e9 aa f8 ff ff       	jmp    80106299 <alltraps>

801069ef <vector40>:
.globl vector40
vector40:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $40
801069f1:	6a 28                	push   $0x28
  jmp alltraps
801069f3:	e9 a1 f8 ff ff       	jmp    80106299 <alltraps>

801069f8 <vector41>:
.globl vector41
vector41:
  pushl $0
801069f8:	6a 00                	push   $0x0
  pushl $41
801069fa:	6a 29                	push   $0x29
  jmp alltraps
801069fc:	e9 98 f8 ff ff       	jmp    80106299 <alltraps>

80106a01 <vector42>:
.globl vector42
vector42:
  pushl $0
80106a01:	6a 00                	push   $0x0
  pushl $42
80106a03:	6a 2a                	push   $0x2a
  jmp alltraps
80106a05:	e9 8f f8 ff ff       	jmp    80106299 <alltraps>

80106a0a <vector43>:
.globl vector43
vector43:
  pushl $0
80106a0a:	6a 00                	push   $0x0
  pushl $43
80106a0c:	6a 2b                	push   $0x2b
  jmp alltraps
80106a0e:	e9 86 f8 ff ff       	jmp    80106299 <alltraps>

80106a13 <vector44>:
.globl vector44
vector44:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $44
80106a15:	6a 2c                	push   $0x2c
  jmp alltraps
80106a17:	e9 7d f8 ff ff       	jmp    80106299 <alltraps>

80106a1c <vector45>:
.globl vector45
vector45:
  pushl $0
80106a1c:	6a 00                	push   $0x0
  pushl $45
80106a1e:	6a 2d                	push   $0x2d
  jmp alltraps
80106a20:	e9 74 f8 ff ff       	jmp    80106299 <alltraps>

80106a25 <vector46>:
.globl vector46
vector46:
  pushl $0
80106a25:	6a 00                	push   $0x0
  pushl $46
80106a27:	6a 2e                	push   $0x2e
  jmp alltraps
80106a29:	e9 6b f8 ff ff       	jmp    80106299 <alltraps>

80106a2e <vector47>:
.globl vector47
vector47:
  pushl $0
80106a2e:	6a 00                	push   $0x0
  pushl $47
80106a30:	6a 2f                	push   $0x2f
  jmp alltraps
80106a32:	e9 62 f8 ff ff       	jmp    80106299 <alltraps>

80106a37 <vector48>:
.globl vector48
vector48:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $48
80106a39:	6a 30                	push   $0x30
  jmp alltraps
80106a3b:	e9 59 f8 ff ff       	jmp    80106299 <alltraps>

80106a40 <vector49>:
.globl vector49
vector49:
  pushl $0
80106a40:	6a 00                	push   $0x0
  pushl $49
80106a42:	6a 31                	push   $0x31
  jmp alltraps
80106a44:	e9 50 f8 ff ff       	jmp    80106299 <alltraps>

80106a49 <vector50>:
.globl vector50
vector50:
  pushl $0
80106a49:	6a 00                	push   $0x0
  pushl $50
80106a4b:	6a 32                	push   $0x32
  jmp alltraps
80106a4d:	e9 47 f8 ff ff       	jmp    80106299 <alltraps>

80106a52 <vector51>:
.globl vector51
vector51:
  pushl $0
80106a52:	6a 00                	push   $0x0
  pushl $51
80106a54:	6a 33                	push   $0x33
  jmp alltraps
80106a56:	e9 3e f8 ff ff       	jmp    80106299 <alltraps>

80106a5b <vector52>:
.globl vector52
vector52:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $52
80106a5d:	6a 34                	push   $0x34
  jmp alltraps
80106a5f:	e9 35 f8 ff ff       	jmp    80106299 <alltraps>

80106a64 <vector53>:
.globl vector53
vector53:
  pushl $0
80106a64:	6a 00                	push   $0x0
  pushl $53
80106a66:	6a 35                	push   $0x35
  jmp alltraps
80106a68:	e9 2c f8 ff ff       	jmp    80106299 <alltraps>

80106a6d <vector54>:
.globl vector54
vector54:
  pushl $0
80106a6d:	6a 00                	push   $0x0
  pushl $54
80106a6f:	6a 36                	push   $0x36
  jmp alltraps
80106a71:	e9 23 f8 ff ff       	jmp    80106299 <alltraps>

80106a76 <vector55>:
.globl vector55
vector55:
  pushl $0
80106a76:	6a 00                	push   $0x0
  pushl $55
80106a78:	6a 37                	push   $0x37
  jmp alltraps
80106a7a:	e9 1a f8 ff ff       	jmp    80106299 <alltraps>

80106a7f <vector56>:
.globl vector56
vector56:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $56
80106a81:	6a 38                	push   $0x38
  jmp alltraps
80106a83:	e9 11 f8 ff ff       	jmp    80106299 <alltraps>

80106a88 <vector57>:
.globl vector57
vector57:
  pushl $0
80106a88:	6a 00                	push   $0x0
  pushl $57
80106a8a:	6a 39                	push   $0x39
  jmp alltraps
80106a8c:	e9 08 f8 ff ff       	jmp    80106299 <alltraps>

80106a91 <vector58>:
.globl vector58
vector58:
  pushl $0
80106a91:	6a 00                	push   $0x0
  pushl $58
80106a93:	6a 3a                	push   $0x3a
  jmp alltraps
80106a95:	e9 ff f7 ff ff       	jmp    80106299 <alltraps>

80106a9a <vector59>:
.globl vector59
vector59:
  pushl $0
80106a9a:	6a 00                	push   $0x0
  pushl $59
80106a9c:	6a 3b                	push   $0x3b
  jmp alltraps
80106a9e:	e9 f6 f7 ff ff       	jmp    80106299 <alltraps>

80106aa3 <vector60>:
.globl vector60
vector60:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $60
80106aa5:	6a 3c                	push   $0x3c
  jmp alltraps
80106aa7:	e9 ed f7 ff ff       	jmp    80106299 <alltraps>

80106aac <vector61>:
.globl vector61
vector61:
  pushl $0
80106aac:	6a 00                	push   $0x0
  pushl $61
80106aae:	6a 3d                	push   $0x3d
  jmp alltraps
80106ab0:	e9 e4 f7 ff ff       	jmp    80106299 <alltraps>

80106ab5 <vector62>:
.globl vector62
vector62:
  pushl $0
80106ab5:	6a 00                	push   $0x0
  pushl $62
80106ab7:	6a 3e                	push   $0x3e
  jmp alltraps
80106ab9:	e9 db f7 ff ff       	jmp    80106299 <alltraps>

80106abe <vector63>:
.globl vector63
vector63:
  pushl $0
80106abe:	6a 00                	push   $0x0
  pushl $63
80106ac0:	6a 3f                	push   $0x3f
  jmp alltraps
80106ac2:	e9 d2 f7 ff ff       	jmp    80106299 <alltraps>

80106ac7 <vector64>:
.globl vector64
vector64:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $64
80106ac9:	6a 40                	push   $0x40
  jmp alltraps
80106acb:	e9 c9 f7 ff ff       	jmp    80106299 <alltraps>

80106ad0 <vector65>:
.globl vector65
vector65:
  pushl $0
80106ad0:	6a 00                	push   $0x0
  pushl $65
80106ad2:	6a 41                	push   $0x41
  jmp alltraps
80106ad4:	e9 c0 f7 ff ff       	jmp    80106299 <alltraps>

80106ad9 <vector66>:
.globl vector66
vector66:
  pushl $0
80106ad9:	6a 00                	push   $0x0
  pushl $66
80106adb:	6a 42                	push   $0x42
  jmp alltraps
80106add:	e9 b7 f7 ff ff       	jmp    80106299 <alltraps>

80106ae2 <vector67>:
.globl vector67
vector67:
  pushl $0
80106ae2:	6a 00                	push   $0x0
  pushl $67
80106ae4:	6a 43                	push   $0x43
  jmp alltraps
80106ae6:	e9 ae f7 ff ff       	jmp    80106299 <alltraps>

80106aeb <vector68>:
.globl vector68
vector68:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $68
80106aed:	6a 44                	push   $0x44
  jmp alltraps
80106aef:	e9 a5 f7 ff ff       	jmp    80106299 <alltraps>

80106af4 <vector69>:
.globl vector69
vector69:
  pushl $0
80106af4:	6a 00                	push   $0x0
  pushl $69
80106af6:	6a 45                	push   $0x45
  jmp alltraps
80106af8:	e9 9c f7 ff ff       	jmp    80106299 <alltraps>

80106afd <vector70>:
.globl vector70
vector70:
  pushl $0
80106afd:	6a 00                	push   $0x0
  pushl $70
80106aff:	6a 46                	push   $0x46
  jmp alltraps
80106b01:	e9 93 f7 ff ff       	jmp    80106299 <alltraps>

80106b06 <vector71>:
.globl vector71
vector71:
  pushl $0
80106b06:	6a 00                	push   $0x0
  pushl $71
80106b08:	6a 47                	push   $0x47
  jmp alltraps
80106b0a:	e9 8a f7 ff ff       	jmp    80106299 <alltraps>

80106b0f <vector72>:
.globl vector72
vector72:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $72
80106b11:	6a 48                	push   $0x48
  jmp alltraps
80106b13:	e9 81 f7 ff ff       	jmp    80106299 <alltraps>

80106b18 <vector73>:
.globl vector73
vector73:
  pushl $0
80106b18:	6a 00                	push   $0x0
  pushl $73
80106b1a:	6a 49                	push   $0x49
  jmp alltraps
80106b1c:	e9 78 f7 ff ff       	jmp    80106299 <alltraps>

80106b21 <vector74>:
.globl vector74
vector74:
  pushl $0
80106b21:	6a 00                	push   $0x0
  pushl $74
80106b23:	6a 4a                	push   $0x4a
  jmp alltraps
80106b25:	e9 6f f7 ff ff       	jmp    80106299 <alltraps>

80106b2a <vector75>:
.globl vector75
vector75:
  pushl $0
80106b2a:	6a 00                	push   $0x0
  pushl $75
80106b2c:	6a 4b                	push   $0x4b
  jmp alltraps
80106b2e:	e9 66 f7 ff ff       	jmp    80106299 <alltraps>

80106b33 <vector76>:
.globl vector76
vector76:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $76
80106b35:	6a 4c                	push   $0x4c
  jmp alltraps
80106b37:	e9 5d f7 ff ff       	jmp    80106299 <alltraps>

80106b3c <vector77>:
.globl vector77
vector77:
  pushl $0
80106b3c:	6a 00                	push   $0x0
  pushl $77
80106b3e:	6a 4d                	push   $0x4d
  jmp alltraps
80106b40:	e9 54 f7 ff ff       	jmp    80106299 <alltraps>

80106b45 <vector78>:
.globl vector78
vector78:
  pushl $0
80106b45:	6a 00                	push   $0x0
  pushl $78
80106b47:	6a 4e                	push   $0x4e
  jmp alltraps
80106b49:	e9 4b f7 ff ff       	jmp    80106299 <alltraps>

80106b4e <vector79>:
.globl vector79
vector79:
  pushl $0
80106b4e:	6a 00                	push   $0x0
  pushl $79
80106b50:	6a 4f                	push   $0x4f
  jmp alltraps
80106b52:	e9 42 f7 ff ff       	jmp    80106299 <alltraps>

80106b57 <vector80>:
.globl vector80
vector80:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $80
80106b59:	6a 50                	push   $0x50
  jmp alltraps
80106b5b:	e9 39 f7 ff ff       	jmp    80106299 <alltraps>

80106b60 <vector81>:
.globl vector81
vector81:
  pushl $0
80106b60:	6a 00                	push   $0x0
  pushl $81
80106b62:	6a 51                	push   $0x51
  jmp alltraps
80106b64:	e9 30 f7 ff ff       	jmp    80106299 <alltraps>

80106b69 <vector82>:
.globl vector82
vector82:
  pushl $0
80106b69:	6a 00                	push   $0x0
  pushl $82
80106b6b:	6a 52                	push   $0x52
  jmp alltraps
80106b6d:	e9 27 f7 ff ff       	jmp    80106299 <alltraps>

80106b72 <vector83>:
.globl vector83
vector83:
  pushl $0
80106b72:	6a 00                	push   $0x0
  pushl $83
80106b74:	6a 53                	push   $0x53
  jmp alltraps
80106b76:	e9 1e f7 ff ff       	jmp    80106299 <alltraps>

80106b7b <vector84>:
.globl vector84
vector84:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $84
80106b7d:	6a 54                	push   $0x54
  jmp alltraps
80106b7f:	e9 15 f7 ff ff       	jmp    80106299 <alltraps>

80106b84 <vector85>:
.globl vector85
vector85:
  pushl $0
80106b84:	6a 00                	push   $0x0
  pushl $85
80106b86:	6a 55                	push   $0x55
  jmp alltraps
80106b88:	e9 0c f7 ff ff       	jmp    80106299 <alltraps>

80106b8d <vector86>:
.globl vector86
vector86:
  pushl $0
80106b8d:	6a 00                	push   $0x0
  pushl $86
80106b8f:	6a 56                	push   $0x56
  jmp alltraps
80106b91:	e9 03 f7 ff ff       	jmp    80106299 <alltraps>

80106b96 <vector87>:
.globl vector87
vector87:
  pushl $0
80106b96:	6a 00                	push   $0x0
  pushl $87
80106b98:	6a 57                	push   $0x57
  jmp alltraps
80106b9a:	e9 fa f6 ff ff       	jmp    80106299 <alltraps>

80106b9f <vector88>:
.globl vector88
vector88:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $88
80106ba1:	6a 58                	push   $0x58
  jmp alltraps
80106ba3:	e9 f1 f6 ff ff       	jmp    80106299 <alltraps>

80106ba8 <vector89>:
.globl vector89
vector89:
  pushl $0
80106ba8:	6a 00                	push   $0x0
  pushl $89
80106baa:	6a 59                	push   $0x59
  jmp alltraps
80106bac:	e9 e8 f6 ff ff       	jmp    80106299 <alltraps>

80106bb1 <vector90>:
.globl vector90
vector90:
  pushl $0
80106bb1:	6a 00                	push   $0x0
  pushl $90
80106bb3:	6a 5a                	push   $0x5a
  jmp alltraps
80106bb5:	e9 df f6 ff ff       	jmp    80106299 <alltraps>

80106bba <vector91>:
.globl vector91
vector91:
  pushl $0
80106bba:	6a 00                	push   $0x0
  pushl $91
80106bbc:	6a 5b                	push   $0x5b
  jmp alltraps
80106bbe:	e9 d6 f6 ff ff       	jmp    80106299 <alltraps>

80106bc3 <vector92>:
.globl vector92
vector92:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $92
80106bc5:	6a 5c                	push   $0x5c
  jmp alltraps
80106bc7:	e9 cd f6 ff ff       	jmp    80106299 <alltraps>

80106bcc <vector93>:
.globl vector93
vector93:
  pushl $0
80106bcc:	6a 00                	push   $0x0
  pushl $93
80106bce:	6a 5d                	push   $0x5d
  jmp alltraps
80106bd0:	e9 c4 f6 ff ff       	jmp    80106299 <alltraps>

80106bd5 <vector94>:
.globl vector94
vector94:
  pushl $0
80106bd5:	6a 00                	push   $0x0
  pushl $94
80106bd7:	6a 5e                	push   $0x5e
  jmp alltraps
80106bd9:	e9 bb f6 ff ff       	jmp    80106299 <alltraps>

80106bde <vector95>:
.globl vector95
vector95:
  pushl $0
80106bde:	6a 00                	push   $0x0
  pushl $95
80106be0:	6a 5f                	push   $0x5f
  jmp alltraps
80106be2:	e9 b2 f6 ff ff       	jmp    80106299 <alltraps>

80106be7 <vector96>:
.globl vector96
vector96:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $96
80106be9:	6a 60                	push   $0x60
  jmp alltraps
80106beb:	e9 a9 f6 ff ff       	jmp    80106299 <alltraps>

80106bf0 <vector97>:
.globl vector97
vector97:
  pushl $0
80106bf0:	6a 00                	push   $0x0
  pushl $97
80106bf2:	6a 61                	push   $0x61
  jmp alltraps
80106bf4:	e9 a0 f6 ff ff       	jmp    80106299 <alltraps>

80106bf9 <vector98>:
.globl vector98
vector98:
  pushl $0
80106bf9:	6a 00                	push   $0x0
  pushl $98
80106bfb:	6a 62                	push   $0x62
  jmp alltraps
80106bfd:	e9 97 f6 ff ff       	jmp    80106299 <alltraps>

80106c02 <vector99>:
.globl vector99
vector99:
  pushl $0
80106c02:	6a 00                	push   $0x0
  pushl $99
80106c04:	6a 63                	push   $0x63
  jmp alltraps
80106c06:	e9 8e f6 ff ff       	jmp    80106299 <alltraps>

80106c0b <vector100>:
.globl vector100
vector100:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $100
80106c0d:	6a 64                	push   $0x64
  jmp alltraps
80106c0f:	e9 85 f6 ff ff       	jmp    80106299 <alltraps>

80106c14 <vector101>:
.globl vector101
vector101:
  pushl $0
80106c14:	6a 00                	push   $0x0
  pushl $101
80106c16:	6a 65                	push   $0x65
  jmp alltraps
80106c18:	e9 7c f6 ff ff       	jmp    80106299 <alltraps>

80106c1d <vector102>:
.globl vector102
vector102:
  pushl $0
80106c1d:	6a 00                	push   $0x0
  pushl $102
80106c1f:	6a 66                	push   $0x66
  jmp alltraps
80106c21:	e9 73 f6 ff ff       	jmp    80106299 <alltraps>

80106c26 <vector103>:
.globl vector103
vector103:
  pushl $0
80106c26:	6a 00                	push   $0x0
  pushl $103
80106c28:	6a 67                	push   $0x67
  jmp alltraps
80106c2a:	e9 6a f6 ff ff       	jmp    80106299 <alltraps>

80106c2f <vector104>:
.globl vector104
vector104:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $104
80106c31:	6a 68                	push   $0x68
  jmp alltraps
80106c33:	e9 61 f6 ff ff       	jmp    80106299 <alltraps>

80106c38 <vector105>:
.globl vector105
vector105:
  pushl $0
80106c38:	6a 00                	push   $0x0
  pushl $105
80106c3a:	6a 69                	push   $0x69
  jmp alltraps
80106c3c:	e9 58 f6 ff ff       	jmp    80106299 <alltraps>

80106c41 <vector106>:
.globl vector106
vector106:
  pushl $0
80106c41:	6a 00                	push   $0x0
  pushl $106
80106c43:	6a 6a                	push   $0x6a
  jmp alltraps
80106c45:	e9 4f f6 ff ff       	jmp    80106299 <alltraps>

80106c4a <vector107>:
.globl vector107
vector107:
  pushl $0
80106c4a:	6a 00                	push   $0x0
  pushl $107
80106c4c:	6a 6b                	push   $0x6b
  jmp alltraps
80106c4e:	e9 46 f6 ff ff       	jmp    80106299 <alltraps>

80106c53 <vector108>:
.globl vector108
vector108:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $108
80106c55:	6a 6c                	push   $0x6c
  jmp alltraps
80106c57:	e9 3d f6 ff ff       	jmp    80106299 <alltraps>

80106c5c <vector109>:
.globl vector109
vector109:
  pushl $0
80106c5c:	6a 00                	push   $0x0
  pushl $109
80106c5e:	6a 6d                	push   $0x6d
  jmp alltraps
80106c60:	e9 34 f6 ff ff       	jmp    80106299 <alltraps>

80106c65 <vector110>:
.globl vector110
vector110:
  pushl $0
80106c65:	6a 00                	push   $0x0
  pushl $110
80106c67:	6a 6e                	push   $0x6e
  jmp alltraps
80106c69:	e9 2b f6 ff ff       	jmp    80106299 <alltraps>

80106c6e <vector111>:
.globl vector111
vector111:
  pushl $0
80106c6e:	6a 00                	push   $0x0
  pushl $111
80106c70:	6a 6f                	push   $0x6f
  jmp alltraps
80106c72:	e9 22 f6 ff ff       	jmp    80106299 <alltraps>

80106c77 <vector112>:
.globl vector112
vector112:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $112
80106c79:	6a 70                	push   $0x70
  jmp alltraps
80106c7b:	e9 19 f6 ff ff       	jmp    80106299 <alltraps>

80106c80 <vector113>:
.globl vector113
vector113:
  pushl $0
80106c80:	6a 00                	push   $0x0
  pushl $113
80106c82:	6a 71                	push   $0x71
  jmp alltraps
80106c84:	e9 10 f6 ff ff       	jmp    80106299 <alltraps>

80106c89 <vector114>:
.globl vector114
vector114:
  pushl $0
80106c89:	6a 00                	push   $0x0
  pushl $114
80106c8b:	6a 72                	push   $0x72
  jmp alltraps
80106c8d:	e9 07 f6 ff ff       	jmp    80106299 <alltraps>

80106c92 <vector115>:
.globl vector115
vector115:
  pushl $0
80106c92:	6a 00                	push   $0x0
  pushl $115
80106c94:	6a 73                	push   $0x73
  jmp alltraps
80106c96:	e9 fe f5 ff ff       	jmp    80106299 <alltraps>

80106c9b <vector116>:
.globl vector116
vector116:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $116
80106c9d:	6a 74                	push   $0x74
  jmp alltraps
80106c9f:	e9 f5 f5 ff ff       	jmp    80106299 <alltraps>

80106ca4 <vector117>:
.globl vector117
vector117:
  pushl $0
80106ca4:	6a 00                	push   $0x0
  pushl $117
80106ca6:	6a 75                	push   $0x75
  jmp alltraps
80106ca8:	e9 ec f5 ff ff       	jmp    80106299 <alltraps>

80106cad <vector118>:
.globl vector118
vector118:
  pushl $0
80106cad:	6a 00                	push   $0x0
  pushl $118
80106caf:	6a 76                	push   $0x76
  jmp alltraps
80106cb1:	e9 e3 f5 ff ff       	jmp    80106299 <alltraps>

80106cb6 <vector119>:
.globl vector119
vector119:
  pushl $0
80106cb6:	6a 00                	push   $0x0
  pushl $119
80106cb8:	6a 77                	push   $0x77
  jmp alltraps
80106cba:	e9 da f5 ff ff       	jmp    80106299 <alltraps>

80106cbf <vector120>:
.globl vector120
vector120:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $120
80106cc1:	6a 78                	push   $0x78
  jmp alltraps
80106cc3:	e9 d1 f5 ff ff       	jmp    80106299 <alltraps>

80106cc8 <vector121>:
.globl vector121
vector121:
  pushl $0
80106cc8:	6a 00                	push   $0x0
  pushl $121
80106cca:	6a 79                	push   $0x79
  jmp alltraps
80106ccc:	e9 c8 f5 ff ff       	jmp    80106299 <alltraps>

80106cd1 <vector122>:
.globl vector122
vector122:
  pushl $0
80106cd1:	6a 00                	push   $0x0
  pushl $122
80106cd3:	6a 7a                	push   $0x7a
  jmp alltraps
80106cd5:	e9 bf f5 ff ff       	jmp    80106299 <alltraps>

80106cda <vector123>:
.globl vector123
vector123:
  pushl $0
80106cda:	6a 00                	push   $0x0
  pushl $123
80106cdc:	6a 7b                	push   $0x7b
  jmp alltraps
80106cde:	e9 b6 f5 ff ff       	jmp    80106299 <alltraps>

80106ce3 <vector124>:
.globl vector124
vector124:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $124
80106ce5:	6a 7c                	push   $0x7c
  jmp alltraps
80106ce7:	e9 ad f5 ff ff       	jmp    80106299 <alltraps>

80106cec <vector125>:
.globl vector125
vector125:
  pushl $0
80106cec:	6a 00                	push   $0x0
  pushl $125
80106cee:	6a 7d                	push   $0x7d
  jmp alltraps
80106cf0:	e9 a4 f5 ff ff       	jmp    80106299 <alltraps>

80106cf5 <vector126>:
.globl vector126
vector126:
  pushl $0
80106cf5:	6a 00                	push   $0x0
  pushl $126
80106cf7:	6a 7e                	push   $0x7e
  jmp alltraps
80106cf9:	e9 9b f5 ff ff       	jmp    80106299 <alltraps>

80106cfe <vector127>:
.globl vector127
vector127:
  pushl $0
80106cfe:	6a 00                	push   $0x0
  pushl $127
80106d00:	6a 7f                	push   $0x7f
  jmp alltraps
80106d02:	e9 92 f5 ff ff       	jmp    80106299 <alltraps>

80106d07 <vector128>:
.globl vector128
vector128:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $128
80106d09:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106d0e:	e9 86 f5 ff ff       	jmp    80106299 <alltraps>

80106d13 <vector129>:
.globl vector129
vector129:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $129
80106d15:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106d1a:	e9 7a f5 ff ff       	jmp    80106299 <alltraps>

80106d1f <vector130>:
.globl vector130
vector130:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $130
80106d21:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106d26:	e9 6e f5 ff ff       	jmp    80106299 <alltraps>

80106d2b <vector131>:
.globl vector131
vector131:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $131
80106d2d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106d32:	e9 62 f5 ff ff       	jmp    80106299 <alltraps>

80106d37 <vector132>:
.globl vector132
vector132:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $132
80106d39:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106d3e:	e9 56 f5 ff ff       	jmp    80106299 <alltraps>

80106d43 <vector133>:
.globl vector133
vector133:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $133
80106d45:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106d4a:	e9 4a f5 ff ff       	jmp    80106299 <alltraps>

80106d4f <vector134>:
.globl vector134
vector134:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $134
80106d51:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106d56:	e9 3e f5 ff ff       	jmp    80106299 <alltraps>

80106d5b <vector135>:
.globl vector135
vector135:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $135
80106d5d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106d62:	e9 32 f5 ff ff       	jmp    80106299 <alltraps>

80106d67 <vector136>:
.globl vector136
vector136:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $136
80106d69:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106d6e:	e9 26 f5 ff ff       	jmp    80106299 <alltraps>

80106d73 <vector137>:
.globl vector137
vector137:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $137
80106d75:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106d7a:	e9 1a f5 ff ff       	jmp    80106299 <alltraps>

80106d7f <vector138>:
.globl vector138
vector138:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $138
80106d81:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106d86:	e9 0e f5 ff ff       	jmp    80106299 <alltraps>

80106d8b <vector139>:
.globl vector139
vector139:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $139
80106d8d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106d92:	e9 02 f5 ff ff       	jmp    80106299 <alltraps>

80106d97 <vector140>:
.globl vector140
vector140:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $140
80106d99:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106d9e:	e9 f6 f4 ff ff       	jmp    80106299 <alltraps>

80106da3 <vector141>:
.globl vector141
vector141:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $141
80106da5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106daa:	e9 ea f4 ff ff       	jmp    80106299 <alltraps>

80106daf <vector142>:
.globl vector142
vector142:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $142
80106db1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106db6:	e9 de f4 ff ff       	jmp    80106299 <alltraps>

80106dbb <vector143>:
.globl vector143
vector143:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $143
80106dbd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106dc2:	e9 d2 f4 ff ff       	jmp    80106299 <alltraps>

80106dc7 <vector144>:
.globl vector144
vector144:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $144
80106dc9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106dce:	e9 c6 f4 ff ff       	jmp    80106299 <alltraps>

80106dd3 <vector145>:
.globl vector145
vector145:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $145
80106dd5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106dda:	e9 ba f4 ff ff       	jmp    80106299 <alltraps>

80106ddf <vector146>:
.globl vector146
vector146:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $146
80106de1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106de6:	e9 ae f4 ff ff       	jmp    80106299 <alltraps>

80106deb <vector147>:
.globl vector147
vector147:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $147
80106ded:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106df2:	e9 a2 f4 ff ff       	jmp    80106299 <alltraps>

80106df7 <vector148>:
.globl vector148
vector148:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $148
80106df9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106dfe:	e9 96 f4 ff ff       	jmp    80106299 <alltraps>

80106e03 <vector149>:
.globl vector149
vector149:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $149
80106e05:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106e0a:	e9 8a f4 ff ff       	jmp    80106299 <alltraps>

80106e0f <vector150>:
.globl vector150
vector150:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $150
80106e11:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106e16:	e9 7e f4 ff ff       	jmp    80106299 <alltraps>

80106e1b <vector151>:
.globl vector151
vector151:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $151
80106e1d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106e22:	e9 72 f4 ff ff       	jmp    80106299 <alltraps>

80106e27 <vector152>:
.globl vector152
vector152:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $152
80106e29:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106e2e:	e9 66 f4 ff ff       	jmp    80106299 <alltraps>

80106e33 <vector153>:
.globl vector153
vector153:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $153
80106e35:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106e3a:	e9 5a f4 ff ff       	jmp    80106299 <alltraps>

80106e3f <vector154>:
.globl vector154
vector154:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $154
80106e41:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106e46:	e9 4e f4 ff ff       	jmp    80106299 <alltraps>

80106e4b <vector155>:
.globl vector155
vector155:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $155
80106e4d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106e52:	e9 42 f4 ff ff       	jmp    80106299 <alltraps>

80106e57 <vector156>:
.globl vector156
vector156:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $156
80106e59:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106e5e:	e9 36 f4 ff ff       	jmp    80106299 <alltraps>

80106e63 <vector157>:
.globl vector157
vector157:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $157
80106e65:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106e6a:	e9 2a f4 ff ff       	jmp    80106299 <alltraps>

80106e6f <vector158>:
.globl vector158
vector158:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $158
80106e71:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106e76:	e9 1e f4 ff ff       	jmp    80106299 <alltraps>

80106e7b <vector159>:
.globl vector159
vector159:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $159
80106e7d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106e82:	e9 12 f4 ff ff       	jmp    80106299 <alltraps>

80106e87 <vector160>:
.globl vector160
vector160:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $160
80106e89:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106e8e:	e9 06 f4 ff ff       	jmp    80106299 <alltraps>

80106e93 <vector161>:
.globl vector161
vector161:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $161
80106e95:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106e9a:	e9 fa f3 ff ff       	jmp    80106299 <alltraps>

80106e9f <vector162>:
.globl vector162
vector162:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $162
80106ea1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106ea6:	e9 ee f3 ff ff       	jmp    80106299 <alltraps>

80106eab <vector163>:
.globl vector163
vector163:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $163
80106ead:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106eb2:	e9 e2 f3 ff ff       	jmp    80106299 <alltraps>

80106eb7 <vector164>:
.globl vector164
vector164:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $164
80106eb9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106ebe:	e9 d6 f3 ff ff       	jmp    80106299 <alltraps>

80106ec3 <vector165>:
.globl vector165
vector165:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $165
80106ec5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106eca:	e9 ca f3 ff ff       	jmp    80106299 <alltraps>

80106ecf <vector166>:
.globl vector166
vector166:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $166
80106ed1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106ed6:	e9 be f3 ff ff       	jmp    80106299 <alltraps>

80106edb <vector167>:
.globl vector167
vector167:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $167
80106edd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106ee2:	e9 b2 f3 ff ff       	jmp    80106299 <alltraps>

80106ee7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $168
80106ee9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106eee:	e9 a6 f3 ff ff       	jmp    80106299 <alltraps>

80106ef3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $169
80106ef5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106efa:	e9 9a f3 ff ff       	jmp    80106299 <alltraps>

80106eff <vector170>:
.globl vector170
vector170:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $170
80106f01:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106f06:	e9 8e f3 ff ff       	jmp    80106299 <alltraps>

80106f0b <vector171>:
.globl vector171
vector171:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $171
80106f0d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106f12:	e9 82 f3 ff ff       	jmp    80106299 <alltraps>

80106f17 <vector172>:
.globl vector172
vector172:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $172
80106f19:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106f1e:	e9 76 f3 ff ff       	jmp    80106299 <alltraps>

80106f23 <vector173>:
.globl vector173
vector173:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $173
80106f25:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106f2a:	e9 6a f3 ff ff       	jmp    80106299 <alltraps>

80106f2f <vector174>:
.globl vector174
vector174:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $174
80106f31:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106f36:	e9 5e f3 ff ff       	jmp    80106299 <alltraps>

80106f3b <vector175>:
.globl vector175
vector175:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $175
80106f3d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106f42:	e9 52 f3 ff ff       	jmp    80106299 <alltraps>

80106f47 <vector176>:
.globl vector176
vector176:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $176
80106f49:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106f4e:	e9 46 f3 ff ff       	jmp    80106299 <alltraps>

80106f53 <vector177>:
.globl vector177
vector177:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $177
80106f55:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106f5a:	e9 3a f3 ff ff       	jmp    80106299 <alltraps>

80106f5f <vector178>:
.globl vector178
vector178:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $178
80106f61:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106f66:	e9 2e f3 ff ff       	jmp    80106299 <alltraps>

80106f6b <vector179>:
.globl vector179
vector179:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $179
80106f6d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106f72:	e9 22 f3 ff ff       	jmp    80106299 <alltraps>

80106f77 <vector180>:
.globl vector180
vector180:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $180
80106f79:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106f7e:	e9 16 f3 ff ff       	jmp    80106299 <alltraps>

80106f83 <vector181>:
.globl vector181
vector181:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $181
80106f85:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106f8a:	e9 0a f3 ff ff       	jmp    80106299 <alltraps>

80106f8f <vector182>:
.globl vector182
vector182:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $182
80106f91:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106f96:	e9 fe f2 ff ff       	jmp    80106299 <alltraps>

80106f9b <vector183>:
.globl vector183
vector183:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $183
80106f9d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106fa2:	e9 f2 f2 ff ff       	jmp    80106299 <alltraps>

80106fa7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $184
80106fa9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106fae:	e9 e6 f2 ff ff       	jmp    80106299 <alltraps>

80106fb3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $185
80106fb5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106fba:	e9 da f2 ff ff       	jmp    80106299 <alltraps>

80106fbf <vector186>:
.globl vector186
vector186:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $186
80106fc1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106fc6:	e9 ce f2 ff ff       	jmp    80106299 <alltraps>

80106fcb <vector187>:
.globl vector187
vector187:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $187
80106fcd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106fd2:	e9 c2 f2 ff ff       	jmp    80106299 <alltraps>

80106fd7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $188
80106fd9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106fde:	e9 b6 f2 ff ff       	jmp    80106299 <alltraps>

80106fe3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $189
80106fe5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106fea:	e9 aa f2 ff ff       	jmp    80106299 <alltraps>

80106fef <vector190>:
.globl vector190
vector190:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $190
80106ff1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106ff6:	e9 9e f2 ff ff       	jmp    80106299 <alltraps>

80106ffb <vector191>:
.globl vector191
vector191:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $191
80106ffd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107002:	e9 92 f2 ff ff       	jmp    80106299 <alltraps>

80107007 <vector192>:
.globl vector192
vector192:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $192
80107009:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010700e:	e9 86 f2 ff ff       	jmp    80106299 <alltraps>

80107013 <vector193>:
.globl vector193
vector193:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $193
80107015:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010701a:	e9 7a f2 ff ff       	jmp    80106299 <alltraps>

8010701f <vector194>:
.globl vector194
vector194:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $194
80107021:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107026:	e9 6e f2 ff ff       	jmp    80106299 <alltraps>

8010702b <vector195>:
.globl vector195
vector195:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $195
8010702d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107032:	e9 62 f2 ff ff       	jmp    80106299 <alltraps>

80107037 <vector196>:
.globl vector196
vector196:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $196
80107039:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010703e:	e9 56 f2 ff ff       	jmp    80106299 <alltraps>

80107043 <vector197>:
.globl vector197
vector197:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $197
80107045:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010704a:	e9 4a f2 ff ff       	jmp    80106299 <alltraps>

8010704f <vector198>:
.globl vector198
vector198:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $198
80107051:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107056:	e9 3e f2 ff ff       	jmp    80106299 <alltraps>

8010705b <vector199>:
.globl vector199
vector199:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $199
8010705d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107062:	e9 32 f2 ff ff       	jmp    80106299 <alltraps>

80107067 <vector200>:
.globl vector200
vector200:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $200
80107069:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010706e:	e9 26 f2 ff ff       	jmp    80106299 <alltraps>

80107073 <vector201>:
.globl vector201
vector201:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $201
80107075:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010707a:	e9 1a f2 ff ff       	jmp    80106299 <alltraps>

8010707f <vector202>:
.globl vector202
vector202:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $202
80107081:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107086:	e9 0e f2 ff ff       	jmp    80106299 <alltraps>

8010708b <vector203>:
.globl vector203
vector203:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $203
8010708d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107092:	e9 02 f2 ff ff       	jmp    80106299 <alltraps>

80107097 <vector204>:
.globl vector204
vector204:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $204
80107099:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010709e:	e9 f6 f1 ff ff       	jmp    80106299 <alltraps>

801070a3 <vector205>:
.globl vector205
vector205:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $205
801070a5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801070aa:	e9 ea f1 ff ff       	jmp    80106299 <alltraps>

801070af <vector206>:
.globl vector206
vector206:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $206
801070b1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801070b6:	e9 de f1 ff ff       	jmp    80106299 <alltraps>

801070bb <vector207>:
.globl vector207
vector207:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $207
801070bd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801070c2:	e9 d2 f1 ff ff       	jmp    80106299 <alltraps>

801070c7 <vector208>:
.globl vector208
vector208:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $208
801070c9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801070ce:	e9 c6 f1 ff ff       	jmp    80106299 <alltraps>

801070d3 <vector209>:
.globl vector209
vector209:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $209
801070d5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801070da:	e9 ba f1 ff ff       	jmp    80106299 <alltraps>

801070df <vector210>:
.globl vector210
vector210:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $210
801070e1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801070e6:	e9 ae f1 ff ff       	jmp    80106299 <alltraps>

801070eb <vector211>:
.globl vector211
vector211:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $211
801070ed:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801070f2:	e9 a2 f1 ff ff       	jmp    80106299 <alltraps>

801070f7 <vector212>:
.globl vector212
vector212:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $212
801070f9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801070fe:	e9 96 f1 ff ff       	jmp    80106299 <alltraps>

80107103 <vector213>:
.globl vector213
vector213:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $213
80107105:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010710a:	e9 8a f1 ff ff       	jmp    80106299 <alltraps>

8010710f <vector214>:
.globl vector214
vector214:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $214
80107111:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107116:	e9 7e f1 ff ff       	jmp    80106299 <alltraps>

8010711b <vector215>:
.globl vector215
vector215:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $215
8010711d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107122:	e9 72 f1 ff ff       	jmp    80106299 <alltraps>

80107127 <vector216>:
.globl vector216
vector216:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $216
80107129:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010712e:	e9 66 f1 ff ff       	jmp    80106299 <alltraps>

80107133 <vector217>:
.globl vector217
vector217:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $217
80107135:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010713a:	e9 5a f1 ff ff       	jmp    80106299 <alltraps>

8010713f <vector218>:
.globl vector218
vector218:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $218
80107141:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107146:	e9 4e f1 ff ff       	jmp    80106299 <alltraps>

8010714b <vector219>:
.globl vector219
vector219:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $219
8010714d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107152:	e9 42 f1 ff ff       	jmp    80106299 <alltraps>

80107157 <vector220>:
.globl vector220
vector220:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $220
80107159:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010715e:	e9 36 f1 ff ff       	jmp    80106299 <alltraps>

80107163 <vector221>:
.globl vector221
vector221:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $221
80107165:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010716a:	e9 2a f1 ff ff       	jmp    80106299 <alltraps>

8010716f <vector222>:
.globl vector222
vector222:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $222
80107171:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107176:	e9 1e f1 ff ff       	jmp    80106299 <alltraps>

8010717b <vector223>:
.globl vector223
vector223:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $223
8010717d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107182:	e9 12 f1 ff ff       	jmp    80106299 <alltraps>

80107187 <vector224>:
.globl vector224
vector224:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $224
80107189:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010718e:	e9 06 f1 ff ff       	jmp    80106299 <alltraps>

80107193 <vector225>:
.globl vector225
vector225:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $225
80107195:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010719a:	e9 fa f0 ff ff       	jmp    80106299 <alltraps>

8010719f <vector226>:
.globl vector226
vector226:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $226
801071a1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801071a6:	e9 ee f0 ff ff       	jmp    80106299 <alltraps>

801071ab <vector227>:
.globl vector227
vector227:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $227
801071ad:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801071b2:	e9 e2 f0 ff ff       	jmp    80106299 <alltraps>

801071b7 <vector228>:
.globl vector228
vector228:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $228
801071b9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801071be:	e9 d6 f0 ff ff       	jmp    80106299 <alltraps>

801071c3 <vector229>:
.globl vector229
vector229:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $229
801071c5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801071ca:	e9 ca f0 ff ff       	jmp    80106299 <alltraps>

801071cf <vector230>:
.globl vector230
vector230:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $230
801071d1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801071d6:	e9 be f0 ff ff       	jmp    80106299 <alltraps>

801071db <vector231>:
.globl vector231
vector231:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $231
801071dd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801071e2:	e9 b2 f0 ff ff       	jmp    80106299 <alltraps>

801071e7 <vector232>:
.globl vector232
vector232:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $232
801071e9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801071ee:	e9 a6 f0 ff ff       	jmp    80106299 <alltraps>

801071f3 <vector233>:
.globl vector233
vector233:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $233
801071f5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801071fa:	e9 9a f0 ff ff       	jmp    80106299 <alltraps>

801071ff <vector234>:
.globl vector234
vector234:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $234
80107201:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107206:	e9 8e f0 ff ff       	jmp    80106299 <alltraps>

8010720b <vector235>:
.globl vector235
vector235:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $235
8010720d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107212:	e9 82 f0 ff ff       	jmp    80106299 <alltraps>

80107217 <vector236>:
.globl vector236
vector236:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $236
80107219:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010721e:	e9 76 f0 ff ff       	jmp    80106299 <alltraps>

80107223 <vector237>:
.globl vector237
vector237:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $237
80107225:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010722a:	e9 6a f0 ff ff       	jmp    80106299 <alltraps>

8010722f <vector238>:
.globl vector238
vector238:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $238
80107231:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107236:	e9 5e f0 ff ff       	jmp    80106299 <alltraps>

8010723b <vector239>:
.globl vector239
vector239:
  pushl $0
8010723b:	6a 00                	push   $0x0
  pushl $239
8010723d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107242:	e9 52 f0 ff ff       	jmp    80106299 <alltraps>

80107247 <vector240>:
.globl vector240
vector240:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $240
80107249:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010724e:	e9 46 f0 ff ff       	jmp    80106299 <alltraps>

80107253 <vector241>:
.globl vector241
vector241:
  pushl $0
80107253:	6a 00                	push   $0x0
  pushl $241
80107255:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010725a:	e9 3a f0 ff ff       	jmp    80106299 <alltraps>

8010725f <vector242>:
.globl vector242
vector242:
  pushl $0
8010725f:	6a 00                	push   $0x0
  pushl $242
80107261:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107266:	e9 2e f0 ff ff       	jmp    80106299 <alltraps>

8010726b <vector243>:
.globl vector243
vector243:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $243
8010726d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107272:	e9 22 f0 ff ff       	jmp    80106299 <alltraps>

80107277 <vector244>:
.globl vector244
vector244:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $244
80107279:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010727e:	e9 16 f0 ff ff       	jmp    80106299 <alltraps>

80107283 <vector245>:
.globl vector245
vector245:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $245
80107285:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010728a:	e9 0a f0 ff ff       	jmp    80106299 <alltraps>

8010728f <vector246>:
.globl vector246
vector246:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $246
80107291:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107296:	e9 fe ef ff ff       	jmp    80106299 <alltraps>

8010729b <vector247>:
.globl vector247
vector247:
  pushl $0
8010729b:	6a 00                	push   $0x0
  pushl $247
8010729d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801072a2:	e9 f2 ef ff ff       	jmp    80106299 <alltraps>

801072a7 <vector248>:
.globl vector248
vector248:
  pushl $0
801072a7:	6a 00                	push   $0x0
  pushl $248
801072a9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801072ae:	e9 e6 ef ff ff       	jmp    80106299 <alltraps>

801072b3 <vector249>:
.globl vector249
vector249:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $249
801072b5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801072ba:	e9 da ef ff ff       	jmp    80106299 <alltraps>

801072bf <vector250>:
.globl vector250
vector250:
  pushl $0
801072bf:	6a 00                	push   $0x0
  pushl $250
801072c1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801072c6:	e9 ce ef ff ff       	jmp    80106299 <alltraps>

801072cb <vector251>:
.globl vector251
vector251:
  pushl $0
801072cb:	6a 00                	push   $0x0
  pushl $251
801072cd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801072d2:	e9 c2 ef ff ff       	jmp    80106299 <alltraps>

801072d7 <vector252>:
.globl vector252
vector252:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $252
801072d9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801072de:	e9 b6 ef ff ff       	jmp    80106299 <alltraps>

801072e3 <vector253>:
.globl vector253
vector253:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $253
801072e5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801072ea:	e9 aa ef ff ff       	jmp    80106299 <alltraps>

801072ef <vector254>:
.globl vector254
vector254:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $254
801072f1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801072f6:	e9 9e ef ff ff       	jmp    80106299 <alltraps>

801072fb <vector255>:
.globl vector255
vector255:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $255
801072fd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107302:	e9 92 ef ff ff       	jmp    80106299 <alltraps>
80107307:	66 90                	xchg   %ax,%ax
80107309:	66 90                	xchg   %ax,%ax
8010730b:	66 90                	xchg   %ax,%ax
8010730d:	66 90                	xchg   %ax,%ax
8010730f:	90                   	nop

80107310 <cow_kfree>:
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc);
int swap_in(struct proc* p, struct pageinfo* pi);
void swap_out(struct proc* p, struct pageinfo* page_to_swap, void* buffer, pde_t* pgdir);

void cow_kfree(char* to_free_kva){
80107310:	55                   	push   %ebp
80107311:	89 e5                	mov    %esp,%ebp
80107313:	56                   	push   %esi
80107314:	53                   	push   %ebx
80107315:	8b 75 08             	mov    0x8(%ebp),%esi
  char count;
  int acq = 0;
  if (lapicid() != 0){
80107318:	e8 63 bc ff ff       	call   80102f80 <lapicid>
8010731d:	8d 9e 00 00 00 80    	lea    -0x80000000(%esi),%ebx
80107323:	c1 eb 0c             	shr    $0xc,%ebx
80107326:	85 c0                	test   %eax,%eax
80107328:	75 16                	jne    80107340 <cow_kfree+0x30>
    acquire(cow_lock);
  }
  // struct proc* p = myproc();
  // if (p != 0 ){ // && p->pid > 2
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
  if (count != 0){
8010732a:	80 ab 40 1f 11 80 01 	subb   $0x1,-0x7feee0c0(%ebx)
80107331:	74 43                	je     80107376 <cow_kfree+0x66>
  if (acq){
    // cprintf("rel kfree %d\n", myproc()->pid);
    release(cow_lock);
  }
  kfree(to_free_kva);
}
80107333:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107336:	5b                   	pop    %ebx
80107337:	5e                   	pop    %esi
80107338:	5d                   	pop    %ebp
80107339:	c3                   	ret    
8010733a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(cow_lock);
80107340:	83 ec 0c             	sub    $0xc,%esp
80107343:	ff 35 40 ff 11 80    	pushl  0x8011ff40
80107349:	e8 12 dc ff ff       	call   80104f60 <acquire>
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
8010734e:	0f b6 83 40 1f 11 80 	movzbl -0x7feee0c0(%ebx),%eax
  if (count != 0){
80107355:	83 c4 10             	add    $0x10,%esp
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
80107358:	83 e8 01             	sub    $0x1,%eax
  if (count != 0){
8010735b:	84 c0                	test   %al,%al
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
8010735d:	88 83 40 1f 11 80    	mov    %al,-0x7feee0c0(%ebx)
  if (count != 0){
80107363:	75 23                	jne    80107388 <cow_kfree+0x78>
    release(cow_lock);
80107365:	83 ec 0c             	sub    $0xc,%esp
80107368:	ff 35 40 ff 11 80    	pushl  0x8011ff40
8010736e:	e8 ad dc ff ff       	call   80105020 <release>
80107373:	83 c4 10             	add    $0x10,%esp
  kfree(to_free_kva);
80107376:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107379:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010737c:	5b                   	pop    %ebx
8010737d:	5e                   	pop    %esi
8010737e:	5d                   	pop    %ebp
  kfree(to_free_kva);
8010737f:	e9 ac b7 ff ff       	jmp    80102b30 <kfree>
80107384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(cow_lock);
80107388:	a1 40 ff 11 80       	mov    0x8011ff40,%eax
8010738d:	89 45 08             	mov    %eax,0x8(%ebp)
}
80107390:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107393:	5b                   	pop    %ebx
80107394:	5e                   	pop    %esi
80107395:	5d                   	pop    %ebp
      release(cow_lock);
80107396:	e9 85 dc ff ff       	jmp    80105020 <release>
8010739b:	90                   	nop
8010739c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801073a0 <cow_kalloc>:

char* cow_kalloc(){
801073a0:	55                   	push   %ebp
801073a1:	89 e5                	mov    %esp,%ebp
801073a3:	57                   	push   %edi
801073a4:	56                   	push   %esi
801073a5:	53                   	push   %ebx
801073a6:	83 ec 0c             	sub    $0xc,%esp
  char* r = kalloc();
801073a9:	e8 62 b9 ff ff       	call   80102d10 <kalloc>
  if (r == 0){
801073ae:	85 c0                	test   %eax,%eax
  char* r = kalloc();
801073b0:	89 c3                	mov    %eax,%ebx
  if (r == 0){
801073b2:	74 28                	je     801073dc <cow_kalloc+0x3c>
801073b4:	8d bb 00 00 00 80    	lea    -0x80000000(%ebx),%edi
    return r;
  }
  int acq = 0;
  // cprintf("kalloc \n");
  if (lapicid() != 0){
801073ba:	e8 c1 bb ff ff       	call   80102f80 <lapicid>
801073bf:	89 fe                	mov    %edi,%esi
801073c1:	c1 ee 0c             	shr    $0xc,%esi
801073c4:	85 c0                	test   %eax,%eax
801073c6:	75 28                	jne    801073f0 <cow_kalloc+0x50>
    acq = 1;
    // cprintf("kalloc %d\n", myproc()->pid);
    acquire(cow_lock);
  }
  if (pg_ref_counts[PGROUNDDOWN(V2P(r)) / PGSIZE]++ != 0){ 
801073c8:	0f b6 86 40 1f 11 80 	movzbl -0x7feee0c0(%esi),%eax
801073cf:	8d 50 01             	lea    0x1(%eax),%edx
801073d2:	84 c0                	test   %al,%al
801073d4:	88 96 40 1f 11 80    	mov    %dl,-0x7feee0c0(%esi)
801073da:	75 54                	jne    80107430 <cow_kalloc+0x90>
  }
  if (acq){
    release(cow_lock);
  }
  return r;
}
801073dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073df:	89 d8                	mov    %ebx,%eax
801073e1:	5b                   	pop    %ebx
801073e2:	5e                   	pop    %esi
801073e3:	5f                   	pop    %edi
801073e4:	5d                   	pop    %ebp
801073e5:	c3                   	ret    
801073e6:	8d 76 00             	lea    0x0(%esi),%esi
801073e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    acquire(cow_lock);
801073f0:	83 ec 0c             	sub    $0xc,%esp
801073f3:	ff 35 40 ff 11 80    	pushl  0x8011ff40
801073f9:	e8 62 db ff ff       	call   80104f60 <acquire>
  if (pg_ref_counts[PGROUNDDOWN(V2P(r)) / PGSIZE]++ != 0){ 
801073fe:	0f b6 86 40 1f 11 80 	movzbl -0x7feee0c0(%esi),%eax
80107405:	83 c4 10             	add    $0x10,%esp
80107408:	8d 50 01             	lea    0x1(%eax),%edx
8010740b:	84 c0                	test   %al,%al
8010740d:	88 96 40 1f 11 80    	mov    %dl,-0x7feee0c0(%esi)
80107413:	75 1b                	jne    80107430 <cow_kalloc+0x90>
      release(cow_lock);
80107415:	83 ec 0c             	sub    $0xc,%esp
80107418:	ff 35 40 ff 11 80    	pushl  0x8011ff40
8010741e:	e8 fd db ff ff       	call   80105020 <release>
80107423:	83 c4 10             	add    $0x10,%esp
}
80107426:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107429:	89 d8                	mov    %ebx,%eax
8010742b:	5b                   	pop    %ebx
8010742c:	5e                   	pop    %esi
8010742d:	5f                   	pop    %edi
8010742e:	5d                   	pop    %ebp
8010742f:	c3                   	ret    
    cprintf("actual ref count = %d, pg index = %x, pg pa = %x\n", pg_ref_counts[PGROUNDDOWN(V2P(r)) / PGSIZE] - 1, PGROUNDDOWN(V2P(r)) / PGSIZE, V2P(r));
80107430:	0f be c2             	movsbl %dl,%eax
80107433:	57                   	push   %edi
80107434:	56                   	push   %esi
80107435:	83 e8 01             	sub    $0x1,%eax
80107438:	50                   	push   %eax
80107439:	68 1c 93 10 80       	push   $0x8010931c
8010743e:	e8 1d 92 ff ff       	call   80100660 <cprintf>
    panic("kalloc allocated something with a reference");
80107443:	c7 04 24 50 93 10 80 	movl   $0x80109350,(%esp)
8010744a:	e8 41 8f ff ff       	call   80100390 <panic>
8010744f:	90                   	nop

80107450 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107450:	55                   	push   %ebp
80107451:	89 e5                	mov    %esp,%ebp
80107453:	57                   	push   %edi
80107454:	56                   	push   %esi
80107455:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107456:	89 d3                	mov    %edx,%ebx
{
80107458:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010745a:	c1 eb 16             	shr    $0x16,%ebx
8010745d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107460:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107463:	8b 06                	mov    (%esi),%eax
80107465:	a8 01                	test   $0x1,%al
80107467:	74 27                	je     80107490 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107469:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010746e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107474:	c1 ef 0a             	shr    $0xa,%edi
}
80107477:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010747a:	89 fa                	mov    %edi,%edx
8010747c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107482:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107485:	5b                   	pop    %ebx
80107486:	5e                   	pop    %esi
80107487:	5f                   	pop    %edi
80107488:	5d                   	pop    %ebp
80107489:	c3                   	ret    
8010748a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)cow_kalloc()) == 0)
80107490:	85 c9                	test   %ecx,%ecx
80107492:	74 2c                	je     801074c0 <walkpgdir+0x70>
80107494:	e8 07 ff ff ff       	call   801073a0 <cow_kalloc>
80107499:	85 c0                	test   %eax,%eax
8010749b:	89 c3                	mov    %eax,%ebx
8010749d:	74 21                	je     801074c0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010749f:	83 ec 04             	sub    $0x4,%esp
801074a2:	68 00 10 00 00       	push   $0x1000
801074a7:	6a 00                	push   $0x0
801074a9:	50                   	push   %eax
801074aa:	e8 c1 db ff ff       	call   80105070 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801074af:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801074b5:	83 c4 10             	add    $0x10,%esp
801074b8:	83 c8 07             	or     $0x7,%eax
801074bb:	89 06                	mov    %eax,(%esi)
801074bd:	eb b5                	jmp    80107474 <walkpgdir+0x24>
801074bf:	90                   	nop
}
801074c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801074c3:	31 c0                	xor    %eax,%eax
}
801074c5:	5b                   	pop    %ebx
801074c6:	5e                   	pop    %esi
801074c7:	5f                   	pop    %edi
801074c8:	5d                   	pop    %ebp
801074c9:	c3                   	ret    
801074ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801074d0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801074d0:	55                   	push   %ebp
801074d1:	89 e5                	mov    %esp,%ebp
801074d3:	57                   	push   %edi
801074d4:	56                   	push   %esi
801074d5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801074d6:	89 d3                	mov    %edx,%ebx
801074d8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801074de:	83 ec 1c             	sub    $0x1c,%esp
801074e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801074e4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801074e8:	8b 7d 08             	mov    0x8(%ebp),%edi
801074eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801074f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801074f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801074f6:	29 df                	sub    %ebx,%edi
801074f8:	83 c8 01             	or     $0x1,%eax
801074fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
801074fe:	eb 15                	jmp    80107515 <mappages+0x45>
    if(*pte & PTE_P)
80107500:	f6 00 01             	testb  $0x1,(%eax)
80107503:	75 45                	jne    8010754a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107505:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107508:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010750b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010750d:	74 31                	je     80107540 <mappages+0x70>
      break;
    a += PGSIZE;
8010750f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107515:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107518:	b9 01 00 00 00       	mov    $0x1,%ecx
8010751d:	89 da                	mov    %ebx,%edx
8010751f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107522:	e8 29 ff ff ff       	call   80107450 <walkpgdir>
80107527:	85 c0                	test   %eax,%eax
80107529:	75 d5                	jne    80107500 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010752b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010752e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107533:	5b                   	pop    %ebx
80107534:	5e                   	pop    %esi
80107535:	5f                   	pop    %edi
80107536:	5d                   	pop    %ebp
80107537:	c3                   	ret    
80107538:	90                   	nop
80107539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107540:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107543:	31 c0                	xor    %eax,%eax
}
80107545:	5b                   	pop    %ebx
80107546:	5e                   	pop    %esi
80107547:	5f                   	pop    %edi
80107548:	5d                   	pop    %ebp
80107549:	c3                   	ret    
      panic("remap");
8010754a:	83 ec 0c             	sub    $0xc,%esp
8010754d:	68 f4 93 10 80       	push   $0x801093f4
80107552:	e8 39 8e ff ff       	call   80100390 <panic>
80107557:	89 f6                	mov    %esi,%esi
80107559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107560 <printQ>:
void printQ(struct proc* p){
80107560:	55                   	push   %ebp
80107561:	89 e5                	mov    %esp,%ebp
80107563:	56                   	push   %esi
80107564:	53                   	push   %ebx
80107565:	8b 75 08             	mov    0x8(%ebp),%esi
80107568:	8d 9e 80 03 00 00    	lea    0x380(%esi),%ebx
8010756e:	81 c6 c0 03 00 00    	add    $0x3c0,%esi
80107574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d, ",p->advance_queue[i]);
80107578:	83 ec 08             	sub    $0x8,%esp
8010757b:	ff 33                	pushl  (%ebx)
8010757d:	83 c3 04             	add    $0x4,%ebx
80107580:	68 fa 93 10 80       	push   $0x801093fa
80107585:	e8 d6 90 ff ff       	call   80100660 <cprintf>
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
8010758a:	83 c4 10             	add    $0x10,%esp
8010758d:	39 f3                	cmp    %esi,%ebx
8010758f:	75 e7                	jne    80107578 <printQ+0x18>
  cprintf("\n");
80107591:	c7 45 08 8e 95 10 80 	movl   $0x8010958e,0x8(%ebp)
}
80107598:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010759b:	5b                   	pop    %ebx
8010759c:	5e                   	pop    %esi
8010759d:	5d                   	pop    %ebp
  cprintf("\n");
8010759e:	e9 bd 90 ff ff       	jmp    80100660 <cprintf>
801075a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801075a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801075b0 <add_page_index_to_queue>:
  void add_page_index_to_queue(struct proc* p, int index){
801075b0:	55                   	push   %ebp
801075b1:	89 e5                	mov    %esp,%ebp
801075b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
    while (p->advance_queue[i]==-1){
801075b6:	83 b9 80 03 00 00 ff 	cmpl   $0xffffffff,0x380(%ecx)
801075bd:	75 29                	jne    801075e8 <add_page_index_to_queue+0x38>
    int i=0;
801075bf:	31 d2                	xor    %edx,%edx
801075c1:	eb 07                	jmp    801075ca <add_page_index_to_queue+0x1a>
801075c3:	90                   	nop
801075c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      i++;
801075c8:	89 c2                	mov    %eax,%edx
801075ca:	8d 42 01             	lea    0x1(%edx),%eax
    while (p->advance_queue[i]==-1){
801075cd:	83 bc 81 80 03 00 00 	cmpl   $0xffffffff,0x380(%ecx,%eax,4)
801075d4:	ff 
801075d5:	74 f1                	je     801075c8 <add_page_index_to_queue+0x18>
    p->advance_queue[i]= index;
801075d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801075da:	89 84 91 80 03 00 00 	mov    %eax,0x380(%ecx,%edx,4)
  }
801075e1:	5d                   	pop    %ebp
801075e2:	c3                   	ret    
801075e3:	90                   	nop
801075e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->advance_queue[i]= index;
801075e8:	8b 45 0c             	mov    0xc(%ebp),%eax
    while (p->advance_queue[i]==-1){
801075eb:	ba ff ff ff ff       	mov    $0xffffffff,%edx
    p->advance_queue[i]= index;
801075f0:	89 84 91 80 03 00 00 	mov    %eax,0x380(%ecx,%edx,4)
  }
801075f7:	5d                   	pop    %ebp
801075f8:	c3                   	ret    
801075f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107600 <remove_page_index_from_q>:
  void remove_page_index_from_q(struct proc* p, int index){
80107600:	55                   	push   %ebp
    for(  i =15; i>0; i--){
80107601:	b8 0f 00 00 00       	mov    $0xf,%eax
  void remove_page_index_from_q(struct proc* p, int index){
80107606:	89 e5                	mov    %esp,%ebp
80107608:	53                   	push   %ebx
80107609:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010760c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010760f:	eb 0d                	jmp    8010761e <remove_page_index_from_q+0x1e>
80107611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(  i =15; i>0; i--){
80107618:	85 d2                	test   %edx,%edx
8010761a:	89 d0                	mov    %edx,%eax
8010761c:	74 41                	je     8010765f <remove_page_index_from_q+0x5f>
      if(p->advance_queue[i]==index){
8010761e:	39 9c 81 80 03 00 00 	cmp    %ebx,0x380(%ecx,%eax,4)
80107625:	8d 50 ff             	lea    -0x1(%eax),%edx
80107628:	75 ee                	jne    80107618 <remove_page_index_from_q+0x18>
        p->advance_queue[i] = -1;
8010762a:	c7 84 81 80 03 00 00 	movl   $0xffffffff,0x380(%ecx,%eax,4)
80107631:	ff ff ff ff 
80107635:	eb 0c                	jmp    80107643 <remove_page_index_from_q+0x43>
80107637:	89 f6                	mov    %esi,%esi
80107639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107640:	83 ea 01             	sub    $0x1,%edx
        p->advance_queue[i] = p->advance_queue[i-1];
80107643:	8b 84 91 80 03 00 00 	mov    0x380(%ecx,%edx,4),%eax
      while(i>0){
8010764a:	85 d2                	test   %edx,%edx
        p->advance_queue[i] = p->advance_queue[i-1];
8010764c:	89 84 91 84 03 00 00 	mov    %eax,0x384(%ecx,%edx,4)
      while(i>0){
80107653:	75 eb                	jne    80107640 <remove_page_index_from_q+0x40>
      p->advance_queue[0] = -1;
80107655:	c7 81 80 03 00 00 ff 	movl   $0xffffffff,0x380(%ecx)
8010765c:	ff ff ff 
  }
8010765f:	5b                   	pop    %ebx
80107660:	5d                   	pop    %ebp
80107661:	c3                   	ret    
80107662:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107670 <find_page_to_swap_aq>:
  struct pageinfo* find_page_to_swap_aq(struct proc* p){
80107670:	55                   	push   %ebp
80107671:	89 e5                	mov    %esp,%ebp
80107673:	56                   	push   %esi
80107674:	53                   	push   %ebx
80107675:	8b 5d 08             	mov    0x8(%ebp),%ebx
    cprintf("page index AQ: %d\n",page_index);
80107678:	83 ec 08             	sub    $0x8,%esp
    int page_index = p->advance_queue[15];
8010767b:	8b b3 bc 03 00 00    	mov    0x3bc(%ebx),%esi
    cprintf("page index AQ: %d\n",page_index);
80107681:	56                   	push   %esi
80107682:	68 ff 93 10 80       	push   $0x801093ff
80107687:	e8 d4 8f ff ff       	call   80100660 <cprintf>
    if (page_index==-1){
8010768c:	83 c4 10             	add    $0x10,%esp
8010768f:	83 fe ff             	cmp    $0xffffffff,%esi
80107692:	74 33                	je     801076c7 <find_page_to_swap_aq+0x57>
80107694:	8d 83 b8 03 00 00    	lea    0x3b8(%ebx),%eax
8010769a:	8d 8b 7c 03 00 00    	lea    0x37c(%ebx),%ecx
      p->advance_queue[i] = p->advance_queue[i-1];
801076a0:	8b 10                	mov    (%eax),%edx
801076a2:	83 e8 04             	sub    $0x4,%eax
801076a5:	89 50 08             	mov    %edx,0x8(%eax)
    for (int i = 15; i>0; i--){
801076a8:	39 c8                	cmp    %ecx,%eax
801076aa:	75 f4                	jne    801076a0 <find_page_to_swap_aq+0x30>
    p->advance_queue[0]= -1;
801076ac:	c7 83 80 03 00 00 ff 	movl   $0xffffffff,0x380(%ebx)
801076b3:	ff ff ff 
    return &(p->ram_pages[page_index]);
801076b6:	8d 04 76             	lea    (%esi,%esi,2),%eax
  }
801076b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return &(p->ram_pages[page_index]);
801076bc:	8d 84 c3 00 02 00 00 	lea    0x200(%ebx,%eax,8),%eax
  }
801076c3:	5b                   	pop    %ebx
801076c4:	5e                   	pop    %esi
801076c5:	5d                   	pop    %ebp
801076c6:	c3                   	ret    
      panic("queue is empty");
801076c7:	83 ec 0c             	sub    $0xc,%esp
801076ca:	68 12 94 10 80       	push   $0x80109412
801076cf:	e8 bc 8c ff ff       	call   80100390 <panic>
801076d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801076da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801076e0 <update_queue>:
  void update_queue(struct proc* p){
801076e0:	55                   	push   %ebp
801076e1:	89 e5                	mov    %esp,%ebp
801076e3:	57                   	push   %edi
801076e4:	56                   	push   %esi
801076e5:	53                   	push   %ebx
    int i=15;
801076e6:	be 0f 00 00 00       	mov    $0xf,%esi
  void update_queue(struct proc* p){
801076eb:	83 ec 28             	sub    $0x28,%esp
801076ee:	8b 7d 08             	mov    0x8(%ebp),%edi
    cprintf("before update: ");printQ(p);
801076f1:	68 21 94 10 80       	push   $0x80109421
801076f6:	e8 65 8f ff ff       	call   80100660 <cprintf>
801076fb:	89 3c 24             	mov    %edi,(%esp)
801076fe:	e8 5d fe ff ff       	call   80107560 <printQ>
80107703:	83 c4 10             	add    $0x10,%esp
80107706:	eb 13                	jmp    8010771b <update_queue+0x3b>
80107708:	90                   	nop
80107709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        i--;
80107710:	8b 75 dc             	mov    -0x24(%ebp),%esi
    while (i>0){
80107713:	85 f6                	test   %esi,%esi
80107715:	0f 8e 9e 00 00 00    	jle    801077b9 <update_queue+0xd9>
8010771b:	8d 04 b7             	lea    (%edi,%esi,4),%eax
      if (p->advance_queue[i] == -1){
8010771e:	8b 98 80 03 00 00    	mov    0x380(%eax),%ebx
80107724:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107727:	83 fb ff             	cmp    $0xffffffff,%ebx
8010772a:	0f 84 89 00 00 00    	je     801077b9 <update_queue+0xd9>
      int prev_index = p->advance_queue[i-1];
80107730:	8b 80 7c 03 00 00    	mov    0x37c(%eax),%eax
      pte_t* curr_pte = walkpgdir(p->pgdir,(void*) p->ram_pages[curr_index].va, 0);
80107736:	8d 14 5b             	lea    (%ebx,%ebx,2),%edx
      int prev_index = p->advance_queue[i-1];
80107739:	8d 4e ff             	lea    -0x1(%esi),%ecx
      pte_t* curr_pte = walkpgdir(p->pgdir,(void*) p->ram_pages[curr_index].va, 0);
8010773c:	8b 94 d7 10 02 00 00 	mov    0x210(%edi,%edx,8),%edx
      int prev_index = p->advance_queue[i-1];
80107743:	89 4d dc             	mov    %ecx,-0x24(%ebp)
      pte_t* curr_pte = walkpgdir(p->pgdir,(void*) p->ram_pages[curr_index].va, 0);
80107746:	31 c9                	xor    %ecx,%ecx
      int prev_index = p->advance_queue[i-1];
80107748:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      pte_t* curr_pte = walkpgdir(p->pgdir,(void*) p->ram_pages[curr_index].va, 0);
8010774b:	8b 47 04             	mov    0x4(%edi),%eax
8010774e:	e8 fd fc ff ff       	call   80107450 <walkpgdir>
      pte_t* prev_pte = walkpgdir(p->pgdir,(void*) p->ram_pages[prev_index].va, 0);
80107753:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
      pte_t* curr_pte = walkpgdir(p->pgdir,(void*) p->ram_pages[curr_index].va, 0);
80107756:	89 45 e0             	mov    %eax,-0x20(%ebp)
      pte_t* prev_pte = walkpgdir(p->pgdir,(void*) p->ram_pages[prev_index].va, 0);
80107759:	8b 47 04             	mov    0x4(%edi),%eax
8010775c:	8d 14 49             	lea    (%ecx,%ecx,2),%edx
8010775f:	31 c9                	xor    %ecx,%ecx
80107761:	8b 94 d7 10 02 00 00 	mov    0x210(%edi,%edx,8),%edx
80107768:	e8 e3 fc ff ff       	call   80107450 <walkpgdir>
      if(!(uint)*curr_pte || !(uint)*prev_pte ){
8010776d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80107770:	8b 11                	mov    (%ecx),%edx
80107772:	85 d2                	test   %edx,%edx
80107774:	74 6e                	je     801077e4 <update_queue+0x104>
80107776:	8b 00                	mov    (%eax),%eax
80107778:	85 c0                	test   %eax,%eax
8010777a:	74 68                	je     801077e4 <update_queue+0x104>
      if ((*curr_pte & PTE_A)&& ((*prev_pte & PTE_A)==0) ){//curr accessed and prev not, swich them
8010777c:	83 e2 20             	and    $0x20,%edx
8010777f:	74 8f                	je     80107710 <update_queue+0x30>
80107781:	a8 20                	test   $0x20,%al
80107783:	75 8b                	jne    80107710 <update_queue+0x30>
        cprintf("p was accessed: %d\n", curr_index);
80107785:	83 ec 08             	sub    $0x8,%esp
        i=i-2;
80107788:	83 ee 02             	sub    $0x2,%esi
        cprintf("p was accessed: %d\n", curr_index);
8010778b:	53                   	push   %ebx
8010778c:	68 49 94 10 80       	push   $0x80109449
80107791:	e8 ca 8e ff ff       	call   80100660 <cprintf>
        *curr_pte &= ~PTE_A;
80107796:	8b 45 e0             	mov    -0x20(%ebp),%eax
        p->advance_queue[i] = prev_index;
80107799:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
        i=i-2;
8010779c:	83 c4 10             	add    $0x10,%esp
        *curr_pte &= ~PTE_A;
8010779f:	83 20 df             	andl   $0xffffffdf,(%eax)
        p->advance_queue[i] = prev_index;
801077a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
    while (i>0){
801077a5:	85 f6                	test   %esi,%esi
        p->advance_queue[i] = prev_index;
801077a7:	89 88 80 03 00 00    	mov    %ecx,0x380(%eax)
        p->advance_queue[i-1] = curr_index;
801077ad:	89 98 7c 03 00 00    	mov    %ebx,0x37c(%eax)
    while (i>0){
801077b3:	0f 8f 62 ff ff ff    	jg     8010771b <update_queue+0x3b>
    cprintf("after update: "); printQ(p);
801077b9:	83 ec 0c             	sub    $0xc,%esp
801077bc:	68 5d 94 10 80       	push   $0x8010945d
801077c1:	e8 9a 8e ff ff       	call   80100660 <cprintf>
801077c6:	89 3c 24             	mov    %edi,(%esp)
801077c9:	e8 92 fd ff ff       	call   80107560 <printQ>
    lcr3(V2P(p->pgdir));//verify
801077ce:	8b 47 04             	mov    0x4(%edi),%eax
801077d1:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801077d6:	0f 22 d8             	mov    %eax,%cr3
  }
801077d9:	83 c4 10             	add    $0x10,%esp
801077dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077df:	5b                   	pop    %ebx
801077e0:	5e                   	pop    %esi
801077e1:	5f                   	pop    %edi
801077e2:	5d                   	pop    %ebp
801077e3:	c3                   	ret    
        panic("can't find page from AQ");
801077e4:	83 ec 0c             	sub    $0xc,%esp
801077e7:	68 31 94 10 80       	push   $0x80109431
801077ec:	e8 9f 8b ff ff       	call   80100390 <panic>
801077f1:	eb 0d                	jmp    80107800 <find_page_to_swap>
801077f3:	90                   	nop
801077f4:	90                   	nop
801077f5:	90                   	nop
801077f6:	90                   	nop
801077f7:	90                   	nop
801077f8:	90                   	nop
801077f9:	90                   	nop
801077fa:	90                   	nop
801077fb:	90                   	nop
801077fc:	90                   	nop
801077fd:	90                   	nop
801077fe:	90                   	nop
801077ff:	90                   	nop

80107800 <find_page_to_swap>:
struct pageinfo* find_page_to_swap(struct proc* p, pde_t* pgdir){
80107800:	55                   	push   %ebp
80107801:	89 e5                	mov    %esp,%ebp
80107803:	53                   	push   %ebx
80107804:	83 ec 10             	sub    $0x10,%esp
80107807:	8b 5d 08             	mov    0x8(%ebp),%ebx
    update_queue(p);
8010780a:	53                   	push   %ebx
8010780b:	e8 d0 fe ff ff       	call   801076e0 <update_queue>
    pi = find_page_to_swap_aq(p);
80107810:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107813:	83 c4 10             	add    $0x10,%esp
}
80107816:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107819:	c9                   	leave  
    pi = find_page_to_swap_aq(p);
8010781a:	e9 51 fe ff ff       	jmp    80107670 <find_page_to_swap_aq>
8010781f:	90                   	nop

80107820 <find_page_to_swap1>:
struct pageinfo* find_page_to_swap1(struct proc* p, pde_t* pgdir){
80107820:	55                   	push   %ebp
  j = j % 16;
80107821:	99                   	cltd   
80107822:	c1 ea 1c             	shr    $0x1c,%edx
struct pageinfo* find_page_to_swap1(struct proc* p, pde_t* pgdir){
80107825:	89 e5                	mov    %esp,%ebp
80107827:	57                   	push   %edi
80107828:	56                   	push   %esi
80107829:	53                   	push   %ebx
  j = j % 16;
8010782a:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
8010782d:	83 e3 0f             	and    $0xf,%ebx
struct pageinfo* find_page_to_swap1(struct proc* p, pde_t* pgdir){
80107830:	83 ec 14             	sub    $0x14,%esp
  j = j % 16;
80107833:	29 d3                	sub    %edx,%ebx
  cprintf("%d\n", j);
80107835:	53                   	push   %ebx
  for (int i = j; i != (j - 1) % 16; i = (i + 1) % 16){
80107836:	8d 73 ff             	lea    -0x1(%ebx),%esi
  cprintf("%d\n", j);
80107839:	68 0e 94 10 80       	push   $0x8010940e
8010783e:	e8 1d 8e ff ff       	call   80100660 <cprintf>
  for (int i = j; i != (j - 1) % 16; i = (i + 1) % 16){
80107843:	89 f0                	mov    %esi,%eax
80107845:	83 c4 10             	add    $0x10,%esp
80107848:	c1 f8 1f             	sar    $0x1f,%eax
8010784b:	c1 e8 1c             	shr    $0x1c,%eax
8010784e:	01 c6                	add    %eax,%esi
80107850:	83 e6 0f             	and    $0xf,%esi
80107853:	29 c6                	sub    %eax,%esi
80107855:	39 f3                	cmp    %esi,%ebx
80107857:	74 57                	je     801078b0 <find_page_to_swap1+0x90>
80107859:	89 df                	mov    %ebx,%edi
8010785b:	eb 17                	jmp    80107874 <find_page_to_swap1+0x54>
8010785d:	8d 76 00             	lea    0x0(%esi),%esi
80107860:	8d 47 01             	lea    0x1(%edi),%eax
80107863:	99                   	cltd   
80107864:	c1 ea 1c             	shr    $0x1c,%edx
80107867:	01 d0                	add    %edx,%eax
80107869:	83 e0 0f             	and    $0xf,%eax
8010786c:	29 d0                	sub    %edx,%eax
8010786e:	39 f0                	cmp    %esi,%eax
80107870:	89 c7                	mov    %eax,%edi
80107872:	74 3c                	je     801078b0 <find_page_to_swap1+0x90>
    cprintf("%d\n", j);
80107874:	83 ec 08             	sub    $0x8,%esp
80107877:	53                   	push   %ebx
80107878:	68 0e 94 10 80       	push   $0x8010940e
8010787d:	e8 de 8d ff ff       	call   80100660 <cprintf>
    if (!p->ram_pages[i].is_free){
80107882:	8d 14 7f             	lea    (%edi,%edi,2),%edx
80107885:	8b 45 08             	mov    0x8(%ebp),%eax
80107888:	83 c4 10             	add    $0x10,%esp
8010788b:	c1 e2 03             	shl    $0x3,%edx
8010788e:	8b 8c 10 00 02 00 00 	mov    0x200(%eax,%edx,1),%ecx
80107895:	85 c9                	test   %ecx,%ecx
80107897:	75 c7                	jne    80107860 <find_page_to_swap1+0x40>
}
80107899:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return &p->ram_pages[i];
8010789c:	8d 84 10 00 02 00 00 	lea    0x200(%eax,%edx,1),%eax
}
801078a3:	5b                   	pop    %ebx
801078a4:	5e                   	pop    %esi
801078a5:	5f                   	pop    %edi
801078a6:	5d                   	pop    %ebp
801078a7:	c3                   	ret    
801078a8:	90                   	nop
801078a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801078b3:	31 c0                	xor    %eax,%eax
}
801078b5:	5b                   	pop    %ebx
801078b6:	5e                   	pop    %esi
801078b7:	5f                   	pop    %edi
801078b8:	5d                   	pop    %ebp
801078b9:	c3                   	ret    
801078ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801078c0 <seginit>:
{
801078c0:	55                   	push   %ebp
801078c1:	89 e5                	mov    %esp,%ebp
801078c3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801078c6:	e8 e5 c7 ff ff       	call   801040b0 <cpuid>
801078cb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
801078d1:	ba 2f 00 00 00       	mov    $0x2f,%edx
801078d6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801078da:	c7 80 78 28 12 80 ff 	movl   $0xffff,-0x7fedd788(%eax)
801078e1:	ff 00 00 
801078e4:	c7 80 7c 28 12 80 00 	movl   $0xcf9a00,-0x7fedd784(%eax)
801078eb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801078ee:	c7 80 80 28 12 80 ff 	movl   $0xffff,-0x7fedd780(%eax)
801078f5:	ff 00 00 
801078f8:	c7 80 84 28 12 80 00 	movl   $0xcf9200,-0x7fedd77c(%eax)
801078ff:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107902:	c7 80 88 28 12 80 ff 	movl   $0xffff,-0x7fedd778(%eax)
80107909:	ff 00 00 
8010790c:	c7 80 8c 28 12 80 00 	movl   $0xcffa00,-0x7fedd774(%eax)
80107913:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107916:	c7 80 90 28 12 80 ff 	movl   $0xffff,-0x7fedd770(%eax)
8010791d:	ff 00 00 
80107920:	c7 80 94 28 12 80 00 	movl   $0xcff200,-0x7fedd76c(%eax)
80107927:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010792a:	05 70 28 12 80       	add    $0x80122870,%eax
  pd[1] = (uint)p;
8010792f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107933:	c1 e8 10             	shr    $0x10,%eax
80107936:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010793a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010793d:	0f 01 10             	lgdtl  (%eax)
}
80107940:	c9                   	leave  
80107941:	c3                   	ret    
80107942:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107950 <public_walkpgdir>:
public_walkpgdir(pde_t *pgdir, const void *va, int alloc){
80107950:	55                   	push   %ebp
80107951:	89 e5                	mov    %esp,%ebp
  return walkpgdir(pgdir, va, alloc);
80107953:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107956:	8b 55 0c             	mov    0xc(%ebp),%edx
80107959:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010795c:	5d                   	pop    %ebp
  return walkpgdir(pgdir, va, alloc);
8010795d:	e9 ee fa ff ff       	jmp    80107450 <walkpgdir>
80107962:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107970 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107970:	a1 24 2a 13 80       	mov    0x80132a24,%eax
{
80107975:	55                   	push   %ebp
80107976:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107978:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010797d:	0f 22 d8             	mov    %eax,%cr3
}
80107980:	5d                   	pop    %ebp
80107981:	c3                   	ret    
80107982:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107990 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107990:	55                   	push   %ebp
80107991:	89 e5                	mov    %esp,%ebp
80107993:	57                   	push   %edi
80107994:	56                   	push   %esi
80107995:	53                   	push   %ebx
80107996:	83 ec 1c             	sub    $0x1c,%esp
80107999:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010799c:	85 db                	test   %ebx,%ebx
8010799e:	0f 84 cb 00 00 00    	je     80107a6f <switchuvm+0xdf>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801079a4:	8b 43 08             	mov    0x8(%ebx),%eax
801079a7:	85 c0                	test   %eax,%eax
801079a9:	0f 84 da 00 00 00    	je     80107a89 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801079af:	8b 43 04             	mov    0x4(%ebx),%eax
801079b2:	85 c0                	test   %eax,%eax
801079b4:	0f 84 c2 00 00 00    	je     80107a7c <switchuvm+0xec>
    panic("switchuvm: no pgdir");

  pushcli();
801079ba:	e8 d1 d4 ff ff       	call   80104e90 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801079bf:	e8 5c c6 ff ff       	call   80104020 <mycpu>
801079c4:	89 c6                	mov    %eax,%esi
801079c6:	e8 55 c6 ff ff       	call   80104020 <mycpu>
801079cb:	89 c7                	mov    %eax,%edi
801079cd:	e8 4e c6 ff ff       	call   80104020 <mycpu>
801079d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801079d5:	83 c7 08             	add    $0x8,%edi
801079d8:	e8 43 c6 ff ff       	call   80104020 <mycpu>
801079dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801079e0:	83 c0 08             	add    $0x8,%eax
801079e3:	ba 67 00 00 00       	mov    $0x67,%edx
801079e8:	c1 e8 18             	shr    $0x18,%eax
801079eb:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
801079f2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
801079f9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801079ff:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107a04:	83 c1 08             	add    $0x8,%ecx
80107a07:	c1 e9 10             	shr    $0x10,%ecx
80107a0a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107a10:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107a15:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107a1c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107a21:	e8 fa c5 ff ff       	call   80104020 <mycpu>
80107a26:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107a2d:	e8 ee c5 ff ff       	call   80104020 <mycpu>
80107a32:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107a36:	8b 73 08             	mov    0x8(%ebx),%esi
80107a39:	e8 e2 c5 ff ff       	call   80104020 <mycpu>
80107a3e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107a44:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107a47:	e8 d4 c5 ff ff       	call   80104020 <mycpu>
80107a4c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107a50:	b8 28 00 00 00       	mov    $0x28,%eax
80107a55:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107a58:	8b 43 04             	mov    0x4(%ebx),%eax
80107a5b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107a60:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80107a63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a66:	5b                   	pop    %ebx
80107a67:	5e                   	pop    %esi
80107a68:	5f                   	pop    %edi
80107a69:	5d                   	pop    %ebp
  popcli();
80107a6a:	e9 61 d4 ff ff       	jmp    80104ed0 <popcli>
    panic("switchuvm: no process");
80107a6f:	83 ec 0c             	sub    $0xc,%esp
80107a72:	68 6c 94 10 80       	push   $0x8010946c
80107a77:	e8 14 89 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107a7c:	83 ec 0c             	sub    $0xc,%esp
80107a7f:	68 97 94 10 80       	push   $0x80109497
80107a84:	e8 07 89 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107a89:	83 ec 0c             	sub    $0xc,%esp
80107a8c:	68 82 94 10 80       	push   $0x80109482
80107a91:	e8 fa 88 ff ff       	call   80100390 <panic>
80107a96:	8d 76 00             	lea    0x0(%esi),%esi
80107a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107aa0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107aa0:	55                   	push   %ebp
80107aa1:	89 e5                	mov    %esp,%ebp
80107aa3:	57                   	push   %edi
80107aa4:	56                   	push   %esi
80107aa5:	53                   	push   %ebx
80107aa6:	83 ec 1c             	sub    $0x1c,%esp
80107aa9:	8b 75 10             	mov    0x10(%ebp),%esi
80107aac:	8b 45 08             	mov    0x8(%ebp),%eax
80107aaf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107ab2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107ab8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107abb:	77 49                	ja     80107b06 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = cow_kalloc();
80107abd:	e8 de f8 ff ff       	call   801073a0 <cow_kalloc>
  memset(mem, 0, PGSIZE);
80107ac2:	83 ec 04             	sub    $0x4,%esp
  mem = cow_kalloc();
80107ac5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107ac7:	68 00 10 00 00       	push   $0x1000
80107acc:	6a 00                	push   $0x0
80107ace:	50                   	push   %eax
80107acf:	e8 9c d5 ff ff       	call   80105070 <memset>
  // cprintf("init1");
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107ad4:	58                   	pop    %eax
80107ad5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107adb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107ae0:	5a                   	pop    %edx
80107ae1:	6a 06                	push   $0x6
80107ae3:	50                   	push   %eax
80107ae4:	31 d2                	xor    %edx,%edx
80107ae6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ae9:	e8 e2 f9 ff ff       	call   801074d0 <mappages>
  // cprintf("init2");
  memmove(mem, init, sz);
80107aee:	89 75 10             	mov    %esi,0x10(%ebp)
80107af1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107af4:	83 c4 10             	add    $0x10,%esp
80107af7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80107afa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107afd:	5b                   	pop    %ebx
80107afe:	5e                   	pop    %esi
80107aff:	5f                   	pop    %edi
80107b00:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107b01:	e9 1a d6 ff ff       	jmp    80105120 <memmove>
    panic("inituvm: more than a page");
80107b06:	83 ec 0c             	sub    $0xc,%esp
80107b09:	68 ab 94 10 80       	push   $0x801094ab
80107b0e:	e8 7d 88 ff ff       	call   80100390 <panic>
80107b13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107b20 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107b20:	55                   	push   %ebp
80107b21:	89 e5                	mov    %esp,%ebp
80107b23:	57                   	push   %edi
80107b24:	56                   	push   %esi
80107b25:	53                   	push   %ebx
80107b26:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107b29:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107b30:	0f 85 91 00 00 00    	jne    80107bc7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107b36:	8b 75 18             	mov    0x18(%ebp),%esi
80107b39:	31 db                	xor    %ebx,%ebx
80107b3b:	85 f6                	test   %esi,%esi
80107b3d:	75 1a                	jne    80107b59 <loaduvm+0x39>
80107b3f:	eb 6f                	jmp    80107bb0 <loaduvm+0x90>
80107b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b48:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107b4e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107b54:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107b57:	76 57                	jbe    80107bb0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107b59:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b5c:	8b 45 08             	mov    0x8(%ebp),%eax
80107b5f:	31 c9                	xor    %ecx,%ecx
80107b61:	01 da                	add    %ebx,%edx
80107b63:	e8 e8 f8 ff ff       	call   80107450 <walkpgdir>
80107b68:	85 c0                	test   %eax,%eax
80107b6a:	74 4e                	je     80107bba <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80107b6c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107b6e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107b71:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107b76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107b7b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107b81:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107b84:	01 d9                	add    %ebx,%ecx
80107b86:	05 00 00 00 80       	add    $0x80000000,%eax
80107b8b:	57                   	push   %edi
80107b8c:	51                   	push   %ecx
80107b8d:	50                   	push   %eax
80107b8e:	ff 75 10             	pushl  0x10(%ebp)
80107b91:	e8 0a a2 ff ff       	call   80101da0 <readi>
80107b96:	83 c4 10             	add    $0x10,%esp
80107b99:	39 f8                	cmp    %edi,%eax
80107b9b:	74 ab                	je     80107b48 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80107b9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107ba5:	5b                   	pop    %ebx
80107ba6:	5e                   	pop    %esi
80107ba7:	5f                   	pop    %edi
80107ba8:	5d                   	pop    %ebp
80107ba9:	c3                   	ret    
80107baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107bb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107bb3:	31 c0                	xor    %eax,%eax
}
80107bb5:	5b                   	pop    %ebx
80107bb6:	5e                   	pop    %esi
80107bb7:	5f                   	pop    %edi
80107bb8:	5d                   	pop    %ebp
80107bb9:	c3                   	ret    
      panic("loaduvm: address should exist");
80107bba:	83 ec 0c             	sub    $0xc,%esp
80107bbd:	68 c5 94 10 80       	push   $0x801094c5
80107bc2:	e8 c9 87 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107bc7:	83 ec 0c             	sub    $0xc,%esp
80107bca:	68 7c 93 10 80       	push   $0x8010937c
80107bcf:	e8 bc 87 ff ff       	call   80100390 <panic>
80107bd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107bda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107be0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107be0:	55                   	push   %ebp
80107be1:	89 e5                	mov    %esp,%ebp
80107be3:	57                   	push   %edi
80107be4:	56                   	push   %esi
80107be5:	53                   	push   %ebx
80107be6:	83 ec 1c             	sub    $0x1c,%esp
80107be9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;
  struct proc* p = myproc();
80107bec:	e8 df c4 ff ff       	call   801040d0 <myproc>

  if(newsz >= oldsz)
80107bf1:	39 7d 10             	cmp    %edi,0x10(%ebp)
80107bf4:	0f 83 a6 00 00 00    	jae    80107ca0 <deallocuvm+0xc0>
80107bfa:	89 c6                	mov    %eax,%esi
    return oldsz;

  a = PGROUNDUP(newsz);
80107bfc:	8b 45 10             	mov    0x10(%ebp),%eax
80107bff:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107c05:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107c0b:	39 df                	cmp    %ebx,%edi
80107c0d:	76 7e                	jbe    80107c8d <deallocuvm+0xad>
80107c0f:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107c12:	8b 7d 08             	mov    0x8(%ebp),%edi
80107c15:	eb 50                	jmp    80107c67 <deallocuvm+0x87>
80107c17:	89 f6                	mov    %esi,%esi
80107c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107c20:	8b 10                	mov    (%eax),%edx
80107c22:	f6 c2 01             	test   $0x1,%dl
80107c25:	74 35                	je     80107c5c <deallocuvm+0x7c>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107c27:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107c2d:	0f 84 27 01 00 00    	je     80107d5a <deallocuvm+0x17a>
        panic("cow_kfree");
      char *v = P2V(pa);
      cow_kfree(v);
80107c33:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107c36:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107c3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      cow_kfree(v);
80107c3f:	52                   	push   %edx
80107c40:	e8 cb f6 ff ff       	call   80107310 <cow_kfree>
      if (p->pid > 2 && pgdir == p->pgdir){
80107c45:	83 c4 10             	add    $0x10,%esp
80107c48:	83 7e 10 02          	cmpl   $0x2,0x10(%esi)
80107c4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107c4f:	7e 05                	jle    80107c56 <deallocuvm+0x76>
80107c51:	39 7e 04             	cmp    %edi,0x4(%esi)
80107c54:	74 5a                	je     80107cb0 <deallocuvm+0xd0>
            p->ram_pages[i].va = 0;
            break;
          }
        }
      }
      *pte = 0;
80107c56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107c5c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107c62:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80107c65:	76 26                	jbe    80107c8d <deallocuvm+0xad>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107c67:	31 c9                	xor    %ecx,%ecx
80107c69:	89 da                	mov    %ebx,%edx
80107c6b:	89 f8                	mov    %edi,%eax
80107c6d:	e8 de f7 ff ff       	call   80107450 <walkpgdir>
    if(!pte)
80107c72:	85 c0                	test   %eax,%eax
80107c74:	75 aa                	jne    80107c20 <deallocuvm+0x40>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107c76:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107c7c:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107c82:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107c88:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80107c8b:	77 da                	ja     80107c67 <deallocuvm+0x87>
    }
  }

  return newsz;
80107c8d:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107c90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c93:	5b                   	pop    %ebx
80107c94:	5e                   	pop    %esi
80107c95:	5f                   	pop    %edi
80107c96:	5d                   	pop    %ebp
80107c97:	c3                   	ret    
80107c98:	90                   	nop
80107c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ca0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return oldsz;
80107ca3:	89 f8                	mov    %edi,%eax
}
80107ca5:	5b                   	pop    %ebx
80107ca6:	5e                   	pop    %esi
80107ca7:	5f                   	pop    %edi
80107ca8:	5d                   	pop    %ebp
80107ca9:	c3                   	ret    
80107caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107cb0:	8d 96 10 02 00 00    	lea    0x210(%esi),%edx
        for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107cb6:	31 c9                	xor    %ecx,%ecx
80107cb8:	eb 11                	jmp    80107ccb <deallocuvm+0xeb>
80107cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107cc0:	83 c1 01             	add    $0x1,%ecx
80107cc3:	83 c2 18             	add    $0x18,%edx
80107cc6:	83 f9 10             	cmp    $0x10,%ecx
80107cc9:	74 8b                	je     80107c56 <deallocuvm+0x76>
          if (p->ram_pages[i].va == (void*)a){
80107ccb:	3b 1a                	cmp    (%edx),%ebx
80107ccd:	75 f1                	jne    80107cc0 <deallocuvm+0xe0>
            p->ram_pages[i].is_free = 1;
80107ccf:	8d 14 49             	lea    (%ecx,%ecx,2),%edx
            p->num_of_actual_pages_in_mem--;
80107cd2:	83 ae c4 03 00 00 01 	subl   $0x1,0x3c4(%esi)
    for(  i =15; i>0; i--){
80107cd9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
            p->ram_pages[i].is_free = 1;
80107cdc:	c7 84 d6 00 02 00 00 	movl   $0x1,0x200(%esi,%edx,8)
80107ce3:	01 00 00 00 
    for(  i =15; i>0; i--){
80107ce7:	ba 0f 00 00 00       	mov    $0xf,%edx
80107cec:	eb 08                	jmp    80107cf6 <deallocuvm+0x116>
80107cee:	66 90                	xchg   %ax,%ax
80107cf0:	85 db                	test   %ebx,%ebx
80107cf2:	89 da                	mov    %ebx,%edx
80107cf4:	74 5f                	je     80107d55 <deallocuvm+0x175>
      if(p->advance_queue[i]==index){
80107cf6:	39 8c 96 80 03 00 00 	cmp    %ecx,0x380(%esi,%edx,4)
80107cfd:	8d 5a ff             	lea    -0x1(%edx),%ebx
80107d00:	75 ee                	jne    80107cf0 <deallocuvm+0x110>
80107d02:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        p->advance_queue[i] = -1;
80107d05:	c7 84 96 80 03 00 00 	movl   $0xffffffff,0x380(%esi,%edx,4)
80107d0c:	ff ff ff ff 
80107d10:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80107d13:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107d16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107d19:	eb 08                	jmp    80107d23 <deallocuvm+0x143>
80107d1b:	90                   	nop
80107d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107d20:	83 ea 01             	sub    $0x1,%edx
        p->advance_queue[i] = p->advance_queue[i-1];
80107d23:	8b 84 96 80 03 00 00 	mov    0x380(%esi,%edx,4),%eax
      while(i>0){
80107d2a:	85 d2                	test   %edx,%edx
        p->advance_queue[i] = p->advance_queue[i-1];
80107d2c:	89 84 96 84 03 00 00 	mov    %eax,0x384(%esi,%edx,4)
      while(i>0){
80107d33:	75 eb                	jne    80107d20 <deallocuvm+0x140>
80107d35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      p->advance_queue[0] = -1;
80107d38:	c7 86 80 03 00 00 ff 	movl   $0xffffffff,0x380(%esi)
80107d3f:	ff ff ff 
            p->ram_pages[i].va = 0;
80107d42:	8d 14 49             	lea    (%ecx,%ecx,2),%edx
80107d45:	c7 84 d6 10 02 00 00 	movl   $0x0,0x210(%esi,%edx,8)
80107d4c:	00 00 00 00 
            break;
80107d50:	e9 01 ff ff ff       	jmp    80107c56 <deallocuvm+0x76>
80107d55:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80107d58:	eb e8                	jmp    80107d42 <deallocuvm+0x162>
        panic("cow_kfree");
80107d5a:	83 ec 0c             	sub    $0xc,%esp
80107d5d:	68 e3 94 10 80       	push   $0x801094e3
80107d62:	e8 29 86 ff ff       	call   80100390 <panic>
80107d67:	89 f6                	mov    %esi,%esi
80107d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107d70 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107d70:	55                   	push   %ebp
80107d71:	89 e5                	mov    %esp,%ebp
80107d73:	57                   	push   %edi
80107d74:	56                   	push   %esi
80107d75:	53                   	push   %ebx
80107d76:	83 ec 0c             	sub    $0xc,%esp
80107d79:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;
  struct proc* p = myproc();
80107d7c:	e8 4f c3 ff ff       	call   801040d0 <myproc>
  if(pgdir == 0)
80107d81:	85 f6                	test   %esi,%esi
80107d83:	0f 84 de 00 00 00    	je     80107e67 <freevm+0xf7>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
80107d89:	83 ec 04             	sub    $0x4,%esp
80107d8c:	89 c3                	mov    %eax,%ebx
80107d8e:	6a 00                	push   $0x0
80107d90:	68 00 00 00 80       	push   $0x80000000
80107d95:	56                   	push   %esi
80107d96:	e8 45 fe ff ff       	call   80107be0 <deallocuvm>
  if (p->pid > 2 && p->pgdir == pgdir){
80107d9b:	83 c4 10             	add    $0x10,%esp
80107d9e:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80107da2:	7e 05                	jle    80107da9 <freevm+0x39>
80107da4:	39 73 04             	cmp    %esi,0x4(%ebx)
80107da7:	74 48                	je     80107df1 <freevm+0x81>
80107da9:	89 f3                	mov    %esi,%ebx
80107dab:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107db1:	eb 0c                	jmp    80107dbf <freevm+0x4f>
80107db3:	90                   	nop
80107db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107db8:	83 c3 04             	add    $0x4,%ebx
      p->ram_pages[i].aging_counter = p->swapped_out_pages[i].aging_counter = 0;
      p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
      p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
    }
  }
  for(i = 0; i < NPDENTRIES; i++){
80107dbb:	39 fb                	cmp    %edi,%ebx
80107dbd:	74 23                	je     80107de2 <freevm+0x72>
    if(pgdir[i] & PTE_P){
80107dbf:	8b 03                	mov    (%ebx),%eax
80107dc1:	a8 01                	test   $0x1,%al
80107dc3:	74 f3                	je     80107db8 <freevm+0x48>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107dc5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
       cow_kfree(v);
80107dca:	83 ec 0c             	sub    $0xc,%esp
80107dcd:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107dd0:	05 00 00 00 80       	add    $0x80000000,%eax
       cow_kfree(v);
80107dd5:	50                   	push   %eax
80107dd6:	e8 35 f5 ff ff       	call   80107310 <cow_kfree>
80107ddb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107dde:	39 fb                	cmp    %edi,%ebx
80107de0:	75 dd                	jne    80107dbf <freevm+0x4f>
    }
  }
   cow_kfree((char*)pgdir);
80107de2:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107de5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107de8:	5b                   	pop    %ebx
80107de9:	5e                   	pop    %esi
80107dea:	5f                   	pop    %edi
80107deb:	5d                   	pop    %ebp
   cow_kfree((char*)pgdir);
80107dec:	e9 1f f5 ff ff       	jmp    80107310 <cow_kfree>
    p->num_of_actual_pages_in_mem = 0;
80107df1:	c7 83 c4 03 00 00 00 	movl   $0x0,0x3c4(%ebx)
80107df8:	00 00 00 
    p->num_of_pages_in_swap_file = 0;
80107dfb:	c7 83 c0 03 00 00 00 	movl   $0x0,0x3c0(%ebx)
80107e02:	00 00 00 
80107e05:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80107e0b:	81 c3 00 02 00 00    	add    $0x200,%ebx
80107e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
80107e18:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80107e1e:	c7 80 80 01 00 00 01 	movl   $0x1,0x180(%eax)
80107e25:	00 00 00 
80107e28:	83 c0 18             	add    $0x18,%eax
      p->ram_pages[i].aging_counter = p->swapped_out_pages[i].aging_counter = 0;
80107e2b:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
80107e32:	c7 80 70 01 00 00 00 	movl   $0x0,0x170(%eax)
80107e39:	00 00 00 
      p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
80107e3c:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
80107e43:	c7 80 6c 01 00 00 00 	movl   $0x0,0x16c(%eax)
80107e4a:	00 00 00 
      p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
80107e4d:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
80107e54:	c7 80 78 01 00 00 00 	movl   $0x0,0x178(%eax)
80107e5b:	00 00 00 
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107e5e:	39 d8                	cmp    %ebx,%eax
80107e60:	75 b6                	jne    80107e18 <freevm+0xa8>
80107e62:	e9 42 ff ff ff       	jmp    80107da9 <freevm+0x39>
    panic("freevm: no pgdir");
80107e67:	83 ec 0c             	sub    $0xc,%esp
80107e6a:	68 ed 94 10 80       	push   $0x801094ed
80107e6f:	e8 1c 85 ff ff       	call   80100390 <panic>
80107e74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107e7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107e80 <setupkvm>:
{
80107e80:	55                   	push   %ebp
80107e81:	89 e5                	mov    %esp,%ebp
80107e83:	56                   	push   %esi
80107e84:	53                   	push   %ebx
  if((pgdir = (pde_t*)cow_kalloc()) == 0)
80107e85:	e8 16 f5 ff ff       	call   801073a0 <cow_kalloc>
80107e8a:	85 c0                	test   %eax,%eax
80107e8c:	89 c6                	mov    %eax,%esi
80107e8e:	74 42                	je     80107ed2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107e90:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++){
80107e93:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80107e98:	68 00 10 00 00       	push   $0x1000
80107e9d:	6a 00                	push   $0x0
80107e9f:	50                   	push   %eax
80107ea0:	e8 cb d1 ff ff       	call   80105070 <memset>
80107ea5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107ea8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107eab:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107eae:	83 ec 08             	sub    $0x8,%esp
80107eb1:	8b 13                	mov    (%ebx),%edx
80107eb3:	ff 73 0c             	pushl  0xc(%ebx)
80107eb6:	50                   	push   %eax
80107eb7:	29 c1                	sub    %eax,%ecx
80107eb9:	89 f0                	mov    %esi,%eax
80107ebb:	e8 10 f6 ff ff       	call   801074d0 <mappages>
80107ec0:	83 c4 10             	add    $0x10,%esp
80107ec3:	85 c0                	test   %eax,%eax
80107ec5:	78 19                	js     80107ee0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++){
80107ec7:	83 c3 10             	add    $0x10,%ebx
80107eca:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80107ed0:	75 d6                	jne    80107ea8 <setupkvm+0x28>
}
80107ed2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107ed5:	89 f0                	mov    %esi,%eax
80107ed7:	5b                   	pop    %ebx
80107ed8:	5e                   	pop    %esi
80107ed9:	5d                   	pop    %ebp
80107eda:	c3                   	ret    
80107edb:	90                   	nop
80107edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107ee0:	83 ec 0c             	sub    $0xc,%esp
80107ee3:	56                   	push   %esi
      return 0;
80107ee4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107ee6:	e8 85 fe ff ff       	call   80107d70 <freevm>
      return 0;
80107eeb:	83 c4 10             	add    $0x10,%esp
}
80107eee:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107ef1:	89 f0                	mov    %esi,%eax
80107ef3:	5b                   	pop    %ebx
80107ef4:	5e                   	pop    %esi
80107ef5:	5d                   	pop    %ebp
80107ef6:	c3                   	ret    
80107ef7:	89 f6                	mov    %esi,%esi
80107ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107f00 <kvmalloc>:
{
80107f00:	55                   	push   %ebp
80107f01:	89 e5                	mov    %esp,%ebp
80107f03:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107f06:	e8 75 ff ff ff       	call   80107e80 <setupkvm>
80107f0b:	a3 24 2a 13 80       	mov    %eax,0x80132a24
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107f10:	05 00 00 00 80       	add    $0x80000000,%eax
80107f15:	0f 22 d8             	mov    %eax,%cr3
}
80107f18:	c9                   	leave  
80107f19:	c3                   	ret    
80107f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107f20 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107f20:	55                   	push   %ebp
  pte_t *pte;
  pte = walkpgdir(pgdir, uva, 0);
80107f21:	31 c9                	xor    %ecx,%ecx
{
80107f23:	89 e5                	mov    %esp,%ebp
80107f25:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107f28:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f2b:	8b 45 08             	mov    0x8(%ebp),%eax
80107f2e:	e8 1d f5 ff ff       	call   80107450 <walkpgdir>
  if(pte == 0)
80107f33:	85 c0                	test   %eax,%eax
80107f35:	74 05                	je     80107f3c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107f37:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107f3a:	c9                   	leave  
80107f3b:	c3                   	ret    
    panic("clearpteu");
80107f3c:	83 ec 0c             	sub    $0xc,%esp
80107f3f:	68 fe 94 10 80       	push   $0x801094fe
80107f44:	e8 47 84 ff ff       	call   80100390 <panic>
80107f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107f50 <cow_copyuvm>:

pde_t*
cow_copyuvm(pde_t *pgdir, uint sz)
{
80107f50:	55                   	push   %ebp
80107f51:	89 e5                	mov    %esp,%ebp
80107f53:	57                   	push   %edi
80107f54:	56                   	push   %esi
80107f55:	53                   	push   %ebx
80107f56:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  if((d = setupkvm()) == 0)
80107f59:	e8 22 ff ff ff       	call   80107e80 <setupkvm>
80107f5e:	85 c0                	test   %eax,%eax
80107f60:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107f63:	0f 84 d0 00 00 00    	je     80108039 <cow_copyuvm+0xe9>
    return 0;
  //cprintf("cow : pages = %d\n", 57344 - sys_get_number_of_free_pages_impl());

  // cprintf("cow_copyuvm : pages = %d\n", 57344 - sys_get_number_of_free_pages_impl());
  for(i = 0; i < sz; i += PGSIZE){
80107f69:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80107f6c:	85 db                	test   %ebx,%ebx
80107f6e:	0f 84 c5 00 00 00    	je     80108039 <cow_copyuvm+0xe9>
80107f74:	31 ff                	xor    %edi,%edi
80107f76:	eb 1e                	jmp    80107f96 <cow_copyuvm+0x46>
80107f78:	90                   	nop
80107f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      // cprintf("cow2");
      goto bad;
    }
    // cprintf("cow2");
    // update parents flags
    *pte |= (PTE_W & flags ? PTE_COW : 0);
80107f80:	0b 1e                	or     (%esi),%ebx
  for(i = 0; i < sz; i += PGSIZE){
80107f82:	81 c7 00 10 00 00    	add    $0x1000,%edi
    *pte &= (~PTE_W);
80107f88:	83 e3 fd             	and    $0xfffffffd,%ebx
  for(i = 0; i < sz; i += PGSIZE){
80107f8b:	39 7d 0c             	cmp    %edi,0xc(%ebp)
    *pte &= (~PTE_W);
80107f8e:	89 1e                	mov    %ebx,(%esi)
  for(i = 0; i < sz; i += PGSIZE){
80107f90:	0f 86 a3 00 00 00    	jbe    80108039 <cow_copyuvm+0xe9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107f96:	8b 45 08             	mov    0x8(%ebp),%eax
80107f99:	31 c9                	xor    %ecx,%ecx
80107f9b:	89 fa                	mov    %edi,%edx
80107f9d:	e8 ae f4 ff ff       	call   80107450 <walkpgdir>
80107fa2:	85 c0                	test   %eax,%eax
80107fa4:	89 c6                	mov    %eax,%esi
80107fa6:	0f 84 a5 00 00 00    	je     80108051 <cow_copyuvm+0x101>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
80107fac:	f7 00 01 02 00 00    	testl  $0x201,(%eax)
80107fb2:	0f 84 8c 00 00 00    	je     80108044 <cow_copyuvm+0xf4>
    acquire(cow_lock);
80107fb8:	83 ec 0c             	sub    $0xc,%esp
80107fbb:	ff 35 40 ff 11 80    	pushl  0x8011ff40
80107fc1:	e8 9a cf ff ff       	call   80104f60 <acquire>
    pa = PTE_ADDR(*pte);
80107fc6:	8b 06                	mov    (%esi),%eax
80107fc8:	89 c2                	mov    %eax,%edx
80107fca:	89 45 e0             	mov    %eax,-0x20(%ebp)
    release(cow_lock);
80107fcd:	58                   	pop    %eax
    pa = PTE_ADDR(*pte);
80107fce:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    release(cow_lock);
80107fd4:	ff 35 40 ff 11 80    	pushl  0x8011ff40
    pg_ref_counts[PGROUNDDOWN(pa)/PGSIZE]++;
80107fda:	89 d1                	mov    %edx,%ecx
80107fdc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107fdf:	c1 e9 0c             	shr    $0xc,%ecx
80107fe2:	80 81 40 1f 11 80 01 	addb   $0x1,-0x7feee0c0(%ecx)
    release(cow_lock);
80107fe9:	e8 32 d0 ff ff       	call   80105020 <release>
    if(mappages(d, (void*)i, PGSIZE, pa, (flags & (~PTE_W)) | (PTE_W & flags ? PTE_COW : 0)) < 0) {
80107fee:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107ff1:	5a                   	pop    %edx
80107ff2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107ff5:	89 c3                	mov    %eax,%ebx
80107ff7:	25 fd 0f 00 00       	and    $0xffd,%eax
80107ffc:	c1 e3 0a             	shl    $0xa,%ebx
80107fff:	81 e3 00 08 00 00    	and    $0x800,%ebx
80108005:	59                   	pop    %ecx
80108006:	09 d8                	or     %ebx,%eax
80108008:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010800d:	50                   	push   %eax
8010800e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108011:	52                   	push   %edx
80108012:	89 fa                	mov    %edi,%edx
80108014:	e8 b7 f4 ff ff       	call   801074d0 <mappages>
80108019:	83 c4 10             	add    $0x10,%esp
8010801c:	85 c0                	test   %eax,%eax
8010801e:	0f 89 5c ff ff ff    	jns    80107f80 <cow_copyuvm+0x30>
  }
  return d;

bad:
  // release(cow_lock);
  freevm(d);
80108024:	83 ec 0c             	sub    $0xc,%esp
80108027:	ff 75 dc             	pushl  -0x24(%ebp)
8010802a:	e8 41 fd ff ff       	call   80107d70 <freevm>
  return 0;
8010802f:	83 c4 10             	add    $0x10,%esp
80108032:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
80108039:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010803c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010803f:	5b                   	pop    %ebx
80108040:	5e                   	pop    %esi
80108041:	5f                   	pop    %edi
80108042:	5d                   	pop    %ebp
80108043:	c3                   	ret    
      panic("copyuvm: page not present");
80108044:	83 ec 0c             	sub    $0xc,%esp
80108047:	68 22 95 10 80       	push   $0x80109522
8010804c:	e8 3f 83 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80108051:	83 ec 0c             	sub    $0xc,%esp
80108054:	68 08 95 10 80       	push   $0x80109508
80108059:	e8 32 83 ff ff       	call   80100390 <panic>
8010805e:	66 90                	xchg   %ax,%ax

80108060 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108060:	55                   	push   %ebp
80108061:	89 e5                	mov    %esp,%ebp
80108063:	57                   	push   %edi
80108064:	56                   	push   %esi
80108065:	53                   	push   %ebx
80108066:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108069:	e8 12 fe ff ff       	call   80107e80 <setupkvm>
8010806e:	85 c0                	test   %eax,%eax
80108070:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108073:	0f 84 a2 00 00 00    	je     8010811b <copyuvm+0xbb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108079:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010807c:	85 c9                	test   %ecx,%ecx
8010807e:	0f 84 97 00 00 00    	je     8010811b <copyuvm+0xbb>
80108084:	31 ff                	xor    %edi,%edi
80108086:	eb 4a                	jmp    801080d2 <copyuvm+0x72>
80108088:	90                   	nop
80108089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = cow_kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108090:	83 ec 04             	sub    $0x4,%esp
80108093:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80108099:	68 00 10 00 00       	push   $0x1000
8010809e:	53                   	push   %ebx
8010809f:	50                   	push   %eax
801080a0:	e8 7b d0 ff ff       	call   80105120 <memmove>
    // cprintf("copy1");
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801080a5:	58                   	pop    %eax
801080a6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801080ac:	b9 00 10 00 00       	mov    $0x1000,%ecx
801080b1:	5a                   	pop    %edx
801080b2:	ff 75 e4             	pushl  -0x1c(%ebp)
801080b5:	50                   	push   %eax
801080b6:	89 fa                	mov    %edi,%edx
801080b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801080bb:	e8 10 f4 ff ff       	call   801074d0 <mappages>
801080c0:	83 c4 10             	add    $0x10,%esp
801080c3:	85 c0                	test   %eax,%eax
801080c5:	78 69                	js     80108130 <copyuvm+0xd0>
  for(i = 0; i < sz; i += PGSIZE){
801080c7:	81 c7 00 10 00 00    	add    $0x1000,%edi
801080cd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801080d0:	76 49                	jbe    8010811b <copyuvm+0xbb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801080d2:	8b 45 08             	mov    0x8(%ebp),%eax
801080d5:	31 c9                	xor    %ecx,%ecx
801080d7:	89 fa                	mov    %edi,%edx
801080d9:	e8 72 f3 ff ff       	call   80107450 <walkpgdir>
801080de:	85 c0                	test   %eax,%eax
801080e0:	74 69                	je     8010814b <copyuvm+0xeb>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
801080e2:	8b 00                	mov    (%eax),%eax
801080e4:	a9 01 02 00 00       	test   $0x201,%eax
801080e9:	74 53                	je     8010813e <copyuvm+0xde>
    pa = PTE_ADDR(*pte);
801080eb:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
801080ed:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
801080f2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
801080f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = cow_kalloc()) == 0)
801080fb:	e8 a0 f2 ff ff       	call   801073a0 <cow_kalloc>
80108100:	85 c0                	test   %eax,%eax
80108102:	89 c6                	mov    %eax,%esi
80108104:	75 8a                	jne    80108090 <copyuvm+0x30>
    // cprintf("copy2");
  }
  return d;

bad:
  freevm(d);
80108106:	83 ec 0c             	sub    $0xc,%esp
80108109:	ff 75 e0             	pushl  -0x20(%ebp)
8010810c:	e8 5f fc ff ff       	call   80107d70 <freevm>
  return 0;
80108111:	83 c4 10             	add    $0x10,%esp
80108114:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
8010811b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010811e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108121:	5b                   	pop    %ebx
80108122:	5e                   	pop    %esi
80108123:	5f                   	pop    %edi
80108124:	5d                   	pop    %ebp
80108125:	c3                   	ret    
80108126:	8d 76 00             	lea    0x0(%esi),%esi
80108129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
       cow_kfree(mem);
80108130:	83 ec 0c             	sub    $0xc,%esp
80108133:	56                   	push   %esi
80108134:	e8 d7 f1 ff ff       	call   80107310 <cow_kfree>
      goto bad;
80108139:	83 c4 10             	add    $0x10,%esp
8010813c:	eb c8                	jmp    80108106 <copyuvm+0xa6>
      panic("copyuvm: page not present");
8010813e:	83 ec 0c             	sub    $0xc,%esp
80108141:	68 22 95 10 80       	push   $0x80109522
80108146:	e8 45 82 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
8010814b:	83 ec 0c             	sub    $0xc,%esp
8010814e:	68 08 95 10 80       	push   $0x80109508
80108153:	e8 38 82 ff ff       	call   80100390 <panic>
80108158:	90                   	nop
80108159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108160 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108160:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108161:	31 c9                	xor    %ecx,%ecx
{
80108163:	89 e5                	mov    %esp,%ebp
80108165:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108168:	8b 55 0c             	mov    0xc(%ebp),%edx
8010816b:	8b 45 08             	mov    0x8(%ebp),%eax
8010816e:	e8 dd f2 ff ff       	call   80107450 <walkpgdir>
  if((*pte & PTE_P) == 0)
80108173:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108175:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80108176:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108178:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010817d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108180:	05 00 00 00 80       	add    $0x80000000,%eax
80108185:	83 fa 05             	cmp    $0x5,%edx
80108188:	ba 00 00 00 00       	mov    $0x0,%edx
8010818d:	0f 45 c2             	cmovne %edx,%eax
}
80108190:	c3                   	ret    
80108191:	eb 0d                	jmp    801081a0 <copyout>
80108193:	90                   	nop
80108194:	90                   	nop
80108195:	90                   	nop
80108196:	90                   	nop
80108197:	90                   	nop
80108198:	90                   	nop
80108199:	90                   	nop
8010819a:	90                   	nop
8010819b:	90                   	nop
8010819c:	90                   	nop
8010819d:	90                   	nop
8010819e:	90                   	nop
8010819f:	90                   	nop

801081a0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801081a0:	55                   	push   %ebp
801081a1:	89 e5                	mov    %esp,%ebp
801081a3:	57                   	push   %edi
801081a4:	56                   	push   %esi
801081a5:	53                   	push   %ebx
801081a6:	83 ec 1c             	sub    $0x1c,%esp
801081a9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801081ac:	8b 55 0c             	mov    0xc(%ebp),%edx
801081af:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801081b2:	85 db                	test   %ebx,%ebx
801081b4:	75 40                	jne    801081f6 <copyout+0x56>
801081b6:	eb 70                	jmp    80108228 <copyout+0x88>
801081b8:	90                   	nop
801081b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801081c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801081c3:	89 f1                	mov    %esi,%ecx
801081c5:	29 d1                	sub    %edx,%ecx
801081c7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801081cd:	39 d9                	cmp    %ebx,%ecx
801081cf:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801081d2:	29 f2                	sub    %esi,%edx
801081d4:	83 ec 04             	sub    $0x4,%esp
801081d7:	01 d0                	add    %edx,%eax
801081d9:	51                   	push   %ecx
801081da:	57                   	push   %edi
801081db:	50                   	push   %eax
801081dc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801081df:	e8 3c cf ff ff       	call   80105120 <memmove>
    len -= n;
    buf += n;
801081e4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801081e7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801081ea:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
801081f0:	01 cf                	add    %ecx,%edi
  while(len > 0){
801081f2:	29 cb                	sub    %ecx,%ebx
801081f4:	74 32                	je     80108228 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801081f6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801081f8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801081fb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801081fe:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108204:	56                   	push   %esi
80108205:	ff 75 08             	pushl  0x8(%ebp)
80108208:	e8 53 ff ff ff       	call   80108160 <uva2ka>
    if(pa0 == 0)
8010820d:	83 c4 10             	add    $0x10,%esp
80108210:	85 c0                	test   %eax,%eax
80108212:	75 ac                	jne    801081c0 <copyout+0x20>
  }
  return 0;
}
80108214:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108217:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010821c:	5b                   	pop    %ebx
8010821d:	5e                   	pop    %esi
8010821e:	5f                   	pop    %edi
8010821f:	5d                   	pop    %ebp
80108220:	c3                   	ret    
80108221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108228:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010822b:	31 c0                	xor    %eax,%eax
}
8010822d:	5b                   	pop    %ebx
8010822e:	5e                   	pop    %esi
8010822f:	5f                   	pop    %edi
80108230:	5d                   	pop    %ebp
80108231:	c3                   	ret    
80108232:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108240 <swap_out>:


//  if buffer == 0 then we put buffer <-- kernel_va(page_to_swap->va)  // p2v(phiscal(va))
//  and use buffer to swap out from
//  we assume that if buffer is not 0, it is kernel virtual address
void swap_out(struct proc* p, struct pageinfo* page_to_swap, void* buffer, pde_t* pgdir){
80108240:	55                   	push   %ebp
80108241:	89 e5                	mov    %esp,%ebp
80108243:	57                   	push   %edi
80108244:	56                   	push   %esi
80108245:	53                   	push   %ebx
80108246:	83 ec 1c             	sub    $0x1c,%esp
  // cprintf("SWAP OUT : ");
  // print_user_char(pgdir, page_to_swap->va);
  if (buffer == 0){
80108249:	8b 75 10             	mov    0x10(%ebp),%esi
void swap_out(struct proc* p, struct pageinfo* page_to_swap, void* buffer, pde_t* pgdir){
8010824c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (buffer == 0){
8010824f:	85 f6                	test   %esi,%esi
80108251:	0f 84 f9 00 00 00    	je     80108350 <swap_out+0x110>
  // swap page
  // INV  : cell swapped_out_pages[i] is free iff there isnt a page that is written in offset i * PGSIZE in the swap file
  int index;
  int found = 0;
  int count = 0;
  p->num_of_pages_in_swap_file++;
80108257:	8b 83 c0 03 00 00    	mov    0x3c0(%ebx),%eax
  for (index = 0; index < MAX_PYSC_PAGES; index++){
8010825d:	31 c9                	xor    %ecx,%ecx
  p->num_of_pages_in_swap_file++;
8010825f:	83 c0 01             	add    $0x1,%eax
80108262:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108265:	89 83 c0 03 00 00    	mov    %eax,0x3c0(%ebx)
8010826b:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80108271:	89 c2                	mov    %eax,%edx
80108273:	eb 0e                	jmp    80108283 <swap_out+0x43>
80108275:	8d 76 00             	lea    0x0(%esi),%esi
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80108278:	83 c1 01             	add    $0x1,%ecx
8010827b:	83 c2 18             	add    $0x18,%edx
8010827e:	83 f9 10             	cmp    $0x10,%ecx
80108281:	74 32                	je     801082b5 <swap_out+0x75>
    if (p->swapped_out_pages[index].is_free){
80108283:	8b 3a                	mov    (%edx),%edi
80108285:	85 ff                	test   %edi,%edi
80108287:	74 ef                	je     80108278 <swap_out+0x38>
      p->swapped_out_pages[index].is_free = 0;
80108289:	8d 14 49             	lea    (%ecx,%ecx,2),%edx
      p->swapped_out_pages[index].va = page_to_swap->va;
8010828c:	8b 7d 0c             	mov    0xc(%ebp),%edi
      p->swapped_out_pages[index].is_free = 0;
8010828f:	8d 14 d3             	lea    (%ebx,%edx,8),%edx
80108292:	c7 82 80 00 00 00 00 	movl   $0x0,0x80(%edx)
80108299:	00 00 00 
      p->swapped_out_pages[index].va = page_to_swap->va;
8010829c:	8b 77 10             	mov    0x10(%edi),%esi
      p->swapped_out_pages[index].swap_file_offset = index * PGSIZE;
      found = 1;
8010829f:	bf 01 00 00 00       	mov    $0x1,%edi
      p->swapped_out_pages[index].va = page_to_swap->va;
801082a4:	89 b2 90 00 00 00    	mov    %esi,0x90(%edx)
      p->swapped_out_pages[index].swap_file_offset = index * PGSIZE;
801082aa:	89 ce                	mov    %ecx,%esi
801082ac:	c1 e6 0c             	shl    $0xc,%esi
801082af:	89 b2 84 00 00 00    	mov    %esi,0x84(%edx)
801082b5:	8d b3 00 02 00 00    	lea    0x200(%ebx),%esi
  int count = 0;
801082bb:	31 d2                	xor    %edx,%edx
801082bd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
  }
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
    if (!p->swapped_out_pages[i].is_free){
      count++;
801082c0:	83 38 01             	cmpl   $0x1,(%eax)
801082c3:	83 d2 00             	adc    $0x0,%edx
801082c6:	83 c0 18             	add    $0x18,%eax
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
801082c9:	39 f0                	cmp    %esi,%eax
801082cb:	75 f3                	jne    801082c0 <swap_out+0x80>
    }
  }
  if (!found){
801082cd:	85 ff                	test   %edi,%edi
801082cf:	0f 84 9f 00 00 00    	je     80108374 <swap_out+0x134>
    cprintf("RAM count : %d , REAL RAM count : %d\n", p->num_of_pages_in_swap_file, count);
    panic("SWAP OUT BALAGAN- no place in swap array\n");
  }
  if (index < 0 || index > 15){
801082d5:	83 f9 10             	cmp    $0x10,%ecx
801082d8:	0f 84 be 00 00 00    	je     8010839c <swap_out+0x15c>
    panic("we have a bug\n");
  }
  int result = writeToSwapFile(p, buffer, index * PGSIZE, PGSIZE);
801082de:	c1 e1 0c             	shl    $0xc,%ecx
801082e1:	68 00 10 00 00       	push   $0x1000
801082e6:	51                   	push   %ecx
801082e7:	ff 75 10             	pushl  0x10(%ebp)
801082ea:	53                   	push   %ebx
801082eb:	e8 a0 a3 ff ff       	call   80102690 <writeToSwapFile>
801082f0:	89 c6                	mov    %eax,%esi


  
  // update flags in PTE
  pte_t* pte_ptr = walkpgdir(pgdir, page_to_swap->va, 0);
801082f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801082f5:	31 c9                	xor    %ecx,%ecx
801082f7:	8b 50 10             	mov    0x10(%eax),%edx
801082fa:	8b 45 14             	mov    0x14(%ebp),%eax
801082fd:	e8 4e f1 ff ff       	call   80107450 <walkpgdir>
  *pte_ptr |= PTE_PG;
  *pte_ptr &= ~PTE_P;
80108302:	8b 10                	mov    (%eax),%edx
80108304:	83 e2 fe             	and    $0xfffffffe,%edx
80108307:	80 ce 02             	or     $0x2,%dh
8010830a:	89 10                	mov    %edx,(%eax)
  // *pte_ptr |= PTE_U;
  cow_kfree(buffer);
8010830c:	58                   	pop    %eax
8010830d:	ff 75 10             	pushl  0x10(%ebp)
80108310:	e8 fb ef ff ff       	call   80107310 <cow_kfree>
  // refresh cr3
  lcr3(V2P(p->pgdir));
80108315:	8b 43 04             	mov    0x4(%ebx),%eax
80108318:	05 00 00 00 80       	add    $0x80000000,%eax
8010831d:	0f 22 d8             	mov    %eax,%cr3
  page_to_swap->is_free = 1;
80108320:	8b 45 0c             	mov    0xc(%ebp),%eax
  if (result < 0){
80108323:	83 c4 10             	add    $0x10,%esp
80108326:	85 f6                	test   %esi,%esi
  page_to_swap->is_free = 1;
80108328:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  if (result < 0){
8010832e:	78 5f                	js     8010838f <swap_out+0x14f>
    panic("swap out failed\n");
  }
  p->num_of_pageOut_occured++;
80108330:	83 83 cc 03 00 00 01 	addl   $0x1,0x3cc(%ebx)
  p->num_of_actual_pages_in_mem--;
80108337:	83 ab c4 03 00 00 01 	subl   $0x1,0x3c4(%ebx)
}
8010833e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108341:	5b                   	pop    %ebx
80108342:	5e                   	pop    %esi
80108343:	5f                   	pop    %edi
80108344:	5d                   	pop    %ebp
80108345:	c3                   	ret    
80108346:	8d 76 00             	lea    0x0(%esi),%esi
80108349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    buffer = P2V((PTE_ADDR(*(walkpgdir(pgdir, page_to_swap->va, 0)))));
80108350:	8b 45 0c             	mov    0xc(%ebp),%eax
80108353:	31 c9                	xor    %ecx,%ecx
80108355:	8b 50 10             	mov    0x10(%eax),%edx
80108358:	8b 45 14             	mov    0x14(%ebp),%eax
8010835b:	e8 f0 f0 ff ff       	call   80107450 <walkpgdir>
80108360:	8b 00                	mov    (%eax),%eax
80108362:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108367:	05 00 00 00 80       	add    $0x80000000,%eax
8010836c:	89 45 10             	mov    %eax,0x10(%ebp)
8010836f:	e9 e3 fe ff ff       	jmp    80108257 <swap_out+0x17>
    cprintf("RAM count : %d , REAL RAM count : %d\n", p->num_of_pages_in_swap_file, count);
80108374:	51                   	push   %ecx
80108375:	52                   	push   %edx
80108376:	ff 75 e4             	pushl  -0x1c(%ebp)
80108379:	68 a0 93 10 80       	push   $0x801093a0
8010837e:	e8 dd 82 ff ff       	call   80100660 <cprintf>
    panic("SWAP OUT BALAGAN- no place in swap array\n");
80108383:	c7 04 24 c8 93 10 80 	movl   $0x801093c8,(%esp)
8010838a:	e8 01 80 ff ff       	call   80100390 <panic>
    panic("swap out failed\n");
8010838f:	83 ec 0c             	sub    $0xc,%esp
80108392:	68 4b 95 10 80       	push   $0x8010954b
80108397:	e8 f4 7f ff ff       	call   80100390 <panic>
    panic("we have a bug\n");
8010839c:	83 ec 0c             	sub    $0xc,%esp
8010839f:	68 3c 95 10 80       	push   $0x8010953c
801083a4:	e8 e7 7f ff ff       	call   80100390 <panic>
801083a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801083b0 <allocuvm>:
{
801083b0:	55                   	push   %ebp
801083b1:	89 e5                	mov    %esp,%ebp
801083b3:	57                   	push   %edi
801083b4:	56                   	push   %esi
801083b5:	53                   	push   %ebx
801083b6:	83 ec 1c             	sub    $0x1c,%esp
  struct proc* p = myproc();
801083b9:	e8 12 bd ff ff       	call   801040d0 <myproc>
801083be:	89 c3                	mov    %eax,%ebx
  if(newsz >= KERNBASE)
801083c0:	8b 45 10             	mov    0x10(%ebp),%eax
801083c3:	85 c0                	test   %eax,%eax
801083c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801083c8:	0f 88 72 01 00 00    	js     80108540 <allocuvm+0x190>
  if(newsz < oldsz)
801083ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801083d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801083d4:	0f 82 4e 01 00 00    	jb     80108528 <allocuvm+0x178>
  a = PGROUNDUP(oldsz);
801083da:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801083e0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801083e6:	39 75 10             	cmp    %esi,0x10(%ebp)
801083e9:	0f 86 3c 01 00 00    	jbe    8010852b <allocuvm+0x17b>
801083ef:	8b 53 10             	mov    0x10(%ebx),%edx
801083f2:	eb 13                	jmp    80108407 <allocuvm+0x57>
801083f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801083f8:	81 c6 00 10 00 00    	add    $0x1000,%esi
801083fe:	39 75 10             	cmp    %esi,0x10(%ebp)
80108401:	0f 86 24 01 00 00    	jbe    8010852b <allocuvm+0x17b>
    if (p->pid > 2){
80108407:	83 fa 02             	cmp    $0x2,%edx
8010840a:	7e 47                	jle    80108453 <allocuvm+0xa3>
      if (p->num_of_actual_pages_in_mem >= 16){
8010840c:	8b 83 c4 03 00 00    	mov    0x3c4(%ebx),%eax
80108412:	83 f8 0f             	cmp    $0xf,%eax
80108415:	7e 33                	jle    8010844a <allocuvm+0x9a>
        if (p->num_of_pages_in_swap_file >= 16){
80108417:	83 bb c0 03 00 00 0f 	cmpl   $0xf,0x3c0(%ebx)
8010841e:	0f 8f 34 01 00 00    	jg     80108558 <allocuvm+0x1a8>
    update_queue(p);
80108424:	83 ec 0c             	sub    $0xc,%esp
80108427:	53                   	push   %ebx
80108428:	e8 b3 f2 ff ff       	call   801076e0 <update_queue>
    pi = find_page_to_swap_aq(p);
8010842d:	89 1c 24             	mov    %ebx,(%esp)
80108430:	e8 3b f2 ff ff       	call   80107670 <find_page_to_swap_aq>
        swap_out(p, page_to_swap, 0, pgdir);
80108435:	ff 75 08             	pushl  0x8(%ebp)
80108438:	6a 00                	push   $0x0
8010843a:	50                   	push   %eax
8010843b:	53                   	push   %ebx
8010843c:	e8 ff fd ff ff       	call   80108240 <swap_out>
80108441:	8b 83 c4 03 00 00    	mov    0x3c4(%ebx),%eax
80108447:	83 c4 20             	add    $0x20,%esp
      p->num_of_actual_pages_in_mem++;
8010844a:	83 c0 01             	add    $0x1,%eax
8010844d:	89 83 c4 03 00 00    	mov    %eax,0x3c4(%ebx)
    mem = cow_kalloc();
80108453:	e8 48 ef ff ff       	call   801073a0 <cow_kalloc>
    if(mem == 0){
80108458:	85 c0                	test   %eax,%eax
    mem = cow_kalloc();
8010845a:	89 c7                	mov    %eax,%edi
    if(mem == 0){
8010845c:	0f 84 f6 00 00 00    	je     80108558 <allocuvm+0x1a8>
    memset(mem, 0, PGSIZE);
80108462:	83 ec 04             	sub    $0x4,%esp
80108465:	68 00 10 00 00       	push   $0x1000
8010846a:	6a 00                	push   $0x0
8010846c:	50                   	push   %eax
8010846d:	e8 fe cb ff ff       	call   80105070 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108472:	58                   	pop    %eax
80108473:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80108479:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010847e:	5a                   	pop    %edx
8010847f:	6a 06                	push   $0x6
80108481:	50                   	push   %eax
80108482:	89 f2                	mov    %esi,%edx
80108484:	8b 45 08             	mov    0x8(%ebp),%eax
80108487:	e8 44 f0 ff ff       	call   801074d0 <mappages>
8010848c:	83 c4 10             	add    $0x10,%esp
8010848f:	85 c0                	test   %eax,%eax
80108491:	0f 88 f9 00 00 00    	js     80108590 <allocuvm+0x1e0>
    if (p->pid > 2){
80108497:	8b 53 10             	mov    0x10(%ebx),%edx
8010849a:	83 fa 02             	cmp    $0x2,%edx
8010849d:	0f 8e 55 ff ff ff    	jle    801083f8 <allocuvm+0x48>
801084a3:	8d 8b 00 02 00 00    	lea    0x200(%ebx),%ecx
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
801084a9:	31 c0                	xor    %eax,%eax
801084ab:	eb 12                	jmp    801084bf <allocuvm+0x10f>
801084ad:	8d 76 00             	lea    0x0(%esi),%esi
801084b0:	83 c0 01             	add    $0x1,%eax
801084b3:	83 c1 18             	add    $0x18,%ecx
801084b6:	83 f8 10             	cmp    $0x10,%eax
801084b9:	0f 84 39 ff ff ff    	je     801083f8 <allocuvm+0x48>
        if (p->ram_pages[i].is_free){
801084bf:	8b 39                	mov    (%ecx),%edi
801084c1:	85 ff                	test   %edi,%edi
801084c3:	74 eb                	je     801084b0 <allocuvm+0x100>
          p->ram_pages[i].is_free = 0;
801084c5:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
801084c8:	8d 3c cb             	lea    (%ebx,%ecx,8),%edi
          p->ram_pages[i].page_index = ++page_counter;
801084cb:	8b 0d c0 c5 10 80    	mov    0x8010c5c0,%ecx
          p->ram_pages[i].is_free = 0;
801084d1:	c7 87 00 02 00 00 00 	movl   $0x0,0x200(%edi)
801084d8:	00 00 00 
          p->ram_pages[i].va = (void *)a;
801084db:	89 b7 10 02 00 00    	mov    %esi,0x210(%edi)
          p->ram_pages[i].page_index = ++page_counter;
801084e1:	83 c1 01             	add    $0x1,%ecx
801084e4:	89 8f 0c 02 00 00    	mov    %ecx,0x20c(%edi)
    while (p->advance_queue[i]==-1){
801084ea:	83 bb 80 03 00 00 ff 	cmpl   $0xffffffff,0x380(%ebx)
          p->ram_pages[i].page_index = ++page_counter;
801084f1:	89 0d c0 c5 10 80    	mov    %ecx,0x8010c5c0
    while (p->advance_queue[i]==-1){
801084f7:	0f 85 d3 00 00 00    	jne    801085d0 <allocuvm+0x220>
    int i=0;
801084fd:	31 ff                	xor    %edi,%edi
801084ff:	eb 09                	jmp    8010850a <allocuvm+0x15a>
80108501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      i++;
80108508:	89 cf                	mov    %ecx,%edi
8010850a:	8d 4f 01             	lea    0x1(%edi),%ecx
    while (p->advance_queue[i]==-1){
8010850d:	83 bc 8b 80 03 00 00 	cmpl   $0xffffffff,0x380(%ebx,%ecx,4)
80108514:	ff 
80108515:	74 f1                	je     80108508 <allocuvm+0x158>
    p->advance_queue[i]= index;
80108517:	89 84 bb 80 03 00 00 	mov    %eax,0x380(%ebx,%edi,4)
8010851e:	e9 d5 fe ff ff       	jmp    801083f8 <allocuvm+0x48>
80108523:	90                   	nop
80108524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80108528:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
8010852b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010852e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108531:	5b                   	pop    %ebx
80108532:	5e                   	pop    %esi
80108533:	5f                   	pop    %edi
80108534:	5d                   	pop    %ebp
80108535:	c3                   	ret    
80108536:	8d 76 00             	lea    0x0(%esi),%esi
80108539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return 0;
80108540:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80108547:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010854a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010854d:	5b                   	pop    %ebx
8010854e:	5e                   	pop    %esi
8010854f:	5f                   	pop    %edi
80108550:	5d                   	pop    %ebp
80108551:	c3                   	ret    
80108552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          cprintf("allocuvm out of memory\n");
80108558:	83 ec 0c             	sub    $0xc,%esp
8010855b:	68 5c 95 10 80       	push   $0x8010955c
80108560:	e8 fb 80 ff ff       	call   80100660 <cprintf>
          deallocuvm(pgdir, newsz, oldsz);
80108565:	83 c4 0c             	add    $0xc,%esp
80108568:	ff 75 0c             	pushl  0xc(%ebp)
8010856b:	ff 75 10             	pushl  0x10(%ebp)
8010856e:	ff 75 08             	pushl  0x8(%ebp)
80108571:	e8 6a f6 ff ff       	call   80107be0 <deallocuvm>
          return 0;
80108576:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010857d:	83 c4 10             	add    $0x10,%esp
}
80108580:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108583:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108586:	5b                   	pop    %ebx
80108587:	5e                   	pop    %esi
80108588:	5f                   	pop    %edi
80108589:	5d                   	pop    %ebp
8010858a:	c3                   	ret    
8010858b:	90                   	nop
8010858c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80108590:	83 ec 0c             	sub    $0xc,%esp
80108593:	68 74 95 10 80       	push   $0x80109574
80108598:	e8 c3 80 ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010859d:	83 c4 0c             	add    $0xc,%esp
801085a0:	ff 75 0c             	pushl  0xc(%ebp)
801085a3:	ff 75 10             	pushl  0x10(%ebp)
801085a6:	ff 75 08             	pushl  0x8(%ebp)
801085a9:	e8 32 f6 ff ff       	call   80107be0 <deallocuvm>
      cow_kfree(mem);
801085ae:	89 3c 24             	mov    %edi,(%esp)
801085b1:	e8 5a ed ff ff       	call   80107310 <cow_kfree>
      return 0;
801085b6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801085bd:	83 c4 10             	add    $0x10,%esp
}
801085c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801085c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801085c6:	5b                   	pop    %ebx
801085c7:	5e                   	pop    %esi
801085c8:	5f                   	pop    %edi
801085c9:	5d                   	pop    %ebp
801085ca:	c3                   	ret    
801085cb:	90                   	nop
801085cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while (p->advance_queue[i]==-1){
801085d0:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801085d5:	e9 3d ff ff ff       	jmp    80108517 <allocuvm+0x167>
801085da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801085e0 <swap_in>:

// we assume there are at most MAX_PYSC_PAGES in the RAM 
int swap_in(struct proc* p, struct pageinfo* pi){
801085e0:	55                   	push   %ebp
801085e1:	89 e5                	mov    %esp,%ebp
801085e3:	57                   	push   %edi
801085e4:	56                   	push   %esi
801085e5:	53                   	push   %ebx
  // print_user_char(pgdir, pi->va);
  int found = 0;
  int index;
  int count = 0;
  // cprintf("SWAP IN: va = %d\n", pi->va);
  for (index = 0; index < MAX_PYSC_PAGES; index++){
801085e6:	31 db                	xor    %ebx,%ebx
int swap_in(struct proc* p, struct pageinfo* pi){
801085e8:	83 ec 1c             	sub    $0x1c,%esp
801085eb:	8b 75 08             	mov    0x8(%ebp),%esi
  pde_t* pgdir = p->pgdir;
801085ee:	8b 46 04             	mov    0x4(%esi),%eax
801085f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint offset = pi->swap_file_offset;
801085f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801085f7:	8b 40 04             	mov    0x4(%eax),%eax
801085fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
801085fd:	8d 86 00 02 00 00    	lea    0x200(%esi),%eax
80108603:	89 c2                	mov    %eax,%edx
80108605:	eb 14                	jmp    8010861b <swap_in+0x3b>
80108607:	89 f6                	mov    %esi,%esi
80108609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80108610:	83 c3 01             	add    $0x1,%ebx
80108613:	83 c2 18             	add    $0x18,%edx
80108616:	83 fb 10             	cmp    $0x10,%ebx
80108619:	74 19                	je     80108634 <swap_in+0x54>
    if (p->ram_pages[index].is_free){
8010861b:	8b 3a                	mov    (%edx),%edi
8010861d:	85 ff                	test   %edi,%edi
8010861f:	74 ef                	je     80108610 <swap_in+0x30>
      found = 1;
      p->ram_pages[index].is_free = 0;
80108621:	8d 14 5b             	lea    (%ebx,%ebx,2),%edx
      found = 1;
80108624:	bf 01 00 00 00       	mov    $0x1,%edi
      p->ram_pages[index].is_free = 0;
80108629:	c7 84 d6 00 02 00 00 	movl   $0x0,0x200(%esi,%edx,8)
80108630:	00 00 00 00 
80108634:	8d 8e 80 03 00 00    	lea    0x380(%esi),%ecx
  int count = 0;
8010863a:	31 d2                	xor    %edx,%edx
8010863c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    }
  }
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
    if (!p->ram_pages[i].is_free){
      count++;
80108640:	83 38 01             	cmpl   $0x1,(%eax)
80108643:	83 d2 00             	adc    $0x0,%edx
80108646:	83 c0 18             	add    $0x18,%eax
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80108649:	39 c1                	cmp    %eax,%ecx
8010864b:	75 f3                	jne    80108640 <swap_in+0x60>
    }
  }
  if (!found){
8010864d:	85 ff                	test   %edi,%edi
8010864f:	0f 84 f8 00 00 00    	je     8010874d <swap_in+0x16d>
    cprintf("RAM count : %d , REAL RAM count : %d\n", p->num_of_actual_pages_in_mem, count);
    panic("SWAP IN BALAGAN\n");
  }
  void* mem = cow_kalloc();
80108655:	e8 46 ed ff ff       	call   801073a0 <cow_kalloc>
  // mem = cow_kalloc();
  if(mem == 0){
8010865a:	85 c0                	test   %eax,%eax
  void* mem = cow_kalloc();
8010865c:	89 c7                	mov    %eax,%edi
  if(mem == 0){
8010865e:	0f 84 d2 00 00 00    	je     80108736 <swap_in+0x156>
    cprintf("swap in - out of memory\n");
    // deallocuvm(pgdir, newsz, oldsz);
    return -1;
  }

  void* va = pi->va;
80108664:	8b 45 0c             	mov    0xc(%ebp),%eax
  pte_t* pte_ptr = walkpgdir(pgdir, va, 0);
80108667:	31 c9                	xor    %ecx,%ecx
  void* va = pi->va;
80108669:	8b 40 10             	mov    0x10(%eax),%eax
  pte_t* pte_ptr = walkpgdir(pgdir, va, 0);
8010866c:	89 c2                	mov    %eax,%edx
  void* va = pi->va;
8010866e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  pte_t* pte_ptr = walkpgdir(pgdir, va, 0);
80108671:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108674:	e8 d7 ed ff ff       	call   80107450 <walkpgdir>
  *pte_ptr &= ~PTE_PG;
  *pte_ptr |= (PTE_P | PTE_U | PTE_W);

  // updating physical address written in the page table entry
  *pte_ptr = PTE_FLAGS(*pte_ptr);
  *pte_ptr |= PTE_ADDR(V2P(mem));
80108679:	8d 97 00 00 00 80    	lea    -0x80000000(%edi),%edx
8010867f:	8b 08                	mov    (%eax),%ecx
80108681:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80108687:	83 ca 07             	or     $0x7,%edx
8010868a:	81 e1 ff 0d 00 00    	and    $0xdff,%ecx
80108690:	09 ca                	or     %ecx,%edx
80108692:	89 10                	mov    %edx,(%eax)
    while (p->advance_queue[i]==-1){
80108694:	83 be 80 03 00 00 ff 	cmpl   $0xffffffff,0x380(%esi)
8010869b:	0f 85 8e 00 00 00    	jne    8010872f <swap_in+0x14f>
    int i=0;
801086a1:	31 d2                	xor    %edx,%edx
801086a3:	eb 05                	jmp    801086aa <swap_in+0xca>
801086a5:	8d 76 00             	lea    0x0(%esi),%esi
      i++;
801086a8:	89 c2                	mov    %eax,%edx
801086aa:	8d 42 01             	lea    0x1(%edx),%eax
    while (p->advance_queue[i]==-1){
801086ad:	83 bc 86 80 03 00 00 	cmpl   $0xffffffff,0x380(%esi,%eax,4)
801086b4:	ff 
801086b5:	74 f1                	je     801086a8 <swap_in+0xc8>
    p->advance_queue[i]= index;
801086b7:	89 9c 96 80 03 00 00 	mov    %ebx,0x380(%esi,%edx,4)
  p->ram_pages[index].aging_counter = 0XFFFFFFFF;
  #endif
  #if SELECTION==AQ
  add_page_index_to_queue(p, index);
  #endif
  p->ram_pages[index].page_index = ++page_counter;
801086be:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
801086c3:	8d 14 5b             	lea    (%ebx,%ebx,2),%edx
801086c6:	8d 14 d6             	lea    (%esi,%edx,8),%edx
801086c9:	83 c0 01             	add    $0x1,%eax
801086cc:	89 82 0c 02 00 00    	mov    %eax,0x20c(%edx)
801086d2:	a3 c0 c5 10 80       	mov    %eax,0x8010c5c0
  p->ram_pages[index].va = va;
801086d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801086da:	89 82 10 02 00 00    	mov    %eax,0x210(%edx)
  int result = readFromSwapFile(p, mem, offset, PGSIZE);
801086e0:	68 00 10 00 00       	push   $0x1000
801086e5:	ff 75 e0             	pushl  -0x20(%ebp)
801086e8:	57                   	push   %edi
801086e9:	56                   	push   %esi
801086ea:	e8 d1 9f ff ff       	call   801026c0 <readFromSwapFile>

  // clean the struct
  pi->is_free = 1;
801086ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801086f2:	c7 01 01 00 00 00    	movl   $0x1,(%ecx)
  pi->va = 0;
801086f8:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  pi->swap_file_offset = 0;
801086ff:	c7 41 04 00 00 00 00 	movl   $0x0,0x4(%ecx)

  // refresh rc3
  lcr3(V2P(p->pgdir));
80108706:	8b 7e 04             	mov    0x4(%esi),%edi
80108709:	8d 97 00 00 00 80    	lea    -0x80000000(%edi),%edx
8010870f:	0f 22 da             	mov    %edx,%cr3

  p->num_of_actual_pages_in_mem++;
80108712:	83 86 c4 03 00 00 01 	addl   $0x1,0x3c4(%esi)
  p->num_of_pages_in_swap_file--;
80108719:	83 ae c0 03 00 00 01 	subl   $0x1,0x3c0(%esi)

  if (result < 0){
80108720:	83 c4 10             	add    $0x10,%esp
80108723:	85 c0                	test   %eax,%eax
80108725:	78 44                	js     8010876b <swap_in+0x18b>
    panic("swap in failed");
  }
  return result;
}
80108727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010872a:	5b                   	pop    %ebx
8010872b:	5e                   	pop    %esi
8010872c:	5f                   	pop    %edi
8010872d:	5d                   	pop    %ebp
8010872e:	c3                   	ret    
    while (p->advance_queue[i]==-1){
8010872f:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80108734:	eb 81                	jmp    801086b7 <swap_in+0xd7>
    cprintf("swap in - out of memory\n");
80108736:	83 ec 0c             	sub    $0xc,%esp
80108739:	68 a1 95 10 80       	push   $0x801095a1
8010873e:	e8 1d 7f ff ff       	call   80100660 <cprintf>
    return -1;
80108743:	83 c4 10             	add    $0x10,%esp
80108746:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010874b:	eb da                	jmp    80108727 <swap_in+0x147>
    cprintf("RAM count : %d , REAL RAM count : %d\n", p->num_of_actual_pages_in_mem, count);
8010874d:	50                   	push   %eax
8010874e:	52                   	push   %edx
8010874f:	ff b6 c4 03 00 00    	pushl  0x3c4(%esi)
80108755:	68 a0 93 10 80       	push   $0x801093a0
8010875a:	e8 01 7f ff ff       	call   80100660 <cprintf>
    panic("SWAP IN BALAGAN\n");
8010875f:	c7 04 24 90 95 10 80 	movl   $0x80109590,(%esp)
80108766:	e8 25 7c ff ff       	call   80100390 <panic>
    panic("swap in failed");
8010876b:	83 ec 0c             	sub    $0xc,%esp
8010876e:	68 ba 95 10 80       	push   $0x801095ba
80108773:	e8 18 7c ff ff       	call   80100390 <panic>
80108778:	90                   	nop
80108779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108780 <swap_page_back>:
 * 3. ram not full - swap in
 * 
 * 
 * */

void swap_page_back(struct proc* p, struct pageinfo* pi_to_swapin){
80108780:	55                   	push   %ebp
80108781:	89 e5                	mov    %esp,%ebp
80108783:	57                   	push   %edi
80108784:	56                   	push   %esi
80108785:	53                   	push   %ebx
80108786:	83 ec 2c             	sub    $0x2c,%esp
80108789:	8b 5d 08             	mov    0x8(%ebp),%ebx
  //   if (!p->swapped_out_pages[i].is_free){
  //     swap++;
  //   }
  // }
  // cprintf("RAM: %d SWAP: %d\n", ram, swap);
  if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file == MAX_PYSC_PAGES){
8010878c:	83 bb c4 03 00 00 10 	cmpl   $0x10,0x3c4(%ebx)
80108793:	74 2b                	je     801087c0 <swap_page_back+0x40>
    // cprintf("swap page back 2\n");
    swap_out(p, page_to_swap, 0, p->pgdir);
    swap_in(p, pi_to_swapin);
  }
  else{
    cprintf("PGFAULT C\n");
80108795:	83 ec 0c             	sub    $0xc,%esp
80108798:	68 df 95 10 80       	push   $0x801095df
8010879d:	e8 be 7e ff ff       	call   80100660 <cprintf>
    swap_in(p, pi_to_swapin);
801087a2:	58                   	pop    %eax
801087a3:	5a                   	pop    %edx
801087a4:	ff 75 0c             	pushl  0xc(%ebp)
801087a7:	53                   	push   %ebx
801087a8:	e8 33 fe ff ff       	call   801085e0 <swap_in>
801087ad:	83 c4 10             	add    $0x10,%esp
  }
}
801087b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801087b3:	5b                   	pop    %ebx
801087b4:	5e                   	pop    %esi
801087b5:	5f                   	pop    %edi
801087b6:	5d                   	pop    %ebp
801087b7:	c3                   	ret    
801087b8:	90                   	nop
801087b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file == MAX_PYSC_PAGES){
801087c0:	8b 83 c0 03 00 00    	mov    0x3c0(%ebx),%eax
801087c6:	83 f8 10             	cmp    $0x10,%eax
801087c9:	74 45                	je     80108810 <swap_page_back+0x90>
  else if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file < MAX_PYSC_PAGES){
801087cb:	83 f8 0f             	cmp    $0xf,%eax
801087ce:	7f c5                	jg     80108795 <swap_page_back+0x15>
    cprintf("PGFAULT B\n");
801087d0:	83 ec 0c             	sub    $0xc,%esp
801087d3:	68 d4 95 10 80       	push   $0x801095d4
801087d8:	e8 83 7e ff ff       	call   80100660 <cprintf>
    update_queue(p);
801087dd:	89 1c 24             	mov    %ebx,(%esp)
801087e0:	e8 fb ee ff ff       	call   801076e0 <update_queue>
    pi = find_page_to_swap_aq(p);
801087e5:	89 1c 24             	mov    %ebx,(%esp)
801087e8:	e8 83 ee ff ff       	call   80107670 <find_page_to_swap_aq>
    swap_out(p, page_to_swap, 0, p->pgdir);
801087ed:	ff 73 04             	pushl  0x4(%ebx)
801087f0:	6a 00                	push   $0x0
801087f2:	50                   	push   %eax
801087f3:	53                   	push   %ebx
801087f4:	e8 47 fa ff ff       	call   80108240 <swap_out>
    swap_in(p, pi_to_swapin);
801087f9:	83 c4 18             	add    $0x18,%esp
801087fc:	ff 75 0c             	pushl  0xc(%ebp)
801087ff:	53                   	push   %ebx
80108800:	e8 db fd ff ff       	call   801085e0 <swap_in>
  else if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file < MAX_PYSC_PAGES){
80108805:	83 c4 10             	add    $0x10,%esp
}
80108808:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010880b:	5b                   	pop    %ebx
8010880c:	5e                   	pop    %esi
8010880d:	5f                   	pop    %edi
8010880e:	5d                   	pop    %ebp
8010880f:	c3                   	ret    
    cprintf("PGFAULT A\n");
80108810:	83 ec 0c             	sub    $0xc,%esp
80108813:	68 c9 95 10 80       	push   $0x801095c9
80108818:	e8 43 7e ff ff       	call   80100660 <cprintf>
    char* buffer = cow_kalloc();
8010881d:	e8 7e eb ff ff       	call   801073a0 <cow_kalloc>
    update_queue(p);
80108822:	89 1c 24             	mov    %ebx,(%esp)
    char* buffer = cow_kalloc();
80108825:	89 c7                	mov    %eax,%edi
    update_queue(p);
80108827:	e8 b4 ee ff ff       	call   801076e0 <update_queue>
    pi = find_page_to_swap_aq(p);
8010882c:	89 1c 24             	mov    %ebx,(%esp)
8010882f:	e8 3c ee ff ff       	call   80107670 <find_page_to_swap_aq>
    memmove(buffer, page_to_swap->va, PGSIZE);
80108834:	83 c4 0c             	add    $0xc,%esp
    pi = find_page_to_swap_aq(p);
80108837:	89 c6                	mov    %eax,%esi
    memmove(buffer, page_to_swap->va, PGSIZE);
80108839:	68 00 10 00 00       	push   $0x1000
8010883e:	ff 70 10             	pushl  0x10(%eax)
80108841:	57                   	push   %edi
80108842:	e8 d9 c8 ff ff       	call   80105120 <memmove>
    p->num_of_actual_pages_in_mem--;
80108847:	83 ab c4 03 00 00 01 	subl   $0x1,0x3c4(%ebx)
    pi = *page_to_swap;
8010884e:	8b 06                	mov    (%esi),%eax
80108850:	89 45 d0             	mov    %eax,-0x30(%ebp)
80108853:	8b 46 04             	mov    0x4(%esi),%eax
80108856:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80108859:	8b 46 08             	mov    0x8(%esi),%eax
8010885c:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010885f:	8b 46 0c             	mov    0xc(%esi),%eax
80108862:	89 45 dc             	mov    %eax,-0x24(%ebp)
80108865:	8b 46 10             	mov    0x10(%esi),%eax
80108868:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010886b:	8b 46 14             	mov    0x14(%esi),%eax
8010886e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    page_to_swap->is_free = 1;
80108871:	c7 06 01 00 00 00    	movl   $0x1,(%esi)
    swap_in(p, page_to_swap);
80108877:	59                   	pop    %ecx
80108878:	58                   	pop    %eax
80108879:	56                   	push   %esi
8010887a:	53                   	push   %ebx
8010887b:	e8 60 fd ff ff       	call   801085e0 <swap_in>
    swap_out(p, &pi, buffer, p->pgdir);
80108880:	8d 45 d0             	lea    -0x30(%ebp),%eax
80108883:	ff 73 04             	pushl  0x4(%ebx)
80108886:	57                   	push   %edi
80108887:	50                   	push   %eax
80108888:	53                   	push   %ebx
80108889:	e8 b2 f9 ff ff       	call   80108240 <swap_out>
  if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file == MAX_PYSC_PAGES){
8010888e:	83 c4 20             	add    $0x20,%esp
80108891:	e9 1a ff ff ff       	jmp    801087b0 <swap_page_back+0x30>
80108896:	8d 76 00             	lea    0x0(%esi),%esi
80108899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801088a0 <copy_page>:

int copy_page(pde_t* pgdir, pte_t* pte_ptr){
801088a0:	55                   	push   %ebp
801088a1:	89 e5                	mov    %esp,%ebp
801088a3:	57                   	push   %edi
801088a4:	56                   	push   %esi
801088a5:	53                   	push   %ebx
801088a6:	83 ec 0c             	sub    $0xc,%esp
801088a9:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint pa = PTE_ADDR(*pte_ptr);
801088ac:	8b 3e                	mov    (%esi),%edi
  char* mem = cow_kalloc();
801088ae:	e8 ed ea ff ff       	call   801073a0 <cow_kalloc>
  uint pa = PTE_ADDR(*pte_ptr);
801088b3:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if (mem == 0){
801088b9:	85 c0                	test   %eax,%eax
801088bb:	74 3b                	je     801088f8 <copy_page+0x58>
801088bd:	89 c3                	mov    %eax,%ebx
    return -1;
  }
  memmove(mem, P2V(pa), PGSIZE);
801088bf:	83 ec 04             	sub    $0x4,%esp
801088c2:	81 c7 00 00 00 80    	add    $0x80000000,%edi
  *pte_ptr = PTE_ADDR(P2V(mem)) | PTE_U | PTE_W | PTE_P;
801088c8:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  memmove(mem, P2V(pa), PGSIZE);
801088ce:	68 00 10 00 00       	push   $0x1000
801088d3:	57                   	push   %edi
  *pte_ptr = PTE_ADDR(P2V(mem)) | PTE_U | PTE_W | PTE_P;
801088d4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  memmove(mem, P2V(pa), PGSIZE);
801088da:	50                   	push   %eax
  *pte_ptr = PTE_ADDR(P2V(mem)) | PTE_U | PTE_W | PTE_P;
801088db:	83 cb 07             	or     $0x7,%ebx
  memmove(mem, P2V(pa), PGSIZE);
801088de:	e8 3d c8 ff ff       	call   80105120 <memmove>
  *pte_ptr = PTE_ADDR(P2V(mem)) | PTE_U | PTE_W | PTE_P;
801088e3:	89 1e                	mov    %ebx,(%esi)
  return 0;
801088e5:	83 c4 10             	add    $0x10,%esp
801088e8:	31 c0                	xor    %eax,%eax
}
801088ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801088ed:	5b                   	pop    %ebx
801088ee:	5e                   	pop    %esi
801088ef:	5f                   	pop    %edi
801088f0:	5d                   	pop    %ebp
801088f1:	c3                   	ret    
801088f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801088f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801088fd:	eb eb                	jmp    801088ea <copy_page+0x4a>
