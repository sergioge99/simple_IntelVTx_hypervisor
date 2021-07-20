
vmm/guest/obj/user/writemotd:     formato del fichero elf64-x86-64


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
  80003c:	e8 36 03 00 00       	callq  800377 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80004e:	89 bd ec fd ff ff    	mov    %edi,-0x214(%rbp)
  800054:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int rfd, wfd;
	char buf[512];
	int n, r;

	if ((rfd = open("/newmotd", O_RDONLY)) < 0)
  80005b:	be 00 00 00 00       	mov    $0x0,%esi
  800060:	48 bf 00 40 80 00 00 	movabs $0x804000,%rdi
  800067:	00 00 00 
  80006a:	48 b8 54 28 80 00 00 	movabs $0x802854,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800079:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80007d:	79 30                	jns    8000af <umain+0x6c>
		panic("open /newmotd: %e", rfd);
  80007f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800082:	89 c1                	mov    %eax,%ecx
  800084:	48 ba 09 40 80 00 00 	movabs $0x804009,%rdx
  80008b:	00 00 00 
  80008e:	be 0b 00 00 00       	mov    $0xb,%esi
  800093:	48 bf 1b 40 80 00 00 	movabs $0x80401b,%rdi
  80009a:	00 00 00 
  80009d:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a2:	49 b8 fa 03 80 00 00 	movabs $0x8003fa,%r8
  8000a9:	00 00 00 
  8000ac:	41 ff d0             	callq  *%r8
	if ((wfd = open("/motd", O_RDWR)) < 0)
  8000af:	be 02 00 00 00       	mov    $0x2,%esi
  8000b4:	48 bf 2c 40 80 00 00 	movabs $0x80402c,%rdi
  8000bb:	00 00 00 
  8000be:	48 b8 54 28 80 00 00 	movabs $0x802854,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	callq  *%rax
  8000ca:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d1:	79 30                	jns    800103 <umain+0xc0>
		panic("open /motd: %e", wfd);
  8000d3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d6:	89 c1                	mov    %eax,%ecx
  8000d8:	48 ba 32 40 80 00 00 	movabs $0x804032,%rdx
  8000df:	00 00 00 
  8000e2:	be 0d 00 00 00       	mov    $0xd,%esi
  8000e7:	48 bf 1b 40 80 00 00 	movabs $0x80401b,%rdi
  8000ee:	00 00 00 
  8000f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f6:	49 b8 fa 03 80 00 00 	movabs $0x8003fa,%r8
  8000fd:	00 00 00 
  800100:	41 ff d0             	callq  *%r8
	cprintf("file descriptors %d %d\n", rfd, wfd);
  800103:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800106:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800109:	89 c6                	mov    %eax,%esi
  80010b:	48 bf 41 40 80 00 00 	movabs $0x804041,%rdi
  800112:	00 00 00 
  800115:	b8 00 00 00 00       	mov    $0x0,%eax
  80011a:	48 b9 33 06 80 00 00 	movabs $0x800633,%rcx
  800121:	00 00 00 
  800124:	ff d1                	callq  *%rcx
	if (rfd == wfd)
  800126:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800129:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  80012c:	75 2a                	jne    800158 <umain+0x115>
		panic("open /newmotd and /motd give same file descriptor");
  80012e:	48 ba 60 40 80 00 00 	movabs $0x804060,%rdx
  800135:	00 00 00 
  800138:	be 10 00 00 00       	mov    $0x10,%esi
  80013d:	48 bf 1b 40 80 00 00 	movabs $0x80401b,%rdi
  800144:	00 00 00 
  800147:	b8 00 00 00 00       	mov    $0x0,%eax
  80014c:	48 b9 fa 03 80 00 00 	movabs $0x8003fa,%rcx
  800153:	00 00 00 
  800156:	ff d1                	callq  *%rcx

	cprintf("OLD MOTD\n===\n");
  800158:	48 bf 92 40 80 00 00 	movabs $0x804092,%rdi
  80015f:	00 00 00 
  800162:	b8 00 00 00 00       	mov    $0x0,%eax
  800167:	48 ba 33 06 80 00 00 	movabs $0x800633,%rdx
  80016e:	00 00 00 
  800171:	ff d2                	callq  *%rdx
	while ((n = read(wfd, buf, sizeof buf-1)) > 0)
  800173:	eb 1f                	jmp    800194 <umain+0x151>
		sys_cputs(buf, n);
  800175:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800178:	48 63 d0             	movslq %eax,%rdx
  80017b:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  800182:	48 89 d6             	mov    %rdx,%rsi
  800185:	48 89 c7             	mov    %rax,%rdi
  800188:	48 b8 b4 19 80 00 00 	movabs $0x8019b4,%rax
  80018f:	00 00 00 
  800192:	ff d0                	callq  *%rax
	while ((n = read(wfd, buf, sizeof buf-1)) > 0)
  800194:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80019b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80019e:	ba ff 01 00 00       	mov    $0x1ff,%edx
  8001a3:	48 89 ce             	mov    %rcx,%rsi
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	48 b8 7c 23 80 00 00 	movabs $0x80237c,%rax
  8001af:	00 00 00 
  8001b2:	ff d0                	callq  *%rax
  8001b4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8001b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8001bb:	7f b8                	jg     800175 <umain+0x132>
	cprintf("===\n");
  8001bd:	48 bf a0 40 80 00 00 	movabs $0x8040a0,%rdi
  8001c4:	00 00 00 
  8001c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8001cc:	48 ba 33 06 80 00 00 	movabs $0x800633,%rdx
  8001d3:	00 00 00 
  8001d6:	ff d2                	callq  *%rdx
	seek(wfd, 0);
  8001d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001db:	be 00 00 00 00       	mov    $0x0,%esi
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	48 b8 9a 25 80 00 00 	movabs $0x80259a,%rax
  8001e9:	00 00 00 
  8001ec:	ff d0                	callq  *%rax

	if ((r = ftruncate(wfd, 0)) < 0)
  8001ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001f1:	be 00 00 00 00       	mov    $0x0,%esi
  8001f6:	89 c7                	mov    %eax,%edi
  8001f8:	48 b8 df 25 80 00 00 	movabs $0x8025df,%rax
  8001ff:	00 00 00 
  800202:	ff d0                	callq  *%rax
  800204:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800207:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80020b:	79 30                	jns    80023d <umain+0x1fa>
		panic("truncate /motd: %e", r);
  80020d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800210:	89 c1                	mov    %eax,%ecx
  800212:	48 ba a5 40 80 00 00 	movabs $0x8040a5,%rdx
  800219:	00 00 00 
  80021c:	be 19 00 00 00       	mov    $0x19,%esi
  800221:	48 bf 1b 40 80 00 00 	movabs $0x80401b,%rdi
  800228:	00 00 00 
  80022b:	b8 00 00 00 00       	mov    $0x0,%eax
  800230:	49 b8 fa 03 80 00 00 	movabs $0x8003fa,%r8
  800237:	00 00 00 
  80023a:	41 ff d0             	callq  *%r8

	cprintf("NEW MOTD\n===\n");
  80023d:	48 bf b8 40 80 00 00 	movabs $0x8040b8,%rdi
  800244:	00 00 00 
  800247:	b8 00 00 00 00       	mov    $0x0,%eax
  80024c:	48 ba 33 06 80 00 00 	movabs $0x800633,%rdx
  800253:	00 00 00 
  800256:	ff d2                	callq  *%rdx
	while ((n = read(rfd, buf, sizeof buf-1)) > 0) {
  800258:	eb 7b                	jmp    8002d5 <umain+0x292>
		sys_cputs(buf, n);
  80025a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80025d:	48 63 d0             	movslq %eax,%rdx
  800260:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  800267:	48 89 d6             	mov    %rdx,%rsi
  80026a:	48 89 c7             	mov    %rax,%rdi
  80026d:	48 b8 b4 19 80 00 00 	movabs $0x8019b4,%rax
  800274:	00 00 00 
  800277:	ff d0                	callq  *%rax
		if ((r = write(wfd, buf, n)) != n)
  800279:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80027c:	48 63 d0             	movslq %eax,%rdx
  80027f:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  800286:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800289:	48 89 ce             	mov    %rcx,%rsi
  80028c:	89 c7                	mov    %eax,%edi
  80028e:	48 b8 c6 24 80 00 00 	movabs $0x8024c6,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
  80029a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80029d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a0:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8002a3:	74 30                	je     8002d5 <umain+0x292>
			panic("write /motd: %e", r);
  8002a5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002a8:	89 c1                	mov    %eax,%ecx
  8002aa:	48 ba c6 40 80 00 00 	movabs $0x8040c6,%rdx
  8002b1:	00 00 00 
  8002b4:	be 1f 00 00 00       	mov    $0x1f,%esi
  8002b9:	48 bf 1b 40 80 00 00 	movabs $0x80401b,%rdi
  8002c0:	00 00 00 
  8002c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c8:	49 b8 fa 03 80 00 00 	movabs $0x8003fa,%r8
  8002cf:	00 00 00 
  8002d2:	41 ff d0             	callq  *%r8
	while ((n = read(rfd, buf, sizeof buf-1)) > 0) {
  8002d5:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8002dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002df:	ba ff 01 00 00       	mov    $0x1ff,%edx
  8002e4:	48 89 ce             	mov    %rcx,%rsi
  8002e7:	89 c7                	mov    %eax,%edi
  8002e9:	48 b8 7c 23 80 00 00 	movabs $0x80237c,%rax
  8002f0:	00 00 00 
  8002f3:	ff d0                	callq  *%rax
  8002f5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8002f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8002fc:	0f 8f 58 ff ff ff    	jg     80025a <umain+0x217>
	}
	cprintf("===\n");
  800302:	48 bf a0 40 80 00 00 	movabs $0x8040a0,%rdi
  800309:	00 00 00 
  80030c:	b8 00 00 00 00       	mov    $0x0,%eax
  800311:	48 ba 33 06 80 00 00 	movabs $0x800633,%rdx
  800318:	00 00 00 
  80031b:	ff d2                	callq  *%rdx

	if (n < 0)
  80031d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800321:	79 30                	jns    800353 <umain+0x310>
		panic("read /newmotd: %e", n);
  800323:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800326:	89 c1                	mov    %eax,%ecx
  800328:	48 ba d6 40 80 00 00 	movabs $0x8040d6,%rdx
  80032f:	00 00 00 
  800332:	be 24 00 00 00       	mov    $0x24,%esi
  800337:	48 bf 1b 40 80 00 00 	movabs $0x80401b,%rdi
  80033e:	00 00 00 
  800341:	b8 00 00 00 00       	mov    $0x0,%eax
  800346:	49 b8 fa 03 80 00 00 	movabs $0x8003fa,%r8
  80034d:	00 00 00 
  800350:	41 ff d0             	callq  *%r8

	close(rfd);
  800353:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800356:	89 c7                	mov    %eax,%edi
  800358:	48 b8 5a 21 80 00 00 	movabs $0x80215a,%rax
  80035f:	00 00 00 
  800362:	ff d0                	callq  *%rax
	close(wfd);
  800364:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800367:	89 c7                	mov    %eax,%edi
  800369:	48 b8 5a 21 80 00 00 	movabs $0x80215a,%rax
  800370:	00 00 00 
  800373:	ff d0                	callq  *%rax
}
  800375:	c9                   	leaveq 
  800376:	c3                   	retq   

0000000000800377 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800377:	55                   	push   %rbp
  800378:	48 89 e5             	mov    %rsp,%rbp
  80037b:	48 83 ec 10          	sub    $0x10,%rsp
  80037f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800382:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800386:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80038d:	00 00 00 
  800390:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800397:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80039b:	7e 14                	jle    8003b1 <libmain+0x3a>
		binaryname = argv[0];
  80039d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a1:	48 8b 10             	mov    (%rax),%rdx
  8003a4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003ab:	00 00 00 
  8003ae:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003b8:	48 89 d6             	mov    %rdx,%rsi
  8003bb:	89 c7                	mov    %eax,%edi
  8003bd:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003c4:	00 00 00 
  8003c7:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003c9:	48 b8 d7 03 80 00 00 	movabs $0x8003d7,%rax
  8003d0:	00 00 00 
  8003d3:	ff d0                	callq  *%rax
}
  8003d5:	c9                   	leaveq 
  8003d6:	c3                   	retq   

00000000008003d7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003d7:	55                   	push   %rbp
  8003d8:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003db:	48 b8 a5 21 80 00 00 	movabs $0x8021a5,%rax
  8003e2:	00 00 00 
  8003e5:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8003ec:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  8003f3:	00 00 00 
  8003f6:	ff d0                	callq  *%rax
}
  8003f8:	5d                   	pop    %rbp
  8003f9:	c3                   	retq   

00000000008003fa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003fa:	55                   	push   %rbp
  8003fb:	48 89 e5             	mov    %rsp,%rbp
  8003fe:	53                   	push   %rbx
  8003ff:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800406:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80040d:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800413:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80041a:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800421:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800428:	84 c0                	test   %al,%al
  80042a:	74 23                	je     80044f <_panic+0x55>
  80042c:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800433:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800437:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80043b:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80043f:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800443:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800447:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80044b:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80044f:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800456:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80045d:	00 00 00 
  800460:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800467:	00 00 00 
  80046a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80046e:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800475:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80047c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800483:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80048a:	00 00 00 
  80048d:	48 8b 18             	mov    (%rax),%rbx
  800490:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  800497:	00 00 00 
  80049a:	ff d0                	callq  *%rax
  80049c:	89 c6                	mov    %eax,%esi
  80049e:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8004a4:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8004ab:	41 89 d0             	mov    %edx,%r8d
  8004ae:	48 89 c1             	mov    %rax,%rcx
  8004b1:	48 89 da             	mov    %rbx,%rdx
  8004b4:	48 bf f8 40 80 00 00 	movabs $0x8040f8,%rdi
  8004bb:	00 00 00 
  8004be:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c3:	49 b9 33 06 80 00 00 	movabs $0x800633,%r9
  8004ca:	00 00 00 
  8004cd:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004d0:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004d7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004de:	48 89 d6             	mov    %rdx,%rsi
  8004e1:	48 89 c7             	mov    %rax,%rdi
  8004e4:	48 b8 87 05 80 00 00 	movabs $0x800587,%rax
  8004eb:	00 00 00 
  8004ee:	ff d0                	callq  *%rax
	cprintf("\n");
  8004f0:	48 bf 1b 41 80 00 00 	movabs $0x80411b,%rdi
  8004f7:	00 00 00 
  8004fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ff:	48 ba 33 06 80 00 00 	movabs $0x800633,%rdx
  800506:	00 00 00 
  800509:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80050b:	cc                   	int3   
  80050c:	eb fd                	jmp    80050b <_panic+0x111>

000000000080050e <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80050e:	55                   	push   %rbp
  80050f:	48 89 e5             	mov    %rsp,%rbp
  800512:	48 83 ec 10          	sub    $0x10,%rsp
  800516:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800519:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80051d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800521:	8b 00                	mov    (%rax),%eax
  800523:	8d 48 01             	lea    0x1(%rax),%ecx
  800526:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80052a:	89 0a                	mov    %ecx,(%rdx)
  80052c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80052f:	89 d1                	mov    %edx,%ecx
  800531:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800535:	48 98                	cltq   
  800537:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80053b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80053f:	8b 00                	mov    (%rax),%eax
  800541:	3d ff 00 00 00       	cmp    $0xff,%eax
  800546:	75 2c                	jne    800574 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800548:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80054c:	8b 00                	mov    (%rax),%eax
  80054e:	48 98                	cltq   
  800550:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800554:	48 83 c2 08          	add    $0x8,%rdx
  800558:	48 89 c6             	mov    %rax,%rsi
  80055b:	48 89 d7             	mov    %rdx,%rdi
  80055e:	48 b8 b4 19 80 00 00 	movabs $0x8019b4,%rax
  800565:	00 00 00 
  800568:	ff d0                	callq  *%rax
        b->idx = 0;
  80056a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80056e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800574:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800578:	8b 40 04             	mov    0x4(%rax),%eax
  80057b:	8d 50 01             	lea    0x1(%rax),%edx
  80057e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800582:	89 50 04             	mov    %edx,0x4(%rax)
}
  800585:	c9                   	leaveq 
  800586:	c3                   	retq   

0000000000800587 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800587:	55                   	push   %rbp
  800588:	48 89 e5             	mov    %rsp,%rbp
  80058b:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800592:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800599:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8005a0:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005a7:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005ae:	48 8b 0a             	mov    (%rdx),%rcx
  8005b1:	48 89 08             	mov    %rcx,(%rax)
  8005b4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005b8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005bc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005c0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005c4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005cb:	00 00 00 
    b.cnt = 0;
  8005ce:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005d5:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8005d8:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005df:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005e6:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005ed:	48 89 c6             	mov    %rax,%rsi
  8005f0:	48 bf 0e 05 80 00 00 	movabs $0x80050e,%rdi
  8005f7:	00 00 00 
  8005fa:	48 b8 d2 09 80 00 00 	movabs $0x8009d2,%rax
  800601:	00 00 00 
  800604:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800606:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80060c:	48 98                	cltq   
  80060e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800615:	48 83 c2 08          	add    $0x8,%rdx
  800619:	48 89 c6             	mov    %rax,%rsi
  80061c:	48 89 d7             	mov    %rdx,%rdi
  80061f:	48 b8 b4 19 80 00 00 	movabs $0x8019b4,%rax
  800626:	00 00 00 
  800629:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80062b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800631:	c9                   	leaveq 
  800632:	c3                   	retq   

0000000000800633 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800633:	55                   	push   %rbp
  800634:	48 89 e5             	mov    %rsp,%rbp
  800637:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80063e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800645:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80064c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800653:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80065a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800661:	84 c0                	test   %al,%al
  800663:	74 20                	je     800685 <cprintf+0x52>
  800665:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800669:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80066d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800671:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800675:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800679:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80067d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800681:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800685:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80068c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800693:	00 00 00 
  800696:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80069d:	00 00 00 
  8006a0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006a4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006ab:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006b2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006b9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006c0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006c7:	48 8b 0a             	mov    (%rdx),%rcx
  8006ca:	48 89 08             	mov    %rcx,(%rax)
  8006cd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006d1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006d5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006d9:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8006dd:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006e4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006eb:	48 89 d6             	mov    %rdx,%rsi
  8006ee:	48 89 c7             	mov    %rax,%rdi
  8006f1:	48 b8 87 05 80 00 00 	movabs $0x800587,%rax
  8006f8:	00 00 00 
  8006fb:	ff d0                	callq  *%rax
  8006fd:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800703:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800709:	c9                   	leaveq 
  80070a:	c3                   	retq   

000000000080070b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80070b:	55                   	push   %rbp
  80070c:	48 89 e5             	mov    %rsp,%rbp
  80070f:	48 83 ec 30          	sub    $0x30,%rsp
  800713:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800717:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80071b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80071f:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800722:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800726:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80072a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80072d:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800731:	77 42                	ja     800775 <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800733:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800736:	8d 78 ff             	lea    -0x1(%rax),%edi
  800739:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  80073c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800740:	ba 00 00 00 00       	mov    $0x0,%edx
  800745:	48 f7 f6             	div    %rsi
  800748:	49 89 c2             	mov    %rax,%r10
  80074b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80074e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800751:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800755:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800759:	41 89 c9             	mov    %ecx,%r9d
  80075c:	41 89 f8             	mov    %edi,%r8d
  80075f:	89 d1                	mov    %edx,%ecx
  800761:	4c 89 d2             	mov    %r10,%rdx
  800764:	48 89 c7             	mov    %rax,%rdi
  800767:	48 b8 0b 07 80 00 00 	movabs $0x80070b,%rax
  80076e:	00 00 00 
  800771:	ff d0                	callq  *%rax
  800773:	eb 1e                	jmp    800793 <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800775:	eb 12                	jmp    800789 <printnum+0x7e>
			putch(padc, putdat);
  800777:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80077b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80077e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800782:	48 89 ce             	mov    %rcx,%rsi
  800785:	89 d7                	mov    %edx,%edi
  800787:	ff d0                	callq  *%rax
		while (--width > 0)
  800789:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80078d:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800791:	7f e4                	jg     800777 <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800793:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800796:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079a:	ba 00 00 00 00       	mov    $0x0,%edx
  80079f:	48 f7 f1             	div    %rcx
  8007a2:	48 b8 30 43 80 00 00 	movabs $0x804330,%rax
  8007a9:	00 00 00 
  8007ac:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8007b0:	0f be d0             	movsbl %al,%edx
  8007b3:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8007b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007bb:	48 89 ce             	mov    %rcx,%rsi
  8007be:	89 d7                	mov    %edx,%edi
  8007c0:	ff d0                	callq  *%rax
}
  8007c2:	c9                   	leaveq 
  8007c3:	c3                   	retq   

00000000008007c4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007c4:	55                   	push   %rbp
  8007c5:	48 89 e5             	mov    %rsp,%rbp
  8007c8:	48 83 ec 20          	sub    $0x20,%rsp
  8007cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007d0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8007d3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007d7:	7e 4f                	jle    800828 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8007d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007dd:	8b 00                	mov    (%rax),%eax
  8007df:	83 f8 30             	cmp    $0x30,%eax
  8007e2:	73 24                	jae    800808 <getuint+0x44>
  8007e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f0:	8b 00                	mov    (%rax),%eax
  8007f2:	89 c0                	mov    %eax,%eax
  8007f4:	48 01 d0             	add    %rdx,%rax
  8007f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007fb:	8b 12                	mov    (%rdx),%edx
  8007fd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800800:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800804:	89 0a                	mov    %ecx,(%rdx)
  800806:	eb 14                	jmp    80081c <getuint+0x58>
  800808:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800810:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800814:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800818:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80081c:	48 8b 00             	mov    (%rax),%rax
  80081f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800823:	e9 9d 00 00 00       	jmpq   8008c5 <getuint+0x101>
	else if (lflag)
  800828:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80082c:	74 4c                	je     80087a <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  80082e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800832:	8b 00                	mov    (%rax),%eax
  800834:	83 f8 30             	cmp    $0x30,%eax
  800837:	73 24                	jae    80085d <getuint+0x99>
  800839:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800841:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800845:	8b 00                	mov    (%rax),%eax
  800847:	89 c0                	mov    %eax,%eax
  800849:	48 01 d0             	add    %rdx,%rax
  80084c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800850:	8b 12                	mov    (%rdx),%edx
  800852:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800855:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800859:	89 0a                	mov    %ecx,(%rdx)
  80085b:	eb 14                	jmp    800871 <getuint+0xad>
  80085d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800861:	48 8b 40 08          	mov    0x8(%rax),%rax
  800865:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800869:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80086d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800871:	48 8b 00             	mov    (%rax),%rax
  800874:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800878:	eb 4b                	jmp    8008c5 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  80087a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087e:	8b 00                	mov    (%rax),%eax
  800880:	83 f8 30             	cmp    $0x30,%eax
  800883:	73 24                	jae    8008a9 <getuint+0xe5>
  800885:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800889:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80088d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800891:	8b 00                	mov    (%rax),%eax
  800893:	89 c0                	mov    %eax,%eax
  800895:	48 01 d0             	add    %rdx,%rax
  800898:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80089c:	8b 12                	mov    (%rdx),%edx
  80089e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a5:	89 0a                	mov    %ecx,(%rdx)
  8008a7:	eb 14                	jmp    8008bd <getuint+0xf9>
  8008a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ad:	48 8b 40 08          	mov    0x8(%rax),%rax
  8008b1:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8008b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008bd:	8b 00                	mov    (%rax),%eax
  8008bf:	89 c0                	mov    %eax,%eax
  8008c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008c9:	c9                   	leaveq 
  8008ca:	c3                   	retq   

