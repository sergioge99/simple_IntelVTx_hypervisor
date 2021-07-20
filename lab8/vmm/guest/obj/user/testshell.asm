
vmm/guest/obj/user/testshell:     formato del fichero elf64-x86-64


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
  80003c:	e8 f5 07 00 00       	callq  800836 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

void wrong(int, int, int);

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 40          	sub    $0x40,%rsp
  80004b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80004e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	char c1, c2;
	int r, rfd, wfd, kfd, n1, n2, off, nloff;
	int pfds[2];

	close(0);
  800052:	bf 00 00 00 00       	mov    $0x0,%edi
  800057:	48 b8 f9 26 80 00 00 	movabs $0x8026f9,%rax
  80005e:	00 00 00 
  800061:	ff d0                	callq  *%rax
	close(1);
  800063:	bf 01 00 00 00       	mov    $0x1,%edi
  800068:	48 b8 f9 26 80 00 00 	movabs $0x8026f9,%rax
  80006f:	00 00 00 
  800072:	ff d0                	callq  *%rax
	opencons();
  800074:	48 b8 44 06 80 00 00 	movabs $0x800644,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
	opencons();
  800080:	48 b8 44 06 80 00 00 	movabs $0x800644,%rax
  800087:	00 00 00 
  80008a:	ff d0                	callq  *%rax

	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  80008c:	be 00 00 00 00       	mov    $0x0,%esi
  800091:	48 bf c0 4d 80 00 00 	movabs $0x804dc0,%rdi
  800098:	00 00 00 
  80009b:	48 b8 f3 2d 80 00 00 	movabs $0x802df3,%rax
  8000a2:	00 00 00 
  8000a5:	ff d0                	callq  *%rax
  8000a7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8000ae:	79 30                	jns    8000e0 <umain+0x9d>
		panic("open testshell.sh: %e", rfd);
  8000b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000b3:	89 c1                	mov    %eax,%ecx
  8000b5:	48 ba cd 4d 80 00 00 	movabs $0x804dcd,%rdx
  8000bc:	00 00 00 
  8000bf:	be 13 00 00 00       	mov    $0x13,%esi
  8000c4:	48 bf e3 4d 80 00 00 	movabs $0x804de3,%rdi
  8000cb:	00 00 00 
  8000ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d3:	49 b8 b9 08 80 00 00 	movabs $0x8008b9,%r8
  8000da:	00 00 00 
  8000dd:	41 ff d0             	callq  *%r8
	if ((wfd = pipe(pfds)) < 0)
  8000e0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8000e4:	48 89 c7             	mov    %rax,%rdi
  8000e7:	48 b8 94 44 80 00 00 	movabs $0x804494,%rax
  8000ee:	00 00 00 
  8000f1:	ff d0                	callq  *%rax
  8000f3:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8000fa:	79 30                	jns    80012c <umain+0xe9>
		panic("pipe: %e", wfd);
  8000fc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000ff:	89 c1                	mov    %eax,%ecx
  800101:	48 ba f4 4d 80 00 00 	movabs $0x804df4,%rdx
  800108:	00 00 00 
  80010b:	be 15 00 00 00       	mov    $0x15,%esi
  800110:	48 bf e3 4d 80 00 00 	movabs $0x804de3,%rdi
  800117:	00 00 00 
  80011a:	b8 00 00 00 00       	mov    $0x0,%eax
  80011f:	49 b8 b9 08 80 00 00 	movabs $0x8008b9,%r8
  800126:	00 00 00 
  800129:	41 ff d0             	callq  *%r8
	wfd = pfds[1];
  80012c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80012f:	89 45 f0             	mov    %eax,-0x10(%rbp)

	cprintf("running sh -x < testshell.sh | cat\n");
  800132:	48 bf 00 4e 80 00 00 	movabs $0x804e00,%rdi
  800139:	00 00 00 
  80013c:	b8 00 00 00 00       	mov    $0x0,%eax
  800141:	48 ba f2 0a 80 00 00 	movabs $0x800af2,%rdx
  800148:	00 00 00 
  80014b:	ff d2                	callq  *%rdx
	if ((r = fork()) < 0)
  80014d:	48 b8 a5 23 80 00 00 	movabs $0x8023a5,%rax
  800154:	00 00 00 
  800157:	ff d0                	callq  *%rax
  800159:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80015c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800160:	79 30                	jns    800192 <umain+0x14f>
		panic("fork: %e", r);
  800162:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800165:	89 c1                	mov    %eax,%ecx
  800167:	48 ba 24 4e 80 00 00 	movabs $0x804e24,%rdx
  80016e:	00 00 00 
  800171:	be 1a 00 00 00       	mov    $0x1a,%esi
  800176:	48 bf e3 4d 80 00 00 	movabs $0x804de3,%rdi
  80017d:	00 00 00 
  800180:	b8 00 00 00 00       	mov    $0x0,%eax
  800185:	49 b8 b9 08 80 00 00 	movabs $0x8008b9,%r8
  80018c:	00 00 00 
  80018f:	41 ff d0             	callq  *%r8
	if (r == 0) {
  800192:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800196:	0f 85 fb 00 00 00    	jne    800297 <umain+0x254>
		dup(rfd, 0);
  80019c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80019f:	be 00 00 00 00       	mov    $0x0,%esi
  8001a4:	89 c7                	mov    %eax,%edi
  8001a6:	48 b8 72 27 80 00 00 	movabs $0x802772,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	callq  *%rax
		dup(wfd, 1);
  8001b2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001b5:	be 01 00 00 00       	mov    $0x1,%esi
  8001ba:	89 c7                	mov    %eax,%edi
  8001bc:	48 b8 72 27 80 00 00 	movabs $0x802772,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
		close(rfd);
  8001c8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	48 b8 f9 26 80 00 00 	movabs $0x8026f9,%rax
  8001d4:	00 00 00 
  8001d7:	ff d0                	callq  *%rax
		close(wfd);
  8001d9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001dc:	89 c7                	mov    %eax,%edi
  8001de:	48 b8 f9 26 80 00 00 	movabs $0x8026f9,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	callq  *%rax
		if ((r = spawnl("/bin/sh", "sh", "-x", 0)) < 0)
  8001ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ef:	48 ba 2d 4e 80 00 00 	movabs $0x804e2d,%rdx
  8001f6:	00 00 00 
  8001f9:	48 be 30 4e 80 00 00 	movabs $0x804e30,%rsi
  800200:	00 00 00 
  800203:	48 bf 33 4e 80 00 00 	movabs $0x804e33,%rdi
  80020a:	00 00 00 
  80020d:	b8 00 00 00 00       	mov    $0x0,%eax
  800212:	49 b8 7a 35 80 00 00 	movabs $0x80357a,%r8
  800219:	00 00 00 
  80021c:	41 ff d0             	callq  *%r8
  80021f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800222:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800226:	79 30                	jns    800258 <umain+0x215>
			panic("spawn: %e", r);
  800228:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80022b:	89 c1                	mov    %eax,%ecx
  80022d:	48 ba 3b 4e 80 00 00 	movabs $0x804e3b,%rdx
  800234:	00 00 00 
  800237:	be 21 00 00 00       	mov    $0x21,%esi
  80023c:	48 bf e3 4d 80 00 00 	movabs $0x804de3,%rdi
  800243:	00 00 00 
  800246:	b8 00 00 00 00       	mov    $0x0,%eax
  80024b:	49 b8 b9 08 80 00 00 	movabs $0x8008b9,%r8
  800252:	00 00 00 
  800255:	41 ff d0             	callq  *%r8
		close(0);
  800258:	bf 00 00 00 00       	mov    $0x0,%edi
  80025d:	48 b8 f9 26 80 00 00 	movabs $0x8026f9,%rax
  800264:	00 00 00 
  800267:	ff d0                	callq  *%rax
		close(1);
  800269:	bf 01 00 00 00       	mov    $0x1,%edi
  80026e:	48 b8 f9 26 80 00 00 	movabs $0x8026f9,%rax
  800275:	00 00 00 
  800278:	ff d0                	callq  *%rax
		wait(r);
  80027a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80027d:	89 c7                	mov    %eax,%edi
  80027f:	48 b8 5b 4a 80 00 00 	movabs $0x804a5b,%rax
  800286:	00 00 00 
  800289:	ff d0                	callq  *%rax
		exit();
  80028b:	48 b8 96 08 80 00 00 	movabs $0x800896,%rax
  800292:	00 00 00 
  800295:	ff d0                	callq  *%rax
	}
	close(rfd);
  800297:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80029a:	89 c7                	mov    %eax,%edi
  80029c:	48 b8 f9 26 80 00 00 	movabs $0x8026f9,%rax
  8002a3:	00 00 00 
  8002a6:	ff d0                	callq  *%rax
	close(wfd);
  8002a8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002ab:	89 c7                	mov    %eax,%edi
  8002ad:	48 b8 f9 26 80 00 00 	movabs $0x8026f9,%rax
  8002b4:	00 00 00 
  8002b7:	ff d0                	callq  *%rax

	rfd = pfds[0];
  8002b9:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002bc:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002bf:	be 00 00 00 00       	mov    $0x0,%esi
  8002c4:	48 bf 45 4e 80 00 00 	movabs $0x804e45,%rdi
  8002cb:	00 00 00 
  8002ce:	48 b8 f3 2d 80 00 00 	movabs $0x802df3,%rax
  8002d5:	00 00 00 
  8002d8:	ff d0                	callq  *%rax
  8002da:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e1:	79 30                	jns    800313 <umain+0x2d0>
		panic("open testshell.key for reading: %e", kfd);
  8002e3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002e6:	89 c1                	mov    %eax,%ecx
  8002e8:	48 ba 58 4e 80 00 00 	movabs $0x804e58,%rdx
  8002ef:	00 00 00 
  8002f2:	be 2c 00 00 00       	mov    $0x2c,%esi
  8002f7:	48 bf e3 4d 80 00 00 	movabs $0x804de3,%rdi
  8002fe:	00 00 00 
  800301:	b8 00 00 00 00       	mov    $0x0,%eax
  800306:	49 b8 b9 08 80 00 00 	movabs $0x8008b9,%r8
  80030d:	00 00 00 
  800310:	41 ff d0             	callq  *%r8

	nloff = 0;
  800313:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	for (off=0;; off++) {
  80031a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		n1 = read(rfd, &c1, 1);
  800321:	48 8d 4d df          	lea    -0x21(%rbp),%rcx
  800325:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800328:	ba 01 00 00 00       	mov    $0x1,%edx
  80032d:	48 89 ce             	mov    %rcx,%rsi
  800330:	89 c7                	mov    %eax,%edi
  800332:	48 b8 1b 29 80 00 00 	movabs $0x80291b,%rax
  800339:	00 00 00 
  80033c:	ff d0                	callq  *%rax
  80033e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		n2 = read(kfd, &c2, 1);
  800341:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
  800345:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800348:	ba 01 00 00 00       	mov    $0x1,%edx
  80034d:	48 89 ce             	mov    %rcx,%rsi
  800350:	89 c7                	mov    %eax,%edi
  800352:	48 b8 1b 29 80 00 00 	movabs $0x80291b,%rax
  800359:	00 00 00 
  80035c:	ff d0                	callq  *%rax
  80035e:	89 45 e0             	mov    %eax,-0x20(%rbp)
		if (n1 < 0)
  800361:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800365:	79 30                	jns    800397 <umain+0x354>
			panic("reading testshell.out: %e", n1);
  800367:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80036a:	89 c1                	mov    %eax,%ecx
  80036c:	48 ba 7b 4e 80 00 00 	movabs $0x804e7b,%rdx
  800373:	00 00 00 
  800376:	be 33 00 00 00       	mov    $0x33,%esi
  80037b:	48 bf e3 4d 80 00 00 	movabs $0x804de3,%rdi
  800382:	00 00 00 
  800385:	b8 00 00 00 00       	mov    $0x0,%eax
  80038a:	49 b8 b9 08 80 00 00 	movabs $0x8008b9,%r8
  800391:	00 00 00 
  800394:	41 ff d0             	callq  *%r8
		if (n2 < 0)
  800397:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80039b:	79 30                	jns    8003cd <umain+0x38a>
			panic("reading testshell.key: %e", n2);
  80039d:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8003a0:	89 c1                	mov    %eax,%ecx
  8003a2:	48 ba 95 4e 80 00 00 	movabs $0x804e95,%rdx
  8003a9:	00 00 00 
  8003ac:	be 35 00 00 00       	mov    $0x35,%esi
  8003b1:	48 bf e3 4d 80 00 00 	movabs $0x804de3,%rdi
  8003b8:	00 00 00 
  8003bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c0:	49 b8 b9 08 80 00 00 	movabs $0x8008b9,%r8
  8003c7:	00 00 00 
  8003ca:	41 ff d0             	callq  *%r8
		if (n1 == 0 && n2 == 0)
  8003cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8003d1:	75 08                	jne    8003db <umain+0x398>
  8003d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8003d7:	75 02                	jne    8003db <umain+0x398>
			break;
  8003d9:	eb 4b                	jmp    800426 <umain+0x3e3>
		if (n1 != 1 || n2 != 1 || c1 != c2)
  8003db:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8003df:	75 12                	jne    8003f3 <umain+0x3b0>
  8003e1:	83 7d e0 01          	cmpl   $0x1,-0x20(%rbp)
  8003e5:	75 0c                	jne    8003f3 <umain+0x3b0>
  8003e7:	0f b6 55 df          	movzbl -0x21(%rbp),%edx
  8003eb:	0f b6 45 de          	movzbl -0x22(%rbp),%eax
  8003ef:	38 c2                	cmp    %al,%dl
  8003f1:	74 19                	je     80040c <umain+0x3c9>
			wrong(rfd, kfd, nloff);
  8003f3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8003f6:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8003f9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8003fc:	89 ce                	mov    %ecx,%esi
  8003fe:	89 c7                	mov    %eax,%edi
  800400:	48 b8 44 04 80 00 00 	movabs $0x800444,%rax
  800407:	00 00 00 
  80040a:	ff d0                	callq  *%rax
		if (c1 == '\n')
  80040c:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  800410:	3c 0a                	cmp    $0xa,%al
  800412:	75 09                	jne    80041d <umain+0x3da>
			nloff = off+1;
  800414:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800417:	83 c0 01             	add    $0x1,%eax
  80041a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	for (off=0;; off++) {
  80041d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	}
  800421:	e9 fb fe ff ff       	jmpq   800321 <umain+0x2de>
	cprintf("shell ran correctly\n");
  800426:	48 bf af 4e 80 00 00 	movabs $0x804eaf,%rdi
  80042d:	00 00 00 
  800430:	b8 00 00 00 00       	mov    $0x0,%eax
  800435:	48 ba f2 0a 80 00 00 	movabs $0x800af2,%rdx
  80043c:	00 00 00 
  80043f:	ff d2                	callq  *%rdx
static __inline void read_gdtr (uint64_t *gdtbase, uint16_t *gdtlimit) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800441:	cc                   	int3   

	breakpoint();
}
  800442:	c9                   	leaveq 
  800443:	c3                   	retq   

0000000000800444 <wrong>:

void
wrong(int rfd, int kfd, int off)
{
  800444:	55                   	push   %rbp
  800445:	48 89 e5             	mov    %rsp,%rbp
  800448:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
  80044c:	89 7d 8c             	mov    %edi,-0x74(%rbp)
  80044f:	89 75 88             	mov    %esi,-0x78(%rbp)
  800452:	89 55 84             	mov    %edx,-0x7c(%rbp)
	char buf[100];
	int n;

	seek(rfd, off);
  800455:	8b 55 84             	mov    -0x7c(%rbp),%edx
  800458:	8b 45 8c             	mov    -0x74(%rbp),%eax
  80045b:	89 d6                	mov    %edx,%esi
  80045d:	89 c7                	mov    %eax,%edi
  80045f:	48 b8 39 2b 80 00 00 	movabs $0x802b39,%rax
  800466:	00 00 00 
  800469:	ff d0                	callq  *%rax
	seek(kfd, off);
  80046b:	8b 55 84             	mov    -0x7c(%rbp),%edx
  80046e:	8b 45 88             	mov    -0x78(%rbp),%eax
  800471:	89 d6                	mov    %edx,%esi
  800473:	89 c7                	mov    %eax,%edi
  800475:	48 b8 39 2b 80 00 00 	movabs $0x802b39,%rax
  80047c:	00 00 00 
  80047f:	ff d0                	callq  *%rax

	cprintf("shell produced incorrect output.\n");
  800481:	48 bf c8 4e 80 00 00 	movabs $0x804ec8,%rdi
  800488:	00 00 00 
  80048b:	b8 00 00 00 00       	mov    $0x0,%eax
  800490:	48 ba f2 0a 80 00 00 	movabs $0x800af2,%rdx
  800497:	00 00 00 
  80049a:	ff d2                	callq  *%rdx
	cprintf("expected:\n===\n");
  80049c:	48 bf ea 4e 80 00 00 	movabs $0x804eea,%rdi
  8004a3:	00 00 00 
  8004a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ab:	48 ba f2 0a 80 00 00 	movabs $0x800af2,%rdx
  8004b2:	00 00 00 
  8004b5:	ff d2                	callq  *%rdx
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  8004b7:	eb 1c                	jmp    8004d5 <wrong+0x91>
		sys_cputs(buf, n);
  8004b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004bc:	48 63 d0             	movslq %eax,%rdx
  8004bf:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8004c3:	48 89 d6             	mov    %rdx,%rsi
  8004c6:	48 89 c7             	mov    %rax,%rdi
  8004c9:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  8004d0:	00 00 00 
  8004d3:	ff d0                	callq  *%rax
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  8004d5:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  8004d9:	8b 45 88             	mov    -0x78(%rbp),%eax
  8004dc:	ba 63 00 00 00       	mov    $0x63,%edx
  8004e1:	48 89 ce             	mov    %rcx,%rsi
  8004e4:	89 c7                	mov    %eax,%edi
  8004e6:	48 b8 1b 29 80 00 00 	movabs $0x80291b,%rax
  8004ed:	00 00 00 
  8004f0:	ff d0                	callq  *%rax
  8004f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004f9:	7f be                	jg     8004b9 <wrong+0x75>
	cprintf("===\ngot:\n===\n");
  8004fb:	48 bf f9 4e 80 00 00 	movabs $0x804ef9,%rdi
  800502:	00 00 00 
  800505:	b8 00 00 00 00       	mov    $0x0,%eax
  80050a:	48 ba f2 0a 80 00 00 	movabs $0x800af2,%rdx
  800511:	00 00 00 
  800514:	ff d2                	callq  *%rdx
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  800516:	eb 1c                	jmp    800534 <wrong+0xf0>
		sys_cputs(buf, n);
  800518:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80051b:	48 63 d0             	movslq %eax,%rdx
  80051e:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  800522:	48 89 d6             	mov    %rdx,%rsi
  800525:	48 89 c7             	mov    %rax,%rdi
  800528:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  80052f:	00 00 00 
  800532:	ff d0                	callq  *%rax
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  800534:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  800538:	8b 45 8c             	mov    -0x74(%rbp),%eax
  80053b:	ba 63 00 00 00       	mov    $0x63,%edx
  800540:	48 89 ce             	mov    %rcx,%rsi
  800543:	89 c7                	mov    %eax,%edi
  800545:	48 b8 1b 29 80 00 00 	movabs $0x80291b,%rax
  80054c:	00 00 00 
  80054f:	ff d0                	callq  *%rax
  800551:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800554:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800558:	7f be                	jg     800518 <wrong+0xd4>
	cprintf("===\n");
  80055a:	48 bf 07 4f 80 00 00 	movabs $0x804f07,%rdi
  800561:	00 00 00 
  800564:	b8 00 00 00 00       	mov    $0x0,%eax
  800569:	48 ba f2 0a 80 00 00 	movabs $0x800af2,%rdx
  800570:	00 00 00 
  800573:	ff d2                	callq  *%rdx
	exit();
  800575:	48 b8 96 08 80 00 00 	movabs $0x800896,%rax
  80057c:	00 00 00 
  80057f:	ff d0                	callq  *%rax
}
  800581:	c9                   	leaveq 
  800582:	c3                   	retq   

0000000000800583 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800583:	55                   	push   %rbp
  800584:	48 89 e5             	mov    %rsp,%rbp
  800587:	48 83 ec 20          	sub    $0x20,%rsp
  80058b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80058e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800591:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800594:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  800598:	be 01 00 00 00       	mov    $0x1,%esi
  80059d:	48 89 c7             	mov    %rax,%rdi
  8005a0:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  8005a7:	00 00 00 
  8005aa:	ff d0                	callq  *%rax
}
  8005ac:	c9                   	leaveq 
  8005ad:	c3                   	retq   

00000000008005ae <getchar>:

int
getchar(void)
{
  8005ae:	55                   	push   %rbp
  8005af:	48 89 e5             	mov    %rsp,%rbp
  8005b2:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8005b6:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8005ba:	ba 01 00 00 00       	mov    $0x1,%edx
  8005bf:	48 89 c6             	mov    %rax,%rsi
  8005c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8005c7:	48 b8 1b 29 80 00 00 	movabs $0x80291b,%rax
  8005ce:	00 00 00 
  8005d1:	ff d0                	callq  *%rax
  8005d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8005d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005da:	79 05                	jns    8005e1 <getchar+0x33>
		return r;
  8005dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005df:	eb 14                	jmp    8005f5 <getchar+0x47>
	if (r < 1)
  8005e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005e5:	7f 07                	jg     8005ee <getchar+0x40>
		return -E_EOF;
  8005e7:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8005ec:	eb 07                	jmp    8005f5 <getchar+0x47>
	return c;
  8005ee:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8005f2:	0f b6 c0             	movzbl %al,%eax
}
  8005f5:	c9                   	leaveq 
  8005f6:	c3                   	retq   

00000000008005f7 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8005f7:	55                   	push   %rbp
  8005f8:	48 89 e5             	mov    %rsp,%rbp
  8005fb:	48 83 ec 20          	sub    $0x20,%rsp
  8005ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800602:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800606:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800609:	48 89 d6             	mov    %rdx,%rsi
  80060c:	89 c7                	mov    %eax,%edi
  80060e:	48 b8 e7 24 80 00 00 	movabs $0x8024e7,%rax
  800615:	00 00 00 
  800618:	ff d0                	callq  *%rax
  80061a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80061d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800621:	79 05                	jns    800628 <iscons+0x31>
		return r;
  800623:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800626:	eb 1a                	jmp    800642 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  800628:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80062c:	8b 10                	mov    (%rax),%edx
  80062e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800635:	00 00 00 
  800638:	8b 00                	mov    (%rax),%eax
  80063a:	39 c2                	cmp    %eax,%edx
  80063c:	0f 94 c0             	sete   %al
  80063f:	0f b6 c0             	movzbl %al,%eax
}
  800642:	c9                   	leaveq 
  800643:	c3                   	retq   

0000000000800644 <opencons>:

int
opencons(void)
{
  800644:	55                   	push   %rbp
  800645:	48 89 e5             	mov    %rsp,%rbp
  800648:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80064c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800650:	48 89 c7             	mov    %rax,%rdi
  800653:	48 b8 4f 24 80 00 00 	movabs $0x80244f,%rax
  80065a:	00 00 00 
  80065d:	ff d0                	callq  *%rax
  80065f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800662:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800666:	79 05                	jns    80066d <opencons+0x29>
		return r;
  800668:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80066b:	eb 5b                	jmp    8006c8 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80066d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800671:	ba 07 04 00 00       	mov    $0x407,%edx
  800676:	48 89 c6             	mov    %rax,%rsi
  800679:	bf 00 00 00 00       	mov    $0x0,%edi
  80067e:	48 b8 b9 1f 80 00 00 	movabs $0x801fb9,%rax
  800685:	00 00 00 
  800688:	ff d0                	callq  *%rax
  80068a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80068d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800691:	79 05                	jns    800698 <opencons+0x54>
		return r;
  800693:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800696:	eb 30                	jmp    8006c8 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  800698:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80069c:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8006a3:	00 00 00 
  8006a6:	8b 12                	mov    (%rdx),%edx
  8006a8:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8006aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006ae:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8006b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006b9:	48 89 c7             	mov    %rax,%rdi
  8006bc:	48 b8 01 24 80 00 00 	movabs $0x802401,%rax
  8006c3:	00 00 00 
  8006c6:	ff d0                	callq  *%rax
}
  8006c8:	c9                   	leaveq 
  8006c9:	c3                   	retq   

00000000008006ca <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8006ca:	55                   	push   %rbp
  8006cb:	48 89 e5             	mov    %rsp,%rbp
  8006ce:	48 83 ec 30          	sub    $0x30,%rsp
  8006d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8006de:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8006e3:	75 07                	jne    8006ec <devcons_read+0x22>
		return 0;
  8006e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ea:	eb 4b                	jmp    800737 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8006ec:	eb 0c                	jmp    8006fa <devcons_read+0x30>
		sys_yield();
  8006ee:	48 b8 7d 1f 80 00 00 	movabs $0x801f7d,%rax
  8006f5:	00 00 00 
  8006f8:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  8006fa:	48 b8 bf 1e 80 00 00 	movabs $0x801ebf,%rax
  800701:	00 00 00 
  800704:	ff d0                	callq  *%rax
  800706:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800709:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80070d:	74 df                	je     8006ee <devcons_read+0x24>
	if (c < 0)
  80070f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800713:	79 05                	jns    80071a <devcons_read+0x50>
		return c;
  800715:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800718:	eb 1d                	jmp    800737 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80071a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80071e:	75 07                	jne    800727 <devcons_read+0x5d>
		return 0;
  800720:	b8 00 00 00 00       	mov    $0x0,%eax
  800725:	eb 10                	jmp    800737 <devcons_read+0x6d>
	*(char*)vbuf = c;
  800727:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80072a:	89 c2                	mov    %eax,%edx
  80072c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800730:	88 10                	mov    %dl,(%rax)
	return 1;
  800732:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800737:	c9                   	leaveq 
  800738:	c3                   	retq   

0000000000800739 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800739:	55                   	push   %rbp
  80073a:	48 89 e5             	mov    %rsp,%rbp
  80073d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  800744:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80074b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  800752:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800759:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800760:	eb 76                	jmp    8007d8 <devcons_write+0x9f>
		m = n - tot;
  800762:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800769:	89 c2                	mov    %eax,%edx
  80076b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80076e:	29 c2                	sub    %eax,%edx
  800770:	89 d0                	mov    %edx,%eax
  800772:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  800775:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800778:	83 f8 7f             	cmp    $0x7f,%eax
  80077b:	76 07                	jbe    800784 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80077d:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  800784:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800787:	48 63 d0             	movslq %eax,%rdx
  80078a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80078d:	48 63 c8             	movslq %eax,%rcx
  800790:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800797:	48 01 c1             	add    %rax,%rcx
  80079a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8007a1:	48 89 ce             	mov    %rcx,%rsi
  8007a4:	48 89 c7             	mov    %rax,%rdi
  8007a7:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  8007ae:	00 00 00 
  8007b1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8007b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8007b6:	48 63 d0             	movslq %eax,%rdx
  8007b9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8007c0:	48 89 d6             	mov    %rdx,%rsi
  8007c3:	48 89 c7             	mov    %rax,%rdi
  8007c6:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  8007cd:	00 00 00 
  8007d0:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  8007d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8007d5:	01 45 fc             	add    %eax,-0x4(%rbp)
  8007d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8007db:	48 98                	cltq   
  8007dd:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8007e4:	0f 82 78 ff ff ff    	jb     800762 <devcons_write+0x29>
	}
	return tot;
  8007ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8007ed:	c9                   	leaveq 
  8007ee:	c3                   	retq   

00000000008007ef <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8007ef:	55                   	push   %rbp
  8007f0:	48 89 e5             	mov    %rsp,%rbp
  8007f3:	48 83 ec 08          	sub    $0x8,%rsp
  8007f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8007fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800800:	c9                   	leaveq 
  800801:	c3                   	retq   

0000000000800802 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800802:	55                   	push   %rbp
  800803:	48 89 e5             	mov    %rsp,%rbp
  800806:	48 83 ec 10          	sub    $0x10,%rsp
  80080a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80080e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800812:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800816:	48 be 11 4f 80 00 00 	movabs $0x804f11,%rsi
  80081d:	00 00 00 
  800820:	48 89 c7             	mov    %rax,%rdi
  800823:	48 b8 8c 16 80 00 00 	movabs $0x80168c,%rax
  80082a:	00 00 00 
  80082d:	ff d0                	callq  *%rax
	return 0;
  80082f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800834:	c9                   	leaveq 
  800835:	c3                   	retq   

0000000000800836 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800836:	55                   	push   %rbp
  800837:	48 89 e5             	mov    %rsp,%rbp
  80083a:	48 83 ec 10          	sub    $0x10,%rsp
  80083e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800841:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800845:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80084c:	00 00 00 
  80084f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800856:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80085a:	7e 14                	jle    800870 <libmain+0x3a>
		binaryname = argv[0];
  80085c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800860:	48 8b 10             	mov    (%rax),%rdx
  800863:	48 b8 38 70 80 00 00 	movabs $0x807038,%rax
  80086a:	00 00 00 
  80086d:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800870:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800874:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800877:	48 89 d6             	mov    %rdx,%rsi
  80087a:	89 c7                	mov    %eax,%edi
  80087c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800883:	00 00 00 
  800886:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800888:	48 b8 96 08 80 00 00 	movabs $0x800896,%rax
  80088f:	00 00 00 
  800892:	ff d0                	callq  *%rax
}
  800894:	c9                   	leaveq 
  800895:	c3                   	retq   

