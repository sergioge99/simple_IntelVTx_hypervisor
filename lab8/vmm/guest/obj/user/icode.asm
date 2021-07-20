
vmm/guest/obj/user/icode:     formato del fichero elf64-x86-64


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
  80003c:	e8 18 02 00 00       	callq  800259 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#define MOTD "/motd"
#endif

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80004e:	89 bd ec fd ff ff    	mov    %edi,-0x214(%rbp)
  800054:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80005b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800062:	00 00 00 
  800065:	48 b9 40 49 80 00 00 	movabs $0x804940,%rcx
  80006c:	00 00 00 
  80006f:	48 89 08             	mov    %rcx,(%rax)

	cprintf("icode startup\n");
  800072:	48 bf 46 49 80 00 00 	movabs $0x804946,%rdi
  800079:	00 00 00 
  80007c:	b8 00 00 00 00       	mov    $0x0,%eax
  800081:	48 ba 15 05 80 00 00 	movabs $0x800515,%rdx
  800088:	00 00 00 
  80008b:	ff d2                	callq  *%rdx

	cprintf("icode: open /motd\n");
  80008d:	48 bf 55 49 80 00 00 	movabs $0x804955,%rdi
  800094:	00 00 00 
  800097:	b8 00 00 00 00       	mov    $0x0,%eax
  80009c:	48 ba 15 05 80 00 00 	movabs $0x800515,%rdx
  8000a3:	00 00 00 
  8000a6:	ff d2                	callq  *%rdx
	if ((fd = open(MOTD, O_RDONLY)) < 0)
  8000a8:	be 00 00 00 00       	mov    $0x0,%esi
  8000ad:	48 bf 68 49 80 00 00 	movabs $0x804968,%rdi
  8000b4:	00 00 00 
  8000b7:	48 b8 36 27 80 00 00 	movabs $0x802736,%rax
  8000be:	00 00 00 
  8000c1:	ff d0                	callq  *%rax
  8000c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000ca:	79 30                	jns    8000fc <umain+0xb9>
		panic("icode: open /motd: %e", fd);
  8000cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000cf:	89 c1                	mov    %eax,%ecx
  8000d1:	48 ba 74 49 80 00 00 	movabs $0x804974,%rdx
  8000d8:	00 00 00 
  8000db:	be 15 00 00 00       	mov    $0x15,%esi
  8000e0:	48 bf 8a 49 80 00 00 	movabs $0x80498a,%rdi
  8000e7:	00 00 00 
  8000ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ef:	49 b8 dc 02 80 00 00 	movabs $0x8002dc,%r8
  8000f6:	00 00 00 
  8000f9:	41 ff d0             	callq  *%r8

	cprintf("icode: read /motd\n");
  8000fc:	48 bf 97 49 80 00 00 	movabs $0x804997,%rdi
  800103:	00 00 00 
  800106:	b8 00 00 00 00       	mov    $0x0,%eax
  80010b:	48 ba 15 05 80 00 00 	movabs $0x800515,%rdx
  800112:	00 00 00 
  800115:	ff d2                	callq  *%rdx
	while ((n = read(fd, buf, sizeof buf-1)) > 0) {
  800117:	eb 3a                	jmp    800153 <umain+0x110>
		cprintf("Writing MOTD\n");
  800119:	48 bf aa 49 80 00 00 	movabs $0x8049aa,%rdi
  800120:	00 00 00 
  800123:	b8 00 00 00 00       	mov    $0x0,%eax
  800128:	48 ba 15 05 80 00 00 	movabs $0x800515,%rdx
  80012f:	00 00 00 
  800132:	ff d2                	callq  *%rdx
		sys_cputs(buf, n);
  800134:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800137:	48 63 d0             	movslq %eax,%rdx
  80013a:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  800141:	48 89 d6             	mov    %rdx,%rsi
  800144:	48 89 c7             	mov    %rax,%rdi
  800147:	48 b8 96 18 80 00 00 	movabs $0x801896,%rax
  80014e:	00 00 00 
  800151:	ff d0                	callq  *%rax
	while ((n = read(fd, buf, sizeof buf-1)) > 0) {
  800153:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80015a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80015d:	ba 00 02 00 00       	mov    $0x200,%edx
  800162:	48 89 ce             	mov    %rcx,%rsi
  800165:	89 c7                	mov    %eax,%edi
  800167:	48 b8 5e 22 80 00 00 	movabs $0x80225e,%rax
  80016e:	00 00 00 
  800171:	ff d0                	callq  *%rax
  800173:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800176:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80017a:	7f 9d                	jg     800119 <umain+0xd6>
	}

	cprintf("icode: close /motd\n");
  80017c:	48 bf b8 49 80 00 00 	movabs $0x8049b8,%rdi
  800183:	00 00 00 
  800186:	b8 00 00 00 00       	mov    $0x0,%eax
  80018b:	48 ba 15 05 80 00 00 	movabs $0x800515,%rdx
  800192:	00 00 00 
  800195:	ff d2                	callq  *%rdx
	close(fd);
  800197:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80019a:	89 c7                	mov    %eax,%edi
  80019c:	48 b8 3c 20 80 00 00 	movabs $0x80203c,%rax
  8001a3:	00 00 00 
  8001a6:	ff d0                	callq  *%rax

	cprintf("icode: spawn /sbin/init\n");
  8001a8:	48 bf cc 49 80 00 00 	movabs $0x8049cc,%rdi
  8001af:	00 00 00 
  8001b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b7:	48 ba 15 05 80 00 00 	movabs $0x800515,%rdx
  8001be:	00 00 00 
  8001c1:	ff d2                	callq  *%rdx
	if ((r = spawnl("/sbin/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8001c3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001c9:	48 b9 e5 49 80 00 00 	movabs $0x8049e5,%rcx
  8001d0:	00 00 00 
  8001d3:	48 ba ee 49 80 00 00 	movabs $0x8049ee,%rdx
  8001da:	00 00 00 
  8001dd:	48 be f7 49 80 00 00 	movabs $0x8049f7,%rsi
  8001e4:	00 00 00 
  8001e7:	48 bf fc 49 80 00 00 	movabs $0x8049fc,%rdi
  8001ee:	00 00 00 
  8001f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f6:	49 b9 bd 2e 80 00 00 	movabs $0x802ebd,%r9
  8001fd:	00 00 00 
  800200:	41 ff d1             	callq  *%r9
  800203:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800206:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80020a:	79 30                	jns    80023c <umain+0x1f9>
		panic("icode: spawn /sbin/init: %e", r);
  80020c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80020f:	89 c1                	mov    %eax,%ecx
  800211:	48 ba 07 4a 80 00 00 	movabs $0x804a07,%rdx
  800218:	00 00 00 
  80021b:	be 22 00 00 00       	mov    $0x22,%esi
  800220:	48 bf 8a 49 80 00 00 	movabs $0x80498a,%rdi
  800227:	00 00 00 
  80022a:	b8 00 00 00 00       	mov    $0x0,%eax
  80022f:	49 b8 dc 02 80 00 00 	movabs $0x8002dc,%r8
  800236:	00 00 00 
  800239:	41 ff d0             	callq  *%r8
	cprintf("icode: exiting\n");
  80023c:	48 bf 23 4a 80 00 00 	movabs $0x804a23,%rdi
  800243:	00 00 00 
  800246:	b8 00 00 00 00       	mov    $0x0,%eax
  80024b:	48 ba 15 05 80 00 00 	movabs $0x800515,%rdx
  800252:	00 00 00 
  800255:	ff d2                	callq  *%rdx
}
  800257:	c9                   	leaveq 
  800258:	c3                   	retq   

0000000000800259 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800259:	55                   	push   %rbp
  80025a:	48 89 e5             	mov    %rsp,%rbp
  80025d:	48 83 ec 10          	sub    $0x10,%rsp
  800261:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800264:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800268:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80026f:	00 00 00 
  800272:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800279:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80027d:	7e 14                	jle    800293 <libmain+0x3a>
		binaryname = argv[0];
  80027f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800283:	48 8b 10             	mov    (%rax),%rdx
  800286:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80028d:	00 00 00 
  800290:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800293:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800297:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80029a:	48 89 d6             	mov    %rdx,%rsi
  80029d:	89 c7                	mov    %eax,%edi
  80029f:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002a6:	00 00 00 
  8002a9:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8002ab:	48 b8 b9 02 80 00 00 	movabs $0x8002b9,%rax
  8002b2:	00 00 00 
  8002b5:	ff d0                	callq  *%rax
}
  8002b7:	c9                   	leaveq 
  8002b8:	c3                   	retq   

00000000008002b9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002b9:	55                   	push   %rbp
  8002ba:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8002bd:	48 b8 87 20 80 00 00 	movabs $0x802087,%rax
  8002c4:	00 00 00 
  8002c7:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8002c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8002ce:	48 b8 1e 19 80 00 00 	movabs $0x80191e,%rax
  8002d5:	00 00 00 
  8002d8:	ff d0                	callq  *%rax
}
  8002da:	5d                   	pop    %rbp
  8002db:	c3                   	retq   

00000000008002dc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002dc:	55                   	push   %rbp
  8002dd:	48 89 e5             	mov    %rsp,%rbp
  8002e0:	53                   	push   %rbx
  8002e1:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8002e8:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8002ef:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8002f5:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8002fc:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800303:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80030a:	84 c0                	test   %al,%al
  80030c:	74 23                	je     800331 <_panic+0x55>
  80030e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800315:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800319:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80031d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800321:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800325:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800329:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80032d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800331:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800338:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80033f:	00 00 00 
  800342:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800349:	00 00 00 
  80034c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800350:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800357:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80035e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800365:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80036c:	00 00 00 
  80036f:	48 8b 18             	mov    (%rax),%rbx
  800372:	48 b8 64 19 80 00 00 	movabs $0x801964,%rax
  800379:	00 00 00 
  80037c:	ff d0                	callq  *%rax
  80037e:	89 c6                	mov    %eax,%esi
  800380:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800386:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80038d:	41 89 d0             	mov    %edx,%r8d
  800390:	48 89 c1             	mov    %rax,%rcx
  800393:	48 89 da             	mov    %rbx,%rdx
  800396:	48 bf 40 4a 80 00 00 	movabs $0x804a40,%rdi
  80039d:	00 00 00 
  8003a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a5:	49 b9 15 05 80 00 00 	movabs $0x800515,%r9
  8003ac:	00 00 00 
  8003af:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003b2:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8003b9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003c0:	48 89 d6             	mov    %rdx,%rsi
  8003c3:	48 89 c7             	mov    %rax,%rdi
  8003c6:	48 b8 69 04 80 00 00 	movabs $0x800469,%rax
  8003cd:	00 00 00 
  8003d0:	ff d0                	callq  *%rax
	cprintf("\n");
  8003d2:	48 bf 63 4a 80 00 00 	movabs $0x804a63,%rdi
  8003d9:	00 00 00 
  8003dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e1:	48 ba 15 05 80 00 00 	movabs $0x800515,%rdx
  8003e8:	00 00 00 
  8003eb:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003ed:	cc                   	int3   
  8003ee:	eb fd                	jmp    8003ed <_panic+0x111>

00000000008003f0 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8003f0:	55                   	push   %rbp
  8003f1:	48 89 e5             	mov    %rsp,%rbp
  8003f4:	48 83 ec 10          	sub    $0x10,%rsp
  8003f8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003fb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8003ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800403:	8b 00                	mov    (%rax),%eax
  800405:	8d 48 01             	lea    0x1(%rax),%ecx
  800408:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80040c:	89 0a                	mov    %ecx,(%rdx)
  80040e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800411:	89 d1                	mov    %edx,%ecx
  800413:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800417:	48 98                	cltq   
  800419:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80041d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800421:	8b 00                	mov    (%rax),%eax
  800423:	3d ff 00 00 00       	cmp    $0xff,%eax
  800428:	75 2c                	jne    800456 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80042a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042e:	8b 00                	mov    (%rax),%eax
  800430:	48 98                	cltq   
  800432:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800436:	48 83 c2 08          	add    $0x8,%rdx
  80043a:	48 89 c6             	mov    %rax,%rsi
  80043d:	48 89 d7             	mov    %rdx,%rdi
  800440:	48 b8 96 18 80 00 00 	movabs $0x801896,%rax
  800447:	00 00 00 
  80044a:	ff d0                	callq  *%rax
        b->idx = 0;
  80044c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800450:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800456:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80045a:	8b 40 04             	mov    0x4(%rax),%eax
  80045d:	8d 50 01             	lea    0x1(%rax),%edx
  800460:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800464:	89 50 04             	mov    %edx,0x4(%rax)
}
  800467:	c9                   	leaveq 
  800468:	c3                   	retq   

0000000000800469 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800469:	55                   	push   %rbp
  80046a:	48 89 e5             	mov    %rsp,%rbp
  80046d:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800474:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80047b:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800482:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800489:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800490:	48 8b 0a             	mov    (%rdx),%rcx
  800493:	48 89 08             	mov    %rcx,(%rax)
  800496:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80049a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80049e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004a2:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8004a6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004ad:	00 00 00 
    b.cnt = 0;
  8004b0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004b7:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8004ba:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004c1:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004c8:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004cf:	48 89 c6             	mov    %rax,%rsi
  8004d2:	48 bf f0 03 80 00 00 	movabs $0x8003f0,%rdi
  8004d9:	00 00 00 
  8004dc:	48 b8 b4 08 80 00 00 	movabs $0x8008b4,%rax
  8004e3:	00 00 00 
  8004e6:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8004e8:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8004ee:	48 98                	cltq   
  8004f0:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8004f7:	48 83 c2 08          	add    $0x8,%rdx
  8004fb:	48 89 c6             	mov    %rax,%rsi
  8004fe:	48 89 d7             	mov    %rdx,%rdi
  800501:	48 b8 96 18 80 00 00 	movabs $0x801896,%rax
  800508:	00 00 00 
  80050b:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80050d:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800513:	c9                   	leaveq 
  800514:	c3                   	retq   

0000000000800515 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800515:	55                   	push   %rbp
  800516:	48 89 e5             	mov    %rsp,%rbp
  800519:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800520:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800527:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80052e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800535:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80053c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800543:	84 c0                	test   %al,%al
  800545:	74 20                	je     800567 <cprintf+0x52>
  800547:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80054b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80054f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800553:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800557:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80055b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80055f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800563:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800567:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80056e:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800575:	00 00 00 
  800578:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80057f:	00 00 00 
  800582:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800586:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80058d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800594:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80059b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8005a2:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005a9:	48 8b 0a             	mov    (%rdx),%rcx
  8005ac:	48 89 08             	mov    %rcx,(%rax)
  8005af:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005b3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005b7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005bb:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8005bf:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005c6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005cd:	48 89 d6             	mov    %rdx,%rsi
  8005d0:	48 89 c7             	mov    %rax,%rdi
  8005d3:	48 b8 69 04 80 00 00 	movabs $0x800469,%rax
  8005da:	00 00 00 
  8005dd:	ff d0                	callq  *%rax
  8005df:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8005e5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8005eb:	c9                   	leaveq 
  8005ec:	c3                   	retq   

00000000008005ed <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005ed:	55                   	push   %rbp
  8005ee:	48 89 e5             	mov    %rsp,%rbp
  8005f1:	48 83 ec 30          	sub    $0x30,%rsp
  8005f5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8005f9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8005fd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800601:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800604:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800608:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80060c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80060f:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800613:	77 42                	ja     800657 <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800615:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800618:	8d 78 ff             	lea    -0x1(%rax),%edi
  80061b:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  80061e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800622:	ba 00 00 00 00       	mov    $0x0,%edx
  800627:	48 f7 f6             	div    %rsi
  80062a:	49 89 c2             	mov    %rax,%r10
  80062d:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800630:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800633:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800637:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80063b:	41 89 c9             	mov    %ecx,%r9d
  80063e:	41 89 f8             	mov    %edi,%r8d
  800641:	89 d1                	mov    %edx,%ecx
  800643:	4c 89 d2             	mov    %r10,%rdx
  800646:	48 89 c7             	mov    %rax,%rdi
  800649:	48 b8 ed 05 80 00 00 	movabs $0x8005ed,%rax
  800650:	00 00 00 
  800653:	ff d0                	callq  *%rax
  800655:	eb 1e                	jmp    800675 <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800657:	eb 12                	jmp    80066b <printnum+0x7e>
			putch(padc, putdat);
  800659:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80065d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800660:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800664:	48 89 ce             	mov    %rcx,%rsi
  800667:	89 d7                	mov    %edx,%edi
  800669:	ff d0                	callq  *%rax
		while (--width > 0)
  80066b:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80066f:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800673:	7f e4                	jg     800659 <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800675:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800678:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067c:	ba 00 00 00 00       	mov    $0x0,%edx
  800681:	48 f7 f1             	div    %rcx
  800684:	48 b8 70 4c 80 00 00 	movabs $0x804c70,%rax
  80068b:	00 00 00 
  80068e:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800692:	0f be d0             	movsbl %al,%edx
  800695:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800699:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80069d:	48 89 ce             	mov    %rcx,%rsi
  8006a0:	89 d7                	mov    %edx,%edi
  8006a2:	ff d0                	callq  *%rax
}
  8006a4:	c9                   	leaveq 
  8006a5:	c3                   	retq   

00000000008006a6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006a6:	55                   	push   %rbp
  8006a7:	48 89 e5             	mov    %rsp,%rbp
  8006aa:	48 83 ec 20          	sub    $0x20,%rsp
  8006ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006b2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8006b5:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006b9:	7e 4f                	jle    80070a <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8006bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bf:	8b 00                	mov    (%rax),%eax
  8006c1:	83 f8 30             	cmp    $0x30,%eax
  8006c4:	73 24                	jae    8006ea <getuint+0x44>
  8006c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ca:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d2:	8b 00                	mov    (%rax),%eax
  8006d4:	89 c0                	mov    %eax,%eax
  8006d6:	48 01 d0             	add    %rdx,%rax
  8006d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006dd:	8b 12                	mov    (%rdx),%edx
  8006df:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e6:	89 0a                	mov    %ecx,(%rdx)
  8006e8:	eb 14                	jmp    8006fe <getuint+0x58>
  8006ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ee:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006f2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006fe:	48 8b 00             	mov    (%rax),%rax
  800701:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800705:	e9 9d 00 00 00       	jmpq   8007a7 <getuint+0x101>
	else if (lflag)
  80070a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80070e:	74 4c                	je     80075c <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800710:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800714:	8b 00                	mov    (%rax),%eax
  800716:	83 f8 30             	cmp    $0x30,%eax
  800719:	73 24                	jae    80073f <getuint+0x99>
  80071b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800723:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800727:	8b 00                	mov    (%rax),%eax
  800729:	89 c0                	mov    %eax,%eax
  80072b:	48 01 d0             	add    %rdx,%rax
  80072e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800732:	8b 12                	mov    (%rdx),%edx
  800734:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800737:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80073b:	89 0a                	mov    %ecx,(%rdx)
  80073d:	eb 14                	jmp    800753 <getuint+0xad>
  80073f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800743:	48 8b 40 08          	mov    0x8(%rax),%rax
  800747:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80074b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800753:	48 8b 00             	mov    (%rax),%rax
  800756:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80075a:	eb 4b                	jmp    8007a7 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  80075c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800760:	8b 00                	mov    (%rax),%eax
  800762:	83 f8 30             	cmp    $0x30,%eax
  800765:	73 24                	jae    80078b <getuint+0xe5>
  800767:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80076f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800773:	8b 00                	mov    (%rax),%eax
  800775:	89 c0                	mov    %eax,%eax
  800777:	48 01 d0             	add    %rdx,%rax
  80077a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077e:	8b 12                	mov    (%rdx),%edx
  800780:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800783:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800787:	89 0a                	mov    %ecx,(%rdx)
  800789:	eb 14                	jmp    80079f <getuint+0xf9>
  80078b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078f:	48 8b 40 08          	mov    0x8(%rax),%rax
  800793:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800797:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80079f:	8b 00                	mov    (%rax),%eax
  8007a1:	89 c0                	mov    %eax,%eax
  8007a3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007ab:	c9                   	leaveq 
  8007ac:	c3                   	retq   

00000000008007ad <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007ad:	55                   	push   %rbp
  8007ae:	48 89 e5             	mov    %rsp,%rbp
  8007b1:	48 83 ec 20          	sub    $0x20,%rsp
  8007b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007b9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007bc:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007c0:	7e 4f                	jle    800811 <getint+0x64>
		x=va_arg(*ap, long long);
  8007c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c6:	8b 00                	mov    (%rax),%eax
  8007c8:	83 f8 30             	cmp    $0x30,%eax
  8007cb:	73 24                	jae    8007f1 <getint+0x44>
  8007cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d9:	8b 00                	mov    (%rax),%eax
  8007db:	89 c0                	mov    %eax,%eax
  8007dd:	48 01 d0             	add    %rdx,%rax
  8007e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e4:	8b 12                	mov    (%rdx),%edx
  8007e6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ed:	89 0a                	mov    %ecx,(%rdx)
  8007ef:	eb 14                	jmp    800805 <getint+0x58>
  8007f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007f9:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800801:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800805:	48 8b 00             	mov    (%rax),%rax
  800808:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80080c:	e9 9d 00 00 00       	jmpq   8008ae <getint+0x101>
	else if (lflag)
  800811:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800815:	74 4c                	je     800863 <getint+0xb6>
		x=va_arg(*ap, long);
  800817:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081b:	8b 00                	mov    (%rax),%eax
  80081d:	83 f8 30             	cmp    $0x30,%eax
  800820:	73 24                	jae    800846 <getint+0x99>
  800822:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800826:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80082a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082e:	8b 00                	mov    (%rax),%eax
  800830:	89 c0                	mov    %eax,%eax
  800832:	48 01 d0             	add    %rdx,%rax
  800835:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800839:	8b 12                	mov    (%rdx),%edx
  80083b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80083e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800842:	89 0a                	mov    %ecx,(%rdx)
  800844:	eb 14                	jmp    80085a <getint+0xad>
  800846:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80084e:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800852:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800856:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80085a:	48 8b 00             	mov    (%rax),%rax
  80085d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800861:	eb 4b                	jmp    8008ae <getint+0x101>
	else
		x=va_arg(*ap, int);
  800863:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800867:	8b 00                	mov    (%rax),%eax
  800869:	83 f8 30             	cmp    $0x30,%eax
  80086c:	73 24                	jae    800892 <getint+0xe5>
  80086e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800872:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800876:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087a:	8b 00                	mov    (%rax),%eax
  80087c:	89 c0                	mov    %eax,%eax
  80087e:	48 01 d0             	add    %rdx,%rax
  800881:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800885:	8b 12                	mov    (%rdx),%edx
  800887:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80088a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088e:	89 0a                	mov    %ecx,(%rdx)
  800890:	eb 14                	jmp    8008a6 <getint+0xf9>
  800892:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800896:	48 8b 40 08          	mov    0x8(%rax),%rax
  80089a:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80089e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008a6:	8b 00                	mov    (%rax),%eax
  8008a8:	48 98                	cltq   
  8008aa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008b2:	c9                   	leaveq 
  8008b3:	c3                   	retq   

