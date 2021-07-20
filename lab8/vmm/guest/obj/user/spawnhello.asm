
vmm/guest/obj/user/spawnhello:     formato del fichero elf64-x86-64


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
  80003c:	e8 a6 00 00 00       	callq  8000e7 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800052:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800059:	00 00 00 
  80005c:	48 8b 00             	mov    (%rax),%rax
  80005f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800065:	89 c6                	mov    %eax,%esi
  800067:	48 bf c0 47 80 00 00 	movabs $0x8047c0,%rdi
  80006e:	00 00 00 
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
  800076:	48 ba a3 03 80 00 00 	movabs $0x8003a3,%rdx
  80007d:	00 00 00 
  800080:	ff d2                	callq  *%rdx
	if ((r = spawnl("/bin/hello", "hello", 0)) < 0)
  800082:	ba 00 00 00 00       	mov    $0x0,%edx
  800087:	48 be de 47 80 00 00 	movabs $0x8047de,%rsi
  80008e:	00 00 00 
  800091:	48 bf e4 47 80 00 00 	movabs $0x8047e4,%rdi
  800098:	00 00 00 
  80009b:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a0:	48 b9 4b 2d 80 00 00 	movabs $0x802d4b,%rcx
  8000a7:	00 00 00 
  8000aa:	ff d1                	callq  *%rcx
  8000ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000b3:	79 30                	jns    8000e5 <umain+0xa2>
		panic("spawn(hello) failed: %e", r);
  8000b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000b8:	89 c1                	mov    %eax,%ecx
  8000ba:	48 ba ef 47 80 00 00 	movabs $0x8047ef,%rdx
  8000c1:	00 00 00 
  8000c4:	be 09 00 00 00       	mov    $0x9,%esi
  8000c9:	48 bf 07 48 80 00 00 	movabs $0x804807,%rdi
  8000d0:	00 00 00 
  8000d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d8:	49 b8 6a 01 80 00 00 	movabs $0x80016a,%r8
  8000df:	00 00 00 
  8000e2:	41 ff d0             	callq  *%r8
}
  8000e5:	c9                   	leaveq 
  8000e6:	c3                   	retq   

00000000008000e7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e7:	55                   	push   %rbp
  8000e8:	48 89 e5             	mov    %rsp,%rbp
  8000eb:	48 83 ec 10          	sub    $0x10,%rsp
  8000ef:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000f2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8000f6:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8000fd:	00 00 00 
  800100:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800107:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80010b:	7e 14                	jle    800121 <libmain+0x3a>
		binaryname = argv[0];
  80010d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800111:	48 8b 10             	mov    (%rax),%rdx
  800114:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80011b:	00 00 00 
  80011e:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800121:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800125:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800128:	48 89 d6             	mov    %rdx,%rsi
  80012b:	89 c7                	mov    %eax,%edi
  80012d:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800139:	48 b8 47 01 80 00 00 	movabs $0x800147,%rax
  800140:	00 00 00 
  800143:	ff d0                	callq  *%rax
}
  800145:	c9                   	leaveq 
  800146:	c3                   	retq   

0000000000800147 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800147:	55                   	push   %rbp
  800148:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80014b:	48 b8 15 1f 80 00 00 	movabs $0x801f15,%rax
  800152:	00 00 00 
  800155:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800157:	bf 00 00 00 00       	mov    $0x0,%edi
  80015c:	48 b8 ac 17 80 00 00 	movabs $0x8017ac,%rax
  800163:	00 00 00 
  800166:	ff d0                	callq  *%rax
}
  800168:	5d                   	pop    %rbp
  800169:	c3                   	retq   

000000000080016a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80016a:	55                   	push   %rbp
  80016b:	48 89 e5             	mov    %rsp,%rbp
  80016e:	53                   	push   %rbx
  80016f:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800176:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80017d:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800183:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80018a:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800191:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800198:	84 c0                	test   %al,%al
  80019a:	74 23                	je     8001bf <_panic+0x55>
  80019c:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8001a3:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8001a7:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8001ab:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8001af:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8001b3:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8001b7:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8001bb:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8001bf:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8001c6:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8001cd:	00 00 00 
  8001d0:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8001d7:	00 00 00 
  8001da:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8001de:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8001e5:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8001ec:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001f3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8001fa:	00 00 00 
  8001fd:	48 8b 18             	mov    (%rax),%rbx
  800200:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  800207:	00 00 00 
  80020a:	ff d0                	callq  *%rax
  80020c:	89 c6                	mov    %eax,%esi
  80020e:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800214:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80021b:	41 89 d0             	mov    %edx,%r8d
  80021e:	48 89 c1             	mov    %rax,%rcx
  800221:	48 89 da             	mov    %rbx,%rdx
  800224:	48 bf 28 48 80 00 00 	movabs $0x804828,%rdi
  80022b:	00 00 00 
  80022e:	b8 00 00 00 00       	mov    $0x0,%eax
  800233:	49 b9 a3 03 80 00 00 	movabs $0x8003a3,%r9
  80023a:	00 00 00 
  80023d:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800240:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800247:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80024e:	48 89 d6             	mov    %rdx,%rsi
  800251:	48 89 c7             	mov    %rax,%rdi
  800254:	48 b8 f7 02 80 00 00 	movabs $0x8002f7,%rax
  80025b:	00 00 00 
  80025e:	ff d0                	callq  *%rax
	cprintf("\n");
  800260:	48 bf 4b 48 80 00 00 	movabs $0x80484b,%rdi
  800267:	00 00 00 
  80026a:	b8 00 00 00 00       	mov    $0x0,%eax
  80026f:	48 ba a3 03 80 00 00 	movabs $0x8003a3,%rdx
  800276:	00 00 00 
  800279:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80027b:	cc                   	int3   
  80027c:	eb fd                	jmp    80027b <_panic+0x111>

000000000080027e <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80027e:	55                   	push   %rbp
  80027f:	48 89 e5             	mov    %rsp,%rbp
  800282:	48 83 ec 10          	sub    $0x10,%rsp
  800286:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800289:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80028d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800291:	8b 00                	mov    (%rax),%eax
  800293:	8d 48 01             	lea    0x1(%rax),%ecx
  800296:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80029a:	89 0a                	mov    %ecx,(%rdx)
  80029c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80029f:	89 d1                	mov    %edx,%ecx
  8002a1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002a5:	48 98                	cltq   
  8002a7:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8002ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002af:	8b 00                	mov    (%rax),%eax
  8002b1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002b6:	75 2c                	jne    8002e4 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8002b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002bc:	8b 00                	mov    (%rax),%eax
  8002be:	48 98                	cltq   
  8002c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002c4:	48 83 c2 08          	add    $0x8,%rdx
  8002c8:	48 89 c6             	mov    %rax,%rsi
  8002cb:	48 89 d7             	mov    %rdx,%rdi
  8002ce:	48 b8 24 17 80 00 00 	movabs $0x801724,%rax
  8002d5:	00 00 00 
  8002d8:	ff d0                	callq  *%rax
        b->idx = 0;
  8002da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002de:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8002e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002e8:	8b 40 04             	mov    0x4(%rax),%eax
  8002eb:	8d 50 01             	lea    0x1(%rax),%edx
  8002ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002f2:	89 50 04             	mov    %edx,0x4(%rax)
}
  8002f5:	c9                   	leaveq 
  8002f6:	c3                   	retq   

00000000008002f7 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8002f7:	55                   	push   %rbp
  8002f8:	48 89 e5             	mov    %rsp,%rbp
  8002fb:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800302:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800309:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800310:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800317:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80031e:	48 8b 0a             	mov    (%rdx),%rcx
  800321:	48 89 08             	mov    %rcx,(%rax)
  800324:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800328:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80032c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800330:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800334:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80033b:	00 00 00 
    b.cnt = 0;
  80033e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800345:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800348:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80034f:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800356:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80035d:	48 89 c6             	mov    %rax,%rsi
  800360:	48 bf 7e 02 80 00 00 	movabs $0x80027e,%rdi
  800367:	00 00 00 
  80036a:	48 b8 42 07 80 00 00 	movabs $0x800742,%rax
  800371:	00 00 00 
  800374:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800376:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80037c:	48 98                	cltq   
  80037e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800385:	48 83 c2 08          	add    $0x8,%rdx
  800389:	48 89 c6             	mov    %rax,%rsi
  80038c:	48 89 d7             	mov    %rdx,%rdi
  80038f:	48 b8 24 17 80 00 00 	movabs $0x801724,%rax
  800396:	00 00 00 
  800399:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80039b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8003a1:	c9                   	leaveq 
  8003a2:	c3                   	retq   

00000000008003a3 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8003a3:	55                   	push   %rbp
  8003a4:	48 89 e5             	mov    %rsp,%rbp
  8003a7:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8003ae:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003b5:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003bc:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003c3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003ca:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8003d1:	84 c0                	test   %al,%al
  8003d3:	74 20                	je     8003f5 <cprintf+0x52>
  8003d5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8003d9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8003dd:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8003e1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8003e5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8003e9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8003ed:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8003f1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8003f5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8003fc:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800403:	00 00 00 
  800406:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80040d:	00 00 00 
  800410:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800414:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80041b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800422:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800429:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800430:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800437:	48 8b 0a             	mov    (%rdx),%rcx
  80043a:	48 89 08             	mov    %rcx,(%rax)
  80043d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800441:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800445:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800449:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80044d:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800454:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80045b:	48 89 d6             	mov    %rdx,%rsi
  80045e:	48 89 c7             	mov    %rax,%rdi
  800461:	48 b8 f7 02 80 00 00 	movabs $0x8002f7,%rax
  800468:	00 00 00 
  80046b:	ff d0                	callq  *%rax
  80046d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800473:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800479:	c9                   	leaveq 
  80047a:	c3                   	retq   

000000000080047b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80047b:	55                   	push   %rbp
  80047c:	48 89 e5             	mov    %rsp,%rbp
  80047f:	48 83 ec 30          	sub    $0x30,%rsp
  800483:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800487:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80048b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80048f:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800492:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800496:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80049a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80049d:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8004a1:	77 42                	ja     8004e5 <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004a3:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8004a6:	8d 78 ff             	lea    -0x1(%rax),%edi
  8004a9:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8004ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8004b5:	48 f7 f6             	div    %rsi
  8004b8:	49 89 c2             	mov    %rax,%r10
  8004bb:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8004be:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8004c1:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8004c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004c9:	41 89 c9             	mov    %ecx,%r9d
  8004cc:	41 89 f8             	mov    %edi,%r8d
  8004cf:	89 d1                	mov    %edx,%ecx
  8004d1:	4c 89 d2             	mov    %r10,%rdx
  8004d4:	48 89 c7             	mov    %rax,%rdi
  8004d7:	48 b8 7b 04 80 00 00 	movabs $0x80047b,%rax
  8004de:	00 00 00 
  8004e1:	ff d0                	callq  *%rax
  8004e3:	eb 1e                	jmp    800503 <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004e5:	eb 12                	jmp    8004f9 <printnum+0x7e>
			putch(padc, putdat);
  8004e7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8004eb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8004ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004f2:	48 89 ce             	mov    %rcx,%rsi
  8004f5:	89 d7                	mov    %edx,%edi
  8004f7:	ff d0                	callq  *%rax
		while (--width > 0)
  8004f9:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8004fd:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800501:	7f e4                	jg     8004e7 <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800503:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800506:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80050a:	ba 00 00 00 00       	mov    $0x0,%edx
  80050f:	48 f7 f1             	div    %rcx
  800512:	48 b8 70 4a 80 00 00 	movabs $0x804a70,%rax
  800519:	00 00 00 
  80051c:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800520:	0f be d0             	movsbl %al,%edx
  800523:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800527:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80052b:	48 89 ce             	mov    %rcx,%rsi
  80052e:	89 d7                	mov    %edx,%edi
  800530:	ff d0                	callq  *%rax
}
  800532:	c9                   	leaveq 
  800533:	c3                   	retq   

0000000000800534 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800534:	55                   	push   %rbp
  800535:	48 89 e5             	mov    %rsp,%rbp
  800538:	48 83 ec 20          	sub    $0x20,%rsp
  80053c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800540:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800543:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800547:	7e 4f                	jle    800598 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800549:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054d:	8b 00                	mov    (%rax),%eax
  80054f:	83 f8 30             	cmp    $0x30,%eax
  800552:	73 24                	jae    800578 <getuint+0x44>
  800554:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800558:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80055c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800560:	8b 00                	mov    (%rax),%eax
  800562:	89 c0                	mov    %eax,%eax
  800564:	48 01 d0             	add    %rdx,%rax
  800567:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80056b:	8b 12                	mov    (%rdx),%edx
  80056d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800570:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800574:	89 0a                	mov    %ecx,(%rdx)
  800576:	eb 14                	jmp    80058c <getuint+0x58>
  800578:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800580:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800584:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800588:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80058c:	48 8b 00             	mov    (%rax),%rax
  80058f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800593:	e9 9d 00 00 00       	jmpq   800635 <getuint+0x101>
	else if (lflag)
  800598:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80059c:	74 4c                	je     8005ea <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  80059e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a2:	8b 00                	mov    (%rax),%eax
  8005a4:	83 f8 30             	cmp    $0x30,%eax
  8005a7:	73 24                	jae    8005cd <getuint+0x99>
  8005a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ad:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b5:	8b 00                	mov    (%rax),%eax
  8005b7:	89 c0                	mov    %eax,%eax
  8005b9:	48 01 d0             	add    %rdx,%rax
  8005bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c0:	8b 12                	mov    (%rdx),%edx
  8005c2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c9:	89 0a                	mov    %ecx,(%rdx)
  8005cb:	eb 14                	jmp    8005e1 <getuint+0xad>
  8005cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8005d5:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8005d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005dd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005e1:	48 8b 00             	mov    (%rax),%rax
  8005e4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005e8:	eb 4b                	jmp    800635 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8005ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ee:	8b 00                	mov    (%rax),%eax
  8005f0:	83 f8 30             	cmp    $0x30,%eax
  8005f3:	73 24                	jae    800619 <getuint+0xe5>
  8005f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800601:	8b 00                	mov    (%rax),%eax
  800603:	89 c0                	mov    %eax,%eax
  800605:	48 01 d0             	add    %rdx,%rax
  800608:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060c:	8b 12                	mov    (%rdx),%edx
  80060e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800611:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800615:	89 0a                	mov    %ecx,(%rdx)
  800617:	eb 14                	jmp    80062d <getuint+0xf9>
  800619:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800621:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800625:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800629:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80062d:	8b 00                	mov    (%rax),%eax
  80062f:	89 c0                	mov    %eax,%eax
  800631:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800635:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800639:	c9                   	leaveq 
  80063a:	c3                   	retq   

000000000080063b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80063b:	55                   	push   %rbp
  80063c:	48 89 e5             	mov    %rsp,%rbp
  80063f:	48 83 ec 20          	sub    $0x20,%rsp
  800643:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800647:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80064a:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80064e:	7e 4f                	jle    80069f <getint+0x64>
		x=va_arg(*ap, long long);
  800650:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800654:	8b 00                	mov    (%rax),%eax
  800656:	83 f8 30             	cmp    $0x30,%eax
  800659:	73 24                	jae    80067f <getint+0x44>
  80065b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800663:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800667:	8b 00                	mov    (%rax),%eax
  800669:	89 c0                	mov    %eax,%eax
  80066b:	48 01 d0             	add    %rdx,%rax
  80066e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800672:	8b 12                	mov    (%rdx),%edx
  800674:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800677:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067b:	89 0a                	mov    %ecx,(%rdx)
  80067d:	eb 14                	jmp    800693 <getint+0x58>
  80067f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800683:	48 8b 40 08          	mov    0x8(%rax),%rax
  800687:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80068b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800693:	48 8b 00             	mov    (%rax),%rax
  800696:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80069a:	e9 9d 00 00 00       	jmpq   80073c <getint+0x101>
	else if (lflag)
  80069f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006a3:	74 4c                	je     8006f1 <getint+0xb6>
		x=va_arg(*ap, long);
  8006a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a9:	8b 00                	mov    (%rax),%eax
  8006ab:	83 f8 30             	cmp    $0x30,%eax
  8006ae:	73 24                	jae    8006d4 <getint+0x99>
  8006b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bc:	8b 00                	mov    (%rax),%eax
  8006be:	89 c0                	mov    %eax,%eax
  8006c0:	48 01 d0             	add    %rdx,%rax
  8006c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c7:	8b 12                	mov    (%rdx),%edx
  8006c9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d0:	89 0a                	mov    %ecx,(%rdx)
  8006d2:	eb 14                	jmp    8006e8 <getint+0xad>
  8006d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d8:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006dc:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006e8:	48 8b 00             	mov    (%rax),%rax
  8006eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006ef:	eb 4b                	jmp    80073c <getint+0x101>
	else
		x=va_arg(*ap, int);
  8006f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f5:	8b 00                	mov    (%rax),%eax
  8006f7:	83 f8 30             	cmp    $0x30,%eax
  8006fa:	73 24                	jae    800720 <getint+0xe5>
  8006fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800700:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800704:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800708:	8b 00                	mov    (%rax),%eax
  80070a:	89 c0                	mov    %eax,%eax
  80070c:	48 01 d0             	add    %rdx,%rax
  80070f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800713:	8b 12                	mov    (%rdx),%edx
  800715:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800718:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071c:	89 0a                	mov    %ecx,(%rdx)
  80071e:	eb 14                	jmp    800734 <getint+0xf9>
  800720:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800724:	48 8b 40 08          	mov    0x8(%rax),%rax
  800728:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80072c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800730:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800734:	8b 00                	mov    (%rax),%eax
  800736:	48 98                	cltq   
  800738:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80073c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800740:	c9                   	leaveq 
  800741:	c3                   	retq   

0000000000800742 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800742:	55                   	push   %rbp
  800743:	48 89 e5             	mov    %rsp,%rbp
  800746:	41 54                	push   %r12
  800748:	53                   	push   %rbx
  800749:	48 83 ec 60          	sub    $0x60,%rsp
  80074d:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800751:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800755:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800759:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80075d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800761:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800765:	48 8b 0a             	mov    (%rdx),%rcx
  800768:	48 89 08             	mov    %rcx,(%rax)
  80076b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80076f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800773:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800777:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077b:	eb 17                	jmp    800794 <vprintfmt+0x52>
			if (ch == '\0')
  80077d:	85 db                	test   %ebx,%ebx
  80077f:	0f 84 c5 04 00 00    	je     800c4a <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  800785:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800789:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80078d:	48 89 d6             	mov    %rdx,%rsi
  800790:	89 df                	mov    %ebx,%edi
  800792:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800794:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800798:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80079c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007a0:	0f b6 00             	movzbl (%rax),%eax
  8007a3:	0f b6 d8             	movzbl %al,%ebx
  8007a6:	83 fb 25             	cmp    $0x25,%ebx
  8007a9:	75 d2                	jne    80077d <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  8007ab:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8007af:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8007b6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8007bd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8007c4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007cb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007cf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007d3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007d7:	0f b6 00             	movzbl (%rax),%eax
  8007da:	0f b6 d8             	movzbl %al,%ebx
  8007dd:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8007e0:	83 f8 55             	cmp    $0x55,%eax
  8007e3:	0f 87 2e 04 00 00    	ja     800c17 <vprintfmt+0x4d5>
  8007e9:	89 c0                	mov    %eax,%eax
  8007eb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8007f2:	00 
  8007f3:	48 b8 98 4a 80 00 00 	movabs $0x804a98,%rax
  8007fa:	00 00 00 
  8007fd:	48 01 d0             	add    %rdx,%rax
  800800:	48 8b 00             	mov    (%rax),%rax
  800803:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800805:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800809:	eb c0                	jmp    8007cb <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80080b:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80080f:	eb ba                	jmp    8007cb <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800811:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800818:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80081b:	89 d0                	mov    %edx,%eax
  80081d:	c1 e0 02             	shl    $0x2,%eax
  800820:	01 d0                	add    %edx,%eax
  800822:	01 c0                	add    %eax,%eax
  800824:	01 d8                	add    %ebx,%eax
  800826:	83 e8 30             	sub    $0x30,%eax
  800829:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80082c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800830:	0f b6 00             	movzbl (%rax),%eax
  800833:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800836:	83 fb 2f             	cmp    $0x2f,%ebx
  800839:	7e 0c                	jle    800847 <vprintfmt+0x105>
  80083b:	83 fb 39             	cmp    $0x39,%ebx
  80083e:	7f 07                	jg     800847 <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  800840:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  800845:	eb d1                	jmp    800818 <vprintfmt+0xd6>
			goto process_precision;
  800847:	eb 50                	jmp    800899 <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  800849:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80084c:	83 f8 30             	cmp    $0x30,%eax
  80084f:	73 17                	jae    800868 <vprintfmt+0x126>
  800851:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800855:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800858:	89 d2                	mov    %edx,%edx
  80085a:	48 01 d0             	add    %rdx,%rax
  80085d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800860:	83 c2 08             	add    $0x8,%edx
  800863:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800866:	eb 0c                	jmp    800874 <vprintfmt+0x132>
  800868:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80086c:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800870:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800874:	8b 00                	mov    (%rax),%eax
  800876:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800879:	eb 1e                	jmp    800899 <vprintfmt+0x157>

		case '.':
			if (width < 0)
  80087b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80087f:	79 07                	jns    800888 <vprintfmt+0x146>
				width = 0;
  800881:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800888:	e9 3e ff ff ff       	jmpq   8007cb <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80088d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800894:	e9 32 ff ff ff       	jmpq   8007cb <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800899:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80089d:	79 0d                	jns    8008ac <vprintfmt+0x16a>
				width = precision, precision = -1;
  80089f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008a2:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8008a5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8008ac:	e9 1a ff ff ff       	jmpq   8007cb <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008b1:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8008b5:	e9 11 ff ff ff       	jmpq   8007cb <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8008ba:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008bd:	83 f8 30             	cmp    $0x30,%eax
  8008c0:	73 17                	jae    8008d9 <vprintfmt+0x197>
  8008c2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8008c6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008c9:	89 d2                	mov    %edx,%edx
  8008cb:	48 01 d0             	add    %rdx,%rax
  8008ce:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008d1:	83 c2 08             	add    $0x8,%edx
  8008d4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008d7:	eb 0c                	jmp    8008e5 <vprintfmt+0x1a3>
  8008d9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8008dd:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8008e1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008e5:	8b 10                	mov    (%rax),%edx
  8008e7:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008eb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008ef:	48 89 ce             	mov    %rcx,%rsi
  8008f2:	89 d7                	mov    %edx,%edi
  8008f4:	ff d0                	callq  *%rax
			break;
  8008f6:	e9 4a 03 00 00       	jmpq   800c45 <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8008fb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008fe:	83 f8 30             	cmp    $0x30,%eax
  800901:	73 17                	jae    80091a <vprintfmt+0x1d8>
  800903:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800907:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80090a:	89 d2                	mov    %edx,%edx
  80090c:	48 01 d0             	add    %rdx,%rax
  80090f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800912:	83 c2 08             	add    $0x8,%edx
  800915:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800918:	eb 0c                	jmp    800926 <vprintfmt+0x1e4>
  80091a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80091e:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800922:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800926:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800928:	85 db                	test   %ebx,%ebx
  80092a:	79 02                	jns    80092e <vprintfmt+0x1ec>
				err = -err;
  80092c:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80092e:	83 fb 15             	cmp    $0x15,%ebx
  800931:	7f 16                	jg     800949 <vprintfmt+0x207>
  800933:	48 b8 c0 49 80 00 00 	movabs $0x8049c0,%rax
  80093a:	00 00 00 
  80093d:	48 63 d3             	movslq %ebx,%rdx
  800940:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800944:	4d 85 e4             	test   %r12,%r12
  800947:	75 2e                	jne    800977 <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  800949:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80094d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800951:	89 d9                	mov    %ebx,%ecx
  800953:	48 ba 81 4a 80 00 00 	movabs $0x804a81,%rdx
  80095a:	00 00 00 
  80095d:	48 89 c7             	mov    %rax,%rdi
  800960:	b8 00 00 00 00       	mov    $0x0,%eax
  800965:	49 b8 53 0c 80 00 00 	movabs $0x800c53,%r8
  80096c:	00 00 00 
  80096f:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800972:	e9 ce 02 00 00       	jmpq   800c45 <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  800977:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80097b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80097f:	4c 89 e1             	mov    %r12,%rcx
  800982:	48 ba 8a 4a 80 00 00 	movabs $0x804a8a,%rdx
  800989:	00 00 00 
  80098c:	48 89 c7             	mov    %rax,%rdi
  80098f:	b8 00 00 00 00       	mov    $0x0,%eax
  800994:	49 b8 53 0c 80 00 00 	movabs $0x800c53,%r8
  80099b:	00 00 00 
  80099e:	41 ff d0             	callq  *%r8
			break;
  8009a1:	e9 9f 02 00 00       	jmpq   800c45 <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8009a6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a9:	83 f8 30             	cmp    $0x30,%eax
  8009ac:	73 17                	jae    8009c5 <vprintfmt+0x283>
  8009ae:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8009b2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009b5:	89 d2                	mov    %edx,%edx
  8009b7:	48 01 d0             	add    %rdx,%rax
  8009ba:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009bd:	83 c2 08             	add    $0x8,%edx
  8009c0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009c3:	eb 0c                	jmp    8009d1 <vprintfmt+0x28f>
  8009c5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8009c9:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8009cd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009d1:	4c 8b 20             	mov    (%rax),%r12
  8009d4:	4d 85 e4             	test   %r12,%r12
  8009d7:	75 0a                	jne    8009e3 <vprintfmt+0x2a1>
				p = "(null)";
  8009d9:	49 bc 8d 4a 80 00 00 	movabs $0x804a8d,%r12
  8009e0:	00 00 00 
			if (width > 0 && padc != '-')
  8009e3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009e7:	7e 3f                	jle    800a28 <vprintfmt+0x2e6>
  8009e9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8009ed:	74 39                	je     800a28 <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ef:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009f2:	48 98                	cltq   
  8009f4:	48 89 c6             	mov    %rax,%rsi
  8009f7:	4c 89 e7             	mov    %r12,%rdi
  8009fa:	48 b8 ff 0e 80 00 00 	movabs $0x800eff,%rax
  800a01:	00 00 00 
  800a04:	ff d0                	callq  *%rax
  800a06:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800a09:	eb 17                	jmp    800a22 <vprintfmt+0x2e0>
					putch(padc, putdat);
  800a0b:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800a0f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a13:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a17:	48 89 ce             	mov    %rcx,%rsi
  800a1a:	89 d7                	mov    %edx,%edi
  800a1c:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  800a1e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a22:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a26:	7f e3                	jg     800a0b <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a28:	eb 37                	jmp    800a61 <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  800a2a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800a2e:	74 1e                	je     800a4e <vprintfmt+0x30c>
  800a30:	83 fb 1f             	cmp    $0x1f,%ebx
  800a33:	7e 05                	jle    800a3a <vprintfmt+0x2f8>
  800a35:	83 fb 7e             	cmp    $0x7e,%ebx
  800a38:	7e 14                	jle    800a4e <vprintfmt+0x30c>
					putch('?', putdat);
  800a3a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a3e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a42:	48 89 d6             	mov    %rdx,%rsi
  800a45:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a4a:	ff d0                	callq  *%rax
  800a4c:	eb 0f                	jmp    800a5d <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  800a4e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a52:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a56:	48 89 d6             	mov    %rdx,%rsi
  800a59:	89 df                	mov    %ebx,%edi
  800a5b:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a5d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a61:	4c 89 e0             	mov    %r12,%rax
  800a64:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a68:	0f b6 00             	movzbl (%rax),%eax
  800a6b:	0f be d8             	movsbl %al,%ebx
  800a6e:	85 db                	test   %ebx,%ebx
  800a70:	74 10                	je     800a82 <vprintfmt+0x340>
  800a72:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a76:	78 b2                	js     800a2a <vprintfmt+0x2e8>
  800a78:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a7c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a80:	79 a8                	jns    800a2a <vprintfmt+0x2e8>
			for (; width > 0; width--)
  800a82:	eb 16                	jmp    800a9a <vprintfmt+0x358>
				putch(' ', putdat);
  800a84:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a88:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a8c:	48 89 d6             	mov    %rdx,%rsi
  800a8f:	bf 20 00 00 00       	mov    $0x20,%edi
  800a94:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  800a96:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a9a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a9e:	7f e4                	jg     800a84 <vprintfmt+0x342>
			break;
  800aa0:	e9 a0 01 00 00       	jmpq   800c45 <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800aa5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800aa9:	be 03 00 00 00       	mov    $0x3,%esi
  800aae:	48 89 c7             	mov    %rax,%rdi
  800ab1:	48 b8 3b 06 80 00 00 	movabs $0x80063b,%rax
  800ab8:	00 00 00 
  800abb:	ff d0                	callq  *%rax
  800abd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ac1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac5:	48 85 c0             	test   %rax,%rax
  800ac8:	79 1d                	jns    800ae7 <vprintfmt+0x3a5>
				putch('-', putdat);
  800aca:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ace:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ad2:	48 89 d6             	mov    %rdx,%rsi
  800ad5:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ada:	ff d0                	callq  *%rax
				num = -(long long) num;
  800adc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae0:	48 f7 d8             	neg    %rax
  800ae3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ae7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800aee:	e9 e5 00 00 00       	jmpq   800bd8 <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800af3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800af7:	be 03 00 00 00       	mov    $0x3,%esi
  800afc:	48 89 c7             	mov    %rax,%rdi
  800aff:	48 b8 34 05 80 00 00 	movabs $0x800534,%rax
  800b06:	00 00 00 
  800b09:	ff d0                	callq  *%rax
  800b0b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b0f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b16:	e9 bd 00 00 00       	jmpq   800bd8 <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b1b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b1f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b23:	48 89 d6             	mov    %rdx,%rsi
  800b26:	bf 58 00 00 00       	mov    $0x58,%edi
  800b2b:	ff d0                	callq  *%rax
			putch('X', putdat);
  800b2d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b31:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b35:	48 89 d6             	mov    %rdx,%rsi
  800b38:	bf 58 00 00 00       	mov    $0x58,%edi
  800b3d:	ff d0                	callq  *%rax
			putch('X', putdat);
  800b3f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b43:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b47:	48 89 d6             	mov    %rdx,%rsi
  800b4a:	bf 58 00 00 00       	mov    $0x58,%edi
  800b4f:	ff d0                	callq  *%rax
			break;
  800b51:	e9 ef 00 00 00       	jmpq   800c45 <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  800b56:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b5a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b5e:	48 89 d6             	mov    %rdx,%rsi
  800b61:	bf 30 00 00 00       	mov    $0x30,%edi
  800b66:	ff d0                	callq  *%rax
			putch('x', putdat);
  800b68:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b6c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b70:	48 89 d6             	mov    %rdx,%rsi
  800b73:	bf 78 00 00 00       	mov    $0x78,%edi
  800b78:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b7a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b7d:	83 f8 30             	cmp    $0x30,%eax
  800b80:	73 17                	jae    800b99 <vprintfmt+0x457>
  800b82:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b86:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b89:	89 d2                	mov    %edx,%edx
  800b8b:	48 01 d0             	add    %rdx,%rax
  800b8e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b91:	83 c2 08             	add    $0x8,%edx
  800b94:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  800b97:	eb 0c                	jmp    800ba5 <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  800b99:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b9d:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ba1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ba5:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  800ba8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800bac:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800bb3:	eb 23                	jmp    800bd8 <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800bb5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bb9:	be 03 00 00 00       	mov    $0x3,%esi
  800bbe:	48 89 c7             	mov    %rax,%rdi
  800bc1:	48 b8 34 05 80 00 00 	movabs $0x800534,%rax
  800bc8:	00 00 00 
  800bcb:	ff d0                	callq  *%rax
  800bcd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800bd1:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bd8:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800bdd:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800be0:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800be3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800be7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800beb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bef:	45 89 c1             	mov    %r8d,%r9d
  800bf2:	41 89 f8             	mov    %edi,%r8d
  800bf5:	48 89 c7             	mov    %rax,%rdi
  800bf8:	48 b8 7b 04 80 00 00 	movabs $0x80047b,%rax
  800bff:	00 00 00 
  800c02:	ff d0                	callq  *%rax
			break;
  800c04:	eb 3f                	jmp    800c45 <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c06:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c0e:	48 89 d6             	mov    %rdx,%rsi
  800c11:	89 df                	mov    %ebx,%edi
  800c13:	ff d0                	callq  *%rax
			break;
  800c15:	eb 2e                	jmp    800c45 <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c17:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c1b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1f:	48 89 d6             	mov    %rdx,%rsi
  800c22:	bf 25 00 00 00       	mov    $0x25,%edi
  800c27:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c29:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c2e:	eb 05                	jmp    800c35 <vprintfmt+0x4f3>
  800c30:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c35:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c39:	48 83 e8 01          	sub    $0x1,%rax
  800c3d:	0f b6 00             	movzbl (%rax),%eax
  800c40:	3c 25                	cmp    $0x25,%al
  800c42:	75 ec                	jne    800c30 <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  800c44:	90                   	nop
		}
	}
  800c45:	e9 31 fb ff ff       	jmpq   80077b <vprintfmt+0x39>
	va_end(aq);
}
  800c4a:	48 83 c4 60          	add    $0x60,%rsp
  800c4e:	5b                   	pop    %rbx
  800c4f:	41 5c                	pop    %r12
  800c51:	5d                   	pop    %rbp
  800c52:	c3                   	retq   