0000000000800896 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800896:	55                   	push   %rbp
  800897:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80089a:	48 b8 44 27 80 00 00 	movabs $0x802744,%rax
  8008a1:	00 00 00 
  8008a4:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8008a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8008ab:	48 b8 fb 1e 80 00 00 	movabs $0x801efb,%rax
  8008b2:	00 00 00 
  8008b5:	ff d0                	callq  *%rax
}
  8008b7:	5d                   	pop    %rbp
  8008b8:	c3                   	retq   

00000000008008b9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8008b9:	55                   	push   %rbp
  8008ba:	48 89 e5             	mov    %rsp,%rbp
  8008bd:	53                   	push   %rbx
  8008be:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8008c5:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8008cc:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8008d2:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8008d9:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8008e0:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8008e7:	84 c0                	test   %al,%al
  8008e9:	74 23                	je     80090e <_panic+0x55>
  8008eb:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8008f2:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8008f6:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8008fa:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8008fe:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800902:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800906:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80090a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80090e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800915:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80091c:	00 00 00 
  80091f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800926:	00 00 00 
  800929:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80092d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800934:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80093b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800942:	48 b8 38 70 80 00 00 	movabs $0x807038,%rax
  800949:	00 00 00 
  80094c:	48 8b 18             	mov    (%rax),%rbx
  80094f:	48 b8 41 1f 80 00 00 	movabs $0x801f41,%rax
  800956:	00 00 00 
  800959:	ff d0                	callq  *%rax
  80095b:	89 c6                	mov    %eax,%esi
  80095d:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800963:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80096a:	41 89 d0             	mov    %edx,%r8d
  80096d:	48 89 c1             	mov    %rax,%rcx
  800970:	48 89 da             	mov    %rbx,%rdx
  800973:	48 bf 28 4f 80 00 00 	movabs $0x804f28,%rdi
  80097a:	00 00 00 
  80097d:	b8 00 00 00 00       	mov    $0x0,%eax
  800982:	49 b9 f2 0a 80 00 00 	movabs $0x800af2,%r9
  800989:	00 00 00 
  80098c:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80098f:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800996:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80099d:	48 89 d6             	mov    %rdx,%rsi
  8009a0:	48 89 c7             	mov    %rax,%rdi
  8009a3:	48 b8 46 0a 80 00 00 	movabs $0x800a46,%rax
  8009aa:	00 00 00 
  8009ad:	ff d0                	callq  *%rax
	cprintf("\n");
  8009af:	48 bf 4b 4f 80 00 00 	movabs $0x804f4b,%rdi
  8009b6:	00 00 00 
  8009b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8009be:	48 ba f2 0a 80 00 00 	movabs $0x800af2,%rdx
  8009c5:	00 00 00 
  8009c8:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8009ca:	cc                   	int3   
  8009cb:	eb fd                	jmp    8009ca <_panic+0x111>

00000000008009cd <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8009cd:	55                   	push   %rbp
  8009ce:	48 89 e5             	mov    %rsp,%rbp
  8009d1:	48 83 ec 10          	sub    $0x10,%rsp
  8009d5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8009d8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8009dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8009e0:	8b 00                	mov    (%rax),%eax
  8009e2:	8d 48 01             	lea    0x1(%rax),%ecx
  8009e5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8009e9:	89 0a                	mov    %ecx,(%rdx)
  8009eb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8009ee:	89 d1                	mov    %edx,%ecx
  8009f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8009f4:	48 98                	cltq   
  8009f6:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8009fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8009fe:	8b 00                	mov    (%rax),%eax
  800a00:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a05:	75 2c                	jne    800a33 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800a07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a0b:	8b 00                	mov    (%rax),%eax
  800a0d:	48 98                	cltq   
  800a0f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a13:	48 83 c2 08          	add    $0x8,%rdx
  800a17:	48 89 c6             	mov    %rax,%rsi
  800a1a:	48 89 d7             	mov    %rdx,%rdi
  800a1d:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  800a24:	00 00 00 
  800a27:	ff d0                	callq  *%rax
        b->idx = 0;
  800a29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a2d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800a33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a37:	8b 40 04             	mov    0x4(%rax),%eax
  800a3a:	8d 50 01             	lea    0x1(%rax),%edx
  800a3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a41:	89 50 04             	mov    %edx,0x4(%rax)
}
  800a44:	c9                   	leaveq 
  800a45:	c3                   	retq   

0000000000800a46 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800a46:	55                   	push   %rbp
  800a47:	48 89 e5             	mov    %rsp,%rbp
  800a4a:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800a51:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800a58:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800a5f:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800a66:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800a6d:	48 8b 0a             	mov    (%rdx),%rcx
  800a70:	48 89 08             	mov    %rcx,(%rax)
  800a73:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a77:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a7b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a7f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800a83:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800a8a:	00 00 00 
    b.cnt = 0;
  800a8d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800a94:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800a97:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800a9e:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800aa5:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800aac:	48 89 c6             	mov    %rax,%rsi
  800aaf:	48 bf cd 09 80 00 00 	movabs $0x8009cd,%rdi
  800ab6:	00 00 00 
  800ab9:	48 b8 91 0e 80 00 00 	movabs $0x800e91,%rax
  800ac0:	00 00 00 
  800ac3:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800ac5:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800acb:	48 98                	cltq   
  800acd:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800ad4:	48 83 c2 08          	add    $0x8,%rdx
  800ad8:	48 89 c6             	mov    %rax,%rsi
  800adb:	48 89 d7             	mov    %rdx,%rdi
  800ade:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  800ae5:	00 00 00 
  800ae8:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800aea:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800af0:	c9                   	leaveq 
  800af1:	c3                   	retq   

0000000000800af2 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800af2:	55                   	push   %rbp
  800af3:	48 89 e5             	mov    %rsp,%rbp
  800af6:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800afd:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800b04:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800b0b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b12:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b19:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b20:	84 c0                	test   %al,%al
  800b22:	74 20                	je     800b44 <cprintf+0x52>
  800b24:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b28:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b2c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b30:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b34:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b38:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b3c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b40:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b44:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800b4b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800b52:	00 00 00 
  800b55:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800b5c:	00 00 00 
  800b5f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b63:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800b6a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800b71:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800b78:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800b7f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800b86:	48 8b 0a             	mov    (%rdx),%rcx
  800b89:	48 89 08             	mov    %rcx,(%rax)
  800b8c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b90:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b94:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b98:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800b9c:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800ba3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800baa:	48 89 d6             	mov    %rdx,%rsi
  800bad:	48 89 c7             	mov    %rax,%rdi
  800bb0:	48 b8 46 0a 80 00 00 	movabs $0x800a46,%rax
  800bb7:	00 00 00 
  800bba:	ff d0                	callq  *%rax
  800bbc:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800bc2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800bc8:	c9                   	leaveq 
  800bc9:	c3                   	retq   

0000000000800bca <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bca:	55                   	push   %rbp
  800bcb:	48 89 e5             	mov    %rsp,%rbp
  800bce:	48 83 ec 30          	sub    $0x30,%rsp
  800bd2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800bd6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800bda:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800bde:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800be1:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800be5:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800be9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800bec:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800bf0:	77 42                	ja     800c34 <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bf2:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800bf5:	8d 78 ff             	lea    -0x1(%rax),%edi
  800bf8:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800bfb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bff:	ba 00 00 00 00       	mov    $0x0,%edx
  800c04:	48 f7 f6             	div    %rsi
  800c07:	49 89 c2             	mov    %rax,%r10
  800c0a:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800c0d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800c10:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800c14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800c18:	41 89 c9             	mov    %ecx,%r9d
  800c1b:	41 89 f8             	mov    %edi,%r8d
  800c1e:	89 d1                	mov    %edx,%ecx
  800c20:	4c 89 d2             	mov    %r10,%rdx
  800c23:	48 89 c7             	mov    %rax,%rdi
  800c26:	48 b8 ca 0b 80 00 00 	movabs $0x800bca,%rax
  800c2d:	00 00 00 
  800c30:	ff d0                	callq  *%rax
  800c32:	eb 1e                	jmp    800c52 <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c34:	eb 12                	jmp    800c48 <printnum+0x7e>
			putch(padc, putdat);
  800c36:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800c3a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800c3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800c41:	48 89 ce             	mov    %rcx,%rsi
  800c44:	89 d7                	mov    %edx,%edi
  800c46:	ff d0                	callq  *%rax
		while (--width > 0)
  800c48:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800c4c:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800c50:	7f e4                	jg     800c36 <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c52:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c59:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5e:	48 f7 f1             	div    %rcx
  800c61:	48 b8 70 51 80 00 00 	movabs $0x805170,%rax
  800c68:	00 00 00 
  800c6b:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800c6f:	0f be d0             	movsbl %al,%edx
  800c72:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800c76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800c7a:	48 89 ce             	mov    %rcx,%rsi
  800c7d:	89 d7                	mov    %edx,%edi
  800c7f:	ff d0                	callq  *%rax
}
  800c81:	c9                   	leaveq 
  800c82:	c3                   	retq   

0000000000800c83 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c83:	55                   	push   %rbp
  800c84:	48 89 e5             	mov    %rsp,%rbp
  800c87:	48 83 ec 20          	sub    $0x20,%rsp
  800c8b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800c8f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800c92:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800c96:	7e 4f                	jle    800ce7 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800c98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c9c:	8b 00                	mov    (%rax),%eax
  800c9e:	83 f8 30             	cmp    $0x30,%eax
  800ca1:	73 24                	jae    800cc7 <getuint+0x44>
  800ca3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ca7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800cab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800caf:	8b 00                	mov    (%rax),%eax
  800cb1:	89 c0                	mov    %eax,%eax
  800cb3:	48 01 d0             	add    %rdx,%rax
  800cb6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cba:	8b 12                	mov    (%rdx),%edx
  800cbc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800cbf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cc3:	89 0a                	mov    %ecx,(%rdx)
  800cc5:	eb 14                	jmp    800cdb <getuint+0x58>
  800cc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ccb:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ccf:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800cd3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cd7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800cdb:	48 8b 00             	mov    (%rax),%rax
  800cde:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ce2:	e9 9d 00 00 00       	jmpq   800d84 <getuint+0x101>
	else if (lflag)
  800ce7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800ceb:	74 4c                	je     800d39 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800ced:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cf1:	8b 00                	mov    (%rax),%eax
  800cf3:	83 f8 30             	cmp    $0x30,%eax
  800cf6:	73 24                	jae    800d1c <getuint+0x99>
  800cf8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cfc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d04:	8b 00                	mov    (%rax),%eax
  800d06:	89 c0                	mov    %eax,%eax
  800d08:	48 01 d0             	add    %rdx,%rax
  800d0b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d0f:	8b 12                	mov    (%rdx),%edx
  800d11:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d14:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d18:	89 0a                	mov    %ecx,(%rdx)
  800d1a:	eb 14                	jmp    800d30 <getuint+0xad>
  800d1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d20:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d24:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800d28:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d2c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d30:	48 8b 00             	mov    (%rax),%rax
  800d33:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d37:	eb 4b                	jmp    800d84 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800d39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d3d:	8b 00                	mov    (%rax),%eax
  800d3f:	83 f8 30             	cmp    $0x30,%eax
  800d42:	73 24                	jae    800d68 <getuint+0xe5>
  800d44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d48:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d50:	8b 00                	mov    (%rax),%eax
  800d52:	89 c0                	mov    %eax,%eax
  800d54:	48 01 d0             	add    %rdx,%rax
  800d57:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d5b:	8b 12                	mov    (%rdx),%edx
  800d5d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d60:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d64:	89 0a                	mov    %ecx,(%rdx)
  800d66:	eb 14                	jmp    800d7c <getuint+0xf9>
  800d68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d6c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d70:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800d74:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d78:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d7c:	8b 00                	mov    (%rax),%eax
  800d7e:	89 c0                	mov    %eax,%eax
  800d80:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800d84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800d88:	c9                   	leaveq 
  800d89:	c3                   	retq   

0000000000800d8a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d8a:	55                   	push   %rbp
  800d8b:	48 89 e5             	mov    %rsp,%rbp
  800d8e:	48 83 ec 20          	sub    $0x20,%rsp
  800d92:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800d96:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800d99:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800d9d:	7e 4f                	jle    800dee <getint+0x64>
		x=va_arg(*ap, long long);
  800d9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800da3:	8b 00                	mov    (%rax),%eax
  800da5:	83 f8 30             	cmp    $0x30,%eax
  800da8:	73 24                	jae    800dce <getint+0x44>
  800daa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dae:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800db2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800db6:	8b 00                	mov    (%rax),%eax
  800db8:	89 c0                	mov    %eax,%eax
  800dba:	48 01 d0             	add    %rdx,%rax
  800dbd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dc1:	8b 12                	mov    (%rdx),%edx
  800dc3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800dc6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dca:	89 0a                	mov    %ecx,(%rdx)
  800dcc:	eb 14                	jmp    800de2 <getint+0x58>
  800dce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dd2:	48 8b 40 08          	mov    0x8(%rax),%rax
  800dd6:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800dda:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dde:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800de2:	48 8b 00             	mov    (%rax),%rax
  800de5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800de9:	e9 9d 00 00 00       	jmpq   800e8b <getint+0x101>
	else if (lflag)
  800dee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800df2:	74 4c                	je     800e40 <getint+0xb6>
		x=va_arg(*ap, long);
  800df4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800df8:	8b 00                	mov    (%rax),%eax
  800dfa:	83 f8 30             	cmp    $0x30,%eax
  800dfd:	73 24                	jae    800e23 <getint+0x99>
  800dff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e03:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e0b:	8b 00                	mov    (%rax),%eax
  800e0d:	89 c0                	mov    %eax,%eax
  800e0f:	48 01 d0             	add    %rdx,%rax
  800e12:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e16:	8b 12                	mov    (%rdx),%edx
  800e18:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e1b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e1f:	89 0a                	mov    %ecx,(%rdx)
  800e21:	eb 14                	jmp    800e37 <getint+0xad>
  800e23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e27:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e2b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800e2f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e33:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e37:	48 8b 00             	mov    (%rax),%rax
  800e3a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e3e:	eb 4b                	jmp    800e8b <getint+0x101>
	else
		x=va_arg(*ap, int);
  800e40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e44:	8b 00                	mov    (%rax),%eax
  800e46:	83 f8 30             	cmp    $0x30,%eax
  800e49:	73 24                	jae    800e6f <getint+0xe5>
  800e4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e4f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e57:	8b 00                	mov    (%rax),%eax
  800e59:	89 c0                	mov    %eax,%eax
  800e5b:	48 01 d0             	add    %rdx,%rax
  800e5e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e62:	8b 12                	mov    (%rdx),%edx
  800e64:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e67:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e6b:	89 0a                	mov    %ecx,(%rdx)
  800e6d:	eb 14                	jmp    800e83 <getint+0xf9>
  800e6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e73:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e77:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800e7b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e7f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e83:	8b 00                	mov    (%rax),%eax
  800e85:	48 98                	cltq   
  800e87:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800e8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e8f:	c9                   	leaveq 
  800e90:	c3                   	retq   

0000000000800e91 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e91:	55                   	push   %rbp
  800e92:	48 89 e5             	mov    %rsp,%rbp
  800e95:	41 54                	push   %r12
  800e97:	53                   	push   %rbx
  800e98:	48 83 ec 60          	sub    $0x60,%rsp
  800e9c:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800ea0:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800ea4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800ea8:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800eac:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800eb0:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800eb4:	48 8b 0a             	mov    (%rdx),%rcx
  800eb7:	48 89 08             	mov    %rcx,(%rax)
  800eba:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ebe:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ec2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ec6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800eca:	eb 17                	jmp    800ee3 <vprintfmt+0x52>
			if (ch == '\0')
  800ecc:	85 db                	test   %ebx,%ebx
  800ece:	0f 84 c5 04 00 00    	je     801399 <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  800ed4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ed8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800edc:	48 89 d6             	mov    %rdx,%rsi
  800edf:	89 df                	mov    %ebx,%edi
  800ee1:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ee3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ee7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800eeb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800eef:	0f b6 00             	movzbl (%rax),%eax
  800ef2:	0f b6 d8             	movzbl %al,%ebx
  800ef5:	83 fb 25             	cmp    $0x25,%ebx
  800ef8:	75 d2                	jne    800ecc <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  800efa:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800efe:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800f05:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800f0c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800f13:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f1a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f1e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f22:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f26:	0f b6 00             	movzbl (%rax),%eax
  800f29:	0f b6 d8             	movzbl %al,%ebx
  800f2c:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800f2f:	83 f8 55             	cmp    $0x55,%eax
  800f32:	0f 87 2e 04 00 00    	ja     801366 <vprintfmt+0x4d5>
  800f38:	89 c0                	mov    %eax,%eax
  800f3a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800f41:	00 
  800f42:	48 b8 98 51 80 00 00 	movabs $0x805198,%rax
  800f49:	00 00 00 
  800f4c:	48 01 d0             	add    %rdx,%rax
  800f4f:	48 8b 00             	mov    (%rax),%rax
  800f52:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800f54:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800f58:	eb c0                	jmp    800f1a <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f5a:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800f5e:	eb ba                	jmp    800f1a <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f60:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800f67:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800f6a:	89 d0                	mov    %edx,%eax
  800f6c:	c1 e0 02             	shl    $0x2,%eax
  800f6f:	01 d0                	add    %edx,%eax
  800f71:	01 c0                	add    %eax,%eax
  800f73:	01 d8                	add    %ebx,%eax
  800f75:	83 e8 30             	sub    $0x30,%eax
  800f78:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800f7b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f7f:	0f b6 00             	movzbl (%rax),%eax
  800f82:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800f85:	83 fb 2f             	cmp    $0x2f,%ebx
  800f88:	7e 0c                	jle    800f96 <vprintfmt+0x105>
  800f8a:	83 fb 39             	cmp    $0x39,%ebx
  800f8d:	7f 07                	jg     800f96 <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  800f8f:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  800f94:	eb d1                	jmp    800f67 <vprintfmt+0xd6>
			goto process_precision;
  800f96:	eb 50                	jmp    800fe8 <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  800f98:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f9b:	83 f8 30             	cmp    $0x30,%eax
  800f9e:	73 17                	jae    800fb7 <vprintfmt+0x126>
  800fa0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fa4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fa7:	89 d2                	mov    %edx,%edx
  800fa9:	48 01 d0             	add    %rdx,%rax
  800fac:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800faf:	83 c2 08             	add    $0x8,%edx
  800fb2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800fb5:	eb 0c                	jmp    800fc3 <vprintfmt+0x132>
  800fb7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800fbb:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800fbf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800fc3:	8b 00                	mov    (%rax),%eax
  800fc5:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800fc8:	eb 1e                	jmp    800fe8 <vprintfmt+0x157>

		case '.':
			if (width < 0)
  800fca:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800fce:	79 07                	jns    800fd7 <vprintfmt+0x146>
				width = 0;
  800fd0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800fd7:	e9 3e ff ff ff       	jmpq   800f1a <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800fdc:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800fe3:	e9 32 ff ff ff       	jmpq   800f1a <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800fe8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800fec:	79 0d                	jns    800ffb <vprintfmt+0x16a>
				width = precision, precision = -1;
  800fee:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ff1:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800ff4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800ffb:	e9 1a ff ff ff       	jmpq   800f1a <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801000:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801004:	e9 11 ff ff ff       	jmpq   800f1a <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801009:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80100c:	83 f8 30             	cmp    $0x30,%eax
  80100f:	73 17                	jae    801028 <vprintfmt+0x197>
  801011:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801015:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801018:	89 d2                	mov    %edx,%edx
  80101a:	48 01 d0             	add    %rdx,%rax
  80101d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801020:	83 c2 08             	add    $0x8,%edx
  801023:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801026:	eb 0c                	jmp    801034 <vprintfmt+0x1a3>
  801028:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80102c:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801030:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801034:	8b 10                	mov    (%rax),%edx
  801036:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80103a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80103e:	48 89 ce             	mov    %rcx,%rsi
  801041:	89 d7                	mov    %edx,%edi
  801043:	ff d0                	callq  *%rax
			break;
  801045:	e9 4a 03 00 00       	jmpq   801394 <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80104a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80104d:	83 f8 30             	cmp    $0x30,%eax
  801050:	73 17                	jae    801069 <vprintfmt+0x1d8>
  801052:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801056:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801059:	89 d2                	mov    %edx,%edx
  80105b:	48 01 d0             	add    %rdx,%rax
  80105e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801061:	83 c2 08             	add    $0x8,%edx
  801064:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801067:	eb 0c                	jmp    801075 <vprintfmt+0x1e4>
  801069:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80106d:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801071:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801075:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  801077:	85 db                	test   %ebx,%ebx
  801079:	79 02                	jns    80107d <vprintfmt+0x1ec>
				err = -err;
  80107b:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80107d:	83 fb 15             	cmp    $0x15,%ebx
  801080:	7f 16                	jg     801098 <vprintfmt+0x207>
  801082:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  801089:	00 00 00 
  80108c:	48 63 d3             	movslq %ebx,%rdx
  80108f:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801093:	4d 85 e4             	test   %r12,%r12
  801096:	75 2e                	jne    8010c6 <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  801098:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80109c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010a0:	89 d9                	mov    %ebx,%ecx
  8010a2:	48 ba 81 51 80 00 00 	movabs $0x805181,%rdx
  8010a9:	00 00 00 
  8010ac:	48 89 c7             	mov    %rax,%rdi
  8010af:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b4:	49 b8 a2 13 80 00 00 	movabs $0x8013a2,%r8
  8010bb:	00 00 00 
  8010be:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8010c1:	e9 ce 02 00 00       	jmpq   801394 <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  8010c6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8010ca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010ce:	4c 89 e1             	mov    %r12,%rcx
  8010d1:	48 ba 8a 51 80 00 00 	movabs $0x80518a,%rdx
  8010d8:	00 00 00 
  8010db:	48 89 c7             	mov    %rax,%rdi
  8010de:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e3:	49 b8 a2 13 80 00 00 	movabs $0x8013a2,%r8
  8010ea:	00 00 00 
  8010ed:	41 ff d0             	callq  *%r8
			break;
  8010f0:	e9 9f 02 00 00       	jmpq   801394 <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8010f5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010f8:	83 f8 30             	cmp    $0x30,%eax
  8010fb:	73 17                	jae    801114 <vprintfmt+0x283>
  8010fd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801101:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801104:	89 d2                	mov    %edx,%edx
  801106:	48 01 d0             	add    %rdx,%rax
  801109:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80110c:	83 c2 08             	add    $0x8,%edx
  80110f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801112:	eb 0c                	jmp    801120 <vprintfmt+0x28f>
  801114:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801118:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80111c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801120:	4c 8b 20             	mov    (%rax),%r12
  801123:	4d 85 e4             	test   %r12,%r12
  801126:	75 0a                	jne    801132 <vprintfmt+0x2a1>
				p = "(null)";
  801128:	49 bc 8d 51 80 00 00 	movabs $0x80518d,%r12
  80112f:	00 00 00 
			if (width > 0 && padc != '-')
  801132:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801136:	7e 3f                	jle    801177 <vprintfmt+0x2e6>
  801138:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80113c:	74 39                	je     801177 <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80113e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801141:	48 98                	cltq   
  801143:	48 89 c6             	mov    %rax,%rsi
  801146:	4c 89 e7             	mov    %r12,%rdi
  801149:	48 b8 4e 16 80 00 00 	movabs $0x80164e,%rax
  801150:	00 00 00 
  801153:	ff d0                	callq  *%rax
  801155:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801158:	eb 17                	jmp    801171 <vprintfmt+0x2e0>
					putch(padc, putdat);
  80115a:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80115e:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801162:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801166:	48 89 ce             	mov    %rcx,%rsi
  801169:	89 d7                	mov    %edx,%edi
  80116b:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  80116d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801171:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801175:	7f e3                	jg     80115a <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801177:	eb 37                	jmp    8011b0 <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  801179:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80117d:	74 1e                	je     80119d <vprintfmt+0x30c>
  80117f:	83 fb 1f             	cmp    $0x1f,%ebx
  801182:	7e 05                	jle    801189 <vprintfmt+0x2f8>
  801184:	83 fb 7e             	cmp    $0x7e,%ebx
  801187:	7e 14                	jle    80119d <vprintfmt+0x30c>
					putch('?', putdat);
  801189:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80118d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801191:	48 89 d6             	mov    %rdx,%rsi
  801194:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801199:	ff d0                	callq  *%rax
  80119b:	eb 0f                	jmp    8011ac <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  80119d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011a1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011a5:	48 89 d6             	mov    %rdx,%rsi
  8011a8:	89 df                	mov    %ebx,%edi
  8011aa:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011ac:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8011b0:	4c 89 e0             	mov    %r12,%rax
  8011b3:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8011b7:	0f b6 00             	movzbl (%rax),%eax
  8011ba:	0f be d8             	movsbl %al,%ebx
  8011bd:	85 db                	test   %ebx,%ebx
  8011bf:	74 10                	je     8011d1 <vprintfmt+0x340>
  8011c1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8011c5:	78 b2                	js     801179 <vprintfmt+0x2e8>
  8011c7:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8011cb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8011cf:	79 a8                	jns    801179 <vprintfmt+0x2e8>
			for (; width > 0; width--)
  8011d1:	eb 16                	jmp    8011e9 <vprintfmt+0x358>
				putch(' ', putdat);
  8011d3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011d7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8011db:	48 89 d6             	mov    %rdx,%rsi
  8011de:	bf 20 00 00 00       	mov    $0x20,%edi
  8011e3:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  8011e5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8011e9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8011ed:	7f e4                	jg     8011d3 <vprintfmt+0x342>
			break;
  8011ef:	e9 a0 01 00 00       	jmpq   801394 <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8011f4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8011f8:	be 03 00 00 00       	mov    $0x3,%esi
  8011fd:	48 89 c7             	mov    %rax,%rdi
  801200:	48 b8 8a 0d 80 00 00 	movabs $0x800d8a,%rax
  801207:	00 00 00 
  80120a:	ff d0                	callq  *%rax
  80120c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801210:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801214:	48 85 c0             	test   %rax,%rax
  801217:	79 1d                	jns    801236 <vprintfmt+0x3a5>
				putch('-', putdat);
  801219:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80121d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801221:	48 89 d6             	mov    %rdx,%rsi
  801224:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801229:	ff d0                	callq  *%rax
				num = -(long long) num;
  80122b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122f:	48 f7 d8             	neg    %rax
  801232:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801236:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80123d:	e9 e5 00 00 00       	jmpq   801327 <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801242:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801246:	be 03 00 00 00       	mov    $0x3,%esi
  80124b:	48 89 c7             	mov    %rax,%rdi
  80124e:	48 b8 83 0c 80 00 00 	movabs $0x800c83,%rax
  801255:	00 00 00 
  801258:	ff d0                	callq  *%rax
  80125a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80125e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801265:	e9 bd 00 00 00       	jmpq   801327 <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80126a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80126e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801272:	48 89 d6             	mov    %rdx,%rsi
  801275:	bf 58 00 00 00       	mov    $0x58,%edi
  80127a:	ff d0                	callq  *%rax
			putch('X', putdat);
  80127c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801280:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801284:	48 89 d6             	mov    %rdx,%rsi
  801287:	bf 58 00 00 00       	mov    $0x58,%edi
  80128c:	ff d0                	callq  *%rax
			putch('X', putdat);
  80128e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801292:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801296:	48 89 d6             	mov    %rdx,%rsi
  801299:	bf 58 00 00 00       	mov    $0x58,%edi
  80129e:	ff d0                	callq  *%rax
			break;
  8012a0:	e9 ef 00 00 00       	jmpq   801394 <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  8012a5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012a9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012ad:	48 89 d6             	mov    %rdx,%rsi
  8012b0:	bf 30 00 00 00       	mov    $0x30,%edi
  8012b5:	ff d0                	callq  *%rax
			putch('x', putdat);
  8012b7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8012bb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012bf:	48 89 d6             	mov    %rdx,%rsi
  8012c2:	bf 78 00 00 00       	mov    $0x78,%edi
  8012c7:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8012c9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012cc:	83 f8 30             	cmp    $0x30,%eax
  8012cf:	73 17                	jae    8012e8 <vprintfmt+0x457>
  8012d1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8012d5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8012d8:	89 d2                	mov    %edx,%edx
  8012da:	48 01 d0             	add    %rdx,%rax
  8012dd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8012e0:	83 c2 08             	add    $0x8,%edx
  8012e3:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  8012e6:	eb 0c                	jmp    8012f4 <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  8012e8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8012ec:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8012f0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8012f4:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  8012f7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8012fb:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801302:	eb 23                	jmp    801327 <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801304:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801308:	be 03 00 00 00       	mov    $0x3,%esi
  80130d:	48 89 c7             	mov    %rax,%rdi
  801310:	48 b8 83 0c 80 00 00 	movabs $0x800c83,%rax
  801317:	00 00 00 
  80131a:	ff d0                	callq  *%rax
  80131c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801320:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801327:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80132c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80132f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801332:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801336:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80133a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80133e:	45 89 c1             	mov    %r8d,%r9d
  801341:	41 89 f8             	mov    %edi,%r8d
  801344:	48 89 c7             	mov    %rax,%rdi
  801347:	48 b8 ca 0b 80 00 00 	movabs $0x800bca,%rax
  80134e:	00 00 00 
  801351:	ff d0                	callq  *%rax
			break;
  801353:	eb 3f                	jmp    801394 <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801355:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801359:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80135d:	48 89 d6             	mov    %rdx,%rsi
  801360:	89 df                	mov    %ebx,%edi
  801362:	ff d0                	callq  *%rax
			break;
  801364:	eb 2e                	jmp    801394 <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801366:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80136a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80136e:	48 89 d6             	mov    %rdx,%rsi
  801371:	bf 25 00 00 00       	mov    $0x25,%edi
  801376:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801378:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80137d:	eb 05                	jmp    801384 <vprintfmt+0x4f3>
  80137f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801384:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801388:	48 83 e8 01          	sub    $0x1,%rax
  80138c:	0f b6 00             	movzbl (%rax),%eax
  80138f:	3c 25                	cmp    $0x25,%al
  801391:	75 ec                	jne    80137f <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  801393:	90                   	nop
		}
	}
  801394:	e9 31 fb ff ff       	jmpq   800eca <vprintfmt+0x39>
	va_end(aq);
}
  801399:	48 83 c4 60          	add    $0x60,%rsp
  80139d:	5b                   	pop    %rbx
  80139e:	41 5c                	pop    %r12
  8013a0:	5d                   	pop    %rbp
  8013a1:	c3                   	retq   