00000000008008b4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008b4:	55                   	push   %rbp
  8008b5:	48 89 e5             	mov    %rsp,%rbp
  8008b8:	41 54                	push   %r12
  8008ba:	53                   	push   %rbx
  8008bb:	48 83 ec 60          	sub    $0x60,%rsp
  8008bf:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008c3:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008c7:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008cb:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008cf:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8008d3:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8008d7:	48 8b 0a             	mov    (%rdx),%rcx
  8008da:	48 89 08             	mov    %rcx,(%rax)
  8008dd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008e1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008e5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008e9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008ed:	eb 17                	jmp    800906 <vprintfmt+0x52>
			if (ch == '\0')
  8008ef:	85 db                	test   %ebx,%ebx
  8008f1:	0f 84 c5 04 00 00    	je     800dbc <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  8008f7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008fb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008ff:	48 89 d6             	mov    %rdx,%rsi
  800902:	89 df                	mov    %ebx,%edi
  800904:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800906:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80090a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80090e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800912:	0f b6 00             	movzbl (%rax),%eax
  800915:	0f b6 d8             	movzbl %al,%ebx
  800918:	83 fb 25             	cmp    $0x25,%ebx
  80091b:	75 d2                	jne    8008ef <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  80091d:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800921:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800928:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80092f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800936:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80093d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800941:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800945:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800949:	0f b6 00             	movzbl (%rax),%eax
  80094c:	0f b6 d8             	movzbl %al,%ebx
  80094f:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800952:	83 f8 55             	cmp    $0x55,%eax
  800955:	0f 87 2e 04 00 00    	ja     800d89 <vprintfmt+0x4d5>
  80095b:	89 c0                	mov    %eax,%eax
  80095d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800964:	00 
  800965:	48 b8 98 4c 80 00 00 	movabs $0x804c98,%rax
  80096c:	00 00 00 
  80096f:	48 01 d0             	add    %rdx,%rax
  800972:	48 8b 00             	mov    (%rax),%rax
  800975:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800977:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80097b:	eb c0                	jmp    80093d <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80097d:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800981:	eb ba                	jmp    80093d <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800983:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80098a:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80098d:	89 d0                	mov    %edx,%eax
  80098f:	c1 e0 02             	shl    $0x2,%eax
  800992:	01 d0                	add    %edx,%eax
  800994:	01 c0                	add    %eax,%eax
  800996:	01 d8                	add    %ebx,%eax
  800998:	83 e8 30             	sub    $0x30,%eax
  80099b:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80099e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009a2:	0f b6 00             	movzbl (%rax),%eax
  8009a5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009a8:	83 fb 2f             	cmp    $0x2f,%ebx
  8009ab:	7e 0c                	jle    8009b9 <vprintfmt+0x105>
  8009ad:	83 fb 39             	cmp    $0x39,%ebx
  8009b0:	7f 07                	jg     8009b9 <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  8009b2:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  8009b7:	eb d1                	jmp    80098a <vprintfmt+0xd6>
			goto process_precision;
  8009b9:	eb 50                	jmp    800a0b <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  8009bb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009be:	83 f8 30             	cmp    $0x30,%eax
  8009c1:	73 17                	jae    8009da <vprintfmt+0x126>
  8009c3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8009c7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009ca:	89 d2                	mov    %edx,%edx
  8009cc:	48 01 d0             	add    %rdx,%rax
  8009cf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009d2:	83 c2 08             	add    $0x8,%edx
  8009d5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009d8:	eb 0c                	jmp    8009e6 <vprintfmt+0x132>
  8009da:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8009de:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8009e2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009e6:	8b 00                	mov    (%rax),%eax
  8009e8:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009eb:	eb 1e                	jmp    800a0b <vprintfmt+0x157>

		case '.':
			if (width < 0)
  8009ed:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009f1:	79 07                	jns    8009fa <vprintfmt+0x146>
				width = 0;
  8009f3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009fa:	e9 3e ff ff ff       	jmpq   80093d <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009ff:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a06:	e9 32 ff ff ff       	jmpq   80093d <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800a0b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a0f:	79 0d                	jns    800a1e <vprintfmt+0x16a>
				width = precision, precision = -1;
  800a11:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a14:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a17:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a1e:	e9 1a ff ff ff       	jmpq   80093d <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a23:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a27:	e9 11 ff ff ff       	jmpq   80093d <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a2c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a2f:	83 f8 30             	cmp    $0x30,%eax
  800a32:	73 17                	jae    800a4b <vprintfmt+0x197>
  800a34:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a38:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a3b:	89 d2                	mov    %edx,%edx
  800a3d:	48 01 d0             	add    %rdx,%rax
  800a40:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a43:	83 c2 08             	add    $0x8,%edx
  800a46:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a49:	eb 0c                	jmp    800a57 <vprintfmt+0x1a3>
  800a4b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a4f:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a53:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a57:	8b 10                	mov    (%rax),%edx
  800a59:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a5d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a61:	48 89 ce             	mov    %rcx,%rsi
  800a64:	89 d7                	mov    %edx,%edi
  800a66:	ff d0                	callq  *%rax
			break;
  800a68:	e9 4a 03 00 00       	jmpq   800db7 <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a6d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a70:	83 f8 30             	cmp    $0x30,%eax
  800a73:	73 17                	jae    800a8c <vprintfmt+0x1d8>
  800a75:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a79:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a7c:	89 d2                	mov    %edx,%edx
  800a7e:	48 01 d0             	add    %rdx,%rax
  800a81:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a84:	83 c2 08             	add    $0x8,%edx
  800a87:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a8a:	eb 0c                	jmp    800a98 <vprintfmt+0x1e4>
  800a8c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a90:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a94:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a98:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a9a:	85 db                	test   %ebx,%ebx
  800a9c:	79 02                	jns    800aa0 <vprintfmt+0x1ec>
				err = -err;
  800a9e:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800aa0:	83 fb 15             	cmp    $0x15,%ebx
  800aa3:	7f 16                	jg     800abb <vprintfmt+0x207>
  800aa5:	48 b8 c0 4b 80 00 00 	movabs $0x804bc0,%rax
  800aac:	00 00 00 
  800aaf:	48 63 d3             	movslq %ebx,%rdx
  800ab2:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800ab6:	4d 85 e4             	test   %r12,%r12
  800ab9:	75 2e                	jne    800ae9 <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  800abb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800abf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ac3:	89 d9                	mov    %ebx,%ecx
  800ac5:	48 ba 81 4c 80 00 00 	movabs $0x804c81,%rdx
  800acc:	00 00 00 
  800acf:	48 89 c7             	mov    %rax,%rdi
  800ad2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad7:	49 b8 c5 0d 80 00 00 	movabs $0x800dc5,%r8
  800ade:	00 00 00 
  800ae1:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ae4:	e9 ce 02 00 00       	jmpq   800db7 <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  800ae9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800af1:	4c 89 e1             	mov    %r12,%rcx
  800af4:	48 ba 8a 4c 80 00 00 	movabs $0x804c8a,%rdx
  800afb:	00 00 00 
  800afe:	48 89 c7             	mov    %rax,%rdi
  800b01:	b8 00 00 00 00       	mov    $0x0,%eax
  800b06:	49 b8 c5 0d 80 00 00 	movabs $0x800dc5,%r8
  800b0d:	00 00 00 
  800b10:	41 ff d0             	callq  *%r8
			break;
  800b13:	e9 9f 02 00 00       	jmpq   800db7 <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b18:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b1b:	83 f8 30             	cmp    $0x30,%eax
  800b1e:	73 17                	jae    800b37 <vprintfmt+0x283>
  800b20:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b24:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b27:	89 d2                	mov    %edx,%edx
  800b29:	48 01 d0             	add    %rdx,%rax
  800b2c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b2f:	83 c2 08             	add    $0x8,%edx
  800b32:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b35:	eb 0c                	jmp    800b43 <vprintfmt+0x28f>
  800b37:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b3b:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b3f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b43:	4c 8b 20             	mov    (%rax),%r12
  800b46:	4d 85 e4             	test   %r12,%r12
  800b49:	75 0a                	jne    800b55 <vprintfmt+0x2a1>
				p = "(null)";
  800b4b:	49 bc 8d 4c 80 00 00 	movabs $0x804c8d,%r12
  800b52:	00 00 00 
			if (width > 0 && padc != '-')
  800b55:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b59:	7e 3f                	jle    800b9a <vprintfmt+0x2e6>
  800b5b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b5f:	74 39                	je     800b9a <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b61:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b64:	48 98                	cltq   
  800b66:	48 89 c6             	mov    %rax,%rsi
  800b69:	4c 89 e7             	mov    %r12,%rdi
  800b6c:	48 b8 71 10 80 00 00 	movabs $0x801071,%rax
  800b73:	00 00 00 
  800b76:	ff d0                	callq  *%rax
  800b78:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b7b:	eb 17                	jmp    800b94 <vprintfmt+0x2e0>
					putch(padc, putdat);
  800b7d:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b81:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b85:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b89:	48 89 ce             	mov    %rcx,%rsi
  800b8c:	89 d7                	mov    %edx,%edi
  800b8e:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  800b90:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b94:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b98:	7f e3                	jg     800b7d <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b9a:	eb 37                	jmp    800bd3 <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  800b9c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ba0:	74 1e                	je     800bc0 <vprintfmt+0x30c>
  800ba2:	83 fb 1f             	cmp    $0x1f,%ebx
  800ba5:	7e 05                	jle    800bac <vprintfmt+0x2f8>
  800ba7:	83 fb 7e             	cmp    $0x7e,%ebx
  800baa:	7e 14                	jle    800bc0 <vprintfmt+0x30c>
					putch('?', putdat);
  800bac:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb4:	48 89 d6             	mov    %rdx,%rsi
  800bb7:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800bbc:	ff d0                	callq  *%rax
  800bbe:	eb 0f                	jmp    800bcf <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  800bc0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bc4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc8:	48 89 d6             	mov    %rdx,%rsi
  800bcb:	89 df                	mov    %ebx,%edi
  800bcd:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bcf:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bd3:	4c 89 e0             	mov    %r12,%rax
  800bd6:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800bda:	0f b6 00             	movzbl (%rax),%eax
  800bdd:	0f be d8             	movsbl %al,%ebx
  800be0:	85 db                	test   %ebx,%ebx
  800be2:	74 10                	je     800bf4 <vprintfmt+0x340>
  800be4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800be8:	78 b2                	js     800b9c <vprintfmt+0x2e8>
  800bea:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bee:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bf2:	79 a8                	jns    800b9c <vprintfmt+0x2e8>
			for (; width > 0; width--)
  800bf4:	eb 16                	jmp    800c0c <vprintfmt+0x358>
				putch(' ', putdat);
  800bf6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bfa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bfe:	48 89 d6             	mov    %rdx,%rsi
  800c01:	bf 20 00 00 00       	mov    $0x20,%edi
  800c06:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  800c08:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c0c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c10:	7f e4                	jg     800bf6 <vprintfmt+0x342>
			break;
  800c12:	e9 a0 01 00 00       	jmpq   800db7 <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c17:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c1b:	be 03 00 00 00       	mov    $0x3,%esi
  800c20:	48 89 c7             	mov    %rax,%rdi
  800c23:	48 b8 ad 07 80 00 00 	movabs $0x8007ad,%rax
  800c2a:	00 00 00 
  800c2d:	ff d0                	callq  *%rax
  800c2f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c37:	48 85 c0             	test   %rax,%rax
  800c3a:	79 1d                	jns    800c59 <vprintfmt+0x3a5>
				putch('-', putdat);
  800c3c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c40:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c44:	48 89 d6             	mov    %rdx,%rsi
  800c47:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c4c:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c52:	48 f7 d8             	neg    %rax
  800c55:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c59:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c60:	e9 e5 00 00 00       	jmpq   800d4a <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c65:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c69:	be 03 00 00 00       	mov    $0x3,%esi
  800c6e:	48 89 c7             	mov    %rax,%rdi
  800c71:	48 b8 a6 06 80 00 00 	movabs $0x8006a6,%rax
  800c78:	00 00 00 
  800c7b:	ff d0                	callq  *%rax
  800c7d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c81:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c88:	e9 bd 00 00 00       	jmpq   800d4a <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c8d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c91:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c95:	48 89 d6             	mov    %rdx,%rsi
  800c98:	bf 58 00 00 00       	mov    $0x58,%edi
  800c9d:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c9f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ca3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca7:	48 89 d6             	mov    %rdx,%rsi
  800caa:	bf 58 00 00 00       	mov    $0x58,%edi
  800caf:	ff d0                	callq  *%rax
			putch('X', putdat);
  800cb1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cb5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb9:	48 89 d6             	mov    %rdx,%rsi
  800cbc:	bf 58 00 00 00       	mov    $0x58,%edi
  800cc1:	ff d0                	callq  *%rax
			break;
  800cc3:	e9 ef 00 00 00       	jmpq   800db7 <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  800cc8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ccc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd0:	48 89 d6             	mov    %rdx,%rsi
  800cd3:	bf 30 00 00 00       	mov    $0x30,%edi
  800cd8:	ff d0                	callq  *%rax
			putch('x', putdat);
  800cda:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cde:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce2:	48 89 d6             	mov    %rdx,%rsi
  800ce5:	bf 78 00 00 00       	mov    $0x78,%edi
  800cea:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cec:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cef:	83 f8 30             	cmp    $0x30,%eax
  800cf2:	73 17                	jae    800d0b <vprintfmt+0x457>
  800cf4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cf8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cfb:	89 d2                	mov    %edx,%edx
  800cfd:	48 01 d0             	add    %rdx,%rax
  800d00:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d03:	83 c2 08             	add    $0x8,%edx
  800d06:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  800d09:	eb 0c                	jmp    800d17 <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  800d0b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d0f:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d13:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d17:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  800d1a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d1e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d25:	eb 23                	jmp    800d4a <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d27:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d2b:	be 03 00 00 00       	mov    $0x3,%esi
  800d30:	48 89 c7             	mov    %rax,%rdi
  800d33:	48 b8 a6 06 80 00 00 	movabs $0x8006a6,%rax
  800d3a:	00 00 00 
  800d3d:	ff d0                	callq  *%rax
  800d3f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d43:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d4a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d4f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d52:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d55:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d59:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d5d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d61:	45 89 c1             	mov    %r8d,%r9d
  800d64:	41 89 f8             	mov    %edi,%r8d
  800d67:	48 89 c7             	mov    %rax,%rdi
  800d6a:	48 b8 ed 05 80 00 00 	movabs $0x8005ed,%rax
  800d71:	00 00 00 
  800d74:	ff d0                	callq  *%rax
			break;
  800d76:	eb 3f                	jmp    800db7 <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d78:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d80:	48 89 d6             	mov    %rdx,%rsi
  800d83:	89 df                	mov    %ebx,%edi
  800d85:	ff d0                	callq  *%rax
			break;
  800d87:	eb 2e                	jmp    800db7 <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d89:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d8d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d91:	48 89 d6             	mov    %rdx,%rsi
  800d94:	bf 25 00 00 00       	mov    $0x25,%edi
  800d99:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d9b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800da0:	eb 05                	jmp    800da7 <vprintfmt+0x4f3>
  800da2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800da7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800dab:	48 83 e8 01          	sub    $0x1,%rax
  800daf:	0f b6 00             	movzbl (%rax),%eax
  800db2:	3c 25                	cmp    $0x25,%al
  800db4:	75 ec                	jne    800da2 <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  800db6:	90                   	nop
		}
	}
  800db7:	e9 31 fb ff ff       	jmpq   8008ed <vprintfmt+0x39>
	va_end(aq);
}
  800dbc:	48 83 c4 60          	add    $0x60,%rsp
  800dc0:	5b                   	pop    %rbx
  800dc1:	41 5c                	pop    %r12
  800dc3:	5d                   	pop    %rbp
  800dc4:	c3                   	retq   

0000000000800dc5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dc5:	55                   	push   %rbp
  800dc6:	48 89 e5             	mov    %rsp,%rbp
  800dc9:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800dd0:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800dd7:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800dde:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800de5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dec:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800df3:	84 c0                	test   %al,%al
  800df5:	74 20                	je     800e17 <printfmt+0x52>
  800df7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dfb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dff:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e03:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e07:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e0b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e0f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e13:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e17:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e1e:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e25:	00 00 00 
  800e28:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e2f:	00 00 00 
  800e32:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e36:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e3d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e44:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e4b:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e52:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e59:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e60:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e67:	48 89 c7             	mov    %rax,%rdi
  800e6a:	48 b8 b4 08 80 00 00 	movabs $0x8008b4,%rax
  800e71:	00 00 00 
  800e74:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e76:	c9                   	leaveq 
  800e77:	c3                   	retq   

0000000000800e78 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e78:	55                   	push   %rbp
  800e79:	48 89 e5             	mov    %rsp,%rbp
  800e7c:	48 83 ec 10          	sub    $0x10,%rsp
  800e80:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e83:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e8b:	8b 40 10             	mov    0x10(%rax),%eax
  800e8e:	8d 50 01             	lea    0x1(%rax),%edx
  800e91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e95:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e9c:	48 8b 10             	mov    (%rax),%rdx
  800e9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ea3:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ea7:	48 39 c2             	cmp    %rax,%rdx
  800eaa:	73 17                	jae    800ec3 <sprintputch+0x4b>
		*b->buf++ = ch;
  800eac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eb0:	48 8b 00             	mov    (%rax),%rax
  800eb3:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800eb7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ebb:	48 89 0a             	mov    %rcx,(%rdx)
  800ebe:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ec1:	88 10                	mov    %dl,(%rax)
}
  800ec3:	c9                   	leaveq 
  800ec4:	c3                   	retq   

0000000000800ec5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ec5:	55                   	push   %rbp
  800ec6:	48 89 e5             	mov    %rsp,%rbp
  800ec9:	48 83 ec 50          	sub    $0x50,%rsp
  800ecd:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ed1:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ed4:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ed8:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800edc:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ee0:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ee4:	48 8b 0a             	mov    (%rdx),%rcx
  800ee7:	48 89 08             	mov    %rcx,(%rax)
  800eea:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800eee:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ef2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ef6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800efa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800efe:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f02:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f05:	48 98                	cltq   
  800f07:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f0b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f0f:	48 01 d0             	add    %rdx,%rax
  800f12:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f16:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f1d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f22:	74 06                	je     800f2a <vsnprintf+0x65>
  800f24:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f28:	7f 07                	jg     800f31 <vsnprintf+0x6c>
		return -E_INVAL;
  800f2a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f2f:	eb 2f                	jmp    800f60 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f31:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f35:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f39:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f3d:	48 89 c6             	mov    %rax,%rsi
  800f40:	48 bf 78 0e 80 00 00 	movabs $0x800e78,%rdi
  800f47:	00 00 00 
  800f4a:	48 b8 b4 08 80 00 00 	movabs $0x8008b4,%rax
  800f51:	00 00 00 
  800f54:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f56:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f5a:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f5d:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f60:	c9                   	leaveq 
  800f61:	c3                   	retq   

0000000000800f62 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f62:	55                   	push   %rbp
  800f63:	48 89 e5             	mov    %rsp,%rbp
  800f66:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f6d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f74:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f7a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f81:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f88:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f8f:	84 c0                	test   %al,%al
  800f91:	74 20                	je     800fb3 <snprintf+0x51>
  800f93:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f97:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f9b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f9f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fa3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fa7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fab:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800faf:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fb3:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800fba:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800fc1:	00 00 00 
  800fc4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fcb:	00 00 00 
  800fce:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fd2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fd9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fe0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fe7:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fee:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ff5:	48 8b 0a             	mov    (%rdx),%rcx
  800ff8:	48 89 08             	mov    %rcx,(%rax)
  800ffb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fff:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801003:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801007:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80100b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801012:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801019:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80101f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801026:	48 89 c7             	mov    %rax,%rdi
  801029:	48 b8 c5 0e 80 00 00 	movabs $0x800ec5,%rax
  801030:	00 00 00 
  801033:	ff d0                	callq  *%rax
  801035:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80103b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801041:	c9                   	leaveq 
  801042:	c3                   	retq   

0000000000801043 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801043:	55                   	push   %rbp
  801044:	48 89 e5             	mov    %rsp,%rbp
  801047:	48 83 ec 18          	sub    $0x18,%rsp
  80104b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80104f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801056:	eb 09                	jmp    801061 <strlen+0x1e>
		n++;
  801058:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  80105c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801061:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801065:	0f b6 00             	movzbl (%rax),%eax
  801068:	84 c0                	test   %al,%al
  80106a:	75 ec                	jne    801058 <strlen+0x15>
	return n;
  80106c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80106f:	c9                   	leaveq 
  801070:	c3                   	retq   

0000000000801071 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801071:	55                   	push   %rbp
  801072:	48 89 e5             	mov    %rsp,%rbp
  801075:	48 83 ec 20          	sub    $0x20,%rsp
  801079:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80107d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801081:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801088:	eb 0e                	jmp    801098 <strnlen+0x27>
		n++;
  80108a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80108e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801093:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801098:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80109d:	74 0b                	je     8010aa <strnlen+0x39>
  80109f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a3:	0f b6 00             	movzbl (%rax),%eax
  8010a6:	84 c0                	test   %al,%al
  8010a8:	75 e0                	jne    80108a <strnlen+0x19>
	return n;
  8010aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010ad:	c9                   	leaveq 
  8010ae:	c3                   	retq   

00000000008010af <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010af:	55                   	push   %rbp
  8010b0:	48 89 e5             	mov    %rsp,%rbp
  8010b3:	48 83 ec 20          	sub    $0x20,%rsp
  8010b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010c7:	90                   	nop
  8010c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010cc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010d0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010d4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010d8:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010dc:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010e0:	0f b6 12             	movzbl (%rdx),%edx
  8010e3:	88 10                	mov    %dl,(%rax)
  8010e5:	0f b6 00             	movzbl (%rax),%eax
  8010e8:	84 c0                	test   %al,%al
  8010ea:	75 dc                	jne    8010c8 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010f0:	c9                   	leaveq 
  8010f1:	c3                   	retq   

00000000008010f2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010f2:	55                   	push   %rbp
  8010f3:	48 89 e5             	mov    %rsp,%rbp
  8010f6:	48 83 ec 20          	sub    $0x20,%rsp
  8010fa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010fe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801102:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801106:	48 89 c7             	mov    %rax,%rdi
  801109:	48 b8 43 10 80 00 00 	movabs $0x801043,%rax
  801110:	00 00 00 
  801113:	ff d0                	callq  *%rax
  801115:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801118:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80111b:	48 63 d0             	movslq %eax,%rdx
  80111e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801122:	48 01 c2             	add    %rax,%rdx
  801125:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801129:	48 89 c6             	mov    %rax,%rsi
  80112c:	48 89 d7             	mov    %rdx,%rdi
  80112f:	48 b8 af 10 80 00 00 	movabs $0x8010af,%rax
  801136:	00 00 00 
  801139:	ff d0                	callq  *%rax
	return dst;
  80113b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80113f:	c9                   	leaveq 
  801140:	c3                   	retq   

0000000000801141 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801141:	55                   	push   %rbp
  801142:	48 89 e5             	mov    %rsp,%rbp
  801145:	48 83 ec 28          	sub    $0x28,%rsp
  801149:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80114d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801151:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801155:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801159:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80115d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801164:	00 
  801165:	eb 2a                	jmp    801191 <strncpy+0x50>
		*dst++ = *src;
  801167:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80116f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801173:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801177:	0f b6 12             	movzbl (%rdx),%edx
  80117a:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80117c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801180:	0f b6 00             	movzbl (%rax),%eax
  801183:	84 c0                	test   %al,%al
  801185:	74 05                	je     80118c <strncpy+0x4b>
			src++;
  801187:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  80118c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801191:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801195:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801199:	72 cc                	jb     801167 <strncpy+0x26>
	}
	return ret;
  80119b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80119f:	c9                   	leaveq 
  8011a0:	c3                   	retq   

00000000008011a1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011a1:	55                   	push   %rbp
  8011a2:	48 89 e5             	mov    %rsp,%rbp
  8011a5:	48 83 ec 28          	sub    $0x28,%rsp
  8011a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011b1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011bd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011c2:	74 3d                	je     801201 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011c4:	eb 1d                	jmp    8011e3 <strlcpy+0x42>
			*dst++ = *src++;
  8011c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ca:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011ce:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011d2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011d6:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011da:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011de:	0f b6 12             	movzbl (%rdx),%edx
  8011e1:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  8011e3:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011e8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011ed:	74 0b                	je     8011fa <strlcpy+0x59>
  8011ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011f3:	0f b6 00             	movzbl (%rax),%eax
  8011f6:	84 c0                	test   %al,%al
  8011f8:	75 cc                	jne    8011c6 <strlcpy+0x25>
		*dst = '\0';
  8011fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011fe:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801201:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801205:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801209:	48 29 c2             	sub    %rax,%rdx
  80120c:	48 89 d0             	mov    %rdx,%rax
}
  80120f:	c9                   	leaveq 
  801210:	c3                   	retq   

0000000000801211 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801211:	55                   	push   %rbp
  801212:	48 89 e5             	mov    %rsp,%rbp
  801215:	48 83 ec 10          	sub    $0x10,%rsp
  801219:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80121d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801221:	eb 0a                	jmp    80122d <strcmp+0x1c>
		p++, q++;
  801223:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801228:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  80122d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801231:	0f b6 00             	movzbl (%rax),%eax
  801234:	84 c0                	test   %al,%al
  801236:	74 12                	je     80124a <strcmp+0x39>
  801238:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123c:	0f b6 10             	movzbl (%rax),%edx
  80123f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801243:	0f b6 00             	movzbl (%rax),%eax
  801246:	38 c2                	cmp    %al,%dl
  801248:	74 d9                	je     801223 <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80124a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124e:	0f b6 00             	movzbl (%rax),%eax
  801251:	0f b6 d0             	movzbl %al,%edx
  801254:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801258:	0f b6 00             	movzbl (%rax),%eax
  80125b:	0f b6 c0             	movzbl %al,%eax
  80125e:	29 c2                	sub    %eax,%edx
  801260:	89 d0                	mov    %edx,%eax
}
  801262:	c9                   	leaveq 
  801263:	c3                   	retq   

0000000000801264 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801264:	55                   	push   %rbp
  801265:	48 89 e5             	mov    %rsp,%rbp
  801268:	48 83 ec 18          	sub    $0x18,%rsp
  80126c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801270:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801274:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801278:	eb 0f                	jmp    801289 <strncmp+0x25>
		n--, p++, q++;
  80127a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80127f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801284:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  801289:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80128e:	74 1d                	je     8012ad <strncmp+0x49>
  801290:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801294:	0f b6 00             	movzbl (%rax),%eax
  801297:	84 c0                	test   %al,%al
  801299:	74 12                	je     8012ad <strncmp+0x49>
  80129b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129f:	0f b6 10             	movzbl (%rax),%edx
  8012a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012a6:	0f b6 00             	movzbl (%rax),%eax
  8012a9:	38 c2                	cmp    %al,%dl
  8012ab:	74 cd                	je     80127a <strncmp+0x16>
	if (n == 0)
  8012ad:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012b2:	75 07                	jne    8012bb <strncmp+0x57>
		return 0;
  8012b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b9:	eb 18                	jmp    8012d3 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bf:	0f b6 00             	movzbl (%rax),%eax
  8012c2:	0f b6 d0             	movzbl %al,%edx
  8012c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c9:	0f b6 00             	movzbl (%rax),%eax
  8012cc:	0f b6 c0             	movzbl %al,%eax
  8012cf:	29 c2                	sub    %eax,%edx
  8012d1:	89 d0                	mov    %edx,%eax
}
  8012d3:	c9                   	leaveq 
  8012d4:	c3                   	retq   

00000000008012d5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012d5:	55                   	push   %rbp
  8012d6:	48 89 e5             	mov    %rsp,%rbp
  8012d9:	48 83 ec 10          	sub    $0x10,%rsp
  8012dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012e1:	89 f0                	mov    %esi,%eax
  8012e3:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012e6:	eb 17                	jmp    8012ff <strchr+0x2a>
		if (*s == c)
  8012e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ec:	0f b6 00             	movzbl (%rax),%eax
  8012ef:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012f2:	75 06                	jne    8012fa <strchr+0x25>
			return (char *) s;
  8012f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f8:	eb 15                	jmp    80130f <strchr+0x3a>
	for (; *s; s++)
  8012fa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801303:	0f b6 00             	movzbl (%rax),%eax
  801306:	84 c0                	test   %al,%al
  801308:	75 de                	jne    8012e8 <strchr+0x13>
	return 0;
  80130a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80130f:	c9                   	leaveq 
  801310:	c3                   	retq   

0000000000801311 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801311:	55                   	push   %rbp
  801312:	48 89 e5             	mov    %rsp,%rbp
  801315:	48 83 ec 10          	sub    $0x10,%rsp
  801319:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80131d:	89 f0                	mov    %esi,%eax
  80131f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801322:	eb 13                	jmp    801337 <strfind+0x26>
		if (*s == c)
  801324:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801328:	0f b6 00             	movzbl (%rax),%eax
  80132b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80132e:	75 02                	jne    801332 <strfind+0x21>
			break;
  801330:	eb 10                	jmp    801342 <strfind+0x31>
	for (; *s; s++)
  801332:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801337:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133b:	0f b6 00             	movzbl (%rax),%eax
  80133e:	84 c0                	test   %al,%al
  801340:	75 e2                	jne    801324 <strfind+0x13>
	return (char *) s;
  801342:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801346:	c9                   	leaveq 
  801347:	c3                   	retq   

0000000000801348 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801348:	55                   	push   %rbp
  801349:	48 89 e5             	mov    %rsp,%rbp
  80134c:	48 83 ec 18          	sub    $0x18,%rsp
  801350:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801354:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801357:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80135b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801360:	75 06                	jne    801368 <memset+0x20>
		return v;
  801362:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801366:	eb 69                	jmp    8013d1 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801368:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136c:	83 e0 03             	and    $0x3,%eax
  80136f:	48 85 c0             	test   %rax,%rax
  801372:	75 48                	jne    8013bc <memset+0x74>
  801374:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801378:	83 e0 03             	and    $0x3,%eax
  80137b:	48 85 c0             	test   %rax,%rax
  80137e:	75 3c                	jne    8013bc <memset+0x74>
		c &= 0xFF;
  801380:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801387:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80138a:	c1 e0 18             	shl    $0x18,%eax
  80138d:	89 c2                	mov    %eax,%edx
  80138f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801392:	c1 e0 10             	shl    $0x10,%eax
  801395:	09 c2                	or     %eax,%edx
  801397:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80139a:	c1 e0 08             	shl    $0x8,%eax
  80139d:	09 d0                	or     %edx,%eax
  80139f:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8013a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a6:	48 c1 e8 02          	shr    $0x2,%rax
  8013aa:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  8013ad:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013b1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013b4:	48 89 d7             	mov    %rdx,%rdi
  8013b7:	fc                   	cld    
  8013b8:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013ba:	eb 11                	jmp    8013cd <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013bc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013c0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013c3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013c7:	48 89 d7             	mov    %rdx,%rdi
  8013ca:	fc                   	cld    
  8013cb:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8013cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013d1:	c9                   	leaveq 
  8013d2:	c3                   	retq   