00000000008008cb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008cb:	55                   	push   %rbp
  8008cc:	48 89 e5             	mov    %rsp,%rbp
  8008cf:	48 83 ec 20          	sub    $0x20,%rsp
  8008d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008d7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008da:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008de:	7e 4f                	jle    80092f <getint+0x64>
		x=va_arg(*ap, long long);
  8008e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e4:	8b 00                	mov    (%rax),%eax
  8008e6:	83 f8 30             	cmp    $0x30,%eax
  8008e9:	73 24                	jae    80090f <getint+0x44>
  8008eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ef:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f7:	8b 00                	mov    (%rax),%eax
  8008f9:	89 c0                	mov    %eax,%eax
  8008fb:	48 01 d0             	add    %rdx,%rax
  8008fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800902:	8b 12                	mov    (%rdx),%edx
  800904:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800907:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80090b:	89 0a                	mov    %ecx,(%rdx)
  80090d:	eb 14                	jmp    800923 <getint+0x58>
  80090f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800913:	48 8b 40 08          	mov    0x8(%rax),%rax
  800917:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80091b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800923:	48 8b 00             	mov    (%rax),%rax
  800926:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80092a:	e9 9d 00 00 00       	jmpq   8009cc <getint+0x101>
	else if (lflag)
  80092f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800933:	74 4c                	je     800981 <getint+0xb6>
		x=va_arg(*ap, long);
  800935:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800939:	8b 00                	mov    (%rax),%eax
  80093b:	83 f8 30             	cmp    $0x30,%eax
  80093e:	73 24                	jae    800964 <getint+0x99>
  800940:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800944:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800948:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094c:	8b 00                	mov    (%rax),%eax
  80094e:	89 c0                	mov    %eax,%eax
  800950:	48 01 d0             	add    %rdx,%rax
  800953:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800957:	8b 12                	mov    (%rdx),%edx
  800959:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80095c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800960:	89 0a                	mov    %ecx,(%rdx)
  800962:	eb 14                	jmp    800978 <getint+0xad>
  800964:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800968:	48 8b 40 08          	mov    0x8(%rax),%rax
  80096c:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800970:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800974:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800978:	48 8b 00             	mov    (%rax),%rax
  80097b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80097f:	eb 4b                	jmp    8009cc <getint+0x101>
	else
		x=va_arg(*ap, int);
  800981:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800985:	8b 00                	mov    (%rax),%eax
  800987:	83 f8 30             	cmp    $0x30,%eax
  80098a:	73 24                	jae    8009b0 <getint+0xe5>
  80098c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800990:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800994:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800998:	8b 00                	mov    (%rax),%eax
  80099a:	89 c0                	mov    %eax,%eax
  80099c:	48 01 d0             	add    %rdx,%rax
  80099f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a3:	8b 12                	mov    (%rdx),%edx
  8009a5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ac:	89 0a                	mov    %ecx,(%rdx)
  8009ae:	eb 14                	jmp    8009c4 <getint+0xf9>
  8009b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b4:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009b8:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009c4:	8b 00                	mov    (%rax),%eax
  8009c6:	48 98                	cltq   
  8009c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009d0:	c9                   	leaveq 
  8009d1:	c3                   	retq   

00000000008009d2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009d2:	55                   	push   %rbp
  8009d3:	48 89 e5             	mov    %rsp,%rbp
  8009d6:	41 54                	push   %r12
  8009d8:	53                   	push   %rbx
  8009d9:	48 83 ec 60          	sub    $0x60,%rsp
  8009dd:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8009e1:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8009e5:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009e9:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8009ed:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009f1:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8009f5:	48 8b 0a             	mov    (%rdx),%rcx
  8009f8:	48 89 08             	mov    %rcx,(%rax)
  8009fb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8009ff:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a03:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a07:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a0b:	eb 17                	jmp    800a24 <vprintfmt+0x52>
			if (ch == '\0')
  800a0d:	85 db                	test   %ebx,%ebx
  800a0f:	0f 84 c5 04 00 00    	je     800eda <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  800a15:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a19:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a1d:	48 89 d6             	mov    %rdx,%rsi
  800a20:	89 df                	mov    %ebx,%edi
  800a22:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a24:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a28:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a2c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a30:	0f b6 00             	movzbl (%rax),%eax
  800a33:	0f b6 d8             	movzbl %al,%ebx
  800a36:	83 fb 25             	cmp    $0x25,%ebx
  800a39:	75 d2                	jne    800a0d <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  800a3b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a3f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a46:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a4d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a54:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a5b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a5f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a63:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a67:	0f b6 00             	movzbl (%rax),%eax
  800a6a:	0f b6 d8             	movzbl %al,%ebx
  800a6d:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a70:	83 f8 55             	cmp    $0x55,%eax
  800a73:	0f 87 2e 04 00 00    	ja     800ea7 <vprintfmt+0x4d5>
  800a79:	89 c0                	mov    %eax,%eax
  800a7b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a82:	00 
  800a83:	48 b8 58 43 80 00 00 	movabs $0x804358,%rax
  800a8a:	00 00 00 
  800a8d:	48 01 d0             	add    %rdx,%rax
  800a90:	48 8b 00             	mov    (%rax),%rax
  800a93:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a95:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a99:	eb c0                	jmp    800a5b <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a9b:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a9f:	eb ba                	jmp    800a5b <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aa1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800aa8:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800aab:	89 d0                	mov    %edx,%eax
  800aad:	c1 e0 02             	shl    $0x2,%eax
  800ab0:	01 d0                	add    %edx,%eax
  800ab2:	01 c0                	add    %eax,%eax
  800ab4:	01 d8                	add    %ebx,%eax
  800ab6:	83 e8 30             	sub    $0x30,%eax
  800ab9:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800abc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ac0:	0f b6 00             	movzbl (%rax),%eax
  800ac3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ac6:	83 fb 2f             	cmp    $0x2f,%ebx
  800ac9:	7e 0c                	jle    800ad7 <vprintfmt+0x105>
  800acb:	83 fb 39             	cmp    $0x39,%ebx
  800ace:	7f 07                	jg     800ad7 <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  800ad0:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  800ad5:	eb d1                	jmp    800aa8 <vprintfmt+0xd6>
			goto process_precision;
  800ad7:	eb 50                	jmp    800b29 <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  800ad9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800adc:	83 f8 30             	cmp    $0x30,%eax
  800adf:	73 17                	jae    800af8 <vprintfmt+0x126>
  800ae1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ae5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ae8:	89 d2                	mov    %edx,%edx
  800aea:	48 01 d0             	add    %rdx,%rax
  800aed:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800af0:	83 c2 08             	add    $0x8,%edx
  800af3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800af6:	eb 0c                	jmp    800b04 <vprintfmt+0x132>
  800af8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800afc:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b00:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b04:	8b 00                	mov    (%rax),%eax
  800b06:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b09:	eb 1e                	jmp    800b29 <vprintfmt+0x157>

		case '.':
			if (width < 0)
  800b0b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b0f:	79 07                	jns    800b18 <vprintfmt+0x146>
				width = 0;
  800b11:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b18:	e9 3e ff ff ff       	jmpq   800a5b <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800b1d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b24:	e9 32 ff ff ff       	jmpq   800a5b <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800b29:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b2d:	79 0d                	jns    800b3c <vprintfmt+0x16a>
				width = precision, precision = -1;
  800b2f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b32:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b35:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b3c:	e9 1a ff ff ff       	jmpq   800a5b <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b41:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b45:	e9 11 ff ff ff       	jmpq   800a5b <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b4a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b4d:	83 f8 30             	cmp    $0x30,%eax
  800b50:	73 17                	jae    800b69 <vprintfmt+0x197>
  800b52:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b56:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b59:	89 d2                	mov    %edx,%edx
  800b5b:	48 01 d0             	add    %rdx,%rax
  800b5e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b61:	83 c2 08             	add    $0x8,%edx
  800b64:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b67:	eb 0c                	jmp    800b75 <vprintfmt+0x1a3>
  800b69:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b6d:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b71:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b75:	8b 10                	mov    (%rax),%edx
  800b77:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b7b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b7f:	48 89 ce             	mov    %rcx,%rsi
  800b82:	89 d7                	mov    %edx,%edi
  800b84:	ff d0                	callq  *%rax
			break;
  800b86:	e9 4a 03 00 00       	jmpq   800ed5 <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b8b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b8e:	83 f8 30             	cmp    $0x30,%eax
  800b91:	73 17                	jae    800baa <vprintfmt+0x1d8>
  800b93:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b97:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b9a:	89 d2                	mov    %edx,%edx
  800b9c:	48 01 d0             	add    %rdx,%rax
  800b9f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ba2:	83 c2 08             	add    $0x8,%edx
  800ba5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ba8:	eb 0c                	jmp    800bb6 <vprintfmt+0x1e4>
  800baa:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800bae:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800bb2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bb6:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bb8:	85 db                	test   %ebx,%ebx
  800bba:	79 02                	jns    800bbe <vprintfmt+0x1ec>
				err = -err;
  800bbc:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bbe:	83 fb 15             	cmp    $0x15,%ebx
  800bc1:	7f 16                	jg     800bd9 <vprintfmt+0x207>
  800bc3:	48 b8 80 42 80 00 00 	movabs $0x804280,%rax
  800bca:	00 00 00 
  800bcd:	48 63 d3             	movslq %ebx,%rdx
  800bd0:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800bd4:	4d 85 e4             	test   %r12,%r12
  800bd7:	75 2e                	jne    800c07 <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  800bd9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bdd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be1:	89 d9                	mov    %ebx,%ecx
  800be3:	48 ba 41 43 80 00 00 	movabs $0x804341,%rdx
  800bea:	00 00 00 
  800bed:	48 89 c7             	mov    %rax,%rdi
  800bf0:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf5:	49 b8 e3 0e 80 00 00 	movabs $0x800ee3,%r8
  800bfc:	00 00 00 
  800bff:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c02:	e9 ce 02 00 00       	jmpq   800ed5 <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  800c07:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c0b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c0f:	4c 89 e1             	mov    %r12,%rcx
  800c12:	48 ba 4a 43 80 00 00 	movabs $0x80434a,%rdx
  800c19:	00 00 00 
  800c1c:	48 89 c7             	mov    %rax,%rdi
  800c1f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c24:	49 b8 e3 0e 80 00 00 	movabs $0x800ee3,%r8
  800c2b:	00 00 00 
  800c2e:	41 ff d0             	callq  *%r8
			break;
  800c31:	e9 9f 02 00 00       	jmpq   800ed5 <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c36:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c39:	83 f8 30             	cmp    $0x30,%eax
  800c3c:	73 17                	jae    800c55 <vprintfmt+0x283>
  800c3e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c42:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c45:	89 d2                	mov    %edx,%edx
  800c47:	48 01 d0             	add    %rdx,%rax
  800c4a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c4d:	83 c2 08             	add    $0x8,%edx
  800c50:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c53:	eb 0c                	jmp    800c61 <vprintfmt+0x28f>
  800c55:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c59:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c5d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c61:	4c 8b 20             	mov    (%rax),%r12
  800c64:	4d 85 e4             	test   %r12,%r12
  800c67:	75 0a                	jne    800c73 <vprintfmt+0x2a1>
				p = "(null)";
  800c69:	49 bc 4d 43 80 00 00 	movabs $0x80434d,%r12
  800c70:	00 00 00 
			if (width > 0 && padc != '-')
  800c73:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c77:	7e 3f                	jle    800cb8 <vprintfmt+0x2e6>
  800c79:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c7d:	74 39                	je     800cb8 <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c7f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c82:	48 98                	cltq   
  800c84:	48 89 c6             	mov    %rax,%rsi
  800c87:	4c 89 e7             	mov    %r12,%rdi
  800c8a:	48 b8 8f 11 80 00 00 	movabs $0x80118f,%rax
  800c91:	00 00 00 
  800c94:	ff d0                	callq  *%rax
  800c96:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c99:	eb 17                	jmp    800cb2 <vprintfmt+0x2e0>
					putch(padc, putdat);
  800c9b:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800c9f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ca3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca7:	48 89 ce             	mov    %rcx,%rsi
  800caa:	89 d7                	mov    %edx,%edi
  800cac:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  800cae:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cb2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cb6:	7f e3                	jg     800c9b <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cb8:	eb 37                	jmp    800cf1 <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  800cba:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800cbe:	74 1e                	je     800cde <vprintfmt+0x30c>
  800cc0:	83 fb 1f             	cmp    $0x1f,%ebx
  800cc3:	7e 05                	jle    800cca <vprintfmt+0x2f8>
  800cc5:	83 fb 7e             	cmp    $0x7e,%ebx
  800cc8:	7e 14                	jle    800cde <vprintfmt+0x30c>
					putch('?', putdat);
  800cca:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd2:	48 89 d6             	mov    %rdx,%rsi
  800cd5:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800cda:	ff d0                	callq  *%rax
  800cdc:	eb 0f                	jmp    800ced <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  800cde:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ce2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce6:	48 89 d6             	mov    %rdx,%rsi
  800ce9:	89 df                	mov    %ebx,%edi
  800ceb:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ced:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cf1:	4c 89 e0             	mov    %r12,%rax
  800cf4:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800cf8:	0f b6 00             	movzbl (%rax),%eax
  800cfb:	0f be d8             	movsbl %al,%ebx
  800cfe:	85 db                	test   %ebx,%ebx
  800d00:	74 10                	je     800d12 <vprintfmt+0x340>
  800d02:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d06:	78 b2                	js     800cba <vprintfmt+0x2e8>
  800d08:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d0c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d10:	79 a8                	jns    800cba <vprintfmt+0x2e8>
			for (; width > 0; width--)
  800d12:	eb 16                	jmp    800d2a <vprintfmt+0x358>
				putch(' ', putdat);
  800d14:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d18:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d1c:	48 89 d6             	mov    %rdx,%rsi
  800d1f:	bf 20 00 00 00       	mov    $0x20,%edi
  800d24:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  800d26:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d2a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d2e:	7f e4                	jg     800d14 <vprintfmt+0x342>
			break;
  800d30:	e9 a0 01 00 00       	jmpq   800ed5 <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d35:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d39:	be 03 00 00 00       	mov    $0x3,%esi
  800d3e:	48 89 c7             	mov    %rax,%rdi
  800d41:	48 b8 cb 08 80 00 00 	movabs $0x8008cb,%rax
  800d48:	00 00 00 
  800d4b:	ff d0                	callq  *%rax
  800d4d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d55:	48 85 c0             	test   %rax,%rax
  800d58:	79 1d                	jns    800d77 <vprintfmt+0x3a5>
				putch('-', putdat);
  800d5a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d5e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d62:	48 89 d6             	mov    %rdx,%rsi
  800d65:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d6a:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d70:	48 f7 d8             	neg    %rax
  800d73:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d77:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d7e:	e9 e5 00 00 00       	jmpq   800e68 <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d83:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d87:	be 03 00 00 00       	mov    $0x3,%esi
  800d8c:	48 89 c7             	mov    %rax,%rdi
  800d8f:	48 b8 c4 07 80 00 00 	movabs $0x8007c4,%rax
  800d96:	00 00 00 
  800d99:	ff d0                	callq  *%rax
  800d9b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d9f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800da6:	e9 bd 00 00 00       	jmpq   800e68 <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800dab:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800daf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800db3:	48 89 d6             	mov    %rdx,%rsi
  800db6:	bf 58 00 00 00       	mov    $0x58,%edi
  800dbb:	ff d0                	callq  *%rax
			putch('X', putdat);
  800dbd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dc1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dc5:	48 89 d6             	mov    %rdx,%rsi
  800dc8:	bf 58 00 00 00       	mov    $0x58,%edi
  800dcd:	ff d0                	callq  *%rax
			putch('X', putdat);
  800dcf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dd3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dd7:	48 89 d6             	mov    %rdx,%rsi
  800dda:	bf 58 00 00 00       	mov    $0x58,%edi
  800ddf:	ff d0                	callq  *%rax
			break;
  800de1:	e9 ef 00 00 00       	jmpq   800ed5 <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  800de6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dea:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dee:	48 89 d6             	mov    %rdx,%rsi
  800df1:	bf 30 00 00 00       	mov    $0x30,%edi
  800df6:	ff d0                	callq  *%rax
			putch('x', putdat);
  800df8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dfc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e00:	48 89 d6             	mov    %rdx,%rsi
  800e03:	bf 78 00 00 00       	mov    $0x78,%edi
  800e08:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e0a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e0d:	83 f8 30             	cmp    $0x30,%eax
  800e10:	73 17                	jae    800e29 <vprintfmt+0x457>
  800e12:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e16:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e19:	89 d2                	mov    %edx,%edx
  800e1b:	48 01 d0             	add    %rdx,%rax
  800e1e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e21:	83 c2 08             	add    $0x8,%edx
  800e24:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  800e27:	eb 0c                	jmp    800e35 <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  800e29:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800e2d:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800e31:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e35:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  800e38:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e3c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e43:	eb 23                	jmp    800e68 <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e45:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e49:	be 03 00 00 00       	mov    $0x3,%esi
  800e4e:	48 89 c7             	mov    %rax,%rdi
  800e51:	48 b8 c4 07 80 00 00 	movabs $0x8007c4,%rax
  800e58:	00 00 00 
  800e5b:	ff d0                	callq  *%rax
  800e5d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e61:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e68:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e6d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e70:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e73:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e77:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e7b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e7f:	45 89 c1             	mov    %r8d,%r9d
  800e82:	41 89 f8             	mov    %edi,%r8d
  800e85:	48 89 c7             	mov    %rax,%rdi
  800e88:	48 b8 0b 07 80 00 00 	movabs $0x80070b,%rax
  800e8f:	00 00 00 
  800e92:	ff d0                	callq  *%rax
			break;
  800e94:	eb 3f                	jmp    800ed5 <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e96:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e9a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e9e:	48 89 d6             	mov    %rdx,%rsi
  800ea1:	89 df                	mov    %ebx,%edi
  800ea3:	ff d0                	callq  *%rax
			break;
  800ea5:	eb 2e                	jmp    800ed5 <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ea7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eab:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eaf:	48 89 d6             	mov    %rdx,%rsi
  800eb2:	bf 25 00 00 00       	mov    $0x25,%edi
  800eb7:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800eb9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ebe:	eb 05                	jmp    800ec5 <vprintfmt+0x4f3>
  800ec0:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ec5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ec9:	48 83 e8 01          	sub    $0x1,%rax
  800ecd:	0f b6 00             	movzbl (%rax),%eax
  800ed0:	3c 25                	cmp    $0x25,%al
  800ed2:	75 ec                	jne    800ec0 <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  800ed4:	90                   	nop
		}
	}
  800ed5:	e9 31 fb ff ff       	jmpq   800a0b <vprintfmt+0x39>
	va_end(aq);
}
  800eda:	48 83 c4 60          	add    $0x60,%rsp
  800ede:	5b                   	pop    %rbx
  800edf:	41 5c                	pop    %r12
  800ee1:	5d                   	pop    %rbp
  800ee2:	c3                   	retq   

0000000000800ee3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ee3:	55                   	push   %rbp
  800ee4:	48 89 e5             	mov    %rsp,%rbp
  800ee7:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800eee:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800ef5:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800efc:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f03:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f0a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f11:	84 c0                	test   %al,%al
  800f13:	74 20                	je     800f35 <printfmt+0x52>
  800f15:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f19:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f1d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f21:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f25:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f29:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f2d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f31:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f35:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f3c:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f43:	00 00 00 
  800f46:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f4d:	00 00 00 
  800f50:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f54:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f5b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f62:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f69:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f70:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f77:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f7e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f85:	48 89 c7             	mov    %rax,%rdi
  800f88:	48 b8 d2 09 80 00 00 	movabs $0x8009d2,%rax
  800f8f:	00 00 00 
  800f92:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f94:	c9                   	leaveq 
  800f95:	c3                   	retq   

0000000000800f96 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f96:	55                   	push   %rbp
  800f97:	48 89 e5             	mov    %rsp,%rbp
  800f9a:	48 83 ec 10          	sub    $0x10,%rsp
  800f9e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fa1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800fa5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fa9:	8b 40 10             	mov    0x10(%rax),%eax
  800fac:	8d 50 01             	lea    0x1(%rax),%edx
  800faf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fb3:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800fb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fba:	48 8b 10             	mov    (%rax),%rdx
  800fbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc1:	48 8b 40 08          	mov    0x8(%rax),%rax
  800fc5:	48 39 c2             	cmp    %rax,%rdx
  800fc8:	73 17                	jae    800fe1 <sprintputch+0x4b>
		*b->buf++ = ch;
  800fca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fce:	48 8b 00             	mov    (%rax),%rax
  800fd1:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800fd5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800fd9:	48 89 0a             	mov    %rcx,(%rdx)
  800fdc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800fdf:	88 10                	mov    %dl,(%rax)
}
  800fe1:	c9                   	leaveq 
  800fe2:	c3                   	retq   

0000000000800fe3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fe3:	55                   	push   %rbp
  800fe4:	48 89 e5             	mov    %rsp,%rbp
  800fe7:	48 83 ec 50          	sub    $0x50,%rsp
  800feb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800fef:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ff2:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ff6:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ffa:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ffe:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801002:	48 8b 0a             	mov    (%rdx),%rcx
  801005:	48 89 08             	mov    %rcx,(%rax)
  801008:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80100c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801010:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801014:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801018:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80101c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801020:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801023:	48 98                	cltq   
  801025:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801029:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80102d:	48 01 d0             	add    %rdx,%rax
  801030:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801034:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80103b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801040:	74 06                	je     801048 <vsnprintf+0x65>
  801042:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801046:	7f 07                	jg     80104f <vsnprintf+0x6c>
		return -E_INVAL;
  801048:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80104d:	eb 2f                	jmp    80107e <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80104f:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801053:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801057:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80105b:	48 89 c6             	mov    %rax,%rsi
  80105e:	48 bf 96 0f 80 00 00 	movabs $0x800f96,%rdi
  801065:	00 00 00 
  801068:	48 b8 d2 09 80 00 00 	movabs $0x8009d2,%rax
  80106f:	00 00 00 
  801072:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801074:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801078:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80107b:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80107e:	c9                   	leaveq 
  80107f:	c3                   	retq   

0000000000801080 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801080:	55                   	push   %rbp
  801081:	48 89 e5             	mov    %rsp,%rbp
  801084:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80108b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801092:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801098:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80109f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010a6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010ad:	84 c0                	test   %al,%al
  8010af:	74 20                	je     8010d1 <snprintf+0x51>
  8010b1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010b5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010b9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010bd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010c1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010c5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010c9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010cd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8010d1:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8010d8:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8010df:	00 00 00 
  8010e2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8010e9:	00 00 00 
  8010ec:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010f0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8010f7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010fe:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801105:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80110c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801113:	48 8b 0a             	mov    (%rdx),%rcx
  801116:	48 89 08             	mov    %rcx,(%rax)
  801119:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80111d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801121:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801125:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801129:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801130:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801137:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80113d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801144:	48 89 c7             	mov    %rax,%rdi
  801147:	48 b8 e3 0f 80 00 00 	movabs $0x800fe3,%rax
  80114e:	00 00 00 
  801151:	ff d0                	callq  *%rax
  801153:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801159:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80115f:	c9                   	leaveq 
  801160:	c3                   	retq   