0000000000800c53 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c53:	55                   	push   %rbp
  800c54:	48 89 e5             	mov    %rsp,%rbp
  800c57:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800c5e:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800c65:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c6c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c73:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c7a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c81:	84 c0                	test   %al,%al
  800c83:	74 20                	je     800ca5 <printfmt+0x52>
  800c85:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c89:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c8d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c91:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c95:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c99:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c9d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ca1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ca5:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800cac:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800cb3:	00 00 00 
  800cb6:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800cbd:	00 00 00 
  800cc0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800cc4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800ccb:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800cd2:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800cd9:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ce0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ce7:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800cee:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800cf5:	48 89 c7             	mov    %rax,%rdi
  800cf8:	48 b8 42 07 80 00 00 	movabs $0x800742,%rax
  800cff:	00 00 00 
  800d02:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d04:	c9                   	leaveq 
  800d05:	c3                   	retq   

0000000000800d06 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d06:	55                   	push   %rbp
  800d07:	48 89 e5             	mov    %rsp,%rbp
  800d0a:	48 83 ec 10          	sub    $0x10,%rsp
  800d0e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d11:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d19:	8b 40 10             	mov    0x10(%rax),%eax
  800d1c:	8d 50 01             	lea    0x1(%rax),%edx
  800d1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d23:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d2a:	48 8b 10             	mov    (%rax),%rdx
  800d2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d31:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d35:	48 39 c2             	cmp    %rax,%rdx
  800d38:	73 17                	jae    800d51 <sprintputch+0x4b>
		*b->buf++ = ch;
  800d3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d3e:	48 8b 00             	mov    (%rax),%rax
  800d41:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800d45:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d49:	48 89 0a             	mov    %rcx,(%rdx)
  800d4c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d4f:	88 10                	mov    %dl,(%rax)
}
  800d51:	c9                   	leaveq 
  800d52:	c3                   	retq   

0000000000800d53 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d53:	55                   	push   %rbp
  800d54:	48 89 e5             	mov    %rsp,%rbp
  800d57:	48 83 ec 50          	sub    $0x50,%rsp
  800d5b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800d5f:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800d62:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800d66:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d6a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d6e:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d72:	48 8b 0a             	mov    (%rdx),%rcx
  800d75:	48 89 08             	mov    %rcx,(%rax)
  800d78:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d7c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d80:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d84:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d88:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d8c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d90:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d93:	48 98                	cltq   
  800d95:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d99:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d9d:	48 01 d0             	add    %rdx,%rax
  800da0:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800da4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800dab:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800db0:	74 06                	je     800db8 <vsnprintf+0x65>
  800db2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800db6:	7f 07                	jg     800dbf <vsnprintf+0x6c>
		return -E_INVAL;
  800db8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dbd:	eb 2f                	jmp    800dee <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800dbf:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800dc3:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800dc7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800dcb:	48 89 c6             	mov    %rax,%rsi
  800dce:	48 bf 06 0d 80 00 00 	movabs $0x800d06,%rdi
  800dd5:	00 00 00 
  800dd8:	48 b8 42 07 80 00 00 	movabs $0x800742,%rax
  800ddf:	00 00 00 
  800de2:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800de4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800de8:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800deb:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800dee:	c9                   	leaveq 
  800def:	c3                   	retq   

0000000000800df0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800df0:	55                   	push   %rbp
  800df1:	48 89 e5             	mov    %rsp,%rbp
  800df4:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800dfb:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e02:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e08:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e0f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e16:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e1d:	84 c0                	test   %al,%al
  800e1f:	74 20                	je     800e41 <snprintf+0x51>
  800e21:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e25:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e29:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e2d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e31:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e35:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e39:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e3d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e41:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e48:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e4f:	00 00 00 
  800e52:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e59:	00 00 00 
  800e5c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e60:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e67:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e6e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e75:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e7c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e83:	48 8b 0a             	mov    (%rdx),%rcx
  800e86:	48 89 08             	mov    %rcx,(%rax)
  800e89:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e8d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e91:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e95:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e99:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800ea0:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800ea7:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800ead:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800eb4:	48 89 c7             	mov    %rax,%rdi
  800eb7:	48 b8 53 0d 80 00 00 	movabs $0x800d53,%rax
  800ebe:	00 00 00 
  800ec1:	ff d0                	callq  *%rax
  800ec3:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800ec9:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800ecf:	c9                   	leaveq 
  800ed0:	c3                   	retq   

0000000000800ed1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ed1:	55                   	push   %rbp
  800ed2:	48 89 e5             	mov    %rsp,%rbp
  800ed5:	48 83 ec 18          	sub    $0x18,%rsp
  800ed9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800edd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ee4:	eb 09                	jmp    800eef <strlen+0x1e>
		n++;
  800ee6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  800eea:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800eef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef3:	0f b6 00             	movzbl (%rax),%eax
  800ef6:	84 c0                	test   %al,%al
  800ef8:	75 ec                	jne    800ee6 <strlen+0x15>
	return n;
  800efa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800efd:	c9                   	leaveq 
  800efe:	c3                   	retq   

0000000000800eff <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800eff:	55                   	push   %rbp
  800f00:	48 89 e5             	mov    %rsp,%rbp
  800f03:	48 83 ec 20          	sub    $0x20,%rsp
  800f07:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f0b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f16:	eb 0e                	jmp    800f26 <strnlen+0x27>
		n++;
  800f18:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f1c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f21:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f26:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f2b:	74 0b                	je     800f38 <strnlen+0x39>
  800f2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f31:	0f b6 00             	movzbl (%rax),%eax
  800f34:	84 c0                	test   %al,%al
  800f36:	75 e0                	jne    800f18 <strnlen+0x19>
	return n;
  800f38:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f3b:	c9                   	leaveq 
  800f3c:	c3                   	retq   

0000000000800f3d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f3d:	55                   	push   %rbp
  800f3e:	48 89 e5             	mov    %rsp,%rbp
  800f41:	48 83 ec 20          	sub    $0x20,%rsp
  800f45:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f49:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f51:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f55:	90                   	nop
  800f56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f5a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f5e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f62:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f66:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f6a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f6e:	0f b6 12             	movzbl (%rdx),%edx
  800f71:	88 10                	mov    %dl,(%rax)
  800f73:	0f b6 00             	movzbl (%rax),%eax
  800f76:	84 c0                	test   %al,%al
  800f78:	75 dc                	jne    800f56 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f7e:	c9                   	leaveq 
  800f7f:	c3                   	retq   

0000000000800f80 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f80:	55                   	push   %rbp
  800f81:	48 89 e5             	mov    %rsp,%rbp
  800f84:	48 83 ec 20          	sub    $0x20,%rsp
  800f88:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f8c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f94:	48 89 c7             	mov    %rax,%rdi
  800f97:	48 b8 d1 0e 80 00 00 	movabs $0x800ed1,%rax
  800f9e:	00 00 00 
  800fa1:	ff d0                	callq  *%rax
  800fa3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800fa6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fa9:	48 63 d0             	movslq %eax,%rdx
  800fac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb0:	48 01 c2             	add    %rax,%rdx
  800fb3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fb7:	48 89 c6             	mov    %rax,%rsi
  800fba:	48 89 d7             	mov    %rdx,%rdi
  800fbd:	48 b8 3d 0f 80 00 00 	movabs $0x800f3d,%rax
  800fc4:	00 00 00 
  800fc7:	ff d0                	callq  *%rax
	return dst;
  800fc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800fcd:	c9                   	leaveq 
  800fce:	c3                   	retq   

0000000000800fcf <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800fcf:	55                   	push   %rbp
  800fd0:	48 89 e5             	mov    %rsp,%rbp
  800fd3:	48 83 ec 28          	sub    $0x28,%rsp
  800fd7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fdb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fdf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800fe3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800feb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800ff2:	00 
  800ff3:	eb 2a                	jmp    80101f <strncpy+0x50>
		*dst++ = *src;
  800ff5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ffd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801001:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801005:	0f b6 12             	movzbl (%rdx),%edx
  801008:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80100a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80100e:	0f b6 00             	movzbl (%rax),%eax
  801011:	84 c0                	test   %al,%al
  801013:	74 05                	je     80101a <strncpy+0x4b>
			src++;
  801015:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  80101a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80101f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801023:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801027:	72 cc                	jb     800ff5 <strncpy+0x26>
	}
	return ret;
  801029:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80102d:	c9                   	leaveq 
  80102e:	c3                   	retq   

000000000080102f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80102f:	55                   	push   %rbp
  801030:	48 89 e5             	mov    %rsp,%rbp
  801033:	48 83 ec 28          	sub    $0x28,%rsp
  801037:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80103b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80103f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801043:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801047:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80104b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801050:	74 3d                	je     80108f <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801052:	eb 1d                	jmp    801071 <strlcpy+0x42>
			*dst++ = *src++;
  801054:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801058:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80105c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801060:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801064:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801068:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80106c:	0f b6 12             	movzbl (%rdx),%edx
  80106f:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  801071:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801076:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80107b:	74 0b                	je     801088 <strlcpy+0x59>
  80107d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801081:	0f b6 00             	movzbl (%rax),%eax
  801084:	84 c0                	test   %al,%al
  801086:	75 cc                	jne    801054 <strlcpy+0x25>
		*dst = '\0';
  801088:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108c:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80108f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801093:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801097:	48 29 c2             	sub    %rax,%rdx
  80109a:	48 89 d0             	mov    %rdx,%rax
}
  80109d:	c9                   	leaveq 
  80109e:	c3                   	retq   

000000000080109f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80109f:	55                   	push   %rbp
  8010a0:	48 89 e5             	mov    %rsp,%rbp
  8010a3:	48 83 ec 10          	sub    $0x10,%rsp
  8010a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8010af:	eb 0a                	jmp    8010bb <strcmp+0x1c>
		p++, q++;
  8010b1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010b6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  8010bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010bf:	0f b6 00             	movzbl (%rax),%eax
  8010c2:	84 c0                	test   %al,%al
  8010c4:	74 12                	je     8010d8 <strcmp+0x39>
  8010c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ca:	0f b6 10             	movzbl (%rax),%edx
  8010cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010d1:	0f b6 00             	movzbl (%rax),%eax
  8010d4:	38 c2                	cmp    %al,%dl
  8010d6:	74 d9                	je     8010b1 <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010dc:	0f b6 00             	movzbl (%rax),%eax
  8010df:	0f b6 d0             	movzbl %al,%edx
  8010e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e6:	0f b6 00             	movzbl (%rax),%eax
  8010e9:	0f b6 c0             	movzbl %al,%eax
  8010ec:	29 c2                	sub    %eax,%edx
  8010ee:	89 d0                	mov    %edx,%eax
}
  8010f0:	c9                   	leaveq 
  8010f1:	c3                   	retq   

00000000008010f2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8010f2:	55                   	push   %rbp
  8010f3:	48 89 e5             	mov    %rsp,%rbp
  8010f6:	48 83 ec 18          	sub    $0x18,%rsp
  8010fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801102:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801106:	eb 0f                	jmp    801117 <strncmp+0x25>
		n--, p++, q++;
  801108:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80110d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801112:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  801117:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80111c:	74 1d                	je     80113b <strncmp+0x49>
  80111e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801122:	0f b6 00             	movzbl (%rax),%eax
  801125:	84 c0                	test   %al,%al
  801127:	74 12                	je     80113b <strncmp+0x49>
  801129:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80112d:	0f b6 10             	movzbl (%rax),%edx
  801130:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801134:	0f b6 00             	movzbl (%rax),%eax
  801137:	38 c2                	cmp    %al,%dl
  801139:	74 cd                	je     801108 <strncmp+0x16>
	if (n == 0)
  80113b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801140:	75 07                	jne    801149 <strncmp+0x57>
		return 0;
  801142:	b8 00 00 00 00       	mov    $0x0,%eax
  801147:	eb 18                	jmp    801161 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801149:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80114d:	0f b6 00             	movzbl (%rax),%eax
  801150:	0f b6 d0             	movzbl %al,%edx
  801153:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801157:	0f b6 00             	movzbl (%rax),%eax
  80115a:	0f b6 c0             	movzbl %al,%eax
  80115d:	29 c2                	sub    %eax,%edx
  80115f:	89 d0                	mov    %edx,%eax
}
  801161:	c9                   	leaveq 
  801162:	c3                   	retq   

0000000000801163 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801163:	55                   	push   %rbp
  801164:	48 89 e5             	mov    %rsp,%rbp
  801167:	48 83 ec 10          	sub    $0x10,%rsp
  80116b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80116f:	89 f0                	mov    %esi,%eax
  801171:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801174:	eb 17                	jmp    80118d <strchr+0x2a>
		if (*s == c)
  801176:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80117a:	0f b6 00             	movzbl (%rax),%eax
  80117d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801180:	75 06                	jne    801188 <strchr+0x25>
			return (char *) s;
  801182:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801186:	eb 15                	jmp    80119d <strchr+0x3a>
	for (; *s; s++)
  801188:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80118d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801191:	0f b6 00             	movzbl (%rax),%eax
  801194:	84 c0                	test   %al,%al
  801196:	75 de                	jne    801176 <strchr+0x13>
	return 0;
  801198:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80119d:	c9                   	leaveq 
  80119e:	c3                   	retq   

000000000080119f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80119f:	55                   	push   %rbp
  8011a0:	48 89 e5             	mov    %rsp,%rbp
  8011a3:	48 83 ec 10          	sub    $0x10,%rsp
  8011a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011ab:	89 f0                	mov    %esi,%eax
  8011ad:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011b0:	eb 13                	jmp    8011c5 <strfind+0x26>
		if (*s == c)
  8011b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b6:	0f b6 00             	movzbl (%rax),%eax
  8011b9:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011bc:	75 02                	jne    8011c0 <strfind+0x21>
			break;
  8011be:	eb 10                	jmp    8011d0 <strfind+0x31>
	for (; *s; s++)
  8011c0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c9:	0f b6 00             	movzbl (%rax),%eax
  8011cc:	84 c0                	test   %al,%al
  8011ce:	75 e2                	jne    8011b2 <strfind+0x13>
	return (char *) s;
  8011d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011d4:	c9                   	leaveq 
  8011d5:	c3                   	retq   

00000000008011d6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8011d6:	55                   	push   %rbp
  8011d7:	48 89 e5             	mov    %rsp,%rbp
  8011da:	48 83 ec 18          	sub    $0x18,%rsp
  8011de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011e2:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8011e5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8011e9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011ee:	75 06                	jne    8011f6 <memset+0x20>
		return v;
  8011f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f4:	eb 69                	jmp    80125f <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8011f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fa:	83 e0 03             	and    $0x3,%eax
  8011fd:	48 85 c0             	test   %rax,%rax
  801200:	75 48                	jne    80124a <memset+0x74>
  801202:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801206:	83 e0 03             	and    $0x3,%eax
  801209:	48 85 c0             	test   %rax,%rax
  80120c:	75 3c                	jne    80124a <memset+0x74>
		c &= 0xFF;
  80120e:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801215:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801218:	c1 e0 18             	shl    $0x18,%eax
  80121b:	89 c2                	mov    %eax,%edx
  80121d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801220:	c1 e0 10             	shl    $0x10,%eax
  801223:	09 c2                	or     %eax,%edx
  801225:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801228:	c1 e0 08             	shl    $0x8,%eax
  80122b:	09 d0                	or     %edx,%eax
  80122d:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801230:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801234:	48 c1 e8 02          	shr    $0x2,%rax
  801238:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  80123b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80123f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801242:	48 89 d7             	mov    %rdx,%rdi
  801245:	fc                   	cld    
  801246:	f3 ab                	rep stos %eax,%es:(%rdi)
  801248:	eb 11                	jmp    80125b <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80124a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80124e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801251:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801255:	48 89 d7             	mov    %rdx,%rdi
  801258:	fc                   	cld    
  801259:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80125b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80125f:	c9                   	leaveq 
  801260:	c3                   	retq   

0000000000801261 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801261:	55                   	push   %rbp
  801262:	48 89 e5             	mov    %rsp,%rbp
  801265:	48 83 ec 28          	sub    $0x28,%rsp
  801269:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80126d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801271:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801275:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801279:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80127d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801281:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801285:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801289:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80128d:	0f 83 88 00 00 00    	jae    80131b <memmove+0xba>
  801293:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801297:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80129b:	48 01 d0             	add    %rdx,%rax
  80129e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012a2:	76 77                	jbe    80131b <memmove+0xba>
		s += n;
  8012a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012a8:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8012ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012b0:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b8:	83 e0 03             	and    $0x3,%eax
  8012bb:	48 85 c0             	test   %rax,%rax
  8012be:	75 3b                	jne    8012fb <memmove+0x9a>
  8012c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c4:	83 e0 03             	and    $0x3,%eax
  8012c7:	48 85 c0             	test   %rax,%rax
  8012ca:	75 2f                	jne    8012fb <memmove+0x9a>
  8012cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d0:	83 e0 03             	and    $0x3,%eax
  8012d3:	48 85 c0             	test   %rax,%rax
  8012d6:	75 23                	jne    8012fb <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8012d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012dc:	48 83 e8 04          	sub    $0x4,%rax
  8012e0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012e4:	48 83 ea 04          	sub    $0x4,%rdx
  8012e8:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012ec:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  8012f0:	48 89 c7             	mov    %rax,%rdi
  8012f3:	48 89 d6             	mov    %rdx,%rsi
  8012f6:	fd                   	std    
  8012f7:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012f9:	eb 1d                	jmp    801318 <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8012fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ff:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801303:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801307:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  80130b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80130f:	48 89 d7             	mov    %rdx,%rdi
  801312:	48 89 c1             	mov    %rax,%rcx
  801315:	fd                   	std    
  801316:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801318:	fc                   	cld    
  801319:	eb 57                	jmp    801372 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80131b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131f:	83 e0 03             	and    $0x3,%eax
  801322:	48 85 c0             	test   %rax,%rax
  801325:	75 36                	jne    80135d <memmove+0xfc>
  801327:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80132b:	83 e0 03             	and    $0x3,%eax
  80132e:	48 85 c0             	test   %rax,%rax
  801331:	75 2a                	jne    80135d <memmove+0xfc>
  801333:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801337:	83 e0 03             	and    $0x3,%eax
  80133a:	48 85 c0             	test   %rax,%rax
  80133d:	75 1e                	jne    80135d <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80133f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801343:	48 c1 e8 02          	shr    $0x2,%rax
  801347:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  80134a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80134e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801352:	48 89 c7             	mov    %rax,%rdi
  801355:	48 89 d6             	mov    %rdx,%rsi
  801358:	fc                   	cld    
  801359:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80135b:	eb 15                	jmp    801372 <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  80135d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801361:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801365:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801369:	48 89 c7             	mov    %rax,%rdi
  80136c:	48 89 d6             	mov    %rdx,%rsi
  80136f:	fc                   	cld    
  801370:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801372:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801376:	c9                   	leaveq 
  801377:	c3                   	retq   

