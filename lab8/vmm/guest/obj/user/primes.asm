
vmm/guest/obj/user/primes:     formato del fichero elf64-x86-64


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
  80003c:	e8 8b 01 00 00       	callq  8001cc <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80004b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80004f:	ba 00 00 00 00       	mov    $0x0,%edx
  800054:	be 00 00 00 00       	mov    $0x0,%esi
  800059:	48 89 c7             	mov    %rax,%rdi
  80005c:	48 b8 97 1d 80 00 00 	movabs $0x801d97,%rax
  800063:	00 00 00 
  800066:	ff d0                	callq  *%rax
  800068:	89 45 fc             	mov    %eax,-0x4(%rbp)
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80006b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800072:	00 00 00 
  800075:	48 8b 00             	mov    (%rax),%rax
  800078:	8b 80 dc 00 00 00    	mov    0xdc(%rax),%eax
  80007e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800081:	89 c6                	mov    %eax,%esi
  800083:	48 bf 40 3f 80 00 00 	movabs $0x803f40,%rdi
  80008a:	00 00 00 
  80008d:	b8 00 00 00 00       	mov    $0x0,%eax
  800092:	48 b9 88 04 80 00 00 	movabs $0x800488,%rcx
  800099:	00 00 00 
  80009c:	ff d1                	callq  *%rcx

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  80009e:	48 b8 3b 1d 80 00 00 	movabs $0x801d3b,%rax
  8000a5:	00 00 00 
  8000a8:	ff d0                	callq  *%rax
  8000aa:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000ad:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000b1:	79 30                	jns    8000e3 <primeproc+0xa0>
		panic("fork: %e", id);
  8000b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000b6:	89 c1                	mov    %eax,%ecx
  8000b8:	48 ba 4c 3f 80 00 00 	movabs $0x803f4c,%rdx
  8000bf:	00 00 00 
  8000c2:	be 1a 00 00 00       	mov    $0x1a,%esi
  8000c7:	48 bf 55 3f 80 00 00 	movabs $0x803f55,%rdi
  8000ce:	00 00 00 
  8000d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d6:	49 b8 4f 02 80 00 00 	movabs $0x80024f,%r8
  8000dd:	00 00 00 
  8000e0:	41 ff d0             	callq  *%r8
	if (id == 0)
  8000e3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000e7:	75 05                	jne    8000ee <primeproc+0xab>
		goto top;
  8000e9:	e9 5d ff ff ff       	jmpq   80004b <primeproc+0x8>

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  8000ee:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8000f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8000f7:	be 00 00 00 00       	mov    $0x0,%esi
  8000fc:	48 89 c7             	mov    %rax,%rdi
  8000ff:	48 b8 97 1d 80 00 00 	movabs $0x801d97,%rax
  800106:	00 00 00 
  800109:	ff d0                	callq  *%rax
  80010b:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (i % p)
  80010e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800111:	99                   	cltd   
  800112:	f7 7d fc             	idivl  -0x4(%rbp)
  800115:	89 d0                	mov    %edx,%eax
  800117:	85 c0                	test   %eax,%eax
  800119:	74 1e                	je     800139 <primeproc+0xf6>
			ipc_send(id, i, 0, 0);
  80011b:	8b 75 f4             	mov    -0xc(%rbp),%esi
  80011e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800121:	b9 00 00 00 00       	mov    $0x0,%ecx
  800126:	ba 00 00 00 00       	mov    $0x0,%edx
  80012b:	89 c7                	mov    %eax,%edi
  80012d:	48 b8 d5 1d 80 00 00 	movabs $0x801dd5,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
	}
  800139:	eb b3                	jmp    8000ee <primeproc+0xab>

000000000080013b <umain>:
}

void
umain(int argc, char **argv)
{
  80013b:	55                   	push   %rbp
  80013c:	48 89 e5             	mov    %rsp,%rbp
  80013f:	48 83 ec 20          	sub    $0x20,%rsp
  800143:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800146:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  80014a:	48 b8 3b 1d 80 00 00 	movabs $0x801d3b,%rax
  800151:	00 00 00 
  800154:	ff d0                	callq  *%rax
  800156:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800159:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80015d:	79 30                	jns    80018f <umain+0x54>
		panic("fork: %e", id);
  80015f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800162:	89 c1                	mov    %eax,%ecx
  800164:	48 ba 4c 3f 80 00 00 	movabs $0x803f4c,%rdx
  80016b:	00 00 00 
  80016e:	be 2d 00 00 00       	mov    $0x2d,%esi
  800173:	48 bf 55 3f 80 00 00 	movabs $0x803f55,%rdi
  80017a:	00 00 00 
  80017d:	b8 00 00 00 00       	mov    $0x0,%eax
  800182:	49 b8 4f 02 80 00 00 	movabs $0x80024f,%r8
  800189:	00 00 00 
  80018c:	41 ff d0             	callq  *%r8
	if (id == 0)
  80018f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800193:	75 0c                	jne    8001a1 <umain+0x66>
		primeproc();
  800195:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80019c:	00 00 00 
  80019f:	ff d0                	callq  *%rax

	// feed all the integers through
	for (i = 2; ; i++)
  8001a1:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%rbp)
		ipc_send(id, i, 0, 0);
  8001a8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8001ab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8001b8:	89 c7                	mov    %eax,%edi
  8001ba:	48 b8 d5 1d 80 00 00 	movabs $0x801dd5,%rax
  8001c1:	00 00 00 
  8001c4:	ff d0                	callq  *%rax
	for (i = 2; ; i++)
  8001c6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
		ipc_send(id, i, 0, 0);
  8001ca:	eb dc                	jmp    8001a8 <umain+0x6d>

00000000008001cc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001cc:	55                   	push   %rbp
  8001cd:	48 89 e5             	mov    %rsp,%rbp
  8001d0:	48 83 ec 10          	sub    $0x10,%rsp
  8001d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001d7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8001db:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8001e2:	00 00 00 
  8001e5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001f0:	7e 14                	jle    800206 <libmain+0x3a>
		binaryname = argv[0];
  8001f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001f6:	48 8b 10             	mov    (%rax),%rdx
  8001f9:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800200:	00 00 00 
  800203:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800206:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80020a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80020d:	48 89 d6             	mov    %rdx,%rsi
  800210:	89 c7                	mov    %eax,%edi
  800212:	48 b8 3b 01 80 00 00 	movabs $0x80013b,%rax
  800219:	00 00 00 
  80021c:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80021e:	48 b8 2c 02 80 00 00 	movabs $0x80022c,%rax
  800225:	00 00 00 
  800228:	ff d0                	callq  *%rax
}
  80022a:	c9                   	leaveq 
  80022b:	c3                   	retq   

000000000080022c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80022c:	55                   	push   %rbp
  80022d:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800230:	48 b8 17 23 80 00 00 	movabs $0x802317,%rax
  800237:	00 00 00 
  80023a:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80023c:	bf 00 00 00 00       	mov    $0x0,%edi
  800241:	48 b8 91 18 80 00 00 	movabs $0x801891,%rax
  800248:	00 00 00 
  80024b:	ff d0                	callq  *%rax
}
  80024d:	5d                   	pop    %rbp
  80024e:	c3                   	retq   

000000000080024f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80024f:	55                   	push   %rbp
  800250:	48 89 e5             	mov    %rsp,%rbp
  800253:	53                   	push   %rbx
  800254:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80025b:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800262:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800268:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80026f:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800276:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80027d:	84 c0                	test   %al,%al
  80027f:	74 23                	je     8002a4 <_panic+0x55>
  800281:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800288:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80028c:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800290:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800294:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800298:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80029c:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002a0:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002a4:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002ab:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002b2:	00 00 00 
  8002b5:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002bc:	00 00 00 
  8002bf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002c3:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002ca:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002d1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002d8:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002df:	00 00 00 
  8002e2:	48 8b 18             	mov    (%rax),%rbx
  8002e5:	48 b8 d7 18 80 00 00 	movabs $0x8018d7,%rax
  8002ec:	00 00 00 
  8002ef:	ff d0                	callq  *%rax
  8002f1:	89 c6                	mov    %eax,%esi
  8002f3:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8002f9:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  800300:	41 89 d0             	mov    %edx,%r8d
  800303:	48 89 c1             	mov    %rax,%rcx
  800306:	48 89 da             	mov    %rbx,%rdx
  800309:	48 bf 70 3f 80 00 00 	movabs $0x803f70,%rdi
  800310:	00 00 00 
  800313:	b8 00 00 00 00       	mov    $0x0,%eax
  800318:	49 b9 88 04 80 00 00 	movabs $0x800488,%r9
  80031f:	00 00 00 
  800322:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800325:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80032c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800333:	48 89 d6             	mov    %rdx,%rsi
  800336:	48 89 c7             	mov    %rax,%rdi
  800339:	48 b8 dc 03 80 00 00 	movabs $0x8003dc,%rax
  800340:	00 00 00 
  800343:	ff d0                	callq  *%rax
	cprintf("\n");
  800345:	48 bf 93 3f 80 00 00 	movabs $0x803f93,%rdi
  80034c:	00 00 00 
  80034f:	b8 00 00 00 00       	mov    $0x0,%eax
  800354:	48 ba 88 04 80 00 00 	movabs $0x800488,%rdx
  80035b:	00 00 00 
  80035e:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800360:	cc                   	int3   
  800361:	eb fd                	jmp    800360 <_panic+0x111>

0000000000800363 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800363:	55                   	push   %rbp
  800364:	48 89 e5             	mov    %rsp,%rbp
  800367:	48 83 ec 10          	sub    $0x10,%rsp
  80036b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80036e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800372:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800376:	8b 00                	mov    (%rax),%eax
  800378:	8d 48 01             	lea    0x1(%rax),%ecx
  80037b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80037f:	89 0a                	mov    %ecx,(%rdx)
  800381:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800384:	89 d1                	mov    %edx,%ecx
  800386:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80038a:	48 98                	cltq   
  80038c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800390:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800394:	8b 00                	mov    (%rax),%eax
  800396:	3d ff 00 00 00       	cmp    $0xff,%eax
  80039b:	75 2c                	jne    8003c9 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80039d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a1:	8b 00                	mov    (%rax),%eax
  8003a3:	48 98                	cltq   
  8003a5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a9:	48 83 c2 08          	add    $0x8,%rdx
  8003ad:	48 89 c6             	mov    %rax,%rsi
  8003b0:	48 89 d7             	mov    %rdx,%rdi
  8003b3:	48 b8 09 18 80 00 00 	movabs $0x801809,%rax
  8003ba:	00 00 00 
  8003bd:	ff d0                	callq  *%rax
        b->idx = 0;
  8003bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003cd:	8b 40 04             	mov    0x4(%rax),%eax
  8003d0:	8d 50 01             	lea    0x1(%rax),%edx
  8003d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d7:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003da:	c9                   	leaveq 
  8003db:	c3                   	retq   

00000000008003dc <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003dc:	55                   	push   %rbp
  8003dd:	48 89 e5             	mov    %rsp,%rbp
  8003e0:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003e7:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003ee:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8003f5:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003fc:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800403:	48 8b 0a             	mov    (%rdx),%rcx
  800406:	48 89 08             	mov    %rcx,(%rax)
  800409:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80040d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800411:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800415:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800419:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800420:	00 00 00 
    b.cnt = 0;
  800423:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80042a:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80042d:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800434:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80043b:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800442:	48 89 c6             	mov    %rax,%rsi
  800445:	48 bf 63 03 80 00 00 	movabs $0x800363,%rdi
  80044c:	00 00 00 
  80044f:	48 b8 27 08 80 00 00 	movabs $0x800827,%rax
  800456:	00 00 00 
  800459:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80045b:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800461:	48 98                	cltq   
  800463:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80046a:	48 83 c2 08          	add    $0x8,%rdx
  80046e:	48 89 c6             	mov    %rax,%rsi
  800471:	48 89 d7             	mov    %rdx,%rdi
  800474:	48 b8 09 18 80 00 00 	movabs $0x801809,%rax
  80047b:	00 00 00 
  80047e:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800480:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800486:	c9                   	leaveq 
  800487:	c3                   	retq   

0000000000800488 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800488:	55                   	push   %rbp
  800489:	48 89 e5             	mov    %rsp,%rbp
  80048c:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800493:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80049a:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004a1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004a8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004af:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004b6:	84 c0                	test   %al,%al
  8004b8:	74 20                	je     8004da <cprintf+0x52>
  8004ba:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004be:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004c2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004c6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004ca:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004ce:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004d2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004d6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004da:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004e1:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004e8:	00 00 00 
  8004eb:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004f2:	00 00 00 
  8004f5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004f9:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800500:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800507:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80050e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800515:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80051c:	48 8b 0a             	mov    (%rdx),%rcx
  80051f:	48 89 08             	mov    %rcx,(%rax)
  800522:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800526:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80052a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80052e:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800532:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800539:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800540:	48 89 d6             	mov    %rdx,%rsi
  800543:	48 89 c7             	mov    %rax,%rdi
  800546:	48 b8 dc 03 80 00 00 	movabs $0x8003dc,%rax
  80054d:	00 00 00 
  800550:	ff d0                	callq  *%rax
  800552:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800558:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80055e:	c9                   	leaveq 
  80055f:	c3                   	retq   

0000000000800560 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800560:	55                   	push   %rbp
  800561:	48 89 e5             	mov    %rsp,%rbp
  800564:	48 83 ec 30          	sub    $0x30,%rsp
  800568:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80056c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800570:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800574:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800577:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80057b:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80057f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800582:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800586:	77 42                	ja     8005ca <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800588:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80058b:	8d 78 ff             	lea    -0x1(%rax),%edi
  80058e:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800591:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800595:	ba 00 00 00 00       	mov    $0x0,%edx
  80059a:	48 f7 f6             	div    %rsi
  80059d:	49 89 c2             	mov    %rax,%r10
  8005a0:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8005a3:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8005a6:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8005aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005ae:	41 89 c9             	mov    %ecx,%r9d
  8005b1:	41 89 f8             	mov    %edi,%r8d
  8005b4:	89 d1                	mov    %edx,%ecx
  8005b6:	4c 89 d2             	mov    %r10,%rdx
  8005b9:	48 89 c7             	mov    %rax,%rdi
  8005bc:	48 b8 60 05 80 00 00 	movabs $0x800560,%rax
  8005c3:	00 00 00 
  8005c6:	ff d0                	callq  *%rax
  8005c8:	eb 1e                	jmp    8005e8 <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005ca:	eb 12                	jmp    8005de <printnum+0x7e>
			putch(padc, putdat);
  8005cc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8005d0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8005d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005d7:	48 89 ce             	mov    %rcx,%rsi
  8005da:	89 d7                	mov    %edx,%edi
  8005dc:	ff d0                	callq  *%rax
		while (--width > 0)
  8005de:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8005e2:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8005e6:	7f e4                	jg     8005cc <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005e8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8005eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f4:	48 f7 f1             	div    %rcx
  8005f7:	48 b8 b0 41 80 00 00 	movabs $0x8041b0,%rax
  8005fe:	00 00 00 
  800601:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800605:	0f be d0             	movsbl %al,%edx
  800608:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80060c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800610:	48 89 ce             	mov    %rcx,%rsi
  800613:	89 d7                	mov    %edx,%edi
  800615:	ff d0                	callq  *%rax
}
  800617:	c9                   	leaveq 
  800618:	c3                   	retq   

0000000000800619 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800619:	55                   	push   %rbp
  80061a:	48 89 e5             	mov    %rsp,%rbp
  80061d:	48 83 ec 20          	sub    $0x20,%rsp
  800621:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800625:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800628:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80062c:	7e 4f                	jle    80067d <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  80062e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800632:	8b 00                	mov    (%rax),%eax
  800634:	83 f8 30             	cmp    $0x30,%eax
  800637:	73 24                	jae    80065d <getuint+0x44>
  800639:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800641:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800645:	8b 00                	mov    (%rax),%eax
  800647:	89 c0                	mov    %eax,%eax
  800649:	48 01 d0             	add    %rdx,%rax
  80064c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800650:	8b 12                	mov    (%rdx),%edx
  800652:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800655:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800659:	89 0a                	mov    %ecx,(%rdx)
  80065b:	eb 14                	jmp    800671 <getuint+0x58>
  80065d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800661:	48 8b 40 08          	mov    0x8(%rax),%rax
  800665:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800669:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800671:	48 8b 00             	mov    (%rax),%rax
  800674:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800678:	e9 9d 00 00 00       	jmpq   80071a <getuint+0x101>
	else if (lflag)
  80067d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800681:	74 4c                	je     8006cf <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800683:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800687:	8b 00                	mov    (%rax),%eax
  800689:	83 f8 30             	cmp    $0x30,%eax
  80068c:	73 24                	jae    8006b2 <getuint+0x99>
  80068e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800692:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800696:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069a:	8b 00                	mov    (%rax),%eax
  80069c:	89 c0                	mov    %eax,%eax
  80069e:	48 01 d0             	add    %rdx,%rax
  8006a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a5:	8b 12                	mov    (%rdx),%edx
  8006a7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ae:	89 0a                	mov    %ecx,(%rdx)
  8006b0:	eb 14                	jmp    8006c6 <getuint+0xad>
  8006b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006ba:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006c6:	48 8b 00             	mov    (%rax),%rax
  8006c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006cd:	eb 4b                	jmp    80071a <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8006cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d3:	8b 00                	mov    (%rax),%eax
  8006d5:	83 f8 30             	cmp    $0x30,%eax
  8006d8:	73 24                	jae    8006fe <getuint+0xe5>
  8006da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006de:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e6:	8b 00                	mov    (%rax),%eax
  8006e8:	89 c0                	mov    %eax,%eax
  8006ea:	48 01 d0             	add    %rdx,%rax
  8006ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f1:	8b 12                	mov    (%rdx),%edx
  8006f3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fa:	89 0a                	mov    %ecx,(%rdx)
  8006fc:	eb 14                	jmp    800712 <getuint+0xf9>
  8006fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800702:	48 8b 40 08          	mov    0x8(%rax),%rax
  800706:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80070a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800712:	8b 00                	mov    (%rax),%eax
  800714:	89 c0                	mov    %eax,%eax
  800716:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80071a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80071e:	c9                   	leaveq 
  80071f:	c3                   	retq   

0000000000800720 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800720:	55                   	push   %rbp
  800721:	48 89 e5             	mov    %rsp,%rbp
  800724:	48 83 ec 20          	sub    $0x20,%rsp
  800728:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80072c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80072f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800733:	7e 4f                	jle    800784 <getint+0x64>
		x=va_arg(*ap, long long);
  800735:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800739:	8b 00                	mov    (%rax),%eax
  80073b:	83 f8 30             	cmp    $0x30,%eax
  80073e:	73 24                	jae    800764 <getint+0x44>
  800740:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800744:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800748:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074c:	8b 00                	mov    (%rax),%eax
  80074e:	89 c0                	mov    %eax,%eax
  800750:	48 01 d0             	add    %rdx,%rax
  800753:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800757:	8b 12                	mov    (%rdx),%edx
  800759:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80075c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800760:	89 0a                	mov    %ecx,(%rdx)
  800762:	eb 14                	jmp    800778 <getint+0x58>
  800764:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800768:	48 8b 40 08          	mov    0x8(%rax),%rax
  80076c:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800770:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800774:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800778:	48 8b 00             	mov    (%rax),%rax
  80077b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80077f:	e9 9d 00 00 00       	jmpq   800821 <getint+0x101>
	else if (lflag)
  800784:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800788:	74 4c                	je     8007d6 <getint+0xb6>
		x=va_arg(*ap, long);
  80078a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078e:	8b 00                	mov    (%rax),%eax
  800790:	83 f8 30             	cmp    $0x30,%eax
  800793:	73 24                	jae    8007b9 <getint+0x99>
  800795:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800799:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80079d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a1:	8b 00                	mov    (%rax),%eax
  8007a3:	89 c0                	mov    %eax,%eax
  8007a5:	48 01 d0             	add    %rdx,%rax
  8007a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ac:	8b 12                	mov    (%rdx),%edx
  8007ae:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b5:	89 0a                	mov    %ecx,(%rdx)
  8007b7:	eb 14                	jmp    8007cd <getint+0xad>
  8007b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bd:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007c1:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007cd:	48 8b 00             	mov    (%rax),%rax
  8007d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007d4:	eb 4b                	jmp    800821 <getint+0x101>
	else
		x=va_arg(*ap, int);
  8007d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007da:	8b 00                	mov    (%rax),%eax
  8007dc:	83 f8 30             	cmp    $0x30,%eax
  8007df:	73 24                	jae    800805 <getint+0xe5>
  8007e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ed:	8b 00                	mov    (%rax),%eax
  8007ef:	89 c0                	mov    %eax,%eax
  8007f1:	48 01 d0             	add    %rdx,%rax
  8007f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f8:	8b 12                	mov    (%rdx),%edx
  8007fa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800801:	89 0a                	mov    %ecx,(%rdx)
  800803:	eb 14                	jmp    800819 <getint+0xf9>
  800805:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800809:	48 8b 40 08          	mov    0x8(%rax),%rax
  80080d:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800811:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800815:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800819:	8b 00                	mov    (%rax),%eax
  80081b:	48 98                	cltq   
  80081d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800821:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800825:	c9                   	leaveq 
  800826:	c3                   	retq   