0000000000801161 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801161:	55                   	push   %rbp
  801162:	48 89 e5             	mov    %rsp,%rbp
  801165:	48 83 ec 18          	sub    $0x18,%rsp
  801169:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80116d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801174:	eb 09                	jmp    80117f <strlen+0x1e>
		n++;
  801176:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  80117a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80117f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801183:	0f b6 00             	movzbl (%rax),%eax
  801186:	84 c0                	test   %al,%al
  801188:	75 ec                	jne    801176 <strlen+0x15>
	return n;
  80118a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80118d:	c9                   	leaveq 
  80118e:	c3                   	retq   

000000000080118f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80118f:	55                   	push   %rbp
  801190:	48 89 e5             	mov    %rsp,%rbp
  801193:	48 83 ec 20          	sub    $0x20,%rsp
  801197:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80119b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80119f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011a6:	eb 0e                	jmp    8011b6 <strnlen+0x27>
		n++;
  8011a8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011ac:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011b1:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011b6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011bb:	74 0b                	je     8011c8 <strnlen+0x39>
  8011bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c1:	0f b6 00             	movzbl (%rax),%eax
  8011c4:	84 c0                	test   %al,%al
  8011c6:	75 e0                	jne    8011a8 <strnlen+0x19>
	return n;
  8011c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011cb:	c9                   	leaveq 
  8011cc:	c3                   	retq   

00000000008011cd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011cd:	55                   	push   %rbp
  8011ce:	48 89 e5             	mov    %rsp,%rbp
  8011d1:	48 83 ec 20          	sub    $0x20,%rsp
  8011d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8011dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8011e5:	90                   	nop
  8011e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ea:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011ee:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011f2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011f6:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011fa:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011fe:	0f b6 12             	movzbl (%rdx),%edx
  801201:	88 10                	mov    %dl,(%rax)
  801203:	0f b6 00             	movzbl (%rax),%eax
  801206:	84 c0                	test   %al,%al
  801208:	75 dc                	jne    8011e6 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80120a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80120e:	c9                   	leaveq 
  80120f:	c3                   	retq   

0000000000801210 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801210:	55                   	push   %rbp
  801211:	48 89 e5             	mov    %rsp,%rbp
  801214:	48 83 ec 20          	sub    $0x20,%rsp
  801218:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80121c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801220:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801224:	48 89 c7             	mov    %rax,%rdi
  801227:	48 b8 61 11 80 00 00 	movabs $0x801161,%rax
  80122e:	00 00 00 
  801231:	ff d0                	callq  *%rax
  801233:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801236:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801239:	48 63 d0             	movslq %eax,%rdx
  80123c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801240:	48 01 c2             	add    %rax,%rdx
  801243:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801247:	48 89 c6             	mov    %rax,%rsi
  80124a:	48 89 d7             	mov    %rdx,%rdi
  80124d:	48 b8 cd 11 80 00 00 	movabs $0x8011cd,%rax
  801254:	00 00 00 
  801257:	ff d0                	callq  *%rax
	return dst;
  801259:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80125d:	c9                   	leaveq 
  80125e:	c3                   	retq   

000000000080125f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80125f:	55                   	push   %rbp
  801260:	48 89 e5             	mov    %rsp,%rbp
  801263:	48 83 ec 28          	sub    $0x28,%rsp
  801267:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80126b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80126f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801273:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801277:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80127b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801282:	00 
  801283:	eb 2a                	jmp    8012af <strncpy+0x50>
		*dst++ = *src;
  801285:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801289:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80128d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801291:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801295:	0f b6 12             	movzbl (%rdx),%edx
  801298:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80129a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80129e:	0f b6 00             	movzbl (%rax),%eax
  8012a1:	84 c0                	test   %al,%al
  8012a3:	74 05                	je     8012aa <strncpy+0x4b>
			src++;
  8012a5:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  8012aa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012b7:	72 cc                	jb     801285 <strncpy+0x26>
	}
	return ret;
  8012b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8012bd:	c9                   	leaveq 
  8012be:	c3                   	retq   

00000000008012bf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012bf:	55                   	push   %rbp
  8012c0:	48 89 e5             	mov    %rsp,%rbp
  8012c3:	48 83 ec 28          	sub    $0x28,%rsp
  8012c7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012cb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012cf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8012d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8012db:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012e0:	74 3d                	je     80131f <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8012e2:	eb 1d                	jmp    801301 <strlcpy+0x42>
			*dst++ = *src++;
  8012e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012ec:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012f0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012f4:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8012f8:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012fc:	0f b6 12             	movzbl (%rdx),%edx
  8012ff:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  801301:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801306:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80130b:	74 0b                	je     801318 <strlcpy+0x59>
  80130d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801311:	0f b6 00             	movzbl (%rax),%eax
  801314:	84 c0                	test   %al,%al
  801316:	75 cc                	jne    8012e4 <strlcpy+0x25>
		*dst = '\0';
  801318:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131c:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80131f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801323:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801327:	48 29 c2             	sub    %rax,%rdx
  80132a:	48 89 d0             	mov    %rdx,%rax
}
  80132d:	c9                   	leaveq 
  80132e:	c3                   	retq   

000000000080132f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80132f:	55                   	push   %rbp
  801330:	48 89 e5             	mov    %rsp,%rbp
  801333:	48 83 ec 10          	sub    $0x10,%rsp
  801337:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80133b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80133f:	eb 0a                	jmp    80134b <strcmp+0x1c>
		p++, q++;
  801341:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801346:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  80134b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134f:	0f b6 00             	movzbl (%rax),%eax
  801352:	84 c0                	test   %al,%al
  801354:	74 12                	je     801368 <strcmp+0x39>
  801356:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135a:	0f b6 10             	movzbl (%rax),%edx
  80135d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801361:	0f b6 00             	movzbl (%rax),%eax
  801364:	38 c2                	cmp    %al,%dl
  801366:	74 d9                	je     801341 <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801368:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136c:	0f b6 00             	movzbl (%rax),%eax
  80136f:	0f b6 d0             	movzbl %al,%edx
  801372:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801376:	0f b6 00             	movzbl (%rax),%eax
  801379:	0f b6 c0             	movzbl %al,%eax
  80137c:	29 c2                	sub    %eax,%edx
  80137e:	89 d0                	mov    %edx,%eax
}
  801380:	c9                   	leaveq 
  801381:	c3                   	retq   

0000000000801382 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801382:	55                   	push   %rbp
  801383:	48 89 e5             	mov    %rsp,%rbp
  801386:	48 83 ec 18          	sub    $0x18,%rsp
  80138a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80138e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801392:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801396:	eb 0f                	jmp    8013a7 <strncmp+0x25>
		n--, p++, q++;
  801398:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80139d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013a2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  8013a7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013ac:	74 1d                	je     8013cb <strncmp+0x49>
  8013ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b2:	0f b6 00             	movzbl (%rax),%eax
  8013b5:	84 c0                	test   %al,%al
  8013b7:	74 12                	je     8013cb <strncmp+0x49>
  8013b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bd:	0f b6 10             	movzbl (%rax),%edx
  8013c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c4:	0f b6 00             	movzbl (%rax),%eax
  8013c7:	38 c2                	cmp    %al,%dl
  8013c9:	74 cd                	je     801398 <strncmp+0x16>
	if (n == 0)
  8013cb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013d0:	75 07                	jne    8013d9 <strncmp+0x57>
		return 0;
  8013d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d7:	eb 18                	jmp    8013f1 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013dd:	0f b6 00             	movzbl (%rax),%eax
  8013e0:	0f b6 d0             	movzbl %al,%edx
  8013e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e7:	0f b6 00             	movzbl (%rax),%eax
  8013ea:	0f b6 c0             	movzbl %al,%eax
  8013ed:	29 c2                	sub    %eax,%edx
  8013ef:	89 d0                	mov    %edx,%eax
}
  8013f1:	c9                   	leaveq 
  8013f2:	c3                   	retq   

00000000008013f3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013f3:	55                   	push   %rbp
  8013f4:	48 89 e5             	mov    %rsp,%rbp
  8013f7:	48 83 ec 10          	sub    $0x10,%rsp
  8013fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013ff:	89 f0                	mov    %esi,%eax
  801401:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801404:	eb 17                	jmp    80141d <strchr+0x2a>
		if (*s == c)
  801406:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80140a:	0f b6 00             	movzbl (%rax),%eax
  80140d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801410:	75 06                	jne    801418 <strchr+0x25>
			return (char *) s;
  801412:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801416:	eb 15                	jmp    80142d <strchr+0x3a>
	for (; *s; s++)
  801418:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80141d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801421:	0f b6 00             	movzbl (%rax),%eax
  801424:	84 c0                	test   %al,%al
  801426:	75 de                	jne    801406 <strchr+0x13>
	return 0;
  801428:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80142d:	c9                   	leaveq 
  80142e:	c3                   	retq   

000000000080142f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80142f:	55                   	push   %rbp
  801430:	48 89 e5             	mov    %rsp,%rbp
  801433:	48 83 ec 10          	sub    $0x10,%rsp
  801437:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80143b:	89 f0                	mov    %esi,%eax
  80143d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801440:	eb 13                	jmp    801455 <strfind+0x26>
		if (*s == c)
  801442:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801446:	0f b6 00             	movzbl (%rax),%eax
  801449:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80144c:	75 02                	jne    801450 <strfind+0x21>
			break;
  80144e:	eb 10                	jmp    801460 <strfind+0x31>
	for (; *s; s++)
  801450:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801455:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801459:	0f b6 00             	movzbl (%rax),%eax
  80145c:	84 c0                	test   %al,%al
  80145e:	75 e2                	jne    801442 <strfind+0x13>
	return (char *) s;
  801460:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801464:	c9                   	leaveq 
  801465:	c3                   	retq   

0000000000801466 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801466:	55                   	push   %rbp
  801467:	48 89 e5             	mov    %rsp,%rbp
  80146a:	48 83 ec 18          	sub    $0x18,%rsp
  80146e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801472:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801475:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801479:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80147e:	75 06                	jne    801486 <memset+0x20>
		return v;
  801480:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801484:	eb 69                	jmp    8014ef <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801486:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148a:	83 e0 03             	and    $0x3,%eax
  80148d:	48 85 c0             	test   %rax,%rax
  801490:	75 48                	jne    8014da <memset+0x74>
  801492:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801496:	83 e0 03             	and    $0x3,%eax
  801499:	48 85 c0             	test   %rax,%rax
  80149c:	75 3c                	jne    8014da <memset+0x74>
		c &= 0xFF;
  80149e:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014a5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014a8:	c1 e0 18             	shl    $0x18,%eax
  8014ab:	89 c2                	mov    %eax,%edx
  8014ad:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014b0:	c1 e0 10             	shl    $0x10,%eax
  8014b3:	09 c2                	or     %eax,%edx
  8014b5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014b8:	c1 e0 08             	shl    $0x8,%eax
  8014bb:	09 d0                	or     %edx,%eax
  8014bd:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8014c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c4:	48 c1 e8 02          	shr    $0x2,%rax
  8014c8:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  8014cb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014cf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014d2:	48 89 d7             	mov    %rdx,%rdi
  8014d5:	fc                   	cld    
  8014d6:	f3 ab                	rep stos %eax,%es:(%rdi)
  8014d8:	eb 11                	jmp    8014eb <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8014da:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014e1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8014e5:	48 89 d7             	mov    %rdx,%rdi
  8014e8:	fc                   	cld    
  8014e9:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8014eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014ef:	c9                   	leaveq 
  8014f0:	c3                   	retq   

00000000008014f1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8014f1:	55                   	push   %rbp
  8014f2:	48 89 e5             	mov    %rsp,%rbp
  8014f5:	48 83 ec 28          	sub    $0x28,%rsp
  8014f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014fd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801501:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801505:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801509:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80150d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801511:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801515:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801519:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80151d:	0f 83 88 00 00 00    	jae    8015ab <memmove+0xba>
  801523:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801527:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152b:	48 01 d0             	add    %rdx,%rax
  80152e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801532:	76 77                	jbe    8015ab <memmove+0xba>
		s += n;
  801534:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801538:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80153c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801540:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801544:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801548:	83 e0 03             	and    $0x3,%eax
  80154b:	48 85 c0             	test   %rax,%rax
  80154e:	75 3b                	jne    80158b <memmove+0x9a>
  801550:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801554:	83 e0 03             	and    $0x3,%eax
  801557:	48 85 c0             	test   %rax,%rax
  80155a:	75 2f                	jne    80158b <memmove+0x9a>
  80155c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801560:	83 e0 03             	and    $0x3,%eax
  801563:	48 85 c0             	test   %rax,%rax
  801566:	75 23                	jne    80158b <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801568:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80156c:	48 83 e8 04          	sub    $0x4,%rax
  801570:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801574:	48 83 ea 04          	sub    $0x4,%rdx
  801578:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80157c:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  801580:	48 89 c7             	mov    %rax,%rdi
  801583:	48 89 d6             	mov    %rdx,%rsi
  801586:	fd                   	std    
  801587:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801589:	eb 1d                	jmp    8015a8 <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80158b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80158f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801593:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801597:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  80159b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159f:	48 89 d7             	mov    %rdx,%rdi
  8015a2:	48 89 c1             	mov    %rax,%rcx
  8015a5:	fd                   	std    
  8015a6:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015a8:	fc                   	cld    
  8015a9:	eb 57                	jmp    801602 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015af:	83 e0 03             	and    $0x3,%eax
  8015b2:	48 85 c0             	test   %rax,%rax
  8015b5:	75 36                	jne    8015ed <memmove+0xfc>
  8015b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015bb:	83 e0 03             	and    $0x3,%eax
  8015be:	48 85 c0             	test   %rax,%rax
  8015c1:	75 2a                	jne    8015ed <memmove+0xfc>
  8015c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c7:	83 e0 03             	and    $0x3,%eax
  8015ca:	48 85 c0             	test   %rax,%rax
  8015cd:	75 1e                	jne    8015ed <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d3:	48 c1 e8 02          	shr    $0x2,%rax
  8015d7:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  8015da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015de:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015e2:	48 89 c7             	mov    %rax,%rdi
  8015e5:	48 89 d6             	mov    %rdx,%rsi
  8015e8:	fc                   	cld    
  8015e9:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015eb:	eb 15                	jmp    801602 <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  8015ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015f5:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015f9:	48 89 c7             	mov    %rax,%rdi
  8015fc:	48 89 d6             	mov    %rdx,%rsi
  8015ff:	fc                   	cld    
  801600:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801602:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801606:	c9                   	leaveq 
  801607:	c3                   	retq   

0000000000801608 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801608:	55                   	push   %rbp
  801609:	48 89 e5             	mov    %rsp,%rbp
  80160c:	48 83 ec 18          	sub    $0x18,%rsp
  801610:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801614:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801618:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80161c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801620:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801624:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801628:	48 89 ce             	mov    %rcx,%rsi
  80162b:	48 89 c7             	mov    %rax,%rdi
  80162e:	48 b8 f1 14 80 00 00 	movabs $0x8014f1,%rax
  801635:	00 00 00 
  801638:	ff d0                	callq  *%rax
}
  80163a:	c9                   	leaveq 
  80163b:	c3                   	retq   

000000000080163c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80163c:	55                   	push   %rbp
  80163d:	48 89 e5             	mov    %rsp,%rbp
  801640:	48 83 ec 28          	sub    $0x28,%rsp
  801644:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801648:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80164c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801650:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801654:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801658:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80165c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801660:	eb 36                	jmp    801698 <memcmp+0x5c>
		if (*s1 != *s2)
  801662:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801666:	0f b6 10             	movzbl (%rax),%edx
  801669:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80166d:	0f b6 00             	movzbl (%rax),%eax
  801670:	38 c2                	cmp    %al,%dl
  801672:	74 1a                	je     80168e <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801674:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801678:	0f b6 00             	movzbl (%rax),%eax
  80167b:	0f b6 d0             	movzbl %al,%edx
  80167e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801682:	0f b6 00             	movzbl (%rax),%eax
  801685:	0f b6 c0             	movzbl %al,%eax
  801688:	29 c2                	sub    %eax,%edx
  80168a:	89 d0                	mov    %edx,%eax
  80168c:	eb 20                	jmp    8016ae <memcmp+0x72>
		s1++, s2++;
  80168e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801693:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  801698:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016a4:	48 85 c0             	test   %rax,%rax
  8016a7:	75 b9                	jne    801662 <memcmp+0x26>
	}

	return 0;
  8016a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ae:	c9                   	leaveq 
  8016af:	c3                   	retq   

00000000008016b0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016b0:	55                   	push   %rbp
  8016b1:	48 89 e5             	mov    %rsp,%rbp
  8016b4:	48 83 ec 28          	sub    $0x28,%rsp
  8016b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016bc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8016bf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8016c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cb:	48 01 d0             	add    %rdx,%rax
  8016ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8016d2:	eb 15                	jmp    8016e9 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016d8:	0f b6 00             	movzbl (%rax),%eax
  8016db:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8016de:	38 d0                	cmp    %dl,%al
  8016e0:	75 02                	jne    8016e4 <memfind+0x34>
			break;
  8016e2:	eb 0f                	jmp    8016f3 <memfind+0x43>
	for (; s < ends; s++)
  8016e4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ed:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8016f1:	72 e1                	jb     8016d4 <memfind+0x24>
	return (void *) s;
  8016f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016f7:	c9                   	leaveq 
  8016f8:	c3                   	retq   

00000000008016f9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016f9:	55                   	push   %rbp
  8016fa:	48 89 e5             	mov    %rsp,%rbp
  8016fd:	48 83 ec 38          	sub    $0x38,%rsp
  801701:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801705:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801709:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80170c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801713:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80171a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80171b:	eb 05                	jmp    801722 <strtol+0x29>
		s++;
  80171d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  801722:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801726:	0f b6 00             	movzbl (%rax),%eax
  801729:	3c 20                	cmp    $0x20,%al
  80172b:	74 f0                	je     80171d <strtol+0x24>
  80172d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801731:	0f b6 00             	movzbl (%rax),%eax
  801734:	3c 09                	cmp    $0x9,%al
  801736:	74 e5                	je     80171d <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  801738:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173c:	0f b6 00             	movzbl (%rax),%eax
  80173f:	3c 2b                	cmp    $0x2b,%al
  801741:	75 07                	jne    80174a <strtol+0x51>
		s++;
  801743:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801748:	eb 17                	jmp    801761 <strtol+0x68>
	else if (*s == '-')
  80174a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174e:	0f b6 00             	movzbl (%rax),%eax
  801751:	3c 2d                	cmp    $0x2d,%al
  801753:	75 0c                	jne    801761 <strtol+0x68>
		s++, neg = 1;
  801755:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80175a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801761:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801765:	74 06                	je     80176d <strtol+0x74>
  801767:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80176b:	75 28                	jne    801795 <strtol+0x9c>
  80176d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801771:	0f b6 00             	movzbl (%rax),%eax
  801774:	3c 30                	cmp    $0x30,%al
  801776:	75 1d                	jne    801795 <strtol+0x9c>
  801778:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177c:	48 83 c0 01          	add    $0x1,%rax
  801780:	0f b6 00             	movzbl (%rax),%eax
  801783:	3c 78                	cmp    $0x78,%al
  801785:	75 0e                	jne    801795 <strtol+0x9c>
		s += 2, base = 16;
  801787:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80178c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801793:	eb 2c                	jmp    8017c1 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801795:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801799:	75 19                	jne    8017b4 <strtol+0xbb>
  80179b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179f:	0f b6 00             	movzbl (%rax),%eax
  8017a2:	3c 30                	cmp    $0x30,%al
  8017a4:	75 0e                	jne    8017b4 <strtol+0xbb>
		s++, base = 8;
  8017a6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017ab:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017b2:	eb 0d                	jmp    8017c1 <strtol+0xc8>
	else if (base == 0)
  8017b4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017b8:	75 07                	jne    8017c1 <strtol+0xc8>
		base = 10;
  8017ba:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c5:	0f b6 00             	movzbl (%rax),%eax
  8017c8:	3c 2f                	cmp    $0x2f,%al
  8017ca:	7e 1d                	jle    8017e9 <strtol+0xf0>
  8017cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d0:	0f b6 00             	movzbl (%rax),%eax
  8017d3:	3c 39                	cmp    $0x39,%al
  8017d5:	7f 12                	jg     8017e9 <strtol+0xf0>
			dig = *s - '0';
  8017d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017db:	0f b6 00             	movzbl (%rax),%eax
  8017de:	0f be c0             	movsbl %al,%eax
  8017e1:	83 e8 30             	sub    $0x30,%eax
  8017e4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017e7:	eb 4e                	jmp    801837 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8017e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ed:	0f b6 00             	movzbl (%rax),%eax
  8017f0:	3c 60                	cmp    $0x60,%al
  8017f2:	7e 1d                	jle    801811 <strtol+0x118>
  8017f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f8:	0f b6 00             	movzbl (%rax),%eax
  8017fb:	3c 7a                	cmp    $0x7a,%al
  8017fd:	7f 12                	jg     801811 <strtol+0x118>
			dig = *s - 'a' + 10;
  8017ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801803:	0f b6 00             	movzbl (%rax),%eax
  801806:	0f be c0             	movsbl %al,%eax
  801809:	83 e8 57             	sub    $0x57,%eax
  80180c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80180f:	eb 26                	jmp    801837 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801811:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801815:	0f b6 00             	movzbl (%rax),%eax
  801818:	3c 40                	cmp    $0x40,%al
  80181a:	7e 48                	jle    801864 <strtol+0x16b>
  80181c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801820:	0f b6 00             	movzbl (%rax),%eax
  801823:	3c 5a                	cmp    $0x5a,%al
  801825:	7f 3d                	jg     801864 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801827:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182b:	0f b6 00             	movzbl (%rax),%eax
  80182e:	0f be c0             	movsbl %al,%eax
  801831:	83 e8 37             	sub    $0x37,%eax
  801834:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801837:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80183a:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80183d:	7c 02                	jl     801841 <strtol+0x148>
			break;
  80183f:	eb 23                	jmp    801864 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801841:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801846:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801849:	48 98                	cltq   
  80184b:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801850:	48 89 c2             	mov    %rax,%rdx
  801853:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801856:	48 98                	cltq   
  801858:	48 01 d0             	add    %rdx,%rax
  80185b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80185f:	e9 5d ff ff ff       	jmpq   8017c1 <strtol+0xc8>

	if (endptr)
  801864:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801869:	74 0b                	je     801876 <strtol+0x17d>
		*endptr = (char *) s;
  80186b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80186f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801873:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801876:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80187a:	74 09                	je     801885 <strtol+0x18c>
  80187c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801880:	48 f7 d8             	neg    %rax
  801883:	eb 04                	jmp    801889 <strtol+0x190>
  801885:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801889:	c9                   	leaveq 
  80188a:	c3                   	retq   

000000000080188b <strstr>:

char * strstr(const char *in, const char *str)
{
  80188b:	55                   	push   %rbp
  80188c:	48 89 e5             	mov    %rsp,%rbp
  80188f:	48 83 ec 30          	sub    $0x30,%rsp
  801893:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801897:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80189b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80189f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018a3:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018a7:	0f b6 00             	movzbl (%rax),%eax
  8018aa:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8018ad:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018b1:	75 06                	jne    8018b9 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8018b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b7:	eb 6b                	jmp    801924 <strstr+0x99>

	len = strlen(str);
  8018b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018bd:	48 89 c7             	mov    %rax,%rdi
  8018c0:	48 b8 61 11 80 00 00 	movabs $0x801161,%rax
  8018c7:	00 00 00 
  8018ca:	ff d0                	callq  *%rax
  8018cc:	48 98                	cltq   
  8018ce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8018d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018de:	0f b6 00             	movzbl (%rax),%eax
  8018e1:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8018e4:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8018e8:	75 07                	jne    8018f1 <strstr+0x66>
				return (char *) 0;
  8018ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ef:	eb 33                	jmp    801924 <strstr+0x99>
		} while (sc != c);
  8018f1:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8018f5:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8018f8:	75 d8                	jne    8018d2 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8018fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018fe:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801902:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801906:	48 89 ce             	mov    %rcx,%rsi
  801909:	48 89 c7             	mov    %rax,%rdi
  80190c:	48 b8 82 13 80 00 00 	movabs $0x801382,%rax
  801913:	00 00 00 
  801916:	ff d0                	callq  *%rax
  801918:	85 c0                	test   %eax,%eax
  80191a:	75 b6                	jne    8018d2 <strstr+0x47>

	return (char *) (in - 1);
  80191c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801920:	48 83 e8 01          	sub    $0x1,%rax
}
  801924:	c9                   	leaveq 
  801925:	c3                   	retq   