0000000000801378 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801378:	55                   	push   %rbp
  801379:	48 89 e5             	mov    %rsp,%rbp
  80137c:	48 83 ec 18          	sub    $0x18,%rsp
  801380:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801384:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801388:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80138c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801390:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801394:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801398:	48 89 ce             	mov    %rcx,%rsi
  80139b:	48 89 c7             	mov    %rax,%rdi
  80139e:	48 b8 61 12 80 00 00 	movabs $0x801261,%rax
  8013a5:	00 00 00 
  8013a8:	ff d0                	callq  *%rax
}
  8013aa:	c9                   	leaveq 
  8013ab:	c3                   	retq   

00000000008013ac <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8013ac:	55                   	push   %rbp
  8013ad:	48 89 e5             	mov    %rsp,%rbp
  8013b0:	48 83 ec 28          	sub    $0x28,%rsp
  8013b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013b8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013bc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8013c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8013c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013cc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8013d0:	eb 36                	jmp    801408 <memcmp+0x5c>
		if (*s1 != *s2)
  8013d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d6:	0f b6 10             	movzbl (%rax),%edx
  8013d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013dd:	0f b6 00             	movzbl (%rax),%eax
  8013e0:	38 c2                	cmp    %al,%dl
  8013e2:	74 1a                	je     8013fe <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8013e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e8:	0f b6 00             	movzbl (%rax),%eax
  8013eb:	0f b6 d0             	movzbl %al,%edx
  8013ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f2:	0f b6 00             	movzbl (%rax),%eax
  8013f5:	0f b6 c0             	movzbl %al,%eax
  8013f8:	29 c2                	sub    %eax,%edx
  8013fa:	89 d0                	mov    %edx,%eax
  8013fc:	eb 20                	jmp    80141e <memcmp+0x72>
		s1++, s2++;
  8013fe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801403:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  801408:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801410:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801414:	48 85 c0             	test   %rax,%rax
  801417:	75 b9                	jne    8013d2 <memcmp+0x26>
	}

	return 0;
  801419:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80141e:	c9                   	leaveq 
  80141f:	c3                   	retq   

0000000000801420 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801420:	55                   	push   %rbp
  801421:	48 89 e5             	mov    %rsp,%rbp
  801424:	48 83 ec 28          	sub    $0x28,%rsp
  801428:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80142c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80142f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801433:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801437:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143b:	48 01 d0             	add    %rdx,%rax
  80143e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801442:	eb 15                	jmp    801459 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801444:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801448:	0f b6 00             	movzbl (%rax),%eax
  80144b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80144e:	38 d0                	cmp    %dl,%al
  801450:	75 02                	jne    801454 <memfind+0x34>
			break;
  801452:	eb 0f                	jmp    801463 <memfind+0x43>
	for (; s < ends; s++)
  801454:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801459:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80145d:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801461:	72 e1                	jb     801444 <memfind+0x24>
	return (void *) s;
  801463:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801467:	c9                   	leaveq 
  801468:	c3                   	retq   

0000000000801469 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801469:	55                   	push   %rbp
  80146a:	48 89 e5             	mov    %rsp,%rbp
  80146d:	48 83 ec 38          	sub    $0x38,%rsp
  801471:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801475:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801479:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80147c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801483:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80148a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80148b:	eb 05                	jmp    801492 <strtol+0x29>
		s++;
  80148d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  801492:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801496:	0f b6 00             	movzbl (%rax),%eax
  801499:	3c 20                	cmp    $0x20,%al
  80149b:	74 f0                	je     80148d <strtol+0x24>
  80149d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a1:	0f b6 00             	movzbl (%rax),%eax
  8014a4:	3c 09                	cmp    $0x9,%al
  8014a6:	74 e5                	je     80148d <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  8014a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ac:	0f b6 00             	movzbl (%rax),%eax
  8014af:	3c 2b                	cmp    $0x2b,%al
  8014b1:	75 07                	jne    8014ba <strtol+0x51>
		s++;
  8014b3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014b8:	eb 17                	jmp    8014d1 <strtol+0x68>
	else if (*s == '-')
  8014ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014be:	0f b6 00             	movzbl (%rax),%eax
  8014c1:	3c 2d                	cmp    $0x2d,%al
  8014c3:	75 0c                	jne    8014d1 <strtol+0x68>
		s++, neg = 1;
  8014c5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014d1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014d5:	74 06                	je     8014dd <strtol+0x74>
  8014d7:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8014db:	75 28                	jne    801505 <strtol+0x9c>
  8014dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e1:	0f b6 00             	movzbl (%rax),%eax
  8014e4:	3c 30                	cmp    $0x30,%al
  8014e6:	75 1d                	jne    801505 <strtol+0x9c>
  8014e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ec:	48 83 c0 01          	add    $0x1,%rax
  8014f0:	0f b6 00             	movzbl (%rax),%eax
  8014f3:	3c 78                	cmp    $0x78,%al
  8014f5:	75 0e                	jne    801505 <strtol+0x9c>
		s += 2, base = 16;
  8014f7:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8014fc:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801503:	eb 2c                	jmp    801531 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801505:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801509:	75 19                	jne    801524 <strtol+0xbb>
  80150b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150f:	0f b6 00             	movzbl (%rax),%eax
  801512:	3c 30                	cmp    $0x30,%al
  801514:	75 0e                	jne    801524 <strtol+0xbb>
		s++, base = 8;
  801516:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80151b:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801522:	eb 0d                	jmp    801531 <strtol+0xc8>
	else if (base == 0)
  801524:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801528:	75 07                	jne    801531 <strtol+0xc8>
		base = 10;
  80152a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801531:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801535:	0f b6 00             	movzbl (%rax),%eax
  801538:	3c 2f                	cmp    $0x2f,%al
  80153a:	7e 1d                	jle    801559 <strtol+0xf0>
  80153c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801540:	0f b6 00             	movzbl (%rax),%eax
  801543:	3c 39                	cmp    $0x39,%al
  801545:	7f 12                	jg     801559 <strtol+0xf0>
			dig = *s - '0';
  801547:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154b:	0f b6 00             	movzbl (%rax),%eax
  80154e:	0f be c0             	movsbl %al,%eax
  801551:	83 e8 30             	sub    $0x30,%eax
  801554:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801557:	eb 4e                	jmp    8015a7 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801559:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155d:	0f b6 00             	movzbl (%rax),%eax
  801560:	3c 60                	cmp    $0x60,%al
  801562:	7e 1d                	jle    801581 <strtol+0x118>
  801564:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801568:	0f b6 00             	movzbl (%rax),%eax
  80156b:	3c 7a                	cmp    $0x7a,%al
  80156d:	7f 12                	jg     801581 <strtol+0x118>
			dig = *s - 'a' + 10;
  80156f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801573:	0f b6 00             	movzbl (%rax),%eax
  801576:	0f be c0             	movsbl %al,%eax
  801579:	83 e8 57             	sub    $0x57,%eax
  80157c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80157f:	eb 26                	jmp    8015a7 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801581:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801585:	0f b6 00             	movzbl (%rax),%eax
  801588:	3c 40                	cmp    $0x40,%al
  80158a:	7e 48                	jle    8015d4 <strtol+0x16b>
  80158c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801590:	0f b6 00             	movzbl (%rax),%eax
  801593:	3c 5a                	cmp    $0x5a,%al
  801595:	7f 3d                	jg     8015d4 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801597:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159b:	0f b6 00             	movzbl (%rax),%eax
  80159e:	0f be c0             	movsbl %al,%eax
  8015a1:	83 e8 37             	sub    $0x37,%eax
  8015a4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8015a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015aa:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8015ad:	7c 02                	jl     8015b1 <strtol+0x148>
			break;
  8015af:	eb 23                	jmp    8015d4 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8015b1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015b6:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8015b9:	48 98                	cltq   
  8015bb:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8015c0:	48 89 c2             	mov    %rax,%rdx
  8015c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015c6:	48 98                	cltq   
  8015c8:	48 01 d0             	add    %rdx,%rax
  8015cb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8015cf:	e9 5d ff ff ff       	jmpq   801531 <strtol+0xc8>

	if (endptr)
  8015d4:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8015d9:	74 0b                	je     8015e6 <strtol+0x17d>
		*endptr = (char *) s;
  8015db:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015df:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8015e3:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8015e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015ea:	74 09                	je     8015f5 <strtol+0x18c>
  8015ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f0:	48 f7 d8             	neg    %rax
  8015f3:	eb 04                	jmp    8015f9 <strtol+0x190>
  8015f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8015f9:	c9                   	leaveq 
  8015fa:	c3                   	retq   

00000000008015fb <strstr>:

char * strstr(const char *in, const char *str)
{
  8015fb:	55                   	push   %rbp
  8015fc:	48 89 e5             	mov    %rsp,%rbp
  8015ff:	48 83 ec 30          	sub    $0x30,%rsp
  801603:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801607:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80160b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80160f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801613:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801617:	0f b6 00             	movzbl (%rax),%eax
  80161a:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80161d:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801621:	75 06                	jne    801629 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801623:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801627:	eb 6b                	jmp    801694 <strstr+0x99>

	len = strlen(str);
  801629:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80162d:	48 89 c7             	mov    %rax,%rdi
  801630:	48 b8 d1 0e 80 00 00 	movabs $0x800ed1,%rax
  801637:	00 00 00 
  80163a:	ff d0                	callq  *%rax
  80163c:	48 98                	cltq   
  80163e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801642:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801646:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80164a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80164e:	0f b6 00             	movzbl (%rax),%eax
  801651:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801654:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801658:	75 07                	jne    801661 <strstr+0x66>
				return (char *) 0;
  80165a:	b8 00 00 00 00       	mov    $0x0,%eax
  80165f:	eb 33                	jmp    801694 <strstr+0x99>
		} while (sc != c);
  801661:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801665:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801668:	75 d8                	jne    801642 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80166a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80166e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801672:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801676:	48 89 ce             	mov    %rcx,%rsi
  801679:	48 89 c7             	mov    %rax,%rdi
  80167c:	48 b8 f2 10 80 00 00 	movabs $0x8010f2,%rax
  801683:	00 00 00 
  801686:	ff d0                	callq  *%rax
  801688:	85 c0                	test   %eax,%eax
  80168a:	75 b6                	jne    801642 <strstr+0x47>

	return (char *) (in - 1);
  80168c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801690:	48 83 e8 01          	sub    $0x1,%rax
}
  801694:	c9                   	leaveq 
  801695:	c3                   	retq   

0000000000801696 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801696:	55                   	push   %rbp
  801697:	48 89 e5             	mov    %rsp,%rbp
  80169a:	53                   	push   %rbx
  80169b:	48 83 ec 48          	sub    $0x48,%rsp
  80169f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8016a2:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8016a5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016a9:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8016ad:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8016b1:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016b5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016b8:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8016bc:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8016c0:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8016c4:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8016c8:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8016cc:	4c 89 c3             	mov    %r8,%rbx
  8016cf:	cd 30                	int    $0x30
  8016d1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8016d5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8016d9:	74 3e                	je     801719 <syscall+0x83>
  8016db:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016e0:	7e 37                	jle    801719 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016e6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016e9:	49 89 d0             	mov    %rdx,%r8
  8016ec:	89 c1                	mov    %eax,%ecx
  8016ee:	48 ba 48 4d 80 00 00 	movabs $0x804d48,%rdx
  8016f5:	00 00 00 
  8016f8:	be 23 00 00 00       	mov    $0x23,%esi
  8016fd:	48 bf 65 4d 80 00 00 	movabs $0x804d65,%rdi
  801704:	00 00 00 
  801707:	b8 00 00 00 00       	mov    $0x0,%eax
  80170c:	49 b9 6a 01 80 00 00 	movabs $0x80016a,%r9
  801713:	00 00 00 
  801716:	41 ff d1             	callq  *%r9

	return ret;
  801719:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80171d:	48 83 c4 48          	add    $0x48,%rsp
  801721:	5b                   	pop    %rbx
  801722:	5d                   	pop    %rbp
  801723:	c3                   	retq   

0000000000801724 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801724:	55                   	push   %rbp
  801725:	48 89 e5             	mov    %rsp,%rbp
  801728:	48 83 ec 10          	sub    $0x10,%rsp
  80172c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801730:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801734:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801738:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80173c:	48 83 ec 08          	sub    $0x8,%rsp
  801740:	6a 00                	pushq  $0x0
  801742:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801748:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80174e:	48 89 d1             	mov    %rdx,%rcx
  801751:	48 89 c2             	mov    %rax,%rdx
  801754:	be 00 00 00 00       	mov    $0x0,%esi
  801759:	bf 00 00 00 00       	mov    $0x0,%edi
  80175e:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  801765:	00 00 00 
  801768:	ff d0                	callq  *%rax
  80176a:	48 83 c4 10          	add    $0x10,%rsp
}
  80176e:	c9                   	leaveq 
  80176f:	c3                   	retq   

0000000000801770 <sys_cgetc>:

int
sys_cgetc(void)
{
  801770:	55                   	push   %rbp
  801771:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801774:	48 83 ec 08          	sub    $0x8,%rsp
  801778:	6a 00                	pushq  $0x0
  80177a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801780:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801786:	b9 00 00 00 00       	mov    $0x0,%ecx
  80178b:	ba 00 00 00 00       	mov    $0x0,%edx
  801790:	be 00 00 00 00       	mov    $0x0,%esi
  801795:	bf 01 00 00 00       	mov    $0x1,%edi
  80179a:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  8017a1:	00 00 00 
  8017a4:	ff d0                	callq  *%rax
  8017a6:	48 83 c4 10          	add    $0x10,%rsp
}
  8017aa:	c9                   	leaveq 
  8017ab:	c3                   	retq   

00000000008017ac <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8017ac:	55                   	push   %rbp
  8017ad:	48 89 e5             	mov    %rsp,%rbp
  8017b0:	48 83 ec 10          	sub    $0x10,%rsp
  8017b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8017b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017ba:	48 98                	cltq   
  8017bc:	48 83 ec 08          	sub    $0x8,%rsp
  8017c0:	6a 00                	pushq  $0x0
  8017c2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017c8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017ce:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017d3:	48 89 c2             	mov    %rax,%rdx
  8017d6:	be 01 00 00 00       	mov    $0x1,%esi
  8017db:	bf 03 00 00 00       	mov    $0x3,%edi
  8017e0:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  8017e7:	00 00 00 
  8017ea:	ff d0                	callq  *%rax
  8017ec:	48 83 c4 10          	add    $0x10,%rsp
}
  8017f0:	c9                   	leaveq 
  8017f1:	c3                   	retq   

00000000008017f2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8017f2:	55                   	push   %rbp
  8017f3:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8017f6:	48 83 ec 08          	sub    $0x8,%rsp
  8017fa:	6a 00                	pushq  $0x0
  8017fc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801802:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801808:	b9 00 00 00 00       	mov    $0x0,%ecx
  80180d:	ba 00 00 00 00       	mov    $0x0,%edx
  801812:	be 00 00 00 00       	mov    $0x0,%esi
  801817:	bf 02 00 00 00       	mov    $0x2,%edi
  80181c:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  801823:	00 00 00 
  801826:	ff d0                	callq  *%rax
  801828:	48 83 c4 10          	add    $0x10,%rsp
}
  80182c:	c9                   	leaveq 
  80182d:	c3                   	retq   

000000000080182e <sys_yield>:

void
sys_yield(void)
{
  80182e:	55                   	push   %rbp
  80182f:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801832:	48 83 ec 08          	sub    $0x8,%rsp
  801836:	6a 00                	pushq  $0x0
  801838:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80183e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801844:	b9 00 00 00 00       	mov    $0x0,%ecx
  801849:	ba 00 00 00 00       	mov    $0x0,%edx
  80184e:	be 00 00 00 00       	mov    $0x0,%esi
  801853:	bf 0b 00 00 00       	mov    $0xb,%edi
  801858:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  80185f:	00 00 00 
  801862:	ff d0                	callq  *%rax
  801864:	48 83 c4 10          	add    $0x10,%rsp
}
  801868:	c9                   	leaveq 
  801869:	c3                   	retq   

000000000080186a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80186a:	55                   	push   %rbp
  80186b:	48 89 e5             	mov    %rsp,%rbp
  80186e:	48 83 ec 10          	sub    $0x10,%rsp
  801872:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801875:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801879:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80187c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80187f:	48 63 c8             	movslq %eax,%rcx
  801882:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801886:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801889:	48 98                	cltq   
  80188b:	48 83 ec 08          	sub    $0x8,%rsp
  80188f:	6a 00                	pushq  $0x0
  801891:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801897:	49 89 c8             	mov    %rcx,%r8
  80189a:	48 89 d1             	mov    %rdx,%rcx
  80189d:	48 89 c2             	mov    %rax,%rdx
  8018a0:	be 01 00 00 00       	mov    $0x1,%esi
  8018a5:	bf 04 00 00 00       	mov    $0x4,%edi
  8018aa:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  8018b1:	00 00 00 
  8018b4:	ff d0                	callq  *%rax
  8018b6:	48 83 c4 10          	add    $0x10,%rsp
}
  8018ba:	c9                   	leaveq 
  8018bb:	c3                   	retq   

00000000008018bc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8018bc:	55                   	push   %rbp
  8018bd:	48 89 e5             	mov    %rsp,%rbp
  8018c0:	48 83 ec 20          	sub    $0x20,%rsp
  8018c4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018cb:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8018ce:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8018d2:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8018d6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018d9:	48 63 c8             	movslq %eax,%rcx
  8018dc:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8018e0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018e3:	48 63 f0             	movslq %eax,%rsi
  8018e6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ed:	48 98                	cltq   
  8018ef:	48 83 ec 08          	sub    $0x8,%rsp
  8018f3:	51                   	push   %rcx
  8018f4:	49 89 f9             	mov    %rdi,%r9
  8018f7:	49 89 f0             	mov    %rsi,%r8
  8018fa:	48 89 d1             	mov    %rdx,%rcx
  8018fd:	48 89 c2             	mov    %rax,%rdx
  801900:	be 01 00 00 00       	mov    $0x1,%esi
  801905:	bf 05 00 00 00       	mov    $0x5,%edi
  80190a:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  801911:	00 00 00 
  801914:	ff d0                	callq  *%rax
  801916:	48 83 c4 10          	add    $0x10,%rsp
}
  80191a:	c9                   	leaveq 
  80191b:	c3                   	retq   

000000000080191c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80191c:	55                   	push   %rbp
  80191d:	48 89 e5             	mov    %rsp,%rbp
  801920:	48 83 ec 10          	sub    $0x10,%rsp
  801924:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801927:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80192b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80192f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801932:	48 98                	cltq   
  801934:	48 83 ec 08          	sub    $0x8,%rsp
  801938:	6a 00                	pushq  $0x0
  80193a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801940:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801946:	48 89 d1             	mov    %rdx,%rcx
  801949:	48 89 c2             	mov    %rax,%rdx
  80194c:	be 01 00 00 00       	mov    $0x1,%esi
  801951:	bf 06 00 00 00       	mov    $0x6,%edi
  801956:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  80195d:	00 00 00 
  801960:	ff d0                	callq  *%rax
  801962:	48 83 c4 10          	add    $0x10,%rsp
}
  801966:	c9                   	leaveq 
  801967:	c3                   	retq   

0000000000801968 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801968:	55                   	push   %rbp
  801969:	48 89 e5             	mov    %rsp,%rbp
  80196c:	48 83 ec 10          	sub    $0x10,%rsp
  801970:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801973:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801976:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801979:	48 63 d0             	movslq %eax,%rdx
  80197c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80197f:	48 98                	cltq   
  801981:	48 83 ec 08          	sub    $0x8,%rsp
  801985:	6a 00                	pushq  $0x0
  801987:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80198d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801993:	48 89 d1             	mov    %rdx,%rcx
  801996:	48 89 c2             	mov    %rax,%rdx
  801999:	be 01 00 00 00       	mov    $0x1,%esi
  80199e:	bf 08 00 00 00       	mov    $0x8,%edi
  8019a3:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  8019aa:	00 00 00 
  8019ad:	ff d0                	callq  *%rax
  8019af:	48 83 c4 10          	add    $0x10,%rsp
}
  8019b3:	c9                   	leaveq 
  8019b4:	c3                   	retq   

00000000008019b5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8019b5:	55                   	push   %rbp
  8019b6:	48 89 e5             	mov    %rsp,%rbp
  8019b9:	48 83 ec 10          	sub    $0x10,%rsp
  8019bd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8019c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019cb:	48 98                	cltq   
  8019cd:	48 83 ec 08          	sub    $0x8,%rsp
  8019d1:	6a 00                	pushq  $0x0
  8019d3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019df:	48 89 d1             	mov    %rdx,%rcx
  8019e2:	48 89 c2             	mov    %rax,%rdx
  8019e5:	be 01 00 00 00       	mov    $0x1,%esi
  8019ea:	bf 09 00 00 00       	mov    $0x9,%edi
  8019ef:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  8019f6:	00 00 00 
  8019f9:	ff d0                	callq  *%rax
  8019fb:	48 83 c4 10          	add    $0x10,%rsp
}
  8019ff:	c9                   	leaveq 
  801a00:	c3                   	retq   

0000000000801a01 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a01:	55                   	push   %rbp
  801a02:	48 89 e5             	mov    %rsp,%rbp
  801a05:	48 83 ec 10          	sub    $0x10,%rsp
  801a09:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a0c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
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
  801a36:	bf 0a 00 00 00       	mov    $0xa,%edi
  801a3b:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  801a42:	00 00 00 
  801a45:	ff d0                	callq  *%rax
  801a47:	48 83 c4 10          	add    $0x10,%rsp
}
  801a4b:	c9                   	leaveq 
  801a4c:	c3                   	retq   

0000000000801a4d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a4d:	55                   	push   %rbp
  801a4e:	48 89 e5             	mov    %rsp,%rbp
  801a51:	48 83 ec 20          	sub    $0x20,%rsp
  801a55:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a58:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a5c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a60:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a63:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a66:	48 63 f0             	movslq %eax,%rsi
  801a69:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a70:	48 98                	cltq   
  801a72:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a76:	48 83 ec 08          	sub    $0x8,%rsp
  801a7a:	6a 00                	pushq  $0x0
  801a7c:	49 89 f1             	mov    %rsi,%r9
  801a7f:	49 89 c8             	mov    %rcx,%r8
  801a82:	48 89 d1             	mov    %rdx,%rcx
  801a85:	48 89 c2             	mov    %rax,%rdx
  801a88:	be 00 00 00 00       	mov    $0x0,%esi
  801a8d:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a92:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  801a99:	00 00 00 
  801a9c:	ff d0                	callq  *%rax
  801a9e:	48 83 c4 10          	add    $0x10,%rsp
}
  801aa2:	c9                   	leaveq 
  801aa3:	c3                   	retq   

0000000000801aa4 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801aa4:	55                   	push   %rbp
  801aa5:	48 89 e5             	mov    %rsp,%rbp
  801aa8:	48 83 ec 10          	sub    $0x10,%rsp
  801aac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ab0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ab4:	48 83 ec 08          	sub    $0x8,%rsp
  801ab8:	6a 00                	pushq  $0x0
  801aba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ac0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ac6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801acb:	48 89 c2             	mov    %rax,%rdx
  801ace:	be 01 00 00 00       	mov    $0x1,%esi
  801ad3:	bf 0d 00 00 00       	mov    $0xd,%edi
  801ad8:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  801adf:	00 00 00 
  801ae2:	ff d0                	callq  *%rax
  801ae4:	48 83 c4 10          	add    $0x10,%rsp
}
  801ae8:	c9                   	leaveq 
  801ae9:	c3                   	retq   

0000000000801aea <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801aea:	55                   	push   %rbp
  801aeb:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801aee:	48 83 ec 08          	sub    $0x8,%rsp
  801af2:	6a 00                	pushq  $0x0
  801af4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801afa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b00:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b05:	ba 00 00 00 00       	mov    $0x0,%edx
  801b0a:	be 00 00 00 00       	mov    $0x0,%esi
  801b0f:	bf 0e 00 00 00       	mov    $0xe,%edi
  801b14:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  801b1b:	00 00 00 
  801b1e:	ff d0                	callq  *%rax
  801b20:	48 83 c4 10          	add    $0x10,%rsp
}
  801b24:	c9                   	leaveq 
  801b25:	c3                   	retq   

0000000000801b26 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801b26:	55                   	push   %rbp
  801b27:	48 89 e5             	mov    %rsp,%rbp
  801b2a:	48 83 ec 20          	sub    $0x20,%rsp
  801b2e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b31:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b35:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b38:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b3c:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801b40:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b43:	48 63 c8             	movslq %eax,%rcx
  801b46:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b4a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b4d:	48 63 f0             	movslq %eax,%rsi
  801b50:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b57:	48 98                	cltq   
  801b59:	48 83 ec 08          	sub    $0x8,%rsp
  801b5d:	51                   	push   %rcx
  801b5e:	49 89 f9             	mov    %rdi,%r9
  801b61:	49 89 f0             	mov    %rsi,%r8
  801b64:	48 89 d1             	mov    %rdx,%rcx
  801b67:	48 89 c2             	mov    %rax,%rdx
  801b6a:	be 00 00 00 00       	mov    $0x0,%esi
  801b6f:	bf 0f 00 00 00       	mov    $0xf,%edi
  801b74:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  801b7b:	00 00 00 
  801b7e:	ff d0                	callq  *%rax
  801b80:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801b84:	c9                   	leaveq 
  801b85:	c3                   	retq   

0000000000801b86 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801b86:	55                   	push   %rbp
  801b87:	48 89 e5             	mov    %rsp,%rbp
  801b8a:	48 83 ec 10          	sub    $0x10,%rsp
  801b8e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b92:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801b96:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b9e:	48 83 ec 08          	sub    $0x8,%rsp
  801ba2:	6a 00                	pushq  $0x0
  801ba4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801baa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bb0:	48 89 d1             	mov    %rdx,%rcx
  801bb3:	48 89 c2             	mov    %rax,%rdx
  801bb6:	be 00 00 00 00       	mov    $0x0,%esi
  801bbb:	bf 10 00 00 00       	mov    $0x10,%edi
  801bc0:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  801bc7:	00 00 00 
  801bca:	ff d0                	callq  *%rax
  801bcc:	48 83 c4 10          	add    $0x10,%rsp
}
  801bd0:	c9                   	leaveq 
  801bd1:	c3                   	retq   