0000000000800827 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800827:	55                   	push   %rbp
  800828:	48 89 e5             	mov    %rsp,%rbp
  80082b:	41 54                	push   %r12
  80082d:	53                   	push   %rbx
  80082e:	48 83 ec 60          	sub    $0x60,%rsp
  800832:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800836:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80083a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80083e:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800842:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800846:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80084a:	48 8b 0a             	mov    (%rdx),%rcx
  80084d:	48 89 08             	mov    %rcx,(%rax)
  800850:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800854:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800858:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80085c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800860:	eb 17                	jmp    800879 <vprintfmt+0x52>
			if (ch == '\0')
  800862:	85 db                	test   %ebx,%ebx
  800864:	0f 84 c5 04 00 00    	je     800d2f <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  80086a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80086e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800872:	48 89 d6             	mov    %rdx,%rsi
  800875:	89 df                	mov    %ebx,%edi
  800877:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800879:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80087d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800881:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800885:	0f b6 00             	movzbl (%rax),%eax
  800888:	0f b6 d8             	movzbl %al,%ebx
  80088b:	83 fb 25             	cmp    $0x25,%ebx
  80088e:	75 d2                	jne    800862 <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  800890:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800894:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80089b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008a2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008a9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008b0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008b4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008b8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008bc:	0f b6 00             	movzbl (%rax),%eax
  8008bf:	0f b6 d8             	movzbl %al,%ebx
  8008c2:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008c5:	83 f8 55             	cmp    $0x55,%eax
  8008c8:	0f 87 2e 04 00 00    	ja     800cfc <vprintfmt+0x4d5>
  8008ce:	89 c0                	mov    %eax,%eax
  8008d0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008d7:	00 
  8008d8:	48 b8 d8 41 80 00 00 	movabs $0x8041d8,%rax
  8008df:	00 00 00 
  8008e2:	48 01 d0             	add    %rdx,%rax
  8008e5:	48 8b 00             	mov    (%rax),%rax
  8008e8:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8008ea:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8008ee:	eb c0                	jmp    8008b0 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008f0:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8008f4:	eb ba                	jmp    8008b0 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008f6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8008fd:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800900:	89 d0                	mov    %edx,%eax
  800902:	c1 e0 02             	shl    $0x2,%eax
  800905:	01 d0                	add    %edx,%eax
  800907:	01 c0                	add    %eax,%eax
  800909:	01 d8                	add    %ebx,%eax
  80090b:	83 e8 30             	sub    $0x30,%eax
  80090e:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800911:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800915:	0f b6 00             	movzbl (%rax),%eax
  800918:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80091b:	83 fb 2f             	cmp    $0x2f,%ebx
  80091e:	7e 0c                	jle    80092c <vprintfmt+0x105>
  800920:	83 fb 39             	cmp    $0x39,%ebx
  800923:	7f 07                	jg     80092c <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  800925:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  80092a:	eb d1                	jmp    8008fd <vprintfmt+0xd6>
			goto process_precision;
  80092c:	eb 50                	jmp    80097e <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  80092e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800931:	83 f8 30             	cmp    $0x30,%eax
  800934:	73 17                	jae    80094d <vprintfmt+0x126>
  800936:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80093a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80093d:	89 d2                	mov    %edx,%edx
  80093f:	48 01 d0             	add    %rdx,%rax
  800942:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800945:	83 c2 08             	add    $0x8,%edx
  800948:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80094b:	eb 0c                	jmp    800959 <vprintfmt+0x132>
  80094d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800951:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800955:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800959:	8b 00                	mov    (%rax),%eax
  80095b:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80095e:	eb 1e                	jmp    80097e <vprintfmt+0x157>

		case '.':
			if (width < 0)
  800960:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800964:	79 07                	jns    80096d <vprintfmt+0x146>
				width = 0;
  800966:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80096d:	e9 3e ff ff ff       	jmpq   8008b0 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800972:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800979:	e9 32 ff ff ff       	jmpq   8008b0 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80097e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800982:	79 0d                	jns    800991 <vprintfmt+0x16a>
				width = precision, precision = -1;
  800984:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800987:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80098a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800991:	e9 1a ff ff ff       	jmpq   8008b0 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800996:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80099a:	e9 11 ff ff ff       	jmpq   8008b0 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80099f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a2:	83 f8 30             	cmp    $0x30,%eax
  8009a5:	73 17                	jae    8009be <vprintfmt+0x197>
  8009a7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8009ab:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009ae:	89 d2                	mov    %edx,%edx
  8009b0:	48 01 d0             	add    %rdx,%rax
  8009b3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009b6:	83 c2 08             	add    $0x8,%edx
  8009b9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009bc:	eb 0c                	jmp    8009ca <vprintfmt+0x1a3>
  8009be:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8009c2:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8009c6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009ca:	8b 10                	mov    (%rax),%edx
  8009cc:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009d0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009d4:	48 89 ce             	mov    %rcx,%rsi
  8009d7:	89 d7                	mov    %edx,%edi
  8009d9:	ff d0                	callq  *%rax
			break;
  8009db:	e9 4a 03 00 00       	jmpq   800d2a <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8009e0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e3:	83 f8 30             	cmp    $0x30,%eax
  8009e6:	73 17                	jae    8009ff <vprintfmt+0x1d8>
  8009e8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8009ec:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009ef:	89 d2                	mov    %edx,%edx
  8009f1:	48 01 d0             	add    %rdx,%rax
  8009f4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009f7:	83 c2 08             	add    $0x8,%edx
  8009fa:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009fd:	eb 0c                	jmp    800a0b <vprintfmt+0x1e4>
  8009ff:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a03:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a07:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a0b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a0d:	85 db                	test   %ebx,%ebx
  800a0f:	79 02                	jns    800a13 <vprintfmt+0x1ec>
				err = -err;
  800a11:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a13:	83 fb 15             	cmp    $0x15,%ebx
  800a16:	7f 16                	jg     800a2e <vprintfmt+0x207>
  800a18:	48 b8 00 41 80 00 00 	movabs $0x804100,%rax
  800a1f:	00 00 00 
  800a22:	48 63 d3             	movslq %ebx,%rdx
  800a25:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a29:	4d 85 e4             	test   %r12,%r12
  800a2c:	75 2e                	jne    800a5c <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  800a2e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a32:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a36:	89 d9                	mov    %ebx,%ecx
  800a38:	48 ba c1 41 80 00 00 	movabs $0x8041c1,%rdx
  800a3f:	00 00 00 
  800a42:	48 89 c7             	mov    %rax,%rdi
  800a45:	b8 00 00 00 00       	mov    $0x0,%eax
  800a4a:	49 b8 38 0d 80 00 00 	movabs $0x800d38,%r8
  800a51:	00 00 00 
  800a54:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a57:	e9 ce 02 00 00       	jmpq   800d2a <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  800a5c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a60:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a64:	4c 89 e1             	mov    %r12,%rcx
  800a67:	48 ba ca 41 80 00 00 	movabs $0x8041ca,%rdx
  800a6e:	00 00 00 
  800a71:	48 89 c7             	mov    %rax,%rdi
  800a74:	b8 00 00 00 00       	mov    $0x0,%eax
  800a79:	49 b8 38 0d 80 00 00 	movabs $0x800d38,%r8
  800a80:	00 00 00 
  800a83:	41 ff d0             	callq  *%r8
			break;
  800a86:	e9 9f 02 00 00       	jmpq   800d2a <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800a8b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a8e:	83 f8 30             	cmp    $0x30,%eax
  800a91:	73 17                	jae    800aaa <vprintfmt+0x283>
  800a93:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a97:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a9a:	89 d2                	mov    %edx,%edx
  800a9c:	48 01 d0             	add    %rdx,%rax
  800a9f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aa2:	83 c2 08             	add    $0x8,%edx
  800aa5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aa8:	eb 0c                	jmp    800ab6 <vprintfmt+0x28f>
  800aaa:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800aae:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ab2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ab6:	4c 8b 20             	mov    (%rax),%r12
  800ab9:	4d 85 e4             	test   %r12,%r12
  800abc:	75 0a                	jne    800ac8 <vprintfmt+0x2a1>
				p = "(null)";
  800abe:	49 bc cd 41 80 00 00 	movabs $0x8041cd,%r12
  800ac5:	00 00 00 
			if (width > 0 && padc != '-')
  800ac8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800acc:	7e 3f                	jle    800b0d <vprintfmt+0x2e6>
  800ace:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ad2:	74 39                	je     800b0d <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ad4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ad7:	48 98                	cltq   
  800ad9:	48 89 c6             	mov    %rax,%rsi
  800adc:	4c 89 e7             	mov    %r12,%rdi
  800adf:	48 b8 e4 0f 80 00 00 	movabs $0x800fe4,%rax
  800ae6:	00 00 00 
  800ae9:	ff d0                	callq  *%rax
  800aeb:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800aee:	eb 17                	jmp    800b07 <vprintfmt+0x2e0>
					putch(padc, putdat);
  800af0:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800af4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800af8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800afc:	48 89 ce             	mov    %rcx,%rsi
  800aff:	89 d7                	mov    %edx,%edi
  800b01:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  800b03:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b07:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b0b:	7f e3                	jg     800af0 <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b0d:	eb 37                	jmp    800b46 <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  800b0f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b13:	74 1e                	je     800b33 <vprintfmt+0x30c>
  800b15:	83 fb 1f             	cmp    $0x1f,%ebx
  800b18:	7e 05                	jle    800b1f <vprintfmt+0x2f8>
  800b1a:	83 fb 7e             	cmp    $0x7e,%ebx
  800b1d:	7e 14                	jle    800b33 <vprintfmt+0x30c>
					putch('?', putdat);
  800b1f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b23:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b27:	48 89 d6             	mov    %rdx,%rsi
  800b2a:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b2f:	ff d0                	callq  *%rax
  800b31:	eb 0f                	jmp    800b42 <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  800b33:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b37:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b3b:	48 89 d6             	mov    %rdx,%rsi
  800b3e:	89 df                	mov    %ebx,%edi
  800b40:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b42:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b46:	4c 89 e0             	mov    %r12,%rax
  800b49:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b4d:	0f b6 00             	movzbl (%rax),%eax
  800b50:	0f be d8             	movsbl %al,%ebx
  800b53:	85 db                	test   %ebx,%ebx
  800b55:	74 10                	je     800b67 <vprintfmt+0x340>
  800b57:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b5b:	78 b2                	js     800b0f <vprintfmt+0x2e8>
  800b5d:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b61:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b65:	79 a8                	jns    800b0f <vprintfmt+0x2e8>
			for (; width > 0; width--)
  800b67:	eb 16                	jmp    800b7f <vprintfmt+0x358>
				putch(' ', putdat);
  800b69:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b6d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b71:	48 89 d6             	mov    %rdx,%rsi
  800b74:	bf 20 00 00 00       	mov    $0x20,%edi
  800b79:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  800b7b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b7f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b83:	7f e4                	jg     800b69 <vprintfmt+0x342>
			break;
  800b85:	e9 a0 01 00 00       	jmpq   800d2a <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800b8a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b8e:	be 03 00 00 00       	mov    $0x3,%esi
  800b93:	48 89 c7             	mov    %rax,%rdi
  800b96:	48 b8 20 07 80 00 00 	movabs $0x800720,%rax
  800b9d:	00 00 00 
  800ba0:	ff d0                	callq  *%rax
  800ba2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ba6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800baa:	48 85 c0             	test   %rax,%rax
  800bad:	79 1d                	jns    800bcc <vprintfmt+0x3a5>
				putch('-', putdat);
  800baf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb7:	48 89 d6             	mov    %rdx,%rsi
  800bba:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bbf:	ff d0                	callq  *%rax
				num = -(long long) num;
  800bc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bc5:	48 f7 d8             	neg    %rax
  800bc8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bcc:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bd3:	e9 e5 00 00 00       	jmpq   800cbd <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800bd8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bdc:	be 03 00 00 00       	mov    $0x3,%esi
  800be1:	48 89 c7             	mov    %rax,%rdi
  800be4:	48 b8 19 06 80 00 00 	movabs $0x800619,%rax
  800beb:	00 00 00 
  800bee:	ff d0                	callq  *%rax
  800bf0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800bf4:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bfb:	e9 bd 00 00 00       	jmpq   800cbd <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c00:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c04:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c08:	48 89 d6             	mov    %rdx,%rsi
  800c0b:	bf 58 00 00 00       	mov    $0x58,%edi
  800c10:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c12:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c16:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1a:	48 89 d6             	mov    %rdx,%rsi
  800c1d:	bf 58 00 00 00       	mov    $0x58,%edi
  800c22:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c24:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c28:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c2c:	48 89 d6             	mov    %rdx,%rsi
  800c2f:	bf 58 00 00 00       	mov    $0x58,%edi
  800c34:	ff d0                	callq  *%rax
			break;
  800c36:	e9 ef 00 00 00       	jmpq   800d2a <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  800c3b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c3f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c43:	48 89 d6             	mov    %rdx,%rsi
  800c46:	bf 30 00 00 00       	mov    $0x30,%edi
  800c4b:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c4d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c51:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c55:	48 89 d6             	mov    %rdx,%rsi
  800c58:	bf 78 00 00 00       	mov    $0x78,%edi
  800c5d:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c5f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c62:	83 f8 30             	cmp    $0x30,%eax
  800c65:	73 17                	jae    800c7e <vprintfmt+0x457>
  800c67:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c6b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c6e:	89 d2                	mov    %edx,%edx
  800c70:	48 01 d0             	add    %rdx,%rax
  800c73:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c76:	83 c2 08             	add    $0x8,%edx
  800c79:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  800c7c:	eb 0c                	jmp    800c8a <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  800c7e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c82:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c86:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c8a:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  800c8d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c91:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c98:	eb 23                	jmp    800cbd <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800c9a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c9e:	be 03 00 00 00       	mov    $0x3,%esi
  800ca3:	48 89 c7             	mov    %rax,%rdi
  800ca6:	48 b8 19 06 80 00 00 	movabs $0x800619,%rax
  800cad:	00 00 00 
  800cb0:	ff d0                	callq  *%rax
  800cb2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cb6:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cbd:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cc2:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800cc5:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800cc8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ccc:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cd0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd4:	45 89 c1             	mov    %r8d,%r9d
  800cd7:	41 89 f8             	mov    %edi,%r8d
  800cda:	48 89 c7             	mov    %rax,%rdi
  800cdd:	48 b8 60 05 80 00 00 	movabs $0x800560,%rax
  800ce4:	00 00 00 
  800ce7:	ff d0                	callq  *%rax
			break;
  800ce9:	eb 3f                	jmp    800d2a <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ceb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cef:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf3:	48 89 d6             	mov    %rdx,%rsi
  800cf6:	89 df                	mov    %ebx,%edi
  800cf8:	ff d0                	callq  *%rax
			break;
  800cfa:	eb 2e                	jmp    800d2a <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cfc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d00:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d04:	48 89 d6             	mov    %rdx,%rsi
  800d07:	bf 25 00 00 00       	mov    $0x25,%edi
  800d0c:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d0e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d13:	eb 05                	jmp    800d1a <vprintfmt+0x4f3>
  800d15:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d1a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d1e:	48 83 e8 01          	sub    $0x1,%rax
  800d22:	0f b6 00             	movzbl (%rax),%eax
  800d25:	3c 25                	cmp    $0x25,%al
  800d27:	75 ec                	jne    800d15 <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  800d29:	90                   	nop
		}
	}
  800d2a:	e9 31 fb ff ff       	jmpq   800860 <vprintfmt+0x39>
	va_end(aq);
}
  800d2f:	48 83 c4 60          	add    $0x60,%rsp
  800d33:	5b                   	pop    %rbx
  800d34:	41 5c                	pop    %r12
  800d36:	5d                   	pop    %rbp
  800d37:	c3                   	retq   

0000000000800d38 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d38:	55                   	push   %rbp
  800d39:	48 89 e5             	mov    %rsp,%rbp
  800d3c:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d43:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d4a:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d51:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d58:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d5f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d66:	84 c0                	test   %al,%al
  800d68:	74 20                	je     800d8a <printfmt+0x52>
  800d6a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d6e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d72:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d76:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d7a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d7e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d82:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d86:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d8a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d91:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d98:	00 00 00 
  800d9b:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800da2:	00 00 00 
  800da5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800da9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800db0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800db7:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800dbe:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800dc5:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800dcc:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800dd3:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800dda:	48 89 c7             	mov    %rax,%rdi
  800ddd:	48 b8 27 08 80 00 00 	movabs $0x800827,%rax
  800de4:	00 00 00 
  800de7:	ff d0                	callq  *%rax
	va_end(ap);
}
  800de9:	c9                   	leaveq 
  800dea:	c3                   	retq   

0000000000800deb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800deb:	55                   	push   %rbp
  800dec:	48 89 e5             	mov    %rsp,%rbp
  800def:	48 83 ec 10          	sub    $0x10,%rsp
  800df3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800df6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800dfa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dfe:	8b 40 10             	mov    0x10(%rax),%eax
  800e01:	8d 50 01             	lea    0x1(%rax),%edx
  800e04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e08:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e0f:	48 8b 10             	mov    (%rax),%rdx
  800e12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e16:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e1a:	48 39 c2             	cmp    %rax,%rdx
  800e1d:	73 17                	jae    800e36 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e23:	48 8b 00             	mov    (%rax),%rax
  800e26:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e2a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e2e:	48 89 0a             	mov    %rcx,(%rdx)
  800e31:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e34:	88 10                	mov    %dl,(%rax)
}
  800e36:	c9                   	leaveq 
  800e37:	c3                   	retq   

0000000000800e38 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e38:	55                   	push   %rbp
  800e39:	48 89 e5             	mov    %rsp,%rbp
  800e3c:	48 83 ec 50          	sub    $0x50,%rsp
  800e40:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e44:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e47:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e4b:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e4f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e53:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e57:	48 8b 0a             	mov    (%rdx),%rcx
  800e5a:	48 89 08             	mov    %rcx,(%rax)
  800e5d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e61:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e65:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e69:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e6d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e71:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e75:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e78:	48 98                	cltq   
  800e7a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e7e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e82:	48 01 d0             	add    %rdx,%rax
  800e85:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e89:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e90:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800e95:	74 06                	je     800e9d <vsnprintf+0x65>
  800e97:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800e9b:	7f 07                	jg     800ea4 <vsnprintf+0x6c>
		return -E_INVAL;
  800e9d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ea2:	eb 2f                	jmp    800ed3 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ea4:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ea8:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800eac:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800eb0:	48 89 c6             	mov    %rax,%rsi
  800eb3:	48 bf eb 0d 80 00 00 	movabs $0x800deb,%rdi
  800eba:	00 00 00 
  800ebd:	48 b8 27 08 80 00 00 	movabs $0x800827,%rax
  800ec4:	00 00 00 
  800ec7:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ec9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ecd:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ed0:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ed3:	c9                   	leaveq 
  800ed4:	c3                   	retq   

0000000000800ed5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ed5:	55                   	push   %rbp
  800ed6:	48 89 e5             	mov    %rsp,%rbp
  800ed9:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800ee0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800ee7:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800eed:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ef4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800efb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f02:	84 c0                	test   %al,%al
  800f04:	74 20                	je     800f26 <snprintf+0x51>
  800f06:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f0a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f0e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f12:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f16:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f1a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f1e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f22:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f26:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f2d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f34:	00 00 00 
  800f37:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f3e:	00 00 00 
  800f41:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f45:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f4c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f53:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f5a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f61:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f68:	48 8b 0a             	mov    (%rdx),%rcx
  800f6b:	48 89 08             	mov    %rcx,(%rax)
  800f6e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f72:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f76:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f7a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f7e:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f85:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f8c:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f92:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f99:	48 89 c7             	mov    %rax,%rdi
  800f9c:	48 b8 38 0e 80 00 00 	movabs $0x800e38,%rax
  800fa3:	00 00 00 
  800fa6:	ff d0                	callq  *%rax
  800fa8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fae:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fb4:	c9                   	leaveq 
  800fb5:	c3                   	retq   

0000000000800fb6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fb6:	55                   	push   %rbp
  800fb7:	48 89 e5             	mov    %rsp,%rbp
  800fba:	48 83 ec 18          	sub    $0x18,%rsp
  800fbe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800fc2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fc9:	eb 09                	jmp    800fd4 <strlen+0x1e>
		n++;
  800fcb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  800fcf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd8:	0f b6 00             	movzbl (%rax),%eax
  800fdb:	84 c0                	test   %al,%al
  800fdd:	75 ec                	jne    800fcb <strlen+0x15>
	return n;
  800fdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fe2:	c9                   	leaveq 
  800fe3:	c3                   	retq   

0000000000800fe4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800fe4:	55                   	push   %rbp
  800fe5:	48 89 e5             	mov    %rsp,%rbp
  800fe8:	48 83 ec 20          	sub    $0x20,%rsp
  800fec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ff0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ff4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ffb:	eb 0e                	jmp    80100b <strnlen+0x27>
		n++;
  800ffd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801001:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801006:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80100b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801010:	74 0b                	je     80101d <strnlen+0x39>
  801012:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801016:	0f b6 00             	movzbl (%rax),%eax
  801019:	84 c0                	test   %al,%al
  80101b:	75 e0                	jne    800ffd <strnlen+0x19>
	return n;
  80101d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801020:	c9                   	leaveq 
  801021:	c3                   	retq   

0000000000801022 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801022:	55                   	push   %rbp
  801023:	48 89 e5             	mov    %rsp,%rbp
  801026:	48 83 ec 20          	sub    $0x20,%rsp
  80102a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80102e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801032:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801036:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80103a:	90                   	nop
  80103b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801043:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801047:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80104b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80104f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801053:	0f b6 12             	movzbl (%rdx),%edx
  801056:	88 10                	mov    %dl,(%rax)
  801058:	0f b6 00             	movzbl (%rax),%eax
  80105b:	84 c0                	test   %al,%al
  80105d:	75 dc                	jne    80103b <strcpy+0x19>
		/* do nothing */;
	return ret;
  80105f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801063:	c9                   	leaveq 
  801064:	c3                   	retq   

0000000000801065 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801065:	55                   	push   %rbp
  801066:	48 89 e5             	mov    %rsp,%rbp
  801069:	48 83 ec 20          	sub    $0x20,%rsp
  80106d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801071:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801075:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801079:	48 89 c7             	mov    %rax,%rdi
  80107c:	48 b8 b6 0f 80 00 00 	movabs $0x800fb6,%rax
  801083:	00 00 00 
  801086:	ff d0                	callq  *%rax
  801088:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80108b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80108e:	48 63 d0             	movslq %eax,%rdx
  801091:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801095:	48 01 c2             	add    %rax,%rdx
  801098:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80109c:	48 89 c6             	mov    %rax,%rsi
  80109f:	48 89 d7             	mov    %rdx,%rdi
  8010a2:	48 b8 22 10 80 00 00 	movabs $0x801022,%rax
  8010a9:	00 00 00 
  8010ac:	ff d0                	callq  *%rax
	return dst;
  8010ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010b2:	c9                   	leaveq 
  8010b3:	c3                   	retq   

00000000008010b4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010b4:	55                   	push   %rbp
  8010b5:	48 89 e5             	mov    %rsp,%rbp
  8010b8:	48 83 ec 28          	sub    $0x28,%rsp
  8010bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010c4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010cc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010d0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010d7:	00 
  8010d8:	eb 2a                	jmp    801104 <strncpy+0x50>
		*dst++ = *src;
  8010da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010de:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010e2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010e6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010ea:	0f b6 12             	movzbl (%rdx),%edx
  8010ed:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010f3:	0f b6 00             	movzbl (%rax),%eax
  8010f6:	84 c0                	test   %al,%al
  8010f8:	74 05                	je     8010ff <strncpy+0x4b>
			src++;
  8010fa:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  8010ff:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801104:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801108:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80110c:	72 cc                	jb     8010da <strncpy+0x26>
	}
	return ret;
  80110e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801112:	c9                   	leaveq 
  801113:	c3                   	retq   

0000000000801114 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801114:	55                   	push   %rbp
  801115:	48 89 e5             	mov    %rsp,%rbp
  801118:	48 83 ec 28          	sub    $0x28,%rsp
  80111c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801120:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801124:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801128:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801130:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801135:	74 3d                	je     801174 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801137:	eb 1d                	jmp    801156 <strlcpy+0x42>
			*dst++ = *src++;
  801139:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801141:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801145:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801149:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80114d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801151:	0f b6 12             	movzbl (%rdx),%edx
  801154:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  801156:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80115b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801160:	74 0b                	je     80116d <strlcpy+0x59>
  801162:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801166:	0f b6 00             	movzbl (%rax),%eax
  801169:	84 c0                	test   %al,%al
  80116b:	75 cc                	jne    801139 <strlcpy+0x25>
		*dst = '\0';
  80116d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801171:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801174:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801178:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80117c:	48 29 c2             	sub    %rax,%rdx
  80117f:	48 89 d0             	mov    %rdx,%rax
}
  801182:	c9                   	leaveq 
  801183:	c3                   	retq   