00000000008013d3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013d3:	55                   	push   %rbp
  8013d4:	48 89 e5             	mov    %rsp,%rbp
  8013d7:	48 83 ec 28          	sub    $0x28,%rsp
  8013db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013e3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013fb:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013ff:	0f 83 88 00 00 00    	jae    80148d <memmove+0xba>
  801405:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801409:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140d:	48 01 d0             	add    %rdx,%rax
  801410:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801414:	76 77                	jbe    80148d <memmove+0xba>
		s += n;
  801416:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80141a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80141e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801422:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801426:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142a:	83 e0 03             	and    $0x3,%eax
  80142d:	48 85 c0             	test   %rax,%rax
  801430:	75 3b                	jne    80146d <memmove+0x9a>
  801432:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801436:	83 e0 03             	and    $0x3,%eax
  801439:	48 85 c0             	test   %rax,%rax
  80143c:	75 2f                	jne    80146d <memmove+0x9a>
  80143e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801442:	83 e0 03             	and    $0x3,%eax
  801445:	48 85 c0             	test   %rax,%rax
  801448:	75 23                	jne    80146d <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80144a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80144e:	48 83 e8 04          	sub    $0x4,%rax
  801452:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801456:	48 83 ea 04          	sub    $0x4,%rdx
  80145a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80145e:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  801462:	48 89 c7             	mov    %rax,%rdi
  801465:	48 89 d6             	mov    %rdx,%rsi
  801468:	fd                   	std    
  801469:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80146b:	eb 1d                	jmp    80148a <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80146d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801471:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801475:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801479:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  80147d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801481:	48 89 d7             	mov    %rdx,%rdi
  801484:	48 89 c1             	mov    %rax,%rcx
  801487:	fd                   	std    
  801488:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80148a:	fc                   	cld    
  80148b:	eb 57                	jmp    8014e4 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80148d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801491:	83 e0 03             	and    $0x3,%eax
  801494:	48 85 c0             	test   %rax,%rax
  801497:	75 36                	jne    8014cf <memmove+0xfc>
  801499:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149d:	83 e0 03             	and    $0x3,%eax
  8014a0:	48 85 c0             	test   %rax,%rax
  8014a3:	75 2a                	jne    8014cf <memmove+0xfc>
  8014a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a9:	83 e0 03             	and    $0x3,%eax
  8014ac:	48 85 c0             	test   %rax,%rax
  8014af:	75 1e                	jne    8014cf <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b5:	48 c1 e8 02          	shr    $0x2,%rax
  8014b9:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  8014bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014c4:	48 89 c7             	mov    %rax,%rdi
  8014c7:	48 89 d6             	mov    %rdx,%rsi
  8014ca:	fc                   	cld    
  8014cb:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014cd:	eb 15                	jmp    8014e4 <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  8014cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014d7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014db:	48 89 c7             	mov    %rax,%rdi
  8014de:	48 89 d6             	mov    %rdx,%rsi
  8014e1:	fc                   	cld    
  8014e2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014e8:	c9                   	leaveq 
  8014e9:	c3                   	retq   

00000000008014ea <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014ea:	55                   	push   %rbp
  8014eb:	48 89 e5             	mov    %rsp,%rbp
  8014ee:	48 83 ec 18          	sub    $0x18,%rsp
  8014f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014f6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014fa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801502:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801506:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80150a:	48 89 ce             	mov    %rcx,%rsi
  80150d:	48 89 c7             	mov    %rax,%rdi
  801510:	48 b8 d3 13 80 00 00 	movabs $0x8013d3,%rax
  801517:	00 00 00 
  80151a:	ff d0                	callq  *%rax
}
  80151c:	c9                   	leaveq 
  80151d:	c3                   	retq   

000000000080151e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80151e:	55                   	push   %rbp
  80151f:	48 89 e5             	mov    %rsp,%rbp
  801522:	48 83 ec 28          	sub    $0x28,%rsp
  801526:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80152a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80152e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801532:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801536:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80153a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80153e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801542:	eb 36                	jmp    80157a <memcmp+0x5c>
		if (*s1 != *s2)
  801544:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801548:	0f b6 10             	movzbl (%rax),%edx
  80154b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80154f:	0f b6 00             	movzbl (%rax),%eax
  801552:	38 c2                	cmp    %al,%dl
  801554:	74 1a                	je     801570 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801556:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155a:	0f b6 00             	movzbl (%rax),%eax
  80155d:	0f b6 d0             	movzbl %al,%edx
  801560:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801564:	0f b6 00             	movzbl (%rax),%eax
  801567:	0f b6 c0             	movzbl %al,%eax
  80156a:	29 c2                	sub    %eax,%edx
  80156c:	89 d0                	mov    %edx,%eax
  80156e:	eb 20                	jmp    801590 <memcmp+0x72>
		s1++, s2++;
  801570:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801575:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  80157a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801582:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801586:	48 85 c0             	test   %rax,%rax
  801589:	75 b9                	jne    801544 <memcmp+0x26>
	}

	return 0;
  80158b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801590:	c9                   	leaveq 
  801591:	c3                   	retq   

0000000000801592 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801592:	55                   	push   %rbp
  801593:	48 89 e5             	mov    %rsp,%rbp
  801596:	48 83 ec 28          	sub    $0x28,%rsp
  80159a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80159e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ad:	48 01 d0             	add    %rdx,%rax
  8015b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015b4:	eb 15                	jmp    8015cb <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ba:	0f b6 00             	movzbl (%rax),%eax
  8015bd:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8015c0:	38 d0                	cmp    %dl,%al
  8015c2:	75 02                	jne    8015c6 <memfind+0x34>
			break;
  8015c4:	eb 0f                	jmp    8015d5 <memfind+0x43>
	for (; s < ends; s++)
  8015c6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015cf:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015d3:	72 e1                	jb     8015b6 <memfind+0x24>
	return (void *) s;
  8015d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015d9:	c9                   	leaveq 
  8015da:	c3                   	retq   

00000000008015db <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015db:	55                   	push   %rbp
  8015dc:	48 89 e5             	mov    %rsp,%rbp
  8015df:	48 83 ec 38          	sub    $0x38,%rsp
  8015e3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015e7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015eb:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015f5:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015fc:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015fd:	eb 05                	jmp    801604 <strtol+0x29>
		s++;
  8015ff:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  801604:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801608:	0f b6 00             	movzbl (%rax),%eax
  80160b:	3c 20                	cmp    $0x20,%al
  80160d:	74 f0                	je     8015ff <strtol+0x24>
  80160f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801613:	0f b6 00             	movzbl (%rax),%eax
  801616:	3c 09                	cmp    $0x9,%al
  801618:	74 e5                	je     8015ff <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  80161a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161e:	0f b6 00             	movzbl (%rax),%eax
  801621:	3c 2b                	cmp    $0x2b,%al
  801623:	75 07                	jne    80162c <strtol+0x51>
		s++;
  801625:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80162a:	eb 17                	jmp    801643 <strtol+0x68>
	else if (*s == '-')
  80162c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801630:	0f b6 00             	movzbl (%rax),%eax
  801633:	3c 2d                	cmp    $0x2d,%al
  801635:	75 0c                	jne    801643 <strtol+0x68>
		s++, neg = 1;
  801637:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80163c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801643:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801647:	74 06                	je     80164f <strtol+0x74>
  801649:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80164d:	75 28                	jne    801677 <strtol+0x9c>
  80164f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801653:	0f b6 00             	movzbl (%rax),%eax
  801656:	3c 30                	cmp    $0x30,%al
  801658:	75 1d                	jne    801677 <strtol+0x9c>
  80165a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165e:	48 83 c0 01          	add    $0x1,%rax
  801662:	0f b6 00             	movzbl (%rax),%eax
  801665:	3c 78                	cmp    $0x78,%al
  801667:	75 0e                	jne    801677 <strtol+0x9c>
		s += 2, base = 16;
  801669:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80166e:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801675:	eb 2c                	jmp    8016a3 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801677:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80167b:	75 19                	jne    801696 <strtol+0xbb>
  80167d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801681:	0f b6 00             	movzbl (%rax),%eax
  801684:	3c 30                	cmp    $0x30,%al
  801686:	75 0e                	jne    801696 <strtol+0xbb>
		s++, base = 8;
  801688:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80168d:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801694:	eb 0d                	jmp    8016a3 <strtol+0xc8>
	else if (base == 0)
  801696:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80169a:	75 07                	jne    8016a3 <strtol+0xc8>
		base = 10;
  80169c:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a7:	0f b6 00             	movzbl (%rax),%eax
  8016aa:	3c 2f                	cmp    $0x2f,%al
  8016ac:	7e 1d                	jle    8016cb <strtol+0xf0>
  8016ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b2:	0f b6 00             	movzbl (%rax),%eax
  8016b5:	3c 39                	cmp    $0x39,%al
  8016b7:	7f 12                	jg     8016cb <strtol+0xf0>
			dig = *s - '0';
  8016b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bd:	0f b6 00             	movzbl (%rax),%eax
  8016c0:	0f be c0             	movsbl %al,%eax
  8016c3:	83 e8 30             	sub    $0x30,%eax
  8016c6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016c9:	eb 4e                	jmp    801719 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cf:	0f b6 00             	movzbl (%rax),%eax
  8016d2:	3c 60                	cmp    $0x60,%al
  8016d4:	7e 1d                	jle    8016f3 <strtol+0x118>
  8016d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016da:	0f b6 00             	movzbl (%rax),%eax
  8016dd:	3c 7a                	cmp    $0x7a,%al
  8016df:	7f 12                	jg     8016f3 <strtol+0x118>
			dig = *s - 'a' + 10;
  8016e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e5:	0f b6 00             	movzbl (%rax),%eax
  8016e8:	0f be c0             	movsbl %al,%eax
  8016eb:	83 e8 57             	sub    $0x57,%eax
  8016ee:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016f1:	eb 26                	jmp    801719 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f7:	0f b6 00             	movzbl (%rax),%eax
  8016fa:	3c 40                	cmp    $0x40,%al
  8016fc:	7e 48                	jle    801746 <strtol+0x16b>
  8016fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801702:	0f b6 00             	movzbl (%rax),%eax
  801705:	3c 5a                	cmp    $0x5a,%al
  801707:	7f 3d                	jg     801746 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801709:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170d:	0f b6 00             	movzbl (%rax),%eax
  801710:	0f be c0             	movsbl %al,%eax
  801713:	83 e8 37             	sub    $0x37,%eax
  801716:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801719:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80171c:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80171f:	7c 02                	jl     801723 <strtol+0x148>
			break;
  801721:	eb 23                	jmp    801746 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801723:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801728:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80172b:	48 98                	cltq   
  80172d:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801732:	48 89 c2             	mov    %rax,%rdx
  801735:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801738:	48 98                	cltq   
  80173a:	48 01 d0             	add    %rdx,%rax
  80173d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801741:	e9 5d ff ff ff       	jmpq   8016a3 <strtol+0xc8>

	if (endptr)
  801746:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80174b:	74 0b                	je     801758 <strtol+0x17d>
		*endptr = (char *) s;
  80174d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801751:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801755:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801758:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80175c:	74 09                	je     801767 <strtol+0x18c>
  80175e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801762:	48 f7 d8             	neg    %rax
  801765:	eb 04                	jmp    80176b <strtol+0x190>
  801767:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80176b:	c9                   	leaveq 
  80176c:	c3                   	retq   

000000000080176d <strstr>:

char * strstr(const char *in, const char *str)
{
  80176d:	55                   	push   %rbp
  80176e:	48 89 e5             	mov    %rsp,%rbp
  801771:	48 83 ec 30          	sub    $0x30,%rsp
  801775:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801779:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80177d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801781:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801785:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801789:	0f b6 00             	movzbl (%rax),%eax
  80178c:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80178f:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801793:	75 06                	jne    80179b <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801795:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801799:	eb 6b                	jmp    801806 <strstr+0x99>

	len = strlen(str);
  80179b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80179f:	48 89 c7             	mov    %rax,%rdi
  8017a2:	48 b8 43 10 80 00 00 	movabs $0x801043,%rax
  8017a9:	00 00 00 
  8017ac:	ff d0                	callq  *%rax
  8017ae:	48 98                	cltq   
  8017b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8017b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017bc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017c0:	0f b6 00             	movzbl (%rax),%eax
  8017c3:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8017c6:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017ca:	75 07                	jne    8017d3 <strstr+0x66>
				return (char *) 0;
  8017cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d1:	eb 33                	jmp    801806 <strstr+0x99>
		} while (sc != c);
  8017d3:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017d7:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017da:	75 d8                	jne    8017b4 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8017dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017e0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e8:	48 89 ce             	mov    %rcx,%rsi
  8017eb:	48 89 c7             	mov    %rax,%rdi
  8017ee:	48 b8 64 12 80 00 00 	movabs $0x801264,%rax
  8017f5:	00 00 00 
  8017f8:	ff d0                	callq  *%rax
  8017fa:	85 c0                	test   %eax,%eax
  8017fc:	75 b6                	jne    8017b4 <strstr+0x47>

	return (char *) (in - 1);
  8017fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801802:	48 83 e8 01          	sub    $0x1,%rax
}
  801806:	c9                   	leaveq 
  801807:	c3                   	retq   

0000000000801808 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801808:	55                   	push   %rbp
  801809:	48 89 e5             	mov    %rsp,%rbp
  80180c:	53                   	push   %rbx
  80180d:	48 83 ec 48          	sub    $0x48,%rsp
  801811:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801814:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801817:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80181b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80181f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801823:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801827:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80182a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80182e:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801832:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801836:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80183a:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80183e:	4c 89 c3             	mov    %r8,%rbx
  801841:	cd 30                	int    $0x30
  801843:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801847:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80184b:	74 3e                	je     80188b <syscall+0x83>
  80184d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801852:	7e 37                	jle    80188b <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801854:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801858:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80185b:	49 89 d0             	mov    %rdx,%r8
  80185e:	89 c1                	mov    %eax,%ecx
  801860:	48 ba 48 4f 80 00 00 	movabs $0x804f48,%rdx
  801867:	00 00 00 
  80186a:	be 23 00 00 00       	mov    $0x23,%esi
  80186f:	48 bf 65 4f 80 00 00 	movabs $0x804f65,%rdi
  801876:	00 00 00 
  801879:	b8 00 00 00 00       	mov    $0x0,%eax
  80187e:	49 b9 dc 02 80 00 00 	movabs $0x8002dc,%r9
  801885:	00 00 00 
  801888:	41 ff d1             	callq  *%r9

	return ret;
  80188b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80188f:	48 83 c4 48          	add    $0x48,%rsp
  801893:	5b                   	pop    %rbx
  801894:	5d                   	pop    %rbp
  801895:	c3                   	retq   

0000000000801896 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801896:	55                   	push   %rbp
  801897:	48 89 e5             	mov    %rsp,%rbp
  80189a:	48 83 ec 10          	sub    $0x10,%rsp
  80189e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018a2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8018a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018aa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ae:	48 83 ec 08          	sub    $0x8,%rsp
  8018b2:	6a 00                	pushq  $0x0
  8018b4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018c0:	48 89 d1             	mov    %rdx,%rcx
  8018c3:	48 89 c2             	mov    %rax,%rdx
  8018c6:	be 00 00 00 00       	mov    $0x0,%esi
  8018cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8018d0:	48 b8 08 18 80 00 00 	movabs $0x801808,%rax
  8018d7:	00 00 00 
  8018da:	ff d0                	callq  *%rax
  8018dc:	48 83 c4 10          	add    $0x10,%rsp
}
  8018e0:	c9                   	leaveq 
  8018e1:	c3                   	retq   

00000000008018e2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018e2:	55                   	push   %rbp
  8018e3:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8018e6:	48 83 ec 08          	sub    $0x8,%rsp
  8018ea:	6a 00                	pushq  $0x0
  8018ec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801902:	be 00 00 00 00       	mov    $0x0,%esi
  801907:	bf 01 00 00 00       	mov    $0x1,%edi
  80190c:	48 b8 08 18 80 00 00 	movabs $0x801808,%rax
  801913:	00 00 00 
  801916:	ff d0                	callq  *%rax
  801918:	48 83 c4 10          	add    $0x10,%rsp
}
  80191c:	c9                   	leaveq 
  80191d:	c3                   	retq   

000000000080191e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80191e:	55                   	push   %rbp
  80191f:	48 89 e5             	mov    %rsp,%rbp
  801922:	48 83 ec 10          	sub    $0x10,%rsp
  801926:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801929:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80192c:	48 98                	cltq   
  80192e:	48 83 ec 08          	sub    $0x8,%rsp
  801932:	6a 00                	pushq  $0x0
  801934:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80193a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801940:	b9 00 00 00 00       	mov    $0x0,%ecx
  801945:	48 89 c2             	mov    %rax,%rdx
  801948:	be 01 00 00 00       	mov    $0x1,%esi
  80194d:	bf 03 00 00 00       	mov    $0x3,%edi
  801952:	48 b8 08 18 80 00 00 	movabs $0x801808,%rax
  801959:	00 00 00 
  80195c:	ff d0                	callq  *%rax
  80195e:	48 83 c4 10          	add    $0x10,%rsp
}
  801962:	c9                   	leaveq 
  801963:	c3                   	retq   

0000000000801964 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801964:	55                   	push   %rbp
  801965:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801968:	48 83 ec 08          	sub    $0x8,%rsp
  80196c:	6a 00                	pushq  $0x0
  80196e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801974:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80197a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80197f:	ba 00 00 00 00       	mov    $0x0,%edx
  801984:	be 00 00 00 00       	mov    $0x0,%esi
  801989:	bf 02 00 00 00       	mov    $0x2,%edi
  80198e:	48 b8 08 18 80 00 00 	movabs $0x801808,%rax
  801995:	00 00 00 
  801998:	ff d0                	callq  *%rax
  80199a:	48 83 c4 10          	add    $0x10,%rsp
}
  80199e:	c9                   	leaveq 
  80199f:	c3                   	retq   

00000000008019a0 <sys_yield>:

void
sys_yield(void)
{
  8019a0:	55                   	push   %rbp
  8019a1:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8019a4:	48 83 ec 08          	sub    $0x8,%rsp
  8019a8:	6a 00                	pushq  $0x0
  8019aa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019b0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c0:	be 00 00 00 00       	mov    $0x0,%esi
  8019c5:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019ca:	48 b8 08 18 80 00 00 	movabs $0x801808,%rax
  8019d1:	00 00 00 
  8019d4:	ff d0                	callq  *%rax
  8019d6:	48 83 c4 10          	add    $0x10,%rsp
}
  8019da:	c9                   	leaveq 
  8019db:	c3                   	retq   

00000000008019dc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8019dc:	55                   	push   %rbp
  8019dd:	48 89 e5             	mov    %rsp,%rbp
  8019e0:	48 83 ec 10          	sub    $0x10,%rsp
  8019e4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019e7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019eb:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8019ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019f1:	48 63 c8             	movslq %eax,%rcx
  8019f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019fb:	48 98                	cltq   
  8019fd:	48 83 ec 08          	sub    $0x8,%rsp
  801a01:	6a 00                	pushq  $0x0
  801a03:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a09:	49 89 c8             	mov    %rcx,%r8
  801a0c:	48 89 d1             	mov    %rdx,%rcx
  801a0f:	48 89 c2             	mov    %rax,%rdx
  801a12:	be 01 00 00 00       	mov    $0x1,%esi
  801a17:	bf 04 00 00 00       	mov    $0x4,%edi
  801a1c:	48 b8 08 18 80 00 00 	movabs $0x801808,%rax
  801a23:	00 00 00 
  801a26:	ff d0                	callq  *%rax
  801a28:	48 83 c4 10          	add    $0x10,%rsp
}
  801a2c:	c9                   	leaveq 
  801a2d:	c3                   	retq   

0000000000801a2e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a2e:	55                   	push   %rbp
  801a2f:	48 89 e5             	mov    %rsp,%rbp
  801a32:	48 83 ec 20          	sub    $0x20,%rsp
  801a36:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a3d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a40:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a44:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a48:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a4b:	48 63 c8             	movslq %eax,%rcx
  801a4e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a52:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a55:	48 63 f0             	movslq %eax,%rsi
  801a58:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a5f:	48 98                	cltq   
  801a61:	48 83 ec 08          	sub    $0x8,%rsp
  801a65:	51                   	push   %rcx
  801a66:	49 89 f9             	mov    %rdi,%r9
  801a69:	49 89 f0             	mov    %rsi,%r8
  801a6c:	48 89 d1             	mov    %rdx,%rcx
  801a6f:	48 89 c2             	mov    %rax,%rdx
  801a72:	be 01 00 00 00       	mov    $0x1,%esi
  801a77:	bf 05 00 00 00       	mov    $0x5,%edi
  801a7c:	48 b8 08 18 80 00 00 	movabs $0x801808,%rax
  801a83:	00 00 00 
  801a86:	ff d0                	callq  *%rax
  801a88:	48 83 c4 10          	add    $0x10,%rsp
}
  801a8c:	c9                   	leaveq 
  801a8d:	c3                   	retq   

0000000000801a8e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a8e:	55                   	push   %rbp
  801a8f:	48 89 e5             	mov    %rsp,%rbp
  801a92:	48 83 ec 10          	sub    $0x10,%rsp
  801a96:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a99:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a9d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aa1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aa4:	48 98                	cltq   
  801aa6:	48 83 ec 08          	sub    $0x8,%rsp
  801aaa:	6a 00                	pushq  $0x0
  801aac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ab2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ab8:	48 89 d1             	mov    %rdx,%rcx
  801abb:	48 89 c2             	mov    %rax,%rdx
  801abe:	be 01 00 00 00       	mov    $0x1,%esi
  801ac3:	bf 06 00 00 00       	mov    $0x6,%edi
  801ac8:	48 b8 08 18 80 00 00 	movabs $0x801808,%rax
  801acf:	00 00 00 
  801ad2:	ff d0                	callq  *%rax
  801ad4:	48 83 c4 10          	add    $0x10,%rsp
}
  801ad8:	c9                   	leaveq 
  801ad9:	c3                   	retq   

0000000000801ada <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801ada:	55                   	push   %rbp
  801adb:	48 89 e5             	mov    %rsp,%rbp
  801ade:	48 83 ec 10          	sub    $0x10,%rsp
  801ae2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ae5:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801ae8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aeb:	48 63 d0             	movslq %eax,%rdx
  801aee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801af1:	48 98                	cltq   
  801af3:	48 83 ec 08          	sub    $0x8,%rsp
  801af7:	6a 00                	pushq  $0x0
  801af9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b05:	48 89 d1             	mov    %rdx,%rcx
  801b08:	48 89 c2             	mov    %rax,%rdx
  801b0b:	be 01 00 00 00       	mov    $0x1,%esi
  801b10:	bf 08 00 00 00       	mov    $0x8,%edi
  801b15:	48 b8 08 18 80 00 00 	movabs $0x801808,%rax
  801b1c:	00 00 00 
  801b1f:	ff d0                	callq  *%rax
  801b21:	48 83 c4 10          	add    $0x10,%rsp
}
  801b25:	c9                   	leaveq 
  801b26:	c3                   	retq   

0000000000801b27 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b27:	55                   	push   %rbp
  801b28:	48 89 e5             	mov    %rsp,%rbp
  801b2b:	48 83 ec 10          	sub    $0x10,%rsp
  801b2f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b32:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b36:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b3d:	48 98                	cltq   
  801b3f:	48 83 ec 08          	sub    $0x8,%rsp
  801b43:	6a 00                	pushq  $0x0
  801b45:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b4b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b51:	48 89 d1             	mov    %rdx,%rcx
  801b54:	48 89 c2             	mov    %rax,%rdx
  801b57:	be 01 00 00 00       	mov    $0x1,%esi
  801b5c:	bf 09 00 00 00       	mov    $0x9,%edi
  801b61:	48 b8 08 18 80 00 00 	movabs $0x801808,%rax
  801b68:	00 00 00 
  801b6b:	ff d0                	callq  *%rax
  801b6d:	48 83 c4 10          	add    $0x10,%rsp
}
  801b71:	c9                   	leaveq 
  801b72:	c3                   	retq   

0000000000801b73 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b73:	55                   	push   %rbp
  801b74:	48 89 e5             	mov    %rsp,%rbp
  801b77:	48 83 ec 10          	sub    $0x10,%rsp
  801b7b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b7e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b82:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b89:	48 98                	cltq   
  801b8b:	48 83 ec 08          	sub    $0x8,%rsp
  801b8f:	6a 00                	pushq  $0x0
  801b91:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b97:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b9d:	48 89 d1             	mov    %rdx,%rcx
  801ba0:	48 89 c2             	mov    %rax,%rdx
  801ba3:	be 01 00 00 00       	mov    $0x1,%esi
  801ba8:	bf 0a 00 00 00       	mov    $0xa,%edi
  801bad:	48 b8 08 18 80 00 00 	movabs $0x801808,%rax
  801bb4:	00 00 00 
  801bb7:	ff d0                	callq  *%rax
  801bb9:	48 83 c4 10          	add    $0x10,%rsp
}
  801bbd:	c9                   	leaveq 
  801bbe:	c3                   	retq   

0000000000801bbf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801bbf:	55                   	push   %rbp
  801bc0:	48 89 e5             	mov    %rsp,%rbp
  801bc3:	48 83 ec 20          	sub    $0x20,%rsp
  801bc7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bce:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bd2:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801bd5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bd8:	48 63 f0             	movslq %eax,%rsi
  801bdb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801bdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801be2:	48 98                	cltq   
  801be4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801be8:	48 83 ec 08          	sub    $0x8,%rsp
  801bec:	6a 00                	pushq  $0x0
  801bee:	49 89 f1             	mov    %rsi,%r9
  801bf1:	49 89 c8             	mov    %rcx,%r8
  801bf4:	48 89 d1             	mov    %rdx,%rcx
  801bf7:	48 89 c2             	mov    %rax,%rdx
  801bfa:	be 00 00 00 00       	mov    $0x0,%esi
  801bff:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c04:	48 b8 08 18 80 00 00 	movabs $0x801808,%rax
  801c0b:	00 00 00 
  801c0e:	ff d0                	callq  *%rax
  801c10:	48 83 c4 10          	add    $0x10,%rsp
}
  801c14:	c9                   	leaveq 
  801c15:	c3                   	retq   