0000000000801bd2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801bd2:	55                   	push   %rbp
  801bd3:	48 89 e5             	mov    %rsp,%rbp
  801bd6:	48 83 ec 08          	sub    $0x8,%rsp
  801bda:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801bde:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801be2:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801be9:	ff ff ff 
  801bec:	48 01 d0             	add    %rdx,%rax
  801bef:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801bf3:	c9                   	leaveq 
  801bf4:	c3                   	retq   

0000000000801bf5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801bf5:	55                   	push   %rbp
  801bf6:	48 89 e5             	mov    %rsp,%rbp
  801bf9:	48 83 ec 08          	sub    $0x8,%rsp
  801bfd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801c01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c05:	48 89 c7             	mov    %rax,%rdi
  801c08:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  801c0f:	00 00 00 
  801c12:	ff d0                	callq  *%rax
  801c14:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801c1a:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801c1e:	c9                   	leaveq 
  801c1f:	c3                   	retq   

0000000000801c20 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801c20:	55                   	push   %rbp
  801c21:	48 89 e5             	mov    %rsp,%rbp
  801c24:	48 83 ec 18          	sub    $0x18,%rsp
  801c28:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801c2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c33:	eb 6b                	jmp    801ca0 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801c35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c38:	48 98                	cltq   
  801c3a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801c40:	48 c1 e0 0c          	shl    $0xc,%rax
  801c44:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801c48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c4c:	48 c1 e8 15          	shr    $0x15,%rax
  801c50:	48 89 c2             	mov    %rax,%rdx
  801c53:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801c5a:	01 00 00 
  801c5d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c61:	83 e0 01             	and    $0x1,%eax
  801c64:	48 85 c0             	test   %rax,%rax
  801c67:	74 21                	je     801c8a <fd_alloc+0x6a>
  801c69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c6d:	48 c1 e8 0c          	shr    $0xc,%rax
  801c71:	48 89 c2             	mov    %rax,%rdx
  801c74:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c7b:	01 00 00 
  801c7e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c82:	83 e0 01             	and    $0x1,%eax
  801c85:	48 85 c0             	test   %rax,%rax
  801c88:	75 12                	jne    801c9c <fd_alloc+0x7c>
			*fd_store = fd;
  801c8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c8e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c92:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801c95:	b8 00 00 00 00       	mov    $0x0,%eax
  801c9a:	eb 1a                	jmp    801cb6 <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  801c9c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ca0:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801ca4:	7e 8f                	jle    801c35 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  801ca6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801caa:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801cb1:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801cb6:	c9                   	leaveq 
  801cb7:	c3                   	retq   

0000000000801cb8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801cb8:	55                   	push   %rbp
  801cb9:	48 89 e5             	mov    %rsp,%rbp
  801cbc:	48 83 ec 20          	sub    $0x20,%rsp
  801cc0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801cc3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801cc7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ccb:	78 06                	js     801cd3 <fd_lookup+0x1b>
  801ccd:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801cd1:	7e 07                	jle    801cda <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801cd3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801cd8:	eb 6c                	jmp    801d46 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801cda:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801cdd:	48 98                	cltq   
  801cdf:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ce5:	48 c1 e0 0c          	shl    $0xc,%rax
  801ce9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ced:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cf1:	48 c1 e8 15          	shr    $0x15,%rax
  801cf5:	48 89 c2             	mov    %rax,%rdx
  801cf8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801cff:	01 00 00 
  801d02:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d06:	83 e0 01             	and    $0x1,%eax
  801d09:	48 85 c0             	test   %rax,%rax
  801d0c:	74 21                	je     801d2f <fd_lookup+0x77>
  801d0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d12:	48 c1 e8 0c          	shr    $0xc,%rax
  801d16:	48 89 c2             	mov    %rax,%rdx
  801d19:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d20:	01 00 00 
  801d23:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d27:	83 e0 01             	and    $0x1,%eax
  801d2a:	48 85 c0             	test   %rax,%rax
  801d2d:	75 07                	jne    801d36 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d2f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d34:	eb 10                	jmp    801d46 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801d36:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d3a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d3e:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801d41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d46:	c9                   	leaveq 
  801d47:	c3                   	retq   

0000000000801d48 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801d48:	55                   	push   %rbp
  801d49:	48 89 e5             	mov    %rsp,%rbp
  801d4c:	48 83 ec 30          	sub    $0x30,%rsp
  801d50:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801d54:	89 f0                	mov    %esi,%eax
  801d56:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801d59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d5d:	48 89 c7             	mov    %rax,%rdi
  801d60:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  801d67:	00 00 00 
  801d6a:	ff d0                	callq  *%rax
  801d6c:	89 c2                	mov    %eax,%edx
  801d6e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801d72:	48 89 c6             	mov    %rax,%rsi
  801d75:	89 d7                	mov    %edx,%edi
  801d77:	48 b8 b8 1c 80 00 00 	movabs $0x801cb8,%rax
  801d7e:	00 00 00 
  801d81:	ff d0                	callq  *%rax
  801d83:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d8a:	78 0a                	js     801d96 <fd_close+0x4e>
	    || fd != fd2)
  801d8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d90:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801d94:	74 12                	je     801da8 <fd_close+0x60>
		return (must_exist ? r : 0);
  801d96:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801d9a:	74 05                	je     801da1 <fd_close+0x59>
  801d9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d9f:	eb 70                	jmp    801e11 <fd_close+0xc9>
  801da1:	b8 00 00 00 00       	mov    $0x0,%eax
  801da6:	eb 69                	jmp    801e11 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801da8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dac:	8b 00                	mov    (%rax),%eax
  801dae:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801db2:	48 89 d6             	mov    %rdx,%rsi
  801db5:	89 c7                	mov    %eax,%edi
  801db7:	48 b8 13 1e 80 00 00 	movabs $0x801e13,%rax
  801dbe:	00 00 00 
  801dc1:	ff d0                	callq  *%rax
  801dc3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801dc6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801dca:	78 2a                	js     801df6 <fd_close+0xae>
		if (dev->dev_close)
  801dcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd0:	48 8b 40 20          	mov    0x20(%rax),%rax
  801dd4:	48 85 c0             	test   %rax,%rax
  801dd7:	74 16                	je     801def <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  801dd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ddd:	48 8b 40 20          	mov    0x20(%rax),%rax
  801de1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801de5:	48 89 d7             	mov    %rdx,%rdi
  801de8:	ff d0                	callq  *%rax
  801dea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ded:	eb 07                	jmp    801df6 <fd_close+0xae>
		else
			r = 0;
  801def:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801df6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dfa:	48 89 c6             	mov    %rax,%rsi
  801dfd:	bf 00 00 00 00       	mov    $0x0,%edi
  801e02:	48 b8 1c 19 80 00 00 	movabs $0x80191c,%rax
  801e09:	00 00 00 
  801e0c:	ff d0                	callq  *%rax
	return r;
  801e0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801e11:	c9                   	leaveq 
  801e12:	c3                   	retq   

0000000000801e13 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801e13:	55                   	push   %rbp
  801e14:	48 89 e5             	mov    %rsp,%rbp
  801e17:	48 83 ec 20          	sub    $0x20,%rsp
  801e1b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e1e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801e22:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e29:	eb 41                	jmp    801e6c <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801e2b:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801e32:	00 00 00 
  801e35:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e38:	48 63 d2             	movslq %edx,%rdx
  801e3b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e3f:	8b 00                	mov    (%rax),%eax
  801e41:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801e44:	75 22                	jne    801e68 <dev_lookup+0x55>
			*dev = devtab[i];
  801e46:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801e4d:	00 00 00 
  801e50:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e53:	48 63 d2             	movslq %edx,%rdx
  801e56:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801e5a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e5e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e61:	b8 00 00 00 00       	mov    $0x0,%eax
  801e66:	eb 60                	jmp    801ec8 <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  801e68:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e6c:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801e73:	00 00 00 
  801e76:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e79:	48 63 d2             	movslq %edx,%rdx
  801e7c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e80:	48 85 c0             	test   %rax,%rax
  801e83:	75 a6                	jne    801e2b <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801e85:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  801e8c:	00 00 00 
  801e8f:	48 8b 00             	mov    (%rax),%rax
  801e92:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801e98:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e9b:	89 c6                	mov    %eax,%esi
  801e9d:	48 bf 78 4d 80 00 00 	movabs $0x804d78,%rdi
  801ea4:	00 00 00 
  801ea7:	b8 00 00 00 00       	mov    $0x0,%eax
  801eac:	48 b9 a3 03 80 00 00 	movabs $0x8003a3,%rcx
  801eb3:	00 00 00 
  801eb6:	ff d1                	callq  *%rcx
	*dev = 0;
  801eb8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ebc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801ec3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801ec8:	c9                   	leaveq 
  801ec9:	c3                   	retq   

0000000000801eca <close>:

int
close(int fdnum)
{
  801eca:	55                   	push   %rbp
  801ecb:	48 89 e5             	mov    %rsp,%rbp
  801ece:	48 83 ec 20          	sub    $0x20,%rsp
  801ed2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ed5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ed9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801edc:	48 89 d6             	mov    %rdx,%rsi
  801edf:	89 c7                	mov    %eax,%edi
  801ee1:	48 b8 b8 1c 80 00 00 	movabs $0x801cb8,%rax
  801ee8:	00 00 00 
  801eeb:	ff d0                	callq  *%rax
  801eed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ef0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ef4:	79 05                	jns    801efb <close+0x31>
		return r;
  801ef6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ef9:	eb 18                	jmp    801f13 <close+0x49>
	else
		return fd_close(fd, 1);
  801efb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eff:	be 01 00 00 00       	mov    $0x1,%esi
  801f04:	48 89 c7             	mov    %rax,%rdi
  801f07:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  801f0e:	00 00 00 
  801f11:	ff d0                	callq  *%rax
}
  801f13:	c9                   	leaveq 
  801f14:	c3                   	retq   

0000000000801f15 <close_all>:

void
close_all(void)
{
  801f15:	55                   	push   %rbp
  801f16:	48 89 e5             	mov    %rsp,%rbp
  801f19:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801f1d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f24:	eb 15                	jmp    801f3b <close_all+0x26>
		close(i);
  801f26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f29:	89 c7                	mov    %eax,%edi
  801f2b:	48 b8 ca 1e 80 00 00 	movabs $0x801eca,%rax
  801f32:	00 00 00 
  801f35:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  801f37:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f3b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f3f:	7e e5                	jle    801f26 <close_all+0x11>
}
  801f41:	c9                   	leaveq 
  801f42:	c3                   	retq   

0000000000801f43 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801f43:	55                   	push   %rbp
  801f44:	48 89 e5             	mov    %rsp,%rbp
  801f47:	48 83 ec 40          	sub    $0x40,%rsp
  801f4b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801f4e:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801f51:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801f55:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f58:	48 89 d6             	mov    %rdx,%rsi
  801f5b:	89 c7                	mov    %eax,%edi
  801f5d:	48 b8 b8 1c 80 00 00 	movabs $0x801cb8,%rax
  801f64:	00 00 00 
  801f67:	ff d0                	callq  *%rax
  801f69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f70:	79 08                	jns    801f7a <dup+0x37>
		return r;
  801f72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f75:	e9 70 01 00 00       	jmpq   8020ea <dup+0x1a7>
	close(newfdnum);
  801f7a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801f7d:	89 c7                	mov    %eax,%edi
  801f7f:	48 b8 ca 1e 80 00 00 	movabs $0x801eca,%rax
  801f86:	00 00 00 
  801f89:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801f8b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801f8e:	48 98                	cltq   
  801f90:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f96:	48 c1 e0 0c          	shl    $0xc,%rax
  801f9a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801f9e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fa2:	48 89 c7             	mov    %rax,%rdi
  801fa5:	48 b8 f5 1b 80 00 00 	movabs $0x801bf5,%rax
  801fac:	00 00 00 
  801faf:	ff d0                	callq  *%rax
  801fb1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801fb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fb9:	48 89 c7             	mov    %rax,%rdi
  801fbc:	48 b8 f5 1b 80 00 00 	movabs $0x801bf5,%rax
  801fc3:	00 00 00 
  801fc6:	ff d0                	callq  *%rax
  801fc8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801fcc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fd0:	48 c1 e8 15          	shr    $0x15,%rax
  801fd4:	48 89 c2             	mov    %rax,%rdx
  801fd7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fde:	01 00 00 
  801fe1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fe5:	83 e0 01             	and    $0x1,%eax
  801fe8:	48 85 c0             	test   %rax,%rax
  801feb:	74 73                	je     802060 <dup+0x11d>
  801fed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ff1:	48 c1 e8 0c          	shr    $0xc,%rax
  801ff5:	48 89 c2             	mov    %rax,%rdx
  801ff8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fff:	01 00 00 
  802002:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802006:	83 e0 01             	and    $0x1,%eax
  802009:	48 85 c0             	test   %rax,%rax
  80200c:	74 52                	je     802060 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80200e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802012:	48 c1 e8 0c          	shr    $0xc,%rax
  802016:	48 89 c2             	mov    %rax,%rdx
  802019:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802020:	01 00 00 
  802023:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802027:	25 07 0e 00 00       	and    $0xe07,%eax
  80202c:	89 c1                	mov    %eax,%ecx
  80202e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802032:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802036:	41 89 c8             	mov    %ecx,%r8d
  802039:	48 89 d1             	mov    %rdx,%rcx
  80203c:	ba 00 00 00 00       	mov    $0x0,%edx
  802041:	48 89 c6             	mov    %rax,%rsi
  802044:	bf 00 00 00 00       	mov    $0x0,%edi
  802049:	48 b8 bc 18 80 00 00 	movabs $0x8018bc,%rax
  802050:	00 00 00 
  802053:	ff d0                	callq  *%rax
  802055:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802058:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80205c:	79 02                	jns    802060 <dup+0x11d>
			goto err;
  80205e:	eb 57                	jmp    8020b7 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802060:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802064:	48 c1 e8 0c          	shr    $0xc,%rax
  802068:	48 89 c2             	mov    %rax,%rdx
  80206b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802072:	01 00 00 
  802075:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802079:	25 07 0e 00 00       	and    $0xe07,%eax
  80207e:	89 c1                	mov    %eax,%ecx
  802080:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802084:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802088:	41 89 c8             	mov    %ecx,%r8d
  80208b:	48 89 d1             	mov    %rdx,%rcx
  80208e:	ba 00 00 00 00       	mov    $0x0,%edx
  802093:	48 89 c6             	mov    %rax,%rsi
  802096:	bf 00 00 00 00       	mov    $0x0,%edi
  80209b:	48 b8 bc 18 80 00 00 	movabs $0x8018bc,%rax
  8020a2:	00 00 00 
  8020a5:	ff d0                	callq  *%rax
  8020a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020ae:	79 02                	jns    8020b2 <dup+0x16f>
		goto err;
  8020b0:	eb 05                	jmp    8020b7 <dup+0x174>

	return newfdnum;
  8020b2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020b5:	eb 33                	jmp    8020ea <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8020b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020bb:	48 89 c6             	mov    %rax,%rsi
  8020be:	bf 00 00 00 00       	mov    $0x0,%edi
  8020c3:	48 b8 1c 19 80 00 00 	movabs $0x80191c,%rax
  8020ca:	00 00 00 
  8020cd:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8020cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020d3:	48 89 c6             	mov    %rax,%rsi
  8020d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8020db:	48 b8 1c 19 80 00 00 	movabs $0x80191c,%rax
  8020e2:	00 00 00 
  8020e5:	ff d0                	callq  *%rax
	return r;
  8020e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020ea:	c9                   	leaveq 
  8020eb:	c3                   	retq   

00000000008020ec <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8020ec:	55                   	push   %rbp
  8020ed:	48 89 e5             	mov    %rsp,%rbp
  8020f0:	48 83 ec 40          	sub    $0x40,%rsp
  8020f4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8020f7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8020fb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8020ff:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802103:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802106:	48 89 d6             	mov    %rdx,%rsi
  802109:	89 c7                	mov    %eax,%edi
  80210b:	48 b8 b8 1c 80 00 00 	movabs $0x801cb8,%rax
  802112:	00 00 00 
  802115:	ff d0                	callq  *%rax
  802117:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80211a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80211e:	78 24                	js     802144 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802120:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802124:	8b 00                	mov    (%rax),%eax
  802126:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80212a:	48 89 d6             	mov    %rdx,%rsi
  80212d:	89 c7                	mov    %eax,%edi
  80212f:	48 b8 13 1e 80 00 00 	movabs $0x801e13,%rax
  802136:	00 00 00 
  802139:	ff d0                	callq  *%rax
  80213b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80213e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802142:	79 05                	jns    802149 <read+0x5d>
		return r;
  802144:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802147:	eb 76                	jmp    8021bf <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802149:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80214d:	8b 40 08             	mov    0x8(%rax),%eax
  802150:	83 e0 03             	and    $0x3,%eax
  802153:	83 f8 01             	cmp    $0x1,%eax
  802156:	75 3a                	jne    802192 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802158:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80215f:	00 00 00 
  802162:	48 8b 00             	mov    (%rax),%rax
  802165:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80216b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80216e:	89 c6                	mov    %eax,%esi
  802170:	48 bf 97 4d 80 00 00 	movabs $0x804d97,%rdi
  802177:	00 00 00 
  80217a:	b8 00 00 00 00       	mov    $0x0,%eax
  80217f:	48 b9 a3 03 80 00 00 	movabs $0x8003a3,%rcx
  802186:	00 00 00 
  802189:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80218b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802190:	eb 2d                	jmp    8021bf <read+0xd3>
	}
	if (!dev->dev_read)
  802192:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802196:	48 8b 40 10          	mov    0x10(%rax),%rax
  80219a:	48 85 c0             	test   %rax,%rax
  80219d:	75 07                	jne    8021a6 <read+0xba>
		return -E_NOT_SUPP;
  80219f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8021a4:	eb 19                	jmp    8021bf <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8021a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021aa:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021ae:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8021b2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8021b6:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8021ba:	48 89 cf             	mov    %rcx,%rdi
  8021bd:	ff d0                	callq  *%rax
}
  8021bf:	c9                   	leaveq 
  8021c0:	c3                   	retq   

00000000008021c1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8021c1:	55                   	push   %rbp
  8021c2:	48 89 e5             	mov    %rsp,%rbp
  8021c5:	48 83 ec 30          	sub    $0x30,%rsp
  8021c9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8021d0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8021d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021db:	eb 49                	jmp    802226 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8021dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021e0:	48 98                	cltq   
  8021e2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8021e6:	48 29 c2             	sub    %rax,%rdx
  8021e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ec:	48 63 c8             	movslq %eax,%rcx
  8021ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021f3:	48 01 c1             	add    %rax,%rcx
  8021f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021f9:	48 89 ce             	mov    %rcx,%rsi
  8021fc:	89 c7                	mov    %eax,%edi
  8021fe:	48 b8 ec 20 80 00 00 	movabs $0x8020ec,%rax
  802205:	00 00 00 
  802208:	ff d0                	callq  *%rax
  80220a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80220d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802211:	79 05                	jns    802218 <readn+0x57>
			return m;
  802213:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802216:	eb 1c                	jmp    802234 <readn+0x73>
		if (m == 0)
  802218:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80221c:	75 02                	jne    802220 <readn+0x5f>
			break;
  80221e:	eb 11                	jmp    802231 <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  802220:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802223:	01 45 fc             	add    %eax,-0x4(%rbp)
  802226:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802229:	48 98                	cltq   
  80222b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80222f:	72 ac                	jb     8021dd <readn+0x1c>
	}
	return tot;
  802231:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802234:	c9                   	leaveq 
  802235:	c3                   	retq   

0000000000802236 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802236:	55                   	push   %rbp
  802237:	48 89 e5             	mov    %rsp,%rbp
  80223a:	48 83 ec 40          	sub    $0x40,%rsp
  80223e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802241:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802245:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802249:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80224d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802250:	48 89 d6             	mov    %rdx,%rsi
  802253:	89 c7                	mov    %eax,%edi
  802255:	48 b8 b8 1c 80 00 00 	movabs $0x801cb8,%rax
  80225c:	00 00 00 
  80225f:	ff d0                	callq  *%rax
  802261:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802264:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802268:	78 24                	js     80228e <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80226a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80226e:	8b 00                	mov    (%rax),%eax
  802270:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802274:	48 89 d6             	mov    %rdx,%rsi
  802277:	89 c7                	mov    %eax,%edi
  802279:	48 b8 13 1e 80 00 00 	movabs $0x801e13,%rax
  802280:	00 00 00 
  802283:	ff d0                	callq  *%rax
  802285:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802288:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80228c:	79 05                	jns    802293 <write+0x5d>
		return r;
  80228e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802291:	eb 75                	jmp    802308 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802293:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802297:	8b 40 08             	mov    0x8(%rax),%eax
  80229a:	83 e0 03             	and    $0x3,%eax
  80229d:	85 c0                	test   %eax,%eax
  80229f:	75 3a                	jne    8022db <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8022a1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8022a8:	00 00 00 
  8022ab:	48 8b 00             	mov    (%rax),%rax
  8022ae:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022b4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022b7:	89 c6                	mov    %eax,%esi
  8022b9:	48 bf b3 4d 80 00 00 	movabs $0x804db3,%rdi
  8022c0:	00 00 00 
  8022c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c8:	48 b9 a3 03 80 00 00 	movabs $0x8003a3,%rcx
  8022cf:	00 00 00 
  8022d2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8022d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022d9:	eb 2d                	jmp    802308 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8022db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022df:	48 8b 40 18          	mov    0x18(%rax),%rax
  8022e3:	48 85 c0             	test   %rax,%rax
  8022e6:	75 07                	jne    8022ef <write+0xb9>
		return -E_NOT_SUPP;
  8022e8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022ed:	eb 19                	jmp    802308 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8022ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022f3:	48 8b 40 18          	mov    0x18(%rax),%rax
  8022f7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8022fb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8022ff:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802303:	48 89 cf             	mov    %rcx,%rdi
  802306:	ff d0                	callq  *%rax
}
  802308:	c9                   	leaveq 
  802309:	c3                   	retq   

000000000080230a <seek>:

int
seek(int fdnum, off_t offset)
{
  80230a:	55                   	push   %rbp
  80230b:	48 89 e5             	mov    %rsp,%rbp
  80230e:	48 83 ec 18          	sub    $0x18,%rsp
  802312:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802315:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802318:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80231c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80231f:	48 89 d6             	mov    %rdx,%rsi
  802322:	89 c7                	mov    %eax,%edi
  802324:	48 b8 b8 1c 80 00 00 	movabs $0x801cb8,%rax
  80232b:	00 00 00 
  80232e:	ff d0                	callq  *%rax
  802330:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802333:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802337:	79 05                	jns    80233e <seek+0x34>
		return r;
  802339:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80233c:	eb 0f                	jmp    80234d <seek+0x43>
	fd->fd_offset = offset;
  80233e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802342:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802345:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802348:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80234d:	c9                   	leaveq 
  80234e:	c3                   	retq   

000000000080234f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80234f:	55                   	push   %rbp
  802350:	48 89 e5             	mov    %rsp,%rbp
  802353:	48 83 ec 30          	sub    $0x30,%rsp
  802357:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80235a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80235d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802361:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802364:	48 89 d6             	mov    %rdx,%rsi
  802367:	89 c7                	mov    %eax,%edi
  802369:	48 b8 b8 1c 80 00 00 	movabs $0x801cb8,%rax
  802370:	00 00 00 
  802373:	ff d0                	callq  *%rax
  802375:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802378:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80237c:	78 24                	js     8023a2 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80237e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802382:	8b 00                	mov    (%rax),%eax
  802384:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802388:	48 89 d6             	mov    %rdx,%rsi
  80238b:	89 c7                	mov    %eax,%edi
  80238d:	48 b8 13 1e 80 00 00 	movabs $0x801e13,%rax
  802394:	00 00 00 
  802397:	ff d0                	callq  *%rax
  802399:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80239c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023a0:	79 05                	jns    8023a7 <ftruncate+0x58>
		return r;
  8023a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a5:	eb 72                	jmp    802419 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ab:	8b 40 08             	mov    0x8(%rax),%eax
  8023ae:	83 e0 03             	and    $0x3,%eax
  8023b1:	85 c0                	test   %eax,%eax
  8023b3:	75 3a                	jne    8023ef <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8023b5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8023bc:	00 00 00 
  8023bf:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8023c2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023c8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023cb:	89 c6                	mov    %eax,%esi
  8023cd:	48 bf d0 4d 80 00 00 	movabs $0x804dd0,%rdi
  8023d4:	00 00 00 
  8023d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023dc:	48 b9 a3 03 80 00 00 	movabs $0x8003a3,%rcx
  8023e3:	00 00 00 
  8023e6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8023e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023ed:	eb 2a                	jmp    802419 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8023ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023f3:	48 8b 40 30          	mov    0x30(%rax),%rax
  8023f7:	48 85 c0             	test   %rax,%rax
  8023fa:	75 07                	jne    802403 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8023fc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802401:	eb 16                	jmp    802419 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802403:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802407:	48 8b 40 30          	mov    0x30(%rax),%rax
  80240b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80240f:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802412:	89 ce                	mov    %ecx,%esi
  802414:	48 89 d7             	mov    %rdx,%rdi
  802417:	ff d0                	callq  *%rax
}
  802419:	c9                   	leaveq 
  80241a:	c3                   	retq   