00000000008013a2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8013a2:	55                   	push   %rbp
  8013a3:	48 89 e5             	mov    %rsp,%rbp
  8013a6:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8013ad:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8013b4:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8013bb:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8013c2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8013c9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8013d0:	84 c0                	test   %al,%al
  8013d2:	74 20                	je     8013f4 <printfmt+0x52>
  8013d4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8013d8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8013dc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8013e0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8013e4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8013e8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8013ec:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8013f0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8013f4:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8013fb:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801402:	00 00 00 
  801405:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80140c:	00 00 00 
  80140f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801413:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80141a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801421:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801428:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80142f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801436:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80143d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801444:	48 89 c7             	mov    %rax,%rdi
  801447:	48 b8 91 0e 80 00 00 	movabs $0x800e91,%rax
  80144e:	00 00 00 
  801451:	ff d0                	callq  *%rax
	va_end(ap);
}
  801453:	c9                   	leaveq 
  801454:	c3                   	retq   

0000000000801455 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801455:	55                   	push   %rbp
  801456:	48 89 e5             	mov    %rsp,%rbp
  801459:	48 83 ec 10          	sub    $0x10,%rsp
  80145d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801460:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801464:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801468:	8b 40 10             	mov    0x10(%rax),%eax
  80146b:	8d 50 01             	lea    0x1(%rax),%edx
  80146e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801472:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801475:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801479:	48 8b 10             	mov    (%rax),%rdx
  80147c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801480:	48 8b 40 08          	mov    0x8(%rax),%rax
  801484:	48 39 c2             	cmp    %rax,%rdx
  801487:	73 17                	jae    8014a0 <sprintputch+0x4b>
		*b->buf++ = ch;
  801489:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80148d:	48 8b 00             	mov    (%rax),%rax
  801490:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801494:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801498:	48 89 0a             	mov    %rcx,(%rdx)
  80149b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80149e:	88 10                	mov    %dl,(%rax)
}
  8014a0:	c9                   	leaveq 
  8014a1:	c3                   	retq   

00000000008014a2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8014a2:	55                   	push   %rbp
  8014a3:	48 89 e5             	mov    %rsp,%rbp
  8014a6:	48 83 ec 50          	sub    $0x50,%rsp
  8014aa:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8014ae:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8014b1:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8014b5:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8014b9:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8014bd:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8014c1:	48 8b 0a             	mov    (%rdx),%rcx
  8014c4:	48 89 08             	mov    %rcx,(%rax)
  8014c7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8014cb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8014cf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8014d3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8014d7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8014db:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8014df:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8014e2:	48 98                	cltq   
  8014e4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014e8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8014ec:	48 01 d0             	add    %rdx,%rax
  8014ef:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8014f3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8014fa:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8014ff:	74 06                	je     801507 <vsnprintf+0x65>
  801501:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801505:	7f 07                	jg     80150e <vsnprintf+0x6c>
		return -E_INVAL;
  801507:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80150c:	eb 2f                	jmp    80153d <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80150e:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801512:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801516:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80151a:	48 89 c6             	mov    %rax,%rsi
  80151d:	48 bf 55 14 80 00 00 	movabs $0x801455,%rdi
  801524:	00 00 00 
  801527:	48 b8 91 0e 80 00 00 	movabs $0x800e91,%rax
  80152e:	00 00 00 
  801531:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801533:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801537:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80153a:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80153d:	c9                   	leaveq 
  80153e:	c3                   	retq   

000000000080153f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80153f:	55                   	push   %rbp
  801540:	48 89 e5             	mov    %rsp,%rbp
  801543:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80154a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801551:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801557:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80155e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801565:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80156c:	84 c0                	test   %al,%al
  80156e:	74 20                	je     801590 <snprintf+0x51>
  801570:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801574:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801578:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80157c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801580:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801584:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801588:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80158c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801590:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801597:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80159e:	00 00 00 
  8015a1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8015a8:	00 00 00 
  8015ab:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8015af:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8015b6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8015bd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8015c4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8015cb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8015d2:	48 8b 0a             	mov    (%rdx),%rcx
  8015d5:	48 89 08             	mov    %rcx,(%rax)
  8015d8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8015dc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8015e0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8015e4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8015e8:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8015ef:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8015f6:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8015fc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801603:	48 89 c7             	mov    %rax,%rdi
  801606:	48 b8 a2 14 80 00 00 	movabs $0x8014a2,%rax
  80160d:	00 00 00 
  801610:	ff d0                	callq  *%rax
  801612:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801618:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80161e:	c9                   	leaveq 
  80161f:	c3                   	retq   

0000000000801620 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801620:	55                   	push   %rbp
  801621:	48 89 e5             	mov    %rsp,%rbp
  801624:	48 83 ec 18          	sub    $0x18,%rsp
  801628:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80162c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801633:	eb 09                	jmp    80163e <strlen+0x1e>
		n++;
  801635:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  801639:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80163e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801642:	0f b6 00             	movzbl (%rax),%eax
  801645:	84 c0                	test   %al,%al
  801647:	75 ec                	jne    801635 <strlen+0x15>
	return n;
  801649:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80164c:	c9                   	leaveq 
  80164d:	c3                   	retq   

000000000080164e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80164e:	55                   	push   %rbp
  80164f:	48 89 e5             	mov    %rsp,%rbp
  801652:	48 83 ec 20          	sub    $0x20,%rsp
  801656:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80165a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80165e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801665:	eb 0e                	jmp    801675 <strnlen+0x27>
		n++;
  801667:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80166b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801670:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801675:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80167a:	74 0b                	je     801687 <strnlen+0x39>
  80167c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801680:	0f b6 00             	movzbl (%rax),%eax
  801683:	84 c0                	test   %al,%al
  801685:	75 e0                	jne    801667 <strnlen+0x19>
	return n;
  801687:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80168a:	c9                   	leaveq 
  80168b:	c3                   	retq   

000000000080168c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80168c:	55                   	push   %rbp
  80168d:	48 89 e5             	mov    %rsp,%rbp
  801690:	48 83 ec 20          	sub    $0x20,%rsp
  801694:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801698:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80169c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016a0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8016a4:	90                   	nop
  8016a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016a9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016ad:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8016b1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8016b5:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8016b9:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8016bd:	0f b6 12             	movzbl (%rdx),%edx
  8016c0:	88 10                	mov    %dl,(%rax)
  8016c2:	0f b6 00             	movzbl (%rax),%eax
  8016c5:	84 c0                	test   %al,%al
  8016c7:	75 dc                	jne    8016a5 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8016c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016cd:	c9                   	leaveq 
  8016ce:	c3                   	retq   

00000000008016cf <strcat>:

char *
strcat(char *dst, const char *src)
{
  8016cf:	55                   	push   %rbp
  8016d0:	48 89 e5             	mov    %rsp,%rbp
  8016d3:	48 83 ec 20          	sub    $0x20,%rsp
  8016d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8016df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016e3:	48 89 c7             	mov    %rax,%rdi
  8016e6:	48 b8 20 16 80 00 00 	movabs $0x801620,%rax
  8016ed:	00 00 00 
  8016f0:	ff d0                	callq  *%rax
  8016f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8016f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016f8:	48 63 d0             	movslq %eax,%rdx
  8016fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ff:	48 01 c2             	add    %rax,%rdx
  801702:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801706:	48 89 c6             	mov    %rax,%rsi
  801709:	48 89 d7             	mov    %rdx,%rdi
  80170c:	48 b8 8c 16 80 00 00 	movabs $0x80168c,%rax
  801713:	00 00 00 
  801716:	ff d0                	callq  *%rax
	return dst;
  801718:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80171c:	c9                   	leaveq 
  80171d:	c3                   	retq   

000000000080171e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80171e:	55                   	push   %rbp
  80171f:	48 89 e5             	mov    %rsp,%rbp
  801722:	48 83 ec 28          	sub    $0x28,%rsp
  801726:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80172a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80172e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801732:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801736:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80173a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801741:	00 
  801742:	eb 2a                	jmp    80176e <strncpy+0x50>
		*dst++ = *src;
  801744:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801748:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80174c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801750:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801754:	0f b6 12             	movzbl (%rdx),%edx
  801757:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801759:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80175d:	0f b6 00             	movzbl (%rax),%eax
  801760:	84 c0                	test   %al,%al
  801762:	74 05                	je     801769 <strncpy+0x4b>
			src++;
  801764:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  801769:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80176e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801772:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801776:	72 cc                	jb     801744 <strncpy+0x26>
	}
	return ret;
  801778:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80177c:	c9                   	leaveq 
  80177d:	c3                   	retq   

000000000080177e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80177e:	55                   	push   %rbp
  80177f:	48 89 e5             	mov    %rsp,%rbp
  801782:	48 83 ec 28          	sub    $0x28,%rsp
  801786:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80178a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80178e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801792:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801796:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80179a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80179f:	74 3d                	je     8017de <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8017a1:	eb 1d                	jmp    8017c0 <strlcpy+0x42>
			*dst++ = *src++;
  8017a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017a7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017ab:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8017af:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8017b3:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8017b7:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8017bb:	0f b6 12             	movzbl (%rdx),%edx
  8017be:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  8017c0:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8017c5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8017ca:	74 0b                	je     8017d7 <strlcpy+0x59>
  8017cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017d0:	0f b6 00             	movzbl (%rax),%eax
  8017d3:	84 c0                	test   %al,%al
  8017d5:	75 cc                	jne    8017a3 <strlcpy+0x25>
		*dst = '\0';
  8017d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017db:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8017de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017e6:	48 29 c2             	sub    %rax,%rdx
  8017e9:	48 89 d0             	mov    %rdx,%rax
}
  8017ec:	c9                   	leaveq 
  8017ed:	c3                   	retq   

00000000008017ee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8017ee:	55                   	push   %rbp
  8017ef:	48 89 e5             	mov    %rsp,%rbp
  8017f2:	48 83 ec 10          	sub    $0x10,%rsp
  8017f6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017fa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8017fe:	eb 0a                	jmp    80180a <strcmp+0x1c>
		p++, q++;
  801800:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801805:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  80180a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80180e:	0f b6 00             	movzbl (%rax),%eax
  801811:	84 c0                	test   %al,%al
  801813:	74 12                	je     801827 <strcmp+0x39>
  801815:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801819:	0f b6 10             	movzbl (%rax),%edx
  80181c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801820:	0f b6 00             	movzbl (%rax),%eax
  801823:	38 c2                	cmp    %al,%dl
  801825:	74 d9                	je     801800 <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801827:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80182b:	0f b6 00             	movzbl (%rax),%eax
  80182e:	0f b6 d0             	movzbl %al,%edx
  801831:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801835:	0f b6 00             	movzbl (%rax),%eax
  801838:	0f b6 c0             	movzbl %al,%eax
  80183b:	29 c2                	sub    %eax,%edx
  80183d:	89 d0                	mov    %edx,%eax
}
  80183f:	c9                   	leaveq 
  801840:	c3                   	retq   

0000000000801841 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801841:	55                   	push   %rbp
  801842:	48 89 e5             	mov    %rsp,%rbp
  801845:	48 83 ec 18          	sub    $0x18,%rsp
  801849:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80184d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801851:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801855:	eb 0f                	jmp    801866 <strncmp+0x25>
		n--, p++, q++;
  801857:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80185c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801861:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  801866:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80186b:	74 1d                	je     80188a <strncmp+0x49>
  80186d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801871:	0f b6 00             	movzbl (%rax),%eax
  801874:	84 c0                	test   %al,%al
  801876:	74 12                	je     80188a <strncmp+0x49>
  801878:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80187c:	0f b6 10             	movzbl (%rax),%edx
  80187f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801883:	0f b6 00             	movzbl (%rax),%eax
  801886:	38 c2                	cmp    %al,%dl
  801888:	74 cd                	je     801857 <strncmp+0x16>
	if (n == 0)
  80188a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80188f:	75 07                	jne    801898 <strncmp+0x57>
		return 0;
  801891:	b8 00 00 00 00       	mov    $0x0,%eax
  801896:	eb 18                	jmp    8018b0 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801898:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80189c:	0f b6 00             	movzbl (%rax),%eax
  80189f:	0f b6 d0             	movzbl %al,%edx
  8018a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018a6:	0f b6 00             	movzbl (%rax),%eax
  8018a9:	0f b6 c0             	movzbl %al,%eax
  8018ac:	29 c2                	sub    %eax,%edx
  8018ae:	89 d0                	mov    %edx,%eax
}
  8018b0:	c9                   	leaveq 
  8018b1:	c3                   	retq   

00000000008018b2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8018b2:	55                   	push   %rbp
  8018b3:	48 89 e5             	mov    %rsp,%rbp
  8018b6:	48 83 ec 10          	sub    $0x10,%rsp
  8018ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018be:	89 f0                	mov    %esi,%eax
  8018c0:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8018c3:	eb 17                	jmp    8018dc <strchr+0x2a>
		if (*s == c)
  8018c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018c9:	0f b6 00             	movzbl (%rax),%eax
  8018cc:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8018cf:	75 06                	jne    8018d7 <strchr+0x25>
			return (char *) s;
  8018d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018d5:	eb 15                	jmp    8018ec <strchr+0x3a>
	for (; *s; s++)
  8018d7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018e0:	0f b6 00             	movzbl (%rax),%eax
  8018e3:	84 c0                	test   %al,%al
  8018e5:	75 de                	jne    8018c5 <strchr+0x13>
	return 0;
  8018e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018ec:	c9                   	leaveq 
  8018ed:	c3                   	retq   

00000000008018ee <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8018ee:	55                   	push   %rbp
  8018ef:	48 89 e5             	mov    %rsp,%rbp
  8018f2:	48 83 ec 10          	sub    $0x10,%rsp
  8018f6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018fa:	89 f0                	mov    %esi,%eax
  8018fc:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8018ff:	eb 13                	jmp    801914 <strfind+0x26>
		if (*s == c)
  801901:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801905:	0f b6 00             	movzbl (%rax),%eax
  801908:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80190b:	75 02                	jne    80190f <strfind+0x21>
			break;
  80190d:	eb 10                	jmp    80191f <strfind+0x31>
	for (; *s; s++)
  80190f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801914:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801918:	0f b6 00             	movzbl (%rax),%eax
  80191b:	84 c0                	test   %al,%al
  80191d:	75 e2                	jne    801901 <strfind+0x13>
	return (char *) s;
  80191f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801923:	c9                   	leaveq 
  801924:	c3                   	retq   

0000000000801925 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801925:	55                   	push   %rbp
  801926:	48 89 e5             	mov    %rsp,%rbp
  801929:	48 83 ec 18          	sub    $0x18,%rsp
  80192d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801931:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801934:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801938:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80193d:	75 06                	jne    801945 <memset+0x20>
		return v;
  80193f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801943:	eb 69                	jmp    8019ae <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801945:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801949:	83 e0 03             	and    $0x3,%eax
  80194c:	48 85 c0             	test   %rax,%rax
  80194f:	75 48                	jne    801999 <memset+0x74>
  801951:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801955:	83 e0 03             	and    $0x3,%eax
  801958:	48 85 c0             	test   %rax,%rax
  80195b:	75 3c                	jne    801999 <memset+0x74>
		c &= 0xFF;
  80195d:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801964:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801967:	c1 e0 18             	shl    $0x18,%eax
  80196a:	89 c2                	mov    %eax,%edx
  80196c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80196f:	c1 e0 10             	shl    $0x10,%eax
  801972:	09 c2                	or     %eax,%edx
  801974:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801977:	c1 e0 08             	shl    $0x8,%eax
  80197a:	09 d0                	or     %edx,%eax
  80197c:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80197f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801983:	48 c1 e8 02          	shr    $0x2,%rax
  801987:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  80198a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80198e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801991:	48 89 d7             	mov    %rdx,%rdi
  801994:	fc                   	cld    
  801995:	f3 ab                	rep stos %eax,%es:(%rdi)
  801997:	eb 11                	jmp    8019aa <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801999:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80199d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019a0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019a4:	48 89 d7             	mov    %rdx,%rdi
  8019a7:	fc                   	cld    
  8019a8:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8019aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019ae:	c9                   	leaveq 
  8019af:	c3                   	retq   

00000000008019b0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8019b0:	55                   	push   %rbp
  8019b1:	48 89 e5             	mov    %rsp,%rbp
  8019b4:	48 83 ec 28          	sub    $0x28,%rsp
  8019b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019c0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8019c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8019cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019d0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8019d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019d8:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8019dc:	0f 83 88 00 00 00    	jae    801a6a <memmove+0xba>
  8019e2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ea:	48 01 d0             	add    %rdx,%rax
  8019ed:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8019f1:	76 77                	jbe    801a6a <memmove+0xba>
		s += n;
  8019f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f7:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8019fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ff:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801a03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a07:	83 e0 03             	and    $0x3,%eax
  801a0a:	48 85 c0             	test   %rax,%rax
  801a0d:	75 3b                	jne    801a4a <memmove+0x9a>
  801a0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a13:	83 e0 03             	and    $0x3,%eax
  801a16:	48 85 c0             	test   %rax,%rax
  801a19:	75 2f                	jne    801a4a <memmove+0x9a>
  801a1b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1f:	83 e0 03             	and    $0x3,%eax
  801a22:	48 85 c0             	test   %rax,%rax
  801a25:	75 23                	jne    801a4a <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801a27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a2b:	48 83 e8 04          	sub    $0x4,%rax
  801a2f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a33:	48 83 ea 04          	sub    $0x4,%rdx
  801a37:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801a3b:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  801a3f:	48 89 c7             	mov    %rax,%rdi
  801a42:	48 89 d6             	mov    %rdx,%rsi
  801a45:	fd                   	std    
  801a46:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801a48:	eb 1d                	jmp    801a67 <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801a4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a4e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801a52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a56:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  801a5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a5e:	48 89 d7             	mov    %rdx,%rdi
  801a61:	48 89 c1             	mov    %rax,%rcx
  801a64:	fd                   	std    
  801a65:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801a67:	fc                   	cld    
  801a68:	eb 57                	jmp    801ac1 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801a6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a6e:	83 e0 03             	and    $0x3,%eax
  801a71:	48 85 c0             	test   %rax,%rax
  801a74:	75 36                	jne    801aac <memmove+0xfc>
  801a76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a7a:	83 e0 03             	and    $0x3,%eax
  801a7d:	48 85 c0             	test   %rax,%rax
  801a80:	75 2a                	jne    801aac <memmove+0xfc>
  801a82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a86:	83 e0 03             	and    $0x3,%eax
  801a89:	48 85 c0             	test   %rax,%rax
  801a8c:	75 1e                	jne    801aac <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801a8e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a92:	48 c1 e8 02          	shr    $0x2,%rax
  801a96:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  801a99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a9d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801aa1:	48 89 c7             	mov    %rax,%rdi
  801aa4:	48 89 d6             	mov    %rdx,%rsi
  801aa7:	fc                   	cld    
  801aa8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801aaa:	eb 15                	jmp    801ac1 <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  801aac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ab0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ab4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801ab8:	48 89 c7             	mov    %rax,%rdi
  801abb:	48 89 d6             	mov    %rdx,%rsi
  801abe:	fc                   	cld    
  801abf:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801ac1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801ac5:	c9                   	leaveq 
  801ac6:	c3                   	retq   

0000000000801ac7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801ac7:	55                   	push   %rbp
  801ac8:	48 89 e5             	mov    %rsp,%rbp
  801acb:	48 83 ec 18          	sub    $0x18,%rsp
  801acf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ad3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ad7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801adb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801adf:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801ae3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ae7:	48 89 ce             	mov    %rcx,%rsi
  801aea:	48 89 c7             	mov    %rax,%rdi
  801aed:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  801af4:	00 00 00 
  801af7:	ff d0                	callq  *%rax
}
  801af9:	c9                   	leaveq 
  801afa:	c3                   	retq   

0000000000801afb <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801afb:	55                   	push   %rbp
  801afc:	48 89 e5             	mov    %rsp,%rbp
  801aff:	48 83 ec 28          	sub    $0x28,%rsp
  801b03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b07:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801b0b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801b0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b13:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801b17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b1b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801b1f:	eb 36                	jmp    801b57 <memcmp+0x5c>
		if (*s1 != *s2)
  801b21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b25:	0f b6 10             	movzbl (%rax),%edx
  801b28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b2c:	0f b6 00             	movzbl (%rax),%eax
  801b2f:	38 c2                	cmp    %al,%dl
  801b31:	74 1a                	je     801b4d <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801b33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b37:	0f b6 00             	movzbl (%rax),%eax
  801b3a:	0f b6 d0             	movzbl %al,%edx
  801b3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b41:	0f b6 00             	movzbl (%rax),%eax
  801b44:	0f b6 c0             	movzbl %al,%eax
  801b47:	29 c2                	sub    %eax,%edx
  801b49:	89 d0                	mov    %edx,%eax
  801b4b:	eb 20                	jmp    801b6d <memcmp+0x72>
		s1++, s2++;
  801b4d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b52:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  801b57:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b5b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801b5f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801b63:	48 85 c0             	test   %rax,%rax
  801b66:	75 b9                	jne    801b21 <memcmp+0x26>
	}

	return 0;
  801b68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b6d:	c9                   	leaveq 
  801b6e:	c3                   	retq   

0000000000801b6f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801b6f:	55                   	push   %rbp
  801b70:	48 89 e5             	mov    %rsp,%rbp
  801b73:	48 83 ec 28          	sub    $0x28,%rsp
  801b77:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b7b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801b7e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801b82:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b86:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b8a:	48 01 d0             	add    %rdx,%rax
  801b8d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801b91:	eb 15                	jmp    801ba8 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801b93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b97:	0f b6 00             	movzbl (%rax),%eax
  801b9a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801b9d:	38 d0                	cmp    %dl,%al
  801b9f:	75 02                	jne    801ba3 <memfind+0x34>
			break;
  801ba1:	eb 0f                	jmp    801bb2 <memfind+0x43>
	for (; s < ends; s++)
  801ba3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801ba8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bac:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801bb0:	72 e1                	jb     801b93 <memfind+0x24>
	return (void *) s;
  801bb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801bb6:	c9                   	leaveq 
  801bb7:	c3                   	retq   

0000000000801bb8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801bb8:	55                   	push   %rbp
  801bb9:	48 89 e5             	mov    %rsp,%rbp
  801bbc:	48 83 ec 38          	sub    $0x38,%rsp
  801bc0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801bc4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801bc8:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801bcb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801bd2:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801bd9:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801bda:	eb 05                	jmp    801be1 <strtol+0x29>
		s++;
  801bdc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  801be1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801be5:	0f b6 00             	movzbl (%rax),%eax
  801be8:	3c 20                	cmp    $0x20,%al
  801bea:	74 f0                	je     801bdc <strtol+0x24>
  801bec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bf0:	0f b6 00             	movzbl (%rax),%eax
  801bf3:	3c 09                	cmp    $0x9,%al
  801bf5:	74 e5                	je     801bdc <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  801bf7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bfb:	0f b6 00             	movzbl (%rax),%eax
  801bfe:	3c 2b                	cmp    $0x2b,%al
  801c00:	75 07                	jne    801c09 <strtol+0x51>
		s++;
  801c02:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c07:	eb 17                	jmp    801c20 <strtol+0x68>
	else if (*s == '-')
  801c09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c0d:	0f b6 00             	movzbl (%rax),%eax
  801c10:	3c 2d                	cmp    $0x2d,%al
  801c12:	75 0c                	jne    801c20 <strtol+0x68>
		s++, neg = 1;
  801c14:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c19:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c20:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801c24:	74 06                	je     801c2c <strtol+0x74>
  801c26:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801c2a:	75 28                	jne    801c54 <strtol+0x9c>
  801c2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c30:	0f b6 00             	movzbl (%rax),%eax
  801c33:	3c 30                	cmp    $0x30,%al
  801c35:	75 1d                	jne    801c54 <strtol+0x9c>
  801c37:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c3b:	48 83 c0 01          	add    $0x1,%rax
  801c3f:	0f b6 00             	movzbl (%rax),%eax
  801c42:	3c 78                	cmp    $0x78,%al
  801c44:	75 0e                	jne    801c54 <strtol+0x9c>
		s += 2, base = 16;
  801c46:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801c4b:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801c52:	eb 2c                	jmp    801c80 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801c54:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801c58:	75 19                	jne    801c73 <strtol+0xbb>
  801c5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c5e:	0f b6 00             	movzbl (%rax),%eax
  801c61:	3c 30                	cmp    $0x30,%al
  801c63:	75 0e                	jne    801c73 <strtol+0xbb>
		s++, base = 8;
  801c65:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c6a:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801c71:	eb 0d                	jmp    801c80 <strtol+0xc8>
	else if (base == 0)
  801c73:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801c77:	75 07                	jne    801c80 <strtol+0xc8>
		base = 10;
  801c79:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801c80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c84:	0f b6 00             	movzbl (%rax),%eax
  801c87:	3c 2f                	cmp    $0x2f,%al
  801c89:	7e 1d                	jle    801ca8 <strtol+0xf0>
  801c8b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c8f:	0f b6 00             	movzbl (%rax),%eax
  801c92:	3c 39                	cmp    $0x39,%al
  801c94:	7f 12                	jg     801ca8 <strtol+0xf0>
			dig = *s - '0';
  801c96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c9a:	0f b6 00             	movzbl (%rax),%eax
  801c9d:	0f be c0             	movsbl %al,%eax
  801ca0:	83 e8 30             	sub    $0x30,%eax
  801ca3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ca6:	eb 4e                	jmp    801cf6 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801ca8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cac:	0f b6 00             	movzbl (%rax),%eax
  801caf:	3c 60                	cmp    $0x60,%al
  801cb1:	7e 1d                	jle    801cd0 <strtol+0x118>
  801cb3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cb7:	0f b6 00             	movzbl (%rax),%eax
  801cba:	3c 7a                	cmp    $0x7a,%al
  801cbc:	7f 12                	jg     801cd0 <strtol+0x118>
			dig = *s - 'a' + 10;
  801cbe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cc2:	0f b6 00             	movzbl (%rax),%eax
  801cc5:	0f be c0             	movsbl %al,%eax
  801cc8:	83 e8 57             	sub    $0x57,%eax
  801ccb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801cce:	eb 26                	jmp    801cf6 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801cd0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cd4:	0f b6 00             	movzbl (%rax),%eax
  801cd7:	3c 40                	cmp    $0x40,%al
  801cd9:	7e 48                	jle    801d23 <strtol+0x16b>
  801cdb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cdf:	0f b6 00             	movzbl (%rax),%eax
  801ce2:	3c 5a                	cmp    $0x5a,%al
  801ce4:	7f 3d                	jg     801d23 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801ce6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cea:	0f b6 00             	movzbl (%rax),%eax
  801ced:	0f be c0             	movsbl %al,%eax
  801cf0:	83 e8 37             	sub    $0x37,%eax
  801cf3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801cf6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801cf9:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801cfc:	7c 02                	jl     801d00 <strtol+0x148>
			break;
  801cfe:	eb 23                	jmp    801d23 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801d00:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801d05:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801d08:	48 98                	cltq   
  801d0a:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801d0f:	48 89 c2             	mov    %rax,%rdx
  801d12:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d15:	48 98                	cltq   
  801d17:	48 01 d0             	add    %rdx,%rax
  801d1a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801d1e:	e9 5d ff ff ff       	jmpq   801c80 <strtol+0xc8>

	if (endptr)
  801d23:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801d28:	74 0b                	je     801d35 <strtol+0x17d>
		*endptr = (char *) s;
  801d2a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d2e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801d32:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801d35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d39:	74 09                	je     801d44 <strtol+0x18c>
  801d3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d3f:	48 f7 d8             	neg    %rax
  801d42:	eb 04                	jmp    801d48 <strtol+0x190>
  801d44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801d48:	c9                   	leaveq 
  801d49:	c3                   	retq   