0000000000801926 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801926:	55                   	push   %rbp
  801927:	48 89 e5             	mov    %rsp,%rbp
  80192a:	53                   	push   %rbx
  80192b:	48 83 ec 48          	sub    $0x48,%rsp
  80192f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801932:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801935:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801939:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80193d:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801941:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801945:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801948:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80194c:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801950:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801954:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801958:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80195c:	4c 89 c3             	mov    %r8,%rbx
  80195f:	cd 30                	int    $0x30
  801961:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801965:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801969:	74 3e                	je     8019a9 <syscall+0x83>
  80196b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801970:	7e 37                	jle    8019a9 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801972:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801976:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801979:	49 89 d0             	mov    %rdx,%r8
  80197c:	89 c1                	mov    %eax,%ecx
  80197e:	48 ba 08 46 80 00 00 	movabs $0x804608,%rdx
  801985:	00 00 00 
  801988:	be 23 00 00 00       	mov    $0x23,%esi
  80198d:	48 bf 25 46 80 00 00 	movabs $0x804625,%rdi
  801994:	00 00 00 
  801997:	b8 00 00 00 00       	mov    $0x0,%eax
  80199c:	49 b9 fa 03 80 00 00 	movabs $0x8003fa,%r9
  8019a3:	00 00 00 
  8019a6:	41 ff d1             	callq  *%r9

	return ret;
  8019a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019ad:	48 83 c4 48          	add    $0x48,%rsp
  8019b1:	5b                   	pop    %rbx
  8019b2:	5d                   	pop    %rbp
  8019b3:	c3                   	retq   

00000000008019b4 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019b4:	55                   	push   %rbp
  8019b5:	48 89 e5             	mov    %rsp,%rbp
  8019b8:	48 83 ec 10          	sub    $0x10,%rsp
  8019bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8019c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019cc:	48 83 ec 08          	sub    $0x8,%rsp
  8019d0:	6a 00                	pushq  $0x0
  8019d2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019de:	48 89 d1             	mov    %rdx,%rcx
  8019e1:	48 89 c2             	mov    %rax,%rdx
  8019e4:	be 00 00 00 00       	mov    $0x0,%esi
  8019e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8019ee:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  8019f5:	00 00 00 
  8019f8:	ff d0                	callq  *%rax
  8019fa:	48 83 c4 10          	add    $0x10,%rsp
}
  8019fe:	c9                   	leaveq 
  8019ff:	c3                   	retq   

0000000000801a00 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a00:	55                   	push   %rbp
  801a01:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a04:	48 83 ec 08          	sub    $0x8,%rsp
  801a08:	6a 00                	pushq  $0x0
  801a0a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a10:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a16:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a1b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a20:	be 00 00 00 00       	mov    $0x0,%esi
  801a25:	bf 01 00 00 00       	mov    $0x1,%edi
  801a2a:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  801a31:	00 00 00 
  801a34:	ff d0                	callq  *%rax
  801a36:	48 83 c4 10          	add    $0x10,%rsp
}
  801a3a:	c9                   	leaveq 
  801a3b:	c3                   	retq   

0000000000801a3c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a3c:	55                   	push   %rbp
  801a3d:	48 89 e5             	mov    %rsp,%rbp
  801a40:	48 83 ec 10          	sub    $0x10,%rsp
  801a44:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a4a:	48 98                	cltq   
  801a4c:	48 83 ec 08          	sub    $0x8,%rsp
  801a50:	6a 00                	pushq  $0x0
  801a52:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a58:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a5e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a63:	48 89 c2             	mov    %rax,%rdx
  801a66:	be 01 00 00 00       	mov    $0x1,%esi
  801a6b:	bf 03 00 00 00       	mov    $0x3,%edi
  801a70:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  801a77:	00 00 00 
  801a7a:	ff d0                	callq  *%rax
  801a7c:	48 83 c4 10          	add    $0x10,%rsp
}
  801a80:	c9                   	leaveq 
  801a81:	c3                   	retq   

0000000000801a82 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a82:	55                   	push   %rbp
  801a83:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a86:	48 83 ec 08          	sub    $0x8,%rsp
  801a8a:	6a 00                	pushq  $0x0
  801a8c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a92:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a98:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a9d:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa2:	be 00 00 00 00       	mov    $0x0,%esi
  801aa7:	bf 02 00 00 00       	mov    $0x2,%edi
  801aac:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  801ab3:	00 00 00 
  801ab6:	ff d0                	callq  *%rax
  801ab8:	48 83 c4 10          	add    $0x10,%rsp
}
  801abc:	c9                   	leaveq 
  801abd:	c3                   	retq   

0000000000801abe <sys_yield>:

void
sys_yield(void)
{
  801abe:	55                   	push   %rbp
  801abf:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801ac2:	48 83 ec 08          	sub    $0x8,%rsp
  801ac6:	6a 00                	pushq  $0x0
  801ac8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ace:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ad4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ad9:	ba 00 00 00 00       	mov    $0x0,%edx
  801ade:	be 00 00 00 00       	mov    $0x0,%esi
  801ae3:	bf 0b 00 00 00       	mov    $0xb,%edi
  801ae8:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  801aef:	00 00 00 
  801af2:	ff d0                	callq  *%rax
  801af4:	48 83 c4 10          	add    $0x10,%rsp
}
  801af8:	c9                   	leaveq 
  801af9:	c3                   	retq   

0000000000801afa <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801afa:	55                   	push   %rbp
  801afb:	48 89 e5             	mov    %rsp,%rbp
  801afe:	48 83 ec 10          	sub    $0x10,%rsp
  801b02:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b05:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b09:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b0c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b0f:	48 63 c8             	movslq %eax,%rcx
  801b12:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b19:	48 98                	cltq   
  801b1b:	48 83 ec 08          	sub    $0x8,%rsp
  801b1f:	6a 00                	pushq  $0x0
  801b21:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b27:	49 89 c8             	mov    %rcx,%r8
  801b2a:	48 89 d1             	mov    %rdx,%rcx
  801b2d:	48 89 c2             	mov    %rax,%rdx
  801b30:	be 01 00 00 00       	mov    $0x1,%esi
  801b35:	bf 04 00 00 00       	mov    $0x4,%edi
  801b3a:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  801b41:	00 00 00 
  801b44:	ff d0                	callq  *%rax
  801b46:	48 83 c4 10          	add    $0x10,%rsp
}
  801b4a:	c9                   	leaveq 
  801b4b:	c3                   	retq   

0000000000801b4c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b4c:	55                   	push   %rbp
  801b4d:	48 89 e5             	mov    %rsp,%rbp
  801b50:	48 83 ec 20          	sub    $0x20,%rsp
  801b54:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b57:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b5b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b5e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b62:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b66:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b69:	48 63 c8             	movslq %eax,%rcx
  801b6c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b70:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b73:	48 63 f0             	movslq %eax,%rsi
  801b76:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b7d:	48 98                	cltq   
  801b7f:	48 83 ec 08          	sub    $0x8,%rsp
  801b83:	51                   	push   %rcx
  801b84:	49 89 f9             	mov    %rdi,%r9
  801b87:	49 89 f0             	mov    %rsi,%r8
  801b8a:	48 89 d1             	mov    %rdx,%rcx
  801b8d:	48 89 c2             	mov    %rax,%rdx
  801b90:	be 01 00 00 00       	mov    $0x1,%esi
  801b95:	bf 05 00 00 00       	mov    $0x5,%edi
  801b9a:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  801ba1:	00 00 00 
  801ba4:	ff d0                	callq  *%rax
  801ba6:	48 83 c4 10          	add    $0x10,%rsp
}
  801baa:	c9                   	leaveq 
  801bab:	c3                   	retq   

0000000000801bac <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bac:	55                   	push   %rbp
  801bad:	48 89 e5             	mov    %rsp,%rbp
  801bb0:	48 83 ec 10          	sub    $0x10,%rsp
  801bb4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bb7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801bbb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc2:	48 98                	cltq   
  801bc4:	48 83 ec 08          	sub    $0x8,%rsp
  801bc8:	6a 00                	pushq  $0x0
  801bca:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bd6:	48 89 d1             	mov    %rdx,%rcx
  801bd9:	48 89 c2             	mov    %rax,%rdx
  801bdc:	be 01 00 00 00       	mov    $0x1,%esi
  801be1:	bf 06 00 00 00       	mov    $0x6,%edi
  801be6:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  801bed:	00 00 00 
  801bf0:	ff d0                	callq  *%rax
  801bf2:	48 83 c4 10          	add    $0x10,%rsp
}
  801bf6:	c9                   	leaveq 
  801bf7:	c3                   	retq   

0000000000801bf8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801bf8:	55                   	push   %rbp
  801bf9:	48 89 e5             	mov    %rsp,%rbp
  801bfc:	48 83 ec 10          	sub    $0x10,%rsp
  801c00:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c03:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c06:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c09:	48 63 d0             	movslq %eax,%rdx
  801c0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c0f:	48 98                	cltq   
  801c11:	48 83 ec 08          	sub    $0x8,%rsp
  801c15:	6a 00                	pushq  $0x0
  801c17:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c1d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c23:	48 89 d1             	mov    %rdx,%rcx
  801c26:	48 89 c2             	mov    %rax,%rdx
  801c29:	be 01 00 00 00       	mov    $0x1,%esi
  801c2e:	bf 08 00 00 00       	mov    $0x8,%edi
  801c33:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  801c3a:	00 00 00 
  801c3d:	ff d0                	callq  *%rax
  801c3f:	48 83 c4 10          	add    $0x10,%rsp
}
  801c43:	c9                   	leaveq 
  801c44:	c3                   	retq   

0000000000801c45 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c45:	55                   	push   %rbp
  801c46:	48 89 e5             	mov    %rsp,%rbp
  801c49:	48 83 ec 10          	sub    $0x10,%rsp
  801c4d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c50:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c54:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c5b:	48 98                	cltq   
  801c5d:	48 83 ec 08          	sub    $0x8,%rsp
  801c61:	6a 00                	pushq  $0x0
  801c63:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c69:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c6f:	48 89 d1             	mov    %rdx,%rcx
  801c72:	48 89 c2             	mov    %rax,%rdx
  801c75:	be 01 00 00 00       	mov    $0x1,%esi
  801c7a:	bf 09 00 00 00       	mov    $0x9,%edi
  801c7f:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  801c86:	00 00 00 
  801c89:	ff d0                	callq  *%rax
  801c8b:	48 83 c4 10          	add    $0x10,%rsp
}
  801c8f:	c9                   	leaveq 
  801c90:	c3                   	retq   

0000000000801c91 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c91:	55                   	push   %rbp
  801c92:	48 89 e5             	mov    %rsp,%rbp
  801c95:	48 83 ec 10          	sub    $0x10,%rsp
  801c99:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c9c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ca0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ca4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ca7:	48 98                	cltq   
  801ca9:	48 83 ec 08          	sub    $0x8,%rsp
  801cad:	6a 00                	pushq  $0x0
  801caf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cb5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cbb:	48 89 d1             	mov    %rdx,%rcx
  801cbe:	48 89 c2             	mov    %rax,%rdx
  801cc1:	be 01 00 00 00       	mov    $0x1,%esi
  801cc6:	bf 0a 00 00 00       	mov    $0xa,%edi
  801ccb:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  801cd2:	00 00 00 
  801cd5:	ff d0                	callq  *%rax
  801cd7:	48 83 c4 10          	add    $0x10,%rsp
}
  801cdb:	c9                   	leaveq 
  801cdc:	c3                   	retq   

0000000000801cdd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801cdd:	55                   	push   %rbp
  801cde:	48 89 e5             	mov    %rsp,%rbp
  801ce1:	48 83 ec 20          	sub    $0x20,%rsp
  801ce5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ce8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cec:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801cf0:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801cf3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cf6:	48 63 f0             	movslq %eax,%rsi
  801cf9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801cfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d00:	48 98                	cltq   
  801d02:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d06:	48 83 ec 08          	sub    $0x8,%rsp
  801d0a:	6a 00                	pushq  $0x0
  801d0c:	49 89 f1             	mov    %rsi,%r9
  801d0f:	49 89 c8             	mov    %rcx,%r8
  801d12:	48 89 d1             	mov    %rdx,%rcx
  801d15:	48 89 c2             	mov    %rax,%rdx
  801d18:	be 00 00 00 00       	mov    $0x0,%esi
  801d1d:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d22:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  801d29:	00 00 00 
  801d2c:	ff d0                	callq  *%rax
  801d2e:	48 83 c4 10          	add    $0x10,%rsp
}
  801d32:	c9                   	leaveq 
  801d33:	c3                   	retq   

0000000000801d34 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d34:	55                   	push   %rbp
  801d35:	48 89 e5             	mov    %rsp,%rbp
  801d38:	48 83 ec 10          	sub    $0x10,%rsp
  801d3c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d44:	48 83 ec 08          	sub    $0x8,%rsp
  801d48:	6a 00                	pushq  $0x0
  801d4a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d50:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d56:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d5b:	48 89 c2             	mov    %rax,%rdx
  801d5e:	be 01 00 00 00       	mov    $0x1,%esi
  801d63:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d68:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  801d6f:	00 00 00 
  801d72:	ff d0                	callq  *%rax
  801d74:	48 83 c4 10          	add    $0x10,%rsp
}
  801d78:	c9                   	leaveq 
  801d79:	c3                   	retq   

0000000000801d7a <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801d7a:	55                   	push   %rbp
  801d7b:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801d7e:	48 83 ec 08          	sub    $0x8,%rsp
  801d82:	6a 00                	pushq  $0x0
  801d84:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d8a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d90:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d95:	ba 00 00 00 00       	mov    $0x0,%edx
  801d9a:	be 00 00 00 00       	mov    $0x0,%esi
  801d9f:	bf 0e 00 00 00       	mov    $0xe,%edi
  801da4:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  801dab:	00 00 00 
  801dae:	ff d0                	callq  *%rax
  801db0:	48 83 c4 10          	add    $0x10,%rsp
}
  801db4:	c9                   	leaveq 
  801db5:	c3                   	retq   

0000000000801db6 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801db6:	55                   	push   %rbp
  801db7:	48 89 e5             	mov    %rsp,%rbp
  801dba:	48 83 ec 20          	sub    $0x20,%rsp
  801dbe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dc1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801dc5:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801dc8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801dcc:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801dd0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801dd3:	48 63 c8             	movslq %eax,%rcx
  801dd6:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801dda:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ddd:	48 63 f0             	movslq %eax,%rsi
  801de0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801de4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801de7:	48 98                	cltq   
  801de9:	48 83 ec 08          	sub    $0x8,%rsp
  801ded:	51                   	push   %rcx
  801dee:	49 89 f9             	mov    %rdi,%r9
  801df1:	49 89 f0             	mov    %rsi,%r8
  801df4:	48 89 d1             	mov    %rdx,%rcx
  801df7:	48 89 c2             	mov    %rax,%rdx
  801dfa:	be 00 00 00 00       	mov    $0x0,%esi
  801dff:	bf 0f 00 00 00       	mov    $0xf,%edi
  801e04:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  801e0b:	00 00 00 
  801e0e:	ff d0                	callq  *%rax
  801e10:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801e14:	c9                   	leaveq 
  801e15:	c3                   	retq   

0000000000801e16 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801e16:	55                   	push   %rbp
  801e17:	48 89 e5             	mov    %rsp,%rbp
  801e1a:	48 83 ec 10          	sub    $0x10,%rsp
  801e1e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e22:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801e26:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e2e:	48 83 ec 08          	sub    $0x8,%rsp
  801e32:	6a 00                	pushq  $0x0
  801e34:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e3a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e40:	48 89 d1             	mov    %rdx,%rcx
  801e43:	48 89 c2             	mov    %rax,%rdx
  801e46:	be 00 00 00 00       	mov    $0x0,%esi
  801e4b:	bf 10 00 00 00       	mov    $0x10,%edi
  801e50:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  801e57:	00 00 00 
  801e5a:	ff d0                	callq  *%rax
  801e5c:	48 83 c4 10          	add    $0x10,%rsp
}
  801e60:	c9                   	leaveq 
  801e61:	c3                   	retq   

0000000000801e62 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801e62:	55                   	push   %rbp
  801e63:	48 89 e5             	mov    %rsp,%rbp
  801e66:	48 83 ec 08          	sub    $0x8,%rsp
  801e6a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e6e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e72:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801e79:	ff ff ff 
  801e7c:	48 01 d0             	add    %rdx,%rax
  801e7f:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801e83:	c9                   	leaveq 
  801e84:	c3                   	retq   

0000000000801e85 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e85:	55                   	push   %rbp
  801e86:	48 89 e5             	mov    %rsp,%rbp
  801e89:	48 83 ec 08          	sub    $0x8,%rsp
  801e8d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801e91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e95:	48 89 c7             	mov    %rax,%rdi
  801e98:	48 b8 62 1e 80 00 00 	movabs $0x801e62,%rax
  801e9f:	00 00 00 
  801ea2:	ff d0                	callq  *%rax
  801ea4:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801eaa:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801eae:	c9                   	leaveq 
  801eaf:	c3                   	retq   

0000000000801eb0 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801eb0:	55                   	push   %rbp
  801eb1:	48 89 e5             	mov    %rsp,%rbp
  801eb4:	48 83 ec 18          	sub    $0x18,%rsp
  801eb8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ebc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ec3:	eb 6b                	jmp    801f30 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801ec5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ec8:	48 98                	cltq   
  801eca:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ed0:	48 c1 e0 0c          	shl    $0xc,%rax
  801ed4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801ed8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801edc:	48 c1 e8 15          	shr    $0x15,%rax
  801ee0:	48 89 c2             	mov    %rax,%rdx
  801ee3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801eea:	01 00 00 
  801eed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ef1:	83 e0 01             	and    $0x1,%eax
  801ef4:	48 85 c0             	test   %rax,%rax
  801ef7:	74 21                	je     801f1a <fd_alloc+0x6a>
  801ef9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801efd:	48 c1 e8 0c          	shr    $0xc,%rax
  801f01:	48 89 c2             	mov    %rax,%rdx
  801f04:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f0b:	01 00 00 
  801f0e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f12:	83 e0 01             	and    $0x1,%eax
  801f15:	48 85 c0             	test   %rax,%rax
  801f18:	75 12                	jne    801f2c <fd_alloc+0x7c>
			*fd_store = fd;
  801f1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f1e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f22:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f25:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2a:	eb 1a                	jmp    801f46 <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  801f2c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f30:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f34:	7e 8f                	jle    801ec5 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  801f36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f3a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801f41:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801f46:	c9                   	leaveq 
  801f47:	c3                   	retq   

0000000000801f48 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f48:	55                   	push   %rbp
  801f49:	48 89 e5             	mov    %rsp,%rbp
  801f4c:	48 83 ec 20          	sub    $0x20,%rsp
  801f50:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f53:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f57:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f5b:	78 06                	js     801f63 <fd_lookup+0x1b>
  801f5d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801f61:	7e 07                	jle    801f6a <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f63:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f68:	eb 6c                	jmp    801fd6 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801f6a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f6d:	48 98                	cltq   
  801f6f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f75:	48 c1 e0 0c          	shl    $0xc,%rax
  801f79:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f81:	48 c1 e8 15          	shr    $0x15,%rax
  801f85:	48 89 c2             	mov    %rax,%rdx
  801f88:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f8f:	01 00 00 
  801f92:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f96:	83 e0 01             	and    $0x1,%eax
  801f99:	48 85 c0             	test   %rax,%rax
  801f9c:	74 21                	je     801fbf <fd_lookup+0x77>
  801f9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fa2:	48 c1 e8 0c          	shr    $0xc,%rax
  801fa6:	48 89 c2             	mov    %rax,%rdx
  801fa9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fb0:	01 00 00 
  801fb3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fb7:	83 e0 01             	and    $0x1,%eax
  801fba:	48 85 c0             	test   %rax,%rax
  801fbd:	75 07                	jne    801fc6 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fbf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fc4:	eb 10                	jmp    801fd6 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801fc6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fca:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801fce:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801fd1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd6:	c9                   	leaveq 
  801fd7:	c3                   	retq   

0000000000801fd8 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801fd8:	55                   	push   %rbp
  801fd9:	48 89 e5             	mov    %rsp,%rbp
  801fdc:	48 83 ec 30          	sub    $0x30,%rsp
  801fe0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801fe4:	89 f0                	mov    %esi,%eax
  801fe6:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801fe9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fed:	48 89 c7             	mov    %rax,%rdi
  801ff0:	48 b8 62 1e 80 00 00 	movabs $0x801e62,%rax
  801ff7:	00 00 00 
  801ffa:	ff d0                	callq  *%rax
  801ffc:	89 c2                	mov    %eax,%edx
  801ffe:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802002:	48 89 c6             	mov    %rax,%rsi
  802005:	89 d7                	mov    %edx,%edi
  802007:	48 b8 48 1f 80 00 00 	movabs $0x801f48,%rax
  80200e:	00 00 00 
  802011:	ff d0                	callq  *%rax
  802013:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802016:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80201a:	78 0a                	js     802026 <fd_close+0x4e>
	    || fd != fd2)
  80201c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802020:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802024:	74 12                	je     802038 <fd_close+0x60>
		return (must_exist ? r : 0);
  802026:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80202a:	74 05                	je     802031 <fd_close+0x59>
  80202c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80202f:	eb 70                	jmp    8020a1 <fd_close+0xc9>
  802031:	b8 00 00 00 00       	mov    $0x0,%eax
  802036:	eb 69                	jmp    8020a1 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802038:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80203c:	8b 00                	mov    (%rax),%eax
  80203e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802042:	48 89 d6             	mov    %rdx,%rsi
  802045:	89 c7                	mov    %eax,%edi
  802047:	48 b8 a3 20 80 00 00 	movabs $0x8020a3,%rax
  80204e:	00 00 00 
  802051:	ff d0                	callq  *%rax
  802053:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802056:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80205a:	78 2a                	js     802086 <fd_close+0xae>
		if (dev->dev_close)
  80205c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802060:	48 8b 40 20          	mov    0x20(%rax),%rax
  802064:	48 85 c0             	test   %rax,%rax
  802067:	74 16                	je     80207f <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  802069:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80206d:	48 8b 40 20          	mov    0x20(%rax),%rax
  802071:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802075:	48 89 d7             	mov    %rdx,%rdi
  802078:	ff d0                	callq  *%rax
  80207a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80207d:	eb 07                	jmp    802086 <fd_close+0xae>
		else
			r = 0;
  80207f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802086:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80208a:	48 89 c6             	mov    %rax,%rsi
  80208d:	bf 00 00 00 00       	mov    $0x0,%edi
  802092:	48 b8 ac 1b 80 00 00 	movabs $0x801bac,%rax
  802099:	00 00 00 
  80209c:	ff d0                	callq  *%rax
	return r;
  80209e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020a1:	c9                   	leaveq 
  8020a2:	c3                   	retq   