000000000080241b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80241b:	55                   	push   %rbp
  80241c:	48 89 e5             	mov    %rsp,%rbp
  80241f:	48 83 ec 30          	sub    $0x30,%rsp
  802423:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802426:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80242a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80242e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802431:	48 89 d6             	mov    %rdx,%rsi
  802434:	89 c7                	mov    %eax,%edi
  802436:	48 b8 b8 1c 80 00 00 	movabs $0x801cb8,%rax
  80243d:	00 00 00 
  802440:	ff d0                	callq  *%rax
  802442:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802445:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802449:	78 24                	js     80246f <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80244b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80244f:	8b 00                	mov    (%rax),%eax
  802451:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802455:	48 89 d6             	mov    %rdx,%rsi
  802458:	89 c7                	mov    %eax,%edi
  80245a:	48 b8 13 1e 80 00 00 	movabs $0x801e13,%rax
  802461:	00 00 00 
  802464:	ff d0                	callq  *%rax
  802466:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802469:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80246d:	79 05                	jns    802474 <fstat+0x59>
		return r;
  80246f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802472:	eb 5e                	jmp    8024d2 <fstat+0xb7>
	if (!dev->dev_stat)
  802474:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802478:	48 8b 40 28          	mov    0x28(%rax),%rax
  80247c:	48 85 c0             	test   %rax,%rax
  80247f:	75 07                	jne    802488 <fstat+0x6d>
		return -E_NOT_SUPP;
  802481:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802486:	eb 4a                	jmp    8024d2 <fstat+0xb7>
	stat->st_name[0] = 0;
  802488:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80248c:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80248f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802493:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80249a:	00 00 00 
	stat->st_isdir = 0;
  80249d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024a1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8024a8:	00 00 00 
	stat->st_dev = dev;
  8024ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024b3:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8024ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024be:	48 8b 40 28          	mov    0x28(%rax),%rax
  8024c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8024c6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8024ca:	48 89 ce             	mov    %rcx,%rsi
  8024cd:	48 89 d7             	mov    %rdx,%rdi
  8024d0:	ff d0                	callq  *%rax
}
  8024d2:	c9                   	leaveq 
  8024d3:	c3                   	retq   

00000000008024d4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8024d4:	55                   	push   %rbp
  8024d5:	48 89 e5             	mov    %rsp,%rbp
  8024d8:	48 83 ec 20          	sub    $0x20,%rsp
  8024dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8024e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8024e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024e8:	be 00 00 00 00       	mov    $0x0,%esi
  8024ed:	48 89 c7             	mov    %rax,%rdi
  8024f0:	48 b8 c4 25 80 00 00 	movabs $0x8025c4,%rax
  8024f7:	00 00 00 
  8024fa:	ff d0                	callq  *%rax
  8024fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802503:	79 05                	jns    80250a <stat+0x36>
		return fd;
  802505:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802508:	eb 2f                	jmp    802539 <stat+0x65>
	r = fstat(fd, stat);
  80250a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80250e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802511:	48 89 d6             	mov    %rdx,%rsi
  802514:	89 c7                	mov    %eax,%edi
  802516:	48 b8 1b 24 80 00 00 	movabs $0x80241b,%rax
  80251d:	00 00 00 
  802520:	ff d0                	callq  *%rax
  802522:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802525:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802528:	89 c7                	mov    %eax,%edi
  80252a:	48 b8 ca 1e 80 00 00 	movabs $0x801eca,%rax
  802531:	00 00 00 
  802534:	ff d0                	callq  *%rax
	return r;
  802536:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802539:	c9                   	leaveq 
  80253a:	c3                   	retq   

000000000080253b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80253b:	55                   	push   %rbp
  80253c:	48 89 e5             	mov    %rsp,%rbp
  80253f:	48 83 ec 10          	sub    $0x10,%rsp
  802543:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802546:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80254a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802551:	00 00 00 
  802554:	8b 00                	mov    (%rax),%eax
  802556:	85 c0                	test   %eax,%eax
  802558:	75 1f                	jne    802579 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80255a:	bf 01 00 00 00       	mov    $0x1,%edi
  80255f:	48 b8 aa 46 80 00 00 	movabs $0x8046aa,%rax
  802566:	00 00 00 
  802569:	ff d0                	callq  *%rax
  80256b:	89 c2                	mov    %eax,%edx
  80256d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802574:	00 00 00 
  802577:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802579:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802580:	00 00 00 
  802583:	8b 00                	mov    (%rax),%eax
  802585:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802588:	b9 07 00 00 00       	mov    $0x7,%ecx
  80258d:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802594:	00 00 00 
  802597:	89 c7                	mov    %eax,%edi
  802599:	48 b8 1d 45 80 00 00 	movabs $0x80451d,%rax
  8025a0:	00 00 00 
  8025a3:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8025a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8025ae:	48 89 c6             	mov    %rax,%rsi
  8025b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8025b6:	48 b8 df 44 80 00 00 	movabs $0x8044df,%rax
  8025bd:	00 00 00 
  8025c0:	ff d0                	callq  *%rax
}
  8025c2:	c9                   	leaveq 
  8025c3:	c3                   	retq   

00000000008025c4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8025c4:	55                   	push   %rbp
  8025c5:	48 89 e5             	mov    %rsp,%rbp
  8025c8:	48 83 ec 10          	sub    $0x10,%rsp
  8025cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8025d0:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  8025d3:	48 ba f6 4d 80 00 00 	movabs $0x804df6,%rdx
  8025da:	00 00 00 
  8025dd:	be 4c 00 00 00       	mov    $0x4c,%esi
  8025e2:	48 bf 0b 4e 80 00 00 	movabs $0x804e0b,%rdi
  8025e9:	00 00 00 
  8025ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f1:	48 b9 6a 01 80 00 00 	movabs $0x80016a,%rcx
  8025f8:	00 00 00 
  8025fb:	ff d1                	callq  *%rcx

00000000008025fd <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8025fd:	55                   	push   %rbp
  8025fe:	48 89 e5             	mov    %rsp,%rbp
  802601:	48 83 ec 10          	sub    $0x10,%rsp
  802605:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802609:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80260d:	8b 50 0c             	mov    0xc(%rax),%edx
  802610:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802617:	00 00 00 
  80261a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80261c:	be 00 00 00 00       	mov    $0x0,%esi
  802621:	bf 06 00 00 00       	mov    $0x6,%edi
  802626:	48 b8 3b 25 80 00 00 	movabs $0x80253b,%rax
  80262d:	00 00 00 
  802630:	ff d0                	callq  *%rax
}
  802632:	c9                   	leaveq 
  802633:	c3                   	retq   

0000000000802634 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802634:	55                   	push   %rbp
  802635:	48 89 e5             	mov    %rsp,%rbp
  802638:	48 83 ec 20          	sub    $0x20,%rsp
  80263c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802640:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802644:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  802648:	48 ba 16 4e 80 00 00 	movabs $0x804e16,%rdx
  80264f:	00 00 00 
  802652:	be 6b 00 00 00       	mov    $0x6b,%esi
  802657:	48 bf 0b 4e 80 00 00 	movabs $0x804e0b,%rdi
  80265e:	00 00 00 
  802661:	b8 00 00 00 00       	mov    $0x0,%eax
  802666:	48 b9 6a 01 80 00 00 	movabs $0x80016a,%rcx
  80266d:	00 00 00 
  802670:	ff d1                	callq  *%rcx

0000000000802672 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802672:	55                   	push   %rbp
  802673:	48 89 e5             	mov    %rsp,%rbp
  802676:	48 83 ec 20          	sub    $0x20,%rsp
  80267a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80267e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802682:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  802686:	48 ba 33 4e 80 00 00 	movabs $0x804e33,%rdx
  80268d:	00 00 00 
  802690:	be 7b 00 00 00       	mov    $0x7b,%esi
  802695:	48 bf 0b 4e 80 00 00 	movabs $0x804e0b,%rdi
  80269c:	00 00 00 
  80269f:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a4:	48 b9 6a 01 80 00 00 	movabs $0x80016a,%rcx
  8026ab:	00 00 00 
  8026ae:	ff d1                	callq  *%rcx

00000000008026b0 <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8026b0:	55                   	push   %rbp
  8026b1:	48 89 e5             	mov    %rsp,%rbp
  8026b4:	48 83 ec 20          	sub    $0x20,%rsp
  8026b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8026c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026c4:	8b 50 0c             	mov    0xc(%rax),%edx
  8026c7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8026ce:	00 00 00 
  8026d1:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8026d3:	be 00 00 00 00       	mov    $0x0,%esi
  8026d8:	bf 05 00 00 00       	mov    $0x5,%edi
  8026dd:	48 b8 3b 25 80 00 00 	movabs $0x80253b,%rax
  8026e4:	00 00 00 
  8026e7:	ff d0                	callq  *%rax
  8026e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026f0:	79 05                	jns    8026f7 <devfile_stat+0x47>
		return r;
  8026f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026f5:	eb 56                	jmp    80274d <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8026f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026fb:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802702:	00 00 00 
  802705:	48 89 c7             	mov    %rax,%rdi
  802708:	48 b8 3d 0f 80 00 00 	movabs $0x800f3d,%rax
  80270f:	00 00 00 
  802712:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802714:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80271b:	00 00 00 
  80271e:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802724:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802728:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80272e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802735:	00 00 00 
  802738:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80273e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802742:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802748:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80274d:	c9                   	leaveq 
  80274e:	c3                   	retq   

000000000080274f <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80274f:	55                   	push   %rbp
  802750:	48 89 e5             	mov    %rsp,%rbp
  802753:	48 83 ec 10          	sub    $0x10,%rsp
  802757:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80275b:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80275e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802762:	8b 50 0c             	mov    0xc(%rax),%edx
  802765:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80276c:	00 00 00 
  80276f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802771:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802778:	00 00 00 
  80277b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80277e:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802781:	be 00 00 00 00       	mov    $0x0,%esi
  802786:	bf 02 00 00 00       	mov    $0x2,%edi
  80278b:	48 b8 3b 25 80 00 00 	movabs $0x80253b,%rax
  802792:	00 00 00 
  802795:	ff d0                	callq  *%rax
}
  802797:	c9                   	leaveq 
  802798:	c3                   	retq   

0000000000802799 <remove>:

// Delete a file
int
remove(const char *path)
{
  802799:	55                   	push   %rbp
  80279a:	48 89 e5             	mov    %rsp,%rbp
  80279d:	48 83 ec 10          	sub    $0x10,%rsp
  8027a1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8027a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027a9:	48 89 c7             	mov    %rax,%rdi
  8027ac:	48 b8 d1 0e 80 00 00 	movabs $0x800ed1,%rax
  8027b3:	00 00 00 
  8027b6:	ff d0                	callq  *%rax
  8027b8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8027bd:	7e 07                	jle    8027c6 <remove+0x2d>
		return -E_BAD_PATH;
  8027bf:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8027c4:	eb 33                	jmp    8027f9 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8027c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027ca:	48 89 c6             	mov    %rax,%rsi
  8027cd:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8027d4:	00 00 00 
  8027d7:	48 b8 3d 0f 80 00 00 	movabs $0x800f3d,%rax
  8027de:	00 00 00 
  8027e1:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8027e3:	be 00 00 00 00       	mov    $0x0,%esi
  8027e8:	bf 07 00 00 00       	mov    $0x7,%edi
  8027ed:	48 b8 3b 25 80 00 00 	movabs $0x80253b,%rax
  8027f4:	00 00 00 
  8027f7:	ff d0                	callq  *%rax
}
  8027f9:	c9                   	leaveq 
  8027fa:	c3                   	retq   

00000000008027fb <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8027fb:	55                   	push   %rbp
  8027fc:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8027ff:	be 00 00 00 00       	mov    $0x0,%esi
  802804:	bf 08 00 00 00       	mov    $0x8,%edi
  802809:	48 b8 3b 25 80 00 00 	movabs $0x80253b,%rax
  802810:	00 00 00 
  802813:	ff d0                	callq  *%rax
}
  802815:	5d                   	pop    %rbp
  802816:	c3                   	retq   

0000000000802817 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802817:	55                   	push   %rbp
  802818:	48 89 e5             	mov    %rsp,%rbp
  80281b:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802822:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802829:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802830:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802837:	be 00 00 00 00       	mov    $0x0,%esi
  80283c:	48 89 c7             	mov    %rax,%rdi
  80283f:	48 b8 c4 25 80 00 00 	movabs $0x8025c4,%rax
  802846:	00 00 00 
  802849:	ff d0                	callq  *%rax
  80284b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80284e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802852:	79 28                	jns    80287c <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802854:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802857:	89 c6                	mov    %eax,%esi
  802859:	48 bf 51 4e 80 00 00 	movabs $0x804e51,%rdi
  802860:	00 00 00 
  802863:	b8 00 00 00 00       	mov    $0x0,%eax
  802868:	48 ba a3 03 80 00 00 	movabs $0x8003a3,%rdx
  80286f:	00 00 00 
  802872:	ff d2                	callq  *%rdx
		return fd_src;
  802874:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802877:	e9 74 01 00 00       	jmpq   8029f0 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80287c:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802883:	be 01 01 00 00       	mov    $0x101,%esi
  802888:	48 89 c7             	mov    %rax,%rdi
  80288b:	48 b8 c4 25 80 00 00 	movabs $0x8025c4,%rax
  802892:	00 00 00 
  802895:	ff d0                	callq  *%rax
  802897:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80289a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80289e:	79 39                	jns    8028d9 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8028a0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028a3:	89 c6                	mov    %eax,%esi
  8028a5:	48 bf 67 4e 80 00 00 	movabs $0x804e67,%rdi
  8028ac:	00 00 00 
  8028af:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b4:	48 ba a3 03 80 00 00 	movabs $0x8003a3,%rdx
  8028bb:	00 00 00 
  8028be:	ff d2                	callq  *%rdx
		close(fd_src);
  8028c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028c3:	89 c7                	mov    %eax,%edi
  8028c5:	48 b8 ca 1e 80 00 00 	movabs $0x801eca,%rax
  8028cc:	00 00 00 
  8028cf:	ff d0                	callq  *%rax
		return fd_dest;
  8028d1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028d4:	e9 17 01 00 00       	jmpq   8029f0 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8028d9:	eb 74                	jmp    80294f <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8028db:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8028de:	48 63 d0             	movslq %eax,%rdx
  8028e1:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8028e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028eb:	48 89 ce             	mov    %rcx,%rsi
  8028ee:	89 c7                	mov    %eax,%edi
  8028f0:	48 b8 36 22 80 00 00 	movabs $0x802236,%rax
  8028f7:	00 00 00 
  8028fa:	ff d0                	callq  *%rax
  8028fc:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8028ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802903:	79 4a                	jns    80294f <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802905:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802908:	89 c6                	mov    %eax,%esi
  80290a:	48 bf 81 4e 80 00 00 	movabs $0x804e81,%rdi
  802911:	00 00 00 
  802914:	b8 00 00 00 00       	mov    $0x0,%eax
  802919:	48 ba a3 03 80 00 00 	movabs $0x8003a3,%rdx
  802920:	00 00 00 
  802923:	ff d2                	callq  *%rdx
			close(fd_src);
  802925:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802928:	89 c7                	mov    %eax,%edi
  80292a:	48 b8 ca 1e 80 00 00 	movabs $0x801eca,%rax
  802931:	00 00 00 
  802934:	ff d0                	callq  *%rax
			close(fd_dest);
  802936:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802939:	89 c7                	mov    %eax,%edi
  80293b:	48 b8 ca 1e 80 00 00 	movabs $0x801eca,%rax
  802942:	00 00 00 
  802945:	ff d0                	callq  *%rax
			return write_size;
  802947:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80294a:	e9 a1 00 00 00       	jmpq   8029f0 <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80294f:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802956:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802959:	ba 00 02 00 00       	mov    $0x200,%edx
  80295e:	48 89 ce             	mov    %rcx,%rsi
  802961:	89 c7                	mov    %eax,%edi
  802963:	48 b8 ec 20 80 00 00 	movabs $0x8020ec,%rax
  80296a:	00 00 00 
  80296d:	ff d0                	callq  *%rax
  80296f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802972:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802976:	0f 8f 5f ff ff ff    	jg     8028db <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  80297c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802980:	79 47                	jns    8029c9 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802982:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802985:	89 c6                	mov    %eax,%esi
  802987:	48 bf 94 4e 80 00 00 	movabs $0x804e94,%rdi
  80298e:	00 00 00 
  802991:	b8 00 00 00 00       	mov    $0x0,%eax
  802996:	48 ba a3 03 80 00 00 	movabs $0x8003a3,%rdx
  80299d:	00 00 00 
  8029a0:	ff d2                	callq  *%rdx
		close(fd_src);
  8029a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a5:	89 c7                	mov    %eax,%edi
  8029a7:	48 b8 ca 1e 80 00 00 	movabs $0x801eca,%rax
  8029ae:	00 00 00 
  8029b1:	ff d0                	callq  *%rax
		close(fd_dest);
  8029b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029b6:	89 c7                	mov    %eax,%edi
  8029b8:	48 b8 ca 1e 80 00 00 	movabs $0x801eca,%rax
  8029bf:	00 00 00 
  8029c2:	ff d0                	callq  *%rax
		return read_size;
  8029c4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8029c7:	eb 27                	jmp    8029f0 <copy+0x1d9>
	}
	close(fd_src);
  8029c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029cc:	89 c7                	mov    %eax,%edi
  8029ce:	48 b8 ca 1e 80 00 00 	movabs $0x801eca,%rax
  8029d5:	00 00 00 
  8029d8:	ff d0                	callq  *%rax
	close(fd_dest);
  8029da:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029dd:	89 c7                	mov    %eax,%edi
  8029df:	48 b8 ca 1e 80 00 00 	movabs $0x801eca,%rax
  8029e6:	00 00 00 
  8029e9:	ff d0                	callq  *%rax
	return 0;
  8029eb:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8029f0:	c9                   	leaveq 
  8029f1:	c3                   	retq   

00000000008029f2 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8029f2:	55                   	push   %rbp
  8029f3:	48 89 e5             	mov    %rsp,%rbp
  8029f6:	48 81 ec 00 03 00 00 	sub    $0x300,%rsp
  8029fd:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  802a04:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial rip and rsp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802a0b:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  802a12:	be 00 00 00 00       	mov    $0x0,%esi
  802a17:	48 89 c7             	mov    %rax,%rdi
  802a1a:	48 b8 c4 25 80 00 00 	movabs $0x8025c4,%rax
  802a21:	00 00 00 
  802a24:	ff d0                	callq  *%rax
  802a26:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802a29:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802a2d:	79 08                	jns    802a37 <spawn+0x45>
		return r;
  802a2f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802a32:	e9 12 03 00 00       	jmpq   802d49 <spawn+0x357>
	fd = r;
  802a37:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802a3a:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802a3d:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  802a44:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802a48:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  802a4f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802a52:	ba 00 02 00 00       	mov    $0x200,%edx
  802a57:	48 89 ce             	mov    %rcx,%rsi
  802a5a:	89 c7                	mov    %eax,%edi
  802a5c:	48 b8 c1 21 80 00 00 	movabs $0x8021c1,%rax
  802a63:	00 00 00 
  802a66:	ff d0                	callq  *%rax
  802a68:	3d 00 02 00 00       	cmp    $0x200,%eax
  802a6d:	75 0d                	jne    802a7c <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  802a6f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a73:	8b 00                	mov    (%rax),%eax
  802a75:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802a7a:	74 43                	je     802abf <spawn+0xcd>
		close(fd);
  802a7c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802a7f:	89 c7                	mov    %eax,%edi
  802a81:	48 b8 ca 1e 80 00 00 	movabs $0x801eca,%rax
  802a88:	00 00 00 
  802a8b:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802a8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a91:	8b 00                	mov    (%rax),%eax
  802a93:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802a98:	89 c6                	mov    %eax,%esi
  802a9a:	48 bf b0 4e 80 00 00 	movabs $0x804eb0,%rdi
  802aa1:	00 00 00 
  802aa4:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa9:	48 b9 a3 03 80 00 00 	movabs $0x8003a3,%rcx
  802ab0:	00 00 00 
  802ab3:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802ab5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802aba:	e9 8a 02 00 00       	jmpq   802d49 <spawn+0x357>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802abf:	b8 07 00 00 00       	mov    $0x7,%eax
  802ac4:	cd 30                	int    $0x30
  802ac6:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802ac9:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802acc:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802acf:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802ad3:	79 08                	jns    802add <spawn+0xeb>
		return r;
  802ad5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802ad8:	e9 6c 02 00 00       	jmpq   802d49 <spawn+0x357>
	child = r;
  802add:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802ae0:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802ae3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802ae6:	25 ff 03 00 00       	and    $0x3ff,%eax
  802aeb:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802af2:	00 00 00 
  802af5:	48 98                	cltq   
  802af7:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802afe:	48 01 c2             	add    %rax,%rdx
  802b01:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802b08:	48 89 d6             	mov    %rdx,%rsi
  802b0b:	ba 18 00 00 00       	mov    $0x18,%edx
  802b10:	48 89 c7             	mov    %rax,%rdi
  802b13:	48 89 d1             	mov    %rdx,%rcx
  802b16:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  802b19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b1d:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b21:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  802b28:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802b2f:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  802b36:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  802b3d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802b40:	48 89 ce             	mov    %rcx,%rsi
  802b43:	89 c7                	mov    %eax,%edi
  802b45:	48 b8 ad 2f 80 00 00 	movabs $0x802fad,%rax
  802b4c:	00 00 00 
  802b4f:	ff d0                	callq  *%rax
  802b51:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802b54:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802b58:	79 08                	jns    802b62 <spawn+0x170>
		return r;
  802b5a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802b5d:	e9 e7 01 00 00       	jmpq   802d49 <spawn+0x357>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802b62:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b66:	48 8b 40 20          	mov    0x20(%rax),%rax
  802b6a:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  802b71:	48 01 d0             	add    %rdx,%rax
  802b74:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802b78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b7f:	e9 a9 00 00 00       	jmpq   802c2d <spawn+0x23b>
		if (ph->p_type != ELF_PROG_LOAD)
  802b84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b88:	8b 00                	mov    (%rax),%eax
  802b8a:	83 f8 01             	cmp    $0x1,%eax
  802b8d:	74 05                	je     802b94 <spawn+0x1a2>
			continue;
  802b8f:	e9 90 00 00 00       	jmpq   802c24 <spawn+0x232>
		perm = PTE_P | PTE_U;
  802b94:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802b9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b9f:	8b 40 04             	mov    0x4(%rax),%eax
  802ba2:	83 e0 02             	and    $0x2,%eax
  802ba5:	85 c0                	test   %eax,%eax
  802ba7:	74 04                	je     802bad <spawn+0x1bb>
			perm |= PTE_W;
  802ba9:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802bad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb1:	48 8b 40 08          	mov    0x8(%rax),%rax
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802bb5:	41 89 c1             	mov    %eax,%r9d
  802bb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bbc:	4c 8b 40 20          	mov    0x20(%rax),%r8
  802bc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bc4:	48 8b 50 28          	mov    0x28(%rax),%rdx
  802bc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bcc:	48 8b 70 10          	mov    0x10(%rax),%rsi
  802bd0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802bd3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802bd6:	48 83 ec 08          	sub    $0x8,%rsp
  802bda:	8b 7d ec             	mov    -0x14(%rbp),%edi
  802bdd:	57                   	push   %rdi
  802bde:	89 c7                	mov    %eax,%edi
  802be0:	48 b8 59 32 80 00 00 	movabs $0x803259,%rax
  802be7:	00 00 00 
  802bea:	ff d0                	callq  *%rax
  802bec:	48 83 c4 10          	add    $0x10,%rsp
  802bf0:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802bf3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802bf7:	79 2b                	jns    802c24 <spawn+0x232>
			goto error;
  802bf9:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802bfa:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802bfd:	89 c7                	mov    %eax,%edi
  802bff:	48 b8 ac 17 80 00 00 	movabs $0x8017ac,%rax
  802c06:	00 00 00 
  802c09:	ff d0                	callq  *%rax
	close(fd);
  802c0b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802c0e:	89 c7                	mov    %eax,%edi
  802c10:	48 b8 ca 1e 80 00 00 	movabs $0x801eca,%rax
  802c17:	00 00 00 
  802c1a:	ff d0                	callq  *%rax
	return r;
  802c1c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802c1f:	e9 25 01 00 00       	jmpq   802d49 <spawn+0x357>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802c24:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802c28:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  802c2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c31:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  802c35:	0f b7 c0             	movzwl %ax,%eax
  802c38:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802c3b:	0f 8f 43 ff ff ff    	jg     802b84 <spawn+0x192>
	close(fd);
  802c41:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802c44:	89 c7                	mov    %eax,%edi
  802c46:	48 b8 ca 1e 80 00 00 	movabs $0x801eca,%rax
  802c4d:	00 00 00 
  802c50:	ff d0                	callq  *%rax
	fd = -1;
  802c52:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)
	if ((r = copy_shared_pages(child)) < 0)
  802c59:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802c5c:	89 c7                	mov    %eax,%edi
  802c5e:	48 b8 45 34 80 00 00 	movabs $0x803445,%rax
  802c65:	00 00 00 
  802c68:	ff d0                	callq  *%rax
  802c6a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802c6d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802c71:	79 30                	jns    802ca3 <spawn+0x2b1>
		panic("copy_shared_pages: %e", r);
  802c73:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802c76:	89 c1                	mov    %eax,%ecx
  802c78:	48 ba ca 4e 80 00 00 	movabs $0x804eca,%rdx
  802c7f:	00 00 00 
  802c82:	be 82 00 00 00       	mov    $0x82,%esi
  802c87:	48 bf e0 4e 80 00 00 	movabs $0x804ee0,%rdi
  802c8e:	00 00 00 
  802c91:	b8 00 00 00 00       	mov    $0x0,%eax
  802c96:	49 b8 6a 01 80 00 00 	movabs $0x80016a,%r8
  802c9d:	00 00 00 
  802ca0:	41 ff d0             	callq  *%r8
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802ca3:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802caa:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802cad:	48 89 d6             	mov    %rdx,%rsi
  802cb0:	89 c7                	mov    %eax,%edi
  802cb2:	48 b8 b5 19 80 00 00 	movabs $0x8019b5,%rax
  802cb9:	00 00 00 
  802cbc:	ff d0                	callq  *%rax
  802cbe:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802cc1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802cc5:	79 30                	jns    802cf7 <spawn+0x305>
		panic("sys_env_set_trapframe: %e", r);
  802cc7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802cca:	89 c1                	mov    %eax,%ecx
  802ccc:	48 ba ec 4e 80 00 00 	movabs $0x804eec,%rdx
  802cd3:	00 00 00 
  802cd6:	be 85 00 00 00       	mov    $0x85,%esi
  802cdb:	48 bf e0 4e 80 00 00 	movabs $0x804ee0,%rdi
  802ce2:	00 00 00 
  802ce5:	b8 00 00 00 00       	mov    $0x0,%eax
  802cea:	49 b8 6a 01 80 00 00 	movabs $0x80016a,%r8
  802cf1:	00 00 00 
  802cf4:	41 ff d0             	callq  *%r8
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802cf7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802cfa:	be 02 00 00 00       	mov    $0x2,%esi
  802cff:	89 c7                	mov    %eax,%edi
  802d01:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  802d08:	00 00 00 
  802d0b:	ff d0                	callq  *%rax
  802d0d:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802d10:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802d14:	79 30                	jns    802d46 <spawn+0x354>
		panic("sys_env_set_status: %e", r);
  802d16:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802d19:	89 c1                	mov    %eax,%ecx
  802d1b:	48 ba 06 4f 80 00 00 	movabs $0x804f06,%rdx
  802d22:	00 00 00 
  802d25:	be 88 00 00 00       	mov    $0x88,%esi
  802d2a:	48 bf e0 4e 80 00 00 	movabs $0x804ee0,%rdi
  802d31:	00 00 00 
  802d34:	b8 00 00 00 00       	mov    $0x0,%eax
  802d39:	49 b8 6a 01 80 00 00 	movabs $0x80016a,%r8
  802d40:	00 00 00 
  802d43:	41 ff d0             	callq  *%r8
	return child;
  802d46:	8b 45 d4             	mov    -0x2c(%rbp),%eax
}
  802d49:	c9                   	leaveq 
  802d4a:	c3                   	retq   