0000000000801d4a <strstr>:

char * strstr(const char *in, const char *str)
{
  801d4a:	55                   	push   %rbp
  801d4b:	48 89 e5             	mov    %rsp,%rbp
  801d4e:	48 83 ec 30          	sub    $0x30,%rsp
  801d52:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801d56:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801d5a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d5e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801d62:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801d66:	0f b6 00             	movzbl (%rax),%eax
  801d69:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801d6c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801d70:	75 06                	jne    801d78 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801d72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d76:	eb 6b                	jmp    801de3 <strstr+0x99>

	len = strlen(str);
  801d78:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d7c:	48 89 c7             	mov    %rax,%rdi
  801d7f:	48 b8 20 16 80 00 00 	movabs $0x801620,%rax
  801d86:	00 00 00 
  801d89:	ff d0                	callq  *%rax
  801d8b:	48 98                	cltq   
  801d8d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801d91:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d95:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801d99:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801d9d:	0f b6 00             	movzbl (%rax),%eax
  801da0:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801da3:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801da7:	75 07                	jne    801db0 <strstr+0x66>
				return (char *) 0;
  801da9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dae:	eb 33                	jmp    801de3 <strstr+0x99>
		} while (sc != c);
  801db0:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801db4:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801db7:	75 d8                	jne    801d91 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801db9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dbd:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801dc1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dc5:	48 89 ce             	mov    %rcx,%rsi
  801dc8:	48 89 c7             	mov    %rax,%rdi
  801dcb:	48 b8 41 18 80 00 00 	movabs $0x801841,%rax
  801dd2:	00 00 00 
  801dd5:	ff d0                	callq  *%rax
  801dd7:	85 c0                	test   %eax,%eax
  801dd9:	75 b6                	jne    801d91 <strstr+0x47>

	return (char *) (in - 1);
  801ddb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ddf:	48 83 e8 01          	sub    $0x1,%rax
}
  801de3:	c9                   	leaveq 
  801de4:	c3                   	retq   

0000000000801de5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801de5:	55                   	push   %rbp
  801de6:	48 89 e5             	mov    %rsp,%rbp
  801de9:	53                   	push   %rbx
  801dea:	48 83 ec 48          	sub    $0x48,%rsp
  801dee:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801df1:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801df4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801df8:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801dfc:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801e00:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e04:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e07:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801e0b:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801e0f:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801e13:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801e17:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801e1b:	4c 89 c3             	mov    %r8,%rbx
  801e1e:	cd 30                	int    $0x30
  801e20:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801e24:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801e28:	74 3e                	je     801e68 <syscall+0x83>
  801e2a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801e2f:	7e 37                	jle    801e68 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801e31:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801e35:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e38:	49 89 d0             	mov    %rdx,%r8
  801e3b:	89 c1                	mov    %eax,%ecx
  801e3d:	48 ba 48 54 80 00 00 	movabs $0x805448,%rdx
  801e44:	00 00 00 
  801e47:	be 23 00 00 00       	mov    $0x23,%esi
  801e4c:	48 bf 65 54 80 00 00 	movabs $0x805465,%rdi
  801e53:	00 00 00 
  801e56:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5b:	49 b9 b9 08 80 00 00 	movabs $0x8008b9,%r9
  801e62:	00 00 00 
  801e65:	41 ff d1             	callq  *%r9

	return ret;
  801e68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801e6c:	48 83 c4 48          	add    $0x48,%rsp
  801e70:	5b                   	pop    %rbx
  801e71:	5d                   	pop    %rbp
  801e72:	c3                   	retq   

0000000000801e73 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801e73:	55                   	push   %rbp
  801e74:	48 89 e5             	mov    %rsp,%rbp
  801e77:	48 83 ec 10          	sub    $0x10,%rsp
  801e7b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e7f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801e83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e87:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e8b:	48 83 ec 08          	sub    $0x8,%rsp
  801e8f:	6a 00                	pushq  $0x0
  801e91:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e97:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e9d:	48 89 d1             	mov    %rdx,%rcx
  801ea0:	48 89 c2             	mov    %rax,%rdx
  801ea3:	be 00 00 00 00       	mov    $0x0,%esi
  801ea8:	bf 00 00 00 00       	mov    $0x0,%edi
  801ead:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  801eb4:	00 00 00 
  801eb7:	ff d0                	callq  *%rax
  801eb9:	48 83 c4 10          	add    $0x10,%rsp
}
  801ebd:	c9                   	leaveq 
  801ebe:	c3                   	retq   

0000000000801ebf <sys_cgetc>:

int
sys_cgetc(void)
{
  801ebf:	55                   	push   %rbp
  801ec0:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801ec3:	48 83 ec 08          	sub    $0x8,%rsp
  801ec7:	6a 00                	pushq  $0x0
  801ec9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ecf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ed5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801eda:	ba 00 00 00 00       	mov    $0x0,%edx
  801edf:	be 00 00 00 00       	mov    $0x0,%esi
  801ee4:	bf 01 00 00 00       	mov    $0x1,%edi
  801ee9:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  801ef0:	00 00 00 
  801ef3:	ff d0                	callq  *%rax
  801ef5:	48 83 c4 10          	add    $0x10,%rsp
}
  801ef9:	c9                   	leaveq 
  801efa:	c3                   	retq   

0000000000801efb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801efb:	55                   	push   %rbp
  801efc:	48 89 e5             	mov    %rsp,%rbp
  801eff:	48 83 ec 10          	sub    $0x10,%rsp
  801f03:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801f06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f09:	48 98                	cltq   
  801f0b:	48 83 ec 08          	sub    $0x8,%rsp
  801f0f:	6a 00                	pushq  $0x0
  801f11:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f17:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f1d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f22:	48 89 c2             	mov    %rax,%rdx
  801f25:	be 01 00 00 00       	mov    $0x1,%esi
  801f2a:	bf 03 00 00 00       	mov    $0x3,%edi
  801f2f:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  801f36:	00 00 00 
  801f39:	ff d0                	callq  *%rax
  801f3b:	48 83 c4 10          	add    $0x10,%rsp
}
  801f3f:	c9                   	leaveq 
  801f40:	c3                   	retq   

0000000000801f41 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801f41:	55                   	push   %rbp
  801f42:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801f45:	48 83 ec 08          	sub    $0x8,%rsp
  801f49:	6a 00                	pushq  $0x0
  801f4b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f51:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f57:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f5c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f61:	be 00 00 00 00       	mov    $0x0,%esi
  801f66:	bf 02 00 00 00       	mov    $0x2,%edi
  801f6b:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  801f72:	00 00 00 
  801f75:	ff d0                	callq  *%rax
  801f77:	48 83 c4 10          	add    $0x10,%rsp
}
  801f7b:	c9                   	leaveq 
  801f7c:	c3                   	retq   

0000000000801f7d <sys_yield>:

void
sys_yield(void)
{
  801f7d:	55                   	push   %rbp
  801f7e:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801f81:	48 83 ec 08          	sub    $0x8,%rsp
  801f85:	6a 00                	pushq  $0x0
  801f87:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f8d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f93:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f98:	ba 00 00 00 00       	mov    $0x0,%edx
  801f9d:	be 00 00 00 00       	mov    $0x0,%esi
  801fa2:	bf 0b 00 00 00       	mov    $0xb,%edi
  801fa7:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  801fae:	00 00 00 
  801fb1:	ff d0                	callq  *%rax
  801fb3:	48 83 c4 10          	add    $0x10,%rsp
}
  801fb7:	c9                   	leaveq 
  801fb8:	c3                   	retq   

0000000000801fb9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801fb9:	55                   	push   %rbp
  801fba:	48 89 e5             	mov    %rsp,%rbp
  801fbd:	48 83 ec 10          	sub    $0x10,%rsp
  801fc1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fc4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801fc8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801fcb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801fce:	48 63 c8             	movslq %eax,%rcx
  801fd1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fd8:	48 98                	cltq   
  801fda:	48 83 ec 08          	sub    $0x8,%rsp
  801fde:	6a 00                	pushq  $0x0
  801fe0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fe6:	49 89 c8             	mov    %rcx,%r8
  801fe9:	48 89 d1             	mov    %rdx,%rcx
  801fec:	48 89 c2             	mov    %rax,%rdx
  801fef:	be 01 00 00 00       	mov    $0x1,%esi
  801ff4:	bf 04 00 00 00       	mov    $0x4,%edi
  801ff9:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  802000:	00 00 00 
  802003:	ff d0                	callq  *%rax
  802005:	48 83 c4 10          	add    $0x10,%rsp
}
  802009:	c9                   	leaveq 
  80200a:	c3                   	retq   

000000000080200b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80200b:	55                   	push   %rbp
  80200c:	48 89 e5             	mov    %rsp,%rbp
  80200f:	48 83 ec 20          	sub    $0x20,%rsp
  802013:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802016:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80201a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80201d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802021:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802025:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802028:	48 63 c8             	movslq %eax,%rcx
  80202b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80202f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802032:	48 63 f0             	movslq %eax,%rsi
  802035:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802039:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80203c:	48 98                	cltq   
  80203e:	48 83 ec 08          	sub    $0x8,%rsp
  802042:	51                   	push   %rcx
  802043:	49 89 f9             	mov    %rdi,%r9
  802046:	49 89 f0             	mov    %rsi,%r8
  802049:	48 89 d1             	mov    %rdx,%rcx
  80204c:	48 89 c2             	mov    %rax,%rdx
  80204f:	be 01 00 00 00       	mov    $0x1,%esi
  802054:	bf 05 00 00 00       	mov    $0x5,%edi
  802059:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  802060:	00 00 00 
  802063:	ff d0                	callq  *%rax
  802065:	48 83 c4 10          	add    $0x10,%rsp
}
  802069:	c9                   	leaveq 
  80206a:	c3                   	retq   

000000000080206b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80206b:	55                   	push   %rbp
  80206c:	48 89 e5             	mov    %rsp,%rbp
  80206f:	48 83 ec 10          	sub    $0x10,%rsp
  802073:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802076:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80207a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80207e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802081:	48 98                	cltq   
  802083:	48 83 ec 08          	sub    $0x8,%rsp
  802087:	6a 00                	pushq  $0x0
  802089:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80208f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802095:	48 89 d1             	mov    %rdx,%rcx
  802098:	48 89 c2             	mov    %rax,%rdx
  80209b:	be 01 00 00 00       	mov    $0x1,%esi
  8020a0:	bf 06 00 00 00       	mov    $0x6,%edi
  8020a5:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  8020ac:	00 00 00 
  8020af:	ff d0                	callq  *%rax
  8020b1:	48 83 c4 10          	add    $0x10,%rsp
}
  8020b5:	c9                   	leaveq 
  8020b6:	c3                   	retq   

00000000008020b7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8020b7:	55                   	push   %rbp
  8020b8:	48 89 e5             	mov    %rsp,%rbp
  8020bb:	48 83 ec 10          	sub    $0x10,%rsp
  8020bf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020c2:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8020c5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020c8:	48 63 d0             	movslq %eax,%rdx
  8020cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ce:	48 98                	cltq   
  8020d0:	48 83 ec 08          	sub    $0x8,%rsp
  8020d4:	6a 00                	pushq  $0x0
  8020d6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020dc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020e2:	48 89 d1             	mov    %rdx,%rcx
  8020e5:	48 89 c2             	mov    %rax,%rdx
  8020e8:	be 01 00 00 00       	mov    $0x1,%esi
  8020ed:	bf 08 00 00 00       	mov    $0x8,%edi
  8020f2:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  8020f9:	00 00 00 
  8020fc:	ff d0                	callq  *%rax
  8020fe:	48 83 c4 10          	add    $0x10,%rsp
}
  802102:	c9                   	leaveq 
  802103:	c3                   	retq   

0000000000802104 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802104:	55                   	push   %rbp
  802105:	48 89 e5             	mov    %rsp,%rbp
  802108:	48 83 ec 10          	sub    $0x10,%rsp
  80210c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80210f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802113:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802117:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80211a:	48 98                	cltq   
  80211c:	48 83 ec 08          	sub    $0x8,%rsp
  802120:	6a 00                	pushq  $0x0
  802122:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802128:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80212e:	48 89 d1             	mov    %rdx,%rcx
  802131:	48 89 c2             	mov    %rax,%rdx
  802134:	be 01 00 00 00       	mov    $0x1,%esi
  802139:	bf 09 00 00 00       	mov    $0x9,%edi
  80213e:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  802145:	00 00 00 
  802148:	ff d0                	callq  *%rax
  80214a:	48 83 c4 10          	add    $0x10,%rsp
}
  80214e:	c9                   	leaveq 
  80214f:	c3                   	retq   

0000000000802150 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802150:	55                   	push   %rbp
  802151:	48 89 e5             	mov    %rsp,%rbp
  802154:	48 83 ec 10          	sub    $0x10,%rsp
  802158:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80215b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80215f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802163:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802166:	48 98                	cltq   
  802168:	48 83 ec 08          	sub    $0x8,%rsp
  80216c:	6a 00                	pushq  $0x0
  80216e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802174:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80217a:	48 89 d1             	mov    %rdx,%rcx
  80217d:	48 89 c2             	mov    %rax,%rdx
  802180:	be 01 00 00 00       	mov    $0x1,%esi
  802185:	bf 0a 00 00 00       	mov    $0xa,%edi
  80218a:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  802191:	00 00 00 
  802194:	ff d0                	callq  *%rax
  802196:	48 83 c4 10          	add    $0x10,%rsp
}
  80219a:	c9                   	leaveq 
  80219b:	c3                   	retq   

000000000080219c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  80219c:	55                   	push   %rbp
  80219d:	48 89 e5             	mov    %rsp,%rbp
  8021a0:	48 83 ec 20          	sub    $0x20,%rsp
  8021a4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021a7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8021ab:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8021af:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8021b2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021b5:	48 63 f0             	movslq %eax,%rsi
  8021b8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8021bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021bf:	48 98                	cltq   
  8021c1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021c5:	48 83 ec 08          	sub    $0x8,%rsp
  8021c9:	6a 00                	pushq  $0x0
  8021cb:	49 89 f1             	mov    %rsi,%r9
  8021ce:	49 89 c8             	mov    %rcx,%r8
  8021d1:	48 89 d1             	mov    %rdx,%rcx
  8021d4:	48 89 c2             	mov    %rax,%rdx
  8021d7:	be 00 00 00 00       	mov    $0x0,%esi
  8021dc:	bf 0c 00 00 00       	mov    $0xc,%edi
  8021e1:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  8021e8:	00 00 00 
  8021eb:	ff d0                	callq  *%rax
  8021ed:	48 83 c4 10          	add    $0x10,%rsp
}
  8021f1:	c9                   	leaveq 
  8021f2:	c3                   	retq   

00000000008021f3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8021f3:	55                   	push   %rbp
  8021f4:	48 89 e5             	mov    %rsp,%rbp
  8021f7:	48 83 ec 10          	sub    $0x10,%rsp
  8021fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8021ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802203:	48 83 ec 08          	sub    $0x8,%rsp
  802207:	6a 00                	pushq  $0x0
  802209:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80220f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802215:	b9 00 00 00 00       	mov    $0x0,%ecx
  80221a:	48 89 c2             	mov    %rax,%rdx
  80221d:	be 01 00 00 00       	mov    $0x1,%esi
  802222:	bf 0d 00 00 00       	mov    $0xd,%edi
  802227:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  80222e:	00 00 00 
  802231:	ff d0                	callq  *%rax
  802233:	48 83 c4 10          	add    $0x10,%rsp
}
  802237:	c9                   	leaveq 
  802238:	c3                   	retq   

0000000000802239 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  802239:	55                   	push   %rbp
  80223a:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  80223d:	48 83 ec 08          	sub    $0x8,%rsp
  802241:	6a 00                	pushq  $0x0
  802243:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802249:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80224f:	b9 00 00 00 00       	mov    $0x0,%ecx
  802254:	ba 00 00 00 00       	mov    $0x0,%edx
  802259:	be 00 00 00 00       	mov    $0x0,%esi
  80225e:	bf 0e 00 00 00       	mov    $0xe,%edi
  802263:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  80226a:	00 00 00 
  80226d:	ff d0                	callq  *%rax
  80226f:	48 83 c4 10          	add    $0x10,%rsp
}
  802273:	c9                   	leaveq 
  802274:	c3                   	retq   

0000000000802275 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  802275:	55                   	push   %rbp
  802276:	48 89 e5             	mov    %rsp,%rbp
  802279:	48 83 ec 20          	sub    $0x20,%rsp
  80227d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802280:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802284:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802287:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80228b:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  80228f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802292:	48 63 c8             	movslq %eax,%rcx
  802295:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802299:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80229c:	48 63 f0             	movslq %eax,%rsi
  80229f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022a6:	48 98                	cltq   
  8022a8:	48 83 ec 08          	sub    $0x8,%rsp
  8022ac:	51                   	push   %rcx
  8022ad:	49 89 f9             	mov    %rdi,%r9
  8022b0:	49 89 f0             	mov    %rsi,%r8
  8022b3:	48 89 d1             	mov    %rdx,%rcx
  8022b6:	48 89 c2             	mov    %rax,%rdx
  8022b9:	be 00 00 00 00       	mov    $0x0,%esi
  8022be:	bf 0f 00 00 00       	mov    $0xf,%edi
  8022c3:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  8022ca:	00 00 00 
  8022cd:	ff d0                	callq  *%rax
  8022cf:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  8022d3:	c9                   	leaveq 
  8022d4:	c3                   	retq   

00000000008022d5 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  8022d5:	55                   	push   %rbp
  8022d6:	48 89 e5             	mov    %rsp,%rbp
  8022d9:	48 83 ec 10          	sub    $0x10,%rsp
  8022dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8022e1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  8022e5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022ed:	48 83 ec 08          	sub    $0x8,%rsp
  8022f1:	6a 00                	pushq  $0x0
  8022f3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022f9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022ff:	48 89 d1             	mov    %rdx,%rcx
  802302:	48 89 c2             	mov    %rax,%rdx
  802305:	be 00 00 00 00       	mov    $0x0,%esi
  80230a:	bf 10 00 00 00       	mov    $0x10,%edi
  80230f:	48 b8 e5 1d 80 00 00 	movabs $0x801de5,%rax
  802316:	00 00 00 
  802319:	ff d0                	callq  *%rax
  80231b:	48 83 c4 10          	add    $0x10,%rsp
}
  80231f:	c9                   	leaveq 
  802320:	c3                   	retq   

0000000000802321 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  802321:	55                   	push   %rbp
  802322:	48 89 e5             	mov    %rsp,%rbp
  802325:	48 83 ec 20          	sub    $0x20,%rsp
  802329:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  80232d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802331:	48 8b 00             	mov    (%rax),%rax
  802334:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  802338:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80233c:	48 8b 40 08          	mov    0x8(%rax),%rax
  802340:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  802343:	48 ba 73 54 80 00 00 	movabs $0x805473,%rdx
  80234a:	00 00 00 
  80234d:	be 26 00 00 00       	mov    $0x26,%esi
  802352:	48 bf 8b 54 80 00 00 	movabs $0x80548b,%rdi
  802359:	00 00 00 
  80235c:	b8 00 00 00 00       	mov    $0x0,%eax
  802361:	48 b9 b9 08 80 00 00 	movabs $0x8008b9,%rcx
  802368:	00 00 00 
  80236b:	ff d1                	callq  *%rcx

000000000080236d <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80236d:	55                   	push   %rbp
  80236e:	48 89 e5             	mov    %rsp,%rbp
  802371:	48 83 ec 10          	sub    $0x10,%rsp
  802375:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802378:	89 75 f8             	mov    %esi,-0x8(%rbp)
	int r;

	// LAB 4: Your code here.
	panic("duppage not implemented");
  80237b:	48 ba 96 54 80 00 00 	movabs $0x805496,%rdx
  802382:	00 00 00 
  802385:	be 3a 00 00 00       	mov    $0x3a,%esi
  80238a:	48 bf 8b 54 80 00 00 	movabs $0x80548b,%rdi
  802391:	00 00 00 
  802394:	b8 00 00 00 00       	mov    $0x0,%eax
  802399:	48 b9 b9 08 80 00 00 	movabs $0x8008b9,%rcx
  8023a0:	00 00 00 
  8023a3:	ff d1                	callq  *%rcx

00000000008023a5 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8023a5:	55                   	push   %rbp
  8023a6:	48 89 e5             	mov    %rsp,%rbp
	// LAB 4: Your code here.
	panic("fork not implemented");
  8023a9:	48 ba ae 54 80 00 00 	movabs $0x8054ae,%rdx
  8023b0:	00 00 00 
  8023b3:	be 52 00 00 00       	mov    $0x52,%esi
  8023b8:	48 bf 8b 54 80 00 00 	movabs $0x80548b,%rdi
  8023bf:	00 00 00 
  8023c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c7:	48 b9 b9 08 80 00 00 	movabs $0x8008b9,%rcx
  8023ce:	00 00 00 
  8023d1:	ff d1                	callq  *%rcx

00000000008023d3 <sfork>:
}

// Challenge!
int
sfork(void)
{
  8023d3:	55                   	push   %rbp
  8023d4:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8023d7:	48 ba c3 54 80 00 00 	movabs $0x8054c3,%rdx
  8023de:	00 00 00 
  8023e1:	be 59 00 00 00       	mov    $0x59,%esi
  8023e6:	48 bf 8b 54 80 00 00 	movabs $0x80548b,%rdi
  8023ed:	00 00 00 
  8023f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f5:	48 b9 b9 08 80 00 00 	movabs $0x8008b9,%rcx
  8023fc:	00 00 00 
  8023ff:	ff d1                	callq  *%rcx

0000000000802401 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802401:	55                   	push   %rbp
  802402:	48 89 e5             	mov    %rsp,%rbp
  802405:	48 83 ec 08          	sub    $0x8,%rsp
  802409:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80240d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802411:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802418:	ff ff ff 
  80241b:	48 01 d0             	add    %rdx,%rax
  80241e:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802422:	c9                   	leaveq 
  802423:	c3                   	retq   

0000000000802424 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802424:	55                   	push   %rbp
  802425:	48 89 e5             	mov    %rsp,%rbp
  802428:	48 83 ec 08          	sub    $0x8,%rsp
  80242c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802430:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802434:	48 89 c7             	mov    %rax,%rdi
  802437:	48 b8 01 24 80 00 00 	movabs $0x802401,%rax
  80243e:	00 00 00 
  802441:	ff d0                	callq  *%rax
  802443:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802449:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80244d:	c9                   	leaveq 
  80244e:	c3                   	retq   

000000000080244f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80244f:	55                   	push   %rbp
  802450:	48 89 e5             	mov    %rsp,%rbp
  802453:	48 83 ec 18          	sub    $0x18,%rsp
  802457:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80245b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802462:	eb 6b                	jmp    8024cf <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802464:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802467:	48 98                	cltq   
  802469:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80246f:	48 c1 e0 0c          	shl    $0xc,%rax
  802473:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802477:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80247b:	48 c1 e8 15          	shr    $0x15,%rax
  80247f:	48 89 c2             	mov    %rax,%rdx
  802482:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802489:	01 00 00 
  80248c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802490:	83 e0 01             	and    $0x1,%eax
  802493:	48 85 c0             	test   %rax,%rax
  802496:	74 21                	je     8024b9 <fd_alloc+0x6a>
  802498:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80249c:	48 c1 e8 0c          	shr    $0xc,%rax
  8024a0:	48 89 c2             	mov    %rax,%rdx
  8024a3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024aa:	01 00 00 
  8024ad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024b1:	83 e0 01             	and    $0x1,%eax
  8024b4:	48 85 c0             	test   %rax,%rax
  8024b7:	75 12                	jne    8024cb <fd_alloc+0x7c>
			*fd_store = fd;
  8024b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024c1:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8024c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c9:	eb 1a                	jmp    8024e5 <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  8024cb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024cf:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8024d3:	7e 8f                	jle    802464 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  8024d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024d9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8024e0:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8024e5:	c9                   	leaveq 
  8024e6:	c3                   	retq   

00000000008024e7 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8024e7:	55                   	push   %rbp
  8024e8:	48 89 e5             	mov    %rsp,%rbp
  8024eb:	48 83 ec 20          	sub    $0x20,%rsp
  8024ef:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024f2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8024f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8024fa:	78 06                	js     802502 <fd_lookup+0x1b>
  8024fc:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802500:	7e 07                	jle    802509 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802502:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802507:	eb 6c                	jmp    802575 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802509:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80250c:	48 98                	cltq   
  80250e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802514:	48 c1 e0 0c          	shl    $0xc,%rax
  802518:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80251c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802520:	48 c1 e8 15          	shr    $0x15,%rax
  802524:	48 89 c2             	mov    %rax,%rdx
  802527:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80252e:	01 00 00 
  802531:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802535:	83 e0 01             	and    $0x1,%eax
  802538:	48 85 c0             	test   %rax,%rax
  80253b:	74 21                	je     80255e <fd_lookup+0x77>
  80253d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802541:	48 c1 e8 0c          	shr    $0xc,%rax
  802545:	48 89 c2             	mov    %rax,%rdx
  802548:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80254f:	01 00 00 
  802552:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802556:	83 e0 01             	and    $0x1,%eax
  802559:	48 85 c0             	test   %rax,%rax
  80255c:	75 07                	jne    802565 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80255e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802563:	eb 10                	jmp    802575 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802565:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802569:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80256d:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802570:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802575:	c9                   	leaveq 
  802576:	c3                   	retq   

0000000000802577 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802577:	55                   	push   %rbp
  802578:	48 89 e5             	mov    %rsp,%rbp
  80257b:	48 83 ec 30          	sub    $0x30,%rsp
  80257f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802583:	89 f0                	mov    %esi,%eax
  802585:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802588:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80258c:	48 89 c7             	mov    %rax,%rdi
  80258f:	48 b8 01 24 80 00 00 	movabs $0x802401,%rax
  802596:	00 00 00 
  802599:	ff d0                	callq  *%rax
  80259b:	89 c2                	mov    %eax,%edx
  80259d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8025a1:	48 89 c6             	mov    %rax,%rsi
  8025a4:	89 d7                	mov    %edx,%edi
  8025a6:	48 b8 e7 24 80 00 00 	movabs $0x8024e7,%rax
  8025ad:	00 00 00 
  8025b0:	ff d0                	callq  *%rax
  8025b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025b9:	78 0a                	js     8025c5 <fd_close+0x4e>
	    || fd != fd2)
  8025bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025bf:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8025c3:	74 12                	je     8025d7 <fd_close+0x60>
		return (must_exist ? r : 0);
  8025c5:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8025c9:	74 05                	je     8025d0 <fd_close+0x59>
  8025cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ce:	eb 70                	jmp    802640 <fd_close+0xc9>
  8025d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d5:	eb 69                	jmp    802640 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8025d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025db:	8b 00                	mov    (%rax),%eax
  8025dd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025e1:	48 89 d6             	mov    %rdx,%rsi
  8025e4:	89 c7                	mov    %eax,%edi
  8025e6:	48 b8 42 26 80 00 00 	movabs $0x802642,%rax
  8025ed:	00 00 00 
  8025f0:	ff d0                	callq  *%rax
  8025f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025f9:	78 2a                	js     802625 <fd_close+0xae>
		if (dev->dev_close)
  8025fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ff:	48 8b 40 20          	mov    0x20(%rax),%rax
  802603:	48 85 c0             	test   %rax,%rax
  802606:	74 16                	je     80261e <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  802608:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80260c:	48 8b 40 20          	mov    0x20(%rax),%rax
  802610:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802614:	48 89 d7             	mov    %rdx,%rdi
  802617:	ff d0                	callq  *%rax
  802619:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261c:	eb 07                	jmp    802625 <fd_close+0xae>
		else
			r = 0;
  80261e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802625:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802629:	48 89 c6             	mov    %rax,%rsi
  80262c:	bf 00 00 00 00       	mov    $0x0,%edi
  802631:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  802638:	00 00 00 
  80263b:	ff d0                	callq  *%rax
	return r;
  80263d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802640:	c9                   	leaveq 
  802641:	c3                   	retq   