00000000008020a3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8020a3:	55                   	push   %rbp
  8020a4:	48 89 e5             	mov    %rsp,%rbp
  8020a7:	48 83 ec 20          	sub    $0x20,%rsp
  8020ab:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8020b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020b9:	eb 41                	jmp    8020fc <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8020bb:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020c2:	00 00 00 
  8020c5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020c8:	48 63 d2             	movslq %edx,%rdx
  8020cb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020cf:	8b 00                	mov    (%rax),%eax
  8020d1:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8020d4:	75 22                	jne    8020f8 <dev_lookup+0x55>
			*dev = devtab[i];
  8020d6:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020dd:	00 00 00 
  8020e0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020e3:	48 63 d2             	movslq %edx,%rdx
  8020e6:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8020ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020ee:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8020f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f6:	eb 60                	jmp    802158 <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  8020f8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020fc:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802103:	00 00 00 
  802106:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802109:	48 63 d2             	movslq %edx,%rdx
  80210c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802110:	48 85 c0             	test   %rax,%rax
  802113:	75 a6                	jne    8020bb <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802115:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80211c:	00 00 00 
  80211f:	48 8b 00             	mov    (%rax),%rax
  802122:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802128:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80212b:	89 c6                	mov    %eax,%esi
  80212d:	48 bf 38 46 80 00 00 	movabs $0x804638,%rdi
  802134:	00 00 00 
  802137:	b8 00 00 00 00       	mov    $0x0,%eax
  80213c:	48 b9 33 06 80 00 00 	movabs $0x800633,%rcx
  802143:	00 00 00 
  802146:	ff d1                	callq  *%rcx
	*dev = 0;
  802148:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80214c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802153:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802158:	c9                   	leaveq 
  802159:	c3                   	retq   

000000000080215a <close>:

int
close(int fdnum)
{
  80215a:	55                   	push   %rbp
  80215b:	48 89 e5             	mov    %rsp,%rbp
  80215e:	48 83 ec 20          	sub    $0x20,%rsp
  802162:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802165:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802169:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80216c:	48 89 d6             	mov    %rdx,%rsi
  80216f:	89 c7                	mov    %eax,%edi
  802171:	48 b8 48 1f 80 00 00 	movabs $0x801f48,%rax
  802178:	00 00 00 
  80217b:	ff d0                	callq  *%rax
  80217d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802180:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802184:	79 05                	jns    80218b <close+0x31>
		return r;
  802186:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802189:	eb 18                	jmp    8021a3 <close+0x49>
	else
		return fd_close(fd, 1);
  80218b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80218f:	be 01 00 00 00       	mov    $0x1,%esi
  802194:	48 89 c7             	mov    %rax,%rdi
  802197:	48 b8 d8 1f 80 00 00 	movabs $0x801fd8,%rax
  80219e:	00 00 00 
  8021a1:	ff d0                	callq  *%rax
}
  8021a3:	c9                   	leaveq 
  8021a4:	c3                   	retq   

00000000008021a5 <close_all>:

void
close_all(void)
{
  8021a5:	55                   	push   %rbp
  8021a6:	48 89 e5             	mov    %rsp,%rbp
  8021a9:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8021ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021b4:	eb 15                	jmp    8021cb <close_all+0x26>
		close(i);
  8021b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021b9:	89 c7                	mov    %eax,%edi
  8021bb:	48 b8 5a 21 80 00 00 	movabs $0x80215a,%rax
  8021c2:	00 00 00 
  8021c5:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  8021c7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021cb:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8021cf:	7e e5                	jle    8021b6 <close_all+0x11>
}
  8021d1:	c9                   	leaveq 
  8021d2:	c3                   	retq   

00000000008021d3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8021d3:	55                   	push   %rbp
  8021d4:	48 89 e5             	mov    %rsp,%rbp
  8021d7:	48 83 ec 40          	sub    $0x40,%rsp
  8021db:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8021de:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8021e1:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8021e5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8021e8:	48 89 d6             	mov    %rdx,%rsi
  8021eb:	89 c7                	mov    %eax,%edi
  8021ed:	48 b8 48 1f 80 00 00 	movabs $0x801f48,%rax
  8021f4:	00 00 00 
  8021f7:	ff d0                	callq  *%rax
  8021f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802200:	79 08                	jns    80220a <dup+0x37>
		return r;
  802202:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802205:	e9 70 01 00 00       	jmpq   80237a <dup+0x1a7>
	close(newfdnum);
  80220a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80220d:	89 c7                	mov    %eax,%edi
  80220f:	48 b8 5a 21 80 00 00 	movabs $0x80215a,%rax
  802216:	00 00 00 
  802219:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80221b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80221e:	48 98                	cltq   
  802220:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802226:	48 c1 e0 0c          	shl    $0xc,%rax
  80222a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80222e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802232:	48 89 c7             	mov    %rax,%rdi
  802235:	48 b8 85 1e 80 00 00 	movabs $0x801e85,%rax
  80223c:	00 00 00 
  80223f:	ff d0                	callq  *%rax
  802241:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802245:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802249:	48 89 c7             	mov    %rax,%rdi
  80224c:	48 b8 85 1e 80 00 00 	movabs $0x801e85,%rax
  802253:	00 00 00 
  802256:	ff d0                	callq  *%rax
  802258:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80225c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802260:	48 c1 e8 15          	shr    $0x15,%rax
  802264:	48 89 c2             	mov    %rax,%rdx
  802267:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80226e:	01 00 00 
  802271:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802275:	83 e0 01             	and    $0x1,%eax
  802278:	48 85 c0             	test   %rax,%rax
  80227b:	74 73                	je     8022f0 <dup+0x11d>
  80227d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802281:	48 c1 e8 0c          	shr    $0xc,%rax
  802285:	48 89 c2             	mov    %rax,%rdx
  802288:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80228f:	01 00 00 
  802292:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802296:	83 e0 01             	and    $0x1,%eax
  802299:	48 85 c0             	test   %rax,%rax
  80229c:	74 52                	je     8022f0 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80229e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a2:	48 c1 e8 0c          	shr    $0xc,%rax
  8022a6:	48 89 c2             	mov    %rax,%rdx
  8022a9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022b0:	01 00 00 
  8022b3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022b7:	25 07 0e 00 00       	and    $0xe07,%eax
  8022bc:	89 c1                	mov    %eax,%ecx
  8022be:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c6:	41 89 c8             	mov    %ecx,%r8d
  8022c9:	48 89 d1             	mov    %rdx,%rcx
  8022cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8022d1:	48 89 c6             	mov    %rax,%rsi
  8022d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8022d9:	48 b8 4c 1b 80 00 00 	movabs $0x801b4c,%rax
  8022e0:	00 00 00 
  8022e3:	ff d0                	callq  *%rax
  8022e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022ec:	79 02                	jns    8022f0 <dup+0x11d>
			goto err;
  8022ee:	eb 57                	jmp    802347 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8022f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022f4:	48 c1 e8 0c          	shr    $0xc,%rax
  8022f8:	48 89 c2             	mov    %rax,%rdx
  8022fb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802302:	01 00 00 
  802305:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802309:	25 07 0e 00 00       	and    $0xe07,%eax
  80230e:	89 c1                	mov    %eax,%ecx
  802310:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802314:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802318:	41 89 c8             	mov    %ecx,%r8d
  80231b:	48 89 d1             	mov    %rdx,%rcx
  80231e:	ba 00 00 00 00       	mov    $0x0,%edx
  802323:	48 89 c6             	mov    %rax,%rsi
  802326:	bf 00 00 00 00       	mov    $0x0,%edi
  80232b:	48 b8 4c 1b 80 00 00 	movabs $0x801b4c,%rax
  802332:	00 00 00 
  802335:	ff d0                	callq  *%rax
  802337:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80233a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80233e:	79 02                	jns    802342 <dup+0x16f>
		goto err;
  802340:	eb 05                	jmp    802347 <dup+0x174>

	return newfdnum;
  802342:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802345:	eb 33                	jmp    80237a <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802347:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80234b:	48 89 c6             	mov    %rax,%rsi
  80234e:	bf 00 00 00 00       	mov    $0x0,%edi
  802353:	48 b8 ac 1b 80 00 00 	movabs $0x801bac,%rax
  80235a:	00 00 00 
  80235d:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80235f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802363:	48 89 c6             	mov    %rax,%rsi
  802366:	bf 00 00 00 00       	mov    $0x0,%edi
  80236b:	48 b8 ac 1b 80 00 00 	movabs $0x801bac,%rax
  802372:	00 00 00 
  802375:	ff d0                	callq  *%rax
	return r;
  802377:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80237a:	c9                   	leaveq 
  80237b:	c3                   	retq   

000000000080237c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80237c:	55                   	push   %rbp
  80237d:	48 89 e5             	mov    %rsp,%rbp
  802380:	48 83 ec 40          	sub    $0x40,%rsp
  802384:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802387:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80238b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80238f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802393:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802396:	48 89 d6             	mov    %rdx,%rsi
  802399:	89 c7                	mov    %eax,%edi
  80239b:	48 b8 48 1f 80 00 00 	movabs $0x801f48,%rax
  8023a2:	00 00 00 
  8023a5:	ff d0                	callq  *%rax
  8023a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023ae:	78 24                	js     8023d4 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023b4:	8b 00                	mov    (%rax),%eax
  8023b6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023ba:	48 89 d6             	mov    %rdx,%rsi
  8023bd:	89 c7                	mov    %eax,%edi
  8023bf:	48 b8 a3 20 80 00 00 	movabs $0x8020a3,%rax
  8023c6:	00 00 00 
  8023c9:	ff d0                	callq  *%rax
  8023cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023d2:	79 05                	jns    8023d9 <read+0x5d>
		return r;
  8023d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023d7:	eb 76                	jmp    80244f <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8023d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023dd:	8b 40 08             	mov    0x8(%rax),%eax
  8023e0:	83 e0 03             	and    $0x3,%eax
  8023e3:	83 f8 01             	cmp    $0x1,%eax
  8023e6:	75 3a                	jne    802422 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8023e8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8023ef:	00 00 00 
  8023f2:	48 8b 00             	mov    (%rax),%rax
  8023f5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023fb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023fe:	89 c6                	mov    %eax,%esi
  802400:	48 bf 57 46 80 00 00 	movabs $0x804657,%rdi
  802407:	00 00 00 
  80240a:	b8 00 00 00 00       	mov    $0x0,%eax
  80240f:	48 b9 33 06 80 00 00 	movabs $0x800633,%rcx
  802416:	00 00 00 
  802419:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80241b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802420:	eb 2d                	jmp    80244f <read+0xd3>
	}
	if (!dev->dev_read)
  802422:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802426:	48 8b 40 10          	mov    0x10(%rax),%rax
  80242a:	48 85 c0             	test   %rax,%rax
  80242d:	75 07                	jne    802436 <read+0xba>
		return -E_NOT_SUPP;
  80242f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802434:	eb 19                	jmp    80244f <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802436:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80243a:	48 8b 40 10          	mov    0x10(%rax),%rax
  80243e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802442:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802446:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80244a:	48 89 cf             	mov    %rcx,%rdi
  80244d:	ff d0                	callq  *%rax
}
  80244f:	c9                   	leaveq 
  802450:	c3                   	retq   

0000000000802451 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802451:	55                   	push   %rbp
  802452:	48 89 e5             	mov    %rsp,%rbp
  802455:	48 83 ec 30          	sub    $0x30,%rsp
  802459:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80245c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802460:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802464:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80246b:	eb 49                	jmp    8024b6 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80246d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802470:	48 98                	cltq   
  802472:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802476:	48 29 c2             	sub    %rax,%rdx
  802479:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80247c:	48 63 c8             	movslq %eax,%rcx
  80247f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802483:	48 01 c1             	add    %rax,%rcx
  802486:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802489:	48 89 ce             	mov    %rcx,%rsi
  80248c:	89 c7                	mov    %eax,%edi
  80248e:	48 b8 7c 23 80 00 00 	movabs $0x80237c,%rax
  802495:	00 00 00 
  802498:	ff d0                	callq  *%rax
  80249a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80249d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024a1:	79 05                	jns    8024a8 <readn+0x57>
			return m;
  8024a3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024a6:	eb 1c                	jmp    8024c4 <readn+0x73>
		if (m == 0)
  8024a8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024ac:	75 02                	jne    8024b0 <readn+0x5f>
			break;
  8024ae:	eb 11                	jmp    8024c1 <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  8024b0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024b3:	01 45 fc             	add    %eax,-0x4(%rbp)
  8024b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b9:	48 98                	cltq   
  8024bb:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8024bf:	72 ac                	jb     80246d <readn+0x1c>
	}
	return tot;
  8024c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024c4:	c9                   	leaveq 
  8024c5:	c3                   	retq   

00000000008024c6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8024c6:	55                   	push   %rbp
  8024c7:	48 89 e5             	mov    %rsp,%rbp
  8024ca:	48 83 ec 40          	sub    $0x40,%rsp
  8024ce:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024d1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8024d5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024d9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024dd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024e0:	48 89 d6             	mov    %rdx,%rsi
  8024e3:	89 c7                	mov    %eax,%edi
  8024e5:	48 b8 48 1f 80 00 00 	movabs $0x801f48,%rax
  8024ec:	00 00 00 
  8024ef:	ff d0                	callq  *%rax
  8024f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f8:	78 24                	js     80251e <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024fe:	8b 00                	mov    (%rax),%eax
  802500:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802504:	48 89 d6             	mov    %rdx,%rsi
  802507:	89 c7                	mov    %eax,%edi
  802509:	48 b8 a3 20 80 00 00 	movabs $0x8020a3,%rax
  802510:	00 00 00 
  802513:	ff d0                	callq  *%rax
  802515:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802518:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80251c:	79 05                	jns    802523 <write+0x5d>
		return r;
  80251e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802521:	eb 75                	jmp    802598 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802523:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802527:	8b 40 08             	mov    0x8(%rax),%eax
  80252a:	83 e0 03             	and    $0x3,%eax
  80252d:	85 c0                	test   %eax,%eax
  80252f:	75 3a                	jne    80256b <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802531:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802538:	00 00 00 
  80253b:	48 8b 00             	mov    (%rax),%rax
  80253e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802544:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802547:	89 c6                	mov    %eax,%esi
  802549:	48 bf 73 46 80 00 00 	movabs $0x804673,%rdi
  802550:	00 00 00 
  802553:	b8 00 00 00 00       	mov    $0x0,%eax
  802558:	48 b9 33 06 80 00 00 	movabs $0x800633,%rcx
  80255f:	00 00 00 
  802562:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802564:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802569:	eb 2d                	jmp    802598 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80256b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80256f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802573:	48 85 c0             	test   %rax,%rax
  802576:	75 07                	jne    80257f <write+0xb9>
		return -E_NOT_SUPP;
  802578:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80257d:	eb 19                	jmp    802598 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80257f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802583:	48 8b 40 18          	mov    0x18(%rax),%rax
  802587:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80258b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80258f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802593:	48 89 cf             	mov    %rcx,%rdi
  802596:	ff d0                	callq  *%rax
}
  802598:	c9                   	leaveq 
  802599:	c3                   	retq   

000000000080259a <seek>:

int
seek(int fdnum, off_t offset)
{
  80259a:	55                   	push   %rbp
  80259b:	48 89 e5             	mov    %rsp,%rbp
  80259e:	48 83 ec 18          	sub    $0x18,%rsp
  8025a2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025a5:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025a8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025af:	48 89 d6             	mov    %rdx,%rsi
  8025b2:	89 c7                	mov    %eax,%edi
  8025b4:	48 b8 48 1f 80 00 00 	movabs $0x801f48,%rax
  8025bb:	00 00 00 
  8025be:	ff d0                	callq  *%rax
  8025c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025c7:	79 05                	jns    8025ce <seek+0x34>
		return r;
  8025c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025cc:	eb 0f                	jmp    8025dd <seek+0x43>
	fd->fd_offset = offset;
  8025ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025d2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8025d5:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8025d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025dd:	c9                   	leaveq 
  8025de:	c3                   	retq   

00000000008025df <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8025df:	55                   	push   %rbp
  8025e0:	48 89 e5             	mov    %rsp,%rbp
  8025e3:	48 83 ec 30          	sub    $0x30,%rsp
  8025e7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025ea:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025ed:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025f1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025f4:	48 89 d6             	mov    %rdx,%rsi
  8025f7:	89 c7                	mov    %eax,%edi
  8025f9:	48 b8 48 1f 80 00 00 	movabs $0x801f48,%rax
  802600:	00 00 00 
  802603:	ff d0                	callq  *%rax
  802605:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802608:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80260c:	78 24                	js     802632 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80260e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802612:	8b 00                	mov    (%rax),%eax
  802614:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802618:	48 89 d6             	mov    %rdx,%rsi
  80261b:	89 c7                	mov    %eax,%edi
  80261d:	48 b8 a3 20 80 00 00 	movabs $0x8020a3,%rax
  802624:	00 00 00 
  802627:	ff d0                	callq  *%rax
  802629:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80262c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802630:	79 05                	jns    802637 <ftruncate+0x58>
		return r;
  802632:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802635:	eb 72                	jmp    8026a9 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802637:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80263b:	8b 40 08             	mov    0x8(%rax),%eax
  80263e:	83 e0 03             	and    $0x3,%eax
  802641:	85 c0                	test   %eax,%eax
  802643:	75 3a                	jne    80267f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802645:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80264c:	00 00 00 
  80264f:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802652:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802658:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80265b:	89 c6                	mov    %eax,%esi
  80265d:	48 bf 90 46 80 00 00 	movabs $0x804690,%rdi
  802664:	00 00 00 
  802667:	b8 00 00 00 00       	mov    $0x0,%eax
  80266c:	48 b9 33 06 80 00 00 	movabs $0x800633,%rcx
  802673:	00 00 00 
  802676:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802678:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80267d:	eb 2a                	jmp    8026a9 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80267f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802683:	48 8b 40 30          	mov    0x30(%rax),%rax
  802687:	48 85 c0             	test   %rax,%rax
  80268a:	75 07                	jne    802693 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80268c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802691:	eb 16                	jmp    8026a9 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802693:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802697:	48 8b 40 30          	mov    0x30(%rax),%rax
  80269b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80269f:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8026a2:	89 ce                	mov    %ecx,%esi
  8026a4:	48 89 d7             	mov    %rdx,%rdi
  8026a7:	ff d0                	callq  *%rax
}
  8026a9:	c9                   	leaveq 
  8026aa:	c3                   	retq   

00000000008026ab <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8026ab:	55                   	push   %rbp
  8026ac:	48 89 e5             	mov    %rsp,%rbp
  8026af:	48 83 ec 30          	sub    $0x30,%rsp
  8026b3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026b6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026ba:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026be:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026c1:	48 89 d6             	mov    %rdx,%rsi
  8026c4:	89 c7                	mov    %eax,%edi
  8026c6:	48 b8 48 1f 80 00 00 	movabs $0x801f48,%rax
  8026cd:	00 00 00 
  8026d0:	ff d0                	callq  *%rax
  8026d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026d9:	78 24                	js     8026ff <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026df:	8b 00                	mov    (%rax),%eax
  8026e1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026e5:	48 89 d6             	mov    %rdx,%rsi
  8026e8:	89 c7                	mov    %eax,%edi
  8026ea:	48 b8 a3 20 80 00 00 	movabs $0x8020a3,%rax
  8026f1:	00 00 00 
  8026f4:	ff d0                	callq  *%rax
  8026f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026fd:	79 05                	jns    802704 <fstat+0x59>
		return r;
  8026ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802702:	eb 5e                	jmp    802762 <fstat+0xb7>
	if (!dev->dev_stat)
  802704:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802708:	48 8b 40 28          	mov    0x28(%rax),%rax
  80270c:	48 85 c0             	test   %rax,%rax
  80270f:	75 07                	jne    802718 <fstat+0x6d>
		return -E_NOT_SUPP;
  802711:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802716:	eb 4a                	jmp    802762 <fstat+0xb7>
	stat->st_name[0] = 0;
  802718:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80271c:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80271f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802723:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80272a:	00 00 00 
	stat->st_isdir = 0;
  80272d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802731:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802738:	00 00 00 
	stat->st_dev = dev;
  80273b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80273f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802743:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80274a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80274e:	48 8b 40 28          	mov    0x28(%rax),%rax
  802752:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802756:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80275a:	48 89 ce             	mov    %rcx,%rsi
  80275d:	48 89 d7             	mov    %rdx,%rdi
  802760:	ff d0                	callq  *%rax
}
  802762:	c9                   	leaveq 
  802763:	c3                   	retq   

0000000000802764 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802764:	55                   	push   %rbp
  802765:	48 89 e5             	mov    %rsp,%rbp
  802768:	48 83 ec 20          	sub    $0x20,%rsp
  80276c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802770:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802774:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802778:	be 00 00 00 00       	mov    $0x0,%esi
  80277d:	48 89 c7             	mov    %rax,%rdi
  802780:	48 b8 54 28 80 00 00 	movabs $0x802854,%rax
  802787:	00 00 00 
  80278a:	ff d0                	callq  *%rax
  80278c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80278f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802793:	79 05                	jns    80279a <stat+0x36>
		return fd;
  802795:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802798:	eb 2f                	jmp    8027c9 <stat+0x65>
	r = fstat(fd, stat);
  80279a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80279e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a1:	48 89 d6             	mov    %rdx,%rsi
  8027a4:	89 c7                	mov    %eax,%edi
  8027a6:	48 b8 ab 26 80 00 00 	movabs $0x8026ab,%rax
  8027ad:	00 00 00 
  8027b0:	ff d0                	callq  *%rax
  8027b2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8027b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b8:	89 c7                	mov    %eax,%edi
  8027ba:	48 b8 5a 21 80 00 00 	movabs $0x80215a,%rax
  8027c1:	00 00 00 
  8027c4:	ff d0                	callq  *%rax
	return r;
  8027c6:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8027c9:	c9                   	leaveq 
  8027ca:	c3                   	retq   

00000000008027cb <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8027cb:	55                   	push   %rbp
  8027cc:	48 89 e5             	mov    %rsp,%rbp
  8027cf:	48 83 ec 10          	sub    $0x10,%rsp
  8027d3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8027d6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8027da:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027e1:	00 00 00 
  8027e4:	8b 00                	mov    (%rax),%eax
  8027e6:	85 c0                	test   %eax,%eax
  8027e8:	75 1f                	jne    802809 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8027ea:	bf 01 00 00 00       	mov    $0x1,%edi
  8027ef:	48 b8 d5 3e 80 00 00 	movabs $0x803ed5,%rax
  8027f6:	00 00 00 
  8027f9:	ff d0                	callq  *%rax
  8027fb:	89 c2                	mov    %eax,%edx
  8027fd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802804:	00 00 00 
  802807:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802809:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802810:	00 00 00 
  802813:	8b 00                	mov    (%rax),%eax
  802815:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802818:	b9 07 00 00 00       	mov    $0x7,%ecx
  80281d:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802824:	00 00 00 
  802827:	89 c7                	mov    %eax,%edi
  802829:	48 b8 48 3d 80 00 00 	movabs $0x803d48,%rax
  802830:	00 00 00 
  802833:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802835:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802839:	ba 00 00 00 00       	mov    $0x0,%edx
  80283e:	48 89 c6             	mov    %rax,%rsi
  802841:	bf 00 00 00 00       	mov    $0x0,%edi
  802846:	48 b8 0a 3d 80 00 00 	movabs $0x803d0a,%rax
  80284d:	00 00 00 
  802850:	ff d0                	callq  *%rax
}
  802852:	c9                   	leaveq 
  802853:	c3                   	retq   