0000000000801c16 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c16:	55                   	push   %rbp
  801c17:	48 89 e5             	mov    %rsp,%rbp
  801c1a:	48 83 ec 10          	sub    $0x10,%rsp
  801c1e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c26:	48 83 ec 08          	sub    $0x8,%rsp
  801c2a:	6a 00                	pushq  $0x0
  801c2c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c32:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c38:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c3d:	48 89 c2             	mov    %rax,%rdx
  801c40:	be 01 00 00 00       	mov    $0x1,%esi
  801c45:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c4a:	48 b8 08 18 80 00 00 	movabs $0x801808,%rax
  801c51:	00 00 00 
  801c54:	ff d0                	callq  *%rax
  801c56:	48 83 c4 10          	add    $0x10,%rsp
}
  801c5a:	c9                   	leaveq 
  801c5b:	c3                   	retq   

0000000000801c5c <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801c5c:	55                   	push   %rbp
  801c5d:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c60:	48 83 ec 08          	sub    $0x8,%rsp
  801c64:	6a 00                	pushq  $0x0
  801c66:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c6c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c72:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c77:	ba 00 00 00 00       	mov    $0x0,%edx
  801c7c:	be 00 00 00 00       	mov    $0x0,%esi
  801c81:	bf 0e 00 00 00       	mov    $0xe,%edi
  801c86:	48 b8 08 18 80 00 00 	movabs $0x801808,%rax
  801c8d:	00 00 00 
  801c90:	ff d0                	callq  *%rax
  801c92:	48 83 c4 10          	add    $0x10,%rsp
}
  801c96:	c9                   	leaveq 
  801c97:	c3                   	retq   

0000000000801c98 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801c98:	55                   	push   %rbp
  801c99:	48 89 e5             	mov    %rsp,%rbp
  801c9c:	48 83 ec 20          	sub    $0x20,%rsp
  801ca0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ca3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ca7:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801caa:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801cae:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801cb2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801cb5:	48 63 c8             	movslq %eax,%rcx
  801cb8:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801cbc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cbf:	48 63 f0             	movslq %eax,%rsi
  801cc2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cc9:	48 98                	cltq   
  801ccb:	48 83 ec 08          	sub    $0x8,%rsp
  801ccf:	51                   	push   %rcx
  801cd0:	49 89 f9             	mov    %rdi,%r9
  801cd3:	49 89 f0             	mov    %rsi,%r8
  801cd6:	48 89 d1             	mov    %rdx,%rcx
  801cd9:	48 89 c2             	mov    %rax,%rdx
  801cdc:	be 00 00 00 00       	mov    $0x0,%esi
  801ce1:	bf 0f 00 00 00       	mov    $0xf,%edi
  801ce6:	48 b8 08 18 80 00 00 	movabs $0x801808,%rax
  801ced:	00 00 00 
  801cf0:	ff d0                	callq  *%rax
  801cf2:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801cf6:	c9                   	leaveq 
  801cf7:	c3                   	retq   

0000000000801cf8 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801cf8:	55                   	push   %rbp
  801cf9:	48 89 e5             	mov    %rsp,%rbp
  801cfc:	48 83 ec 10          	sub    $0x10,%rsp
  801d00:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d04:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801d08:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d10:	48 83 ec 08          	sub    $0x8,%rsp
  801d14:	6a 00                	pushq  $0x0
  801d16:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d1c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d22:	48 89 d1             	mov    %rdx,%rcx
  801d25:	48 89 c2             	mov    %rax,%rdx
  801d28:	be 00 00 00 00       	mov    $0x0,%esi
  801d2d:	bf 10 00 00 00       	mov    $0x10,%edi
  801d32:	48 b8 08 18 80 00 00 	movabs $0x801808,%rax
  801d39:	00 00 00 
  801d3c:	ff d0                	callq  *%rax
  801d3e:	48 83 c4 10          	add    $0x10,%rsp
}
  801d42:	c9                   	leaveq 
  801d43:	c3                   	retq   

0000000000801d44 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d44:	55                   	push   %rbp
  801d45:	48 89 e5             	mov    %rsp,%rbp
  801d48:	48 83 ec 08          	sub    $0x8,%rsp
  801d4c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d50:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d54:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d5b:	ff ff ff 
  801d5e:	48 01 d0             	add    %rdx,%rax
  801d61:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d65:	c9                   	leaveq 
  801d66:	c3                   	retq   

0000000000801d67 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d67:	55                   	push   %rbp
  801d68:	48 89 e5             	mov    %rsp,%rbp
  801d6b:	48 83 ec 08          	sub    $0x8,%rsp
  801d6f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d77:	48 89 c7             	mov    %rax,%rdi
  801d7a:	48 b8 44 1d 80 00 00 	movabs $0x801d44,%rax
  801d81:	00 00 00 
  801d84:	ff d0                	callq  *%rax
  801d86:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d8c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d90:	c9                   	leaveq 
  801d91:	c3                   	retq   

0000000000801d92 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d92:	55                   	push   %rbp
  801d93:	48 89 e5             	mov    %rsp,%rbp
  801d96:	48 83 ec 18          	sub    $0x18,%rsp
  801d9a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801da5:	eb 6b                	jmp    801e12 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801da7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801daa:	48 98                	cltq   
  801dac:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801db2:	48 c1 e0 0c          	shl    $0xc,%rax
  801db6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801dba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dbe:	48 c1 e8 15          	shr    $0x15,%rax
  801dc2:	48 89 c2             	mov    %rax,%rdx
  801dc5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801dcc:	01 00 00 
  801dcf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dd3:	83 e0 01             	and    $0x1,%eax
  801dd6:	48 85 c0             	test   %rax,%rax
  801dd9:	74 21                	je     801dfc <fd_alloc+0x6a>
  801ddb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ddf:	48 c1 e8 0c          	shr    $0xc,%rax
  801de3:	48 89 c2             	mov    %rax,%rdx
  801de6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ded:	01 00 00 
  801df0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801df4:	83 e0 01             	and    $0x1,%eax
  801df7:	48 85 c0             	test   %rax,%rax
  801dfa:	75 12                	jne    801e0e <fd_alloc+0x7c>
			*fd_store = fd;
  801dfc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e00:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e04:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e07:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0c:	eb 1a                	jmp    801e28 <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  801e0e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e12:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e16:	7e 8f                	jle    801da7 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  801e18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e1c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e23:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e28:	c9                   	leaveq 
  801e29:	c3                   	retq   

0000000000801e2a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e2a:	55                   	push   %rbp
  801e2b:	48 89 e5             	mov    %rsp,%rbp
  801e2e:	48 83 ec 20          	sub    $0x20,%rsp
  801e32:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e35:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e39:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e3d:	78 06                	js     801e45 <fd_lookup+0x1b>
  801e3f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e43:	7e 07                	jle    801e4c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e45:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e4a:	eb 6c                	jmp    801eb8 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e4c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e4f:	48 98                	cltq   
  801e51:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e57:	48 c1 e0 0c          	shl    $0xc,%rax
  801e5b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e63:	48 c1 e8 15          	shr    $0x15,%rax
  801e67:	48 89 c2             	mov    %rax,%rdx
  801e6a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e71:	01 00 00 
  801e74:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e78:	83 e0 01             	and    $0x1,%eax
  801e7b:	48 85 c0             	test   %rax,%rax
  801e7e:	74 21                	je     801ea1 <fd_lookup+0x77>
  801e80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e84:	48 c1 e8 0c          	shr    $0xc,%rax
  801e88:	48 89 c2             	mov    %rax,%rdx
  801e8b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e92:	01 00 00 
  801e95:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e99:	83 e0 01             	and    $0x1,%eax
  801e9c:	48 85 c0             	test   %rax,%rax
  801e9f:	75 07                	jne    801ea8 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ea1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ea6:	eb 10                	jmp    801eb8 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801ea8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801eac:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801eb0:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801eb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb8:	c9                   	leaveq 
  801eb9:	c3                   	retq   

0000000000801eba <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801eba:	55                   	push   %rbp
  801ebb:	48 89 e5             	mov    %rsp,%rbp
  801ebe:	48 83 ec 30          	sub    $0x30,%rsp
  801ec2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ec6:	89 f0                	mov    %esi,%eax
  801ec8:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ecb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ecf:	48 89 c7             	mov    %rax,%rdi
  801ed2:	48 b8 44 1d 80 00 00 	movabs $0x801d44,%rax
  801ed9:	00 00 00 
  801edc:	ff d0                	callq  *%rax
  801ede:	89 c2                	mov    %eax,%edx
  801ee0:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801ee4:	48 89 c6             	mov    %rax,%rsi
  801ee7:	89 d7                	mov    %edx,%edi
  801ee9:	48 b8 2a 1e 80 00 00 	movabs $0x801e2a,%rax
  801ef0:	00 00 00 
  801ef3:	ff d0                	callq  *%rax
  801ef5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ef8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801efc:	78 0a                	js     801f08 <fd_close+0x4e>
	    || fd != fd2)
  801efe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f02:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f06:	74 12                	je     801f1a <fd_close+0x60>
		return (must_exist ? r : 0);
  801f08:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f0c:	74 05                	je     801f13 <fd_close+0x59>
  801f0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f11:	eb 70                	jmp    801f83 <fd_close+0xc9>
  801f13:	b8 00 00 00 00       	mov    $0x0,%eax
  801f18:	eb 69                	jmp    801f83 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f1e:	8b 00                	mov    (%rax),%eax
  801f20:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f24:	48 89 d6             	mov    %rdx,%rsi
  801f27:	89 c7                	mov    %eax,%edi
  801f29:	48 b8 85 1f 80 00 00 	movabs $0x801f85,%rax
  801f30:	00 00 00 
  801f33:	ff d0                	callq  *%rax
  801f35:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f3c:	78 2a                	js     801f68 <fd_close+0xae>
		if (dev->dev_close)
  801f3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f42:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f46:	48 85 c0             	test   %rax,%rax
  801f49:	74 16                	je     801f61 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  801f4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f4f:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f53:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f57:	48 89 d7             	mov    %rdx,%rdi
  801f5a:	ff d0                	callq  *%rax
  801f5c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f5f:	eb 07                	jmp    801f68 <fd_close+0xae>
		else
			r = 0;
  801f61:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f6c:	48 89 c6             	mov    %rax,%rsi
  801f6f:	bf 00 00 00 00       	mov    $0x0,%edi
  801f74:	48 b8 8e 1a 80 00 00 	movabs $0x801a8e,%rax
  801f7b:	00 00 00 
  801f7e:	ff d0                	callq  *%rax
	return r;
  801f80:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f83:	c9                   	leaveq 
  801f84:	c3                   	retq   

0000000000801f85 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f85:	55                   	push   %rbp
  801f86:	48 89 e5             	mov    %rsp,%rbp
  801f89:	48 83 ec 20          	sub    $0x20,%rsp
  801f8d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f90:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f9b:	eb 41                	jmp    801fde <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f9d:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801fa4:	00 00 00 
  801fa7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801faa:	48 63 d2             	movslq %edx,%rdx
  801fad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fb1:	8b 00                	mov    (%rax),%eax
  801fb3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801fb6:	75 22                	jne    801fda <dev_lookup+0x55>
			*dev = devtab[i];
  801fb8:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801fbf:	00 00 00 
  801fc2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fc5:	48 63 d2             	movslq %edx,%rdx
  801fc8:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801fcc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fd0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801fd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd8:	eb 60                	jmp    80203a <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  801fda:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fde:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801fe5:	00 00 00 
  801fe8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801feb:	48 63 d2             	movslq %edx,%rdx
  801fee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ff2:	48 85 c0             	test   %rax,%rax
  801ff5:	75 a6                	jne    801f9d <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801ff7:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  801ffe:	00 00 00 
  802001:	48 8b 00             	mov    (%rax),%rax
  802004:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80200a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80200d:	89 c6                	mov    %eax,%esi
  80200f:	48 bf 78 4f 80 00 00 	movabs $0x804f78,%rdi
  802016:	00 00 00 
  802019:	b8 00 00 00 00       	mov    $0x0,%eax
  80201e:	48 b9 15 05 80 00 00 	movabs $0x800515,%rcx
  802025:	00 00 00 
  802028:	ff d1                	callq  *%rcx
	*dev = 0;
  80202a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80202e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802035:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80203a:	c9                   	leaveq 
  80203b:	c3                   	retq   

000000000080203c <close>:

int
close(int fdnum)
{
  80203c:	55                   	push   %rbp
  80203d:	48 89 e5             	mov    %rsp,%rbp
  802040:	48 83 ec 20          	sub    $0x20,%rsp
  802044:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802047:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80204b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80204e:	48 89 d6             	mov    %rdx,%rsi
  802051:	89 c7                	mov    %eax,%edi
  802053:	48 b8 2a 1e 80 00 00 	movabs $0x801e2a,%rax
  80205a:	00 00 00 
  80205d:	ff d0                	callq  *%rax
  80205f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802062:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802066:	79 05                	jns    80206d <close+0x31>
		return r;
  802068:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80206b:	eb 18                	jmp    802085 <close+0x49>
	else
		return fd_close(fd, 1);
  80206d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802071:	be 01 00 00 00       	mov    $0x1,%esi
  802076:	48 89 c7             	mov    %rax,%rdi
  802079:	48 b8 ba 1e 80 00 00 	movabs $0x801eba,%rax
  802080:	00 00 00 
  802083:	ff d0                	callq  *%rax
}
  802085:	c9                   	leaveq 
  802086:	c3                   	retq   

0000000000802087 <close_all>:

void
close_all(void)
{
  802087:	55                   	push   %rbp
  802088:	48 89 e5             	mov    %rsp,%rbp
  80208b:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80208f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802096:	eb 15                	jmp    8020ad <close_all+0x26>
		close(i);
  802098:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80209b:	89 c7                	mov    %eax,%edi
  80209d:	48 b8 3c 20 80 00 00 	movabs $0x80203c,%rax
  8020a4:	00 00 00 
  8020a7:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  8020a9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020ad:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8020b1:	7e e5                	jle    802098 <close_all+0x11>
}
  8020b3:	c9                   	leaveq 
  8020b4:	c3                   	retq   

00000000008020b5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8020b5:	55                   	push   %rbp
  8020b6:	48 89 e5             	mov    %rsp,%rbp
  8020b9:	48 83 ec 40          	sub    $0x40,%rsp
  8020bd:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8020c0:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8020c3:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8020c7:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8020ca:	48 89 d6             	mov    %rdx,%rsi
  8020cd:	89 c7                	mov    %eax,%edi
  8020cf:	48 b8 2a 1e 80 00 00 	movabs $0x801e2a,%rax
  8020d6:	00 00 00 
  8020d9:	ff d0                	callq  *%rax
  8020db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020e2:	79 08                	jns    8020ec <dup+0x37>
		return r;
  8020e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020e7:	e9 70 01 00 00       	jmpq   80225c <dup+0x1a7>
	close(newfdnum);
  8020ec:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020ef:	89 c7                	mov    %eax,%edi
  8020f1:	48 b8 3c 20 80 00 00 	movabs $0x80203c,%rax
  8020f8:	00 00 00 
  8020fb:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8020fd:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802100:	48 98                	cltq   
  802102:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802108:	48 c1 e0 0c          	shl    $0xc,%rax
  80210c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802110:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802114:	48 89 c7             	mov    %rax,%rdi
  802117:	48 b8 67 1d 80 00 00 	movabs $0x801d67,%rax
  80211e:	00 00 00 
  802121:	ff d0                	callq  *%rax
  802123:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802127:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80212b:	48 89 c7             	mov    %rax,%rdi
  80212e:	48 b8 67 1d 80 00 00 	movabs $0x801d67,%rax
  802135:	00 00 00 
  802138:	ff d0                	callq  *%rax
  80213a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80213e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802142:	48 c1 e8 15          	shr    $0x15,%rax
  802146:	48 89 c2             	mov    %rax,%rdx
  802149:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802150:	01 00 00 
  802153:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802157:	83 e0 01             	and    $0x1,%eax
  80215a:	48 85 c0             	test   %rax,%rax
  80215d:	74 73                	je     8021d2 <dup+0x11d>
  80215f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802163:	48 c1 e8 0c          	shr    $0xc,%rax
  802167:	48 89 c2             	mov    %rax,%rdx
  80216a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802171:	01 00 00 
  802174:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802178:	83 e0 01             	and    $0x1,%eax
  80217b:	48 85 c0             	test   %rax,%rax
  80217e:	74 52                	je     8021d2 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802180:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802184:	48 c1 e8 0c          	shr    $0xc,%rax
  802188:	48 89 c2             	mov    %rax,%rdx
  80218b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802192:	01 00 00 
  802195:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802199:	25 07 0e 00 00       	and    $0xe07,%eax
  80219e:	89 c1                	mov    %eax,%ecx
  8021a0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8021a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a8:	41 89 c8             	mov    %ecx,%r8d
  8021ab:	48 89 d1             	mov    %rdx,%rcx
  8021ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b3:	48 89 c6             	mov    %rax,%rsi
  8021b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8021bb:	48 b8 2e 1a 80 00 00 	movabs $0x801a2e,%rax
  8021c2:	00 00 00 
  8021c5:	ff d0                	callq  *%rax
  8021c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021ce:	79 02                	jns    8021d2 <dup+0x11d>
			goto err;
  8021d0:	eb 57                	jmp    802229 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8021d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021d6:	48 c1 e8 0c          	shr    $0xc,%rax
  8021da:	48 89 c2             	mov    %rax,%rdx
  8021dd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021e4:	01 00 00 
  8021e7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021eb:	25 07 0e 00 00       	and    $0xe07,%eax
  8021f0:	89 c1                	mov    %eax,%ecx
  8021f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021f6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021fa:	41 89 c8             	mov    %ecx,%r8d
  8021fd:	48 89 d1             	mov    %rdx,%rcx
  802200:	ba 00 00 00 00       	mov    $0x0,%edx
  802205:	48 89 c6             	mov    %rax,%rsi
  802208:	bf 00 00 00 00       	mov    $0x0,%edi
  80220d:	48 b8 2e 1a 80 00 00 	movabs $0x801a2e,%rax
  802214:	00 00 00 
  802217:	ff d0                	callq  *%rax
  802219:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80221c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802220:	79 02                	jns    802224 <dup+0x16f>
		goto err;
  802222:	eb 05                	jmp    802229 <dup+0x174>

	return newfdnum;
  802224:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802227:	eb 33                	jmp    80225c <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802229:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80222d:	48 89 c6             	mov    %rax,%rsi
  802230:	bf 00 00 00 00       	mov    $0x0,%edi
  802235:	48 b8 8e 1a 80 00 00 	movabs $0x801a8e,%rax
  80223c:	00 00 00 
  80223f:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802241:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802245:	48 89 c6             	mov    %rax,%rsi
  802248:	bf 00 00 00 00       	mov    $0x0,%edi
  80224d:	48 b8 8e 1a 80 00 00 	movabs $0x801a8e,%rax
  802254:	00 00 00 
  802257:	ff d0                	callq  *%rax
	return r;
  802259:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80225c:	c9                   	leaveq 
  80225d:	c3                   	retq   

000000000080225e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80225e:	55                   	push   %rbp
  80225f:	48 89 e5             	mov    %rsp,%rbp
  802262:	48 83 ec 40          	sub    $0x40,%rsp
  802266:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802269:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80226d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802271:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802275:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802278:	48 89 d6             	mov    %rdx,%rsi
  80227b:	89 c7                	mov    %eax,%edi
  80227d:	48 b8 2a 1e 80 00 00 	movabs $0x801e2a,%rax
  802284:	00 00 00 
  802287:	ff d0                	callq  *%rax
  802289:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80228c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802290:	78 24                	js     8022b6 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802292:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802296:	8b 00                	mov    (%rax),%eax
  802298:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80229c:	48 89 d6             	mov    %rdx,%rsi
  80229f:	89 c7                	mov    %eax,%edi
  8022a1:	48 b8 85 1f 80 00 00 	movabs $0x801f85,%rax
  8022a8:	00 00 00 
  8022ab:	ff d0                	callq  *%rax
  8022ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022b4:	79 05                	jns    8022bb <read+0x5d>
		return r;
  8022b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022b9:	eb 76                	jmp    802331 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8022bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022bf:	8b 40 08             	mov    0x8(%rax),%eax
  8022c2:	83 e0 03             	and    $0x3,%eax
  8022c5:	83 f8 01             	cmp    $0x1,%eax
  8022c8:	75 3a                	jne    802304 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8022ca:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8022d1:	00 00 00 
  8022d4:	48 8b 00             	mov    (%rax),%rax
  8022d7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022dd:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022e0:	89 c6                	mov    %eax,%esi
  8022e2:	48 bf 97 4f 80 00 00 	movabs $0x804f97,%rdi
  8022e9:	00 00 00 
  8022ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f1:	48 b9 15 05 80 00 00 	movabs $0x800515,%rcx
  8022f8:	00 00 00 
  8022fb:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8022fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802302:	eb 2d                	jmp    802331 <read+0xd3>
	}
	if (!dev->dev_read)
  802304:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802308:	48 8b 40 10          	mov    0x10(%rax),%rax
  80230c:	48 85 c0             	test   %rax,%rax
  80230f:	75 07                	jne    802318 <read+0xba>
		return -E_NOT_SUPP;
  802311:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802316:	eb 19                	jmp    802331 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802318:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80231c:	48 8b 40 10          	mov    0x10(%rax),%rax
  802320:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802324:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802328:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80232c:	48 89 cf             	mov    %rcx,%rdi
  80232f:	ff d0                	callq  *%rax
}
  802331:	c9                   	leaveq 
  802332:	c3                   	retq   

0000000000802333 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802333:	55                   	push   %rbp
  802334:	48 89 e5             	mov    %rsp,%rbp
  802337:	48 83 ec 30          	sub    $0x30,%rsp
  80233b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80233e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802342:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802346:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80234d:	eb 49                	jmp    802398 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80234f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802352:	48 98                	cltq   
  802354:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802358:	48 29 c2             	sub    %rax,%rdx
  80235b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80235e:	48 63 c8             	movslq %eax,%rcx
  802361:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802365:	48 01 c1             	add    %rax,%rcx
  802368:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80236b:	48 89 ce             	mov    %rcx,%rsi
  80236e:	89 c7                	mov    %eax,%edi
  802370:	48 b8 5e 22 80 00 00 	movabs $0x80225e,%rax
  802377:	00 00 00 
  80237a:	ff d0                	callq  *%rax
  80237c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80237f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802383:	79 05                	jns    80238a <readn+0x57>
			return m;
  802385:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802388:	eb 1c                	jmp    8023a6 <readn+0x73>
		if (m == 0)
  80238a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80238e:	75 02                	jne    802392 <readn+0x5f>
			break;
  802390:	eb 11                	jmp    8023a3 <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  802392:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802395:	01 45 fc             	add    %eax,-0x4(%rbp)
  802398:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80239b:	48 98                	cltq   
  80239d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8023a1:	72 ac                	jb     80234f <readn+0x1c>
	}
	return tot;
  8023a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023a6:	c9                   	leaveq 
  8023a7:	c3                   	retq   

00000000008023a8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8023a8:	55                   	push   %rbp
  8023a9:	48 89 e5             	mov    %rsp,%rbp
  8023ac:	48 83 ec 40          	sub    $0x40,%rsp
  8023b0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023b3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023b7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023bb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023bf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023c2:	48 89 d6             	mov    %rdx,%rsi
  8023c5:	89 c7                	mov    %eax,%edi
  8023c7:	48 b8 2a 1e 80 00 00 	movabs $0x801e2a,%rax
  8023ce:	00 00 00 
  8023d1:	ff d0                	callq  *%rax
  8023d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023da:	78 24                	js     802400 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023e0:	8b 00                	mov    (%rax),%eax
  8023e2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023e6:	48 89 d6             	mov    %rdx,%rsi
  8023e9:	89 c7                	mov    %eax,%edi
  8023eb:	48 b8 85 1f 80 00 00 	movabs $0x801f85,%rax
  8023f2:	00 00 00 
  8023f5:	ff d0                	callq  *%rax
  8023f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023fe:	79 05                	jns    802405 <write+0x5d>
		return r;
  802400:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802403:	eb 75                	jmp    80247a <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802405:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802409:	8b 40 08             	mov    0x8(%rax),%eax
  80240c:	83 e0 03             	and    $0x3,%eax
  80240f:	85 c0                	test   %eax,%eax
  802411:	75 3a                	jne    80244d <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802413:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80241a:	00 00 00 
  80241d:	48 8b 00             	mov    (%rax),%rax
  802420:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802426:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802429:	89 c6                	mov    %eax,%esi
  80242b:	48 bf b3 4f 80 00 00 	movabs $0x804fb3,%rdi
  802432:	00 00 00 
  802435:	b8 00 00 00 00       	mov    $0x0,%eax
  80243a:	48 b9 15 05 80 00 00 	movabs $0x800515,%rcx
  802441:	00 00 00 
  802444:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802446:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80244b:	eb 2d                	jmp    80247a <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80244d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802451:	48 8b 40 18          	mov    0x18(%rax),%rax
  802455:	48 85 c0             	test   %rax,%rax
  802458:	75 07                	jne    802461 <write+0xb9>
		return -E_NOT_SUPP;
  80245a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80245f:	eb 19                	jmp    80247a <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802461:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802465:	48 8b 40 18          	mov    0x18(%rax),%rax
  802469:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80246d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802471:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802475:	48 89 cf             	mov    %rcx,%rdi
  802478:	ff d0                	callq  *%rax
}
  80247a:	c9                   	leaveq 
  80247b:	c3                   	retq   

000000000080247c <seek>:

int
seek(int fdnum, off_t offset)
{
  80247c:	55                   	push   %rbp
  80247d:	48 89 e5             	mov    %rsp,%rbp
  802480:	48 83 ec 18          	sub    $0x18,%rsp
  802484:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802487:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80248a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80248e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802491:	48 89 d6             	mov    %rdx,%rsi
  802494:	89 c7                	mov    %eax,%edi
  802496:	48 b8 2a 1e 80 00 00 	movabs $0x801e2a,%rax
  80249d:	00 00 00 
  8024a0:	ff d0                	callq  *%rax
  8024a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024a9:	79 05                	jns    8024b0 <seek+0x34>
		return r;
  8024ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ae:	eb 0f                	jmp    8024bf <seek+0x43>
	fd->fd_offset = offset;
  8024b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8024b7:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8024ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024bf:	c9                   	leaveq 
  8024c0:	c3                   	retq   

00000000008024c1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8024c1:	55                   	push   %rbp
  8024c2:	48 89 e5             	mov    %rsp,%rbp
  8024c5:	48 83 ec 30          	sub    $0x30,%rsp
  8024c9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024cc:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024cf:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024d3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024d6:	48 89 d6             	mov    %rdx,%rsi
  8024d9:	89 c7                	mov    %eax,%edi
  8024db:	48 b8 2a 1e 80 00 00 	movabs $0x801e2a,%rax
  8024e2:	00 00 00 
  8024e5:	ff d0                	callq  *%rax
  8024e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024ee:	78 24                	js     802514 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024f4:	8b 00                	mov    (%rax),%eax
  8024f6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024fa:	48 89 d6             	mov    %rdx,%rsi
  8024fd:	89 c7                	mov    %eax,%edi
  8024ff:	48 b8 85 1f 80 00 00 	movabs $0x801f85,%rax
  802506:	00 00 00 
  802509:	ff d0                	callq  *%rax
  80250b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80250e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802512:	79 05                	jns    802519 <ftruncate+0x58>
		return r;
  802514:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802517:	eb 72                	jmp    80258b <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802519:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80251d:	8b 40 08             	mov    0x8(%rax),%eax
  802520:	83 e0 03             	and    $0x3,%eax
  802523:	85 c0                	test   %eax,%eax
  802525:	75 3a                	jne    802561 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802527:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80252e:	00 00 00 
  802531:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802534:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80253a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80253d:	89 c6                	mov    %eax,%esi
  80253f:	48 bf d0 4f 80 00 00 	movabs $0x804fd0,%rdi
  802546:	00 00 00 
  802549:	b8 00 00 00 00       	mov    $0x0,%eax
  80254e:	48 b9 15 05 80 00 00 	movabs $0x800515,%rcx
  802555:	00 00 00 
  802558:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80255a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80255f:	eb 2a                	jmp    80258b <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802561:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802565:	48 8b 40 30          	mov    0x30(%rax),%rax
  802569:	48 85 c0             	test   %rax,%rax
  80256c:	75 07                	jne    802575 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80256e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802573:	eb 16                	jmp    80258b <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802575:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802579:	48 8b 40 30          	mov    0x30(%rax),%rax
  80257d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802581:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802584:	89 ce                	mov    %ecx,%esi
  802586:	48 89 d7             	mov    %rdx,%rdi
  802589:	ff d0                	callq  *%rax
}
  80258b:	c9                   	leaveq 
  80258c:	c3                   	retq   

000000000080258d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80258d:	55                   	push   %rbp
  80258e:	48 89 e5             	mov    %rsp,%rbp
  802591:	48 83 ec 30          	sub    $0x30,%rsp
  802595:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802598:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80259c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025a0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025a3:	48 89 d6             	mov    %rdx,%rsi
  8025a6:	89 c7                	mov    %eax,%edi
  8025a8:	48 b8 2a 1e 80 00 00 	movabs $0x801e2a,%rax
  8025af:	00 00 00 
  8025b2:	ff d0                	callq  *%rax
  8025b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025bb:	78 24                	js     8025e1 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025c1:	8b 00                	mov    (%rax),%eax
  8025c3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025c7:	48 89 d6             	mov    %rdx,%rsi
  8025ca:	89 c7                	mov    %eax,%edi
  8025cc:	48 b8 85 1f 80 00 00 	movabs $0x801f85,%rax
  8025d3:	00 00 00 
  8025d6:	ff d0                	callq  *%rax
  8025d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025df:	79 05                	jns    8025e6 <fstat+0x59>
		return r;
  8025e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e4:	eb 5e                	jmp    802644 <fstat+0xb7>
	if (!dev->dev_stat)
  8025e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ea:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025ee:	48 85 c0             	test   %rax,%rax
  8025f1:	75 07                	jne    8025fa <fstat+0x6d>
		return -E_NOT_SUPP;
  8025f3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025f8:	eb 4a                	jmp    802644 <fstat+0xb7>
	stat->st_name[0] = 0;
  8025fa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025fe:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802601:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802605:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80260c:	00 00 00 
	stat->st_isdir = 0;
  80260f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802613:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80261a:	00 00 00 
	stat->st_dev = dev;
  80261d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802621:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802625:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80262c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802630:	48 8b 40 28          	mov    0x28(%rax),%rax
  802634:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802638:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80263c:	48 89 ce             	mov    %rcx,%rsi
  80263f:	48 89 d7             	mov    %rdx,%rdi
  802642:	ff d0                	callq  *%rax
}
  802644:	c9                   	leaveq 
  802645:	c3                   	retq   

0000000000802646 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802646:	55                   	push   %rbp
  802647:	48 89 e5             	mov    %rsp,%rbp
  80264a:	48 83 ec 20          	sub    $0x20,%rsp
  80264e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802652:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802656:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80265a:	be 00 00 00 00       	mov    $0x0,%esi
  80265f:	48 89 c7             	mov    %rax,%rdi
  802662:	48 b8 36 27 80 00 00 	movabs $0x802736,%rax
  802669:	00 00 00 
  80266c:	ff d0                	callq  *%rax
  80266e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802671:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802675:	79 05                	jns    80267c <stat+0x36>
		return fd;
  802677:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80267a:	eb 2f                	jmp    8026ab <stat+0x65>
	r = fstat(fd, stat);
  80267c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802680:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802683:	48 89 d6             	mov    %rdx,%rsi
  802686:	89 c7                	mov    %eax,%edi
  802688:	48 b8 8d 25 80 00 00 	movabs $0x80258d,%rax
  80268f:	00 00 00 
  802692:	ff d0                	callq  *%rax
  802694:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802697:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80269a:	89 c7                	mov    %eax,%edi
  80269c:	48 b8 3c 20 80 00 00 	movabs $0x80203c,%rax
  8026a3:	00 00 00 
  8026a6:	ff d0                	callq  *%rax
	return r;
  8026a8:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8026ab:	c9                   	leaveq 
  8026ac:	c3                   	retq   

00000000008026ad <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8026ad:	55                   	push   %rbp
  8026ae:	48 89 e5             	mov    %rsp,%rbp
  8026b1:	48 83 ec 10          	sub    $0x10,%rsp
  8026b5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8026b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8026bc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8026c3:	00 00 00 
  8026c6:	8b 00                	mov    (%rax),%eax
  8026c8:	85 c0                	test   %eax,%eax
  8026ca:	75 1f                	jne    8026eb <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8026cc:	bf 01 00 00 00       	mov    $0x1,%edi
  8026d1:	48 b8 1c 48 80 00 00 	movabs $0x80481c,%rax
  8026d8:	00 00 00 
  8026db:	ff d0                	callq  *%rax
  8026dd:	89 c2                	mov    %eax,%edx
  8026df:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8026e6:	00 00 00 
  8026e9:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8026eb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8026f2:	00 00 00 
  8026f5:	8b 00                	mov    (%rax),%eax
  8026f7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8026fa:	b9 07 00 00 00       	mov    $0x7,%ecx
  8026ff:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802706:	00 00 00 
  802709:	89 c7                	mov    %eax,%edi
  80270b:	48 b8 8f 46 80 00 00 	movabs $0x80468f,%rax
  802712:	00 00 00 
  802715:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802717:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80271b:	ba 00 00 00 00       	mov    $0x0,%edx
  802720:	48 89 c6             	mov    %rax,%rsi
  802723:	bf 00 00 00 00       	mov    $0x0,%edi
  802728:	48 b8 51 46 80 00 00 	movabs $0x804651,%rax
  80272f:	00 00 00 
  802732:	ff d0                	callq  *%rax
}
  802734:	c9                   	leaveq 
  802735:	c3                   	retq   

0000000000802736 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802736:	55                   	push   %rbp
  802737:	48 89 e5             	mov    %rsp,%rbp
  80273a:	48 83 ec 10          	sub    $0x10,%rsp
  80273e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802742:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  802745:	48 ba f6 4f 80 00 00 	movabs $0x804ff6,%rdx
  80274c:	00 00 00 
  80274f:	be 4c 00 00 00       	mov    $0x4c,%esi
  802754:	48 bf 0b 50 80 00 00 	movabs $0x80500b,%rdi
  80275b:	00 00 00 
  80275e:	b8 00 00 00 00       	mov    $0x0,%eax
  802763:	48 b9 dc 02 80 00 00 	movabs $0x8002dc,%rcx
  80276a:	00 00 00 
  80276d:	ff d1                	callq  *%rcx

000000000080276f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80276f:	55                   	push   %rbp
  802770:	48 89 e5             	mov    %rsp,%rbp
  802773:	48 83 ec 10          	sub    $0x10,%rsp
  802777:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80277b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80277f:	8b 50 0c             	mov    0xc(%rax),%edx
  802782:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802789:	00 00 00 
  80278c:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80278e:	be 00 00 00 00       	mov    $0x0,%esi
  802793:	bf 06 00 00 00       	mov    $0x6,%edi
  802798:	48 b8 ad 26 80 00 00 	movabs $0x8026ad,%rax
  80279f:	00 00 00 
  8027a2:	ff d0                	callq  *%rax
}
  8027a4:	c9                   	leaveq 
  8027a5:	c3                   	retq   

00000000008027a6 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8027a6:	55                   	push   %rbp
  8027a7:	48 89 e5             	mov    %rsp,%rbp
  8027aa:	48 83 ec 20          	sub    $0x20,%rsp
  8027ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8027b2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8027b6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  8027ba:	48 ba 16 50 80 00 00 	movabs $0x805016,%rdx
  8027c1:	00 00 00 
  8027c4:	be 6b 00 00 00       	mov    $0x6b,%esi
  8027c9:	48 bf 0b 50 80 00 00 	movabs $0x80500b,%rdi
  8027d0:	00 00 00 
  8027d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d8:	48 b9 dc 02 80 00 00 	movabs $0x8002dc,%rcx
  8027df:	00 00 00 
  8027e2:	ff d1                	callq  *%rcx

00000000008027e4 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8027e4:	55                   	push   %rbp
  8027e5:	48 89 e5             	mov    %rsp,%rbp
  8027e8:	48 83 ec 20          	sub    $0x20,%rsp
  8027ec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8027f0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8027f4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  8027f8:	48 ba 33 50 80 00 00 	movabs $0x805033,%rdx
  8027ff:	00 00 00 
  802802:	be 7b 00 00 00       	mov    $0x7b,%esi
  802807:	48 bf 0b 50 80 00 00 	movabs $0x80500b,%rdi
  80280e:	00 00 00 
  802811:	b8 00 00 00 00       	mov    $0x0,%eax
  802816:	48 b9 dc 02 80 00 00 	movabs $0x8002dc,%rcx
  80281d:	00 00 00 
  802820:	ff d1                	callq  *%rcx

0000000000802822 <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802822:	55                   	push   %rbp
  802823:	48 89 e5             	mov    %rsp,%rbp
  802826:	48 83 ec 20          	sub    $0x20,%rsp
  80282a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80282e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802832:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802836:	8b 50 0c             	mov    0xc(%rax),%edx
  802839:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802840:	00 00 00 
  802843:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802845:	be 00 00 00 00       	mov    $0x0,%esi
  80284a:	bf 05 00 00 00       	mov    $0x5,%edi
  80284f:	48 b8 ad 26 80 00 00 	movabs $0x8026ad,%rax
  802856:	00 00 00 
  802859:	ff d0                	callq  *%rax
  80285b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80285e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802862:	79 05                	jns    802869 <devfile_stat+0x47>
		return r;
  802864:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802867:	eb 56                	jmp    8028bf <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802869:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80286d:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802874:	00 00 00 
  802877:	48 89 c7             	mov    %rax,%rdi
  80287a:	48 b8 af 10 80 00 00 	movabs $0x8010af,%rax
  802881:	00 00 00 
  802884:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802886:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80288d:	00 00 00 
  802890:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802896:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80289a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8028a0:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028a7:	00 00 00 
  8028aa:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8028b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028b4:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8028ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028bf:	c9                   	leaveq 
  8028c0:	c3                   	retq   

00000000008028c1 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8028c1:	55                   	push   %rbp
  8028c2:	48 89 e5             	mov    %rsp,%rbp
  8028c5:	48 83 ec 10          	sub    $0x10,%rsp
  8028c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8028cd:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8028d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028d4:	8b 50 0c             	mov    0xc(%rax),%edx
  8028d7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028de:	00 00 00 
  8028e1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8028e3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028ea:	00 00 00 
  8028ed:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8028f0:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8028f3:	be 00 00 00 00       	mov    $0x0,%esi
  8028f8:	bf 02 00 00 00       	mov    $0x2,%edi
  8028fd:	48 b8 ad 26 80 00 00 	movabs $0x8026ad,%rax
  802904:	00 00 00 
  802907:	ff d0                	callq  *%rax
}
  802909:	c9                   	leaveq 
  80290a:	c3                   	retq   

000000000080290b <remove>:

// Delete a file
int
remove(const char *path)
{
  80290b:	55                   	push   %rbp
  80290c:	48 89 e5             	mov    %rsp,%rbp
  80290f:	48 83 ec 10          	sub    $0x10,%rsp
  802913:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802917:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80291b:	48 89 c7             	mov    %rax,%rdi
  80291e:	48 b8 43 10 80 00 00 	movabs $0x801043,%rax
  802925:	00 00 00 
  802928:	ff d0                	callq  *%rax
  80292a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80292f:	7e 07                	jle    802938 <remove+0x2d>
		return -E_BAD_PATH;
  802931:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802936:	eb 33                	jmp    80296b <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802938:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80293c:	48 89 c6             	mov    %rax,%rsi
  80293f:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802946:	00 00 00 
  802949:	48 b8 af 10 80 00 00 	movabs $0x8010af,%rax
  802950:	00 00 00 
  802953:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802955:	be 00 00 00 00       	mov    $0x0,%esi
  80295a:	bf 07 00 00 00       	mov    $0x7,%edi
  80295f:	48 b8 ad 26 80 00 00 	movabs $0x8026ad,%rax
  802966:	00 00 00 
  802969:	ff d0                	callq  *%rax
}
  80296b:	c9                   	leaveq 
  80296c:	c3                   	retq   

000000000080296d <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80296d:	55                   	push   %rbp
  80296e:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802971:	be 00 00 00 00       	mov    $0x0,%esi
  802976:	bf 08 00 00 00       	mov    $0x8,%edi
  80297b:	48 b8 ad 26 80 00 00 	movabs $0x8026ad,%rax
  802982:	00 00 00 
  802985:	ff d0                	callq  *%rax
}
  802987:	5d                   	pop    %rbp
  802988:	c3                   	retq   

0000000000802989 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802989:	55                   	push   %rbp
  80298a:	48 89 e5             	mov    %rsp,%rbp
  80298d:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802994:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80299b:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8029a2:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8029a9:	be 00 00 00 00       	mov    $0x0,%esi
  8029ae:	48 89 c7             	mov    %rax,%rdi
  8029b1:	48 b8 36 27 80 00 00 	movabs $0x802736,%rax
  8029b8:	00 00 00 
  8029bb:	ff d0                	callq  *%rax
  8029bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8029c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029c4:	79 28                	jns    8029ee <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8029c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c9:	89 c6                	mov    %eax,%esi
  8029cb:	48 bf 51 50 80 00 00 	movabs $0x805051,%rdi
  8029d2:	00 00 00 
  8029d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8029da:	48 ba 15 05 80 00 00 	movabs $0x800515,%rdx
  8029e1:	00 00 00 
  8029e4:	ff d2                	callq  *%rdx
		return fd_src;
  8029e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e9:	e9 74 01 00 00       	jmpq   802b62 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8029ee:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8029f5:	be 01 01 00 00       	mov    $0x101,%esi
  8029fa:	48 89 c7             	mov    %rax,%rdi
  8029fd:	48 b8 36 27 80 00 00 	movabs $0x802736,%rax
  802a04:	00 00 00 
  802a07:	ff d0                	callq  *%rax
  802a09:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802a0c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a10:	79 39                	jns    802a4b <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802a12:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a15:	89 c6                	mov    %eax,%esi
  802a17:	48 bf 67 50 80 00 00 	movabs $0x805067,%rdi
  802a1e:	00 00 00 
  802a21:	b8 00 00 00 00       	mov    $0x0,%eax
  802a26:	48 ba 15 05 80 00 00 	movabs $0x800515,%rdx
  802a2d:	00 00 00 
  802a30:	ff d2                	callq  *%rdx
		close(fd_src);
  802a32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a35:	89 c7                	mov    %eax,%edi
  802a37:	48 b8 3c 20 80 00 00 	movabs $0x80203c,%rax
  802a3e:	00 00 00 
  802a41:	ff d0                	callq  *%rax
		return fd_dest;
  802a43:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a46:	e9 17 01 00 00       	jmpq   802b62 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802a4b:	eb 74                	jmp    802ac1 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802a4d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a50:	48 63 d0             	movslq %eax,%rdx
  802a53:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802a5a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a5d:	48 89 ce             	mov    %rcx,%rsi
  802a60:	89 c7                	mov    %eax,%edi
  802a62:	48 b8 a8 23 80 00 00 	movabs $0x8023a8,%rax
  802a69:	00 00 00 
  802a6c:	ff d0                	callq  *%rax
  802a6e:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802a71:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802a75:	79 4a                	jns    802ac1 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802a77:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802a7a:	89 c6                	mov    %eax,%esi
  802a7c:	48 bf 81 50 80 00 00 	movabs $0x805081,%rdi
  802a83:	00 00 00 
  802a86:	b8 00 00 00 00       	mov    $0x0,%eax
  802a8b:	48 ba 15 05 80 00 00 	movabs $0x800515,%rdx
  802a92:	00 00 00 
  802a95:	ff d2                	callq  *%rdx
			close(fd_src);
  802a97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a9a:	89 c7                	mov    %eax,%edi
  802a9c:	48 b8 3c 20 80 00 00 	movabs $0x80203c,%rax
  802aa3:	00 00 00 
  802aa6:	ff d0                	callq  *%rax
			close(fd_dest);
  802aa8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802aab:	89 c7                	mov    %eax,%edi
  802aad:	48 b8 3c 20 80 00 00 	movabs $0x80203c,%rax
  802ab4:	00 00 00 
  802ab7:	ff d0                	callq  *%rax
			return write_size;
  802ab9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802abc:	e9 a1 00 00 00       	jmpq   802b62 <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802ac1:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802ac8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802acb:	ba 00 02 00 00       	mov    $0x200,%edx
  802ad0:	48 89 ce             	mov    %rcx,%rsi
  802ad3:	89 c7                	mov    %eax,%edi
  802ad5:	48 b8 5e 22 80 00 00 	movabs $0x80225e,%rax
  802adc:	00 00 00 
  802adf:	ff d0                	callq  *%rax
  802ae1:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802ae4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802ae8:	0f 8f 5f ff ff ff    	jg     802a4d <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  802aee:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802af2:	79 47                	jns    802b3b <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802af4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802af7:	89 c6                	mov    %eax,%esi
  802af9:	48 bf 94 50 80 00 00 	movabs $0x805094,%rdi
  802b00:	00 00 00 
  802b03:	b8 00 00 00 00       	mov    $0x0,%eax
  802b08:	48 ba 15 05 80 00 00 	movabs $0x800515,%rdx
  802b0f:	00 00 00 
  802b12:	ff d2                	callq  *%rdx
		close(fd_src);
  802b14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b17:	89 c7                	mov    %eax,%edi
  802b19:	48 b8 3c 20 80 00 00 	movabs $0x80203c,%rax
  802b20:	00 00 00 
  802b23:	ff d0                	callq  *%rax
		close(fd_dest);
  802b25:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b28:	89 c7                	mov    %eax,%edi
  802b2a:	48 b8 3c 20 80 00 00 	movabs $0x80203c,%rax
  802b31:	00 00 00 
  802b34:	ff d0                	callq  *%rax
		return read_size;
  802b36:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b39:	eb 27                	jmp    802b62 <copy+0x1d9>
	}
	close(fd_src);
  802b3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b3e:	89 c7                	mov    %eax,%edi
  802b40:	48 b8 3c 20 80 00 00 	movabs $0x80203c,%rax
  802b47:	00 00 00 
  802b4a:	ff d0                	callq  *%rax
	close(fd_dest);
  802b4c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b4f:	89 c7                	mov    %eax,%edi
  802b51:	48 b8 3c 20 80 00 00 	movabs $0x80203c,%rax
  802b58:	00 00 00 
  802b5b:	ff d0                	callq  *%rax
	return 0;
  802b5d:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802b62:	c9                   	leaveq 
  802b63:	c3                   	retq   

0000000000802b64 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802b64:	55                   	push   %rbp
  802b65:	48 89 e5             	mov    %rsp,%rbp
  802b68:	48 81 ec 00 03 00 00 	sub    $0x300,%rsp
  802b6f:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  802b76:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial rip and rsp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802b7d:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  802b84:	be 00 00 00 00       	mov    $0x0,%esi
  802b89:	48 89 c7             	mov    %rax,%rdi
  802b8c:	48 b8 36 27 80 00 00 	movabs $0x802736,%rax
  802b93:	00 00 00 
  802b96:	ff d0                	callq  *%rax
  802b98:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802b9b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802b9f:	79 08                	jns    802ba9 <spawn+0x45>
		return r;
  802ba1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802ba4:	e9 12 03 00 00       	jmpq   802ebb <spawn+0x357>
	fd = r;
  802ba9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802bac:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802baf:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  802bb6:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802bba:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  802bc1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802bc4:	ba 00 02 00 00       	mov    $0x200,%edx
  802bc9:	48 89 ce             	mov    %rcx,%rsi
  802bcc:	89 c7                	mov    %eax,%edi
  802bce:	48 b8 33 23 80 00 00 	movabs $0x802333,%rax
  802bd5:	00 00 00 
  802bd8:	ff d0                	callq  *%rax
  802bda:	3d 00 02 00 00       	cmp    $0x200,%eax
  802bdf:	75 0d                	jne    802bee <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  802be1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802be5:	8b 00                	mov    (%rax),%eax
  802be7:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802bec:	74 43                	je     802c31 <spawn+0xcd>
		close(fd);
  802bee:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802bf1:	89 c7                	mov    %eax,%edi
  802bf3:	48 b8 3c 20 80 00 00 	movabs $0x80203c,%rax
  802bfa:	00 00 00 
  802bfd:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802bff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c03:	8b 00                	mov    (%rax),%eax
  802c05:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802c0a:	89 c6                	mov    %eax,%esi
  802c0c:	48 bf b0 50 80 00 00 	movabs $0x8050b0,%rdi
  802c13:	00 00 00 
  802c16:	b8 00 00 00 00       	mov    $0x0,%eax
  802c1b:	48 b9 15 05 80 00 00 	movabs $0x800515,%rcx
  802c22:	00 00 00 
  802c25:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802c27:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802c2c:	e9 8a 02 00 00       	jmpq   802ebb <spawn+0x357>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802c31:	b8 07 00 00 00       	mov    $0x7,%eax
  802c36:	cd 30                	int    $0x30
  802c38:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802c3b:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802c3e:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802c41:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802c45:	79 08                	jns    802c4f <spawn+0xeb>
		return r;
  802c47:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802c4a:	e9 6c 02 00 00       	jmpq   802ebb <spawn+0x357>
	child = r;
  802c4f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802c52:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802c55:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802c58:	25 ff 03 00 00       	and    $0x3ff,%eax
  802c5d:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802c64:	00 00 00 
  802c67:	48 98                	cltq   
  802c69:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802c70:	48 01 c2             	add    %rax,%rdx
  802c73:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802c7a:	48 89 d6             	mov    %rdx,%rsi
  802c7d:	ba 18 00 00 00       	mov    $0x18,%edx
  802c82:	48 89 c7             	mov    %rax,%rdi
  802c85:	48 89 d1             	mov    %rdx,%rcx
  802c88:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  802c8b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c8f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802c93:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  802c9a:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802ca1:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  802ca8:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  802caf:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802cb2:	48 89 ce             	mov    %rcx,%rsi
  802cb5:	89 c7                	mov    %eax,%edi
  802cb7:	48 b8 1f 31 80 00 00 	movabs $0x80311f,%rax
  802cbe:	00 00 00 
  802cc1:	ff d0                	callq  *%rax
  802cc3:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802cc6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802cca:	79 08                	jns    802cd4 <spawn+0x170>
		return r;
  802ccc:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802ccf:	e9 e7 01 00 00       	jmpq   802ebb <spawn+0x357>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802cd4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cd8:	48 8b 40 20          	mov    0x20(%rax),%rax
  802cdc:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  802ce3:	48 01 d0             	add    %rdx,%rax
  802ce6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802cea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802cf1:	e9 a9 00 00 00       	jmpq   802d9f <spawn+0x23b>
		if (ph->p_type != ELF_PROG_LOAD)
  802cf6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cfa:	8b 00                	mov    (%rax),%eax
  802cfc:	83 f8 01             	cmp    $0x1,%eax
  802cff:	74 05                	je     802d06 <spawn+0x1a2>
			continue;
  802d01:	e9 90 00 00 00       	jmpq   802d96 <spawn+0x232>
		perm = PTE_P | PTE_U;
  802d06:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802d0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d11:	8b 40 04             	mov    0x4(%rax),%eax
  802d14:	83 e0 02             	and    $0x2,%eax
  802d17:	85 c0                	test   %eax,%eax
  802d19:	74 04                	je     802d1f <spawn+0x1bb>
			perm |= PTE_W;
  802d1b:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802d1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d23:	48 8b 40 08          	mov    0x8(%rax),%rax
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802d27:	41 89 c1             	mov    %eax,%r9d
  802d2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d2e:	4c 8b 40 20          	mov    0x20(%rax),%r8
  802d32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d36:	48 8b 50 28          	mov    0x28(%rax),%rdx
  802d3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d3e:	48 8b 70 10          	mov    0x10(%rax),%rsi
  802d42:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802d45:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802d48:	48 83 ec 08          	sub    $0x8,%rsp
  802d4c:	8b 7d ec             	mov    -0x14(%rbp),%edi
  802d4f:	57                   	push   %rdi
  802d50:	89 c7                	mov    %eax,%edi
  802d52:	48 b8 cb 33 80 00 00 	movabs $0x8033cb,%rax
  802d59:	00 00 00 
  802d5c:	ff d0                	callq  *%rax
  802d5e:	48 83 c4 10          	add    $0x10,%rsp
  802d62:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802d65:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802d69:	79 2b                	jns    802d96 <spawn+0x232>
			goto error;
  802d6b:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802d6c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802d6f:	89 c7                	mov    %eax,%edi
  802d71:	48 b8 1e 19 80 00 00 	movabs $0x80191e,%rax
  802d78:	00 00 00 
  802d7b:	ff d0                	callq  *%rax
	close(fd);
  802d7d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802d80:	89 c7                	mov    %eax,%edi
  802d82:	48 b8 3c 20 80 00 00 	movabs $0x80203c,%rax
  802d89:	00 00 00 
  802d8c:	ff d0                	callq  *%rax
	return r;
  802d8e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802d91:	e9 25 01 00 00       	jmpq   802ebb <spawn+0x357>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802d96:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802d9a:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  802d9f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802da3:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  802da7:	0f b7 c0             	movzwl %ax,%eax
  802daa:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802dad:	0f 8f 43 ff ff ff    	jg     802cf6 <spawn+0x192>
	close(fd);
  802db3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802db6:	89 c7                	mov    %eax,%edi
  802db8:	48 b8 3c 20 80 00 00 	movabs $0x80203c,%rax
  802dbf:	00 00 00 
  802dc2:	ff d0                	callq  *%rax
	fd = -1;
  802dc4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)
	if ((r = copy_shared_pages(child)) < 0)
  802dcb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802dce:	89 c7                	mov    %eax,%edi
  802dd0:	48 b8 b7 35 80 00 00 	movabs $0x8035b7,%rax
  802dd7:	00 00 00 
  802dda:	ff d0                	callq  *%rax
  802ddc:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802ddf:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802de3:	79 30                	jns    802e15 <spawn+0x2b1>
		panic("copy_shared_pages: %e", r);
  802de5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802de8:	89 c1                	mov    %eax,%ecx
  802dea:	48 ba ca 50 80 00 00 	movabs $0x8050ca,%rdx
  802df1:	00 00 00 
  802df4:	be 82 00 00 00       	mov    $0x82,%esi
  802df9:	48 bf e0 50 80 00 00 	movabs $0x8050e0,%rdi
  802e00:	00 00 00 
  802e03:	b8 00 00 00 00       	mov    $0x0,%eax
  802e08:	49 b8 dc 02 80 00 00 	movabs $0x8002dc,%r8
  802e0f:	00 00 00 
  802e12:	41 ff d0             	callq  *%r8
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802e15:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802e1c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802e1f:	48 89 d6             	mov    %rdx,%rsi
  802e22:	89 c7                	mov    %eax,%edi
  802e24:	48 b8 27 1b 80 00 00 	movabs $0x801b27,%rax
  802e2b:	00 00 00 
  802e2e:	ff d0                	callq  *%rax
  802e30:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802e33:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802e37:	79 30                	jns    802e69 <spawn+0x305>
		panic("sys_env_set_trapframe: %e", r);
  802e39:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e3c:	89 c1                	mov    %eax,%ecx
  802e3e:	48 ba ec 50 80 00 00 	movabs $0x8050ec,%rdx
  802e45:	00 00 00 
  802e48:	be 85 00 00 00       	mov    $0x85,%esi
  802e4d:	48 bf e0 50 80 00 00 	movabs $0x8050e0,%rdi
  802e54:	00 00 00 
  802e57:	b8 00 00 00 00       	mov    $0x0,%eax
  802e5c:	49 b8 dc 02 80 00 00 	movabs $0x8002dc,%r8
  802e63:	00 00 00 
  802e66:	41 ff d0             	callq  *%r8
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802e69:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802e6c:	be 02 00 00 00       	mov    $0x2,%esi
  802e71:	89 c7                	mov    %eax,%edi
  802e73:	48 b8 da 1a 80 00 00 	movabs $0x801ada,%rax
  802e7a:	00 00 00 
  802e7d:	ff d0                	callq  *%rax
  802e7f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802e82:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802e86:	79 30                	jns    802eb8 <spawn+0x354>
		panic("sys_env_set_status: %e", r);
  802e88:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e8b:	89 c1                	mov    %eax,%ecx
  802e8d:	48 ba 06 51 80 00 00 	movabs $0x805106,%rdx
  802e94:	00 00 00 
  802e97:	be 88 00 00 00       	mov    $0x88,%esi
  802e9c:	48 bf e0 50 80 00 00 	movabs $0x8050e0,%rdi
  802ea3:	00 00 00 
  802ea6:	b8 00 00 00 00       	mov    $0x0,%eax
  802eab:	49 b8 dc 02 80 00 00 	movabs $0x8002dc,%r8
  802eb2:	00 00 00 
  802eb5:	41 ff d0             	callq  *%r8
	return child;
  802eb8:	8b 45 d4             	mov    -0x2c(%rbp),%eax
}
  802ebb:	c9                   	leaveq 
  802ebc:	c3                   	retq   