0000000000802d4b <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802d4b:	55                   	push   %rbp
  802d4c:	48 89 e5             	mov    %rsp,%rbp
  802d4f:	41 55                	push   %r13
  802d51:	41 54                	push   %r12
  802d53:	53                   	push   %rbx
  802d54:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802d5b:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  802d62:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  802d69:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  802d70:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  802d77:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  802d7e:	84 c0                	test   %al,%al
  802d80:	74 26                	je     802da8 <spawnl+0x5d>
  802d82:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  802d89:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  802d90:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  802d94:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  802d98:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  802d9c:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  802da0:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  802da4:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  802da8:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802daf:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  802db6:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  802db9:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  802dc0:	00 00 00 
  802dc3:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  802dca:	00 00 00 
  802dcd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802dd1:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  802dd8:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  802ddf:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  802de6:	eb 07                	jmp    802def <spawnl+0xa4>
		argc++;
  802de8:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	while(va_arg(vl, void *) != NULL)
  802def:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802df5:	83 f8 30             	cmp    $0x30,%eax
  802df8:	73 23                	jae    802e1d <spawnl+0xd2>
  802dfa:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  802e01:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  802e07:	89 d2                	mov    %edx,%edx
  802e09:	48 01 d0             	add    %rdx,%rax
  802e0c:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  802e12:	83 c2 08             	add    $0x8,%edx
  802e15:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  802e1b:	eb 12                	jmp    802e2f <spawnl+0xe4>
  802e1d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802e24:	48 8d 50 08          	lea    0x8(%rax),%rdx
  802e28:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  802e2f:	48 8b 00             	mov    (%rax),%rax
  802e32:	48 85 c0             	test   %rax,%rax
  802e35:	75 b1                	jne    802de8 <spawnl+0x9d>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802e37:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802e3d:	83 c0 02             	add    $0x2,%eax
  802e40:	48 89 e2             	mov    %rsp,%rdx
  802e43:	48 89 d3             	mov    %rdx,%rbx
  802e46:	48 63 d0             	movslq %eax,%rdx
  802e49:	48 83 ea 01          	sub    $0x1,%rdx
  802e4d:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  802e54:	48 63 d0             	movslq %eax,%rdx
  802e57:	49 89 d4             	mov    %rdx,%r12
  802e5a:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  802e60:	48 63 d0             	movslq %eax,%rdx
  802e63:	49 89 d2             	mov    %rdx,%r10
  802e66:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  802e6c:	48 98                	cltq   
  802e6e:	48 c1 e0 03          	shl    $0x3,%rax
  802e72:	48 8d 50 07          	lea    0x7(%rax),%rdx
  802e76:	b8 10 00 00 00       	mov    $0x10,%eax
  802e7b:	48 83 e8 01          	sub    $0x1,%rax
  802e7f:	48 01 d0             	add    %rdx,%rax
  802e82:	be 10 00 00 00       	mov    $0x10,%esi
  802e87:	ba 00 00 00 00       	mov    $0x0,%edx
  802e8c:	48 f7 f6             	div    %rsi
  802e8f:	48 6b c0 10          	imul   $0x10,%rax,%rax
  802e93:	48 29 c4             	sub    %rax,%rsp
  802e96:	48 89 e0             	mov    %rsp,%rax
  802e99:	48 83 c0 07          	add    $0x7,%rax
  802e9d:	48 c1 e8 03          	shr    $0x3,%rax
  802ea1:	48 c1 e0 03          	shl    $0x3,%rax
  802ea5:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  802eac:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  802eb3:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  802eba:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  802ebd:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802ec3:	8d 50 01             	lea    0x1(%rax),%edx
  802ec6:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  802ecd:	48 63 d2             	movslq %edx,%rdx
  802ed0:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  802ed7:	00 

	va_start(vl, arg0);
  802ed8:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  802edf:	00 00 00 
  802ee2:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  802ee9:	00 00 00 
  802eec:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802ef0:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  802ef7:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  802efe:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  802f05:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  802f0c:	00 00 00 
  802f0f:	eb 60                	jmp    802f71 <spawnl+0x226>
		argv[i+1] = va_arg(vl, const char *);
  802f11:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  802f17:	8d 48 01             	lea    0x1(%rax),%ecx
  802f1a:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802f20:	83 f8 30             	cmp    $0x30,%eax
  802f23:	73 23                	jae    802f48 <spawnl+0x1fd>
  802f25:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  802f2c:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  802f32:	89 d2                	mov    %edx,%edx
  802f34:	48 01 d0             	add    %rdx,%rax
  802f37:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  802f3d:	83 c2 08             	add    $0x8,%edx
  802f40:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  802f46:	eb 12                	jmp    802f5a <spawnl+0x20f>
  802f48:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802f4f:	48 8d 50 08          	lea    0x8(%rax),%rdx
  802f53:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  802f5a:	48 8b 10             	mov    (%rax),%rdx
  802f5d:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  802f64:	89 c9                	mov    %ecx,%ecx
  802f66:	48 89 14 c8          	mov    %rdx,(%rax,%rcx,8)
	for(i=0;i<argc;i++)
  802f6a:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  802f71:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802f77:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  802f7d:	77 92                	ja     802f11 <spawnl+0x1c6>
	va_end(vl);
	return spawn(prog, argv);
  802f7f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802f86:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  802f8d:	48 89 d6             	mov    %rdx,%rsi
  802f90:	48 89 c7             	mov    %rax,%rdi
  802f93:	48 b8 f2 29 80 00 00 	movabs $0x8029f2,%rax
  802f9a:	00 00 00 
  802f9d:	ff d0                	callq  *%rax
  802f9f:	48 89 dc             	mov    %rbx,%rsp
}
  802fa2:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  802fa6:	5b                   	pop    %rbx
  802fa7:	41 5c                	pop    %r12
  802fa9:	41 5d                	pop    %r13
  802fab:	5d                   	pop    %rbp
  802fac:	c3                   	retq   

0000000000802fad <init_stack>:
// On success, returns 0 and sets *init_rsp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_rsp)
{
  802fad:	55                   	push   %rbp
  802fae:	48 89 e5             	mov    %rsp,%rbp
  802fb1:	48 83 ec 50          	sub    $0x50,%rsp
  802fb5:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802fb8:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802fbc:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  802fc0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802fc7:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  802fc8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  802fcf:	eb 33                	jmp    803004 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  802fd1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802fd4:	48 98                	cltq   
  802fd6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802fdd:	00 
  802fde:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802fe2:	48 01 d0             	add    %rdx,%rax
  802fe5:	48 8b 00             	mov    (%rax),%rax
  802fe8:	48 89 c7             	mov    %rax,%rdi
  802feb:	48 b8 d1 0e 80 00 00 	movabs $0x800ed1,%rax
  802ff2:	00 00 00 
  802ff5:	ff d0                	callq  *%rax
  802ff7:	83 c0 01             	add    $0x1,%eax
  802ffa:	48 98                	cltq   
  802ffc:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	for (argc = 0; argv[argc] != 0; argc++)
  803000:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803004:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803007:	48 98                	cltq   
  803009:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803010:	00 
  803011:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803015:	48 01 d0             	add    %rdx,%rax
  803018:	48 8b 00             	mov    (%rax),%rax
  80301b:	48 85 c0             	test   %rax,%rax
  80301e:	75 b1                	jne    802fd1 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803020:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803024:	48 f7 d8             	neg    %rax
  803027:	48 05 00 10 40 00    	add    $0x401000,%rax
  80302d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803031:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803035:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803039:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80303d:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803041:	48 89 c2             	mov    %rax,%rdx
  803044:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803047:	83 c0 01             	add    $0x1,%eax
  80304a:	c1 e0 03             	shl    $0x3,%eax
  80304d:	48 98                	cltq   
  80304f:	48 f7 d8             	neg    %rax
  803052:	48 01 d0             	add    %rdx,%rax
  803055:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803059:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80305d:	48 83 e8 10          	sub    $0x10,%rax
  803061:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803067:	77 0a                	ja     803073 <init_stack+0xc6>
		return -E_NO_MEM;
  803069:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  80306e:	e9 e4 01 00 00       	jmpq   803257 <init_stack+0x2aa>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803073:	ba 07 00 00 00       	mov    $0x7,%edx
  803078:	be 00 00 40 00       	mov    $0x400000,%esi
  80307d:	bf 00 00 00 00       	mov    $0x0,%edi
  803082:	48 b8 6a 18 80 00 00 	movabs $0x80186a,%rax
  803089:	00 00 00 
  80308c:	ff d0                	callq  *%rax
  80308e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803091:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803095:	79 08                	jns    80309f <init_stack+0xf2>
		return r;
  803097:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80309a:	e9 b8 01 00 00       	jmpq   803257 <init_stack+0x2aa>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_rsp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80309f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  8030a6:	e9 8a 00 00 00       	jmpq   803135 <init_stack+0x188>
		argv_store[i] = UTEMP2USTACK(string_store);
  8030ab:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8030ae:	48 98                	cltq   
  8030b0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8030b7:	00 
  8030b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030bc:	48 01 d0             	add    %rdx,%rax
  8030bf:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8030c4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8030c8:	48 01 ca             	add    %rcx,%rdx
  8030cb:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  8030d2:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  8030d5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8030d8:	48 98                	cltq   
  8030da:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8030e1:	00 
  8030e2:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8030e6:	48 01 d0             	add    %rdx,%rax
  8030e9:	48 8b 10             	mov    (%rax),%rdx
  8030ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030f0:	48 89 d6             	mov    %rdx,%rsi
  8030f3:	48 89 c7             	mov    %rax,%rdi
  8030f6:	48 b8 3d 0f 80 00 00 	movabs $0x800f3d,%rax
  8030fd:	00 00 00 
  803100:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803102:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803105:	48 98                	cltq   
  803107:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80310e:	00 
  80310f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803113:	48 01 d0             	add    %rdx,%rax
  803116:	48 8b 00             	mov    (%rax),%rax
  803119:	48 89 c7             	mov    %rax,%rdi
  80311c:	48 b8 d1 0e 80 00 00 	movabs $0x800ed1,%rax
  803123:	00 00 00 
  803126:	ff d0                	callq  *%rax
  803128:	83 c0 01             	add    $0x1,%eax
  80312b:	48 98                	cltq   
  80312d:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	for (i = 0; i < argc; i++) {
  803131:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803135:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803138:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80313b:	0f 8c 6a ff ff ff    	jl     8030ab <init_stack+0xfe>
	}
	argv_store[argc] = 0;
  803141:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803144:	48 98                	cltq   
  803146:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80314d:	00 
  80314e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803152:	48 01 d0             	add    %rdx,%rax
  803155:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80315c:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803163:	00 
  803164:	74 35                	je     80319b <init_stack+0x1ee>
  803166:	48 b9 20 4f 80 00 00 	movabs $0x804f20,%rcx
  80316d:	00 00 00 
  803170:	48 ba 46 4f 80 00 00 	movabs $0x804f46,%rdx
  803177:	00 00 00 
  80317a:	be f1 00 00 00       	mov    $0xf1,%esi
  80317f:	48 bf e0 4e 80 00 00 	movabs $0x804ee0,%rdi
  803186:	00 00 00 
  803189:	b8 00 00 00 00       	mov    $0x0,%eax
  80318e:	49 b8 6a 01 80 00 00 	movabs $0x80016a,%r8
  803195:	00 00 00 
  803198:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80319b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80319f:	48 83 e8 08          	sub    $0x8,%rax
  8031a3:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8031a8:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8031ac:	48 01 ca             	add    %rcx,%rdx
  8031af:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  8031b6:	48 89 10             	mov    %rdx,(%rax)
	argv_store[-2] = argc;
  8031b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031bd:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  8031c1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031c4:	48 98                	cltq   
  8031c6:	48 89 02             	mov    %rax,(%rdx)

	*init_rsp = UTEMP2USTACK(&argv_store[-2]);
  8031c9:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  8031ce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031d2:	48 01 d0             	add    %rdx,%rax
  8031d5:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8031db:	48 89 c2             	mov    %rax,%rdx
  8031de:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8031e2:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8031e5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8031e8:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8031ee:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8031f3:	89 c2                	mov    %eax,%edx
  8031f5:	be 00 00 40 00       	mov    $0x400000,%esi
  8031fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8031ff:	48 b8 bc 18 80 00 00 	movabs $0x8018bc,%rax
  803206:	00 00 00 
  803209:	ff d0                	callq  *%rax
  80320b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80320e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803212:	79 02                	jns    803216 <init_stack+0x269>
		goto error;
  803214:	eb 28                	jmp    80323e <init_stack+0x291>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803216:	be 00 00 40 00       	mov    $0x400000,%esi
  80321b:	bf 00 00 00 00       	mov    $0x0,%edi
  803220:	48 b8 1c 19 80 00 00 	movabs $0x80191c,%rax
  803227:	00 00 00 
  80322a:	ff d0                	callq  *%rax
  80322c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80322f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803233:	79 02                	jns    803237 <init_stack+0x28a>
		goto error;
  803235:	eb 07                	jmp    80323e <init_stack+0x291>

	return 0;
  803237:	b8 00 00 00 00       	mov    $0x0,%eax
  80323c:	eb 19                	jmp    803257 <init_stack+0x2aa>

error:
	sys_page_unmap(0, UTEMP);
  80323e:	be 00 00 40 00       	mov    $0x400000,%esi
  803243:	bf 00 00 00 00       	mov    $0x0,%edi
  803248:	48 b8 1c 19 80 00 00 	movabs $0x80191c,%rax
  80324f:	00 00 00 
  803252:	ff d0                	callq  *%rax
	return r;
  803254:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803257:	c9                   	leaveq 
  803258:	c3                   	retq   

0000000000803259 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  803259:	55                   	push   %rbp
  80325a:	48 89 e5             	mov    %rsp,%rbp
  80325d:	48 83 ec 50          	sub    $0x50,%rsp
  803261:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803264:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803268:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80326c:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  80326f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803273:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803277:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80327b:	25 ff 0f 00 00       	and    $0xfff,%eax
  803280:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803283:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803287:	74 21                	je     8032aa <map_segment+0x51>
		va -= i;
  803289:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80328c:	48 98                	cltq   
  80328e:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803292:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803295:	48 98                	cltq   
  803297:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  80329b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80329e:	48 98                	cltq   
  8032a0:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  8032a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032a7:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8032aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8032b1:	e9 79 01 00 00       	jmpq   80342f <map_segment+0x1d6>
		if (i >= filesz) {
  8032b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032b9:	48 98                	cltq   
  8032bb:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  8032bf:	72 3c                	jb     8032fd <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8032c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032c4:	48 63 d0             	movslq %eax,%rdx
  8032c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032cb:	48 01 d0             	add    %rdx,%rax
  8032ce:	48 89 c1             	mov    %rax,%rcx
  8032d1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8032d4:	8b 55 10             	mov    0x10(%rbp),%edx
  8032d7:	48 89 ce             	mov    %rcx,%rsi
  8032da:	89 c7                	mov    %eax,%edi
  8032dc:	48 b8 6a 18 80 00 00 	movabs $0x80186a,%rax
  8032e3:	00 00 00 
  8032e6:	ff d0                	callq  *%rax
  8032e8:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8032eb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8032ef:	0f 89 33 01 00 00    	jns    803428 <map_segment+0x1cf>
				return r;
  8032f5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032f8:	e9 46 01 00 00       	jmpq   803443 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8032fd:	ba 07 00 00 00       	mov    $0x7,%edx
  803302:	be 00 00 40 00       	mov    $0x400000,%esi
  803307:	bf 00 00 00 00       	mov    $0x0,%edi
  80330c:	48 b8 6a 18 80 00 00 	movabs $0x80186a,%rax
  803313:	00 00 00 
  803316:	ff d0                	callq  *%rax
  803318:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80331b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80331f:	79 08                	jns    803329 <map_segment+0xd0>
				return r;
  803321:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803324:	e9 1a 01 00 00       	jmpq   803443 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803329:	8b 55 bc             	mov    -0x44(%rbp),%edx
  80332c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80332f:	01 c2                	add    %eax,%edx
  803331:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803334:	89 d6                	mov    %edx,%esi
  803336:	89 c7                	mov    %eax,%edi
  803338:	48 b8 0a 23 80 00 00 	movabs $0x80230a,%rax
  80333f:	00 00 00 
  803342:	ff d0                	callq  *%rax
  803344:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803347:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80334b:	79 08                	jns    803355 <map_segment+0xfc>
				return r;
  80334d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803350:	e9 ee 00 00 00       	jmpq   803443 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803355:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  80335c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80335f:	48 98                	cltq   
  803361:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803365:	48 29 c2             	sub    %rax,%rdx
  803368:	48 89 d0             	mov    %rdx,%rax
  80336b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80336f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803372:	48 63 d0             	movslq %eax,%rdx
  803375:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803379:	48 39 c2             	cmp    %rax,%rdx
  80337c:	48 0f 47 d0          	cmova  %rax,%rdx
  803380:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803383:	be 00 00 40 00       	mov    $0x400000,%esi
  803388:	89 c7                	mov    %eax,%edi
  80338a:	48 b8 c1 21 80 00 00 	movabs $0x8021c1,%rax
  803391:	00 00 00 
  803394:	ff d0                	callq  *%rax
  803396:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803399:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80339d:	79 08                	jns    8033a7 <map_segment+0x14e>
				return r;
  80339f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033a2:	e9 9c 00 00 00       	jmpq   803443 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8033a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033aa:	48 63 d0             	movslq %eax,%rdx
  8033ad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033b1:	48 01 d0             	add    %rdx,%rax
  8033b4:	48 89 c2             	mov    %rax,%rdx
  8033b7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8033ba:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  8033be:	48 89 d1             	mov    %rdx,%rcx
  8033c1:	89 c2                	mov    %eax,%edx
  8033c3:	be 00 00 40 00       	mov    $0x400000,%esi
  8033c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8033cd:	48 b8 bc 18 80 00 00 	movabs $0x8018bc,%rax
  8033d4:	00 00 00 
  8033d7:	ff d0                	callq  *%rax
  8033d9:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8033dc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8033e0:	79 30                	jns    803412 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  8033e2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033e5:	89 c1                	mov    %eax,%ecx
  8033e7:	48 ba 5b 4f 80 00 00 	movabs $0x804f5b,%rdx
  8033ee:	00 00 00 
  8033f1:	be 24 01 00 00       	mov    $0x124,%esi
  8033f6:	48 bf e0 4e 80 00 00 	movabs $0x804ee0,%rdi
  8033fd:	00 00 00 
  803400:	b8 00 00 00 00       	mov    $0x0,%eax
  803405:	49 b8 6a 01 80 00 00 	movabs $0x80016a,%r8
  80340c:	00 00 00 
  80340f:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803412:	be 00 00 40 00       	mov    $0x400000,%esi
  803417:	bf 00 00 00 00       	mov    $0x0,%edi
  80341c:	48 b8 1c 19 80 00 00 	movabs $0x80191c,%rax
  803423:	00 00 00 
  803426:	ff d0                	callq  *%rax
	for (i = 0; i < memsz; i += PGSIZE) {
  803428:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  80342f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803432:	48 98                	cltq   
  803434:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803438:	0f 82 78 fe ff ff    	jb     8032b6 <map_segment+0x5d>
		}
	}
	return 0;
  80343e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803443:	c9                   	leaveq 
  803444:	c3                   	retq   

0000000000803445 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803445:	55                   	push   %rbp
  803446:	48 89 e5             	mov    %rsp,%rbp
  803449:	48 83 ec 08          	sub    $0x8,%rsp
  80344d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	// LAB 5: Your code here.
	return 0;
  803450:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803455:	c9                   	leaveq 
  803456:	c3                   	retq   

0000000000803457 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803457:	55                   	push   %rbp
  803458:	48 89 e5             	mov    %rsp,%rbp
  80345b:	48 83 ec 20          	sub    $0x20,%rsp
  80345f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803462:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803466:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803469:	48 89 d6             	mov    %rdx,%rsi
  80346c:	89 c7                	mov    %eax,%edi
  80346e:	48 b8 b8 1c 80 00 00 	movabs $0x801cb8,%rax
  803475:	00 00 00 
  803478:	ff d0                	callq  *%rax
  80347a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80347d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803481:	79 05                	jns    803488 <fd2sockid+0x31>
		return r;
  803483:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803486:	eb 24                	jmp    8034ac <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803488:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80348c:	8b 10                	mov    (%rax),%edx
  80348e:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803495:	00 00 00 
  803498:	8b 00                	mov    (%rax),%eax
  80349a:	39 c2                	cmp    %eax,%edx
  80349c:	74 07                	je     8034a5 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80349e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8034a3:	eb 07                	jmp    8034ac <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8034a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034a9:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8034ac:	c9                   	leaveq 
  8034ad:	c3                   	retq   

00000000008034ae <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8034ae:	55                   	push   %rbp
  8034af:	48 89 e5             	mov    %rsp,%rbp
  8034b2:	48 83 ec 20          	sub    $0x20,%rsp
  8034b6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8034b9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8034bd:	48 89 c7             	mov    %rax,%rdi
  8034c0:	48 b8 20 1c 80 00 00 	movabs $0x801c20,%rax
  8034c7:	00 00 00 
  8034ca:	ff d0                	callq  *%rax
  8034cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034d3:	78 26                	js     8034fb <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8034d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034d9:	ba 07 04 00 00       	mov    $0x407,%edx
  8034de:	48 89 c6             	mov    %rax,%rsi
  8034e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8034e6:	48 b8 6a 18 80 00 00 	movabs $0x80186a,%rax
  8034ed:	00 00 00 
  8034f0:	ff d0                	callq  *%rax
  8034f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034f9:	79 16                	jns    803511 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8034fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034fe:	89 c7                	mov    %eax,%edi
  803500:	48 b8 bd 39 80 00 00 	movabs $0x8039bd,%rax
  803507:	00 00 00 
  80350a:	ff d0                	callq  *%rax
		return r;
  80350c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80350f:	eb 3a                	jmp    80354b <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803511:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803515:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  80351c:	00 00 00 
  80351f:	8b 12                	mov    (%rdx),%edx
  803521:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803523:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803527:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80352e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803532:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803535:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803538:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80353c:	48 89 c7             	mov    %rax,%rdi
  80353f:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  803546:	00 00 00 
  803549:	ff d0                	callq  *%rax
}
  80354b:	c9                   	leaveq 
  80354c:	c3                   	retq   

000000000080354d <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80354d:	55                   	push   %rbp
  80354e:	48 89 e5             	mov    %rsp,%rbp
  803551:	48 83 ec 30          	sub    $0x30,%rsp
  803555:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803558:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80355c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803560:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803563:	89 c7                	mov    %eax,%edi
  803565:	48 b8 57 34 80 00 00 	movabs $0x803457,%rax
  80356c:	00 00 00 
  80356f:	ff d0                	callq  *%rax
  803571:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803574:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803578:	79 05                	jns    80357f <accept+0x32>
		return r;
  80357a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80357d:	eb 3b                	jmp    8035ba <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80357f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803583:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803587:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80358a:	48 89 ce             	mov    %rcx,%rsi
  80358d:	89 c7                	mov    %eax,%edi
  80358f:	48 b8 9a 38 80 00 00 	movabs $0x80389a,%rax
  803596:	00 00 00 
  803599:	ff d0                	callq  *%rax
  80359b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80359e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035a2:	79 05                	jns    8035a9 <accept+0x5c>
		return r;
  8035a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035a7:	eb 11                	jmp    8035ba <accept+0x6d>
	return alloc_sockfd(r);
  8035a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ac:	89 c7                	mov    %eax,%edi
  8035ae:	48 b8 ae 34 80 00 00 	movabs $0x8034ae,%rax
  8035b5:	00 00 00 
  8035b8:	ff d0                	callq  *%rax
}
  8035ba:	c9                   	leaveq 
  8035bb:	c3                   	retq   

00000000008035bc <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8035bc:	55                   	push   %rbp
  8035bd:	48 89 e5             	mov    %rsp,%rbp
  8035c0:	48 83 ec 20          	sub    $0x20,%rsp
  8035c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035c7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035cb:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035d1:	89 c7                	mov    %eax,%edi
  8035d3:	48 b8 57 34 80 00 00 	movabs $0x803457,%rax
  8035da:	00 00 00 
  8035dd:	ff d0                	callq  *%rax
  8035df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035e6:	79 05                	jns    8035ed <bind+0x31>
		return r;
  8035e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035eb:	eb 1b                	jmp    803608 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8035ed:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8035f0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8035f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f7:	48 89 ce             	mov    %rcx,%rsi
  8035fa:	89 c7                	mov    %eax,%edi
  8035fc:	48 b8 19 39 80 00 00 	movabs $0x803919,%rax
  803603:	00 00 00 
  803606:	ff d0                	callq  *%rax
}
  803608:	c9                   	leaveq 
  803609:	c3                   	retq   

000000000080360a <shutdown>:

int
shutdown(int s, int how)
{
  80360a:	55                   	push   %rbp
  80360b:	48 89 e5             	mov    %rsp,%rbp
  80360e:	48 83 ec 20          	sub    $0x20,%rsp
  803612:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803615:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803618:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80361b:	89 c7                	mov    %eax,%edi
  80361d:	48 b8 57 34 80 00 00 	movabs $0x803457,%rax
  803624:	00 00 00 
  803627:	ff d0                	callq  *%rax
  803629:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80362c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803630:	79 05                	jns    803637 <shutdown+0x2d>
		return r;
  803632:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803635:	eb 16                	jmp    80364d <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803637:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80363a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80363d:	89 d6                	mov    %edx,%esi
  80363f:	89 c7                	mov    %eax,%edi
  803641:	48 b8 7d 39 80 00 00 	movabs $0x80397d,%rax
  803648:	00 00 00 
  80364b:	ff d0                	callq  *%rax
}
  80364d:	c9                   	leaveq 
  80364e:	c3                   	retq   

000000000080364f <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80364f:	55                   	push   %rbp
  803650:	48 89 e5             	mov    %rsp,%rbp
  803653:	48 83 ec 10          	sub    $0x10,%rsp
  803657:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80365b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80365f:	48 89 c7             	mov    %rax,%rdi
  803662:	48 b8 1c 47 80 00 00 	movabs $0x80471c,%rax
  803669:	00 00 00 
  80366c:	ff d0                	callq  *%rax
  80366e:	83 f8 01             	cmp    $0x1,%eax
  803671:	75 17                	jne    80368a <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803673:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803677:	8b 40 0c             	mov    0xc(%rax),%eax
  80367a:	89 c7                	mov    %eax,%edi
  80367c:	48 b8 bd 39 80 00 00 	movabs $0x8039bd,%rax
  803683:	00 00 00 
  803686:	ff d0                	callq  *%rax
  803688:	eb 05                	jmp    80368f <devsock_close+0x40>
	else
		return 0;
  80368a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80368f:	c9                   	leaveq 
  803690:	c3                   	retq   

0000000000803691 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803691:	55                   	push   %rbp
  803692:	48 89 e5             	mov    %rsp,%rbp
  803695:	48 83 ec 20          	sub    $0x20,%rsp
  803699:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80369c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036a0:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036a6:	89 c7                	mov    %eax,%edi
  8036a8:	48 b8 57 34 80 00 00 	movabs $0x803457,%rax
  8036af:	00 00 00 
  8036b2:	ff d0                	callq  *%rax
  8036b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036bb:	79 05                	jns    8036c2 <connect+0x31>
		return r;
  8036bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c0:	eb 1b                	jmp    8036dd <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8036c2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036c5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8036c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036cc:	48 89 ce             	mov    %rcx,%rsi
  8036cf:	89 c7                	mov    %eax,%edi
  8036d1:	48 b8 ea 39 80 00 00 	movabs $0x8039ea,%rax
  8036d8:	00 00 00 
  8036db:	ff d0                	callq  *%rax
}
  8036dd:	c9                   	leaveq 
  8036de:	c3                   	retq   

00000000008036df <listen>:

int
listen(int s, int backlog)
{
  8036df:	55                   	push   %rbp
  8036e0:	48 89 e5             	mov    %rsp,%rbp
  8036e3:	48 83 ec 20          	sub    $0x20,%rsp
  8036e7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036ea:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036f0:	89 c7                	mov    %eax,%edi
  8036f2:	48 b8 57 34 80 00 00 	movabs $0x803457,%rax
  8036f9:	00 00 00 
  8036fc:	ff d0                	callq  *%rax
  8036fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803701:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803705:	79 05                	jns    80370c <listen+0x2d>
		return r;
  803707:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80370a:	eb 16                	jmp    803722 <listen+0x43>
	return nsipc_listen(r, backlog);
  80370c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80370f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803712:	89 d6                	mov    %edx,%esi
  803714:	89 c7                	mov    %eax,%edi
  803716:	48 b8 4e 3a 80 00 00 	movabs $0x803a4e,%rax
  80371d:	00 00 00 
  803720:	ff d0                	callq  *%rax
}
  803722:	c9                   	leaveq 
  803723:	c3                   	retq   

0000000000803724 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803724:	55                   	push   %rbp
  803725:	48 89 e5             	mov    %rsp,%rbp
  803728:	48 83 ec 20          	sub    $0x20,%rsp
  80372c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803730:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803734:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803738:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80373c:	89 c2                	mov    %eax,%edx
  80373e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803742:	8b 40 0c             	mov    0xc(%rax),%eax
  803745:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803749:	b9 00 00 00 00       	mov    $0x0,%ecx
  80374e:	89 c7                	mov    %eax,%edi
  803750:	48 b8 8e 3a 80 00 00 	movabs $0x803a8e,%rax
  803757:	00 00 00 
  80375a:	ff d0                	callq  *%rax
}
  80375c:	c9                   	leaveq 
  80375d:	c3                   	retq   

000000000080375e <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80375e:	55                   	push   %rbp
  80375f:	48 89 e5             	mov    %rsp,%rbp
  803762:	48 83 ec 20          	sub    $0x20,%rsp
  803766:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80376a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80376e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803772:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803776:	89 c2                	mov    %eax,%edx
  803778:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80377c:	8b 40 0c             	mov    0xc(%rax),%eax
  80377f:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803783:	b9 00 00 00 00       	mov    $0x0,%ecx
  803788:	89 c7                	mov    %eax,%edi
  80378a:	48 b8 5a 3b 80 00 00 	movabs $0x803b5a,%rax
  803791:	00 00 00 
  803794:	ff d0                	callq  *%rax
}
  803796:	c9                   	leaveq 
  803797:	c3                   	retq   

0000000000803798 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803798:	55                   	push   %rbp
  803799:	48 89 e5             	mov    %rsp,%rbp
  80379c:	48 83 ec 10          	sub    $0x10,%rsp
  8037a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8037a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ac:	48 be 7d 4f 80 00 00 	movabs $0x804f7d,%rsi
  8037b3:	00 00 00 
  8037b6:	48 89 c7             	mov    %rax,%rdi
  8037b9:	48 b8 3d 0f 80 00 00 	movabs $0x800f3d,%rax
  8037c0:	00 00 00 
  8037c3:	ff d0                	callq  *%rax
	return 0;
  8037c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037ca:	c9                   	leaveq 
  8037cb:	c3                   	retq   

00000000008037cc <socket>:

int
socket(int domain, int type, int protocol)
{
  8037cc:	55                   	push   %rbp
  8037cd:	48 89 e5             	mov    %rsp,%rbp
  8037d0:	48 83 ec 20          	sub    $0x20,%rsp
  8037d4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037d7:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8037da:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8037dd:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8037e0:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8037e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037e6:	89 ce                	mov    %ecx,%esi
  8037e8:	89 c7                	mov    %eax,%edi
  8037ea:	48 b8 12 3c 80 00 00 	movabs $0x803c12,%rax
  8037f1:	00 00 00 
  8037f4:	ff d0                	callq  *%rax
  8037f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037fd:	79 05                	jns    803804 <socket+0x38>
		return r;
  8037ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803802:	eb 11                	jmp    803815 <socket+0x49>
	return alloc_sockfd(r);
  803804:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803807:	89 c7                	mov    %eax,%edi
  803809:	48 b8 ae 34 80 00 00 	movabs $0x8034ae,%rax
  803810:	00 00 00 
  803813:	ff d0                	callq  *%rax
}
  803815:	c9                   	leaveq 
  803816:	c3                   	retq   

0000000000803817 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803817:	55                   	push   %rbp
  803818:	48 89 e5             	mov    %rsp,%rbp
  80381b:	48 83 ec 10          	sub    $0x10,%rsp
  80381f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803822:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803829:	00 00 00 
  80382c:	8b 00                	mov    (%rax),%eax
  80382e:	85 c0                	test   %eax,%eax
  803830:	75 1f                	jne    803851 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803832:	bf 02 00 00 00       	mov    $0x2,%edi
  803837:	48 b8 aa 46 80 00 00 	movabs $0x8046aa,%rax
  80383e:	00 00 00 
  803841:	ff d0                	callq  *%rax
  803843:	89 c2                	mov    %eax,%edx
  803845:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  80384c:	00 00 00 
  80384f:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803851:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803858:	00 00 00 
  80385b:	8b 00                	mov    (%rax),%eax
  80385d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803860:	b9 07 00 00 00       	mov    $0x7,%ecx
  803865:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  80386c:	00 00 00 
  80386f:	89 c7                	mov    %eax,%edi
  803871:	48 b8 1d 45 80 00 00 	movabs $0x80451d,%rax
  803878:	00 00 00 
  80387b:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80387d:	ba 00 00 00 00       	mov    $0x0,%edx
  803882:	be 00 00 00 00       	mov    $0x0,%esi
  803887:	bf 00 00 00 00       	mov    $0x0,%edi
  80388c:	48 b8 df 44 80 00 00 	movabs $0x8044df,%rax
  803893:	00 00 00 
  803896:	ff d0                	callq  *%rax
}
  803898:	c9                   	leaveq 
  803899:	c3                   	retq   

000000000080389a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80389a:	55                   	push   %rbp
  80389b:	48 89 e5             	mov    %rsp,%rbp
  80389e:	48 83 ec 30          	sub    $0x30,%rsp
  8038a2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038a9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8038ad:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8038b4:	00 00 00 
  8038b7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8038ba:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8038bc:	bf 01 00 00 00       	mov    $0x1,%edi
  8038c1:	48 b8 17 38 80 00 00 	movabs $0x803817,%rax
  8038c8:	00 00 00 
  8038cb:	ff d0                	callq  *%rax
  8038cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038d4:	78 3e                	js     803914 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8038d6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8038dd:	00 00 00 
  8038e0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8038e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038e8:	8b 40 10             	mov    0x10(%rax),%eax
  8038eb:	89 c2                	mov    %eax,%edx
  8038ed:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8038f1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038f5:	48 89 ce             	mov    %rcx,%rsi
  8038f8:	48 89 c7             	mov    %rax,%rdi
  8038fb:	48 b8 61 12 80 00 00 	movabs $0x801261,%rax
  803902:	00 00 00 
  803905:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803907:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80390b:	8b 50 10             	mov    0x10(%rax),%edx
  80390e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803912:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803914:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803917:	c9                   	leaveq 
  803918:	c3                   	retq   

0000000000803919 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803919:	55                   	push   %rbp
  80391a:	48 89 e5             	mov    %rsp,%rbp
  80391d:	48 83 ec 10          	sub    $0x10,%rsp
  803921:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803924:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803928:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80392b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803932:	00 00 00 
  803935:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803938:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80393a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80393d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803941:	48 89 c6             	mov    %rax,%rsi
  803944:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  80394b:	00 00 00 
  80394e:	48 b8 61 12 80 00 00 	movabs $0x801261,%rax
  803955:	00 00 00 
  803958:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80395a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803961:	00 00 00 
  803964:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803967:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80396a:	bf 02 00 00 00       	mov    $0x2,%edi
  80396f:	48 b8 17 38 80 00 00 	movabs $0x803817,%rax
  803976:	00 00 00 
  803979:	ff d0                	callq  *%rax
}
  80397b:	c9                   	leaveq 
  80397c:	c3                   	retq   

000000000080397d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80397d:	55                   	push   %rbp
  80397e:	48 89 e5             	mov    %rsp,%rbp
  803981:	48 83 ec 10          	sub    $0x10,%rsp
  803985:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803988:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80398b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803992:	00 00 00 
  803995:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803998:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80399a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039a1:	00 00 00 
  8039a4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039a7:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8039aa:	bf 03 00 00 00       	mov    $0x3,%edi
  8039af:	48 b8 17 38 80 00 00 	movabs $0x803817,%rax
  8039b6:	00 00 00 
  8039b9:	ff d0                	callq  *%rax
}
  8039bb:	c9                   	leaveq 
  8039bc:	c3                   	retq   

00000000008039bd <nsipc_close>:

int
nsipc_close(int s)
{
  8039bd:	55                   	push   %rbp
  8039be:	48 89 e5             	mov    %rsp,%rbp
  8039c1:	48 83 ec 10          	sub    $0x10,%rsp
  8039c5:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8039c8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039cf:	00 00 00 
  8039d2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039d5:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8039d7:	bf 04 00 00 00       	mov    $0x4,%edi
  8039dc:	48 b8 17 38 80 00 00 	movabs $0x803817,%rax
  8039e3:	00 00 00 
  8039e6:	ff d0                	callq  *%rax
}
  8039e8:	c9                   	leaveq 
  8039e9:	c3                   	retq   

00000000008039ea <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8039ea:	55                   	push   %rbp
  8039eb:	48 89 e5             	mov    %rsp,%rbp
  8039ee:	48 83 ec 10          	sub    $0x10,%rsp
  8039f2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039f5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039f9:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8039fc:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a03:	00 00 00 
  803a06:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a09:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803a0b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a12:	48 89 c6             	mov    %rax,%rsi
  803a15:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803a1c:	00 00 00 
  803a1f:	48 b8 61 12 80 00 00 	movabs $0x801261,%rax
  803a26:	00 00 00 
  803a29:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803a2b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a32:	00 00 00 
  803a35:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a38:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803a3b:	bf 05 00 00 00       	mov    $0x5,%edi
  803a40:	48 b8 17 38 80 00 00 	movabs $0x803817,%rax
  803a47:	00 00 00 
  803a4a:	ff d0                	callq  *%rax
}
  803a4c:	c9                   	leaveq 
  803a4d:	c3                   	retq   

0000000000803a4e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803a4e:	55                   	push   %rbp
  803a4f:	48 89 e5             	mov    %rsp,%rbp
  803a52:	48 83 ec 10          	sub    $0x10,%rsp
  803a56:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a59:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803a5c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a63:	00 00 00 
  803a66:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a69:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803a6b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a72:	00 00 00 
  803a75:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a78:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803a7b:	bf 06 00 00 00       	mov    $0x6,%edi
  803a80:	48 b8 17 38 80 00 00 	movabs $0x803817,%rax
  803a87:	00 00 00 
  803a8a:	ff d0                	callq  *%rax
}
  803a8c:	c9                   	leaveq 
  803a8d:	c3                   	retq   

0000000000803a8e <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803a8e:	55                   	push   %rbp
  803a8f:	48 89 e5             	mov    %rsp,%rbp
  803a92:	48 83 ec 30          	sub    $0x30,%rsp
  803a96:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a99:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a9d:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803aa0:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803aa3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803aaa:	00 00 00 
  803aad:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803ab0:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803ab2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ab9:	00 00 00 
  803abc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803abf:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803ac2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ac9:	00 00 00 
  803acc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803acf:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803ad2:	bf 07 00 00 00       	mov    $0x7,%edi
  803ad7:	48 b8 17 38 80 00 00 	movabs $0x803817,%rax
  803ade:	00 00 00 
  803ae1:	ff d0                	callq  *%rax
  803ae3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ae6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aea:	78 69                	js     803b55 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803aec:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803af3:	7f 08                	jg     803afd <nsipc_recv+0x6f>
  803af5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803af8:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803afb:	7e 35                	jle    803b32 <nsipc_recv+0xa4>
  803afd:	48 b9 84 4f 80 00 00 	movabs $0x804f84,%rcx
  803b04:	00 00 00 
  803b07:	48 ba 99 4f 80 00 00 	movabs $0x804f99,%rdx
  803b0e:	00 00 00 
  803b11:	be 61 00 00 00       	mov    $0x61,%esi
  803b16:	48 bf ae 4f 80 00 00 	movabs $0x804fae,%rdi
  803b1d:	00 00 00 
  803b20:	b8 00 00 00 00       	mov    $0x0,%eax
  803b25:	49 b8 6a 01 80 00 00 	movabs $0x80016a,%r8
  803b2c:	00 00 00 
  803b2f:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803b32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b35:	48 63 d0             	movslq %eax,%rdx
  803b38:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b3c:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803b43:	00 00 00 
  803b46:	48 89 c7             	mov    %rax,%rdi
  803b49:	48 b8 61 12 80 00 00 	movabs $0x801261,%rax
  803b50:	00 00 00 
  803b53:	ff d0                	callq  *%rax
	}

	return r;
  803b55:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b58:	c9                   	leaveq 
  803b59:	c3                   	retq   

0000000000803b5a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803b5a:	55                   	push   %rbp
  803b5b:	48 89 e5             	mov    %rsp,%rbp
  803b5e:	48 83 ec 20          	sub    $0x20,%rsp
  803b62:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b65:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803b69:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803b6c:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803b6f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b76:	00 00 00 
  803b79:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b7c:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803b7e:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803b85:	7e 35                	jle    803bbc <nsipc_send+0x62>
  803b87:	48 b9 ba 4f 80 00 00 	movabs $0x804fba,%rcx
  803b8e:	00 00 00 
  803b91:	48 ba 99 4f 80 00 00 	movabs $0x804f99,%rdx
  803b98:	00 00 00 
  803b9b:	be 6c 00 00 00       	mov    $0x6c,%esi
  803ba0:	48 bf ae 4f 80 00 00 	movabs $0x804fae,%rdi
  803ba7:	00 00 00 
  803baa:	b8 00 00 00 00       	mov    $0x0,%eax
  803baf:	49 b8 6a 01 80 00 00 	movabs $0x80016a,%r8
  803bb6:	00 00 00 
  803bb9:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803bbc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803bbf:	48 63 d0             	movslq %eax,%rdx
  803bc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bc6:	48 89 c6             	mov    %rax,%rsi
  803bc9:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803bd0:	00 00 00 
  803bd3:	48 b8 61 12 80 00 00 	movabs $0x801261,%rax
  803bda:	00 00 00 
  803bdd:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803bdf:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803be6:	00 00 00 
  803be9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bec:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803bef:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bf6:	00 00 00 
  803bf9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803bfc:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803bff:	bf 08 00 00 00       	mov    $0x8,%edi
  803c04:	48 b8 17 38 80 00 00 	movabs $0x803817,%rax
  803c0b:	00 00 00 
  803c0e:	ff d0                	callq  *%rax
}
  803c10:	c9                   	leaveq 
  803c11:	c3                   	retq   

0000000000803c12 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803c12:	55                   	push   %rbp
  803c13:	48 89 e5             	mov    %rsp,%rbp
  803c16:	48 83 ec 10          	sub    $0x10,%rsp
  803c1a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c1d:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803c20:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803c23:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c2a:	00 00 00 
  803c2d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c30:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803c32:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c39:	00 00 00 
  803c3c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c3f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803c42:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c49:	00 00 00 
  803c4c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803c4f:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803c52:	bf 09 00 00 00       	mov    $0x9,%edi
  803c57:	48 b8 17 38 80 00 00 	movabs $0x803817,%rax
  803c5e:	00 00 00 
  803c61:	ff d0                	callq  *%rax
}
  803c63:	c9                   	leaveq 
  803c64:	c3                   	retq   

0000000000803c65 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803c65:	55                   	push   %rbp
  803c66:	48 89 e5             	mov    %rsp,%rbp
  803c69:	53                   	push   %rbx
  803c6a:	48 83 ec 38          	sub    $0x38,%rsp
  803c6e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803c72:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803c76:	48 89 c7             	mov    %rax,%rdi
  803c79:	48 b8 20 1c 80 00 00 	movabs $0x801c20,%rax
  803c80:	00 00 00 
  803c83:	ff d0                	callq  *%rax
  803c85:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c88:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c8c:	0f 88 bf 01 00 00    	js     803e51 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c92:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c96:	ba 07 04 00 00       	mov    $0x407,%edx
  803c9b:	48 89 c6             	mov    %rax,%rsi
  803c9e:	bf 00 00 00 00       	mov    $0x0,%edi
  803ca3:	48 b8 6a 18 80 00 00 	movabs $0x80186a,%rax
  803caa:	00 00 00 
  803cad:	ff d0                	callq  *%rax
  803caf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cb2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cb6:	0f 88 95 01 00 00    	js     803e51 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803cbc:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803cc0:	48 89 c7             	mov    %rax,%rdi
  803cc3:	48 b8 20 1c 80 00 00 	movabs $0x801c20,%rax
  803cca:	00 00 00 
  803ccd:	ff d0                	callq  *%rax
  803ccf:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cd2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cd6:	0f 88 5d 01 00 00    	js     803e39 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803cdc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ce0:	ba 07 04 00 00       	mov    $0x407,%edx
  803ce5:	48 89 c6             	mov    %rax,%rsi
  803ce8:	bf 00 00 00 00       	mov    $0x0,%edi
  803ced:	48 b8 6a 18 80 00 00 	movabs $0x80186a,%rax
  803cf4:	00 00 00 
  803cf7:	ff d0                	callq  *%rax
  803cf9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803cfc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d00:	0f 88 33 01 00 00    	js     803e39 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803d06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d0a:	48 89 c7             	mov    %rax,%rdi
  803d0d:	48 b8 f5 1b 80 00 00 	movabs $0x801bf5,%rax
  803d14:	00 00 00 
  803d17:	ff d0                	callq  *%rax
  803d19:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d1d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d21:	ba 07 04 00 00       	mov    $0x407,%edx
  803d26:	48 89 c6             	mov    %rax,%rsi
  803d29:	bf 00 00 00 00       	mov    $0x0,%edi
  803d2e:	48 b8 6a 18 80 00 00 	movabs $0x80186a,%rax
  803d35:	00 00 00 
  803d38:	ff d0                	callq  *%rax
  803d3a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d3d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d41:	79 05                	jns    803d48 <pipe+0xe3>
		goto err2;
  803d43:	e9 d9 00 00 00       	jmpq   803e21 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d48:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d4c:	48 89 c7             	mov    %rax,%rdi
  803d4f:	48 b8 f5 1b 80 00 00 	movabs $0x801bf5,%rax
  803d56:	00 00 00 
  803d59:	ff d0                	callq  *%rax
  803d5b:	48 89 c2             	mov    %rax,%rdx
  803d5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d62:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803d68:	48 89 d1             	mov    %rdx,%rcx
  803d6b:	ba 00 00 00 00       	mov    $0x0,%edx
  803d70:	48 89 c6             	mov    %rax,%rsi
  803d73:	bf 00 00 00 00       	mov    $0x0,%edi
  803d78:	48 b8 bc 18 80 00 00 	movabs $0x8018bc,%rax
  803d7f:	00 00 00 
  803d82:	ff d0                	callq  *%rax
  803d84:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d87:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d8b:	79 1b                	jns    803da8 <pipe+0x143>
		goto err3;
  803d8d:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803d8e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d92:	48 89 c6             	mov    %rax,%rsi
  803d95:	bf 00 00 00 00       	mov    $0x0,%edi
  803d9a:	48 b8 1c 19 80 00 00 	movabs $0x80191c,%rax
  803da1:	00 00 00 
  803da4:	ff d0                	callq  *%rax
  803da6:	eb 79                	jmp    803e21 <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  803da8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dac:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803db3:	00 00 00 
  803db6:	8b 12                	mov    (%rdx),%edx
  803db8:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803dba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dbe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  803dc5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803dc9:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803dd0:	00 00 00 
  803dd3:	8b 12                	mov    (%rdx),%edx
  803dd5:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803dd7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ddb:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  803de2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803de6:	48 89 c7             	mov    %rax,%rdi
  803de9:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  803df0:	00 00 00 
  803df3:	ff d0                	callq  *%rax
  803df5:	89 c2                	mov    %eax,%edx
  803df7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803dfb:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803dfd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803e01:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803e05:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e09:	48 89 c7             	mov    %rax,%rdi
  803e0c:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  803e13:	00 00 00 
  803e16:	ff d0                	callq  *%rax
  803e18:	89 03                	mov    %eax,(%rbx)
	return 0;
  803e1a:	b8 00 00 00 00       	mov    $0x0,%eax
  803e1f:	eb 33                	jmp    803e54 <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  803e21:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e25:	48 89 c6             	mov    %rax,%rsi
  803e28:	bf 00 00 00 00       	mov    $0x0,%edi
  803e2d:	48 b8 1c 19 80 00 00 	movabs $0x80191c,%rax
  803e34:	00 00 00 
  803e37:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803e39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e3d:	48 89 c6             	mov    %rax,%rsi
  803e40:	bf 00 00 00 00       	mov    $0x0,%edi
  803e45:	48 b8 1c 19 80 00 00 	movabs $0x80191c,%rax
  803e4c:	00 00 00 
  803e4f:	ff d0                	callq  *%rax
err:
	return r;
  803e51:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803e54:	48 83 c4 38          	add    $0x38,%rsp
  803e58:	5b                   	pop    %rbx
  803e59:	5d                   	pop    %rbp
  803e5a:	c3                   	retq   

0000000000803e5b <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803e5b:	55                   	push   %rbp
  803e5c:	48 89 e5             	mov    %rsp,%rbp
  803e5f:	53                   	push   %rbx
  803e60:	48 83 ec 28          	sub    $0x28,%rsp
  803e64:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e68:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803e6c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803e73:	00 00 00 
  803e76:	48 8b 00             	mov    (%rax),%rax
  803e79:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803e7f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803e82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e86:	48 89 c7             	mov    %rax,%rdi
  803e89:	48 b8 1c 47 80 00 00 	movabs $0x80471c,%rax
  803e90:	00 00 00 
  803e93:	ff d0                	callq  *%rax
  803e95:	89 c3                	mov    %eax,%ebx
  803e97:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e9b:	48 89 c7             	mov    %rax,%rdi
  803e9e:	48 b8 1c 47 80 00 00 	movabs $0x80471c,%rax
  803ea5:	00 00 00 
  803ea8:	ff d0                	callq  *%rax
  803eaa:	39 c3                	cmp    %eax,%ebx
  803eac:	0f 94 c0             	sete   %al
  803eaf:	0f b6 c0             	movzbl %al,%eax
  803eb2:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803eb5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803ebc:	00 00 00 
  803ebf:	48 8b 00             	mov    (%rax),%rax
  803ec2:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803ec8:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803ecb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ece:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803ed1:	75 05                	jne    803ed8 <_pipeisclosed+0x7d>
			return ret;
  803ed3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803ed6:	eb 4a                	jmp    803f22 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803ed8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803edb:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803ede:	74 3d                	je     803f1d <_pipeisclosed+0xc2>
  803ee0:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803ee4:	75 37                	jne    803f1d <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803ee6:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803eed:	00 00 00 
  803ef0:	48 8b 00             	mov    (%rax),%rax
  803ef3:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803ef9:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803efc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803eff:	89 c6                	mov    %eax,%esi
  803f01:	48 bf cb 4f 80 00 00 	movabs $0x804fcb,%rdi
  803f08:	00 00 00 
  803f0b:	b8 00 00 00 00       	mov    $0x0,%eax
  803f10:	49 b8 a3 03 80 00 00 	movabs $0x8003a3,%r8
  803f17:	00 00 00 
  803f1a:	41 ff d0             	callq  *%r8
	}
  803f1d:	e9 4a ff ff ff       	jmpq   803e6c <_pipeisclosed+0x11>
}
  803f22:	48 83 c4 28          	add    $0x28,%rsp
  803f26:	5b                   	pop    %rbx
  803f27:	5d                   	pop    %rbp
  803f28:	c3                   	retq   