0000000000801184 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801184:	55                   	push   %rbp
  801185:	48 89 e5             	mov    %rsp,%rbp
  801188:	48 83 ec 10          	sub    $0x10,%rsp
  80118c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801190:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801194:	eb 0a                	jmp    8011a0 <strcmp+0x1c>
		p++, q++;
  801196:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80119b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  8011a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a4:	0f b6 00             	movzbl (%rax),%eax
  8011a7:	84 c0                	test   %al,%al
  8011a9:	74 12                	je     8011bd <strcmp+0x39>
  8011ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011af:	0f b6 10             	movzbl (%rax),%edx
  8011b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b6:	0f b6 00             	movzbl (%rax),%eax
  8011b9:	38 c2                	cmp    %al,%dl
  8011bb:	74 d9                	je     801196 <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c1:	0f b6 00             	movzbl (%rax),%eax
  8011c4:	0f b6 d0             	movzbl %al,%edx
  8011c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011cb:	0f b6 00             	movzbl (%rax),%eax
  8011ce:	0f b6 c0             	movzbl %al,%eax
  8011d1:	29 c2                	sub    %eax,%edx
  8011d3:	89 d0                	mov    %edx,%eax
}
  8011d5:	c9                   	leaveq 
  8011d6:	c3                   	retq   

00000000008011d7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011d7:	55                   	push   %rbp
  8011d8:	48 89 e5             	mov    %rsp,%rbp
  8011db:	48 83 ec 18          	sub    $0x18,%rsp
  8011df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8011e7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8011eb:	eb 0f                	jmp    8011fc <strncmp+0x25>
		n--, p++, q++;
  8011ed:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8011f2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011f7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  8011fc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801201:	74 1d                	je     801220 <strncmp+0x49>
  801203:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801207:	0f b6 00             	movzbl (%rax),%eax
  80120a:	84 c0                	test   %al,%al
  80120c:	74 12                	je     801220 <strncmp+0x49>
  80120e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801212:	0f b6 10             	movzbl (%rax),%edx
  801215:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801219:	0f b6 00             	movzbl (%rax),%eax
  80121c:	38 c2                	cmp    %al,%dl
  80121e:	74 cd                	je     8011ed <strncmp+0x16>
	if (n == 0)
  801220:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801225:	75 07                	jne    80122e <strncmp+0x57>
		return 0;
  801227:	b8 00 00 00 00       	mov    $0x0,%eax
  80122c:	eb 18                	jmp    801246 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80122e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801232:	0f b6 00             	movzbl (%rax),%eax
  801235:	0f b6 d0             	movzbl %al,%edx
  801238:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80123c:	0f b6 00             	movzbl (%rax),%eax
  80123f:	0f b6 c0             	movzbl %al,%eax
  801242:	29 c2                	sub    %eax,%edx
  801244:	89 d0                	mov    %edx,%eax
}
  801246:	c9                   	leaveq 
  801247:	c3                   	retq   

0000000000801248 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801248:	55                   	push   %rbp
  801249:	48 89 e5             	mov    %rsp,%rbp
  80124c:	48 83 ec 10          	sub    $0x10,%rsp
  801250:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801254:	89 f0                	mov    %esi,%eax
  801256:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801259:	eb 17                	jmp    801272 <strchr+0x2a>
		if (*s == c)
  80125b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125f:	0f b6 00             	movzbl (%rax),%eax
  801262:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801265:	75 06                	jne    80126d <strchr+0x25>
			return (char *) s;
  801267:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126b:	eb 15                	jmp    801282 <strchr+0x3a>
	for (; *s; s++)
  80126d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801272:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801276:	0f b6 00             	movzbl (%rax),%eax
  801279:	84 c0                	test   %al,%al
  80127b:	75 de                	jne    80125b <strchr+0x13>
	return 0;
  80127d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801282:	c9                   	leaveq 
  801283:	c3                   	retq   

0000000000801284 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801284:	55                   	push   %rbp
  801285:	48 89 e5             	mov    %rsp,%rbp
  801288:	48 83 ec 10          	sub    $0x10,%rsp
  80128c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801290:	89 f0                	mov    %esi,%eax
  801292:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801295:	eb 13                	jmp    8012aa <strfind+0x26>
		if (*s == c)
  801297:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129b:	0f b6 00             	movzbl (%rax),%eax
  80129e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012a1:	75 02                	jne    8012a5 <strfind+0x21>
			break;
  8012a3:	eb 10                	jmp    8012b5 <strfind+0x31>
	for (; *s; s++)
  8012a5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ae:	0f b6 00             	movzbl (%rax),%eax
  8012b1:	84 c0                	test   %al,%al
  8012b3:	75 e2                	jne    801297 <strfind+0x13>
	return (char *) s;
  8012b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012b9:	c9                   	leaveq 
  8012ba:	c3                   	retq   

00000000008012bb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012bb:	55                   	push   %rbp
  8012bc:	48 89 e5             	mov    %rsp,%rbp
  8012bf:	48 83 ec 18          	sub    $0x18,%rsp
  8012c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012c7:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012ca:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012ce:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012d3:	75 06                	jne    8012db <memset+0x20>
		return v;
  8012d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d9:	eb 69                	jmp    801344 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012df:	83 e0 03             	and    $0x3,%eax
  8012e2:	48 85 c0             	test   %rax,%rax
  8012e5:	75 48                	jne    80132f <memset+0x74>
  8012e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012eb:	83 e0 03             	and    $0x3,%eax
  8012ee:	48 85 c0             	test   %rax,%rax
  8012f1:	75 3c                	jne    80132f <memset+0x74>
		c &= 0xFF;
  8012f3:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8012fa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012fd:	c1 e0 18             	shl    $0x18,%eax
  801300:	89 c2                	mov    %eax,%edx
  801302:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801305:	c1 e0 10             	shl    $0x10,%eax
  801308:	09 c2                	or     %eax,%edx
  80130a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80130d:	c1 e0 08             	shl    $0x8,%eax
  801310:	09 d0                	or     %edx,%eax
  801312:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801315:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801319:	48 c1 e8 02          	shr    $0x2,%rax
  80131d:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  801320:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801324:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801327:	48 89 d7             	mov    %rdx,%rdi
  80132a:	fc                   	cld    
  80132b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80132d:	eb 11                	jmp    801340 <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80132f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801333:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801336:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80133a:	48 89 d7             	mov    %rdx,%rdi
  80133d:	fc                   	cld    
  80133e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801340:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801344:	c9                   	leaveq 
  801345:	c3                   	retq   

0000000000801346 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801346:	55                   	push   %rbp
  801347:	48 89 e5             	mov    %rsp,%rbp
  80134a:	48 83 ec 28          	sub    $0x28,%rsp
  80134e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801352:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801356:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80135a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80135e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801362:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801366:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80136a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801372:	0f 83 88 00 00 00    	jae    801400 <memmove+0xba>
  801378:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80137c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801380:	48 01 d0             	add    %rdx,%rax
  801383:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801387:	76 77                	jbe    801400 <memmove+0xba>
		s += n;
  801389:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801391:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801395:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801399:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139d:	83 e0 03             	and    $0x3,%eax
  8013a0:	48 85 c0             	test   %rax,%rax
  8013a3:	75 3b                	jne    8013e0 <memmove+0x9a>
  8013a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a9:	83 e0 03             	and    $0x3,%eax
  8013ac:	48 85 c0             	test   %rax,%rax
  8013af:	75 2f                	jne    8013e0 <memmove+0x9a>
  8013b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b5:	83 e0 03             	and    $0x3,%eax
  8013b8:	48 85 c0             	test   %rax,%rax
  8013bb:	75 23                	jne    8013e0 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c1:	48 83 e8 04          	sub    $0x4,%rax
  8013c5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013c9:	48 83 ea 04          	sub    $0x4,%rdx
  8013cd:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013d1:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  8013d5:	48 89 c7             	mov    %rax,%rdi
  8013d8:	48 89 d6             	mov    %rdx,%rsi
  8013db:	fd                   	std    
  8013dc:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013de:	eb 1d                	jmp    8013fd <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ec:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  8013f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f4:	48 89 d7             	mov    %rdx,%rdi
  8013f7:	48 89 c1             	mov    %rax,%rcx
  8013fa:	fd                   	std    
  8013fb:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8013fd:	fc                   	cld    
  8013fe:	eb 57                	jmp    801457 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801400:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801404:	83 e0 03             	and    $0x3,%eax
  801407:	48 85 c0             	test   %rax,%rax
  80140a:	75 36                	jne    801442 <memmove+0xfc>
  80140c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801410:	83 e0 03             	and    $0x3,%eax
  801413:	48 85 c0             	test   %rax,%rax
  801416:	75 2a                	jne    801442 <memmove+0xfc>
  801418:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80141c:	83 e0 03             	and    $0x3,%eax
  80141f:	48 85 c0             	test   %rax,%rax
  801422:	75 1e                	jne    801442 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801424:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801428:	48 c1 e8 02          	shr    $0x2,%rax
  80142c:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  80142f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801433:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801437:	48 89 c7             	mov    %rax,%rdi
  80143a:	48 89 d6             	mov    %rdx,%rsi
  80143d:	fc                   	cld    
  80143e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801440:	eb 15                	jmp    801457 <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  801442:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801446:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80144a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80144e:	48 89 c7             	mov    %rax,%rdi
  801451:	48 89 d6             	mov    %rdx,%rsi
  801454:	fc                   	cld    
  801455:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801457:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80145b:	c9                   	leaveq 
  80145c:	c3                   	retq   

000000000080145d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80145d:	55                   	push   %rbp
  80145e:	48 89 e5             	mov    %rsp,%rbp
  801461:	48 83 ec 18          	sub    $0x18,%rsp
  801465:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801469:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80146d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801471:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801475:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801479:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147d:	48 89 ce             	mov    %rcx,%rsi
  801480:	48 89 c7             	mov    %rax,%rdi
  801483:	48 b8 46 13 80 00 00 	movabs $0x801346,%rax
  80148a:	00 00 00 
  80148d:	ff d0                	callq  *%rax
}
  80148f:	c9                   	leaveq 
  801490:	c3                   	retq   

0000000000801491 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801491:	55                   	push   %rbp
  801492:	48 89 e5             	mov    %rsp,%rbp
  801495:	48 83 ec 28          	sub    $0x28,%rsp
  801499:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80149d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014b1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014b5:	eb 36                	jmp    8014ed <memcmp+0x5c>
		if (*s1 != *s2)
  8014b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014bb:	0f b6 10             	movzbl (%rax),%edx
  8014be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c2:	0f b6 00             	movzbl (%rax),%eax
  8014c5:	38 c2                	cmp    %al,%dl
  8014c7:	74 1a                	je     8014e3 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014cd:	0f b6 00             	movzbl (%rax),%eax
  8014d0:	0f b6 d0             	movzbl %al,%edx
  8014d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d7:	0f b6 00             	movzbl (%rax),%eax
  8014da:	0f b6 c0             	movzbl %al,%eax
  8014dd:	29 c2                	sub    %eax,%edx
  8014df:	89 d0                	mov    %edx,%eax
  8014e1:	eb 20                	jmp    801503 <memcmp+0x72>
		s1++, s2++;
  8014e3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014e8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  8014ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014f5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8014f9:	48 85 c0             	test   %rax,%rax
  8014fc:	75 b9                	jne    8014b7 <memcmp+0x26>
	}

	return 0;
  8014fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801503:	c9                   	leaveq 
  801504:	c3                   	retq   

0000000000801505 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801505:	55                   	push   %rbp
  801506:	48 89 e5             	mov    %rsp,%rbp
  801509:	48 83 ec 28          	sub    $0x28,%rsp
  80150d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801511:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801514:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801518:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80151c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801520:	48 01 d0             	add    %rdx,%rax
  801523:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801527:	eb 15                	jmp    80153e <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801529:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80152d:	0f b6 00             	movzbl (%rax),%eax
  801530:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801533:	38 d0                	cmp    %dl,%al
  801535:	75 02                	jne    801539 <memfind+0x34>
			break;
  801537:	eb 0f                	jmp    801548 <memfind+0x43>
	for (; s < ends; s++)
  801539:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80153e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801542:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801546:	72 e1                	jb     801529 <memfind+0x24>
	return (void *) s;
  801548:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80154c:	c9                   	leaveq 
  80154d:	c3                   	retq   

000000000080154e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80154e:	55                   	push   %rbp
  80154f:	48 89 e5             	mov    %rsp,%rbp
  801552:	48 83 ec 38          	sub    $0x38,%rsp
  801556:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80155a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80155e:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801561:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801568:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80156f:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801570:	eb 05                	jmp    801577 <strtol+0x29>
		s++;
  801572:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  801577:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157b:	0f b6 00             	movzbl (%rax),%eax
  80157e:	3c 20                	cmp    $0x20,%al
  801580:	74 f0                	je     801572 <strtol+0x24>
  801582:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801586:	0f b6 00             	movzbl (%rax),%eax
  801589:	3c 09                	cmp    $0x9,%al
  80158b:	74 e5                	je     801572 <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  80158d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801591:	0f b6 00             	movzbl (%rax),%eax
  801594:	3c 2b                	cmp    $0x2b,%al
  801596:	75 07                	jne    80159f <strtol+0x51>
		s++;
  801598:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80159d:	eb 17                	jmp    8015b6 <strtol+0x68>
	else if (*s == '-')
  80159f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a3:	0f b6 00             	movzbl (%rax),%eax
  8015a6:	3c 2d                	cmp    $0x2d,%al
  8015a8:	75 0c                	jne    8015b6 <strtol+0x68>
		s++, neg = 1;
  8015aa:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015af:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015b6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015ba:	74 06                	je     8015c2 <strtol+0x74>
  8015bc:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015c0:	75 28                	jne    8015ea <strtol+0x9c>
  8015c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c6:	0f b6 00             	movzbl (%rax),%eax
  8015c9:	3c 30                	cmp    $0x30,%al
  8015cb:	75 1d                	jne    8015ea <strtol+0x9c>
  8015cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d1:	48 83 c0 01          	add    $0x1,%rax
  8015d5:	0f b6 00             	movzbl (%rax),%eax
  8015d8:	3c 78                	cmp    $0x78,%al
  8015da:	75 0e                	jne    8015ea <strtol+0x9c>
		s += 2, base = 16;
  8015dc:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8015e1:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8015e8:	eb 2c                	jmp    801616 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8015ea:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015ee:	75 19                	jne    801609 <strtol+0xbb>
  8015f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f4:	0f b6 00             	movzbl (%rax),%eax
  8015f7:	3c 30                	cmp    $0x30,%al
  8015f9:	75 0e                	jne    801609 <strtol+0xbb>
		s++, base = 8;
  8015fb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801600:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801607:	eb 0d                	jmp    801616 <strtol+0xc8>
	else if (base == 0)
  801609:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80160d:	75 07                	jne    801616 <strtol+0xc8>
		base = 10;
  80160f:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801616:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161a:	0f b6 00             	movzbl (%rax),%eax
  80161d:	3c 2f                	cmp    $0x2f,%al
  80161f:	7e 1d                	jle    80163e <strtol+0xf0>
  801621:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801625:	0f b6 00             	movzbl (%rax),%eax
  801628:	3c 39                	cmp    $0x39,%al
  80162a:	7f 12                	jg     80163e <strtol+0xf0>
			dig = *s - '0';
  80162c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801630:	0f b6 00             	movzbl (%rax),%eax
  801633:	0f be c0             	movsbl %al,%eax
  801636:	83 e8 30             	sub    $0x30,%eax
  801639:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80163c:	eb 4e                	jmp    80168c <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80163e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801642:	0f b6 00             	movzbl (%rax),%eax
  801645:	3c 60                	cmp    $0x60,%al
  801647:	7e 1d                	jle    801666 <strtol+0x118>
  801649:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164d:	0f b6 00             	movzbl (%rax),%eax
  801650:	3c 7a                	cmp    $0x7a,%al
  801652:	7f 12                	jg     801666 <strtol+0x118>
			dig = *s - 'a' + 10;
  801654:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801658:	0f b6 00             	movzbl (%rax),%eax
  80165b:	0f be c0             	movsbl %al,%eax
  80165e:	83 e8 57             	sub    $0x57,%eax
  801661:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801664:	eb 26                	jmp    80168c <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801666:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166a:	0f b6 00             	movzbl (%rax),%eax
  80166d:	3c 40                	cmp    $0x40,%al
  80166f:	7e 48                	jle    8016b9 <strtol+0x16b>
  801671:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801675:	0f b6 00             	movzbl (%rax),%eax
  801678:	3c 5a                	cmp    $0x5a,%al
  80167a:	7f 3d                	jg     8016b9 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80167c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801680:	0f b6 00             	movzbl (%rax),%eax
  801683:	0f be c0             	movsbl %al,%eax
  801686:	83 e8 37             	sub    $0x37,%eax
  801689:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80168c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80168f:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801692:	7c 02                	jl     801696 <strtol+0x148>
			break;
  801694:	eb 23                	jmp    8016b9 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801696:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80169b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80169e:	48 98                	cltq   
  8016a0:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016a5:	48 89 c2             	mov    %rax,%rdx
  8016a8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016ab:	48 98                	cltq   
  8016ad:	48 01 d0             	add    %rdx,%rax
  8016b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016b4:	e9 5d ff ff ff       	jmpq   801616 <strtol+0xc8>

	if (endptr)
  8016b9:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016be:	74 0b                	je     8016cb <strtol+0x17d>
		*endptr = (char *) s;
  8016c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016c4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016c8:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016cf:	74 09                	je     8016da <strtol+0x18c>
  8016d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d5:	48 f7 d8             	neg    %rax
  8016d8:	eb 04                	jmp    8016de <strtol+0x190>
  8016da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016de:	c9                   	leaveq 
  8016df:	c3                   	retq   

00000000008016e0 <strstr>:

char * strstr(const char *in, const char *str)
{
  8016e0:	55                   	push   %rbp
  8016e1:	48 89 e5             	mov    %rsp,%rbp
  8016e4:	48 83 ec 30          	sub    $0x30,%rsp
  8016e8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016ec:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8016f0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016f4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016f8:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016fc:	0f b6 00             	movzbl (%rax),%eax
  8016ff:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801702:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801706:	75 06                	jne    80170e <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801708:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170c:	eb 6b                	jmp    801779 <strstr+0x99>

	len = strlen(str);
  80170e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801712:	48 89 c7             	mov    %rax,%rdi
  801715:	48 b8 b6 0f 80 00 00 	movabs $0x800fb6,%rax
  80171c:	00 00 00 
  80171f:	ff d0                	callq  *%rax
  801721:	48 98                	cltq   
  801723:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801727:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80172f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801733:	0f b6 00             	movzbl (%rax),%eax
  801736:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801739:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80173d:	75 07                	jne    801746 <strstr+0x66>
				return (char *) 0;
  80173f:	b8 00 00 00 00       	mov    $0x0,%eax
  801744:	eb 33                	jmp    801779 <strstr+0x99>
		} while (sc != c);
  801746:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80174a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80174d:	75 d8                	jne    801727 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80174f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801753:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801757:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175b:	48 89 ce             	mov    %rcx,%rsi
  80175e:	48 89 c7             	mov    %rax,%rdi
  801761:	48 b8 d7 11 80 00 00 	movabs $0x8011d7,%rax
  801768:	00 00 00 
  80176b:	ff d0                	callq  *%rax
  80176d:	85 c0                	test   %eax,%eax
  80176f:	75 b6                	jne    801727 <strstr+0x47>

	return (char *) (in - 1);
  801771:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801775:	48 83 e8 01          	sub    $0x1,%rax
}
  801779:	c9                   	leaveq 
  80177a:	c3                   	retq   

000000000080177b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80177b:	55                   	push   %rbp
  80177c:	48 89 e5             	mov    %rsp,%rbp
  80177f:	53                   	push   %rbx
  801780:	48 83 ec 48          	sub    $0x48,%rsp
  801784:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801787:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80178a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80178e:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801792:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801796:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80179a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80179d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017a1:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017a5:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017a9:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017ad:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017b1:	4c 89 c3             	mov    %r8,%rbx
  8017b4:	cd 30                	int    $0x30
  8017b6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017ba:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017be:	74 3e                	je     8017fe <syscall+0x83>
  8017c0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017c5:	7e 37                	jle    8017fe <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017cb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017ce:	49 89 d0             	mov    %rdx,%r8
  8017d1:	89 c1                	mov    %eax,%ecx
  8017d3:	48 ba 88 44 80 00 00 	movabs $0x804488,%rdx
  8017da:	00 00 00 
  8017dd:	be 23 00 00 00       	mov    $0x23,%esi
  8017e2:	48 bf a5 44 80 00 00 	movabs $0x8044a5,%rdi
  8017e9:	00 00 00 
  8017ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f1:	49 b9 4f 02 80 00 00 	movabs $0x80024f,%r9
  8017f8:	00 00 00 
  8017fb:	41 ff d1             	callq  *%r9

	return ret;
  8017fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801802:	48 83 c4 48          	add    $0x48,%rsp
  801806:	5b                   	pop    %rbx
  801807:	5d                   	pop    %rbp
  801808:	c3                   	retq   

0000000000801809 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801809:	55                   	push   %rbp
  80180a:	48 89 e5             	mov    %rsp,%rbp
  80180d:	48 83 ec 10          	sub    $0x10,%rsp
  801811:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801815:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801819:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80181d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801821:	48 83 ec 08          	sub    $0x8,%rsp
  801825:	6a 00                	pushq  $0x0
  801827:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80182d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801833:	48 89 d1             	mov    %rdx,%rcx
  801836:	48 89 c2             	mov    %rax,%rdx
  801839:	be 00 00 00 00       	mov    $0x0,%esi
  80183e:	bf 00 00 00 00       	mov    $0x0,%edi
  801843:	48 b8 7b 17 80 00 00 	movabs $0x80177b,%rax
  80184a:	00 00 00 
  80184d:	ff d0                	callq  *%rax
  80184f:	48 83 c4 10          	add    $0x10,%rsp
}
  801853:	c9                   	leaveq 
  801854:	c3                   	retq   

0000000000801855 <sys_cgetc>:

int
sys_cgetc(void)
{
  801855:	55                   	push   %rbp
  801856:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801859:	48 83 ec 08          	sub    $0x8,%rsp
  80185d:	6a 00                	pushq  $0x0
  80185f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801865:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80186b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801870:	ba 00 00 00 00       	mov    $0x0,%edx
  801875:	be 00 00 00 00       	mov    $0x0,%esi
  80187a:	bf 01 00 00 00       	mov    $0x1,%edi
  80187f:	48 b8 7b 17 80 00 00 	movabs $0x80177b,%rax
  801886:	00 00 00 
  801889:	ff d0                	callq  *%rax
  80188b:	48 83 c4 10          	add    $0x10,%rsp
}
  80188f:	c9                   	leaveq 
  801890:	c3                   	retq   

0000000000801891 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801891:	55                   	push   %rbp
  801892:	48 89 e5             	mov    %rsp,%rbp
  801895:	48 83 ec 10          	sub    $0x10,%rsp
  801899:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80189c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80189f:	48 98                	cltq   
  8018a1:	48 83 ec 08          	sub    $0x8,%rsp
  8018a5:	6a 00                	pushq  $0x0
  8018a7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ad:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018b3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018b8:	48 89 c2             	mov    %rax,%rdx
  8018bb:	be 01 00 00 00       	mov    $0x1,%esi
  8018c0:	bf 03 00 00 00       	mov    $0x3,%edi
  8018c5:	48 b8 7b 17 80 00 00 	movabs $0x80177b,%rax
  8018cc:	00 00 00 
  8018cf:	ff d0                	callq  *%rax
  8018d1:	48 83 c4 10          	add    $0x10,%rsp
}
  8018d5:	c9                   	leaveq 
  8018d6:	c3                   	retq   

