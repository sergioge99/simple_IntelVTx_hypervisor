
vmm/guest/obj/fs/fs:     formato del fichero elf64-x86-64


Desensamblado de la sección .text:

0000000000800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	movabs $USTACKTOP, %rax
  800020:	48 b8 00 e0 7f ef 00 	movabs $0xef7fe000,%rax
  800027:	00 00 00 
	cmpq %rax,%rsp
  80002a:	48 39 c4             	cmp    %rax,%rsp
	jne args_exist
  80002d:	75 04                	jne    800033 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushq $0
  80002f:	6a 00                	pushq  $0x0
	pushq $0
  800031:	6a 00                	pushq  $0x0

0000000000800033 <args_exist>:

args_exist:
	movq 8(%rsp), %rsi
  800033:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
	movq (%rsp), %rdi
  800038:	48 8b 3c 24          	mov    (%rsp),%rdi
	call libmain
  80003c:	e8 50 31 00 00       	callq  803191 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 18          	sub    $0x18,%rsp
  80004b:	89 f8                	mov    %edi,%eax
  80004d:	88 45 ec             	mov    %al,-0x14(%rbp)
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800050:	90                   	nop
  800051:	c7 45 f8 f7 01 00 00 	movl   $0x1f7,-0x8(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800058:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80005b:	89 c2                	mov    %eax,%edx
  80005d:	ec                   	in     (%dx),%al
  80005e:	88 45 f7             	mov    %al,-0x9(%rbp)
	return data;
  800061:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800065:	0f b6 c0             	movzbl %al,%eax
  800068:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80006b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80006e:	25 c0 00 00 00       	and    $0xc0,%eax
  800073:	83 f8 40             	cmp    $0x40,%eax
  800076:	75 d9                	jne    800051 <ide_wait_ready+0xe>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  800078:	80 7d ec 00          	cmpb   $0x0,-0x14(%rbp)
  80007c:	74 11                	je     80008f <ide_wait_ready+0x4c>
  80007e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800081:	83 e0 21             	and    $0x21,%eax
  800084:	85 c0                	test   %eax,%eax
  800086:	74 07                	je     80008f <ide_wait_ready+0x4c>
		return -1;
  800088:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80008d:	eb 05                	jmp    800094 <ide_wait_ready+0x51>
	return 0;
  80008f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800094:	c9                   	leaveq 
  800095:	c3                   	retq   

0000000000800096 <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  800096:	55                   	push   %rbp
  800097:	48 89 e5             	mov    %rsp,%rbp
  80009a:	48 83 ec 20          	sub    $0x20,%rsp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  80009e:	bf 00 00 00 00       	mov    $0x0,%edi
  8000a3:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000aa:	00 00 00 
  8000ad:	ff d0                	callq  *%rax
  8000af:	c7 45 f4 f6 01 00 00 	movl   $0x1f6,-0xc(%rbp)
  8000b6:	c6 45 f3 f0          	movb   $0xf0,-0xd(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8000ba:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
  8000be:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8000c1:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  8000c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000c9:	eb 04                	jmp    8000cf <ide_probe_disk1+0x39>
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
	     x++)
  8000cb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (x = 0;
  8000cf:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  8000d6:	7f 26                	jg     8000fe <ide_probe_disk1+0x68>
  8000d8:	c7 45 ec f7 01 00 00 	movl   $0x1f7,-0x14(%rbp)
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  8000df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000e2:	89 c2                	mov    %eax,%edx
  8000e4:	ec                   	in     (%dx),%al
  8000e5:	88 45 eb             	mov    %al,-0x15(%rbp)
	return data;
  8000e8:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  8000ec:	0f b6 c0             	movzbl %al,%eax
  8000ef:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000f5:	25 a1 00 00 00       	and    $0xa1,%eax
  8000fa:	85 c0                	test   %eax,%eax
  8000fc:	75 cd                	jne    8000cb <ide_probe_disk1+0x35>
  8000fe:	c7 45 e4 f6 01 00 00 	movl   $0x1f6,-0x1c(%rbp)
  800105:	c6 45 e3 e0          	movb   $0xe0,-0x1d(%rbp)
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800109:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
  80010d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800110:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  800111:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  800118:	0f 9e c0             	setle  %al
  80011b:	0f b6 c0             	movzbl %al,%eax
  80011e:	89 c6                	mov    %eax,%esi
  800120:	48 bf 80 6e 80 00 00 	movabs $0x806e80,%rdi
  800127:	00 00 00 
  80012a:	b8 00 00 00 00       	mov    $0x0,%eax
  80012f:	48 ba 4d 34 80 00 00 	movabs $0x80344d,%rdx
  800136:	00 00 00 
  800139:	ff d2                	callq  *%rdx
	return (x < 1000);
  80013b:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  800142:	0f 9e c0             	setle  %al
}
  800145:	c9                   	leaveq 
  800146:	c3                   	retq   

0000000000800147 <ide_set_disk>:

void
ide_set_disk(int d)
{
  800147:	55                   	push   %rbp
  800148:	48 89 e5             	mov    %rsp,%rbp
  80014b:	48 83 ec 10          	sub    $0x10,%rsp
  80014f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	if (d != 0 && d != 1)
  800152:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800156:	74 30                	je     800188 <ide_set_disk+0x41>
  800158:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
  80015c:	74 2a                	je     800188 <ide_set_disk+0x41>
		panic("bad disk number");
  80015e:	48 ba 97 6e 80 00 00 	movabs $0x806e97,%rdx
  800165:	00 00 00 
  800168:	be 3a 00 00 00       	mov    $0x3a,%esi
  80016d:	48 bf a7 6e 80 00 00 	movabs $0x806ea7,%rdi
  800174:	00 00 00 
  800177:	b8 00 00 00 00       	mov    $0x0,%eax
  80017c:	48 b9 14 32 80 00 00 	movabs $0x803214,%rcx
  800183:	00 00 00 
  800186:	ff d1                	callq  *%rcx
	diskno = d;
  800188:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80018f:	00 00 00 
  800192:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800195:	89 10                	mov    %edx,(%rax)
}
  800197:	c9                   	leaveq 
  800198:	c3                   	retq   

0000000000800199 <ide_read>:

int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  800199:	55                   	push   %rbp
  80019a:	48 89 e5             	mov    %rsp,%rbp
  80019d:	48 83 ec 70          	sub    $0x70,%rsp
  8001a1:	89 7d ac             	mov    %edi,-0x54(%rbp)
  8001a4:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8001a8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
	int r;

	assert(nsecs <= 256);
  8001ac:	48 81 7d 98 00 01 00 	cmpq   $0x100,-0x68(%rbp)
  8001b3:	00 
  8001b4:	76 35                	jbe    8001eb <ide_read+0x52>
  8001b6:	48 b9 b0 6e 80 00 00 	movabs $0x806eb0,%rcx
  8001bd:	00 00 00 
  8001c0:	48 ba bd 6e 80 00 00 	movabs $0x806ebd,%rdx
  8001c7:	00 00 00 
  8001ca:	be 43 00 00 00       	mov    $0x43,%esi
  8001cf:	48 bf a7 6e 80 00 00 	movabs $0x806ea7,%rdi
  8001d6:	00 00 00 
  8001d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8001de:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  8001e5:	00 00 00 
  8001e8:	41 ff d0             	callq  *%r8

	ide_wait_ready(0);
  8001eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f0:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001f7:	00 00 00 
  8001fa:	ff d0                	callq  *%rax

	outb(0x1F2, nsecs);
  8001fc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800200:	0f b6 c0             	movzbl %al,%eax
  800203:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%rbp)
  80020a:	88 45 f7             	mov    %al,-0x9(%rbp)
  80020d:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800211:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800214:	ee                   	out    %al,(%dx)
	outb(0x1F3, secno & 0xFF);
  800215:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800218:	0f b6 c0             	movzbl %al,%eax
  80021b:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%rbp)
  800222:	88 45 ef             	mov    %al,-0x11(%rbp)
  800225:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  800229:	8b 55 f0             	mov    -0x10(%rbp),%edx
  80022c:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
  80022d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800230:	c1 e8 08             	shr    $0x8,%eax
  800233:	0f b6 c0             	movzbl %al,%eax
  800236:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%rbp)
  80023d:	88 45 e7             	mov    %al,-0x19(%rbp)
  800240:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  800244:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800247:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  800248:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80024b:	c1 e8 10             	shr    $0x10,%eax
  80024e:	0f b6 c0             	movzbl %al,%eax
  800251:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%rbp)
  800258:	88 45 df             	mov    %al,-0x21(%rbp)
  80025b:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  80025f:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800262:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800263:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80026a:	00 00 00 
  80026d:	8b 00                	mov    (%rax),%eax
  80026f:	83 e0 01             	and    $0x1,%eax
  800272:	c1 e0 04             	shl    $0x4,%eax
  800275:	89 c2                	mov    %eax,%edx
  800277:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80027a:	c1 e8 18             	shr    $0x18,%eax
  80027d:	83 e0 0f             	and    $0xf,%eax
  800280:	09 d0                	or     %edx,%eax
  800282:	83 c8 e0             	or     $0xffffffe0,%eax
  800285:	0f b6 c0             	movzbl %al,%eax
  800288:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%rbp)
  80028f:	88 45 d7             	mov    %al,-0x29(%rbp)
  800292:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
  800296:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800299:	ee                   	out    %al,(%dx)
  80029a:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%rbp)
  8002a1:	c6 45 cf 20          	movb   $0x20,-0x31(%rbp)
  8002a5:	0f b6 45 cf          	movzbl -0x31(%rbp),%eax
  8002a9:	8b 55 d0             	mov    -0x30(%rbp),%edx
  8002ac:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8002ad:	eb 64                	jmp    800313 <ide_read+0x17a>
		if ((r = ide_wait_ready(1)) < 0)
  8002af:	bf 01 00 00 00       	mov    $0x1,%edi
  8002b4:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
  8002c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8002c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002c7:	79 05                	jns    8002ce <ide_read+0x135>
			return r;
  8002c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002cc:	eb 51                	jmp    80031f <ide_read+0x186>
  8002ce:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%rbp)
  8002d5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8002d9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8002dd:	c7 45 bc 00 01 00 00 	movl   $0x100,-0x44(%rbp)
	__asm __volatile("cld\n\trepne\n\tinsw"			:
  8002e4:	8b 55 c8             	mov    -0x38(%rbp),%edx
  8002e7:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8002eb:	8b 45 bc             	mov    -0x44(%rbp),%eax
  8002ee:	48 89 ce             	mov    %rcx,%rsi
  8002f1:	48 89 f7             	mov    %rsi,%rdi
  8002f4:	89 c1                	mov    %eax,%ecx
  8002f6:	fc                   	cld    
  8002f7:	f2 66 6d             	repnz insw (%dx),%es:(%rdi)
  8002fa:	89 c8                	mov    %ecx,%eax
  8002fc:	48 89 fe             	mov    %rdi,%rsi
  8002ff:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  800303:	89 45 bc             	mov    %eax,-0x44(%rbp)
	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800306:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80030b:	48 81 45 a0 00 02 00 	addq   $0x200,-0x60(%rbp)
  800312:	00 
  800313:	48 83 7d 98 00       	cmpq   $0x0,-0x68(%rbp)
  800318:	75 95                	jne    8002af <ide_read+0x116>
		insw(0x1F0, dst, SECTSIZE/2);
	}

	return 0;
  80031a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80031f:	c9                   	leaveq 
  800320:	c3                   	retq   

0000000000800321 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  800321:	55                   	push   %rbp
  800322:	48 89 e5             	mov    %rsp,%rbp
  800325:	48 83 ec 70          	sub    $0x70,%rsp
  800329:	89 7d ac             	mov    %edi,-0x54(%rbp)
  80032c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800330:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
	int r;

	assert(nsecs <= 256);
  800334:	48 81 7d 98 00 01 00 	cmpq   $0x100,-0x68(%rbp)
  80033b:	00 
  80033c:	76 35                	jbe    800373 <ide_write+0x52>
  80033e:	48 b9 b0 6e 80 00 00 	movabs $0x806eb0,%rcx
  800345:	00 00 00 
  800348:	48 ba bd 6e 80 00 00 	movabs $0x806ebd,%rdx
  80034f:	00 00 00 
  800352:	be 5c 00 00 00       	mov    $0x5c,%esi
  800357:	48 bf a7 6e 80 00 00 	movabs $0x806ea7,%rdi
  80035e:	00 00 00 
  800361:	b8 00 00 00 00       	mov    $0x0,%eax
  800366:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  80036d:	00 00 00 
  800370:	41 ff d0             	callq  *%r8

	ide_wait_ready(0);
  800373:	bf 00 00 00 00       	mov    $0x0,%edi
  800378:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80037f:	00 00 00 
  800382:	ff d0                	callq  *%rax

	outb(0x1F2, nsecs);
  800384:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800388:	0f b6 c0             	movzbl %al,%eax
  80038b:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%rbp)
  800392:	88 45 f7             	mov    %al,-0x9(%rbp)
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800395:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800399:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80039c:	ee                   	out    %al,(%dx)
	outb(0x1F3, secno & 0xFF);
  80039d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003a0:	0f b6 c0             	movzbl %al,%eax
  8003a3:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%rbp)
  8003aa:	88 45 ef             	mov    %al,-0x11(%rbp)
  8003ad:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8003b1:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8003b4:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
  8003b5:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003b8:	c1 e8 08             	shr    $0x8,%eax
  8003bb:	0f b6 c0             	movzbl %al,%eax
  8003be:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%rbp)
  8003c5:	88 45 e7             	mov    %al,-0x19(%rbp)
  8003c8:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8003cc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8003cf:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  8003d0:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003d3:	c1 e8 10             	shr    $0x10,%eax
  8003d6:	0f b6 c0             	movzbl %al,%eax
  8003d9:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%rbp)
  8003e0:	88 45 df             	mov    %al,-0x21(%rbp)
  8003e3:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  8003e7:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8003ea:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  8003eb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8003f2:	00 00 00 
  8003f5:	8b 00                	mov    (%rax),%eax
  8003f7:	83 e0 01             	and    $0x1,%eax
  8003fa:	c1 e0 04             	shl    $0x4,%eax
  8003fd:	89 c2                	mov    %eax,%edx
  8003ff:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800402:	c1 e8 18             	shr    $0x18,%eax
  800405:	83 e0 0f             	and    $0xf,%eax
  800408:	09 d0                	or     %edx,%eax
  80040a:	83 c8 e0             	or     $0xffffffe0,%eax
  80040d:	0f b6 c0             	movzbl %al,%eax
  800410:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%rbp)
  800417:	88 45 d7             	mov    %al,-0x29(%rbp)
  80041a:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
  80041e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800421:	ee                   	out    %al,(%dx)
  800422:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%rbp)
  800429:	c6 45 cf 30          	movb   $0x30,-0x31(%rbp)
  80042d:	0f b6 45 cf          	movzbl -0x31(%rbp),%eax
  800431:	8b 55 d0             	mov    -0x30(%rbp),%edx
  800434:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800435:	eb 5e                	jmp    800495 <ide_write+0x174>
		if ((r = ide_wait_ready(1)) < 0)
  800437:	bf 01 00 00 00       	mov    $0x1,%edi
  80043c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800443:	00 00 00 
  800446:	ff d0                	callq  *%rax
  800448:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80044b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80044f:	79 05                	jns    800456 <ide_write+0x135>
			return r;
  800451:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800454:	eb 4b                	jmp    8004a1 <ide_write+0x180>
  800456:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%rbp)
  80045d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800461:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800465:	c7 45 bc 00 01 00 00 	movl   $0x100,-0x44(%rbp)
}

static __inline void
outsw(int port, const void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\toutsw"		:
  80046c:	8b 55 c8             	mov    -0x38(%rbp),%edx
  80046f:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800473:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800476:	48 89 ce             	mov    %rcx,%rsi
  800479:	89 c1                	mov    %eax,%ecx
  80047b:	fc                   	cld    
  80047c:	f2 66 6f             	repnz outsw %ds:(%rsi),(%dx)
  80047f:	89 c8                	mov    %ecx,%eax
  800481:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  800485:	89 45 bc             	mov    %eax,-0x44(%rbp)
	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800488:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80048d:	48 81 45 a0 00 02 00 	addq   $0x200,-0x60(%rbp)
  800494:	00 
  800495:	48 83 7d 98 00       	cmpq   $0x0,-0x68(%rbp)
  80049a:	75 9b                	jne    800437 <ide_write+0x116>
		outsw(0x1F0, src, SECTSIZE/2);
	}

	return 0;
  80049c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004a1:	c9                   	leaveq 
  8004a2:	c3                   	retq   

00000000008004a3 <diskaddr>:
#include "fs.h"

// Return the virtual address of this disk block.
void*
diskaddr(uint64_t blockno)
{
  8004a3:	55                   	push   %rbp
  8004a4:	48 89 e5             	mov    %rsp,%rbp
  8004a7:	48 83 ec 10          	sub    $0x10,%rsp
  8004ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  8004af:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004b4:	74 2a                	je     8004e0 <diskaddr+0x3d>
  8004b6:	48 b8 18 50 81 00 00 	movabs $0x815018,%rax
  8004bd:	00 00 00 
  8004c0:	48 8b 00             	mov    (%rax),%rax
  8004c3:	48 85 c0             	test   %rax,%rax
  8004c6:	74 4a                	je     800512 <diskaddr+0x6f>
  8004c8:	48 b8 18 50 81 00 00 	movabs $0x815018,%rax
  8004cf:	00 00 00 
  8004d2:	48 8b 00             	mov    (%rax),%rax
  8004d5:	8b 40 04             	mov    0x4(%rax),%eax
  8004d8:	89 c0                	mov    %eax,%eax
  8004da:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8004de:	77 32                	ja     800512 <diskaddr+0x6f>
		panic("bad block number %08x in diskaddr", blockno);
  8004e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004e4:	48 89 c1             	mov    %rax,%rcx
  8004e7:	48 ba d8 6e 80 00 00 	movabs $0x806ed8,%rdx
  8004ee:	00 00 00 
  8004f1:	be 09 00 00 00       	mov    $0x9,%esi
  8004f6:	48 bf fa 6e 80 00 00 	movabs $0x806efa,%rdi
  8004fd:	00 00 00 
  800500:	b8 00 00 00 00       	mov    $0x0,%eax
  800505:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  80050c:	00 00 00 
  80050f:	41 ff d0             	callq  *%r8
	return (char*) (DISKMAP + blockno * BLKSIZE);
  800512:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800516:	48 05 00 00 01 00    	add    $0x10000,%rax
  80051c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800520:	c9                   	leaveq 
  800521:	c3                   	retq   

0000000000800522 <va_is_mapped>:

// Is this virtual address mapped?
bool
va_is_mapped(void *va)
{
  800522:	55                   	push   %rbp
  800523:	48 89 e5             	mov    %rsp,%rbp
  800526:	48 83 ec 08          	sub    $0x8,%rsp
  80052a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (uvpml4e[VPML4E(va)] & PTE_P) && (uvpde[VPDPE(va)] & PTE_P) && (uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  80052e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800532:	48 c1 e8 27          	shr    $0x27,%rax
  800536:	48 89 c2             	mov    %rax,%rdx
  800539:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  800540:	01 00 00 
  800543:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800547:	83 e0 01             	and    $0x1,%eax
  80054a:	48 85 c0             	test   %rax,%rax
  80054d:	74 6a                	je     8005b9 <va_is_mapped+0x97>
  80054f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800553:	48 c1 e8 1e          	shr    $0x1e,%rax
  800557:	48 89 c2             	mov    %rax,%rdx
  80055a:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  800561:	01 00 00 
  800564:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800568:	83 e0 01             	and    $0x1,%eax
  80056b:	48 85 c0             	test   %rax,%rax
  80056e:	74 49                	je     8005b9 <va_is_mapped+0x97>
  800570:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800574:	48 c1 e8 15          	shr    $0x15,%rax
  800578:	48 89 c2             	mov    %rax,%rdx
  80057b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800582:	01 00 00 
  800585:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800589:	83 e0 01             	and    $0x1,%eax
  80058c:	48 85 c0             	test   %rax,%rax
  80058f:	74 28                	je     8005b9 <va_is_mapped+0x97>
  800591:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800595:	48 c1 e8 0c          	shr    $0xc,%rax
  800599:	48 89 c2             	mov    %rax,%rdx
  80059c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8005a3:	01 00 00 
  8005a6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005aa:	83 e0 01             	and    $0x1,%eax
  8005ad:	48 85 c0             	test   %rax,%rax
  8005b0:	74 07                	je     8005b9 <va_is_mapped+0x97>
  8005b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8005b7:	eb 05                	jmp    8005be <va_is_mapped+0x9c>
  8005b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8005be:	83 e0 01             	and    $0x1,%eax
}
  8005c1:	c9                   	leaveq 
  8005c2:	c3                   	retq   

00000000008005c3 <va_is_dirty>:

// Is this virtual address dirty?
bool
va_is_dirty(void *va)
{
  8005c3:	55                   	push   %rbp
  8005c4:	48 89 e5             	mov    %rsp,%rbp
  8005c7:	48 83 ec 08          	sub    $0x8,%rsp
  8005cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  8005cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005d3:	48 c1 e8 0c          	shr    $0xc,%rax
  8005d7:	48 89 c2             	mov    %rax,%rdx
  8005da:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8005e1:	01 00 00 
  8005e4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005e8:	83 e0 40             	and    $0x40,%eax
  8005eb:	48 85 c0             	test   %rax,%rax
  8005ee:	0f 95 c0             	setne  %al
}
  8005f1:	c9                   	leaveq 
  8005f2:	c3                   	retq   

00000000008005f3 <bc_pgfault>:
// Fault any disk block that is read in to memory by
// loading it from disk.
// Hint: Use ide_read and BLKSECTS.
static void
bc_pgfault(struct UTrapframe *utf)
{
  8005f3:	55                   	push   %rbp
  8005f4:	48 89 e5             	mov    %rsp,%rbp
  8005f7:	48 83 ec 50          	sub    $0x50,%rsp
  8005fb:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  8005ff:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800603:	48 8b 00             	mov    (%rax),%rax
  800606:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint64_t blockno = ((uint64_t)addr - DISKMAP) / BLKSIZE;
  80060a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80060e:	48 2d 00 00 00 10    	sub    $0x10000000,%rax
  800614:	48 c1 e8 0c          	shr    $0xc,%rax
  800618:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80061c:	48 81 7d f8 ff ff ff 	cmpq   $0xfffffff,-0x8(%rbp)
  800623:	0f 
  800624:	76 0b                	jbe    800631 <bc_pgfault+0x3e>
  800626:	b8 ff ff ff cf       	mov    $0xcfffffff,%eax
  80062b:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80062f:	76 4b                	jbe    80067c <bc_pgfault+0x89>
		panic("page fault in FS: rip %08x, va %08x, err %04x",
  800631:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  800635:	48 8b 48 08          	mov    0x8(%rax),%rcx
  800639:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80063d:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  800644:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800648:	49 89 c9             	mov    %rcx,%r9
  80064b:	49 89 d0             	mov    %rdx,%r8
  80064e:	48 89 c1             	mov    %rax,%rcx
  800651:	48 ba 08 6f 80 00 00 	movabs $0x806f08,%rdx
  800658:	00 00 00 
  80065b:	be 28 00 00 00       	mov    $0x28,%esi
  800660:	48 bf fa 6e 80 00 00 	movabs $0x806efa,%rdi
  800667:	00 00 00 
  80066a:	b8 00 00 00 00       	mov    $0x0,%eax
  80066f:	49 ba 14 32 80 00 00 	movabs $0x803214,%r10
  800676:	00 00 00 
  800679:	41 ff d2             	callq  *%r10
		      utf->utf_rip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  80067c:	48 b8 18 50 81 00 00 	movabs $0x815018,%rax
  800683:	00 00 00 
  800686:	48 8b 00             	mov    (%rax),%rax
  800689:	48 85 c0             	test   %rax,%rax
  80068c:	74 4a                	je     8006d8 <bc_pgfault+0xe5>
  80068e:	48 b8 18 50 81 00 00 	movabs $0x815018,%rax
  800695:	00 00 00 
  800698:	48 8b 00             	mov    (%rax),%rax
  80069b:	8b 40 04             	mov    0x4(%rax),%eax
  80069e:	89 c0                	mov    %eax,%eax
  8006a0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8006a4:	77 32                	ja     8006d8 <bc_pgfault+0xe5>
		panic("reading non-existent block %08x\n", blockno);
  8006a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006aa:	48 89 c1             	mov    %rax,%rcx
  8006ad:	48 ba 38 6f 80 00 00 	movabs $0x806f38,%rdx
  8006b4:	00 00 00 
  8006b7:	be 2c 00 00 00       	mov    $0x2c,%esi
  8006bc:	48 bf fa 6e 80 00 00 	movabs $0x806efa,%rdi
  8006c3:	00 00 00 
  8006c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8006cb:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  8006d2:	00 00 00 
  8006d5:	41 ff d0             	callq  *%r8
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary.
	//
	// LAB 5: your code here:

	void *new_addr = ROUNDDOWN(addr, PGSIZE);
  8006d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006dc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8006e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8006ea:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	r = sys_page_alloc(0, new_addr, PTE_P|PTE_W|PTE_U);
  8006ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8006f2:	ba 07 00 00 00       	mov    $0x7,%edx
  8006f7:	48 89 c6             	mov    %rax,%rsi
  8006fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8006ff:	48 b8 14 49 80 00 00 	movabs $0x804914,%rax
  800706:	00 00 00 
  800709:	ff d0                	callq  *%rax
  80070b:	89 45 dc             	mov    %eax,-0x24(%rbp)
	if(r<0) panic("Something wrong with allocation %e",r);
  80070e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800712:	79 30                	jns    800744 <bc_pgfault+0x151>
  800714:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800717:	89 c1                	mov    %eax,%ecx
  800719:	48 ba 60 6f 80 00 00 	movabs $0x806f60,%rdx
  800720:	00 00 00 
  800723:	be 36 00 00 00       	mov    $0x36,%esi
  800728:	48 bf fa 6e 80 00 00 	movabs $0x806efa,%rdi
  80072f:	00 00 00 
  800732:	b8 00 00 00 00       	mov    $0x0,%eax
  800737:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  80073e:	00 00 00 
  800741:	41 ff d0             	callq  *%r8
	uint64_t sec_no = BLKSECTS * blockno;
  800744:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800748:	48 c1 e0 03          	shl    $0x3,%rax
  80074c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	size_t nsecs = BLKSECTS;
  800750:	48 c7 45 c8 08 00 00 	movq   $0x8,-0x38(%rbp)
  800757:	00 
	r = ide_read(sec_no, new_addr, nsecs);

#else  // VMM GUEST

	/* Your code here */
	r = host_read(sec_no, new_addr, nsecs);
  800758:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80075c:	89 c1                	mov    %eax,%ecx
  80075e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800762:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800766:	48 89 c6             	mov    %rax,%rsi
  800769:	89 cf                	mov    %ecx,%edi
  80076b:	48 b8 73 2e 80 00 00 	movabs $0x802e73,%rax
  800772:	00 00 00 
  800775:	ff d0                	callq  *%rax
  800777:	89 45 dc             	mov    %eax,-0x24(%rbp)
	//panic("Guest read not implemented!\n");
#endif // VMM_GUEST


	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  80077a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80077e:	48 c1 e8 0c          	shr    $0xc,%rax
  800782:	48 89 c2             	mov    %rax,%rdx
  800785:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80078c:	01 00 00 
  80078f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800793:	25 07 0e 00 00       	and    $0xe07,%eax
  800798:	89 c1                	mov    %eax,%ecx
  80079a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80079e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007a2:	41 89 c8             	mov    %ecx,%r8d
  8007a5:	48 89 d1             	mov    %rdx,%rcx
  8007a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ad:	48 89 c6             	mov    %rax,%rsi
  8007b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8007b5:	48 b8 66 49 80 00 00 	movabs $0x804966,%rax
  8007bc:	00 00 00 
  8007bf:	ff d0                	callq  *%rax
  8007c1:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8007c4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007c8:	79 30                	jns    8007fa <bc_pgfault+0x207>
		panic("in bc_pgfault, sys_page_map: %e", r);
  8007ca:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8007cd:	89 c1                	mov    %eax,%ecx
  8007cf:	48 ba 88 6f 80 00 00 	movabs $0x806f88,%rdx
  8007d6:	00 00 00 
  8007d9:	be 48 00 00 00       	mov    $0x48,%esi
  8007de:	48 bf fa 6e 80 00 00 	movabs $0x806efa,%rdi
  8007e5:	00 00 00 
  8007e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ed:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  8007f4:	00 00 00 
  8007f7:	41 ff d0             	callq  *%r8

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  8007fa:	48 b8 10 50 81 00 00 	movabs $0x815010,%rax
  800801:	00 00 00 
  800804:	48 8b 00             	mov    (%rax),%rax
  800807:	48 85 c0             	test   %rax,%rax
  80080a:	74 48                	je     800854 <bc_pgfault+0x261>
  80080c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800810:	89 c7                	mov    %eax,%edi
  800812:	48 b8 2d 0d 80 00 00 	movabs $0x800d2d,%rax
  800819:	00 00 00 
  80081c:	ff d0                	callq  *%rax
  80081e:	84 c0                	test   %al,%al
  800820:	74 32                	je     800854 <bc_pgfault+0x261>
		panic("reading free block %08x\n", blockno);
  800822:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800826:	48 89 c1             	mov    %rax,%rcx
  800829:	48 ba a8 6f 80 00 00 	movabs $0x806fa8,%rdx
  800830:	00 00 00 
  800833:	be 4e 00 00 00       	mov    $0x4e,%esi
  800838:	48 bf fa 6e 80 00 00 	movabs $0x806efa,%rdi
  80083f:	00 00 00 
  800842:	b8 00 00 00 00       	mov    $0x0,%eax
  800847:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  80084e:	00 00 00 
  800851:	41 ff d0             	callq  *%r8
}
  800854:	c9                   	leaveq 
  800855:	c3                   	retq   

0000000000800856 <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  800856:	55                   	push   %rbp
  800857:	48 89 e5             	mov    %rsp,%rbp
  80085a:	48 83 ec 40          	sub    $0x40,%rsp
  80085e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	uint64_t blockno = ((uint64_t)addr - DISKMAP) / BLKSIZE;
  800862:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800866:	48 2d 00 00 00 10    	sub    $0x10000000,%rax
  80086c:	48 c1 e8 0c          	shr    $0xc,%rax
  800870:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800874:	48 81 7d c8 ff ff ff 	cmpq   $0xfffffff,-0x38(%rbp)
  80087b:	0f 
  80087c:	76 0b                	jbe    800889 <flush_block+0x33>
  80087e:	b8 ff ff ff cf       	mov    $0xcfffffff,%eax
  800883:	48 39 45 c8          	cmp    %rax,-0x38(%rbp)
  800887:	76 32                	jbe    8008bb <flush_block+0x65>
		panic("flush_block of bad va %08x", addr);
  800889:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80088d:	48 89 c1             	mov    %rax,%rcx
  800890:	48 ba c1 6f 80 00 00 	movabs $0x806fc1,%rdx
  800897:	00 00 00 
  80089a:	be 5e 00 00 00       	mov    $0x5e,%esi
  80089f:	48 bf fa 6e 80 00 00 	movabs $0x806efa,%rdi
  8008a6:	00 00 00 
  8008a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ae:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  8008b5:	00 00 00 
  8008b8:	41 ff d0             	callq  *%r8

	int r;
	addr = ROUNDDOWN(addr,BLKSIZE);
  8008bb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8008bf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8008c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008c7:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8008cd:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	uint64_t sec_no = BLKSECTS * blockno;
  8008d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8008d5:	48 c1 e0 03          	shl    $0x3,%rax
  8008d9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	size_t nsecs = BLKSECTS;
  8008dd:	48 c7 45 e0 08 00 00 	movq   $0x8,-0x20(%rbp)
  8008e4:	00 
	if (va_is_mapped(addr) && va_is_dirty(addr))
  8008e5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8008e9:	48 89 c7             	mov    %rax,%rdi
  8008ec:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  8008f3:	00 00 00 
  8008f6:	ff d0                	callq  *%rax
  8008f8:	84 c0                	test   %al,%al
  8008fa:	74 36                	je     800932 <flush_block+0xdc>
  8008fc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800900:	48 89 c7             	mov    %rax,%rdi
  800903:	48 b8 c3 05 80 00 00 	movabs $0x8005c3,%rax
  80090a:	00 00 00 
  80090d:	ff d0                	callq  *%rax
  80090f:	84 c0                	test   %al,%al
  800911:	74 1f                	je     800932 <flush_block+0xdc>
#ifndef VMM_GUEST
		ide_write(sec_no, addr, nsecs);
#else  // VMM GUEST
		host_write(sec_no, addr, nsecs);
  800913:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800917:	89 c1                	mov    %eax,%ecx
  800919:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80091d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800921:	48 89 c6             	mov    %rax,%rsi
  800924:	89 cf                	mov    %ecx,%edi
  800926:	48 b8 6b 2f 80 00 00 	movabs $0x802f6b,%rax
  80092d:	00 00 00 
  800930:	ff d0                	callq  *%rax
#endif // VMM_GUEST

	if(va_is_mapped(addr)) {
  800932:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800936:	48 89 c7             	mov    %rax,%rdi
  800939:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  800940:	00 00 00 
  800943:	ff d0                	callq  *%rax
  800945:	84 c0                	test   %al,%al
  800947:	74 53                	je     80099c <flush_block+0x146>
		if ((r = sys_page_map(0,addr,0,addr,PTE_SYSCALL&~PTE_D))<0)
  800949:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80094d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800951:	41 b8 07 0e 00 00    	mov    $0xe07,%r8d
  800957:	48 89 d1             	mov    %rdx,%rcx
  80095a:	ba 00 00 00 00       	mov    $0x0,%edx
  80095f:	48 89 c6             	mov    %rax,%rsi
  800962:	bf 00 00 00 00       	mov    $0x0,%edi
  800967:	48 b8 66 49 80 00 00 	movabs $0x804966,%rax
  80096e:	00 00 00 
  800971:	ff d0                	callq  *%rax
  800973:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800976:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80097a:	79 20                	jns    80099c <flush_block+0x146>
			cprintf("error in flushing the block : %e\n",r);
  80097c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80097f:	89 c6                	mov    %eax,%esi
  800981:	48 bf e0 6f 80 00 00 	movabs $0x806fe0,%rdi
  800988:	00 00 00 
  80098b:	b8 00 00 00 00       	mov    $0x0,%eax
  800990:	48 ba 4d 34 80 00 00 	movabs $0x80344d,%rdx
  800997:	00 00 00 
  80099a:	ff d2                	callq  *%rdx
	}
}
  80099c:	c9                   	leaveq 
  80099d:	c3                   	retq   

000000000080099e <check_bc>:

// Test that the block cache works, by smashing the superblock and
// reading it back.
static void
check_bc(void)
{
  80099e:	55                   	push   %rbp
  80099f:	48 89 e5             	mov    %rsp,%rbp
  8009a2:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
	struct Super backup;

	// back up super block
	memmove(&backup, diskaddr(1), sizeof backup);
  8009a9:	bf 01 00 00 00       	mov    $0x1,%edi
  8009ae:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8009b5:	00 00 00 
  8009b8:	ff d0                	callq  *%rax
  8009ba:	48 89 c1             	mov    %rax,%rcx
  8009bd:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8009c4:	ba 08 01 00 00       	mov    $0x108,%edx
  8009c9:	48 89 ce             	mov    %rcx,%rsi
  8009cc:	48 89 c7             	mov    %rax,%rdi
  8009cf:	48 b8 0b 43 80 00 00 	movabs $0x80430b,%rax
  8009d6:	00 00 00 
  8009d9:	ff d0                	callq  *%rax

	// smash it
	strcpy(diskaddr(1), "OOPS!\n");
  8009db:	bf 01 00 00 00       	mov    $0x1,%edi
  8009e0:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8009e7:	00 00 00 
  8009ea:	ff d0                	callq  *%rax
  8009ec:	48 be 02 70 80 00 00 	movabs $0x807002,%rsi
  8009f3:	00 00 00 
  8009f6:	48 89 c7             	mov    %rax,%rdi
  8009f9:	48 b8 e7 3f 80 00 00 	movabs $0x803fe7,%rax
  800a00:	00 00 00 
  800a03:	ff d0                	callq  *%rax
	flush_block(diskaddr(1));
  800a05:	bf 01 00 00 00       	mov    $0x1,%edi
  800a0a:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800a11:	00 00 00 
  800a14:	ff d0                	callq  *%rax
  800a16:	48 89 c7             	mov    %rax,%rdi
  800a19:	48 b8 56 08 80 00 00 	movabs $0x800856,%rax
  800a20:	00 00 00 
  800a23:	ff d0                	callq  *%rax
	assert(va_is_mapped(diskaddr(1)));
  800a25:	bf 01 00 00 00       	mov    $0x1,%edi
  800a2a:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800a31:	00 00 00 
  800a34:	ff d0                	callq  *%rax
  800a36:	48 89 c7             	mov    %rax,%rdi
  800a39:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  800a40:	00 00 00 
  800a43:	ff d0                	callq  *%rax
  800a45:	83 f0 01             	xor    $0x1,%eax
  800a48:	84 c0                	test   %al,%al
  800a4a:	74 35                	je     800a81 <check_bc+0xe3>
  800a4c:	48 b9 09 70 80 00 00 	movabs $0x807009,%rcx
  800a53:	00 00 00 
  800a56:	48 ba 23 70 80 00 00 	movabs $0x807023,%rdx
  800a5d:	00 00 00 
  800a60:	be 7e 00 00 00       	mov    $0x7e,%esi
  800a65:	48 bf fa 6e 80 00 00 	movabs $0x806efa,%rdi
  800a6c:	00 00 00 
  800a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a74:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  800a7b:	00 00 00 
  800a7e:	41 ff d0             	callq  *%r8
	assert(!va_is_dirty(diskaddr(1)));
  800a81:	bf 01 00 00 00       	mov    $0x1,%edi
  800a86:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800a8d:	00 00 00 
  800a90:	ff d0                	callq  *%rax
  800a92:	48 89 c7             	mov    %rax,%rdi
  800a95:	48 b8 c3 05 80 00 00 	movabs $0x8005c3,%rax
  800a9c:	00 00 00 
  800a9f:	ff d0                	callq  *%rax
  800aa1:	84 c0                	test   %al,%al
  800aa3:	74 35                	je     800ada <check_bc+0x13c>
  800aa5:	48 b9 38 70 80 00 00 	movabs $0x807038,%rcx
  800aac:	00 00 00 
  800aaf:	48 ba 23 70 80 00 00 	movabs $0x807023,%rdx
  800ab6:	00 00 00 
  800ab9:	be 7f 00 00 00       	mov    $0x7f,%esi
  800abe:	48 bf fa 6e 80 00 00 	movabs $0x806efa,%rdi
  800ac5:	00 00 00 
  800ac8:	b8 00 00 00 00       	mov    $0x0,%eax
  800acd:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  800ad4:	00 00 00 
  800ad7:	41 ff d0             	callq  *%r8

	// clear it out
	sys_page_unmap(0, diskaddr(1));
  800ada:	bf 01 00 00 00       	mov    $0x1,%edi
  800adf:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800ae6:	00 00 00 
  800ae9:	ff d0                	callq  *%rax
  800aeb:	48 89 c6             	mov    %rax,%rsi
  800aee:	bf 00 00 00 00       	mov    $0x0,%edi
  800af3:	48 b8 c6 49 80 00 00 	movabs $0x8049c6,%rax
  800afa:	00 00 00 
  800afd:	ff d0                	callq  *%rax
	assert(!va_is_mapped(diskaddr(1)));
  800aff:	bf 01 00 00 00       	mov    $0x1,%edi
  800b04:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800b0b:	00 00 00 
  800b0e:	ff d0                	callq  *%rax
  800b10:	48 89 c7             	mov    %rax,%rdi
  800b13:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  800b1a:	00 00 00 
  800b1d:	ff d0                	callq  *%rax
  800b1f:	84 c0                	test   %al,%al
  800b21:	74 35                	je     800b58 <check_bc+0x1ba>
  800b23:	48 b9 52 70 80 00 00 	movabs $0x807052,%rcx
  800b2a:	00 00 00 
  800b2d:	48 ba 23 70 80 00 00 	movabs $0x807023,%rdx
  800b34:	00 00 00 
  800b37:	be 83 00 00 00       	mov    $0x83,%esi
  800b3c:	48 bf fa 6e 80 00 00 	movabs $0x806efa,%rdi
  800b43:	00 00 00 
  800b46:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4b:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  800b52:	00 00 00 
  800b55:	41 ff d0             	callq  *%r8

	// read it back in
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800b58:	bf 01 00 00 00       	mov    $0x1,%edi
  800b5d:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800b64:	00 00 00 
  800b67:	ff d0                	callq  *%rax
  800b69:	48 be 02 70 80 00 00 	movabs $0x807002,%rsi
  800b70:	00 00 00 
  800b73:	48 89 c7             	mov    %rax,%rdi
  800b76:	48 b8 49 41 80 00 00 	movabs $0x804149,%rax
  800b7d:	00 00 00 
  800b80:	ff d0                	callq  *%rax
  800b82:	85 c0                	test   %eax,%eax
  800b84:	74 35                	je     800bbb <check_bc+0x21d>
  800b86:	48 b9 70 70 80 00 00 	movabs $0x807070,%rcx
  800b8d:	00 00 00 
  800b90:	48 ba 23 70 80 00 00 	movabs $0x807023,%rdx
  800b97:	00 00 00 
  800b9a:	be 86 00 00 00       	mov    $0x86,%esi
  800b9f:	48 bf fa 6e 80 00 00 	movabs $0x806efa,%rdi
  800ba6:	00 00 00 
  800ba9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bae:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  800bb5:	00 00 00 
  800bb8:	41 ff d0             	callq  *%r8

	// fix it
	memmove(diskaddr(1), &backup, sizeof backup);
  800bbb:	bf 01 00 00 00       	mov    $0x1,%edi
  800bc0:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800bc7:	00 00 00 
  800bca:	ff d0                	callq  *%rax
  800bcc:	48 89 c1             	mov    %rax,%rcx
  800bcf:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800bd6:	ba 08 01 00 00       	mov    $0x108,%edx
  800bdb:	48 89 c6             	mov    %rax,%rsi
  800bde:	48 89 cf             	mov    %rcx,%rdi
  800be1:	48 b8 0b 43 80 00 00 	movabs $0x80430b,%rax
  800be8:	00 00 00 
  800beb:	ff d0                	callq  *%rax
	flush_block(diskaddr(1));
  800bed:	bf 01 00 00 00       	mov    $0x1,%edi
  800bf2:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800bf9:	00 00 00 
  800bfc:	ff d0                	callq  *%rax
  800bfe:	48 89 c7             	mov    %rax,%rdi
  800c01:	48 b8 56 08 80 00 00 	movabs $0x800856,%rax
  800c08:	00 00 00 
  800c0b:	ff d0                	callq  *%rax

	cprintf("block cache is good\n");
  800c0d:	48 bf 94 70 80 00 00 	movabs $0x807094,%rdi
  800c14:	00 00 00 
  800c17:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1c:	48 ba 4d 34 80 00 00 	movabs $0x80344d,%rdx
  800c23:	00 00 00 
  800c26:	ff d2                	callq  *%rdx
}
  800c28:	c9                   	leaveq 
  800c29:	c3                   	retq   

0000000000800c2a <bc_init>:

void
bc_init(void)
{
  800c2a:	55                   	push   %rbp
  800c2b:	48 89 e5             	mov    %rsp,%rbp
  800c2e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  800c35:	48 bf f3 05 80 00 00 	movabs $0x8005f3,%rdi
  800c3c:	00 00 00 
  800c3f:	48 b8 7c 4c 80 00 00 	movabs $0x804c7c,%rax
  800c46:	00 00 00 
  800c49:	ff d0                	callq  *%rax
	check_bc();
  800c4b:	48 b8 9e 09 80 00 00 	movabs $0x80099e,%rax
  800c52:	00 00 00 
  800c55:	ff d0                	callq  *%rax

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  800c57:	bf 01 00 00 00       	mov    $0x1,%edi
  800c5c:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800c63:	00 00 00 
  800c66:	ff d0                	callq  *%rax
  800c68:	48 89 c1             	mov    %rax,%rcx
  800c6b:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800c72:	ba 08 01 00 00       	mov    $0x108,%edx
  800c77:	48 89 ce             	mov    %rcx,%rsi
  800c7a:	48 89 c7             	mov    %rax,%rdi
  800c7d:	48 b8 0b 43 80 00 00 	movabs $0x80430b,%rax
  800c84:	00 00 00 
  800c87:	ff d0                	callq  *%rax
}
  800c89:	c9                   	leaveq 
  800c8a:	c3                   	retq   

0000000000800c8b <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  800c8b:	55                   	push   %rbp
  800c8c:	48 89 e5             	mov    %rsp,%rbp
	if (super->s_magic != FS_MAGIC)
  800c8f:	48 b8 18 50 81 00 00 	movabs $0x815018,%rax
  800c96:	00 00 00 
  800c99:	48 8b 00             	mov    (%rax),%rax
  800c9c:	8b 00                	mov    (%rax),%eax
  800c9e:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  800ca3:	74 2a                	je     800ccf <check_super+0x44>
		panic("bad file system magic number");
  800ca5:	48 ba b0 70 80 00 00 	movabs $0x8070b0,%rdx
  800cac:	00 00 00 
  800caf:	be 0e 00 00 00       	mov    $0xe,%esi
  800cb4:	48 bf cd 70 80 00 00 	movabs $0x8070cd,%rdi
  800cbb:	00 00 00 
  800cbe:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc3:	48 b9 14 32 80 00 00 	movabs $0x803214,%rcx
  800cca:	00 00 00 
  800ccd:	ff d1                	callq  *%rcx

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  800ccf:	48 b8 18 50 81 00 00 	movabs $0x815018,%rax
  800cd6:	00 00 00 
  800cd9:	48 8b 00             	mov    (%rax),%rax
  800cdc:	8b 40 04             	mov    0x4(%rax),%eax
  800cdf:	3d 00 00 0c 00       	cmp    $0xc0000,%eax
  800ce4:	76 2a                	jbe    800d10 <check_super+0x85>
		panic("file system is too large");
  800ce6:	48 ba d5 70 80 00 00 	movabs $0x8070d5,%rdx
  800ced:	00 00 00 
  800cf0:	be 11 00 00 00       	mov    $0x11,%esi
  800cf5:	48 bf cd 70 80 00 00 	movabs $0x8070cd,%rdi
  800cfc:	00 00 00 
  800cff:	b8 00 00 00 00       	mov    $0x0,%eax
  800d04:	48 b9 14 32 80 00 00 	movabs $0x803214,%rcx
  800d0b:	00 00 00 
  800d0e:	ff d1                	callq  *%rcx

	cprintf("superblock is good\n");
  800d10:	48 bf ee 70 80 00 00 	movabs $0x8070ee,%rdi
  800d17:	00 00 00 
  800d1a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1f:	48 ba 4d 34 80 00 00 	movabs $0x80344d,%rdx
  800d26:	00 00 00 
  800d29:	ff d2                	callq  *%rdx
}
  800d2b:	5d                   	pop    %rbp
  800d2c:	c3                   	retq   

0000000000800d2d <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  800d2d:	55                   	push   %rbp
  800d2e:	48 89 e5             	mov    %rsp,%rbp
  800d31:	48 83 ec 08          	sub    $0x8,%rsp
  800d35:	89 7d fc             	mov    %edi,-0x4(%rbp)
	if (super == 0 || blockno >= super->s_nblocks)
  800d38:	48 b8 18 50 81 00 00 	movabs $0x815018,%rax
  800d3f:	00 00 00 
  800d42:	48 8b 00             	mov    (%rax),%rax
  800d45:	48 85 c0             	test   %rax,%rax
  800d48:	74 15                	je     800d5f <block_is_free+0x32>
  800d4a:	48 b8 18 50 81 00 00 	movabs $0x815018,%rax
  800d51:	00 00 00 
  800d54:	48 8b 00             	mov    (%rax),%rax
  800d57:	8b 40 04             	mov    0x4(%rax),%eax
  800d5a:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800d5d:	77 07                	ja     800d66 <block_is_free+0x39>
		return 0;
  800d5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d64:	eb 41                	jmp    800da7 <block_is_free+0x7a>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  800d66:	48 b8 10 50 81 00 00 	movabs $0x815010,%rax
  800d6d:	00 00 00 
  800d70:	48 8b 00             	mov    (%rax),%rax
  800d73:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d76:	c1 ea 05             	shr    $0x5,%edx
  800d79:	89 d2                	mov    %edx,%edx
  800d7b:	48 c1 e2 02          	shl    $0x2,%rdx
  800d7f:	48 01 d0             	add    %rdx,%rax
  800d82:	8b 00                	mov    (%rax),%eax
  800d84:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d87:	83 e2 1f             	and    $0x1f,%edx
  800d8a:	be 01 00 00 00       	mov    $0x1,%esi
  800d8f:	89 d1                	mov    %edx,%ecx
  800d91:	d3 e6                	shl    %cl,%esi
  800d93:	89 f2                	mov    %esi,%edx
  800d95:	21 d0                	and    %edx,%eax
  800d97:	85 c0                	test   %eax,%eax
  800d99:	74 07                	je     800da2 <block_is_free+0x75>
		return 1;
  800d9b:	b8 01 00 00 00       	mov    $0x1,%eax
  800da0:	eb 05                	jmp    800da7 <block_is_free+0x7a>
	return 0;
  800da2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800da7:	c9                   	leaveq 
  800da8:	c3                   	retq   

0000000000800da9 <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  800da9:	55                   	push   %rbp
  800daa:	48 89 e5             	mov    %rsp,%rbp
  800dad:	48 83 ec 10          	sub    $0x10,%rsp
  800db1:	89 7d fc             	mov    %edi,-0x4(%rbp)
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  800db4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800db8:	75 2a                	jne    800de4 <free_block+0x3b>
		panic("attempt to free zero block");
  800dba:	48 ba 02 71 80 00 00 	movabs $0x807102,%rdx
  800dc1:	00 00 00 
  800dc4:	be 2c 00 00 00       	mov    $0x2c,%esi
  800dc9:	48 bf cd 70 80 00 00 	movabs $0x8070cd,%rdi
  800dd0:	00 00 00 
  800dd3:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd8:	48 b9 14 32 80 00 00 	movabs $0x803214,%rcx
  800ddf:	00 00 00 
  800de2:	ff d1                	callq  *%rcx
	bitmap[blockno/32] |= 1<<(blockno%32);
  800de4:	48 b8 10 50 81 00 00 	movabs $0x815010,%rax
  800deb:	00 00 00 
  800dee:	48 8b 10             	mov    (%rax),%rdx
  800df1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800df4:	c1 e8 05             	shr    $0x5,%eax
  800df7:	89 c1                	mov    %eax,%ecx
  800df9:	48 c1 e1 02          	shl    $0x2,%rcx
  800dfd:	48 8d 34 0a          	lea    (%rdx,%rcx,1),%rsi
  800e01:	48 ba 10 50 81 00 00 	movabs $0x815010,%rdx
  800e08:	00 00 00 
  800e0b:	48 8b 12             	mov    (%rdx),%rdx
  800e0e:	89 c0                	mov    %eax,%eax
  800e10:	48 c1 e0 02          	shl    $0x2,%rax
  800e14:	48 01 d0             	add    %rdx,%rax
  800e17:	8b 00                	mov    (%rax),%eax
  800e19:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e1c:	83 e2 1f             	and    $0x1f,%edx
  800e1f:	bf 01 00 00 00       	mov    $0x1,%edi
  800e24:	89 d1                	mov    %edx,%ecx
  800e26:	d3 e7                	shl    %cl,%edi
  800e28:	89 fa                	mov    %edi,%edx
  800e2a:	09 d0                	or     %edx,%eax
  800e2c:	89 06                	mov    %eax,(%rsi)
}
  800e2e:	c9                   	leaveq 
  800e2f:	c3                   	retq   

0000000000800e30 <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  800e30:	55                   	push   %rbp
  800e31:	48 89 e5             	mov    %rsp,%rbp
	// The bitmap consists of one or more blocks.  A single bitmap block
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	panic("alloc_block not implemented");
  800e34:	48 ba 1d 71 80 00 00 	movabs $0x80711d,%rdx
  800e3b:	00 00 00 
  800e3e:	be 40 00 00 00       	mov    $0x40,%esi
  800e43:	48 bf cd 70 80 00 00 	movabs $0x8070cd,%rdi
  800e4a:	00 00 00 
  800e4d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e52:	48 b9 14 32 80 00 00 	movabs $0x803214,%rcx
  800e59:	00 00 00 
  800e5c:	ff d1                	callq  *%rcx

0000000000800e5e <check_bitmap>:
//
// Check that all reserved blocks -- 0, 1, and the bitmap blocks themselves --
// are all marked as in-use.
void
check_bitmap(void)
{
  800e5e:	55                   	push   %rbp
  800e5f:	48 89 e5             	mov    %rsp,%rbp
  800e62:	48 83 ec 10          	sub    $0x10,%rsp
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800e66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e6d:	eb 51                	jmp    800ec0 <check_bitmap+0x62>
		assert(!block_is_free(2+i));
  800e6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e72:	83 c0 02             	add    $0x2,%eax
  800e75:	89 c7                	mov    %eax,%edi
  800e77:	48 b8 2d 0d 80 00 00 	movabs $0x800d2d,%rax
  800e7e:	00 00 00 
  800e81:	ff d0                	callq  *%rax
  800e83:	84 c0                	test   %al,%al
  800e85:	74 35                	je     800ebc <check_bitmap+0x5e>
  800e87:	48 b9 39 71 80 00 00 	movabs $0x807139,%rcx
  800e8e:	00 00 00 
  800e91:	48 ba 4d 71 80 00 00 	movabs $0x80714d,%rdx
  800e98:	00 00 00 
  800e9b:	be 4f 00 00 00       	mov    $0x4f,%esi
  800ea0:	48 bf cd 70 80 00 00 	movabs $0x8070cd,%rdi
  800ea7:	00 00 00 
  800eaa:	b8 00 00 00 00       	mov    $0x0,%eax
  800eaf:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  800eb6:	00 00 00 
  800eb9:	41 ff d0             	callq  *%r8
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800ebc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800ec0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ec3:	c1 e0 0f             	shl    $0xf,%eax
  800ec6:	89 c2                	mov    %eax,%edx
  800ec8:	48 b8 18 50 81 00 00 	movabs $0x815018,%rax
  800ecf:	00 00 00 
  800ed2:	48 8b 00             	mov    (%rax),%rax
  800ed5:	8b 40 04             	mov    0x4(%rax),%eax
  800ed8:	39 c2                	cmp    %eax,%edx
  800eda:	72 93                	jb     800e6f <check_bitmap+0x11>

	// Make sure the reserved and root blocks are marked in-use.
	assert(!block_is_free(0));
  800edc:	bf 00 00 00 00       	mov    $0x0,%edi
  800ee1:	48 b8 2d 0d 80 00 00 	movabs $0x800d2d,%rax
  800ee8:	00 00 00 
  800eeb:	ff d0                	callq  *%rax
  800eed:	84 c0                	test   %al,%al
  800eef:	74 35                	je     800f26 <check_bitmap+0xc8>
  800ef1:	48 b9 62 71 80 00 00 	movabs $0x807162,%rcx
  800ef8:	00 00 00 
  800efb:	48 ba 4d 71 80 00 00 	movabs $0x80714d,%rdx
  800f02:	00 00 00 
  800f05:	be 52 00 00 00       	mov    $0x52,%esi
  800f0a:	48 bf cd 70 80 00 00 	movabs $0x8070cd,%rdi
  800f11:	00 00 00 
  800f14:	b8 00 00 00 00       	mov    $0x0,%eax
  800f19:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  800f20:	00 00 00 
  800f23:	41 ff d0             	callq  *%r8
	assert(!block_is_free(1));
  800f26:	bf 01 00 00 00       	mov    $0x1,%edi
  800f2b:	48 b8 2d 0d 80 00 00 	movabs $0x800d2d,%rax
  800f32:	00 00 00 
  800f35:	ff d0                	callq  *%rax
  800f37:	84 c0                	test   %al,%al
  800f39:	74 35                	je     800f70 <check_bitmap+0x112>
  800f3b:	48 b9 74 71 80 00 00 	movabs $0x807174,%rcx
  800f42:	00 00 00 
  800f45:	48 ba 4d 71 80 00 00 	movabs $0x80714d,%rdx
  800f4c:	00 00 00 
  800f4f:	be 53 00 00 00       	mov    $0x53,%esi
  800f54:	48 bf cd 70 80 00 00 	movabs $0x8070cd,%rdi
  800f5b:	00 00 00 
  800f5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f63:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  800f6a:	00 00 00 
  800f6d:	41 ff d0             	callq  *%r8

	cprintf("bitmap is good\n");
  800f70:	48 bf 86 71 80 00 00 	movabs $0x807186,%rdi
  800f77:	00 00 00 
  800f7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f7f:	48 ba 4d 34 80 00 00 	movabs $0x80344d,%rdx
  800f86:	00 00 00 
  800f89:	ff d2                	callq  *%rdx
}
  800f8b:	c9                   	leaveq 
  800f8c:	c3                   	retq   

0000000000800f8d <fs_init>:


// Initialize the file system
void
fs_init(void)
{
  800f8d:	55                   	push   %rbp
  800f8e:	48 89 e5             	mov    %rsp,%rbp
	if (ide_probe_disk1())
		ide_set_disk(1);
	else
		ide_set_disk(0);
#else
	host_ipc_init();
  800f91:	b8 00 00 00 00       	mov    $0x0,%eax
  800f96:	48 ba 60 30 80 00 00 	movabs $0x803060,%rdx
  800f9d:	00 00 00 
  800fa0:	ff d2                	callq  *%rdx
#endif


	bc_init();
  800fa2:	48 b8 2a 0c 80 00 00 	movabs $0x800c2a,%rax
  800fa9:	00 00 00 
  800fac:	ff d0                	callq  *%rax

	// Set "super" to point to the super block.
	super = diskaddr(1);
  800fae:	bf 01 00 00 00       	mov    $0x1,%edi
  800fb3:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800fba:	00 00 00 
  800fbd:	ff d0                	callq  *%rax
  800fbf:	48 89 c2             	mov    %rax,%rdx
  800fc2:	48 b8 18 50 81 00 00 	movabs $0x815018,%rax
  800fc9:	00 00 00 
  800fcc:	48 89 10             	mov    %rdx,(%rax)
	check_super();
  800fcf:	48 b8 8b 0c 80 00 00 	movabs $0x800c8b,%rax
  800fd6:	00 00 00 
  800fd9:	ff d0                	callq  *%rax

	// Set "bitmap" to the beginning of the first bitmap block.
	bitmap = diskaddr(2);
  800fdb:	bf 02 00 00 00       	mov    $0x2,%edi
  800fe0:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800fe7:	00 00 00 
  800fea:	ff d0                	callq  *%rax
  800fec:	48 89 c2             	mov    %rax,%rdx
  800fef:	48 b8 10 50 81 00 00 	movabs $0x815010,%rax
  800ff6:	00 00 00 
  800ff9:	48 89 10             	mov    %rdx,(%rax)
	check_bitmap();
  800ffc:	48 b8 5e 0e 80 00 00 	movabs $0x800e5e,%rax
  801003:	00 00 00 
  801006:	ff d0                	callq  *%rax
}
  801008:	5d                   	pop    %rbp
  801009:	c3                   	retq   

000000000080100a <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  80100a:	55                   	push   %rbp
  80100b:	48 89 e5             	mov    %rsp,%rbp
  80100e:	48 83 ec 20          	sub    $0x20,%rsp
  801012:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801016:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801019:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80101d:	89 c8                	mov    %ecx,%eax
  80101f:	88 45 f0             	mov    %al,-0x10(%rbp)
        // LAB 5: Your code here.
        panic("file_block_walk not implemented");
  801022:	48 ba 98 71 80 00 00 	movabs $0x807198,%rdx
  801029:	00 00 00 
  80102c:	be 91 00 00 00       	mov    $0x91,%esi
  801031:	48 bf cd 70 80 00 00 	movabs $0x8070cd,%rdi
  801038:	00 00 00 
  80103b:	b8 00 00 00 00       	mov    $0x0,%eax
  801040:	48 b9 14 32 80 00 00 	movabs $0x803214,%rcx
  801047:	00 00 00 
  80104a:	ff d1                	callq  *%rcx

000000000080104c <file_get_block>:
//	-E_NO_DISK if a block needed to be allocated but the disk is full.
//	-E_INVAL if filebno is out of range.
//
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  80104c:	55                   	push   %rbp
  80104d:	48 89 e5             	mov    %rsp,%rbp
  801050:	48 83 ec 20          	sub    $0x20,%rsp
  801054:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801058:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80105b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 5: Your code here.
	panic("file_block_walk not implemented");
  80105f:	48 ba 98 71 80 00 00 	movabs $0x807198,%rdx
  801066:	00 00 00 
  801069:	be 9f 00 00 00       	mov    $0x9f,%esi
  80106e:	48 bf cd 70 80 00 00 	movabs $0x8070cd,%rdi
  801075:	00 00 00 
  801078:	b8 00 00 00 00       	mov    $0x0,%eax
  80107d:	48 b9 14 32 80 00 00 	movabs $0x803214,%rcx
  801084:	00 00 00 
  801087:	ff d1                	callq  *%rcx

0000000000801089 <dir_lookup>:
//
// Returns 0 and sets *file on success, < 0 on error.  Errors are:
//	-E_NOT_FOUND if the file is not found
static int
dir_lookup(struct File *dir, const char *name, struct File **file)
{
  801089:	55                   	push   %rbp
  80108a:	48 89 e5             	mov    %rsp,%rbp
  80108d:	48 83 ec 40          	sub    $0x40,%rsp
  801091:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801095:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801099:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  80109d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8010a1:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8010a7:	25 ff 0f 00 00       	and    $0xfff,%eax
  8010ac:	85 c0                	test   %eax,%eax
  8010ae:	74 35                	je     8010e5 <dir_lookup+0x5c>
  8010b0:	48 b9 b8 71 80 00 00 	movabs $0x8071b8,%rcx
  8010b7:	00 00 00 
  8010ba:	48 ba 4d 71 80 00 00 	movabs $0x80714d,%rdx
  8010c1:	00 00 00 
  8010c4:	be b1 00 00 00       	mov    $0xb1,%esi
  8010c9:	48 bf cd 70 80 00 00 	movabs $0x8070cd,%rdi
  8010d0:	00 00 00 
  8010d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8010d8:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  8010df:	00 00 00 
  8010e2:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  8010e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8010e9:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8010ef:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  8010f5:	85 c0                	test   %eax,%eax
  8010f7:	0f 48 c2             	cmovs  %edx,%eax
  8010fa:	c1 f8 0c             	sar    $0xc,%eax
  8010fd:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  801100:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801107:	e9 96 00 00 00       	jmpq   8011a2 <dir_lookup+0x119>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  80110c:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  801110:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801113:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801117:	89 ce                	mov    %ecx,%esi
  801119:	48 89 c7             	mov    %rax,%rdi
  80111c:	48 b8 4c 10 80 00 00 	movabs $0x80104c,%rax
  801123:	00 00 00 
  801126:	ff d0                	callq  *%rax
  801128:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80112b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80112f:	79 05                	jns    801136 <dir_lookup+0xad>
			return r;
  801131:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801134:	eb 7d                	jmp    8011b3 <dir_lookup+0x12a>
		f = (struct File*) blk;
  801136:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80113a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  80113e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  801145:	eb 51                	jmp    801198 <dir_lookup+0x10f>
			if (strcmp(f[j].f_name, name) == 0) {
  801147:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80114a:	48 c1 e0 08          	shl    $0x8,%rax
  80114e:	48 89 c2             	mov    %rax,%rdx
  801151:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801155:	48 01 d0             	add    %rdx,%rax
  801158:	48 89 c2             	mov    %rax,%rdx
  80115b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80115f:	48 89 c6             	mov    %rax,%rsi
  801162:	48 89 d7             	mov    %rdx,%rdi
  801165:	48 b8 49 41 80 00 00 	movabs $0x804149,%rax
  80116c:	00 00 00 
  80116f:	ff d0                	callq  *%rax
  801171:	85 c0                	test   %eax,%eax
  801173:	75 1f                	jne    801194 <dir_lookup+0x10b>
				*file = &f[j];
  801175:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801178:	48 c1 e0 08          	shl    $0x8,%rax
  80117c:	48 89 c2             	mov    %rax,%rdx
  80117f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801183:	48 01 c2             	add    %rax,%rdx
  801186:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80118a:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  80118d:	b8 00 00 00 00       	mov    $0x0,%eax
  801192:	eb 1f                	jmp    8011b3 <dir_lookup+0x12a>
		for (j = 0; j < BLKFILES; j++)
  801194:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  801198:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  80119c:	76 a9                	jbe    801147 <dir_lookup+0xbe>
	for (i = 0; i < nblock; i++) {
  80119e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8011a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011a5:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8011a8:	0f 82 5e ff ff ff    	jb     80110c <dir_lookup+0x83>
			}
	}
	return -E_NOT_FOUND;
  8011ae:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
}
  8011b3:	c9                   	leaveq 
  8011b4:	c3                   	retq   

00000000008011b5 <dir_alloc_file>:

// Set *file to point at a free File structure in dir.  The caller is
// responsible for filling in the File fields.
static int
dir_alloc_file(struct File *dir, struct File **file)
{
  8011b5:	55                   	push   %rbp
  8011b6:	48 89 e5             	mov    %rsp,%rbp
  8011b9:	48 83 ec 30          	sub    $0x30,%rsp
  8011bd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8011c1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	uint32_t nblock, i, j;
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
  8011c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011c9:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8011cf:	25 ff 0f 00 00       	and    $0xfff,%eax
  8011d4:	85 c0                	test   %eax,%eax
  8011d6:	74 35                	je     80120d <dir_alloc_file+0x58>
  8011d8:	48 b9 b8 71 80 00 00 	movabs $0x8071b8,%rcx
  8011df:	00 00 00 
  8011e2:	48 ba 4d 71 80 00 00 	movabs $0x80714d,%rdx
  8011e9:	00 00 00 
  8011ec:	be ca 00 00 00       	mov    $0xca,%esi
  8011f1:	48 bf cd 70 80 00 00 	movabs $0x8070cd,%rdi
  8011f8:	00 00 00 
  8011fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801200:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  801207:	00 00 00 
  80120a:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  80120d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801211:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801217:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  80121d:	85 c0                	test   %eax,%eax
  80121f:	0f 48 c2             	cmovs  %edx,%eax
  801222:	c1 f8 0c             	sar    $0xc,%eax
  801225:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  801228:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80122f:	e9 83 00 00 00       	jmpq   8012b7 <dir_alloc_file+0x102>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801234:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  801238:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80123b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80123f:	89 ce                	mov    %ecx,%esi
  801241:	48 89 c7             	mov    %rax,%rdi
  801244:	48 b8 4c 10 80 00 00 	movabs $0x80104c,%rax
  80124b:	00 00 00 
  80124e:	ff d0                	callq  *%rax
  801250:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801253:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801257:	79 08                	jns    801261 <dir_alloc_file+0xac>
			return r;
  801259:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80125c:	e9 be 00 00 00       	jmpq   80131f <dir_alloc_file+0x16a>
		f = (struct File*) blk;
  801261:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801265:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  801269:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  801270:	eb 3b                	jmp    8012ad <dir_alloc_file+0xf8>
			if (f[j].f_name[0] == '\0') {
  801272:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801275:	48 c1 e0 08          	shl    $0x8,%rax
  801279:	48 89 c2             	mov    %rax,%rdx
  80127c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801280:	48 01 d0             	add    %rdx,%rax
  801283:	0f b6 00             	movzbl (%rax),%eax
  801286:	84 c0                	test   %al,%al
  801288:	75 1f                	jne    8012a9 <dir_alloc_file+0xf4>
				*file = &f[j];
  80128a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80128d:	48 c1 e0 08          	shl    $0x8,%rax
  801291:	48 89 c2             	mov    %rax,%rdx
  801294:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801298:	48 01 c2             	add    %rax,%rdx
  80129b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80129f:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  8012a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a7:	eb 76                	jmp    80131f <dir_alloc_file+0x16a>
		for (j = 0; j < BLKFILES; j++)
  8012a9:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  8012ad:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  8012b1:	76 bf                	jbe    801272 <dir_alloc_file+0xbd>
	for (i = 0; i < nblock; i++) {
  8012b3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8012b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012ba:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8012bd:	0f 82 71 ff ff ff    	jb     801234 <dir_alloc_file+0x7f>
			}
	}
	dir->f_size += BLKSIZE;
  8012c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012c7:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8012cd:	8d 90 00 10 00 00    	lea    0x1000(%rax),%edx
  8012d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d7:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	if ((r = file_get_block(dir, i, &blk)) < 0)
  8012dd:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  8012e1:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8012e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012e8:	89 ce                	mov    %ecx,%esi
  8012ea:	48 89 c7             	mov    %rax,%rdi
  8012ed:	48 b8 4c 10 80 00 00 	movabs $0x80104c,%rax
  8012f4:	00 00 00 
  8012f7:	ff d0                	callq  *%rax
  8012f9:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8012fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801300:	79 05                	jns    801307 <dir_alloc_file+0x152>
		return r;
  801302:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801305:	eb 18                	jmp    80131f <dir_alloc_file+0x16a>
	f = (struct File*) blk;
  801307:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80130b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	*file = &f[0];
  80130f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801313:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801317:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80131a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80131f:	c9                   	leaveq 
  801320:	c3                   	retq   

0000000000801321 <skip_slash>:

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
  801321:	55                   	push   %rbp
  801322:	48 89 e5             	mov    %rsp,%rbp
  801325:	48 83 ec 08          	sub    $0x8,%rsp
  801329:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	while (*p == '/')
  80132d:	eb 05                	jmp    801334 <skip_slash+0x13>
		p++;
  80132f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
	while (*p == '/')
  801334:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801338:	0f b6 00             	movzbl (%rax),%eax
  80133b:	3c 2f                	cmp    $0x2f,%al
  80133d:	74 f0                	je     80132f <skip_slash+0xe>
	return p;
  80133f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801343:	c9                   	leaveq 
  801344:	c3                   	retq   

0000000000801345 <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  801345:	55                   	push   %rbp
  801346:	48 89 e5             	mov    %rsp,%rbp
  801349:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  801350:	48 89 bd 48 ff ff ff 	mov    %rdi,-0xb8(%rbp)
  801357:	48 89 b5 40 ff ff ff 	mov    %rsi,-0xc0(%rbp)
  80135e:	48 89 95 38 ff ff ff 	mov    %rdx,-0xc8(%rbp)
  801365:	48 89 8d 30 ff ff ff 	mov    %rcx,-0xd0(%rbp)
	struct File *dir, *f;
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
  80136c:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801373:	48 89 c7             	mov    %rax,%rdi
  801376:	48 b8 21 13 80 00 00 	movabs $0x801321,%rax
  80137d:	00 00 00 
  801380:	ff d0                	callq  *%rax
  801382:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	f = &super->s_root;
  801389:	48 b8 18 50 81 00 00 	movabs $0x815018,%rax
  801390:	00 00 00 
  801393:	48 8b 00             	mov    (%rax),%rax
  801396:	48 83 c0 08          	add    $0x8,%rax
  80139a:	48 89 85 58 ff ff ff 	mov    %rax,-0xa8(%rbp)
	dir = 0;
  8013a1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8013a8:	00 
	name[0] = 0;
  8013a9:	c6 85 60 ff ff ff 00 	movb   $0x0,-0xa0(%rbp)

	if (pdir)
  8013b0:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  8013b7:	00 
  8013b8:	74 0e                	je     8013c8 <walk_path+0x83>
		*pdir = 0;
  8013ba:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  8013c1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	*pf = 0;
  8013c8:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  8013cf:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	while (*path != '\0') {
  8013d6:	e9 73 01 00 00       	jmpq   80154e <walk_path+0x209>
		dir = f;
  8013db:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8013e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		p = path;
  8013e6:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8013ed:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		while (*path != '/' && *path != '\0')
  8013f1:	eb 08                	jmp    8013fb <walk_path+0xb6>
			path++;
  8013f3:	48 83 85 48 ff ff ff 	addq   $0x1,-0xb8(%rbp)
  8013fa:	01 
		while (*path != '/' && *path != '\0')
  8013fb:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801402:	0f b6 00             	movzbl (%rax),%eax
  801405:	3c 2f                	cmp    $0x2f,%al
  801407:	74 0e                	je     801417 <walk_path+0xd2>
  801409:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801410:	0f b6 00             	movzbl (%rax),%eax
  801413:	84 c0                	test   %al,%al
  801415:	75 dc                	jne    8013f3 <walk_path+0xae>
		if (path - p >= MAXNAMELEN)
  801417:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  80141e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801422:	48 29 c2             	sub    %rax,%rdx
  801425:	48 89 d0             	mov    %rdx,%rax
  801428:	48 83 f8 7f          	cmp    $0x7f,%rax
  80142c:	7e 0a                	jle    801438 <walk_path+0xf3>
			return -E_BAD_PATH;
  80142e:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801433:	e9 56 01 00 00       	jmpq   80158e <walk_path+0x249>
		memmove(name, p, path - p);
  801438:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  80143f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801443:	48 29 c2             	sub    %rax,%rdx
  801446:	48 89 d0             	mov    %rdx,%rax
  801449:	48 89 c2             	mov    %rax,%rdx
  80144c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801450:	48 8d 85 60 ff ff ff 	lea    -0xa0(%rbp),%rax
  801457:	48 89 ce             	mov    %rcx,%rsi
  80145a:	48 89 c7             	mov    %rax,%rdi
  80145d:	48 b8 0b 43 80 00 00 	movabs $0x80430b,%rax
  801464:	00 00 00 
  801467:	ff d0                	callq  *%rax
		name[path - p] = '\0';
  801469:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  801470:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801474:	48 29 c2             	sub    %rax,%rdx
  801477:	48 89 d0             	mov    %rdx,%rax
  80147a:	c6 84 05 60 ff ff ff 	movb   $0x0,-0xa0(%rbp,%rax,1)
  801481:	00 
		path = skip_slash(path);
  801482:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801489:	48 89 c7             	mov    %rax,%rdi
  80148c:	48 b8 21 13 80 00 00 	movabs $0x801321,%rax
  801493:	00 00 00 
  801496:	ff d0                	callq  *%rax
  801498:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)

		if (dir->f_type != FTYPE_DIR)
  80149f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a3:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  8014a9:	83 f8 01             	cmp    $0x1,%eax
  8014ac:	74 0a                	je     8014b8 <walk_path+0x173>
			return -E_NOT_FOUND;
  8014ae:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8014b3:	e9 d6 00 00 00       	jmpq   80158e <walk_path+0x249>

		if ((r = dir_lookup(dir, name, &f)) < 0) {
  8014b8:	48 8d 95 58 ff ff ff 	lea    -0xa8(%rbp),%rdx
  8014bf:	48 8d 8d 60 ff ff ff 	lea    -0xa0(%rbp),%rcx
  8014c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ca:	48 89 ce             	mov    %rcx,%rsi
  8014cd:	48 89 c7             	mov    %rax,%rdi
  8014d0:	48 b8 89 10 80 00 00 	movabs $0x801089,%rax
  8014d7:	00 00 00 
  8014da:	ff d0                	callq  *%rax
  8014dc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014df:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8014e3:	79 69                	jns    80154e <walk_path+0x209>
			if (r == -E_NOT_FOUND && *path == '\0') {
  8014e5:	83 7d ec f4          	cmpl   $0xfffffff4,-0x14(%rbp)
  8014e9:	75 5e                	jne    801549 <walk_path+0x204>
  8014eb:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8014f2:	0f b6 00             	movzbl (%rax),%eax
  8014f5:	84 c0                	test   %al,%al
  8014f7:	75 50                	jne    801549 <walk_path+0x204>
				if (pdir)
  8014f9:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  801500:	00 
  801501:	74 0e                	je     801511 <walk_path+0x1cc>
					*pdir = dir;
  801503:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  80150a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80150e:	48 89 10             	mov    %rdx,(%rax)
				if (lastelem)
  801511:	48 83 bd 30 ff ff ff 	cmpq   $0x0,-0xd0(%rbp)
  801518:	00 
  801519:	74 20                	je     80153b <walk_path+0x1f6>
					strcpy(lastelem, name);
  80151b:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  801522:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
  801529:	48 89 d6             	mov    %rdx,%rsi
  80152c:	48 89 c7             	mov    %rax,%rdi
  80152f:	48 b8 e7 3f 80 00 00 	movabs $0x803fe7,%rax
  801536:	00 00 00 
  801539:	ff d0                	callq  *%rax
				*pf = 0;
  80153b:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  801542:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
			}
			return r;
  801549:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80154c:	eb 40                	jmp    80158e <walk_path+0x249>
	while (*path != '\0') {
  80154e:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801555:	0f b6 00             	movzbl (%rax),%eax
  801558:	84 c0                	test   %al,%al
  80155a:	0f 85 7b fe ff ff    	jne    8013db <walk_path+0x96>
		}
	}

	if (pdir)
  801560:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  801567:	00 
  801568:	74 0e                	je     801578 <walk_path+0x233>
		*pdir = dir;
  80156a:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  801571:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801575:	48 89 10             	mov    %rdx,(%rax)
	*pf = f;
  801578:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  80157f:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  801586:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801589:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80158e:	c9                   	leaveq 
  80158f:	c3                   	retq   

0000000000801590 <file_create>:

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
{
  801590:	55                   	push   %rbp
  801591:	48 89 e5             	mov    %rsp,%rbp
  801594:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80159b:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
  8015a2:	48 89 b5 50 ff ff ff 	mov    %rsi,-0xb0(%rbp)
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
  8015a9:	48 8d 8d 70 ff ff ff 	lea    -0x90(%rbp),%rcx
  8015b0:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  8015b7:	48 8d b5 68 ff ff ff 	lea    -0x98(%rbp),%rsi
  8015be:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8015c5:	48 89 c7             	mov    %rax,%rdi
  8015c8:	48 b8 45 13 80 00 00 	movabs $0x801345,%rax
  8015cf:	00 00 00 
  8015d2:	ff d0                	callq  *%rax
  8015d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8015d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015db:	75 0a                	jne    8015e7 <file_create+0x57>
		return -E_FILE_EXISTS;
  8015dd:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8015e2:	e9 94 00 00 00       	jmpq   80167b <file_create+0xeb>
	if (r != -E_NOT_FOUND || dir == 0)
  8015e7:	83 7d fc f4          	cmpl   $0xfffffff4,-0x4(%rbp)
  8015eb:	75 0c                	jne    8015f9 <file_create+0x69>
  8015ed:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8015f4:	48 85 c0             	test   %rax,%rax
  8015f7:	75 05                	jne    8015fe <file_create+0x6e>
		return r;
  8015f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015fc:	eb 7d                	jmp    80167b <file_create+0xeb>
	if ((r = dir_alloc_file(dir, &f)) < 0)
  8015fe:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  801605:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  80160c:	48 89 d6             	mov    %rdx,%rsi
  80160f:	48 89 c7             	mov    %rax,%rdi
  801612:	48 b8 b5 11 80 00 00 	movabs $0x8011b5,%rax
  801619:	00 00 00 
  80161c:	ff d0                	callq  *%rax
  80161e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801621:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801625:	79 05                	jns    80162c <file_create+0x9c>
		return r;
  801627:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80162a:	eb 4f                	jmp    80167b <file_create+0xeb>
	strcpy(f->f_name, name);
  80162c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801633:	48 89 c2             	mov    %rax,%rdx
  801636:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80163d:	48 89 c6             	mov    %rax,%rsi
  801640:	48 89 d7             	mov    %rdx,%rdi
  801643:	48 b8 e7 3f 80 00 00 	movabs $0x803fe7,%rax
  80164a:	00 00 00 
  80164d:	ff d0                	callq  *%rax
	*pf = f;
  80164f:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  801656:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  80165d:	48 89 10             	mov    %rdx,(%rax)
	file_flush(dir);
  801660:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  801667:	48 89 c7             	mov    %rax,%rdi
  80166a:	48 b8 09 1b 80 00 00 	movabs $0x801b09,%rax
  801671:	00 00 00 
  801674:	ff d0                	callq  *%rax
	return 0;
  801676:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80167b:	c9                   	leaveq 
  80167c:	c3                   	retq   

000000000080167d <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  80167d:	55                   	push   %rbp
  80167e:	48 89 e5             	mov    %rsp,%rbp
  801681:	48 83 ec 10          	sub    $0x10,%rsp
  801685:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801689:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return walk_path(path, 0, pf, 0);
  80168d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801691:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801695:	b9 00 00 00 00       	mov    $0x0,%ecx
  80169a:	be 00 00 00 00       	mov    $0x0,%esi
  80169f:	48 89 c7             	mov    %rax,%rdi
  8016a2:	48 b8 45 13 80 00 00 	movabs $0x801345,%rax
  8016a9:	00 00 00 
  8016ac:	ff d0                	callq  *%rax
}
  8016ae:	c9                   	leaveq 
  8016af:	c3                   	retq   

00000000008016b0 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  8016b0:	55                   	push   %rbp
  8016b1:	48 89 e5             	mov    %rsp,%rbp
  8016b4:	48 83 ec 60          	sub    $0x60,%rsp
  8016b8:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  8016bc:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  8016c0:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  8016c4:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  8016c7:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8016cb:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8016d1:	3b 45 a4             	cmp    -0x5c(%rbp),%eax
  8016d4:	7f 0a                	jg     8016e0 <file_read+0x30>
		return 0;
  8016d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016db:	e9 24 01 00 00       	jmpq   801804 <file_read+0x154>

	count = MIN(count, f->f_size - offset);
  8016e0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8016e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8016e8:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8016ec:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8016f2:	2b 45 a4             	sub    -0x5c(%rbp),%eax
  8016f5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016f8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016fb:	48 63 d0             	movslq %eax,%rdx
  8016fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801702:	48 39 c2             	cmp    %rax,%rdx
  801705:	48 0f 46 c2          	cmovbe %rdx,%rax
  801709:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	for (pos = offset; pos < offset + count; ) {
  80170d:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  801710:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801713:	e9 cd 00 00 00       	jmpq   8017e5 <file_read+0x135>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  801718:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80171b:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801721:	85 c0                	test   %eax,%eax
  801723:	0f 48 c2             	cmovs  %edx,%eax
  801726:	c1 f8 0c             	sar    $0xc,%eax
  801729:	89 c1                	mov    %eax,%ecx
  80172b:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  80172f:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801733:	89 ce                	mov    %ecx,%esi
  801735:	48 89 c7             	mov    %rax,%rdi
  801738:	48 b8 4c 10 80 00 00 	movabs $0x80104c,%rax
  80173f:	00 00 00 
  801742:	ff d0                	callq  *%rax
  801744:	89 45 e8             	mov    %eax,-0x18(%rbp)
  801747:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80174b:	79 08                	jns    801755 <file_read+0xa5>
			return r;
  80174d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801750:	e9 af 00 00 00       	jmpq   801804 <file_read+0x154>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801755:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801758:	99                   	cltd   
  801759:	c1 ea 14             	shr    $0x14,%edx
  80175c:	01 d0                	add    %edx,%eax
  80175e:	25 ff 0f 00 00       	and    $0xfff,%eax
  801763:	29 d0                	sub    %edx,%eax
  801765:	ba 00 10 00 00       	mov    $0x1000,%edx
  80176a:	29 c2                	sub    %eax,%edx
  80176c:	89 d0                	mov    %edx,%eax
  80176e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  801771:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  801774:	48 63 d0             	movslq %eax,%rdx
  801777:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80177b:	48 01 c2             	add    %rax,%rdx
  80177e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801781:	48 98                	cltq   
  801783:	48 29 c2             	sub    %rax,%rdx
  801786:	48 89 d0             	mov    %rdx,%rax
  801789:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80178d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801790:	48 63 d0             	movslq %eax,%rdx
  801793:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801797:	48 39 c2             	cmp    %rax,%rdx
  80179a:	48 0f 46 c2          	cmovbe %rdx,%rax
  80179e:	89 45 d4             	mov    %eax,-0x2c(%rbp)
		memmove(buf, blk + pos % BLKSIZE, bn);
  8017a1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8017a4:	48 63 c8             	movslq %eax,%rcx
  8017a7:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8017ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017ae:	99                   	cltd   
  8017af:	c1 ea 14             	shr    $0x14,%edx
  8017b2:	01 d0                	add    %edx,%eax
  8017b4:	25 ff 0f 00 00       	and    $0xfff,%eax
  8017b9:	29 d0                	sub    %edx,%eax
  8017bb:	48 98                	cltq   
  8017bd:	48 01 c6             	add    %rax,%rsi
  8017c0:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8017c4:	48 89 ca             	mov    %rcx,%rdx
  8017c7:	48 89 c7             	mov    %rax,%rdi
  8017ca:	48 b8 0b 43 80 00 00 	movabs $0x80430b,%rax
  8017d1:	00 00 00 
  8017d4:	ff d0                	callq  *%rax
		pos += bn;
  8017d6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8017d9:	01 45 fc             	add    %eax,-0x4(%rbp)
		buf += bn;
  8017dc:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8017df:	48 98                	cltq   
  8017e1:	48 01 45 b0          	add    %rax,-0x50(%rbp)
	for (pos = offset; pos < offset + count; ) {
  8017e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017e8:	48 98                	cltq   
  8017ea:	8b 55 a4             	mov    -0x5c(%rbp),%edx
  8017ed:	48 63 ca             	movslq %edx,%rcx
  8017f0:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8017f4:	48 01 ca             	add    %rcx,%rdx
  8017f7:	48 39 d0             	cmp    %rdx,%rax
  8017fa:	0f 82 18 ff ff ff    	jb     801718 <file_read+0x68>
	}

	return count;
  801800:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
}
  801804:	c9                   	leaveq 
  801805:	c3                   	retq   

0000000000801806 <file_write>:
// offset.  This is meant to mimic the standard pwrite function.
// Extends the file if necessary.
// Returns the number of bytes written, < 0 on error.
int
file_write(struct File *f, const void *buf, size_t count, off_t offset)
{
  801806:	55                   	push   %rbp
  801807:	48 89 e5             	mov    %rsp,%rbp
  80180a:	48 83 ec 50          	sub    $0x50,%rsp
  80180e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801812:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  801816:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80181a:	89 4d b4             	mov    %ecx,-0x4c(%rbp)
	int r, bn;
	off_t pos;
	char *blk;

	// Extend file if necessary
	if (offset + count > f->f_size)
  80181d:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801820:	48 63 d0             	movslq %eax,%rdx
  801823:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801827:	48 01 c2             	add    %rax,%rdx
  80182a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80182e:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801834:	48 98                	cltq   
  801836:	48 39 c2             	cmp    %rax,%rdx
  801839:	76 33                	jbe    80186e <file_write+0x68>
		if ((r = file_set_size(f, offset + count)) < 0)
  80183b:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80183f:	89 c2                	mov    %eax,%edx
  801841:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801844:	01 d0                	add    %edx,%eax
  801846:	89 c2                	mov    %eax,%edx
  801848:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80184c:	89 d6                	mov    %edx,%esi
  80184e:	48 89 c7             	mov    %rax,%rdi
  801851:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  801858:	00 00 00 
  80185b:	ff d0                	callq  *%rax
  80185d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801860:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801864:	79 08                	jns    80186e <file_write+0x68>
			return r;
  801866:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801869:	e9 f8 00 00 00       	jmpq   801966 <file_write+0x160>

	for (pos = offset; pos < offset + count; ) {
  80186e:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801871:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801874:	e9 ce 00 00 00       	jmpq   801947 <file_write+0x141>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  801879:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80187c:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801882:	85 c0                	test   %eax,%eax
  801884:	0f 48 c2             	cmovs  %edx,%eax
  801887:	c1 f8 0c             	sar    $0xc,%eax
  80188a:	89 c1                	mov    %eax,%ecx
  80188c:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801890:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801894:	89 ce                	mov    %ecx,%esi
  801896:	48 89 c7             	mov    %rax,%rdi
  801899:	48 b8 4c 10 80 00 00 	movabs $0x80104c,%rax
  8018a0:	00 00 00 
  8018a3:	ff d0                	callq  *%rax
  8018a5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8018a8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8018ac:	79 08                	jns    8018b6 <file_write+0xb0>
			return r;
  8018ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018b1:	e9 b0 00 00 00       	jmpq   801966 <file_write+0x160>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  8018b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018b9:	99                   	cltd   
  8018ba:	c1 ea 14             	shr    $0x14,%edx
  8018bd:	01 d0                	add    %edx,%eax
  8018bf:	25 ff 0f 00 00       	and    $0xfff,%eax
  8018c4:	29 d0                	sub    %edx,%eax
  8018c6:	ba 00 10 00 00       	mov    $0x1000,%edx
  8018cb:	29 c2                	sub    %eax,%edx
  8018cd:	89 d0                	mov    %edx,%eax
  8018cf:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8018d2:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8018d5:	48 63 d0             	movslq %eax,%rdx
  8018d8:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8018dc:	48 01 c2             	add    %rax,%rdx
  8018df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018e2:	48 98                	cltq   
  8018e4:	48 29 c2             	sub    %rax,%rdx
  8018e7:	48 89 d0             	mov    %rdx,%rax
  8018ea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8018ee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8018f1:	48 63 d0             	movslq %eax,%rdx
  8018f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018f8:	48 39 c2             	cmp    %rax,%rdx
  8018fb:	48 0f 46 c2          	cmovbe %rdx,%rax
  8018ff:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		memmove(blk + pos % BLKSIZE, buf, bn);
  801902:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801905:	48 63 c8             	movslq %eax,%rcx
  801908:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80190c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80190f:	99                   	cltd   
  801910:	c1 ea 14             	shr    $0x14,%edx
  801913:	01 d0                	add    %edx,%eax
  801915:	25 ff 0f 00 00       	and    $0xfff,%eax
  80191a:	29 d0                	sub    %edx,%eax
  80191c:	48 98                	cltq   
  80191e:	48 8d 3c 06          	lea    (%rsi,%rax,1),%rdi
  801922:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801926:	48 89 ca             	mov    %rcx,%rdx
  801929:	48 89 c6             	mov    %rax,%rsi
  80192c:	48 b8 0b 43 80 00 00 	movabs $0x80430b,%rax
  801933:	00 00 00 
  801936:	ff d0                	callq  *%rax
		pos += bn;
  801938:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80193b:	01 45 fc             	add    %eax,-0x4(%rbp)
		buf += bn;
  80193e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801941:	48 98                	cltq   
  801943:	48 01 45 c0          	add    %rax,-0x40(%rbp)
	for (pos = offset; pos < offset + count; ) {
  801947:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80194a:	48 98                	cltq   
  80194c:	8b 55 b4             	mov    -0x4c(%rbp),%edx
  80194f:	48 63 ca             	movslq %edx,%rcx
  801952:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801956:	48 01 ca             	add    %rcx,%rdx
  801959:	48 39 d0             	cmp    %rdx,%rax
  80195c:	0f 82 17 ff ff ff    	jb     801879 <file_write+0x73>
	}

	return count;
  801962:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
}
  801966:	c9                   	leaveq 
  801967:	c3                   	retq   

0000000000801968 <file_free_block>:

// Remove a block from file f.  If it's not there, just silently succeed.
// Returns 0 on success, < 0 on error.
static int
file_free_block(struct File *f, uint32_t filebno)
{
  801968:	55                   	push   %rbp
  801969:	48 89 e5             	mov    %rsp,%rbp
  80196c:	48 83 ec 20          	sub    $0x20,%rsp
  801970:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801974:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  801977:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80197b:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  80197e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801982:	b9 00 00 00 00       	mov    $0x0,%ecx
  801987:	48 89 c7             	mov    %rax,%rdi
  80198a:	48 b8 0a 10 80 00 00 	movabs $0x80100a,%rax
  801991:	00 00 00 
  801994:	ff d0                	callq  *%rax
  801996:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801999:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80199d:	79 05                	jns    8019a4 <file_free_block+0x3c>
		return r;
  80199f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019a2:	eb 2d                	jmp    8019d1 <file_free_block+0x69>
	if (*ptr) {
  8019a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019a8:	8b 00                	mov    (%rax),%eax
  8019aa:	85 c0                	test   %eax,%eax
  8019ac:	74 1e                	je     8019cc <file_free_block+0x64>
		free_block(*ptr);
  8019ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019b2:	8b 00                	mov    (%rax),%eax
  8019b4:	89 c7                	mov    %eax,%edi
  8019b6:	48 b8 a9 0d 80 00 00 	movabs $0x800da9,%rax
  8019bd:	00 00 00 
  8019c0:	ff d0                	callq  *%rax
		*ptr = 0;
  8019c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019c6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	return 0;
  8019cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019d1:	c9                   	leaveq 
  8019d2:	c3                   	retq   

00000000008019d3 <file_truncate_blocks>:
// (Remember to clear the f->f_indirect pointer so you'll know
// whether it's valid!)
// Do not change f->f_size.
static void
file_truncate_blocks(struct File *f, off_t newsize)
{
  8019d3:	55                   	push   %rbp
  8019d4:	48 89 e5             	mov    %rsp,%rbp
  8019d7:	48 83 ec 20          	sub    $0x20,%rsp
  8019db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019df:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  8019e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019e6:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8019ec:	05 ff 0f 00 00       	add    $0xfff,%eax
  8019f1:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  8019f7:	85 c0                	test   %eax,%eax
  8019f9:	0f 48 c2             	cmovs  %edx,%eax
  8019fc:	c1 f8 0c             	sar    $0xc,%eax
  8019ff:	89 45 f8             	mov    %eax,-0x8(%rbp)
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  801a02:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a05:	05 ff 0f 00 00       	add    $0xfff,%eax
  801a0a:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801a10:	85 c0                	test   %eax,%eax
  801a12:	0f 48 c2             	cmovs  %edx,%eax
  801a15:	c1 f8 0c             	sar    $0xc,%eax
  801a18:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  801a1b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a21:	eb 45                	jmp    801a68 <file_truncate_blocks+0x95>
		if ((r = file_free_block(f, bno)) < 0)
  801a23:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801a26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a2a:	89 d6                	mov    %edx,%esi
  801a2c:	48 89 c7             	mov    %rax,%rdi
  801a2f:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  801a36:	00 00 00 
  801a39:	ff d0                	callq  *%rax
  801a3b:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801a3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801a42:	79 20                	jns    801a64 <file_truncate_blocks+0x91>
			cprintf("warning: file_free_block: %e", r);
  801a44:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801a47:	89 c6                	mov    %eax,%esi
  801a49:	48 bf d5 71 80 00 00 	movabs $0x8071d5,%rdi
  801a50:	00 00 00 
  801a53:	b8 00 00 00 00       	mov    $0x0,%eax
  801a58:	48 ba 4d 34 80 00 00 	movabs $0x80344d,%rdx
  801a5f:	00 00 00 
  801a62:	ff d2                	callq  *%rdx
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  801a64:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801a68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a6b:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  801a6e:	72 b3                	jb     801a23 <file_truncate_blocks+0x50>

	if (new_nblocks <= NDIRECT && f->f_indirect) {
  801a70:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  801a74:	77 34                	ja     801aaa <file_truncate_blocks+0xd7>
  801a76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a7a:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801a80:	85 c0                	test   %eax,%eax
  801a82:	74 26                	je     801aaa <file_truncate_blocks+0xd7>
		free_block(f->f_indirect);
  801a84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a88:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801a8e:	89 c7                	mov    %eax,%edi
  801a90:	48 b8 a9 0d 80 00 00 	movabs $0x800da9,%rax
  801a97:	00 00 00 
  801a9a:	ff d0                	callq  *%rax
		f->f_indirect = 0;
  801a9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801aa0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%rax)
  801aa7:	00 00 00 
	}
}
  801aaa:	c9                   	leaveq 
  801aab:	c3                   	retq   

0000000000801aac <file_set_size>:

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  801aac:	55                   	push   %rbp
  801aad:	48 89 e5             	mov    %rsp,%rbp
  801ab0:	48 83 ec 10          	sub    $0x10,%rsp
  801ab4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ab8:	89 75 f4             	mov    %esi,-0xc(%rbp)
	if (f->f_size > newsize)
  801abb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801abf:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801ac5:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801ac8:	7e 18                	jle    801ae2 <file_set_size+0x36>
		file_truncate_blocks(f, newsize);
  801aca:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801acd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ad1:	89 d6                	mov    %edx,%esi
  801ad3:	48 89 c7             	mov    %rax,%rdi
  801ad6:	48 b8 d3 19 80 00 00 	movabs $0x8019d3,%rax
  801add:	00 00 00 
  801ae0:	ff d0                	callq  *%rax
	f->f_size = newsize;
  801ae2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ae6:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801ae9:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	flush_block(f);
  801aef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801af3:	48 89 c7             	mov    %rax,%rdi
  801af6:	48 b8 56 08 80 00 00 	movabs $0x800856,%rax
  801afd:	00 00 00 
  801b00:	ff d0                	callq  *%rax
	return 0;
  801b02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b07:	c9                   	leaveq 
  801b08:	c3                   	retq   

0000000000801b09 <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  801b09:	55                   	push   %rbp
  801b0a:	48 89 e5             	mov    %rsp,%rbp
  801b0d:	48 83 ec 20          	sub    $0x20,%rsp
  801b11:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801b15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801b1c:	eb 62                	jmp    801b80 <file_flush+0x77>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801b1e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801b21:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801b25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b29:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b2e:	48 89 c7             	mov    %rax,%rdi
  801b31:	48 b8 0a 10 80 00 00 	movabs $0x80100a,%rax
  801b38:	00 00 00 
  801b3b:	ff d0                	callq  *%rax
  801b3d:	85 c0                	test   %eax,%eax
  801b3f:	78 13                	js     801b54 <file_flush+0x4b>
		    pdiskbno == NULL || *pdiskbno == 0)
  801b41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801b45:	48 85 c0             	test   %rax,%rax
  801b48:	74 0a                	je     801b54 <file_flush+0x4b>
		    pdiskbno == NULL || *pdiskbno == 0)
  801b4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b4e:	8b 00                	mov    (%rax),%eax
  801b50:	85 c0                	test   %eax,%eax
  801b52:	75 02                	jne    801b56 <file_flush+0x4d>
			continue;
  801b54:	eb 26                	jmp    801b7c <file_flush+0x73>
		flush_block(diskaddr(*pdiskbno));
  801b56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b5a:	8b 00                	mov    (%rax),%eax
  801b5c:	89 c0                	mov    %eax,%eax
  801b5e:	48 89 c7             	mov    %rax,%rdi
  801b61:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801b68:	00 00 00 
  801b6b:	ff d0                	callq  *%rax
  801b6d:	48 89 c7             	mov    %rax,%rdi
  801b70:	48 b8 56 08 80 00 00 	movabs $0x800856,%rax
  801b77:	00 00 00 
  801b7a:	ff d0                	callq  *%rax
	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801b7c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801b80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b84:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801b8a:	05 ff 0f 00 00       	add    $0xfff,%eax
  801b8f:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801b95:	85 c0                	test   %eax,%eax
  801b97:	0f 48 c2             	cmovs  %edx,%eax
  801b9a:	c1 f8 0c             	sar    $0xc,%eax
  801b9d:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  801ba0:	0f 8f 78 ff ff ff    	jg     801b1e <file_flush+0x15>
	}
	flush_block(f);
  801ba6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801baa:	48 89 c7             	mov    %rax,%rdi
  801bad:	48 b8 56 08 80 00 00 	movabs $0x800856,%rax
  801bb4:	00 00 00 
  801bb7:	ff d0                	callq  *%rax
	if (f->f_indirect)
  801bb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bbd:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801bc3:	85 c0                	test   %eax,%eax
  801bc5:	74 2a                	je     801bf1 <file_flush+0xe8>
		flush_block(diskaddr(f->f_indirect));
  801bc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bcb:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801bd1:	89 c0                	mov    %eax,%eax
  801bd3:	48 89 c7             	mov    %rax,%rdi
  801bd6:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801bdd:	00 00 00 
  801be0:	ff d0                	callq  *%rax
  801be2:	48 89 c7             	mov    %rax,%rdi
  801be5:	48 b8 56 08 80 00 00 	movabs $0x800856,%rax
  801bec:	00 00 00 
  801bef:	ff d0                	callq  *%rax
}
  801bf1:	c9                   	leaveq 
  801bf2:	c3                   	retq   

0000000000801bf3 <file_remove>:

// Remove a file by truncating it and then zeroing the name.
int
file_remove(const char *path)
{
  801bf3:	55                   	push   %rbp
  801bf4:	48 89 e5             	mov    %rsp,%rbp
  801bf7:	48 83 ec 20          	sub    $0x20,%rsp
  801bfb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;
	struct File *f;

	if ((r = walk_path(path, 0, &f, 0)) < 0)
  801bff:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801c03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c07:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c0c:	be 00 00 00 00       	mov    $0x0,%esi
  801c11:	48 89 c7             	mov    %rax,%rdi
  801c14:	48 b8 45 13 80 00 00 	movabs $0x801345,%rax
  801c1b:	00 00 00 
  801c1e:	ff d0                	callq  *%rax
  801c20:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c27:	79 05                	jns    801c2e <file_remove+0x3b>
		return r;
  801c29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c2c:	eb 45                	jmp    801c73 <file_remove+0x80>

	file_truncate_blocks(f, 0);
  801c2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c32:	be 00 00 00 00       	mov    $0x0,%esi
  801c37:	48 89 c7             	mov    %rax,%rdi
  801c3a:	48 b8 d3 19 80 00 00 	movabs $0x8019d3,%rax
  801c41:	00 00 00 
  801c44:	ff d0                	callq  *%rax
	f->f_name[0] = '\0';
  801c46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c4a:	c6 00 00             	movb   $0x0,(%rax)
	f->f_size = 0;
  801c4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c51:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  801c58:	00 00 00 
	flush_block(f);
  801c5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c5f:	48 89 c7             	mov    %rax,%rdi
  801c62:	48 b8 56 08 80 00 00 	movabs $0x800856,%rax
  801c69:	00 00 00 
  801c6c:	ff d0                	callq  *%rax

	return 0;
  801c6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c73:	c9                   	leaveq 
  801c74:	c3                   	retq   

0000000000801c75 <fs_sync>:

// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  801c75:	55                   	push   %rbp
  801c76:	48 89 e5             	mov    %rsp,%rbp
  801c79:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  801c7d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  801c84:	eb 27                	jmp    801cad <fs_sync+0x38>
		flush_block(diskaddr(i));
  801c86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c89:	48 98                	cltq   
  801c8b:	48 89 c7             	mov    %rax,%rdi
  801c8e:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801c95:	00 00 00 
  801c98:	ff d0                	callq  *%rax
  801c9a:	48 89 c7             	mov    %rax,%rdi
  801c9d:	48 b8 56 08 80 00 00 	movabs $0x800856,%rax
  801ca4:	00 00 00 
  801ca7:	ff d0                	callq  *%rax
	for (i = 1; i < super->s_nblocks; i++)
  801ca9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801cad:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801cb0:	48 b8 18 50 81 00 00 	movabs $0x815018,%rax
  801cb7:	00 00 00 
  801cba:	48 8b 00             	mov    (%rax),%rax
  801cbd:	8b 40 04             	mov    0x4(%rax),%eax
  801cc0:	39 c2                	cmp    %eax,%edx
  801cc2:	72 c2                	jb     801c86 <fs_sync+0x11>
}
  801cc4:	c9                   	leaveq 
  801cc5:	c3                   	retq   

0000000000801cc6 <serve_init>:
// Virtual address at which to receive page mappings containing client requests.
union Fsipc *fsreq = (union Fsipc *)0x0ffff000;

void
serve_init(void)
{
  801cc6:	55                   	push   %rbp
  801cc7:	48 89 e5             	mov    %rsp,%rbp
  801cca:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	uintptr_t va = FILEVA;
  801cce:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
  801cd3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < MAXOPEN; i++) {
  801cd7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801cde:	eb 4b                	jmp    801d2b <serve_init+0x65>
		opentab[i].o_fileid = i;
  801ce0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ce3:	48 ba 40 a0 80 00 00 	movabs $0x80a040,%rdx
  801cea:	00 00 00 
  801ced:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801cf0:	48 63 c9             	movslq %ecx,%rcx
  801cf3:	48 c1 e1 05          	shl    $0x5,%rcx
  801cf7:	48 01 ca             	add    %rcx,%rdx
  801cfa:	89 02                	mov    %eax,(%rdx)
		opentab[i].o_fd = (struct Fd*) va;
  801cfc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d00:	48 ba 40 a0 80 00 00 	movabs $0x80a040,%rdx
  801d07:	00 00 00 
  801d0a:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801d0d:	48 63 c9             	movslq %ecx,%rcx
  801d10:	48 c1 e1 05          	shl    $0x5,%rcx
  801d14:	48 01 ca             	add    %rcx,%rdx
  801d17:	48 83 c2 10          	add    $0x10,%rdx
  801d1b:	48 89 42 08          	mov    %rax,0x8(%rdx)
		va += PGSIZE;
  801d1f:	48 81 45 f0 00 10 00 	addq   $0x1000,-0x10(%rbp)
  801d26:	00 
	for (i = 0; i < MAXOPEN; i++) {
  801d27:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d2b:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  801d32:	7e ac                	jle    801ce0 <serve_init+0x1a>
	}
}
  801d34:	c9                   	leaveq 
  801d35:	c3                   	retq   

0000000000801d36 <openfile_alloc>:

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  801d36:	55                   	push   %rbp
  801d37:	48 89 e5             	mov    %rsp,%rbp
  801d3a:	53                   	push   %rbx
  801d3b:	48 83 ec 28          	sub    $0x28,%rsp
  801d3f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  801d43:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  801d4a:	e9 02 02 00 00       	jmpq   801f51 <openfile_alloc+0x21b>
		switch (pageref(opentab[i].o_fd)) {
  801d4f:	48 b8 40 a0 80 00 00 	movabs $0x80a040,%rax
  801d56:	00 00 00 
  801d59:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d5c:	48 63 d2             	movslq %edx,%rdx
  801d5f:	48 c1 e2 05          	shl    $0x5,%rdx
  801d63:	48 01 d0             	add    %rdx,%rax
  801d66:	48 83 c0 10          	add    $0x10,%rax
  801d6a:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d6e:	48 89 c7             	mov    %rax,%rdi
  801d71:	48 b8 34 5d 80 00 00 	movabs $0x805d34,%rax
  801d78:	00 00 00 
  801d7b:	ff d0                	callq  *%rax
  801d7d:	85 c0                	test   %eax,%eax
  801d7f:	74 0e                	je     801d8f <openfile_alloc+0x59>
  801d81:	83 f8 01             	cmp    $0x1,%eax
  801d84:	0f 84 ec 00 00 00    	je     801e76 <openfile_alloc+0x140>
  801d8a:	e9 be 01 00 00       	jmpq   801f4d <openfile_alloc+0x217>

		case 0:
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  801d8f:	48 b8 40 a0 80 00 00 	movabs $0x80a040,%rax
  801d96:	00 00 00 
  801d99:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d9c:	48 63 d2             	movslq %edx,%rdx
  801d9f:	48 c1 e2 05          	shl    $0x5,%rdx
  801da3:	48 01 d0             	add    %rdx,%rax
  801da6:	48 83 c0 10          	add    $0x10,%rax
  801daa:	48 8b 40 08          	mov    0x8(%rax),%rax
  801dae:	ba 07 00 00 00       	mov    $0x7,%edx
  801db3:	48 89 c6             	mov    %rax,%rsi
  801db6:	bf 00 00 00 00       	mov    $0x0,%edi
  801dbb:	48 b8 14 49 80 00 00 	movabs $0x804914,%rax
  801dc2:	00 00 00 
  801dc5:	ff d0                	callq  *%rax
  801dc7:	89 45 e8             	mov    %eax,-0x18(%rbp)
  801dca:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  801dce:	79 08                	jns    801dd8 <openfile_alloc+0xa2>
				return r;
  801dd0:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801dd3:	e9 8b 01 00 00       	jmpq   801f63 <openfile_alloc+0x22d>
#ifdef VMM_GUEST
			opentab[i].o_fileid += MAXOPEN;
  801dd8:	48 b8 40 a0 80 00 00 	movabs $0x80a040,%rax
  801ddf:	00 00 00 
  801de2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801de5:	48 63 d2             	movslq %edx,%rdx
  801de8:	48 c1 e2 05          	shl    $0x5,%rdx
  801dec:	48 01 d0             	add    %rdx,%rax
  801def:	8b 00                	mov    (%rax),%eax
  801df1:	8d 90 00 04 00 00    	lea    0x400(%rax),%edx
  801df7:	48 b8 40 a0 80 00 00 	movabs $0x80a040,%rax
  801dfe:	00 00 00 
  801e01:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  801e04:	48 63 c9             	movslq %ecx,%rcx
  801e07:	48 c1 e1 05          	shl    $0x5,%rcx
  801e0b:	48 01 c8             	add    %rcx,%rax
  801e0e:	89 10                	mov    %edx,(%rax)
			*o = &opentab[i];
  801e10:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e13:	48 98                	cltq   
  801e15:	48 c1 e0 05          	shl    $0x5,%rax
  801e19:	48 89 c2             	mov    %rax,%rdx
  801e1c:	48 b8 40 a0 80 00 00 	movabs $0x80a040,%rax
  801e23:	00 00 00 
  801e26:	48 01 c2             	add    %rax,%rdx
  801e29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e2d:	48 89 10             	mov    %rdx,(%rax)
			memset(opentab[i].o_fd, 0, PGSIZE);
  801e30:	48 b8 40 a0 80 00 00 	movabs $0x80a040,%rax
  801e37:	00 00 00 
  801e3a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e3d:	48 63 d2             	movslq %edx,%rdx
  801e40:	48 c1 e2 05          	shl    $0x5,%rdx
  801e44:	48 01 d0             	add    %rdx,%rax
  801e47:	48 83 c0 10          	add    $0x10,%rax
  801e4b:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e4f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801e54:	be 00 00 00 00       	mov    $0x0,%esi
  801e59:	48 89 c7             	mov    %rax,%rdi
  801e5c:	48 b8 80 42 80 00 00 	movabs $0x804280,%rax
  801e63:	00 00 00 
  801e66:	ff d0                	callq  *%rax
			return (*o)->o_fileid;
  801e68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e6c:	48 8b 00             	mov    (%rax),%rax
  801e6f:	8b 00                	mov    (%rax),%eax
  801e71:	e9 ed 00 00 00       	jmpq   801f63 <openfile_alloc+0x22d>
#else
			/* fall through */
#endif // VMM_GUEST
		case 1:
#ifdef VMM_GUEST
			if ((uint64_t) opentab[i].o_fd != get_host_fd()) {
  801e76:	48 b8 40 a0 80 00 00 	movabs $0x80a040,%rax
  801e7d:	00 00 00 
  801e80:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e83:	48 63 d2             	movslq %edx,%rdx
  801e86:	48 c1 e2 05          	shl    $0x5,%rdx
  801e8a:	48 01 d0             	add    %rdx,%rax
  801e8d:	48 83 c0 10          	add    $0x10,%rax
  801e91:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e95:	48 89 c3             	mov    %rax,%rbx
  801e98:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9d:	48 ba 60 2e 80 00 00 	movabs $0x802e60,%rdx
  801ea4:	00 00 00 
  801ea7:	ff d2                	callq  *%rdx
  801ea9:	48 39 c3             	cmp    %rax,%rbx
  801eac:	0f 84 9b 00 00 00    	je     801f4d <openfile_alloc+0x217>
#endif // VMM_GUEST

			opentab[i].o_fileid += MAXOPEN;
  801eb2:	48 b8 40 a0 80 00 00 	movabs $0x80a040,%rax
  801eb9:	00 00 00 
  801ebc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ebf:	48 63 d2             	movslq %edx,%rdx
  801ec2:	48 c1 e2 05          	shl    $0x5,%rdx
  801ec6:	48 01 d0             	add    %rdx,%rax
  801ec9:	8b 00                	mov    (%rax),%eax
  801ecb:	8d 90 00 04 00 00    	lea    0x400(%rax),%edx
  801ed1:	48 b8 40 a0 80 00 00 	movabs $0x80a040,%rax
  801ed8:	00 00 00 
  801edb:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  801ede:	48 63 c9             	movslq %ecx,%rcx
  801ee1:	48 c1 e1 05          	shl    $0x5,%rcx
  801ee5:	48 01 c8             	add    %rcx,%rax
  801ee8:	89 10                	mov    %edx,(%rax)
			*o = &opentab[i];
  801eea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801eed:	48 98                	cltq   
  801eef:	48 c1 e0 05          	shl    $0x5,%rax
  801ef3:	48 89 c2             	mov    %rax,%rdx
  801ef6:	48 b8 40 a0 80 00 00 	movabs $0x80a040,%rax
  801efd:	00 00 00 
  801f00:	48 01 c2             	add    %rax,%rdx
  801f03:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f07:	48 89 10             	mov    %rdx,(%rax)
			memset(opentab[i].o_fd, 0, PGSIZE);
  801f0a:	48 b8 40 a0 80 00 00 	movabs $0x80a040,%rax
  801f11:	00 00 00 
  801f14:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f17:	48 63 d2             	movslq %edx,%rdx
  801f1a:	48 c1 e2 05          	shl    $0x5,%rdx
  801f1e:	48 01 d0             	add    %rdx,%rax
  801f21:	48 83 c0 10          	add    $0x10,%rax
  801f25:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f29:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f2e:	be 00 00 00 00       	mov    $0x0,%esi
  801f33:	48 89 c7             	mov    %rax,%rdi
  801f36:	48 b8 80 42 80 00 00 	movabs $0x804280,%rax
  801f3d:	00 00 00 
  801f40:	ff d0                	callq  *%rax
			return (*o)->o_fileid;
  801f42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f46:	48 8b 00             	mov    (%rax),%rax
  801f49:	8b 00                	mov    (%rax),%eax
  801f4b:	eb 16                	jmp    801f63 <openfile_alloc+0x22d>
	for (i = 0; i < MAXOPEN; i++) {
  801f4d:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  801f51:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%rbp)
  801f58:	0f 8e f1 fd ff ff    	jle    801d4f <openfile_alloc+0x19>
#ifdef VMM_GUEST
		        }
#endif // VMM_GUEST
	         }
        }
	return -E_MAX_OPEN;
  801f5e:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801f63:	48 83 c4 28          	add    $0x28,%rsp
  801f67:	5b                   	pop    %rbx
  801f68:	5d                   	pop    %rbp
  801f69:	c3                   	retq   

0000000000801f6a <openfile_lookup>:

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  801f6a:	55                   	push   %rbp
  801f6b:	48 89 e5             	mov    %rsp,%rbp
  801f6e:	48 83 ec 20          	sub    $0x20,%rsp
  801f72:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f75:	89 75 e8             	mov    %esi,-0x18(%rbp)
  801f78:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  801f7c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801f7f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801f84:	89 c0                	mov    %eax,%eax
  801f86:	48 c1 e0 05          	shl    $0x5,%rax
  801f8a:	48 89 c2             	mov    %rax,%rdx
  801f8d:	48 b8 40 a0 80 00 00 	movabs $0x80a040,%rax
  801f94:	00 00 00 
  801f97:	48 01 d0             	add    %rdx,%rax
  801f9a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (pageref(o->o_fd) == 1 || o->o_fileid != fileid)
  801f9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fa2:	48 8b 40 18          	mov    0x18(%rax),%rax
  801fa6:	48 89 c7             	mov    %rax,%rdi
  801fa9:	48 b8 34 5d 80 00 00 	movabs $0x805d34,%rax
  801fb0:	00 00 00 
  801fb3:	ff d0                	callq  *%rax
  801fb5:	83 f8 01             	cmp    $0x1,%eax
  801fb8:	74 0b                	je     801fc5 <openfile_lookup+0x5b>
  801fba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fbe:	8b 00                	mov    (%rax),%eax
  801fc0:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  801fc3:	74 07                	je     801fcc <openfile_lookup+0x62>
		return -E_INVAL;
  801fc5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fca:	eb 10                	jmp    801fdc <openfile_lookup+0x72>
	*po = o;
  801fcc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fd0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801fd4:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801fd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fdc:	c9                   	leaveq 
  801fdd:	c3                   	retq   

0000000000801fde <serve_open>:
// permissions to return to the calling environment in *pg_store and
// *perm_store respectively.
int
serve_open(envid_t envid, struct Fsreq_open *req,
	   void **pg_store, int *perm_store)
{
  801fde:	55                   	push   %rbp
  801fdf:	48 89 e5             	mov    %rsp,%rbp
  801fe2:	48 81 ec 40 04 00 00 	sub    $0x440,%rsp
  801fe9:	89 bd dc fb ff ff    	mov    %edi,-0x424(%rbp)
  801fef:	48 89 b5 d0 fb ff ff 	mov    %rsi,-0x430(%rbp)
  801ff6:	48 89 95 c8 fb ff ff 	mov    %rdx,-0x438(%rbp)
  801ffd:	48 89 8d c0 fb ff ff 	mov    %rcx,-0x440(%rbp)

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, req->req_path, req->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  802004:	48 8b 8d d0 fb ff ff 	mov    -0x430(%rbp),%rcx
  80200b:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  802012:	ba 00 04 00 00       	mov    $0x400,%edx
  802017:	48 89 ce             	mov    %rcx,%rsi
  80201a:	48 89 c7             	mov    %rax,%rdi
  80201d:	48 b8 0b 43 80 00 00 	movabs $0x80430b,%rax
  802024:	00 00 00 
  802027:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  802029:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  80202d:	48 8d 85 e0 fb ff ff 	lea    -0x420(%rbp),%rax
  802034:	48 89 c7             	mov    %rax,%rdi
  802037:	48 b8 36 1d 80 00 00 	movabs $0x801d36,%rax
  80203e:	00 00 00 
  802041:	ff d0                	callq  *%rax
  802043:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802046:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80204a:	79 08                	jns    802054 <serve_open+0x76>
		if (debug)
			cprintf("openfile_alloc failed: %e", r);
		return r;
  80204c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80204f:	e9 7c 01 00 00       	jmpq   8021d0 <serve_open+0x1f2>
	}
	fileid = r;
  802054:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802057:	89 45 f8             	mov    %eax,-0x8(%rbp)

	// Open the file
	if (req->req_omode & O_CREAT) {
  80205a:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  802061:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  802067:	25 00 01 00 00       	and    $0x100,%eax
  80206c:	85 c0                	test   %eax,%eax
  80206e:	74 4f                	je     8020bf <serve_open+0xe1>
		if ((r = file_create(path, &f)) < 0) {
  802070:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  802077:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  80207e:	48 89 d6             	mov    %rdx,%rsi
  802081:	48 89 c7             	mov    %rax,%rdi
  802084:	48 b8 90 15 80 00 00 	movabs $0x801590,%rax
  80208b:	00 00 00 
  80208e:	ff d0                	callq  *%rax
  802090:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802093:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802097:	79 57                	jns    8020f0 <serve_open+0x112>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  802099:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  8020a0:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  8020a6:	25 00 04 00 00       	and    $0x400,%eax
  8020ab:	85 c0                	test   %eax,%eax
  8020ad:	75 08                	jne    8020b7 <serve_open+0xd9>
  8020af:	83 7d fc f2          	cmpl   $0xfffffff2,-0x4(%rbp)
  8020b3:	75 02                	jne    8020b7 <serve_open+0xd9>
				goto try_open;
  8020b5:	eb 08                	jmp    8020bf <serve_open+0xe1>
			if (debug)
				cprintf("file_create failed: %e", r);
			return r;
  8020b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ba:	e9 11 01 00 00       	jmpq   8021d0 <serve_open+0x1f2>
		}
	} else {
try_open:
		if ((r = file_open(path, &f)) < 0) {
  8020bf:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  8020c6:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  8020cd:	48 89 d6             	mov    %rdx,%rsi
  8020d0:	48 89 c7             	mov    %rax,%rdi
  8020d3:	48 b8 7d 16 80 00 00 	movabs $0x80167d,%rax
  8020da:	00 00 00 
  8020dd:	ff d0                	callq  *%rax
  8020df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020e6:	79 08                	jns    8020f0 <serve_open+0x112>
			if (debug)
				cprintf("file_open failed: %e", r);
			return r;
  8020e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020eb:	e9 e0 00 00 00       	jmpq   8021d0 <serve_open+0x1f2>
		}
	}

	// Truncate
	if (req->req_omode & O_TRUNC) {
  8020f0:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  8020f7:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  8020fd:	25 00 02 00 00       	and    $0x200,%eax
  802102:	85 c0                	test   %eax,%eax
  802104:	74 2c                	je     802132 <serve_open+0x154>
		if ((r = file_set_size(f, 0)) < 0) {
  802106:	48 8b 85 e8 fb ff ff 	mov    -0x418(%rbp),%rax
  80210d:	be 00 00 00 00       	mov    $0x0,%esi
  802112:	48 89 c7             	mov    %rax,%rdi
  802115:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  80211c:	00 00 00 
  80211f:	ff d0                	callq  *%rax
  802121:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802124:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802128:	79 08                	jns    802132 <serve_open+0x154>
			if (debug)
				cprintf("file_set_size failed: %e", r);
			return r;
  80212a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80212d:	e9 9e 00 00 00       	jmpq   8021d0 <serve_open+0x1f2>
		}
	}

	// Save the file pointer
	o->o_file = f;
  802132:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802139:	48 8b 95 e8 fb ff ff 	mov    -0x418(%rbp),%rdx
  802140:	48 89 50 08          	mov    %rdx,0x8(%rax)

	// Fill out the Fd structure
	o->o_fd->fd_file.id = o->o_fileid;
  802144:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  80214b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80214f:	48 8b 95 e0 fb ff ff 	mov    -0x420(%rbp),%rdx
  802156:	8b 12                	mov    (%rdx),%edx
  802158:	89 50 0c             	mov    %edx,0xc(%rax)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  80215b:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802162:	48 8b 40 18          	mov    0x18(%rax),%rax
  802166:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  80216d:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  802173:	83 e2 03             	and    $0x3,%edx
  802176:	89 50 08             	mov    %edx,0x8(%rax)
	o->o_fd->fd_dev_id = devfile.dev_id;
  802179:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802180:	48 8b 40 18          	mov    0x18(%rax),%rax
  802184:	48 ba 20 21 81 00 00 	movabs $0x812120,%rdx
  80218b:	00 00 00 
  80218e:	8b 12                	mov    (%rdx),%edx
  802190:	89 10                	mov    %edx,(%rax)
	o->o_mode = req->req_omode;
  802192:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802199:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  8021a0:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  8021a6:	89 50 10             	mov    %edx,0x10(%rax)
	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);

	// Share the FD page with the caller by setting *pg_store,
	// store its permission in *perm_store
	*pg_store = o->o_fd;
  8021a9:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8021b0:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8021b4:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  8021bb:	48 89 10             	mov    %rdx,(%rax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  8021be:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  8021c5:	c7 00 07 04 00 00    	movl   $0x407,(%rax)

	return 0;
  8021cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d0:	c9                   	leaveq 
  8021d1:	c3                   	retq   

00000000008021d2 <serve_set_size>:

// Set the size of req->req_fileid to req->req_size bytes, truncating
// or extending the file as necessary.
int
serve_set_size(envid_t envid, struct Fsreq_set_size *req)
{
  8021d2:	55                   	push   %rbp
  8021d3:	48 89 e5             	mov    %rsp,%rbp
  8021d6:	48 83 ec 20          	sub    $0x20,%rsp
  8021da:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// Every file system IPC call has the same general structure.
	// Here's how it goes.

	// First, use openfile_lookup to find the relevant open file.
	// On failure, return the error code to the client with ipc_send.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8021e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021e5:	8b 00                	mov    (%rax),%eax
  8021e7:	89 c1                	mov    %eax,%ecx
  8021e9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021f0:	89 ce                	mov    %ecx,%esi
  8021f2:	89 c7                	mov    %eax,%edi
  8021f4:	48 b8 6a 1f 80 00 00 	movabs $0x801f6a,%rax
  8021fb:	00 00 00 
  8021fe:	ff d0                	callq  *%rax
  802200:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802203:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802207:	79 05                	jns    80220e <serve_set_size+0x3c>
		return r;
  802209:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80220c:	eb 20                	jmp    80222e <serve_set_size+0x5c>

	// Second, call the relevant file system function (from fs/fs.c).
	// On failure, return the error code to the client.
	return file_set_size(o->o_file, req->req_size);
  80220e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802212:	8b 50 04             	mov    0x4(%rax),%edx
  802215:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802219:	48 8b 40 08          	mov    0x8(%rax),%rax
  80221d:	89 d6                	mov    %edx,%esi
  80221f:	48 89 c7             	mov    %rax,%rdi
  802222:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  802229:	00 00 00 
  80222c:	ff d0                	callq  *%rax
}
  80222e:	c9                   	leaveq 
  80222f:	c3                   	retq   

0000000000802230 <serve_read>:
// in ipc->read.req_fileid.  Return the bytes read from the file to
// the caller in ipc->readRet, then update the seek position.  Returns
// the number of bytes successfully read, or < 0 on error.
int
serve_read(envid_t envid, union Fsipc *ipc)
{
  802230:	55                   	push   %rbp
  802231:	48 89 e5             	mov    %rsp,%rbp
  802234:	48 83 ec 20          	sub    $0x20,%rsp
  802238:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80223b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fsreq_read *req = &ipc->read;
  80223f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802243:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct Fsret_read *ret = &ipc->readRet;
  802247:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80224b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	// (remember that read is always allowed to return fewer bytes
	// than requested).  Also, be careful because ipc is a union,
	// so filling in ret will overwrite req.
	//
	// LAB 5: Your code here
	panic("serve_read not implemented");
  80224f:	48 ba f8 71 80 00 00 	movabs $0x8071f8,%rdx
  802256:	00 00 00 
  802259:	be ea 00 00 00       	mov    $0xea,%esi
  80225e:	48 bf 13 72 80 00 00 	movabs $0x807213,%rdi
  802265:	00 00 00 
  802268:	b8 00 00 00 00       	mov    $0x0,%eax
  80226d:	48 b9 14 32 80 00 00 	movabs $0x803214,%rcx
  802274:	00 00 00 
  802277:	ff d1                	callq  *%rcx

0000000000802279 <serve_write>:
// the current seek position, and update the seek position
// accordingly.  Extend the file if necessary.  Returns the number of
// bytes written, or < 0 on error.
int
serve_write(envid_t envid, struct Fsreq_write *req)
{
  802279:	55                   	push   %rbp
  80227a:	48 89 e5             	mov    %rsp,%rbp
  80227d:	48 83 ec 10          	sub    $0x10,%rsp
  802281:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802284:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	if (debug)
		cprintf("serve_write %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	// LAB 5: Your code here.
	panic("serve_write not implemented");
  802288:	48 ba 1d 72 80 00 00 	movabs $0x80721d,%rdx
  80228f:	00 00 00 
  802292:	be f9 00 00 00       	mov    $0xf9,%esi
  802297:	48 bf 13 72 80 00 00 	movabs $0x807213,%rdi
  80229e:	00 00 00 
  8022a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a6:	48 b9 14 32 80 00 00 	movabs $0x803214,%rcx
  8022ad:	00 00 00 
  8022b0:	ff d1                	callq  *%rcx

00000000008022b2 <serve_stat>:

// Stat ipc->stat.req_fileid.  Return the file's struct Stat to the
// caller in ipc->statRet.
int
serve_stat(envid_t envid, union Fsipc *ipc)
{
  8022b2:	55                   	push   %rbp
  8022b3:	48 89 e5             	mov    %rsp,%rbp
  8022b6:	48 83 ec 30          	sub    $0x30,%rsp
  8022ba:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022bd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	struct Fsreq_stat *req = &ipc->stat;
  8022c1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8022c5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct Fsret_stat *ret = &ipc->statRet;
  8022c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8022cd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int r;

	if (debug)
		cprintf("serve_stat %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8022d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022d5:	8b 00                	mov    (%rax),%eax
  8022d7:	89 c1                	mov    %eax,%ecx
  8022d9:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  8022dd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022e0:	89 ce                	mov    %ecx,%esi
  8022e2:	89 c7                	mov    %eax,%edi
  8022e4:	48 b8 6a 1f 80 00 00 	movabs $0x801f6a,%rax
  8022eb:	00 00 00 
  8022ee:	ff d0                	callq  *%rax
  8022f0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8022f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8022f7:	79 05                	jns    8022fe <serve_stat+0x4c>
		return r;
  8022f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022fc:	eb 5f                	jmp    80235d <serve_stat+0xab>

	strcpy(ret->ret_name, o->o_file->f_name);
  8022fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802302:	48 8b 40 08          	mov    0x8(%rax),%rax
  802306:	48 89 c2             	mov    %rax,%rdx
  802309:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80230d:	48 89 d6             	mov    %rdx,%rsi
  802310:	48 89 c7             	mov    %rax,%rdi
  802313:	48 b8 e7 3f 80 00 00 	movabs $0x803fe7,%rax
  80231a:	00 00 00 
  80231d:	ff d0                	callq  *%rax
	ret->ret_size = o->o_file->f_size;
  80231f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802323:	48 8b 40 08          	mov    0x8(%rax),%rax
  802327:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80232d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802331:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  802337:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80233b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80233f:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  802345:	83 f8 01             	cmp    $0x1,%eax
  802348:	0f 94 c0             	sete   %al
  80234b:	0f b6 d0             	movzbl %al,%edx
  80234e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802352:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802358:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80235d:	c9                   	leaveq 
  80235e:	c3                   	retq   

000000000080235f <serve_flush>:

// Flush all data and metadata of req->req_fileid to disk.
int
serve_flush(envid_t envid, struct Fsreq_flush *req)
{
  80235f:	55                   	push   %rbp
  802360:	48 89 e5             	mov    %rsp,%rbp
  802363:	48 83 ec 20          	sub    $0x20,%rsp
  802367:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80236a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	if (debug)
		cprintf("serve_flush %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80236e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802372:	8b 00                	mov    (%rax),%eax
  802374:	89 c1                	mov    %eax,%ecx
  802376:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80237a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80237d:	89 ce                	mov    %ecx,%esi
  80237f:	89 c7                	mov    %eax,%edi
  802381:	48 b8 6a 1f 80 00 00 	movabs $0x801f6a,%rax
  802388:	00 00 00 
  80238b:	ff d0                	callq  *%rax
  80238d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802390:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802394:	79 05                	jns    80239b <serve_flush+0x3c>
		return r;
  802396:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802399:	eb 1c                	jmp    8023b7 <serve_flush+0x58>
	file_flush(o->o_file);
  80239b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80239f:	48 8b 40 08          	mov    0x8(%rax),%rax
  8023a3:	48 89 c7             	mov    %rax,%rdi
  8023a6:	48 b8 09 1b 80 00 00 	movabs $0x801b09,%rax
  8023ad:	00 00 00 
  8023b0:	ff d0                	callq  *%rax
	return 0;
  8023b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023b7:	c9                   	leaveq 
  8023b8:	c3                   	retq   

00000000008023b9 <serve_remove>:

// Remove the file req->req_path.
int
serve_remove(envid_t envid, struct Fsreq_remove *req)
{
  8023b9:	55                   	push   %rbp
  8023ba:	48 89 e5             	mov    %rsp,%rbp
  8023bd:	48 81 ec 10 04 00 00 	sub    $0x410,%rsp
  8023c4:	89 bd fc fb ff ff    	mov    %edi,-0x404(%rbp)
  8023ca:	48 89 b5 f0 fb ff ff 	mov    %rsi,-0x410(%rbp)

	// Delete the named file.
	// Note: This request doesn't refer to an open file.

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  8023d1:	48 8b 8d f0 fb ff ff 	mov    -0x410(%rbp),%rcx
  8023d8:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  8023df:	ba 00 04 00 00       	mov    $0x400,%edx
  8023e4:	48 89 ce             	mov    %rcx,%rsi
  8023e7:	48 89 c7             	mov    %rax,%rdi
  8023ea:	48 b8 0b 43 80 00 00 	movabs $0x80430b,%rax
  8023f1:	00 00 00 
  8023f4:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  8023f6:	c6 45 ff 00          	movb   $0x0,-0x1(%rbp)

	// Delete the specified file
	return file_remove(path);
  8023fa:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  802401:	48 89 c7             	mov    %rax,%rdi
  802404:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  80240b:	00 00 00 
  80240e:	ff d0                	callq  *%rax
}
  802410:	c9                   	leaveq 
  802411:	c3                   	retq   

0000000000802412 <serve_sync>:

// Sync the file system.
int
serve_sync(envid_t envid, union Fsipc *req)
{
  802412:	55                   	push   %rbp
  802413:	48 89 e5             	mov    %rsp,%rbp
  802416:	48 83 ec 10          	sub    $0x10,%rsp
  80241a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80241d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	fs_sync();
  802421:	48 b8 75 1c 80 00 00 	movabs $0x801c75,%rax
  802428:	00 00 00 
  80242b:	ff d0                	callq  *%rax
	return 0;
  80242d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802432:	c9                   	leaveq 
  802433:	c3                   	retq   

0000000000802434 <serve>:
};
#define NHANDLERS (sizeof(handlers)/sizeof(handlers[0]))

void
serve(void)
{
  802434:	55                   	push   %rbp
  802435:	48 89 e5             	mov    %rsp,%rbp
  802438:	48 83 ec 20          	sub    $0x20,%rsp
	uint32_t req, whom;
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
  80243c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  802443:	48 b8 40 20 81 00 00 	movabs $0x812040,%rax
  80244a:	00 00 00 
  80244d:	48 8b 08             	mov    (%rax),%rcx
  802450:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802454:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
  802458:	48 89 ce             	mov    %rcx,%rsi
  80245b:	48 89 c7             	mov    %rax,%rdi
  80245e:	48 b8 d7 4c 80 00 00 	movabs $0x804cd7,%rax
  802465:	00 00 00 
  802468:	ff d0                	callq  *%rax
  80246a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (debug)
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  80246d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802470:	83 e0 01             	and    $0x1,%eax
  802473:	85 c0                	test   %eax,%eax
  802475:	75 25                	jne    80249c <serve+0x68>
			cprintf("Invalid request from %08x: no argument page\n",
  802477:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80247a:	89 c6                	mov    %eax,%esi
  80247c:	48 bf 40 72 80 00 00 	movabs $0x807240,%rdi
  802483:	00 00 00 
  802486:	b8 00 00 00 00       	mov    $0x0,%eax
  80248b:	48 ba 4d 34 80 00 00 	movabs $0x80344d,%rdx
  802492:	00 00 00 
  802495:	ff d2                	callq  *%rdx
				whom);
			continue; // just leave it hanging...
  802497:	e9 ed 00 00 00       	jmpq   802589 <serve+0x155>
		}

		pg = NULL;
  80249c:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8024a3:	00 
		if (req == FSREQ_OPEN) {
  8024a4:	83 7d f8 01          	cmpl   $0x1,-0x8(%rbp)
  8024a8:	75 2e                	jne    8024d8 <serve+0xa4>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  8024aa:	48 b8 40 20 81 00 00 	movabs $0x812040,%rax
  8024b1:	00 00 00 
  8024b4:	48 8b 00             	mov    (%rax),%rax
  8024b7:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8024ba:	89 d7                	mov    %edx,%edi
  8024bc:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  8024c0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024c4:	48 89 c6             	mov    %rax,%rsi
  8024c7:	48 b8 de 1f 80 00 00 	movabs $0x801fde,%rax
  8024ce:	00 00 00 
  8024d1:	ff d0                	callq  *%rax
  8024d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024d6:	eb 73                	jmp    80254b <serve+0x117>
		} else if (req < NHANDLERS && handlers[req]) {
  8024d8:	83 7d f8 08          	cmpl   $0x8,-0x8(%rbp)
  8024dc:	77 43                	ja     802521 <serve+0xed>
  8024de:	48 b8 80 20 81 00 00 	movabs $0x812080,%rax
  8024e5:	00 00 00 
  8024e8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8024eb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024ef:	48 85 c0             	test   %rax,%rax
  8024f2:	74 2d                	je     802521 <serve+0xed>
			r = handlers[req](whom, fsreq);
  8024f4:	48 b8 80 20 81 00 00 	movabs $0x812080,%rax
  8024fb:	00 00 00 
  8024fe:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802501:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802505:	48 ba 40 20 81 00 00 	movabs $0x812040,%rdx
  80250c:	00 00 00 
  80250f:	48 8b 12             	mov    (%rdx),%rdx
  802512:	8b 4d f4             	mov    -0xc(%rbp),%ecx
  802515:	48 89 d6             	mov    %rdx,%rsi
  802518:	89 cf                	mov    %ecx,%edi
  80251a:	ff d0                	callq  *%rax
  80251c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80251f:	eb 2a                	jmp    80254b <serve+0x117>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  802521:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802524:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802527:	89 c6                	mov    %eax,%esi
  802529:	48 bf 70 72 80 00 00 	movabs $0x807270,%rdi
  802530:	00 00 00 
  802533:	b8 00 00 00 00       	mov    $0x0,%eax
  802538:	48 b9 4d 34 80 00 00 	movabs $0x80344d,%rcx
  80253f:	00 00 00 
  802542:	ff d1                	callq  *%rcx
			r = -E_INVAL;
  802544:	c7 45 fc fd ff ff ff 	movl   $0xfffffffd,-0x4(%rbp)
		}
		ipc_send(whom, r, pg, perm);
  80254b:	8b 4d f0             	mov    -0x10(%rbp),%ecx
  80254e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802552:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802555:	8b 75 f4             	mov    -0xc(%rbp),%esi
  802558:	89 f7                	mov    %esi,%edi
  80255a:	89 c6                	mov    %eax,%esi
  80255c:	48 b8 15 4d 80 00 00 	movabs $0x804d15,%rax
  802563:	00 00 00 
  802566:	ff d0                	callq  *%rax
		if(debug)
			cprintf("FS: Sent response %d to %x\n", r, whom);
		sys_page_unmap(0, fsreq);
  802568:	48 b8 40 20 81 00 00 	movabs $0x812040,%rax
  80256f:	00 00 00 
  802572:	48 8b 00             	mov    (%rax),%rax
  802575:	48 89 c6             	mov    %rax,%rsi
  802578:	bf 00 00 00 00       	mov    $0x0,%edi
  80257d:	48 b8 c6 49 80 00 00 	movabs $0x8049c6,%rax
  802584:	00 00 00 
  802587:	ff d0                	callq  *%rax
	}
  802589:	e9 ae fe ff ff       	jmpq   80243c <serve+0x8>

000000000080258e <umain>:
}

void
umain(int argc, char **argv)
{
  80258e:	55                   	push   %rbp
  80258f:	48 89 e5             	mov    %rsp,%rbp
  802592:	48 83 ec 20          	sub    $0x20,%rsp
  802596:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802599:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  80259d:	48 b8 d0 20 81 00 00 	movabs $0x8120d0,%rax
  8025a4:	00 00 00 
  8025a7:	48 b9 93 72 80 00 00 	movabs $0x807293,%rcx
  8025ae:	00 00 00 
  8025b1:	48 89 08             	mov    %rcx,(%rax)
	cprintf("FS is running\n");
  8025b4:	48 bf 96 72 80 00 00 	movabs $0x807296,%rdi
  8025bb:	00 00 00 
  8025be:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c3:	48 ba 4d 34 80 00 00 	movabs $0x80344d,%rdx
  8025ca:	00 00 00 
  8025cd:	ff d2                	callq  *%rdx
  8025cf:	c7 45 fc 00 8a 00 00 	movl   $0x8a00,-0x4(%rbp)
  8025d6:	66 c7 45 fa 00 8a    	movw   $0x8a00,-0x6(%rbp)
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  8025dc:	0f b7 45 fa          	movzwl -0x6(%rbp),%eax
  8025e0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025e3:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  8025e5:	48 bf a5 72 80 00 00 	movabs $0x8072a5,%rdi
  8025ec:	00 00 00 
  8025ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f4:	48 ba 4d 34 80 00 00 	movabs $0x80344d,%rdx
  8025fb:	00 00 00 
  8025fe:	ff d2                	callq  *%rdx

	serve_init();
  802600:	48 b8 c6 1c 80 00 00 	movabs $0x801cc6,%rax
  802607:	00 00 00 
  80260a:	ff d0                	callq  *%rax
	fs_init();
  80260c:	48 b8 8d 0f 80 00 00 	movabs $0x800f8d,%rax
  802613:	00 00 00 
  802616:	ff d0                	callq  *%rax
	serve();
  802618:	48 b8 34 24 80 00 00 	movabs $0x802434,%rax
  80261f:	00 00 00 
  802622:	ff d0                	callq  *%rax
}
  802624:	c9                   	leaveq 
  802625:	c3                   	retq   

0000000000802626 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  802626:	55                   	push   %rbp
  802627:	48 89 e5             	mov    %rsp,%rbp
  80262a:	48 83 ec 20          	sub    $0x20,%rsp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  80262e:	ba 07 00 00 00       	mov    $0x7,%edx
  802633:	be 00 10 00 00       	mov    $0x1000,%esi
  802638:	bf 00 00 00 00       	mov    $0x0,%edi
  80263d:	48 b8 14 49 80 00 00 	movabs $0x804914,%rax
  802644:	00 00 00 
  802647:	ff d0                	callq  *%rax
  802649:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80264c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802650:	79 30                	jns    802682 <fs_test+0x5c>
		panic("sys_page_alloc: %e", r);
  802652:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802655:	89 c1                	mov    %eax,%ecx
  802657:	48 ba de 72 80 00 00 	movabs $0x8072de,%rdx
  80265e:	00 00 00 
  802661:	be 13 00 00 00       	mov    $0x13,%esi
  802666:	48 bf f1 72 80 00 00 	movabs $0x8072f1,%rdi
  80266d:	00 00 00 
  802670:	b8 00 00 00 00       	mov    $0x0,%eax
  802675:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  80267c:	00 00 00 
  80267f:	41 ff d0             	callq  *%r8
	bits = (uint32_t*) PGSIZE;
  802682:	48 c7 45 f0 00 10 00 	movq   $0x1000,-0x10(%rbp)
  802689:	00 
	memmove(bits, bitmap, PGSIZE);
  80268a:	48 b8 10 50 81 00 00 	movabs $0x815010,%rax
  802691:	00 00 00 
  802694:	48 8b 08             	mov    (%rax),%rcx
  802697:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80269b:	ba 00 10 00 00       	mov    $0x1000,%edx
  8026a0:	48 89 ce             	mov    %rcx,%rsi
  8026a3:	48 89 c7             	mov    %rax,%rdi
  8026a6:	48 b8 0b 43 80 00 00 	movabs $0x80430b,%rax
  8026ad:	00 00 00 
  8026b0:	ff d0                	callq  *%rax
	// allocate block
	if ((r = alloc_block()) < 0)
  8026b2:	48 b8 30 0e 80 00 00 	movabs $0x800e30,%rax
  8026b9:	00 00 00 
  8026bc:	ff d0                	callq  *%rax
  8026be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c5:	79 30                	jns    8026f7 <fs_test+0xd1>
		panic("alloc_block: %e", r);
  8026c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ca:	89 c1                	mov    %eax,%ecx
  8026cc:	48 ba fb 72 80 00 00 	movabs $0x8072fb,%rdx
  8026d3:	00 00 00 
  8026d6:	be 18 00 00 00       	mov    $0x18,%esi
  8026db:	48 bf f1 72 80 00 00 	movabs $0x8072f1,%rdi
  8026e2:	00 00 00 
  8026e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ea:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  8026f1:	00 00 00 
  8026f4:	41 ff d0             	callq  *%r8
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  8026f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026fa:	8d 50 1f             	lea    0x1f(%rax),%edx
  8026fd:	85 c0                	test   %eax,%eax
  8026ff:	0f 48 c2             	cmovs  %edx,%eax
  802702:	c1 f8 05             	sar    $0x5,%eax
  802705:	48 98                	cltq   
  802707:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  80270e:	00 
  80270f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802713:	48 01 d0             	add    %rdx,%rax
  802716:	8b 30                	mov    (%rax),%esi
  802718:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80271b:	99                   	cltd   
  80271c:	c1 ea 1b             	shr    $0x1b,%edx
  80271f:	01 d0                	add    %edx,%eax
  802721:	83 e0 1f             	and    $0x1f,%eax
  802724:	29 d0                	sub    %edx,%eax
  802726:	ba 01 00 00 00       	mov    $0x1,%edx
  80272b:	89 c1                	mov    %eax,%ecx
  80272d:	d3 e2                	shl    %cl,%edx
  80272f:	89 d0                	mov    %edx,%eax
  802731:	21 f0                	and    %esi,%eax
  802733:	85 c0                	test   %eax,%eax
  802735:	75 35                	jne    80276c <fs_test+0x146>
  802737:	48 b9 0b 73 80 00 00 	movabs $0x80730b,%rcx
  80273e:	00 00 00 
  802741:	48 ba 26 73 80 00 00 	movabs $0x807326,%rdx
  802748:	00 00 00 
  80274b:	be 1a 00 00 00       	mov    $0x1a,%esi
  802750:	48 bf f1 72 80 00 00 	movabs $0x8072f1,%rdi
  802757:	00 00 00 
  80275a:	b8 00 00 00 00       	mov    $0x0,%eax
  80275f:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  802766:	00 00 00 
  802769:	41 ff d0             	callq  *%r8
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  80276c:	48 b8 10 50 81 00 00 	movabs $0x815010,%rax
  802773:	00 00 00 
  802776:	48 8b 10             	mov    (%rax),%rdx
  802779:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80277c:	8d 48 1f             	lea    0x1f(%rax),%ecx
  80277f:	85 c0                	test   %eax,%eax
  802781:	0f 48 c1             	cmovs  %ecx,%eax
  802784:	c1 f8 05             	sar    $0x5,%eax
  802787:	48 98                	cltq   
  802789:	48 c1 e0 02          	shl    $0x2,%rax
  80278d:	48 01 d0             	add    %rdx,%rax
  802790:	8b 30                	mov    (%rax),%esi
  802792:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802795:	99                   	cltd   
  802796:	c1 ea 1b             	shr    $0x1b,%edx
  802799:	01 d0                	add    %edx,%eax
  80279b:	83 e0 1f             	and    $0x1f,%eax
  80279e:	29 d0                	sub    %edx,%eax
  8027a0:	ba 01 00 00 00       	mov    $0x1,%edx
  8027a5:	89 c1                	mov    %eax,%ecx
  8027a7:	d3 e2                	shl    %cl,%edx
  8027a9:	89 d0                	mov    %edx,%eax
  8027ab:	21 f0                	and    %esi,%eax
  8027ad:	85 c0                	test   %eax,%eax
  8027af:	74 35                	je     8027e6 <fs_test+0x1c0>
  8027b1:	48 b9 40 73 80 00 00 	movabs $0x807340,%rcx
  8027b8:	00 00 00 
  8027bb:	48 ba 26 73 80 00 00 	movabs $0x807326,%rdx
  8027c2:	00 00 00 
  8027c5:	be 1c 00 00 00       	mov    $0x1c,%esi
  8027ca:	48 bf f1 72 80 00 00 	movabs $0x8072f1,%rdi
  8027d1:	00 00 00 
  8027d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d9:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  8027e0:	00 00 00 
  8027e3:	41 ff d0             	callq  *%r8
	cprintf("alloc_block is good\n");
  8027e6:	48 bf 60 73 80 00 00 	movabs $0x807360,%rdi
  8027ed:	00 00 00 
  8027f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f5:	48 ba 4d 34 80 00 00 	movabs $0x80344d,%rdx
  8027fc:	00 00 00 
  8027ff:	ff d2                	callq  *%rdx

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  802801:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802805:	48 89 c6             	mov    %rax,%rsi
  802808:	48 bf 75 73 80 00 00 	movabs $0x807375,%rdi
  80280f:	00 00 00 
  802812:	48 b8 7d 16 80 00 00 	movabs $0x80167d,%rax
  802819:	00 00 00 
  80281c:	ff d0                	callq  *%rax
  80281e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802821:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802825:	79 36                	jns    80285d <fs_test+0x237>
  802827:	83 7d fc f4          	cmpl   $0xfffffff4,-0x4(%rbp)
  80282b:	74 30                	je     80285d <fs_test+0x237>
		panic("file_open /not-found: %e", r);
  80282d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802830:	89 c1                	mov    %eax,%ecx
  802832:	48 ba 80 73 80 00 00 	movabs $0x807380,%rdx
  802839:	00 00 00 
  80283c:	be 20 00 00 00       	mov    $0x20,%esi
  802841:	48 bf f1 72 80 00 00 	movabs $0x8072f1,%rdi
  802848:	00 00 00 
  80284b:	b8 00 00 00 00       	mov    $0x0,%eax
  802850:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  802857:	00 00 00 
  80285a:	41 ff d0             	callq  *%r8
	else if (r == 0)
  80285d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802861:	75 2a                	jne    80288d <fs_test+0x267>
		panic("file_open /not-found succeeded!");
  802863:	48 ba a0 73 80 00 00 	movabs $0x8073a0,%rdx
  80286a:	00 00 00 
  80286d:	be 22 00 00 00       	mov    $0x22,%esi
  802872:	48 bf f1 72 80 00 00 	movabs $0x8072f1,%rdi
  802879:	00 00 00 
  80287c:	b8 00 00 00 00       	mov    $0x0,%eax
  802881:	48 b9 14 32 80 00 00 	movabs $0x803214,%rcx
  802888:	00 00 00 
  80288b:	ff d1                	callq  *%rcx
	if ((r = file_open("/newmotd", &f)) < 0)
  80288d:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802891:	48 89 c6             	mov    %rax,%rsi
  802894:	48 bf c0 73 80 00 00 	movabs $0x8073c0,%rdi
  80289b:	00 00 00 
  80289e:	48 b8 7d 16 80 00 00 	movabs $0x80167d,%rax
  8028a5:	00 00 00 
  8028a8:	ff d0                	callq  *%rax
  8028aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b1:	79 30                	jns    8028e3 <fs_test+0x2bd>
		panic("file_open /newmotd: %e", r);
  8028b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028b6:	89 c1                	mov    %eax,%ecx
  8028b8:	48 ba c9 73 80 00 00 	movabs $0x8073c9,%rdx
  8028bf:	00 00 00 
  8028c2:	be 24 00 00 00       	mov    $0x24,%esi
  8028c7:	48 bf f1 72 80 00 00 	movabs $0x8072f1,%rdi
  8028ce:	00 00 00 
  8028d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d6:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  8028dd:	00 00 00 
  8028e0:	41 ff d0             	callq  *%r8
	cprintf("file_open is good\n");
  8028e3:	48 bf e0 73 80 00 00 	movabs $0x8073e0,%rdi
  8028ea:	00 00 00 
  8028ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f2:	48 ba 4d 34 80 00 00 	movabs $0x80344d,%rdx
  8028f9:	00 00 00 
  8028fc:	ff d2                	callq  *%rdx

	if ((r = file_get_block(f, 0, &blk)) < 0)
  8028fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802902:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802906:	be 00 00 00 00       	mov    $0x0,%esi
  80290b:	48 89 c7             	mov    %rax,%rdi
  80290e:	48 b8 4c 10 80 00 00 	movabs $0x80104c,%rax
  802915:	00 00 00 
  802918:	ff d0                	callq  *%rax
  80291a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80291d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802921:	79 30                	jns    802953 <fs_test+0x32d>
		panic("file_get_block: %e", r);
  802923:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802926:	89 c1                	mov    %eax,%ecx
  802928:	48 ba f3 73 80 00 00 	movabs $0x8073f3,%rdx
  80292f:	00 00 00 
  802932:	be 28 00 00 00       	mov    $0x28,%esi
  802937:	48 bf f1 72 80 00 00 	movabs $0x8072f1,%rdi
  80293e:	00 00 00 
  802941:	b8 00 00 00 00       	mov    $0x0,%eax
  802946:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  80294d:	00 00 00 
  802950:	41 ff d0             	callq  *%r8
	if (strcmp(blk, msg) != 0)
  802953:	48 b8 c8 20 81 00 00 	movabs $0x8120c8,%rax
  80295a:	00 00 00 
  80295d:	48 8b 10             	mov    (%rax),%rdx
  802960:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802964:	48 89 d6             	mov    %rdx,%rsi
  802967:	48 89 c7             	mov    %rax,%rdi
  80296a:	48 b8 49 41 80 00 00 	movabs $0x804149,%rax
  802971:	00 00 00 
  802974:	ff d0                	callq  *%rax
  802976:	85 c0                	test   %eax,%eax
  802978:	74 2a                	je     8029a4 <fs_test+0x37e>
		panic("file_get_block returned wrong data");
  80297a:	48 ba 08 74 80 00 00 	movabs $0x807408,%rdx
  802981:	00 00 00 
  802984:	be 2a 00 00 00       	mov    $0x2a,%esi
  802989:	48 bf f1 72 80 00 00 	movabs $0x8072f1,%rdi
  802990:	00 00 00 
  802993:	b8 00 00 00 00       	mov    $0x0,%eax
  802998:	48 b9 14 32 80 00 00 	movabs $0x803214,%rcx
  80299f:	00 00 00 
  8029a2:	ff d1                	callq  *%rcx
	cprintf("file_get_block is good\n");
  8029a4:	48 bf 2b 74 80 00 00 	movabs $0x80742b,%rdi
  8029ab:	00 00 00 
  8029ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b3:	48 ba 4d 34 80 00 00 	movabs $0x80344d,%rdx
  8029ba:	00 00 00 
  8029bd:	ff d2                	callq  *%rdx

	*(volatile char*)blk = *(volatile char*)blk;
  8029bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029c3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8029c7:	0f b6 12             	movzbl (%rdx),%edx
  8029ca:	88 10                	mov    %dl,(%rax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  8029cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029d0:	48 c1 e8 0c          	shr    $0xc,%rax
  8029d4:	48 89 c2             	mov    %rax,%rdx
  8029d7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029de:	01 00 00 
  8029e1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029e5:	83 e0 40             	and    $0x40,%eax
  8029e8:	48 85 c0             	test   %rax,%rax
  8029eb:	75 35                	jne    802a22 <fs_test+0x3fc>
  8029ed:	48 b9 43 74 80 00 00 	movabs $0x807443,%rcx
  8029f4:	00 00 00 
  8029f7:	48 ba 26 73 80 00 00 	movabs $0x807326,%rdx
  8029fe:	00 00 00 
  802a01:	be 2e 00 00 00       	mov    $0x2e,%esi
  802a06:	48 bf f1 72 80 00 00 	movabs $0x8072f1,%rdi
  802a0d:	00 00 00 
  802a10:	b8 00 00 00 00       	mov    $0x0,%eax
  802a15:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  802a1c:	00 00 00 
  802a1f:	41 ff d0             	callq  *%r8
	file_flush(f);
  802a22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a26:	48 89 c7             	mov    %rax,%rdi
  802a29:	48 b8 09 1b 80 00 00 	movabs $0x801b09,%rax
  802a30:	00 00 00 
  802a33:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  802a35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a39:	48 c1 e8 0c          	shr    $0xc,%rax
  802a3d:	48 89 c2             	mov    %rax,%rdx
  802a40:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a47:	01 00 00 
  802a4a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a4e:	83 e0 40             	and    $0x40,%eax
  802a51:	48 85 c0             	test   %rax,%rax
  802a54:	74 35                	je     802a8b <fs_test+0x465>
  802a56:	48 b9 5e 74 80 00 00 	movabs $0x80745e,%rcx
  802a5d:	00 00 00 
  802a60:	48 ba 26 73 80 00 00 	movabs $0x807326,%rdx
  802a67:	00 00 00 
  802a6a:	be 30 00 00 00       	mov    $0x30,%esi
  802a6f:	48 bf f1 72 80 00 00 	movabs $0x8072f1,%rdi
  802a76:	00 00 00 
  802a79:	b8 00 00 00 00       	mov    $0x0,%eax
  802a7e:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  802a85:	00 00 00 
  802a88:	41 ff d0             	callq  *%r8
	cprintf("file_flush is good\n");
  802a8b:	48 bf 7a 74 80 00 00 	movabs $0x80747a,%rdi
  802a92:	00 00 00 
  802a95:	b8 00 00 00 00       	mov    $0x0,%eax
  802a9a:	48 ba 4d 34 80 00 00 	movabs $0x80344d,%rdx
  802aa1:	00 00 00 
  802aa4:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, 0)) < 0)
  802aa6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aaa:	be 00 00 00 00       	mov    $0x0,%esi
  802aaf:	48 89 c7             	mov    %rax,%rdi
  802ab2:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  802ab9:	00 00 00 
  802abc:	ff d0                	callq  *%rax
  802abe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ac1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ac5:	79 30                	jns    802af7 <fs_test+0x4d1>
		panic("file_set_size: %e", r);
  802ac7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aca:	89 c1                	mov    %eax,%ecx
  802acc:	48 ba 8e 74 80 00 00 	movabs $0x80748e,%rdx
  802ad3:	00 00 00 
  802ad6:	be 34 00 00 00       	mov    $0x34,%esi
  802adb:	48 bf f1 72 80 00 00 	movabs $0x8072f1,%rdi
  802ae2:	00 00 00 
  802ae5:	b8 00 00 00 00       	mov    $0x0,%eax
  802aea:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  802af1:	00 00 00 
  802af4:	41 ff d0             	callq  *%r8
	assert(f->f_direct[0] == 0);
  802af7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802afb:	8b 80 88 00 00 00    	mov    0x88(%rax),%eax
  802b01:	85 c0                	test   %eax,%eax
  802b03:	74 35                	je     802b3a <fs_test+0x514>
  802b05:	48 b9 a0 74 80 00 00 	movabs $0x8074a0,%rcx
  802b0c:	00 00 00 
  802b0f:	48 ba 26 73 80 00 00 	movabs $0x807326,%rdx
  802b16:	00 00 00 
  802b19:	be 35 00 00 00       	mov    $0x35,%esi
  802b1e:	48 bf f1 72 80 00 00 	movabs $0x8072f1,%rdi
  802b25:	00 00 00 
  802b28:	b8 00 00 00 00       	mov    $0x0,%eax
  802b2d:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  802b34:	00 00 00 
  802b37:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  802b3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b3e:	48 c1 e8 0c          	shr    $0xc,%rax
  802b42:	48 89 c2             	mov    %rax,%rdx
  802b45:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b4c:	01 00 00 
  802b4f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b53:	83 e0 40             	and    $0x40,%eax
  802b56:	48 85 c0             	test   %rax,%rax
  802b59:	74 35                	je     802b90 <fs_test+0x56a>
  802b5b:	48 b9 b4 74 80 00 00 	movabs $0x8074b4,%rcx
  802b62:	00 00 00 
  802b65:	48 ba 26 73 80 00 00 	movabs $0x807326,%rdx
  802b6c:	00 00 00 
  802b6f:	be 36 00 00 00       	mov    $0x36,%esi
  802b74:	48 bf f1 72 80 00 00 	movabs $0x8072f1,%rdi
  802b7b:	00 00 00 
  802b7e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b83:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  802b8a:	00 00 00 
  802b8d:	41 ff d0             	callq  *%r8
	cprintf("file_truncate is good\n");
  802b90:	48 bf ce 74 80 00 00 	movabs $0x8074ce,%rdi
  802b97:	00 00 00 
  802b9a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b9f:	48 ba 4d 34 80 00 00 	movabs $0x80344d,%rdx
  802ba6:	00 00 00 
  802ba9:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, strlen(msg))) < 0)
  802bab:	48 b8 c8 20 81 00 00 	movabs $0x8120c8,%rax
  802bb2:	00 00 00 
  802bb5:	48 8b 00             	mov    (%rax),%rax
  802bb8:	48 89 c7             	mov    %rax,%rdi
  802bbb:	48 b8 7b 3f 80 00 00 	movabs $0x803f7b,%rax
  802bc2:	00 00 00 
  802bc5:	ff d0                	callq  *%rax
  802bc7:	89 c2                	mov    %eax,%edx
  802bc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bcd:	89 d6                	mov    %edx,%esi
  802bcf:	48 89 c7             	mov    %rax,%rdi
  802bd2:	48 b8 ac 1a 80 00 00 	movabs $0x801aac,%rax
  802bd9:	00 00 00 
  802bdc:	ff d0                	callq  *%rax
  802bde:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802be1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802be5:	79 30                	jns    802c17 <fs_test+0x5f1>
		panic("file_set_size 2: %e", r);
  802be7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bea:	89 c1                	mov    %eax,%ecx
  802bec:	48 ba e5 74 80 00 00 	movabs $0x8074e5,%rdx
  802bf3:	00 00 00 
  802bf6:	be 3a 00 00 00       	mov    $0x3a,%esi
  802bfb:	48 bf f1 72 80 00 00 	movabs $0x8072f1,%rdi
  802c02:	00 00 00 
  802c05:	b8 00 00 00 00       	mov    $0x0,%eax
  802c0a:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  802c11:	00 00 00 
  802c14:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  802c17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c1b:	48 c1 e8 0c          	shr    $0xc,%rax
  802c1f:	48 89 c2             	mov    %rax,%rdx
  802c22:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c29:	01 00 00 
  802c2c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c30:	83 e0 40             	and    $0x40,%eax
  802c33:	48 85 c0             	test   %rax,%rax
  802c36:	74 35                	je     802c6d <fs_test+0x647>
  802c38:	48 b9 b4 74 80 00 00 	movabs $0x8074b4,%rcx
  802c3f:	00 00 00 
  802c42:	48 ba 26 73 80 00 00 	movabs $0x807326,%rdx
  802c49:	00 00 00 
  802c4c:	be 3b 00 00 00       	mov    $0x3b,%esi
  802c51:	48 bf f1 72 80 00 00 	movabs $0x8072f1,%rdi
  802c58:	00 00 00 
  802c5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c60:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  802c67:	00 00 00 
  802c6a:	41 ff d0             	callq  *%r8
	if ((r = file_get_block(f, 0, &blk)) < 0)
  802c6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c71:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802c75:	be 00 00 00 00       	mov    $0x0,%esi
  802c7a:	48 89 c7             	mov    %rax,%rdi
  802c7d:	48 b8 4c 10 80 00 00 	movabs $0x80104c,%rax
  802c84:	00 00 00 
  802c87:	ff d0                	callq  *%rax
  802c89:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c90:	79 30                	jns    802cc2 <fs_test+0x69c>
		panic("file_get_block 2: %e", r);
  802c92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c95:	89 c1                	mov    %eax,%ecx
  802c97:	48 ba f9 74 80 00 00 	movabs $0x8074f9,%rdx
  802c9e:	00 00 00 
  802ca1:	be 3d 00 00 00       	mov    $0x3d,%esi
  802ca6:	48 bf f1 72 80 00 00 	movabs $0x8072f1,%rdi
  802cad:	00 00 00 
  802cb0:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb5:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  802cbc:	00 00 00 
  802cbf:	41 ff d0             	callq  *%r8
	strcpy(blk, msg);
  802cc2:	48 b8 c8 20 81 00 00 	movabs $0x8120c8,%rax
  802cc9:	00 00 00 
  802ccc:	48 8b 10             	mov    (%rax),%rdx
  802ccf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cd3:	48 89 d6             	mov    %rdx,%rsi
  802cd6:	48 89 c7             	mov    %rax,%rdi
  802cd9:	48 b8 e7 3f 80 00 00 	movabs $0x803fe7,%rax
  802ce0:	00 00 00 
  802ce3:	ff d0                	callq  *%rax
	assert((uvpt[PGNUM(blk)] & PTE_D));
  802ce5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ce9:	48 c1 e8 0c          	shr    $0xc,%rax
  802ced:	48 89 c2             	mov    %rax,%rdx
  802cf0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802cf7:	01 00 00 
  802cfa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cfe:	83 e0 40             	and    $0x40,%eax
  802d01:	48 85 c0             	test   %rax,%rax
  802d04:	75 35                	jne    802d3b <fs_test+0x715>
  802d06:	48 b9 43 74 80 00 00 	movabs $0x807443,%rcx
  802d0d:	00 00 00 
  802d10:	48 ba 26 73 80 00 00 	movabs $0x807326,%rdx
  802d17:	00 00 00 
  802d1a:	be 3f 00 00 00       	mov    $0x3f,%esi
  802d1f:	48 bf f1 72 80 00 00 	movabs $0x8072f1,%rdi
  802d26:	00 00 00 
  802d29:	b8 00 00 00 00       	mov    $0x0,%eax
  802d2e:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  802d35:	00 00 00 
  802d38:	41 ff d0             	callq  *%r8
	file_flush(f);
  802d3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d3f:	48 89 c7             	mov    %rax,%rdi
  802d42:	48 b8 09 1b 80 00 00 	movabs $0x801b09,%rax
  802d49:	00 00 00 
  802d4c:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  802d4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d52:	48 c1 e8 0c          	shr    $0xc,%rax
  802d56:	48 89 c2             	mov    %rax,%rdx
  802d59:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d60:	01 00 00 
  802d63:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d67:	83 e0 40             	and    $0x40,%eax
  802d6a:	48 85 c0             	test   %rax,%rax
  802d6d:	74 35                	je     802da4 <fs_test+0x77e>
  802d6f:	48 b9 5e 74 80 00 00 	movabs $0x80745e,%rcx
  802d76:	00 00 00 
  802d79:	48 ba 26 73 80 00 00 	movabs $0x807326,%rdx
  802d80:	00 00 00 
  802d83:	be 41 00 00 00       	mov    $0x41,%esi
  802d88:	48 bf f1 72 80 00 00 	movabs $0x8072f1,%rdi
  802d8f:	00 00 00 
  802d92:	b8 00 00 00 00       	mov    $0x0,%eax
  802d97:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  802d9e:	00 00 00 
  802da1:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  802da4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802da8:	48 c1 e8 0c          	shr    $0xc,%rax
  802dac:	48 89 c2             	mov    %rax,%rdx
  802daf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802db6:	01 00 00 
  802db9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802dbd:	83 e0 40             	and    $0x40,%eax
  802dc0:	48 85 c0             	test   %rax,%rax
  802dc3:	74 35                	je     802dfa <fs_test+0x7d4>
  802dc5:	48 b9 b4 74 80 00 00 	movabs $0x8074b4,%rcx
  802dcc:	00 00 00 
  802dcf:	48 ba 26 73 80 00 00 	movabs $0x807326,%rdx
  802dd6:	00 00 00 
  802dd9:	be 42 00 00 00       	mov    $0x42,%esi
  802dde:	48 bf f1 72 80 00 00 	movabs $0x8072f1,%rdi
  802de5:	00 00 00 
  802de8:	b8 00 00 00 00       	mov    $0x0,%eax
  802ded:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  802df4:	00 00 00 
  802df7:	41 ff d0             	callq  *%r8
	cprintf("file rewrite is good\n");
  802dfa:	48 bf 0e 75 80 00 00 	movabs $0x80750e,%rdi
  802e01:	00 00 00 
  802e04:	b8 00 00 00 00       	mov    $0x0,%eax
  802e09:	48 ba 4d 34 80 00 00 	movabs $0x80344d,%rdx
  802e10:	00 00 00 
  802e13:	ff d2                	callq  *%rdx
}
  802e15:	c9                   	leaveq 
  802e16:	c3                   	retq   

0000000000802e17 <host_fsipc>:
static struct Fd *host_fd;
static union Fsipc host_fsipcbuf __attribute__((aligned(PGSIZE)));

static int
host_fsipc(unsigned type, void *dstva)
{
  802e17:	55                   	push   %rbp
  802e18:	48 89 e5             	mov    %rsp,%rbp
  802e1b:	48 83 ec 10          	sub    $0x10,%rsp
  802e1f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e22:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	ipc_host_send(VMX_HOST_FS_ENV, type, &host_fsipcbuf, PTE_P | PTE_W | PTE_U);
  802e26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e29:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e2e:	48 ba 00 40 81 00 00 	movabs $0x814000,%rdx
  802e35:	00 00 00 
  802e38:	89 c6                	mov    %eax,%esi
  802e3a:	bf 01 00 00 00       	mov    $0x1,%edi
  802e3f:	48 b8 12 4e 80 00 00 	movabs $0x804e12,%rax
  802e46:	00 00 00 
  802e49:	ff d0                	callq  *%rax
	return ipc_host_recv(dstva);
  802e4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e4f:	48 89 c7             	mov    %rax,%rdi
  802e52:	48 b8 54 4d 80 00 00 	movabs $0x804d54,%rax
  802e59:	00 00 00 
  802e5c:	ff d0                	callq  *%rax
}
  802e5e:	c9                   	leaveq 
  802e5f:	c3                   	retq   

0000000000802e60 <get_host_fd>:


uint64_t
get_host_fd()
{
  802e60:	55                   	push   %rbp
  802e61:	48 89 e5             	mov    %rsp,%rbp
	return (uint64_t) host_fd;
  802e64:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  802e6b:	00 00 00 
  802e6e:	48 8b 00             	mov    (%rax),%rax
}
  802e71:	5d                   	pop    %rbp
  802e72:	c3                   	retq   

0000000000802e73 <host_read>:

int
host_read(uint32_t secno, void *dst, size_t nsecs)
{
  802e73:	55                   	push   %rbp
  802e74:	48 89 e5             	mov    %rsp,%rbp
  802e77:	48 83 ec 30          	sub    $0x30,%rsp
  802e7b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e7e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e82:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r, read = 0;
  802e86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	if(host_fd->fd_file.id == 0) {
  802e8d:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  802e94:	00 00 00 
  802e97:	48 8b 00             	mov    (%rax),%rax
  802e9a:	8b 40 0c             	mov    0xc(%rax),%eax
  802e9d:	85 c0                	test   %eax,%eax
  802e9f:	75 11                	jne    802eb2 <host_read+0x3f>
		host_ipc_init();
  802ea1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ea6:	48 ba 60 30 80 00 00 	movabs $0x803060,%rdx
  802ead:	00 00 00 
  802eb0:	ff d2                	callq  *%rdx
	}

	host_fd->fd_offset = secno * SECTSIZE;
  802eb2:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  802eb9:	00 00 00 
  802ebc:	48 8b 00             	mov    (%rax),%rax
  802ebf:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ec2:	c1 e2 09             	shl    $0x9,%edx
  802ec5:	89 50 04             	mov    %edx,0x4(%rax)
	// read from the host, 2 sectors at a time.
	for(; nsecs > 0; nsecs-=2) {
  802ec8:	e9 8c 00 00 00       	jmpq   802f59 <host_read+0xe6>

		host_fsipcbuf.read.req_fileid = host_fd->fd_file.id;
  802ecd:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  802ed4:	00 00 00 
  802ed7:	48 8b 00             	mov    (%rax),%rax
  802eda:	8b 50 0c             	mov    0xc(%rax),%edx
  802edd:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  802ee4:	00 00 00 
  802ee7:	89 10                	mov    %edx,(%rax)
		host_fsipcbuf.read.req_n = SECTSIZE * 2;
  802ee9:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  802ef0:	00 00 00 
  802ef3:	48 c7 40 08 00 04 00 	movq   $0x400,0x8(%rax)
  802efa:	00 
		if ((r = host_fsipc(FSREQ_READ, NULL)) < 0)
  802efb:	be 00 00 00 00       	mov    $0x0,%esi
  802f00:	bf 03 00 00 00       	mov    $0x3,%edi
  802f05:	48 b8 17 2e 80 00 00 	movabs $0x802e17,%rax
  802f0c:	00 00 00 
  802f0f:	ff d0                	callq  *%rax
  802f11:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802f14:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f18:	79 05                	jns    802f1f <host_read+0xac>
			return r;
  802f1a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f1d:	eb 4a                	jmp    802f69 <host_read+0xf6>
		// FIXME: Handle case where r < SECTSIZE * 2;
		memmove(dst+read, &host_fsipcbuf, r);
  802f1f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f22:	48 98                	cltq   
  802f24:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f27:	48 63 ca             	movslq %edx,%rcx
  802f2a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802f2e:	48 01 d1             	add    %rdx,%rcx
  802f31:	48 89 c2             	mov    %rax,%rdx
  802f34:	48 be 00 40 81 00 00 	movabs $0x814000,%rsi
  802f3b:	00 00 00 
  802f3e:	48 89 cf             	mov    %rcx,%rdi
  802f41:	48 b8 0b 43 80 00 00 	movabs $0x80430b,%rax
  802f48:	00 00 00 
  802f4b:	ff d0                	callq  *%rax
		read += SECTSIZE * 2;
  802f4d:	81 45 fc 00 04 00 00 	addl   $0x400,-0x4(%rbp)
	for(; nsecs > 0; nsecs-=2) {
  802f54:	48 83 6d d8 02       	subq   $0x2,-0x28(%rbp)
  802f59:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802f5e:	0f 85 69 ff ff ff    	jne    802ecd <host_read+0x5a>
	}

	return 0;
  802f64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f69:	c9                   	leaveq 
  802f6a:	c3                   	retq   

0000000000802f6b <host_write>:

int
host_write(uint32_t secno, const void *src, size_t nsecs)
{
  802f6b:	55                   	push   %rbp
  802f6c:	48 89 e5             	mov    %rsp,%rbp
  802f6f:	48 83 ec 30          	sub    $0x30,%rsp
  802f73:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f76:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f7a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r, written = 0;
  802f7e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	if(host_fd->fd_file.id == 0) {
  802f85:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  802f8c:	00 00 00 
  802f8f:	48 8b 00             	mov    (%rax),%rax
  802f92:	8b 40 0c             	mov    0xc(%rax),%eax
  802f95:	85 c0                	test   %eax,%eax
  802f97:	75 11                	jne    802faa <host_write+0x3f>
		host_ipc_init();
  802f99:	b8 00 00 00 00       	mov    $0x0,%eax
  802f9e:	48 ba 60 30 80 00 00 	movabs $0x803060,%rdx
  802fa5:	00 00 00 
  802fa8:	ff d2                	callq  *%rdx
	}

	host_fd->fd_offset = secno * SECTSIZE;
  802faa:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  802fb1:	00 00 00 
  802fb4:	48 8b 00             	mov    (%rax),%rax
  802fb7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802fba:	c1 e2 09             	shl    $0x9,%edx
  802fbd:	89 50 04             	mov    %edx,0x4(%rax)
	for(; nsecs > 0; nsecs-=2) {
  802fc0:	e9 89 00 00 00       	jmpq   80304e <host_write+0xe3>
		host_fsipcbuf.write.req_fileid = host_fd->fd_file.id;
  802fc5:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  802fcc:	00 00 00 
  802fcf:	48 8b 00             	mov    (%rax),%rax
  802fd2:	8b 50 0c             	mov    0xc(%rax),%edx
  802fd5:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  802fdc:	00 00 00 
  802fdf:	89 10                	mov    %edx,(%rax)
		host_fsipcbuf.write.req_n = SECTSIZE * 2;
  802fe1:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  802fe8:	00 00 00 
  802feb:	48 c7 40 08 00 04 00 	movq   $0x400,0x8(%rax)
  802ff2:	00 
		memmove(host_fsipcbuf.write.req_buf, src+written, SECTSIZE * 2);
  802ff3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff6:	48 63 d0             	movslq %eax,%rdx
  802ff9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ffd:	48 01 d0             	add    %rdx,%rax
  803000:	ba 00 04 00 00       	mov    $0x400,%edx
  803005:	48 89 c6             	mov    %rax,%rsi
  803008:	48 bf 10 40 81 00 00 	movabs $0x814010,%rdi
  80300f:	00 00 00 
  803012:	48 b8 0b 43 80 00 00 	movabs $0x80430b,%rax
  803019:	00 00 00 
  80301c:	ff d0                	callq  *%rax
		if ((r = host_fsipc(FSREQ_WRITE, NULL)) < 0)
  80301e:	be 00 00 00 00       	mov    $0x0,%esi
  803023:	bf 04 00 00 00       	mov    $0x4,%edi
  803028:	48 b8 17 2e 80 00 00 	movabs $0x802e17,%rax
  80302f:	00 00 00 
  803032:	ff d0                	callq  *%rax
  803034:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803037:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80303b:	79 05                	jns    803042 <host_write+0xd7>
			return r;
  80303d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803040:	eb 1c                	jmp    80305e <host_write+0xf3>
		written += SECTSIZE * 2;
  803042:	81 45 fc 00 04 00 00 	addl   $0x400,-0x4(%rbp)
	for(; nsecs > 0; nsecs-=2) {
  803049:	48 83 6d d8 02       	subq   $0x2,-0x28(%rbp)
  80304e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803053:	0f 85 6c ff ff ff    	jne    802fc5 <host_write+0x5a>
	}
	return 0;
  803059:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80305e:	c9                   	leaveq 
  80305f:	c3                   	retq   

0000000000803060 <host_ipc_init>:

void
host_ipc_init()
{
  803060:	55                   	push   %rbp
  803061:	48 89 e5             	mov    %rsp,%rbp
  803064:	48 83 ec 40          	sub    $0x40,%rsp
	int r;
	int vmdisk_number;
	char path_string[50];
	if ((r = fd_alloc(&host_fd)) < 0)
  803068:	48 bf 00 30 81 00 00 	movabs $0x813000,%rdi
  80306f:	00 00 00 
  803072:	48 b8 62 4f 80 00 00 	movabs $0x804f62,%rax
  803079:	00 00 00 
  80307c:	ff d0                	callq  *%rax
  80307e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803081:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803085:	79 2a                	jns    8030b1 <host_ipc_init+0x51>
		panic("Couldn't allocate an fd!");
  803087:	48 ba 24 75 80 00 00 	movabs $0x807524,%rdx
  80308e:	00 00 00 
  803091:	be 52 00 00 00       	mov    $0x52,%esi
  803096:	48 bf 3d 75 80 00 00 	movabs $0x80753d,%rdi
  80309d:	00 00 00 
  8030a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a5:	48 b9 14 32 80 00 00 	movabs $0x803214,%rcx
  8030ac:	00 00 00 
  8030af:	ff d1                	callq  *%rcx
	asm("vmcall":"=a"(vmdisk_number): "0"(VMX_VMCALL_GETDISKIMGNUM));
  8030b1:	b8 06 00 00 00       	mov    $0x6,%eax
  8030b6:	0f 01 c1             	vmcall 
  8030b9:	89 45 f8             	mov    %eax,-0x8(%rbp)
	snprintf(path_string, 50, "/vmm/fs%d.img", vmdisk_number);
  8030bc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8030bf:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  8030c3:	89 d1                	mov    %edx,%ecx
  8030c5:	48 ba 4b 75 80 00 00 	movabs $0x80754b,%rdx
  8030cc:	00 00 00 
  8030cf:	be 32 00 00 00       	mov    $0x32,%esi
  8030d4:	48 89 c7             	mov    %rax,%rdi
  8030d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8030dc:	49 b8 9a 3e 80 00 00 	movabs $0x803e9a,%r8
  8030e3:	00 00 00 
  8030e6:	41 ff d0             	callq  *%r8
	strcpy(host_fsipcbuf.open.req_path, path_string);
  8030e9:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  8030ed:	48 89 c6             	mov    %rax,%rsi
  8030f0:	48 bf 00 40 81 00 00 	movabs $0x814000,%rdi
  8030f7:	00 00 00 
  8030fa:	48 b8 e7 3f 80 00 00 	movabs $0x803fe7,%rax
  803101:	00 00 00 
  803104:	ff d0                	callq  *%rax
	host_fsipcbuf.open.req_omode = O_RDWR;
  803106:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  80310d:	00 00 00 
  803110:	c7 80 00 04 00 00 02 	movl   $0x2,0x400(%rax)
  803117:	00 00 00 

	if ((r = host_fsipc(FSREQ_OPEN, host_fd)) < 0) {
  80311a:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  803121:	00 00 00 
  803124:	48 8b 00             	mov    (%rax),%rax
  803127:	48 89 c6             	mov    %rax,%rsi
  80312a:	bf 01 00 00 00       	mov    $0x1,%edi
  80312f:	48 b8 17 2e 80 00 00 	movabs $0x802e17,%rax
  803136:	00 00 00 
  803139:	ff d0                	callq  *%rax
  80313b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80313e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803142:	79 4b                	jns    80318f <host_ipc_init+0x12f>
		fd_close(host_fd, 0);
  803144:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  80314b:	00 00 00 
  80314e:	48 8b 00             	mov    (%rax),%rax
  803151:	be 00 00 00 00       	mov    $0x0,%esi
  803156:	48 89 c7             	mov    %rax,%rdi
  803159:	48 b8 8a 50 80 00 00 	movabs $0x80508a,%rax
  803160:	00 00 00 
  803163:	ff d0                	callq  *%rax
		panic("Couldn't open host file!");
  803165:	48 ba 59 75 80 00 00 	movabs $0x807559,%rdx
  80316c:	00 00 00 
  80316f:	be 5a 00 00 00       	mov    $0x5a,%esi
  803174:	48 bf 3d 75 80 00 00 	movabs $0x80753d,%rdi
  80317b:	00 00 00 
  80317e:	b8 00 00 00 00       	mov    $0x0,%eax
  803183:	48 b9 14 32 80 00 00 	movabs $0x803214,%rcx
  80318a:	00 00 00 
  80318d:	ff d1                	callq  *%rcx
	}

}
  80318f:	c9                   	leaveq 
  803190:	c3                   	retq   

0000000000803191 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  803191:	55                   	push   %rbp
  803192:	48 89 e5             	mov    %rsp,%rbp
  803195:	48 83 ec 10          	sub    $0x10,%rsp
  803199:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80319c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8031a0:	48 b8 20 50 81 00 00 	movabs $0x815020,%rax
  8031a7:	00 00 00 
  8031aa:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8031b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031b5:	7e 14                	jle    8031cb <libmain+0x3a>
		binaryname = argv[0];
  8031b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031bb:	48 8b 10             	mov    (%rax),%rdx
  8031be:	48 b8 d0 20 81 00 00 	movabs $0x8120d0,%rax
  8031c5:	00 00 00 
  8031c8:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8031cb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8031cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d2:	48 89 d6             	mov    %rdx,%rsi
  8031d5:	89 c7                	mov    %eax,%edi
  8031d7:	48 b8 8e 25 80 00 00 	movabs $0x80258e,%rax
  8031de:	00 00 00 
  8031e1:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8031e3:	48 b8 f1 31 80 00 00 	movabs $0x8031f1,%rax
  8031ea:	00 00 00 
  8031ed:	ff d0                	callq  *%rax
}
  8031ef:	c9                   	leaveq 
  8031f0:	c3                   	retq   

00000000008031f1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8031f1:	55                   	push   %rbp
  8031f2:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8031f5:	48 b8 57 52 80 00 00 	movabs $0x805257,%rax
  8031fc:	00 00 00 
  8031ff:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  803201:	bf 00 00 00 00       	mov    $0x0,%edi
  803206:	48 b8 56 48 80 00 00 	movabs $0x804856,%rax
  80320d:	00 00 00 
  803210:	ff d0                	callq  *%rax
}
  803212:	5d                   	pop    %rbp
  803213:	c3                   	retq   

0000000000803214 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803214:	55                   	push   %rbp
  803215:	48 89 e5             	mov    %rsp,%rbp
  803218:	53                   	push   %rbx
  803219:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803220:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803227:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80322d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803234:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80323b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803242:	84 c0                	test   %al,%al
  803244:	74 23                	je     803269 <_panic+0x55>
  803246:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80324d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803251:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803255:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803259:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80325d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803261:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803265:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803269:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803270:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803277:	00 00 00 
  80327a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803281:	00 00 00 
  803284:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803288:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80328f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803296:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80329d:	48 b8 d0 20 81 00 00 	movabs $0x8120d0,%rax
  8032a4:	00 00 00 
  8032a7:	48 8b 18             	mov    (%rax),%rbx
  8032aa:	48 b8 9c 48 80 00 00 	movabs $0x80489c,%rax
  8032b1:	00 00 00 
  8032b4:	ff d0                	callq  *%rax
  8032b6:	89 c6                	mov    %eax,%esi
  8032b8:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8032be:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8032c5:	41 89 d0             	mov    %edx,%r8d
  8032c8:	48 89 c1             	mov    %rax,%rcx
  8032cb:	48 89 da             	mov    %rbx,%rdx
  8032ce:	48 bf 80 75 80 00 00 	movabs $0x807580,%rdi
  8032d5:	00 00 00 
  8032d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8032dd:	49 b9 4d 34 80 00 00 	movabs $0x80344d,%r9
  8032e4:	00 00 00 
  8032e7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8032ea:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8032f1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8032f8:	48 89 d6             	mov    %rdx,%rsi
  8032fb:	48 89 c7             	mov    %rax,%rdi
  8032fe:	48 b8 a1 33 80 00 00 	movabs $0x8033a1,%rax
  803305:	00 00 00 
  803308:	ff d0                	callq  *%rax
	cprintf("\n");
  80330a:	48 bf a3 75 80 00 00 	movabs $0x8075a3,%rdi
  803311:	00 00 00 
  803314:	b8 00 00 00 00       	mov    $0x0,%eax
  803319:	48 ba 4d 34 80 00 00 	movabs $0x80344d,%rdx
  803320:	00 00 00 
  803323:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803325:	cc                   	int3   
  803326:	eb fd                	jmp    803325 <_panic+0x111>

0000000000803328 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  803328:	55                   	push   %rbp
  803329:	48 89 e5             	mov    %rsp,%rbp
  80332c:	48 83 ec 10          	sub    $0x10,%rsp
  803330:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803333:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  803337:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80333b:	8b 00                	mov    (%rax),%eax
  80333d:	8d 48 01             	lea    0x1(%rax),%ecx
  803340:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803344:	89 0a                	mov    %ecx,(%rdx)
  803346:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803349:	89 d1                	mov    %edx,%ecx
  80334b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80334f:	48 98                	cltq   
  803351:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  803355:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803359:	8b 00                	mov    (%rax),%eax
  80335b:	3d ff 00 00 00       	cmp    $0xff,%eax
  803360:	75 2c                	jne    80338e <putch+0x66>
        sys_cputs(b->buf, b->idx);
  803362:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803366:	8b 00                	mov    (%rax),%eax
  803368:	48 98                	cltq   
  80336a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80336e:	48 83 c2 08          	add    $0x8,%rdx
  803372:	48 89 c6             	mov    %rax,%rsi
  803375:	48 89 d7             	mov    %rdx,%rdi
  803378:	48 b8 ce 47 80 00 00 	movabs $0x8047ce,%rax
  80337f:	00 00 00 
  803382:	ff d0                	callq  *%rax
        b->idx = 0;
  803384:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803388:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80338e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803392:	8b 40 04             	mov    0x4(%rax),%eax
  803395:	8d 50 01             	lea    0x1(%rax),%edx
  803398:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80339c:	89 50 04             	mov    %edx,0x4(%rax)
}
  80339f:	c9                   	leaveq 
  8033a0:	c3                   	retq   

00000000008033a1 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8033a1:	55                   	push   %rbp
  8033a2:	48 89 e5             	mov    %rsp,%rbp
  8033a5:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8033ac:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8033b3:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8033ba:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8033c1:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8033c8:	48 8b 0a             	mov    (%rdx),%rcx
  8033cb:	48 89 08             	mov    %rcx,(%rax)
  8033ce:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8033d2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8033d6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8033da:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8033de:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8033e5:	00 00 00 
    b.cnt = 0;
  8033e8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8033ef:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8033f2:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8033f9:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  803400:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803407:	48 89 c6             	mov    %rax,%rsi
  80340a:	48 bf 28 33 80 00 00 	movabs $0x803328,%rdi
  803411:	00 00 00 
  803414:	48 b8 ec 37 80 00 00 	movabs $0x8037ec,%rax
  80341b:	00 00 00 
  80341e:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  803420:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  803426:	48 98                	cltq   
  803428:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80342f:	48 83 c2 08          	add    $0x8,%rdx
  803433:	48 89 c6             	mov    %rax,%rsi
  803436:	48 89 d7             	mov    %rdx,%rdi
  803439:	48 b8 ce 47 80 00 00 	movabs $0x8047ce,%rax
  803440:	00 00 00 
  803443:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  803445:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80344b:	c9                   	leaveq 
  80344c:	c3                   	retq   

000000000080344d <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80344d:	55                   	push   %rbp
  80344e:	48 89 e5             	mov    %rsp,%rbp
  803451:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  803458:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80345f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803466:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80346d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803474:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80347b:	84 c0                	test   %al,%al
  80347d:	74 20                	je     80349f <cprintf+0x52>
  80347f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803483:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803487:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80348b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80348f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803493:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803497:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80349b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80349f:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8034a6:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8034ad:	00 00 00 
  8034b0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8034b7:	00 00 00 
  8034ba:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8034be:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8034c5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8034cc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8034d3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8034da:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8034e1:	48 8b 0a             	mov    (%rdx),%rcx
  8034e4:	48 89 08             	mov    %rcx,(%rax)
  8034e7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8034eb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8034ef:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8034f3:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8034f7:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8034fe:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803505:	48 89 d6             	mov    %rdx,%rsi
  803508:	48 89 c7             	mov    %rax,%rdi
  80350b:	48 b8 a1 33 80 00 00 	movabs $0x8033a1,%rax
  803512:	00 00 00 
  803515:	ff d0                	callq  *%rax
  803517:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80351d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803523:	c9                   	leaveq 
  803524:	c3                   	retq   

0000000000803525 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  803525:	55                   	push   %rbp
  803526:	48 89 e5             	mov    %rsp,%rbp
  803529:	48 83 ec 30          	sub    $0x30,%rsp
  80352d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803531:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803535:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  803539:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80353c:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  803540:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  803544:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803547:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80354b:	77 42                	ja     80358f <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80354d:	8b 45 e0             	mov    -0x20(%rbp),%eax
  803550:	8d 78 ff             	lea    -0x1(%rax),%edi
  803553:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  803556:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80355a:	ba 00 00 00 00       	mov    $0x0,%edx
  80355f:	48 f7 f6             	div    %rsi
  803562:	49 89 c2             	mov    %rax,%r10
  803565:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803568:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80356b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80356f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803573:	41 89 c9             	mov    %ecx,%r9d
  803576:	41 89 f8             	mov    %edi,%r8d
  803579:	89 d1                	mov    %edx,%ecx
  80357b:	4c 89 d2             	mov    %r10,%rdx
  80357e:	48 89 c7             	mov    %rax,%rdi
  803581:	48 b8 25 35 80 00 00 	movabs $0x803525,%rax
  803588:	00 00 00 
  80358b:	ff d0                	callq  *%rax
  80358d:	eb 1e                	jmp    8035ad <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80358f:	eb 12                	jmp    8035a3 <printnum+0x7e>
			putch(padc, putdat);
  803591:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803595:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803598:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80359c:	48 89 ce             	mov    %rcx,%rsi
  80359f:	89 d7                	mov    %edx,%edi
  8035a1:	ff d0                	callq  *%rax
		while (--width > 0)
  8035a3:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8035a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8035ab:	7f e4                	jg     803591 <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8035ad:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8035b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8035b9:	48 f7 f1             	div    %rcx
  8035bc:	48 b8 b0 77 80 00 00 	movabs $0x8077b0,%rax
  8035c3:	00 00 00 
  8035c6:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8035ca:	0f be d0             	movsbl %al,%edx
  8035cd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8035d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035d5:	48 89 ce             	mov    %rcx,%rsi
  8035d8:	89 d7                	mov    %edx,%edi
  8035da:	ff d0                	callq  *%rax
}
  8035dc:	c9                   	leaveq 
  8035dd:	c3                   	retq   

00000000008035de <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8035de:	55                   	push   %rbp
  8035df:	48 89 e5             	mov    %rsp,%rbp
  8035e2:	48 83 ec 20          	sub    $0x20,%rsp
  8035e6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035ea:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8035ed:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8035f1:	7e 4f                	jle    803642 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8035f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035f7:	8b 00                	mov    (%rax),%eax
  8035f9:	83 f8 30             	cmp    $0x30,%eax
  8035fc:	73 24                	jae    803622 <getuint+0x44>
  8035fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803602:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803606:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80360a:	8b 00                	mov    (%rax),%eax
  80360c:	89 c0                	mov    %eax,%eax
  80360e:	48 01 d0             	add    %rdx,%rax
  803611:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803615:	8b 12                	mov    (%rdx),%edx
  803617:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80361a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80361e:	89 0a                	mov    %ecx,(%rdx)
  803620:	eb 14                	jmp    803636 <getuint+0x58>
  803622:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803626:	48 8b 40 08          	mov    0x8(%rax),%rax
  80362a:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80362e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803632:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803636:	48 8b 00             	mov    (%rax),%rax
  803639:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80363d:	e9 9d 00 00 00       	jmpq   8036df <getuint+0x101>
	else if (lflag)
  803642:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803646:	74 4c                	je     803694 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  803648:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80364c:	8b 00                	mov    (%rax),%eax
  80364e:	83 f8 30             	cmp    $0x30,%eax
  803651:	73 24                	jae    803677 <getuint+0x99>
  803653:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803657:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80365b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80365f:	8b 00                	mov    (%rax),%eax
  803661:	89 c0                	mov    %eax,%eax
  803663:	48 01 d0             	add    %rdx,%rax
  803666:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80366a:	8b 12                	mov    (%rdx),%edx
  80366c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80366f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803673:	89 0a                	mov    %ecx,(%rdx)
  803675:	eb 14                	jmp    80368b <getuint+0xad>
  803677:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80367b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80367f:	48 8d 48 08          	lea    0x8(%rax),%rcx
  803683:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803687:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80368b:	48 8b 00             	mov    (%rax),%rax
  80368e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803692:	eb 4b                	jmp    8036df <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  803694:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803698:	8b 00                	mov    (%rax),%eax
  80369a:	83 f8 30             	cmp    $0x30,%eax
  80369d:	73 24                	jae    8036c3 <getuint+0xe5>
  80369f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036a3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8036a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036ab:	8b 00                	mov    (%rax),%eax
  8036ad:	89 c0                	mov    %eax,%eax
  8036af:	48 01 d0             	add    %rdx,%rax
  8036b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036b6:	8b 12                	mov    (%rdx),%edx
  8036b8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8036bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036bf:	89 0a                	mov    %ecx,(%rdx)
  8036c1:	eb 14                	jmp    8036d7 <getuint+0xf9>
  8036c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036c7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8036cb:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8036cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036d3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8036d7:	8b 00                	mov    (%rax),%eax
  8036d9:	89 c0                	mov    %eax,%eax
  8036db:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8036df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8036e3:	c9                   	leaveq 
  8036e4:	c3                   	retq   

00000000008036e5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8036e5:	55                   	push   %rbp
  8036e6:	48 89 e5             	mov    %rsp,%rbp
  8036e9:	48 83 ec 20          	sub    $0x20,%rsp
  8036ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036f1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8036f4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8036f8:	7e 4f                	jle    803749 <getint+0x64>
		x=va_arg(*ap, long long);
  8036fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036fe:	8b 00                	mov    (%rax),%eax
  803700:	83 f8 30             	cmp    $0x30,%eax
  803703:	73 24                	jae    803729 <getint+0x44>
  803705:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803709:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80370d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803711:	8b 00                	mov    (%rax),%eax
  803713:	89 c0                	mov    %eax,%eax
  803715:	48 01 d0             	add    %rdx,%rax
  803718:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80371c:	8b 12                	mov    (%rdx),%edx
  80371e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803721:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803725:	89 0a                	mov    %ecx,(%rdx)
  803727:	eb 14                	jmp    80373d <getint+0x58>
  803729:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80372d:	48 8b 40 08          	mov    0x8(%rax),%rax
  803731:	48 8d 48 08          	lea    0x8(%rax),%rcx
  803735:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803739:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80373d:	48 8b 00             	mov    (%rax),%rax
  803740:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803744:	e9 9d 00 00 00       	jmpq   8037e6 <getint+0x101>
	else if (lflag)
  803749:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80374d:	74 4c                	je     80379b <getint+0xb6>
		x=va_arg(*ap, long);
  80374f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803753:	8b 00                	mov    (%rax),%eax
  803755:	83 f8 30             	cmp    $0x30,%eax
  803758:	73 24                	jae    80377e <getint+0x99>
  80375a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80375e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803762:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803766:	8b 00                	mov    (%rax),%eax
  803768:	89 c0                	mov    %eax,%eax
  80376a:	48 01 d0             	add    %rdx,%rax
  80376d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803771:	8b 12                	mov    (%rdx),%edx
  803773:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803776:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80377a:	89 0a                	mov    %ecx,(%rdx)
  80377c:	eb 14                	jmp    803792 <getint+0xad>
  80377e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803782:	48 8b 40 08          	mov    0x8(%rax),%rax
  803786:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80378a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80378e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803792:	48 8b 00             	mov    (%rax),%rax
  803795:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803799:	eb 4b                	jmp    8037e6 <getint+0x101>
	else
		x=va_arg(*ap, int);
  80379b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80379f:	8b 00                	mov    (%rax),%eax
  8037a1:	83 f8 30             	cmp    $0x30,%eax
  8037a4:	73 24                	jae    8037ca <getint+0xe5>
  8037a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037aa:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8037ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037b2:	8b 00                	mov    (%rax),%eax
  8037b4:	89 c0                	mov    %eax,%eax
  8037b6:	48 01 d0             	add    %rdx,%rax
  8037b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8037bd:	8b 12                	mov    (%rdx),%edx
  8037bf:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8037c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8037c6:	89 0a                	mov    %ecx,(%rdx)
  8037c8:	eb 14                	jmp    8037de <getint+0xf9>
  8037ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037ce:	48 8b 40 08          	mov    0x8(%rax),%rax
  8037d2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8037d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8037da:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8037de:	8b 00                	mov    (%rax),%eax
  8037e0:	48 98                	cltq   
  8037e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8037e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8037ea:	c9                   	leaveq 
  8037eb:	c3                   	retq   

00000000008037ec <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8037ec:	55                   	push   %rbp
  8037ed:	48 89 e5             	mov    %rsp,%rbp
  8037f0:	41 54                	push   %r12
  8037f2:	53                   	push   %rbx
  8037f3:	48 83 ec 60          	sub    $0x60,%rsp
  8037f7:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8037fb:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8037ff:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803803:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  803807:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80380b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80380f:	48 8b 0a             	mov    (%rdx),%rcx
  803812:	48 89 08             	mov    %rcx,(%rax)
  803815:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803819:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80381d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803821:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803825:	eb 17                	jmp    80383e <vprintfmt+0x52>
			if (ch == '\0')
  803827:	85 db                	test   %ebx,%ebx
  803829:	0f 84 c5 04 00 00    	je     803cf4 <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  80382f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803833:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803837:	48 89 d6             	mov    %rdx,%rsi
  80383a:	89 df                	mov    %ebx,%edi
  80383c:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80383e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803842:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803846:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80384a:	0f b6 00             	movzbl (%rax),%eax
  80384d:	0f b6 d8             	movzbl %al,%ebx
  803850:	83 fb 25             	cmp    $0x25,%ebx
  803853:	75 d2                	jne    803827 <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  803855:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  803859:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  803860:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  803867:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80386e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  803875:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803879:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80387d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803881:	0f b6 00             	movzbl (%rax),%eax
  803884:	0f b6 d8             	movzbl %al,%ebx
  803887:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80388a:	83 f8 55             	cmp    $0x55,%eax
  80388d:	0f 87 2e 04 00 00    	ja     803cc1 <vprintfmt+0x4d5>
  803893:	89 c0                	mov    %eax,%eax
  803895:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80389c:	00 
  80389d:	48 b8 d8 77 80 00 00 	movabs $0x8077d8,%rax
  8038a4:	00 00 00 
  8038a7:	48 01 d0             	add    %rdx,%rax
  8038aa:	48 8b 00             	mov    (%rax),%rax
  8038ad:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8038af:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8038b3:	eb c0                	jmp    803875 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8038b5:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8038b9:	eb ba                	jmp    803875 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8038bb:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8038c2:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8038c5:	89 d0                	mov    %edx,%eax
  8038c7:	c1 e0 02             	shl    $0x2,%eax
  8038ca:	01 d0                	add    %edx,%eax
  8038cc:	01 c0                	add    %eax,%eax
  8038ce:	01 d8                	add    %ebx,%eax
  8038d0:	83 e8 30             	sub    $0x30,%eax
  8038d3:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8038d6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8038da:	0f b6 00             	movzbl (%rax),%eax
  8038dd:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8038e0:	83 fb 2f             	cmp    $0x2f,%ebx
  8038e3:	7e 0c                	jle    8038f1 <vprintfmt+0x105>
  8038e5:	83 fb 39             	cmp    $0x39,%ebx
  8038e8:	7f 07                	jg     8038f1 <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  8038ea:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  8038ef:	eb d1                	jmp    8038c2 <vprintfmt+0xd6>
			goto process_precision;
  8038f1:	eb 50                	jmp    803943 <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  8038f3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8038f6:	83 f8 30             	cmp    $0x30,%eax
  8038f9:	73 17                	jae    803912 <vprintfmt+0x126>
  8038fb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8038ff:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803902:	89 d2                	mov    %edx,%edx
  803904:	48 01 d0             	add    %rdx,%rax
  803907:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80390a:	83 c2 08             	add    $0x8,%edx
  80390d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803910:	eb 0c                	jmp    80391e <vprintfmt+0x132>
  803912:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803916:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80391a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80391e:	8b 00                	mov    (%rax),%eax
  803920:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  803923:	eb 1e                	jmp    803943 <vprintfmt+0x157>

		case '.':
			if (width < 0)
  803925:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803929:	79 07                	jns    803932 <vprintfmt+0x146>
				width = 0;
  80392b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  803932:	e9 3e ff ff ff       	jmpq   803875 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  803937:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80393e:	e9 32 ff ff ff       	jmpq   803875 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  803943:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803947:	79 0d                	jns    803956 <vprintfmt+0x16a>
				width = precision, precision = -1;
  803949:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80394c:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80394f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  803956:	e9 1a ff ff ff       	jmpq   803875 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80395b:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80395f:	e9 11 ff ff ff       	jmpq   803875 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  803964:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803967:	83 f8 30             	cmp    $0x30,%eax
  80396a:	73 17                	jae    803983 <vprintfmt+0x197>
  80396c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803970:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803973:	89 d2                	mov    %edx,%edx
  803975:	48 01 d0             	add    %rdx,%rax
  803978:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80397b:	83 c2 08             	add    $0x8,%edx
  80397e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803981:	eb 0c                	jmp    80398f <vprintfmt+0x1a3>
  803983:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803987:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80398b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80398f:	8b 10                	mov    (%rax),%edx
  803991:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803995:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803999:	48 89 ce             	mov    %rcx,%rsi
  80399c:	89 d7                	mov    %edx,%edi
  80399e:	ff d0                	callq  *%rax
			break;
  8039a0:	e9 4a 03 00 00       	jmpq   803cef <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8039a5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8039a8:	83 f8 30             	cmp    $0x30,%eax
  8039ab:	73 17                	jae    8039c4 <vprintfmt+0x1d8>
  8039ad:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8039b1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8039b4:	89 d2                	mov    %edx,%edx
  8039b6:	48 01 d0             	add    %rdx,%rax
  8039b9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8039bc:	83 c2 08             	add    $0x8,%edx
  8039bf:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8039c2:	eb 0c                	jmp    8039d0 <vprintfmt+0x1e4>
  8039c4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8039c8:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8039cc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8039d0:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8039d2:	85 db                	test   %ebx,%ebx
  8039d4:	79 02                	jns    8039d8 <vprintfmt+0x1ec>
				err = -err;
  8039d6:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8039d8:	83 fb 15             	cmp    $0x15,%ebx
  8039db:	7f 16                	jg     8039f3 <vprintfmt+0x207>
  8039dd:	48 b8 00 77 80 00 00 	movabs $0x807700,%rax
  8039e4:	00 00 00 
  8039e7:	48 63 d3             	movslq %ebx,%rdx
  8039ea:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8039ee:	4d 85 e4             	test   %r12,%r12
  8039f1:	75 2e                	jne    803a21 <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  8039f3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8039f7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8039fb:	89 d9                	mov    %ebx,%ecx
  8039fd:	48 ba c1 77 80 00 00 	movabs $0x8077c1,%rdx
  803a04:	00 00 00 
  803a07:	48 89 c7             	mov    %rax,%rdi
  803a0a:	b8 00 00 00 00       	mov    $0x0,%eax
  803a0f:	49 b8 fd 3c 80 00 00 	movabs $0x803cfd,%r8
  803a16:	00 00 00 
  803a19:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  803a1c:	e9 ce 02 00 00       	jmpq   803cef <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  803a21:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803a25:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803a29:	4c 89 e1             	mov    %r12,%rcx
  803a2c:	48 ba ca 77 80 00 00 	movabs $0x8077ca,%rdx
  803a33:	00 00 00 
  803a36:	48 89 c7             	mov    %rax,%rdi
  803a39:	b8 00 00 00 00       	mov    $0x0,%eax
  803a3e:	49 b8 fd 3c 80 00 00 	movabs $0x803cfd,%r8
  803a45:	00 00 00 
  803a48:	41 ff d0             	callq  *%r8
			break;
  803a4b:	e9 9f 02 00 00       	jmpq   803cef <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  803a50:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803a53:	83 f8 30             	cmp    $0x30,%eax
  803a56:	73 17                	jae    803a6f <vprintfmt+0x283>
  803a58:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803a5c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803a5f:	89 d2                	mov    %edx,%edx
  803a61:	48 01 d0             	add    %rdx,%rax
  803a64:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803a67:	83 c2 08             	add    $0x8,%edx
  803a6a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803a6d:	eb 0c                	jmp    803a7b <vprintfmt+0x28f>
  803a6f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803a73:	48 8d 50 08          	lea    0x8(%rax),%rdx
  803a77:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803a7b:	4c 8b 20             	mov    (%rax),%r12
  803a7e:	4d 85 e4             	test   %r12,%r12
  803a81:	75 0a                	jne    803a8d <vprintfmt+0x2a1>
				p = "(null)";
  803a83:	49 bc cd 77 80 00 00 	movabs $0x8077cd,%r12
  803a8a:	00 00 00 
			if (width > 0 && padc != '-')
  803a8d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803a91:	7e 3f                	jle    803ad2 <vprintfmt+0x2e6>
  803a93:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  803a97:	74 39                	je     803ad2 <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  803a99:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803a9c:	48 98                	cltq   
  803a9e:	48 89 c6             	mov    %rax,%rsi
  803aa1:	4c 89 e7             	mov    %r12,%rdi
  803aa4:	48 b8 a9 3f 80 00 00 	movabs $0x803fa9,%rax
  803aab:	00 00 00 
  803aae:	ff d0                	callq  *%rax
  803ab0:	29 45 dc             	sub    %eax,-0x24(%rbp)
  803ab3:	eb 17                	jmp    803acc <vprintfmt+0x2e0>
					putch(padc, putdat);
  803ab5:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  803ab9:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803abd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803ac1:	48 89 ce             	mov    %rcx,%rsi
  803ac4:	89 d7                	mov    %edx,%edi
  803ac6:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  803ac8:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803acc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803ad0:	7f e3                	jg     803ab5 <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803ad2:	eb 37                	jmp    803b0b <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  803ad4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  803ad8:	74 1e                	je     803af8 <vprintfmt+0x30c>
  803ada:	83 fb 1f             	cmp    $0x1f,%ebx
  803add:	7e 05                	jle    803ae4 <vprintfmt+0x2f8>
  803adf:	83 fb 7e             	cmp    $0x7e,%ebx
  803ae2:	7e 14                	jle    803af8 <vprintfmt+0x30c>
					putch('?', putdat);
  803ae4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803ae8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803aec:	48 89 d6             	mov    %rdx,%rsi
  803aef:	bf 3f 00 00 00       	mov    $0x3f,%edi
  803af4:	ff d0                	callq  *%rax
  803af6:	eb 0f                	jmp    803b07 <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  803af8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803afc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b00:	48 89 d6             	mov    %rdx,%rsi
  803b03:	89 df                	mov    %ebx,%edi
  803b05:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803b07:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803b0b:	4c 89 e0             	mov    %r12,%rax
  803b0e:	4c 8d 60 01          	lea    0x1(%rax),%r12
  803b12:	0f b6 00             	movzbl (%rax),%eax
  803b15:	0f be d8             	movsbl %al,%ebx
  803b18:	85 db                	test   %ebx,%ebx
  803b1a:	74 10                	je     803b2c <vprintfmt+0x340>
  803b1c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803b20:	78 b2                	js     803ad4 <vprintfmt+0x2e8>
  803b22:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  803b26:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803b2a:	79 a8                	jns    803ad4 <vprintfmt+0x2e8>
			for (; width > 0; width--)
  803b2c:	eb 16                	jmp    803b44 <vprintfmt+0x358>
				putch(' ', putdat);
  803b2e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803b32:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b36:	48 89 d6             	mov    %rdx,%rsi
  803b39:	bf 20 00 00 00       	mov    $0x20,%edi
  803b3e:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  803b40:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803b44:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803b48:	7f e4                	jg     803b2e <vprintfmt+0x342>
			break;
  803b4a:	e9 a0 01 00 00       	jmpq   803cef <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  803b4f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803b53:	be 03 00 00 00       	mov    $0x3,%esi
  803b58:	48 89 c7             	mov    %rax,%rdi
  803b5b:	48 b8 e5 36 80 00 00 	movabs $0x8036e5,%rax
  803b62:	00 00 00 
  803b65:	ff d0                	callq  *%rax
  803b67:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  803b6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b6f:	48 85 c0             	test   %rax,%rax
  803b72:	79 1d                	jns    803b91 <vprintfmt+0x3a5>
				putch('-', putdat);
  803b74:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803b78:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b7c:	48 89 d6             	mov    %rdx,%rsi
  803b7f:	bf 2d 00 00 00       	mov    $0x2d,%edi
  803b84:	ff d0                	callq  *%rax
				num = -(long long) num;
  803b86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b8a:	48 f7 d8             	neg    %rax
  803b8d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  803b91:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803b98:	e9 e5 00 00 00       	jmpq   803c82 <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  803b9d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803ba1:	be 03 00 00 00       	mov    $0x3,%esi
  803ba6:	48 89 c7             	mov    %rax,%rdi
  803ba9:	48 b8 de 35 80 00 00 	movabs $0x8035de,%rax
  803bb0:	00 00 00 
  803bb3:	ff d0                	callq  *%rax
  803bb5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  803bb9:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803bc0:	e9 bd 00 00 00       	jmpq   803c82 <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  803bc5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803bc9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803bcd:	48 89 d6             	mov    %rdx,%rsi
  803bd0:	bf 58 00 00 00       	mov    $0x58,%edi
  803bd5:	ff d0                	callq  *%rax
			putch('X', putdat);
  803bd7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803bdb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803bdf:	48 89 d6             	mov    %rdx,%rsi
  803be2:	bf 58 00 00 00       	mov    $0x58,%edi
  803be7:	ff d0                	callq  *%rax
			putch('X', putdat);
  803be9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803bed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803bf1:	48 89 d6             	mov    %rdx,%rsi
  803bf4:	bf 58 00 00 00       	mov    $0x58,%edi
  803bf9:	ff d0                	callq  *%rax
			break;
  803bfb:	e9 ef 00 00 00       	jmpq   803cef <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  803c00:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803c04:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803c08:	48 89 d6             	mov    %rdx,%rsi
  803c0b:	bf 30 00 00 00       	mov    $0x30,%edi
  803c10:	ff d0                	callq  *%rax
			putch('x', putdat);
  803c12:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803c16:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803c1a:	48 89 d6             	mov    %rdx,%rsi
  803c1d:	bf 78 00 00 00       	mov    $0x78,%edi
  803c22:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  803c24:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803c27:	83 f8 30             	cmp    $0x30,%eax
  803c2a:	73 17                	jae    803c43 <vprintfmt+0x457>
  803c2c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803c30:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803c33:	89 d2                	mov    %edx,%edx
  803c35:	48 01 d0             	add    %rdx,%rax
  803c38:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803c3b:	83 c2 08             	add    $0x8,%edx
  803c3e:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  803c41:	eb 0c                	jmp    803c4f <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  803c43:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803c47:	48 8d 50 08          	lea    0x8(%rax),%rdx
  803c4b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803c4f:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  803c52:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  803c56:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  803c5d:	eb 23                	jmp    803c82 <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  803c5f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803c63:	be 03 00 00 00       	mov    $0x3,%esi
  803c68:	48 89 c7             	mov    %rax,%rdi
  803c6b:	48 b8 de 35 80 00 00 	movabs $0x8035de,%rax
  803c72:	00 00 00 
  803c75:	ff d0                	callq  *%rax
  803c77:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  803c7b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  803c82:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  803c87:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803c8a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  803c8d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803c91:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803c95:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803c99:	45 89 c1             	mov    %r8d,%r9d
  803c9c:	41 89 f8             	mov    %edi,%r8d
  803c9f:	48 89 c7             	mov    %rax,%rdi
  803ca2:	48 b8 25 35 80 00 00 	movabs $0x803525,%rax
  803ca9:	00 00 00 
  803cac:	ff d0                	callq  *%rax
			break;
  803cae:	eb 3f                	jmp    803cef <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  803cb0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803cb4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803cb8:	48 89 d6             	mov    %rdx,%rsi
  803cbb:	89 df                	mov    %ebx,%edi
  803cbd:	ff d0                	callq  *%rax
			break;
  803cbf:	eb 2e                	jmp    803cef <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  803cc1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803cc5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803cc9:	48 89 d6             	mov    %rdx,%rsi
  803ccc:	bf 25 00 00 00       	mov    $0x25,%edi
  803cd1:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  803cd3:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803cd8:	eb 05                	jmp    803cdf <vprintfmt+0x4f3>
  803cda:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803cdf:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803ce3:	48 83 e8 01          	sub    $0x1,%rax
  803ce7:	0f b6 00             	movzbl (%rax),%eax
  803cea:	3c 25                	cmp    $0x25,%al
  803cec:	75 ec                	jne    803cda <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  803cee:	90                   	nop
		}
	}
  803cef:	e9 31 fb ff ff       	jmpq   803825 <vprintfmt+0x39>
	va_end(aq);
}
  803cf4:	48 83 c4 60          	add    $0x60,%rsp
  803cf8:	5b                   	pop    %rbx
  803cf9:	41 5c                	pop    %r12
  803cfb:	5d                   	pop    %rbp
  803cfc:	c3                   	retq   

0000000000803cfd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  803cfd:	55                   	push   %rbp
  803cfe:	48 89 e5             	mov    %rsp,%rbp
  803d01:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  803d08:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  803d0f:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  803d16:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803d1d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803d24:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803d2b:	84 c0                	test   %al,%al
  803d2d:	74 20                	je     803d4f <printfmt+0x52>
  803d2f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803d33:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803d37:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803d3b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803d3f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803d43:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803d47:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803d4b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803d4f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803d56:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  803d5d:	00 00 00 
  803d60:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  803d67:	00 00 00 
  803d6a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803d6e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  803d75:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803d7c:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  803d83:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  803d8a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803d91:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  803d98:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803d9f:	48 89 c7             	mov    %rax,%rdi
  803da2:	48 b8 ec 37 80 00 00 	movabs $0x8037ec,%rax
  803da9:	00 00 00 
  803dac:	ff d0                	callq  *%rax
	va_end(ap);
}
  803dae:	c9                   	leaveq 
  803daf:	c3                   	retq   

0000000000803db0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  803db0:	55                   	push   %rbp
  803db1:	48 89 e5             	mov    %rsp,%rbp
  803db4:	48 83 ec 10          	sub    $0x10,%rsp
  803db8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803dbb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  803dbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dc3:	8b 40 10             	mov    0x10(%rax),%eax
  803dc6:	8d 50 01             	lea    0x1(%rax),%edx
  803dc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dcd:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  803dd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dd4:	48 8b 10             	mov    (%rax),%rdx
  803dd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ddb:	48 8b 40 08          	mov    0x8(%rax),%rax
  803ddf:	48 39 c2             	cmp    %rax,%rdx
  803de2:	73 17                	jae    803dfb <sprintputch+0x4b>
		*b->buf++ = ch;
  803de4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803de8:	48 8b 00             	mov    (%rax),%rax
  803deb:	48 8d 48 01          	lea    0x1(%rax),%rcx
  803def:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803df3:	48 89 0a             	mov    %rcx,(%rdx)
  803df6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803df9:	88 10                	mov    %dl,(%rax)
}
  803dfb:	c9                   	leaveq 
  803dfc:	c3                   	retq   

0000000000803dfd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  803dfd:	55                   	push   %rbp
  803dfe:	48 89 e5             	mov    %rsp,%rbp
  803e01:	48 83 ec 50          	sub    $0x50,%rsp
  803e05:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  803e09:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  803e0c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  803e10:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  803e14:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803e18:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  803e1c:	48 8b 0a             	mov    (%rdx),%rcx
  803e1f:	48 89 08             	mov    %rcx,(%rax)
  803e22:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803e26:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803e2a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803e2e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  803e32:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e36:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803e3a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803e3d:	48 98                	cltq   
  803e3f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803e43:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e47:	48 01 d0             	add    %rdx,%rax
  803e4a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803e4e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  803e55:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  803e5a:	74 06                	je     803e62 <vsnprintf+0x65>
  803e5c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  803e60:	7f 07                	jg     803e69 <vsnprintf+0x6c>
		return -E_INVAL;
  803e62:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803e67:	eb 2f                	jmp    803e98 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  803e69:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  803e6d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803e71:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803e75:	48 89 c6             	mov    %rax,%rsi
  803e78:	48 bf b0 3d 80 00 00 	movabs $0x803db0,%rdi
  803e7f:	00 00 00 
  803e82:	48 b8 ec 37 80 00 00 	movabs $0x8037ec,%rax
  803e89:	00 00 00 
  803e8c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  803e8e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e92:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  803e95:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  803e98:	c9                   	leaveq 
  803e99:	c3                   	retq   

0000000000803e9a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  803e9a:	55                   	push   %rbp
  803e9b:	48 89 e5             	mov    %rsp,%rbp
  803e9e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  803ea5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  803eac:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  803eb2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803eb9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803ec0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803ec7:	84 c0                	test   %al,%al
  803ec9:	74 20                	je     803eeb <snprintf+0x51>
  803ecb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803ecf:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803ed3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803ed7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803edb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803edf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803ee3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803ee7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803eeb:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  803ef2:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  803ef9:	00 00 00 
  803efc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803f03:	00 00 00 
  803f06:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803f0a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803f11:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803f18:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  803f1f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803f26:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803f2d:	48 8b 0a             	mov    (%rdx),%rcx
  803f30:	48 89 08             	mov    %rcx,(%rax)
  803f33:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803f37:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803f3b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803f3f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  803f43:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  803f4a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  803f51:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  803f57:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803f5e:	48 89 c7             	mov    %rax,%rdi
  803f61:	48 b8 fd 3d 80 00 00 	movabs $0x803dfd,%rax
  803f68:	00 00 00 
  803f6b:	ff d0                	callq  *%rax
  803f6d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  803f73:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803f79:	c9                   	leaveq 
  803f7a:	c3                   	retq   

0000000000803f7b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  803f7b:	55                   	push   %rbp
  803f7c:	48 89 e5             	mov    %rsp,%rbp
  803f7f:	48 83 ec 18          	sub    $0x18,%rsp
  803f83:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  803f87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f8e:	eb 09                	jmp    803f99 <strlen+0x1e>
		n++;
  803f90:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  803f94:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803f99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f9d:	0f b6 00             	movzbl (%rax),%eax
  803fa0:	84 c0                	test   %al,%al
  803fa2:	75 ec                	jne    803f90 <strlen+0x15>
	return n;
  803fa4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803fa7:	c9                   	leaveq 
  803fa8:	c3                   	retq   

0000000000803fa9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  803fa9:	55                   	push   %rbp
  803faa:	48 89 e5             	mov    %rsp,%rbp
  803fad:	48 83 ec 20          	sub    $0x20,%rsp
  803fb1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803fb5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  803fb9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803fc0:	eb 0e                	jmp    803fd0 <strnlen+0x27>
		n++;
  803fc2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  803fc6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803fcb:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  803fd0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803fd5:	74 0b                	je     803fe2 <strnlen+0x39>
  803fd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fdb:	0f b6 00             	movzbl (%rax),%eax
  803fde:	84 c0                	test   %al,%al
  803fe0:	75 e0                	jne    803fc2 <strnlen+0x19>
	return n;
  803fe2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803fe5:	c9                   	leaveq 
  803fe6:	c3                   	retq   

0000000000803fe7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  803fe7:	55                   	push   %rbp
  803fe8:	48 89 e5             	mov    %rsp,%rbp
  803feb:	48 83 ec 20          	sub    $0x20,%rsp
  803fef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ff3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  803ff7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ffb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  803fff:	90                   	nop
  804000:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804004:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804008:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80400c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804010:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  804014:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  804018:	0f b6 12             	movzbl (%rdx),%edx
  80401b:	88 10                	mov    %dl,(%rax)
  80401d:	0f b6 00             	movzbl (%rax),%eax
  804020:	84 c0                	test   %al,%al
  804022:	75 dc                	jne    804000 <strcpy+0x19>
		/* do nothing */;
	return ret;
  804024:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804028:	c9                   	leaveq 
  804029:	c3                   	retq   

000000000080402a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80402a:	55                   	push   %rbp
  80402b:	48 89 e5             	mov    %rsp,%rbp
  80402e:	48 83 ec 20          	sub    $0x20,%rsp
  804032:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804036:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80403a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80403e:	48 89 c7             	mov    %rax,%rdi
  804041:	48 b8 7b 3f 80 00 00 	movabs $0x803f7b,%rax
  804048:	00 00 00 
  80404b:	ff d0                	callq  *%rax
  80404d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  804050:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804053:	48 63 d0             	movslq %eax,%rdx
  804056:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80405a:	48 01 c2             	add    %rax,%rdx
  80405d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804061:	48 89 c6             	mov    %rax,%rsi
  804064:	48 89 d7             	mov    %rdx,%rdi
  804067:	48 b8 e7 3f 80 00 00 	movabs $0x803fe7,%rax
  80406e:	00 00 00 
  804071:	ff d0                	callq  *%rax
	return dst;
  804073:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  804077:	c9                   	leaveq 
  804078:	c3                   	retq   

0000000000804079 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  804079:	55                   	push   %rbp
  80407a:	48 89 e5             	mov    %rsp,%rbp
  80407d:	48 83 ec 28          	sub    $0x28,%rsp
  804081:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804085:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804089:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80408d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804091:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  804095:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80409c:	00 
  80409d:	eb 2a                	jmp    8040c9 <strncpy+0x50>
		*dst++ = *src;
  80409f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040a3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8040a7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8040ab:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8040af:	0f b6 12             	movzbl (%rdx),%edx
  8040b2:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8040b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040b8:	0f b6 00             	movzbl (%rax),%eax
  8040bb:	84 c0                	test   %al,%al
  8040bd:	74 05                	je     8040c4 <strncpy+0x4b>
			src++;
  8040bf:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  8040c4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8040c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040cd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8040d1:	72 cc                	jb     80409f <strncpy+0x26>
	}
	return ret;
  8040d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8040d7:	c9                   	leaveq 
  8040d8:	c3                   	retq   

00000000008040d9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8040d9:	55                   	push   %rbp
  8040da:	48 89 e5             	mov    %rsp,%rbp
  8040dd:	48 83 ec 28          	sub    $0x28,%rsp
  8040e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8040e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8040e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8040ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8040f5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8040fa:	74 3d                	je     804139 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8040fc:	eb 1d                	jmp    80411b <strlcpy+0x42>
			*dst++ = *src++;
  8040fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804102:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804106:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80410a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80410e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  804112:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  804116:	0f b6 12             	movzbl (%rdx),%edx
  804119:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  80411b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  804120:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804125:	74 0b                	je     804132 <strlcpy+0x59>
  804127:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80412b:	0f b6 00             	movzbl (%rax),%eax
  80412e:	84 c0                	test   %al,%al
  804130:	75 cc                	jne    8040fe <strlcpy+0x25>
		*dst = '\0';
  804132:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804136:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  804139:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80413d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804141:	48 29 c2             	sub    %rax,%rdx
  804144:	48 89 d0             	mov    %rdx,%rax
}
  804147:	c9                   	leaveq 
  804148:	c3                   	retq   

0000000000804149 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  804149:	55                   	push   %rbp
  80414a:	48 89 e5             	mov    %rsp,%rbp
  80414d:	48 83 ec 10          	sub    $0x10,%rsp
  804151:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804155:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  804159:	eb 0a                	jmp    804165 <strcmp+0x1c>
		p++, q++;
  80415b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804160:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  804165:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804169:	0f b6 00             	movzbl (%rax),%eax
  80416c:	84 c0                	test   %al,%al
  80416e:	74 12                	je     804182 <strcmp+0x39>
  804170:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804174:	0f b6 10             	movzbl (%rax),%edx
  804177:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80417b:	0f b6 00             	movzbl (%rax),%eax
  80417e:	38 c2                	cmp    %al,%dl
  804180:	74 d9                	je     80415b <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  804182:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804186:	0f b6 00             	movzbl (%rax),%eax
  804189:	0f b6 d0             	movzbl %al,%edx
  80418c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804190:	0f b6 00             	movzbl (%rax),%eax
  804193:	0f b6 c0             	movzbl %al,%eax
  804196:	29 c2                	sub    %eax,%edx
  804198:	89 d0                	mov    %edx,%eax
}
  80419a:	c9                   	leaveq 
  80419b:	c3                   	retq   

000000000080419c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80419c:	55                   	push   %rbp
  80419d:	48 89 e5             	mov    %rsp,%rbp
  8041a0:	48 83 ec 18          	sub    $0x18,%rsp
  8041a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8041a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8041ac:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8041b0:	eb 0f                	jmp    8041c1 <strncmp+0x25>
		n--, p++, q++;
  8041b2:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8041b7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8041bc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  8041c1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8041c6:	74 1d                	je     8041e5 <strncmp+0x49>
  8041c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041cc:	0f b6 00             	movzbl (%rax),%eax
  8041cf:	84 c0                	test   %al,%al
  8041d1:	74 12                	je     8041e5 <strncmp+0x49>
  8041d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041d7:	0f b6 10             	movzbl (%rax),%edx
  8041da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041de:	0f b6 00             	movzbl (%rax),%eax
  8041e1:	38 c2                	cmp    %al,%dl
  8041e3:	74 cd                	je     8041b2 <strncmp+0x16>
	if (n == 0)
  8041e5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8041ea:	75 07                	jne    8041f3 <strncmp+0x57>
		return 0;
  8041ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8041f1:	eb 18                	jmp    80420b <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8041f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041f7:	0f b6 00             	movzbl (%rax),%eax
  8041fa:	0f b6 d0             	movzbl %al,%edx
  8041fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804201:	0f b6 00             	movzbl (%rax),%eax
  804204:	0f b6 c0             	movzbl %al,%eax
  804207:	29 c2                	sub    %eax,%edx
  804209:	89 d0                	mov    %edx,%eax
}
  80420b:	c9                   	leaveq 
  80420c:	c3                   	retq   

000000000080420d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80420d:	55                   	push   %rbp
  80420e:	48 89 e5             	mov    %rsp,%rbp
  804211:	48 83 ec 10          	sub    $0x10,%rsp
  804215:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804219:	89 f0                	mov    %esi,%eax
  80421b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80421e:	eb 17                	jmp    804237 <strchr+0x2a>
		if (*s == c)
  804220:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804224:	0f b6 00             	movzbl (%rax),%eax
  804227:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80422a:	75 06                	jne    804232 <strchr+0x25>
			return (char *) s;
  80422c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804230:	eb 15                	jmp    804247 <strchr+0x3a>
	for (; *s; s++)
  804232:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804237:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80423b:	0f b6 00             	movzbl (%rax),%eax
  80423e:	84 c0                	test   %al,%al
  804240:	75 de                	jne    804220 <strchr+0x13>
	return 0;
  804242:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804247:	c9                   	leaveq 
  804248:	c3                   	retq   

0000000000804249 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  804249:	55                   	push   %rbp
  80424a:	48 89 e5             	mov    %rsp,%rbp
  80424d:	48 83 ec 10          	sub    $0x10,%rsp
  804251:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804255:	89 f0                	mov    %esi,%eax
  804257:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80425a:	eb 13                	jmp    80426f <strfind+0x26>
		if (*s == c)
  80425c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804260:	0f b6 00             	movzbl (%rax),%eax
  804263:	3a 45 f4             	cmp    -0xc(%rbp),%al
  804266:	75 02                	jne    80426a <strfind+0x21>
			break;
  804268:	eb 10                	jmp    80427a <strfind+0x31>
	for (; *s; s++)
  80426a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80426f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804273:	0f b6 00             	movzbl (%rax),%eax
  804276:	84 c0                	test   %al,%al
  804278:	75 e2                	jne    80425c <strfind+0x13>
	return (char *) s;
  80427a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80427e:	c9                   	leaveq 
  80427f:	c3                   	retq   

0000000000804280 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  804280:	55                   	push   %rbp
  804281:	48 89 e5             	mov    %rsp,%rbp
  804284:	48 83 ec 18          	sub    $0x18,%rsp
  804288:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80428c:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80428f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  804293:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804298:	75 06                	jne    8042a0 <memset+0x20>
		return v;
  80429a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80429e:	eb 69                	jmp    804309 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8042a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042a4:	83 e0 03             	and    $0x3,%eax
  8042a7:	48 85 c0             	test   %rax,%rax
  8042aa:	75 48                	jne    8042f4 <memset+0x74>
  8042ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042b0:	83 e0 03             	and    $0x3,%eax
  8042b3:	48 85 c0             	test   %rax,%rax
  8042b6:	75 3c                	jne    8042f4 <memset+0x74>
		c &= 0xFF;
  8042b8:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8042bf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8042c2:	c1 e0 18             	shl    $0x18,%eax
  8042c5:	89 c2                	mov    %eax,%edx
  8042c7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8042ca:	c1 e0 10             	shl    $0x10,%eax
  8042cd:	09 c2                	or     %eax,%edx
  8042cf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8042d2:	c1 e0 08             	shl    $0x8,%eax
  8042d5:	09 d0                	or     %edx,%eax
  8042d7:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8042da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042de:	48 c1 e8 02          	shr    $0x2,%rax
  8042e2:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  8042e5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8042e9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8042ec:	48 89 d7             	mov    %rdx,%rdi
  8042ef:	fc                   	cld    
  8042f0:	f3 ab                	rep stos %eax,%es:(%rdi)
  8042f2:	eb 11                	jmp    804305 <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8042f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8042f8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8042fb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8042ff:	48 89 d7             	mov    %rdx,%rdi
  804302:	fc                   	cld    
  804303:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  804305:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804309:	c9                   	leaveq 
  80430a:	c3                   	retq   

000000000080430b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80430b:	55                   	push   %rbp
  80430c:	48 89 e5             	mov    %rsp,%rbp
  80430f:	48 83 ec 28          	sub    $0x28,%rsp
  804313:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804317:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80431b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80431f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804323:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  804327:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80432b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80432f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804333:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  804337:	0f 83 88 00 00 00    	jae    8043c5 <memmove+0xba>
  80433d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804341:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804345:	48 01 d0             	add    %rdx,%rax
  804348:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80434c:	76 77                	jbe    8043c5 <memmove+0xba>
		s += n;
  80434e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804352:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  804356:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80435a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80435e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804362:	83 e0 03             	and    $0x3,%eax
  804365:	48 85 c0             	test   %rax,%rax
  804368:	75 3b                	jne    8043a5 <memmove+0x9a>
  80436a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80436e:	83 e0 03             	and    $0x3,%eax
  804371:	48 85 c0             	test   %rax,%rax
  804374:	75 2f                	jne    8043a5 <memmove+0x9a>
  804376:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80437a:	83 e0 03             	and    $0x3,%eax
  80437d:	48 85 c0             	test   %rax,%rax
  804380:	75 23                	jne    8043a5 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  804382:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804386:	48 83 e8 04          	sub    $0x4,%rax
  80438a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80438e:	48 83 ea 04          	sub    $0x4,%rdx
  804392:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  804396:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  80439a:	48 89 c7             	mov    %rax,%rdi
  80439d:	48 89 d6             	mov    %rdx,%rsi
  8043a0:	fd                   	std    
  8043a1:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8043a3:	eb 1d                	jmp    8043c2 <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8043a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043a9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8043ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043b1:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  8043b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043b9:	48 89 d7             	mov    %rdx,%rdi
  8043bc:	48 89 c1             	mov    %rax,%rcx
  8043bf:	fd                   	std    
  8043c0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8043c2:	fc                   	cld    
  8043c3:	eb 57                	jmp    80441c <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8043c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043c9:	83 e0 03             	and    $0x3,%eax
  8043cc:	48 85 c0             	test   %rax,%rax
  8043cf:	75 36                	jne    804407 <memmove+0xfc>
  8043d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043d5:	83 e0 03             	and    $0x3,%eax
  8043d8:	48 85 c0             	test   %rax,%rax
  8043db:	75 2a                	jne    804407 <memmove+0xfc>
  8043dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043e1:	83 e0 03             	and    $0x3,%eax
  8043e4:	48 85 c0             	test   %rax,%rax
  8043e7:	75 1e                	jne    804407 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8043e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043ed:	48 c1 e8 02          	shr    $0x2,%rax
  8043f1:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  8043f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043f8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8043fc:	48 89 c7             	mov    %rax,%rdi
  8043ff:	48 89 d6             	mov    %rdx,%rsi
  804402:	fc                   	cld    
  804403:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  804405:	eb 15                	jmp    80441c <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  804407:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80440b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80440f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  804413:	48 89 c7             	mov    %rax,%rdi
  804416:	48 89 d6             	mov    %rdx,%rsi
  804419:	fc                   	cld    
  80441a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80441c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  804420:	c9                   	leaveq 
  804421:	c3                   	retq   

0000000000804422 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  804422:	55                   	push   %rbp
  804423:	48 89 e5             	mov    %rsp,%rbp
  804426:	48 83 ec 18          	sub    $0x18,%rsp
  80442a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80442e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804432:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  804436:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80443a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80443e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804442:	48 89 ce             	mov    %rcx,%rsi
  804445:	48 89 c7             	mov    %rax,%rdi
  804448:	48 b8 0b 43 80 00 00 	movabs $0x80430b,%rax
  80444f:	00 00 00 
  804452:	ff d0                	callq  *%rax
}
  804454:	c9                   	leaveq 
  804455:	c3                   	retq   

0000000000804456 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  804456:	55                   	push   %rbp
  804457:	48 89 e5             	mov    %rsp,%rbp
  80445a:	48 83 ec 28          	sub    $0x28,%rsp
  80445e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804462:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804466:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80446a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80446e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  804472:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804476:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80447a:	eb 36                	jmp    8044b2 <memcmp+0x5c>
		if (*s1 != *s2)
  80447c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804480:	0f b6 10             	movzbl (%rax),%edx
  804483:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804487:	0f b6 00             	movzbl (%rax),%eax
  80448a:	38 c2                	cmp    %al,%dl
  80448c:	74 1a                	je     8044a8 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80448e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804492:	0f b6 00             	movzbl (%rax),%eax
  804495:	0f b6 d0             	movzbl %al,%edx
  804498:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80449c:	0f b6 00             	movzbl (%rax),%eax
  80449f:	0f b6 c0             	movzbl %al,%eax
  8044a2:	29 c2                	sub    %eax,%edx
  8044a4:	89 d0                	mov    %edx,%eax
  8044a6:	eb 20                	jmp    8044c8 <memcmp+0x72>
		s1++, s2++;
  8044a8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8044ad:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  8044b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044b6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8044ba:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8044be:	48 85 c0             	test   %rax,%rax
  8044c1:	75 b9                	jne    80447c <memcmp+0x26>
	}

	return 0;
  8044c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8044c8:	c9                   	leaveq 
  8044c9:	c3                   	retq   

00000000008044ca <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8044ca:	55                   	push   %rbp
  8044cb:	48 89 e5             	mov    %rsp,%rbp
  8044ce:	48 83 ec 28          	sub    $0x28,%rsp
  8044d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8044d6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8044d9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8044dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8044e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044e5:	48 01 d0             	add    %rdx,%rax
  8044e8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8044ec:	eb 15                	jmp    804503 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8044ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044f2:	0f b6 00             	movzbl (%rax),%eax
  8044f5:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8044f8:	38 d0                	cmp    %dl,%al
  8044fa:	75 02                	jne    8044fe <memfind+0x34>
			break;
  8044fc:	eb 0f                	jmp    80450d <memfind+0x43>
	for (; s < ends; s++)
  8044fe:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  804503:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804507:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80450b:	72 e1                	jb     8044ee <memfind+0x24>
	return (void *) s;
  80450d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  804511:	c9                   	leaveq 
  804512:	c3                   	retq   

0000000000804513 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  804513:	55                   	push   %rbp
  804514:	48 89 e5             	mov    %rsp,%rbp
  804517:	48 83 ec 38          	sub    $0x38,%rsp
  80451b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80451f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804523:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  804526:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80452d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  804534:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  804535:	eb 05                	jmp    80453c <strtol+0x29>
		s++;
  804537:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  80453c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804540:	0f b6 00             	movzbl (%rax),%eax
  804543:	3c 20                	cmp    $0x20,%al
  804545:	74 f0                	je     804537 <strtol+0x24>
  804547:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80454b:	0f b6 00             	movzbl (%rax),%eax
  80454e:	3c 09                	cmp    $0x9,%al
  804550:	74 e5                	je     804537 <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  804552:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804556:	0f b6 00             	movzbl (%rax),%eax
  804559:	3c 2b                	cmp    $0x2b,%al
  80455b:	75 07                	jne    804564 <strtol+0x51>
		s++;
  80455d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  804562:	eb 17                	jmp    80457b <strtol+0x68>
	else if (*s == '-')
  804564:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804568:	0f b6 00             	movzbl (%rax),%eax
  80456b:	3c 2d                	cmp    $0x2d,%al
  80456d:	75 0c                	jne    80457b <strtol+0x68>
		s++, neg = 1;
  80456f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  804574:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80457b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80457f:	74 06                	je     804587 <strtol+0x74>
  804581:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  804585:	75 28                	jne    8045af <strtol+0x9c>
  804587:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80458b:	0f b6 00             	movzbl (%rax),%eax
  80458e:	3c 30                	cmp    $0x30,%al
  804590:	75 1d                	jne    8045af <strtol+0x9c>
  804592:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804596:	48 83 c0 01          	add    $0x1,%rax
  80459a:	0f b6 00             	movzbl (%rax),%eax
  80459d:	3c 78                	cmp    $0x78,%al
  80459f:	75 0e                	jne    8045af <strtol+0x9c>
		s += 2, base = 16;
  8045a1:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8045a6:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8045ad:	eb 2c                	jmp    8045db <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8045af:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8045b3:	75 19                	jne    8045ce <strtol+0xbb>
  8045b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045b9:	0f b6 00             	movzbl (%rax),%eax
  8045bc:	3c 30                	cmp    $0x30,%al
  8045be:	75 0e                	jne    8045ce <strtol+0xbb>
		s++, base = 8;
  8045c0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8045c5:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8045cc:	eb 0d                	jmp    8045db <strtol+0xc8>
	else if (base == 0)
  8045ce:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8045d2:	75 07                	jne    8045db <strtol+0xc8>
		base = 10;
  8045d4:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8045db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045df:	0f b6 00             	movzbl (%rax),%eax
  8045e2:	3c 2f                	cmp    $0x2f,%al
  8045e4:	7e 1d                	jle    804603 <strtol+0xf0>
  8045e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045ea:	0f b6 00             	movzbl (%rax),%eax
  8045ed:	3c 39                	cmp    $0x39,%al
  8045ef:	7f 12                	jg     804603 <strtol+0xf0>
			dig = *s - '0';
  8045f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045f5:	0f b6 00             	movzbl (%rax),%eax
  8045f8:	0f be c0             	movsbl %al,%eax
  8045fb:	83 e8 30             	sub    $0x30,%eax
  8045fe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804601:	eb 4e                	jmp    804651 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  804603:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804607:	0f b6 00             	movzbl (%rax),%eax
  80460a:	3c 60                	cmp    $0x60,%al
  80460c:	7e 1d                	jle    80462b <strtol+0x118>
  80460e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804612:	0f b6 00             	movzbl (%rax),%eax
  804615:	3c 7a                	cmp    $0x7a,%al
  804617:	7f 12                	jg     80462b <strtol+0x118>
			dig = *s - 'a' + 10;
  804619:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80461d:	0f b6 00             	movzbl (%rax),%eax
  804620:	0f be c0             	movsbl %al,%eax
  804623:	83 e8 57             	sub    $0x57,%eax
  804626:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804629:	eb 26                	jmp    804651 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80462b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80462f:	0f b6 00             	movzbl (%rax),%eax
  804632:	3c 40                	cmp    $0x40,%al
  804634:	7e 48                	jle    80467e <strtol+0x16b>
  804636:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80463a:	0f b6 00             	movzbl (%rax),%eax
  80463d:	3c 5a                	cmp    $0x5a,%al
  80463f:	7f 3d                	jg     80467e <strtol+0x16b>
			dig = *s - 'A' + 10;
  804641:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804645:	0f b6 00             	movzbl (%rax),%eax
  804648:	0f be c0             	movsbl %al,%eax
  80464b:	83 e8 37             	sub    $0x37,%eax
  80464e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  804651:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804654:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  804657:	7c 02                	jl     80465b <strtol+0x148>
			break;
  804659:	eb 23                	jmp    80467e <strtol+0x16b>
		s++, val = (val * base) + dig;
  80465b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  804660:	8b 45 cc             	mov    -0x34(%rbp),%eax
  804663:	48 98                	cltq   
  804665:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80466a:	48 89 c2             	mov    %rax,%rdx
  80466d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804670:	48 98                	cltq   
  804672:	48 01 d0             	add    %rdx,%rax
  804675:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  804679:	e9 5d ff ff ff       	jmpq   8045db <strtol+0xc8>

	if (endptr)
  80467e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  804683:	74 0b                	je     804690 <strtol+0x17d>
		*endptr = (char *) s;
  804685:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804689:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80468d:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  804690:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804694:	74 09                	je     80469f <strtol+0x18c>
  804696:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80469a:	48 f7 d8             	neg    %rax
  80469d:	eb 04                	jmp    8046a3 <strtol+0x190>
  80469f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8046a3:	c9                   	leaveq 
  8046a4:	c3                   	retq   

00000000008046a5 <strstr>:

char * strstr(const char *in, const char *str)
{
  8046a5:	55                   	push   %rbp
  8046a6:	48 89 e5             	mov    %rsp,%rbp
  8046a9:	48 83 ec 30          	sub    $0x30,%rsp
  8046ad:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8046b1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8046b5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8046b9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8046bd:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8046c1:	0f b6 00             	movzbl (%rax),%eax
  8046c4:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8046c7:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8046cb:	75 06                	jne    8046d3 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8046cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046d1:	eb 6b                	jmp    80473e <strstr+0x99>

	len = strlen(str);
  8046d3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8046d7:	48 89 c7             	mov    %rax,%rdi
  8046da:	48 b8 7b 3f 80 00 00 	movabs $0x803f7b,%rax
  8046e1:	00 00 00 
  8046e4:	ff d0                	callq  *%rax
  8046e6:	48 98                	cltq   
  8046e8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8046ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046f0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8046f4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8046f8:	0f b6 00             	movzbl (%rax),%eax
  8046fb:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8046fe:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  804702:	75 07                	jne    80470b <strstr+0x66>
				return (char *) 0;
  804704:	b8 00 00 00 00       	mov    $0x0,%eax
  804709:	eb 33                	jmp    80473e <strstr+0x99>
		} while (sc != c);
  80470b:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80470f:	3a 45 ff             	cmp    -0x1(%rbp),%al
  804712:	75 d8                	jne    8046ec <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  804714:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804718:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80471c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804720:	48 89 ce             	mov    %rcx,%rsi
  804723:	48 89 c7             	mov    %rax,%rdi
  804726:	48 b8 9c 41 80 00 00 	movabs $0x80419c,%rax
  80472d:	00 00 00 
  804730:	ff d0                	callq  *%rax
  804732:	85 c0                	test   %eax,%eax
  804734:	75 b6                	jne    8046ec <strstr+0x47>

	return (char *) (in - 1);
  804736:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80473a:	48 83 e8 01          	sub    $0x1,%rax
}
  80473e:	c9                   	leaveq 
  80473f:	c3                   	retq   

0000000000804740 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  804740:	55                   	push   %rbp
  804741:	48 89 e5             	mov    %rsp,%rbp
  804744:	53                   	push   %rbx
  804745:	48 83 ec 48          	sub    $0x48,%rsp
  804749:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80474c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80474f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804753:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  804757:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80475b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80475f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804762:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  804766:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80476a:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80476e:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  804772:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  804776:	4c 89 c3             	mov    %r8,%rbx
  804779:	cd 30                	int    $0x30
  80477b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80477f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  804783:	74 3e                	je     8047c3 <syscall+0x83>
  804785:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80478a:	7e 37                	jle    8047c3 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80478c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804790:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804793:	49 89 d0             	mov    %rdx,%r8
  804796:	89 c1                	mov    %eax,%ecx
  804798:	48 ba 88 7a 80 00 00 	movabs $0x807a88,%rdx
  80479f:	00 00 00 
  8047a2:	be 23 00 00 00       	mov    $0x23,%esi
  8047a7:	48 bf a5 7a 80 00 00 	movabs $0x807aa5,%rdi
  8047ae:	00 00 00 
  8047b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8047b6:	49 b9 14 32 80 00 00 	movabs $0x803214,%r9
  8047bd:	00 00 00 
  8047c0:	41 ff d1             	callq  *%r9

	return ret;
  8047c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8047c7:	48 83 c4 48          	add    $0x48,%rsp
  8047cb:	5b                   	pop    %rbx
  8047cc:	5d                   	pop    %rbp
  8047cd:	c3                   	retq   

00000000008047ce <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8047ce:	55                   	push   %rbp
  8047cf:	48 89 e5             	mov    %rsp,%rbp
  8047d2:	48 83 ec 10          	sub    $0x10,%rsp
  8047d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8047da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8047de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047e2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8047e6:	48 83 ec 08          	sub    $0x8,%rsp
  8047ea:	6a 00                	pushq  $0x0
  8047ec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8047f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8047f8:	48 89 d1             	mov    %rdx,%rcx
  8047fb:	48 89 c2             	mov    %rax,%rdx
  8047fe:	be 00 00 00 00       	mov    $0x0,%esi
  804803:	bf 00 00 00 00       	mov    $0x0,%edi
  804808:	48 b8 40 47 80 00 00 	movabs $0x804740,%rax
  80480f:	00 00 00 
  804812:	ff d0                	callq  *%rax
  804814:	48 83 c4 10          	add    $0x10,%rsp
}
  804818:	c9                   	leaveq 
  804819:	c3                   	retq   

000000000080481a <sys_cgetc>:

int
sys_cgetc(void)
{
  80481a:	55                   	push   %rbp
  80481b:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80481e:	48 83 ec 08          	sub    $0x8,%rsp
  804822:	6a 00                	pushq  $0x0
  804824:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80482a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804830:	b9 00 00 00 00       	mov    $0x0,%ecx
  804835:	ba 00 00 00 00       	mov    $0x0,%edx
  80483a:	be 00 00 00 00       	mov    $0x0,%esi
  80483f:	bf 01 00 00 00       	mov    $0x1,%edi
  804844:	48 b8 40 47 80 00 00 	movabs $0x804740,%rax
  80484b:	00 00 00 
  80484e:	ff d0                	callq  *%rax
  804850:	48 83 c4 10          	add    $0x10,%rsp
}
  804854:	c9                   	leaveq 
  804855:	c3                   	retq   

0000000000804856 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  804856:	55                   	push   %rbp
  804857:	48 89 e5             	mov    %rsp,%rbp
  80485a:	48 83 ec 10          	sub    $0x10,%rsp
  80485e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  804861:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804864:	48 98                	cltq   
  804866:	48 83 ec 08          	sub    $0x8,%rsp
  80486a:	6a 00                	pushq  $0x0
  80486c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804872:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804878:	b9 00 00 00 00       	mov    $0x0,%ecx
  80487d:	48 89 c2             	mov    %rax,%rdx
  804880:	be 01 00 00 00       	mov    $0x1,%esi
  804885:	bf 03 00 00 00       	mov    $0x3,%edi
  80488a:	48 b8 40 47 80 00 00 	movabs $0x804740,%rax
  804891:	00 00 00 
  804894:	ff d0                	callq  *%rax
  804896:	48 83 c4 10          	add    $0x10,%rsp
}
  80489a:	c9                   	leaveq 
  80489b:	c3                   	retq   

000000000080489c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80489c:	55                   	push   %rbp
  80489d:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8048a0:	48 83 ec 08          	sub    $0x8,%rsp
  8048a4:	6a 00                	pushq  $0x0
  8048a6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8048ac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8048b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8048b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8048bc:	be 00 00 00 00       	mov    $0x0,%esi
  8048c1:	bf 02 00 00 00       	mov    $0x2,%edi
  8048c6:	48 b8 40 47 80 00 00 	movabs $0x804740,%rax
  8048cd:	00 00 00 
  8048d0:	ff d0                	callq  *%rax
  8048d2:	48 83 c4 10          	add    $0x10,%rsp
}
  8048d6:	c9                   	leaveq 
  8048d7:	c3                   	retq   

00000000008048d8 <sys_yield>:

void
sys_yield(void)
{
  8048d8:	55                   	push   %rbp
  8048d9:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8048dc:	48 83 ec 08          	sub    $0x8,%rsp
  8048e0:	6a 00                	pushq  $0x0
  8048e2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8048e8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8048ee:	b9 00 00 00 00       	mov    $0x0,%ecx
  8048f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8048f8:	be 00 00 00 00       	mov    $0x0,%esi
  8048fd:	bf 0b 00 00 00       	mov    $0xb,%edi
  804902:	48 b8 40 47 80 00 00 	movabs $0x804740,%rax
  804909:	00 00 00 
  80490c:	ff d0                	callq  *%rax
  80490e:	48 83 c4 10          	add    $0x10,%rsp
}
  804912:	c9                   	leaveq 
  804913:	c3                   	retq   

0000000000804914 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  804914:	55                   	push   %rbp
  804915:	48 89 e5             	mov    %rsp,%rbp
  804918:	48 83 ec 10          	sub    $0x10,%rsp
  80491c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80491f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804923:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  804926:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804929:	48 63 c8             	movslq %eax,%rcx
  80492c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804930:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804933:	48 98                	cltq   
  804935:	48 83 ec 08          	sub    $0x8,%rsp
  804939:	6a 00                	pushq  $0x0
  80493b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804941:	49 89 c8             	mov    %rcx,%r8
  804944:	48 89 d1             	mov    %rdx,%rcx
  804947:	48 89 c2             	mov    %rax,%rdx
  80494a:	be 01 00 00 00       	mov    $0x1,%esi
  80494f:	bf 04 00 00 00       	mov    $0x4,%edi
  804954:	48 b8 40 47 80 00 00 	movabs $0x804740,%rax
  80495b:	00 00 00 
  80495e:	ff d0                	callq  *%rax
  804960:	48 83 c4 10          	add    $0x10,%rsp
}
  804964:	c9                   	leaveq 
  804965:	c3                   	retq   

0000000000804966 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  804966:	55                   	push   %rbp
  804967:	48 89 e5             	mov    %rsp,%rbp
  80496a:	48 83 ec 20          	sub    $0x20,%rsp
  80496e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804971:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804975:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804978:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80497c:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  804980:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804983:	48 63 c8             	movslq %eax,%rcx
  804986:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80498a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80498d:	48 63 f0             	movslq %eax,%rsi
  804990:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804994:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804997:	48 98                	cltq   
  804999:	48 83 ec 08          	sub    $0x8,%rsp
  80499d:	51                   	push   %rcx
  80499e:	49 89 f9             	mov    %rdi,%r9
  8049a1:	49 89 f0             	mov    %rsi,%r8
  8049a4:	48 89 d1             	mov    %rdx,%rcx
  8049a7:	48 89 c2             	mov    %rax,%rdx
  8049aa:	be 01 00 00 00       	mov    $0x1,%esi
  8049af:	bf 05 00 00 00       	mov    $0x5,%edi
  8049b4:	48 b8 40 47 80 00 00 	movabs $0x804740,%rax
  8049bb:	00 00 00 
  8049be:	ff d0                	callq  *%rax
  8049c0:	48 83 c4 10          	add    $0x10,%rsp
}
  8049c4:	c9                   	leaveq 
  8049c5:	c3                   	retq   

00000000008049c6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8049c6:	55                   	push   %rbp
  8049c7:	48 89 e5             	mov    %rsp,%rbp
  8049ca:	48 83 ec 10          	sub    $0x10,%rsp
  8049ce:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8049d1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8049d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8049d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049dc:	48 98                	cltq   
  8049de:	48 83 ec 08          	sub    $0x8,%rsp
  8049e2:	6a 00                	pushq  $0x0
  8049e4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8049ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8049f0:	48 89 d1             	mov    %rdx,%rcx
  8049f3:	48 89 c2             	mov    %rax,%rdx
  8049f6:	be 01 00 00 00       	mov    $0x1,%esi
  8049fb:	bf 06 00 00 00       	mov    $0x6,%edi
  804a00:	48 b8 40 47 80 00 00 	movabs $0x804740,%rax
  804a07:	00 00 00 
  804a0a:	ff d0                	callq  *%rax
  804a0c:	48 83 c4 10          	add    $0x10,%rsp
}
  804a10:	c9                   	leaveq 
  804a11:	c3                   	retq   

0000000000804a12 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  804a12:	55                   	push   %rbp
  804a13:	48 89 e5             	mov    %rsp,%rbp
  804a16:	48 83 ec 10          	sub    $0x10,%rsp
  804a1a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804a1d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  804a20:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804a23:	48 63 d0             	movslq %eax,%rdx
  804a26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a29:	48 98                	cltq   
  804a2b:	48 83 ec 08          	sub    $0x8,%rsp
  804a2f:	6a 00                	pushq  $0x0
  804a31:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804a37:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804a3d:	48 89 d1             	mov    %rdx,%rcx
  804a40:	48 89 c2             	mov    %rax,%rdx
  804a43:	be 01 00 00 00       	mov    $0x1,%esi
  804a48:	bf 08 00 00 00       	mov    $0x8,%edi
  804a4d:	48 b8 40 47 80 00 00 	movabs $0x804740,%rax
  804a54:	00 00 00 
  804a57:	ff d0                	callq  *%rax
  804a59:	48 83 c4 10          	add    $0x10,%rsp
}
  804a5d:	c9                   	leaveq 
  804a5e:	c3                   	retq   

0000000000804a5f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  804a5f:	55                   	push   %rbp
  804a60:	48 89 e5             	mov    %rsp,%rbp
  804a63:	48 83 ec 10          	sub    $0x10,%rsp
  804a67:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804a6a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  804a6e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a75:	48 98                	cltq   
  804a77:	48 83 ec 08          	sub    $0x8,%rsp
  804a7b:	6a 00                	pushq  $0x0
  804a7d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804a83:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804a89:	48 89 d1             	mov    %rdx,%rcx
  804a8c:	48 89 c2             	mov    %rax,%rdx
  804a8f:	be 01 00 00 00       	mov    $0x1,%esi
  804a94:	bf 09 00 00 00       	mov    $0x9,%edi
  804a99:	48 b8 40 47 80 00 00 	movabs $0x804740,%rax
  804aa0:	00 00 00 
  804aa3:	ff d0                	callq  *%rax
  804aa5:	48 83 c4 10          	add    $0x10,%rsp
}
  804aa9:	c9                   	leaveq 
  804aaa:	c3                   	retq   

0000000000804aab <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  804aab:	55                   	push   %rbp
  804aac:	48 89 e5             	mov    %rsp,%rbp
  804aaf:	48 83 ec 10          	sub    $0x10,%rsp
  804ab3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804ab6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  804aba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804abe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ac1:	48 98                	cltq   
  804ac3:	48 83 ec 08          	sub    $0x8,%rsp
  804ac7:	6a 00                	pushq  $0x0
  804ac9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804acf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804ad5:	48 89 d1             	mov    %rdx,%rcx
  804ad8:	48 89 c2             	mov    %rax,%rdx
  804adb:	be 01 00 00 00       	mov    $0x1,%esi
  804ae0:	bf 0a 00 00 00       	mov    $0xa,%edi
  804ae5:	48 b8 40 47 80 00 00 	movabs $0x804740,%rax
  804aec:	00 00 00 
  804aef:	ff d0                	callq  *%rax
  804af1:	48 83 c4 10          	add    $0x10,%rsp
}
  804af5:	c9                   	leaveq 
  804af6:	c3                   	retq   

0000000000804af7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  804af7:	55                   	push   %rbp
  804af8:	48 89 e5             	mov    %rsp,%rbp
  804afb:	48 83 ec 20          	sub    $0x20,%rsp
  804aff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804b02:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804b06:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  804b0a:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  804b0d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804b10:	48 63 f0             	movslq %eax,%rsi
  804b13:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804b17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b1a:	48 98                	cltq   
  804b1c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804b20:	48 83 ec 08          	sub    $0x8,%rsp
  804b24:	6a 00                	pushq  $0x0
  804b26:	49 89 f1             	mov    %rsi,%r9
  804b29:	49 89 c8             	mov    %rcx,%r8
  804b2c:	48 89 d1             	mov    %rdx,%rcx
  804b2f:	48 89 c2             	mov    %rax,%rdx
  804b32:	be 00 00 00 00       	mov    $0x0,%esi
  804b37:	bf 0c 00 00 00       	mov    $0xc,%edi
  804b3c:	48 b8 40 47 80 00 00 	movabs $0x804740,%rax
  804b43:	00 00 00 
  804b46:	ff d0                	callq  *%rax
  804b48:	48 83 c4 10          	add    $0x10,%rsp
}
  804b4c:	c9                   	leaveq 
  804b4d:	c3                   	retq   

0000000000804b4e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  804b4e:	55                   	push   %rbp
  804b4f:	48 89 e5             	mov    %rsp,%rbp
  804b52:	48 83 ec 10          	sub    $0x10,%rsp
  804b56:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  804b5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b5e:	48 83 ec 08          	sub    $0x8,%rsp
  804b62:	6a 00                	pushq  $0x0
  804b64:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804b6a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804b70:	b9 00 00 00 00       	mov    $0x0,%ecx
  804b75:	48 89 c2             	mov    %rax,%rdx
  804b78:	be 01 00 00 00       	mov    $0x1,%esi
  804b7d:	bf 0d 00 00 00       	mov    $0xd,%edi
  804b82:	48 b8 40 47 80 00 00 	movabs $0x804740,%rax
  804b89:	00 00 00 
  804b8c:	ff d0                	callq  *%rax
  804b8e:	48 83 c4 10          	add    $0x10,%rsp
}
  804b92:	c9                   	leaveq 
  804b93:	c3                   	retq   

0000000000804b94 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  804b94:	55                   	push   %rbp
  804b95:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  804b98:	48 83 ec 08          	sub    $0x8,%rsp
  804b9c:	6a 00                	pushq  $0x0
  804b9e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804ba4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804baa:	b9 00 00 00 00       	mov    $0x0,%ecx
  804baf:	ba 00 00 00 00       	mov    $0x0,%edx
  804bb4:	be 00 00 00 00       	mov    $0x0,%esi
  804bb9:	bf 0e 00 00 00       	mov    $0xe,%edi
  804bbe:	48 b8 40 47 80 00 00 	movabs $0x804740,%rax
  804bc5:	00 00 00 
  804bc8:	ff d0                	callq  *%rax
  804bca:	48 83 c4 10          	add    $0x10,%rsp
}
  804bce:	c9                   	leaveq 
  804bcf:	c3                   	retq   

0000000000804bd0 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  804bd0:	55                   	push   %rbp
  804bd1:	48 89 e5             	mov    %rsp,%rbp
  804bd4:	48 83 ec 20          	sub    $0x20,%rsp
  804bd8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804bdb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804bdf:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804be2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  804be6:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  804bea:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804bed:	48 63 c8             	movslq %eax,%rcx
  804bf0:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  804bf4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804bf7:	48 63 f0             	movslq %eax,%rsi
  804bfa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804bfe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c01:	48 98                	cltq   
  804c03:	48 83 ec 08          	sub    $0x8,%rsp
  804c07:	51                   	push   %rcx
  804c08:	49 89 f9             	mov    %rdi,%r9
  804c0b:	49 89 f0             	mov    %rsi,%r8
  804c0e:	48 89 d1             	mov    %rdx,%rcx
  804c11:	48 89 c2             	mov    %rax,%rdx
  804c14:	be 00 00 00 00       	mov    $0x0,%esi
  804c19:	bf 0f 00 00 00       	mov    $0xf,%edi
  804c1e:	48 b8 40 47 80 00 00 	movabs $0x804740,%rax
  804c25:	00 00 00 
  804c28:	ff d0                	callq  *%rax
  804c2a:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  804c2e:	c9                   	leaveq 
  804c2f:	c3                   	retq   

0000000000804c30 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  804c30:	55                   	push   %rbp
  804c31:	48 89 e5             	mov    %rsp,%rbp
  804c34:	48 83 ec 10          	sub    $0x10,%rsp
  804c38:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804c3c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  804c40:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804c44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c48:	48 83 ec 08          	sub    $0x8,%rsp
  804c4c:	6a 00                	pushq  $0x0
  804c4e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804c54:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804c5a:	48 89 d1             	mov    %rdx,%rcx
  804c5d:	48 89 c2             	mov    %rax,%rdx
  804c60:	be 00 00 00 00       	mov    $0x0,%esi
  804c65:	bf 10 00 00 00       	mov    $0x10,%edi
  804c6a:	48 b8 40 47 80 00 00 	movabs $0x804740,%rax
  804c71:	00 00 00 
  804c74:	ff d0                	callq  *%rax
  804c76:	48 83 c4 10          	add    $0x10,%rsp
}
  804c7a:	c9                   	leaveq 
  804c7b:	c3                   	retq   

0000000000804c7c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804c7c:	55                   	push   %rbp
  804c7d:	48 89 e5             	mov    %rsp,%rbp
  804c80:	48 83 ec 10          	sub    $0x10,%rsp
  804c84:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804c88:	48 b8 28 50 81 00 00 	movabs $0x815028,%rax
  804c8f:	00 00 00 
  804c92:	48 8b 00             	mov    (%rax),%rax
  804c95:	48 85 c0             	test   %rax,%rax
  804c98:	75 2a                	jne    804cc4 <set_pgfault_handler+0x48>
		// First time through!
		// LAB 4: Your code here.
		panic("set_pgfault_handler not implemented");
  804c9a:	48 ba b8 7a 80 00 00 	movabs $0x807ab8,%rdx
  804ca1:	00 00 00 
  804ca4:	be 20 00 00 00       	mov    $0x20,%esi
  804ca9:	48 bf dc 7a 80 00 00 	movabs $0x807adc,%rdi
  804cb0:	00 00 00 
  804cb3:	b8 00 00 00 00       	mov    $0x0,%eax
  804cb8:	48 b9 14 32 80 00 00 	movabs $0x803214,%rcx
  804cbf:	00 00 00 
  804cc2:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804cc4:	48 b8 28 50 81 00 00 	movabs $0x815028,%rax
  804ccb:	00 00 00 
  804cce:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804cd2:	48 89 10             	mov    %rdx,(%rax)
}
  804cd5:	c9                   	leaveq 
  804cd6:	c3                   	retq   

0000000000804cd7 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804cd7:	55                   	push   %rbp
  804cd8:	48 89 e5             	mov    %rsp,%rbp
  804cdb:	48 83 ec 20          	sub    $0x20,%rsp
  804cdf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804ce3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804ce7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  804ceb:	48 ba f0 7a 80 00 00 	movabs $0x807af0,%rdx
  804cf2:	00 00 00 
  804cf5:	be 1d 00 00 00       	mov    $0x1d,%esi
  804cfa:	48 bf 09 7b 80 00 00 	movabs $0x807b09,%rdi
  804d01:	00 00 00 
  804d04:	b8 00 00 00 00       	mov    $0x0,%eax
  804d09:	48 b9 14 32 80 00 00 	movabs $0x803214,%rcx
  804d10:	00 00 00 
  804d13:	ff d1                	callq  *%rcx

0000000000804d15 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804d15:	55                   	push   %rbp
  804d16:	48 89 e5             	mov    %rsp,%rbp
  804d19:	48 83 ec 20          	sub    $0x20,%rsp
  804d1d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804d20:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804d23:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  804d27:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  804d2a:	48 ba 13 7b 80 00 00 	movabs $0x807b13,%rdx
  804d31:	00 00 00 
  804d34:	be 2d 00 00 00       	mov    $0x2d,%esi
  804d39:	48 bf 09 7b 80 00 00 	movabs $0x807b09,%rdi
  804d40:	00 00 00 
  804d43:	b8 00 00 00 00       	mov    $0x0,%eax
  804d48:	48 b9 14 32 80 00 00 	movabs $0x803214,%rcx
  804d4f:	00 00 00 
  804d52:	ff d1                	callq  *%rcx

0000000000804d54 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  804d54:	55                   	push   %rbp
  804d55:	48 89 e5             	mov    %rsp,%rbp
  804d58:	53                   	push   %rbx
  804d59:	48 83 ec 48          	sub    $0x48,%rsp
  804d5d:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  804d61:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  804d68:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  804d6f:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  804d74:	75 0e                	jne    804d84 <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  804d76:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  804d7d:	00 00 00 
  804d80:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  804d84:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804d88:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  804d8c:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  804d93:	00 
	a3 = (uint64_t) 0;
  804d94:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  804d9b:	00 
	a4 = (uint64_t) 0;
  804d9c:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  804da3:	00 
	a5 = 0;
  804da4:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  804dab:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  804dac:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804daf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804db3:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  804db7:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  804dbb:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  804dbf:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  804dc3:	4c 89 c3             	mov    %r8,%rbx
  804dc6:	0f 01 c1             	vmcall 
  804dc9:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  804dcc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804dd0:	7e 36                	jle    804e08 <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  804dd2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804dd5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804dd8:	41 89 d0             	mov    %edx,%r8d
  804ddb:	89 c1                	mov    %eax,%ecx
  804ddd:	48 ba 30 7b 80 00 00 	movabs $0x807b30,%rdx
  804de4:	00 00 00 
  804de7:	be 54 00 00 00       	mov    $0x54,%esi
  804dec:	48 bf 09 7b 80 00 00 	movabs $0x807b09,%rdi
  804df3:	00 00 00 
  804df6:	b8 00 00 00 00       	mov    $0x0,%eax
  804dfb:	49 b9 14 32 80 00 00 	movabs $0x803214,%r9
  804e02:	00 00 00 
  804e05:	41 ff d1             	callq  *%r9
	return ret;
  804e08:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804e0b:	48 83 c4 48          	add    $0x48,%rsp
  804e0f:	5b                   	pop    %rbx
  804e10:	5d                   	pop    %rbp
  804e11:	c3                   	retq   

0000000000804e12 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804e12:	55                   	push   %rbp
  804e13:	48 89 e5             	mov    %rsp,%rbp
  804e16:	53                   	push   %rbx
  804e17:	48 83 ec 58          	sub    $0x58,%rsp
  804e1b:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  804e1e:	89 75 b0             	mov    %esi,-0x50(%rbp)
  804e21:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  804e25:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  804e28:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  804e2f:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  804e36:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  804e3b:	75 0e                	jne    804e4b <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  804e3d:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  804e44:	00 00 00 
  804e47:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  804e4b:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  804e4e:	48 98                	cltq   
  804e50:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  804e54:	8b 45 b0             	mov    -0x50(%rbp),%eax
  804e57:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  804e5b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804e5f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  804e63:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  804e66:	48 98                	cltq   
  804e68:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  804e6c:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  804e73:	00 

	int r = -E_IPC_NOT_RECV;
  804e74:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  804e7b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804e7e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804e82:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  804e86:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  804e8a:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  804e8e:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  804e92:	4c 89 c3             	mov    %r8,%rbx
  804e95:	0f 01 c1             	vmcall 
  804e98:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  804e9b:	48 83 c4 58          	add    $0x58,%rsp
  804e9f:	5b                   	pop    %rbx
  804ea0:	5d                   	pop    %rbp
  804ea1:	c3                   	retq   

0000000000804ea2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804ea2:	55                   	push   %rbp
  804ea3:	48 89 e5             	mov    %rsp,%rbp
  804ea6:	48 83 ec 18          	sub    $0x18,%rsp
  804eaa:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804ead:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804eb4:	eb 4e                	jmp    804f04 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  804eb6:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804ebd:	00 00 00 
  804ec0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ec3:	48 98                	cltq   
  804ec5:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804ecc:	48 01 d0             	add    %rdx,%rax
  804ecf:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804ed5:	8b 00                	mov    (%rax),%eax
  804ed7:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804eda:	75 24                	jne    804f00 <ipc_find_env+0x5e>
			return envs[i].env_id;
  804edc:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804ee3:	00 00 00 
  804ee6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ee9:	48 98                	cltq   
  804eeb:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804ef2:	48 01 d0             	add    %rdx,%rax
  804ef5:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804efb:	8b 40 08             	mov    0x8(%rax),%eax
  804efe:	eb 12                	jmp    804f12 <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  804f00:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804f04:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804f0b:	7e a9                	jle    804eb6 <ipc_find_env+0x14>
	}
	return 0;
  804f0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804f12:	c9                   	leaveq 
  804f13:	c3                   	retq   

0000000000804f14 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  804f14:	55                   	push   %rbp
  804f15:	48 89 e5             	mov    %rsp,%rbp
  804f18:	48 83 ec 08          	sub    $0x8,%rsp
  804f1c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  804f20:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804f24:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  804f2b:	ff ff ff 
  804f2e:	48 01 d0             	add    %rdx,%rax
  804f31:	48 c1 e8 0c          	shr    $0xc,%rax
}
  804f35:	c9                   	leaveq 
  804f36:	c3                   	retq   

0000000000804f37 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  804f37:	55                   	push   %rbp
  804f38:	48 89 e5             	mov    %rsp,%rbp
  804f3b:	48 83 ec 08          	sub    $0x8,%rsp
  804f3f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  804f43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804f47:	48 89 c7             	mov    %rax,%rdi
  804f4a:	48 b8 14 4f 80 00 00 	movabs $0x804f14,%rax
  804f51:	00 00 00 
  804f54:	ff d0                	callq  *%rax
  804f56:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  804f5c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  804f60:	c9                   	leaveq 
  804f61:	c3                   	retq   

0000000000804f62 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  804f62:	55                   	push   %rbp
  804f63:	48 89 e5             	mov    %rsp,%rbp
  804f66:	48 83 ec 18          	sub    $0x18,%rsp
  804f6a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  804f6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804f75:	eb 6b                	jmp    804fe2 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  804f77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f7a:	48 98                	cltq   
  804f7c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  804f82:	48 c1 e0 0c          	shl    $0xc,%rax
  804f86:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  804f8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f8e:	48 c1 e8 15          	shr    $0x15,%rax
  804f92:	48 89 c2             	mov    %rax,%rdx
  804f95:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804f9c:	01 00 00 
  804f9f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804fa3:	83 e0 01             	and    $0x1,%eax
  804fa6:	48 85 c0             	test   %rax,%rax
  804fa9:	74 21                	je     804fcc <fd_alloc+0x6a>
  804fab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804faf:	48 c1 e8 0c          	shr    $0xc,%rax
  804fb3:	48 89 c2             	mov    %rax,%rdx
  804fb6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804fbd:	01 00 00 
  804fc0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804fc4:	83 e0 01             	and    $0x1,%eax
  804fc7:	48 85 c0             	test   %rax,%rax
  804fca:	75 12                	jne    804fde <fd_alloc+0x7c>
			*fd_store = fd;
  804fcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804fd0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804fd4:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  804fd7:	b8 00 00 00 00       	mov    $0x0,%eax
  804fdc:	eb 1a                	jmp    804ff8 <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  804fde:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804fe2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  804fe6:	7e 8f                	jle    804f77 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  804fe8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804fec:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  804ff3:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  804ff8:	c9                   	leaveq 
  804ff9:	c3                   	retq   

0000000000804ffa <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  804ffa:	55                   	push   %rbp
  804ffb:	48 89 e5             	mov    %rsp,%rbp
  804ffe:	48 83 ec 20          	sub    $0x20,%rsp
  805002:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805005:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  805009:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80500d:	78 06                	js     805015 <fd_lookup+0x1b>
  80500f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  805013:	7e 07                	jle    80501c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  805015:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80501a:	eb 6c                	jmp    805088 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80501c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80501f:	48 98                	cltq   
  805021:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  805027:	48 c1 e0 0c          	shl    $0xc,%rax
  80502b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80502f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805033:	48 c1 e8 15          	shr    $0x15,%rax
  805037:	48 89 c2             	mov    %rax,%rdx
  80503a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805041:	01 00 00 
  805044:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805048:	83 e0 01             	and    $0x1,%eax
  80504b:	48 85 c0             	test   %rax,%rax
  80504e:	74 21                	je     805071 <fd_lookup+0x77>
  805050:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805054:	48 c1 e8 0c          	shr    $0xc,%rax
  805058:	48 89 c2             	mov    %rax,%rdx
  80505b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805062:	01 00 00 
  805065:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805069:	83 e0 01             	and    $0x1,%eax
  80506c:	48 85 c0             	test   %rax,%rax
  80506f:	75 07                	jne    805078 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  805071:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805076:	eb 10                	jmp    805088 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  805078:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80507c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805080:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  805083:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805088:	c9                   	leaveq 
  805089:	c3                   	retq   

000000000080508a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80508a:	55                   	push   %rbp
  80508b:	48 89 e5             	mov    %rsp,%rbp
  80508e:	48 83 ec 30          	sub    $0x30,%rsp
  805092:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805096:	89 f0                	mov    %esi,%eax
  805098:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80509b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80509f:	48 89 c7             	mov    %rax,%rdi
  8050a2:	48 b8 14 4f 80 00 00 	movabs $0x804f14,%rax
  8050a9:	00 00 00 
  8050ac:	ff d0                	callq  *%rax
  8050ae:	89 c2                	mov    %eax,%edx
  8050b0:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8050b4:	48 89 c6             	mov    %rax,%rsi
  8050b7:	89 d7                	mov    %edx,%edi
  8050b9:	48 b8 fa 4f 80 00 00 	movabs $0x804ffa,%rax
  8050c0:	00 00 00 
  8050c3:	ff d0                	callq  *%rax
  8050c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8050c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8050cc:	78 0a                	js     8050d8 <fd_close+0x4e>
	    || fd != fd2)
  8050ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8050d2:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8050d6:	74 12                	je     8050ea <fd_close+0x60>
		return (must_exist ? r : 0);
  8050d8:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8050dc:	74 05                	je     8050e3 <fd_close+0x59>
  8050de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8050e1:	eb 70                	jmp    805153 <fd_close+0xc9>
  8050e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8050e8:	eb 69                	jmp    805153 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8050ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8050ee:	8b 00                	mov    (%rax),%eax
  8050f0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8050f4:	48 89 d6             	mov    %rdx,%rsi
  8050f7:	89 c7                	mov    %eax,%edi
  8050f9:	48 b8 55 51 80 00 00 	movabs $0x805155,%rax
  805100:	00 00 00 
  805103:	ff d0                	callq  *%rax
  805105:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805108:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80510c:	78 2a                	js     805138 <fd_close+0xae>
		if (dev->dev_close)
  80510e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805112:	48 8b 40 20          	mov    0x20(%rax),%rax
  805116:	48 85 c0             	test   %rax,%rax
  805119:	74 16                	je     805131 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  80511b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80511f:	48 8b 40 20          	mov    0x20(%rax),%rax
  805123:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805127:	48 89 d7             	mov    %rdx,%rdi
  80512a:	ff d0                	callq  *%rax
  80512c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80512f:	eb 07                	jmp    805138 <fd_close+0xae>
		else
			r = 0;
  805131:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  805138:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80513c:	48 89 c6             	mov    %rax,%rsi
  80513f:	bf 00 00 00 00       	mov    $0x0,%edi
  805144:	48 b8 c6 49 80 00 00 	movabs $0x8049c6,%rax
  80514b:	00 00 00 
  80514e:	ff d0                	callq  *%rax
	return r;
  805150:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805153:	c9                   	leaveq 
  805154:	c3                   	retq   

0000000000805155 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  805155:	55                   	push   %rbp
  805156:	48 89 e5             	mov    %rsp,%rbp
  805159:	48 83 ec 20          	sub    $0x20,%rsp
  80515d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805160:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  805164:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80516b:	eb 41                	jmp    8051ae <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80516d:	48 b8 e0 20 81 00 00 	movabs $0x8120e0,%rax
  805174:	00 00 00 
  805177:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80517a:	48 63 d2             	movslq %edx,%rdx
  80517d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805181:	8b 00                	mov    (%rax),%eax
  805183:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  805186:	75 22                	jne    8051aa <dev_lookup+0x55>
			*dev = devtab[i];
  805188:	48 b8 e0 20 81 00 00 	movabs $0x8120e0,%rax
  80518f:	00 00 00 
  805192:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805195:	48 63 d2             	movslq %edx,%rdx
  805198:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80519c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8051a0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8051a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8051a8:	eb 60                	jmp    80520a <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  8051aa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8051ae:	48 b8 e0 20 81 00 00 	movabs $0x8120e0,%rax
  8051b5:	00 00 00 
  8051b8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8051bb:	48 63 d2             	movslq %edx,%rdx
  8051be:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8051c2:	48 85 c0             	test   %rax,%rax
  8051c5:	75 a6                	jne    80516d <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8051c7:	48 b8 20 50 81 00 00 	movabs $0x815020,%rax
  8051ce:	00 00 00 
  8051d1:	48 8b 00             	mov    (%rax),%rax
  8051d4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8051da:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8051dd:	89 c6                	mov    %eax,%esi
  8051df:	48 bf 60 7b 80 00 00 	movabs $0x807b60,%rdi
  8051e6:	00 00 00 
  8051e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8051ee:	48 b9 4d 34 80 00 00 	movabs $0x80344d,%rcx
  8051f5:	00 00 00 
  8051f8:	ff d1                	callq  *%rcx
	*dev = 0;
  8051fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8051fe:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  805205:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80520a:	c9                   	leaveq 
  80520b:	c3                   	retq   

000000000080520c <close>:

int
close(int fdnum)
{
  80520c:	55                   	push   %rbp
  80520d:	48 89 e5             	mov    %rsp,%rbp
  805210:	48 83 ec 20          	sub    $0x20,%rsp
  805214:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  805217:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80521b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80521e:	48 89 d6             	mov    %rdx,%rsi
  805221:	89 c7                	mov    %eax,%edi
  805223:	48 b8 fa 4f 80 00 00 	movabs $0x804ffa,%rax
  80522a:	00 00 00 
  80522d:	ff d0                	callq  *%rax
  80522f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805232:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805236:	79 05                	jns    80523d <close+0x31>
		return r;
  805238:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80523b:	eb 18                	jmp    805255 <close+0x49>
	else
		return fd_close(fd, 1);
  80523d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805241:	be 01 00 00 00       	mov    $0x1,%esi
  805246:	48 89 c7             	mov    %rax,%rdi
  805249:	48 b8 8a 50 80 00 00 	movabs $0x80508a,%rax
  805250:	00 00 00 
  805253:	ff d0                	callq  *%rax
}
  805255:	c9                   	leaveq 
  805256:	c3                   	retq   

0000000000805257 <close_all>:

void
close_all(void)
{
  805257:	55                   	push   %rbp
  805258:	48 89 e5             	mov    %rsp,%rbp
  80525b:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80525f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805266:	eb 15                	jmp    80527d <close_all+0x26>
		close(i);
  805268:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80526b:	89 c7                	mov    %eax,%edi
  80526d:	48 b8 0c 52 80 00 00 	movabs $0x80520c,%rax
  805274:	00 00 00 
  805277:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  805279:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80527d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  805281:	7e e5                	jle    805268 <close_all+0x11>
}
  805283:	c9                   	leaveq 
  805284:	c3                   	retq   

0000000000805285 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  805285:	55                   	push   %rbp
  805286:	48 89 e5             	mov    %rsp,%rbp
  805289:	48 83 ec 40          	sub    $0x40,%rsp
  80528d:	89 7d cc             	mov    %edi,-0x34(%rbp)
  805290:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  805293:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  805297:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80529a:	48 89 d6             	mov    %rdx,%rsi
  80529d:	89 c7                	mov    %eax,%edi
  80529f:	48 b8 fa 4f 80 00 00 	movabs $0x804ffa,%rax
  8052a6:	00 00 00 
  8052a9:	ff d0                	callq  *%rax
  8052ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8052ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8052b2:	79 08                	jns    8052bc <dup+0x37>
		return r;
  8052b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8052b7:	e9 70 01 00 00       	jmpq   80542c <dup+0x1a7>
	close(newfdnum);
  8052bc:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8052bf:	89 c7                	mov    %eax,%edi
  8052c1:	48 b8 0c 52 80 00 00 	movabs $0x80520c,%rax
  8052c8:	00 00 00 
  8052cb:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8052cd:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8052d0:	48 98                	cltq   
  8052d2:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8052d8:	48 c1 e0 0c          	shl    $0xc,%rax
  8052dc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8052e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8052e4:	48 89 c7             	mov    %rax,%rdi
  8052e7:	48 b8 37 4f 80 00 00 	movabs $0x804f37,%rax
  8052ee:	00 00 00 
  8052f1:	ff d0                	callq  *%rax
  8052f3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8052f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8052fb:	48 89 c7             	mov    %rax,%rdi
  8052fe:	48 b8 37 4f 80 00 00 	movabs $0x804f37,%rax
  805305:	00 00 00 
  805308:	ff d0                	callq  *%rax
  80530a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80530e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805312:	48 c1 e8 15          	shr    $0x15,%rax
  805316:	48 89 c2             	mov    %rax,%rdx
  805319:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805320:	01 00 00 
  805323:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805327:	83 e0 01             	and    $0x1,%eax
  80532a:	48 85 c0             	test   %rax,%rax
  80532d:	74 73                	je     8053a2 <dup+0x11d>
  80532f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805333:	48 c1 e8 0c          	shr    $0xc,%rax
  805337:	48 89 c2             	mov    %rax,%rdx
  80533a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805341:	01 00 00 
  805344:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805348:	83 e0 01             	and    $0x1,%eax
  80534b:	48 85 c0             	test   %rax,%rax
  80534e:	74 52                	je     8053a2 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  805350:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805354:	48 c1 e8 0c          	shr    $0xc,%rax
  805358:	48 89 c2             	mov    %rax,%rdx
  80535b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805362:	01 00 00 
  805365:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805369:	25 07 0e 00 00       	and    $0xe07,%eax
  80536e:	89 c1                	mov    %eax,%ecx
  805370:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805374:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805378:	41 89 c8             	mov    %ecx,%r8d
  80537b:	48 89 d1             	mov    %rdx,%rcx
  80537e:	ba 00 00 00 00       	mov    $0x0,%edx
  805383:	48 89 c6             	mov    %rax,%rsi
  805386:	bf 00 00 00 00       	mov    $0x0,%edi
  80538b:	48 b8 66 49 80 00 00 	movabs $0x804966,%rax
  805392:	00 00 00 
  805395:	ff d0                	callq  *%rax
  805397:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80539a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80539e:	79 02                	jns    8053a2 <dup+0x11d>
			goto err;
  8053a0:	eb 57                	jmp    8053f9 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8053a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8053a6:	48 c1 e8 0c          	shr    $0xc,%rax
  8053aa:	48 89 c2             	mov    %rax,%rdx
  8053ad:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8053b4:	01 00 00 
  8053b7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8053bb:	25 07 0e 00 00       	and    $0xe07,%eax
  8053c0:	89 c1                	mov    %eax,%ecx
  8053c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8053c6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8053ca:	41 89 c8             	mov    %ecx,%r8d
  8053cd:	48 89 d1             	mov    %rdx,%rcx
  8053d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8053d5:	48 89 c6             	mov    %rax,%rsi
  8053d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8053dd:	48 b8 66 49 80 00 00 	movabs $0x804966,%rax
  8053e4:	00 00 00 
  8053e7:	ff d0                	callq  *%rax
  8053e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8053ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8053f0:	79 02                	jns    8053f4 <dup+0x16f>
		goto err;
  8053f2:	eb 05                	jmp    8053f9 <dup+0x174>

	return newfdnum;
  8053f4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8053f7:	eb 33                	jmp    80542c <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8053f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8053fd:	48 89 c6             	mov    %rax,%rsi
  805400:	bf 00 00 00 00       	mov    $0x0,%edi
  805405:	48 b8 c6 49 80 00 00 	movabs $0x8049c6,%rax
  80540c:	00 00 00 
  80540f:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  805411:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805415:	48 89 c6             	mov    %rax,%rsi
  805418:	bf 00 00 00 00       	mov    $0x0,%edi
  80541d:	48 b8 c6 49 80 00 00 	movabs $0x8049c6,%rax
  805424:	00 00 00 
  805427:	ff d0                	callq  *%rax
	return r;
  805429:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80542c:	c9                   	leaveq 
  80542d:	c3                   	retq   

000000000080542e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80542e:	55                   	push   %rbp
  80542f:	48 89 e5             	mov    %rsp,%rbp
  805432:	48 83 ec 40          	sub    $0x40,%rsp
  805436:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805439:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80543d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  805441:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805445:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805448:	48 89 d6             	mov    %rdx,%rsi
  80544b:	89 c7                	mov    %eax,%edi
  80544d:	48 b8 fa 4f 80 00 00 	movabs $0x804ffa,%rax
  805454:	00 00 00 
  805457:	ff d0                	callq  *%rax
  805459:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80545c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805460:	78 24                	js     805486 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805462:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805466:	8b 00                	mov    (%rax),%eax
  805468:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80546c:	48 89 d6             	mov    %rdx,%rsi
  80546f:	89 c7                	mov    %eax,%edi
  805471:	48 b8 55 51 80 00 00 	movabs $0x805155,%rax
  805478:	00 00 00 
  80547b:	ff d0                	callq  *%rax
  80547d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805480:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805484:	79 05                	jns    80548b <read+0x5d>
		return r;
  805486:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805489:	eb 76                	jmp    805501 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80548b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80548f:	8b 40 08             	mov    0x8(%rax),%eax
  805492:	83 e0 03             	and    $0x3,%eax
  805495:	83 f8 01             	cmp    $0x1,%eax
  805498:	75 3a                	jne    8054d4 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80549a:	48 b8 20 50 81 00 00 	movabs $0x815020,%rax
  8054a1:	00 00 00 
  8054a4:	48 8b 00             	mov    (%rax),%rax
  8054a7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8054ad:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8054b0:	89 c6                	mov    %eax,%esi
  8054b2:	48 bf 7f 7b 80 00 00 	movabs $0x807b7f,%rdi
  8054b9:	00 00 00 
  8054bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8054c1:	48 b9 4d 34 80 00 00 	movabs $0x80344d,%rcx
  8054c8:	00 00 00 
  8054cb:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8054cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8054d2:	eb 2d                	jmp    805501 <read+0xd3>
	}
	if (!dev->dev_read)
  8054d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8054d8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8054dc:	48 85 c0             	test   %rax,%rax
  8054df:	75 07                	jne    8054e8 <read+0xba>
		return -E_NOT_SUPP;
  8054e1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8054e6:	eb 19                	jmp    805501 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8054e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8054ec:	48 8b 40 10          	mov    0x10(%rax),%rax
  8054f0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8054f4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8054f8:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8054fc:	48 89 cf             	mov    %rcx,%rdi
  8054ff:	ff d0                	callq  *%rax
}
  805501:	c9                   	leaveq 
  805502:	c3                   	retq   

0000000000805503 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  805503:	55                   	push   %rbp
  805504:	48 89 e5             	mov    %rsp,%rbp
  805507:	48 83 ec 30          	sub    $0x30,%rsp
  80550b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80550e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805512:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  805516:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80551d:	eb 49                	jmp    805568 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80551f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805522:	48 98                	cltq   
  805524:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805528:	48 29 c2             	sub    %rax,%rdx
  80552b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80552e:	48 63 c8             	movslq %eax,%rcx
  805531:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805535:	48 01 c1             	add    %rax,%rcx
  805538:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80553b:	48 89 ce             	mov    %rcx,%rsi
  80553e:	89 c7                	mov    %eax,%edi
  805540:	48 b8 2e 54 80 00 00 	movabs $0x80542e,%rax
  805547:	00 00 00 
  80554a:	ff d0                	callq  *%rax
  80554c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80554f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805553:	79 05                	jns    80555a <readn+0x57>
			return m;
  805555:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805558:	eb 1c                	jmp    805576 <readn+0x73>
		if (m == 0)
  80555a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80555e:	75 02                	jne    805562 <readn+0x5f>
			break;
  805560:	eb 11                	jmp    805573 <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  805562:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805565:	01 45 fc             	add    %eax,-0x4(%rbp)
  805568:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80556b:	48 98                	cltq   
  80556d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  805571:	72 ac                	jb     80551f <readn+0x1c>
	}
	return tot;
  805573:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805576:	c9                   	leaveq 
  805577:	c3                   	retq   

0000000000805578 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  805578:	55                   	push   %rbp
  805579:	48 89 e5             	mov    %rsp,%rbp
  80557c:	48 83 ec 40          	sub    $0x40,%rsp
  805580:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805583:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805587:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80558b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80558f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805592:	48 89 d6             	mov    %rdx,%rsi
  805595:	89 c7                	mov    %eax,%edi
  805597:	48 b8 fa 4f 80 00 00 	movabs $0x804ffa,%rax
  80559e:	00 00 00 
  8055a1:	ff d0                	callq  *%rax
  8055a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8055a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8055aa:	78 24                	js     8055d0 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8055ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8055b0:	8b 00                	mov    (%rax),%eax
  8055b2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8055b6:	48 89 d6             	mov    %rdx,%rsi
  8055b9:	89 c7                	mov    %eax,%edi
  8055bb:	48 b8 55 51 80 00 00 	movabs $0x805155,%rax
  8055c2:	00 00 00 
  8055c5:	ff d0                	callq  *%rax
  8055c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8055ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8055ce:	79 05                	jns    8055d5 <write+0x5d>
		return r;
  8055d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8055d3:	eb 75                	jmp    80564a <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8055d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8055d9:	8b 40 08             	mov    0x8(%rax),%eax
  8055dc:	83 e0 03             	and    $0x3,%eax
  8055df:	85 c0                	test   %eax,%eax
  8055e1:	75 3a                	jne    80561d <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8055e3:	48 b8 20 50 81 00 00 	movabs $0x815020,%rax
  8055ea:	00 00 00 
  8055ed:	48 8b 00             	mov    (%rax),%rax
  8055f0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8055f6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8055f9:	89 c6                	mov    %eax,%esi
  8055fb:	48 bf 9b 7b 80 00 00 	movabs $0x807b9b,%rdi
  805602:	00 00 00 
  805605:	b8 00 00 00 00       	mov    $0x0,%eax
  80560a:	48 b9 4d 34 80 00 00 	movabs $0x80344d,%rcx
  805611:	00 00 00 
  805614:	ff d1                	callq  *%rcx
		return -E_INVAL;
  805616:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80561b:	eb 2d                	jmp    80564a <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80561d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805621:	48 8b 40 18          	mov    0x18(%rax),%rax
  805625:	48 85 c0             	test   %rax,%rax
  805628:	75 07                	jne    805631 <write+0xb9>
		return -E_NOT_SUPP;
  80562a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80562f:	eb 19                	jmp    80564a <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  805631:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805635:	48 8b 40 18          	mov    0x18(%rax),%rax
  805639:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80563d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  805641:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  805645:	48 89 cf             	mov    %rcx,%rdi
  805648:	ff d0                	callq  *%rax
}
  80564a:	c9                   	leaveq 
  80564b:	c3                   	retq   

000000000080564c <seek>:

int
seek(int fdnum, off_t offset)
{
  80564c:	55                   	push   %rbp
  80564d:	48 89 e5             	mov    %rsp,%rbp
  805650:	48 83 ec 18          	sub    $0x18,%rsp
  805654:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805657:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80565a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80565e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805661:	48 89 d6             	mov    %rdx,%rsi
  805664:	89 c7                	mov    %eax,%edi
  805666:	48 b8 fa 4f 80 00 00 	movabs $0x804ffa,%rax
  80566d:	00 00 00 
  805670:	ff d0                	callq  *%rax
  805672:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805675:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805679:	79 05                	jns    805680 <seek+0x34>
		return r;
  80567b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80567e:	eb 0f                	jmp    80568f <seek+0x43>
	fd->fd_offset = offset;
  805680:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805684:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805687:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80568a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80568f:	c9                   	leaveq 
  805690:	c3                   	retq   

0000000000805691 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  805691:	55                   	push   %rbp
  805692:	48 89 e5             	mov    %rsp,%rbp
  805695:	48 83 ec 30          	sub    $0x30,%rsp
  805699:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80569c:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80569f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8056a3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8056a6:	48 89 d6             	mov    %rdx,%rsi
  8056a9:	89 c7                	mov    %eax,%edi
  8056ab:	48 b8 fa 4f 80 00 00 	movabs $0x804ffa,%rax
  8056b2:	00 00 00 
  8056b5:	ff d0                	callq  *%rax
  8056b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8056ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8056be:	78 24                	js     8056e4 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8056c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8056c4:	8b 00                	mov    (%rax),%eax
  8056c6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8056ca:	48 89 d6             	mov    %rdx,%rsi
  8056cd:	89 c7                	mov    %eax,%edi
  8056cf:	48 b8 55 51 80 00 00 	movabs $0x805155,%rax
  8056d6:	00 00 00 
  8056d9:	ff d0                	callq  *%rax
  8056db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8056de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8056e2:	79 05                	jns    8056e9 <ftruncate+0x58>
		return r;
  8056e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8056e7:	eb 72                	jmp    80575b <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8056e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8056ed:	8b 40 08             	mov    0x8(%rax),%eax
  8056f0:	83 e0 03             	and    $0x3,%eax
  8056f3:	85 c0                	test   %eax,%eax
  8056f5:	75 3a                	jne    805731 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8056f7:	48 b8 20 50 81 00 00 	movabs $0x815020,%rax
  8056fe:	00 00 00 
  805701:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  805704:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80570a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80570d:	89 c6                	mov    %eax,%esi
  80570f:	48 bf b8 7b 80 00 00 	movabs $0x807bb8,%rdi
  805716:	00 00 00 
  805719:	b8 00 00 00 00       	mov    $0x0,%eax
  80571e:	48 b9 4d 34 80 00 00 	movabs $0x80344d,%rcx
  805725:	00 00 00 
  805728:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80572a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80572f:	eb 2a                	jmp    80575b <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  805731:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805735:	48 8b 40 30          	mov    0x30(%rax),%rax
  805739:	48 85 c0             	test   %rax,%rax
  80573c:	75 07                	jne    805745 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80573e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805743:	eb 16                	jmp    80575b <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  805745:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805749:	48 8b 40 30          	mov    0x30(%rax),%rax
  80574d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805751:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  805754:	89 ce                	mov    %ecx,%esi
  805756:	48 89 d7             	mov    %rdx,%rdi
  805759:	ff d0                	callq  *%rax
}
  80575b:	c9                   	leaveq 
  80575c:	c3                   	retq   

000000000080575d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80575d:	55                   	push   %rbp
  80575e:	48 89 e5             	mov    %rsp,%rbp
  805761:	48 83 ec 30          	sub    $0x30,%rsp
  805765:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805768:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80576c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805770:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805773:	48 89 d6             	mov    %rdx,%rsi
  805776:	89 c7                	mov    %eax,%edi
  805778:	48 b8 fa 4f 80 00 00 	movabs $0x804ffa,%rax
  80577f:	00 00 00 
  805782:	ff d0                	callq  *%rax
  805784:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805787:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80578b:	78 24                	js     8057b1 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80578d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805791:	8b 00                	mov    (%rax),%eax
  805793:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805797:	48 89 d6             	mov    %rdx,%rsi
  80579a:	89 c7                	mov    %eax,%edi
  80579c:	48 b8 55 51 80 00 00 	movabs $0x805155,%rax
  8057a3:	00 00 00 
  8057a6:	ff d0                	callq  *%rax
  8057a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8057ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8057af:	79 05                	jns    8057b6 <fstat+0x59>
		return r;
  8057b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8057b4:	eb 5e                	jmp    805814 <fstat+0xb7>
	if (!dev->dev_stat)
  8057b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8057ba:	48 8b 40 28          	mov    0x28(%rax),%rax
  8057be:	48 85 c0             	test   %rax,%rax
  8057c1:	75 07                	jne    8057ca <fstat+0x6d>
		return -E_NOT_SUPP;
  8057c3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8057c8:	eb 4a                	jmp    805814 <fstat+0xb7>
	stat->st_name[0] = 0;
  8057ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8057ce:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8057d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8057d5:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8057dc:	00 00 00 
	stat->st_isdir = 0;
  8057df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8057e3:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8057ea:	00 00 00 
	stat->st_dev = dev;
  8057ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8057f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8057f5:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8057fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805800:	48 8b 40 28          	mov    0x28(%rax),%rax
  805804:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805808:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80580c:	48 89 ce             	mov    %rcx,%rsi
  80580f:	48 89 d7             	mov    %rdx,%rdi
  805812:	ff d0                	callq  *%rax
}
  805814:	c9                   	leaveq 
  805815:	c3                   	retq   

0000000000805816 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  805816:	55                   	push   %rbp
  805817:	48 89 e5             	mov    %rsp,%rbp
  80581a:	48 83 ec 20          	sub    $0x20,%rsp
  80581e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805822:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  805826:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80582a:	be 00 00 00 00       	mov    $0x0,%esi
  80582f:	48 89 c7             	mov    %rax,%rdi
  805832:	48 b8 06 59 80 00 00 	movabs $0x805906,%rax
  805839:	00 00 00 
  80583c:	ff d0                	callq  *%rax
  80583e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805841:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805845:	79 05                	jns    80584c <stat+0x36>
		return fd;
  805847:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80584a:	eb 2f                	jmp    80587b <stat+0x65>
	r = fstat(fd, stat);
  80584c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805850:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805853:	48 89 d6             	mov    %rdx,%rsi
  805856:	89 c7                	mov    %eax,%edi
  805858:	48 b8 5d 57 80 00 00 	movabs $0x80575d,%rax
  80585f:	00 00 00 
  805862:	ff d0                	callq  *%rax
  805864:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  805867:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80586a:	89 c7                	mov    %eax,%edi
  80586c:	48 b8 0c 52 80 00 00 	movabs $0x80520c,%rax
  805873:	00 00 00 
  805876:	ff d0                	callq  *%rax
	return r;
  805878:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80587b:	c9                   	leaveq 
  80587c:	c3                   	retq   

000000000080587d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80587d:	55                   	push   %rbp
  80587e:	48 89 e5             	mov    %rsp,%rbp
  805881:	48 83 ec 10          	sub    $0x10,%rsp
  805885:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805888:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80588c:	48 b8 08 50 81 00 00 	movabs $0x815008,%rax
  805893:	00 00 00 
  805896:	8b 00                	mov    (%rax),%eax
  805898:	85 c0                	test   %eax,%eax
  80589a:	75 1f                	jne    8058bb <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80589c:	bf 01 00 00 00       	mov    $0x1,%edi
  8058a1:	48 b8 a2 4e 80 00 00 	movabs $0x804ea2,%rax
  8058a8:	00 00 00 
  8058ab:	ff d0                	callq  *%rax
  8058ad:	89 c2                	mov    %eax,%edx
  8058af:	48 b8 08 50 81 00 00 	movabs $0x815008,%rax
  8058b6:	00 00 00 
  8058b9:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8058bb:	48 b8 08 50 81 00 00 	movabs $0x815008,%rax
  8058c2:	00 00 00 
  8058c5:	8b 00                	mov    (%rax),%eax
  8058c7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8058ca:	b9 07 00 00 00       	mov    $0x7,%ecx
  8058cf:	48 ba 00 60 81 00 00 	movabs $0x816000,%rdx
  8058d6:	00 00 00 
  8058d9:	89 c7                	mov    %eax,%edi
  8058db:	48 b8 15 4d 80 00 00 	movabs $0x804d15,%rax
  8058e2:	00 00 00 
  8058e5:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8058e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8058eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8058f0:	48 89 c6             	mov    %rax,%rsi
  8058f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8058f8:	48 b8 d7 4c 80 00 00 	movabs $0x804cd7,%rax
  8058ff:	00 00 00 
  805902:	ff d0                	callq  *%rax
}
  805904:	c9                   	leaveq 
  805905:	c3                   	retq   

0000000000805906 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  805906:	55                   	push   %rbp
  805907:	48 89 e5             	mov    %rsp,%rbp
  80590a:	48 83 ec 10          	sub    $0x10,%rsp
  80590e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805912:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  805915:	48 ba de 7b 80 00 00 	movabs $0x807bde,%rdx
  80591c:	00 00 00 
  80591f:	be 4c 00 00 00       	mov    $0x4c,%esi
  805924:	48 bf f3 7b 80 00 00 	movabs $0x807bf3,%rdi
  80592b:	00 00 00 
  80592e:	b8 00 00 00 00       	mov    $0x0,%eax
  805933:	48 b9 14 32 80 00 00 	movabs $0x803214,%rcx
  80593a:	00 00 00 
  80593d:	ff d1                	callq  *%rcx

000000000080593f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80593f:	55                   	push   %rbp
  805940:	48 89 e5             	mov    %rsp,%rbp
  805943:	48 83 ec 10          	sub    $0x10,%rsp
  805947:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80594b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80594f:	8b 50 0c             	mov    0xc(%rax),%edx
  805952:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  805959:	00 00 00 
  80595c:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80595e:	be 00 00 00 00       	mov    $0x0,%esi
  805963:	bf 06 00 00 00       	mov    $0x6,%edi
  805968:	48 b8 7d 58 80 00 00 	movabs $0x80587d,%rax
  80596f:	00 00 00 
  805972:	ff d0                	callq  *%rax
}
  805974:	c9                   	leaveq 
  805975:	c3                   	retq   

0000000000805976 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  805976:	55                   	push   %rbp
  805977:	48 89 e5             	mov    %rsp,%rbp
  80597a:	48 83 ec 20          	sub    $0x20,%rsp
  80597e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805982:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805986:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  80598a:	48 ba fe 7b 80 00 00 	movabs $0x807bfe,%rdx
  805991:	00 00 00 
  805994:	be 6b 00 00 00       	mov    $0x6b,%esi
  805999:	48 bf f3 7b 80 00 00 	movabs $0x807bf3,%rdi
  8059a0:	00 00 00 
  8059a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8059a8:	48 b9 14 32 80 00 00 	movabs $0x803214,%rcx
  8059af:	00 00 00 
  8059b2:	ff d1                	callq  *%rcx

00000000008059b4 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8059b4:	55                   	push   %rbp
  8059b5:	48 89 e5             	mov    %rsp,%rbp
  8059b8:	48 83 ec 20          	sub    $0x20,%rsp
  8059bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8059c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8059c4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  8059c8:	48 ba 1b 7c 80 00 00 	movabs $0x807c1b,%rdx
  8059cf:	00 00 00 
  8059d2:	be 7b 00 00 00       	mov    $0x7b,%esi
  8059d7:	48 bf f3 7b 80 00 00 	movabs $0x807bf3,%rdi
  8059de:	00 00 00 
  8059e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8059e6:	48 b9 14 32 80 00 00 	movabs $0x803214,%rcx
  8059ed:	00 00 00 
  8059f0:	ff d1                	callq  *%rcx

00000000008059f2 <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8059f2:	55                   	push   %rbp
  8059f3:	48 89 e5             	mov    %rsp,%rbp
  8059f6:	48 83 ec 20          	sub    $0x20,%rsp
  8059fa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8059fe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  805a02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805a06:	8b 50 0c             	mov    0xc(%rax),%edx
  805a09:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  805a10:	00 00 00 
  805a13:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  805a15:	be 00 00 00 00       	mov    $0x0,%esi
  805a1a:	bf 05 00 00 00       	mov    $0x5,%edi
  805a1f:	48 b8 7d 58 80 00 00 	movabs $0x80587d,%rax
  805a26:	00 00 00 
  805a29:	ff d0                	callq  *%rax
  805a2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805a2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805a32:	79 05                	jns    805a39 <devfile_stat+0x47>
		return r;
  805a34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805a37:	eb 56                	jmp    805a8f <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  805a39:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805a3d:	48 be 00 60 81 00 00 	movabs $0x816000,%rsi
  805a44:	00 00 00 
  805a47:	48 89 c7             	mov    %rax,%rdi
  805a4a:	48 b8 e7 3f 80 00 00 	movabs $0x803fe7,%rax
  805a51:	00 00 00 
  805a54:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  805a56:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  805a5d:	00 00 00 
  805a60:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  805a66:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805a6a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  805a70:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  805a77:	00 00 00 
  805a7a:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  805a80:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805a84:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  805a8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805a8f:	c9                   	leaveq 
  805a90:	c3                   	retq   

0000000000805a91 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  805a91:	55                   	push   %rbp
  805a92:	48 89 e5             	mov    %rsp,%rbp
  805a95:	48 83 ec 10          	sub    $0x10,%rsp
  805a99:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805a9d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  805aa0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805aa4:	8b 50 0c             	mov    0xc(%rax),%edx
  805aa7:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  805aae:	00 00 00 
  805ab1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  805ab3:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  805aba:	00 00 00 
  805abd:	8b 55 f4             	mov    -0xc(%rbp),%edx
  805ac0:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  805ac3:	be 00 00 00 00       	mov    $0x0,%esi
  805ac8:	bf 02 00 00 00       	mov    $0x2,%edi
  805acd:	48 b8 7d 58 80 00 00 	movabs $0x80587d,%rax
  805ad4:	00 00 00 
  805ad7:	ff d0                	callq  *%rax
}
  805ad9:	c9                   	leaveq 
  805ada:	c3                   	retq   

0000000000805adb <remove>:

// Delete a file
int
remove(const char *path)
{
  805adb:	55                   	push   %rbp
  805adc:	48 89 e5             	mov    %rsp,%rbp
  805adf:	48 83 ec 10          	sub    $0x10,%rsp
  805ae3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  805ae7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805aeb:	48 89 c7             	mov    %rax,%rdi
  805aee:	48 b8 7b 3f 80 00 00 	movabs $0x803f7b,%rax
  805af5:	00 00 00 
  805af8:	ff d0                	callq  *%rax
  805afa:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  805aff:	7e 07                	jle    805b08 <remove+0x2d>
		return -E_BAD_PATH;
  805b01:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  805b06:	eb 33                	jmp    805b3b <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  805b08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805b0c:	48 89 c6             	mov    %rax,%rsi
  805b0f:	48 bf 00 60 81 00 00 	movabs $0x816000,%rdi
  805b16:	00 00 00 
  805b19:	48 b8 e7 3f 80 00 00 	movabs $0x803fe7,%rax
  805b20:	00 00 00 
  805b23:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  805b25:	be 00 00 00 00       	mov    $0x0,%esi
  805b2a:	bf 07 00 00 00       	mov    $0x7,%edi
  805b2f:	48 b8 7d 58 80 00 00 	movabs $0x80587d,%rax
  805b36:	00 00 00 
  805b39:	ff d0                	callq  *%rax
}
  805b3b:	c9                   	leaveq 
  805b3c:	c3                   	retq   

0000000000805b3d <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  805b3d:	55                   	push   %rbp
  805b3e:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  805b41:	be 00 00 00 00       	mov    $0x0,%esi
  805b46:	bf 08 00 00 00       	mov    $0x8,%edi
  805b4b:	48 b8 7d 58 80 00 00 	movabs $0x80587d,%rax
  805b52:	00 00 00 
  805b55:	ff d0                	callq  *%rax
}
  805b57:	5d                   	pop    %rbp
  805b58:	c3                   	retq   

0000000000805b59 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  805b59:	55                   	push   %rbp
  805b5a:	48 89 e5             	mov    %rsp,%rbp
  805b5d:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  805b64:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  805b6b:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  805b72:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  805b79:	be 00 00 00 00       	mov    $0x0,%esi
  805b7e:	48 89 c7             	mov    %rax,%rdi
  805b81:	48 b8 06 59 80 00 00 	movabs $0x805906,%rax
  805b88:	00 00 00 
  805b8b:	ff d0                	callq  *%rax
  805b8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  805b90:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805b94:	79 28                	jns    805bbe <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  805b96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805b99:	89 c6                	mov    %eax,%esi
  805b9b:	48 bf 39 7c 80 00 00 	movabs $0x807c39,%rdi
  805ba2:	00 00 00 
  805ba5:	b8 00 00 00 00       	mov    $0x0,%eax
  805baa:	48 ba 4d 34 80 00 00 	movabs $0x80344d,%rdx
  805bb1:	00 00 00 
  805bb4:	ff d2                	callq  *%rdx
		return fd_src;
  805bb6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805bb9:	e9 74 01 00 00       	jmpq   805d32 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  805bbe:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  805bc5:	be 01 01 00 00       	mov    $0x101,%esi
  805bca:	48 89 c7             	mov    %rax,%rdi
  805bcd:	48 b8 06 59 80 00 00 	movabs $0x805906,%rax
  805bd4:	00 00 00 
  805bd7:	ff d0                	callq  *%rax
  805bd9:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  805bdc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805be0:	79 39                	jns    805c1b <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  805be2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805be5:	89 c6                	mov    %eax,%esi
  805be7:	48 bf 4f 7c 80 00 00 	movabs $0x807c4f,%rdi
  805bee:	00 00 00 
  805bf1:	b8 00 00 00 00       	mov    $0x0,%eax
  805bf6:	48 ba 4d 34 80 00 00 	movabs $0x80344d,%rdx
  805bfd:	00 00 00 
  805c00:	ff d2                	callq  *%rdx
		close(fd_src);
  805c02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c05:	89 c7                	mov    %eax,%edi
  805c07:	48 b8 0c 52 80 00 00 	movabs $0x80520c,%rax
  805c0e:	00 00 00 
  805c11:	ff d0                	callq  *%rax
		return fd_dest;
  805c13:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805c16:	e9 17 01 00 00       	jmpq   805d32 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  805c1b:	eb 74                	jmp    805c91 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  805c1d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805c20:	48 63 d0             	movslq %eax,%rdx
  805c23:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  805c2a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805c2d:	48 89 ce             	mov    %rcx,%rsi
  805c30:	89 c7                	mov    %eax,%edi
  805c32:	48 b8 78 55 80 00 00 	movabs $0x805578,%rax
  805c39:	00 00 00 
  805c3c:	ff d0                	callq  *%rax
  805c3e:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  805c41:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  805c45:	79 4a                	jns    805c91 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  805c47:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805c4a:	89 c6                	mov    %eax,%esi
  805c4c:	48 bf 69 7c 80 00 00 	movabs $0x807c69,%rdi
  805c53:	00 00 00 
  805c56:	b8 00 00 00 00       	mov    $0x0,%eax
  805c5b:	48 ba 4d 34 80 00 00 	movabs $0x80344d,%rdx
  805c62:	00 00 00 
  805c65:	ff d2                	callq  *%rdx
			close(fd_src);
  805c67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c6a:	89 c7                	mov    %eax,%edi
  805c6c:	48 b8 0c 52 80 00 00 	movabs $0x80520c,%rax
  805c73:	00 00 00 
  805c76:	ff d0                	callq  *%rax
			close(fd_dest);
  805c78:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805c7b:	89 c7                	mov    %eax,%edi
  805c7d:	48 b8 0c 52 80 00 00 	movabs $0x80520c,%rax
  805c84:	00 00 00 
  805c87:	ff d0                	callq  *%rax
			return write_size;
  805c89:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805c8c:	e9 a1 00 00 00       	jmpq   805d32 <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  805c91:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  805c98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c9b:	ba 00 02 00 00       	mov    $0x200,%edx
  805ca0:	48 89 ce             	mov    %rcx,%rsi
  805ca3:	89 c7                	mov    %eax,%edi
  805ca5:	48 b8 2e 54 80 00 00 	movabs $0x80542e,%rax
  805cac:	00 00 00 
  805caf:	ff d0                	callq  *%rax
  805cb1:	89 45 f4             	mov    %eax,-0xc(%rbp)
  805cb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  805cb8:	0f 8f 5f ff ff ff    	jg     805c1d <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  805cbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  805cc2:	79 47                	jns    805d0b <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  805cc4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805cc7:	89 c6                	mov    %eax,%esi
  805cc9:	48 bf 7c 7c 80 00 00 	movabs $0x807c7c,%rdi
  805cd0:	00 00 00 
  805cd3:	b8 00 00 00 00       	mov    $0x0,%eax
  805cd8:	48 ba 4d 34 80 00 00 	movabs $0x80344d,%rdx
  805cdf:	00 00 00 
  805ce2:	ff d2                	callq  *%rdx
		close(fd_src);
  805ce4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805ce7:	89 c7                	mov    %eax,%edi
  805ce9:	48 b8 0c 52 80 00 00 	movabs $0x80520c,%rax
  805cf0:	00 00 00 
  805cf3:	ff d0                	callq  *%rax
		close(fd_dest);
  805cf5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805cf8:	89 c7                	mov    %eax,%edi
  805cfa:	48 b8 0c 52 80 00 00 	movabs $0x80520c,%rax
  805d01:	00 00 00 
  805d04:	ff d0                	callq  *%rax
		return read_size;
  805d06:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805d09:	eb 27                	jmp    805d32 <copy+0x1d9>
	}
	close(fd_src);
  805d0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805d0e:	89 c7                	mov    %eax,%edi
  805d10:	48 b8 0c 52 80 00 00 	movabs $0x80520c,%rax
  805d17:	00 00 00 
  805d1a:	ff d0                	callq  *%rax
	close(fd_dest);
  805d1c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805d1f:	89 c7                	mov    %eax,%edi
  805d21:	48 b8 0c 52 80 00 00 	movabs $0x80520c,%rax
  805d28:	00 00 00 
  805d2b:	ff d0                	callq  *%rax
	return 0;
  805d2d:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  805d32:	c9                   	leaveq 
  805d33:	c3                   	retq   

0000000000805d34 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  805d34:	55                   	push   %rbp
  805d35:	48 89 e5             	mov    %rsp,%rbp
  805d38:	48 83 ec 18          	sub    $0x18,%rsp
  805d3c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  805d40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805d44:	48 c1 e8 15          	shr    $0x15,%rax
  805d48:	48 89 c2             	mov    %rax,%rdx
  805d4b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805d52:	01 00 00 
  805d55:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805d59:	83 e0 01             	and    $0x1,%eax
  805d5c:	48 85 c0             	test   %rax,%rax
  805d5f:	75 07                	jne    805d68 <pageref+0x34>
		return 0;
  805d61:	b8 00 00 00 00       	mov    $0x0,%eax
  805d66:	eb 53                	jmp    805dbb <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  805d68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805d6c:	48 c1 e8 0c          	shr    $0xc,%rax
  805d70:	48 89 c2             	mov    %rax,%rdx
  805d73:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805d7a:	01 00 00 
  805d7d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805d81:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  805d85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805d89:	83 e0 01             	and    $0x1,%eax
  805d8c:	48 85 c0             	test   %rax,%rax
  805d8f:	75 07                	jne    805d98 <pageref+0x64>
		return 0;
  805d91:	b8 00 00 00 00       	mov    $0x0,%eax
  805d96:	eb 23                	jmp    805dbb <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  805d98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805d9c:	48 c1 e8 0c          	shr    $0xc,%rax
  805da0:	48 89 c2             	mov    %rax,%rdx
  805da3:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  805daa:	00 00 00 
  805dad:	48 c1 e2 04          	shl    $0x4,%rdx
  805db1:	48 01 d0             	add    %rdx,%rax
  805db4:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  805db8:	0f b7 c0             	movzwl %ax,%eax
}
  805dbb:	c9                   	leaveq 
  805dbc:	c3                   	retq   

0000000000805dbd <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  805dbd:	55                   	push   %rbp
  805dbe:	48 89 e5             	mov    %rsp,%rbp
  805dc1:	48 83 ec 20          	sub    $0x20,%rsp
  805dc5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  805dc8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805dcc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805dcf:	48 89 d6             	mov    %rdx,%rsi
  805dd2:	89 c7                	mov    %eax,%edi
  805dd4:	48 b8 fa 4f 80 00 00 	movabs $0x804ffa,%rax
  805ddb:	00 00 00 
  805dde:	ff d0                	callq  *%rax
  805de0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805de3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805de7:	79 05                	jns    805dee <fd2sockid+0x31>
		return r;
  805de9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805dec:	eb 24                	jmp    805e12 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  805dee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805df2:	8b 10                	mov    (%rax),%edx
  805df4:	48 b8 60 21 81 00 00 	movabs $0x812160,%rax
  805dfb:	00 00 00 
  805dfe:	8b 00                	mov    (%rax),%eax
  805e00:	39 c2                	cmp    %eax,%edx
  805e02:	74 07                	je     805e0b <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  805e04:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805e09:	eb 07                	jmp    805e12 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  805e0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805e0f:	8b 40 0c             	mov    0xc(%rax),%eax
}
  805e12:	c9                   	leaveq 
  805e13:	c3                   	retq   

0000000000805e14 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  805e14:	55                   	push   %rbp
  805e15:	48 89 e5             	mov    %rsp,%rbp
  805e18:	48 83 ec 20          	sub    $0x20,%rsp
  805e1c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  805e1f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  805e23:	48 89 c7             	mov    %rax,%rdi
  805e26:	48 b8 62 4f 80 00 00 	movabs $0x804f62,%rax
  805e2d:	00 00 00 
  805e30:	ff d0                	callq  *%rax
  805e32:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805e35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805e39:	78 26                	js     805e61 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  805e3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805e3f:	ba 07 04 00 00       	mov    $0x407,%edx
  805e44:	48 89 c6             	mov    %rax,%rsi
  805e47:	bf 00 00 00 00       	mov    $0x0,%edi
  805e4c:	48 b8 14 49 80 00 00 	movabs $0x804914,%rax
  805e53:	00 00 00 
  805e56:	ff d0                	callq  *%rax
  805e58:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805e5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805e5f:	79 16                	jns    805e77 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  805e61:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805e64:	89 c7                	mov    %eax,%edi
  805e66:	48 b8 23 63 80 00 00 	movabs $0x806323,%rax
  805e6d:	00 00 00 
  805e70:	ff d0                	callq  *%rax
		return r;
  805e72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805e75:	eb 3a                	jmp    805eb1 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  805e77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805e7b:	48 ba 60 21 81 00 00 	movabs $0x812160,%rdx
  805e82:	00 00 00 
  805e85:	8b 12                	mov    (%rdx),%edx
  805e87:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  805e89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805e8d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  805e94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805e98:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805e9b:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  805e9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805ea2:	48 89 c7             	mov    %rax,%rdi
  805ea5:	48 b8 14 4f 80 00 00 	movabs $0x804f14,%rax
  805eac:	00 00 00 
  805eaf:	ff d0                	callq  *%rax
}
  805eb1:	c9                   	leaveq 
  805eb2:	c3                   	retq   

0000000000805eb3 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  805eb3:	55                   	push   %rbp
  805eb4:	48 89 e5             	mov    %rsp,%rbp
  805eb7:	48 83 ec 30          	sub    $0x30,%rsp
  805ebb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805ebe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805ec2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  805ec6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805ec9:	89 c7                	mov    %eax,%edi
  805ecb:	48 b8 bd 5d 80 00 00 	movabs $0x805dbd,%rax
  805ed2:	00 00 00 
  805ed5:	ff d0                	callq  *%rax
  805ed7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805eda:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805ede:	79 05                	jns    805ee5 <accept+0x32>
		return r;
  805ee0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805ee3:	eb 3b                	jmp    805f20 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  805ee5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805ee9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  805eed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805ef0:	48 89 ce             	mov    %rcx,%rsi
  805ef3:	89 c7                	mov    %eax,%edi
  805ef5:	48 b8 00 62 80 00 00 	movabs $0x806200,%rax
  805efc:	00 00 00 
  805eff:	ff d0                	callq  *%rax
  805f01:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805f04:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805f08:	79 05                	jns    805f0f <accept+0x5c>
		return r;
  805f0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805f0d:	eb 11                	jmp    805f20 <accept+0x6d>
	return alloc_sockfd(r);
  805f0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805f12:	89 c7                	mov    %eax,%edi
  805f14:	48 b8 14 5e 80 00 00 	movabs $0x805e14,%rax
  805f1b:	00 00 00 
  805f1e:	ff d0                	callq  *%rax
}
  805f20:	c9                   	leaveq 
  805f21:	c3                   	retq   

0000000000805f22 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  805f22:	55                   	push   %rbp
  805f23:	48 89 e5             	mov    %rsp,%rbp
  805f26:	48 83 ec 20          	sub    $0x20,%rsp
  805f2a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805f2d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805f31:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  805f34:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805f37:	89 c7                	mov    %eax,%edi
  805f39:	48 b8 bd 5d 80 00 00 	movabs $0x805dbd,%rax
  805f40:	00 00 00 
  805f43:	ff d0                	callq  *%rax
  805f45:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805f48:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805f4c:	79 05                	jns    805f53 <bind+0x31>
		return r;
  805f4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805f51:	eb 1b                	jmp    805f6e <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  805f53:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805f56:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  805f5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805f5d:	48 89 ce             	mov    %rcx,%rsi
  805f60:	89 c7                	mov    %eax,%edi
  805f62:	48 b8 7f 62 80 00 00 	movabs $0x80627f,%rax
  805f69:	00 00 00 
  805f6c:	ff d0                	callq  *%rax
}
  805f6e:	c9                   	leaveq 
  805f6f:	c3                   	retq   

0000000000805f70 <shutdown>:

int
shutdown(int s, int how)
{
  805f70:	55                   	push   %rbp
  805f71:	48 89 e5             	mov    %rsp,%rbp
  805f74:	48 83 ec 20          	sub    $0x20,%rsp
  805f78:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805f7b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  805f7e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805f81:	89 c7                	mov    %eax,%edi
  805f83:	48 b8 bd 5d 80 00 00 	movabs $0x805dbd,%rax
  805f8a:	00 00 00 
  805f8d:	ff d0                	callq  *%rax
  805f8f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805f92:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805f96:	79 05                	jns    805f9d <shutdown+0x2d>
		return r;
  805f98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805f9b:	eb 16                	jmp    805fb3 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  805f9d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805fa0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805fa3:	89 d6                	mov    %edx,%esi
  805fa5:	89 c7                	mov    %eax,%edi
  805fa7:	48 b8 e3 62 80 00 00 	movabs $0x8062e3,%rax
  805fae:	00 00 00 
  805fb1:	ff d0                	callq  *%rax
}
  805fb3:	c9                   	leaveq 
  805fb4:	c3                   	retq   

0000000000805fb5 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  805fb5:	55                   	push   %rbp
  805fb6:	48 89 e5             	mov    %rsp,%rbp
  805fb9:	48 83 ec 10          	sub    $0x10,%rsp
  805fbd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  805fc1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805fc5:	48 89 c7             	mov    %rax,%rdi
  805fc8:	48 b8 34 5d 80 00 00 	movabs $0x805d34,%rax
  805fcf:	00 00 00 
  805fd2:	ff d0                	callq  *%rax
  805fd4:	83 f8 01             	cmp    $0x1,%eax
  805fd7:	75 17                	jne    805ff0 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  805fd9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805fdd:	8b 40 0c             	mov    0xc(%rax),%eax
  805fe0:	89 c7                	mov    %eax,%edi
  805fe2:	48 b8 23 63 80 00 00 	movabs $0x806323,%rax
  805fe9:	00 00 00 
  805fec:	ff d0                	callq  *%rax
  805fee:	eb 05                	jmp    805ff5 <devsock_close+0x40>
	else
		return 0;
  805ff0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805ff5:	c9                   	leaveq 
  805ff6:	c3                   	retq   

0000000000805ff7 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  805ff7:	55                   	push   %rbp
  805ff8:	48 89 e5             	mov    %rsp,%rbp
  805ffb:	48 83 ec 20          	sub    $0x20,%rsp
  805fff:	89 7d ec             	mov    %edi,-0x14(%rbp)
  806002:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  806006:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  806009:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80600c:	89 c7                	mov    %eax,%edi
  80600e:	48 b8 bd 5d 80 00 00 	movabs $0x805dbd,%rax
  806015:	00 00 00 
  806018:	ff d0                	callq  *%rax
  80601a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80601d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806021:	79 05                	jns    806028 <connect+0x31>
		return r;
  806023:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806026:	eb 1b                	jmp    806043 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  806028:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80602b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80602f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806032:	48 89 ce             	mov    %rcx,%rsi
  806035:	89 c7                	mov    %eax,%edi
  806037:	48 b8 50 63 80 00 00 	movabs $0x806350,%rax
  80603e:	00 00 00 
  806041:	ff d0                	callq  *%rax
}
  806043:	c9                   	leaveq 
  806044:	c3                   	retq   

0000000000806045 <listen>:

int
listen(int s, int backlog)
{
  806045:	55                   	push   %rbp
  806046:	48 89 e5             	mov    %rsp,%rbp
  806049:	48 83 ec 20          	sub    $0x20,%rsp
  80604d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  806050:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  806053:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806056:	89 c7                	mov    %eax,%edi
  806058:	48 b8 bd 5d 80 00 00 	movabs $0x805dbd,%rax
  80605f:	00 00 00 
  806062:	ff d0                	callq  *%rax
  806064:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806067:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80606b:	79 05                	jns    806072 <listen+0x2d>
		return r;
  80606d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806070:	eb 16                	jmp    806088 <listen+0x43>
	return nsipc_listen(r, backlog);
  806072:	8b 55 e8             	mov    -0x18(%rbp),%edx
  806075:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806078:	89 d6                	mov    %edx,%esi
  80607a:	89 c7                	mov    %eax,%edi
  80607c:	48 b8 b4 63 80 00 00 	movabs $0x8063b4,%rax
  806083:	00 00 00 
  806086:	ff d0                	callq  *%rax
}
  806088:	c9                   	leaveq 
  806089:	c3                   	retq   

000000000080608a <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80608a:	55                   	push   %rbp
  80608b:	48 89 e5             	mov    %rsp,%rbp
  80608e:	48 83 ec 20          	sub    $0x20,%rsp
  806092:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  806096:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80609a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80609e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8060a2:	89 c2                	mov    %eax,%edx
  8060a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8060a8:	8b 40 0c             	mov    0xc(%rax),%eax
  8060ab:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8060af:	b9 00 00 00 00       	mov    $0x0,%ecx
  8060b4:	89 c7                	mov    %eax,%edi
  8060b6:	48 b8 f4 63 80 00 00 	movabs $0x8063f4,%rax
  8060bd:	00 00 00 
  8060c0:	ff d0                	callq  *%rax
}
  8060c2:	c9                   	leaveq 
  8060c3:	c3                   	retq   

00000000008060c4 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8060c4:	55                   	push   %rbp
  8060c5:	48 89 e5             	mov    %rsp,%rbp
  8060c8:	48 83 ec 20          	sub    $0x20,%rsp
  8060cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8060d0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8060d4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8060d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8060dc:	89 c2                	mov    %eax,%edx
  8060de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8060e2:	8b 40 0c             	mov    0xc(%rax),%eax
  8060e5:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8060e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8060ee:	89 c7                	mov    %eax,%edi
  8060f0:	48 b8 c0 64 80 00 00 	movabs $0x8064c0,%rax
  8060f7:	00 00 00 
  8060fa:	ff d0                	callq  *%rax
}
  8060fc:	c9                   	leaveq 
  8060fd:	c3                   	retq   

00000000008060fe <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8060fe:	55                   	push   %rbp
  8060ff:	48 89 e5             	mov    %rsp,%rbp
  806102:	48 83 ec 10          	sub    $0x10,%rsp
  806106:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80610a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80610e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806112:	48 be 97 7c 80 00 00 	movabs $0x807c97,%rsi
  806119:	00 00 00 
  80611c:	48 89 c7             	mov    %rax,%rdi
  80611f:	48 b8 e7 3f 80 00 00 	movabs $0x803fe7,%rax
  806126:	00 00 00 
  806129:	ff d0                	callq  *%rax
	return 0;
  80612b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806130:	c9                   	leaveq 
  806131:	c3                   	retq   

0000000000806132 <socket>:

int
socket(int domain, int type, int protocol)
{
  806132:	55                   	push   %rbp
  806133:	48 89 e5             	mov    %rsp,%rbp
  806136:	48 83 ec 20          	sub    $0x20,%rsp
  80613a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80613d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  806140:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  806143:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  806146:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  806149:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80614c:	89 ce                	mov    %ecx,%esi
  80614e:	89 c7                	mov    %eax,%edi
  806150:	48 b8 78 65 80 00 00 	movabs $0x806578,%rax
  806157:	00 00 00 
  80615a:	ff d0                	callq  *%rax
  80615c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80615f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806163:	79 05                	jns    80616a <socket+0x38>
		return r;
  806165:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806168:	eb 11                	jmp    80617b <socket+0x49>
	return alloc_sockfd(r);
  80616a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80616d:	89 c7                	mov    %eax,%edi
  80616f:	48 b8 14 5e 80 00 00 	movabs $0x805e14,%rax
  806176:	00 00 00 
  806179:	ff d0                	callq  *%rax
}
  80617b:	c9                   	leaveq 
  80617c:	c3                   	retq   

000000000080617d <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80617d:	55                   	push   %rbp
  80617e:	48 89 e5             	mov    %rsp,%rbp
  806181:	48 83 ec 10          	sub    $0x10,%rsp
  806185:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  806188:	48 b8 0c 50 81 00 00 	movabs $0x81500c,%rax
  80618f:	00 00 00 
  806192:	8b 00                	mov    (%rax),%eax
  806194:	85 c0                	test   %eax,%eax
  806196:	75 1f                	jne    8061b7 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  806198:	bf 02 00 00 00       	mov    $0x2,%edi
  80619d:	48 b8 a2 4e 80 00 00 	movabs $0x804ea2,%rax
  8061a4:	00 00 00 
  8061a7:	ff d0                	callq  *%rax
  8061a9:	89 c2                	mov    %eax,%edx
  8061ab:	48 b8 0c 50 81 00 00 	movabs $0x81500c,%rax
  8061b2:	00 00 00 
  8061b5:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8061b7:	48 b8 0c 50 81 00 00 	movabs $0x81500c,%rax
  8061be:	00 00 00 
  8061c1:	8b 00                	mov    (%rax),%eax
  8061c3:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8061c6:	b9 07 00 00 00       	mov    $0x7,%ecx
  8061cb:	48 ba 00 80 81 00 00 	movabs $0x818000,%rdx
  8061d2:	00 00 00 
  8061d5:	89 c7                	mov    %eax,%edi
  8061d7:	48 b8 15 4d 80 00 00 	movabs $0x804d15,%rax
  8061de:	00 00 00 
  8061e1:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8061e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8061e8:	be 00 00 00 00       	mov    $0x0,%esi
  8061ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8061f2:	48 b8 d7 4c 80 00 00 	movabs $0x804cd7,%rax
  8061f9:	00 00 00 
  8061fc:	ff d0                	callq  *%rax
}
  8061fe:	c9                   	leaveq 
  8061ff:	c3                   	retq   

0000000000806200 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  806200:	55                   	push   %rbp
  806201:	48 89 e5             	mov    %rsp,%rbp
  806204:	48 83 ec 30          	sub    $0x30,%rsp
  806208:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80620b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80620f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  806213:	48 b8 00 80 81 00 00 	movabs $0x818000,%rax
  80621a:	00 00 00 
  80621d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  806220:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  806222:	bf 01 00 00 00       	mov    $0x1,%edi
  806227:	48 b8 7d 61 80 00 00 	movabs $0x80617d,%rax
  80622e:	00 00 00 
  806231:	ff d0                	callq  *%rax
  806233:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806236:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80623a:	78 3e                	js     80627a <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80623c:	48 b8 00 80 81 00 00 	movabs $0x818000,%rax
  806243:	00 00 00 
  806246:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80624a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80624e:	8b 40 10             	mov    0x10(%rax),%eax
  806251:	89 c2                	mov    %eax,%edx
  806253:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  806257:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80625b:	48 89 ce             	mov    %rcx,%rsi
  80625e:	48 89 c7             	mov    %rax,%rdi
  806261:	48 b8 0b 43 80 00 00 	movabs $0x80430b,%rax
  806268:	00 00 00 
  80626b:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80626d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806271:	8b 50 10             	mov    0x10(%rax),%edx
  806274:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806278:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80627a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80627d:	c9                   	leaveq 
  80627e:	c3                   	retq   

000000000080627f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80627f:	55                   	push   %rbp
  806280:	48 89 e5             	mov    %rsp,%rbp
  806283:	48 83 ec 10          	sub    $0x10,%rsp
  806287:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80628a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80628e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  806291:	48 b8 00 80 81 00 00 	movabs $0x818000,%rax
  806298:	00 00 00 
  80629b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80629e:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8062a0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8062a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8062a7:	48 89 c6             	mov    %rax,%rsi
  8062aa:	48 bf 04 80 81 00 00 	movabs $0x818004,%rdi
  8062b1:	00 00 00 
  8062b4:	48 b8 0b 43 80 00 00 	movabs $0x80430b,%rax
  8062bb:	00 00 00 
  8062be:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8062c0:	48 b8 00 80 81 00 00 	movabs $0x818000,%rax
  8062c7:	00 00 00 
  8062ca:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8062cd:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8062d0:	bf 02 00 00 00       	mov    $0x2,%edi
  8062d5:	48 b8 7d 61 80 00 00 	movabs $0x80617d,%rax
  8062dc:	00 00 00 
  8062df:	ff d0                	callq  *%rax
}
  8062e1:	c9                   	leaveq 
  8062e2:	c3                   	retq   

00000000008062e3 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8062e3:	55                   	push   %rbp
  8062e4:	48 89 e5             	mov    %rsp,%rbp
  8062e7:	48 83 ec 10          	sub    $0x10,%rsp
  8062eb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8062ee:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8062f1:	48 b8 00 80 81 00 00 	movabs $0x818000,%rax
  8062f8:	00 00 00 
  8062fb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8062fe:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  806300:	48 b8 00 80 81 00 00 	movabs $0x818000,%rax
  806307:	00 00 00 
  80630a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80630d:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  806310:	bf 03 00 00 00       	mov    $0x3,%edi
  806315:	48 b8 7d 61 80 00 00 	movabs $0x80617d,%rax
  80631c:	00 00 00 
  80631f:	ff d0                	callq  *%rax
}
  806321:	c9                   	leaveq 
  806322:	c3                   	retq   

0000000000806323 <nsipc_close>:

int
nsipc_close(int s)
{
  806323:	55                   	push   %rbp
  806324:	48 89 e5             	mov    %rsp,%rbp
  806327:	48 83 ec 10          	sub    $0x10,%rsp
  80632b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80632e:	48 b8 00 80 81 00 00 	movabs $0x818000,%rax
  806335:	00 00 00 
  806338:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80633b:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80633d:	bf 04 00 00 00       	mov    $0x4,%edi
  806342:	48 b8 7d 61 80 00 00 	movabs $0x80617d,%rax
  806349:	00 00 00 
  80634c:	ff d0                	callq  *%rax
}
  80634e:	c9                   	leaveq 
  80634f:	c3                   	retq   

0000000000806350 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  806350:	55                   	push   %rbp
  806351:	48 89 e5             	mov    %rsp,%rbp
  806354:	48 83 ec 10          	sub    $0x10,%rsp
  806358:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80635b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80635f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  806362:	48 b8 00 80 81 00 00 	movabs $0x818000,%rax
  806369:	00 00 00 
  80636c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80636f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  806371:	8b 55 f8             	mov    -0x8(%rbp),%edx
  806374:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806378:	48 89 c6             	mov    %rax,%rsi
  80637b:	48 bf 04 80 81 00 00 	movabs $0x818004,%rdi
  806382:	00 00 00 
  806385:	48 b8 0b 43 80 00 00 	movabs $0x80430b,%rax
  80638c:	00 00 00 
  80638f:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  806391:	48 b8 00 80 81 00 00 	movabs $0x818000,%rax
  806398:	00 00 00 
  80639b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80639e:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8063a1:	bf 05 00 00 00       	mov    $0x5,%edi
  8063a6:	48 b8 7d 61 80 00 00 	movabs $0x80617d,%rax
  8063ad:	00 00 00 
  8063b0:	ff d0                	callq  *%rax
}
  8063b2:	c9                   	leaveq 
  8063b3:	c3                   	retq   

00000000008063b4 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8063b4:	55                   	push   %rbp
  8063b5:	48 89 e5             	mov    %rsp,%rbp
  8063b8:	48 83 ec 10          	sub    $0x10,%rsp
  8063bc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8063bf:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8063c2:	48 b8 00 80 81 00 00 	movabs $0x818000,%rax
  8063c9:	00 00 00 
  8063cc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8063cf:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8063d1:	48 b8 00 80 81 00 00 	movabs $0x818000,%rax
  8063d8:	00 00 00 
  8063db:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8063de:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8063e1:	bf 06 00 00 00       	mov    $0x6,%edi
  8063e6:	48 b8 7d 61 80 00 00 	movabs $0x80617d,%rax
  8063ed:	00 00 00 
  8063f0:	ff d0                	callq  *%rax
}
  8063f2:	c9                   	leaveq 
  8063f3:	c3                   	retq   

00000000008063f4 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8063f4:	55                   	push   %rbp
  8063f5:	48 89 e5             	mov    %rsp,%rbp
  8063f8:	48 83 ec 30          	sub    $0x30,%rsp
  8063fc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8063ff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  806403:	89 55 e8             	mov    %edx,-0x18(%rbp)
  806406:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  806409:	48 b8 00 80 81 00 00 	movabs $0x818000,%rax
  806410:	00 00 00 
  806413:	8b 55 ec             	mov    -0x14(%rbp),%edx
  806416:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  806418:	48 b8 00 80 81 00 00 	movabs $0x818000,%rax
  80641f:	00 00 00 
  806422:	8b 55 e8             	mov    -0x18(%rbp),%edx
  806425:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  806428:	48 b8 00 80 81 00 00 	movabs $0x818000,%rax
  80642f:	00 00 00 
  806432:	8b 55 dc             	mov    -0x24(%rbp),%edx
  806435:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  806438:	bf 07 00 00 00       	mov    $0x7,%edi
  80643d:	48 b8 7d 61 80 00 00 	movabs $0x80617d,%rax
  806444:	00 00 00 
  806447:	ff d0                	callq  *%rax
  806449:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80644c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806450:	78 69                	js     8064bb <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  806452:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  806459:	7f 08                	jg     806463 <nsipc_recv+0x6f>
  80645b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80645e:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  806461:	7e 35                	jle    806498 <nsipc_recv+0xa4>
  806463:	48 b9 9e 7c 80 00 00 	movabs $0x807c9e,%rcx
  80646a:	00 00 00 
  80646d:	48 ba b3 7c 80 00 00 	movabs $0x807cb3,%rdx
  806474:	00 00 00 
  806477:	be 61 00 00 00       	mov    $0x61,%esi
  80647c:	48 bf c8 7c 80 00 00 	movabs $0x807cc8,%rdi
  806483:	00 00 00 
  806486:	b8 00 00 00 00       	mov    $0x0,%eax
  80648b:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  806492:	00 00 00 
  806495:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  806498:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80649b:	48 63 d0             	movslq %eax,%rdx
  80649e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8064a2:	48 be 00 80 81 00 00 	movabs $0x818000,%rsi
  8064a9:	00 00 00 
  8064ac:	48 89 c7             	mov    %rax,%rdi
  8064af:	48 b8 0b 43 80 00 00 	movabs $0x80430b,%rax
  8064b6:	00 00 00 
  8064b9:	ff d0                	callq  *%rax
	}

	return r;
  8064bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8064be:	c9                   	leaveq 
  8064bf:	c3                   	retq   

00000000008064c0 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8064c0:	55                   	push   %rbp
  8064c1:	48 89 e5             	mov    %rsp,%rbp
  8064c4:	48 83 ec 20          	sub    $0x20,%rsp
  8064c8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8064cb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8064cf:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8064d2:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8064d5:	48 b8 00 80 81 00 00 	movabs $0x818000,%rax
  8064dc:	00 00 00 
  8064df:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8064e2:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8064e4:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8064eb:	7e 35                	jle    806522 <nsipc_send+0x62>
  8064ed:	48 b9 d4 7c 80 00 00 	movabs $0x807cd4,%rcx
  8064f4:	00 00 00 
  8064f7:	48 ba b3 7c 80 00 00 	movabs $0x807cb3,%rdx
  8064fe:	00 00 00 
  806501:	be 6c 00 00 00       	mov    $0x6c,%esi
  806506:	48 bf c8 7c 80 00 00 	movabs $0x807cc8,%rdi
  80650d:	00 00 00 
  806510:	b8 00 00 00 00       	mov    $0x0,%eax
  806515:	49 b8 14 32 80 00 00 	movabs $0x803214,%r8
  80651c:	00 00 00 
  80651f:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  806522:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806525:	48 63 d0             	movslq %eax,%rdx
  806528:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80652c:	48 89 c6             	mov    %rax,%rsi
  80652f:	48 bf 0c 80 81 00 00 	movabs $0x81800c,%rdi
  806536:	00 00 00 
  806539:	48 b8 0b 43 80 00 00 	movabs $0x80430b,%rax
  806540:	00 00 00 
  806543:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  806545:	48 b8 00 80 81 00 00 	movabs $0x818000,%rax
  80654c:	00 00 00 
  80654f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  806552:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  806555:	48 b8 00 80 81 00 00 	movabs $0x818000,%rax
  80655c:	00 00 00 
  80655f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  806562:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  806565:	bf 08 00 00 00       	mov    $0x8,%edi
  80656a:	48 b8 7d 61 80 00 00 	movabs $0x80617d,%rax
  806571:	00 00 00 
  806574:	ff d0                	callq  *%rax
}
  806576:	c9                   	leaveq 
  806577:	c3                   	retq   

0000000000806578 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  806578:	55                   	push   %rbp
  806579:	48 89 e5             	mov    %rsp,%rbp
  80657c:	48 83 ec 10          	sub    $0x10,%rsp
  806580:	89 7d fc             	mov    %edi,-0x4(%rbp)
  806583:	89 75 f8             	mov    %esi,-0x8(%rbp)
  806586:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  806589:	48 b8 00 80 81 00 00 	movabs $0x818000,%rax
  806590:	00 00 00 
  806593:	8b 55 fc             	mov    -0x4(%rbp),%edx
  806596:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  806598:	48 b8 00 80 81 00 00 	movabs $0x818000,%rax
  80659f:	00 00 00 
  8065a2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8065a5:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8065a8:	48 b8 00 80 81 00 00 	movabs $0x818000,%rax
  8065af:	00 00 00 
  8065b2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8065b5:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8065b8:	bf 09 00 00 00       	mov    $0x9,%edi
  8065bd:	48 b8 7d 61 80 00 00 	movabs $0x80617d,%rax
  8065c4:	00 00 00 
  8065c7:	ff d0                	callq  *%rax
}
  8065c9:	c9                   	leaveq 
  8065ca:	c3                   	retq   

00000000008065cb <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8065cb:	55                   	push   %rbp
  8065cc:	48 89 e5             	mov    %rsp,%rbp
  8065cf:	53                   	push   %rbx
  8065d0:	48 83 ec 38          	sub    $0x38,%rsp
  8065d4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8065d8:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8065dc:	48 89 c7             	mov    %rax,%rdi
  8065df:	48 b8 62 4f 80 00 00 	movabs $0x804f62,%rax
  8065e6:	00 00 00 
  8065e9:	ff d0                	callq  *%rax
  8065eb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8065ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8065f2:	0f 88 bf 01 00 00    	js     8067b7 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8065f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8065fc:	ba 07 04 00 00       	mov    $0x407,%edx
  806601:	48 89 c6             	mov    %rax,%rsi
  806604:	bf 00 00 00 00       	mov    $0x0,%edi
  806609:	48 b8 14 49 80 00 00 	movabs $0x804914,%rax
  806610:	00 00 00 
  806613:	ff d0                	callq  *%rax
  806615:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806618:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80661c:	0f 88 95 01 00 00    	js     8067b7 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  806622:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  806626:	48 89 c7             	mov    %rax,%rdi
  806629:	48 b8 62 4f 80 00 00 	movabs $0x804f62,%rax
  806630:	00 00 00 
  806633:	ff d0                	callq  *%rax
  806635:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806638:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80663c:	0f 88 5d 01 00 00    	js     80679f <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806642:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806646:	ba 07 04 00 00       	mov    $0x407,%edx
  80664b:	48 89 c6             	mov    %rax,%rsi
  80664e:	bf 00 00 00 00       	mov    $0x0,%edi
  806653:	48 b8 14 49 80 00 00 	movabs $0x804914,%rax
  80665a:	00 00 00 
  80665d:	ff d0                	callq  *%rax
  80665f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806662:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806666:	0f 88 33 01 00 00    	js     80679f <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80666c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806670:	48 89 c7             	mov    %rax,%rdi
  806673:	48 b8 37 4f 80 00 00 	movabs $0x804f37,%rax
  80667a:	00 00 00 
  80667d:	ff d0                	callq  *%rax
  80667f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806683:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806687:	ba 07 04 00 00       	mov    $0x407,%edx
  80668c:	48 89 c6             	mov    %rax,%rsi
  80668f:	bf 00 00 00 00       	mov    $0x0,%edi
  806694:	48 b8 14 49 80 00 00 	movabs $0x804914,%rax
  80669b:	00 00 00 
  80669e:	ff d0                	callq  *%rax
  8066a0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8066a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8066a7:	79 05                	jns    8066ae <pipe+0xe3>
		goto err2;
  8066a9:	e9 d9 00 00 00       	jmpq   806787 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8066ae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8066b2:	48 89 c7             	mov    %rax,%rdi
  8066b5:	48 b8 37 4f 80 00 00 	movabs $0x804f37,%rax
  8066bc:	00 00 00 
  8066bf:	ff d0                	callq  *%rax
  8066c1:	48 89 c2             	mov    %rax,%rdx
  8066c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8066c8:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8066ce:	48 89 d1             	mov    %rdx,%rcx
  8066d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8066d6:	48 89 c6             	mov    %rax,%rsi
  8066d9:	bf 00 00 00 00       	mov    $0x0,%edi
  8066de:	48 b8 66 49 80 00 00 	movabs $0x804966,%rax
  8066e5:	00 00 00 
  8066e8:	ff d0                	callq  *%rax
  8066ea:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8066ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8066f1:	79 1b                	jns    80670e <pipe+0x143>
		goto err3;
  8066f3:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8066f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8066f8:	48 89 c6             	mov    %rax,%rsi
  8066fb:	bf 00 00 00 00       	mov    $0x0,%edi
  806700:	48 b8 c6 49 80 00 00 	movabs $0x8049c6,%rax
  806707:	00 00 00 
  80670a:	ff d0                	callq  *%rax
  80670c:	eb 79                	jmp    806787 <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  80670e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806712:	48 ba a0 21 81 00 00 	movabs $0x8121a0,%rdx
  806719:	00 00 00 
  80671c:	8b 12                	mov    (%rdx),%edx
  80671e:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  806720:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806724:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  80672b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80672f:	48 ba a0 21 81 00 00 	movabs $0x8121a0,%rdx
  806736:	00 00 00 
  806739:	8b 12                	mov    (%rdx),%edx
  80673b:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80673d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806741:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  806748:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80674c:	48 89 c7             	mov    %rax,%rdi
  80674f:	48 b8 14 4f 80 00 00 	movabs $0x804f14,%rax
  806756:	00 00 00 
  806759:	ff d0                	callq  *%rax
  80675b:	89 c2                	mov    %eax,%edx
  80675d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  806761:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  806763:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  806767:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80676b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80676f:	48 89 c7             	mov    %rax,%rdi
  806772:	48 b8 14 4f 80 00 00 	movabs $0x804f14,%rax
  806779:	00 00 00 
  80677c:	ff d0                	callq  *%rax
  80677e:	89 03                	mov    %eax,(%rbx)
	return 0;
  806780:	b8 00 00 00 00       	mov    $0x0,%eax
  806785:	eb 33                	jmp    8067ba <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  806787:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80678b:	48 89 c6             	mov    %rax,%rsi
  80678e:	bf 00 00 00 00       	mov    $0x0,%edi
  806793:	48 b8 c6 49 80 00 00 	movabs $0x8049c6,%rax
  80679a:	00 00 00 
  80679d:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80679f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8067a3:	48 89 c6             	mov    %rax,%rsi
  8067a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8067ab:	48 b8 c6 49 80 00 00 	movabs $0x8049c6,%rax
  8067b2:	00 00 00 
  8067b5:	ff d0                	callq  *%rax
err:
	return r;
  8067b7:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8067ba:	48 83 c4 38          	add    $0x38,%rsp
  8067be:	5b                   	pop    %rbx
  8067bf:	5d                   	pop    %rbp
  8067c0:	c3                   	retq   

00000000008067c1 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8067c1:	55                   	push   %rbp
  8067c2:	48 89 e5             	mov    %rsp,%rbp
  8067c5:	53                   	push   %rbx
  8067c6:	48 83 ec 28          	sub    $0x28,%rsp
  8067ca:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8067ce:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8067d2:	48 b8 20 50 81 00 00 	movabs $0x815020,%rax
  8067d9:	00 00 00 
  8067dc:	48 8b 00             	mov    (%rax),%rax
  8067df:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8067e5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8067e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8067ec:	48 89 c7             	mov    %rax,%rdi
  8067ef:	48 b8 34 5d 80 00 00 	movabs $0x805d34,%rax
  8067f6:	00 00 00 
  8067f9:	ff d0                	callq  *%rax
  8067fb:	89 c3                	mov    %eax,%ebx
  8067fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806801:	48 89 c7             	mov    %rax,%rdi
  806804:	48 b8 34 5d 80 00 00 	movabs $0x805d34,%rax
  80680b:	00 00 00 
  80680e:	ff d0                	callq  *%rax
  806810:	39 c3                	cmp    %eax,%ebx
  806812:	0f 94 c0             	sete   %al
  806815:	0f b6 c0             	movzbl %al,%eax
  806818:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80681b:	48 b8 20 50 81 00 00 	movabs $0x815020,%rax
  806822:	00 00 00 
  806825:	48 8b 00             	mov    (%rax),%rax
  806828:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80682e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  806831:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806834:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  806837:	75 05                	jne    80683e <_pipeisclosed+0x7d>
			return ret;
  806839:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80683c:	eb 4a                	jmp    806888 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  80683e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806841:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  806844:	74 3d                	je     806883 <_pipeisclosed+0xc2>
  806846:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80684a:	75 37                	jne    806883 <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80684c:	48 b8 20 50 81 00 00 	movabs $0x815020,%rax
  806853:	00 00 00 
  806856:	48 8b 00             	mov    (%rax),%rax
  806859:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80685f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  806862:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806865:	89 c6                	mov    %eax,%esi
  806867:	48 bf e5 7c 80 00 00 	movabs $0x807ce5,%rdi
  80686e:	00 00 00 
  806871:	b8 00 00 00 00       	mov    $0x0,%eax
  806876:	49 b8 4d 34 80 00 00 	movabs $0x80344d,%r8
  80687d:	00 00 00 
  806880:	41 ff d0             	callq  *%r8
	}
  806883:	e9 4a ff ff ff       	jmpq   8067d2 <_pipeisclosed+0x11>
}
  806888:	48 83 c4 28          	add    $0x28,%rsp
  80688c:	5b                   	pop    %rbx
  80688d:	5d                   	pop    %rbp
  80688e:	c3                   	retq   

000000000080688f <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80688f:	55                   	push   %rbp
  806890:	48 89 e5             	mov    %rsp,%rbp
  806893:	48 83 ec 30          	sub    $0x30,%rsp
  806897:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80689a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80689e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8068a1:	48 89 d6             	mov    %rdx,%rsi
  8068a4:	89 c7                	mov    %eax,%edi
  8068a6:	48 b8 fa 4f 80 00 00 	movabs $0x804ffa,%rax
  8068ad:	00 00 00 
  8068b0:	ff d0                	callq  *%rax
  8068b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8068b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8068b9:	79 05                	jns    8068c0 <pipeisclosed+0x31>
		return r;
  8068bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8068be:	eb 31                	jmp    8068f1 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8068c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8068c4:	48 89 c7             	mov    %rax,%rdi
  8068c7:	48 b8 37 4f 80 00 00 	movabs $0x804f37,%rax
  8068ce:	00 00 00 
  8068d1:	ff d0                	callq  *%rax
  8068d3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8068d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8068db:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8068df:	48 89 d6             	mov    %rdx,%rsi
  8068e2:	48 89 c7             	mov    %rax,%rdi
  8068e5:	48 b8 c1 67 80 00 00 	movabs $0x8067c1,%rax
  8068ec:	00 00 00 
  8068ef:	ff d0                	callq  *%rax
}
  8068f1:	c9                   	leaveq 
  8068f2:	c3                   	retq   

00000000008068f3 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8068f3:	55                   	push   %rbp
  8068f4:	48 89 e5             	mov    %rsp,%rbp
  8068f7:	48 83 ec 40          	sub    $0x40,%rsp
  8068fb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8068ff:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  806903:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  806907:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80690b:	48 89 c7             	mov    %rax,%rdi
  80690e:	48 b8 37 4f 80 00 00 	movabs $0x804f37,%rax
  806915:	00 00 00 
  806918:	ff d0                	callq  *%rax
  80691a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80691e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806922:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  806926:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80692d:	00 
  80692e:	e9 92 00 00 00       	jmpq   8069c5 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  806933:	eb 41                	jmp    806976 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  806935:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80693a:	74 09                	je     806945 <devpipe_read+0x52>
				return i;
  80693c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806940:	e9 92 00 00 00       	jmpq   8069d7 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  806945:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806949:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80694d:	48 89 d6             	mov    %rdx,%rsi
  806950:	48 89 c7             	mov    %rax,%rdi
  806953:	48 b8 c1 67 80 00 00 	movabs $0x8067c1,%rax
  80695a:	00 00 00 
  80695d:	ff d0                	callq  *%rax
  80695f:	85 c0                	test   %eax,%eax
  806961:	74 07                	je     80696a <devpipe_read+0x77>
				return 0;
  806963:	b8 00 00 00 00       	mov    $0x0,%eax
  806968:	eb 6d                	jmp    8069d7 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80696a:	48 b8 d8 48 80 00 00 	movabs $0x8048d8,%rax
  806971:	00 00 00 
  806974:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  806976:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80697a:	8b 10                	mov    (%rax),%edx
  80697c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806980:	8b 40 04             	mov    0x4(%rax),%eax
  806983:	39 c2                	cmp    %eax,%edx
  806985:	74 ae                	je     806935 <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  806987:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80698b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80698f:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  806993:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806997:	8b 00                	mov    (%rax),%eax
  806999:	99                   	cltd   
  80699a:	c1 ea 1b             	shr    $0x1b,%edx
  80699d:	01 d0                	add    %edx,%eax
  80699f:	83 e0 1f             	and    $0x1f,%eax
  8069a2:	29 d0                	sub    %edx,%eax
  8069a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8069a8:	48 98                	cltq   
  8069aa:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8069af:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8069b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8069b5:	8b 00                	mov    (%rax),%eax
  8069b7:	8d 50 01             	lea    0x1(%rax),%edx
  8069ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8069be:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  8069c0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8069c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8069c9:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8069cd:	0f 82 60 ff ff ff    	jb     806933 <devpipe_read+0x40>
	}
	return i;
  8069d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8069d7:	c9                   	leaveq 
  8069d8:	c3                   	retq   

00000000008069d9 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8069d9:	55                   	push   %rbp
  8069da:	48 89 e5             	mov    %rsp,%rbp
  8069dd:	48 83 ec 40          	sub    $0x40,%rsp
  8069e1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8069e5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8069e9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8069ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8069f1:	48 89 c7             	mov    %rax,%rdi
  8069f4:	48 b8 37 4f 80 00 00 	movabs $0x804f37,%rax
  8069fb:	00 00 00 
  8069fe:	ff d0                	callq  *%rax
  806a00:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  806a04:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806a08:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  806a0c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  806a13:	00 
  806a14:	e9 91 00 00 00       	jmpq   806aaa <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  806a19:	eb 31                	jmp    806a4c <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  806a1b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806a1f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806a23:	48 89 d6             	mov    %rdx,%rsi
  806a26:	48 89 c7             	mov    %rax,%rdi
  806a29:	48 b8 c1 67 80 00 00 	movabs $0x8067c1,%rax
  806a30:	00 00 00 
  806a33:	ff d0                	callq  *%rax
  806a35:	85 c0                	test   %eax,%eax
  806a37:	74 07                	je     806a40 <devpipe_write+0x67>
				return 0;
  806a39:	b8 00 00 00 00       	mov    $0x0,%eax
  806a3e:	eb 7c                	jmp    806abc <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  806a40:	48 b8 d8 48 80 00 00 	movabs $0x8048d8,%rax
  806a47:	00 00 00 
  806a4a:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  806a4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806a50:	8b 40 04             	mov    0x4(%rax),%eax
  806a53:	48 63 d0             	movslq %eax,%rdx
  806a56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806a5a:	8b 00                	mov    (%rax),%eax
  806a5c:	48 98                	cltq   
  806a5e:	48 83 c0 20          	add    $0x20,%rax
  806a62:	48 39 c2             	cmp    %rax,%rdx
  806a65:	73 b4                	jae    806a1b <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  806a67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806a6b:	8b 40 04             	mov    0x4(%rax),%eax
  806a6e:	99                   	cltd   
  806a6f:	c1 ea 1b             	shr    $0x1b,%edx
  806a72:	01 d0                	add    %edx,%eax
  806a74:	83 e0 1f             	and    $0x1f,%eax
  806a77:	29 d0                	sub    %edx,%eax
  806a79:	89 c6                	mov    %eax,%esi
  806a7b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  806a7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806a83:	48 01 d0             	add    %rdx,%rax
  806a86:	0f b6 08             	movzbl (%rax),%ecx
  806a89:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806a8d:	48 63 c6             	movslq %esi,%rax
  806a90:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  806a94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806a98:	8b 40 04             	mov    0x4(%rax),%eax
  806a9b:	8d 50 01             	lea    0x1(%rax),%edx
  806a9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806aa2:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  806aa5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  806aaa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806aae:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  806ab2:	0f 82 61 ff ff ff    	jb     806a19 <devpipe_write+0x40>
	}

	return i;
  806ab8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  806abc:	c9                   	leaveq 
  806abd:	c3                   	retq   

0000000000806abe <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  806abe:	55                   	push   %rbp
  806abf:	48 89 e5             	mov    %rsp,%rbp
  806ac2:	48 83 ec 20          	sub    $0x20,%rsp
  806ac6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  806aca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  806ace:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806ad2:	48 89 c7             	mov    %rax,%rdi
  806ad5:	48 b8 37 4f 80 00 00 	movabs $0x804f37,%rax
  806adc:	00 00 00 
  806adf:	ff d0                	callq  *%rax
  806ae1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  806ae5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806ae9:	48 be f8 7c 80 00 00 	movabs $0x807cf8,%rsi
  806af0:	00 00 00 
  806af3:	48 89 c7             	mov    %rax,%rdi
  806af6:	48 b8 e7 3f 80 00 00 	movabs $0x803fe7,%rax
  806afd:	00 00 00 
  806b00:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  806b02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806b06:	8b 50 04             	mov    0x4(%rax),%edx
  806b09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806b0d:	8b 00                	mov    (%rax),%eax
  806b0f:	29 c2                	sub    %eax,%edx
  806b11:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806b15:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  806b1b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806b1f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  806b26:	00 00 00 
	stat->st_dev = &devpipe;
  806b29:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806b2d:	48 b9 a0 21 81 00 00 	movabs $0x8121a0,%rcx
  806b34:	00 00 00 
  806b37:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  806b3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806b43:	c9                   	leaveq 
  806b44:	c3                   	retq   

0000000000806b45 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  806b45:	55                   	push   %rbp
  806b46:	48 89 e5             	mov    %rsp,%rbp
  806b49:	48 83 ec 10          	sub    $0x10,%rsp
  806b4d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  806b51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806b55:	48 89 c6             	mov    %rax,%rsi
  806b58:	bf 00 00 00 00       	mov    $0x0,%edi
  806b5d:	48 b8 c6 49 80 00 00 	movabs $0x8049c6,%rax
  806b64:	00 00 00 
  806b67:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  806b69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806b6d:	48 89 c7             	mov    %rax,%rdi
  806b70:	48 b8 37 4f 80 00 00 	movabs $0x804f37,%rax
  806b77:	00 00 00 
  806b7a:	ff d0                	callq  *%rax
  806b7c:	48 89 c6             	mov    %rax,%rsi
  806b7f:	bf 00 00 00 00       	mov    $0x0,%edi
  806b84:	48 b8 c6 49 80 00 00 	movabs $0x8049c6,%rax
  806b8b:	00 00 00 
  806b8e:	ff d0                	callq  *%rax
}
  806b90:	c9                   	leaveq 
  806b91:	c3                   	retq   

0000000000806b92 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  806b92:	55                   	push   %rbp
  806b93:	48 89 e5             	mov    %rsp,%rbp
  806b96:	48 83 ec 20          	sub    $0x20,%rsp
  806b9a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  806b9d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806ba0:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  806ba3:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  806ba7:	be 01 00 00 00       	mov    $0x1,%esi
  806bac:	48 89 c7             	mov    %rax,%rdi
  806baf:	48 b8 ce 47 80 00 00 	movabs $0x8047ce,%rax
  806bb6:	00 00 00 
  806bb9:	ff d0                	callq  *%rax
}
  806bbb:	c9                   	leaveq 
  806bbc:	c3                   	retq   

0000000000806bbd <getchar>:

int
getchar(void)
{
  806bbd:	55                   	push   %rbp
  806bbe:	48 89 e5             	mov    %rsp,%rbp
  806bc1:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  806bc5:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  806bc9:	ba 01 00 00 00       	mov    $0x1,%edx
  806bce:	48 89 c6             	mov    %rax,%rsi
  806bd1:	bf 00 00 00 00       	mov    $0x0,%edi
  806bd6:	48 b8 2e 54 80 00 00 	movabs $0x80542e,%rax
  806bdd:	00 00 00 
  806be0:	ff d0                	callq  *%rax
  806be2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  806be5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806be9:	79 05                	jns    806bf0 <getchar+0x33>
		return r;
  806beb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806bee:	eb 14                	jmp    806c04 <getchar+0x47>
	if (r < 1)
  806bf0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806bf4:	7f 07                	jg     806bfd <getchar+0x40>
		return -E_EOF;
  806bf6:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  806bfb:	eb 07                	jmp    806c04 <getchar+0x47>
	return c;
  806bfd:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  806c01:	0f b6 c0             	movzbl %al,%eax
}
  806c04:	c9                   	leaveq 
  806c05:	c3                   	retq   

0000000000806c06 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  806c06:	55                   	push   %rbp
  806c07:	48 89 e5             	mov    %rsp,%rbp
  806c0a:	48 83 ec 20          	sub    $0x20,%rsp
  806c0e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  806c11:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  806c15:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806c18:	48 89 d6             	mov    %rdx,%rsi
  806c1b:	89 c7                	mov    %eax,%edi
  806c1d:	48 b8 fa 4f 80 00 00 	movabs $0x804ffa,%rax
  806c24:	00 00 00 
  806c27:	ff d0                	callq  *%rax
  806c29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806c2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806c30:	79 05                	jns    806c37 <iscons+0x31>
		return r;
  806c32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806c35:	eb 1a                	jmp    806c51 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  806c37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806c3b:	8b 10                	mov    (%rax),%edx
  806c3d:	48 b8 e0 21 81 00 00 	movabs $0x8121e0,%rax
  806c44:	00 00 00 
  806c47:	8b 00                	mov    (%rax),%eax
  806c49:	39 c2                	cmp    %eax,%edx
  806c4b:	0f 94 c0             	sete   %al
  806c4e:	0f b6 c0             	movzbl %al,%eax
}
  806c51:	c9                   	leaveq 
  806c52:	c3                   	retq   

0000000000806c53 <opencons>:

int
opencons(void)
{
  806c53:	55                   	push   %rbp
  806c54:	48 89 e5             	mov    %rsp,%rbp
  806c57:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  806c5b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  806c5f:	48 89 c7             	mov    %rax,%rdi
  806c62:	48 b8 62 4f 80 00 00 	movabs $0x804f62,%rax
  806c69:	00 00 00 
  806c6c:	ff d0                	callq  *%rax
  806c6e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806c71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806c75:	79 05                	jns    806c7c <opencons+0x29>
		return r;
  806c77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806c7a:	eb 5b                	jmp    806cd7 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  806c7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806c80:	ba 07 04 00 00       	mov    $0x407,%edx
  806c85:	48 89 c6             	mov    %rax,%rsi
  806c88:	bf 00 00 00 00       	mov    $0x0,%edi
  806c8d:	48 b8 14 49 80 00 00 	movabs $0x804914,%rax
  806c94:	00 00 00 
  806c97:	ff d0                	callq  *%rax
  806c99:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806c9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806ca0:	79 05                	jns    806ca7 <opencons+0x54>
		return r;
  806ca2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806ca5:	eb 30                	jmp    806cd7 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  806ca7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806cab:	48 ba e0 21 81 00 00 	movabs $0x8121e0,%rdx
  806cb2:	00 00 00 
  806cb5:	8b 12                	mov    (%rdx),%edx
  806cb7:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  806cb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806cbd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  806cc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806cc8:	48 89 c7             	mov    %rax,%rdi
  806ccb:	48 b8 14 4f 80 00 00 	movabs $0x804f14,%rax
  806cd2:	00 00 00 
  806cd5:	ff d0                	callq  *%rax
}
  806cd7:	c9                   	leaveq 
  806cd8:	c3                   	retq   

0000000000806cd9 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  806cd9:	55                   	push   %rbp
  806cda:	48 89 e5             	mov    %rsp,%rbp
  806cdd:	48 83 ec 30          	sub    $0x30,%rsp
  806ce1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  806ce5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  806ce9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  806ced:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  806cf2:	75 07                	jne    806cfb <devcons_read+0x22>
		return 0;
  806cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  806cf9:	eb 4b                	jmp    806d46 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  806cfb:	eb 0c                	jmp    806d09 <devcons_read+0x30>
		sys_yield();
  806cfd:	48 b8 d8 48 80 00 00 	movabs $0x8048d8,%rax
  806d04:	00 00 00 
  806d07:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  806d09:	48 b8 1a 48 80 00 00 	movabs $0x80481a,%rax
  806d10:	00 00 00 
  806d13:	ff d0                	callq  *%rax
  806d15:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806d18:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806d1c:	74 df                	je     806cfd <devcons_read+0x24>
	if (c < 0)
  806d1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806d22:	79 05                	jns    806d29 <devcons_read+0x50>
		return c;
  806d24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806d27:	eb 1d                	jmp    806d46 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  806d29:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  806d2d:	75 07                	jne    806d36 <devcons_read+0x5d>
		return 0;
  806d2f:	b8 00 00 00 00       	mov    $0x0,%eax
  806d34:	eb 10                	jmp    806d46 <devcons_read+0x6d>
	*(char*)vbuf = c;
  806d36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806d39:	89 c2                	mov    %eax,%edx
  806d3b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806d3f:	88 10                	mov    %dl,(%rax)
	return 1;
  806d41:	b8 01 00 00 00       	mov    $0x1,%eax
}
  806d46:	c9                   	leaveq 
  806d47:	c3                   	retq   

0000000000806d48 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  806d48:	55                   	push   %rbp
  806d49:	48 89 e5             	mov    %rsp,%rbp
  806d4c:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  806d53:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  806d5a:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  806d61:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  806d68:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  806d6f:	eb 76                	jmp    806de7 <devcons_write+0x9f>
		m = n - tot;
  806d71:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  806d78:	89 c2                	mov    %eax,%edx
  806d7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806d7d:	29 c2                	sub    %eax,%edx
  806d7f:	89 d0                	mov    %edx,%eax
  806d81:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  806d84:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806d87:	83 f8 7f             	cmp    $0x7f,%eax
  806d8a:	76 07                	jbe    806d93 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  806d8c:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  806d93:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806d96:	48 63 d0             	movslq %eax,%rdx
  806d99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806d9c:	48 63 c8             	movslq %eax,%rcx
  806d9f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  806da6:	48 01 c1             	add    %rax,%rcx
  806da9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  806db0:	48 89 ce             	mov    %rcx,%rsi
  806db3:	48 89 c7             	mov    %rax,%rdi
  806db6:	48 b8 0b 43 80 00 00 	movabs $0x80430b,%rax
  806dbd:	00 00 00 
  806dc0:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  806dc2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806dc5:	48 63 d0             	movslq %eax,%rdx
  806dc8:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  806dcf:	48 89 d6             	mov    %rdx,%rsi
  806dd2:	48 89 c7             	mov    %rax,%rdi
  806dd5:	48 b8 ce 47 80 00 00 	movabs $0x8047ce,%rax
  806ddc:	00 00 00 
  806ddf:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  806de1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806de4:	01 45 fc             	add    %eax,-0x4(%rbp)
  806de7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806dea:	48 98                	cltq   
  806dec:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  806df3:	0f 82 78 ff ff ff    	jb     806d71 <devcons_write+0x29>
	}
	return tot;
  806df9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  806dfc:	c9                   	leaveq 
  806dfd:	c3                   	retq   

0000000000806dfe <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  806dfe:	55                   	push   %rbp
  806dff:	48 89 e5             	mov    %rsp,%rbp
  806e02:	48 83 ec 08          	sub    $0x8,%rsp
  806e06:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  806e0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806e0f:	c9                   	leaveq 
  806e10:	c3                   	retq   

0000000000806e11 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  806e11:	55                   	push   %rbp
  806e12:	48 89 e5             	mov    %rsp,%rbp
  806e15:	48 83 ec 10          	sub    $0x10,%rsp
  806e19:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  806e1d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  806e21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806e25:	48 be 04 7d 80 00 00 	movabs $0x807d04,%rsi
  806e2c:	00 00 00 
  806e2f:	48 89 c7             	mov    %rax,%rdi
  806e32:	48 b8 e7 3f 80 00 00 	movabs $0x803fe7,%rax
  806e39:	00 00 00 
  806e3c:	ff d0                	callq  *%rax
	return 0;
  806e3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806e43:	c9                   	leaveq 
  806e44:	c3                   	retq   