0000000000803f29 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803f29:	55                   	push   %rbp
  803f2a:	48 89 e5             	mov    %rsp,%rbp
  803f2d:	48 83 ec 30          	sub    $0x30,%rsp
  803f31:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803f34:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803f38:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803f3b:	48 89 d6             	mov    %rdx,%rsi
  803f3e:	89 c7                	mov    %eax,%edi
  803f40:	48 b8 b8 1c 80 00 00 	movabs $0x801cb8,%rax
  803f47:	00 00 00 
  803f4a:	ff d0                	callq  *%rax
  803f4c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f4f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f53:	79 05                	jns    803f5a <pipeisclosed+0x31>
		return r;
  803f55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f58:	eb 31                	jmp    803f8b <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803f5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f5e:	48 89 c7             	mov    %rax,%rdi
  803f61:	48 b8 f5 1b 80 00 00 	movabs $0x801bf5,%rax
  803f68:	00 00 00 
  803f6b:	ff d0                	callq  *%rax
  803f6d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803f71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f75:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f79:	48 89 d6             	mov    %rdx,%rsi
  803f7c:	48 89 c7             	mov    %rax,%rdi
  803f7f:	48 b8 5b 3e 80 00 00 	movabs $0x803e5b,%rax
  803f86:	00 00 00 
  803f89:	ff d0                	callq  *%rax
}
  803f8b:	c9                   	leaveq 
  803f8c:	c3                   	retq   

0000000000803f8d <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803f8d:	55                   	push   %rbp
  803f8e:	48 89 e5             	mov    %rsp,%rbp
  803f91:	48 83 ec 40          	sub    $0x40,%rsp
  803f95:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f99:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f9d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803fa1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fa5:	48 89 c7             	mov    %rax,%rdi
  803fa8:	48 b8 f5 1b 80 00 00 	movabs $0x801bf5,%rax
  803faf:	00 00 00 
  803fb2:	ff d0                	callq  *%rax
  803fb4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803fb8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fbc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803fc0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803fc7:	00 
  803fc8:	e9 92 00 00 00       	jmpq   80405f <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803fcd:	eb 41                	jmp    804010 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803fcf:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803fd4:	74 09                	je     803fdf <devpipe_read+0x52>
				return i;
  803fd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fda:	e9 92 00 00 00       	jmpq   804071 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803fdf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803fe3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fe7:	48 89 d6             	mov    %rdx,%rsi
  803fea:	48 89 c7             	mov    %rax,%rdi
  803fed:	48 b8 5b 3e 80 00 00 	movabs $0x803e5b,%rax
  803ff4:	00 00 00 
  803ff7:	ff d0                	callq  *%rax
  803ff9:	85 c0                	test   %eax,%eax
  803ffb:	74 07                	je     804004 <devpipe_read+0x77>
				return 0;
  803ffd:	b8 00 00 00 00       	mov    $0x0,%eax
  804002:	eb 6d                	jmp    804071 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804004:	48 b8 2e 18 80 00 00 	movabs $0x80182e,%rax
  80400b:	00 00 00 
  80400e:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  804010:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804014:	8b 10                	mov    (%rax),%edx
  804016:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80401a:	8b 40 04             	mov    0x4(%rax),%eax
  80401d:	39 c2                	cmp    %eax,%edx
  80401f:	74 ae                	je     803fcf <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804021:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804025:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804029:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80402d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804031:	8b 00                	mov    (%rax),%eax
  804033:	99                   	cltd   
  804034:	c1 ea 1b             	shr    $0x1b,%edx
  804037:	01 d0                	add    %edx,%eax
  804039:	83 e0 1f             	and    $0x1f,%eax
  80403c:	29 d0                	sub    %edx,%eax
  80403e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804042:	48 98                	cltq   
  804044:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804049:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80404b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80404f:	8b 00                	mov    (%rax),%eax
  804051:	8d 50 01             	lea    0x1(%rax),%edx
  804054:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804058:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  80405a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80405f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804063:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804067:	0f 82 60 ff ff ff    	jb     803fcd <devpipe_read+0x40>
	}
	return i;
  80406d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804071:	c9                   	leaveq 
  804072:	c3                   	retq   

0000000000804073 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804073:	55                   	push   %rbp
  804074:	48 89 e5             	mov    %rsp,%rbp
  804077:	48 83 ec 40          	sub    $0x40,%rsp
  80407b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80407f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804083:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804087:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80408b:	48 89 c7             	mov    %rax,%rdi
  80408e:	48 b8 f5 1b 80 00 00 	movabs $0x801bf5,%rax
  804095:	00 00 00 
  804098:	ff d0                	callq  *%rax
  80409a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80409e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040a2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8040a6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8040ad:	00 
  8040ae:	e9 91 00 00 00       	jmpq   804144 <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8040b3:	eb 31                	jmp    8040e6 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8040b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040bd:	48 89 d6             	mov    %rdx,%rsi
  8040c0:	48 89 c7             	mov    %rax,%rdi
  8040c3:	48 b8 5b 3e 80 00 00 	movabs $0x803e5b,%rax
  8040ca:	00 00 00 
  8040cd:	ff d0                	callq  *%rax
  8040cf:	85 c0                	test   %eax,%eax
  8040d1:	74 07                	je     8040da <devpipe_write+0x67>
				return 0;
  8040d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8040d8:	eb 7c                	jmp    804156 <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8040da:	48 b8 2e 18 80 00 00 	movabs $0x80182e,%rax
  8040e1:	00 00 00 
  8040e4:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8040e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040ea:	8b 40 04             	mov    0x4(%rax),%eax
  8040ed:	48 63 d0             	movslq %eax,%rdx
  8040f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040f4:	8b 00                	mov    (%rax),%eax
  8040f6:	48 98                	cltq   
  8040f8:	48 83 c0 20          	add    $0x20,%rax
  8040fc:	48 39 c2             	cmp    %rax,%rdx
  8040ff:	73 b4                	jae    8040b5 <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804101:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804105:	8b 40 04             	mov    0x4(%rax),%eax
  804108:	99                   	cltd   
  804109:	c1 ea 1b             	shr    $0x1b,%edx
  80410c:	01 d0                	add    %edx,%eax
  80410e:	83 e0 1f             	and    $0x1f,%eax
  804111:	29 d0                	sub    %edx,%eax
  804113:	89 c6                	mov    %eax,%esi
  804115:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804119:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80411d:	48 01 d0             	add    %rdx,%rax
  804120:	0f b6 08             	movzbl (%rax),%ecx
  804123:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804127:	48 63 c6             	movslq %esi,%rax
  80412a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80412e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804132:	8b 40 04             	mov    0x4(%rax),%eax
  804135:	8d 50 01             	lea    0x1(%rax),%edx
  804138:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80413c:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  80413f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804144:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804148:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80414c:	0f 82 61 ff ff ff    	jb     8040b3 <devpipe_write+0x40>
	}

	return i;
  804152:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804156:	c9                   	leaveq 
  804157:	c3                   	retq   

0000000000804158 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804158:	55                   	push   %rbp
  804159:	48 89 e5             	mov    %rsp,%rbp
  80415c:	48 83 ec 20          	sub    $0x20,%rsp
  804160:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804164:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804168:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80416c:	48 89 c7             	mov    %rax,%rdi
  80416f:	48 b8 f5 1b 80 00 00 	movabs $0x801bf5,%rax
  804176:	00 00 00 
  804179:	ff d0                	callq  *%rax
  80417b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80417f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804183:	48 be de 4f 80 00 00 	movabs $0x804fde,%rsi
  80418a:	00 00 00 
  80418d:	48 89 c7             	mov    %rax,%rdi
  804190:	48 b8 3d 0f 80 00 00 	movabs $0x800f3d,%rax
  804197:	00 00 00 
  80419a:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80419c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041a0:	8b 50 04             	mov    0x4(%rax),%edx
  8041a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041a7:	8b 00                	mov    (%rax),%eax
  8041a9:	29 c2                	sub    %eax,%edx
  8041ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041af:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8041b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041b9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8041c0:	00 00 00 
	stat->st_dev = &devpipe;
  8041c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041c7:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  8041ce:	00 00 00 
  8041d1:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8041d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041dd:	c9                   	leaveq 
  8041de:	c3                   	retq   

00000000008041df <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8041df:	55                   	push   %rbp
  8041e0:	48 89 e5             	mov    %rsp,%rbp
  8041e3:	48 83 ec 10          	sub    $0x10,%rsp
  8041e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8041eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041ef:	48 89 c6             	mov    %rax,%rsi
  8041f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8041f7:	48 b8 1c 19 80 00 00 	movabs $0x80191c,%rax
  8041fe:	00 00 00 
  804201:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804203:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804207:	48 89 c7             	mov    %rax,%rdi
  80420a:	48 b8 f5 1b 80 00 00 	movabs $0x801bf5,%rax
  804211:	00 00 00 
  804214:	ff d0                	callq  *%rax
  804216:	48 89 c6             	mov    %rax,%rsi
  804219:	bf 00 00 00 00       	mov    $0x0,%edi
  80421e:	48 b8 1c 19 80 00 00 	movabs $0x80191c,%rax
  804225:	00 00 00 
  804228:	ff d0                	callq  *%rax
}
  80422a:	c9                   	leaveq 
  80422b:	c3                   	retq   

000000000080422c <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80422c:	55                   	push   %rbp
  80422d:	48 89 e5             	mov    %rsp,%rbp
  804230:	48 83 ec 20          	sub    $0x20,%rsp
  804234:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804237:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80423a:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80423d:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804241:	be 01 00 00 00       	mov    $0x1,%esi
  804246:	48 89 c7             	mov    %rax,%rdi
  804249:	48 b8 24 17 80 00 00 	movabs $0x801724,%rax
  804250:	00 00 00 
  804253:	ff d0                	callq  *%rax
}
  804255:	c9                   	leaveq 
  804256:	c3                   	retq   

0000000000804257 <getchar>:

int
getchar(void)
{
  804257:	55                   	push   %rbp
  804258:	48 89 e5             	mov    %rsp,%rbp
  80425b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80425f:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804263:	ba 01 00 00 00       	mov    $0x1,%edx
  804268:	48 89 c6             	mov    %rax,%rsi
  80426b:	bf 00 00 00 00       	mov    $0x0,%edi
  804270:	48 b8 ec 20 80 00 00 	movabs $0x8020ec,%rax
  804277:	00 00 00 
  80427a:	ff d0                	callq  *%rax
  80427c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80427f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804283:	79 05                	jns    80428a <getchar+0x33>
		return r;
  804285:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804288:	eb 14                	jmp    80429e <getchar+0x47>
	if (r < 1)
  80428a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80428e:	7f 07                	jg     804297 <getchar+0x40>
		return -E_EOF;
  804290:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804295:	eb 07                	jmp    80429e <getchar+0x47>
	return c;
  804297:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80429b:	0f b6 c0             	movzbl %al,%eax
}
  80429e:	c9                   	leaveq 
  80429f:	c3                   	retq   

00000000008042a0 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8042a0:	55                   	push   %rbp
  8042a1:	48 89 e5             	mov    %rsp,%rbp
  8042a4:	48 83 ec 20          	sub    $0x20,%rsp
  8042a8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8042ab:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8042af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042b2:	48 89 d6             	mov    %rdx,%rsi
  8042b5:	89 c7                	mov    %eax,%edi
  8042b7:	48 b8 b8 1c 80 00 00 	movabs $0x801cb8,%rax
  8042be:	00 00 00 
  8042c1:	ff d0                	callq  *%rax
  8042c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042ca:	79 05                	jns    8042d1 <iscons+0x31>
		return r;
  8042cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042cf:	eb 1a                	jmp    8042eb <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8042d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042d5:	8b 10                	mov    (%rax),%edx
  8042d7:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  8042de:	00 00 00 
  8042e1:	8b 00                	mov    (%rax),%eax
  8042e3:	39 c2                	cmp    %eax,%edx
  8042e5:	0f 94 c0             	sete   %al
  8042e8:	0f b6 c0             	movzbl %al,%eax
}
  8042eb:	c9                   	leaveq 
  8042ec:	c3                   	retq   

00000000008042ed <opencons>:

int
opencons(void)
{
  8042ed:	55                   	push   %rbp
  8042ee:	48 89 e5             	mov    %rsp,%rbp
  8042f1:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8042f5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8042f9:	48 89 c7             	mov    %rax,%rdi
  8042fc:	48 b8 20 1c 80 00 00 	movabs $0x801c20,%rax
  804303:	00 00 00 
  804306:	ff d0                	callq  *%rax
  804308:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80430b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80430f:	79 05                	jns    804316 <opencons+0x29>
		return r;
  804311:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804314:	eb 5b                	jmp    804371 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804316:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80431a:	ba 07 04 00 00       	mov    $0x407,%edx
  80431f:	48 89 c6             	mov    %rax,%rsi
  804322:	bf 00 00 00 00       	mov    $0x0,%edi
  804327:	48 b8 6a 18 80 00 00 	movabs $0x80186a,%rax
  80432e:	00 00 00 
  804331:	ff d0                	callq  *%rax
  804333:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804336:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80433a:	79 05                	jns    804341 <opencons+0x54>
		return r;
  80433c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80433f:	eb 30                	jmp    804371 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804341:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804345:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  80434c:	00 00 00 
  80434f:	8b 12                	mov    (%rdx),%edx
  804351:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804353:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804357:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80435e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804362:	48 89 c7             	mov    %rax,%rdi
  804365:	48 b8 d2 1b 80 00 00 	movabs $0x801bd2,%rax
  80436c:	00 00 00 
  80436f:	ff d0                	callq  *%rax
}
  804371:	c9                   	leaveq 
  804372:	c3                   	retq   

0000000000804373 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804373:	55                   	push   %rbp
  804374:	48 89 e5             	mov    %rsp,%rbp
  804377:	48 83 ec 30          	sub    $0x30,%rsp
  80437b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80437f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804383:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804387:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80438c:	75 07                	jne    804395 <devcons_read+0x22>
		return 0;
  80438e:	b8 00 00 00 00       	mov    $0x0,%eax
  804393:	eb 4b                	jmp    8043e0 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804395:	eb 0c                	jmp    8043a3 <devcons_read+0x30>
		sys_yield();
  804397:	48 b8 2e 18 80 00 00 	movabs $0x80182e,%rax
  80439e:	00 00 00 
  8043a1:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  8043a3:	48 b8 70 17 80 00 00 	movabs $0x801770,%rax
  8043aa:	00 00 00 
  8043ad:	ff d0                	callq  *%rax
  8043af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043b6:	74 df                	je     804397 <devcons_read+0x24>
	if (c < 0)
  8043b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043bc:	79 05                	jns    8043c3 <devcons_read+0x50>
		return c;
  8043be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043c1:	eb 1d                	jmp    8043e0 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8043c3:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8043c7:	75 07                	jne    8043d0 <devcons_read+0x5d>
		return 0;
  8043c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8043ce:	eb 10                	jmp    8043e0 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8043d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043d3:	89 c2                	mov    %eax,%edx
  8043d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043d9:	88 10                	mov    %dl,(%rax)
	return 1;
  8043db:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8043e0:	c9                   	leaveq 
  8043e1:	c3                   	retq   

00000000008043e2 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8043e2:	55                   	push   %rbp
  8043e3:	48 89 e5             	mov    %rsp,%rbp
  8043e6:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8043ed:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8043f4:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8043fb:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804402:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804409:	eb 76                	jmp    804481 <devcons_write+0x9f>
		m = n - tot;
  80440b:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804412:	89 c2                	mov    %eax,%edx
  804414:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804417:	29 c2                	sub    %eax,%edx
  804419:	89 d0                	mov    %edx,%eax
  80441b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80441e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804421:	83 f8 7f             	cmp    $0x7f,%eax
  804424:	76 07                	jbe    80442d <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804426:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80442d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804430:	48 63 d0             	movslq %eax,%rdx
  804433:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804436:	48 63 c8             	movslq %eax,%rcx
  804439:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804440:	48 01 c1             	add    %rax,%rcx
  804443:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80444a:	48 89 ce             	mov    %rcx,%rsi
  80444d:	48 89 c7             	mov    %rax,%rdi
  804450:	48 b8 61 12 80 00 00 	movabs $0x801261,%rax
  804457:	00 00 00 
  80445a:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80445c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80445f:	48 63 d0             	movslq %eax,%rdx
  804462:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804469:	48 89 d6             	mov    %rdx,%rsi
  80446c:	48 89 c7             	mov    %rax,%rdi
  80446f:	48 b8 24 17 80 00 00 	movabs $0x801724,%rax
  804476:	00 00 00 
  804479:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  80447b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80447e:	01 45 fc             	add    %eax,-0x4(%rbp)
  804481:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804484:	48 98                	cltq   
  804486:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80448d:	0f 82 78 ff ff ff    	jb     80440b <devcons_write+0x29>
	}
	return tot;
  804493:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804496:	c9                   	leaveq 
  804497:	c3                   	retq   

0000000000804498 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804498:	55                   	push   %rbp
  804499:	48 89 e5             	mov    %rsp,%rbp
  80449c:	48 83 ec 08          	sub    $0x8,%rsp
  8044a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8044a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8044a9:	c9                   	leaveq 
  8044aa:	c3                   	retq   

00000000008044ab <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8044ab:	55                   	push   %rbp
  8044ac:	48 89 e5             	mov    %rsp,%rbp
  8044af:	48 83 ec 10          	sub    $0x10,%rsp
  8044b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8044b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8044bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044bf:	48 be ea 4f 80 00 00 	movabs $0x804fea,%rsi
  8044c6:	00 00 00 
  8044c9:	48 89 c7             	mov    %rax,%rdi
  8044cc:	48 b8 3d 0f 80 00 00 	movabs $0x800f3d,%rax
  8044d3:	00 00 00 
  8044d6:	ff d0                	callq  *%rax
	return 0;
  8044d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8044dd:	c9                   	leaveq 
  8044de:	c3                   	retq   

00000000008044df <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8044df:	55                   	push   %rbp
  8044e0:	48 89 e5             	mov    %rsp,%rbp
  8044e3:	48 83 ec 20          	sub    $0x20,%rsp
  8044e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8044eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8044ef:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  8044f3:	48 ba f8 4f 80 00 00 	movabs $0x804ff8,%rdx
  8044fa:	00 00 00 
  8044fd:	be 1d 00 00 00       	mov    $0x1d,%esi
  804502:	48 bf 11 50 80 00 00 	movabs $0x805011,%rdi
  804509:	00 00 00 
  80450c:	b8 00 00 00 00       	mov    $0x0,%eax
  804511:	48 b9 6a 01 80 00 00 	movabs $0x80016a,%rcx
  804518:	00 00 00 
  80451b:	ff d1                	callq  *%rcx

000000000080451d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80451d:	55                   	push   %rbp
  80451e:	48 89 e5             	mov    %rsp,%rbp
  804521:	48 83 ec 20          	sub    $0x20,%rsp
  804525:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804528:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80452b:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  80452f:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  804532:	48 ba 1b 50 80 00 00 	movabs $0x80501b,%rdx
  804539:	00 00 00 
  80453c:	be 2d 00 00 00       	mov    $0x2d,%esi
  804541:	48 bf 11 50 80 00 00 	movabs $0x805011,%rdi
  804548:	00 00 00 
  80454b:	b8 00 00 00 00       	mov    $0x0,%eax
  804550:	48 b9 6a 01 80 00 00 	movabs $0x80016a,%rcx
  804557:	00 00 00 
  80455a:	ff d1                	callq  *%rcx

000000000080455c <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  80455c:	55                   	push   %rbp
  80455d:	48 89 e5             	mov    %rsp,%rbp
  804560:	53                   	push   %rbx
  804561:	48 83 ec 48          	sub    $0x48,%rsp
  804565:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  804569:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  804570:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  804577:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  80457c:	75 0e                	jne    80458c <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  80457e:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  804585:	00 00 00 
  804588:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  80458c:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  804590:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  804594:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  80459b:	00 
	a3 = (uint64_t) 0;
  80459c:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  8045a3:	00 
	a4 = (uint64_t) 0;
  8045a4:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  8045ab:	00 
	a5 = 0;
  8045ac:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  8045b3:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  8045b4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8045b7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8045bb:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8045bf:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  8045c3:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8045c7:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  8045cb:	4c 89 c3             	mov    %r8,%rbx
  8045ce:	0f 01 c1             	vmcall 
  8045d1:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  8045d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8045d8:	7e 36                	jle    804610 <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  8045da:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8045dd:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8045e0:	41 89 d0             	mov    %edx,%r8d
  8045e3:	89 c1                	mov    %eax,%ecx
  8045e5:	48 ba 38 50 80 00 00 	movabs $0x805038,%rdx
  8045ec:	00 00 00 
  8045ef:	be 54 00 00 00       	mov    $0x54,%esi
  8045f4:	48 bf 11 50 80 00 00 	movabs $0x805011,%rdi
  8045fb:	00 00 00 
  8045fe:	b8 00 00 00 00       	mov    $0x0,%eax
  804603:	49 b9 6a 01 80 00 00 	movabs $0x80016a,%r9
  80460a:	00 00 00 
  80460d:	41 ff d1             	callq  *%r9
	return ret;
  804610:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804613:	48 83 c4 48          	add    $0x48,%rsp
  804617:	5b                   	pop    %rbx
  804618:	5d                   	pop    %rbp
  804619:	c3                   	retq   

000000000080461a <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80461a:	55                   	push   %rbp
  80461b:	48 89 e5             	mov    %rsp,%rbp
  80461e:	53                   	push   %rbx
  80461f:	48 83 ec 58          	sub    $0x58,%rsp
  804623:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  804626:	89 75 b0             	mov    %esi,-0x50(%rbp)
  804629:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  80462d:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  804630:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  804637:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  80463e:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  804643:	75 0e                	jne    804653 <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  804645:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  80464c:	00 00 00 
  80464f:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  804653:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  804656:	48 98                	cltq   
  804658:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  80465c:	8b 45 b0             	mov    -0x50(%rbp),%eax
  80465f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  804663:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804667:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  80466b:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  80466e:	48 98                	cltq   
  804670:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  804674:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  80467b:	00 

	int r = -E_IPC_NOT_RECV;
  80467c:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  804683:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804686:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80468a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80468e:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  804692:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  804696:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  80469a:	4c 89 c3             	mov    %r8,%rbx
  80469d:	0f 01 c1             	vmcall 
  8046a0:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  8046a3:	48 83 c4 58          	add    $0x58,%rsp
  8046a7:	5b                   	pop    %rbx
  8046a8:	5d                   	pop    %rbp
  8046a9:	c3                   	retq   

00000000008046aa <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8046aa:	55                   	push   %rbp
  8046ab:	48 89 e5             	mov    %rsp,%rbp
  8046ae:	48 83 ec 18          	sub    $0x18,%rsp
  8046b2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8046b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8046bc:	eb 4e                	jmp    80470c <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8046be:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8046c5:	00 00 00 
  8046c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046cb:	48 98                	cltq   
  8046cd:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8046d4:	48 01 d0             	add    %rdx,%rax
  8046d7:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8046dd:	8b 00                	mov    (%rax),%eax
  8046df:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8046e2:	75 24                	jne    804708 <ipc_find_env+0x5e>
			return envs[i].env_id;
  8046e4:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8046eb:	00 00 00 
  8046ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046f1:	48 98                	cltq   
  8046f3:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8046fa:	48 01 d0             	add    %rdx,%rax
  8046fd:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804703:	8b 40 08             	mov    0x8(%rax),%eax
  804706:	eb 12                	jmp    80471a <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  804708:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80470c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804713:	7e a9                	jle    8046be <ipc_find_env+0x14>
	}
	return 0;
  804715:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80471a:	c9                   	leaveq 
  80471b:	c3                   	retq   

000000000080471c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80471c:	55                   	push   %rbp
  80471d:	48 89 e5             	mov    %rsp,%rbp
  804720:	48 83 ec 18          	sub    $0x18,%rsp
  804724:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804728:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80472c:	48 c1 e8 15          	shr    $0x15,%rax
  804730:	48 89 c2             	mov    %rax,%rdx
  804733:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80473a:	01 00 00 
  80473d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804741:	83 e0 01             	and    $0x1,%eax
  804744:	48 85 c0             	test   %rax,%rax
  804747:	75 07                	jne    804750 <pageref+0x34>
		return 0;
  804749:	b8 00 00 00 00       	mov    $0x0,%eax
  80474e:	eb 53                	jmp    8047a3 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804750:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804754:	48 c1 e8 0c          	shr    $0xc,%rax
  804758:	48 89 c2             	mov    %rax,%rdx
  80475b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804762:	01 00 00 
  804765:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804769:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80476d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804771:	83 e0 01             	and    $0x1,%eax
  804774:	48 85 c0             	test   %rax,%rax
  804777:	75 07                	jne    804780 <pageref+0x64>
		return 0;
  804779:	b8 00 00 00 00       	mov    $0x0,%eax
  80477e:	eb 23                	jmp    8047a3 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804780:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804784:	48 c1 e8 0c          	shr    $0xc,%rax
  804788:	48 89 c2             	mov    %rax,%rdx
  80478b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804792:	00 00 00 
  804795:	48 c1 e2 04          	shl    $0x4,%rdx
  804799:	48 01 d0             	add    %rdx,%rax
  80479c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8047a0:	0f b7 c0             	movzwl %ax,%eax
}
  8047a3:	c9                   	leaveq 
  8047a4:	c3                   	retq   