0000000000802642 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802642:	55                   	push   %rbp
  802643:	48 89 e5             	mov    %rsp,%rbp
  802646:	48 83 ec 20          	sub    $0x20,%rsp
  80264a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80264d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802651:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802658:	eb 41                	jmp    80269b <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80265a:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802661:	00 00 00 
  802664:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802667:	48 63 d2             	movslq %edx,%rdx
  80266a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80266e:	8b 00                	mov    (%rax),%eax
  802670:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802673:	75 22                	jne    802697 <dev_lookup+0x55>
			*dev = devtab[i];
  802675:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80267c:	00 00 00 
  80267f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802682:	48 63 d2             	movslq %edx,%rdx
  802685:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802689:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80268d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802690:	b8 00 00 00 00       	mov    $0x0,%eax
  802695:	eb 60                	jmp    8026f7 <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  802697:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80269b:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8026a2:	00 00 00 
  8026a5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026a8:	48 63 d2             	movslq %edx,%rdx
  8026ab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026af:	48 85 c0             	test   %rax,%rax
  8026b2:	75 a6                	jne    80265a <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8026b4:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8026bb:	00 00 00 
  8026be:	48 8b 00             	mov    (%rax),%rax
  8026c1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026c7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8026ca:	89 c6                	mov    %eax,%esi
  8026cc:	48 bf e0 54 80 00 00 	movabs $0x8054e0,%rdi
  8026d3:	00 00 00 
  8026d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026db:	48 b9 f2 0a 80 00 00 	movabs $0x800af2,%rcx
  8026e2:	00 00 00 
  8026e5:	ff d1                	callq  *%rcx
	*dev = 0;
  8026e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026eb:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8026f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8026f7:	c9                   	leaveq 
  8026f8:	c3                   	retq   

00000000008026f9 <close>:

int
close(int fdnum)
{
  8026f9:	55                   	push   %rbp
  8026fa:	48 89 e5             	mov    %rsp,%rbp
  8026fd:	48 83 ec 20          	sub    $0x20,%rsp
  802701:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802704:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802708:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80270b:	48 89 d6             	mov    %rdx,%rsi
  80270e:	89 c7                	mov    %eax,%edi
  802710:	48 b8 e7 24 80 00 00 	movabs $0x8024e7,%rax
  802717:	00 00 00 
  80271a:	ff d0                	callq  *%rax
  80271c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80271f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802723:	79 05                	jns    80272a <close+0x31>
		return r;
  802725:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802728:	eb 18                	jmp    802742 <close+0x49>
	else
		return fd_close(fd, 1);
  80272a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80272e:	be 01 00 00 00       	mov    $0x1,%esi
  802733:	48 89 c7             	mov    %rax,%rdi
  802736:	48 b8 77 25 80 00 00 	movabs $0x802577,%rax
  80273d:	00 00 00 
  802740:	ff d0                	callq  *%rax
}
  802742:	c9                   	leaveq 
  802743:	c3                   	retq   

0000000000802744 <close_all>:

void
close_all(void)
{
  802744:	55                   	push   %rbp
  802745:	48 89 e5             	mov    %rsp,%rbp
  802748:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80274c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802753:	eb 15                	jmp    80276a <close_all+0x26>
		close(i);
  802755:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802758:	89 c7                	mov    %eax,%edi
  80275a:	48 b8 f9 26 80 00 00 	movabs $0x8026f9,%rax
  802761:	00 00 00 
  802764:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  802766:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80276a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80276e:	7e e5                	jle    802755 <close_all+0x11>
}
  802770:	c9                   	leaveq 
  802771:	c3                   	retq   

0000000000802772 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802772:	55                   	push   %rbp
  802773:	48 89 e5             	mov    %rsp,%rbp
  802776:	48 83 ec 40          	sub    $0x40,%rsp
  80277a:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80277d:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802780:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802784:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802787:	48 89 d6             	mov    %rdx,%rsi
  80278a:	89 c7                	mov    %eax,%edi
  80278c:	48 b8 e7 24 80 00 00 	movabs $0x8024e7,%rax
  802793:	00 00 00 
  802796:	ff d0                	callq  *%rax
  802798:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80279b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80279f:	79 08                	jns    8027a9 <dup+0x37>
		return r;
  8027a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a4:	e9 70 01 00 00       	jmpq   802919 <dup+0x1a7>
	close(newfdnum);
  8027a9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027ac:	89 c7                	mov    %eax,%edi
  8027ae:	48 b8 f9 26 80 00 00 	movabs $0x8026f9,%rax
  8027b5:	00 00 00 
  8027b8:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8027ba:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027bd:	48 98                	cltq   
  8027bf:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8027c5:	48 c1 e0 0c          	shl    $0xc,%rax
  8027c9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8027cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027d1:	48 89 c7             	mov    %rax,%rdi
  8027d4:	48 b8 24 24 80 00 00 	movabs $0x802424,%rax
  8027db:	00 00 00 
  8027de:	ff d0                	callq  *%rax
  8027e0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8027e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027e8:	48 89 c7             	mov    %rax,%rdi
  8027eb:	48 b8 24 24 80 00 00 	movabs $0x802424,%rax
  8027f2:	00 00 00 
  8027f5:	ff d0                	callq  *%rax
  8027f7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8027fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ff:	48 c1 e8 15          	shr    $0x15,%rax
  802803:	48 89 c2             	mov    %rax,%rdx
  802806:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80280d:	01 00 00 
  802810:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802814:	83 e0 01             	and    $0x1,%eax
  802817:	48 85 c0             	test   %rax,%rax
  80281a:	74 73                	je     80288f <dup+0x11d>
  80281c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802820:	48 c1 e8 0c          	shr    $0xc,%rax
  802824:	48 89 c2             	mov    %rax,%rdx
  802827:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80282e:	01 00 00 
  802831:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802835:	83 e0 01             	and    $0x1,%eax
  802838:	48 85 c0             	test   %rax,%rax
  80283b:	74 52                	je     80288f <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80283d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802841:	48 c1 e8 0c          	shr    $0xc,%rax
  802845:	48 89 c2             	mov    %rax,%rdx
  802848:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80284f:	01 00 00 
  802852:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802856:	25 07 0e 00 00       	and    $0xe07,%eax
  80285b:	89 c1                	mov    %eax,%ecx
  80285d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802861:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802865:	41 89 c8             	mov    %ecx,%r8d
  802868:	48 89 d1             	mov    %rdx,%rcx
  80286b:	ba 00 00 00 00       	mov    $0x0,%edx
  802870:	48 89 c6             	mov    %rax,%rsi
  802873:	bf 00 00 00 00       	mov    $0x0,%edi
  802878:	48 b8 0b 20 80 00 00 	movabs $0x80200b,%rax
  80287f:	00 00 00 
  802882:	ff d0                	callq  *%rax
  802884:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802887:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80288b:	79 02                	jns    80288f <dup+0x11d>
			goto err;
  80288d:	eb 57                	jmp    8028e6 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80288f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802893:	48 c1 e8 0c          	shr    $0xc,%rax
  802897:	48 89 c2             	mov    %rax,%rdx
  80289a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028a1:	01 00 00 
  8028a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028a8:	25 07 0e 00 00       	and    $0xe07,%eax
  8028ad:	89 c1                	mov    %eax,%ecx
  8028af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028b7:	41 89 c8             	mov    %ecx,%r8d
  8028ba:	48 89 d1             	mov    %rdx,%rcx
  8028bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8028c2:	48 89 c6             	mov    %rax,%rsi
  8028c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8028ca:	48 b8 0b 20 80 00 00 	movabs $0x80200b,%rax
  8028d1:	00 00 00 
  8028d4:	ff d0                	callq  *%rax
  8028d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028dd:	79 02                	jns    8028e1 <dup+0x16f>
		goto err;
  8028df:	eb 05                	jmp    8028e6 <dup+0x174>

	return newfdnum;
  8028e1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8028e4:	eb 33                	jmp    802919 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8028e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028ea:	48 89 c6             	mov    %rax,%rsi
  8028ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8028f2:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  8028f9:	00 00 00 
  8028fc:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8028fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802902:	48 89 c6             	mov    %rax,%rsi
  802905:	bf 00 00 00 00       	mov    $0x0,%edi
  80290a:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  802911:	00 00 00 
  802914:	ff d0                	callq  *%rax
	return r;
  802916:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802919:	c9                   	leaveq 
  80291a:	c3                   	retq   

000000000080291b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80291b:	55                   	push   %rbp
  80291c:	48 89 e5             	mov    %rsp,%rbp
  80291f:	48 83 ec 40          	sub    $0x40,%rsp
  802923:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802926:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80292a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80292e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802932:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802935:	48 89 d6             	mov    %rdx,%rsi
  802938:	89 c7                	mov    %eax,%edi
  80293a:	48 b8 e7 24 80 00 00 	movabs $0x8024e7,%rax
  802941:	00 00 00 
  802944:	ff d0                	callq  *%rax
  802946:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802949:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80294d:	78 24                	js     802973 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80294f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802953:	8b 00                	mov    (%rax),%eax
  802955:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802959:	48 89 d6             	mov    %rdx,%rsi
  80295c:	89 c7                	mov    %eax,%edi
  80295e:	48 b8 42 26 80 00 00 	movabs $0x802642,%rax
  802965:	00 00 00 
  802968:	ff d0                	callq  *%rax
  80296a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80296d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802971:	79 05                	jns    802978 <read+0x5d>
		return r;
  802973:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802976:	eb 76                	jmp    8029ee <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802978:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80297c:	8b 40 08             	mov    0x8(%rax),%eax
  80297f:	83 e0 03             	and    $0x3,%eax
  802982:	83 f8 01             	cmp    $0x1,%eax
  802985:	75 3a                	jne    8029c1 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802987:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80298e:	00 00 00 
  802991:	48 8b 00             	mov    (%rax),%rax
  802994:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80299a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80299d:	89 c6                	mov    %eax,%esi
  80299f:	48 bf ff 54 80 00 00 	movabs $0x8054ff,%rdi
  8029a6:	00 00 00 
  8029a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ae:	48 b9 f2 0a 80 00 00 	movabs $0x800af2,%rcx
  8029b5:	00 00 00 
  8029b8:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8029ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029bf:	eb 2d                	jmp    8029ee <read+0xd3>
	}
	if (!dev->dev_read)
  8029c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029c5:	48 8b 40 10          	mov    0x10(%rax),%rax
  8029c9:	48 85 c0             	test   %rax,%rax
  8029cc:	75 07                	jne    8029d5 <read+0xba>
		return -E_NOT_SUPP;
  8029ce:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029d3:	eb 19                	jmp    8029ee <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8029d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029d9:	48 8b 40 10          	mov    0x10(%rax),%rax
  8029dd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8029e1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8029e5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8029e9:	48 89 cf             	mov    %rcx,%rdi
  8029ec:	ff d0                	callq  *%rax
}
  8029ee:	c9                   	leaveq 
  8029ef:	c3                   	retq   

00000000008029f0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8029f0:	55                   	push   %rbp
  8029f1:	48 89 e5             	mov    %rsp,%rbp
  8029f4:	48 83 ec 30          	sub    $0x30,%rsp
  8029f8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029fb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029ff:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a0a:	eb 49                	jmp    802a55 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802a0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a0f:	48 98                	cltq   
  802a11:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a15:	48 29 c2             	sub    %rax,%rdx
  802a18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a1b:	48 63 c8             	movslq %eax,%rcx
  802a1e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a22:	48 01 c1             	add    %rax,%rcx
  802a25:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a28:	48 89 ce             	mov    %rcx,%rsi
  802a2b:	89 c7                	mov    %eax,%edi
  802a2d:	48 b8 1b 29 80 00 00 	movabs $0x80291b,%rax
  802a34:	00 00 00 
  802a37:	ff d0                	callq  *%rax
  802a39:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802a3c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a40:	79 05                	jns    802a47 <readn+0x57>
			return m;
  802a42:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a45:	eb 1c                	jmp    802a63 <readn+0x73>
		if (m == 0)
  802a47:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a4b:	75 02                	jne    802a4f <readn+0x5f>
			break;
  802a4d:	eb 11                	jmp    802a60 <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  802a4f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a52:	01 45 fc             	add    %eax,-0x4(%rbp)
  802a55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a58:	48 98                	cltq   
  802a5a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a5e:	72 ac                	jb     802a0c <readn+0x1c>
	}
	return tot;
  802a60:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a63:	c9                   	leaveq 
  802a64:	c3                   	retq   

0000000000802a65 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802a65:	55                   	push   %rbp
  802a66:	48 89 e5             	mov    %rsp,%rbp
  802a69:	48 83 ec 40          	sub    $0x40,%rsp
  802a6d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a70:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a74:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a78:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a7c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a7f:	48 89 d6             	mov    %rdx,%rsi
  802a82:	89 c7                	mov    %eax,%edi
  802a84:	48 b8 e7 24 80 00 00 	movabs $0x8024e7,%rax
  802a8b:	00 00 00 
  802a8e:	ff d0                	callq  *%rax
  802a90:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a93:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a97:	78 24                	js     802abd <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a9d:	8b 00                	mov    (%rax),%eax
  802a9f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802aa3:	48 89 d6             	mov    %rdx,%rsi
  802aa6:	89 c7                	mov    %eax,%edi
  802aa8:	48 b8 42 26 80 00 00 	movabs $0x802642,%rax
  802aaf:	00 00 00 
  802ab2:	ff d0                	callq  *%rax
  802ab4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802abb:	79 05                	jns    802ac2 <write+0x5d>
		return r;
  802abd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac0:	eb 75                	jmp    802b37 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ac2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ac6:	8b 40 08             	mov    0x8(%rax),%eax
  802ac9:	83 e0 03             	and    $0x3,%eax
  802acc:	85 c0                	test   %eax,%eax
  802ace:	75 3a                	jne    802b0a <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802ad0:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802ad7:	00 00 00 
  802ada:	48 8b 00             	mov    (%rax),%rax
  802add:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ae3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ae6:	89 c6                	mov    %eax,%esi
  802ae8:	48 bf 1b 55 80 00 00 	movabs $0x80551b,%rdi
  802aef:	00 00 00 
  802af2:	b8 00 00 00 00       	mov    $0x0,%eax
  802af7:	48 b9 f2 0a 80 00 00 	movabs $0x800af2,%rcx
  802afe:	00 00 00 
  802b01:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b03:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b08:	eb 2d                	jmp    802b37 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802b0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b0e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b12:	48 85 c0             	test   %rax,%rax
  802b15:	75 07                	jne    802b1e <write+0xb9>
		return -E_NOT_SUPP;
  802b17:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b1c:	eb 19                	jmp    802b37 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802b1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b22:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b26:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802b2a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b2e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802b32:	48 89 cf             	mov    %rcx,%rdi
  802b35:	ff d0                	callq  *%rax
}
  802b37:	c9                   	leaveq 
  802b38:	c3                   	retq   

0000000000802b39 <seek>:

int
seek(int fdnum, off_t offset)
{
  802b39:	55                   	push   %rbp
  802b3a:	48 89 e5             	mov    %rsp,%rbp
  802b3d:	48 83 ec 18          	sub    $0x18,%rsp
  802b41:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b44:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b47:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b4b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b4e:	48 89 d6             	mov    %rdx,%rsi
  802b51:	89 c7                	mov    %eax,%edi
  802b53:	48 b8 e7 24 80 00 00 	movabs $0x8024e7,%rax
  802b5a:	00 00 00 
  802b5d:	ff d0                	callq  *%rax
  802b5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b66:	79 05                	jns    802b6d <seek+0x34>
		return r;
  802b68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b6b:	eb 0f                	jmp    802b7c <seek+0x43>
	fd->fd_offset = offset;
  802b6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b71:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802b74:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802b77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b7c:	c9                   	leaveq 
  802b7d:	c3                   	retq   

0000000000802b7e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802b7e:	55                   	push   %rbp
  802b7f:	48 89 e5             	mov    %rsp,%rbp
  802b82:	48 83 ec 30          	sub    $0x30,%rsp
  802b86:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b89:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b8c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b90:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b93:	48 89 d6             	mov    %rdx,%rsi
  802b96:	89 c7                	mov    %eax,%edi
  802b98:	48 b8 e7 24 80 00 00 	movabs $0x8024e7,%rax
  802b9f:	00 00 00 
  802ba2:	ff d0                	callq  *%rax
  802ba4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ba7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bab:	78 24                	js     802bd1 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bb1:	8b 00                	mov    (%rax),%eax
  802bb3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bb7:	48 89 d6             	mov    %rdx,%rsi
  802bba:	89 c7                	mov    %eax,%edi
  802bbc:	48 b8 42 26 80 00 00 	movabs $0x802642,%rax
  802bc3:	00 00 00 
  802bc6:	ff d0                	callq  *%rax
  802bc8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bcb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bcf:	79 05                	jns    802bd6 <ftruncate+0x58>
		return r;
  802bd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd4:	eb 72                	jmp    802c48 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802bd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bda:	8b 40 08             	mov    0x8(%rax),%eax
  802bdd:	83 e0 03             	and    $0x3,%eax
  802be0:	85 c0                	test   %eax,%eax
  802be2:	75 3a                	jne    802c1e <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802be4:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802beb:	00 00 00 
  802bee:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802bf1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802bf7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802bfa:	89 c6                	mov    %eax,%esi
  802bfc:	48 bf 38 55 80 00 00 	movabs $0x805538,%rdi
  802c03:	00 00 00 
  802c06:	b8 00 00 00 00       	mov    $0x0,%eax
  802c0b:	48 b9 f2 0a 80 00 00 	movabs $0x800af2,%rcx
  802c12:	00 00 00 
  802c15:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c17:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c1c:	eb 2a                	jmp    802c48 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802c1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c22:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c26:	48 85 c0             	test   %rax,%rax
  802c29:	75 07                	jne    802c32 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802c2b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c30:	eb 16                	jmp    802c48 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802c32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c36:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c3a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c3e:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802c41:	89 ce                	mov    %ecx,%esi
  802c43:	48 89 d7             	mov    %rdx,%rdi
  802c46:	ff d0                	callq  *%rax
}
  802c48:	c9                   	leaveq 
  802c49:	c3                   	retq   

0000000000802c4a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802c4a:	55                   	push   %rbp
  802c4b:	48 89 e5             	mov    %rsp,%rbp
  802c4e:	48 83 ec 30          	sub    $0x30,%rsp
  802c52:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c55:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c59:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c5d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c60:	48 89 d6             	mov    %rdx,%rsi
  802c63:	89 c7                	mov    %eax,%edi
  802c65:	48 b8 e7 24 80 00 00 	movabs $0x8024e7,%rax
  802c6c:	00 00 00 
  802c6f:	ff d0                	callq  *%rax
  802c71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c78:	78 24                	js     802c9e <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c7e:	8b 00                	mov    (%rax),%eax
  802c80:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c84:	48 89 d6             	mov    %rdx,%rsi
  802c87:	89 c7                	mov    %eax,%edi
  802c89:	48 b8 42 26 80 00 00 	movabs $0x802642,%rax
  802c90:	00 00 00 
  802c93:	ff d0                	callq  *%rax
  802c95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c9c:	79 05                	jns    802ca3 <fstat+0x59>
		return r;
  802c9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca1:	eb 5e                	jmp    802d01 <fstat+0xb7>
	if (!dev->dev_stat)
  802ca3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ca7:	48 8b 40 28          	mov    0x28(%rax),%rax
  802cab:	48 85 c0             	test   %rax,%rax
  802cae:	75 07                	jne    802cb7 <fstat+0x6d>
		return -E_NOT_SUPP;
  802cb0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cb5:	eb 4a                	jmp    802d01 <fstat+0xb7>
	stat->st_name[0] = 0;
  802cb7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cbb:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802cbe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cc2:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802cc9:	00 00 00 
	stat->st_isdir = 0;
  802ccc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cd0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802cd7:	00 00 00 
	stat->st_dev = dev;
  802cda:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802cde:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ce2:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802ce9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ced:	48 8b 40 28          	mov    0x28(%rax),%rax
  802cf1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cf5:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802cf9:	48 89 ce             	mov    %rcx,%rsi
  802cfc:	48 89 d7             	mov    %rdx,%rdi
  802cff:	ff d0                	callq  *%rax
}
  802d01:	c9                   	leaveq 
  802d02:	c3                   	retq   

0000000000802d03 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802d03:	55                   	push   %rbp
  802d04:	48 89 e5             	mov    %rsp,%rbp
  802d07:	48 83 ec 20          	sub    $0x20,%rsp
  802d0b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d0f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802d13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d17:	be 00 00 00 00       	mov    $0x0,%esi
  802d1c:	48 89 c7             	mov    %rax,%rdi
  802d1f:	48 b8 f3 2d 80 00 00 	movabs $0x802df3,%rax
  802d26:	00 00 00 
  802d29:	ff d0                	callq  *%rax
  802d2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d32:	79 05                	jns    802d39 <stat+0x36>
		return fd;
  802d34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d37:	eb 2f                	jmp    802d68 <stat+0x65>
	r = fstat(fd, stat);
  802d39:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d40:	48 89 d6             	mov    %rdx,%rsi
  802d43:	89 c7                	mov    %eax,%edi
  802d45:	48 b8 4a 2c 80 00 00 	movabs $0x802c4a,%rax
  802d4c:	00 00 00 
  802d4f:	ff d0                	callq  *%rax
  802d51:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802d54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d57:	89 c7                	mov    %eax,%edi
  802d59:	48 b8 f9 26 80 00 00 	movabs $0x8026f9,%rax
  802d60:	00 00 00 
  802d63:	ff d0                	callq  *%rax
	return r;
  802d65:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802d68:	c9                   	leaveq 
  802d69:	c3                   	retq   

0000000000802d6a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802d6a:	55                   	push   %rbp
  802d6b:	48 89 e5             	mov    %rsp,%rbp
  802d6e:	48 83 ec 10          	sub    $0x10,%rsp
  802d72:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d75:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802d79:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d80:	00 00 00 
  802d83:	8b 00                	mov    (%rax),%eax
  802d85:	85 c0                	test   %eax,%eax
  802d87:	75 1f                	jne    802da8 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802d89:	bf 01 00 00 00       	mov    $0x1,%edi
  802d8e:	48 b8 bb 4c 80 00 00 	movabs $0x804cbb,%rax
  802d95:	00 00 00 
  802d98:	ff d0                	callq  *%rax
  802d9a:	89 c2                	mov    %eax,%edx
  802d9c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802da3:	00 00 00 
  802da6:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802da8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802daf:	00 00 00 
  802db2:	8b 00                	mov    (%rax),%eax
  802db4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802db7:	b9 07 00 00 00       	mov    $0x7,%ecx
  802dbc:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802dc3:	00 00 00 
  802dc6:	89 c7                	mov    %eax,%edi
  802dc8:	48 b8 2e 4b 80 00 00 	movabs $0x804b2e,%rax
  802dcf:	00 00 00 
  802dd2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802dd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dd8:	ba 00 00 00 00       	mov    $0x0,%edx
  802ddd:	48 89 c6             	mov    %rax,%rsi
  802de0:	bf 00 00 00 00       	mov    $0x0,%edi
  802de5:	48 b8 f0 4a 80 00 00 	movabs $0x804af0,%rax
  802dec:	00 00 00 
  802def:	ff d0                	callq  *%rax
}
  802df1:	c9                   	leaveq 
  802df2:	c3                   	retq   

0000000000802df3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802df3:	55                   	push   %rbp
  802df4:	48 89 e5             	mov    %rsp,%rbp
  802df7:	48 83 ec 10          	sub    $0x10,%rsp
  802dfb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802dff:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  802e02:	48 ba 5e 55 80 00 00 	movabs $0x80555e,%rdx
  802e09:	00 00 00 
  802e0c:	be 4c 00 00 00       	mov    $0x4c,%esi
  802e11:	48 bf 73 55 80 00 00 	movabs $0x805573,%rdi
  802e18:	00 00 00 
  802e1b:	b8 00 00 00 00       	mov    $0x0,%eax
  802e20:	48 b9 b9 08 80 00 00 	movabs $0x8008b9,%rcx
  802e27:	00 00 00 
  802e2a:	ff d1                	callq  *%rcx

0000000000802e2c <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802e2c:	55                   	push   %rbp
  802e2d:	48 89 e5             	mov    %rsp,%rbp
  802e30:	48 83 ec 10          	sub    $0x10,%rsp
  802e34:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802e38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e3c:	8b 50 0c             	mov    0xc(%rax),%edx
  802e3f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802e46:	00 00 00 
  802e49:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802e4b:	be 00 00 00 00       	mov    $0x0,%esi
  802e50:	bf 06 00 00 00       	mov    $0x6,%edi
  802e55:	48 b8 6a 2d 80 00 00 	movabs $0x802d6a,%rax
  802e5c:	00 00 00 
  802e5f:	ff d0                	callq  *%rax
}
  802e61:	c9                   	leaveq 
  802e62:	c3                   	retq   

0000000000802e63 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802e63:	55                   	push   %rbp
  802e64:	48 89 e5             	mov    %rsp,%rbp
  802e67:	48 83 ec 20          	sub    $0x20,%rsp
  802e6b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e6f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802e73:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  802e77:	48 ba 7e 55 80 00 00 	movabs $0x80557e,%rdx
  802e7e:	00 00 00 
  802e81:	be 6b 00 00 00       	mov    $0x6b,%esi
  802e86:	48 bf 73 55 80 00 00 	movabs $0x805573,%rdi
  802e8d:	00 00 00 
  802e90:	b8 00 00 00 00       	mov    $0x0,%eax
  802e95:	48 b9 b9 08 80 00 00 	movabs $0x8008b9,%rcx
  802e9c:	00 00 00 
  802e9f:	ff d1                	callq  *%rcx

0000000000802ea1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802ea1:	55                   	push   %rbp
  802ea2:	48 89 e5             	mov    %rsp,%rbp
  802ea5:	48 83 ec 20          	sub    $0x20,%rsp
  802ea9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ead:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802eb1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  802eb5:	48 ba 9b 55 80 00 00 	movabs $0x80559b,%rdx
  802ebc:	00 00 00 
  802ebf:	be 7b 00 00 00       	mov    $0x7b,%esi
  802ec4:	48 bf 73 55 80 00 00 	movabs $0x805573,%rdi
  802ecb:	00 00 00 
  802ece:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed3:	48 b9 b9 08 80 00 00 	movabs $0x8008b9,%rcx
  802eda:	00 00 00 
  802edd:	ff d1                	callq  *%rcx

0000000000802edf <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802edf:	55                   	push   %rbp
  802ee0:	48 89 e5             	mov    %rsp,%rbp
  802ee3:	48 83 ec 20          	sub    $0x20,%rsp
  802ee7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802eeb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802eef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef3:	8b 50 0c             	mov    0xc(%rax),%edx
  802ef6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802efd:	00 00 00 
  802f00:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802f02:	be 00 00 00 00       	mov    $0x0,%esi
  802f07:	bf 05 00 00 00       	mov    $0x5,%edi
  802f0c:	48 b8 6a 2d 80 00 00 	movabs $0x802d6a,%rax
  802f13:	00 00 00 
  802f16:	ff d0                	callq  *%rax
  802f18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f1f:	79 05                	jns    802f26 <devfile_stat+0x47>
		return r;
  802f21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f24:	eb 56                	jmp    802f7c <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802f26:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f2a:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802f31:	00 00 00 
  802f34:	48 89 c7             	mov    %rax,%rdi
  802f37:	48 b8 8c 16 80 00 00 	movabs $0x80168c,%rax
  802f3e:	00 00 00 
  802f41:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802f43:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f4a:	00 00 00 
  802f4d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802f53:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f57:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802f5d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f64:	00 00 00 
  802f67:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802f6d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f71:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802f77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f7c:	c9                   	leaveq 
  802f7d:	c3                   	retq   

0000000000802f7e <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802f7e:	55                   	push   %rbp
  802f7f:	48 89 e5             	mov    %rsp,%rbp
  802f82:	48 83 ec 10          	sub    $0x10,%rsp
  802f86:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f8a:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802f8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f91:	8b 50 0c             	mov    0xc(%rax),%edx
  802f94:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f9b:	00 00 00 
  802f9e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802fa0:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fa7:	00 00 00 
  802faa:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802fad:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802fb0:	be 00 00 00 00       	mov    $0x0,%esi
  802fb5:	bf 02 00 00 00       	mov    $0x2,%edi
  802fba:	48 b8 6a 2d 80 00 00 	movabs $0x802d6a,%rax
  802fc1:	00 00 00 
  802fc4:	ff d0                	callq  *%rax
}
  802fc6:	c9                   	leaveq 
  802fc7:	c3                   	retq   

0000000000802fc8 <remove>:

// Delete a file
int
remove(const char *path)
{
  802fc8:	55                   	push   %rbp
  802fc9:	48 89 e5             	mov    %rsp,%rbp
  802fcc:	48 83 ec 10          	sub    $0x10,%rsp
  802fd0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802fd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fd8:	48 89 c7             	mov    %rax,%rdi
  802fdb:	48 b8 20 16 80 00 00 	movabs $0x801620,%rax
  802fe2:	00 00 00 
  802fe5:	ff d0                	callq  *%rax
  802fe7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802fec:	7e 07                	jle    802ff5 <remove+0x2d>
		return -E_BAD_PATH;
  802fee:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ff3:	eb 33                	jmp    803028 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802ff5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ff9:	48 89 c6             	mov    %rax,%rsi
  802ffc:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803003:	00 00 00 
  803006:	48 b8 8c 16 80 00 00 	movabs $0x80168c,%rax
  80300d:	00 00 00 
  803010:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803012:	be 00 00 00 00       	mov    $0x0,%esi
  803017:	bf 07 00 00 00       	mov    $0x7,%edi
  80301c:	48 b8 6a 2d 80 00 00 	movabs $0x802d6a,%rax
  803023:	00 00 00 
  803026:	ff d0                	callq  *%rax
}
  803028:	c9                   	leaveq 
  803029:	c3                   	retq   