0000000000802854 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802854:	55                   	push   %rbp
  802855:	48 89 e5             	mov    %rsp,%rbp
  802858:	48 83 ec 10          	sub    $0x10,%rsp
  80285c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802860:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  802863:	48 ba b6 46 80 00 00 	movabs $0x8046b6,%rdx
  80286a:	00 00 00 
  80286d:	be 4c 00 00 00       	mov    $0x4c,%esi
  802872:	48 bf cb 46 80 00 00 	movabs $0x8046cb,%rdi
  802879:	00 00 00 
  80287c:	b8 00 00 00 00       	mov    $0x0,%eax
  802881:	48 b9 fa 03 80 00 00 	movabs $0x8003fa,%rcx
  802888:	00 00 00 
  80288b:	ff d1                	callq  *%rcx

000000000080288d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80288d:	55                   	push   %rbp
  80288e:	48 89 e5             	mov    %rsp,%rbp
  802891:	48 83 ec 10          	sub    $0x10,%rsp
  802895:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802899:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80289d:	8b 50 0c             	mov    0xc(%rax),%edx
  8028a0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028a7:	00 00 00 
  8028aa:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8028ac:	be 00 00 00 00       	mov    $0x0,%esi
  8028b1:	bf 06 00 00 00       	mov    $0x6,%edi
  8028b6:	48 b8 cb 27 80 00 00 	movabs $0x8027cb,%rax
  8028bd:	00 00 00 
  8028c0:	ff d0                	callq  *%rax
}
  8028c2:	c9                   	leaveq 
  8028c3:	c3                   	retq   

00000000008028c4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8028c4:	55                   	push   %rbp
  8028c5:	48 89 e5             	mov    %rsp,%rbp
  8028c8:	48 83 ec 20          	sub    $0x20,%rsp
  8028cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8028d0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8028d4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  8028d8:	48 ba d6 46 80 00 00 	movabs $0x8046d6,%rdx
  8028df:	00 00 00 
  8028e2:	be 6b 00 00 00       	mov    $0x6b,%esi
  8028e7:	48 bf cb 46 80 00 00 	movabs $0x8046cb,%rdi
  8028ee:	00 00 00 
  8028f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f6:	48 b9 fa 03 80 00 00 	movabs $0x8003fa,%rcx
  8028fd:	00 00 00 
  802900:	ff d1                	callq  *%rcx

0000000000802902 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802902:	55                   	push   %rbp
  802903:	48 89 e5             	mov    %rsp,%rbp
  802906:	48 83 ec 20          	sub    $0x20,%rsp
  80290a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80290e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802912:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  802916:	48 ba f3 46 80 00 00 	movabs $0x8046f3,%rdx
  80291d:	00 00 00 
  802920:	be 7b 00 00 00       	mov    $0x7b,%esi
  802925:	48 bf cb 46 80 00 00 	movabs $0x8046cb,%rdi
  80292c:	00 00 00 
  80292f:	b8 00 00 00 00       	mov    $0x0,%eax
  802934:	48 b9 fa 03 80 00 00 	movabs $0x8003fa,%rcx
  80293b:	00 00 00 
  80293e:	ff d1                	callq  *%rcx

0000000000802940 <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802940:	55                   	push   %rbp
  802941:	48 89 e5             	mov    %rsp,%rbp
  802944:	48 83 ec 20          	sub    $0x20,%rsp
  802948:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80294c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802950:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802954:	8b 50 0c             	mov    0xc(%rax),%edx
  802957:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80295e:	00 00 00 
  802961:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802963:	be 00 00 00 00       	mov    $0x0,%esi
  802968:	bf 05 00 00 00       	mov    $0x5,%edi
  80296d:	48 b8 cb 27 80 00 00 	movabs $0x8027cb,%rax
  802974:	00 00 00 
  802977:	ff d0                	callq  *%rax
  802979:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80297c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802980:	79 05                	jns    802987 <devfile_stat+0x47>
		return r;
  802982:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802985:	eb 56                	jmp    8029dd <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802987:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80298b:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802992:	00 00 00 
  802995:	48 89 c7             	mov    %rax,%rdi
  802998:	48 b8 cd 11 80 00 00 	movabs $0x8011cd,%rax
  80299f:	00 00 00 
  8029a2:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8029a4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029ab:	00 00 00 
  8029ae:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8029b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029b8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8029be:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029c5:	00 00 00 
  8029c8:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8029ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029d2:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8029d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029dd:	c9                   	leaveq 
  8029de:	c3                   	retq   

00000000008029df <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8029df:	55                   	push   %rbp
  8029e0:	48 89 e5             	mov    %rsp,%rbp
  8029e3:	48 83 ec 10          	sub    $0x10,%rsp
  8029e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8029eb:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8029ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029f2:	8b 50 0c             	mov    0xc(%rax),%edx
  8029f5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029fc:	00 00 00 
  8029ff:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802a01:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a08:	00 00 00 
  802a0b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802a0e:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802a11:	be 00 00 00 00       	mov    $0x0,%esi
  802a16:	bf 02 00 00 00       	mov    $0x2,%edi
  802a1b:	48 b8 cb 27 80 00 00 	movabs $0x8027cb,%rax
  802a22:	00 00 00 
  802a25:	ff d0                	callq  *%rax
}
  802a27:	c9                   	leaveq 
  802a28:	c3                   	retq   

0000000000802a29 <remove>:

// Delete a file
int
remove(const char *path)
{
  802a29:	55                   	push   %rbp
  802a2a:	48 89 e5             	mov    %rsp,%rbp
  802a2d:	48 83 ec 10          	sub    $0x10,%rsp
  802a31:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802a35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a39:	48 89 c7             	mov    %rax,%rdi
  802a3c:	48 b8 61 11 80 00 00 	movabs $0x801161,%rax
  802a43:	00 00 00 
  802a46:	ff d0                	callq  *%rax
  802a48:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802a4d:	7e 07                	jle    802a56 <remove+0x2d>
		return -E_BAD_PATH;
  802a4f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802a54:	eb 33                	jmp    802a89 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802a56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a5a:	48 89 c6             	mov    %rax,%rsi
  802a5d:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802a64:	00 00 00 
  802a67:	48 b8 cd 11 80 00 00 	movabs $0x8011cd,%rax
  802a6e:	00 00 00 
  802a71:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802a73:	be 00 00 00 00       	mov    $0x0,%esi
  802a78:	bf 07 00 00 00       	mov    $0x7,%edi
  802a7d:	48 b8 cb 27 80 00 00 	movabs $0x8027cb,%rax
  802a84:	00 00 00 
  802a87:	ff d0                	callq  *%rax
}
  802a89:	c9                   	leaveq 
  802a8a:	c3                   	retq   

0000000000802a8b <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802a8b:	55                   	push   %rbp
  802a8c:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802a8f:	be 00 00 00 00       	mov    $0x0,%esi
  802a94:	bf 08 00 00 00       	mov    $0x8,%edi
  802a99:	48 b8 cb 27 80 00 00 	movabs $0x8027cb,%rax
  802aa0:	00 00 00 
  802aa3:	ff d0                	callq  *%rax
}
  802aa5:	5d                   	pop    %rbp
  802aa6:	c3                   	retq   

0000000000802aa7 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802aa7:	55                   	push   %rbp
  802aa8:	48 89 e5             	mov    %rsp,%rbp
  802aab:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802ab2:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802ab9:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802ac0:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802ac7:	be 00 00 00 00       	mov    $0x0,%esi
  802acc:	48 89 c7             	mov    %rax,%rdi
  802acf:	48 b8 54 28 80 00 00 	movabs $0x802854,%rax
  802ad6:	00 00 00 
  802ad9:	ff d0                	callq  *%rax
  802adb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802ade:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ae2:	79 28                	jns    802b0c <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802ae4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae7:	89 c6                	mov    %eax,%esi
  802ae9:	48 bf 11 47 80 00 00 	movabs $0x804711,%rdi
  802af0:	00 00 00 
  802af3:	b8 00 00 00 00       	mov    $0x0,%eax
  802af8:	48 ba 33 06 80 00 00 	movabs $0x800633,%rdx
  802aff:	00 00 00 
  802b02:	ff d2                	callq  *%rdx
		return fd_src;
  802b04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b07:	e9 74 01 00 00       	jmpq   802c80 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802b0c:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802b13:	be 01 01 00 00       	mov    $0x101,%esi
  802b18:	48 89 c7             	mov    %rax,%rdi
  802b1b:	48 b8 54 28 80 00 00 	movabs $0x802854,%rax
  802b22:	00 00 00 
  802b25:	ff d0                	callq  *%rax
  802b27:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802b2a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b2e:	79 39                	jns    802b69 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802b30:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b33:	89 c6                	mov    %eax,%esi
  802b35:	48 bf 27 47 80 00 00 	movabs $0x804727,%rdi
  802b3c:	00 00 00 
  802b3f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b44:	48 ba 33 06 80 00 00 	movabs $0x800633,%rdx
  802b4b:	00 00 00 
  802b4e:	ff d2                	callq  *%rdx
		close(fd_src);
  802b50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b53:	89 c7                	mov    %eax,%edi
  802b55:	48 b8 5a 21 80 00 00 	movabs $0x80215a,%rax
  802b5c:	00 00 00 
  802b5f:	ff d0                	callq  *%rax
		return fd_dest;
  802b61:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b64:	e9 17 01 00 00       	jmpq   802c80 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802b69:	eb 74                	jmp    802bdf <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802b6b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b6e:	48 63 d0             	movslq %eax,%rdx
  802b71:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802b78:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b7b:	48 89 ce             	mov    %rcx,%rsi
  802b7e:	89 c7                	mov    %eax,%edi
  802b80:	48 b8 c6 24 80 00 00 	movabs $0x8024c6,%rax
  802b87:	00 00 00 
  802b8a:	ff d0                	callq  *%rax
  802b8c:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802b8f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802b93:	79 4a                	jns    802bdf <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802b95:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802b98:	89 c6                	mov    %eax,%esi
  802b9a:	48 bf 41 47 80 00 00 	movabs $0x804741,%rdi
  802ba1:	00 00 00 
  802ba4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba9:	48 ba 33 06 80 00 00 	movabs $0x800633,%rdx
  802bb0:	00 00 00 
  802bb3:	ff d2                	callq  *%rdx
			close(fd_src);
  802bb5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb8:	89 c7                	mov    %eax,%edi
  802bba:	48 b8 5a 21 80 00 00 	movabs $0x80215a,%rax
  802bc1:	00 00 00 
  802bc4:	ff d0                	callq  *%rax
			close(fd_dest);
  802bc6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bc9:	89 c7                	mov    %eax,%edi
  802bcb:	48 b8 5a 21 80 00 00 	movabs $0x80215a,%rax
  802bd2:	00 00 00 
  802bd5:	ff d0                	callq  *%rax
			return write_size;
  802bd7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802bda:	e9 a1 00 00 00       	jmpq   802c80 <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802bdf:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802be6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be9:	ba 00 02 00 00       	mov    $0x200,%edx
  802bee:	48 89 ce             	mov    %rcx,%rsi
  802bf1:	89 c7                	mov    %eax,%edi
  802bf3:	48 b8 7c 23 80 00 00 	movabs $0x80237c,%rax
  802bfa:	00 00 00 
  802bfd:	ff d0                	callq  *%rax
  802bff:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802c02:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c06:	0f 8f 5f ff ff ff    	jg     802b6b <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  802c0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c10:	79 47                	jns    802c59 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802c12:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c15:	89 c6                	mov    %eax,%esi
  802c17:	48 bf 54 47 80 00 00 	movabs $0x804754,%rdi
  802c1e:	00 00 00 
  802c21:	b8 00 00 00 00       	mov    $0x0,%eax
  802c26:	48 ba 33 06 80 00 00 	movabs $0x800633,%rdx
  802c2d:	00 00 00 
  802c30:	ff d2                	callq  *%rdx
		close(fd_src);
  802c32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c35:	89 c7                	mov    %eax,%edi
  802c37:	48 b8 5a 21 80 00 00 	movabs $0x80215a,%rax
  802c3e:	00 00 00 
  802c41:	ff d0                	callq  *%rax
		close(fd_dest);
  802c43:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c46:	89 c7                	mov    %eax,%edi
  802c48:	48 b8 5a 21 80 00 00 	movabs $0x80215a,%rax
  802c4f:	00 00 00 
  802c52:	ff d0                	callq  *%rax
		return read_size;
  802c54:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c57:	eb 27                	jmp    802c80 <copy+0x1d9>
	}
	close(fd_src);
  802c59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c5c:	89 c7                	mov    %eax,%edi
  802c5e:	48 b8 5a 21 80 00 00 	movabs $0x80215a,%rax
  802c65:	00 00 00 
  802c68:	ff d0                	callq  *%rax
	close(fd_dest);
  802c6a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c6d:	89 c7                	mov    %eax,%edi
  802c6f:	48 b8 5a 21 80 00 00 	movabs $0x80215a,%rax
  802c76:	00 00 00 
  802c79:	ff d0                	callq  *%rax
	return 0;
  802c7b:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802c80:	c9                   	leaveq 
  802c81:	c3                   	retq   

0000000000802c82 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802c82:	55                   	push   %rbp
  802c83:	48 89 e5             	mov    %rsp,%rbp
  802c86:	48 83 ec 20          	sub    $0x20,%rsp
  802c8a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802c8d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c91:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c94:	48 89 d6             	mov    %rdx,%rsi
  802c97:	89 c7                	mov    %eax,%edi
  802c99:	48 b8 48 1f 80 00 00 	movabs $0x801f48,%rax
  802ca0:	00 00 00 
  802ca3:	ff d0                	callq  *%rax
  802ca5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ca8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cac:	79 05                	jns    802cb3 <fd2sockid+0x31>
		return r;
  802cae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb1:	eb 24                	jmp    802cd7 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802cb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cb7:	8b 10                	mov    (%rax),%edx
  802cb9:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802cc0:	00 00 00 
  802cc3:	8b 00                	mov    (%rax),%eax
  802cc5:	39 c2                	cmp    %eax,%edx
  802cc7:	74 07                	je     802cd0 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802cc9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cce:	eb 07                	jmp    802cd7 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802cd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cd4:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802cd7:	c9                   	leaveq 
  802cd8:	c3                   	retq   

0000000000802cd9 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802cd9:	55                   	push   %rbp
  802cda:	48 89 e5             	mov    %rsp,%rbp
  802cdd:	48 83 ec 20          	sub    $0x20,%rsp
  802ce1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802ce4:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802ce8:	48 89 c7             	mov    %rax,%rdi
  802ceb:	48 b8 b0 1e 80 00 00 	movabs $0x801eb0,%rax
  802cf2:	00 00 00 
  802cf5:	ff d0                	callq  *%rax
  802cf7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cfa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cfe:	78 26                	js     802d26 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802d00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d04:	ba 07 04 00 00       	mov    $0x407,%edx
  802d09:	48 89 c6             	mov    %rax,%rsi
  802d0c:	bf 00 00 00 00       	mov    $0x0,%edi
  802d11:	48 b8 fa 1a 80 00 00 	movabs $0x801afa,%rax
  802d18:	00 00 00 
  802d1b:	ff d0                	callq  *%rax
  802d1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d24:	79 16                	jns    802d3c <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802d26:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d29:	89 c7                	mov    %eax,%edi
  802d2b:	48 b8 e8 31 80 00 00 	movabs $0x8031e8,%rax
  802d32:	00 00 00 
  802d35:	ff d0                	callq  *%rax
		return r;
  802d37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d3a:	eb 3a                	jmp    802d76 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802d3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d40:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802d47:	00 00 00 
  802d4a:	8b 12                	mov    (%rdx),%edx
  802d4c:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802d4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d52:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802d59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d5d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802d60:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802d63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d67:	48 89 c7             	mov    %rax,%rdi
  802d6a:	48 b8 62 1e 80 00 00 	movabs $0x801e62,%rax
  802d71:	00 00 00 
  802d74:	ff d0                	callq  *%rax
}
  802d76:	c9                   	leaveq 
  802d77:	c3                   	retq   

0000000000802d78 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802d78:	55                   	push   %rbp
  802d79:	48 89 e5             	mov    %rsp,%rbp
  802d7c:	48 83 ec 30          	sub    $0x30,%rsp
  802d80:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d83:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d87:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802d8b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d8e:	89 c7                	mov    %eax,%edi
  802d90:	48 b8 82 2c 80 00 00 	movabs $0x802c82,%rax
  802d97:	00 00 00 
  802d9a:	ff d0                	callq  *%rax
  802d9c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d9f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802da3:	79 05                	jns    802daa <accept+0x32>
		return r;
  802da5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da8:	eb 3b                	jmp    802de5 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802daa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802dae:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802db2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db5:	48 89 ce             	mov    %rcx,%rsi
  802db8:	89 c7                	mov    %eax,%edi
  802dba:	48 b8 c5 30 80 00 00 	movabs $0x8030c5,%rax
  802dc1:	00 00 00 
  802dc4:	ff d0                	callq  *%rax
  802dc6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dc9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dcd:	79 05                	jns    802dd4 <accept+0x5c>
		return r;
  802dcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd2:	eb 11                	jmp    802de5 <accept+0x6d>
	return alloc_sockfd(r);
  802dd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd7:	89 c7                	mov    %eax,%edi
  802dd9:	48 b8 d9 2c 80 00 00 	movabs $0x802cd9,%rax
  802de0:	00 00 00 
  802de3:	ff d0                	callq  *%rax
}
  802de5:	c9                   	leaveq 
  802de6:	c3                   	retq   

0000000000802de7 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802de7:	55                   	push   %rbp
  802de8:	48 89 e5             	mov    %rsp,%rbp
  802deb:	48 83 ec 20          	sub    $0x20,%rsp
  802def:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802df2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802df6:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802df9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dfc:	89 c7                	mov    %eax,%edi
  802dfe:	48 b8 82 2c 80 00 00 	movabs $0x802c82,%rax
  802e05:	00 00 00 
  802e08:	ff d0                	callq  *%rax
  802e0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e11:	79 05                	jns    802e18 <bind+0x31>
		return r;
  802e13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e16:	eb 1b                	jmp    802e33 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802e18:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e1b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802e1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e22:	48 89 ce             	mov    %rcx,%rsi
  802e25:	89 c7                	mov    %eax,%edi
  802e27:	48 b8 44 31 80 00 00 	movabs $0x803144,%rax
  802e2e:	00 00 00 
  802e31:	ff d0                	callq  *%rax
}
  802e33:	c9                   	leaveq 
  802e34:	c3                   	retq   

0000000000802e35 <shutdown>:

int
shutdown(int s, int how)
{
  802e35:	55                   	push   %rbp
  802e36:	48 89 e5             	mov    %rsp,%rbp
  802e39:	48 83 ec 20          	sub    $0x20,%rsp
  802e3d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e40:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e43:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e46:	89 c7                	mov    %eax,%edi
  802e48:	48 b8 82 2c 80 00 00 	movabs $0x802c82,%rax
  802e4f:	00 00 00 
  802e52:	ff d0                	callq  *%rax
  802e54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e5b:	79 05                	jns    802e62 <shutdown+0x2d>
		return r;
  802e5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e60:	eb 16                	jmp    802e78 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802e62:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e68:	89 d6                	mov    %edx,%esi
  802e6a:	89 c7                	mov    %eax,%edi
  802e6c:	48 b8 a8 31 80 00 00 	movabs $0x8031a8,%rax
  802e73:	00 00 00 
  802e76:	ff d0                	callq  *%rax
}
  802e78:	c9                   	leaveq 
  802e79:	c3                   	retq   

0000000000802e7a <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802e7a:	55                   	push   %rbp
  802e7b:	48 89 e5             	mov    %rsp,%rbp
  802e7e:	48 83 ec 10          	sub    $0x10,%rsp
  802e82:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802e86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e8a:	48 89 c7             	mov    %rax,%rdi
  802e8d:	48 b8 47 3f 80 00 00 	movabs $0x803f47,%rax
  802e94:	00 00 00 
  802e97:	ff d0                	callq  *%rax
  802e99:	83 f8 01             	cmp    $0x1,%eax
  802e9c:	75 17                	jne    802eb5 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802e9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ea2:	8b 40 0c             	mov    0xc(%rax),%eax
  802ea5:	89 c7                	mov    %eax,%edi
  802ea7:	48 b8 e8 31 80 00 00 	movabs $0x8031e8,%rax
  802eae:	00 00 00 
  802eb1:	ff d0                	callq  *%rax
  802eb3:	eb 05                	jmp    802eba <devsock_close+0x40>
	else
		return 0;
  802eb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802eba:	c9                   	leaveq 
  802ebb:	c3                   	retq   

0000000000802ebc <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802ebc:	55                   	push   %rbp
  802ebd:	48 89 e5             	mov    %rsp,%rbp
  802ec0:	48 83 ec 20          	sub    $0x20,%rsp
  802ec4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ec7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ecb:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ece:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ed1:	89 c7                	mov    %eax,%edi
  802ed3:	48 b8 82 2c 80 00 00 	movabs $0x802c82,%rax
  802eda:	00 00 00 
  802edd:	ff d0                	callq  *%rax
  802edf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ee2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ee6:	79 05                	jns    802eed <connect+0x31>
		return r;
  802ee8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eeb:	eb 1b                	jmp    802f08 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802eed:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ef0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802ef4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef7:	48 89 ce             	mov    %rcx,%rsi
  802efa:	89 c7                	mov    %eax,%edi
  802efc:	48 b8 15 32 80 00 00 	movabs $0x803215,%rax
  802f03:	00 00 00 
  802f06:	ff d0                	callq  *%rax
}
  802f08:	c9                   	leaveq 
  802f09:	c3                   	retq   

0000000000802f0a <listen>:

int
listen(int s, int backlog)
{
  802f0a:	55                   	push   %rbp
  802f0b:	48 89 e5             	mov    %rsp,%rbp
  802f0e:	48 83 ec 20          	sub    $0x20,%rsp
  802f12:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f15:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f18:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f1b:	89 c7                	mov    %eax,%edi
  802f1d:	48 b8 82 2c 80 00 00 	movabs $0x802c82,%rax
  802f24:	00 00 00 
  802f27:	ff d0                	callq  *%rax
  802f29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f30:	79 05                	jns    802f37 <listen+0x2d>
		return r;
  802f32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f35:	eb 16                	jmp    802f4d <listen+0x43>
	return nsipc_listen(r, backlog);
  802f37:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f3d:	89 d6                	mov    %edx,%esi
  802f3f:	89 c7                	mov    %eax,%edi
  802f41:	48 b8 79 32 80 00 00 	movabs $0x803279,%rax
  802f48:	00 00 00 
  802f4b:	ff d0                	callq  *%rax
}
  802f4d:	c9                   	leaveq 
  802f4e:	c3                   	retq   

0000000000802f4f <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802f4f:	55                   	push   %rbp
  802f50:	48 89 e5             	mov    %rsp,%rbp
  802f53:	48 83 ec 20          	sub    $0x20,%rsp
  802f57:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f5b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802f5f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802f63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f67:	89 c2                	mov    %eax,%edx
  802f69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f6d:	8b 40 0c             	mov    0xc(%rax),%eax
  802f70:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802f74:	b9 00 00 00 00       	mov    $0x0,%ecx
  802f79:	89 c7                	mov    %eax,%edi
  802f7b:	48 b8 b9 32 80 00 00 	movabs $0x8032b9,%rax
  802f82:	00 00 00 
  802f85:	ff d0                	callq  *%rax
}
  802f87:	c9                   	leaveq 
  802f88:	c3                   	retq   