00000000008018d7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018d7:	55                   	push   %rbp
  8018d8:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018db:	48 83 ec 08          	sub    $0x8,%rsp
  8018df:	6a 00                	pushq  $0x0
  8018e1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018e7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f7:	be 00 00 00 00       	mov    $0x0,%esi
  8018fc:	bf 02 00 00 00       	mov    $0x2,%edi
  801901:	48 b8 7b 17 80 00 00 	movabs $0x80177b,%rax
  801908:	00 00 00 
  80190b:	ff d0                	callq  *%rax
  80190d:	48 83 c4 10          	add    $0x10,%rsp
}
  801911:	c9                   	leaveq 
  801912:	c3                   	retq   

0000000000801913 <sys_yield>:

void
sys_yield(void)
{
  801913:	55                   	push   %rbp
  801914:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801917:	48 83 ec 08          	sub    $0x8,%rsp
  80191b:	6a 00                	pushq  $0x0
  80191d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801923:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801929:	b9 00 00 00 00       	mov    $0x0,%ecx
  80192e:	ba 00 00 00 00       	mov    $0x0,%edx
  801933:	be 00 00 00 00       	mov    $0x0,%esi
  801938:	bf 0b 00 00 00       	mov    $0xb,%edi
  80193d:	48 b8 7b 17 80 00 00 	movabs $0x80177b,%rax
  801944:	00 00 00 
  801947:	ff d0                	callq  *%rax
  801949:	48 83 c4 10          	add    $0x10,%rsp
}
  80194d:	c9                   	leaveq 
  80194e:	c3                   	retq   

000000000080194f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80194f:	55                   	push   %rbp
  801950:	48 89 e5             	mov    %rsp,%rbp
  801953:	48 83 ec 10          	sub    $0x10,%rsp
  801957:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80195a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80195e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801961:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801964:	48 63 c8             	movslq %eax,%rcx
  801967:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80196b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80196e:	48 98                	cltq   
  801970:	48 83 ec 08          	sub    $0x8,%rsp
  801974:	6a 00                	pushq  $0x0
  801976:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80197c:	49 89 c8             	mov    %rcx,%r8
  80197f:	48 89 d1             	mov    %rdx,%rcx
  801982:	48 89 c2             	mov    %rax,%rdx
  801985:	be 01 00 00 00       	mov    $0x1,%esi
  80198a:	bf 04 00 00 00       	mov    $0x4,%edi
  80198f:	48 b8 7b 17 80 00 00 	movabs $0x80177b,%rax
  801996:	00 00 00 
  801999:	ff d0                	callq  *%rax
  80199b:	48 83 c4 10          	add    $0x10,%rsp
}
  80199f:	c9                   	leaveq 
  8019a0:	c3                   	retq   

00000000008019a1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019a1:	55                   	push   %rbp
  8019a2:	48 89 e5             	mov    %rsp,%rbp
  8019a5:	48 83 ec 20          	sub    $0x20,%rsp
  8019a9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019ac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019b0:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019b3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019b7:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019bb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019be:	48 63 c8             	movslq %eax,%rcx
  8019c1:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019c5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019c8:	48 63 f0             	movslq %eax,%rsi
  8019cb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019d2:	48 98                	cltq   
  8019d4:	48 83 ec 08          	sub    $0x8,%rsp
  8019d8:	51                   	push   %rcx
  8019d9:	49 89 f9             	mov    %rdi,%r9
  8019dc:	49 89 f0             	mov    %rsi,%r8
  8019df:	48 89 d1             	mov    %rdx,%rcx
  8019e2:	48 89 c2             	mov    %rax,%rdx
  8019e5:	be 01 00 00 00       	mov    $0x1,%esi
  8019ea:	bf 05 00 00 00       	mov    $0x5,%edi
  8019ef:	48 b8 7b 17 80 00 00 	movabs $0x80177b,%rax
  8019f6:	00 00 00 
  8019f9:	ff d0                	callq  *%rax
  8019fb:	48 83 c4 10          	add    $0x10,%rsp
}
  8019ff:	c9                   	leaveq 
  801a00:	c3                   	retq   

0000000000801a01 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a01:	55                   	push   %rbp
  801a02:	48 89 e5             	mov    %rsp,%rbp
  801a05:	48 83 ec 10          	sub    $0x10,%rsp
  801a09:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a0c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a10:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a17:	48 98                	cltq   
  801a19:	48 83 ec 08          	sub    $0x8,%rsp
  801a1d:	6a 00                	pushq  $0x0
  801a1f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a25:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a2b:	48 89 d1             	mov    %rdx,%rcx
  801a2e:	48 89 c2             	mov    %rax,%rdx
  801a31:	be 01 00 00 00       	mov    $0x1,%esi
  801a36:	bf 06 00 00 00       	mov    $0x6,%edi
  801a3b:	48 b8 7b 17 80 00 00 	movabs $0x80177b,%rax
  801a42:	00 00 00 
  801a45:	ff d0                	callq  *%rax
  801a47:	48 83 c4 10          	add    $0x10,%rsp
}
  801a4b:	c9                   	leaveq 
  801a4c:	c3                   	retq   

0000000000801a4d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a4d:	55                   	push   %rbp
  801a4e:	48 89 e5             	mov    %rsp,%rbp
  801a51:	48 83 ec 10          	sub    $0x10,%rsp
  801a55:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a58:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a5b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a5e:	48 63 d0             	movslq %eax,%rdx
  801a61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a64:	48 98                	cltq   
  801a66:	48 83 ec 08          	sub    $0x8,%rsp
  801a6a:	6a 00                	pushq  $0x0
  801a6c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a72:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a78:	48 89 d1             	mov    %rdx,%rcx
  801a7b:	48 89 c2             	mov    %rax,%rdx
  801a7e:	be 01 00 00 00       	mov    $0x1,%esi
  801a83:	bf 08 00 00 00       	mov    $0x8,%edi
  801a88:	48 b8 7b 17 80 00 00 	movabs $0x80177b,%rax
  801a8f:	00 00 00 
  801a92:	ff d0                	callq  *%rax
  801a94:	48 83 c4 10          	add    $0x10,%rsp
}
  801a98:	c9                   	leaveq 
  801a99:	c3                   	retq   

0000000000801a9a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801a9a:	55                   	push   %rbp
  801a9b:	48 89 e5             	mov    %rsp,%rbp
  801a9e:	48 83 ec 10          	sub    $0x10,%rsp
  801aa2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aa5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801aa9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ab0:	48 98                	cltq   
  801ab2:	48 83 ec 08          	sub    $0x8,%rsp
  801ab6:	6a 00                	pushq  $0x0
  801ab8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801abe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ac4:	48 89 d1             	mov    %rdx,%rcx
  801ac7:	48 89 c2             	mov    %rax,%rdx
  801aca:	be 01 00 00 00       	mov    $0x1,%esi
  801acf:	bf 09 00 00 00       	mov    $0x9,%edi
  801ad4:	48 b8 7b 17 80 00 00 	movabs $0x80177b,%rax
  801adb:	00 00 00 
  801ade:	ff d0                	callq  *%rax
  801ae0:	48 83 c4 10          	add    $0x10,%rsp
}
  801ae4:	c9                   	leaveq 
  801ae5:	c3                   	retq   

0000000000801ae6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ae6:	55                   	push   %rbp
  801ae7:	48 89 e5             	mov    %rsp,%rbp
  801aea:	48 83 ec 10          	sub    $0x10,%rsp
  801aee:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801af1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801af5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801af9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801afc:	48 98                	cltq   
  801afe:	48 83 ec 08          	sub    $0x8,%rsp
  801b02:	6a 00                	pushq  $0x0
  801b04:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b0a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b10:	48 89 d1             	mov    %rdx,%rcx
  801b13:	48 89 c2             	mov    %rax,%rdx
  801b16:	be 01 00 00 00       	mov    $0x1,%esi
  801b1b:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b20:	48 b8 7b 17 80 00 00 	movabs $0x80177b,%rax
  801b27:	00 00 00 
  801b2a:	ff d0                	callq  *%rax
  801b2c:	48 83 c4 10          	add    $0x10,%rsp
}
  801b30:	c9                   	leaveq 
  801b31:	c3                   	retq   

0000000000801b32 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b32:	55                   	push   %rbp
  801b33:	48 89 e5             	mov    %rsp,%rbp
  801b36:	48 83 ec 20          	sub    $0x20,%rsp
  801b3a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b3d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b41:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b45:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b48:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b4b:	48 63 f0             	movslq %eax,%rsi
  801b4e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b55:	48 98                	cltq   
  801b57:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b5b:	48 83 ec 08          	sub    $0x8,%rsp
  801b5f:	6a 00                	pushq  $0x0
  801b61:	49 89 f1             	mov    %rsi,%r9
  801b64:	49 89 c8             	mov    %rcx,%r8
  801b67:	48 89 d1             	mov    %rdx,%rcx
  801b6a:	48 89 c2             	mov    %rax,%rdx
  801b6d:	be 00 00 00 00       	mov    $0x0,%esi
  801b72:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b77:	48 b8 7b 17 80 00 00 	movabs $0x80177b,%rax
  801b7e:	00 00 00 
  801b81:	ff d0                	callq  *%rax
  801b83:	48 83 c4 10          	add    $0x10,%rsp
}
  801b87:	c9                   	leaveq 
  801b88:	c3                   	retq   

0000000000801b89 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b89:	55                   	push   %rbp
  801b8a:	48 89 e5             	mov    %rsp,%rbp
  801b8d:	48 83 ec 10          	sub    $0x10,%rsp
  801b91:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b99:	48 83 ec 08          	sub    $0x8,%rsp
  801b9d:	6a 00                	pushq  $0x0
  801b9f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ba5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bab:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bb0:	48 89 c2             	mov    %rax,%rdx
  801bb3:	be 01 00 00 00       	mov    $0x1,%esi
  801bb8:	bf 0d 00 00 00       	mov    $0xd,%edi
  801bbd:	48 b8 7b 17 80 00 00 	movabs $0x80177b,%rax
  801bc4:	00 00 00 
  801bc7:	ff d0                	callq  *%rax
  801bc9:	48 83 c4 10          	add    $0x10,%rsp
}
  801bcd:	c9                   	leaveq 
  801bce:	c3                   	retq   

0000000000801bcf <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801bcf:	55                   	push   %rbp
  801bd0:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801bd3:	48 83 ec 08          	sub    $0x8,%rsp
  801bd7:	6a 00                	pushq  $0x0
  801bd9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bdf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801be5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bea:	ba 00 00 00 00       	mov    $0x0,%edx
  801bef:	be 00 00 00 00       	mov    $0x0,%esi
  801bf4:	bf 0e 00 00 00       	mov    $0xe,%edi
  801bf9:	48 b8 7b 17 80 00 00 	movabs $0x80177b,%rax
  801c00:	00 00 00 
  801c03:	ff d0                	callq  *%rax
  801c05:	48 83 c4 10          	add    $0x10,%rsp
}
  801c09:	c9                   	leaveq 
  801c0a:	c3                   	retq   

0000000000801c0b <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801c0b:	55                   	push   %rbp
  801c0c:	48 89 e5             	mov    %rsp,%rbp
  801c0f:	48 83 ec 20          	sub    $0x20,%rsp
  801c13:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c16:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c1a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801c1d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801c21:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801c25:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c28:	48 63 c8             	movslq %eax,%rcx
  801c2b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c2f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c32:	48 63 f0             	movslq %eax,%rsi
  801c35:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c3c:	48 98                	cltq   
  801c3e:	48 83 ec 08          	sub    $0x8,%rsp
  801c42:	51                   	push   %rcx
  801c43:	49 89 f9             	mov    %rdi,%r9
  801c46:	49 89 f0             	mov    %rsi,%r8
  801c49:	48 89 d1             	mov    %rdx,%rcx
  801c4c:	48 89 c2             	mov    %rax,%rdx
  801c4f:	be 00 00 00 00       	mov    $0x0,%esi
  801c54:	bf 0f 00 00 00       	mov    $0xf,%edi
  801c59:	48 b8 7b 17 80 00 00 	movabs $0x80177b,%rax
  801c60:	00 00 00 
  801c63:	ff d0                	callq  *%rax
  801c65:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801c69:	c9                   	leaveq 
  801c6a:	c3                   	retq   

0000000000801c6b <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801c6b:	55                   	push   %rbp
  801c6c:	48 89 e5             	mov    %rsp,%rbp
  801c6f:	48 83 ec 10          	sub    $0x10,%rsp
  801c73:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c77:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801c7b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c83:	48 83 ec 08          	sub    $0x8,%rsp
  801c87:	6a 00                	pushq  $0x0
  801c89:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c8f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c95:	48 89 d1             	mov    %rdx,%rcx
  801c98:	48 89 c2             	mov    %rax,%rdx
  801c9b:	be 00 00 00 00       	mov    $0x0,%esi
  801ca0:	bf 10 00 00 00       	mov    $0x10,%edi
  801ca5:	48 b8 7b 17 80 00 00 	movabs $0x80177b,%rax
  801cac:	00 00 00 
  801caf:	ff d0                	callq  *%rax
  801cb1:	48 83 c4 10          	add    $0x10,%rsp
}
  801cb5:	c9                   	leaveq 
  801cb6:	c3                   	retq   

0000000000801cb7 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801cb7:	55                   	push   %rbp
  801cb8:	48 89 e5             	mov    %rsp,%rbp
  801cbb:	48 83 ec 20          	sub    $0x20,%rsp
  801cbf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801cc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cc7:	48 8b 00             	mov    (%rax),%rax
  801cca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801cce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cd2:	48 8b 40 08          	mov    0x8(%rax),%rax
  801cd6:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  801cd9:	48 ba b3 44 80 00 00 	movabs $0x8044b3,%rdx
  801ce0:	00 00 00 
  801ce3:	be 26 00 00 00       	mov    $0x26,%esi
  801ce8:	48 bf cb 44 80 00 00 	movabs $0x8044cb,%rdi
  801cef:	00 00 00 
  801cf2:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf7:	48 b9 4f 02 80 00 00 	movabs $0x80024f,%rcx
  801cfe:	00 00 00 
  801d01:	ff d1                	callq  *%rcx

0000000000801d03 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801d03:	55                   	push   %rbp
  801d04:	48 89 e5             	mov    %rsp,%rbp
  801d07:	48 83 ec 10          	sub    $0x10,%rsp
  801d0b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d0e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	int r;

	// LAB 4: Your code here.
	panic("duppage not implemented");
  801d11:	48 ba d6 44 80 00 00 	movabs $0x8044d6,%rdx
  801d18:	00 00 00 
  801d1b:	be 3a 00 00 00       	mov    $0x3a,%esi
  801d20:	48 bf cb 44 80 00 00 	movabs $0x8044cb,%rdi
  801d27:	00 00 00 
  801d2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2f:	48 b9 4f 02 80 00 00 	movabs $0x80024f,%rcx
  801d36:	00 00 00 
  801d39:	ff d1                	callq  *%rcx

0000000000801d3b <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801d3b:	55                   	push   %rbp
  801d3c:	48 89 e5             	mov    %rsp,%rbp
	// LAB 4: Your code here.
	panic("fork not implemented");
  801d3f:	48 ba ee 44 80 00 00 	movabs $0x8044ee,%rdx
  801d46:	00 00 00 
  801d49:	be 52 00 00 00       	mov    $0x52,%esi
  801d4e:	48 bf cb 44 80 00 00 	movabs $0x8044cb,%rdi
  801d55:	00 00 00 
  801d58:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5d:	48 b9 4f 02 80 00 00 	movabs $0x80024f,%rcx
  801d64:	00 00 00 
  801d67:	ff d1                	callq  *%rcx

0000000000801d69 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801d69:	55                   	push   %rbp
  801d6a:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  801d6d:	48 ba 03 45 80 00 00 	movabs $0x804503,%rdx
  801d74:	00 00 00 
  801d77:	be 59 00 00 00       	mov    $0x59,%esi
  801d7c:	48 bf cb 44 80 00 00 	movabs $0x8044cb,%rdi
  801d83:	00 00 00 
  801d86:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8b:	48 b9 4f 02 80 00 00 	movabs $0x80024f,%rcx
  801d92:	00 00 00 
  801d95:	ff d1                	callq  *%rcx

0000000000801d97 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d97:	55                   	push   %rbp
  801d98:	48 89 e5             	mov    %rsp,%rbp
  801d9b:	48 83 ec 20          	sub    $0x20,%rsp
  801d9f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801da3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801da7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801dab:	48 ba 20 45 80 00 00 	movabs $0x804520,%rdx
  801db2:	00 00 00 
  801db5:	be 1d 00 00 00       	mov    $0x1d,%esi
  801dba:	48 bf 39 45 80 00 00 	movabs $0x804539,%rdi
  801dc1:	00 00 00 
  801dc4:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc9:	48 b9 4f 02 80 00 00 	movabs $0x80024f,%rcx
  801dd0:	00 00 00 
  801dd3:	ff d1                	callq  *%rcx

0000000000801dd5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801dd5:	55                   	push   %rbp
  801dd6:	48 89 e5             	mov    %rsp,%rbp
  801dd9:	48 83 ec 20          	sub    $0x20,%rsp
  801ddd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801de0:	89 75 f8             	mov    %esi,-0x8(%rbp)
  801de3:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  801de7:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801dea:	48 ba 43 45 80 00 00 	movabs $0x804543,%rdx
  801df1:	00 00 00 
  801df4:	be 2d 00 00 00       	mov    $0x2d,%esi
  801df9:	48 bf 39 45 80 00 00 	movabs $0x804539,%rdi
  801e00:	00 00 00 
  801e03:	b8 00 00 00 00       	mov    $0x0,%eax
  801e08:	48 b9 4f 02 80 00 00 	movabs $0x80024f,%rcx
  801e0f:	00 00 00 
  801e12:	ff d1                	callq  *%rcx

0000000000801e14 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  801e14:	55                   	push   %rbp
  801e15:	48 89 e5             	mov    %rsp,%rbp
  801e18:	53                   	push   %rbx
  801e19:	48 83 ec 48          	sub    $0x48,%rsp
  801e1d:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  801e21:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  801e28:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  801e2f:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  801e34:	75 0e                	jne    801e44 <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  801e36:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  801e3d:	00 00 00 
  801e40:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  801e44:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801e48:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  801e4c:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  801e53:	00 
	a3 = (uint64_t) 0;
  801e54:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  801e5b:	00 
	a4 = (uint64_t) 0;
  801e5c:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  801e63:	00 
	a5 = 0;
  801e64:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  801e6b:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  801e6c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801e6f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801e73:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801e77:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  801e7b:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  801e7f:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  801e83:	4c 89 c3             	mov    %r8,%rbx
  801e86:	0f 01 c1             	vmcall 
  801e89:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  801e8c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e90:	7e 36                	jle    801ec8 <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  801e92:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e95:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801e98:	41 89 d0             	mov    %edx,%r8d
  801e9b:	89 c1                	mov    %eax,%ecx
  801e9d:	48 ba 60 45 80 00 00 	movabs $0x804560,%rdx
  801ea4:	00 00 00 
  801ea7:	be 54 00 00 00       	mov    $0x54,%esi
  801eac:	48 bf 39 45 80 00 00 	movabs $0x804539,%rdi
  801eb3:	00 00 00 
  801eb6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ebb:	49 b9 4f 02 80 00 00 	movabs $0x80024f,%r9
  801ec2:	00 00 00 
  801ec5:	41 ff d1             	callq  *%r9
	return ret;
  801ec8:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801ecb:	48 83 c4 48          	add    $0x48,%rsp
  801ecf:	5b                   	pop    %rbx
  801ed0:	5d                   	pop    %rbp
  801ed1:	c3                   	retq   

0000000000801ed2 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ed2:	55                   	push   %rbp
  801ed3:	48 89 e5             	mov    %rsp,%rbp
  801ed6:	53                   	push   %rbx
  801ed7:	48 83 ec 58          	sub    $0x58,%rsp
  801edb:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  801ede:	89 75 b0             	mov    %esi,-0x50(%rbp)
  801ee1:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  801ee5:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  801ee8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  801eef:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  801ef6:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  801efb:	75 0e                	jne    801f0b <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  801efd:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  801f04:	00 00 00 
  801f07:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  801f0b:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801f0e:	48 98                	cltq   
  801f10:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  801f14:	8b 45 b0             	mov    -0x50(%rbp),%eax
  801f17:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  801f1b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801f1f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  801f23:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  801f26:	48 98                	cltq   
  801f28:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  801f2c:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  801f33:	00 

	int r = -E_IPC_NOT_RECV;
  801f34:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  801f3b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801f3e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801f42:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801f46:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  801f4a:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  801f4e:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  801f52:	4c 89 c3             	mov    %r8,%rbx
  801f55:	0f 01 c1             	vmcall 
  801f58:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  801f5b:	48 83 c4 58          	add    $0x58,%rsp
  801f5f:	5b                   	pop    %rbx
  801f60:	5d                   	pop    %rbp
  801f61:	c3                   	retq   

0000000000801f62 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f62:	55                   	push   %rbp
  801f63:	48 89 e5             	mov    %rsp,%rbp
  801f66:	48 83 ec 18          	sub    $0x18,%rsp
  801f6a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  801f6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f74:	eb 4e                	jmp    801fc4 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  801f76:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801f7d:	00 00 00 
  801f80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f83:	48 98                	cltq   
  801f85:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  801f8c:	48 01 d0             	add    %rdx,%rax
  801f8f:	48 05 d0 00 00 00    	add    $0xd0,%rax
  801f95:	8b 00                	mov    (%rax),%eax
  801f97:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f9a:	75 24                	jne    801fc0 <ipc_find_env+0x5e>
			return envs[i].env_id;
  801f9c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801fa3:	00 00 00 
  801fa6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fa9:	48 98                	cltq   
  801fab:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  801fb2:	48 01 d0             	add    %rdx,%rax
  801fb5:	48 05 c0 00 00 00    	add    $0xc0,%rax
  801fbb:	8b 40 08             	mov    0x8(%rax),%eax
  801fbe:	eb 12                	jmp    801fd2 <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  801fc0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fc4:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  801fcb:	7e a9                	jle    801f76 <ipc_find_env+0x14>
	}
	return 0;
  801fcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd2:	c9                   	leaveq 
  801fd3:	c3                   	retq   

0000000000801fd4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801fd4:	55                   	push   %rbp
  801fd5:	48 89 e5             	mov    %rsp,%rbp
  801fd8:	48 83 ec 08          	sub    $0x8,%rsp
  801fdc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801fe0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801fe4:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801feb:	ff ff ff 
  801fee:	48 01 d0             	add    %rdx,%rax
  801ff1:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801ff5:	c9                   	leaveq 
  801ff6:	c3                   	retq   

0000000000801ff7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801ff7:	55                   	push   %rbp
  801ff8:	48 89 e5             	mov    %rsp,%rbp
  801ffb:	48 83 ec 08          	sub    $0x8,%rsp
  801fff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802003:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802007:	48 89 c7             	mov    %rax,%rdi
  80200a:	48 b8 d4 1f 80 00 00 	movabs $0x801fd4,%rax
  802011:	00 00 00 
  802014:	ff d0                	callq  *%rax
  802016:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80201c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802020:	c9                   	leaveq 
  802021:	c3                   	retq   