000000000080302a <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80302a:	55                   	push   %rbp
  80302b:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80302e:	be 00 00 00 00       	mov    $0x0,%esi
  803033:	bf 08 00 00 00       	mov    $0x8,%edi
  803038:	48 b8 6a 2d 80 00 00 	movabs $0x802d6a,%rax
  80303f:	00 00 00 
  803042:	ff d0                	callq  *%rax
}
  803044:	5d                   	pop    %rbp
  803045:	c3                   	retq   

0000000000803046 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803046:	55                   	push   %rbp
  803047:	48 89 e5             	mov    %rsp,%rbp
  80304a:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803051:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803058:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80305f:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803066:	be 00 00 00 00       	mov    $0x0,%esi
  80306b:	48 89 c7             	mov    %rax,%rdi
  80306e:	48 b8 f3 2d 80 00 00 	movabs $0x802df3,%rax
  803075:	00 00 00 
  803078:	ff d0                	callq  *%rax
  80307a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80307d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803081:	79 28                	jns    8030ab <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803083:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803086:	89 c6                	mov    %eax,%esi
  803088:	48 bf b9 55 80 00 00 	movabs $0x8055b9,%rdi
  80308f:	00 00 00 
  803092:	b8 00 00 00 00       	mov    $0x0,%eax
  803097:	48 ba f2 0a 80 00 00 	movabs $0x800af2,%rdx
  80309e:	00 00 00 
  8030a1:	ff d2                	callq  *%rdx
		return fd_src;
  8030a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a6:	e9 74 01 00 00       	jmpq   80321f <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8030ab:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8030b2:	be 01 01 00 00       	mov    $0x101,%esi
  8030b7:	48 89 c7             	mov    %rax,%rdi
  8030ba:	48 b8 f3 2d 80 00 00 	movabs $0x802df3,%rax
  8030c1:	00 00 00 
  8030c4:	ff d0                	callq  *%rax
  8030c6:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8030c9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8030cd:	79 39                	jns    803108 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8030cf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030d2:	89 c6                	mov    %eax,%esi
  8030d4:	48 bf cf 55 80 00 00 	movabs $0x8055cf,%rdi
  8030db:	00 00 00 
  8030de:	b8 00 00 00 00       	mov    $0x0,%eax
  8030e3:	48 ba f2 0a 80 00 00 	movabs $0x800af2,%rdx
  8030ea:	00 00 00 
  8030ed:	ff d2                	callq  *%rdx
		close(fd_src);
  8030ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f2:	89 c7                	mov    %eax,%edi
  8030f4:	48 b8 f9 26 80 00 00 	movabs $0x8026f9,%rax
  8030fb:	00 00 00 
  8030fe:	ff d0                	callq  *%rax
		return fd_dest;
  803100:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803103:	e9 17 01 00 00       	jmpq   80321f <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803108:	eb 74                	jmp    80317e <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80310a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80310d:	48 63 d0             	movslq %eax,%rdx
  803110:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803117:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80311a:	48 89 ce             	mov    %rcx,%rsi
  80311d:	89 c7                	mov    %eax,%edi
  80311f:	48 b8 65 2a 80 00 00 	movabs $0x802a65,%rax
  803126:	00 00 00 
  803129:	ff d0                	callq  *%rax
  80312b:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80312e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803132:	79 4a                	jns    80317e <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803134:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803137:	89 c6                	mov    %eax,%esi
  803139:	48 bf e9 55 80 00 00 	movabs $0x8055e9,%rdi
  803140:	00 00 00 
  803143:	b8 00 00 00 00       	mov    $0x0,%eax
  803148:	48 ba f2 0a 80 00 00 	movabs $0x800af2,%rdx
  80314f:	00 00 00 
  803152:	ff d2                	callq  *%rdx
			close(fd_src);
  803154:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803157:	89 c7                	mov    %eax,%edi
  803159:	48 b8 f9 26 80 00 00 	movabs $0x8026f9,%rax
  803160:	00 00 00 
  803163:	ff d0                	callq  *%rax
			close(fd_dest);
  803165:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803168:	89 c7                	mov    %eax,%edi
  80316a:	48 b8 f9 26 80 00 00 	movabs $0x8026f9,%rax
  803171:	00 00 00 
  803174:	ff d0                	callq  *%rax
			return write_size;
  803176:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803179:	e9 a1 00 00 00       	jmpq   80321f <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80317e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803185:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803188:	ba 00 02 00 00       	mov    $0x200,%edx
  80318d:	48 89 ce             	mov    %rcx,%rsi
  803190:	89 c7                	mov    %eax,%edi
  803192:	48 b8 1b 29 80 00 00 	movabs $0x80291b,%rax
  803199:	00 00 00 
  80319c:	ff d0                	callq  *%rax
  80319e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8031a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8031a5:	0f 8f 5f ff ff ff    	jg     80310a <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  8031ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8031af:	79 47                	jns    8031f8 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8031b1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031b4:	89 c6                	mov    %eax,%esi
  8031b6:	48 bf fc 55 80 00 00 	movabs $0x8055fc,%rdi
  8031bd:	00 00 00 
  8031c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8031c5:	48 ba f2 0a 80 00 00 	movabs $0x800af2,%rdx
  8031cc:	00 00 00 
  8031cf:	ff d2                	callq  *%rdx
		close(fd_src);
  8031d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d4:	89 c7                	mov    %eax,%edi
  8031d6:	48 b8 f9 26 80 00 00 	movabs $0x8026f9,%rax
  8031dd:	00 00 00 
  8031e0:	ff d0                	callq  *%rax
		close(fd_dest);
  8031e2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031e5:	89 c7                	mov    %eax,%edi
  8031e7:	48 b8 f9 26 80 00 00 	movabs $0x8026f9,%rax
  8031ee:	00 00 00 
  8031f1:	ff d0                	callq  *%rax
		return read_size;
  8031f3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031f6:	eb 27                	jmp    80321f <copy+0x1d9>
	}
	close(fd_src);
  8031f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031fb:	89 c7                	mov    %eax,%edi
  8031fd:	48 b8 f9 26 80 00 00 	movabs $0x8026f9,%rax
  803204:	00 00 00 
  803207:	ff d0                	callq  *%rax
	close(fd_dest);
  803209:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80320c:	89 c7                	mov    %eax,%edi
  80320e:	48 b8 f9 26 80 00 00 	movabs $0x8026f9,%rax
  803215:	00 00 00 
  803218:	ff d0                	callq  *%rax
	return 0;
  80321a:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80321f:	c9                   	leaveq 
  803220:	c3                   	retq   

0000000000803221 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  803221:	55                   	push   %rbp
  803222:	48 89 e5             	mov    %rsp,%rbp
  803225:	48 81 ec 00 03 00 00 	sub    $0x300,%rsp
  80322c:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  803233:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial rip and rsp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  80323a:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  803241:	be 00 00 00 00       	mov    $0x0,%esi
  803246:	48 89 c7             	mov    %rax,%rdi
  803249:	48 b8 f3 2d 80 00 00 	movabs $0x802df3,%rax
  803250:	00 00 00 
  803253:	ff d0                	callq  *%rax
  803255:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803258:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80325c:	79 08                	jns    803266 <spawn+0x45>
		return r;
  80325e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803261:	e9 12 03 00 00       	jmpq   803578 <spawn+0x357>
	fd = r;
  803266:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803269:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  80326c:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  803273:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  803277:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  80327e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803281:	ba 00 02 00 00       	mov    $0x200,%edx
  803286:	48 89 ce             	mov    %rcx,%rsi
  803289:	89 c7                	mov    %eax,%edi
  80328b:	48 b8 f0 29 80 00 00 	movabs $0x8029f0,%rax
  803292:	00 00 00 
  803295:	ff d0                	callq  *%rax
  803297:	3d 00 02 00 00       	cmp    $0x200,%eax
  80329c:	75 0d                	jne    8032ab <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  80329e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032a2:	8b 00                	mov    (%rax),%eax
  8032a4:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  8032a9:	74 43                	je     8032ee <spawn+0xcd>
		close(fd);
  8032ab:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8032ae:	89 c7                	mov    %eax,%edi
  8032b0:	48 b8 f9 26 80 00 00 	movabs $0x8026f9,%rax
  8032b7:	00 00 00 
  8032ba:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8032bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032c0:	8b 00                	mov    (%rax),%eax
  8032c2:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  8032c7:	89 c6                	mov    %eax,%esi
  8032c9:	48 bf 18 56 80 00 00 	movabs $0x805618,%rdi
  8032d0:	00 00 00 
  8032d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8032d8:	48 b9 f2 0a 80 00 00 	movabs $0x800af2,%rcx
  8032df:	00 00 00 
  8032e2:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  8032e4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8032e9:	e9 8a 02 00 00       	jmpq   803578 <spawn+0x357>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8032ee:	b8 07 00 00 00       	mov    $0x7,%eax
  8032f3:	cd 30                	int    $0x30
  8032f5:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8032f8:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8032fb:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8032fe:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803302:	79 08                	jns    80330c <spawn+0xeb>
		return r;
  803304:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803307:	e9 6c 02 00 00       	jmpq   803578 <spawn+0x357>
	child = r;
  80330c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80330f:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  803312:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803315:	25 ff 03 00 00       	and    $0x3ff,%eax
  80331a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803321:	00 00 00 
  803324:	48 98                	cltq   
  803326:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80332d:	48 01 c2             	add    %rax,%rdx
  803330:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  803337:	48 89 d6             	mov    %rdx,%rsi
  80333a:	ba 18 00 00 00       	mov    $0x18,%edx
  80333f:	48 89 c7             	mov    %rax,%rdi
  803342:	48 89 d1             	mov    %rdx,%rcx
  803345:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  803348:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80334c:	48 8b 40 18          	mov    0x18(%rax),%rax
  803350:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  803357:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  80335e:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  803365:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  80336c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80336f:	48 89 ce             	mov    %rcx,%rsi
  803372:	89 c7                	mov    %eax,%edi
  803374:	48 b8 dc 37 80 00 00 	movabs $0x8037dc,%rax
  80337b:	00 00 00 
  80337e:	ff d0                	callq  *%rax
  803380:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803383:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803387:	79 08                	jns    803391 <spawn+0x170>
		return r;
  803389:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80338c:	e9 e7 01 00 00       	jmpq   803578 <spawn+0x357>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  803391:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803395:	48 8b 40 20          	mov    0x20(%rax),%rax
  803399:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  8033a0:	48 01 d0             	add    %rdx,%rax
  8033a3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8033a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8033ae:	e9 a9 00 00 00       	jmpq   80345c <spawn+0x23b>
		if (ph->p_type != ELF_PROG_LOAD)
  8033b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033b7:	8b 00                	mov    (%rax),%eax
  8033b9:	83 f8 01             	cmp    $0x1,%eax
  8033bc:	74 05                	je     8033c3 <spawn+0x1a2>
			continue;
  8033be:	e9 90 00 00 00       	jmpq   803453 <spawn+0x232>
		perm = PTE_P | PTE_U;
  8033c3:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8033ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033ce:	8b 40 04             	mov    0x4(%rax),%eax
  8033d1:	83 e0 02             	and    $0x2,%eax
  8033d4:	85 c0                	test   %eax,%eax
  8033d6:	74 04                	je     8033dc <spawn+0x1bb>
			perm |= PTE_W;
  8033d8:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  8033dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033e0:	48 8b 40 08          	mov    0x8(%rax),%rax
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8033e4:	41 89 c1             	mov    %eax,%r9d
  8033e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033eb:	4c 8b 40 20          	mov    0x20(%rax),%r8
  8033ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033f3:	48 8b 50 28          	mov    0x28(%rax),%rdx
  8033f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033fb:	48 8b 70 10          	mov    0x10(%rax),%rsi
  8033ff:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803402:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803405:	48 83 ec 08          	sub    $0x8,%rsp
  803409:	8b 7d ec             	mov    -0x14(%rbp),%edi
  80340c:	57                   	push   %rdi
  80340d:	89 c7                	mov    %eax,%edi
  80340f:	48 b8 88 3a 80 00 00 	movabs $0x803a88,%rax
  803416:	00 00 00 
  803419:	ff d0                	callq  *%rax
  80341b:	48 83 c4 10          	add    $0x10,%rsp
  80341f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803422:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803426:	79 2b                	jns    803453 <spawn+0x232>
			goto error;
  803428:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803429:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80342c:	89 c7                	mov    %eax,%edi
  80342e:	48 b8 fb 1e 80 00 00 	movabs $0x801efb,%rax
  803435:	00 00 00 
  803438:	ff d0                	callq  *%rax
	close(fd);
  80343a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80343d:	89 c7                	mov    %eax,%edi
  80343f:	48 b8 f9 26 80 00 00 	movabs $0x8026f9,%rax
  803446:	00 00 00 
  803449:	ff d0                	callq  *%rax
	return r;
  80344b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80344e:	e9 25 01 00 00       	jmpq   803578 <spawn+0x357>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803453:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803457:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  80345c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803460:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  803464:	0f b7 c0             	movzwl %ax,%eax
  803467:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  80346a:	0f 8f 43 ff ff ff    	jg     8033b3 <spawn+0x192>
	close(fd);
  803470:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803473:	89 c7                	mov    %eax,%edi
  803475:	48 b8 f9 26 80 00 00 	movabs $0x8026f9,%rax
  80347c:	00 00 00 
  80347f:	ff d0                	callq  *%rax
	fd = -1;
  803481:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)
	if ((r = copy_shared_pages(child)) < 0)
  803488:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80348b:	89 c7                	mov    %eax,%edi
  80348d:	48 b8 74 3c 80 00 00 	movabs $0x803c74,%rax
  803494:	00 00 00 
  803497:	ff d0                	callq  *%rax
  803499:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80349c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8034a0:	79 30                	jns    8034d2 <spawn+0x2b1>
		panic("copy_shared_pages: %e", r);
  8034a2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8034a5:	89 c1                	mov    %eax,%ecx
  8034a7:	48 ba 32 56 80 00 00 	movabs $0x805632,%rdx
  8034ae:	00 00 00 
  8034b1:	be 82 00 00 00       	mov    $0x82,%esi
  8034b6:	48 bf 48 56 80 00 00 	movabs $0x805648,%rdi
  8034bd:	00 00 00 
  8034c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c5:	49 b8 b9 08 80 00 00 	movabs $0x8008b9,%r8
  8034cc:	00 00 00 
  8034cf:	41 ff d0             	callq  *%r8
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8034d2:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  8034d9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8034dc:	48 89 d6             	mov    %rdx,%rsi
  8034df:	89 c7                	mov    %eax,%edi
  8034e1:	48 b8 04 21 80 00 00 	movabs $0x802104,%rax
  8034e8:	00 00 00 
  8034eb:	ff d0                	callq  *%rax
  8034ed:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8034f0:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8034f4:	79 30                	jns    803526 <spawn+0x305>
		panic("sys_env_set_trapframe: %e", r);
  8034f6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8034f9:	89 c1                	mov    %eax,%ecx
  8034fb:	48 ba 54 56 80 00 00 	movabs $0x805654,%rdx
  803502:	00 00 00 
  803505:	be 85 00 00 00       	mov    $0x85,%esi
  80350a:	48 bf 48 56 80 00 00 	movabs $0x805648,%rdi
  803511:	00 00 00 
  803514:	b8 00 00 00 00       	mov    $0x0,%eax
  803519:	49 b8 b9 08 80 00 00 	movabs $0x8008b9,%r8
  803520:	00 00 00 
  803523:	41 ff d0             	callq  *%r8
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803526:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803529:	be 02 00 00 00       	mov    $0x2,%esi
  80352e:	89 c7                	mov    %eax,%edi
  803530:	48 b8 b7 20 80 00 00 	movabs $0x8020b7,%rax
  803537:	00 00 00 
  80353a:	ff d0                	callq  *%rax
  80353c:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80353f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803543:	79 30                	jns    803575 <spawn+0x354>
		panic("sys_env_set_status: %e", r);
  803545:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803548:	89 c1                	mov    %eax,%ecx
  80354a:	48 ba 6e 56 80 00 00 	movabs $0x80566e,%rdx
  803551:	00 00 00 
  803554:	be 88 00 00 00       	mov    $0x88,%esi
  803559:	48 bf 48 56 80 00 00 	movabs $0x805648,%rdi
  803560:	00 00 00 
  803563:	b8 00 00 00 00       	mov    $0x0,%eax
  803568:	49 b8 b9 08 80 00 00 	movabs $0x8008b9,%r8
  80356f:	00 00 00 
  803572:	41 ff d0             	callq  *%r8
	return child;
  803575:	8b 45 d4             	mov    -0x2c(%rbp),%eax
}
  803578:	c9                   	leaveq 
  803579:	c3                   	retq   

000000000080357a <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  80357a:	55                   	push   %rbp
  80357b:	48 89 e5             	mov    %rsp,%rbp
  80357e:	41 55                	push   %r13
  803580:	41 54                	push   %r12
  803582:	53                   	push   %rbx
  803583:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80358a:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  803591:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  803598:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  80359f:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  8035a6:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  8035ad:	84 c0                	test   %al,%al
  8035af:	74 26                	je     8035d7 <spawnl+0x5d>
  8035b1:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  8035b8:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  8035bf:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  8035c3:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  8035c7:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  8035cb:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  8035cf:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  8035d3:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  8035d7:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  8035de:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  8035e5:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  8035e8:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  8035ef:	00 00 00 
  8035f2:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  8035f9:	00 00 00 
  8035fc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803600:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803607:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80360e:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803615:	eb 07                	jmp    80361e <spawnl+0xa4>
		argc++;
  803617:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	while(va_arg(vl, void *) != NULL)
  80361e:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803624:	83 f8 30             	cmp    $0x30,%eax
  803627:	73 23                	jae    80364c <spawnl+0xd2>
  803629:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  803630:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803636:	89 d2                	mov    %edx,%edx
  803638:	48 01 d0             	add    %rdx,%rax
  80363b:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803641:	83 c2 08             	add    $0x8,%edx
  803644:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  80364a:	eb 12                	jmp    80365e <spawnl+0xe4>
  80364c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803653:	48 8d 50 08          	lea    0x8(%rax),%rdx
  803657:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80365e:	48 8b 00             	mov    (%rax),%rax
  803661:	48 85 c0             	test   %rax,%rax
  803664:	75 b1                	jne    803617 <spawnl+0x9d>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803666:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80366c:	83 c0 02             	add    $0x2,%eax
  80366f:	48 89 e2             	mov    %rsp,%rdx
  803672:	48 89 d3             	mov    %rdx,%rbx
  803675:	48 63 d0             	movslq %eax,%rdx
  803678:	48 83 ea 01          	sub    $0x1,%rdx
  80367c:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  803683:	48 63 d0             	movslq %eax,%rdx
  803686:	49 89 d4             	mov    %rdx,%r12
  803689:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  80368f:	48 63 d0             	movslq %eax,%rdx
  803692:	49 89 d2             	mov    %rdx,%r10
  803695:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  80369b:	48 98                	cltq   
  80369d:	48 c1 e0 03          	shl    $0x3,%rax
  8036a1:	48 8d 50 07          	lea    0x7(%rax),%rdx
  8036a5:	b8 10 00 00 00       	mov    $0x10,%eax
  8036aa:	48 83 e8 01          	sub    $0x1,%rax
  8036ae:	48 01 d0             	add    %rdx,%rax
  8036b1:	be 10 00 00 00       	mov    $0x10,%esi
  8036b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8036bb:	48 f7 f6             	div    %rsi
  8036be:	48 6b c0 10          	imul   $0x10,%rax,%rax
  8036c2:	48 29 c4             	sub    %rax,%rsp
  8036c5:	48 89 e0             	mov    %rsp,%rax
  8036c8:	48 83 c0 07          	add    $0x7,%rax
  8036cc:	48 c1 e8 03          	shr    $0x3,%rax
  8036d0:	48 c1 e0 03          	shl    $0x3,%rax
  8036d4:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  8036db:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8036e2:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  8036e9:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  8036ec:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8036f2:	8d 50 01             	lea    0x1(%rax),%edx
  8036f5:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8036fc:	48 63 d2             	movslq %edx,%rdx
  8036ff:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803706:	00 

	va_start(vl, arg0);
  803707:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80370e:	00 00 00 
  803711:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  803718:	00 00 00 
  80371b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80371f:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803726:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80372d:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803734:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  80373b:	00 00 00 
  80373e:	eb 60                	jmp    8037a0 <spawnl+0x226>
		argv[i+1] = va_arg(vl, const char *);
  803740:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803746:	8d 48 01             	lea    0x1(%rax),%ecx
  803749:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  80374f:	83 f8 30             	cmp    $0x30,%eax
  803752:	73 23                	jae    803777 <spawnl+0x1fd>
  803754:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  80375b:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  803761:	89 d2                	mov    %edx,%edx
  803763:	48 01 d0             	add    %rdx,%rax
  803766:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80376c:	83 c2 08             	add    $0x8,%edx
  80376f:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  803775:	eb 12                	jmp    803789 <spawnl+0x20f>
  803777:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80377e:	48 8d 50 08          	lea    0x8(%rax),%rdx
  803782:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803789:	48 8b 10             	mov    (%rax),%rdx
  80378c:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803793:	89 c9                	mov    %ecx,%ecx
  803795:	48 89 14 c8          	mov    %rdx,(%rax,%rcx,8)
	for(i=0;i<argc;i++)
  803799:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  8037a0:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8037a6:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  8037ac:	77 92                	ja     803740 <spawnl+0x1c6>
	va_end(vl);
	return spawn(prog, argv);
  8037ae:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8037b5:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  8037bc:	48 89 d6             	mov    %rdx,%rsi
  8037bf:	48 89 c7             	mov    %rax,%rdi
  8037c2:	48 b8 21 32 80 00 00 	movabs $0x803221,%rax
  8037c9:	00 00 00 
  8037cc:	ff d0                	callq  *%rax
  8037ce:	48 89 dc             	mov    %rbx,%rsp
}
  8037d1:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  8037d5:	5b                   	pop    %rbx
  8037d6:	41 5c                	pop    %r12
  8037d8:	41 5d                	pop    %r13
  8037da:	5d                   	pop    %rbp
  8037db:	c3                   	retq   