0000000000802ebd <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802ebd:	55                   	push   %rbp
  802ebe:	48 89 e5             	mov    %rsp,%rbp
  802ec1:	41 55                	push   %r13
  802ec3:	41 54                	push   %r12
  802ec5:	53                   	push   %rbx
  802ec6:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802ecd:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  802ed4:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  802edb:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  802ee2:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  802ee9:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  802ef0:	84 c0                	test   %al,%al
  802ef2:	74 26                	je     802f1a <spawnl+0x5d>
  802ef4:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  802efb:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  802f02:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  802f06:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  802f0a:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  802f0e:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  802f12:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  802f16:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  802f1a:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802f21:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  802f28:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  802f2b:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  802f32:	00 00 00 
  802f35:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  802f3c:	00 00 00 
  802f3f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802f43:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  802f4a:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  802f51:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  802f58:	eb 07                	jmp    802f61 <spawnl+0xa4>
		argc++;
  802f5a:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	while(va_arg(vl, void *) != NULL)
  802f61:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802f67:	83 f8 30             	cmp    $0x30,%eax
  802f6a:	73 23                	jae    802f8f <spawnl+0xd2>
  802f6c:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  802f73:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  802f79:	89 d2                	mov    %edx,%edx
  802f7b:	48 01 d0             	add    %rdx,%rax
  802f7e:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  802f84:	83 c2 08             	add    $0x8,%edx
  802f87:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  802f8d:	eb 12                	jmp    802fa1 <spawnl+0xe4>
  802f8f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802f96:	48 8d 50 08          	lea    0x8(%rax),%rdx
  802f9a:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  802fa1:	48 8b 00             	mov    (%rax),%rax
  802fa4:	48 85 c0             	test   %rax,%rax
  802fa7:	75 b1                	jne    802f5a <spawnl+0x9d>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802fa9:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802faf:	83 c0 02             	add    $0x2,%eax
  802fb2:	48 89 e2             	mov    %rsp,%rdx
  802fb5:	48 89 d3             	mov    %rdx,%rbx
  802fb8:	48 63 d0             	movslq %eax,%rdx
  802fbb:	48 83 ea 01          	sub    $0x1,%rdx
  802fbf:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  802fc6:	48 63 d0             	movslq %eax,%rdx
  802fc9:	49 89 d4             	mov    %rdx,%r12
  802fcc:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  802fd2:	48 63 d0             	movslq %eax,%rdx
  802fd5:	49 89 d2             	mov    %rdx,%r10
  802fd8:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  802fde:	48 98                	cltq   
  802fe0:	48 c1 e0 03          	shl    $0x3,%rax
  802fe4:	48 8d 50 07          	lea    0x7(%rax),%rdx
  802fe8:	b8 10 00 00 00       	mov    $0x10,%eax
  802fed:	48 83 e8 01          	sub    $0x1,%rax
  802ff1:	48 01 d0             	add    %rdx,%rax
  802ff4:	be 10 00 00 00       	mov    $0x10,%esi
  802ff9:	ba 00 00 00 00       	mov    $0x0,%edx
  802ffe:	48 f7 f6             	div    %rsi
  803001:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803005:	48 29 c4             	sub    %rax,%rsp
  803008:	48 89 e0             	mov    %rsp,%rax
  80300b:	48 83 c0 07          	add    $0x7,%rax
  80300f:	48 c1 e8 03          	shr    $0x3,%rax
  803013:	48 c1 e0 03          	shl    $0x3,%rax
  803017:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  80301e:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803025:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  80302c:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  80302f:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803035:	8d 50 01             	lea    0x1(%rax),%edx
  803038:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80303f:	48 63 d2             	movslq %edx,%rdx
  803042:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803049:	00 

	va_start(vl, arg0);
  80304a:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803051:	00 00 00 
  803054:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  80305b:	00 00 00 
  80305e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803062:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803069:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803070:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803077:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  80307e:	00 00 00 
  803081:	eb 60                	jmp    8030e3 <spawnl+0x226>
		argv[i+1] = va_arg(vl, const char *);
  803083:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  803089:	8d 48 01             	lea    0x1(%rax),%ecx
  80308c:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803092:	83 f8 30             	cmp    $0x30,%eax
  803095:	73 23                	jae    8030ba <spawnl+0x1fd>
  803097:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  80309e:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8030a4:	89 d2                	mov    %edx,%edx
  8030a6:	48 01 d0             	add    %rdx,%rax
  8030a9:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8030af:	83 c2 08             	add    $0x8,%edx
  8030b2:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8030b8:	eb 12                	jmp    8030cc <spawnl+0x20f>
  8030ba:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8030c1:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8030c5:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8030cc:	48 8b 10             	mov    (%rax),%rdx
  8030cf:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8030d6:	89 c9                	mov    %ecx,%ecx
  8030d8:	48 89 14 c8          	mov    %rdx,(%rax,%rcx,8)
	for(i=0;i<argc;i++)
  8030dc:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  8030e3:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8030e9:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  8030ef:	77 92                	ja     803083 <spawnl+0x1c6>
	va_end(vl);
	return spawn(prog, argv);
  8030f1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8030f8:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  8030ff:	48 89 d6             	mov    %rdx,%rsi
  803102:	48 89 c7             	mov    %rax,%rdi
  803105:	48 b8 64 2b 80 00 00 	movabs $0x802b64,%rax
  80310c:	00 00 00 
  80310f:	ff d0                	callq  *%rax
  803111:	48 89 dc             	mov    %rbx,%rsp
}
  803114:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803118:	5b                   	pop    %rbx
  803119:	41 5c                	pop    %r12
  80311b:	41 5d                	pop    %r13
  80311d:	5d                   	pop    %rbp
  80311e:	c3                   	retq   

000000000080311f <init_stack>:
// On success, returns 0 and sets *init_rsp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_rsp)
{
  80311f:	55                   	push   %rbp
  803120:	48 89 e5             	mov    %rsp,%rbp
  803123:	48 83 ec 50          	sub    $0x50,%rsp
  803127:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80312a:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80312e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803132:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803139:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  80313a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803141:	eb 33                	jmp    803176 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803143:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803146:	48 98                	cltq   
  803148:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80314f:	00 
  803150:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803154:	48 01 d0             	add    %rdx,%rax
  803157:	48 8b 00             	mov    (%rax),%rax
  80315a:	48 89 c7             	mov    %rax,%rdi
  80315d:	48 b8 43 10 80 00 00 	movabs $0x801043,%rax
  803164:	00 00 00 
  803167:	ff d0                	callq  *%rax
  803169:	83 c0 01             	add    $0x1,%eax
  80316c:	48 98                	cltq   
  80316e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	for (argc = 0; argv[argc] != 0; argc++)
  803172:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803176:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803179:	48 98                	cltq   
  80317b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803182:	00 
  803183:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803187:	48 01 d0             	add    %rdx,%rax
  80318a:	48 8b 00             	mov    (%rax),%rax
  80318d:	48 85 c0             	test   %rax,%rax
  803190:	75 b1                	jne    803143 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803192:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803196:	48 f7 d8             	neg    %rax
  803199:	48 05 00 10 40 00    	add    $0x401000,%rax
  80319f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8031a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031a7:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8031ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031af:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  8031b3:	48 89 c2             	mov    %rax,%rdx
  8031b6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031b9:	83 c0 01             	add    $0x1,%eax
  8031bc:	c1 e0 03             	shl    $0x3,%eax
  8031bf:	48 98                	cltq   
  8031c1:	48 f7 d8             	neg    %rax
  8031c4:	48 01 d0             	add    %rdx,%rax
  8031c7:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8031cb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031cf:	48 83 e8 10          	sub    $0x10,%rax
  8031d3:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8031d9:	77 0a                	ja     8031e5 <init_stack+0xc6>
		return -E_NO_MEM;
  8031db:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8031e0:	e9 e4 01 00 00       	jmpq   8033c9 <init_stack+0x2aa>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8031e5:	ba 07 00 00 00       	mov    $0x7,%edx
  8031ea:	be 00 00 40 00       	mov    $0x400000,%esi
  8031ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8031f4:	48 b8 dc 19 80 00 00 	movabs $0x8019dc,%rax
  8031fb:	00 00 00 
  8031fe:	ff d0                	callq  *%rax
  803200:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803203:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803207:	79 08                	jns    803211 <init_stack+0xf2>
		return r;
  803209:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80320c:	e9 b8 01 00 00       	jmpq   8033c9 <init_stack+0x2aa>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_rsp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803211:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803218:	e9 8a 00 00 00       	jmpq   8032a7 <init_stack+0x188>
		argv_store[i] = UTEMP2USTACK(string_store);
  80321d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803220:	48 98                	cltq   
  803222:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803229:	00 
  80322a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80322e:	48 01 d0             	add    %rdx,%rax
  803231:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803236:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80323a:	48 01 ca             	add    %rcx,%rdx
  80323d:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  803244:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  803247:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80324a:	48 98                	cltq   
  80324c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803253:	00 
  803254:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803258:	48 01 d0             	add    %rdx,%rax
  80325b:	48 8b 10             	mov    (%rax),%rdx
  80325e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803262:	48 89 d6             	mov    %rdx,%rsi
  803265:	48 89 c7             	mov    %rax,%rdi
  803268:	48 b8 af 10 80 00 00 	movabs $0x8010af,%rax
  80326f:	00 00 00 
  803272:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803274:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803277:	48 98                	cltq   
  803279:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803280:	00 
  803281:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803285:	48 01 d0             	add    %rdx,%rax
  803288:	48 8b 00             	mov    (%rax),%rax
  80328b:	48 89 c7             	mov    %rax,%rdi
  80328e:	48 b8 43 10 80 00 00 	movabs $0x801043,%rax
  803295:	00 00 00 
  803298:	ff d0                	callq  *%rax
  80329a:	83 c0 01             	add    $0x1,%eax
  80329d:	48 98                	cltq   
  80329f:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	for (i = 0; i < argc; i++) {
  8032a3:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8032a7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8032aa:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8032ad:	0f 8c 6a ff ff ff    	jl     80321d <init_stack+0xfe>
	}
	argv_store[argc] = 0;
  8032b3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032b6:	48 98                	cltq   
  8032b8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8032bf:	00 
  8032c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032c4:	48 01 d0             	add    %rdx,%rax
  8032c7:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8032ce:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  8032d5:	00 
  8032d6:	74 35                	je     80330d <init_stack+0x1ee>
  8032d8:	48 b9 20 51 80 00 00 	movabs $0x805120,%rcx
  8032df:	00 00 00 
  8032e2:	48 ba 46 51 80 00 00 	movabs $0x805146,%rdx
  8032e9:	00 00 00 
  8032ec:	be f1 00 00 00       	mov    $0xf1,%esi
  8032f1:	48 bf e0 50 80 00 00 	movabs $0x8050e0,%rdi
  8032f8:	00 00 00 
  8032fb:	b8 00 00 00 00       	mov    $0x0,%eax
  803300:	49 b8 dc 02 80 00 00 	movabs $0x8002dc,%r8
  803307:	00 00 00 
  80330a:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80330d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803311:	48 83 e8 08          	sub    $0x8,%rax
  803315:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80331a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80331e:	48 01 ca             	add    %rcx,%rdx
  803321:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  803328:	48 89 10             	mov    %rdx,(%rax)
	argv_store[-2] = argc;
  80332b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80332f:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803333:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803336:	48 98                	cltq   
  803338:	48 89 02             	mov    %rax,(%rdx)

	*init_rsp = UTEMP2USTACK(&argv_store[-2]);
  80333b:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803340:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803344:	48 01 d0             	add    %rdx,%rax
  803347:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80334d:	48 89 c2             	mov    %rax,%rdx
  803350:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803354:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803357:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80335a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803360:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803365:	89 c2                	mov    %eax,%edx
  803367:	be 00 00 40 00       	mov    $0x400000,%esi
  80336c:	bf 00 00 00 00       	mov    $0x0,%edi
  803371:	48 b8 2e 1a 80 00 00 	movabs $0x801a2e,%rax
  803378:	00 00 00 
  80337b:	ff d0                	callq  *%rax
  80337d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803380:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803384:	79 02                	jns    803388 <init_stack+0x269>
		goto error;
  803386:	eb 28                	jmp    8033b0 <init_stack+0x291>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803388:	be 00 00 40 00       	mov    $0x400000,%esi
  80338d:	bf 00 00 00 00       	mov    $0x0,%edi
  803392:	48 b8 8e 1a 80 00 00 	movabs $0x801a8e,%rax
  803399:	00 00 00 
  80339c:	ff d0                	callq  *%rax
  80339e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033a5:	79 02                	jns    8033a9 <init_stack+0x28a>
		goto error;
  8033a7:	eb 07                	jmp    8033b0 <init_stack+0x291>

	return 0;
  8033a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ae:	eb 19                	jmp    8033c9 <init_stack+0x2aa>

error:
	sys_page_unmap(0, UTEMP);
  8033b0:	be 00 00 40 00       	mov    $0x400000,%esi
  8033b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8033ba:	48 b8 8e 1a 80 00 00 	movabs $0x801a8e,%rax
  8033c1:	00 00 00 
  8033c4:	ff d0                	callq  *%rax
	return r;
  8033c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8033c9:	c9                   	leaveq 
  8033ca:	c3                   	retq   

00000000008033cb <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  8033cb:	55                   	push   %rbp
  8033cc:	48 89 e5             	mov    %rsp,%rbp
  8033cf:	48 83 ec 50          	sub    $0x50,%rsp
  8033d3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8033d6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8033da:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8033de:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  8033e1:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8033e5:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8033e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033ed:	25 ff 0f 00 00       	and    $0xfff,%eax
  8033f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033f9:	74 21                	je     80341c <map_segment+0x51>
		va -= i;
  8033fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033fe:	48 98                	cltq   
  803400:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803404:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803407:	48 98                	cltq   
  803409:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  80340d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803410:	48 98                	cltq   
  803412:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803416:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803419:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80341c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803423:	e9 79 01 00 00       	jmpq   8035a1 <map_segment+0x1d6>
		if (i >= filesz) {
  803428:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80342b:	48 98                	cltq   
  80342d:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803431:	72 3c                	jb     80346f <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803433:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803436:	48 63 d0             	movslq %eax,%rdx
  803439:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80343d:	48 01 d0             	add    %rdx,%rax
  803440:	48 89 c1             	mov    %rax,%rcx
  803443:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803446:	8b 55 10             	mov    0x10(%rbp),%edx
  803449:	48 89 ce             	mov    %rcx,%rsi
  80344c:	89 c7                	mov    %eax,%edi
  80344e:	48 b8 dc 19 80 00 00 	movabs $0x8019dc,%rax
  803455:	00 00 00 
  803458:	ff d0                	callq  *%rax
  80345a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80345d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803461:	0f 89 33 01 00 00    	jns    80359a <map_segment+0x1cf>
				return r;
  803467:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80346a:	e9 46 01 00 00       	jmpq   8035b5 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80346f:	ba 07 00 00 00       	mov    $0x7,%edx
  803474:	be 00 00 40 00       	mov    $0x400000,%esi
  803479:	bf 00 00 00 00       	mov    $0x0,%edi
  80347e:	48 b8 dc 19 80 00 00 	movabs $0x8019dc,%rax
  803485:	00 00 00 
  803488:	ff d0                	callq  *%rax
  80348a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80348d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803491:	79 08                	jns    80349b <map_segment+0xd0>
				return r;
  803493:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803496:	e9 1a 01 00 00       	jmpq   8035b5 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  80349b:	8b 55 bc             	mov    -0x44(%rbp),%edx
  80349e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a1:	01 c2                	add    %eax,%edx
  8034a3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8034a6:	89 d6                	mov    %edx,%esi
  8034a8:	89 c7                	mov    %eax,%edi
  8034aa:	48 b8 7c 24 80 00 00 	movabs $0x80247c,%rax
  8034b1:	00 00 00 
  8034b4:	ff d0                	callq  *%rax
  8034b6:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8034b9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8034bd:	79 08                	jns    8034c7 <map_segment+0xfc>
				return r;
  8034bf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034c2:	e9 ee 00 00 00       	jmpq   8035b5 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8034c7:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  8034ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034d1:	48 98                	cltq   
  8034d3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8034d7:	48 29 c2             	sub    %rax,%rdx
  8034da:	48 89 d0             	mov    %rdx,%rax
  8034dd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8034e1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034e4:	48 63 d0             	movslq %eax,%rdx
  8034e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034eb:	48 39 c2             	cmp    %rax,%rdx
  8034ee:	48 0f 47 d0          	cmova  %rax,%rdx
  8034f2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8034f5:	be 00 00 40 00       	mov    $0x400000,%esi
  8034fa:	89 c7                	mov    %eax,%edi
  8034fc:	48 b8 33 23 80 00 00 	movabs $0x802333,%rax
  803503:	00 00 00 
  803506:	ff d0                	callq  *%rax
  803508:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80350b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80350f:	79 08                	jns    803519 <map_segment+0x14e>
				return r;
  803511:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803514:	e9 9c 00 00 00       	jmpq   8035b5 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803519:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80351c:	48 63 d0             	movslq %eax,%rdx
  80351f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803523:	48 01 d0             	add    %rdx,%rax
  803526:	48 89 c2             	mov    %rax,%rdx
  803529:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80352c:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803530:	48 89 d1             	mov    %rdx,%rcx
  803533:	89 c2                	mov    %eax,%edx
  803535:	be 00 00 40 00       	mov    $0x400000,%esi
  80353a:	bf 00 00 00 00       	mov    $0x0,%edi
  80353f:	48 b8 2e 1a 80 00 00 	movabs $0x801a2e,%rax
  803546:	00 00 00 
  803549:	ff d0                	callq  *%rax
  80354b:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80354e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803552:	79 30                	jns    803584 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803554:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803557:	89 c1                	mov    %eax,%ecx
  803559:	48 ba 5b 51 80 00 00 	movabs $0x80515b,%rdx
  803560:	00 00 00 
  803563:	be 24 01 00 00       	mov    $0x124,%esi
  803568:	48 bf e0 50 80 00 00 	movabs $0x8050e0,%rdi
  80356f:	00 00 00 
  803572:	b8 00 00 00 00       	mov    $0x0,%eax
  803577:	49 b8 dc 02 80 00 00 	movabs $0x8002dc,%r8
  80357e:	00 00 00 
  803581:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803584:	be 00 00 40 00       	mov    $0x400000,%esi
  803589:	bf 00 00 00 00       	mov    $0x0,%edi
  80358e:	48 b8 8e 1a 80 00 00 	movabs $0x801a8e,%rax
  803595:	00 00 00 
  803598:	ff d0                	callq  *%rax
	for (i = 0; i < memsz; i += PGSIZE) {
  80359a:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  8035a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035a4:	48 98                	cltq   
  8035a6:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8035aa:	0f 82 78 fe ff ff    	jb     803428 <map_segment+0x5d>
		}
	}
	return 0;
  8035b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035b5:	c9                   	leaveq 
  8035b6:	c3                   	retq   

00000000008035b7 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  8035b7:	55                   	push   %rbp
  8035b8:	48 89 e5             	mov    %rsp,%rbp
  8035bb:	48 83 ec 08          	sub    $0x8,%rsp
  8035bf:	89 7d fc             	mov    %edi,-0x4(%rbp)
	// LAB 5: Your code here.
	return 0;
  8035c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035c7:	c9                   	leaveq 
  8035c8:	c3                   	retq   

00000000008035c9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8035c9:	55                   	push   %rbp
  8035ca:	48 89 e5             	mov    %rsp,%rbp
  8035cd:	48 83 ec 20          	sub    $0x20,%rsp
  8035d1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8035d4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8035d8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035db:	48 89 d6             	mov    %rdx,%rsi
  8035de:	89 c7                	mov    %eax,%edi
  8035e0:	48 b8 2a 1e 80 00 00 	movabs $0x801e2a,%rax
  8035e7:	00 00 00 
  8035ea:	ff d0                	callq  *%rax
  8035ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035f3:	79 05                	jns    8035fa <fd2sockid+0x31>
		return r;
  8035f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f8:	eb 24                	jmp    80361e <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8035fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035fe:	8b 10                	mov    (%rax),%edx
  803600:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803607:	00 00 00 
  80360a:	8b 00                	mov    (%rax),%eax
  80360c:	39 c2                	cmp    %eax,%edx
  80360e:	74 07                	je     803617 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803610:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803615:	eb 07                	jmp    80361e <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803617:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80361b:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80361e:	c9                   	leaveq 
  80361f:	c3                   	retq   

0000000000803620 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803620:	55                   	push   %rbp
  803621:	48 89 e5             	mov    %rsp,%rbp
  803624:	48 83 ec 20          	sub    $0x20,%rsp
  803628:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80362b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80362f:	48 89 c7             	mov    %rax,%rdi
  803632:	48 b8 92 1d 80 00 00 	movabs $0x801d92,%rax
  803639:	00 00 00 
  80363c:	ff d0                	callq  *%rax
  80363e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803641:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803645:	78 26                	js     80366d <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803647:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80364b:	ba 07 04 00 00       	mov    $0x407,%edx
  803650:	48 89 c6             	mov    %rax,%rsi
  803653:	bf 00 00 00 00       	mov    $0x0,%edi
  803658:	48 b8 dc 19 80 00 00 	movabs $0x8019dc,%rax
  80365f:	00 00 00 
  803662:	ff d0                	callq  *%rax
  803664:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803667:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80366b:	79 16                	jns    803683 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  80366d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803670:	89 c7                	mov    %eax,%edi
  803672:	48 b8 2f 3b 80 00 00 	movabs $0x803b2f,%rax
  803679:	00 00 00 
  80367c:	ff d0                	callq  *%rax
		return r;
  80367e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803681:	eb 3a                	jmp    8036bd <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803683:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803687:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  80368e:	00 00 00 
  803691:	8b 12                	mov    (%rdx),%edx
  803693:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803695:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803699:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8036a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036a4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8036a7:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8036aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ae:	48 89 c7             	mov    %rax,%rdi
  8036b1:	48 b8 44 1d 80 00 00 	movabs $0x801d44,%rax
  8036b8:	00 00 00 
  8036bb:	ff d0                	callq  *%rax
}
  8036bd:	c9                   	leaveq 
  8036be:	c3                   	retq   

00000000008036bf <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8036bf:	55                   	push   %rbp
  8036c0:	48 89 e5             	mov    %rsp,%rbp
  8036c3:	48 83 ec 30          	sub    $0x30,%rsp
  8036c7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036ce:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036d2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036d5:	89 c7                	mov    %eax,%edi
  8036d7:	48 b8 c9 35 80 00 00 	movabs $0x8035c9,%rax
  8036de:	00 00 00 
  8036e1:	ff d0                	callq  *%rax
  8036e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036ea:	79 05                	jns    8036f1 <accept+0x32>
		return r;
  8036ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ef:	eb 3b                	jmp    80372c <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8036f1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8036f5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8036f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036fc:	48 89 ce             	mov    %rcx,%rsi
  8036ff:	89 c7                	mov    %eax,%edi
  803701:	48 b8 0c 3a 80 00 00 	movabs $0x803a0c,%rax
  803708:	00 00 00 
  80370b:	ff d0                	callq  *%rax
  80370d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803710:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803714:	79 05                	jns    80371b <accept+0x5c>
		return r;
  803716:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803719:	eb 11                	jmp    80372c <accept+0x6d>
	return alloc_sockfd(r);
  80371b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80371e:	89 c7                	mov    %eax,%edi
  803720:	48 b8 20 36 80 00 00 	movabs $0x803620,%rax
  803727:	00 00 00 
  80372a:	ff d0                	callq  *%rax
}
  80372c:	c9                   	leaveq 
  80372d:	c3                   	retq   