0000000000802022 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802022:	55                   	push   %rbp
  802023:	48 89 e5             	mov    %rsp,%rbp
  802026:	48 83 ec 18          	sub    $0x18,%rsp
  80202a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80202e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802035:	eb 6b                	jmp    8020a2 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802037:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80203a:	48 98                	cltq   
  80203c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802042:	48 c1 e0 0c          	shl    $0xc,%rax
  802046:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80204a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80204e:	48 c1 e8 15          	shr    $0x15,%rax
  802052:	48 89 c2             	mov    %rax,%rdx
  802055:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80205c:	01 00 00 
  80205f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802063:	83 e0 01             	and    $0x1,%eax
  802066:	48 85 c0             	test   %rax,%rax
  802069:	74 21                	je     80208c <fd_alloc+0x6a>
  80206b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80206f:	48 c1 e8 0c          	shr    $0xc,%rax
  802073:	48 89 c2             	mov    %rax,%rdx
  802076:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80207d:	01 00 00 
  802080:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802084:	83 e0 01             	and    $0x1,%eax
  802087:	48 85 c0             	test   %rax,%rax
  80208a:	75 12                	jne    80209e <fd_alloc+0x7c>
			*fd_store = fd;
  80208c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802090:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802094:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802097:	b8 00 00 00 00       	mov    $0x0,%eax
  80209c:	eb 1a                	jmp    8020b8 <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  80209e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020a2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8020a6:	7e 8f                	jle    802037 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  8020a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ac:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8020b3:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8020b8:	c9                   	leaveq 
  8020b9:	c3                   	retq   

00000000008020ba <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8020ba:	55                   	push   %rbp
  8020bb:	48 89 e5             	mov    %rsp,%rbp
  8020be:	48 83 ec 20          	sub    $0x20,%rsp
  8020c2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8020c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8020cd:	78 06                	js     8020d5 <fd_lookup+0x1b>
  8020cf:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8020d3:	7e 07                	jle    8020dc <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8020d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020da:	eb 6c                	jmp    802148 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8020dc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020df:	48 98                	cltq   
  8020e1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020e7:	48 c1 e0 0c          	shl    $0xc,%rax
  8020eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8020ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020f3:	48 c1 e8 15          	shr    $0x15,%rax
  8020f7:	48 89 c2             	mov    %rax,%rdx
  8020fa:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802101:	01 00 00 
  802104:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802108:	83 e0 01             	and    $0x1,%eax
  80210b:	48 85 c0             	test   %rax,%rax
  80210e:	74 21                	je     802131 <fd_lookup+0x77>
  802110:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802114:	48 c1 e8 0c          	shr    $0xc,%rax
  802118:	48 89 c2             	mov    %rax,%rdx
  80211b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802122:	01 00 00 
  802125:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802129:	83 e0 01             	and    $0x1,%eax
  80212c:	48 85 c0             	test   %rax,%rax
  80212f:	75 07                	jne    802138 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802131:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802136:	eb 10                	jmp    802148 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802138:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80213c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802140:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802143:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802148:	c9                   	leaveq 
  802149:	c3                   	retq   

000000000080214a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80214a:	55                   	push   %rbp
  80214b:	48 89 e5             	mov    %rsp,%rbp
  80214e:	48 83 ec 30          	sub    $0x30,%rsp
  802152:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802156:	89 f0                	mov    %esi,%eax
  802158:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80215b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80215f:	48 89 c7             	mov    %rax,%rdi
  802162:	48 b8 d4 1f 80 00 00 	movabs $0x801fd4,%rax
  802169:	00 00 00 
  80216c:	ff d0                	callq  *%rax
  80216e:	89 c2                	mov    %eax,%edx
  802170:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802174:	48 89 c6             	mov    %rax,%rsi
  802177:	89 d7                	mov    %edx,%edi
  802179:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  802180:	00 00 00 
  802183:	ff d0                	callq  *%rax
  802185:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802188:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80218c:	78 0a                	js     802198 <fd_close+0x4e>
	    || fd != fd2)
  80218e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802192:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802196:	74 12                	je     8021aa <fd_close+0x60>
		return (must_exist ? r : 0);
  802198:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80219c:	74 05                	je     8021a3 <fd_close+0x59>
  80219e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021a1:	eb 70                	jmp    802213 <fd_close+0xc9>
  8021a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a8:	eb 69                	jmp    802213 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8021aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021ae:	8b 00                	mov    (%rax),%eax
  8021b0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021b4:	48 89 d6             	mov    %rdx,%rsi
  8021b7:	89 c7                	mov    %eax,%edi
  8021b9:	48 b8 15 22 80 00 00 	movabs $0x802215,%rax
  8021c0:	00 00 00 
  8021c3:	ff d0                	callq  *%rax
  8021c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021cc:	78 2a                	js     8021f8 <fd_close+0xae>
		if (dev->dev_close)
  8021ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d2:	48 8b 40 20          	mov    0x20(%rax),%rax
  8021d6:	48 85 c0             	test   %rax,%rax
  8021d9:	74 16                	je     8021f1 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  8021db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021df:	48 8b 40 20          	mov    0x20(%rax),%rax
  8021e3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8021e7:	48 89 d7             	mov    %rdx,%rdi
  8021ea:	ff d0                	callq  *%rax
  8021ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021ef:	eb 07                	jmp    8021f8 <fd_close+0xae>
		else
			r = 0;
  8021f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8021f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021fc:	48 89 c6             	mov    %rax,%rsi
  8021ff:	bf 00 00 00 00       	mov    $0x0,%edi
  802204:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  80220b:	00 00 00 
  80220e:	ff d0                	callq  *%rax
	return r;
  802210:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802213:	c9                   	leaveq 
  802214:	c3                   	retq   

0000000000802215 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802215:	55                   	push   %rbp
  802216:	48 89 e5             	mov    %rsp,%rbp
  802219:	48 83 ec 20          	sub    $0x20,%rsp
  80221d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802220:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802224:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80222b:	eb 41                	jmp    80226e <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80222d:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802234:	00 00 00 
  802237:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80223a:	48 63 d2             	movslq %edx,%rdx
  80223d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802241:	8b 00                	mov    (%rax),%eax
  802243:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802246:	75 22                	jne    80226a <dev_lookup+0x55>
			*dev = devtab[i];
  802248:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80224f:	00 00 00 
  802252:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802255:	48 63 d2             	movslq %edx,%rdx
  802258:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80225c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802260:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802263:	b8 00 00 00 00       	mov    $0x0,%eax
  802268:	eb 60                	jmp    8022ca <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  80226a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80226e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802275:	00 00 00 
  802278:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80227b:	48 63 d2             	movslq %edx,%rdx
  80227e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802282:	48 85 c0             	test   %rax,%rax
  802285:	75 a6                	jne    80222d <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802287:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80228e:	00 00 00 
  802291:	48 8b 00             	mov    (%rax),%rax
  802294:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80229a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80229d:	89 c6                	mov    %eax,%esi
  80229f:	48 bf 90 45 80 00 00 	movabs $0x804590,%rdi
  8022a6:	00 00 00 
  8022a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ae:	48 b9 88 04 80 00 00 	movabs $0x800488,%rcx
  8022b5:	00 00 00 
  8022b8:	ff d1                	callq  *%rcx
	*dev = 0;
  8022ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022be:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8022c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8022ca:	c9                   	leaveq 
  8022cb:	c3                   	retq   

00000000008022cc <close>:

int
close(int fdnum)
{
  8022cc:	55                   	push   %rbp
  8022cd:	48 89 e5             	mov    %rsp,%rbp
  8022d0:	48 83 ec 20          	sub    $0x20,%rsp
  8022d4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022d7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022db:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022de:	48 89 d6             	mov    %rdx,%rsi
  8022e1:	89 c7                	mov    %eax,%edi
  8022e3:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  8022ea:	00 00 00 
  8022ed:	ff d0                	callq  *%rax
  8022ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022f6:	79 05                	jns    8022fd <close+0x31>
		return r;
  8022f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022fb:	eb 18                	jmp    802315 <close+0x49>
	else
		return fd_close(fd, 1);
  8022fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802301:	be 01 00 00 00       	mov    $0x1,%esi
  802306:	48 89 c7             	mov    %rax,%rdi
  802309:	48 b8 4a 21 80 00 00 	movabs $0x80214a,%rax
  802310:	00 00 00 
  802313:	ff d0                	callq  *%rax
}
  802315:	c9                   	leaveq 
  802316:	c3                   	retq   

0000000000802317 <close_all>:

void
close_all(void)
{
  802317:	55                   	push   %rbp
  802318:	48 89 e5             	mov    %rsp,%rbp
  80231b:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80231f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802326:	eb 15                	jmp    80233d <close_all+0x26>
		close(i);
  802328:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80232b:	89 c7                	mov    %eax,%edi
  80232d:	48 b8 cc 22 80 00 00 	movabs $0x8022cc,%rax
  802334:	00 00 00 
  802337:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  802339:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80233d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802341:	7e e5                	jle    802328 <close_all+0x11>
}
  802343:	c9                   	leaveq 
  802344:	c3                   	retq   

0000000000802345 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802345:	55                   	push   %rbp
  802346:	48 89 e5             	mov    %rsp,%rbp
  802349:	48 83 ec 40          	sub    $0x40,%rsp
  80234d:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802350:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802353:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802357:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80235a:	48 89 d6             	mov    %rdx,%rsi
  80235d:	89 c7                	mov    %eax,%edi
  80235f:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  802366:	00 00 00 
  802369:	ff d0                	callq  *%rax
  80236b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80236e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802372:	79 08                	jns    80237c <dup+0x37>
		return r;
  802374:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802377:	e9 70 01 00 00       	jmpq   8024ec <dup+0x1a7>
	close(newfdnum);
  80237c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80237f:	89 c7                	mov    %eax,%edi
  802381:	48 b8 cc 22 80 00 00 	movabs $0x8022cc,%rax
  802388:	00 00 00 
  80238b:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80238d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802390:	48 98                	cltq   
  802392:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802398:	48 c1 e0 0c          	shl    $0xc,%rax
  80239c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8023a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023a4:	48 89 c7             	mov    %rax,%rdi
  8023a7:	48 b8 f7 1f 80 00 00 	movabs $0x801ff7,%rax
  8023ae:	00 00 00 
  8023b1:	ff d0                	callq  *%rax
  8023b3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8023b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023bb:	48 89 c7             	mov    %rax,%rdi
  8023be:	48 b8 f7 1f 80 00 00 	movabs $0x801ff7,%rax
  8023c5:	00 00 00 
  8023c8:	ff d0                	callq  *%rax
  8023ca:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8023ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d2:	48 c1 e8 15          	shr    $0x15,%rax
  8023d6:	48 89 c2             	mov    %rax,%rdx
  8023d9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023e0:	01 00 00 
  8023e3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023e7:	83 e0 01             	and    $0x1,%eax
  8023ea:	48 85 c0             	test   %rax,%rax
  8023ed:	74 73                	je     802462 <dup+0x11d>
  8023ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f3:	48 c1 e8 0c          	shr    $0xc,%rax
  8023f7:	48 89 c2             	mov    %rax,%rdx
  8023fa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802401:	01 00 00 
  802404:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802408:	83 e0 01             	and    $0x1,%eax
  80240b:	48 85 c0             	test   %rax,%rax
  80240e:	74 52                	je     802462 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802410:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802414:	48 c1 e8 0c          	shr    $0xc,%rax
  802418:	48 89 c2             	mov    %rax,%rdx
  80241b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802422:	01 00 00 
  802425:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802429:	25 07 0e 00 00       	and    $0xe07,%eax
  80242e:	89 c1                	mov    %eax,%ecx
  802430:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802434:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802438:	41 89 c8             	mov    %ecx,%r8d
  80243b:	48 89 d1             	mov    %rdx,%rcx
  80243e:	ba 00 00 00 00       	mov    $0x0,%edx
  802443:	48 89 c6             	mov    %rax,%rsi
  802446:	bf 00 00 00 00       	mov    $0x0,%edi
  80244b:	48 b8 a1 19 80 00 00 	movabs $0x8019a1,%rax
  802452:	00 00 00 
  802455:	ff d0                	callq  *%rax
  802457:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80245a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80245e:	79 02                	jns    802462 <dup+0x11d>
			goto err;
  802460:	eb 57                	jmp    8024b9 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802462:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802466:	48 c1 e8 0c          	shr    $0xc,%rax
  80246a:	48 89 c2             	mov    %rax,%rdx
  80246d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802474:	01 00 00 
  802477:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80247b:	25 07 0e 00 00       	and    $0xe07,%eax
  802480:	89 c1                	mov    %eax,%ecx
  802482:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802486:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80248a:	41 89 c8             	mov    %ecx,%r8d
  80248d:	48 89 d1             	mov    %rdx,%rcx
  802490:	ba 00 00 00 00       	mov    $0x0,%edx
  802495:	48 89 c6             	mov    %rax,%rsi
  802498:	bf 00 00 00 00       	mov    $0x0,%edi
  80249d:	48 b8 a1 19 80 00 00 	movabs $0x8019a1,%rax
  8024a4:	00 00 00 
  8024a7:	ff d0                	callq  *%rax
  8024a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b0:	79 02                	jns    8024b4 <dup+0x16f>
		goto err;
  8024b2:	eb 05                	jmp    8024b9 <dup+0x174>

	return newfdnum;
  8024b4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8024b7:	eb 33                	jmp    8024ec <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8024b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024bd:	48 89 c6             	mov    %rax,%rsi
  8024c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8024c5:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  8024cc:	00 00 00 
  8024cf:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8024d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024d5:	48 89 c6             	mov    %rax,%rsi
  8024d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8024dd:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  8024e4:	00 00 00 
  8024e7:	ff d0                	callq  *%rax
	return r;
  8024e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024ec:	c9                   	leaveq 
  8024ed:	c3                   	retq   

00000000008024ee <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8024ee:	55                   	push   %rbp
  8024ef:	48 89 e5             	mov    %rsp,%rbp
  8024f2:	48 83 ec 40          	sub    $0x40,%rsp
  8024f6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024f9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8024fd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802501:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802505:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802508:	48 89 d6             	mov    %rdx,%rsi
  80250b:	89 c7                	mov    %eax,%edi
  80250d:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  802514:	00 00 00 
  802517:	ff d0                	callq  *%rax
  802519:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80251c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802520:	78 24                	js     802546 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802522:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802526:	8b 00                	mov    (%rax),%eax
  802528:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80252c:	48 89 d6             	mov    %rdx,%rsi
  80252f:	89 c7                	mov    %eax,%edi
  802531:	48 b8 15 22 80 00 00 	movabs $0x802215,%rax
  802538:	00 00 00 
  80253b:	ff d0                	callq  *%rax
  80253d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802540:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802544:	79 05                	jns    80254b <read+0x5d>
		return r;
  802546:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802549:	eb 76                	jmp    8025c1 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80254b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80254f:	8b 40 08             	mov    0x8(%rax),%eax
  802552:	83 e0 03             	and    $0x3,%eax
  802555:	83 f8 01             	cmp    $0x1,%eax
  802558:	75 3a                	jne    802594 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80255a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802561:	00 00 00 
  802564:	48 8b 00             	mov    (%rax),%rax
  802567:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80256d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802570:	89 c6                	mov    %eax,%esi
  802572:	48 bf af 45 80 00 00 	movabs $0x8045af,%rdi
  802579:	00 00 00 
  80257c:	b8 00 00 00 00       	mov    $0x0,%eax
  802581:	48 b9 88 04 80 00 00 	movabs $0x800488,%rcx
  802588:	00 00 00 
  80258b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80258d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802592:	eb 2d                	jmp    8025c1 <read+0xd3>
	}
	if (!dev->dev_read)
  802594:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802598:	48 8b 40 10          	mov    0x10(%rax),%rax
  80259c:	48 85 c0             	test   %rax,%rax
  80259f:	75 07                	jne    8025a8 <read+0xba>
		return -E_NOT_SUPP;
  8025a1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025a6:	eb 19                	jmp    8025c1 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8025a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ac:	48 8b 40 10          	mov    0x10(%rax),%rax
  8025b0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8025b4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025b8:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025bc:	48 89 cf             	mov    %rcx,%rdi
  8025bf:	ff d0                	callq  *%rax
}
  8025c1:	c9                   	leaveq 
  8025c2:	c3                   	retq   

00000000008025c3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8025c3:	55                   	push   %rbp
  8025c4:	48 89 e5             	mov    %rsp,%rbp
  8025c7:	48 83 ec 30          	sub    $0x30,%rsp
  8025cb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025ce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025d2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8025d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025dd:	eb 49                	jmp    802628 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8025df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e2:	48 98                	cltq   
  8025e4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8025e8:	48 29 c2             	sub    %rax,%rdx
  8025eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ee:	48 63 c8             	movslq %eax,%rcx
  8025f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025f5:	48 01 c1             	add    %rax,%rcx
  8025f8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025fb:	48 89 ce             	mov    %rcx,%rsi
  8025fe:	89 c7                	mov    %eax,%edi
  802600:	48 b8 ee 24 80 00 00 	movabs $0x8024ee,%rax
  802607:	00 00 00 
  80260a:	ff d0                	callq  *%rax
  80260c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80260f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802613:	79 05                	jns    80261a <readn+0x57>
			return m;
  802615:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802618:	eb 1c                	jmp    802636 <readn+0x73>
		if (m == 0)
  80261a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80261e:	75 02                	jne    802622 <readn+0x5f>
			break;
  802620:	eb 11                	jmp    802633 <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  802622:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802625:	01 45 fc             	add    %eax,-0x4(%rbp)
  802628:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80262b:	48 98                	cltq   
  80262d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802631:	72 ac                	jb     8025df <readn+0x1c>
	}
	return tot;
  802633:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802636:	c9                   	leaveq 
  802637:	c3                   	retq   

0000000000802638 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802638:	55                   	push   %rbp
  802639:	48 89 e5             	mov    %rsp,%rbp
  80263c:	48 83 ec 40          	sub    $0x40,%rsp
  802640:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802643:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802647:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80264b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80264f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802652:	48 89 d6             	mov    %rdx,%rsi
  802655:	89 c7                	mov    %eax,%edi
  802657:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  80265e:	00 00 00 
  802661:	ff d0                	callq  *%rax
  802663:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802666:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80266a:	78 24                	js     802690 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80266c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802670:	8b 00                	mov    (%rax),%eax
  802672:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802676:	48 89 d6             	mov    %rdx,%rsi
  802679:	89 c7                	mov    %eax,%edi
  80267b:	48 b8 15 22 80 00 00 	movabs $0x802215,%rax
  802682:	00 00 00 
  802685:	ff d0                	callq  *%rax
  802687:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80268a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80268e:	79 05                	jns    802695 <write+0x5d>
		return r;
  802690:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802693:	eb 75                	jmp    80270a <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802695:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802699:	8b 40 08             	mov    0x8(%rax),%eax
  80269c:	83 e0 03             	and    $0x3,%eax
  80269f:	85 c0                	test   %eax,%eax
  8026a1:	75 3a                	jne    8026dd <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8026a3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8026aa:	00 00 00 
  8026ad:	48 8b 00             	mov    (%rax),%rax
  8026b0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026b6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026b9:	89 c6                	mov    %eax,%esi
  8026bb:	48 bf cb 45 80 00 00 	movabs $0x8045cb,%rdi
  8026c2:	00 00 00 
  8026c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ca:	48 b9 88 04 80 00 00 	movabs $0x800488,%rcx
  8026d1:	00 00 00 
  8026d4:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8026d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026db:	eb 2d                	jmp    80270a <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8026dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e1:	48 8b 40 18          	mov    0x18(%rax),%rax
  8026e5:	48 85 c0             	test   %rax,%rax
  8026e8:	75 07                	jne    8026f1 <write+0xb9>
		return -E_NOT_SUPP;
  8026ea:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026ef:	eb 19                	jmp    80270a <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8026f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026f5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8026f9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8026fd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802701:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802705:	48 89 cf             	mov    %rcx,%rdi
  802708:	ff d0                	callq  *%rax
}
  80270a:	c9                   	leaveq 
  80270b:	c3                   	retq   

000000000080270c <seek>:

int
seek(int fdnum, off_t offset)
{
  80270c:	55                   	push   %rbp
  80270d:	48 89 e5             	mov    %rsp,%rbp
  802710:	48 83 ec 18          	sub    $0x18,%rsp
  802714:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802717:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80271a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80271e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802721:	48 89 d6             	mov    %rdx,%rsi
  802724:	89 c7                	mov    %eax,%edi
  802726:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  80272d:	00 00 00 
  802730:	ff d0                	callq  *%rax
  802732:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802735:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802739:	79 05                	jns    802740 <seek+0x34>
		return r;
  80273b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80273e:	eb 0f                	jmp    80274f <seek+0x43>
	fd->fd_offset = offset;
  802740:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802744:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802747:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80274a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80274f:	c9                   	leaveq 
  802750:	c3                   	retq   

0000000000802751 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802751:	55                   	push   %rbp
  802752:	48 89 e5             	mov    %rsp,%rbp
  802755:	48 83 ec 30          	sub    $0x30,%rsp
  802759:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80275c:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80275f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802763:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802766:	48 89 d6             	mov    %rdx,%rsi
  802769:	89 c7                	mov    %eax,%edi
  80276b:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  802772:	00 00 00 
  802775:	ff d0                	callq  *%rax
  802777:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80277a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80277e:	78 24                	js     8027a4 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802780:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802784:	8b 00                	mov    (%rax),%eax
  802786:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80278a:	48 89 d6             	mov    %rdx,%rsi
  80278d:	89 c7                	mov    %eax,%edi
  80278f:	48 b8 15 22 80 00 00 	movabs $0x802215,%rax
  802796:	00 00 00 
  802799:	ff d0                	callq  *%rax
  80279b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80279e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a2:	79 05                	jns    8027a9 <ftruncate+0x58>
		return r;
  8027a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a7:	eb 72                	jmp    80281b <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8027a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ad:	8b 40 08             	mov    0x8(%rax),%eax
  8027b0:	83 e0 03             	and    $0x3,%eax
  8027b3:	85 c0                	test   %eax,%eax
  8027b5:	75 3a                	jne    8027f1 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8027b7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8027be:	00 00 00 
  8027c1:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8027c4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027ca:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027cd:	89 c6                	mov    %eax,%esi
  8027cf:	48 bf e8 45 80 00 00 	movabs $0x8045e8,%rdi
  8027d6:	00 00 00 
  8027d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027de:	48 b9 88 04 80 00 00 	movabs $0x800488,%rcx
  8027e5:	00 00 00 
  8027e8:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8027ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027ef:	eb 2a                	jmp    80281b <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8027f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027f5:	48 8b 40 30          	mov    0x30(%rax),%rax
  8027f9:	48 85 c0             	test   %rax,%rax
  8027fc:	75 07                	jne    802805 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8027fe:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802803:	eb 16                	jmp    80281b <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802805:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802809:	48 8b 40 30          	mov    0x30(%rax),%rax
  80280d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802811:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802814:	89 ce                	mov    %ecx,%esi
  802816:	48 89 d7             	mov    %rdx,%rdi
  802819:	ff d0                	callq  *%rax
}
  80281b:	c9                   	leaveq 
  80281c:	c3                   	retq   