00000000008037dc <init_stack>:
// On success, returns 0 and sets *init_rsp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_rsp)
{
  8037dc:	55                   	push   %rbp
  8037dd:	48 89 e5             	mov    %rsp,%rbp
  8037e0:	48 83 ec 50          	sub    $0x50,%rsp
  8037e4:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8037e7:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8037eb:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8037ef:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8037f6:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  8037f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8037fe:	eb 33                	jmp    803833 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803800:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803803:	48 98                	cltq   
  803805:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80380c:	00 
  80380d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803811:	48 01 d0             	add    %rdx,%rax
  803814:	48 8b 00             	mov    (%rax),%rax
  803817:	48 89 c7             	mov    %rax,%rdi
  80381a:	48 b8 20 16 80 00 00 	movabs $0x801620,%rax
  803821:	00 00 00 
  803824:	ff d0                	callq  *%rax
  803826:	83 c0 01             	add    $0x1,%eax
  803829:	48 98                	cltq   
  80382b:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	for (argc = 0; argv[argc] != 0; argc++)
  80382f:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803833:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803836:	48 98                	cltq   
  803838:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80383f:	00 
  803840:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803844:	48 01 d0             	add    %rdx,%rax
  803847:	48 8b 00             	mov    (%rax),%rax
  80384a:	48 85 c0             	test   %rax,%rax
  80384d:	75 b1                	jne    803800 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80384f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803853:	48 f7 d8             	neg    %rax
  803856:	48 05 00 10 40 00    	add    $0x401000,%rax
  80385c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803860:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803864:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803868:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80386c:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803870:	48 89 c2             	mov    %rax,%rdx
  803873:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803876:	83 c0 01             	add    $0x1,%eax
  803879:	c1 e0 03             	shl    $0x3,%eax
  80387c:	48 98                	cltq   
  80387e:	48 f7 d8             	neg    %rax
  803881:	48 01 d0             	add    %rdx,%rax
  803884:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803888:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80388c:	48 83 e8 10          	sub    $0x10,%rax
  803890:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803896:	77 0a                	ja     8038a2 <init_stack+0xc6>
		return -E_NO_MEM;
  803898:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  80389d:	e9 e4 01 00 00       	jmpq   803a86 <init_stack+0x2aa>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8038a2:	ba 07 00 00 00       	mov    $0x7,%edx
  8038a7:	be 00 00 40 00       	mov    $0x400000,%esi
  8038ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8038b1:	48 b8 b9 1f 80 00 00 	movabs $0x801fb9,%rax
  8038b8:	00 00 00 
  8038bb:	ff d0                	callq  *%rax
  8038bd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038c4:	79 08                	jns    8038ce <init_stack+0xf2>
		return r;
  8038c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038c9:	e9 b8 01 00 00       	jmpq   803a86 <init_stack+0x2aa>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_rsp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8038ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8038d5:	e9 8a 00 00 00       	jmpq   803964 <init_stack+0x188>
		argv_store[i] = UTEMP2USTACK(string_store);
  8038da:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8038dd:	48 98                	cltq   
  8038df:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8038e6:	00 
  8038e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038eb:	48 01 d0             	add    %rdx,%rax
  8038ee:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8038f3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8038f7:	48 01 ca             	add    %rcx,%rdx
  8038fa:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  803901:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  803904:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803907:	48 98                	cltq   
  803909:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803910:	00 
  803911:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803915:	48 01 d0             	add    %rdx,%rax
  803918:	48 8b 10             	mov    (%rax),%rdx
  80391b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80391f:	48 89 d6             	mov    %rdx,%rsi
  803922:	48 89 c7             	mov    %rax,%rdi
  803925:	48 b8 8c 16 80 00 00 	movabs $0x80168c,%rax
  80392c:	00 00 00 
  80392f:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803931:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803934:	48 98                	cltq   
  803936:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80393d:	00 
  80393e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803942:	48 01 d0             	add    %rdx,%rax
  803945:	48 8b 00             	mov    (%rax),%rax
  803948:	48 89 c7             	mov    %rax,%rdi
  80394b:	48 b8 20 16 80 00 00 	movabs $0x801620,%rax
  803952:	00 00 00 
  803955:	ff d0                	callq  *%rax
  803957:	83 c0 01             	add    $0x1,%eax
  80395a:	48 98                	cltq   
  80395c:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	for (i = 0; i < argc; i++) {
  803960:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803964:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803967:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80396a:	0f 8c 6a ff ff ff    	jl     8038da <init_stack+0xfe>
	}
	argv_store[argc] = 0;
  803970:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803973:	48 98                	cltq   
  803975:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80397c:	00 
  80397d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803981:	48 01 d0             	add    %rdx,%rax
  803984:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80398b:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803992:	00 
  803993:	74 35                	je     8039ca <init_stack+0x1ee>
  803995:	48 b9 88 56 80 00 00 	movabs $0x805688,%rcx
  80399c:	00 00 00 
  80399f:	48 ba ae 56 80 00 00 	movabs $0x8056ae,%rdx
  8039a6:	00 00 00 
  8039a9:	be f1 00 00 00       	mov    $0xf1,%esi
  8039ae:	48 bf 48 56 80 00 00 	movabs $0x805648,%rdi
  8039b5:	00 00 00 
  8039b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8039bd:	49 b8 b9 08 80 00 00 	movabs $0x8008b9,%r8
  8039c4:	00 00 00 
  8039c7:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8039ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039ce:	48 83 e8 08          	sub    $0x8,%rax
  8039d2:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8039d7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8039db:	48 01 ca             	add    %rcx,%rdx
  8039de:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  8039e5:	48 89 10             	mov    %rdx,(%rax)
	argv_store[-2] = argc;
  8039e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039ec:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  8039f0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8039f3:	48 98                	cltq   
  8039f5:	48 89 02             	mov    %rax,(%rdx)

	*init_rsp = UTEMP2USTACK(&argv_store[-2]);
  8039f8:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  8039fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a01:	48 01 d0             	add    %rdx,%rax
  803a04:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803a0a:	48 89 c2             	mov    %rax,%rdx
  803a0d:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803a11:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803a14:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803a17:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803a1d:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803a22:	89 c2                	mov    %eax,%edx
  803a24:	be 00 00 40 00       	mov    $0x400000,%esi
  803a29:	bf 00 00 00 00       	mov    $0x0,%edi
  803a2e:	48 b8 0b 20 80 00 00 	movabs $0x80200b,%rax
  803a35:	00 00 00 
  803a38:	ff d0                	callq  *%rax
  803a3a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a3d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a41:	79 02                	jns    803a45 <init_stack+0x269>
		goto error;
  803a43:	eb 28                	jmp    803a6d <init_stack+0x291>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803a45:	be 00 00 40 00       	mov    $0x400000,%esi
  803a4a:	bf 00 00 00 00       	mov    $0x0,%edi
  803a4f:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  803a56:	00 00 00 
  803a59:	ff d0                	callq  *%rax
  803a5b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a5e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a62:	79 02                	jns    803a66 <init_stack+0x28a>
		goto error;
  803a64:	eb 07                	jmp    803a6d <init_stack+0x291>

	return 0;
  803a66:	b8 00 00 00 00       	mov    $0x0,%eax
  803a6b:	eb 19                	jmp    803a86 <init_stack+0x2aa>

error:
	sys_page_unmap(0, UTEMP);
  803a6d:	be 00 00 40 00       	mov    $0x400000,%esi
  803a72:	bf 00 00 00 00       	mov    $0x0,%edi
  803a77:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  803a7e:	00 00 00 
  803a81:	ff d0                	callq  *%rax
	return r;
  803a83:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803a86:	c9                   	leaveq 
  803a87:	c3                   	retq   

0000000000803a88 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  803a88:	55                   	push   %rbp
  803a89:	48 89 e5             	mov    %rsp,%rbp
  803a8c:	48 83 ec 50          	sub    $0x50,%rsp
  803a90:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803a93:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a97:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803a9b:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803a9e:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803aa2:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803aa6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803aaa:	25 ff 0f 00 00       	and    $0xfff,%eax
  803aaf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ab2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ab6:	74 21                	je     803ad9 <map_segment+0x51>
		va -= i;
  803ab8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803abb:	48 98                	cltq   
  803abd:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803ac1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ac4:	48 98                	cltq   
  803ac6:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803aca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803acd:	48 98                	cltq   
  803acf:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803ad3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ad6:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803ad9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ae0:	e9 79 01 00 00       	jmpq   803c5e <map_segment+0x1d6>
		if (i >= filesz) {
  803ae5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ae8:	48 98                	cltq   
  803aea:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803aee:	72 3c                	jb     803b2c <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803af0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803af3:	48 63 d0             	movslq %eax,%rdx
  803af6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803afa:	48 01 d0             	add    %rdx,%rax
  803afd:	48 89 c1             	mov    %rax,%rcx
  803b00:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803b03:	8b 55 10             	mov    0x10(%rbp),%edx
  803b06:	48 89 ce             	mov    %rcx,%rsi
  803b09:	89 c7                	mov    %eax,%edi
  803b0b:	48 b8 b9 1f 80 00 00 	movabs $0x801fb9,%rax
  803b12:	00 00 00 
  803b15:	ff d0                	callq  *%rax
  803b17:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803b1a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803b1e:	0f 89 33 01 00 00    	jns    803c57 <map_segment+0x1cf>
				return r;
  803b24:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b27:	e9 46 01 00 00       	jmpq   803c72 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803b2c:	ba 07 00 00 00       	mov    $0x7,%edx
  803b31:	be 00 00 40 00       	mov    $0x400000,%esi
  803b36:	bf 00 00 00 00       	mov    $0x0,%edi
  803b3b:	48 b8 b9 1f 80 00 00 	movabs $0x801fb9,%rax
  803b42:	00 00 00 
  803b45:	ff d0                	callq  *%rax
  803b47:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803b4a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803b4e:	79 08                	jns    803b58 <map_segment+0xd0>
				return r;
  803b50:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b53:	e9 1a 01 00 00       	jmpq   803c72 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803b58:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803b5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b5e:	01 c2                	add    %eax,%edx
  803b60:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803b63:	89 d6                	mov    %edx,%esi
  803b65:	89 c7                	mov    %eax,%edi
  803b67:	48 b8 39 2b 80 00 00 	movabs $0x802b39,%rax
  803b6e:	00 00 00 
  803b71:	ff d0                	callq  *%rax
  803b73:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803b76:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803b7a:	79 08                	jns    803b84 <map_segment+0xfc>
				return r;
  803b7c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b7f:	e9 ee 00 00 00       	jmpq   803c72 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803b84:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803b8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b8e:	48 98                	cltq   
  803b90:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803b94:	48 29 c2             	sub    %rax,%rdx
  803b97:	48 89 d0             	mov    %rdx,%rax
  803b9a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803b9e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803ba1:	48 63 d0             	movslq %eax,%rdx
  803ba4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ba8:	48 39 c2             	cmp    %rax,%rdx
  803bab:	48 0f 47 d0          	cmova  %rax,%rdx
  803baf:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803bb2:	be 00 00 40 00       	mov    $0x400000,%esi
  803bb7:	89 c7                	mov    %eax,%edi
  803bb9:	48 b8 f0 29 80 00 00 	movabs $0x8029f0,%rax
  803bc0:	00 00 00 
  803bc3:	ff d0                	callq  *%rax
  803bc5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803bc8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803bcc:	79 08                	jns    803bd6 <map_segment+0x14e>
				return r;
  803bce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803bd1:	e9 9c 00 00 00       	jmpq   803c72 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803bd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bd9:	48 63 d0             	movslq %eax,%rdx
  803bdc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803be0:	48 01 d0             	add    %rdx,%rax
  803be3:	48 89 c2             	mov    %rax,%rdx
  803be6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803be9:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803bed:	48 89 d1             	mov    %rdx,%rcx
  803bf0:	89 c2                	mov    %eax,%edx
  803bf2:	be 00 00 40 00       	mov    $0x400000,%esi
  803bf7:	bf 00 00 00 00       	mov    $0x0,%edi
  803bfc:	48 b8 0b 20 80 00 00 	movabs $0x80200b,%rax
  803c03:	00 00 00 
  803c06:	ff d0                	callq  *%rax
  803c08:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803c0b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803c0f:	79 30                	jns    803c41 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803c11:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c14:	89 c1                	mov    %eax,%ecx
  803c16:	48 ba c3 56 80 00 00 	movabs $0x8056c3,%rdx
  803c1d:	00 00 00 
  803c20:	be 24 01 00 00       	mov    $0x124,%esi
  803c25:	48 bf 48 56 80 00 00 	movabs $0x805648,%rdi
  803c2c:	00 00 00 
  803c2f:	b8 00 00 00 00       	mov    $0x0,%eax
  803c34:	49 b8 b9 08 80 00 00 	movabs $0x8008b9,%r8
  803c3b:	00 00 00 
  803c3e:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803c41:	be 00 00 40 00       	mov    $0x400000,%esi
  803c46:	bf 00 00 00 00       	mov    $0x0,%edi
  803c4b:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  803c52:	00 00 00 
  803c55:	ff d0                	callq  *%rax
	for (i = 0; i < memsz; i += PGSIZE) {
  803c57:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803c5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c61:	48 98                	cltq   
  803c63:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803c67:	0f 82 78 fe ff ff    	jb     803ae5 <map_segment+0x5d>
		}
	}
	return 0;
  803c6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c72:	c9                   	leaveq 
  803c73:	c3                   	retq   

0000000000803c74 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803c74:	55                   	push   %rbp
  803c75:	48 89 e5             	mov    %rsp,%rbp
  803c78:	48 83 ec 08          	sub    $0x8,%rsp
  803c7c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	// LAB 5: Your code here.
	return 0;
  803c7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c84:	c9                   	leaveq 
  803c85:	c3                   	retq   

0000000000803c86 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803c86:	55                   	push   %rbp
  803c87:	48 89 e5             	mov    %rsp,%rbp
  803c8a:	48 83 ec 20          	sub    $0x20,%rsp
  803c8e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803c91:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803c95:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c98:	48 89 d6             	mov    %rdx,%rsi
  803c9b:	89 c7                	mov    %eax,%edi
  803c9d:	48 b8 e7 24 80 00 00 	movabs $0x8024e7,%rax
  803ca4:	00 00 00 
  803ca7:	ff d0                	callq  *%rax
  803ca9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cb0:	79 05                	jns    803cb7 <fd2sockid+0x31>
		return r;
  803cb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cb5:	eb 24                	jmp    803cdb <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803cb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cbb:	8b 10                	mov    (%rax),%edx
  803cbd:	48 b8 c0 70 80 00 00 	movabs $0x8070c0,%rax
  803cc4:	00 00 00 
  803cc7:	8b 00                	mov    (%rax),%eax
  803cc9:	39 c2                	cmp    %eax,%edx
  803ccb:	74 07                	je     803cd4 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803ccd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803cd2:	eb 07                	jmp    803cdb <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803cd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cd8:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803cdb:	c9                   	leaveq 
  803cdc:	c3                   	retq   

0000000000803cdd <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803cdd:	55                   	push   %rbp
  803cde:	48 89 e5             	mov    %rsp,%rbp
  803ce1:	48 83 ec 20          	sub    $0x20,%rsp
  803ce5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803ce8:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803cec:	48 89 c7             	mov    %rax,%rdi
  803cef:	48 b8 4f 24 80 00 00 	movabs $0x80244f,%rax
  803cf6:	00 00 00 
  803cf9:	ff d0                	callq  *%rax
  803cfb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cfe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d02:	78 26                	js     803d2a <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803d04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d08:	ba 07 04 00 00       	mov    $0x407,%edx
  803d0d:	48 89 c6             	mov    %rax,%rsi
  803d10:	bf 00 00 00 00       	mov    $0x0,%edi
  803d15:	48 b8 b9 1f 80 00 00 	movabs $0x801fb9,%rax
  803d1c:	00 00 00 
  803d1f:	ff d0                	callq  *%rax
  803d21:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d24:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d28:	79 16                	jns    803d40 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803d2a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d2d:	89 c7                	mov    %eax,%edi
  803d2f:	48 b8 ec 41 80 00 00 	movabs $0x8041ec,%rax
  803d36:	00 00 00 
  803d39:	ff d0                	callq  *%rax
		return r;
  803d3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d3e:	eb 3a                	jmp    803d7a <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803d40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d44:	48 ba c0 70 80 00 00 	movabs $0x8070c0,%rdx
  803d4b:	00 00 00 
  803d4e:	8b 12                	mov    (%rdx),%edx
  803d50:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803d52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d56:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803d5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d61:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803d64:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803d67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d6b:	48 89 c7             	mov    %rax,%rdi
  803d6e:	48 b8 01 24 80 00 00 	movabs $0x802401,%rax
  803d75:	00 00 00 
  803d78:	ff d0                	callq  *%rax
}
  803d7a:	c9                   	leaveq 
  803d7b:	c3                   	retq   

0000000000803d7c <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803d7c:	55                   	push   %rbp
  803d7d:	48 89 e5             	mov    %rsp,%rbp
  803d80:	48 83 ec 30          	sub    $0x30,%rsp
  803d84:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d87:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d8b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803d8f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d92:	89 c7                	mov    %eax,%edi
  803d94:	48 b8 86 3c 80 00 00 	movabs $0x803c86,%rax
  803d9b:	00 00 00 
  803d9e:	ff d0                	callq  *%rax
  803da0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803da3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803da7:	79 05                	jns    803dae <accept+0x32>
		return r;
  803da9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dac:	eb 3b                	jmp    803de9 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803dae:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803db2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803db6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803db9:	48 89 ce             	mov    %rcx,%rsi
  803dbc:	89 c7                	mov    %eax,%edi
  803dbe:	48 b8 c9 40 80 00 00 	movabs $0x8040c9,%rax
  803dc5:	00 00 00 
  803dc8:	ff d0                	callq  *%rax
  803dca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dcd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dd1:	79 05                	jns    803dd8 <accept+0x5c>
		return r;
  803dd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dd6:	eb 11                	jmp    803de9 <accept+0x6d>
	return alloc_sockfd(r);
  803dd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ddb:	89 c7                	mov    %eax,%edi
  803ddd:	48 b8 dd 3c 80 00 00 	movabs $0x803cdd,%rax
  803de4:	00 00 00 
  803de7:	ff d0                	callq  *%rax
}
  803de9:	c9                   	leaveq 
  803dea:	c3                   	retq   

0000000000803deb <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803deb:	55                   	push   %rbp
  803dec:	48 89 e5             	mov    %rsp,%rbp
  803def:	48 83 ec 20          	sub    $0x20,%rsp
  803df3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803df6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803dfa:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803dfd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e00:	89 c7                	mov    %eax,%edi
  803e02:	48 b8 86 3c 80 00 00 	movabs $0x803c86,%rax
  803e09:	00 00 00 
  803e0c:	ff d0                	callq  *%rax
  803e0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e11:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e15:	79 05                	jns    803e1c <bind+0x31>
		return r;
  803e17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e1a:	eb 1b                	jmp    803e37 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803e1c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803e1f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803e23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e26:	48 89 ce             	mov    %rcx,%rsi
  803e29:	89 c7                	mov    %eax,%edi
  803e2b:	48 b8 48 41 80 00 00 	movabs $0x804148,%rax
  803e32:	00 00 00 
  803e35:	ff d0                	callq  *%rax
}
  803e37:	c9                   	leaveq 
  803e38:	c3                   	retq   

0000000000803e39 <shutdown>:

int
shutdown(int s, int how)
{
  803e39:	55                   	push   %rbp
  803e3a:	48 89 e5             	mov    %rsp,%rbp
  803e3d:	48 83 ec 20          	sub    $0x20,%rsp
  803e41:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e44:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803e47:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e4a:	89 c7                	mov    %eax,%edi
  803e4c:	48 b8 86 3c 80 00 00 	movabs $0x803c86,%rax
  803e53:	00 00 00 
  803e56:	ff d0                	callq  *%rax
  803e58:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e5f:	79 05                	jns    803e66 <shutdown+0x2d>
		return r;
  803e61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e64:	eb 16                	jmp    803e7c <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803e66:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803e69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e6c:	89 d6                	mov    %edx,%esi
  803e6e:	89 c7                	mov    %eax,%edi
  803e70:	48 b8 ac 41 80 00 00 	movabs $0x8041ac,%rax
  803e77:	00 00 00 
  803e7a:	ff d0                	callq  *%rax
}
  803e7c:	c9                   	leaveq 
  803e7d:	c3                   	retq   

0000000000803e7e <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803e7e:	55                   	push   %rbp
  803e7f:	48 89 e5             	mov    %rsp,%rbp
  803e82:	48 83 ec 10          	sub    $0x10,%rsp
  803e86:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803e8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e8e:	48 89 c7             	mov    %rax,%rdi
  803e91:	48 b8 2d 4d 80 00 00 	movabs $0x804d2d,%rax
  803e98:	00 00 00 
  803e9b:	ff d0                	callq  *%rax
  803e9d:	83 f8 01             	cmp    $0x1,%eax
  803ea0:	75 17                	jne    803eb9 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803ea2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ea6:	8b 40 0c             	mov    0xc(%rax),%eax
  803ea9:	89 c7                	mov    %eax,%edi
  803eab:	48 b8 ec 41 80 00 00 	movabs $0x8041ec,%rax
  803eb2:	00 00 00 
  803eb5:	ff d0                	callq  *%rax
  803eb7:	eb 05                	jmp    803ebe <devsock_close+0x40>
	else
		return 0;
  803eb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ebe:	c9                   	leaveq 
  803ebf:	c3                   	retq   

0000000000803ec0 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803ec0:	55                   	push   %rbp
  803ec1:	48 89 e5             	mov    %rsp,%rbp
  803ec4:	48 83 ec 20          	sub    $0x20,%rsp
  803ec8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ecb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ecf:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803ed2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ed5:	89 c7                	mov    %eax,%edi
  803ed7:	48 b8 86 3c 80 00 00 	movabs $0x803c86,%rax
  803ede:	00 00 00 
  803ee1:	ff d0                	callq  *%rax
  803ee3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ee6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eea:	79 05                	jns    803ef1 <connect+0x31>
		return r;
  803eec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eef:	eb 1b                	jmp    803f0c <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803ef1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803ef4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803ef8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803efb:	48 89 ce             	mov    %rcx,%rsi
  803efe:	89 c7                	mov    %eax,%edi
  803f00:	48 b8 19 42 80 00 00 	movabs $0x804219,%rax
  803f07:	00 00 00 
  803f0a:	ff d0                	callq  *%rax
}
  803f0c:	c9                   	leaveq 
  803f0d:	c3                   	retq   

0000000000803f0e <listen>:

int
listen(int s, int backlog)
{
  803f0e:	55                   	push   %rbp
  803f0f:	48 89 e5             	mov    %rsp,%rbp
  803f12:	48 83 ec 20          	sub    $0x20,%rsp
  803f16:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f19:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803f1c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f1f:	89 c7                	mov    %eax,%edi
  803f21:	48 b8 86 3c 80 00 00 	movabs $0x803c86,%rax
  803f28:	00 00 00 
  803f2b:	ff d0                	callq  *%rax
  803f2d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f30:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f34:	79 05                	jns    803f3b <listen+0x2d>
		return r;
  803f36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f39:	eb 16                	jmp    803f51 <listen+0x43>
	return nsipc_listen(r, backlog);
  803f3b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803f3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f41:	89 d6                	mov    %edx,%esi
  803f43:	89 c7                	mov    %eax,%edi
  803f45:	48 b8 7d 42 80 00 00 	movabs $0x80427d,%rax
  803f4c:	00 00 00 
  803f4f:	ff d0                	callq  *%rax
}
  803f51:	c9                   	leaveq 
  803f52:	c3                   	retq   

0000000000803f53 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803f53:	55                   	push   %rbp
  803f54:	48 89 e5             	mov    %rsp,%rbp
  803f57:	48 83 ec 20          	sub    $0x20,%rsp
  803f5b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803f5f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803f63:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803f67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f6b:	89 c2                	mov    %eax,%edx
  803f6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f71:	8b 40 0c             	mov    0xc(%rax),%eax
  803f74:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803f78:	b9 00 00 00 00       	mov    $0x0,%ecx
  803f7d:	89 c7                	mov    %eax,%edi
  803f7f:	48 b8 bd 42 80 00 00 	movabs $0x8042bd,%rax
  803f86:	00 00 00 
  803f89:	ff d0                	callq  *%rax
}
  803f8b:	c9                   	leaveq 
  803f8c:	c3                   	retq   

0000000000803f8d <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803f8d:	55                   	push   %rbp
  803f8e:	48 89 e5             	mov    %rsp,%rbp
  803f91:	48 83 ec 20          	sub    $0x20,%rsp
  803f95:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803f99:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803f9d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803fa1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fa5:	89 c2                	mov    %eax,%edx
  803fa7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fab:	8b 40 0c             	mov    0xc(%rax),%eax
  803fae:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803fb2:	b9 00 00 00 00       	mov    $0x0,%ecx
  803fb7:	89 c7                	mov    %eax,%edi
  803fb9:	48 b8 89 43 80 00 00 	movabs $0x804389,%rax
  803fc0:	00 00 00 
  803fc3:	ff d0                	callq  *%rax
}
  803fc5:	c9                   	leaveq 
  803fc6:	c3                   	retq   

0000000000803fc7 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803fc7:	55                   	push   %rbp
  803fc8:	48 89 e5             	mov    %rsp,%rbp
  803fcb:	48 83 ec 10          	sub    $0x10,%rsp
  803fcf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803fd3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803fd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fdb:	48 be e5 56 80 00 00 	movabs $0x8056e5,%rsi
  803fe2:	00 00 00 
  803fe5:	48 89 c7             	mov    %rax,%rdi
  803fe8:	48 b8 8c 16 80 00 00 	movabs $0x80168c,%rax
  803fef:	00 00 00 
  803ff2:	ff d0                	callq  *%rax
	return 0;
  803ff4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ff9:	c9                   	leaveq 
  803ffa:	c3                   	retq   

0000000000803ffb <socket>:

int
socket(int domain, int type, int protocol)
{
  803ffb:	55                   	push   %rbp
  803ffc:	48 89 e5             	mov    %rsp,%rbp
  803fff:	48 83 ec 20          	sub    $0x20,%rsp
  804003:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804006:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804009:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80400c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80400f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804012:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804015:	89 ce                	mov    %ecx,%esi
  804017:	89 c7                	mov    %eax,%edi
  804019:	48 b8 41 44 80 00 00 	movabs $0x804441,%rax
  804020:	00 00 00 
  804023:	ff d0                	callq  *%rax
  804025:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804028:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80402c:	79 05                	jns    804033 <socket+0x38>
		return r;
  80402e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804031:	eb 11                	jmp    804044 <socket+0x49>
	return alloc_sockfd(r);
  804033:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804036:	89 c7                	mov    %eax,%edi
  804038:	48 b8 dd 3c 80 00 00 	movabs $0x803cdd,%rax
  80403f:	00 00 00 
  804042:	ff d0                	callq  *%rax
}
  804044:	c9                   	leaveq 
  804045:	c3                   	retq   

0000000000804046 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  804046:	55                   	push   %rbp
  804047:	48 89 e5             	mov    %rsp,%rbp
  80404a:	48 83 ec 10          	sub    $0x10,%rsp
  80404e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  804051:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  804058:	00 00 00 
  80405b:	8b 00                	mov    (%rax),%eax
  80405d:	85 c0                	test   %eax,%eax
  80405f:	75 1f                	jne    804080 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  804061:	bf 02 00 00 00       	mov    $0x2,%edi
  804066:	48 b8 bb 4c 80 00 00 	movabs $0x804cbb,%rax
  80406d:	00 00 00 
  804070:	ff d0                	callq  *%rax
  804072:	89 c2                	mov    %eax,%edx
  804074:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  80407b:	00 00 00 
  80407e:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  804080:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  804087:	00 00 00 
  80408a:	8b 00                	mov    (%rax),%eax
  80408c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80408f:	b9 07 00 00 00       	mov    $0x7,%ecx
  804094:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  80409b:	00 00 00 
  80409e:	89 c7                	mov    %eax,%edi
  8040a0:	48 b8 2e 4b 80 00 00 	movabs $0x804b2e,%rax
  8040a7:	00 00 00 
  8040aa:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8040ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8040b1:	be 00 00 00 00       	mov    $0x0,%esi
  8040b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8040bb:	48 b8 f0 4a 80 00 00 	movabs $0x804af0,%rax
  8040c2:	00 00 00 
  8040c5:	ff d0                	callq  *%rax
}
  8040c7:	c9                   	leaveq 
  8040c8:	c3                   	retq   

00000000008040c9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8040c9:	55                   	push   %rbp
  8040ca:	48 89 e5             	mov    %rsp,%rbp
  8040cd:	48 83 ec 30          	sub    $0x30,%rsp
  8040d1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8040d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8040d8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8040dc:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040e3:	00 00 00 
  8040e6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8040e9:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8040eb:	bf 01 00 00 00       	mov    $0x1,%edi
  8040f0:	48 b8 46 40 80 00 00 	movabs $0x804046,%rax
  8040f7:	00 00 00 
  8040fa:	ff d0                	callq  *%rax
  8040fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804103:	78 3e                	js     804143 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  804105:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80410c:	00 00 00 
  80410f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  804113:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804117:	8b 40 10             	mov    0x10(%rax),%eax
  80411a:	89 c2                	mov    %eax,%edx
  80411c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  804120:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804124:	48 89 ce             	mov    %rcx,%rsi
  804127:	48 89 c7             	mov    %rax,%rdi
  80412a:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  804131:	00 00 00 
  804134:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  804136:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80413a:	8b 50 10             	mov    0x10(%rax),%edx
  80413d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804141:	89 10                	mov    %edx,(%rax)
	}
	return r;
  804143:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804146:	c9                   	leaveq 
  804147:	c3                   	retq   

0000000000804148 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  804148:	55                   	push   %rbp
  804149:	48 89 e5             	mov    %rsp,%rbp
  80414c:	48 83 ec 10          	sub    $0x10,%rsp
  804150:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804153:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804157:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80415a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804161:	00 00 00 
  804164:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804167:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  804169:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80416c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804170:	48 89 c6             	mov    %rax,%rsi
  804173:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  80417a:	00 00 00 
  80417d:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  804184:	00 00 00 
  804187:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  804189:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804190:	00 00 00 
  804193:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804196:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  804199:	bf 02 00 00 00       	mov    $0x2,%edi
  80419e:	48 b8 46 40 80 00 00 	movabs $0x804046,%rax
  8041a5:	00 00 00 
  8041a8:	ff d0                	callq  *%rax
}
  8041aa:	c9                   	leaveq 
  8041ab:	c3                   	retq   

00000000008041ac <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8041ac:	55                   	push   %rbp
  8041ad:	48 89 e5             	mov    %rsp,%rbp
  8041b0:	48 83 ec 10          	sub    $0x10,%rsp
  8041b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8041b7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8041ba:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8041c1:	00 00 00 
  8041c4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8041c7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8041c9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8041d0:	00 00 00 
  8041d3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8041d6:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8041d9:	bf 03 00 00 00       	mov    $0x3,%edi
  8041de:	48 b8 46 40 80 00 00 	movabs $0x804046,%rax
  8041e5:	00 00 00 
  8041e8:	ff d0                	callq  *%rax
}
  8041ea:	c9                   	leaveq 
  8041eb:	c3                   	retq   

00000000008041ec <nsipc_close>:

int
nsipc_close(int s)
{
  8041ec:	55                   	push   %rbp
  8041ed:	48 89 e5             	mov    %rsp,%rbp
  8041f0:	48 83 ec 10          	sub    $0x10,%rsp
  8041f4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8041f7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8041fe:	00 00 00 
  804201:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804204:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  804206:	bf 04 00 00 00       	mov    $0x4,%edi
  80420b:	48 b8 46 40 80 00 00 	movabs $0x804046,%rax
  804212:	00 00 00 
  804215:	ff d0                	callq  *%rax
}
  804217:	c9                   	leaveq 
  804218:	c3                   	retq   

0000000000804219 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804219:	55                   	push   %rbp
  80421a:	48 89 e5             	mov    %rsp,%rbp
  80421d:	48 83 ec 10          	sub    $0x10,%rsp
  804221:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804224:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804228:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80422b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804232:	00 00 00 
  804235:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804238:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80423a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80423d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804241:	48 89 c6             	mov    %rax,%rsi
  804244:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  80424b:	00 00 00 
  80424e:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  804255:	00 00 00 
  804258:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80425a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804261:	00 00 00 
  804264:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804267:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80426a:	bf 05 00 00 00       	mov    $0x5,%edi
  80426f:	48 b8 46 40 80 00 00 	movabs $0x804046,%rax
  804276:	00 00 00 
  804279:	ff d0                	callq  *%rax
}
  80427b:	c9                   	leaveq 
  80427c:	c3                   	retq   

000000000080427d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80427d:	55                   	push   %rbp
  80427e:	48 89 e5             	mov    %rsp,%rbp
  804281:	48 83 ec 10          	sub    $0x10,%rsp
  804285:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804288:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80428b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804292:	00 00 00 
  804295:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804298:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80429a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042a1:	00 00 00 
  8042a4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8042a7:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8042aa:	bf 06 00 00 00       	mov    $0x6,%edi
  8042af:	48 b8 46 40 80 00 00 	movabs $0x804046,%rax
  8042b6:	00 00 00 
  8042b9:	ff d0                	callq  *%rax
}
  8042bb:	c9                   	leaveq 
  8042bc:	c3                   	retq   

00000000008042bd <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8042bd:	55                   	push   %rbp
  8042be:	48 89 e5             	mov    %rsp,%rbp
  8042c1:	48 83 ec 30          	sub    $0x30,%rsp
  8042c5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8042c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8042cc:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8042cf:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8042d2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042d9:	00 00 00 
  8042dc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8042df:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8042e1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042e8:	00 00 00 
  8042eb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8042ee:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8042f1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042f8:	00 00 00 
  8042fb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8042fe:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804301:	bf 07 00 00 00       	mov    $0x7,%edi
  804306:	48 b8 46 40 80 00 00 	movabs $0x804046,%rax
  80430d:	00 00 00 
  804310:	ff d0                	callq  *%rax
  804312:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804315:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804319:	78 69                	js     804384 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80431b:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  804322:	7f 08                	jg     80432c <nsipc_recv+0x6f>
  804324:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804327:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80432a:	7e 35                	jle    804361 <nsipc_recv+0xa4>
  80432c:	48 b9 ec 56 80 00 00 	movabs $0x8056ec,%rcx
  804333:	00 00 00 
  804336:	48 ba 01 57 80 00 00 	movabs $0x805701,%rdx
  80433d:	00 00 00 
  804340:	be 61 00 00 00       	mov    $0x61,%esi
  804345:	48 bf 16 57 80 00 00 	movabs $0x805716,%rdi
  80434c:	00 00 00 
  80434f:	b8 00 00 00 00       	mov    $0x0,%eax
  804354:	49 b8 b9 08 80 00 00 	movabs $0x8008b9,%r8
  80435b:	00 00 00 
  80435e:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804361:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804364:	48 63 d0             	movslq %eax,%rdx
  804367:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80436b:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  804372:	00 00 00 
  804375:	48 89 c7             	mov    %rax,%rdi
  804378:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  80437f:	00 00 00 
  804382:	ff d0                	callq  *%rax
	}

	return r;
  804384:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804387:	c9                   	leaveq 
  804388:	c3                   	retq   