0000000000802f89 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802f89:	55                   	push   %rbp
  802f8a:	48 89 e5             	mov    %rsp,%rbp
  802f8d:	48 83 ec 20          	sub    $0x20,%rsp
  802f91:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f95:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802f99:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802f9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fa1:	89 c2                	mov    %eax,%edx
  802fa3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fa7:	8b 40 0c             	mov    0xc(%rax),%eax
  802faa:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802fae:	b9 00 00 00 00       	mov    $0x0,%ecx
  802fb3:	89 c7                	mov    %eax,%edi
  802fb5:	48 b8 85 33 80 00 00 	movabs $0x803385,%rax
  802fbc:	00 00 00 
  802fbf:	ff d0                	callq  *%rax
}
  802fc1:	c9                   	leaveq 
  802fc2:	c3                   	retq   

0000000000802fc3 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802fc3:	55                   	push   %rbp
  802fc4:	48 89 e5             	mov    %rsp,%rbp
  802fc7:	48 83 ec 10          	sub    $0x10,%rsp
  802fcb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802fcf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802fd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fd7:	48 be 6f 47 80 00 00 	movabs $0x80476f,%rsi
  802fde:	00 00 00 
  802fe1:	48 89 c7             	mov    %rax,%rdi
  802fe4:	48 b8 cd 11 80 00 00 	movabs $0x8011cd,%rax
  802feb:	00 00 00 
  802fee:	ff d0                	callq  *%rax
	return 0;
  802ff0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ff5:	c9                   	leaveq 
  802ff6:	c3                   	retq   

0000000000802ff7 <socket>:

int
socket(int domain, int type, int protocol)
{
  802ff7:	55                   	push   %rbp
  802ff8:	48 89 e5             	mov    %rsp,%rbp
  802ffb:	48 83 ec 20          	sub    $0x20,%rsp
  802fff:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803002:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803005:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803008:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80300b:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80300e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803011:	89 ce                	mov    %ecx,%esi
  803013:	89 c7                	mov    %eax,%edi
  803015:	48 b8 3d 34 80 00 00 	movabs $0x80343d,%rax
  80301c:	00 00 00 
  80301f:	ff d0                	callq  *%rax
  803021:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803024:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803028:	79 05                	jns    80302f <socket+0x38>
		return r;
  80302a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80302d:	eb 11                	jmp    803040 <socket+0x49>
	return alloc_sockfd(r);
  80302f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803032:	89 c7                	mov    %eax,%edi
  803034:	48 b8 d9 2c 80 00 00 	movabs $0x802cd9,%rax
  80303b:	00 00 00 
  80303e:	ff d0                	callq  *%rax
}
  803040:	c9                   	leaveq 
  803041:	c3                   	retq   

0000000000803042 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803042:	55                   	push   %rbp
  803043:	48 89 e5             	mov    %rsp,%rbp
  803046:	48 83 ec 10          	sub    $0x10,%rsp
  80304a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80304d:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803054:	00 00 00 
  803057:	8b 00                	mov    (%rax),%eax
  803059:	85 c0                	test   %eax,%eax
  80305b:	75 1f                	jne    80307c <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80305d:	bf 02 00 00 00       	mov    $0x2,%edi
  803062:	48 b8 d5 3e 80 00 00 	movabs $0x803ed5,%rax
  803069:	00 00 00 
  80306c:	ff d0                	callq  *%rax
  80306e:	89 c2                	mov    %eax,%edx
  803070:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803077:	00 00 00 
  80307a:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80307c:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803083:	00 00 00 
  803086:	8b 00                	mov    (%rax),%eax
  803088:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80308b:	b9 07 00 00 00       	mov    $0x7,%ecx
  803090:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803097:	00 00 00 
  80309a:	89 c7                	mov    %eax,%edi
  80309c:	48 b8 48 3d 80 00 00 	movabs $0x803d48,%rax
  8030a3:	00 00 00 
  8030a6:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8030a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8030ad:	be 00 00 00 00       	mov    $0x0,%esi
  8030b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8030b7:	48 b8 0a 3d 80 00 00 	movabs $0x803d0a,%rax
  8030be:	00 00 00 
  8030c1:	ff d0                	callq  *%rax
}
  8030c3:	c9                   	leaveq 
  8030c4:	c3                   	retq   

00000000008030c5 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8030c5:	55                   	push   %rbp
  8030c6:	48 89 e5             	mov    %rsp,%rbp
  8030c9:	48 83 ec 30          	sub    $0x30,%rsp
  8030cd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030d0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030d4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8030d8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030df:	00 00 00 
  8030e2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8030e5:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8030e7:	bf 01 00 00 00       	mov    $0x1,%edi
  8030ec:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  8030f3:	00 00 00 
  8030f6:	ff d0                	callq  *%rax
  8030f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ff:	78 3e                	js     80313f <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803101:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803108:	00 00 00 
  80310b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80310f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803113:	8b 40 10             	mov    0x10(%rax),%eax
  803116:	89 c2                	mov    %eax,%edx
  803118:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80311c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803120:	48 89 ce             	mov    %rcx,%rsi
  803123:	48 89 c7             	mov    %rax,%rdi
  803126:	48 b8 f1 14 80 00 00 	movabs $0x8014f1,%rax
  80312d:	00 00 00 
  803130:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803132:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803136:	8b 50 10             	mov    0x10(%rax),%edx
  803139:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80313d:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80313f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803142:	c9                   	leaveq 
  803143:	c3                   	retq   

0000000000803144 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803144:	55                   	push   %rbp
  803145:	48 89 e5             	mov    %rsp,%rbp
  803148:	48 83 ec 10          	sub    $0x10,%rsp
  80314c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80314f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803153:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803156:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80315d:	00 00 00 
  803160:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803163:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803165:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803168:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80316c:	48 89 c6             	mov    %rax,%rsi
  80316f:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803176:	00 00 00 
  803179:	48 b8 f1 14 80 00 00 	movabs $0x8014f1,%rax
  803180:	00 00 00 
  803183:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803185:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80318c:	00 00 00 
  80318f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803192:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803195:	bf 02 00 00 00       	mov    $0x2,%edi
  80319a:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  8031a1:	00 00 00 
  8031a4:	ff d0                	callq  *%rax
}
  8031a6:	c9                   	leaveq 
  8031a7:	c3                   	retq   

00000000008031a8 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8031a8:	55                   	push   %rbp
  8031a9:	48 89 e5             	mov    %rsp,%rbp
  8031ac:	48 83 ec 10          	sub    $0x10,%rsp
  8031b0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8031b3:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8031b6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031bd:	00 00 00 
  8031c0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8031c3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8031c5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031cc:	00 00 00 
  8031cf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8031d2:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8031d5:	bf 03 00 00 00       	mov    $0x3,%edi
  8031da:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  8031e1:	00 00 00 
  8031e4:	ff d0                	callq  *%rax
}
  8031e6:	c9                   	leaveq 
  8031e7:	c3                   	retq   

00000000008031e8 <nsipc_close>:

int
nsipc_close(int s)
{
  8031e8:	55                   	push   %rbp
  8031e9:	48 89 e5             	mov    %rsp,%rbp
  8031ec:	48 83 ec 10          	sub    $0x10,%rsp
  8031f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8031f3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031fa:	00 00 00 
  8031fd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803200:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803202:	bf 04 00 00 00       	mov    $0x4,%edi
  803207:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  80320e:	00 00 00 
  803211:	ff d0                	callq  *%rax
}
  803213:	c9                   	leaveq 
  803214:	c3                   	retq   

0000000000803215 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803215:	55                   	push   %rbp
  803216:	48 89 e5             	mov    %rsp,%rbp
  803219:	48 83 ec 10          	sub    $0x10,%rsp
  80321d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803220:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803224:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803227:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80322e:	00 00 00 
  803231:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803234:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803236:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803239:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80323d:	48 89 c6             	mov    %rax,%rsi
  803240:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803247:	00 00 00 
  80324a:	48 b8 f1 14 80 00 00 	movabs $0x8014f1,%rax
  803251:	00 00 00 
  803254:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803256:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80325d:	00 00 00 
  803260:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803263:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803266:	bf 05 00 00 00       	mov    $0x5,%edi
  80326b:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  803272:	00 00 00 
  803275:	ff d0                	callq  *%rax
}
  803277:	c9                   	leaveq 
  803278:	c3                   	retq   

0000000000803279 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803279:	55                   	push   %rbp
  80327a:	48 89 e5             	mov    %rsp,%rbp
  80327d:	48 83 ec 10          	sub    $0x10,%rsp
  803281:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803284:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803287:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80328e:	00 00 00 
  803291:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803294:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803296:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80329d:	00 00 00 
  8032a0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032a3:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8032a6:	bf 06 00 00 00       	mov    $0x6,%edi
  8032ab:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  8032b2:	00 00 00 
  8032b5:	ff d0                	callq  *%rax
}
  8032b7:	c9                   	leaveq 
  8032b8:	c3                   	retq   

00000000008032b9 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8032b9:	55                   	push   %rbp
  8032ba:	48 89 e5             	mov    %rsp,%rbp
  8032bd:	48 83 ec 30          	sub    $0x30,%rsp
  8032c1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032c4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032c8:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8032cb:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8032ce:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032d5:	00 00 00 
  8032d8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8032db:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8032dd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032e4:	00 00 00 
  8032e7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8032ea:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8032ed:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032f4:	00 00 00 
  8032f7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8032fa:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8032fd:	bf 07 00 00 00       	mov    $0x7,%edi
  803302:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  803309:	00 00 00 
  80330c:	ff d0                	callq  *%rax
  80330e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803311:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803315:	78 69                	js     803380 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803317:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80331e:	7f 08                	jg     803328 <nsipc_recv+0x6f>
  803320:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803323:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803326:	7e 35                	jle    80335d <nsipc_recv+0xa4>
  803328:	48 b9 76 47 80 00 00 	movabs $0x804776,%rcx
  80332f:	00 00 00 
  803332:	48 ba 8b 47 80 00 00 	movabs $0x80478b,%rdx
  803339:	00 00 00 
  80333c:	be 61 00 00 00       	mov    $0x61,%esi
  803341:	48 bf a0 47 80 00 00 	movabs $0x8047a0,%rdi
  803348:	00 00 00 
  80334b:	b8 00 00 00 00       	mov    $0x0,%eax
  803350:	49 b8 fa 03 80 00 00 	movabs $0x8003fa,%r8
  803357:	00 00 00 
  80335a:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80335d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803360:	48 63 d0             	movslq %eax,%rdx
  803363:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803367:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80336e:	00 00 00 
  803371:	48 89 c7             	mov    %rax,%rdi
  803374:	48 b8 f1 14 80 00 00 	movabs $0x8014f1,%rax
  80337b:	00 00 00 
  80337e:	ff d0                	callq  *%rax
	}

	return r;
  803380:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803383:	c9                   	leaveq 
  803384:	c3                   	retq   

0000000000803385 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803385:	55                   	push   %rbp
  803386:	48 89 e5             	mov    %rsp,%rbp
  803389:	48 83 ec 20          	sub    $0x20,%rsp
  80338d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803390:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803394:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803397:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80339a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033a1:	00 00 00 
  8033a4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033a7:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8033a9:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8033b0:	7e 35                	jle    8033e7 <nsipc_send+0x62>
  8033b2:	48 b9 ac 47 80 00 00 	movabs $0x8047ac,%rcx
  8033b9:	00 00 00 
  8033bc:	48 ba 8b 47 80 00 00 	movabs $0x80478b,%rdx
  8033c3:	00 00 00 
  8033c6:	be 6c 00 00 00       	mov    $0x6c,%esi
  8033cb:	48 bf a0 47 80 00 00 	movabs $0x8047a0,%rdi
  8033d2:	00 00 00 
  8033d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8033da:	49 b8 fa 03 80 00 00 	movabs $0x8003fa,%r8
  8033e1:	00 00 00 
  8033e4:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8033e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033ea:	48 63 d0             	movslq %eax,%rdx
  8033ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033f1:	48 89 c6             	mov    %rax,%rsi
  8033f4:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8033fb:	00 00 00 
  8033fe:	48 b8 f1 14 80 00 00 	movabs $0x8014f1,%rax
  803405:	00 00 00 
  803408:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80340a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803411:	00 00 00 
  803414:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803417:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80341a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803421:	00 00 00 
  803424:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803427:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80342a:	bf 08 00 00 00       	mov    $0x8,%edi
  80342f:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  803436:	00 00 00 
  803439:	ff d0                	callq  *%rax
}
  80343b:	c9                   	leaveq 
  80343c:	c3                   	retq   

000000000080343d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80343d:	55                   	push   %rbp
  80343e:	48 89 e5             	mov    %rsp,%rbp
  803441:	48 83 ec 10          	sub    $0x10,%rsp
  803445:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803448:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80344b:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80344e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803455:	00 00 00 
  803458:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80345b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80345d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803464:	00 00 00 
  803467:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80346a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80346d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803474:	00 00 00 
  803477:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80347a:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  80347d:	bf 09 00 00 00       	mov    $0x9,%edi
  803482:	48 b8 42 30 80 00 00 	movabs $0x803042,%rax
  803489:	00 00 00 
  80348c:	ff d0                	callq  *%rax
}
  80348e:	c9                   	leaveq 
  80348f:	c3                   	retq   

0000000000803490 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803490:	55                   	push   %rbp
  803491:	48 89 e5             	mov    %rsp,%rbp
  803494:	53                   	push   %rbx
  803495:	48 83 ec 38          	sub    $0x38,%rsp
  803499:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80349d:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8034a1:	48 89 c7             	mov    %rax,%rdi
  8034a4:	48 b8 b0 1e 80 00 00 	movabs $0x801eb0,%rax
  8034ab:	00 00 00 
  8034ae:	ff d0                	callq  *%rax
  8034b0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034b7:	0f 88 bf 01 00 00    	js     80367c <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034c1:	ba 07 04 00 00       	mov    $0x407,%edx
  8034c6:	48 89 c6             	mov    %rax,%rsi
  8034c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8034ce:	48 b8 fa 1a 80 00 00 	movabs $0x801afa,%rax
  8034d5:	00 00 00 
  8034d8:	ff d0                	callq  *%rax
  8034da:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034e1:	0f 88 95 01 00 00    	js     80367c <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8034e7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8034eb:	48 89 c7             	mov    %rax,%rdi
  8034ee:	48 b8 b0 1e 80 00 00 	movabs $0x801eb0,%rax
  8034f5:	00 00 00 
  8034f8:	ff d0                	callq  *%rax
  8034fa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803501:	0f 88 5d 01 00 00    	js     803664 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803507:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80350b:	ba 07 04 00 00       	mov    $0x407,%edx
  803510:	48 89 c6             	mov    %rax,%rsi
  803513:	bf 00 00 00 00       	mov    $0x0,%edi
  803518:	48 b8 fa 1a 80 00 00 	movabs $0x801afa,%rax
  80351f:	00 00 00 
  803522:	ff d0                	callq  *%rax
  803524:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803527:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80352b:	0f 88 33 01 00 00    	js     803664 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803531:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803535:	48 89 c7             	mov    %rax,%rdi
  803538:	48 b8 85 1e 80 00 00 	movabs $0x801e85,%rax
  80353f:	00 00 00 
  803542:	ff d0                	callq  *%rax
  803544:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803548:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80354c:	ba 07 04 00 00       	mov    $0x407,%edx
  803551:	48 89 c6             	mov    %rax,%rsi
  803554:	bf 00 00 00 00       	mov    $0x0,%edi
  803559:	48 b8 fa 1a 80 00 00 	movabs $0x801afa,%rax
  803560:	00 00 00 
  803563:	ff d0                	callq  *%rax
  803565:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803568:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80356c:	79 05                	jns    803573 <pipe+0xe3>
		goto err2;
  80356e:	e9 d9 00 00 00       	jmpq   80364c <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803573:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803577:	48 89 c7             	mov    %rax,%rdi
  80357a:	48 b8 85 1e 80 00 00 	movabs $0x801e85,%rax
  803581:	00 00 00 
  803584:	ff d0                	callq  *%rax
  803586:	48 89 c2             	mov    %rax,%rdx
  803589:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80358d:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803593:	48 89 d1             	mov    %rdx,%rcx
  803596:	ba 00 00 00 00       	mov    $0x0,%edx
  80359b:	48 89 c6             	mov    %rax,%rsi
  80359e:	bf 00 00 00 00       	mov    $0x0,%edi
  8035a3:	48 b8 4c 1b 80 00 00 	movabs $0x801b4c,%rax
  8035aa:	00 00 00 
  8035ad:	ff d0                	callq  *%rax
  8035af:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035b6:	79 1b                	jns    8035d3 <pipe+0x143>
		goto err3;
  8035b8:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8035b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035bd:	48 89 c6             	mov    %rax,%rsi
  8035c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8035c5:	48 b8 ac 1b 80 00 00 	movabs $0x801bac,%rax
  8035cc:	00 00 00 
  8035cf:	ff d0                	callq  *%rax
  8035d1:	eb 79                	jmp    80364c <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  8035d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035d7:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8035de:	00 00 00 
  8035e1:	8b 12                	mov    (%rdx),%edx
  8035e3:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8035e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035e9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  8035f0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035f4:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8035fb:	00 00 00 
  8035fe:	8b 12                	mov    (%rdx),%edx
  803600:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803602:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803606:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  80360d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803611:	48 89 c7             	mov    %rax,%rdi
  803614:	48 b8 62 1e 80 00 00 	movabs $0x801e62,%rax
  80361b:	00 00 00 
  80361e:	ff d0                	callq  *%rax
  803620:	89 c2                	mov    %eax,%edx
  803622:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803626:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803628:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80362c:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803630:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803634:	48 89 c7             	mov    %rax,%rdi
  803637:	48 b8 62 1e 80 00 00 	movabs $0x801e62,%rax
  80363e:	00 00 00 
  803641:	ff d0                	callq  *%rax
  803643:	89 03                	mov    %eax,(%rbx)
	return 0;
  803645:	b8 00 00 00 00       	mov    $0x0,%eax
  80364a:	eb 33                	jmp    80367f <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  80364c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803650:	48 89 c6             	mov    %rax,%rsi
  803653:	bf 00 00 00 00       	mov    $0x0,%edi
  803658:	48 b8 ac 1b 80 00 00 	movabs $0x801bac,%rax
  80365f:	00 00 00 
  803662:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803664:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803668:	48 89 c6             	mov    %rax,%rsi
  80366b:	bf 00 00 00 00       	mov    $0x0,%edi
  803670:	48 b8 ac 1b 80 00 00 	movabs $0x801bac,%rax
  803677:	00 00 00 
  80367a:	ff d0                	callq  *%rax
err:
	return r;
  80367c:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80367f:	48 83 c4 38          	add    $0x38,%rsp
  803683:	5b                   	pop    %rbx
  803684:	5d                   	pop    %rbp
  803685:	c3                   	retq   

0000000000803686 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803686:	55                   	push   %rbp
  803687:	48 89 e5             	mov    %rsp,%rbp
  80368a:	53                   	push   %rbx
  80368b:	48 83 ec 28          	sub    $0x28,%rsp
  80368f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803693:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803697:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80369e:	00 00 00 
  8036a1:	48 8b 00             	mov    (%rax),%rax
  8036a4:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8036aa:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8036ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036b1:	48 89 c7             	mov    %rax,%rdi
  8036b4:	48 b8 47 3f 80 00 00 	movabs $0x803f47,%rax
  8036bb:	00 00 00 
  8036be:	ff d0                	callq  *%rax
  8036c0:	89 c3                	mov    %eax,%ebx
  8036c2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036c6:	48 89 c7             	mov    %rax,%rdi
  8036c9:	48 b8 47 3f 80 00 00 	movabs $0x803f47,%rax
  8036d0:	00 00 00 
  8036d3:	ff d0                	callq  *%rax
  8036d5:	39 c3                	cmp    %eax,%ebx
  8036d7:	0f 94 c0             	sete   %al
  8036da:	0f b6 c0             	movzbl %al,%eax
  8036dd:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8036e0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8036e7:	00 00 00 
  8036ea:	48 8b 00             	mov    (%rax),%rax
  8036ed:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8036f3:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8036f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036f9:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8036fc:	75 05                	jne    803703 <_pipeisclosed+0x7d>
			return ret;
  8036fe:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803701:	eb 4a                	jmp    80374d <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803703:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803706:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803709:	74 3d                	je     803748 <_pipeisclosed+0xc2>
  80370b:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80370f:	75 37                	jne    803748 <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803711:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803718:	00 00 00 
  80371b:	48 8b 00             	mov    (%rax),%rax
  80371e:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803724:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803727:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80372a:	89 c6                	mov    %eax,%esi
  80372c:	48 bf bd 47 80 00 00 	movabs $0x8047bd,%rdi
  803733:	00 00 00 
  803736:	b8 00 00 00 00       	mov    $0x0,%eax
  80373b:	49 b8 33 06 80 00 00 	movabs $0x800633,%r8
  803742:	00 00 00 
  803745:	41 ff d0             	callq  *%r8
	}
  803748:	e9 4a ff ff ff       	jmpq   803697 <_pipeisclosed+0x11>
}
  80374d:	48 83 c4 28          	add    $0x28,%rsp
  803751:	5b                   	pop    %rbx
  803752:	5d                   	pop    %rbp
  803753:	c3                   	retq   

0000000000803754 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803754:	55                   	push   %rbp
  803755:	48 89 e5             	mov    %rsp,%rbp
  803758:	48 83 ec 30          	sub    $0x30,%rsp
  80375c:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80375f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803763:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803766:	48 89 d6             	mov    %rdx,%rsi
  803769:	89 c7                	mov    %eax,%edi
  80376b:	48 b8 48 1f 80 00 00 	movabs $0x801f48,%rax
  803772:	00 00 00 
  803775:	ff d0                	callq  *%rax
  803777:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80377a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80377e:	79 05                	jns    803785 <pipeisclosed+0x31>
		return r;
  803780:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803783:	eb 31                	jmp    8037b6 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803785:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803789:	48 89 c7             	mov    %rax,%rdi
  80378c:	48 b8 85 1e 80 00 00 	movabs $0x801e85,%rax
  803793:	00 00 00 
  803796:	ff d0                	callq  *%rax
  803798:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80379c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037a4:	48 89 d6             	mov    %rdx,%rsi
  8037a7:	48 89 c7             	mov    %rax,%rdi
  8037aa:	48 b8 86 36 80 00 00 	movabs $0x803686,%rax
  8037b1:	00 00 00 
  8037b4:	ff d0                	callq  *%rax
}
  8037b6:	c9                   	leaveq 
  8037b7:	c3                   	retq   