000000000080281d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80281d:	55                   	push   %rbp
  80281e:	48 89 e5             	mov    %rsp,%rbp
  802821:	48 83 ec 30          	sub    $0x30,%rsp
  802825:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802828:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80282c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802830:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802833:	48 89 d6             	mov    %rdx,%rsi
  802836:	89 c7                	mov    %eax,%edi
  802838:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  80283f:	00 00 00 
  802842:	ff d0                	callq  *%rax
  802844:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802847:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80284b:	78 24                	js     802871 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80284d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802851:	8b 00                	mov    (%rax),%eax
  802853:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802857:	48 89 d6             	mov    %rdx,%rsi
  80285a:	89 c7                	mov    %eax,%edi
  80285c:	48 b8 15 22 80 00 00 	movabs $0x802215,%rax
  802863:	00 00 00 
  802866:	ff d0                	callq  *%rax
  802868:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80286b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80286f:	79 05                	jns    802876 <fstat+0x59>
		return r;
  802871:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802874:	eb 5e                	jmp    8028d4 <fstat+0xb7>
	if (!dev->dev_stat)
  802876:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80287a:	48 8b 40 28          	mov    0x28(%rax),%rax
  80287e:	48 85 c0             	test   %rax,%rax
  802881:	75 07                	jne    80288a <fstat+0x6d>
		return -E_NOT_SUPP;
  802883:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802888:	eb 4a                	jmp    8028d4 <fstat+0xb7>
	stat->st_name[0] = 0;
  80288a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80288e:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802891:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802895:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80289c:	00 00 00 
	stat->st_isdir = 0;
  80289f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028a3:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8028aa:	00 00 00 
	stat->st_dev = dev;
  8028ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028b5:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8028bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c0:	48 8b 40 28          	mov    0x28(%rax),%rax
  8028c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028c8:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8028cc:	48 89 ce             	mov    %rcx,%rsi
  8028cf:	48 89 d7             	mov    %rdx,%rdi
  8028d2:	ff d0                	callq  *%rax
}
  8028d4:	c9                   	leaveq 
  8028d5:	c3                   	retq   

00000000008028d6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8028d6:	55                   	push   %rbp
  8028d7:	48 89 e5             	mov    %rsp,%rbp
  8028da:	48 83 ec 20          	sub    $0x20,%rsp
  8028de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028e2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8028e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ea:	be 00 00 00 00       	mov    $0x0,%esi
  8028ef:	48 89 c7             	mov    %rax,%rdi
  8028f2:	48 b8 c6 29 80 00 00 	movabs $0x8029c6,%rax
  8028f9:	00 00 00 
  8028fc:	ff d0                	callq  *%rax
  8028fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802901:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802905:	79 05                	jns    80290c <stat+0x36>
		return fd;
  802907:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80290a:	eb 2f                	jmp    80293b <stat+0x65>
	r = fstat(fd, stat);
  80290c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802910:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802913:	48 89 d6             	mov    %rdx,%rsi
  802916:	89 c7                	mov    %eax,%edi
  802918:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  80291f:	00 00 00 
  802922:	ff d0                	callq  *%rax
  802924:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802927:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80292a:	89 c7                	mov    %eax,%edi
  80292c:	48 b8 cc 22 80 00 00 	movabs $0x8022cc,%rax
  802933:	00 00 00 
  802936:	ff d0                	callq  *%rax
	return r;
  802938:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80293b:	c9                   	leaveq 
  80293c:	c3                   	retq   

000000000080293d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80293d:	55                   	push   %rbp
  80293e:	48 89 e5             	mov    %rsp,%rbp
  802941:	48 83 ec 10          	sub    $0x10,%rsp
  802945:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802948:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80294c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802953:	00 00 00 
  802956:	8b 00                	mov    (%rax),%eax
  802958:	85 c0                	test   %eax,%eax
  80295a:	75 1f                	jne    80297b <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80295c:	bf 01 00 00 00       	mov    $0x1,%edi
  802961:	48 b8 62 1f 80 00 00 	movabs $0x801f62,%rax
  802968:	00 00 00 
  80296b:	ff d0                	callq  *%rax
  80296d:	89 c2                	mov    %eax,%edx
  80296f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802976:	00 00 00 
  802979:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80297b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802982:	00 00 00 
  802985:	8b 00                	mov    (%rax),%eax
  802987:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80298a:	b9 07 00 00 00       	mov    $0x7,%ecx
  80298f:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802996:	00 00 00 
  802999:	89 c7                	mov    %eax,%edi
  80299b:	48 b8 d5 1d 80 00 00 	movabs $0x801dd5,%rax
  8029a2:	00 00 00 
  8029a5:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8029a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8029b0:	48 89 c6             	mov    %rax,%rsi
  8029b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8029b8:	48 b8 97 1d 80 00 00 	movabs $0x801d97,%rax
  8029bf:	00 00 00 
  8029c2:	ff d0                	callq  *%rax
}
  8029c4:	c9                   	leaveq 
  8029c5:	c3                   	retq   

00000000008029c6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8029c6:	55                   	push   %rbp
  8029c7:	48 89 e5             	mov    %rsp,%rbp
  8029ca:	48 83 ec 10          	sub    $0x10,%rsp
  8029ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8029d2:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  8029d5:	48 ba 0e 46 80 00 00 	movabs $0x80460e,%rdx
  8029dc:	00 00 00 
  8029df:	be 4c 00 00 00       	mov    $0x4c,%esi
  8029e4:	48 bf 23 46 80 00 00 	movabs $0x804623,%rdi
  8029eb:	00 00 00 
  8029ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f3:	48 b9 4f 02 80 00 00 	movabs $0x80024f,%rcx
  8029fa:	00 00 00 
  8029fd:	ff d1                	callq  *%rcx

00000000008029ff <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8029ff:	55                   	push   %rbp
  802a00:	48 89 e5             	mov    %rsp,%rbp
  802a03:	48 83 ec 10          	sub    $0x10,%rsp
  802a07:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802a0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a0f:	8b 50 0c             	mov    0xc(%rax),%edx
  802a12:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a19:	00 00 00 
  802a1c:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802a1e:	be 00 00 00 00       	mov    $0x0,%esi
  802a23:	bf 06 00 00 00       	mov    $0x6,%edi
  802a28:	48 b8 3d 29 80 00 00 	movabs $0x80293d,%rax
  802a2f:	00 00 00 
  802a32:	ff d0                	callq  *%rax
}
  802a34:	c9                   	leaveq 
  802a35:	c3                   	retq   

0000000000802a36 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802a36:	55                   	push   %rbp
  802a37:	48 89 e5             	mov    %rsp,%rbp
  802a3a:	48 83 ec 20          	sub    $0x20,%rsp
  802a3e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a42:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802a46:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  802a4a:	48 ba 2e 46 80 00 00 	movabs $0x80462e,%rdx
  802a51:	00 00 00 
  802a54:	be 6b 00 00 00       	mov    $0x6b,%esi
  802a59:	48 bf 23 46 80 00 00 	movabs $0x804623,%rdi
  802a60:	00 00 00 
  802a63:	b8 00 00 00 00       	mov    $0x0,%eax
  802a68:	48 b9 4f 02 80 00 00 	movabs $0x80024f,%rcx
  802a6f:	00 00 00 
  802a72:	ff d1                	callq  *%rcx

0000000000802a74 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802a74:	55                   	push   %rbp
  802a75:	48 89 e5             	mov    %rsp,%rbp
  802a78:	48 83 ec 20          	sub    $0x20,%rsp
  802a7c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a80:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802a84:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  802a88:	48 ba 4b 46 80 00 00 	movabs $0x80464b,%rdx
  802a8f:	00 00 00 
  802a92:	be 7b 00 00 00       	mov    $0x7b,%esi
  802a97:	48 bf 23 46 80 00 00 	movabs $0x804623,%rdi
  802a9e:	00 00 00 
  802aa1:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa6:	48 b9 4f 02 80 00 00 	movabs $0x80024f,%rcx
  802aad:	00 00 00 
  802ab0:	ff d1                	callq  *%rcx

0000000000802ab2 <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802ab2:	55                   	push   %rbp
  802ab3:	48 89 e5             	mov    %rsp,%rbp
  802ab6:	48 83 ec 20          	sub    $0x20,%rsp
  802aba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802abe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802ac2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ac6:	8b 50 0c             	mov    0xc(%rax),%edx
  802ac9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ad0:	00 00 00 
  802ad3:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802ad5:	be 00 00 00 00       	mov    $0x0,%esi
  802ada:	bf 05 00 00 00       	mov    $0x5,%edi
  802adf:	48 b8 3d 29 80 00 00 	movabs $0x80293d,%rax
  802ae6:	00 00 00 
  802ae9:	ff d0                	callq  *%rax
  802aeb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802af2:	79 05                	jns    802af9 <devfile_stat+0x47>
		return r;
  802af4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af7:	eb 56                	jmp    802b4f <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802af9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802afd:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802b04:	00 00 00 
  802b07:	48 89 c7             	mov    %rax,%rdi
  802b0a:	48 b8 22 10 80 00 00 	movabs $0x801022,%rax
  802b11:	00 00 00 
  802b14:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802b16:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b1d:	00 00 00 
  802b20:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802b26:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b2a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802b30:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b37:	00 00 00 
  802b3a:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802b40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b44:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802b4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b4f:	c9                   	leaveq 
  802b50:	c3                   	retq   

0000000000802b51 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802b51:	55                   	push   %rbp
  802b52:	48 89 e5             	mov    %rsp,%rbp
  802b55:	48 83 ec 10          	sub    $0x10,%rsp
  802b59:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b5d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802b60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b64:	8b 50 0c             	mov    0xc(%rax),%edx
  802b67:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b6e:	00 00 00 
  802b71:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802b73:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b7a:	00 00 00 
  802b7d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802b80:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802b83:	be 00 00 00 00       	mov    $0x0,%esi
  802b88:	bf 02 00 00 00       	mov    $0x2,%edi
  802b8d:	48 b8 3d 29 80 00 00 	movabs $0x80293d,%rax
  802b94:	00 00 00 
  802b97:	ff d0                	callq  *%rax
}
  802b99:	c9                   	leaveq 
  802b9a:	c3                   	retq   

0000000000802b9b <remove>:

// Delete a file
int
remove(const char *path)
{
  802b9b:	55                   	push   %rbp
  802b9c:	48 89 e5             	mov    %rsp,%rbp
  802b9f:	48 83 ec 10          	sub    $0x10,%rsp
  802ba3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802ba7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bab:	48 89 c7             	mov    %rax,%rdi
  802bae:	48 b8 b6 0f 80 00 00 	movabs $0x800fb6,%rax
  802bb5:	00 00 00 
  802bb8:	ff d0                	callq  *%rax
  802bba:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802bbf:	7e 07                	jle    802bc8 <remove+0x2d>
		return -E_BAD_PATH;
  802bc1:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802bc6:	eb 33                	jmp    802bfb <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802bc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bcc:	48 89 c6             	mov    %rax,%rsi
  802bcf:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802bd6:	00 00 00 
  802bd9:	48 b8 22 10 80 00 00 	movabs $0x801022,%rax
  802be0:	00 00 00 
  802be3:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802be5:	be 00 00 00 00       	mov    $0x0,%esi
  802bea:	bf 07 00 00 00       	mov    $0x7,%edi
  802bef:	48 b8 3d 29 80 00 00 	movabs $0x80293d,%rax
  802bf6:	00 00 00 
  802bf9:	ff d0                	callq  *%rax
}
  802bfb:	c9                   	leaveq 
  802bfc:	c3                   	retq   

0000000000802bfd <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802bfd:	55                   	push   %rbp
  802bfe:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802c01:	be 00 00 00 00       	mov    $0x0,%esi
  802c06:	bf 08 00 00 00       	mov    $0x8,%edi
  802c0b:	48 b8 3d 29 80 00 00 	movabs $0x80293d,%rax
  802c12:	00 00 00 
  802c15:	ff d0                	callq  *%rax
}
  802c17:	5d                   	pop    %rbp
  802c18:	c3                   	retq   

0000000000802c19 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802c19:	55                   	push   %rbp
  802c1a:	48 89 e5             	mov    %rsp,%rbp
  802c1d:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802c24:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802c2b:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802c32:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802c39:	be 00 00 00 00       	mov    $0x0,%esi
  802c3e:	48 89 c7             	mov    %rax,%rdi
  802c41:	48 b8 c6 29 80 00 00 	movabs $0x8029c6,%rax
  802c48:	00 00 00 
  802c4b:	ff d0                	callq  *%rax
  802c4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802c50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c54:	79 28                	jns    802c7e <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802c56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c59:	89 c6                	mov    %eax,%esi
  802c5b:	48 bf 69 46 80 00 00 	movabs $0x804669,%rdi
  802c62:	00 00 00 
  802c65:	b8 00 00 00 00       	mov    $0x0,%eax
  802c6a:	48 ba 88 04 80 00 00 	movabs $0x800488,%rdx
  802c71:	00 00 00 
  802c74:	ff d2                	callq  *%rdx
		return fd_src;
  802c76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c79:	e9 74 01 00 00       	jmpq   802df2 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802c7e:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802c85:	be 01 01 00 00       	mov    $0x101,%esi
  802c8a:	48 89 c7             	mov    %rax,%rdi
  802c8d:	48 b8 c6 29 80 00 00 	movabs $0x8029c6,%rax
  802c94:	00 00 00 
  802c97:	ff d0                	callq  *%rax
  802c99:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802c9c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ca0:	79 39                	jns    802cdb <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802ca2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ca5:	89 c6                	mov    %eax,%esi
  802ca7:	48 bf 7f 46 80 00 00 	movabs $0x80467f,%rdi
  802cae:	00 00 00 
  802cb1:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb6:	48 ba 88 04 80 00 00 	movabs $0x800488,%rdx
  802cbd:	00 00 00 
  802cc0:	ff d2                	callq  *%rdx
		close(fd_src);
  802cc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc5:	89 c7                	mov    %eax,%edi
  802cc7:	48 b8 cc 22 80 00 00 	movabs $0x8022cc,%rax
  802cce:	00 00 00 
  802cd1:	ff d0                	callq  *%rax
		return fd_dest;
  802cd3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cd6:	e9 17 01 00 00       	jmpq   802df2 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802cdb:	eb 74                	jmp    802d51 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802cdd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ce0:	48 63 d0             	movslq %eax,%rdx
  802ce3:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802cea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ced:	48 89 ce             	mov    %rcx,%rsi
  802cf0:	89 c7                	mov    %eax,%edi
  802cf2:	48 b8 38 26 80 00 00 	movabs $0x802638,%rax
  802cf9:	00 00 00 
  802cfc:	ff d0                	callq  *%rax
  802cfe:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802d01:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802d05:	79 4a                	jns    802d51 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802d07:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d0a:	89 c6                	mov    %eax,%esi
  802d0c:	48 bf 99 46 80 00 00 	movabs $0x804699,%rdi
  802d13:	00 00 00 
  802d16:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1b:	48 ba 88 04 80 00 00 	movabs $0x800488,%rdx
  802d22:	00 00 00 
  802d25:	ff d2                	callq  *%rdx
			close(fd_src);
  802d27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d2a:	89 c7                	mov    %eax,%edi
  802d2c:	48 b8 cc 22 80 00 00 	movabs $0x8022cc,%rax
  802d33:	00 00 00 
  802d36:	ff d0                	callq  *%rax
			close(fd_dest);
  802d38:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d3b:	89 c7                	mov    %eax,%edi
  802d3d:	48 b8 cc 22 80 00 00 	movabs $0x8022cc,%rax
  802d44:	00 00 00 
  802d47:	ff d0                	callq  *%rax
			return write_size;
  802d49:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d4c:	e9 a1 00 00 00       	jmpq   802df2 <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d51:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d5b:	ba 00 02 00 00       	mov    $0x200,%edx
  802d60:	48 89 ce             	mov    %rcx,%rsi
  802d63:	89 c7                	mov    %eax,%edi
  802d65:	48 b8 ee 24 80 00 00 	movabs $0x8024ee,%rax
  802d6c:	00 00 00 
  802d6f:	ff d0                	callq  *%rax
  802d71:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802d74:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d78:	0f 8f 5f ff ff ff    	jg     802cdd <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  802d7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d82:	79 47                	jns    802dcb <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802d84:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d87:	89 c6                	mov    %eax,%esi
  802d89:	48 bf ac 46 80 00 00 	movabs $0x8046ac,%rdi
  802d90:	00 00 00 
  802d93:	b8 00 00 00 00       	mov    $0x0,%eax
  802d98:	48 ba 88 04 80 00 00 	movabs $0x800488,%rdx
  802d9f:	00 00 00 
  802da2:	ff d2                	callq  *%rdx
		close(fd_src);
  802da4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da7:	89 c7                	mov    %eax,%edi
  802da9:	48 b8 cc 22 80 00 00 	movabs $0x8022cc,%rax
  802db0:	00 00 00 
  802db3:	ff d0                	callq  *%rax
		close(fd_dest);
  802db5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802db8:	89 c7                	mov    %eax,%edi
  802dba:	48 b8 cc 22 80 00 00 	movabs $0x8022cc,%rax
  802dc1:	00 00 00 
  802dc4:	ff d0                	callq  *%rax
		return read_size;
  802dc6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802dc9:	eb 27                	jmp    802df2 <copy+0x1d9>
	}
	close(fd_src);
  802dcb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dce:	89 c7                	mov    %eax,%edi
  802dd0:	48 b8 cc 22 80 00 00 	movabs $0x8022cc,%rax
  802dd7:	00 00 00 
  802dda:	ff d0                	callq  *%rax
	close(fd_dest);
  802ddc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ddf:	89 c7                	mov    %eax,%edi
  802de1:	48 b8 cc 22 80 00 00 	movabs $0x8022cc,%rax
  802de8:	00 00 00 
  802deb:	ff d0                	callq  *%rax
	return 0;
  802ded:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802df2:	c9                   	leaveq 
  802df3:	c3                   	retq   

0000000000802df4 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802df4:	55                   	push   %rbp
  802df5:	48 89 e5             	mov    %rsp,%rbp
  802df8:	48 83 ec 20          	sub    $0x20,%rsp
  802dfc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802dff:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e03:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e06:	48 89 d6             	mov    %rdx,%rsi
  802e09:	89 c7                	mov    %eax,%edi
  802e0b:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  802e12:	00 00 00 
  802e15:	ff d0                	callq  *%rax
  802e17:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e1e:	79 05                	jns    802e25 <fd2sockid+0x31>
		return r;
  802e20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e23:	eb 24                	jmp    802e49 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802e25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e29:	8b 10                	mov    (%rax),%edx
  802e2b:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802e32:	00 00 00 
  802e35:	8b 00                	mov    (%rax),%eax
  802e37:	39 c2                	cmp    %eax,%edx
  802e39:	74 07                	je     802e42 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802e3b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e40:	eb 07                	jmp    802e49 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802e42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e46:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802e49:	c9                   	leaveq 
  802e4a:	c3                   	retq   

0000000000802e4b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802e4b:	55                   	push   %rbp
  802e4c:	48 89 e5             	mov    %rsp,%rbp
  802e4f:	48 83 ec 20          	sub    $0x20,%rsp
  802e53:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802e56:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802e5a:	48 89 c7             	mov    %rax,%rdi
  802e5d:	48 b8 22 20 80 00 00 	movabs $0x802022,%rax
  802e64:	00 00 00 
  802e67:	ff d0                	callq  *%rax
  802e69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e70:	78 26                	js     802e98 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802e72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e76:	ba 07 04 00 00       	mov    $0x407,%edx
  802e7b:	48 89 c6             	mov    %rax,%rsi
  802e7e:	bf 00 00 00 00       	mov    $0x0,%edi
  802e83:	48 b8 4f 19 80 00 00 	movabs $0x80194f,%rax
  802e8a:	00 00 00 
  802e8d:	ff d0                	callq  *%rax
  802e8f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e92:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e96:	79 16                	jns    802eae <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802e98:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e9b:	89 c7                	mov    %eax,%edi
  802e9d:	48 b8 5a 33 80 00 00 	movabs $0x80335a,%rax
  802ea4:	00 00 00 
  802ea7:	ff d0                	callq  *%rax
		return r;
  802ea9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eac:	eb 3a                	jmp    802ee8 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802eae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eb2:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802eb9:	00 00 00 
  802ebc:	8b 12                	mov    (%rdx),%edx
  802ebe:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802ec0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ec4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802ecb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ecf:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ed2:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802ed5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ed9:	48 89 c7             	mov    %rax,%rdi
  802edc:	48 b8 d4 1f 80 00 00 	movabs $0x801fd4,%rax
  802ee3:	00 00 00 
  802ee6:	ff d0                	callq  *%rax
}
  802ee8:	c9                   	leaveq 
  802ee9:	c3                   	retq   

0000000000802eea <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802eea:	55                   	push   %rbp
  802eeb:	48 89 e5             	mov    %rsp,%rbp
  802eee:	48 83 ec 30          	sub    $0x30,%rsp
  802ef2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ef5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ef9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802efd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f00:	89 c7                	mov    %eax,%edi
  802f02:	48 b8 f4 2d 80 00 00 	movabs $0x802df4,%rax
  802f09:	00 00 00 
  802f0c:	ff d0                	callq  *%rax
  802f0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f11:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f15:	79 05                	jns    802f1c <accept+0x32>
		return r;
  802f17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f1a:	eb 3b                	jmp    802f57 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802f1c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f20:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f27:	48 89 ce             	mov    %rcx,%rsi
  802f2a:	89 c7                	mov    %eax,%edi
  802f2c:	48 b8 37 32 80 00 00 	movabs $0x803237,%rax
  802f33:	00 00 00 
  802f36:	ff d0                	callq  *%rax
  802f38:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f3f:	79 05                	jns    802f46 <accept+0x5c>
		return r;
  802f41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f44:	eb 11                	jmp    802f57 <accept+0x6d>
	return alloc_sockfd(r);
  802f46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f49:	89 c7                	mov    %eax,%edi
  802f4b:	48 b8 4b 2e 80 00 00 	movabs $0x802e4b,%rax
  802f52:	00 00 00 
  802f55:	ff d0                	callq  *%rax
}
  802f57:	c9                   	leaveq 
  802f58:	c3                   	retq   

0000000000802f59 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802f59:	55                   	push   %rbp
  802f5a:	48 89 e5             	mov    %rsp,%rbp
  802f5d:	48 83 ec 20          	sub    $0x20,%rsp
  802f61:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f64:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f68:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f6b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f6e:	89 c7                	mov    %eax,%edi
  802f70:	48 b8 f4 2d 80 00 00 	movabs $0x802df4,%rax
  802f77:	00 00 00 
  802f7a:	ff d0                	callq  *%rax
  802f7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f83:	79 05                	jns    802f8a <bind+0x31>
		return r;
  802f85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f88:	eb 1b                	jmp    802fa5 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802f8a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f8d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f94:	48 89 ce             	mov    %rcx,%rsi
  802f97:	89 c7                	mov    %eax,%edi
  802f99:	48 b8 b6 32 80 00 00 	movabs $0x8032b6,%rax
  802fa0:	00 00 00 
  802fa3:	ff d0                	callq  *%rax
}
  802fa5:	c9                   	leaveq 
  802fa6:	c3                   	retq   