000000000080372e <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80372e:	55                   	push   %rbp
  80372f:	48 89 e5             	mov    %rsp,%rbp
  803732:	48 83 ec 20          	sub    $0x20,%rsp
  803736:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803739:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80373d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803740:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803743:	89 c7                	mov    %eax,%edi
  803745:	48 b8 c9 35 80 00 00 	movabs $0x8035c9,%rax
  80374c:	00 00 00 
  80374f:	ff d0                	callq  *%rax
  803751:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803754:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803758:	79 05                	jns    80375f <bind+0x31>
		return r;
  80375a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80375d:	eb 1b                	jmp    80377a <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80375f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803762:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803766:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803769:	48 89 ce             	mov    %rcx,%rsi
  80376c:	89 c7                	mov    %eax,%edi
  80376e:	48 b8 8b 3a 80 00 00 	movabs $0x803a8b,%rax
  803775:	00 00 00 
  803778:	ff d0                	callq  *%rax
}
  80377a:	c9                   	leaveq 
  80377b:	c3                   	retq   

000000000080377c <shutdown>:

int
shutdown(int s, int how)
{
  80377c:	55                   	push   %rbp
  80377d:	48 89 e5             	mov    %rsp,%rbp
  803780:	48 83 ec 20          	sub    $0x20,%rsp
  803784:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803787:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80378a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80378d:	89 c7                	mov    %eax,%edi
  80378f:	48 b8 c9 35 80 00 00 	movabs $0x8035c9,%rax
  803796:	00 00 00 
  803799:	ff d0                	callq  *%rax
  80379b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80379e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037a2:	79 05                	jns    8037a9 <shutdown+0x2d>
		return r;
  8037a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a7:	eb 16                	jmp    8037bf <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8037a9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8037ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037af:	89 d6                	mov    %edx,%esi
  8037b1:	89 c7                	mov    %eax,%edi
  8037b3:	48 b8 ef 3a 80 00 00 	movabs $0x803aef,%rax
  8037ba:	00 00 00 
  8037bd:	ff d0                	callq  *%rax
}
  8037bf:	c9                   	leaveq 
  8037c0:	c3                   	retq   

00000000008037c1 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8037c1:	55                   	push   %rbp
  8037c2:	48 89 e5             	mov    %rsp,%rbp
  8037c5:	48 83 ec 10          	sub    $0x10,%rsp
  8037c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8037cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037d1:	48 89 c7             	mov    %rax,%rdi
  8037d4:	48 b8 8e 48 80 00 00 	movabs $0x80488e,%rax
  8037db:	00 00 00 
  8037de:	ff d0                	callq  *%rax
  8037e0:	83 f8 01             	cmp    $0x1,%eax
  8037e3:	75 17                	jne    8037fc <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8037e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037e9:	8b 40 0c             	mov    0xc(%rax),%eax
  8037ec:	89 c7                	mov    %eax,%edi
  8037ee:	48 b8 2f 3b 80 00 00 	movabs $0x803b2f,%rax
  8037f5:	00 00 00 
  8037f8:	ff d0                	callq  *%rax
  8037fa:	eb 05                	jmp    803801 <devsock_close+0x40>
	else
		return 0;
  8037fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803801:	c9                   	leaveq 
  803802:	c3                   	retq   

0000000000803803 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803803:	55                   	push   %rbp
  803804:	48 89 e5             	mov    %rsp,%rbp
  803807:	48 83 ec 20          	sub    $0x20,%rsp
  80380b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80380e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803812:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803815:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803818:	89 c7                	mov    %eax,%edi
  80381a:	48 b8 c9 35 80 00 00 	movabs $0x8035c9,%rax
  803821:	00 00 00 
  803824:	ff d0                	callq  *%rax
  803826:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803829:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80382d:	79 05                	jns    803834 <connect+0x31>
		return r;
  80382f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803832:	eb 1b                	jmp    80384f <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803834:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803837:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80383b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80383e:	48 89 ce             	mov    %rcx,%rsi
  803841:	89 c7                	mov    %eax,%edi
  803843:	48 b8 5c 3b 80 00 00 	movabs $0x803b5c,%rax
  80384a:	00 00 00 
  80384d:	ff d0                	callq  *%rax
}
  80384f:	c9                   	leaveq 
  803850:	c3                   	retq   

0000000000803851 <listen>:

int
listen(int s, int backlog)
{
  803851:	55                   	push   %rbp
  803852:	48 89 e5             	mov    %rsp,%rbp
  803855:	48 83 ec 20          	sub    $0x20,%rsp
  803859:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80385c:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80385f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803862:	89 c7                	mov    %eax,%edi
  803864:	48 b8 c9 35 80 00 00 	movabs $0x8035c9,%rax
  80386b:	00 00 00 
  80386e:	ff d0                	callq  *%rax
  803870:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803873:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803877:	79 05                	jns    80387e <listen+0x2d>
		return r;
  803879:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80387c:	eb 16                	jmp    803894 <listen+0x43>
	return nsipc_listen(r, backlog);
  80387e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803881:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803884:	89 d6                	mov    %edx,%esi
  803886:	89 c7                	mov    %eax,%edi
  803888:	48 b8 c0 3b 80 00 00 	movabs $0x803bc0,%rax
  80388f:	00 00 00 
  803892:	ff d0                	callq  *%rax
}
  803894:	c9                   	leaveq 
  803895:	c3                   	retq   

0000000000803896 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803896:	55                   	push   %rbp
  803897:	48 89 e5             	mov    %rsp,%rbp
  80389a:	48 83 ec 20          	sub    $0x20,%rsp
  80389e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8038a2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038a6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8038aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038ae:	89 c2                	mov    %eax,%edx
  8038b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038b4:	8b 40 0c             	mov    0xc(%rax),%eax
  8038b7:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8038bb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8038c0:	89 c7                	mov    %eax,%edi
  8038c2:	48 b8 00 3c 80 00 00 	movabs $0x803c00,%rax
  8038c9:	00 00 00 
  8038cc:	ff d0                	callq  *%rax
}
  8038ce:	c9                   	leaveq 
  8038cf:	c3                   	retq   

00000000008038d0 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8038d0:	55                   	push   %rbp
  8038d1:	48 89 e5             	mov    %rsp,%rbp
  8038d4:	48 83 ec 20          	sub    $0x20,%rsp
  8038d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8038dc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038e0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8038e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038e8:	89 c2                	mov    %eax,%edx
  8038ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038ee:	8b 40 0c             	mov    0xc(%rax),%eax
  8038f1:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8038f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8038fa:	89 c7                	mov    %eax,%edi
  8038fc:	48 b8 cc 3c 80 00 00 	movabs $0x803ccc,%rax
  803903:	00 00 00 
  803906:	ff d0                	callq  *%rax
}
  803908:	c9                   	leaveq 
  803909:	c3                   	retq   

000000000080390a <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80390a:	55                   	push   %rbp
  80390b:	48 89 e5             	mov    %rsp,%rbp
  80390e:	48 83 ec 10          	sub    $0x10,%rsp
  803912:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803916:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80391a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80391e:	48 be 7d 51 80 00 00 	movabs $0x80517d,%rsi
  803925:	00 00 00 
  803928:	48 89 c7             	mov    %rax,%rdi
  80392b:	48 b8 af 10 80 00 00 	movabs $0x8010af,%rax
  803932:	00 00 00 
  803935:	ff d0                	callq  *%rax
	return 0;
  803937:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80393c:	c9                   	leaveq 
  80393d:	c3                   	retq   

000000000080393e <socket>:

int
socket(int domain, int type, int protocol)
{
  80393e:	55                   	push   %rbp
  80393f:	48 89 e5             	mov    %rsp,%rbp
  803942:	48 83 ec 20          	sub    $0x20,%rsp
  803946:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803949:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80394c:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80394f:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803952:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803955:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803958:	89 ce                	mov    %ecx,%esi
  80395a:	89 c7                	mov    %eax,%edi
  80395c:	48 b8 84 3d 80 00 00 	movabs $0x803d84,%rax
  803963:	00 00 00 
  803966:	ff d0                	callq  *%rax
  803968:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80396b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80396f:	79 05                	jns    803976 <socket+0x38>
		return r;
  803971:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803974:	eb 11                	jmp    803987 <socket+0x49>
	return alloc_sockfd(r);
  803976:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803979:	89 c7                	mov    %eax,%edi
  80397b:	48 b8 20 36 80 00 00 	movabs $0x803620,%rax
  803982:	00 00 00 
  803985:	ff d0                	callq  *%rax
}
  803987:	c9                   	leaveq 
  803988:	c3                   	retq   

0000000000803989 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803989:	55                   	push   %rbp
  80398a:	48 89 e5             	mov    %rsp,%rbp
  80398d:	48 83 ec 10          	sub    $0x10,%rsp
  803991:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803994:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  80399b:	00 00 00 
  80399e:	8b 00                	mov    (%rax),%eax
  8039a0:	85 c0                	test   %eax,%eax
  8039a2:	75 1f                	jne    8039c3 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8039a4:	bf 02 00 00 00       	mov    $0x2,%edi
  8039a9:	48 b8 1c 48 80 00 00 	movabs $0x80481c,%rax
  8039b0:	00 00 00 
  8039b3:	ff d0                	callq  *%rax
  8039b5:	89 c2                	mov    %eax,%edx
  8039b7:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8039be:	00 00 00 
  8039c1:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8039c3:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8039ca:	00 00 00 
  8039cd:	8b 00                	mov    (%rax),%eax
  8039cf:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8039d2:	b9 07 00 00 00       	mov    $0x7,%ecx
  8039d7:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  8039de:	00 00 00 
  8039e1:	89 c7                	mov    %eax,%edi
  8039e3:	48 b8 8f 46 80 00 00 	movabs $0x80468f,%rax
  8039ea:	00 00 00 
  8039ed:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8039ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8039f4:	be 00 00 00 00       	mov    $0x0,%esi
  8039f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8039fe:	48 b8 51 46 80 00 00 	movabs $0x804651,%rax
  803a05:	00 00 00 
  803a08:	ff d0                	callq  *%rax
}
  803a0a:	c9                   	leaveq 
  803a0b:	c3                   	retq   

0000000000803a0c <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803a0c:	55                   	push   %rbp
  803a0d:	48 89 e5             	mov    %rsp,%rbp
  803a10:	48 83 ec 30          	sub    $0x30,%rsp
  803a14:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a17:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a1b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803a1f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a26:	00 00 00 
  803a29:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a2c:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803a2e:	bf 01 00 00 00       	mov    $0x1,%edi
  803a33:	48 b8 89 39 80 00 00 	movabs $0x803989,%rax
  803a3a:	00 00 00 
  803a3d:	ff d0                	callq  *%rax
  803a3f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a46:	78 3e                	js     803a86 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803a48:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a4f:	00 00 00 
  803a52:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803a56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a5a:	8b 40 10             	mov    0x10(%rax),%eax
  803a5d:	89 c2                	mov    %eax,%edx
  803a5f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803a63:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a67:	48 89 ce             	mov    %rcx,%rsi
  803a6a:	48 89 c7             	mov    %rax,%rdi
  803a6d:	48 b8 d3 13 80 00 00 	movabs $0x8013d3,%rax
  803a74:	00 00 00 
  803a77:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803a79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a7d:	8b 50 10             	mov    0x10(%rax),%edx
  803a80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a84:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803a86:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a89:	c9                   	leaveq 
  803a8a:	c3                   	retq   

0000000000803a8b <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803a8b:	55                   	push   %rbp
  803a8c:	48 89 e5             	mov    %rsp,%rbp
  803a8f:	48 83 ec 10          	sub    $0x10,%rsp
  803a93:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a96:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a9a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803a9d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803aa4:	00 00 00 
  803aa7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803aaa:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803aac:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803aaf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ab3:	48 89 c6             	mov    %rax,%rsi
  803ab6:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803abd:	00 00 00 
  803ac0:	48 b8 d3 13 80 00 00 	movabs $0x8013d3,%rax
  803ac7:	00 00 00 
  803aca:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803acc:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ad3:	00 00 00 
  803ad6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ad9:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803adc:	bf 02 00 00 00       	mov    $0x2,%edi
  803ae1:	48 b8 89 39 80 00 00 	movabs $0x803989,%rax
  803ae8:	00 00 00 
  803aeb:	ff d0                	callq  *%rax
}
  803aed:	c9                   	leaveq 
  803aee:	c3                   	retq   

0000000000803aef <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803aef:	55                   	push   %rbp
  803af0:	48 89 e5             	mov    %rsp,%rbp
  803af3:	48 83 ec 10          	sub    $0x10,%rsp
  803af7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803afa:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803afd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b04:	00 00 00 
  803b07:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b0a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803b0c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b13:	00 00 00 
  803b16:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b19:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803b1c:	bf 03 00 00 00       	mov    $0x3,%edi
  803b21:	48 b8 89 39 80 00 00 	movabs $0x803989,%rax
  803b28:	00 00 00 
  803b2b:	ff d0                	callq  *%rax
}
  803b2d:	c9                   	leaveq 
  803b2e:	c3                   	retq   

0000000000803b2f <nsipc_close>:

int
nsipc_close(int s)
{
  803b2f:	55                   	push   %rbp
  803b30:	48 89 e5             	mov    %rsp,%rbp
  803b33:	48 83 ec 10          	sub    $0x10,%rsp
  803b37:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803b3a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b41:	00 00 00 
  803b44:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b47:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803b49:	bf 04 00 00 00       	mov    $0x4,%edi
  803b4e:	48 b8 89 39 80 00 00 	movabs $0x803989,%rax
  803b55:	00 00 00 
  803b58:	ff d0                	callq  *%rax
}
  803b5a:	c9                   	leaveq 
  803b5b:	c3                   	retq   

0000000000803b5c <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803b5c:	55                   	push   %rbp
  803b5d:	48 89 e5             	mov    %rsp,%rbp
  803b60:	48 83 ec 10          	sub    $0x10,%rsp
  803b64:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803b6b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803b6e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b75:	00 00 00 
  803b78:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b7b:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803b7d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b84:	48 89 c6             	mov    %rax,%rsi
  803b87:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803b8e:	00 00 00 
  803b91:	48 b8 d3 13 80 00 00 	movabs $0x8013d3,%rax
  803b98:	00 00 00 
  803b9b:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803b9d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ba4:	00 00 00 
  803ba7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803baa:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803bad:	bf 05 00 00 00       	mov    $0x5,%edi
  803bb2:	48 b8 89 39 80 00 00 	movabs $0x803989,%rax
  803bb9:	00 00 00 
  803bbc:	ff d0                	callq  *%rax
}
  803bbe:	c9                   	leaveq 
  803bbf:	c3                   	retq   

0000000000803bc0 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803bc0:	55                   	push   %rbp
  803bc1:	48 89 e5             	mov    %rsp,%rbp
  803bc4:	48 83 ec 10          	sub    $0x10,%rsp
  803bc8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803bcb:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803bce:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bd5:	00 00 00 
  803bd8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bdb:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803bdd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803be4:	00 00 00 
  803be7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bea:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803bed:	bf 06 00 00 00       	mov    $0x6,%edi
  803bf2:	48 b8 89 39 80 00 00 	movabs $0x803989,%rax
  803bf9:	00 00 00 
  803bfc:	ff d0                	callq  *%rax
}
  803bfe:	c9                   	leaveq 
  803bff:	c3                   	retq   

0000000000803c00 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803c00:	55                   	push   %rbp
  803c01:	48 89 e5             	mov    %rsp,%rbp
  803c04:	48 83 ec 30          	sub    $0x30,%rsp
  803c08:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c0b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c0f:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803c12:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803c15:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c1c:	00 00 00 
  803c1f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c22:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803c24:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c2b:	00 00 00 
  803c2e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803c31:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803c34:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c3b:	00 00 00 
  803c3e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803c41:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803c44:	bf 07 00 00 00       	mov    $0x7,%edi
  803c49:	48 b8 89 39 80 00 00 	movabs $0x803989,%rax
  803c50:	00 00 00 
  803c53:	ff d0                	callq  *%rax
  803c55:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c5c:	78 69                	js     803cc7 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803c5e:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803c65:	7f 08                	jg     803c6f <nsipc_recv+0x6f>
  803c67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c6a:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803c6d:	7e 35                	jle    803ca4 <nsipc_recv+0xa4>
  803c6f:	48 b9 84 51 80 00 00 	movabs $0x805184,%rcx
  803c76:	00 00 00 
  803c79:	48 ba 99 51 80 00 00 	movabs $0x805199,%rdx
  803c80:	00 00 00 
  803c83:	be 61 00 00 00       	mov    $0x61,%esi
  803c88:	48 bf ae 51 80 00 00 	movabs $0x8051ae,%rdi
  803c8f:	00 00 00 
  803c92:	b8 00 00 00 00       	mov    $0x0,%eax
  803c97:	49 b8 dc 02 80 00 00 	movabs $0x8002dc,%r8
  803c9e:	00 00 00 
  803ca1:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803ca4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ca7:	48 63 d0             	movslq %eax,%rdx
  803caa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cae:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803cb5:	00 00 00 
  803cb8:	48 89 c7             	mov    %rax,%rdi
  803cbb:	48 b8 d3 13 80 00 00 	movabs $0x8013d3,%rax
  803cc2:	00 00 00 
  803cc5:	ff d0                	callq  *%rax
	}

	return r;
  803cc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803cca:	c9                   	leaveq 
  803ccb:	c3                   	retq   

0000000000803ccc <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803ccc:	55                   	push   %rbp
  803ccd:	48 89 e5             	mov    %rsp,%rbp
  803cd0:	48 83 ec 20          	sub    $0x20,%rsp
  803cd4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803cd7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803cdb:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803cde:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803ce1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ce8:	00 00 00 
  803ceb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803cee:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803cf0:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803cf7:	7e 35                	jle    803d2e <nsipc_send+0x62>
  803cf9:	48 b9 ba 51 80 00 00 	movabs $0x8051ba,%rcx
  803d00:	00 00 00 
  803d03:	48 ba 99 51 80 00 00 	movabs $0x805199,%rdx
  803d0a:	00 00 00 
  803d0d:	be 6c 00 00 00       	mov    $0x6c,%esi
  803d12:	48 bf ae 51 80 00 00 	movabs $0x8051ae,%rdi
  803d19:	00 00 00 
  803d1c:	b8 00 00 00 00       	mov    $0x0,%eax
  803d21:	49 b8 dc 02 80 00 00 	movabs $0x8002dc,%r8
  803d28:	00 00 00 
  803d2b:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803d2e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d31:	48 63 d0             	movslq %eax,%rdx
  803d34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d38:	48 89 c6             	mov    %rax,%rsi
  803d3b:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803d42:	00 00 00 
  803d45:	48 b8 d3 13 80 00 00 	movabs $0x8013d3,%rax
  803d4c:	00 00 00 
  803d4f:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803d51:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d58:	00 00 00 
  803d5b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d5e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803d61:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d68:	00 00 00 
  803d6b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803d6e:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803d71:	bf 08 00 00 00       	mov    $0x8,%edi
  803d76:	48 b8 89 39 80 00 00 	movabs $0x803989,%rax
  803d7d:	00 00 00 
  803d80:	ff d0                	callq  *%rax
}
  803d82:	c9                   	leaveq 
  803d83:	c3                   	retq   

0000000000803d84 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803d84:	55                   	push   %rbp
  803d85:	48 89 e5             	mov    %rsp,%rbp
  803d88:	48 83 ec 10          	sub    $0x10,%rsp
  803d8c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d8f:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803d92:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803d95:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d9c:	00 00 00 
  803d9f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803da2:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803da4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dab:	00 00 00 
  803dae:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803db1:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803db4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dbb:	00 00 00 
  803dbe:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803dc1:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803dc4:	bf 09 00 00 00       	mov    $0x9,%edi
  803dc9:	48 b8 89 39 80 00 00 	movabs $0x803989,%rax
  803dd0:	00 00 00 
  803dd3:	ff d0                	callq  *%rax
}
  803dd5:	c9                   	leaveq 
  803dd6:	c3                   	retq   

0000000000803dd7 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803dd7:	55                   	push   %rbp
  803dd8:	48 89 e5             	mov    %rsp,%rbp
  803ddb:	53                   	push   %rbx
  803ddc:	48 83 ec 38          	sub    $0x38,%rsp
  803de0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803de4:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803de8:	48 89 c7             	mov    %rax,%rdi
  803deb:	48 b8 92 1d 80 00 00 	movabs $0x801d92,%rax
  803df2:	00 00 00 
  803df5:	ff d0                	callq  *%rax
  803df7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803dfa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803dfe:	0f 88 bf 01 00 00    	js     803fc3 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e08:	ba 07 04 00 00       	mov    $0x407,%edx
  803e0d:	48 89 c6             	mov    %rax,%rsi
  803e10:	bf 00 00 00 00       	mov    $0x0,%edi
  803e15:	48 b8 dc 19 80 00 00 	movabs $0x8019dc,%rax
  803e1c:	00 00 00 
  803e1f:	ff d0                	callq  *%rax
  803e21:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e24:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e28:	0f 88 95 01 00 00    	js     803fc3 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803e2e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803e32:	48 89 c7             	mov    %rax,%rdi
  803e35:	48 b8 92 1d 80 00 00 	movabs $0x801d92,%rax
  803e3c:	00 00 00 
  803e3f:	ff d0                	callq  *%rax
  803e41:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e44:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e48:	0f 88 5d 01 00 00    	js     803fab <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e4e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e52:	ba 07 04 00 00       	mov    $0x407,%edx
  803e57:	48 89 c6             	mov    %rax,%rsi
  803e5a:	bf 00 00 00 00       	mov    $0x0,%edi
  803e5f:	48 b8 dc 19 80 00 00 	movabs $0x8019dc,%rax
  803e66:	00 00 00 
  803e69:	ff d0                	callq  *%rax
  803e6b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e6e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e72:	0f 88 33 01 00 00    	js     803fab <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803e78:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e7c:	48 89 c7             	mov    %rax,%rdi
  803e7f:	48 b8 67 1d 80 00 00 	movabs $0x801d67,%rax
  803e86:	00 00 00 
  803e89:	ff d0                	callq  *%rax
  803e8b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e8f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e93:	ba 07 04 00 00       	mov    $0x407,%edx
  803e98:	48 89 c6             	mov    %rax,%rsi
  803e9b:	bf 00 00 00 00       	mov    $0x0,%edi
  803ea0:	48 b8 dc 19 80 00 00 	movabs $0x8019dc,%rax
  803ea7:	00 00 00 
  803eaa:	ff d0                	callq  *%rax
  803eac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803eaf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803eb3:	79 05                	jns    803eba <pipe+0xe3>
		goto err2;
  803eb5:	e9 d9 00 00 00       	jmpq   803f93 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803eba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ebe:	48 89 c7             	mov    %rax,%rdi
  803ec1:	48 b8 67 1d 80 00 00 	movabs $0x801d67,%rax
  803ec8:	00 00 00 
  803ecb:	ff d0                	callq  *%rax
  803ecd:	48 89 c2             	mov    %rax,%rdx
  803ed0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ed4:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803eda:	48 89 d1             	mov    %rdx,%rcx
  803edd:	ba 00 00 00 00       	mov    $0x0,%edx
  803ee2:	48 89 c6             	mov    %rax,%rsi
  803ee5:	bf 00 00 00 00       	mov    $0x0,%edi
  803eea:	48 b8 2e 1a 80 00 00 	movabs $0x801a2e,%rax
  803ef1:	00 00 00 
  803ef4:	ff d0                	callq  *%rax
  803ef6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ef9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803efd:	79 1b                	jns    803f1a <pipe+0x143>
		goto err3;
  803eff:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803f00:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f04:	48 89 c6             	mov    %rax,%rsi
  803f07:	bf 00 00 00 00       	mov    $0x0,%edi
  803f0c:	48 b8 8e 1a 80 00 00 	movabs $0x801a8e,%rax
  803f13:	00 00 00 
  803f16:	ff d0                	callq  *%rax
  803f18:	eb 79                	jmp    803f93 <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  803f1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f1e:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803f25:	00 00 00 
  803f28:	8b 12                	mov    (%rdx),%edx
  803f2a:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803f2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f30:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  803f37:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f3b:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803f42:	00 00 00 
  803f45:	8b 12                	mov    (%rdx),%edx
  803f47:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803f49:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f4d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  803f54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f58:	48 89 c7             	mov    %rax,%rdi
  803f5b:	48 b8 44 1d 80 00 00 	movabs $0x801d44,%rax
  803f62:	00 00 00 
  803f65:	ff d0                	callq  *%rax
  803f67:	89 c2                	mov    %eax,%edx
  803f69:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803f6d:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803f6f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803f73:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803f77:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f7b:	48 89 c7             	mov    %rax,%rdi
  803f7e:	48 b8 44 1d 80 00 00 	movabs $0x801d44,%rax
  803f85:	00 00 00 
  803f88:	ff d0                	callq  *%rax
  803f8a:	89 03                	mov    %eax,(%rbx)
	return 0;
  803f8c:	b8 00 00 00 00       	mov    $0x0,%eax
  803f91:	eb 33                	jmp    803fc6 <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  803f93:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f97:	48 89 c6             	mov    %rax,%rsi
  803f9a:	bf 00 00 00 00       	mov    $0x0,%edi
  803f9f:	48 b8 8e 1a 80 00 00 	movabs $0x801a8e,%rax
  803fa6:	00 00 00 
  803fa9:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803fab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803faf:	48 89 c6             	mov    %rax,%rsi
  803fb2:	bf 00 00 00 00       	mov    $0x0,%edi
  803fb7:	48 b8 8e 1a 80 00 00 	movabs $0x801a8e,%rax
  803fbe:	00 00 00 
  803fc1:	ff d0                	callq  *%rax
err:
	return r;
  803fc3:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803fc6:	48 83 c4 38          	add    $0x38,%rsp
  803fca:	5b                   	pop    %rbx
  803fcb:	5d                   	pop    %rbp
  803fcc:	c3                   	retq   