00000000008037b8 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8037b8:	55                   	push   %rbp
  8037b9:	48 89 e5             	mov    %rsp,%rbp
  8037bc:	48 83 ec 40          	sub    $0x40,%rsp
  8037c0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037c4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8037c8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8037cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037d0:	48 89 c7             	mov    %rax,%rdi
  8037d3:	48 b8 85 1e 80 00 00 	movabs $0x801e85,%rax
  8037da:	00 00 00 
  8037dd:	ff d0                	callq  *%rax
  8037df:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8037e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037e7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8037eb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8037f2:	00 
  8037f3:	e9 92 00 00 00       	jmpq   80388a <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8037f8:	eb 41                	jmp    80383b <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8037fa:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8037ff:	74 09                	je     80380a <devpipe_read+0x52>
				return i;
  803801:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803805:	e9 92 00 00 00       	jmpq   80389c <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80380a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80380e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803812:	48 89 d6             	mov    %rdx,%rsi
  803815:	48 89 c7             	mov    %rax,%rdi
  803818:	48 b8 86 36 80 00 00 	movabs $0x803686,%rax
  80381f:	00 00 00 
  803822:	ff d0                	callq  *%rax
  803824:	85 c0                	test   %eax,%eax
  803826:	74 07                	je     80382f <devpipe_read+0x77>
				return 0;
  803828:	b8 00 00 00 00       	mov    $0x0,%eax
  80382d:	eb 6d                	jmp    80389c <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80382f:	48 b8 be 1a 80 00 00 	movabs $0x801abe,%rax
  803836:	00 00 00 
  803839:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  80383b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80383f:	8b 10                	mov    (%rax),%edx
  803841:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803845:	8b 40 04             	mov    0x4(%rax),%eax
  803848:	39 c2                	cmp    %eax,%edx
  80384a:	74 ae                	je     8037fa <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80384c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803850:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803854:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803858:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80385c:	8b 00                	mov    (%rax),%eax
  80385e:	99                   	cltd   
  80385f:	c1 ea 1b             	shr    $0x1b,%edx
  803862:	01 d0                	add    %edx,%eax
  803864:	83 e0 1f             	and    $0x1f,%eax
  803867:	29 d0                	sub    %edx,%eax
  803869:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80386d:	48 98                	cltq   
  80386f:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803874:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803876:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80387a:	8b 00                	mov    (%rax),%eax
  80387c:	8d 50 01             	lea    0x1(%rax),%edx
  80387f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803883:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  803885:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80388a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80388e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803892:	0f 82 60 ff ff ff    	jb     8037f8 <devpipe_read+0x40>
	}
	return i;
  803898:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80389c:	c9                   	leaveq 
  80389d:	c3                   	retq   

000000000080389e <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80389e:	55                   	push   %rbp
  80389f:	48 89 e5             	mov    %rsp,%rbp
  8038a2:	48 83 ec 40          	sub    $0x40,%rsp
  8038a6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038aa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038ae:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8038b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038b6:	48 89 c7             	mov    %rax,%rdi
  8038b9:	48 b8 85 1e 80 00 00 	movabs $0x801e85,%rax
  8038c0:	00 00 00 
  8038c3:	ff d0                	callq  *%rax
  8038c5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8038c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038cd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8038d1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8038d8:	00 
  8038d9:	e9 91 00 00 00       	jmpq   80396f <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8038de:	eb 31                	jmp    803911 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8038e0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038e8:	48 89 d6             	mov    %rdx,%rsi
  8038eb:	48 89 c7             	mov    %rax,%rdi
  8038ee:	48 b8 86 36 80 00 00 	movabs $0x803686,%rax
  8038f5:	00 00 00 
  8038f8:	ff d0                	callq  *%rax
  8038fa:	85 c0                	test   %eax,%eax
  8038fc:	74 07                	je     803905 <devpipe_write+0x67>
				return 0;
  8038fe:	b8 00 00 00 00       	mov    $0x0,%eax
  803903:	eb 7c                	jmp    803981 <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803905:	48 b8 be 1a 80 00 00 	movabs $0x801abe,%rax
  80390c:	00 00 00 
  80390f:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803911:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803915:	8b 40 04             	mov    0x4(%rax),%eax
  803918:	48 63 d0             	movslq %eax,%rdx
  80391b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80391f:	8b 00                	mov    (%rax),%eax
  803921:	48 98                	cltq   
  803923:	48 83 c0 20          	add    $0x20,%rax
  803927:	48 39 c2             	cmp    %rax,%rdx
  80392a:	73 b4                	jae    8038e0 <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80392c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803930:	8b 40 04             	mov    0x4(%rax),%eax
  803933:	99                   	cltd   
  803934:	c1 ea 1b             	shr    $0x1b,%edx
  803937:	01 d0                	add    %edx,%eax
  803939:	83 e0 1f             	and    $0x1f,%eax
  80393c:	29 d0                	sub    %edx,%eax
  80393e:	89 c6                	mov    %eax,%esi
  803940:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803944:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803948:	48 01 d0             	add    %rdx,%rax
  80394b:	0f b6 08             	movzbl (%rax),%ecx
  80394e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803952:	48 63 c6             	movslq %esi,%rax
  803955:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803959:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80395d:	8b 40 04             	mov    0x4(%rax),%eax
  803960:	8d 50 01             	lea    0x1(%rax),%edx
  803963:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803967:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  80396a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80396f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803973:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803977:	0f 82 61 ff ff ff    	jb     8038de <devpipe_write+0x40>
	}

	return i;
  80397d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803981:	c9                   	leaveq 
  803982:	c3                   	retq   

0000000000803983 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803983:	55                   	push   %rbp
  803984:	48 89 e5             	mov    %rsp,%rbp
  803987:	48 83 ec 20          	sub    $0x20,%rsp
  80398b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80398f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803993:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803997:	48 89 c7             	mov    %rax,%rdi
  80399a:	48 b8 85 1e 80 00 00 	movabs $0x801e85,%rax
  8039a1:	00 00 00 
  8039a4:	ff d0                	callq  *%rax
  8039a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8039aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039ae:	48 be d0 47 80 00 00 	movabs $0x8047d0,%rsi
  8039b5:	00 00 00 
  8039b8:	48 89 c7             	mov    %rax,%rdi
  8039bb:	48 b8 cd 11 80 00 00 	movabs $0x8011cd,%rax
  8039c2:	00 00 00 
  8039c5:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8039c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039cb:	8b 50 04             	mov    0x4(%rax),%edx
  8039ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039d2:	8b 00                	mov    (%rax),%eax
  8039d4:	29 c2                	sub    %eax,%edx
  8039d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039da:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8039e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039e4:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8039eb:	00 00 00 
	stat->st_dev = &devpipe;
  8039ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039f2:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  8039f9:	00 00 00 
  8039fc:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803a03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a08:	c9                   	leaveq 
  803a09:	c3                   	retq   

0000000000803a0a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803a0a:	55                   	push   %rbp
  803a0b:	48 89 e5             	mov    %rsp,%rbp
  803a0e:	48 83 ec 10          	sub    $0x10,%rsp
  803a12:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803a16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a1a:	48 89 c6             	mov    %rax,%rsi
  803a1d:	bf 00 00 00 00       	mov    $0x0,%edi
  803a22:	48 b8 ac 1b 80 00 00 	movabs $0x801bac,%rax
  803a29:	00 00 00 
  803a2c:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803a2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a32:	48 89 c7             	mov    %rax,%rdi
  803a35:	48 b8 85 1e 80 00 00 	movabs $0x801e85,%rax
  803a3c:	00 00 00 
  803a3f:	ff d0                	callq  *%rax
  803a41:	48 89 c6             	mov    %rax,%rsi
  803a44:	bf 00 00 00 00       	mov    $0x0,%edi
  803a49:	48 b8 ac 1b 80 00 00 	movabs $0x801bac,%rax
  803a50:	00 00 00 
  803a53:	ff d0                	callq  *%rax
}
  803a55:	c9                   	leaveq 
  803a56:	c3                   	retq   

0000000000803a57 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803a57:	55                   	push   %rbp
  803a58:	48 89 e5             	mov    %rsp,%rbp
  803a5b:	48 83 ec 20          	sub    $0x20,%rsp
  803a5f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803a62:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a65:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803a68:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803a6c:	be 01 00 00 00       	mov    $0x1,%esi
  803a71:	48 89 c7             	mov    %rax,%rdi
  803a74:	48 b8 b4 19 80 00 00 	movabs $0x8019b4,%rax
  803a7b:	00 00 00 
  803a7e:	ff d0                	callq  *%rax
}
  803a80:	c9                   	leaveq 
  803a81:	c3                   	retq   

0000000000803a82 <getchar>:

int
getchar(void)
{
  803a82:	55                   	push   %rbp
  803a83:	48 89 e5             	mov    %rsp,%rbp
  803a86:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803a8a:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803a8e:	ba 01 00 00 00       	mov    $0x1,%edx
  803a93:	48 89 c6             	mov    %rax,%rsi
  803a96:	bf 00 00 00 00       	mov    $0x0,%edi
  803a9b:	48 b8 7c 23 80 00 00 	movabs $0x80237c,%rax
  803aa2:	00 00 00 
  803aa5:	ff d0                	callq  *%rax
  803aa7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803aaa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aae:	79 05                	jns    803ab5 <getchar+0x33>
		return r;
  803ab0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ab3:	eb 14                	jmp    803ac9 <getchar+0x47>
	if (r < 1)
  803ab5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ab9:	7f 07                	jg     803ac2 <getchar+0x40>
		return -E_EOF;
  803abb:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803ac0:	eb 07                	jmp    803ac9 <getchar+0x47>
	return c;
  803ac2:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803ac6:	0f b6 c0             	movzbl %al,%eax
}
  803ac9:	c9                   	leaveq 
  803aca:	c3                   	retq   

0000000000803acb <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803acb:	55                   	push   %rbp
  803acc:	48 89 e5             	mov    %rsp,%rbp
  803acf:	48 83 ec 20          	sub    $0x20,%rsp
  803ad3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ad6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803ada:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803add:	48 89 d6             	mov    %rdx,%rsi
  803ae0:	89 c7                	mov    %eax,%edi
  803ae2:	48 b8 48 1f 80 00 00 	movabs $0x801f48,%rax
  803ae9:	00 00 00 
  803aec:	ff d0                	callq  *%rax
  803aee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803af1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803af5:	79 05                	jns    803afc <iscons+0x31>
		return r;
  803af7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803afa:	eb 1a                	jmp    803b16 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803afc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b00:	8b 10                	mov    (%rax),%edx
  803b02:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803b09:	00 00 00 
  803b0c:	8b 00                	mov    (%rax),%eax
  803b0e:	39 c2                	cmp    %eax,%edx
  803b10:	0f 94 c0             	sete   %al
  803b13:	0f b6 c0             	movzbl %al,%eax
}
  803b16:	c9                   	leaveq 
  803b17:	c3                   	retq   

0000000000803b18 <opencons>:

int
opencons(void)
{
  803b18:	55                   	push   %rbp
  803b19:	48 89 e5             	mov    %rsp,%rbp
  803b1c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803b20:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803b24:	48 89 c7             	mov    %rax,%rdi
  803b27:	48 b8 b0 1e 80 00 00 	movabs $0x801eb0,%rax
  803b2e:	00 00 00 
  803b31:	ff d0                	callq  *%rax
  803b33:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b36:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b3a:	79 05                	jns    803b41 <opencons+0x29>
		return r;
  803b3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b3f:	eb 5b                	jmp    803b9c <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803b41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b45:	ba 07 04 00 00       	mov    $0x407,%edx
  803b4a:	48 89 c6             	mov    %rax,%rsi
  803b4d:	bf 00 00 00 00       	mov    $0x0,%edi
  803b52:	48 b8 fa 1a 80 00 00 	movabs $0x801afa,%rax
  803b59:	00 00 00 
  803b5c:	ff d0                	callq  *%rax
  803b5e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b61:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b65:	79 05                	jns    803b6c <opencons+0x54>
		return r;
  803b67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b6a:	eb 30                	jmp    803b9c <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803b6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b70:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803b77:	00 00 00 
  803b7a:	8b 12                	mov    (%rdx),%edx
  803b7c:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803b7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b82:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803b89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b8d:	48 89 c7             	mov    %rax,%rdi
  803b90:	48 b8 62 1e 80 00 00 	movabs $0x801e62,%rax
  803b97:	00 00 00 
  803b9a:	ff d0                	callq  *%rax
}
  803b9c:	c9                   	leaveq 
  803b9d:	c3                   	retq   

0000000000803b9e <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803b9e:	55                   	push   %rbp
  803b9f:	48 89 e5             	mov    %rsp,%rbp
  803ba2:	48 83 ec 30          	sub    $0x30,%rsp
  803ba6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803baa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803bb2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803bb7:	75 07                	jne    803bc0 <devcons_read+0x22>
		return 0;
  803bb9:	b8 00 00 00 00       	mov    $0x0,%eax
  803bbe:	eb 4b                	jmp    803c0b <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803bc0:	eb 0c                	jmp    803bce <devcons_read+0x30>
		sys_yield();
  803bc2:	48 b8 be 1a 80 00 00 	movabs $0x801abe,%rax
  803bc9:	00 00 00 
  803bcc:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  803bce:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  803bd5:	00 00 00 
  803bd8:	ff d0                	callq  *%rax
  803bda:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bdd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803be1:	74 df                	je     803bc2 <devcons_read+0x24>
	if (c < 0)
  803be3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803be7:	79 05                	jns    803bee <devcons_read+0x50>
		return c;
  803be9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bec:	eb 1d                	jmp    803c0b <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803bee:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803bf2:	75 07                	jne    803bfb <devcons_read+0x5d>
		return 0;
  803bf4:	b8 00 00 00 00       	mov    $0x0,%eax
  803bf9:	eb 10                	jmp    803c0b <devcons_read+0x6d>
	*(char*)vbuf = c;
  803bfb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bfe:	89 c2                	mov    %eax,%edx
  803c00:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c04:	88 10                	mov    %dl,(%rax)
	return 1;
  803c06:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803c0b:	c9                   	leaveq 
  803c0c:	c3                   	retq   

0000000000803c0d <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803c0d:	55                   	push   %rbp
  803c0e:	48 89 e5             	mov    %rsp,%rbp
  803c11:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803c18:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803c1f:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803c26:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803c2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c34:	eb 76                	jmp    803cac <devcons_write+0x9f>
		m = n - tot;
  803c36:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803c3d:	89 c2                	mov    %eax,%edx
  803c3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c42:	29 c2                	sub    %eax,%edx
  803c44:	89 d0                	mov    %edx,%eax
  803c46:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803c49:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c4c:	83 f8 7f             	cmp    $0x7f,%eax
  803c4f:	76 07                	jbe    803c58 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803c51:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803c58:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c5b:	48 63 d0             	movslq %eax,%rdx
  803c5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c61:	48 63 c8             	movslq %eax,%rcx
  803c64:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803c6b:	48 01 c1             	add    %rax,%rcx
  803c6e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803c75:	48 89 ce             	mov    %rcx,%rsi
  803c78:	48 89 c7             	mov    %rax,%rdi
  803c7b:	48 b8 f1 14 80 00 00 	movabs $0x8014f1,%rax
  803c82:	00 00 00 
  803c85:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803c87:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c8a:	48 63 d0             	movslq %eax,%rdx
  803c8d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803c94:	48 89 d6             	mov    %rdx,%rsi
  803c97:	48 89 c7             	mov    %rax,%rdi
  803c9a:	48 b8 b4 19 80 00 00 	movabs $0x8019b4,%rax
  803ca1:	00 00 00 
  803ca4:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  803ca6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ca9:	01 45 fc             	add    %eax,-0x4(%rbp)
  803cac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803caf:	48 98                	cltq   
  803cb1:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803cb8:	0f 82 78 ff ff ff    	jb     803c36 <devcons_write+0x29>
	}
	return tot;
  803cbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803cc1:	c9                   	leaveq 
  803cc2:	c3                   	retq   

0000000000803cc3 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803cc3:	55                   	push   %rbp
  803cc4:	48 89 e5             	mov    %rsp,%rbp
  803cc7:	48 83 ec 08          	sub    $0x8,%rsp
  803ccb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803ccf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cd4:	c9                   	leaveq 
  803cd5:	c3                   	retq   

0000000000803cd6 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803cd6:	55                   	push   %rbp
  803cd7:	48 89 e5             	mov    %rsp,%rbp
  803cda:	48 83 ec 10          	sub    $0x10,%rsp
  803cde:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ce2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803ce6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cea:	48 be dc 47 80 00 00 	movabs $0x8047dc,%rsi
  803cf1:	00 00 00 
  803cf4:	48 89 c7             	mov    %rax,%rdi
  803cf7:	48 b8 cd 11 80 00 00 	movabs $0x8011cd,%rax
  803cfe:	00 00 00 
  803d01:	ff d0                	callq  *%rax
	return 0;
  803d03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d08:	c9                   	leaveq 
  803d09:	c3                   	retq   

0000000000803d0a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803d0a:	55                   	push   %rbp
  803d0b:	48 89 e5             	mov    %rsp,%rbp
  803d0e:	48 83 ec 20          	sub    $0x20,%rsp
  803d12:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d16:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d1a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  803d1e:	48 ba e8 47 80 00 00 	movabs $0x8047e8,%rdx
  803d25:	00 00 00 
  803d28:	be 1d 00 00 00       	mov    $0x1d,%esi
  803d2d:	48 bf 01 48 80 00 00 	movabs $0x804801,%rdi
  803d34:	00 00 00 
  803d37:	b8 00 00 00 00       	mov    $0x0,%eax
  803d3c:	48 b9 fa 03 80 00 00 	movabs $0x8003fa,%rcx
  803d43:	00 00 00 
  803d46:	ff d1                	callq  *%rcx

0000000000803d48 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803d48:	55                   	push   %rbp
  803d49:	48 89 e5             	mov    %rsp,%rbp
  803d4c:	48 83 ec 20          	sub    $0x20,%rsp
  803d50:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d53:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803d56:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  803d5a:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  803d5d:	48 ba 0b 48 80 00 00 	movabs $0x80480b,%rdx
  803d64:	00 00 00 
  803d67:	be 2d 00 00 00       	mov    $0x2d,%esi
  803d6c:	48 bf 01 48 80 00 00 	movabs $0x804801,%rdi
  803d73:	00 00 00 
  803d76:	b8 00 00 00 00       	mov    $0x0,%eax
  803d7b:	48 b9 fa 03 80 00 00 	movabs $0x8003fa,%rcx
  803d82:	00 00 00 
  803d85:	ff d1                	callq  *%rcx

0000000000803d87 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803d87:	55                   	push   %rbp
  803d88:	48 89 e5             	mov    %rsp,%rbp
  803d8b:	53                   	push   %rbx
  803d8c:	48 83 ec 48          	sub    $0x48,%rsp
  803d90:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  803d94:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  803d9b:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  803da2:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  803da7:	75 0e                	jne    803db7 <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  803da9:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803db0:	00 00 00 
  803db3:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  803db7:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803dbb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  803dbf:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803dc6:	00 
	a3 = (uint64_t) 0;
  803dc7:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  803dce:	00 
	a4 = (uint64_t) 0;
  803dcf:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803dd6:	00 
	a5 = 0;
  803dd7:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  803dde:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  803ddf:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803de2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803de6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803dea:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  803dee:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  803df2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  803df6:	4c 89 c3             	mov    %r8,%rbx
  803df9:	0f 01 c1             	vmcall 
  803dfc:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  803dff:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e03:	7e 36                	jle    803e3b <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  803e05:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803e08:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803e0b:	41 89 d0             	mov    %edx,%r8d
  803e0e:	89 c1                	mov    %eax,%ecx
  803e10:	48 ba 28 48 80 00 00 	movabs $0x804828,%rdx
  803e17:	00 00 00 
  803e1a:	be 54 00 00 00       	mov    $0x54,%esi
  803e1f:	48 bf 01 48 80 00 00 	movabs $0x804801,%rdi
  803e26:	00 00 00 
  803e29:	b8 00 00 00 00       	mov    $0x0,%eax
  803e2e:	49 b9 fa 03 80 00 00 	movabs $0x8003fa,%r9
  803e35:	00 00 00 
  803e38:	41 ff d1             	callq  *%r9
	return ret;
  803e3b:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803e3e:	48 83 c4 48          	add    $0x48,%rsp
  803e42:	5b                   	pop    %rbx
  803e43:	5d                   	pop    %rbp
  803e44:	c3                   	retq   

0000000000803e45 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803e45:	55                   	push   %rbp
  803e46:	48 89 e5             	mov    %rsp,%rbp
  803e49:	53                   	push   %rbx
  803e4a:	48 83 ec 58          	sub    $0x58,%rsp
  803e4e:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  803e51:	89 75 b0             	mov    %esi,-0x50(%rbp)
  803e54:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  803e58:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  803e5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  803e62:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  803e69:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  803e6e:	75 0e                	jne    803e7e <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  803e70:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803e77:	00 00 00 
  803e7a:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  803e7e:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  803e81:	48 98                	cltq   
  803e83:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  803e87:	8b 45 b0             	mov    -0x50(%rbp),%eax
  803e8a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  803e8e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803e92:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  803e96:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  803e99:	48 98                	cltq   
  803e9b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  803e9f:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803ea6:	00 

	int r = -E_IPC_NOT_RECV;
  803ea7:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  803eae:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803eb1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803eb5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803eb9:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  803ebd:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803ec1:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  803ec5:	4c 89 c3             	mov    %r8,%rbx
  803ec8:	0f 01 c1             	vmcall 
  803ecb:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  803ece:	48 83 c4 58          	add    $0x58,%rsp
  803ed2:	5b                   	pop    %rbx
  803ed3:	5d                   	pop    %rbp
  803ed4:	c3                   	retq   

0000000000803ed5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803ed5:	55                   	push   %rbp
  803ed6:	48 89 e5             	mov    %rsp,%rbp
  803ed9:	48 83 ec 18          	sub    $0x18,%rsp
  803edd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803ee0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ee7:	eb 4e                	jmp    803f37 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  803ee9:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803ef0:	00 00 00 
  803ef3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ef6:	48 98                	cltq   
  803ef8:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803eff:	48 01 d0             	add    %rdx,%rax
  803f02:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803f08:	8b 00                	mov    (%rax),%eax
  803f0a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803f0d:	75 24                	jne    803f33 <ipc_find_env+0x5e>
			return envs[i].env_id;
  803f0f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803f16:	00 00 00 
  803f19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f1c:	48 98                	cltq   
  803f1e:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803f25:	48 01 d0             	add    %rdx,%rax
  803f28:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803f2e:	8b 40 08             	mov    0x8(%rax),%eax
  803f31:	eb 12                	jmp    803f45 <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  803f33:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803f37:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803f3e:	7e a9                	jle    803ee9 <ipc_find_env+0x14>
	}
	return 0;
  803f40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f45:	c9                   	leaveq 
  803f46:	c3                   	retq   

0000000000803f47 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803f47:	55                   	push   %rbp
  803f48:	48 89 e5             	mov    %rsp,%rbp
  803f4b:	48 83 ec 18          	sub    $0x18,%rsp
  803f4f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803f53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f57:	48 c1 e8 15          	shr    $0x15,%rax
  803f5b:	48 89 c2             	mov    %rax,%rdx
  803f5e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803f65:	01 00 00 
  803f68:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f6c:	83 e0 01             	and    $0x1,%eax
  803f6f:	48 85 c0             	test   %rax,%rax
  803f72:	75 07                	jne    803f7b <pageref+0x34>
		return 0;
  803f74:	b8 00 00 00 00       	mov    $0x0,%eax
  803f79:	eb 53                	jmp    803fce <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803f7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f7f:	48 c1 e8 0c          	shr    $0xc,%rax
  803f83:	48 89 c2             	mov    %rax,%rdx
  803f86:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803f8d:	01 00 00 
  803f90:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803f94:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803f98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f9c:	83 e0 01             	and    $0x1,%eax
  803f9f:	48 85 c0             	test   %rax,%rax
  803fa2:	75 07                	jne    803fab <pageref+0x64>
		return 0;
  803fa4:	b8 00 00 00 00       	mov    $0x0,%eax
  803fa9:	eb 23                	jmp    803fce <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803fab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803faf:	48 c1 e8 0c          	shr    $0xc,%rax
  803fb3:	48 89 c2             	mov    %rax,%rdx
  803fb6:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803fbd:	00 00 00 
  803fc0:	48 c1 e2 04          	shl    $0x4,%rdx
  803fc4:	48 01 d0             	add    %rdx,%rax
  803fc7:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803fcb:	0f b7 c0             	movzwl %ax,%eax
}
  803fce:	c9                   	leaveq 
  803fcf:	c3                   	retq   