0000000000802fa7 <shutdown>:

int
shutdown(int s, int how)
{
  802fa7:	55                   	push   %rbp
  802fa8:	48 89 e5             	mov    %rsp,%rbp
  802fab:	48 83 ec 20          	sub    $0x20,%rsp
  802faf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fb2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fb5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fb8:	89 c7                	mov    %eax,%edi
  802fba:	48 b8 f4 2d 80 00 00 	movabs $0x802df4,%rax
  802fc1:	00 00 00 
  802fc4:	ff d0                	callq  *%rax
  802fc6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fc9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fcd:	79 05                	jns    802fd4 <shutdown+0x2d>
		return r;
  802fcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fd2:	eb 16                	jmp    802fea <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802fd4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802fd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fda:	89 d6                	mov    %edx,%esi
  802fdc:	89 c7                	mov    %eax,%edi
  802fde:	48 b8 1a 33 80 00 00 	movabs $0x80331a,%rax
  802fe5:	00 00 00 
  802fe8:	ff d0                	callq  *%rax
}
  802fea:	c9                   	leaveq 
  802feb:	c3                   	retq   

0000000000802fec <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802fec:	55                   	push   %rbp
  802fed:	48 89 e5             	mov    %rsp,%rbp
  802ff0:	48 83 ec 10          	sub    $0x10,%rsp
  802ff4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802ff8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ffc:	48 89 c7             	mov    %rax,%rdi
  802fff:	48 b8 7c 3e 80 00 00 	movabs $0x803e7c,%rax
  803006:	00 00 00 
  803009:	ff d0                	callq  *%rax
  80300b:	83 f8 01             	cmp    $0x1,%eax
  80300e:	75 17                	jne    803027 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803010:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803014:	8b 40 0c             	mov    0xc(%rax),%eax
  803017:	89 c7                	mov    %eax,%edi
  803019:	48 b8 5a 33 80 00 00 	movabs $0x80335a,%rax
  803020:	00 00 00 
  803023:	ff d0                	callq  *%rax
  803025:	eb 05                	jmp    80302c <devsock_close+0x40>
	else
		return 0;
  803027:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80302c:	c9                   	leaveq 
  80302d:	c3                   	retq   

000000000080302e <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80302e:	55                   	push   %rbp
  80302f:	48 89 e5             	mov    %rsp,%rbp
  803032:	48 83 ec 20          	sub    $0x20,%rsp
  803036:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803039:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80303d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803040:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803043:	89 c7                	mov    %eax,%edi
  803045:	48 b8 f4 2d 80 00 00 	movabs $0x802df4,%rax
  80304c:	00 00 00 
  80304f:	ff d0                	callq  *%rax
  803051:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803054:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803058:	79 05                	jns    80305f <connect+0x31>
		return r;
  80305a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80305d:	eb 1b                	jmp    80307a <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80305f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803062:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803066:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803069:	48 89 ce             	mov    %rcx,%rsi
  80306c:	89 c7                	mov    %eax,%edi
  80306e:	48 b8 87 33 80 00 00 	movabs $0x803387,%rax
  803075:	00 00 00 
  803078:	ff d0                	callq  *%rax
}
  80307a:	c9                   	leaveq 
  80307b:	c3                   	retq   

000000000080307c <listen>:

int
listen(int s, int backlog)
{
  80307c:	55                   	push   %rbp
  80307d:	48 89 e5             	mov    %rsp,%rbp
  803080:	48 83 ec 20          	sub    $0x20,%rsp
  803084:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803087:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80308a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80308d:	89 c7                	mov    %eax,%edi
  80308f:	48 b8 f4 2d 80 00 00 	movabs $0x802df4,%rax
  803096:	00 00 00 
  803099:	ff d0                	callq  *%rax
  80309b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80309e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030a2:	79 05                	jns    8030a9 <listen+0x2d>
		return r;
  8030a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a7:	eb 16                	jmp    8030bf <listen+0x43>
	return nsipc_listen(r, backlog);
  8030a9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030af:	89 d6                	mov    %edx,%esi
  8030b1:	89 c7                	mov    %eax,%edi
  8030b3:	48 b8 eb 33 80 00 00 	movabs $0x8033eb,%rax
  8030ba:	00 00 00 
  8030bd:	ff d0                	callq  *%rax
}
  8030bf:	c9                   	leaveq 
  8030c0:	c3                   	retq   

00000000008030c1 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8030c1:	55                   	push   %rbp
  8030c2:	48 89 e5             	mov    %rsp,%rbp
  8030c5:	48 83 ec 20          	sub    $0x20,%rsp
  8030c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030cd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8030d1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8030d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030d9:	89 c2                	mov    %eax,%edx
  8030db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030df:	8b 40 0c             	mov    0xc(%rax),%eax
  8030e2:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8030e6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8030eb:	89 c7                	mov    %eax,%edi
  8030ed:	48 b8 2b 34 80 00 00 	movabs $0x80342b,%rax
  8030f4:	00 00 00 
  8030f7:	ff d0                	callq  *%rax
}
  8030f9:	c9                   	leaveq 
  8030fa:	c3                   	retq   

00000000008030fb <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8030fb:	55                   	push   %rbp
  8030fc:	48 89 e5             	mov    %rsp,%rbp
  8030ff:	48 83 ec 20          	sub    $0x20,%rsp
  803103:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803107:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80310b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80310f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803113:	89 c2                	mov    %eax,%edx
  803115:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803119:	8b 40 0c             	mov    0xc(%rax),%eax
  80311c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803120:	b9 00 00 00 00       	mov    $0x0,%ecx
  803125:	89 c7                	mov    %eax,%edi
  803127:	48 b8 f7 34 80 00 00 	movabs $0x8034f7,%rax
  80312e:	00 00 00 
  803131:	ff d0                	callq  *%rax
}
  803133:	c9                   	leaveq 
  803134:	c3                   	retq   

0000000000803135 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803135:	55                   	push   %rbp
  803136:	48 89 e5             	mov    %rsp,%rbp
  803139:	48 83 ec 10          	sub    $0x10,%rsp
  80313d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803141:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803145:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803149:	48 be c7 46 80 00 00 	movabs $0x8046c7,%rsi
  803150:	00 00 00 
  803153:	48 89 c7             	mov    %rax,%rdi
  803156:	48 b8 22 10 80 00 00 	movabs $0x801022,%rax
  80315d:	00 00 00 
  803160:	ff d0                	callq  *%rax
	return 0;
  803162:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803167:	c9                   	leaveq 
  803168:	c3                   	retq   

0000000000803169 <socket>:

int
socket(int domain, int type, int protocol)
{
  803169:	55                   	push   %rbp
  80316a:	48 89 e5             	mov    %rsp,%rbp
  80316d:	48 83 ec 20          	sub    $0x20,%rsp
  803171:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803174:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803177:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80317a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80317d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803180:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803183:	89 ce                	mov    %ecx,%esi
  803185:	89 c7                	mov    %eax,%edi
  803187:	48 b8 af 35 80 00 00 	movabs $0x8035af,%rax
  80318e:	00 00 00 
  803191:	ff d0                	callq  *%rax
  803193:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803196:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80319a:	79 05                	jns    8031a1 <socket+0x38>
		return r;
  80319c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80319f:	eb 11                	jmp    8031b2 <socket+0x49>
	return alloc_sockfd(r);
  8031a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031a4:	89 c7                	mov    %eax,%edi
  8031a6:	48 b8 4b 2e 80 00 00 	movabs $0x802e4b,%rax
  8031ad:	00 00 00 
  8031b0:	ff d0                	callq  *%rax
}
  8031b2:	c9                   	leaveq 
  8031b3:	c3                   	retq   

00000000008031b4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8031b4:	55                   	push   %rbp
  8031b5:	48 89 e5             	mov    %rsp,%rbp
  8031b8:	48 83 ec 10          	sub    $0x10,%rsp
  8031bc:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8031bf:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8031c6:	00 00 00 
  8031c9:	8b 00                	mov    (%rax),%eax
  8031cb:	85 c0                	test   %eax,%eax
  8031cd:	75 1f                	jne    8031ee <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8031cf:	bf 02 00 00 00       	mov    $0x2,%edi
  8031d4:	48 b8 62 1f 80 00 00 	movabs $0x801f62,%rax
  8031db:	00 00 00 
  8031de:	ff d0                	callq  *%rax
  8031e0:	89 c2                	mov    %eax,%edx
  8031e2:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8031e9:	00 00 00 
  8031ec:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8031ee:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8031f5:	00 00 00 
  8031f8:	8b 00                	mov    (%rax),%eax
  8031fa:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8031fd:	b9 07 00 00 00       	mov    $0x7,%ecx
  803202:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803209:	00 00 00 
  80320c:	89 c7                	mov    %eax,%edi
  80320e:	48 b8 d5 1d 80 00 00 	movabs $0x801dd5,%rax
  803215:	00 00 00 
  803218:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80321a:	ba 00 00 00 00       	mov    $0x0,%edx
  80321f:	be 00 00 00 00       	mov    $0x0,%esi
  803224:	bf 00 00 00 00       	mov    $0x0,%edi
  803229:	48 b8 97 1d 80 00 00 	movabs $0x801d97,%rax
  803230:	00 00 00 
  803233:	ff d0                	callq  *%rax
}
  803235:	c9                   	leaveq 
  803236:	c3                   	retq   

0000000000803237 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803237:	55                   	push   %rbp
  803238:	48 89 e5             	mov    %rsp,%rbp
  80323b:	48 83 ec 30          	sub    $0x30,%rsp
  80323f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803242:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803246:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80324a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803251:	00 00 00 
  803254:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803257:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803259:	bf 01 00 00 00       	mov    $0x1,%edi
  80325e:	48 b8 b4 31 80 00 00 	movabs $0x8031b4,%rax
  803265:	00 00 00 
  803268:	ff d0                	callq  *%rax
  80326a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80326d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803271:	78 3e                	js     8032b1 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803273:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80327a:	00 00 00 
  80327d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803281:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803285:	8b 40 10             	mov    0x10(%rax),%eax
  803288:	89 c2                	mov    %eax,%edx
  80328a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80328e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803292:	48 89 ce             	mov    %rcx,%rsi
  803295:	48 89 c7             	mov    %rax,%rdi
  803298:	48 b8 46 13 80 00 00 	movabs $0x801346,%rax
  80329f:	00 00 00 
  8032a2:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8032a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032a8:	8b 50 10             	mov    0x10(%rax),%edx
  8032ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032af:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8032b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8032b4:	c9                   	leaveq 
  8032b5:	c3                   	retq   

00000000008032b6 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8032b6:	55                   	push   %rbp
  8032b7:	48 89 e5             	mov    %rsp,%rbp
  8032ba:	48 83 ec 10          	sub    $0x10,%rsp
  8032be:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032c1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8032c5:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8032c8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032cf:	00 00 00 
  8032d2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032d5:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8032d7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032de:	48 89 c6             	mov    %rax,%rsi
  8032e1:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8032e8:	00 00 00 
  8032eb:	48 b8 46 13 80 00 00 	movabs $0x801346,%rax
  8032f2:	00 00 00 
  8032f5:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8032f7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032fe:	00 00 00 
  803301:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803304:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803307:	bf 02 00 00 00       	mov    $0x2,%edi
  80330c:	48 b8 b4 31 80 00 00 	movabs $0x8031b4,%rax
  803313:	00 00 00 
  803316:	ff d0                	callq  *%rax
}
  803318:	c9                   	leaveq 
  803319:	c3                   	retq   

000000000080331a <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80331a:	55                   	push   %rbp
  80331b:	48 89 e5             	mov    %rsp,%rbp
  80331e:	48 83 ec 10          	sub    $0x10,%rsp
  803322:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803325:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803328:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80332f:	00 00 00 
  803332:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803335:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803337:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80333e:	00 00 00 
  803341:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803344:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803347:	bf 03 00 00 00       	mov    $0x3,%edi
  80334c:	48 b8 b4 31 80 00 00 	movabs $0x8031b4,%rax
  803353:	00 00 00 
  803356:	ff d0                	callq  *%rax
}
  803358:	c9                   	leaveq 
  803359:	c3                   	retq   

000000000080335a <nsipc_close>:

int
nsipc_close(int s)
{
  80335a:	55                   	push   %rbp
  80335b:	48 89 e5             	mov    %rsp,%rbp
  80335e:	48 83 ec 10          	sub    $0x10,%rsp
  803362:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803365:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80336c:	00 00 00 
  80336f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803372:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803374:	bf 04 00 00 00       	mov    $0x4,%edi
  803379:	48 b8 b4 31 80 00 00 	movabs $0x8031b4,%rax
  803380:	00 00 00 
  803383:	ff d0                	callq  *%rax
}
  803385:	c9                   	leaveq 
  803386:	c3                   	retq   

0000000000803387 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803387:	55                   	push   %rbp
  803388:	48 89 e5             	mov    %rsp,%rbp
  80338b:	48 83 ec 10          	sub    $0x10,%rsp
  80338f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803392:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803396:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803399:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033a0:	00 00 00 
  8033a3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033a6:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8033a8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033af:	48 89 c6             	mov    %rax,%rsi
  8033b2:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8033b9:	00 00 00 
  8033bc:	48 b8 46 13 80 00 00 	movabs $0x801346,%rax
  8033c3:	00 00 00 
  8033c6:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8033c8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033cf:	00 00 00 
  8033d2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033d5:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8033d8:	bf 05 00 00 00       	mov    $0x5,%edi
  8033dd:	48 b8 b4 31 80 00 00 	movabs $0x8031b4,%rax
  8033e4:	00 00 00 
  8033e7:	ff d0                	callq  *%rax
}
  8033e9:	c9                   	leaveq 
  8033ea:	c3                   	retq   

00000000008033eb <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8033eb:	55                   	push   %rbp
  8033ec:	48 89 e5             	mov    %rsp,%rbp
  8033ef:	48 83 ec 10          	sub    $0x10,%rsp
  8033f3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033f6:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8033f9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803400:	00 00 00 
  803403:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803406:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803408:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80340f:	00 00 00 
  803412:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803415:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803418:	bf 06 00 00 00       	mov    $0x6,%edi
  80341d:	48 b8 b4 31 80 00 00 	movabs $0x8031b4,%rax
  803424:	00 00 00 
  803427:	ff d0                	callq  *%rax
}
  803429:	c9                   	leaveq 
  80342a:	c3                   	retq   

000000000080342b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80342b:	55                   	push   %rbp
  80342c:	48 89 e5             	mov    %rsp,%rbp
  80342f:	48 83 ec 30          	sub    $0x30,%rsp
  803433:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803436:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80343a:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80343d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803440:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803447:	00 00 00 
  80344a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80344d:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80344f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803456:	00 00 00 
  803459:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80345c:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80345f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803466:	00 00 00 
  803469:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80346c:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80346f:	bf 07 00 00 00       	mov    $0x7,%edi
  803474:	48 b8 b4 31 80 00 00 	movabs $0x8031b4,%rax
  80347b:	00 00 00 
  80347e:	ff d0                	callq  *%rax
  803480:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803483:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803487:	78 69                	js     8034f2 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803489:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803490:	7f 08                	jg     80349a <nsipc_recv+0x6f>
  803492:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803495:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803498:	7e 35                	jle    8034cf <nsipc_recv+0xa4>
  80349a:	48 b9 ce 46 80 00 00 	movabs $0x8046ce,%rcx
  8034a1:	00 00 00 
  8034a4:	48 ba e3 46 80 00 00 	movabs $0x8046e3,%rdx
  8034ab:	00 00 00 
  8034ae:	be 61 00 00 00       	mov    $0x61,%esi
  8034b3:	48 bf f8 46 80 00 00 	movabs $0x8046f8,%rdi
  8034ba:	00 00 00 
  8034bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c2:	49 b8 4f 02 80 00 00 	movabs $0x80024f,%r8
  8034c9:	00 00 00 
  8034cc:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8034cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034d2:	48 63 d0             	movslq %eax,%rdx
  8034d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034d9:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8034e0:	00 00 00 
  8034e3:	48 89 c7             	mov    %rax,%rdi
  8034e6:	48 b8 46 13 80 00 00 	movabs $0x801346,%rax
  8034ed:	00 00 00 
  8034f0:	ff d0                	callq  *%rax
	}

	return r;
  8034f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8034f5:	c9                   	leaveq 
  8034f6:	c3                   	retq   

00000000008034f7 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8034f7:	55                   	push   %rbp
  8034f8:	48 89 e5             	mov    %rsp,%rbp
  8034fb:	48 83 ec 20          	sub    $0x20,%rsp
  8034ff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803502:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803506:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803509:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80350c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803513:	00 00 00 
  803516:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803519:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80351b:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803522:	7e 35                	jle    803559 <nsipc_send+0x62>
  803524:	48 b9 04 47 80 00 00 	movabs $0x804704,%rcx
  80352b:	00 00 00 
  80352e:	48 ba e3 46 80 00 00 	movabs $0x8046e3,%rdx
  803535:	00 00 00 
  803538:	be 6c 00 00 00       	mov    $0x6c,%esi
  80353d:	48 bf f8 46 80 00 00 	movabs $0x8046f8,%rdi
  803544:	00 00 00 
  803547:	b8 00 00 00 00       	mov    $0x0,%eax
  80354c:	49 b8 4f 02 80 00 00 	movabs $0x80024f,%r8
  803553:	00 00 00 
  803556:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803559:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80355c:	48 63 d0             	movslq %eax,%rdx
  80355f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803563:	48 89 c6             	mov    %rax,%rsi
  803566:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80356d:	00 00 00 
  803570:	48 b8 46 13 80 00 00 	movabs $0x801346,%rax
  803577:	00 00 00 
  80357a:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80357c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803583:	00 00 00 
  803586:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803589:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80358c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803593:	00 00 00 
  803596:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803599:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80359c:	bf 08 00 00 00       	mov    $0x8,%edi
  8035a1:	48 b8 b4 31 80 00 00 	movabs $0x8031b4,%rax
  8035a8:	00 00 00 
  8035ab:	ff d0                	callq  *%rax
}
  8035ad:	c9                   	leaveq 
  8035ae:	c3                   	retq   

00000000008035af <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8035af:	55                   	push   %rbp
  8035b0:	48 89 e5             	mov    %rsp,%rbp
  8035b3:	48 83 ec 10          	sub    $0x10,%rsp
  8035b7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8035ba:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8035bd:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8035c0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035c7:	00 00 00 
  8035ca:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035cd:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8035cf:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035d6:	00 00 00 
  8035d9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035dc:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8035df:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035e6:	00 00 00 
  8035e9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8035ec:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8035ef:	bf 09 00 00 00       	mov    $0x9,%edi
  8035f4:	48 b8 b4 31 80 00 00 	movabs $0x8031b4,%rax
  8035fb:	00 00 00 
  8035fe:	ff d0                	callq  *%rax
}
  803600:	c9                   	leaveq 
  803601:	c3                   	retq   

0000000000803602 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803602:	55                   	push   %rbp
  803603:	48 89 e5             	mov    %rsp,%rbp
  803606:	53                   	push   %rbx
  803607:	48 83 ec 38          	sub    $0x38,%rsp
  80360b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80360f:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803613:	48 89 c7             	mov    %rax,%rdi
  803616:	48 b8 22 20 80 00 00 	movabs $0x802022,%rax
  80361d:	00 00 00 
  803620:	ff d0                	callq  *%rax
  803622:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803625:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803629:	0f 88 bf 01 00 00    	js     8037ee <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80362f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803633:	ba 07 04 00 00       	mov    $0x407,%edx
  803638:	48 89 c6             	mov    %rax,%rsi
  80363b:	bf 00 00 00 00       	mov    $0x0,%edi
  803640:	48 b8 4f 19 80 00 00 	movabs $0x80194f,%rax
  803647:	00 00 00 
  80364a:	ff d0                	callq  *%rax
  80364c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80364f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803653:	0f 88 95 01 00 00    	js     8037ee <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803659:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80365d:	48 89 c7             	mov    %rax,%rdi
  803660:	48 b8 22 20 80 00 00 	movabs $0x802022,%rax
  803667:	00 00 00 
  80366a:	ff d0                	callq  *%rax
  80366c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80366f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803673:	0f 88 5d 01 00 00    	js     8037d6 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803679:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80367d:	ba 07 04 00 00       	mov    $0x407,%edx
  803682:	48 89 c6             	mov    %rax,%rsi
  803685:	bf 00 00 00 00       	mov    $0x0,%edi
  80368a:	48 b8 4f 19 80 00 00 	movabs $0x80194f,%rax
  803691:	00 00 00 
  803694:	ff d0                	callq  *%rax
  803696:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803699:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80369d:	0f 88 33 01 00 00    	js     8037d6 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8036a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036a7:	48 89 c7             	mov    %rax,%rdi
  8036aa:	48 b8 f7 1f 80 00 00 	movabs $0x801ff7,%rax
  8036b1:	00 00 00 
  8036b4:	ff d0                	callq  *%rax
  8036b6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036be:	ba 07 04 00 00       	mov    $0x407,%edx
  8036c3:	48 89 c6             	mov    %rax,%rsi
  8036c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8036cb:	48 b8 4f 19 80 00 00 	movabs $0x80194f,%rax
  8036d2:	00 00 00 
  8036d5:	ff d0                	callq  *%rax
  8036d7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036da:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036de:	79 05                	jns    8036e5 <pipe+0xe3>
		goto err2;
  8036e0:	e9 d9 00 00 00       	jmpq   8037be <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036e5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036e9:	48 89 c7             	mov    %rax,%rdi
  8036ec:	48 b8 f7 1f 80 00 00 	movabs $0x801ff7,%rax
  8036f3:	00 00 00 
  8036f6:	ff d0                	callq  *%rax
  8036f8:	48 89 c2             	mov    %rax,%rdx
  8036fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036ff:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803705:	48 89 d1             	mov    %rdx,%rcx
  803708:	ba 00 00 00 00       	mov    $0x0,%edx
  80370d:	48 89 c6             	mov    %rax,%rsi
  803710:	bf 00 00 00 00       	mov    $0x0,%edi
  803715:	48 b8 a1 19 80 00 00 	movabs $0x8019a1,%rax
  80371c:	00 00 00 
  80371f:	ff d0                	callq  *%rax
  803721:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803724:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803728:	79 1b                	jns    803745 <pipe+0x143>
		goto err3;
  80372a:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80372b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80372f:	48 89 c6             	mov    %rax,%rsi
  803732:	bf 00 00 00 00       	mov    $0x0,%edi
  803737:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  80373e:	00 00 00 
  803741:	ff d0                	callq  *%rax
  803743:	eb 79                	jmp    8037be <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  803745:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803749:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803750:	00 00 00 
  803753:	8b 12                	mov    (%rdx),%edx
  803755:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803757:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80375b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  803762:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803766:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80376d:	00 00 00 
  803770:	8b 12                	mov    (%rdx),%edx
  803772:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803774:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803778:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  80377f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803783:	48 89 c7             	mov    %rax,%rdi
  803786:	48 b8 d4 1f 80 00 00 	movabs $0x801fd4,%rax
  80378d:	00 00 00 
  803790:	ff d0                	callq  *%rax
  803792:	89 c2                	mov    %eax,%edx
  803794:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803798:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80379a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80379e:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8037a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037a6:	48 89 c7             	mov    %rax,%rdi
  8037a9:	48 b8 d4 1f 80 00 00 	movabs $0x801fd4,%rax
  8037b0:	00 00 00 
  8037b3:	ff d0                	callq  *%rax
  8037b5:	89 03                	mov    %eax,(%rbx)
	return 0;
  8037b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8037bc:	eb 33                	jmp    8037f1 <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  8037be:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037c2:	48 89 c6             	mov    %rax,%rsi
  8037c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8037ca:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  8037d1:	00 00 00 
  8037d4:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8037d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037da:	48 89 c6             	mov    %rax,%rsi
  8037dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8037e2:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  8037e9:	00 00 00 
  8037ec:	ff d0                	callq  *%rax