0000000000804389 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  804389:	55                   	push   %rbp
  80438a:	48 89 e5             	mov    %rsp,%rbp
  80438d:	48 83 ec 20          	sub    $0x20,%rsp
  804391:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804394:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804398:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80439b:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80439e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043a5:	00 00 00 
  8043a8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8043ab:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8043ad:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8043b4:	7e 35                	jle    8043eb <nsipc_send+0x62>
  8043b6:	48 b9 22 57 80 00 00 	movabs $0x805722,%rcx
  8043bd:	00 00 00 
  8043c0:	48 ba 01 57 80 00 00 	movabs $0x805701,%rdx
  8043c7:	00 00 00 
  8043ca:	be 6c 00 00 00       	mov    $0x6c,%esi
  8043cf:	48 bf 16 57 80 00 00 	movabs $0x805716,%rdi
  8043d6:	00 00 00 
  8043d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8043de:	49 b8 b9 08 80 00 00 	movabs $0x8008b9,%r8
  8043e5:	00 00 00 
  8043e8:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8043eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8043ee:	48 63 d0             	movslq %eax,%rdx
  8043f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043f5:	48 89 c6             	mov    %rax,%rsi
  8043f8:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  8043ff:	00 00 00 
  804402:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  804409:	00 00 00 
  80440c:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80440e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804415:	00 00 00 
  804418:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80441b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80441e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804425:	00 00 00 
  804428:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80442b:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80442e:	bf 08 00 00 00       	mov    $0x8,%edi
  804433:	48 b8 46 40 80 00 00 	movabs $0x804046,%rax
  80443a:	00 00 00 
  80443d:	ff d0                	callq  *%rax
}
  80443f:	c9                   	leaveq 
  804440:	c3                   	retq   

0000000000804441 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  804441:	55                   	push   %rbp
  804442:	48 89 e5             	mov    %rsp,%rbp
  804445:	48 83 ec 10          	sub    $0x10,%rsp
  804449:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80444c:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80444f:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  804452:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804459:	00 00 00 
  80445c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80445f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  804461:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804468:	00 00 00 
  80446b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80446e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  804471:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804478:	00 00 00 
  80447b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80447e:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804481:	bf 09 00 00 00       	mov    $0x9,%edi
  804486:	48 b8 46 40 80 00 00 	movabs $0x804046,%rax
  80448d:	00 00 00 
  804490:	ff d0                	callq  *%rax
}
  804492:	c9                   	leaveq 
  804493:	c3                   	retq   

0000000000804494 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804494:	55                   	push   %rbp
  804495:	48 89 e5             	mov    %rsp,%rbp
  804498:	53                   	push   %rbx
  804499:	48 83 ec 38          	sub    $0x38,%rsp
  80449d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8044a1:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8044a5:	48 89 c7             	mov    %rax,%rdi
  8044a8:	48 b8 4f 24 80 00 00 	movabs $0x80244f,%rax
  8044af:	00 00 00 
  8044b2:	ff d0                	callq  *%rax
  8044b4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8044b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8044bb:	0f 88 bf 01 00 00    	js     804680 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8044c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044c5:	ba 07 04 00 00       	mov    $0x407,%edx
  8044ca:	48 89 c6             	mov    %rax,%rsi
  8044cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8044d2:	48 b8 b9 1f 80 00 00 	movabs $0x801fb9,%rax
  8044d9:	00 00 00 
  8044dc:	ff d0                	callq  *%rax
  8044de:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8044e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8044e5:	0f 88 95 01 00 00    	js     804680 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8044eb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8044ef:	48 89 c7             	mov    %rax,%rdi
  8044f2:	48 b8 4f 24 80 00 00 	movabs $0x80244f,%rax
  8044f9:	00 00 00 
  8044fc:	ff d0                	callq  *%rax
  8044fe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804501:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804505:	0f 88 5d 01 00 00    	js     804668 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80450b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80450f:	ba 07 04 00 00       	mov    $0x407,%edx
  804514:	48 89 c6             	mov    %rax,%rsi
  804517:	bf 00 00 00 00       	mov    $0x0,%edi
  80451c:	48 b8 b9 1f 80 00 00 	movabs $0x801fb9,%rax
  804523:	00 00 00 
  804526:	ff d0                	callq  *%rax
  804528:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80452b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80452f:	0f 88 33 01 00 00    	js     804668 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804535:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804539:	48 89 c7             	mov    %rax,%rdi
  80453c:	48 b8 24 24 80 00 00 	movabs $0x802424,%rax
  804543:	00 00 00 
  804546:	ff d0                	callq  *%rax
  804548:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80454c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804550:	ba 07 04 00 00       	mov    $0x407,%edx
  804555:	48 89 c6             	mov    %rax,%rsi
  804558:	bf 00 00 00 00       	mov    $0x0,%edi
  80455d:	48 b8 b9 1f 80 00 00 	movabs $0x801fb9,%rax
  804564:	00 00 00 
  804567:	ff d0                	callq  *%rax
  804569:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80456c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804570:	79 05                	jns    804577 <pipe+0xe3>
		goto err2;
  804572:	e9 d9 00 00 00       	jmpq   804650 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804577:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80457b:	48 89 c7             	mov    %rax,%rdi
  80457e:	48 b8 24 24 80 00 00 	movabs $0x802424,%rax
  804585:	00 00 00 
  804588:	ff d0                	callq  *%rax
  80458a:	48 89 c2             	mov    %rax,%rdx
  80458d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804591:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804597:	48 89 d1             	mov    %rdx,%rcx
  80459a:	ba 00 00 00 00       	mov    $0x0,%edx
  80459f:	48 89 c6             	mov    %rax,%rsi
  8045a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8045a7:	48 b8 0b 20 80 00 00 	movabs $0x80200b,%rax
  8045ae:	00 00 00 
  8045b1:	ff d0                	callq  *%rax
  8045b3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8045b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8045ba:	79 1b                	jns    8045d7 <pipe+0x143>
		goto err3;
  8045bc:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8045bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8045c1:	48 89 c6             	mov    %rax,%rsi
  8045c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8045c9:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  8045d0:	00 00 00 
  8045d3:	ff d0                	callq  *%rax
  8045d5:	eb 79                	jmp    804650 <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  8045d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045db:	48 ba 00 71 80 00 00 	movabs $0x807100,%rdx
  8045e2:	00 00 00 
  8045e5:	8b 12                	mov    (%rdx),%edx
  8045e7:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8045e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045ed:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  8045f4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8045f8:	48 ba 00 71 80 00 00 	movabs $0x807100,%rdx
  8045ff:	00 00 00 
  804602:	8b 12                	mov    (%rdx),%edx
  804604:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804606:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80460a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  804611:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804615:	48 89 c7             	mov    %rax,%rdi
  804618:	48 b8 01 24 80 00 00 	movabs $0x802401,%rax
  80461f:	00 00 00 
  804622:	ff d0                	callq  *%rax
  804624:	89 c2                	mov    %eax,%edx
  804626:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80462a:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80462c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804630:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804634:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804638:	48 89 c7             	mov    %rax,%rdi
  80463b:	48 b8 01 24 80 00 00 	movabs $0x802401,%rax
  804642:	00 00 00 
  804645:	ff d0                	callq  *%rax
  804647:	89 03                	mov    %eax,(%rbx)
	return 0;
  804649:	b8 00 00 00 00       	mov    $0x0,%eax
  80464e:	eb 33                	jmp    804683 <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  804650:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804654:	48 89 c6             	mov    %rax,%rsi
  804657:	bf 00 00 00 00       	mov    $0x0,%edi
  80465c:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  804663:	00 00 00 
  804666:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804668:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80466c:	48 89 c6             	mov    %rax,%rsi
  80466f:	bf 00 00 00 00       	mov    $0x0,%edi
  804674:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  80467b:	00 00 00 
  80467e:	ff d0                	callq  *%rax
err:
	return r;
  804680:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804683:	48 83 c4 38          	add    $0x38,%rsp
  804687:	5b                   	pop    %rbx
  804688:	5d                   	pop    %rbp
  804689:	c3                   	retq   

000000000080468a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80468a:	55                   	push   %rbp
  80468b:	48 89 e5             	mov    %rsp,%rbp
  80468e:	53                   	push   %rbx
  80468f:	48 83 ec 28          	sub    $0x28,%rsp
  804693:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804697:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80469b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8046a2:	00 00 00 
  8046a5:	48 8b 00             	mov    (%rax),%rax
  8046a8:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8046ae:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8046b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046b5:	48 89 c7             	mov    %rax,%rdi
  8046b8:	48 b8 2d 4d 80 00 00 	movabs $0x804d2d,%rax
  8046bf:	00 00 00 
  8046c2:	ff d0                	callq  *%rax
  8046c4:	89 c3                	mov    %eax,%ebx
  8046c6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8046ca:	48 89 c7             	mov    %rax,%rdi
  8046cd:	48 b8 2d 4d 80 00 00 	movabs $0x804d2d,%rax
  8046d4:	00 00 00 
  8046d7:	ff d0                	callq  *%rax
  8046d9:	39 c3                	cmp    %eax,%ebx
  8046db:	0f 94 c0             	sete   %al
  8046de:	0f b6 c0             	movzbl %al,%eax
  8046e1:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8046e4:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8046eb:	00 00 00 
  8046ee:	48 8b 00             	mov    (%rax),%rax
  8046f1:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8046f7:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8046fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8046fd:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804700:	75 05                	jne    804707 <_pipeisclosed+0x7d>
			return ret;
  804702:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804705:	eb 4a                	jmp    804751 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  804707:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80470a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80470d:	74 3d                	je     80474c <_pipeisclosed+0xc2>
  80470f:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804713:	75 37                	jne    80474c <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804715:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80471c:	00 00 00 
  80471f:	48 8b 00             	mov    (%rax),%rax
  804722:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804728:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80472b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80472e:	89 c6                	mov    %eax,%esi
  804730:	48 bf 33 57 80 00 00 	movabs $0x805733,%rdi
  804737:	00 00 00 
  80473a:	b8 00 00 00 00       	mov    $0x0,%eax
  80473f:	49 b8 f2 0a 80 00 00 	movabs $0x800af2,%r8
  804746:	00 00 00 
  804749:	41 ff d0             	callq  *%r8
	}
  80474c:	e9 4a ff ff ff       	jmpq   80469b <_pipeisclosed+0x11>
}
  804751:	48 83 c4 28          	add    $0x28,%rsp
  804755:	5b                   	pop    %rbx
  804756:	5d                   	pop    %rbp
  804757:	c3                   	retq   

0000000000804758 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804758:	55                   	push   %rbp
  804759:	48 89 e5             	mov    %rsp,%rbp
  80475c:	48 83 ec 30          	sub    $0x30,%rsp
  804760:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804763:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804767:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80476a:	48 89 d6             	mov    %rdx,%rsi
  80476d:	89 c7                	mov    %eax,%edi
  80476f:	48 b8 e7 24 80 00 00 	movabs $0x8024e7,%rax
  804776:	00 00 00 
  804779:	ff d0                	callq  *%rax
  80477b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80477e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804782:	79 05                	jns    804789 <pipeisclosed+0x31>
		return r;
  804784:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804787:	eb 31                	jmp    8047ba <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804789:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80478d:	48 89 c7             	mov    %rax,%rdi
  804790:	48 b8 24 24 80 00 00 	movabs $0x802424,%rax
  804797:	00 00 00 
  80479a:	ff d0                	callq  *%rax
  80479c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8047a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8047a8:	48 89 d6             	mov    %rdx,%rsi
  8047ab:	48 89 c7             	mov    %rax,%rdi
  8047ae:	48 b8 8a 46 80 00 00 	movabs $0x80468a,%rax
  8047b5:	00 00 00 
  8047b8:	ff d0                	callq  *%rax
}
  8047ba:	c9                   	leaveq 
  8047bb:	c3                   	retq   

00000000008047bc <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8047bc:	55                   	push   %rbp
  8047bd:	48 89 e5             	mov    %rsp,%rbp
  8047c0:	48 83 ec 40          	sub    $0x40,%rsp
  8047c4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8047c8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8047cc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8047d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047d4:	48 89 c7             	mov    %rax,%rdi
  8047d7:	48 b8 24 24 80 00 00 	movabs $0x802424,%rax
  8047de:	00 00 00 
  8047e1:	ff d0                	callq  *%rax
  8047e3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8047e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8047eb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8047ef:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8047f6:	00 
  8047f7:	e9 92 00 00 00       	jmpq   80488e <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8047fc:	eb 41                	jmp    80483f <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8047fe:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804803:	74 09                	je     80480e <devpipe_read+0x52>
				return i;
  804805:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804809:	e9 92 00 00 00       	jmpq   8048a0 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80480e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804812:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804816:	48 89 d6             	mov    %rdx,%rsi
  804819:	48 89 c7             	mov    %rax,%rdi
  80481c:	48 b8 8a 46 80 00 00 	movabs $0x80468a,%rax
  804823:	00 00 00 
  804826:	ff d0                	callq  *%rax
  804828:	85 c0                	test   %eax,%eax
  80482a:	74 07                	je     804833 <devpipe_read+0x77>
				return 0;
  80482c:	b8 00 00 00 00       	mov    $0x0,%eax
  804831:	eb 6d                	jmp    8048a0 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804833:	48 b8 7d 1f 80 00 00 	movabs $0x801f7d,%rax
  80483a:	00 00 00 
  80483d:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  80483f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804843:	8b 10                	mov    (%rax),%edx
  804845:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804849:	8b 40 04             	mov    0x4(%rax),%eax
  80484c:	39 c2                	cmp    %eax,%edx
  80484e:	74 ae                	je     8047fe <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804850:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804854:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804858:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80485c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804860:	8b 00                	mov    (%rax),%eax
  804862:	99                   	cltd   
  804863:	c1 ea 1b             	shr    $0x1b,%edx
  804866:	01 d0                	add    %edx,%eax
  804868:	83 e0 1f             	and    $0x1f,%eax
  80486b:	29 d0                	sub    %edx,%eax
  80486d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804871:	48 98                	cltq   
  804873:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804878:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80487a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80487e:	8b 00                	mov    (%rax),%eax
  804880:	8d 50 01             	lea    0x1(%rax),%edx
  804883:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804887:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  804889:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80488e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804892:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804896:	0f 82 60 ff ff ff    	jb     8047fc <devpipe_read+0x40>
	}
	return i;
  80489c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8048a0:	c9                   	leaveq 
  8048a1:	c3                   	retq   

00000000008048a2 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8048a2:	55                   	push   %rbp
  8048a3:	48 89 e5             	mov    %rsp,%rbp
  8048a6:	48 83 ec 40          	sub    $0x40,%rsp
  8048aa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8048ae:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8048b2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8048b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048ba:	48 89 c7             	mov    %rax,%rdi
  8048bd:	48 b8 24 24 80 00 00 	movabs $0x802424,%rax
  8048c4:	00 00 00 
  8048c7:	ff d0                	callq  *%rax
  8048c9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8048cd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8048d1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8048d5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8048dc:	00 
  8048dd:	e9 91 00 00 00       	jmpq   804973 <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8048e2:	eb 31                	jmp    804915 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8048e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8048e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048ec:	48 89 d6             	mov    %rdx,%rsi
  8048ef:	48 89 c7             	mov    %rax,%rdi
  8048f2:	48 b8 8a 46 80 00 00 	movabs $0x80468a,%rax
  8048f9:	00 00 00 
  8048fc:	ff d0                	callq  *%rax
  8048fe:	85 c0                	test   %eax,%eax
  804900:	74 07                	je     804909 <devpipe_write+0x67>
				return 0;
  804902:	b8 00 00 00 00       	mov    $0x0,%eax
  804907:	eb 7c                	jmp    804985 <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804909:	48 b8 7d 1f 80 00 00 	movabs $0x801f7d,%rax
  804910:	00 00 00 
  804913:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804915:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804919:	8b 40 04             	mov    0x4(%rax),%eax
  80491c:	48 63 d0             	movslq %eax,%rdx
  80491f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804923:	8b 00                	mov    (%rax),%eax
  804925:	48 98                	cltq   
  804927:	48 83 c0 20          	add    $0x20,%rax
  80492b:	48 39 c2             	cmp    %rax,%rdx
  80492e:	73 b4                	jae    8048e4 <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804930:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804934:	8b 40 04             	mov    0x4(%rax),%eax
  804937:	99                   	cltd   
  804938:	c1 ea 1b             	shr    $0x1b,%edx
  80493b:	01 d0                	add    %edx,%eax
  80493d:	83 e0 1f             	and    $0x1f,%eax
  804940:	29 d0                	sub    %edx,%eax
  804942:	89 c6                	mov    %eax,%esi
  804944:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804948:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80494c:	48 01 d0             	add    %rdx,%rax
  80494f:	0f b6 08             	movzbl (%rax),%ecx
  804952:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804956:	48 63 c6             	movslq %esi,%rax
  804959:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80495d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804961:	8b 40 04             	mov    0x4(%rax),%eax
  804964:	8d 50 01             	lea    0x1(%rax),%edx
  804967:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80496b:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  80496e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804973:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804977:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80497b:	0f 82 61 ff ff ff    	jb     8048e2 <devpipe_write+0x40>
	}

	return i;
  804981:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804985:	c9                   	leaveq 
  804986:	c3                   	retq   

0000000000804987 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804987:	55                   	push   %rbp
  804988:	48 89 e5             	mov    %rsp,%rbp
  80498b:	48 83 ec 20          	sub    $0x20,%rsp
  80498f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804993:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804997:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80499b:	48 89 c7             	mov    %rax,%rdi
  80499e:	48 b8 24 24 80 00 00 	movabs $0x802424,%rax
  8049a5:	00 00 00 
  8049a8:	ff d0                	callq  *%rax
  8049aa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8049ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8049b2:	48 be 46 57 80 00 00 	movabs $0x805746,%rsi
  8049b9:	00 00 00 
  8049bc:	48 89 c7             	mov    %rax,%rdi
  8049bf:	48 b8 8c 16 80 00 00 	movabs $0x80168c,%rax
  8049c6:	00 00 00 
  8049c9:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8049cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049cf:	8b 50 04             	mov    0x4(%rax),%edx
  8049d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049d6:	8b 00                	mov    (%rax),%eax
  8049d8:	29 c2                	sub    %eax,%edx
  8049da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8049de:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8049e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8049e8:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8049ef:	00 00 00 
	stat->st_dev = &devpipe;
  8049f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8049f6:	48 b9 00 71 80 00 00 	movabs $0x807100,%rcx
  8049fd:	00 00 00 
  804a00:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804a07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804a0c:	c9                   	leaveq 
  804a0d:	c3                   	retq   

0000000000804a0e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804a0e:	55                   	push   %rbp
  804a0f:	48 89 e5             	mov    %rsp,%rbp
  804a12:	48 83 ec 10          	sub    $0x10,%rsp
  804a16:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804a1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a1e:	48 89 c6             	mov    %rax,%rsi
  804a21:	bf 00 00 00 00       	mov    $0x0,%edi
  804a26:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  804a2d:	00 00 00 
  804a30:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804a32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a36:	48 89 c7             	mov    %rax,%rdi
  804a39:	48 b8 24 24 80 00 00 	movabs $0x802424,%rax
  804a40:	00 00 00 
  804a43:	ff d0                	callq  *%rax
  804a45:	48 89 c6             	mov    %rax,%rsi
  804a48:	bf 00 00 00 00       	mov    $0x0,%edi
  804a4d:	48 b8 6b 20 80 00 00 	movabs $0x80206b,%rax
  804a54:	00 00 00 
  804a57:	ff d0                	callq  *%rax
}
  804a59:	c9                   	leaveq 
  804a5a:	c3                   	retq   

0000000000804a5b <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  804a5b:	55                   	push   %rbp
  804a5c:	48 89 e5             	mov    %rsp,%rbp
  804a5f:	48 83 ec 20          	sub    $0x20,%rsp
  804a63:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  804a66:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804a6a:	75 35                	jne    804aa1 <wait+0x46>
  804a6c:	48 b9 4d 57 80 00 00 	movabs $0x80574d,%rcx
  804a73:	00 00 00 
  804a76:	48 ba 58 57 80 00 00 	movabs $0x805758,%rdx
  804a7d:	00 00 00 
  804a80:	be 09 00 00 00       	mov    $0x9,%esi
  804a85:	48 bf 6d 57 80 00 00 	movabs $0x80576d,%rdi
  804a8c:	00 00 00 
  804a8f:	b8 00 00 00 00       	mov    $0x0,%eax
  804a94:	49 b8 b9 08 80 00 00 	movabs $0x8008b9,%r8
  804a9b:	00 00 00 
  804a9e:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804aa1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804aa4:	25 ff 03 00 00       	and    $0x3ff,%eax
  804aa9:	48 98                	cltq   
  804aab:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  804ab2:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804ab9:	00 00 00 
  804abc:	48 01 d0             	add    %rdx,%rax
  804abf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804ac3:	eb 0c                	jmp    804ad1 <wait+0x76>
		sys_yield();
  804ac5:	48 b8 7d 1f 80 00 00 	movabs $0x801f7d,%rax
  804acc:	00 00 00 
  804acf:	ff d0                	callq  *%rax
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804ad1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ad5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804adb:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804ade:	75 0e                	jne    804aee <wait+0x93>
  804ae0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ae4:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804aea:	85 c0                	test   %eax,%eax
  804aec:	75 d7                	jne    804ac5 <wait+0x6a>
}
  804aee:	c9                   	leaveq 
  804aef:	c3                   	retq   

0000000000804af0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804af0:	55                   	push   %rbp
  804af1:	48 89 e5             	mov    %rsp,%rbp
  804af4:	48 83 ec 20          	sub    $0x20,%rsp
  804af8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804afc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804b00:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  804b04:	48 ba 78 57 80 00 00 	movabs $0x805778,%rdx
  804b0b:	00 00 00 
  804b0e:	be 1d 00 00 00       	mov    $0x1d,%esi
  804b13:	48 bf 91 57 80 00 00 	movabs $0x805791,%rdi
  804b1a:	00 00 00 
  804b1d:	b8 00 00 00 00       	mov    $0x0,%eax
  804b22:	48 b9 b9 08 80 00 00 	movabs $0x8008b9,%rcx
  804b29:	00 00 00 
  804b2c:	ff d1                	callq  *%rcx

0000000000804b2e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804b2e:	55                   	push   %rbp
  804b2f:	48 89 e5             	mov    %rsp,%rbp
  804b32:	48 83 ec 20          	sub    $0x20,%rsp
  804b36:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804b39:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804b3c:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  804b40:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  804b43:	48 ba 9b 57 80 00 00 	movabs $0x80579b,%rdx
  804b4a:	00 00 00 
  804b4d:	be 2d 00 00 00       	mov    $0x2d,%esi
  804b52:	48 bf 91 57 80 00 00 	movabs $0x805791,%rdi
  804b59:	00 00 00 
  804b5c:	b8 00 00 00 00       	mov    $0x0,%eax
  804b61:	48 b9 b9 08 80 00 00 	movabs $0x8008b9,%rcx
  804b68:	00 00 00 
  804b6b:	ff d1                	callq  *%rcx

0000000000804b6d <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  804b6d:	55                   	push   %rbp
  804b6e:	48 89 e5             	mov    %rsp,%rbp
  804b71:	53                   	push   %rbx
  804b72:	48 83 ec 48          	sub    $0x48,%rsp
  804b76:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  804b7a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  804b81:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  804b88:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  804b8d:	75 0e                	jne    804b9d <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  804b8f:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  804b96:	00 00 00 
  804b99:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  804b9d:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804ba1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  804ba5:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  804bac:	00 
	a3 = (uint64_t) 0;
  804bad:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  804bb4:	00 
	a4 = (uint64_t) 0;
  804bb5:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  804bbc:	00 
	a5 = 0;
  804bbd:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  804bc4:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  804bc5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804bc8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804bcc:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  804bd0:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  804bd4:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  804bd8:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  804bdc:	4c 89 c3             	mov    %r8,%rbx
  804bdf:	0f 01 c1             	vmcall 
  804be2:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  804be5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804be9:	7e 36                	jle    804c21 <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  804beb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804bee:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804bf1:	41 89 d0             	mov    %edx,%r8d
  804bf4:	89 c1                	mov    %eax,%ecx
  804bf6:	48 ba b8 57 80 00 00 	movabs $0x8057b8,%rdx
  804bfd:	00 00 00 
  804c00:	be 54 00 00 00       	mov    $0x54,%esi
  804c05:	48 bf 91 57 80 00 00 	movabs $0x805791,%rdi
  804c0c:	00 00 00 
  804c0f:	b8 00 00 00 00       	mov    $0x0,%eax
  804c14:	49 b9 b9 08 80 00 00 	movabs $0x8008b9,%r9
  804c1b:	00 00 00 
  804c1e:	41 ff d1             	callq  *%r9
	return ret;
  804c21:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804c24:	48 83 c4 48          	add    $0x48,%rsp
  804c28:	5b                   	pop    %rbx
  804c29:	5d                   	pop    %rbp
  804c2a:	c3                   	retq   

0000000000804c2b <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804c2b:	55                   	push   %rbp
  804c2c:	48 89 e5             	mov    %rsp,%rbp
  804c2f:	53                   	push   %rbx
  804c30:	48 83 ec 58          	sub    $0x58,%rsp
  804c34:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  804c37:	89 75 b0             	mov    %esi,-0x50(%rbp)
  804c3a:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  804c3e:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  804c41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  804c48:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  804c4f:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  804c54:	75 0e                	jne    804c64 <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  804c56:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  804c5d:	00 00 00 
  804c60:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  804c64:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  804c67:	48 98                	cltq   
  804c69:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  804c6d:	8b 45 b0             	mov    -0x50(%rbp),%eax
  804c70:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  804c74:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804c78:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  804c7c:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  804c7f:	48 98                	cltq   
  804c81:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  804c85:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  804c8c:	00 

	int r = -E_IPC_NOT_RECV;
  804c8d:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  804c94:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804c97:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804c9b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  804c9f:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  804ca3:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  804ca7:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  804cab:	4c 89 c3             	mov    %r8,%rbx
  804cae:	0f 01 c1             	vmcall 
  804cb1:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  804cb4:	48 83 c4 58          	add    $0x58,%rsp
  804cb8:	5b                   	pop    %rbx
  804cb9:	5d                   	pop    %rbp
  804cba:	c3                   	retq   

0000000000804cbb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804cbb:	55                   	push   %rbp
  804cbc:	48 89 e5             	mov    %rsp,%rbp
  804cbf:	48 83 ec 18          	sub    $0x18,%rsp
  804cc3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804cc6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804ccd:	eb 4e                	jmp    804d1d <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  804ccf:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804cd6:	00 00 00 
  804cd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804cdc:	48 98                	cltq   
  804cde:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804ce5:	48 01 d0             	add    %rdx,%rax
  804ce8:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804cee:	8b 00                	mov    (%rax),%eax
  804cf0:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804cf3:	75 24                	jne    804d19 <ipc_find_env+0x5e>
			return envs[i].env_id;
  804cf5:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804cfc:	00 00 00 
  804cff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d02:	48 98                	cltq   
  804d04:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804d0b:	48 01 d0             	add    %rdx,%rax
  804d0e:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804d14:	8b 40 08             	mov    0x8(%rax),%eax
  804d17:	eb 12                	jmp    804d2b <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  804d19:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804d1d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804d24:	7e a9                	jle    804ccf <ipc_find_env+0x14>
	}
	return 0;
  804d26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804d2b:	c9                   	leaveq 
  804d2c:	c3                   	retq   

0000000000804d2d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804d2d:	55                   	push   %rbp
  804d2e:	48 89 e5             	mov    %rsp,%rbp
  804d31:	48 83 ec 18          	sub    $0x18,%rsp
  804d35:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804d39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804d3d:	48 c1 e8 15          	shr    $0x15,%rax
  804d41:	48 89 c2             	mov    %rax,%rdx
  804d44:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804d4b:	01 00 00 
  804d4e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804d52:	83 e0 01             	and    $0x1,%eax
  804d55:	48 85 c0             	test   %rax,%rax
  804d58:	75 07                	jne    804d61 <pageref+0x34>
		return 0;
  804d5a:	b8 00 00 00 00       	mov    $0x0,%eax
  804d5f:	eb 53                	jmp    804db4 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804d61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804d65:	48 c1 e8 0c          	shr    $0xc,%rax
  804d69:	48 89 c2             	mov    %rax,%rdx
  804d6c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804d73:	01 00 00 
  804d76:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804d7a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804d7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d82:	83 e0 01             	and    $0x1,%eax
  804d85:	48 85 c0             	test   %rax,%rax
  804d88:	75 07                	jne    804d91 <pageref+0x64>
		return 0;
  804d8a:	b8 00 00 00 00       	mov    $0x0,%eax
  804d8f:	eb 23                	jmp    804db4 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804d91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d95:	48 c1 e8 0c          	shr    $0xc,%rax
  804d99:	48 89 c2             	mov    %rax,%rdx
  804d9c:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804da3:	00 00 00 
  804da6:	48 c1 e2 04          	shl    $0x4,%rdx
  804daa:	48 01 d0             	add    %rdx,%rax
  804dad:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804db1:	0f b7 c0             	movzwl %ax,%eax
}
  804db4:	c9                   	leaveq 
  804db5:	c3                   	retq   