0000000000803fcd <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803fcd:	55                   	push   %rbp
  803fce:	48 89 e5             	mov    %rsp,%rbp
  803fd1:	53                   	push   %rbx
  803fd2:	48 83 ec 28          	sub    $0x28,%rsp
  803fd6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803fda:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803fde:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803fe5:	00 00 00 
  803fe8:	48 8b 00             	mov    (%rax),%rax
  803feb:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803ff1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803ff4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ff8:	48 89 c7             	mov    %rax,%rdi
  803ffb:	48 b8 8e 48 80 00 00 	movabs $0x80488e,%rax
  804002:	00 00 00 
  804005:	ff d0                	callq  *%rax
  804007:	89 c3                	mov    %eax,%ebx
  804009:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80400d:	48 89 c7             	mov    %rax,%rdi
  804010:	48 b8 8e 48 80 00 00 	movabs $0x80488e,%rax
  804017:	00 00 00 
  80401a:	ff d0                	callq  *%rax
  80401c:	39 c3                	cmp    %eax,%ebx
  80401e:	0f 94 c0             	sete   %al
  804021:	0f b6 c0             	movzbl %al,%eax
  804024:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804027:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80402e:	00 00 00 
  804031:	48 8b 00             	mov    (%rax),%rax
  804034:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80403a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80403d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804040:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804043:	75 05                	jne    80404a <_pipeisclosed+0x7d>
			return ret;
  804045:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804048:	eb 4a                	jmp    804094 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  80404a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80404d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804050:	74 3d                	je     80408f <_pipeisclosed+0xc2>
  804052:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804056:	75 37                	jne    80408f <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804058:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80405f:	00 00 00 
  804062:	48 8b 00             	mov    (%rax),%rax
  804065:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80406b:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80406e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804071:	89 c6                	mov    %eax,%esi
  804073:	48 bf cb 51 80 00 00 	movabs $0x8051cb,%rdi
  80407a:	00 00 00 
  80407d:	b8 00 00 00 00       	mov    $0x0,%eax
  804082:	49 b8 15 05 80 00 00 	movabs $0x800515,%r8
  804089:	00 00 00 
  80408c:	41 ff d0             	callq  *%r8
	}
  80408f:	e9 4a ff ff ff       	jmpq   803fde <_pipeisclosed+0x11>
}
  804094:	48 83 c4 28          	add    $0x28,%rsp
  804098:	5b                   	pop    %rbx
  804099:	5d                   	pop    %rbp
  80409a:	c3                   	retq   

000000000080409b <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80409b:	55                   	push   %rbp
  80409c:	48 89 e5             	mov    %rsp,%rbp
  80409f:	48 83 ec 30          	sub    $0x30,%rsp
  8040a3:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8040a6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8040aa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8040ad:	48 89 d6             	mov    %rdx,%rsi
  8040b0:	89 c7                	mov    %eax,%edi
  8040b2:	48 b8 2a 1e 80 00 00 	movabs $0x801e2a,%rax
  8040b9:	00 00 00 
  8040bc:	ff d0                	callq  *%rax
  8040be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040c5:	79 05                	jns    8040cc <pipeisclosed+0x31>
		return r;
  8040c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040ca:	eb 31                	jmp    8040fd <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8040cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040d0:	48 89 c7             	mov    %rax,%rdi
  8040d3:	48 b8 67 1d 80 00 00 	movabs $0x801d67,%rax
  8040da:	00 00 00 
  8040dd:	ff d0                	callq  *%rax
  8040df:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8040e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040eb:	48 89 d6             	mov    %rdx,%rsi
  8040ee:	48 89 c7             	mov    %rax,%rdi
  8040f1:	48 b8 cd 3f 80 00 00 	movabs $0x803fcd,%rax
  8040f8:	00 00 00 
  8040fb:	ff d0                	callq  *%rax
}
  8040fd:	c9                   	leaveq 
  8040fe:	c3                   	retq   

00000000008040ff <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8040ff:	55                   	push   %rbp
  804100:	48 89 e5             	mov    %rsp,%rbp
  804103:	48 83 ec 40          	sub    $0x40,%rsp
  804107:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80410b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80410f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804113:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804117:	48 89 c7             	mov    %rax,%rdi
  80411a:	48 b8 67 1d 80 00 00 	movabs $0x801d67,%rax
  804121:	00 00 00 
  804124:	ff d0                	callq  *%rax
  804126:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80412a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80412e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804132:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804139:	00 
  80413a:	e9 92 00 00 00       	jmpq   8041d1 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80413f:	eb 41                	jmp    804182 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804141:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804146:	74 09                	je     804151 <devpipe_read+0x52>
				return i;
  804148:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80414c:	e9 92 00 00 00       	jmpq   8041e3 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804151:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804155:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804159:	48 89 d6             	mov    %rdx,%rsi
  80415c:	48 89 c7             	mov    %rax,%rdi
  80415f:	48 b8 cd 3f 80 00 00 	movabs $0x803fcd,%rax
  804166:	00 00 00 
  804169:	ff d0                	callq  *%rax
  80416b:	85 c0                	test   %eax,%eax
  80416d:	74 07                	je     804176 <devpipe_read+0x77>
				return 0;
  80416f:	b8 00 00 00 00       	mov    $0x0,%eax
  804174:	eb 6d                	jmp    8041e3 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804176:	48 b8 a0 19 80 00 00 	movabs $0x8019a0,%rax
  80417d:	00 00 00 
  804180:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  804182:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804186:	8b 10                	mov    (%rax),%edx
  804188:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80418c:	8b 40 04             	mov    0x4(%rax),%eax
  80418f:	39 c2                	cmp    %eax,%edx
  804191:	74 ae                	je     804141 <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804193:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804197:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80419b:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80419f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041a3:	8b 00                	mov    (%rax),%eax
  8041a5:	99                   	cltd   
  8041a6:	c1 ea 1b             	shr    $0x1b,%edx
  8041a9:	01 d0                	add    %edx,%eax
  8041ab:	83 e0 1f             	and    $0x1f,%eax
  8041ae:	29 d0                	sub    %edx,%eax
  8041b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041b4:	48 98                	cltq   
  8041b6:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8041bb:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8041bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041c1:	8b 00                	mov    (%rax),%eax
  8041c3:	8d 50 01             	lea    0x1(%rax),%edx
  8041c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041ca:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  8041cc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8041d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041d5:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8041d9:	0f 82 60 ff ff ff    	jb     80413f <devpipe_read+0x40>
	}
	return i;
  8041df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8041e3:	c9                   	leaveq 
  8041e4:	c3                   	retq   

00000000008041e5 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8041e5:	55                   	push   %rbp
  8041e6:	48 89 e5             	mov    %rsp,%rbp
  8041e9:	48 83 ec 40          	sub    $0x40,%rsp
  8041ed:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8041f1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8041f5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8041f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041fd:	48 89 c7             	mov    %rax,%rdi
  804200:	48 b8 67 1d 80 00 00 	movabs $0x801d67,%rax
  804207:	00 00 00 
  80420a:	ff d0                	callq  *%rax
  80420c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804210:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804214:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804218:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80421f:	00 
  804220:	e9 91 00 00 00       	jmpq   8042b6 <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804225:	eb 31                	jmp    804258 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804227:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80422b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80422f:	48 89 d6             	mov    %rdx,%rsi
  804232:	48 89 c7             	mov    %rax,%rdi
  804235:	48 b8 cd 3f 80 00 00 	movabs $0x803fcd,%rax
  80423c:	00 00 00 
  80423f:	ff d0                	callq  *%rax
  804241:	85 c0                	test   %eax,%eax
  804243:	74 07                	je     80424c <devpipe_write+0x67>
				return 0;
  804245:	b8 00 00 00 00       	mov    $0x0,%eax
  80424a:	eb 7c                	jmp    8042c8 <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80424c:	48 b8 a0 19 80 00 00 	movabs $0x8019a0,%rax
  804253:	00 00 00 
  804256:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804258:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80425c:	8b 40 04             	mov    0x4(%rax),%eax
  80425f:	48 63 d0             	movslq %eax,%rdx
  804262:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804266:	8b 00                	mov    (%rax),%eax
  804268:	48 98                	cltq   
  80426a:	48 83 c0 20          	add    $0x20,%rax
  80426e:	48 39 c2             	cmp    %rax,%rdx
  804271:	73 b4                	jae    804227 <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804273:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804277:	8b 40 04             	mov    0x4(%rax),%eax
  80427a:	99                   	cltd   
  80427b:	c1 ea 1b             	shr    $0x1b,%edx
  80427e:	01 d0                	add    %edx,%eax
  804280:	83 e0 1f             	and    $0x1f,%eax
  804283:	29 d0                	sub    %edx,%eax
  804285:	89 c6                	mov    %eax,%esi
  804287:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80428b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80428f:	48 01 d0             	add    %rdx,%rax
  804292:	0f b6 08             	movzbl (%rax),%ecx
  804295:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804299:	48 63 c6             	movslq %esi,%rax
  80429c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8042a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042a4:	8b 40 04             	mov    0x4(%rax),%eax
  8042a7:	8d 50 01             	lea    0x1(%rax),%edx
  8042aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042ae:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  8042b1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8042b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042ba:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8042be:	0f 82 61 ff ff ff    	jb     804225 <devpipe_write+0x40>
	}

	return i;
  8042c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8042c8:	c9                   	leaveq 
  8042c9:	c3                   	retq   

00000000008042ca <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8042ca:	55                   	push   %rbp
  8042cb:	48 89 e5             	mov    %rsp,%rbp
  8042ce:	48 83 ec 20          	sub    $0x20,%rsp
  8042d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8042d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8042da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042de:	48 89 c7             	mov    %rax,%rdi
  8042e1:	48 b8 67 1d 80 00 00 	movabs $0x801d67,%rax
  8042e8:	00 00 00 
  8042eb:	ff d0                	callq  *%rax
  8042ed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8042f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042f5:	48 be de 51 80 00 00 	movabs $0x8051de,%rsi
  8042fc:	00 00 00 
  8042ff:	48 89 c7             	mov    %rax,%rdi
  804302:	48 b8 af 10 80 00 00 	movabs $0x8010af,%rax
  804309:	00 00 00 
  80430c:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80430e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804312:	8b 50 04             	mov    0x4(%rax),%edx
  804315:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804319:	8b 00                	mov    (%rax),%eax
  80431b:	29 c2                	sub    %eax,%edx
  80431d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804321:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804327:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80432b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804332:	00 00 00 
	stat->st_dev = &devpipe;
  804335:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804339:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  804340:	00 00 00 
  804343:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80434a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80434f:	c9                   	leaveq 
  804350:	c3                   	retq   

0000000000804351 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804351:	55                   	push   %rbp
  804352:	48 89 e5             	mov    %rsp,%rbp
  804355:	48 83 ec 10          	sub    $0x10,%rsp
  804359:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80435d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804361:	48 89 c6             	mov    %rax,%rsi
  804364:	bf 00 00 00 00       	mov    $0x0,%edi
  804369:	48 b8 8e 1a 80 00 00 	movabs $0x801a8e,%rax
  804370:	00 00 00 
  804373:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804375:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804379:	48 89 c7             	mov    %rax,%rdi
  80437c:	48 b8 67 1d 80 00 00 	movabs $0x801d67,%rax
  804383:	00 00 00 
  804386:	ff d0                	callq  *%rax
  804388:	48 89 c6             	mov    %rax,%rsi
  80438b:	bf 00 00 00 00       	mov    $0x0,%edi
  804390:	48 b8 8e 1a 80 00 00 	movabs $0x801a8e,%rax
  804397:	00 00 00 
  80439a:	ff d0                	callq  *%rax
}
  80439c:	c9                   	leaveq 
  80439d:	c3                   	retq   

000000000080439e <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80439e:	55                   	push   %rbp
  80439f:	48 89 e5             	mov    %rsp,%rbp
  8043a2:	48 83 ec 20          	sub    $0x20,%rsp
  8043a6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8043a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8043ac:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8043af:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8043b3:	be 01 00 00 00       	mov    $0x1,%esi
  8043b8:	48 89 c7             	mov    %rax,%rdi
  8043bb:	48 b8 96 18 80 00 00 	movabs $0x801896,%rax
  8043c2:	00 00 00 
  8043c5:	ff d0                	callq  *%rax
}
  8043c7:	c9                   	leaveq 
  8043c8:	c3                   	retq   

00000000008043c9 <getchar>:

int
getchar(void)
{
  8043c9:	55                   	push   %rbp
  8043ca:	48 89 e5             	mov    %rsp,%rbp
  8043cd:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8043d1:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8043d5:	ba 01 00 00 00       	mov    $0x1,%edx
  8043da:	48 89 c6             	mov    %rax,%rsi
  8043dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8043e2:	48 b8 5e 22 80 00 00 	movabs $0x80225e,%rax
  8043e9:	00 00 00 
  8043ec:	ff d0                	callq  *%rax
  8043ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8043f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043f5:	79 05                	jns    8043fc <getchar+0x33>
		return r;
  8043f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043fa:	eb 14                	jmp    804410 <getchar+0x47>
	if (r < 1)
  8043fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804400:	7f 07                	jg     804409 <getchar+0x40>
		return -E_EOF;
  804402:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804407:	eb 07                	jmp    804410 <getchar+0x47>
	return c;
  804409:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80440d:	0f b6 c0             	movzbl %al,%eax
}
  804410:	c9                   	leaveq 
  804411:	c3                   	retq   

0000000000804412 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804412:	55                   	push   %rbp
  804413:	48 89 e5             	mov    %rsp,%rbp
  804416:	48 83 ec 20          	sub    $0x20,%rsp
  80441a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80441d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804421:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804424:	48 89 d6             	mov    %rdx,%rsi
  804427:	89 c7                	mov    %eax,%edi
  804429:	48 b8 2a 1e 80 00 00 	movabs $0x801e2a,%rax
  804430:	00 00 00 
  804433:	ff d0                	callq  *%rax
  804435:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804438:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80443c:	79 05                	jns    804443 <iscons+0x31>
		return r;
  80443e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804441:	eb 1a                	jmp    80445d <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804443:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804447:	8b 10                	mov    (%rax),%edx
  804449:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804450:	00 00 00 
  804453:	8b 00                	mov    (%rax),%eax
  804455:	39 c2                	cmp    %eax,%edx
  804457:	0f 94 c0             	sete   %al
  80445a:	0f b6 c0             	movzbl %al,%eax
}
  80445d:	c9                   	leaveq 
  80445e:	c3                   	retq   

000000000080445f <opencons>:

int
opencons(void)
{
  80445f:	55                   	push   %rbp
  804460:	48 89 e5             	mov    %rsp,%rbp
  804463:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804467:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80446b:	48 89 c7             	mov    %rax,%rdi
  80446e:	48 b8 92 1d 80 00 00 	movabs $0x801d92,%rax
  804475:	00 00 00 
  804478:	ff d0                	callq  *%rax
  80447a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80447d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804481:	79 05                	jns    804488 <opencons+0x29>
		return r;
  804483:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804486:	eb 5b                	jmp    8044e3 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804488:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80448c:	ba 07 04 00 00       	mov    $0x407,%edx
  804491:	48 89 c6             	mov    %rax,%rsi
  804494:	bf 00 00 00 00       	mov    $0x0,%edi
  804499:	48 b8 dc 19 80 00 00 	movabs $0x8019dc,%rax
  8044a0:	00 00 00 
  8044a3:	ff d0                	callq  *%rax
  8044a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044ac:	79 05                	jns    8044b3 <opencons+0x54>
		return r;
  8044ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044b1:	eb 30                	jmp    8044e3 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8044b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044b7:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8044be:	00 00 00 
  8044c1:	8b 12                	mov    (%rdx),%edx
  8044c3:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8044c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044c9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8044d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044d4:	48 89 c7             	mov    %rax,%rdi
  8044d7:	48 b8 44 1d 80 00 00 	movabs $0x801d44,%rax
  8044de:	00 00 00 
  8044e1:	ff d0                	callq  *%rax
}
  8044e3:	c9                   	leaveq 
  8044e4:	c3                   	retq   

00000000008044e5 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8044e5:	55                   	push   %rbp
  8044e6:	48 89 e5             	mov    %rsp,%rbp
  8044e9:	48 83 ec 30          	sub    $0x30,%rsp
  8044ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8044f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8044f5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8044f9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8044fe:	75 07                	jne    804507 <devcons_read+0x22>
		return 0;
  804500:	b8 00 00 00 00       	mov    $0x0,%eax
  804505:	eb 4b                	jmp    804552 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804507:	eb 0c                	jmp    804515 <devcons_read+0x30>
		sys_yield();
  804509:	48 b8 a0 19 80 00 00 	movabs $0x8019a0,%rax
  804510:	00 00 00 
  804513:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  804515:	48 b8 e2 18 80 00 00 	movabs $0x8018e2,%rax
  80451c:	00 00 00 
  80451f:	ff d0                	callq  *%rax
  804521:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804524:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804528:	74 df                	je     804509 <devcons_read+0x24>
	if (c < 0)
  80452a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80452e:	79 05                	jns    804535 <devcons_read+0x50>
		return c;
  804530:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804533:	eb 1d                	jmp    804552 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804535:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804539:	75 07                	jne    804542 <devcons_read+0x5d>
		return 0;
  80453b:	b8 00 00 00 00       	mov    $0x0,%eax
  804540:	eb 10                	jmp    804552 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804542:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804545:	89 c2                	mov    %eax,%edx
  804547:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80454b:	88 10                	mov    %dl,(%rax)
	return 1;
  80454d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804552:	c9                   	leaveq 
  804553:	c3                   	retq   

0000000000804554 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804554:	55                   	push   %rbp
  804555:	48 89 e5             	mov    %rsp,%rbp
  804558:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80455f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804566:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80456d:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804574:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80457b:	eb 76                	jmp    8045f3 <devcons_write+0x9f>
		m = n - tot;
  80457d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804584:	89 c2                	mov    %eax,%edx
  804586:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804589:	29 c2                	sub    %eax,%edx
  80458b:	89 d0                	mov    %edx,%eax
  80458d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804590:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804593:	83 f8 7f             	cmp    $0x7f,%eax
  804596:	76 07                	jbe    80459f <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804598:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80459f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045a2:	48 63 d0             	movslq %eax,%rdx
  8045a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045a8:	48 63 c8             	movslq %eax,%rcx
  8045ab:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8045b2:	48 01 c1             	add    %rax,%rcx
  8045b5:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8045bc:	48 89 ce             	mov    %rcx,%rsi
  8045bf:	48 89 c7             	mov    %rax,%rdi
  8045c2:	48 b8 d3 13 80 00 00 	movabs $0x8013d3,%rax
  8045c9:	00 00 00 
  8045cc:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8045ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045d1:	48 63 d0             	movslq %eax,%rdx
  8045d4:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8045db:	48 89 d6             	mov    %rdx,%rsi
  8045de:	48 89 c7             	mov    %rax,%rdi
  8045e1:	48 b8 96 18 80 00 00 	movabs $0x801896,%rax
  8045e8:	00 00 00 
  8045eb:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  8045ed:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045f0:	01 45 fc             	add    %eax,-0x4(%rbp)
  8045f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045f6:	48 98                	cltq   
  8045f8:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8045ff:	0f 82 78 ff ff ff    	jb     80457d <devcons_write+0x29>
	}
	return tot;
  804605:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804608:	c9                   	leaveq 
  804609:	c3                   	retq   

000000000080460a <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80460a:	55                   	push   %rbp
  80460b:	48 89 e5             	mov    %rsp,%rbp
  80460e:	48 83 ec 08          	sub    $0x8,%rsp
  804612:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804616:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80461b:	c9                   	leaveq 
  80461c:	c3                   	retq   

000000000080461d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80461d:	55                   	push   %rbp
  80461e:	48 89 e5             	mov    %rsp,%rbp
  804621:	48 83 ec 10          	sub    $0x10,%rsp
  804625:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804629:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80462d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804631:	48 be ea 51 80 00 00 	movabs $0x8051ea,%rsi
  804638:	00 00 00 
  80463b:	48 89 c7             	mov    %rax,%rdi
  80463e:	48 b8 af 10 80 00 00 	movabs $0x8010af,%rax
  804645:	00 00 00 
  804648:	ff d0                	callq  *%rax
	return 0;
  80464a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80464f:	c9                   	leaveq 
  804650:	c3                   	retq   

0000000000804651 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804651:	55                   	push   %rbp
  804652:	48 89 e5             	mov    %rsp,%rbp
  804655:	48 83 ec 20          	sub    $0x20,%rsp
  804659:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80465d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804661:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  804665:	48 ba f8 51 80 00 00 	movabs $0x8051f8,%rdx
  80466c:	00 00 00 
  80466f:	be 1d 00 00 00       	mov    $0x1d,%esi
  804674:	48 bf 11 52 80 00 00 	movabs $0x805211,%rdi
  80467b:	00 00 00 
  80467e:	b8 00 00 00 00       	mov    $0x0,%eax
  804683:	48 b9 dc 02 80 00 00 	movabs $0x8002dc,%rcx
  80468a:	00 00 00 
  80468d:	ff d1                	callq  *%rcx

000000000080468f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80468f:	55                   	push   %rbp
  804690:	48 89 e5             	mov    %rsp,%rbp
  804693:	48 83 ec 20          	sub    $0x20,%rsp
  804697:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80469a:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80469d:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  8046a1:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  8046a4:	48 ba 1b 52 80 00 00 	movabs $0x80521b,%rdx
  8046ab:	00 00 00 
  8046ae:	be 2d 00 00 00       	mov    $0x2d,%esi
  8046b3:	48 bf 11 52 80 00 00 	movabs $0x805211,%rdi
  8046ba:	00 00 00 
  8046bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8046c2:	48 b9 dc 02 80 00 00 	movabs $0x8002dc,%rcx
  8046c9:	00 00 00 
  8046cc:	ff d1                	callq  *%rcx

00000000008046ce <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8046ce:	55                   	push   %rbp
  8046cf:	48 89 e5             	mov    %rsp,%rbp
  8046d2:	53                   	push   %rbx
  8046d3:	48 83 ec 48          	sub    $0x48,%rsp
  8046d7:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  8046db:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  8046e2:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  8046e9:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  8046ee:	75 0e                	jne    8046fe <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  8046f0:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8046f7:	00 00 00 
  8046fa:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  8046fe:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804702:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  804706:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  80470d:	00 
	a3 = (uint64_t) 0;
  80470e:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  804715:	00 
	a4 = (uint64_t) 0;
  804716:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  80471d:	00 
	a5 = 0;
  80471e:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  804725:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  804726:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804729:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80472d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  804731:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  804735:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  804739:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80473d:	4c 89 c3             	mov    %r8,%rbx
  804740:	0f 01 c1             	vmcall 
  804743:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  804746:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80474a:	7e 36                	jle    804782 <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  80474c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80474f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804752:	41 89 d0             	mov    %edx,%r8d
  804755:	89 c1                	mov    %eax,%ecx
  804757:	48 ba 38 52 80 00 00 	movabs $0x805238,%rdx
  80475e:	00 00 00 
  804761:	be 54 00 00 00       	mov    $0x54,%esi
  804766:	48 bf 11 52 80 00 00 	movabs $0x805211,%rdi
  80476d:	00 00 00 
  804770:	b8 00 00 00 00       	mov    $0x0,%eax
  804775:	49 b9 dc 02 80 00 00 	movabs $0x8002dc,%r9
  80477c:	00 00 00 
  80477f:	41 ff d1             	callq  *%r9
	return ret;
  804782:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804785:	48 83 c4 48          	add    $0x48,%rsp
  804789:	5b                   	pop    %rbx
  80478a:	5d                   	pop    %rbp
  80478b:	c3                   	retq   

000000000080478c <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80478c:	55                   	push   %rbp
  80478d:	48 89 e5             	mov    %rsp,%rbp
  804790:	53                   	push   %rbx
  804791:	48 83 ec 58          	sub    $0x58,%rsp
  804795:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  804798:	89 75 b0             	mov    %esi,-0x50(%rbp)
  80479b:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  80479f:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  8047a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  8047a9:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  8047b0:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  8047b5:	75 0e                	jne    8047c5 <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  8047b7:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8047be:	00 00 00 
  8047c1:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  8047c5:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8047c8:	48 98                	cltq   
  8047ca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  8047ce:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8047d1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  8047d5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8047d9:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  8047dd:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  8047e0:	48 98                	cltq   
  8047e2:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  8047e6:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  8047ed:	00 

	int r = -E_IPC_NOT_RECV;
  8047ee:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  8047f5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8047f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8047fc:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  804800:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  804804:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  804808:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  80480c:	4c 89 c3             	mov    %r8,%rbx
  80480f:	0f 01 c1             	vmcall 
  804812:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  804815:	48 83 c4 58          	add    $0x58,%rsp
  804819:	5b                   	pop    %rbx
  80481a:	5d                   	pop    %rbp
  80481b:	c3                   	retq   

000000000080481c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80481c:	55                   	push   %rbp
  80481d:	48 89 e5             	mov    %rsp,%rbp
  804820:	48 83 ec 18          	sub    $0x18,%rsp
  804824:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804827:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80482e:	eb 4e                	jmp    80487e <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  804830:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804837:	00 00 00 
  80483a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80483d:	48 98                	cltq   
  80483f:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804846:	48 01 d0             	add    %rdx,%rax
  804849:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80484f:	8b 00                	mov    (%rax),%eax
  804851:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804854:	75 24                	jne    80487a <ipc_find_env+0x5e>
			return envs[i].env_id;
  804856:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80485d:	00 00 00 
  804860:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804863:	48 98                	cltq   
  804865:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80486c:	48 01 d0             	add    %rdx,%rax
  80486f:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804875:	8b 40 08             	mov    0x8(%rax),%eax
  804878:	eb 12                	jmp    80488c <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  80487a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80487e:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804885:	7e a9                	jle    804830 <ipc_find_env+0x14>
	}
	return 0;
  804887:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80488c:	c9                   	leaveq 
  80488d:	c3                   	retq   

000000000080488e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80488e:	55                   	push   %rbp
  80488f:	48 89 e5             	mov    %rsp,%rbp
  804892:	48 83 ec 18          	sub    $0x18,%rsp
  804896:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80489a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80489e:	48 c1 e8 15          	shr    $0x15,%rax
  8048a2:	48 89 c2             	mov    %rax,%rdx
  8048a5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8048ac:	01 00 00 
  8048af:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8048b3:	83 e0 01             	and    $0x1,%eax
  8048b6:	48 85 c0             	test   %rax,%rax
  8048b9:	75 07                	jne    8048c2 <pageref+0x34>
		return 0;
  8048bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8048c0:	eb 53                	jmp    804915 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8048c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048c6:	48 c1 e8 0c          	shr    $0xc,%rax
  8048ca:	48 89 c2             	mov    %rax,%rdx
  8048cd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8048d4:	01 00 00 
  8048d7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8048db:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8048df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048e3:	83 e0 01             	and    $0x1,%eax
  8048e6:	48 85 c0             	test   %rax,%rax
  8048e9:	75 07                	jne    8048f2 <pageref+0x64>
		return 0;
  8048eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8048f0:	eb 23                	jmp    804915 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8048f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048f6:	48 c1 e8 0c          	shr    $0xc,%rax
  8048fa:	48 89 c2             	mov    %rax,%rdx
  8048fd:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804904:	00 00 00 
  804907:	48 c1 e2 04          	shl    $0x4,%rdx
  80490b:	48 01 d0             	add    %rdx,%rax
  80490e:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804912:	0f b7 c0             	movzwl %ax,%eax
}
  804915:	c9                   	leaveq 
  804916:	c3                   	retq   