err:
	return r;
  8037ee:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8037f1:	48 83 c4 38          	add    $0x38,%rsp
  8037f5:	5b                   	pop    %rbx
  8037f6:	5d                   	pop    %rbp
  8037f7:	c3                   	retq   

00000000008037f8 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8037f8:	55                   	push   %rbp
  8037f9:	48 89 e5             	mov    %rsp,%rbp
  8037fc:	53                   	push   %rbx
  8037fd:	48 83 ec 28          	sub    $0x28,%rsp
  803801:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803805:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803809:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803810:	00 00 00 
  803813:	48 8b 00             	mov    (%rax),%rax
  803816:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80381c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80381f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803823:	48 89 c7             	mov    %rax,%rdi
  803826:	48 b8 7c 3e 80 00 00 	movabs $0x803e7c,%rax
  80382d:	00 00 00 
  803830:	ff d0                	callq  *%rax
  803832:	89 c3                	mov    %eax,%ebx
  803834:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803838:	48 89 c7             	mov    %rax,%rdi
  80383b:	48 b8 7c 3e 80 00 00 	movabs $0x803e7c,%rax
  803842:	00 00 00 
  803845:	ff d0                	callq  *%rax
  803847:	39 c3                	cmp    %eax,%ebx
  803849:	0f 94 c0             	sete   %al
  80384c:	0f b6 c0             	movzbl %al,%eax
  80384f:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803852:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803859:	00 00 00 
  80385c:	48 8b 00             	mov    (%rax),%rax
  80385f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803865:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803868:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80386b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80386e:	75 05                	jne    803875 <_pipeisclosed+0x7d>
			return ret;
  803870:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803873:	eb 4a                	jmp    8038bf <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803875:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803878:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80387b:	74 3d                	je     8038ba <_pipeisclosed+0xc2>
  80387d:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803881:	75 37                	jne    8038ba <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803883:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80388a:	00 00 00 
  80388d:	48 8b 00             	mov    (%rax),%rax
  803890:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803896:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803899:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80389c:	89 c6                	mov    %eax,%esi
  80389e:	48 bf 15 47 80 00 00 	movabs $0x804715,%rdi
  8038a5:	00 00 00 
  8038a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8038ad:	49 b8 88 04 80 00 00 	movabs $0x800488,%r8
  8038b4:	00 00 00 
  8038b7:	41 ff d0             	callq  *%r8
	}
  8038ba:	e9 4a ff ff ff       	jmpq   803809 <_pipeisclosed+0x11>
}
  8038bf:	48 83 c4 28          	add    $0x28,%rsp
  8038c3:	5b                   	pop    %rbx
  8038c4:	5d                   	pop    %rbp
  8038c5:	c3                   	retq   

00000000008038c6 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8038c6:	55                   	push   %rbp
  8038c7:	48 89 e5             	mov    %rsp,%rbp
  8038ca:	48 83 ec 30          	sub    $0x30,%rsp
  8038ce:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038d1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8038d5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8038d8:	48 89 d6             	mov    %rdx,%rsi
  8038db:	89 c7                	mov    %eax,%edi
  8038dd:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  8038e4:	00 00 00 
  8038e7:	ff d0                	callq  *%rax
  8038e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038f0:	79 05                	jns    8038f7 <pipeisclosed+0x31>
		return r;
  8038f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038f5:	eb 31                	jmp    803928 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8038f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038fb:	48 89 c7             	mov    %rax,%rdi
  8038fe:	48 b8 f7 1f 80 00 00 	movabs $0x801ff7,%rax
  803905:	00 00 00 
  803908:	ff d0                	callq  *%rax
  80390a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80390e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803912:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803916:	48 89 d6             	mov    %rdx,%rsi
  803919:	48 89 c7             	mov    %rax,%rdi
  80391c:	48 b8 f8 37 80 00 00 	movabs $0x8037f8,%rax
  803923:	00 00 00 
  803926:	ff d0                	callq  *%rax
}
  803928:	c9                   	leaveq 
  803929:	c3                   	retq   

000000000080392a <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80392a:	55                   	push   %rbp
  80392b:	48 89 e5             	mov    %rsp,%rbp
  80392e:	48 83 ec 40          	sub    $0x40,%rsp
  803932:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803936:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80393a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80393e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803942:	48 89 c7             	mov    %rax,%rdi
  803945:	48 b8 f7 1f 80 00 00 	movabs $0x801ff7,%rax
  80394c:	00 00 00 
  80394f:	ff d0                	callq  *%rax
  803951:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803955:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803959:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80395d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803964:	00 
  803965:	e9 92 00 00 00       	jmpq   8039fc <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80396a:	eb 41                	jmp    8039ad <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80396c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803971:	74 09                	je     80397c <devpipe_read+0x52>
				return i;
  803973:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803977:	e9 92 00 00 00       	jmpq   803a0e <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80397c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803980:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803984:	48 89 d6             	mov    %rdx,%rsi
  803987:	48 89 c7             	mov    %rax,%rdi
  80398a:	48 b8 f8 37 80 00 00 	movabs $0x8037f8,%rax
  803991:	00 00 00 
  803994:	ff d0                	callq  *%rax
  803996:	85 c0                	test   %eax,%eax
  803998:	74 07                	je     8039a1 <devpipe_read+0x77>
				return 0;
  80399a:	b8 00 00 00 00       	mov    $0x0,%eax
  80399f:	eb 6d                	jmp    803a0e <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8039a1:	48 b8 13 19 80 00 00 	movabs $0x801913,%rax
  8039a8:	00 00 00 
  8039ab:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  8039ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039b1:	8b 10                	mov    (%rax),%edx
  8039b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039b7:	8b 40 04             	mov    0x4(%rax),%eax
  8039ba:	39 c2                	cmp    %eax,%edx
  8039bc:	74 ae                	je     80396c <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8039be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039c6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8039ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ce:	8b 00                	mov    (%rax),%eax
  8039d0:	99                   	cltd   
  8039d1:	c1 ea 1b             	shr    $0x1b,%edx
  8039d4:	01 d0                	add    %edx,%eax
  8039d6:	83 e0 1f             	and    $0x1f,%eax
  8039d9:	29 d0                	sub    %edx,%eax
  8039db:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039df:	48 98                	cltq   
  8039e1:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8039e6:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8039e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ec:	8b 00                	mov    (%rax),%eax
  8039ee:	8d 50 01             	lea    0x1(%rax),%edx
  8039f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039f5:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  8039f7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8039fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a00:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a04:	0f 82 60 ff ff ff    	jb     80396a <devpipe_read+0x40>
	}
	return i;
  803a0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a0e:	c9                   	leaveq 
  803a0f:	c3                   	retq   

0000000000803a10 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a10:	55                   	push   %rbp
  803a11:	48 89 e5             	mov    %rsp,%rbp
  803a14:	48 83 ec 40          	sub    $0x40,%rsp
  803a18:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a1c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a20:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803a24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a28:	48 89 c7             	mov    %rax,%rdi
  803a2b:	48 b8 f7 1f 80 00 00 	movabs $0x801ff7,%rax
  803a32:	00 00 00 
  803a35:	ff d0                	callq  *%rax
  803a37:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803a3b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a3f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803a43:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a4a:	00 
  803a4b:	e9 91 00 00 00       	jmpq   803ae1 <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a50:	eb 31                	jmp    803a83 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803a52:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a56:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a5a:	48 89 d6             	mov    %rdx,%rsi
  803a5d:	48 89 c7             	mov    %rax,%rdi
  803a60:	48 b8 f8 37 80 00 00 	movabs $0x8037f8,%rax
  803a67:	00 00 00 
  803a6a:	ff d0                	callq  *%rax
  803a6c:	85 c0                	test   %eax,%eax
  803a6e:	74 07                	je     803a77 <devpipe_write+0x67>
				return 0;
  803a70:	b8 00 00 00 00       	mov    $0x0,%eax
  803a75:	eb 7c                	jmp    803af3 <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803a77:	48 b8 13 19 80 00 00 	movabs $0x801913,%rax
  803a7e:	00 00 00 
  803a81:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a87:	8b 40 04             	mov    0x4(%rax),%eax
  803a8a:	48 63 d0             	movslq %eax,%rdx
  803a8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a91:	8b 00                	mov    (%rax),%eax
  803a93:	48 98                	cltq   
  803a95:	48 83 c0 20          	add    $0x20,%rax
  803a99:	48 39 c2             	cmp    %rax,%rdx
  803a9c:	73 b4                	jae    803a52 <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803a9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aa2:	8b 40 04             	mov    0x4(%rax),%eax
  803aa5:	99                   	cltd   
  803aa6:	c1 ea 1b             	shr    $0x1b,%edx
  803aa9:	01 d0                	add    %edx,%eax
  803aab:	83 e0 1f             	and    $0x1f,%eax
  803aae:	29 d0                	sub    %edx,%eax
  803ab0:	89 c6                	mov    %eax,%esi
  803ab2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803ab6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803aba:	48 01 d0             	add    %rdx,%rax
  803abd:	0f b6 08             	movzbl (%rax),%ecx
  803ac0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ac4:	48 63 c6             	movslq %esi,%rax
  803ac7:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803acb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803acf:	8b 40 04             	mov    0x4(%rax),%eax
  803ad2:	8d 50 01             	lea    0x1(%rax),%edx
  803ad5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ad9:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  803adc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ae1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ae5:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803ae9:	0f 82 61 ff ff ff    	jb     803a50 <devpipe_write+0x40>
	}

	return i;
  803aef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803af3:	c9                   	leaveq 
  803af4:	c3                   	retq   

0000000000803af5 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803af5:	55                   	push   %rbp
  803af6:	48 89 e5             	mov    %rsp,%rbp
  803af9:	48 83 ec 20          	sub    $0x20,%rsp
  803afd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b01:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803b05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b09:	48 89 c7             	mov    %rax,%rdi
  803b0c:	48 b8 f7 1f 80 00 00 	movabs $0x801ff7,%rax
  803b13:	00 00 00 
  803b16:	ff d0                	callq  *%rax
  803b18:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803b1c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b20:	48 be 28 47 80 00 00 	movabs $0x804728,%rsi
  803b27:	00 00 00 
  803b2a:	48 89 c7             	mov    %rax,%rdi
  803b2d:	48 b8 22 10 80 00 00 	movabs $0x801022,%rax
  803b34:	00 00 00 
  803b37:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803b39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b3d:	8b 50 04             	mov    0x4(%rax),%edx
  803b40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b44:	8b 00                	mov    (%rax),%eax
  803b46:	29 c2                	sub    %eax,%edx
  803b48:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b4c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803b52:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b56:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803b5d:	00 00 00 
	stat->st_dev = &devpipe;
  803b60:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b64:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803b6b:	00 00 00 
  803b6e:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803b75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b7a:	c9                   	leaveq 
  803b7b:	c3                   	retq   

0000000000803b7c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803b7c:	55                   	push   %rbp
  803b7d:	48 89 e5             	mov    %rsp,%rbp
  803b80:	48 83 ec 10          	sub    $0x10,%rsp
  803b84:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803b88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b8c:	48 89 c6             	mov    %rax,%rsi
  803b8f:	bf 00 00 00 00       	mov    $0x0,%edi
  803b94:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  803b9b:	00 00 00 
  803b9e:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803ba0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ba4:	48 89 c7             	mov    %rax,%rdi
  803ba7:	48 b8 f7 1f 80 00 00 	movabs $0x801ff7,%rax
  803bae:	00 00 00 
  803bb1:	ff d0                	callq  *%rax
  803bb3:	48 89 c6             	mov    %rax,%rsi
  803bb6:	bf 00 00 00 00       	mov    $0x0,%edi
  803bbb:	48 b8 01 1a 80 00 00 	movabs $0x801a01,%rax
  803bc2:	00 00 00 
  803bc5:	ff d0                	callq  *%rax
}
  803bc7:	c9                   	leaveq 
  803bc8:	c3                   	retq   

0000000000803bc9 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803bc9:	55                   	push   %rbp
  803bca:	48 89 e5             	mov    %rsp,%rbp
  803bcd:	48 83 ec 20          	sub    $0x20,%rsp
  803bd1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803bd4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bd7:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803bda:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803bde:	be 01 00 00 00       	mov    $0x1,%esi
  803be3:	48 89 c7             	mov    %rax,%rdi
  803be6:	48 b8 09 18 80 00 00 	movabs $0x801809,%rax
  803bed:	00 00 00 
  803bf0:	ff d0                	callq  *%rax
}
  803bf2:	c9                   	leaveq 
  803bf3:	c3                   	retq   

0000000000803bf4 <getchar>:

int
getchar(void)
{
  803bf4:	55                   	push   %rbp
  803bf5:	48 89 e5             	mov    %rsp,%rbp
  803bf8:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803bfc:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803c00:	ba 01 00 00 00       	mov    $0x1,%edx
  803c05:	48 89 c6             	mov    %rax,%rsi
  803c08:	bf 00 00 00 00       	mov    $0x0,%edi
  803c0d:	48 b8 ee 24 80 00 00 	movabs $0x8024ee,%rax
  803c14:	00 00 00 
  803c17:	ff d0                	callq  *%rax
  803c19:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803c1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c20:	79 05                	jns    803c27 <getchar+0x33>
		return r;
  803c22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c25:	eb 14                	jmp    803c3b <getchar+0x47>
	if (r < 1)
  803c27:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c2b:	7f 07                	jg     803c34 <getchar+0x40>
		return -E_EOF;
  803c2d:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803c32:	eb 07                	jmp    803c3b <getchar+0x47>
	return c;
  803c34:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803c38:	0f b6 c0             	movzbl %al,%eax
}
  803c3b:	c9                   	leaveq 
  803c3c:	c3                   	retq   

0000000000803c3d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803c3d:	55                   	push   %rbp
  803c3e:	48 89 e5             	mov    %rsp,%rbp
  803c41:	48 83 ec 20          	sub    $0x20,%rsp
  803c45:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c48:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803c4c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c4f:	48 89 d6             	mov    %rdx,%rsi
  803c52:	89 c7                	mov    %eax,%edi
  803c54:	48 b8 ba 20 80 00 00 	movabs $0x8020ba,%rax
  803c5b:	00 00 00 
  803c5e:	ff d0                	callq  *%rax
  803c60:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c63:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c67:	79 05                	jns    803c6e <iscons+0x31>
		return r;
  803c69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c6c:	eb 1a                	jmp    803c88 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803c6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c72:	8b 10                	mov    (%rax),%edx
  803c74:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803c7b:	00 00 00 
  803c7e:	8b 00                	mov    (%rax),%eax
  803c80:	39 c2                	cmp    %eax,%edx
  803c82:	0f 94 c0             	sete   %al
  803c85:	0f b6 c0             	movzbl %al,%eax
}
  803c88:	c9                   	leaveq 
  803c89:	c3                   	retq   

0000000000803c8a <opencons>:

int
opencons(void)
{
  803c8a:	55                   	push   %rbp
  803c8b:	48 89 e5             	mov    %rsp,%rbp
  803c8e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803c92:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803c96:	48 89 c7             	mov    %rax,%rdi
  803c99:	48 b8 22 20 80 00 00 	movabs $0x802022,%rax
  803ca0:	00 00 00 
  803ca3:	ff d0                	callq  *%rax
  803ca5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ca8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cac:	79 05                	jns    803cb3 <opencons+0x29>
		return r;
  803cae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cb1:	eb 5b                	jmp    803d0e <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803cb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cb7:	ba 07 04 00 00       	mov    $0x407,%edx
  803cbc:	48 89 c6             	mov    %rax,%rsi
  803cbf:	bf 00 00 00 00       	mov    $0x0,%edi
  803cc4:	48 b8 4f 19 80 00 00 	movabs $0x80194f,%rax
  803ccb:	00 00 00 
  803cce:	ff d0                	callq  *%rax
  803cd0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cd3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cd7:	79 05                	jns    803cde <opencons+0x54>
		return r;
  803cd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cdc:	eb 30                	jmp    803d0e <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803cde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ce2:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803ce9:	00 00 00 
  803cec:	8b 12                	mov    (%rdx),%edx
  803cee:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803cf0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cf4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803cfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cff:	48 89 c7             	mov    %rax,%rdi
  803d02:	48 b8 d4 1f 80 00 00 	movabs $0x801fd4,%rax
  803d09:	00 00 00 
  803d0c:	ff d0                	callq  *%rax
}
  803d0e:	c9                   	leaveq 
  803d0f:	c3                   	retq   

0000000000803d10 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d10:	55                   	push   %rbp
  803d11:	48 89 e5             	mov    %rsp,%rbp
  803d14:	48 83 ec 30          	sub    $0x30,%rsp
  803d18:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d1c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d20:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803d24:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d29:	75 07                	jne    803d32 <devcons_read+0x22>
		return 0;
  803d2b:	b8 00 00 00 00       	mov    $0x0,%eax
  803d30:	eb 4b                	jmp    803d7d <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803d32:	eb 0c                	jmp    803d40 <devcons_read+0x30>
		sys_yield();
  803d34:	48 b8 13 19 80 00 00 	movabs $0x801913,%rax
  803d3b:	00 00 00 
  803d3e:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  803d40:	48 b8 55 18 80 00 00 	movabs $0x801855,%rax
  803d47:	00 00 00 
  803d4a:	ff d0                	callq  *%rax
  803d4c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d4f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d53:	74 df                	je     803d34 <devcons_read+0x24>
	if (c < 0)
  803d55:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d59:	79 05                	jns    803d60 <devcons_read+0x50>
		return c;
  803d5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d5e:	eb 1d                	jmp    803d7d <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803d60:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803d64:	75 07                	jne    803d6d <devcons_read+0x5d>
		return 0;
  803d66:	b8 00 00 00 00       	mov    $0x0,%eax
  803d6b:	eb 10                	jmp    803d7d <devcons_read+0x6d>
	*(char*)vbuf = c;
  803d6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d70:	89 c2                	mov    %eax,%edx
  803d72:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d76:	88 10                	mov    %dl,(%rax)
	return 1;
  803d78:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803d7d:	c9                   	leaveq 
  803d7e:	c3                   	retq   

0000000000803d7f <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d7f:	55                   	push   %rbp
  803d80:	48 89 e5             	mov    %rsp,%rbp
  803d83:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803d8a:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803d91:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803d98:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d9f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803da6:	eb 76                	jmp    803e1e <devcons_write+0x9f>
		m = n - tot;
  803da8:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803daf:	89 c2                	mov    %eax,%edx
  803db1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803db4:	29 c2                	sub    %eax,%edx
  803db6:	89 d0                	mov    %edx,%eax
  803db8:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803dbb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dbe:	83 f8 7f             	cmp    $0x7f,%eax
  803dc1:	76 07                	jbe    803dca <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803dc3:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803dca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dcd:	48 63 d0             	movslq %eax,%rdx
  803dd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dd3:	48 63 c8             	movslq %eax,%rcx
  803dd6:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803ddd:	48 01 c1             	add    %rax,%rcx
  803de0:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803de7:	48 89 ce             	mov    %rcx,%rsi
  803dea:	48 89 c7             	mov    %rax,%rdi
  803ded:	48 b8 46 13 80 00 00 	movabs $0x801346,%rax
  803df4:	00 00 00 
  803df7:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803df9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dfc:	48 63 d0             	movslq %eax,%rdx
  803dff:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e06:	48 89 d6             	mov    %rdx,%rsi
  803e09:	48 89 c7             	mov    %rax,%rdi
  803e0c:	48 b8 09 18 80 00 00 	movabs $0x801809,%rax
  803e13:	00 00 00 
  803e16:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  803e18:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e1b:	01 45 fc             	add    %eax,-0x4(%rbp)
  803e1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e21:	48 98                	cltq   
  803e23:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803e2a:	0f 82 78 ff ff ff    	jb     803da8 <devcons_write+0x29>
	}
	return tot;
  803e30:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e33:	c9                   	leaveq 
  803e34:	c3                   	retq   

0000000000803e35 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803e35:	55                   	push   %rbp
  803e36:	48 89 e5             	mov    %rsp,%rbp
  803e39:	48 83 ec 08          	sub    $0x8,%rsp
  803e3d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803e41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e46:	c9                   	leaveq 
  803e47:	c3                   	retq   

0000000000803e48 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803e48:	55                   	push   %rbp
  803e49:	48 89 e5             	mov    %rsp,%rbp
  803e4c:	48 83 ec 10          	sub    $0x10,%rsp
  803e50:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e54:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803e58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e5c:	48 be 34 47 80 00 00 	movabs $0x804734,%rsi
  803e63:	00 00 00 
  803e66:	48 89 c7             	mov    %rax,%rdi
  803e69:	48 b8 22 10 80 00 00 	movabs $0x801022,%rax
  803e70:	00 00 00 
  803e73:	ff d0                	callq  *%rax
	return 0;
  803e75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e7a:	c9                   	leaveq 
  803e7b:	c3                   	retq   

0000000000803e7c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803e7c:	55                   	push   %rbp
  803e7d:	48 89 e5             	mov    %rsp,%rbp
  803e80:	48 83 ec 18          	sub    $0x18,%rsp
  803e84:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803e88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e8c:	48 c1 e8 15          	shr    $0x15,%rax
  803e90:	48 89 c2             	mov    %rax,%rdx
  803e93:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803e9a:	01 00 00 
  803e9d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ea1:	83 e0 01             	and    $0x1,%eax
  803ea4:	48 85 c0             	test   %rax,%rax
  803ea7:	75 07                	jne    803eb0 <pageref+0x34>
		return 0;
  803ea9:	b8 00 00 00 00       	mov    $0x0,%eax
  803eae:	eb 53                	jmp    803f03 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803eb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803eb4:	48 c1 e8 0c          	shr    $0xc,%rax
  803eb8:	48 89 c2             	mov    %rax,%rdx
  803ebb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803ec2:	01 00 00 
  803ec5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ec9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803ecd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ed1:	83 e0 01             	and    $0x1,%eax
  803ed4:	48 85 c0             	test   %rax,%rax
  803ed7:	75 07                	jne    803ee0 <pageref+0x64>
		return 0;
  803ed9:	b8 00 00 00 00       	mov    $0x0,%eax
  803ede:	eb 23                	jmp    803f03 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803ee0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ee4:	48 c1 e8 0c          	shr    $0xc,%rax
  803ee8:	48 89 c2             	mov    %rax,%rdx
  803eeb:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803ef2:	00 00 00 
  803ef5:	48 c1 e2 04          	shl    $0x4,%rdx
  803ef9:	48 01 d0             	add    %rdx,%rax
  803efc:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803f00:	0f b7 c0             	movzwl %ax,%eax
}
  803f03:	c9                   	leaveq 
  803f04:	c3                   	retq   
