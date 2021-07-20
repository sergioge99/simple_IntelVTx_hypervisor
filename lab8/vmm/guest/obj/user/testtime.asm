
vmm/guest/obj/user/testtime:     formato del fichero elf64-x86-64


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
  80003c:	e8 6c 01 00 00       	callq  8001ad <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <sleep>:
#include <inc/lib.h>
#include <inc/x86.h>

void
sleep(int sec)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	unsigned now = sys_time_msec();
  80004e:	48 b8 b0 1b 80 00 00 	movabs $0x801bb0,%rax
  800055:	00 00 00 
  800058:	ff d0                	callq  *%rax
  80005a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	unsigned end = now + sec * 1000;
  80005d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800060:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
  800066:	89 c2                	mov    %eax,%edx
  800068:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80006b:	01 d0                	add    %edx,%eax
  80006d:	89 45 f8             	mov    %eax,-0x8(%rbp)

	if ((int)now < 0 && (int)now > -MAXERROR)
  800070:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800073:	85 c0                	test   %eax,%eax
  800075:	79 38                	jns    8000af <sleep+0x6c>
  800077:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80007a:	83 f8 eb             	cmp    $0xffffffeb,%eax
  80007d:	7c 30                	jl     8000af <sleep+0x6c>
		panic("sys_time_msec: %e", (int)now);
  80007f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800082:	89 c1                	mov    %eax,%ecx
  800084:	48 ba 40 3e 80 00 00 	movabs $0x803e40,%rdx
  80008b:	00 00 00 
  80008e:	be 0b 00 00 00       	mov    $0xb,%esi
  800093:	48 bf 52 3e 80 00 00 	movabs $0x803e52,%rdi
  80009a:	00 00 00 
  80009d:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a2:	49 b8 30 02 80 00 00 	movabs $0x800230,%r8
  8000a9:	00 00 00 
  8000ac:	41 ff d0             	callq  *%r8
	if (end < now)
  8000af:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000b2:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8000b5:	73 2a                	jae    8000e1 <sleep+0x9e>
		panic("sleep: wrap");
  8000b7:	48 ba 62 3e 80 00 00 	movabs $0x803e62,%rdx
  8000be:	00 00 00 
  8000c1:	be 0d 00 00 00       	mov    $0xd,%esi
  8000c6:	48 bf 52 3e 80 00 00 	movabs $0x803e52,%rdi
  8000cd:	00 00 00 
  8000d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d5:	48 b9 30 02 80 00 00 	movabs $0x800230,%rcx
  8000dc:	00 00 00 
  8000df:	ff d1                	callq  *%rcx

	while (sys_time_msec() < end)
  8000e1:	eb 0c                	jmp    8000ef <sleep+0xac>
		sys_yield();
  8000e3:	48 b8 f4 18 80 00 00 	movabs $0x8018f4,%rax
  8000ea:	00 00 00 
  8000ed:	ff d0                	callq  *%rax
	while (sys_time_msec() < end)
  8000ef:	48 b8 b0 1b 80 00 00 	movabs $0x801bb0,%rax
  8000f6:	00 00 00 
  8000f9:	ff d0                	callq  *%rax
  8000fb:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8000fe:	72 e3                	jb     8000e3 <sleep+0xa0>
}
  800100:	c9                   	leaveq 
  800101:	c3                   	retq   

0000000000800102 <umain>:

void
umain(int argc, char **argv)
{
  800102:	55                   	push   %rbp
  800103:	48 89 e5             	mov    %rsp,%rbp
  800106:	48 83 ec 20          	sub    $0x20,%rsp
  80010a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80010d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
  800111:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800118:	eb 10                	jmp    80012a <umain+0x28>
		sys_yield();
  80011a:	48 b8 f4 18 80 00 00 	movabs $0x8018f4,%rax
  800121:	00 00 00 
  800124:	ff d0                	callq  *%rax
	for (i = 0; i < 50; i++)
  800126:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80012a:	83 7d fc 31          	cmpl   $0x31,-0x4(%rbp)
  80012e:	7e ea                	jle    80011a <umain+0x18>

	cprintf("starting count down: ");
  800130:	48 bf 6e 3e 80 00 00 	movabs $0x803e6e,%rdi
  800137:	00 00 00 
  80013a:	b8 00 00 00 00       	mov    $0x0,%eax
  80013f:	48 ba 69 04 80 00 00 	movabs $0x800469,%rdx
  800146:	00 00 00 
  800149:	ff d2                	callq  *%rdx
	for (i = 5; i >= 0; i--) {
  80014b:	c7 45 fc 05 00 00 00 	movl   $0x5,-0x4(%rbp)
  800152:	eb 35                	jmp    800189 <umain+0x87>
		cprintf("%d ", i);
  800154:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800157:	89 c6                	mov    %eax,%esi
  800159:	48 bf 84 3e 80 00 00 	movabs $0x803e84,%rdi
  800160:	00 00 00 
  800163:	b8 00 00 00 00       	mov    $0x0,%eax
  800168:	48 ba 69 04 80 00 00 	movabs $0x800469,%rdx
  80016f:	00 00 00 
  800172:	ff d2                	callq  *%rdx
		sleep(1);
  800174:	bf 01 00 00 00       	mov    $0x1,%edi
  800179:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800180:	00 00 00 
  800183:	ff d0                	callq  *%rax
	for (i = 5; i >= 0; i--) {
  800185:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  800189:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80018d:	79 c5                	jns    800154 <umain+0x52>
	}
	cprintf("\n");
  80018f:	48 bf 88 3e 80 00 00 	movabs $0x803e88,%rdi
  800196:	00 00 00 
  800199:	b8 00 00 00 00       	mov    $0x0,%eax
  80019e:	48 ba 69 04 80 00 00 	movabs $0x800469,%rdx
  8001a5:	00 00 00 
  8001a8:	ff d2                	callq  *%rdx
static __inline void read_gdtr (uint64_t *gdtbase, uint16_t *gdtlimit) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  8001aa:	cc                   	int3   
	breakpoint();
}
  8001ab:	c9                   	leaveq 
  8001ac:	c3                   	retq   

00000000008001ad <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ad:	55                   	push   %rbp
  8001ae:	48 89 e5             	mov    %rsp,%rbp
  8001b1:	48 83 ec 10          	sub    $0x10,%rsp
  8001b5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8001bc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8001c3:	00 00 00 
  8001c6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001d1:	7e 14                	jle    8001e7 <libmain+0x3a>
		binaryname = argv[0];
  8001d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001d7:	48 8b 10             	mov    (%rax),%rdx
  8001da:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001e1:	00 00 00 
  8001e4:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001ee:	48 89 d6             	mov    %rdx,%rsi
  8001f1:	89 c7                	mov    %eax,%edi
  8001f3:	48 b8 02 01 80 00 00 	movabs $0x800102,%rax
  8001fa:	00 00 00 
  8001fd:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001ff:	48 b8 0d 02 80 00 00 	movabs $0x80020d,%rax
  800206:	00 00 00 
  800209:	ff d0                	callq  *%rax
}
  80020b:	c9                   	leaveq 
  80020c:	c3                   	retq   

000000000080020d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80020d:	55                   	push   %rbp
  80020e:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800211:	48 b8 db 1f 80 00 00 	movabs $0x801fdb,%rax
  800218:	00 00 00 
  80021b:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80021d:	bf 00 00 00 00       	mov    $0x0,%edi
  800222:	48 b8 72 18 80 00 00 	movabs $0x801872,%rax
  800229:	00 00 00 
  80022c:	ff d0                	callq  *%rax
}
  80022e:	5d                   	pop    %rbp
  80022f:	c3                   	retq   

0000000000800230 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800230:	55                   	push   %rbp
  800231:	48 89 e5             	mov    %rsp,%rbp
  800234:	53                   	push   %rbx
  800235:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80023c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800243:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800249:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800250:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800257:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80025e:	84 c0                	test   %al,%al
  800260:	74 23                	je     800285 <_panic+0x55>
  800262:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800269:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80026d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800271:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800275:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800279:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80027d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800281:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800285:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80028c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800293:	00 00 00 
  800296:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80029d:	00 00 00 
  8002a0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002a4:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002ab:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002b2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002b9:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002c0:	00 00 00 
  8002c3:	48 8b 18             	mov    (%rax),%rbx
  8002c6:	48 b8 b8 18 80 00 00 	movabs $0x8018b8,%rax
  8002cd:	00 00 00 
  8002d0:	ff d0                	callq  *%rax
  8002d2:	89 c6                	mov    %eax,%esi
  8002d4:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8002da:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8002e1:	41 89 d0             	mov    %edx,%r8d
  8002e4:	48 89 c1             	mov    %rax,%rcx
  8002e7:	48 89 da             	mov    %rbx,%rdx
  8002ea:	48 bf 98 3e 80 00 00 	movabs $0x803e98,%rdi
  8002f1:	00 00 00 
  8002f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002f9:	49 b9 69 04 80 00 00 	movabs $0x800469,%r9
  800300:	00 00 00 
  800303:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800306:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80030d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800314:	48 89 d6             	mov    %rdx,%rsi
  800317:	48 89 c7             	mov    %rax,%rdi
  80031a:	48 b8 bd 03 80 00 00 	movabs $0x8003bd,%rax
  800321:	00 00 00 
  800324:	ff d0                	callq  *%rax
	cprintf("\n");
  800326:	48 bf bb 3e 80 00 00 	movabs $0x803ebb,%rdi
  80032d:	00 00 00 
  800330:	b8 00 00 00 00       	mov    $0x0,%eax
  800335:	48 ba 69 04 80 00 00 	movabs $0x800469,%rdx
  80033c:	00 00 00 
  80033f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800341:	cc                   	int3   
  800342:	eb fd                	jmp    800341 <_panic+0x111>

0000000000800344 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800344:	55                   	push   %rbp
  800345:	48 89 e5             	mov    %rsp,%rbp
  800348:	48 83 ec 10          	sub    $0x10,%rsp
  80034c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80034f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800353:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800357:	8b 00                	mov    (%rax),%eax
  800359:	8d 48 01             	lea    0x1(%rax),%ecx
  80035c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800360:	89 0a                	mov    %ecx,(%rdx)
  800362:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800365:	89 d1                	mov    %edx,%ecx
  800367:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80036b:	48 98                	cltq   
  80036d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800371:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800375:	8b 00                	mov    (%rax),%eax
  800377:	3d ff 00 00 00       	cmp    $0xff,%eax
  80037c:	75 2c                	jne    8003aa <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80037e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800382:	8b 00                	mov    (%rax),%eax
  800384:	48 98                	cltq   
  800386:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80038a:	48 83 c2 08          	add    $0x8,%rdx
  80038e:	48 89 c6             	mov    %rax,%rsi
  800391:	48 89 d7             	mov    %rdx,%rdi
  800394:	48 b8 ea 17 80 00 00 	movabs $0x8017ea,%rax
  80039b:	00 00 00 
  80039e:	ff d0                	callq  *%rax
        b->idx = 0;
  8003a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ae:	8b 40 04             	mov    0x4(%rax),%eax
  8003b1:	8d 50 01             	lea    0x1(%rax),%edx
  8003b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b8:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003bb:	c9                   	leaveq 
  8003bc:	c3                   	retq   

00000000008003bd <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003bd:	55                   	push   %rbp
  8003be:	48 89 e5             	mov    %rsp,%rbp
  8003c1:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003c8:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003cf:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8003d6:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003dd:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8003e4:	48 8b 0a             	mov    (%rdx),%rcx
  8003e7:	48 89 08             	mov    %rcx,(%rax)
  8003ea:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003ee:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003f2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003f6:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8003fa:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800401:	00 00 00 
    b.cnt = 0;
  800404:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80040b:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80040e:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800415:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80041c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800423:	48 89 c6             	mov    %rax,%rsi
  800426:	48 bf 44 03 80 00 00 	movabs $0x800344,%rdi
  80042d:	00 00 00 
  800430:	48 b8 08 08 80 00 00 	movabs $0x800808,%rax
  800437:	00 00 00 
  80043a:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80043c:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800442:	48 98                	cltq   
  800444:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80044b:	48 83 c2 08          	add    $0x8,%rdx
  80044f:	48 89 c6             	mov    %rax,%rsi
  800452:	48 89 d7             	mov    %rdx,%rdi
  800455:	48 b8 ea 17 80 00 00 	movabs $0x8017ea,%rax
  80045c:	00 00 00 
  80045f:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800461:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800467:	c9                   	leaveq 
  800468:	c3                   	retq   

0000000000800469 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800469:	55                   	push   %rbp
  80046a:	48 89 e5             	mov    %rsp,%rbp
  80046d:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800474:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80047b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800482:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800489:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800490:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800497:	84 c0                	test   %al,%al
  800499:	74 20                	je     8004bb <cprintf+0x52>
  80049b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80049f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004a3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004a7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004ab:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004af:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004b3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004b7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004bb:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004c2:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004c9:	00 00 00 
  8004cc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004d3:	00 00 00 
  8004d6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004da:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004e1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004e8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8004ef:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8004f6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8004fd:	48 8b 0a             	mov    (%rdx),%rcx
  800500:	48 89 08             	mov    %rcx,(%rax)
  800503:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800507:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80050b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80050f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800513:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80051a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800521:	48 89 d6             	mov    %rdx,%rsi
  800524:	48 89 c7             	mov    %rax,%rdi
  800527:	48 b8 bd 03 80 00 00 	movabs $0x8003bd,%rax
  80052e:	00 00 00 
  800531:	ff d0                	callq  *%rax
  800533:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800539:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80053f:	c9                   	leaveq 
  800540:	c3                   	retq   

0000000000800541 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800541:	55                   	push   %rbp
  800542:	48 89 e5             	mov    %rsp,%rbp
  800545:	48 83 ec 30          	sub    $0x30,%rsp
  800549:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80054d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800551:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800555:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800558:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80055c:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800560:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800563:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800567:	77 42                	ja     8005ab <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800569:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80056c:	8d 78 ff             	lea    -0x1(%rax),%edi
  80056f:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800572:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800576:	ba 00 00 00 00       	mov    $0x0,%edx
  80057b:	48 f7 f6             	div    %rsi
  80057e:	49 89 c2             	mov    %rax,%r10
  800581:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800584:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800587:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80058b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80058f:	41 89 c9             	mov    %ecx,%r9d
  800592:	41 89 f8             	mov    %edi,%r8d
  800595:	89 d1                	mov    %edx,%ecx
  800597:	4c 89 d2             	mov    %r10,%rdx
  80059a:	48 89 c7             	mov    %rax,%rdi
  80059d:	48 b8 41 05 80 00 00 	movabs $0x800541,%rax
  8005a4:	00 00 00 
  8005a7:	ff d0                	callq  *%rax
  8005a9:	eb 1e                	jmp    8005c9 <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005ab:	eb 12                	jmp    8005bf <printnum+0x7e>
			putch(padc, putdat);
  8005ad:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8005b1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8005b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005b8:	48 89 ce             	mov    %rcx,%rsi
  8005bb:	89 d7                	mov    %edx,%edi
  8005bd:	ff d0                	callq  *%rax
		while (--width > 0)
  8005bf:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8005c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8005c7:	7f e4                	jg     8005ad <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005c9:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8005cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d5:	48 f7 f1             	div    %rcx
  8005d8:	48 b8 b0 40 80 00 00 	movabs $0x8040b0,%rax
  8005df:	00 00 00 
  8005e2:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8005e6:	0f be d0             	movsbl %al,%edx
  8005e9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8005ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005f1:	48 89 ce             	mov    %rcx,%rsi
  8005f4:	89 d7                	mov    %edx,%edi
  8005f6:	ff d0                	callq  *%rax
}
  8005f8:	c9                   	leaveq 
  8005f9:	c3                   	retq   

00000000008005fa <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005fa:	55                   	push   %rbp
  8005fb:	48 89 e5             	mov    %rsp,%rbp
  8005fe:	48 83 ec 20          	sub    $0x20,%rsp
  800602:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800606:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800609:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80060d:	7e 4f                	jle    80065e <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  80060f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800613:	8b 00                	mov    (%rax),%eax
  800615:	83 f8 30             	cmp    $0x30,%eax
  800618:	73 24                	jae    80063e <getuint+0x44>
  80061a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800622:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800626:	8b 00                	mov    (%rax),%eax
  800628:	89 c0                	mov    %eax,%eax
  80062a:	48 01 d0             	add    %rdx,%rax
  80062d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800631:	8b 12                	mov    (%rdx),%edx
  800633:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800636:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80063a:	89 0a                	mov    %ecx,(%rdx)
  80063c:	eb 14                	jmp    800652 <getuint+0x58>
  80063e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800642:	48 8b 40 08          	mov    0x8(%rax),%rax
  800646:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80064a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80064e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800652:	48 8b 00             	mov    (%rax),%rax
  800655:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800659:	e9 9d 00 00 00       	jmpq   8006fb <getuint+0x101>
	else if (lflag)
  80065e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800662:	74 4c                	je     8006b0 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800664:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800668:	8b 00                	mov    (%rax),%eax
  80066a:	83 f8 30             	cmp    $0x30,%eax
  80066d:	73 24                	jae    800693 <getuint+0x99>
  80066f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800673:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800677:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067b:	8b 00                	mov    (%rax),%eax
  80067d:	89 c0                	mov    %eax,%eax
  80067f:	48 01 d0             	add    %rdx,%rax
  800682:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800686:	8b 12                	mov    (%rdx),%edx
  800688:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80068b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068f:	89 0a                	mov    %ecx,(%rdx)
  800691:	eb 14                	jmp    8006a7 <getuint+0xad>
  800693:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800697:	48 8b 40 08          	mov    0x8(%rax),%rax
  80069b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80069f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006a7:	48 8b 00             	mov    (%rax),%rax
  8006aa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006ae:	eb 4b                	jmp    8006fb <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8006b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b4:	8b 00                	mov    (%rax),%eax
  8006b6:	83 f8 30             	cmp    $0x30,%eax
  8006b9:	73 24                	jae    8006df <getuint+0xe5>
  8006bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c7:	8b 00                	mov    (%rax),%eax
  8006c9:	89 c0                	mov    %eax,%eax
  8006cb:	48 01 d0             	add    %rdx,%rax
  8006ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d2:	8b 12                	mov    (%rdx),%edx
  8006d4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006db:	89 0a                	mov    %ecx,(%rdx)
  8006dd:	eb 14                	jmp    8006f3 <getuint+0xf9>
  8006df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006e7:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ef:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006f3:	8b 00                	mov    (%rax),%eax
  8006f5:	89 c0                	mov    %eax,%eax
  8006f7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006ff:	c9                   	leaveq 
  800700:	c3                   	retq   

0000000000800701 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800701:	55                   	push   %rbp
  800702:	48 89 e5             	mov    %rsp,%rbp
  800705:	48 83 ec 20          	sub    $0x20,%rsp
  800709:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80070d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800710:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800714:	7e 4f                	jle    800765 <getint+0x64>
		x=va_arg(*ap, long long);
  800716:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071a:	8b 00                	mov    (%rax),%eax
  80071c:	83 f8 30             	cmp    $0x30,%eax
  80071f:	73 24                	jae    800745 <getint+0x44>
  800721:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800725:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800729:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072d:	8b 00                	mov    (%rax),%eax
  80072f:	89 c0                	mov    %eax,%eax
  800731:	48 01 d0             	add    %rdx,%rax
  800734:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800738:	8b 12                	mov    (%rdx),%edx
  80073a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80073d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800741:	89 0a                	mov    %ecx,(%rdx)
  800743:	eb 14                	jmp    800759 <getint+0x58>
  800745:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800749:	48 8b 40 08          	mov    0x8(%rax),%rax
  80074d:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800751:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800755:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800759:	48 8b 00             	mov    (%rax),%rax
  80075c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800760:	e9 9d 00 00 00       	jmpq   800802 <getint+0x101>
	else if (lflag)
  800765:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800769:	74 4c                	je     8007b7 <getint+0xb6>
		x=va_arg(*ap, long);
  80076b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076f:	8b 00                	mov    (%rax),%eax
  800771:	83 f8 30             	cmp    $0x30,%eax
  800774:	73 24                	jae    80079a <getint+0x99>
  800776:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80077e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800782:	8b 00                	mov    (%rax),%eax
  800784:	89 c0                	mov    %eax,%eax
  800786:	48 01 d0             	add    %rdx,%rax
  800789:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078d:	8b 12                	mov    (%rdx),%edx
  80078f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800792:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800796:	89 0a                	mov    %ecx,(%rdx)
  800798:	eb 14                	jmp    8007ae <getint+0xad>
  80079a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079e:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007a2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007aa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007ae:	48 8b 00             	mov    (%rax),%rax
  8007b1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007b5:	eb 4b                	jmp    800802 <getint+0x101>
	else
		x=va_arg(*ap, int);
  8007b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bb:	8b 00                	mov    (%rax),%eax
  8007bd:	83 f8 30             	cmp    $0x30,%eax
  8007c0:	73 24                	jae    8007e6 <getint+0xe5>
  8007c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ce:	8b 00                	mov    (%rax),%eax
  8007d0:	89 c0                	mov    %eax,%eax
  8007d2:	48 01 d0             	add    %rdx,%rax
  8007d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d9:	8b 12                	mov    (%rdx),%edx
  8007db:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e2:	89 0a                	mov    %ecx,(%rdx)
  8007e4:	eb 14                	jmp    8007fa <getint+0xf9>
  8007e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ea:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007ee:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007fa:	8b 00                	mov    (%rax),%eax
  8007fc:	48 98                	cltq   
  8007fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800802:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800806:	c9                   	leaveq 
  800807:	c3                   	retq   

0000000000800808 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800808:	55                   	push   %rbp
  800809:	48 89 e5             	mov    %rsp,%rbp
  80080c:	41 54                	push   %r12
  80080e:	53                   	push   %rbx
  80080f:	48 83 ec 60          	sub    $0x60,%rsp
  800813:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800817:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80081b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80081f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800823:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800827:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80082b:	48 8b 0a             	mov    (%rdx),%rcx
  80082e:	48 89 08             	mov    %rcx,(%rax)
  800831:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800835:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800839:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80083d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800841:	eb 17                	jmp    80085a <vprintfmt+0x52>
			if (ch == '\0')
  800843:	85 db                	test   %ebx,%ebx
  800845:	0f 84 c5 04 00 00    	je     800d10 <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  80084b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80084f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800853:	48 89 d6             	mov    %rdx,%rsi
  800856:	89 df                	mov    %ebx,%edi
  800858:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80085a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80085e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800862:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800866:	0f b6 00             	movzbl (%rax),%eax
  800869:	0f b6 d8             	movzbl %al,%ebx
  80086c:	83 fb 25             	cmp    $0x25,%ebx
  80086f:	75 d2                	jne    800843 <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  800871:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800875:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80087c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800883:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80088a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800891:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800895:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800899:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80089d:	0f b6 00             	movzbl (%rax),%eax
  8008a0:	0f b6 d8             	movzbl %al,%ebx
  8008a3:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008a6:	83 f8 55             	cmp    $0x55,%eax
  8008a9:	0f 87 2e 04 00 00    	ja     800cdd <vprintfmt+0x4d5>
  8008af:	89 c0                	mov    %eax,%eax
  8008b1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008b8:	00 
  8008b9:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  8008c0:	00 00 00 
  8008c3:	48 01 d0             	add    %rdx,%rax
  8008c6:	48 8b 00             	mov    (%rax),%rax
  8008c9:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8008cb:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8008cf:	eb c0                	jmp    800891 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008d1:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8008d5:	eb ba                	jmp    800891 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008d7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8008de:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8008e1:	89 d0                	mov    %edx,%eax
  8008e3:	c1 e0 02             	shl    $0x2,%eax
  8008e6:	01 d0                	add    %edx,%eax
  8008e8:	01 c0                	add    %eax,%eax
  8008ea:	01 d8                	add    %ebx,%eax
  8008ec:	83 e8 30             	sub    $0x30,%eax
  8008ef:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8008f2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008f6:	0f b6 00             	movzbl (%rax),%eax
  8008f9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008fc:	83 fb 2f             	cmp    $0x2f,%ebx
  8008ff:	7e 0c                	jle    80090d <vprintfmt+0x105>
  800901:	83 fb 39             	cmp    $0x39,%ebx
  800904:	7f 07                	jg     80090d <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  800906:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  80090b:	eb d1                	jmp    8008de <vprintfmt+0xd6>
			goto process_precision;
  80090d:	eb 50                	jmp    80095f <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  80090f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800912:	83 f8 30             	cmp    $0x30,%eax
  800915:	73 17                	jae    80092e <vprintfmt+0x126>
  800917:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80091b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80091e:	89 d2                	mov    %edx,%edx
  800920:	48 01 d0             	add    %rdx,%rax
  800923:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800926:	83 c2 08             	add    $0x8,%edx
  800929:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80092c:	eb 0c                	jmp    80093a <vprintfmt+0x132>
  80092e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800932:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800936:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80093a:	8b 00                	mov    (%rax),%eax
  80093c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80093f:	eb 1e                	jmp    80095f <vprintfmt+0x157>

		case '.':
			if (width < 0)
  800941:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800945:	79 07                	jns    80094e <vprintfmt+0x146>
				width = 0;
  800947:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80094e:	e9 3e ff ff ff       	jmpq   800891 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800953:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80095a:	e9 32 ff ff ff       	jmpq   800891 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80095f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800963:	79 0d                	jns    800972 <vprintfmt+0x16a>
				width = precision, precision = -1;
  800965:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800968:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80096b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800972:	e9 1a ff ff ff       	jmpq   800891 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800977:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80097b:	e9 11 ff ff ff       	jmpq   800891 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800980:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800983:	83 f8 30             	cmp    $0x30,%eax
  800986:	73 17                	jae    80099f <vprintfmt+0x197>
  800988:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80098c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80098f:	89 d2                	mov    %edx,%edx
  800991:	48 01 d0             	add    %rdx,%rax
  800994:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800997:	83 c2 08             	add    $0x8,%edx
  80099a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80099d:	eb 0c                	jmp    8009ab <vprintfmt+0x1a3>
  80099f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8009a3:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8009a7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009ab:	8b 10                	mov    (%rax),%edx
  8009ad:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009b1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009b5:	48 89 ce             	mov    %rcx,%rsi
  8009b8:	89 d7                	mov    %edx,%edi
  8009ba:	ff d0                	callq  *%rax
			break;
  8009bc:	e9 4a 03 00 00       	jmpq   800d0b <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8009c1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c4:	83 f8 30             	cmp    $0x30,%eax
  8009c7:	73 17                	jae    8009e0 <vprintfmt+0x1d8>
  8009c9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8009cd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009d0:	89 d2                	mov    %edx,%edx
  8009d2:	48 01 d0             	add    %rdx,%rax
  8009d5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009d8:	83 c2 08             	add    $0x8,%edx
  8009db:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009de:	eb 0c                	jmp    8009ec <vprintfmt+0x1e4>
  8009e0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8009e4:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8009e8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009ec:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8009ee:	85 db                	test   %ebx,%ebx
  8009f0:	79 02                	jns    8009f4 <vprintfmt+0x1ec>
				err = -err;
  8009f2:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009f4:	83 fb 15             	cmp    $0x15,%ebx
  8009f7:	7f 16                	jg     800a0f <vprintfmt+0x207>
  8009f9:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  800a00:	00 00 00 
  800a03:	48 63 d3             	movslq %ebx,%rdx
  800a06:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a0a:	4d 85 e4             	test   %r12,%r12
  800a0d:	75 2e                	jne    800a3d <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  800a0f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a13:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a17:	89 d9                	mov    %ebx,%ecx
  800a19:	48 ba c1 40 80 00 00 	movabs $0x8040c1,%rdx
  800a20:	00 00 00 
  800a23:	48 89 c7             	mov    %rax,%rdi
  800a26:	b8 00 00 00 00       	mov    $0x0,%eax
  800a2b:	49 b8 19 0d 80 00 00 	movabs $0x800d19,%r8
  800a32:	00 00 00 
  800a35:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a38:	e9 ce 02 00 00       	jmpq   800d0b <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  800a3d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a41:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a45:	4c 89 e1             	mov    %r12,%rcx
  800a48:	48 ba ca 40 80 00 00 	movabs $0x8040ca,%rdx
  800a4f:	00 00 00 
  800a52:	48 89 c7             	mov    %rax,%rdi
  800a55:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5a:	49 b8 19 0d 80 00 00 	movabs $0x800d19,%r8
  800a61:	00 00 00 
  800a64:	41 ff d0             	callq  *%r8
			break;
  800a67:	e9 9f 02 00 00       	jmpq   800d0b <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800a6c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a6f:	83 f8 30             	cmp    $0x30,%eax
  800a72:	73 17                	jae    800a8b <vprintfmt+0x283>
  800a74:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a78:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a7b:	89 d2                	mov    %edx,%edx
  800a7d:	48 01 d0             	add    %rdx,%rax
  800a80:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a83:	83 c2 08             	add    $0x8,%edx
  800a86:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a89:	eb 0c                	jmp    800a97 <vprintfmt+0x28f>
  800a8b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a8f:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a93:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a97:	4c 8b 20             	mov    (%rax),%r12
  800a9a:	4d 85 e4             	test   %r12,%r12
  800a9d:	75 0a                	jne    800aa9 <vprintfmt+0x2a1>
				p = "(null)";
  800a9f:	49 bc cd 40 80 00 00 	movabs $0x8040cd,%r12
  800aa6:	00 00 00 
			if (width > 0 && padc != '-')
  800aa9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800aad:	7e 3f                	jle    800aee <vprintfmt+0x2e6>
  800aaf:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ab3:	74 39                	je     800aee <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ab5:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ab8:	48 98                	cltq   
  800aba:	48 89 c6             	mov    %rax,%rsi
  800abd:	4c 89 e7             	mov    %r12,%rdi
  800ac0:	48 b8 c5 0f 80 00 00 	movabs $0x800fc5,%rax
  800ac7:	00 00 00 
  800aca:	ff d0                	callq  *%rax
  800acc:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800acf:	eb 17                	jmp    800ae8 <vprintfmt+0x2e0>
					putch(padc, putdat);
  800ad1:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ad5:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ad9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800add:	48 89 ce             	mov    %rcx,%rsi
  800ae0:	89 d7                	mov    %edx,%edi
  800ae2:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  800ae4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ae8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800aec:	7f e3                	jg     800ad1 <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aee:	eb 37                	jmp    800b27 <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  800af0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800af4:	74 1e                	je     800b14 <vprintfmt+0x30c>
  800af6:	83 fb 1f             	cmp    $0x1f,%ebx
  800af9:	7e 05                	jle    800b00 <vprintfmt+0x2f8>
  800afb:	83 fb 7e             	cmp    $0x7e,%ebx
  800afe:	7e 14                	jle    800b14 <vprintfmt+0x30c>
					putch('?', putdat);
  800b00:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b04:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b08:	48 89 d6             	mov    %rdx,%rsi
  800b0b:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b10:	ff d0                	callq  *%rax
  800b12:	eb 0f                	jmp    800b23 <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  800b14:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b18:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b1c:	48 89 d6             	mov    %rdx,%rsi
  800b1f:	89 df                	mov    %ebx,%edi
  800b21:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b23:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b27:	4c 89 e0             	mov    %r12,%rax
  800b2a:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b2e:	0f b6 00             	movzbl (%rax),%eax
  800b31:	0f be d8             	movsbl %al,%ebx
  800b34:	85 db                	test   %ebx,%ebx
  800b36:	74 10                	je     800b48 <vprintfmt+0x340>
  800b38:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b3c:	78 b2                	js     800af0 <vprintfmt+0x2e8>
  800b3e:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b42:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b46:	79 a8                	jns    800af0 <vprintfmt+0x2e8>
			for (; width > 0; width--)
  800b48:	eb 16                	jmp    800b60 <vprintfmt+0x358>
				putch(' ', putdat);
  800b4a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b4e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b52:	48 89 d6             	mov    %rdx,%rsi
  800b55:	bf 20 00 00 00       	mov    $0x20,%edi
  800b5a:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  800b5c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b60:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b64:	7f e4                	jg     800b4a <vprintfmt+0x342>
			break;
  800b66:	e9 a0 01 00 00       	jmpq   800d0b <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800b6b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b6f:	be 03 00 00 00       	mov    $0x3,%esi
  800b74:	48 89 c7             	mov    %rax,%rdi
  800b77:	48 b8 01 07 80 00 00 	movabs $0x800701,%rax
  800b7e:	00 00 00 
  800b81:	ff d0                	callq  *%rax
  800b83:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b8b:	48 85 c0             	test   %rax,%rax
  800b8e:	79 1d                	jns    800bad <vprintfmt+0x3a5>
				putch('-', putdat);
  800b90:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b94:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b98:	48 89 d6             	mov    %rdx,%rsi
  800b9b:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ba0:	ff d0                	callq  *%rax
				num = -(long long) num;
  800ba2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba6:	48 f7 d8             	neg    %rax
  800ba9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bad:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bb4:	e9 e5 00 00 00       	jmpq   800c9e <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800bb9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bbd:	be 03 00 00 00       	mov    $0x3,%esi
  800bc2:	48 89 c7             	mov    %rax,%rdi
  800bc5:	48 b8 fa 05 80 00 00 	movabs $0x8005fa,%rax
  800bcc:	00 00 00 
  800bcf:	ff d0                	callq  *%rax
  800bd1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800bd5:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bdc:	e9 bd 00 00 00       	jmpq   800c9e <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800be1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800be5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be9:	48 89 d6             	mov    %rdx,%rsi
  800bec:	bf 58 00 00 00       	mov    $0x58,%edi
  800bf1:	ff d0                	callq  *%rax
			putch('X', putdat);
  800bf3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bf7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bfb:	48 89 d6             	mov    %rdx,%rsi
  800bfe:	bf 58 00 00 00       	mov    $0x58,%edi
  800c03:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c05:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c0d:	48 89 d6             	mov    %rdx,%rsi
  800c10:	bf 58 00 00 00       	mov    $0x58,%edi
  800c15:	ff d0                	callq  *%rax
			break;
  800c17:	e9 ef 00 00 00       	jmpq   800d0b <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  800c1c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c20:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c24:	48 89 d6             	mov    %rdx,%rsi
  800c27:	bf 30 00 00 00       	mov    $0x30,%edi
  800c2c:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c2e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c32:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c36:	48 89 d6             	mov    %rdx,%rsi
  800c39:	bf 78 00 00 00       	mov    $0x78,%edi
  800c3e:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c40:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c43:	83 f8 30             	cmp    $0x30,%eax
  800c46:	73 17                	jae    800c5f <vprintfmt+0x457>
  800c48:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c4c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c4f:	89 d2                	mov    %edx,%edx
  800c51:	48 01 d0             	add    %rdx,%rax
  800c54:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c57:	83 c2 08             	add    $0x8,%edx
  800c5a:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  800c5d:	eb 0c                	jmp    800c6b <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  800c5f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c63:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c67:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c6b:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  800c6e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c72:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c79:	eb 23                	jmp    800c9e <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800c7b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c7f:	be 03 00 00 00       	mov    $0x3,%esi
  800c84:	48 89 c7             	mov    %rax,%rdi
  800c87:	48 b8 fa 05 80 00 00 	movabs $0x8005fa,%rax
  800c8e:	00 00 00 
  800c91:	ff d0                	callq  *%rax
  800c93:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c97:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c9e:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ca3:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ca6:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ca9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cad:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cb1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb5:	45 89 c1             	mov    %r8d,%r9d
  800cb8:	41 89 f8             	mov    %edi,%r8d
  800cbb:	48 89 c7             	mov    %rax,%rdi
  800cbe:	48 b8 41 05 80 00 00 	movabs $0x800541,%rax
  800cc5:	00 00 00 
  800cc8:	ff d0                	callq  *%rax
			break;
  800cca:	eb 3f                	jmp    800d0b <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ccc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cd0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd4:	48 89 d6             	mov    %rdx,%rsi
  800cd7:	89 df                	mov    %ebx,%edi
  800cd9:	ff d0                	callq  *%rax
			break;
  800cdb:	eb 2e                	jmp    800d0b <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cdd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ce1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce5:	48 89 d6             	mov    %rdx,%rsi
  800ce8:	bf 25 00 00 00       	mov    $0x25,%edi
  800ced:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cef:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800cf4:	eb 05                	jmp    800cfb <vprintfmt+0x4f3>
  800cf6:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800cfb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800cff:	48 83 e8 01          	sub    $0x1,%rax
  800d03:	0f b6 00             	movzbl (%rax),%eax
  800d06:	3c 25                	cmp    $0x25,%al
  800d08:	75 ec                	jne    800cf6 <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  800d0a:	90                   	nop
		}
	}
  800d0b:	e9 31 fb ff ff       	jmpq   800841 <vprintfmt+0x39>
	va_end(aq);
}
  800d10:	48 83 c4 60          	add    $0x60,%rsp
  800d14:	5b                   	pop    %rbx
  800d15:	41 5c                	pop    %r12
  800d17:	5d                   	pop    %rbp
  800d18:	c3                   	retq   

0000000000800d19 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d19:	55                   	push   %rbp
  800d1a:	48 89 e5             	mov    %rsp,%rbp
  800d1d:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d24:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d2b:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d32:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d39:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d40:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d47:	84 c0                	test   %al,%al
  800d49:	74 20                	je     800d6b <printfmt+0x52>
  800d4b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d4f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d53:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d57:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d5b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d5f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d63:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d67:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d6b:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d72:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d79:	00 00 00 
  800d7c:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d83:	00 00 00 
  800d86:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d8a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800d91:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d98:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800d9f:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800da6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800dad:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800db4:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800dbb:	48 89 c7             	mov    %rax,%rdi
  800dbe:	48 b8 08 08 80 00 00 	movabs $0x800808,%rax
  800dc5:	00 00 00 
  800dc8:	ff d0                	callq  *%rax
	va_end(ap);
}
  800dca:	c9                   	leaveq 
  800dcb:	c3                   	retq   

0000000000800dcc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dcc:	55                   	push   %rbp
  800dcd:	48 89 e5             	mov    %rsp,%rbp
  800dd0:	48 83 ec 10          	sub    $0x10,%rsp
  800dd4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800dd7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ddb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ddf:	8b 40 10             	mov    0x10(%rax),%eax
  800de2:	8d 50 01             	lea    0x1(%rax),%edx
  800de5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800de9:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800dec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800df0:	48 8b 10             	mov    (%rax),%rdx
  800df3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800df7:	48 8b 40 08          	mov    0x8(%rax),%rax
  800dfb:	48 39 c2             	cmp    %rax,%rdx
  800dfe:	73 17                	jae    800e17 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e04:	48 8b 00             	mov    (%rax),%rax
  800e07:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e0f:	48 89 0a             	mov    %rcx,(%rdx)
  800e12:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e15:	88 10                	mov    %dl,(%rax)
}
  800e17:	c9                   	leaveq 
  800e18:	c3                   	retq   

0000000000800e19 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e19:	55                   	push   %rbp
  800e1a:	48 89 e5             	mov    %rsp,%rbp
  800e1d:	48 83 ec 50          	sub    $0x50,%rsp
  800e21:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e25:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e28:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e2c:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e30:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e34:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e38:	48 8b 0a             	mov    (%rdx),%rcx
  800e3b:	48 89 08             	mov    %rcx,(%rax)
  800e3e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e42:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e46:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e4a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e4e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e52:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e56:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e59:	48 98                	cltq   
  800e5b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e5f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e63:	48 01 d0             	add    %rdx,%rax
  800e66:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e6a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e71:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800e76:	74 06                	je     800e7e <vsnprintf+0x65>
  800e78:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800e7c:	7f 07                	jg     800e85 <vsnprintf+0x6c>
		return -E_INVAL;
  800e7e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e83:	eb 2f                	jmp    800eb4 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e85:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e89:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800e8d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e91:	48 89 c6             	mov    %rax,%rsi
  800e94:	48 bf cc 0d 80 00 00 	movabs $0x800dcc,%rdi
  800e9b:	00 00 00 
  800e9e:	48 b8 08 08 80 00 00 	movabs $0x800808,%rax
  800ea5:	00 00 00 
  800ea8:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800eaa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800eae:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800eb1:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800eb4:	c9                   	leaveq 
  800eb5:	c3                   	retq   

0000000000800eb6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800eb6:	55                   	push   %rbp
  800eb7:	48 89 e5             	mov    %rsp,%rbp
  800eba:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800ec1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800ec8:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800ece:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ed5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800edc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ee3:	84 c0                	test   %al,%al
  800ee5:	74 20                	je     800f07 <snprintf+0x51>
  800ee7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800eeb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800eef:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ef3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ef7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800efb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800eff:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f03:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f07:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f0e:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f15:	00 00 00 
  800f18:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f1f:	00 00 00 
  800f22:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f26:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f2d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f34:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f3b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f42:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f49:	48 8b 0a             	mov    (%rdx),%rcx
  800f4c:	48 89 08             	mov    %rcx,(%rax)
  800f4f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f53:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f57:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f5b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f5f:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f66:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f6d:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f73:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f7a:	48 89 c7             	mov    %rax,%rdi
  800f7d:	48 b8 19 0e 80 00 00 	movabs $0x800e19,%rax
  800f84:	00 00 00 
  800f87:	ff d0                	callq  *%rax
  800f89:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800f8f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f95:	c9                   	leaveq 
  800f96:	c3                   	retq   

0000000000800f97 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f97:	55                   	push   %rbp
  800f98:	48 89 e5             	mov    %rsp,%rbp
  800f9b:	48 83 ec 18          	sub    $0x18,%rsp
  800f9f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800fa3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800faa:	eb 09                	jmp    800fb5 <strlen+0x1e>
		n++;
  800fac:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  800fb0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fb5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb9:	0f b6 00             	movzbl (%rax),%eax
  800fbc:	84 c0                	test   %al,%al
  800fbe:	75 ec                	jne    800fac <strlen+0x15>
	return n;
  800fc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fc3:	c9                   	leaveq 
  800fc4:	c3                   	retq   

0000000000800fc5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800fc5:	55                   	push   %rbp
  800fc6:	48 89 e5             	mov    %rsp,%rbp
  800fc9:	48 83 ec 20          	sub    $0x20,%rsp
  800fcd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fd1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fdc:	eb 0e                	jmp    800fec <strnlen+0x27>
		n++;
  800fde:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fe2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fe7:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800fec:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800ff1:	74 0b                	je     800ffe <strnlen+0x39>
  800ff3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff7:	0f b6 00             	movzbl (%rax),%eax
  800ffa:	84 c0                	test   %al,%al
  800ffc:	75 e0                	jne    800fde <strnlen+0x19>
	return n;
  800ffe:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801001:	c9                   	leaveq 
  801002:	c3                   	retq   

0000000000801003 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801003:	55                   	push   %rbp
  801004:	48 89 e5             	mov    %rsp,%rbp
  801007:	48 83 ec 20          	sub    $0x20,%rsp
  80100b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80100f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801013:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801017:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80101b:	90                   	nop
  80101c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801020:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801024:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801028:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80102c:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801030:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801034:	0f b6 12             	movzbl (%rdx),%edx
  801037:	88 10                	mov    %dl,(%rax)
  801039:	0f b6 00             	movzbl (%rax),%eax
  80103c:	84 c0                	test   %al,%al
  80103e:	75 dc                	jne    80101c <strcpy+0x19>
		/* do nothing */;
	return ret;
  801040:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801044:	c9                   	leaveq 
  801045:	c3                   	retq   

0000000000801046 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801046:	55                   	push   %rbp
  801047:	48 89 e5             	mov    %rsp,%rbp
  80104a:	48 83 ec 20          	sub    $0x20,%rsp
  80104e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801052:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801056:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80105a:	48 89 c7             	mov    %rax,%rdi
  80105d:	48 b8 97 0f 80 00 00 	movabs $0x800f97,%rax
  801064:	00 00 00 
  801067:	ff d0                	callq  *%rax
  801069:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80106c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80106f:	48 63 d0             	movslq %eax,%rdx
  801072:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801076:	48 01 c2             	add    %rax,%rdx
  801079:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80107d:	48 89 c6             	mov    %rax,%rsi
  801080:	48 89 d7             	mov    %rdx,%rdi
  801083:	48 b8 03 10 80 00 00 	movabs $0x801003,%rax
  80108a:	00 00 00 
  80108d:	ff d0                	callq  *%rax
	return dst;
  80108f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801093:	c9                   	leaveq 
  801094:	c3                   	retq   

0000000000801095 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801095:	55                   	push   %rbp
  801096:	48 89 e5             	mov    %rsp,%rbp
  801099:	48 83 ec 28          	sub    $0x28,%rsp
  80109d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010a5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ad:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010b1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010b8:	00 
  8010b9:	eb 2a                	jmp    8010e5 <strncpy+0x50>
		*dst++ = *src;
  8010bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010bf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010c3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010c7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010cb:	0f b6 12             	movzbl (%rdx),%edx
  8010ce:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010d4:	0f b6 00             	movzbl (%rax),%eax
  8010d7:	84 c0                	test   %al,%al
  8010d9:	74 05                	je     8010e0 <strncpy+0x4b>
			src++;
  8010db:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  8010e0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e9:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8010ed:	72 cc                	jb     8010bb <strncpy+0x26>
	}
	return ret;
  8010ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8010f3:	c9                   	leaveq 
  8010f4:	c3                   	retq   

00000000008010f5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8010f5:	55                   	push   %rbp
  8010f6:	48 89 e5             	mov    %rsp,%rbp
  8010f9:	48 83 ec 28          	sub    $0x28,%rsp
  8010fd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801101:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801105:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801109:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801111:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801116:	74 3d                	je     801155 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801118:	eb 1d                	jmp    801137 <strlcpy+0x42>
			*dst++ = *src++;
  80111a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801122:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801126:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80112a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80112e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801132:	0f b6 12             	movzbl (%rdx),%edx
  801135:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  801137:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80113c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801141:	74 0b                	je     80114e <strlcpy+0x59>
  801143:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801147:	0f b6 00             	movzbl (%rax),%eax
  80114a:	84 c0                	test   %al,%al
  80114c:	75 cc                	jne    80111a <strlcpy+0x25>
		*dst = '\0';
  80114e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801152:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801155:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801159:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80115d:	48 29 c2             	sub    %rax,%rdx
  801160:	48 89 d0             	mov    %rdx,%rax
}
  801163:	c9                   	leaveq 
  801164:	c3                   	retq   

0000000000801165 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801165:	55                   	push   %rbp
  801166:	48 89 e5             	mov    %rsp,%rbp
  801169:	48 83 ec 10          	sub    $0x10,%rsp
  80116d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801171:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801175:	eb 0a                	jmp    801181 <strcmp+0x1c>
		p++, q++;
  801177:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80117c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  801181:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801185:	0f b6 00             	movzbl (%rax),%eax
  801188:	84 c0                	test   %al,%al
  80118a:	74 12                	je     80119e <strcmp+0x39>
  80118c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801190:	0f b6 10             	movzbl (%rax),%edx
  801193:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801197:	0f b6 00             	movzbl (%rax),%eax
  80119a:	38 c2                	cmp    %al,%dl
  80119c:	74 d9                	je     801177 <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80119e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a2:	0f b6 00             	movzbl (%rax),%eax
  8011a5:	0f b6 d0             	movzbl %al,%edx
  8011a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ac:	0f b6 00             	movzbl (%rax),%eax
  8011af:	0f b6 c0             	movzbl %al,%eax
  8011b2:	29 c2                	sub    %eax,%edx
  8011b4:	89 d0                	mov    %edx,%eax
}
  8011b6:	c9                   	leaveq 
  8011b7:	c3                   	retq   

00000000008011b8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011b8:	55                   	push   %rbp
  8011b9:	48 89 e5             	mov    %rsp,%rbp
  8011bc:	48 83 ec 18          	sub    $0x18,%rsp
  8011c0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011c4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8011c8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8011cc:	eb 0f                	jmp    8011dd <strncmp+0x25>
		n--, p++, q++;
  8011ce:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8011d3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011d8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  8011dd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011e2:	74 1d                	je     801201 <strncmp+0x49>
  8011e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e8:	0f b6 00             	movzbl (%rax),%eax
  8011eb:	84 c0                	test   %al,%al
  8011ed:	74 12                	je     801201 <strncmp+0x49>
  8011ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f3:	0f b6 10             	movzbl (%rax),%edx
  8011f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011fa:	0f b6 00             	movzbl (%rax),%eax
  8011fd:	38 c2                	cmp    %al,%dl
  8011ff:	74 cd                	je     8011ce <strncmp+0x16>
	if (n == 0)
  801201:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801206:	75 07                	jne    80120f <strncmp+0x57>
		return 0;
  801208:	b8 00 00 00 00       	mov    $0x0,%eax
  80120d:	eb 18                	jmp    801227 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80120f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801213:	0f b6 00             	movzbl (%rax),%eax
  801216:	0f b6 d0             	movzbl %al,%edx
  801219:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80121d:	0f b6 00             	movzbl (%rax),%eax
  801220:	0f b6 c0             	movzbl %al,%eax
  801223:	29 c2                	sub    %eax,%edx
  801225:	89 d0                	mov    %edx,%eax
}
  801227:	c9                   	leaveq 
  801228:	c3                   	retq   

0000000000801229 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801229:	55                   	push   %rbp
  80122a:	48 89 e5             	mov    %rsp,%rbp
  80122d:	48 83 ec 10          	sub    $0x10,%rsp
  801231:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801235:	89 f0                	mov    %esi,%eax
  801237:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80123a:	eb 17                	jmp    801253 <strchr+0x2a>
		if (*s == c)
  80123c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801240:	0f b6 00             	movzbl (%rax),%eax
  801243:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801246:	75 06                	jne    80124e <strchr+0x25>
			return (char *) s;
  801248:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124c:	eb 15                	jmp    801263 <strchr+0x3a>
	for (; *s; s++)
  80124e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801253:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801257:	0f b6 00             	movzbl (%rax),%eax
  80125a:	84 c0                	test   %al,%al
  80125c:	75 de                	jne    80123c <strchr+0x13>
	return 0;
  80125e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801263:	c9                   	leaveq 
  801264:	c3                   	retq   

0000000000801265 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801265:	55                   	push   %rbp
  801266:	48 89 e5             	mov    %rsp,%rbp
  801269:	48 83 ec 10          	sub    $0x10,%rsp
  80126d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801271:	89 f0                	mov    %esi,%eax
  801273:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801276:	eb 13                	jmp    80128b <strfind+0x26>
		if (*s == c)
  801278:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127c:	0f b6 00             	movzbl (%rax),%eax
  80127f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801282:	75 02                	jne    801286 <strfind+0x21>
			break;
  801284:	eb 10                	jmp    801296 <strfind+0x31>
	for (; *s; s++)
  801286:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80128b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128f:	0f b6 00             	movzbl (%rax),%eax
  801292:	84 c0                	test   %al,%al
  801294:	75 e2                	jne    801278 <strfind+0x13>
	return (char *) s;
  801296:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80129a:	c9                   	leaveq 
  80129b:	c3                   	retq   

000000000080129c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80129c:	55                   	push   %rbp
  80129d:	48 89 e5             	mov    %rsp,%rbp
  8012a0:	48 83 ec 18          	sub    $0x18,%rsp
  8012a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012a8:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012ab:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012af:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012b4:	75 06                	jne    8012bc <memset+0x20>
		return v;
  8012b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ba:	eb 69                	jmp    801325 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c0:	83 e0 03             	and    $0x3,%eax
  8012c3:	48 85 c0             	test   %rax,%rax
  8012c6:	75 48                	jne    801310 <memset+0x74>
  8012c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012cc:	83 e0 03             	and    $0x3,%eax
  8012cf:	48 85 c0             	test   %rax,%rax
  8012d2:	75 3c                	jne    801310 <memset+0x74>
		c &= 0xFF;
  8012d4:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8012db:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012de:	c1 e0 18             	shl    $0x18,%eax
  8012e1:	89 c2                	mov    %eax,%edx
  8012e3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012e6:	c1 e0 10             	shl    $0x10,%eax
  8012e9:	09 c2                	or     %eax,%edx
  8012eb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012ee:	c1 e0 08             	shl    $0x8,%eax
  8012f1:	09 d0                	or     %edx,%eax
  8012f3:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8012f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012fa:	48 c1 e8 02          	shr    $0x2,%rax
  8012fe:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  801301:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801305:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801308:	48 89 d7             	mov    %rdx,%rdi
  80130b:	fc                   	cld    
  80130c:	f3 ab                	rep stos %eax,%es:(%rdi)
  80130e:	eb 11                	jmp    801321 <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801310:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801314:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801317:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80131b:	48 89 d7             	mov    %rdx,%rdi
  80131e:	fc                   	cld    
  80131f:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801321:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801325:	c9                   	leaveq 
  801326:	c3                   	retq   

0000000000801327 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801327:	55                   	push   %rbp
  801328:	48 89 e5             	mov    %rsp,%rbp
  80132b:	48 83 ec 28          	sub    $0x28,%rsp
  80132f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801333:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801337:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80133b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80133f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801343:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801347:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80134b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801353:	0f 83 88 00 00 00    	jae    8013e1 <memmove+0xba>
  801359:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80135d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801361:	48 01 d0             	add    %rdx,%rax
  801364:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801368:	76 77                	jbe    8013e1 <memmove+0xba>
		s += n;
  80136a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80136e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801372:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801376:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80137a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137e:	83 e0 03             	and    $0x3,%eax
  801381:	48 85 c0             	test   %rax,%rax
  801384:	75 3b                	jne    8013c1 <memmove+0x9a>
  801386:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80138a:	83 e0 03             	and    $0x3,%eax
  80138d:	48 85 c0             	test   %rax,%rax
  801390:	75 2f                	jne    8013c1 <memmove+0x9a>
  801392:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801396:	83 e0 03             	and    $0x3,%eax
  801399:	48 85 c0             	test   %rax,%rax
  80139c:	75 23                	jne    8013c1 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80139e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a2:	48 83 e8 04          	sub    $0x4,%rax
  8013a6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013aa:	48 83 ea 04          	sub    $0x4,%rdx
  8013ae:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013b2:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  8013b6:	48 89 c7             	mov    %rax,%rdi
  8013b9:	48 89 d6             	mov    %rdx,%rsi
  8013bc:	fd                   	std    
  8013bd:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013bf:	eb 1d                	jmp    8013de <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013cd:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  8013d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d5:	48 89 d7             	mov    %rdx,%rdi
  8013d8:	48 89 c1             	mov    %rax,%rcx
  8013db:	fd                   	std    
  8013dc:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8013de:	fc                   	cld    
  8013df:	eb 57                	jmp    801438 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e5:	83 e0 03             	and    $0x3,%eax
  8013e8:	48 85 c0             	test   %rax,%rax
  8013eb:	75 36                	jne    801423 <memmove+0xfc>
  8013ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f1:	83 e0 03             	and    $0x3,%eax
  8013f4:	48 85 c0             	test   %rax,%rax
  8013f7:	75 2a                	jne    801423 <memmove+0xfc>
  8013f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fd:	83 e0 03             	and    $0x3,%eax
  801400:	48 85 c0             	test   %rax,%rax
  801403:	75 1e                	jne    801423 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801405:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801409:	48 c1 e8 02          	shr    $0x2,%rax
  80140d:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  801410:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801414:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801418:	48 89 c7             	mov    %rax,%rdi
  80141b:	48 89 d6             	mov    %rdx,%rsi
  80141e:	fc                   	cld    
  80141f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801421:	eb 15                	jmp    801438 <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  801423:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801427:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80142b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80142f:	48 89 c7             	mov    %rax,%rdi
  801432:	48 89 d6             	mov    %rdx,%rsi
  801435:	fc                   	cld    
  801436:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801438:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80143c:	c9                   	leaveq 
  80143d:	c3                   	retq   

000000000080143e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80143e:	55                   	push   %rbp
  80143f:	48 89 e5             	mov    %rsp,%rbp
  801442:	48 83 ec 18          	sub    $0x18,%rsp
  801446:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80144a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80144e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801452:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801456:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80145a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145e:	48 89 ce             	mov    %rcx,%rsi
  801461:	48 89 c7             	mov    %rax,%rdi
  801464:	48 b8 27 13 80 00 00 	movabs $0x801327,%rax
  80146b:	00 00 00 
  80146e:	ff d0                	callq  *%rax
}
  801470:	c9                   	leaveq 
  801471:	c3                   	retq   

0000000000801472 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801472:	55                   	push   %rbp
  801473:	48 89 e5             	mov    %rsp,%rbp
  801476:	48 83 ec 28          	sub    $0x28,%rsp
  80147a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80147e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801482:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801486:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80148e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801492:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801496:	eb 36                	jmp    8014ce <memcmp+0x5c>
		if (*s1 != *s2)
  801498:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149c:	0f b6 10             	movzbl (%rax),%edx
  80149f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a3:	0f b6 00             	movzbl (%rax),%eax
  8014a6:	38 c2                	cmp    %al,%dl
  8014a8:	74 1a                	je     8014c4 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ae:	0f b6 00             	movzbl (%rax),%eax
  8014b1:	0f b6 d0             	movzbl %al,%edx
  8014b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b8:	0f b6 00             	movzbl (%rax),%eax
  8014bb:	0f b6 c0             	movzbl %al,%eax
  8014be:	29 c2                	sub    %eax,%edx
  8014c0:	89 d0                	mov    %edx,%eax
  8014c2:	eb 20                	jmp    8014e4 <memcmp+0x72>
		s1++, s2++;
  8014c4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014c9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  8014ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014d6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8014da:	48 85 c0             	test   %rax,%rax
  8014dd:	75 b9                	jne    801498 <memcmp+0x26>
	}

	return 0;
  8014df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014e4:	c9                   	leaveq 
  8014e5:	c3                   	retq   

00000000008014e6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8014e6:	55                   	push   %rbp
  8014e7:	48 89 e5             	mov    %rsp,%rbp
  8014ea:	48 83 ec 28          	sub    $0x28,%rsp
  8014ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014f2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8014f5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8014f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801501:	48 01 d0             	add    %rdx,%rax
  801504:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801508:	eb 15                	jmp    80151f <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80150a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80150e:	0f b6 00             	movzbl (%rax),%eax
  801511:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801514:	38 d0                	cmp    %dl,%al
  801516:	75 02                	jne    80151a <memfind+0x34>
			break;
  801518:	eb 0f                	jmp    801529 <memfind+0x43>
	for (; s < ends; s++)
  80151a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80151f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801523:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801527:	72 e1                	jb     80150a <memfind+0x24>
	return (void *) s;
  801529:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80152d:	c9                   	leaveq 
  80152e:	c3                   	retq   

000000000080152f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80152f:	55                   	push   %rbp
  801530:	48 89 e5             	mov    %rsp,%rbp
  801533:	48 83 ec 38          	sub    $0x38,%rsp
  801537:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80153b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80153f:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801542:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801549:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801550:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801551:	eb 05                	jmp    801558 <strtol+0x29>
		s++;
  801553:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  801558:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155c:	0f b6 00             	movzbl (%rax),%eax
  80155f:	3c 20                	cmp    $0x20,%al
  801561:	74 f0                	je     801553 <strtol+0x24>
  801563:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801567:	0f b6 00             	movzbl (%rax),%eax
  80156a:	3c 09                	cmp    $0x9,%al
  80156c:	74 e5                	je     801553 <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  80156e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801572:	0f b6 00             	movzbl (%rax),%eax
  801575:	3c 2b                	cmp    $0x2b,%al
  801577:	75 07                	jne    801580 <strtol+0x51>
		s++;
  801579:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80157e:	eb 17                	jmp    801597 <strtol+0x68>
	else if (*s == '-')
  801580:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801584:	0f b6 00             	movzbl (%rax),%eax
  801587:	3c 2d                	cmp    $0x2d,%al
  801589:	75 0c                	jne    801597 <strtol+0x68>
		s++, neg = 1;
  80158b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801590:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801597:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80159b:	74 06                	je     8015a3 <strtol+0x74>
  80159d:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015a1:	75 28                	jne    8015cb <strtol+0x9c>
  8015a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a7:	0f b6 00             	movzbl (%rax),%eax
  8015aa:	3c 30                	cmp    $0x30,%al
  8015ac:	75 1d                	jne    8015cb <strtol+0x9c>
  8015ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b2:	48 83 c0 01          	add    $0x1,%rax
  8015b6:	0f b6 00             	movzbl (%rax),%eax
  8015b9:	3c 78                	cmp    $0x78,%al
  8015bb:	75 0e                	jne    8015cb <strtol+0x9c>
		s += 2, base = 16;
  8015bd:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8015c2:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8015c9:	eb 2c                	jmp    8015f7 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8015cb:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015cf:	75 19                	jne    8015ea <strtol+0xbb>
  8015d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d5:	0f b6 00             	movzbl (%rax),%eax
  8015d8:	3c 30                	cmp    $0x30,%al
  8015da:	75 0e                	jne    8015ea <strtol+0xbb>
		s++, base = 8;
  8015dc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015e1:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8015e8:	eb 0d                	jmp    8015f7 <strtol+0xc8>
	else if (base == 0)
  8015ea:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015ee:	75 07                	jne    8015f7 <strtol+0xc8>
		base = 10;
  8015f0:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8015f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fb:	0f b6 00             	movzbl (%rax),%eax
  8015fe:	3c 2f                	cmp    $0x2f,%al
  801600:	7e 1d                	jle    80161f <strtol+0xf0>
  801602:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801606:	0f b6 00             	movzbl (%rax),%eax
  801609:	3c 39                	cmp    $0x39,%al
  80160b:	7f 12                	jg     80161f <strtol+0xf0>
			dig = *s - '0';
  80160d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801611:	0f b6 00             	movzbl (%rax),%eax
  801614:	0f be c0             	movsbl %al,%eax
  801617:	83 e8 30             	sub    $0x30,%eax
  80161a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80161d:	eb 4e                	jmp    80166d <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80161f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801623:	0f b6 00             	movzbl (%rax),%eax
  801626:	3c 60                	cmp    $0x60,%al
  801628:	7e 1d                	jle    801647 <strtol+0x118>
  80162a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162e:	0f b6 00             	movzbl (%rax),%eax
  801631:	3c 7a                	cmp    $0x7a,%al
  801633:	7f 12                	jg     801647 <strtol+0x118>
			dig = *s - 'a' + 10;
  801635:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801639:	0f b6 00             	movzbl (%rax),%eax
  80163c:	0f be c0             	movsbl %al,%eax
  80163f:	83 e8 57             	sub    $0x57,%eax
  801642:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801645:	eb 26                	jmp    80166d <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801647:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164b:	0f b6 00             	movzbl (%rax),%eax
  80164e:	3c 40                	cmp    $0x40,%al
  801650:	7e 48                	jle    80169a <strtol+0x16b>
  801652:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801656:	0f b6 00             	movzbl (%rax),%eax
  801659:	3c 5a                	cmp    $0x5a,%al
  80165b:	7f 3d                	jg     80169a <strtol+0x16b>
			dig = *s - 'A' + 10;
  80165d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801661:	0f b6 00             	movzbl (%rax),%eax
  801664:	0f be c0             	movsbl %al,%eax
  801667:	83 e8 37             	sub    $0x37,%eax
  80166a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80166d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801670:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801673:	7c 02                	jl     801677 <strtol+0x148>
			break;
  801675:	eb 23                	jmp    80169a <strtol+0x16b>
		s++, val = (val * base) + dig;
  801677:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80167c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80167f:	48 98                	cltq   
  801681:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801686:	48 89 c2             	mov    %rax,%rdx
  801689:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80168c:	48 98                	cltq   
  80168e:	48 01 d0             	add    %rdx,%rax
  801691:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801695:	e9 5d ff ff ff       	jmpq   8015f7 <strtol+0xc8>

	if (endptr)
  80169a:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80169f:	74 0b                	je     8016ac <strtol+0x17d>
		*endptr = (char *) s;
  8016a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016a5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016a9:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016b0:	74 09                	je     8016bb <strtol+0x18c>
  8016b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b6:	48 f7 d8             	neg    %rax
  8016b9:	eb 04                	jmp    8016bf <strtol+0x190>
  8016bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016bf:	c9                   	leaveq 
  8016c0:	c3                   	retq   

00000000008016c1 <strstr>:

char * strstr(const char *in, const char *str)
{
  8016c1:	55                   	push   %rbp
  8016c2:	48 89 e5             	mov    %rsp,%rbp
  8016c5:	48 83 ec 30          	sub    $0x30,%rsp
  8016c9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016cd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8016d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016d5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016d9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016dd:	0f b6 00             	movzbl (%rax),%eax
  8016e0:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8016e3:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8016e7:	75 06                	jne    8016ef <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8016e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ed:	eb 6b                	jmp    80175a <strstr+0x99>

	len = strlen(str);
  8016ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016f3:	48 89 c7             	mov    %rax,%rdi
  8016f6:	48 b8 97 0f 80 00 00 	movabs $0x800f97,%rax
  8016fd:	00 00 00 
  801700:	ff d0                	callq  *%rax
  801702:	48 98                	cltq   
  801704:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801708:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801710:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801714:	0f b6 00             	movzbl (%rax),%eax
  801717:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80171a:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80171e:	75 07                	jne    801727 <strstr+0x66>
				return (char *) 0;
  801720:	b8 00 00 00 00       	mov    $0x0,%eax
  801725:	eb 33                	jmp    80175a <strstr+0x99>
		} while (sc != c);
  801727:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80172b:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80172e:	75 d8                	jne    801708 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801730:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801734:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801738:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173c:	48 89 ce             	mov    %rcx,%rsi
  80173f:	48 89 c7             	mov    %rax,%rdi
  801742:	48 b8 b8 11 80 00 00 	movabs $0x8011b8,%rax
  801749:	00 00 00 
  80174c:	ff d0                	callq  *%rax
  80174e:	85 c0                	test   %eax,%eax
  801750:	75 b6                	jne    801708 <strstr+0x47>

	return (char *) (in - 1);
  801752:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801756:	48 83 e8 01          	sub    $0x1,%rax
}
  80175a:	c9                   	leaveq 
  80175b:	c3                   	retq   

000000000080175c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80175c:	55                   	push   %rbp
  80175d:	48 89 e5             	mov    %rsp,%rbp
  801760:	53                   	push   %rbx
  801761:	48 83 ec 48          	sub    $0x48,%rsp
  801765:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801768:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80176b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80176f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801773:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801777:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80177b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80177e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801782:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801786:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80178a:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80178e:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801792:	4c 89 c3             	mov    %r8,%rbx
  801795:	cd 30                	int    $0x30
  801797:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80179b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80179f:	74 3e                	je     8017df <syscall+0x83>
  8017a1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017a6:	7e 37                	jle    8017df <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017ac:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017af:	49 89 d0             	mov    %rdx,%r8
  8017b2:	89 c1                	mov    %eax,%ecx
  8017b4:	48 ba 88 43 80 00 00 	movabs $0x804388,%rdx
  8017bb:	00 00 00 
  8017be:	be 23 00 00 00       	mov    $0x23,%esi
  8017c3:	48 bf a5 43 80 00 00 	movabs $0x8043a5,%rdi
  8017ca:	00 00 00 
  8017cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d2:	49 b9 30 02 80 00 00 	movabs $0x800230,%r9
  8017d9:	00 00 00 
  8017dc:	41 ff d1             	callq  *%r9

	return ret;
  8017df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017e3:	48 83 c4 48          	add    $0x48,%rsp
  8017e7:	5b                   	pop    %rbx
  8017e8:	5d                   	pop    %rbp
  8017e9:	c3                   	retq   

00000000008017ea <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8017ea:	55                   	push   %rbp
  8017eb:	48 89 e5             	mov    %rsp,%rbp
  8017ee:	48 83 ec 10          	sub    $0x10,%rsp
  8017f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017f6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8017fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017fe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801802:	48 83 ec 08          	sub    $0x8,%rsp
  801806:	6a 00                	pushq  $0x0
  801808:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80180e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801814:	48 89 d1             	mov    %rdx,%rcx
  801817:	48 89 c2             	mov    %rax,%rdx
  80181a:	be 00 00 00 00       	mov    $0x0,%esi
  80181f:	bf 00 00 00 00       	mov    $0x0,%edi
  801824:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  80182b:	00 00 00 
  80182e:	ff d0                	callq  *%rax
  801830:	48 83 c4 10          	add    $0x10,%rsp
}
  801834:	c9                   	leaveq 
  801835:	c3                   	retq   

0000000000801836 <sys_cgetc>:

int
sys_cgetc(void)
{
  801836:	55                   	push   %rbp
  801837:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80183a:	48 83 ec 08          	sub    $0x8,%rsp
  80183e:	6a 00                	pushq  $0x0
  801840:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801846:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80184c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801851:	ba 00 00 00 00       	mov    $0x0,%edx
  801856:	be 00 00 00 00       	mov    $0x0,%esi
  80185b:	bf 01 00 00 00       	mov    $0x1,%edi
  801860:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  801867:	00 00 00 
  80186a:	ff d0                	callq  *%rax
  80186c:	48 83 c4 10          	add    $0x10,%rsp
}
  801870:	c9                   	leaveq 
  801871:	c3                   	retq   

0000000000801872 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801872:	55                   	push   %rbp
  801873:	48 89 e5             	mov    %rsp,%rbp
  801876:	48 83 ec 10          	sub    $0x10,%rsp
  80187a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80187d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801880:	48 98                	cltq   
  801882:	48 83 ec 08          	sub    $0x8,%rsp
  801886:	6a 00                	pushq  $0x0
  801888:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80188e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801894:	b9 00 00 00 00       	mov    $0x0,%ecx
  801899:	48 89 c2             	mov    %rax,%rdx
  80189c:	be 01 00 00 00       	mov    $0x1,%esi
  8018a1:	bf 03 00 00 00       	mov    $0x3,%edi
  8018a6:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  8018ad:	00 00 00 
  8018b0:	ff d0                	callq  *%rax
  8018b2:	48 83 c4 10          	add    $0x10,%rsp
}
  8018b6:	c9                   	leaveq 
  8018b7:	c3                   	retq   

00000000008018b8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018b8:	55                   	push   %rbp
  8018b9:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018bc:	48 83 ec 08          	sub    $0x8,%rsp
  8018c0:	6a 00                	pushq  $0x0
  8018c2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018c8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018ce:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d8:	be 00 00 00 00       	mov    $0x0,%esi
  8018dd:	bf 02 00 00 00       	mov    $0x2,%edi
  8018e2:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  8018e9:	00 00 00 
  8018ec:	ff d0                	callq  *%rax
  8018ee:	48 83 c4 10          	add    $0x10,%rsp
}
  8018f2:	c9                   	leaveq 
  8018f3:	c3                   	retq   

00000000008018f4 <sys_yield>:

void
sys_yield(void)
{
  8018f4:	55                   	push   %rbp
  8018f5:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8018f8:	48 83 ec 08          	sub    $0x8,%rsp
  8018fc:	6a 00                	pushq  $0x0
  8018fe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801904:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80190a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80190f:	ba 00 00 00 00       	mov    $0x0,%edx
  801914:	be 00 00 00 00       	mov    $0x0,%esi
  801919:	bf 0b 00 00 00       	mov    $0xb,%edi
  80191e:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  801925:	00 00 00 
  801928:	ff d0                	callq  *%rax
  80192a:	48 83 c4 10          	add    $0x10,%rsp
}
  80192e:	c9                   	leaveq 
  80192f:	c3                   	retq   

0000000000801930 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801930:	55                   	push   %rbp
  801931:	48 89 e5             	mov    %rsp,%rbp
  801934:	48 83 ec 10          	sub    $0x10,%rsp
  801938:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80193b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80193f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801942:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801945:	48 63 c8             	movslq %eax,%rcx
  801948:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80194c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80194f:	48 98                	cltq   
  801951:	48 83 ec 08          	sub    $0x8,%rsp
  801955:	6a 00                	pushq  $0x0
  801957:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80195d:	49 89 c8             	mov    %rcx,%r8
  801960:	48 89 d1             	mov    %rdx,%rcx
  801963:	48 89 c2             	mov    %rax,%rdx
  801966:	be 01 00 00 00       	mov    $0x1,%esi
  80196b:	bf 04 00 00 00       	mov    $0x4,%edi
  801970:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  801977:	00 00 00 
  80197a:	ff d0                	callq  *%rax
  80197c:	48 83 c4 10          	add    $0x10,%rsp
}
  801980:	c9                   	leaveq 
  801981:	c3                   	retq   

0000000000801982 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801982:	55                   	push   %rbp
  801983:	48 89 e5             	mov    %rsp,%rbp
  801986:	48 83 ec 20          	sub    $0x20,%rsp
  80198a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80198d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801991:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801994:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801998:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80199c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80199f:	48 63 c8             	movslq %eax,%rcx
  8019a2:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019a9:	48 63 f0             	movslq %eax,%rsi
  8019ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b3:	48 98                	cltq   
  8019b5:	48 83 ec 08          	sub    $0x8,%rsp
  8019b9:	51                   	push   %rcx
  8019ba:	49 89 f9             	mov    %rdi,%r9
  8019bd:	49 89 f0             	mov    %rsi,%r8
  8019c0:	48 89 d1             	mov    %rdx,%rcx
  8019c3:	48 89 c2             	mov    %rax,%rdx
  8019c6:	be 01 00 00 00       	mov    $0x1,%esi
  8019cb:	bf 05 00 00 00       	mov    $0x5,%edi
  8019d0:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  8019d7:	00 00 00 
  8019da:	ff d0                	callq  *%rax
  8019dc:	48 83 c4 10          	add    $0x10,%rsp
}
  8019e0:	c9                   	leaveq 
  8019e1:	c3                   	retq   

00000000008019e2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8019e2:	55                   	push   %rbp
  8019e3:	48 89 e5             	mov    %rsp,%rbp
  8019e6:	48 83 ec 10          	sub    $0x10,%rsp
  8019ea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8019f1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019f8:	48 98                	cltq   
  8019fa:	48 83 ec 08          	sub    $0x8,%rsp
  8019fe:	6a 00                	pushq  $0x0
  801a00:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a06:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a0c:	48 89 d1             	mov    %rdx,%rcx
  801a0f:	48 89 c2             	mov    %rax,%rdx
  801a12:	be 01 00 00 00       	mov    $0x1,%esi
  801a17:	bf 06 00 00 00       	mov    $0x6,%edi
  801a1c:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  801a23:	00 00 00 
  801a26:	ff d0                	callq  *%rax
  801a28:	48 83 c4 10          	add    $0x10,%rsp
}
  801a2c:	c9                   	leaveq 
  801a2d:	c3                   	retq   

0000000000801a2e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a2e:	55                   	push   %rbp
  801a2f:	48 89 e5             	mov    %rsp,%rbp
  801a32:	48 83 ec 10          	sub    $0x10,%rsp
  801a36:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a39:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a3c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a3f:	48 63 d0             	movslq %eax,%rdx
  801a42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a45:	48 98                	cltq   
  801a47:	48 83 ec 08          	sub    $0x8,%rsp
  801a4b:	6a 00                	pushq  $0x0
  801a4d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a53:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a59:	48 89 d1             	mov    %rdx,%rcx
  801a5c:	48 89 c2             	mov    %rax,%rdx
  801a5f:	be 01 00 00 00       	mov    $0x1,%esi
  801a64:	bf 08 00 00 00       	mov    $0x8,%edi
  801a69:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  801a70:	00 00 00 
  801a73:	ff d0                	callq  *%rax
  801a75:	48 83 c4 10          	add    $0x10,%rsp
}
  801a79:	c9                   	leaveq 
  801a7a:	c3                   	retq   

0000000000801a7b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801a7b:	55                   	push   %rbp
  801a7c:	48 89 e5             	mov    %rsp,%rbp
  801a7f:	48 83 ec 10          	sub    $0x10,%rsp
  801a83:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a86:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801a8a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a91:	48 98                	cltq   
  801a93:	48 83 ec 08          	sub    $0x8,%rsp
  801a97:	6a 00                	pushq  $0x0
  801a99:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a9f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aa5:	48 89 d1             	mov    %rdx,%rcx
  801aa8:	48 89 c2             	mov    %rax,%rdx
  801aab:	be 01 00 00 00       	mov    $0x1,%esi
  801ab0:	bf 09 00 00 00       	mov    $0x9,%edi
  801ab5:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  801abc:	00 00 00 
  801abf:	ff d0                	callq  *%rax
  801ac1:	48 83 c4 10          	add    $0x10,%rsp
}
  801ac5:	c9                   	leaveq 
  801ac6:	c3                   	retq   

0000000000801ac7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ac7:	55                   	push   %rbp
  801ac8:	48 89 e5             	mov    %rsp,%rbp
  801acb:	48 83 ec 10          	sub    $0x10,%rsp
  801acf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ad2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ad6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ada:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801add:	48 98                	cltq   
  801adf:	48 83 ec 08          	sub    $0x8,%rsp
  801ae3:	6a 00                	pushq  $0x0
  801ae5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aeb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af1:	48 89 d1             	mov    %rdx,%rcx
  801af4:	48 89 c2             	mov    %rax,%rdx
  801af7:	be 01 00 00 00       	mov    $0x1,%esi
  801afc:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b01:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  801b08:	00 00 00 
  801b0b:	ff d0                	callq  *%rax
  801b0d:	48 83 c4 10          	add    $0x10,%rsp
}
  801b11:	c9                   	leaveq 
  801b12:	c3                   	retq   

0000000000801b13 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b13:	55                   	push   %rbp
  801b14:	48 89 e5             	mov    %rsp,%rbp
  801b17:	48 83 ec 20          	sub    $0x20,%rsp
  801b1b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b1e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b22:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b26:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b29:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b2c:	48 63 f0             	movslq %eax,%rsi
  801b2f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b36:	48 98                	cltq   
  801b38:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b3c:	48 83 ec 08          	sub    $0x8,%rsp
  801b40:	6a 00                	pushq  $0x0
  801b42:	49 89 f1             	mov    %rsi,%r9
  801b45:	49 89 c8             	mov    %rcx,%r8
  801b48:	48 89 d1             	mov    %rdx,%rcx
  801b4b:	48 89 c2             	mov    %rax,%rdx
  801b4e:	be 00 00 00 00       	mov    $0x0,%esi
  801b53:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b58:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  801b5f:	00 00 00 
  801b62:	ff d0                	callq  *%rax
  801b64:	48 83 c4 10          	add    $0x10,%rsp
}
  801b68:	c9                   	leaveq 
  801b69:	c3                   	retq   

0000000000801b6a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b6a:	55                   	push   %rbp
  801b6b:	48 89 e5             	mov    %rsp,%rbp
  801b6e:	48 83 ec 10          	sub    $0x10,%rsp
  801b72:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b7a:	48 83 ec 08          	sub    $0x8,%rsp
  801b7e:	6a 00                	pushq  $0x0
  801b80:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b86:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b91:	48 89 c2             	mov    %rax,%rdx
  801b94:	be 01 00 00 00       	mov    $0x1,%esi
  801b99:	bf 0d 00 00 00       	mov    $0xd,%edi
  801b9e:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  801ba5:	00 00 00 
  801ba8:	ff d0                	callq  *%rax
  801baa:	48 83 c4 10          	add    $0x10,%rsp
}
  801bae:	c9                   	leaveq 
  801baf:	c3                   	retq   

0000000000801bb0 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801bb0:	55                   	push   %rbp
  801bb1:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801bb4:	48 83 ec 08          	sub    $0x8,%rsp
  801bb8:	6a 00                	pushq  $0x0
  801bba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bc6:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bcb:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd0:	be 00 00 00 00       	mov    $0x0,%esi
  801bd5:	bf 0e 00 00 00       	mov    $0xe,%edi
  801bda:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  801be1:	00 00 00 
  801be4:	ff d0                	callq  *%rax
  801be6:	48 83 c4 10          	add    $0x10,%rsp
}
  801bea:	c9                   	leaveq 
  801beb:	c3                   	retq   

0000000000801bec <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801bec:	55                   	push   %rbp
  801bed:	48 89 e5             	mov    %rsp,%rbp
  801bf0:	48 83 ec 20          	sub    $0x20,%rsp
  801bf4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bf7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bfb:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801bfe:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801c02:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801c06:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c09:	48 63 c8             	movslq %eax,%rcx
  801c0c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c10:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c13:	48 63 f0             	movslq %eax,%rsi
  801c16:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c1d:	48 98                	cltq   
  801c1f:	48 83 ec 08          	sub    $0x8,%rsp
  801c23:	51                   	push   %rcx
  801c24:	49 89 f9             	mov    %rdi,%r9
  801c27:	49 89 f0             	mov    %rsi,%r8
  801c2a:	48 89 d1             	mov    %rdx,%rcx
  801c2d:	48 89 c2             	mov    %rax,%rdx
  801c30:	be 00 00 00 00       	mov    $0x0,%esi
  801c35:	bf 0f 00 00 00       	mov    $0xf,%edi
  801c3a:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  801c41:	00 00 00 
  801c44:	ff d0                	callq  *%rax
  801c46:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801c4a:	c9                   	leaveq 
  801c4b:	c3                   	retq   

0000000000801c4c <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801c4c:	55                   	push   %rbp
  801c4d:	48 89 e5             	mov    %rsp,%rbp
  801c50:	48 83 ec 10          	sub    $0x10,%rsp
  801c54:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c58:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801c5c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c64:	48 83 ec 08          	sub    $0x8,%rsp
  801c68:	6a 00                	pushq  $0x0
  801c6a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c70:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c76:	48 89 d1             	mov    %rdx,%rcx
  801c79:	48 89 c2             	mov    %rax,%rdx
  801c7c:	be 00 00 00 00       	mov    $0x0,%esi
  801c81:	bf 10 00 00 00       	mov    $0x10,%edi
  801c86:	48 b8 5c 17 80 00 00 	movabs $0x80175c,%rax
  801c8d:	00 00 00 
  801c90:	ff d0                	callq  *%rax
  801c92:	48 83 c4 10          	add    $0x10,%rsp
}
  801c96:	c9                   	leaveq 
  801c97:	c3                   	retq   

0000000000801c98 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801c98:	55                   	push   %rbp
  801c99:	48 89 e5             	mov    %rsp,%rbp
  801c9c:	48 83 ec 08          	sub    $0x8,%rsp
  801ca0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ca4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ca8:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801caf:	ff ff ff 
  801cb2:	48 01 d0             	add    %rdx,%rax
  801cb5:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801cb9:	c9                   	leaveq 
  801cba:	c3                   	retq   

0000000000801cbb <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801cbb:	55                   	push   %rbp
  801cbc:	48 89 e5             	mov    %rsp,%rbp
  801cbf:	48 83 ec 08          	sub    $0x8,%rsp
  801cc3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801cc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ccb:	48 89 c7             	mov    %rax,%rdi
  801cce:	48 b8 98 1c 80 00 00 	movabs $0x801c98,%rax
  801cd5:	00 00 00 
  801cd8:	ff d0                	callq  *%rax
  801cda:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801ce0:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ce4:	c9                   	leaveq 
  801ce5:	c3                   	retq   

0000000000801ce6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ce6:	55                   	push   %rbp
  801ce7:	48 89 e5             	mov    %rsp,%rbp
  801cea:	48 83 ec 18          	sub    $0x18,%rsp
  801cee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801cf2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801cf9:	eb 6b                	jmp    801d66 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801cfb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cfe:	48 98                	cltq   
  801d00:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d06:	48 c1 e0 0c          	shl    $0xc,%rax
  801d0a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d12:	48 c1 e8 15          	shr    $0x15,%rax
  801d16:	48 89 c2             	mov    %rax,%rdx
  801d19:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d20:	01 00 00 
  801d23:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d27:	83 e0 01             	and    $0x1,%eax
  801d2a:	48 85 c0             	test   %rax,%rax
  801d2d:	74 21                	je     801d50 <fd_alloc+0x6a>
  801d2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d33:	48 c1 e8 0c          	shr    $0xc,%rax
  801d37:	48 89 c2             	mov    %rax,%rdx
  801d3a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d41:	01 00 00 
  801d44:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d48:	83 e0 01             	and    $0x1,%eax
  801d4b:	48 85 c0             	test   %rax,%rax
  801d4e:	75 12                	jne    801d62 <fd_alloc+0x7c>
			*fd_store = fd;
  801d50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d54:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d58:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801d5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d60:	eb 1a                	jmp    801d7c <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  801d62:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d66:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801d6a:	7e 8f                	jle    801cfb <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  801d6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d70:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801d77:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801d7c:	c9                   	leaveq 
  801d7d:	c3                   	retq   

0000000000801d7e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d7e:	55                   	push   %rbp
  801d7f:	48 89 e5             	mov    %rsp,%rbp
  801d82:	48 83 ec 20          	sub    $0x20,%rsp
  801d86:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d89:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801d8d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d91:	78 06                	js     801d99 <fd_lookup+0x1b>
  801d93:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801d97:	7e 07                	jle    801da0 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d99:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d9e:	eb 6c                	jmp    801e0c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801da0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801da3:	48 98                	cltq   
  801da5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801dab:	48 c1 e0 0c          	shl    $0xc,%rax
  801daf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801db3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801db7:	48 c1 e8 15          	shr    $0x15,%rax
  801dbb:	48 89 c2             	mov    %rax,%rdx
  801dbe:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801dc5:	01 00 00 
  801dc8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dcc:	83 e0 01             	and    $0x1,%eax
  801dcf:	48 85 c0             	test   %rax,%rax
  801dd2:	74 21                	je     801df5 <fd_lookup+0x77>
  801dd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dd8:	48 c1 e8 0c          	shr    $0xc,%rax
  801ddc:	48 89 c2             	mov    %rax,%rdx
  801ddf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801de6:	01 00 00 
  801de9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ded:	83 e0 01             	and    $0x1,%eax
  801df0:	48 85 c0             	test   %rax,%rax
  801df3:	75 07                	jne    801dfc <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801df5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801dfa:	eb 10                	jmp    801e0c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801dfc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e00:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e04:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e0c:	c9                   	leaveq 
  801e0d:	c3                   	retq   

0000000000801e0e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e0e:	55                   	push   %rbp
  801e0f:	48 89 e5             	mov    %rsp,%rbp
  801e12:	48 83 ec 30          	sub    $0x30,%rsp
  801e16:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e1a:	89 f0                	mov    %esi,%eax
  801e1c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e1f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e23:	48 89 c7             	mov    %rax,%rdi
  801e26:	48 b8 98 1c 80 00 00 	movabs $0x801c98,%rax
  801e2d:	00 00 00 
  801e30:	ff d0                	callq  *%rax
  801e32:	89 c2                	mov    %eax,%edx
  801e34:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801e38:	48 89 c6             	mov    %rax,%rsi
  801e3b:	89 d7                	mov    %edx,%edi
  801e3d:	48 b8 7e 1d 80 00 00 	movabs $0x801d7e,%rax
  801e44:	00 00 00 
  801e47:	ff d0                	callq  *%rax
  801e49:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e50:	78 0a                	js     801e5c <fd_close+0x4e>
	    || fd != fd2)
  801e52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e56:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801e5a:	74 12                	je     801e6e <fd_close+0x60>
		return (must_exist ? r : 0);
  801e5c:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801e60:	74 05                	je     801e67 <fd_close+0x59>
  801e62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e65:	eb 70                	jmp    801ed7 <fd_close+0xc9>
  801e67:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6c:	eb 69                	jmp    801ed7 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801e6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e72:	8b 00                	mov    (%rax),%eax
  801e74:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e78:	48 89 d6             	mov    %rdx,%rsi
  801e7b:	89 c7                	mov    %eax,%edi
  801e7d:	48 b8 d9 1e 80 00 00 	movabs $0x801ed9,%rax
  801e84:	00 00 00 
  801e87:	ff d0                	callq  *%rax
  801e89:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e90:	78 2a                	js     801ebc <fd_close+0xae>
		if (dev->dev_close)
  801e92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e96:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e9a:	48 85 c0             	test   %rax,%rax
  801e9d:	74 16                	je     801eb5 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  801e9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ea3:	48 8b 40 20          	mov    0x20(%rax),%rax
  801ea7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801eab:	48 89 d7             	mov    %rdx,%rdi
  801eae:	ff d0                	callq  *%rax
  801eb0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801eb3:	eb 07                	jmp    801ebc <fd_close+0xae>
		else
			r = 0;
  801eb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801ebc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ec0:	48 89 c6             	mov    %rax,%rsi
  801ec3:	bf 00 00 00 00       	mov    $0x0,%edi
  801ec8:	48 b8 e2 19 80 00 00 	movabs $0x8019e2,%rax
  801ecf:	00 00 00 
  801ed2:	ff d0                	callq  *%rax
	return r;
  801ed4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801ed7:	c9                   	leaveq 
  801ed8:	c3                   	retq   

0000000000801ed9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801ed9:	55                   	push   %rbp
  801eda:	48 89 e5             	mov    %rsp,%rbp
  801edd:	48 83 ec 20          	sub    $0x20,%rsp
  801ee1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ee4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801ee8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801eef:	eb 41                	jmp    801f32 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801ef1:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801ef8:	00 00 00 
  801efb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801efe:	48 63 d2             	movslq %edx,%rdx
  801f01:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f05:	8b 00                	mov    (%rax),%eax
  801f07:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f0a:	75 22                	jne    801f2e <dev_lookup+0x55>
			*dev = devtab[i];
  801f0c:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f13:	00 00 00 
  801f16:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f19:	48 63 d2             	movslq %edx,%rdx
  801f1c:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f20:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f24:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f27:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2c:	eb 60                	jmp    801f8e <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  801f2e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f32:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f39:	00 00 00 
  801f3c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f3f:	48 63 d2             	movslq %edx,%rdx
  801f42:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f46:	48 85 c0             	test   %rax,%rax
  801f49:	75 a6                	jne    801ef1 <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801f4b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801f52:	00 00 00 
  801f55:	48 8b 00             	mov    (%rax),%rax
  801f58:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801f5e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f61:	89 c6                	mov    %eax,%esi
  801f63:	48 bf b8 43 80 00 00 	movabs $0x8043b8,%rdi
  801f6a:	00 00 00 
  801f6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f72:	48 b9 69 04 80 00 00 	movabs $0x800469,%rcx
  801f79:	00 00 00 
  801f7c:	ff d1                	callq  *%rcx
	*dev = 0;
  801f7e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f82:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801f89:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801f8e:	c9                   	leaveq 
  801f8f:	c3                   	retq   

0000000000801f90 <close>:

int
close(int fdnum)
{
  801f90:	55                   	push   %rbp
  801f91:	48 89 e5             	mov    %rsp,%rbp
  801f94:	48 83 ec 20          	sub    $0x20,%rsp
  801f98:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f9b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f9f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fa2:	48 89 d6             	mov    %rdx,%rsi
  801fa5:	89 c7                	mov    %eax,%edi
  801fa7:	48 b8 7e 1d 80 00 00 	movabs $0x801d7e,%rax
  801fae:	00 00 00 
  801fb1:	ff d0                	callq  *%rax
  801fb3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fb6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fba:	79 05                	jns    801fc1 <close+0x31>
		return r;
  801fbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fbf:	eb 18                	jmp    801fd9 <close+0x49>
	else
		return fd_close(fd, 1);
  801fc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fc5:	be 01 00 00 00       	mov    $0x1,%esi
  801fca:	48 89 c7             	mov    %rax,%rdi
  801fcd:	48 b8 0e 1e 80 00 00 	movabs $0x801e0e,%rax
  801fd4:	00 00 00 
  801fd7:	ff d0                	callq  *%rax
}
  801fd9:	c9                   	leaveq 
  801fda:	c3                   	retq   

0000000000801fdb <close_all>:

void
close_all(void)
{
  801fdb:	55                   	push   %rbp
  801fdc:	48 89 e5             	mov    %rsp,%rbp
  801fdf:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801fe3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fea:	eb 15                	jmp    802001 <close_all+0x26>
		close(i);
  801fec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fef:	89 c7                	mov    %eax,%edi
  801ff1:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  801ff8:	00 00 00 
  801ffb:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  801ffd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802001:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802005:	7e e5                	jle    801fec <close_all+0x11>
}
  802007:	c9                   	leaveq 
  802008:	c3                   	retq   

0000000000802009 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802009:	55                   	push   %rbp
  80200a:	48 89 e5             	mov    %rsp,%rbp
  80200d:	48 83 ec 40          	sub    $0x40,%rsp
  802011:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802014:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802017:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80201b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80201e:	48 89 d6             	mov    %rdx,%rsi
  802021:	89 c7                	mov    %eax,%edi
  802023:	48 b8 7e 1d 80 00 00 	movabs $0x801d7e,%rax
  80202a:	00 00 00 
  80202d:	ff d0                	callq  *%rax
  80202f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802032:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802036:	79 08                	jns    802040 <dup+0x37>
		return r;
  802038:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80203b:	e9 70 01 00 00       	jmpq   8021b0 <dup+0x1a7>
	close(newfdnum);
  802040:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802043:	89 c7                	mov    %eax,%edi
  802045:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  80204c:	00 00 00 
  80204f:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802051:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802054:	48 98                	cltq   
  802056:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80205c:	48 c1 e0 0c          	shl    $0xc,%rax
  802060:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802064:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802068:	48 89 c7             	mov    %rax,%rdi
  80206b:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  802072:	00 00 00 
  802075:	ff d0                	callq  *%rax
  802077:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80207b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80207f:	48 89 c7             	mov    %rax,%rdi
  802082:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  802089:	00 00 00 
  80208c:	ff d0                	callq  *%rax
  80208e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802092:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802096:	48 c1 e8 15          	shr    $0x15,%rax
  80209a:	48 89 c2             	mov    %rax,%rdx
  80209d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020a4:	01 00 00 
  8020a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020ab:	83 e0 01             	and    $0x1,%eax
  8020ae:	48 85 c0             	test   %rax,%rax
  8020b1:	74 73                	je     802126 <dup+0x11d>
  8020b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020b7:	48 c1 e8 0c          	shr    $0xc,%rax
  8020bb:	48 89 c2             	mov    %rax,%rdx
  8020be:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020c5:	01 00 00 
  8020c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020cc:	83 e0 01             	and    $0x1,%eax
  8020cf:	48 85 c0             	test   %rax,%rax
  8020d2:	74 52                	je     802126 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8020d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020d8:	48 c1 e8 0c          	shr    $0xc,%rax
  8020dc:	48 89 c2             	mov    %rax,%rdx
  8020df:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020e6:	01 00 00 
  8020e9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020ed:	25 07 0e 00 00       	and    $0xe07,%eax
  8020f2:	89 c1                	mov    %eax,%ecx
  8020f4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8020f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020fc:	41 89 c8             	mov    %ecx,%r8d
  8020ff:	48 89 d1             	mov    %rdx,%rcx
  802102:	ba 00 00 00 00       	mov    $0x0,%edx
  802107:	48 89 c6             	mov    %rax,%rsi
  80210a:	bf 00 00 00 00       	mov    $0x0,%edi
  80210f:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  802116:	00 00 00 
  802119:	ff d0                	callq  *%rax
  80211b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80211e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802122:	79 02                	jns    802126 <dup+0x11d>
			goto err;
  802124:	eb 57                	jmp    80217d <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802126:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80212a:	48 c1 e8 0c          	shr    $0xc,%rax
  80212e:	48 89 c2             	mov    %rax,%rdx
  802131:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802138:	01 00 00 
  80213b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80213f:	25 07 0e 00 00       	and    $0xe07,%eax
  802144:	89 c1                	mov    %eax,%ecx
  802146:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80214a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80214e:	41 89 c8             	mov    %ecx,%r8d
  802151:	48 89 d1             	mov    %rdx,%rcx
  802154:	ba 00 00 00 00       	mov    $0x0,%edx
  802159:	48 89 c6             	mov    %rax,%rsi
  80215c:	bf 00 00 00 00       	mov    $0x0,%edi
  802161:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  802168:	00 00 00 
  80216b:	ff d0                	callq  *%rax
  80216d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802170:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802174:	79 02                	jns    802178 <dup+0x16f>
		goto err;
  802176:	eb 05                	jmp    80217d <dup+0x174>

	return newfdnum;
  802178:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80217b:	eb 33                	jmp    8021b0 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80217d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802181:	48 89 c6             	mov    %rax,%rsi
  802184:	bf 00 00 00 00       	mov    $0x0,%edi
  802189:	48 b8 e2 19 80 00 00 	movabs $0x8019e2,%rax
  802190:	00 00 00 
  802193:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802195:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802199:	48 89 c6             	mov    %rax,%rsi
  80219c:	bf 00 00 00 00       	mov    $0x0,%edi
  8021a1:	48 b8 e2 19 80 00 00 	movabs $0x8019e2,%rax
  8021a8:	00 00 00 
  8021ab:	ff d0                	callq  *%rax
	return r;
  8021ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8021b0:	c9                   	leaveq 
  8021b1:	c3                   	retq   

00000000008021b2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8021b2:	55                   	push   %rbp
  8021b3:	48 89 e5             	mov    %rsp,%rbp
  8021b6:	48 83 ec 40          	sub    $0x40,%rsp
  8021ba:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8021bd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8021c1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021c5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021c9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021cc:	48 89 d6             	mov    %rdx,%rsi
  8021cf:	89 c7                	mov    %eax,%edi
  8021d1:	48 b8 7e 1d 80 00 00 	movabs $0x801d7e,%rax
  8021d8:	00 00 00 
  8021db:	ff d0                	callq  *%rax
  8021dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021e4:	78 24                	js     80220a <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ea:	8b 00                	mov    (%rax),%eax
  8021ec:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021f0:	48 89 d6             	mov    %rdx,%rsi
  8021f3:	89 c7                	mov    %eax,%edi
  8021f5:	48 b8 d9 1e 80 00 00 	movabs $0x801ed9,%rax
  8021fc:	00 00 00 
  8021ff:	ff d0                	callq  *%rax
  802201:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802204:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802208:	79 05                	jns    80220f <read+0x5d>
		return r;
  80220a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80220d:	eb 76                	jmp    802285 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80220f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802213:	8b 40 08             	mov    0x8(%rax),%eax
  802216:	83 e0 03             	and    $0x3,%eax
  802219:	83 f8 01             	cmp    $0x1,%eax
  80221c:	75 3a                	jne    802258 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80221e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802225:	00 00 00 
  802228:	48 8b 00             	mov    (%rax),%rax
  80222b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802231:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802234:	89 c6                	mov    %eax,%esi
  802236:	48 bf d7 43 80 00 00 	movabs $0x8043d7,%rdi
  80223d:	00 00 00 
  802240:	b8 00 00 00 00       	mov    $0x0,%eax
  802245:	48 b9 69 04 80 00 00 	movabs $0x800469,%rcx
  80224c:	00 00 00 
  80224f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802251:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802256:	eb 2d                	jmp    802285 <read+0xd3>
	}
	if (!dev->dev_read)
  802258:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80225c:	48 8b 40 10          	mov    0x10(%rax),%rax
  802260:	48 85 c0             	test   %rax,%rax
  802263:	75 07                	jne    80226c <read+0xba>
		return -E_NOT_SUPP;
  802265:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80226a:	eb 19                	jmp    802285 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80226c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802270:	48 8b 40 10          	mov    0x10(%rax),%rax
  802274:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802278:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80227c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802280:	48 89 cf             	mov    %rcx,%rdi
  802283:	ff d0                	callq  *%rax
}
  802285:	c9                   	leaveq 
  802286:	c3                   	retq   

0000000000802287 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802287:	55                   	push   %rbp
  802288:	48 89 e5             	mov    %rsp,%rbp
  80228b:	48 83 ec 30          	sub    $0x30,%rsp
  80228f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802292:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802296:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80229a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022a1:	eb 49                	jmp    8022ec <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8022a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022a6:	48 98                	cltq   
  8022a8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8022ac:	48 29 c2             	sub    %rax,%rdx
  8022af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022b2:	48 63 c8             	movslq %eax,%rcx
  8022b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022b9:	48 01 c1             	add    %rax,%rcx
  8022bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022bf:	48 89 ce             	mov    %rcx,%rsi
  8022c2:	89 c7                	mov    %eax,%edi
  8022c4:	48 b8 b2 21 80 00 00 	movabs $0x8021b2,%rax
  8022cb:	00 00 00 
  8022ce:	ff d0                	callq  *%rax
  8022d0:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8022d3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022d7:	79 05                	jns    8022de <readn+0x57>
			return m;
  8022d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022dc:	eb 1c                	jmp    8022fa <readn+0x73>
		if (m == 0)
  8022de:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022e2:	75 02                	jne    8022e6 <readn+0x5f>
			break;
  8022e4:	eb 11                	jmp    8022f7 <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  8022e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022e9:	01 45 fc             	add    %eax,-0x4(%rbp)
  8022ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022ef:	48 98                	cltq   
  8022f1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8022f5:	72 ac                	jb     8022a3 <readn+0x1c>
	}
	return tot;
  8022f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022fa:	c9                   	leaveq 
  8022fb:	c3                   	retq   

00000000008022fc <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8022fc:	55                   	push   %rbp
  8022fd:	48 89 e5             	mov    %rsp,%rbp
  802300:	48 83 ec 40          	sub    $0x40,%rsp
  802304:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802307:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80230b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80230f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802313:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802316:	48 89 d6             	mov    %rdx,%rsi
  802319:	89 c7                	mov    %eax,%edi
  80231b:	48 b8 7e 1d 80 00 00 	movabs $0x801d7e,%rax
  802322:	00 00 00 
  802325:	ff d0                	callq  *%rax
  802327:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80232a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80232e:	78 24                	js     802354 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802330:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802334:	8b 00                	mov    (%rax),%eax
  802336:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80233a:	48 89 d6             	mov    %rdx,%rsi
  80233d:	89 c7                	mov    %eax,%edi
  80233f:	48 b8 d9 1e 80 00 00 	movabs $0x801ed9,%rax
  802346:	00 00 00 
  802349:	ff d0                	callq  *%rax
  80234b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80234e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802352:	79 05                	jns    802359 <write+0x5d>
		return r;
  802354:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802357:	eb 75                	jmp    8023ce <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802359:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80235d:	8b 40 08             	mov    0x8(%rax),%eax
  802360:	83 e0 03             	and    $0x3,%eax
  802363:	85 c0                	test   %eax,%eax
  802365:	75 3a                	jne    8023a1 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802367:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80236e:	00 00 00 
  802371:	48 8b 00             	mov    (%rax),%rax
  802374:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80237a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80237d:	89 c6                	mov    %eax,%esi
  80237f:	48 bf f3 43 80 00 00 	movabs $0x8043f3,%rdi
  802386:	00 00 00 
  802389:	b8 00 00 00 00       	mov    $0x0,%eax
  80238e:	48 b9 69 04 80 00 00 	movabs $0x800469,%rcx
  802395:	00 00 00 
  802398:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80239a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80239f:	eb 2d                	jmp    8023ce <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8023a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023a5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023a9:	48 85 c0             	test   %rax,%rax
  8023ac:	75 07                	jne    8023b5 <write+0xb9>
		return -E_NOT_SUPP;
  8023ae:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023b3:	eb 19                	jmp    8023ce <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8023b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023b9:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023bd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023c1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023c5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023c9:	48 89 cf             	mov    %rcx,%rdi
  8023cc:	ff d0                	callq  *%rax
}
  8023ce:	c9                   	leaveq 
  8023cf:	c3                   	retq   

00000000008023d0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8023d0:	55                   	push   %rbp
  8023d1:	48 89 e5             	mov    %rsp,%rbp
  8023d4:	48 83 ec 18          	sub    $0x18,%rsp
  8023d8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023db:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023de:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023e2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023e5:	48 89 d6             	mov    %rdx,%rsi
  8023e8:	89 c7                	mov    %eax,%edi
  8023ea:	48 b8 7e 1d 80 00 00 	movabs $0x801d7e,%rax
  8023f1:	00 00 00 
  8023f4:	ff d0                	callq  *%rax
  8023f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023fd:	79 05                	jns    802404 <seek+0x34>
		return r;
  8023ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802402:	eb 0f                	jmp    802413 <seek+0x43>
	fd->fd_offset = offset;
  802404:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802408:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80240b:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80240e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802413:	c9                   	leaveq 
  802414:	c3                   	retq   

0000000000802415 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802415:	55                   	push   %rbp
  802416:	48 89 e5             	mov    %rsp,%rbp
  802419:	48 83 ec 30          	sub    $0x30,%rsp
  80241d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802420:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802423:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802427:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80242a:	48 89 d6             	mov    %rdx,%rsi
  80242d:	89 c7                	mov    %eax,%edi
  80242f:	48 b8 7e 1d 80 00 00 	movabs $0x801d7e,%rax
  802436:	00 00 00 
  802439:	ff d0                	callq  *%rax
  80243b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80243e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802442:	78 24                	js     802468 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802444:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802448:	8b 00                	mov    (%rax),%eax
  80244a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80244e:	48 89 d6             	mov    %rdx,%rsi
  802451:	89 c7                	mov    %eax,%edi
  802453:	48 b8 d9 1e 80 00 00 	movabs $0x801ed9,%rax
  80245a:	00 00 00 
  80245d:	ff d0                	callq  *%rax
  80245f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802462:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802466:	79 05                	jns    80246d <ftruncate+0x58>
		return r;
  802468:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80246b:	eb 72                	jmp    8024df <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80246d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802471:	8b 40 08             	mov    0x8(%rax),%eax
  802474:	83 e0 03             	and    $0x3,%eax
  802477:	85 c0                	test   %eax,%eax
  802479:	75 3a                	jne    8024b5 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80247b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802482:	00 00 00 
  802485:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802488:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80248e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802491:	89 c6                	mov    %eax,%esi
  802493:	48 bf 10 44 80 00 00 	movabs $0x804410,%rdi
  80249a:	00 00 00 
  80249d:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a2:	48 b9 69 04 80 00 00 	movabs $0x800469,%rcx
  8024a9:	00 00 00 
  8024ac:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024b3:	eb 2a                	jmp    8024df <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8024b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b9:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024bd:	48 85 c0             	test   %rax,%rax
  8024c0:	75 07                	jne    8024c9 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8024c2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024c7:	eb 16                	jmp    8024df <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8024c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024cd:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8024d5:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8024d8:	89 ce                	mov    %ecx,%esi
  8024da:	48 89 d7             	mov    %rdx,%rdi
  8024dd:	ff d0                	callq  *%rax
}
  8024df:	c9                   	leaveq 
  8024e0:	c3                   	retq   

00000000008024e1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8024e1:	55                   	push   %rbp
  8024e2:	48 89 e5             	mov    %rsp,%rbp
  8024e5:	48 83 ec 30          	sub    $0x30,%rsp
  8024e9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024ec:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024f0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024f4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024f7:	48 89 d6             	mov    %rdx,%rsi
  8024fa:	89 c7                	mov    %eax,%edi
  8024fc:	48 b8 7e 1d 80 00 00 	movabs $0x801d7e,%rax
  802503:	00 00 00 
  802506:	ff d0                	callq  *%rax
  802508:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80250b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80250f:	78 24                	js     802535 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802511:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802515:	8b 00                	mov    (%rax),%eax
  802517:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80251b:	48 89 d6             	mov    %rdx,%rsi
  80251e:	89 c7                	mov    %eax,%edi
  802520:	48 b8 d9 1e 80 00 00 	movabs $0x801ed9,%rax
  802527:	00 00 00 
  80252a:	ff d0                	callq  *%rax
  80252c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80252f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802533:	79 05                	jns    80253a <fstat+0x59>
		return r;
  802535:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802538:	eb 5e                	jmp    802598 <fstat+0xb7>
	if (!dev->dev_stat)
  80253a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80253e:	48 8b 40 28          	mov    0x28(%rax),%rax
  802542:	48 85 c0             	test   %rax,%rax
  802545:	75 07                	jne    80254e <fstat+0x6d>
		return -E_NOT_SUPP;
  802547:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80254c:	eb 4a                	jmp    802598 <fstat+0xb7>
	stat->st_name[0] = 0;
  80254e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802552:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802555:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802559:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802560:	00 00 00 
	stat->st_isdir = 0;
  802563:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802567:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80256e:	00 00 00 
	stat->st_dev = dev;
  802571:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802575:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802579:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802580:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802584:	48 8b 40 28          	mov    0x28(%rax),%rax
  802588:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80258c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802590:	48 89 ce             	mov    %rcx,%rsi
  802593:	48 89 d7             	mov    %rdx,%rdi
  802596:	ff d0                	callq  *%rax
}
  802598:	c9                   	leaveq 
  802599:	c3                   	retq   

000000000080259a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80259a:	55                   	push   %rbp
  80259b:	48 89 e5             	mov    %rsp,%rbp
  80259e:	48 83 ec 20          	sub    $0x20,%rsp
  8025a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025a6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8025aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ae:	be 00 00 00 00       	mov    $0x0,%esi
  8025b3:	48 89 c7             	mov    %rax,%rdi
  8025b6:	48 b8 8a 26 80 00 00 	movabs $0x80268a,%rax
  8025bd:	00 00 00 
  8025c0:	ff d0                	callq  *%rax
  8025c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025c9:	79 05                	jns    8025d0 <stat+0x36>
		return fd;
  8025cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ce:	eb 2f                	jmp    8025ff <stat+0x65>
	r = fstat(fd, stat);
  8025d0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8025d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d7:	48 89 d6             	mov    %rdx,%rsi
  8025da:	89 c7                	mov    %eax,%edi
  8025dc:	48 b8 e1 24 80 00 00 	movabs $0x8024e1,%rax
  8025e3:	00 00 00 
  8025e6:	ff d0                	callq  *%rax
  8025e8:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8025eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ee:	89 c7                	mov    %eax,%edi
  8025f0:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  8025f7:	00 00 00 
  8025fa:	ff d0                	callq  *%rax
	return r;
  8025fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8025ff:	c9                   	leaveq 
  802600:	c3                   	retq   

0000000000802601 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802601:	55                   	push   %rbp
  802602:	48 89 e5             	mov    %rsp,%rbp
  802605:	48 83 ec 10          	sub    $0x10,%rsp
  802609:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80260c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802610:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802617:	00 00 00 
  80261a:	8b 00                	mov    (%rax),%eax
  80261c:	85 c0                	test   %eax,%eax
  80261e:	75 1f                	jne    80263f <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802620:	bf 01 00 00 00       	mov    $0x1,%edi
  802625:	48 b8 0b 3d 80 00 00 	movabs $0x803d0b,%rax
  80262c:	00 00 00 
  80262f:	ff d0                	callq  *%rax
  802631:	89 c2                	mov    %eax,%edx
  802633:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80263a:	00 00 00 
  80263d:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80263f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802646:	00 00 00 
  802649:	8b 00                	mov    (%rax),%eax
  80264b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80264e:	b9 07 00 00 00       	mov    $0x7,%ecx
  802653:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80265a:	00 00 00 
  80265d:	89 c7                	mov    %eax,%edi
  80265f:	48 b8 7e 3b 80 00 00 	movabs $0x803b7e,%rax
  802666:	00 00 00 
  802669:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80266b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80266f:	ba 00 00 00 00       	mov    $0x0,%edx
  802674:	48 89 c6             	mov    %rax,%rsi
  802677:	bf 00 00 00 00       	mov    $0x0,%edi
  80267c:	48 b8 40 3b 80 00 00 	movabs $0x803b40,%rax
  802683:	00 00 00 
  802686:	ff d0                	callq  *%rax
}
  802688:	c9                   	leaveq 
  802689:	c3                   	retq   

000000000080268a <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80268a:	55                   	push   %rbp
  80268b:	48 89 e5             	mov    %rsp,%rbp
  80268e:	48 83 ec 10          	sub    $0x10,%rsp
  802692:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802696:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  802699:	48 ba 36 44 80 00 00 	movabs $0x804436,%rdx
  8026a0:	00 00 00 
  8026a3:	be 4c 00 00 00       	mov    $0x4c,%esi
  8026a8:	48 bf 4b 44 80 00 00 	movabs $0x80444b,%rdi
  8026af:	00 00 00 
  8026b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b7:	48 b9 30 02 80 00 00 	movabs $0x800230,%rcx
  8026be:	00 00 00 
  8026c1:	ff d1                	callq  *%rcx

00000000008026c3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8026c3:	55                   	push   %rbp
  8026c4:	48 89 e5             	mov    %rsp,%rbp
  8026c7:	48 83 ec 10          	sub    $0x10,%rsp
  8026cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8026cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026d3:	8b 50 0c             	mov    0xc(%rax),%edx
  8026d6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8026dd:	00 00 00 
  8026e0:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8026e2:	be 00 00 00 00       	mov    $0x0,%esi
  8026e7:	bf 06 00 00 00       	mov    $0x6,%edi
  8026ec:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  8026f3:	00 00 00 
  8026f6:	ff d0                	callq  *%rax
}
  8026f8:	c9                   	leaveq 
  8026f9:	c3                   	retq   

00000000008026fa <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8026fa:	55                   	push   %rbp
  8026fb:	48 89 e5             	mov    %rsp,%rbp
  8026fe:	48 83 ec 20          	sub    $0x20,%rsp
  802702:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802706:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80270a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  80270e:	48 ba 56 44 80 00 00 	movabs $0x804456,%rdx
  802715:	00 00 00 
  802718:	be 6b 00 00 00       	mov    $0x6b,%esi
  80271d:	48 bf 4b 44 80 00 00 	movabs $0x80444b,%rdi
  802724:	00 00 00 
  802727:	b8 00 00 00 00       	mov    $0x0,%eax
  80272c:	48 b9 30 02 80 00 00 	movabs $0x800230,%rcx
  802733:	00 00 00 
  802736:	ff d1                	callq  *%rcx

0000000000802738 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802738:	55                   	push   %rbp
  802739:	48 89 e5             	mov    %rsp,%rbp
  80273c:	48 83 ec 20          	sub    $0x20,%rsp
  802740:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802744:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802748:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  80274c:	48 ba 73 44 80 00 00 	movabs $0x804473,%rdx
  802753:	00 00 00 
  802756:	be 7b 00 00 00       	mov    $0x7b,%esi
  80275b:	48 bf 4b 44 80 00 00 	movabs $0x80444b,%rdi
  802762:	00 00 00 
  802765:	b8 00 00 00 00       	mov    $0x0,%eax
  80276a:	48 b9 30 02 80 00 00 	movabs $0x800230,%rcx
  802771:	00 00 00 
  802774:	ff d1                	callq  *%rcx

0000000000802776 <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802776:	55                   	push   %rbp
  802777:	48 89 e5             	mov    %rsp,%rbp
  80277a:	48 83 ec 20          	sub    $0x20,%rsp
  80277e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802782:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802786:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80278a:	8b 50 0c             	mov    0xc(%rax),%edx
  80278d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802794:	00 00 00 
  802797:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802799:	be 00 00 00 00       	mov    $0x0,%esi
  80279e:	bf 05 00 00 00       	mov    $0x5,%edi
  8027a3:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  8027aa:	00 00 00 
  8027ad:	ff d0                	callq  *%rax
  8027af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027b6:	79 05                	jns    8027bd <devfile_stat+0x47>
		return r;
  8027b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027bb:	eb 56                	jmp    802813 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8027bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027c1:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8027c8:	00 00 00 
  8027cb:	48 89 c7             	mov    %rax,%rdi
  8027ce:	48 b8 03 10 80 00 00 	movabs $0x801003,%rax
  8027d5:	00 00 00 
  8027d8:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8027da:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027e1:	00 00 00 
  8027e4:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8027ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027ee:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8027f4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027fb:	00 00 00 
  8027fe:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802804:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802808:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80280e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802813:	c9                   	leaveq 
  802814:	c3                   	retq   

0000000000802815 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802815:	55                   	push   %rbp
  802816:	48 89 e5             	mov    %rsp,%rbp
  802819:	48 83 ec 10          	sub    $0x10,%rsp
  80281d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802821:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802824:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802828:	8b 50 0c             	mov    0xc(%rax),%edx
  80282b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802832:	00 00 00 
  802835:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802837:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80283e:	00 00 00 
  802841:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802844:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802847:	be 00 00 00 00       	mov    $0x0,%esi
  80284c:	bf 02 00 00 00       	mov    $0x2,%edi
  802851:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  802858:	00 00 00 
  80285b:	ff d0                	callq  *%rax
}
  80285d:	c9                   	leaveq 
  80285e:	c3                   	retq   

000000000080285f <remove>:

// Delete a file
int
remove(const char *path)
{
  80285f:	55                   	push   %rbp
  802860:	48 89 e5             	mov    %rsp,%rbp
  802863:	48 83 ec 10          	sub    $0x10,%rsp
  802867:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80286b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80286f:	48 89 c7             	mov    %rax,%rdi
  802872:	48 b8 97 0f 80 00 00 	movabs $0x800f97,%rax
  802879:	00 00 00 
  80287c:	ff d0                	callq  *%rax
  80287e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802883:	7e 07                	jle    80288c <remove+0x2d>
		return -E_BAD_PATH;
  802885:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80288a:	eb 33                	jmp    8028bf <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80288c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802890:	48 89 c6             	mov    %rax,%rsi
  802893:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80289a:	00 00 00 
  80289d:	48 b8 03 10 80 00 00 	movabs $0x801003,%rax
  8028a4:	00 00 00 
  8028a7:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8028a9:	be 00 00 00 00       	mov    $0x0,%esi
  8028ae:	bf 07 00 00 00       	mov    $0x7,%edi
  8028b3:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  8028ba:	00 00 00 
  8028bd:	ff d0                	callq  *%rax
}
  8028bf:	c9                   	leaveq 
  8028c0:	c3                   	retq   

00000000008028c1 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8028c1:	55                   	push   %rbp
  8028c2:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8028c5:	be 00 00 00 00       	mov    $0x0,%esi
  8028ca:	bf 08 00 00 00       	mov    $0x8,%edi
  8028cf:	48 b8 01 26 80 00 00 	movabs $0x802601,%rax
  8028d6:	00 00 00 
  8028d9:	ff d0                	callq  *%rax
}
  8028db:	5d                   	pop    %rbp
  8028dc:	c3                   	retq   

00000000008028dd <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8028dd:	55                   	push   %rbp
  8028de:	48 89 e5             	mov    %rsp,%rbp
  8028e1:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8028e8:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8028ef:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8028f6:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8028fd:	be 00 00 00 00       	mov    $0x0,%esi
  802902:	48 89 c7             	mov    %rax,%rdi
  802905:	48 b8 8a 26 80 00 00 	movabs $0x80268a,%rax
  80290c:	00 00 00 
  80290f:	ff d0                	callq  *%rax
  802911:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802914:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802918:	79 28                	jns    802942 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80291a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80291d:	89 c6                	mov    %eax,%esi
  80291f:	48 bf 91 44 80 00 00 	movabs $0x804491,%rdi
  802926:	00 00 00 
  802929:	b8 00 00 00 00       	mov    $0x0,%eax
  80292e:	48 ba 69 04 80 00 00 	movabs $0x800469,%rdx
  802935:	00 00 00 
  802938:	ff d2                	callq  *%rdx
		return fd_src;
  80293a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80293d:	e9 74 01 00 00       	jmpq   802ab6 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802942:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802949:	be 01 01 00 00       	mov    $0x101,%esi
  80294e:	48 89 c7             	mov    %rax,%rdi
  802951:	48 b8 8a 26 80 00 00 	movabs $0x80268a,%rax
  802958:	00 00 00 
  80295b:	ff d0                	callq  *%rax
  80295d:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802960:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802964:	79 39                	jns    80299f <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802966:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802969:	89 c6                	mov    %eax,%esi
  80296b:	48 bf a7 44 80 00 00 	movabs $0x8044a7,%rdi
  802972:	00 00 00 
  802975:	b8 00 00 00 00       	mov    $0x0,%eax
  80297a:	48 ba 69 04 80 00 00 	movabs $0x800469,%rdx
  802981:	00 00 00 
  802984:	ff d2                	callq  *%rdx
		close(fd_src);
  802986:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802989:	89 c7                	mov    %eax,%edi
  80298b:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  802992:	00 00 00 
  802995:	ff d0                	callq  *%rax
		return fd_dest;
  802997:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80299a:	e9 17 01 00 00       	jmpq   802ab6 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80299f:	eb 74                	jmp    802a15 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8029a1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8029a4:	48 63 d0             	movslq %eax,%rdx
  8029a7:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8029ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029b1:	48 89 ce             	mov    %rcx,%rsi
  8029b4:	89 c7                	mov    %eax,%edi
  8029b6:	48 b8 fc 22 80 00 00 	movabs $0x8022fc,%rax
  8029bd:	00 00 00 
  8029c0:	ff d0                	callq  *%rax
  8029c2:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8029c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8029c9:	79 4a                	jns    802a15 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8029cb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8029ce:	89 c6                	mov    %eax,%esi
  8029d0:	48 bf c1 44 80 00 00 	movabs $0x8044c1,%rdi
  8029d7:	00 00 00 
  8029da:	b8 00 00 00 00       	mov    $0x0,%eax
  8029df:	48 ba 69 04 80 00 00 	movabs $0x800469,%rdx
  8029e6:	00 00 00 
  8029e9:	ff d2                	callq  *%rdx
			close(fd_src);
  8029eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ee:	89 c7                	mov    %eax,%edi
  8029f0:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  8029f7:	00 00 00 
  8029fa:	ff d0                	callq  *%rax
			close(fd_dest);
  8029fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029ff:	89 c7                	mov    %eax,%edi
  802a01:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  802a08:	00 00 00 
  802a0b:	ff d0                	callq  *%rax
			return write_size;
  802a0d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802a10:	e9 a1 00 00 00       	jmpq   802ab6 <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802a15:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802a1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a1f:	ba 00 02 00 00       	mov    $0x200,%edx
  802a24:	48 89 ce             	mov    %rcx,%rsi
  802a27:	89 c7                	mov    %eax,%edi
  802a29:	48 b8 b2 21 80 00 00 	movabs $0x8021b2,%rax
  802a30:	00 00 00 
  802a33:	ff d0                	callq  *%rax
  802a35:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802a38:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802a3c:	0f 8f 5f ff ff ff    	jg     8029a1 <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  802a42:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802a46:	79 47                	jns    802a8f <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802a48:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a4b:	89 c6                	mov    %eax,%esi
  802a4d:	48 bf d4 44 80 00 00 	movabs $0x8044d4,%rdi
  802a54:	00 00 00 
  802a57:	b8 00 00 00 00       	mov    $0x0,%eax
  802a5c:	48 ba 69 04 80 00 00 	movabs $0x800469,%rdx
  802a63:	00 00 00 
  802a66:	ff d2                	callq  *%rdx
		close(fd_src);
  802a68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a6b:	89 c7                	mov    %eax,%edi
  802a6d:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  802a74:	00 00 00 
  802a77:	ff d0                	callq  *%rax
		close(fd_dest);
  802a79:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a7c:	89 c7                	mov    %eax,%edi
  802a7e:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  802a85:	00 00 00 
  802a88:	ff d0                	callq  *%rax
		return read_size;
  802a8a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a8d:	eb 27                	jmp    802ab6 <copy+0x1d9>
	}
	close(fd_src);
  802a8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a92:	89 c7                	mov    %eax,%edi
  802a94:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  802a9b:	00 00 00 
  802a9e:	ff d0                	callq  *%rax
	close(fd_dest);
  802aa0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802aa3:	89 c7                	mov    %eax,%edi
  802aa5:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  802aac:	00 00 00 
  802aaf:	ff d0                	callq  *%rax
	return 0;
  802ab1:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802ab6:	c9                   	leaveq 
  802ab7:	c3                   	retq   

0000000000802ab8 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802ab8:	55                   	push   %rbp
  802ab9:	48 89 e5             	mov    %rsp,%rbp
  802abc:	48 83 ec 20          	sub    $0x20,%rsp
  802ac0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802ac3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ac7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802aca:	48 89 d6             	mov    %rdx,%rsi
  802acd:	89 c7                	mov    %eax,%edi
  802acf:	48 b8 7e 1d 80 00 00 	movabs $0x801d7e,%rax
  802ad6:	00 00 00 
  802ad9:	ff d0                	callq  *%rax
  802adb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ade:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ae2:	79 05                	jns    802ae9 <fd2sockid+0x31>
		return r;
  802ae4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae7:	eb 24                	jmp    802b0d <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802ae9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aed:	8b 10                	mov    (%rax),%edx
  802aef:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802af6:	00 00 00 
  802af9:	8b 00                	mov    (%rax),%eax
  802afb:	39 c2                	cmp    %eax,%edx
  802afd:	74 07                	je     802b06 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802aff:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b04:	eb 07                	jmp    802b0d <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802b06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b0a:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802b0d:	c9                   	leaveq 
  802b0e:	c3                   	retq   

0000000000802b0f <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802b0f:	55                   	push   %rbp
  802b10:	48 89 e5             	mov    %rsp,%rbp
  802b13:	48 83 ec 20          	sub    $0x20,%rsp
  802b17:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802b1a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802b1e:	48 89 c7             	mov    %rax,%rdi
  802b21:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  802b28:	00 00 00 
  802b2b:	ff d0                	callq  *%rax
  802b2d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b30:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b34:	78 26                	js     802b5c <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802b36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b3a:	ba 07 04 00 00       	mov    $0x407,%edx
  802b3f:	48 89 c6             	mov    %rax,%rsi
  802b42:	bf 00 00 00 00       	mov    $0x0,%edi
  802b47:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  802b4e:	00 00 00 
  802b51:	ff d0                	callq  *%rax
  802b53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b5a:	79 16                	jns    802b72 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802b5c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b5f:	89 c7                	mov    %eax,%edi
  802b61:	48 b8 1e 30 80 00 00 	movabs $0x80301e,%rax
  802b68:	00 00 00 
  802b6b:	ff d0                	callq  *%rax
		return r;
  802b6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b70:	eb 3a                	jmp    802bac <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802b72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b76:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802b7d:	00 00 00 
  802b80:	8b 12                	mov    (%rdx),%edx
  802b82:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802b84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b88:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802b8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b93:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802b96:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802b99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b9d:	48 89 c7             	mov    %rax,%rdi
  802ba0:	48 b8 98 1c 80 00 00 	movabs $0x801c98,%rax
  802ba7:	00 00 00 
  802baa:	ff d0                	callq  *%rax
}
  802bac:	c9                   	leaveq 
  802bad:	c3                   	retq   

0000000000802bae <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802bae:	55                   	push   %rbp
  802baf:	48 89 e5             	mov    %rsp,%rbp
  802bb2:	48 83 ec 30          	sub    $0x30,%rsp
  802bb6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bb9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802bbd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802bc1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bc4:	89 c7                	mov    %eax,%edi
  802bc6:	48 b8 b8 2a 80 00 00 	movabs $0x802ab8,%rax
  802bcd:	00 00 00 
  802bd0:	ff d0                	callq  *%rax
  802bd2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bd5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd9:	79 05                	jns    802be0 <accept+0x32>
		return r;
  802bdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bde:	eb 3b                	jmp    802c1b <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802be0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802be4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802be8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802beb:	48 89 ce             	mov    %rcx,%rsi
  802bee:	89 c7                	mov    %eax,%edi
  802bf0:	48 b8 fb 2e 80 00 00 	movabs $0x802efb,%rax
  802bf7:	00 00 00 
  802bfa:	ff d0                	callq  *%rax
  802bfc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c03:	79 05                	jns    802c0a <accept+0x5c>
		return r;
  802c05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c08:	eb 11                	jmp    802c1b <accept+0x6d>
	return alloc_sockfd(r);
  802c0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c0d:	89 c7                	mov    %eax,%edi
  802c0f:	48 b8 0f 2b 80 00 00 	movabs $0x802b0f,%rax
  802c16:	00 00 00 
  802c19:	ff d0                	callq  *%rax
}
  802c1b:	c9                   	leaveq 
  802c1c:	c3                   	retq   

0000000000802c1d <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802c1d:	55                   	push   %rbp
  802c1e:	48 89 e5             	mov    %rsp,%rbp
  802c21:	48 83 ec 20          	sub    $0x20,%rsp
  802c25:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c28:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c2c:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802c2f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c32:	89 c7                	mov    %eax,%edi
  802c34:	48 b8 b8 2a 80 00 00 	movabs $0x802ab8,%rax
  802c3b:	00 00 00 
  802c3e:	ff d0                	callq  *%rax
  802c40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c47:	79 05                	jns    802c4e <bind+0x31>
		return r;
  802c49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c4c:	eb 1b                	jmp    802c69 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802c4e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c51:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802c55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c58:	48 89 ce             	mov    %rcx,%rsi
  802c5b:	89 c7                	mov    %eax,%edi
  802c5d:	48 b8 7a 2f 80 00 00 	movabs $0x802f7a,%rax
  802c64:	00 00 00 
  802c67:	ff d0                	callq  *%rax
}
  802c69:	c9                   	leaveq 
  802c6a:	c3                   	retq   

0000000000802c6b <shutdown>:

int
shutdown(int s, int how)
{
  802c6b:	55                   	push   %rbp
  802c6c:	48 89 e5             	mov    %rsp,%rbp
  802c6f:	48 83 ec 20          	sub    $0x20,%rsp
  802c73:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c76:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802c79:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c7c:	89 c7                	mov    %eax,%edi
  802c7e:	48 b8 b8 2a 80 00 00 	movabs $0x802ab8,%rax
  802c85:	00 00 00 
  802c88:	ff d0                	callq  *%rax
  802c8a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c91:	79 05                	jns    802c98 <shutdown+0x2d>
		return r;
  802c93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c96:	eb 16                	jmp    802cae <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802c98:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c9e:	89 d6                	mov    %edx,%esi
  802ca0:	89 c7                	mov    %eax,%edi
  802ca2:	48 b8 de 2f 80 00 00 	movabs $0x802fde,%rax
  802ca9:	00 00 00 
  802cac:	ff d0                	callq  *%rax
}
  802cae:	c9                   	leaveq 
  802caf:	c3                   	retq   

0000000000802cb0 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802cb0:	55                   	push   %rbp
  802cb1:	48 89 e5             	mov    %rsp,%rbp
  802cb4:	48 83 ec 10          	sub    $0x10,%rsp
  802cb8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802cbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cc0:	48 89 c7             	mov    %rax,%rdi
  802cc3:	48 b8 7d 3d 80 00 00 	movabs $0x803d7d,%rax
  802cca:	00 00 00 
  802ccd:	ff d0                	callq  *%rax
  802ccf:	83 f8 01             	cmp    $0x1,%eax
  802cd2:	75 17                	jne    802ceb <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802cd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cd8:	8b 40 0c             	mov    0xc(%rax),%eax
  802cdb:	89 c7                	mov    %eax,%edi
  802cdd:	48 b8 1e 30 80 00 00 	movabs $0x80301e,%rax
  802ce4:	00 00 00 
  802ce7:	ff d0                	callq  *%rax
  802ce9:	eb 05                	jmp    802cf0 <devsock_close+0x40>
	else
		return 0;
  802ceb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cf0:	c9                   	leaveq 
  802cf1:	c3                   	retq   

0000000000802cf2 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802cf2:	55                   	push   %rbp
  802cf3:	48 89 e5             	mov    %rsp,%rbp
  802cf6:	48 83 ec 20          	sub    $0x20,%rsp
  802cfa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cfd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d01:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802d04:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d07:	89 c7                	mov    %eax,%edi
  802d09:	48 b8 b8 2a 80 00 00 	movabs $0x802ab8,%rax
  802d10:	00 00 00 
  802d13:	ff d0                	callq  *%rax
  802d15:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d18:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d1c:	79 05                	jns    802d23 <connect+0x31>
		return r;
  802d1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d21:	eb 1b                	jmp    802d3e <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802d23:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d26:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802d2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d2d:	48 89 ce             	mov    %rcx,%rsi
  802d30:	89 c7                	mov    %eax,%edi
  802d32:	48 b8 4b 30 80 00 00 	movabs $0x80304b,%rax
  802d39:	00 00 00 
  802d3c:	ff d0                	callq  *%rax
}
  802d3e:	c9                   	leaveq 
  802d3f:	c3                   	retq   

0000000000802d40 <listen>:

int
listen(int s, int backlog)
{
  802d40:	55                   	push   %rbp
  802d41:	48 89 e5             	mov    %rsp,%rbp
  802d44:	48 83 ec 20          	sub    $0x20,%rsp
  802d48:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d4b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802d4e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d51:	89 c7                	mov    %eax,%edi
  802d53:	48 b8 b8 2a 80 00 00 	movabs $0x802ab8,%rax
  802d5a:	00 00 00 
  802d5d:	ff d0                	callq  *%rax
  802d5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d66:	79 05                	jns    802d6d <listen+0x2d>
		return r;
  802d68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d6b:	eb 16                	jmp    802d83 <listen+0x43>
	return nsipc_listen(r, backlog);
  802d6d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d73:	89 d6                	mov    %edx,%esi
  802d75:	89 c7                	mov    %eax,%edi
  802d77:	48 b8 af 30 80 00 00 	movabs $0x8030af,%rax
  802d7e:	00 00 00 
  802d81:	ff d0                	callq  *%rax
}
  802d83:	c9                   	leaveq 
  802d84:	c3                   	retq   

0000000000802d85 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802d85:	55                   	push   %rbp
  802d86:	48 89 e5             	mov    %rsp,%rbp
  802d89:	48 83 ec 20          	sub    $0x20,%rsp
  802d8d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d91:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802d95:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802d99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d9d:	89 c2                	mov    %eax,%edx
  802d9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802da3:	8b 40 0c             	mov    0xc(%rax),%eax
  802da6:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802daa:	b9 00 00 00 00       	mov    $0x0,%ecx
  802daf:	89 c7                	mov    %eax,%edi
  802db1:	48 b8 ef 30 80 00 00 	movabs $0x8030ef,%rax
  802db8:	00 00 00 
  802dbb:	ff d0                	callq  *%rax
}
  802dbd:	c9                   	leaveq 
  802dbe:	c3                   	retq   

0000000000802dbf <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802dbf:	55                   	push   %rbp
  802dc0:	48 89 e5             	mov    %rsp,%rbp
  802dc3:	48 83 ec 20          	sub    $0x20,%rsp
  802dc7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802dcb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802dcf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802dd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dd7:	89 c2                	mov    %eax,%edx
  802dd9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ddd:	8b 40 0c             	mov    0xc(%rax),%eax
  802de0:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802de4:	b9 00 00 00 00       	mov    $0x0,%ecx
  802de9:	89 c7                	mov    %eax,%edi
  802deb:	48 b8 bb 31 80 00 00 	movabs $0x8031bb,%rax
  802df2:	00 00 00 
  802df5:	ff d0                	callq  *%rax
}
  802df7:	c9                   	leaveq 
  802df8:	c3                   	retq   

0000000000802df9 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802df9:	55                   	push   %rbp
  802dfa:	48 89 e5             	mov    %rsp,%rbp
  802dfd:	48 83 ec 10          	sub    $0x10,%rsp
  802e01:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e05:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802e09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e0d:	48 be ef 44 80 00 00 	movabs $0x8044ef,%rsi
  802e14:	00 00 00 
  802e17:	48 89 c7             	mov    %rax,%rdi
  802e1a:	48 b8 03 10 80 00 00 	movabs $0x801003,%rax
  802e21:	00 00 00 
  802e24:	ff d0                	callq  *%rax
	return 0;
  802e26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e2b:	c9                   	leaveq 
  802e2c:	c3                   	retq   

0000000000802e2d <socket>:

int
socket(int domain, int type, int protocol)
{
  802e2d:	55                   	push   %rbp
  802e2e:	48 89 e5             	mov    %rsp,%rbp
  802e31:	48 83 ec 20          	sub    $0x20,%rsp
  802e35:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e38:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802e3b:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802e3e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802e41:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802e44:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e47:	89 ce                	mov    %ecx,%esi
  802e49:	89 c7                	mov    %eax,%edi
  802e4b:	48 b8 73 32 80 00 00 	movabs $0x803273,%rax
  802e52:	00 00 00 
  802e55:	ff d0                	callq  *%rax
  802e57:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e5e:	79 05                	jns    802e65 <socket+0x38>
		return r;
  802e60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e63:	eb 11                	jmp    802e76 <socket+0x49>
	return alloc_sockfd(r);
  802e65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e68:	89 c7                	mov    %eax,%edi
  802e6a:	48 b8 0f 2b 80 00 00 	movabs $0x802b0f,%rax
  802e71:	00 00 00 
  802e74:	ff d0                	callq  *%rax
}
  802e76:	c9                   	leaveq 
  802e77:	c3                   	retq   

0000000000802e78 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802e78:	55                   	push   %rbp
  802e79:	48 89 e5             	mov    %rsp,%rbp
  802e7c:	48 83 ec 10          	sub    $0x10,%rsp
  802e80:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  802e83:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802e8a:	00 00 00 
  802e8d:	8b 00                	mov    (%rax),%eax
  802e8f:	85 c0                	test   %eax,%eax
  802e91:	75 1f                	jne    802eb2 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802e93:	bf 02 00 00 00       	mov    $0x2,%edi
  802e98:	48 b8 0b 3d 80 00 00 	movabs $0x803d0b,%rax
  802e9f:	00 00 00 
  802ea2:	ff d0                	callq  *%rax
  802ea4:	89 c2                	mov    %eax,%edx
  802ea6:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802ead:	00 00 00 
  802eb0:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802eb2:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802eb9:	00 00 00 
  802ebc:	8b 00                	mov    (%rax),%eax
  802ebe:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802ec1:	b9 07 00 00 00       	mov    $0x7,%ecx
  802ec6:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802ecd:	00 00 00 
  802ed0:	89 c7                	mov    %eax,%edi
  802ed2:	48 b8 7e 3b 80 00 00 	movabs $0x803b7e,%rax
  802ed9:	00 00 00 
  802edc:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  802ede:	ba 00 00 00 00       	mov    $0x0,%edx
  802ee3:	be 00 00 00 00       	mov    $0x0,%esi
  802ee8:	bf 00 00 00 00       	mov    $0x0,%edi
  802eed:	48 b8 40 3b 80 00 00 	movabs $0x803b40,%rax
  802ef4:	00 00 00 
  802ef7:	ff d0                	callq  *%rax
}
  802ef9:	c9                   	leaveq 
  802efa:	c3                   	retq   

0000000000802efb <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802efb:	55                   	push   %rbp
  802efc:	48 89 e5             	mov    %rsp,%rbp
  802eff:	48 83 ec 30          	sub    $0x30,%rsp
  802f03:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f06:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f0a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  802f0e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f15:	00 00 00 
  802f18:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802f1b:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802f1d:	bf 01 00 00 00       	mov    $0x1,%edi
  802f22:	48 b8 78 2e 80 00 00 	movabs $0x802e78,%rax
  802f29:	00 00 00 
  802f2c:	ff d0                	callq  *%rax
  802f2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f35:	78 3e                	js     802f75 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802f37:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f3e:	00 00 00 
  802f41:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802f45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f49:	8b 40 10             	mov    0x10(%rax),%eax
  802f4c:	89 c2                	mov    %eax,%edx
  802f4e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802f52:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f56:	48 89 ce             	mov    %rcx,%rsi
  802f59:	48 89 c7             	mov    %rax,%rdi
  802f5c:	48 b8 27 13 80 00 00 	movabs $0x801327,%rax
  802f63:	00 00 00 
  802f66:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  802f68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f6c:	8b 50 10             	mov    0x10(%rax),%edx
  802f6f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f73:	89 10                	mov    %edx,(%rax)
	}
	return r;
  802f75:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f78:	c9                   	leaveq 
  802f79:	c3                   	retq   

0000000000802f7a <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802f7a:	55                   	push   %rbp
  802f7b:	48 89 e5             	mov    %rsp,%rbp
  802f7e:	48 83 ec 10          	sub    $0x10,%rsp
  802f82:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f85:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802f89:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  802f8c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f93:	00 00 00 
  802f96:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f99:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802f9b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802f9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fa2:	48 89 c6             	mov    %rax,%rsi
  802fa5:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802fac:	00 00 00 
  802faf:	48 b8 27 13 80 00 00 	movabs $0x801327,%rax
  802fb6:	00 00 00 
  802fb9:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  802fbb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fc2:	00 00 00 
  802fc5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802fc8:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  802fcb:	bf 02 00 00 00       	mov    $0x2,%edi
  802fd0:	48 b8 78 2e 80 00 00 	movabs $0x802e78,%rax
  802fd7:	00 00 00 
  802fda:	ff d0                	callq  *%rax
}
  802fdc:	c9                   	leaveq 
  802fdd:	c3                   	retq   

0000000000802fde <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802fde:	55                   	push   %rbp
  802fdf:	48 89 e5             	mov    %rsp,%rbp
  802fe2:	48 83 ec 10          	sub    $0x10,%rsp
  802fe6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802fe9:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  802fec:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ff3:	00 00 00 
  802ff6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ff9:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  802ffb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803002:	00 00 00 
  803005:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803008:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80300b:	bf 03 00 00 00       	mov    $0x3,%edi
  803010:	48 b8 78 2e 80 00 00 	movabs $0x802e78,%rax
  803017:	00 00 00 
  80301a:	ff d0                	callq  *%rax
}
  80301c:	c9                   	leaveq 
  80301d:	c3                   	retq   

000000000080301e <nsipc_close>:

int
nsipc_close(int s)
{
  80301e:	55                   	push   %rbp
  80301f:	48 89 e5             	mov    %rsp,%rbp
  803022:	48 83 ec 10          	sub    $0x10,%rsp
  803026:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803029:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803030:	00 00 00 
  803033:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803036:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803038:	bf 04 00 00 00       	mov    $0x4,%edi
  80303d:	48 b8 78 2e 80 00 00 	movabs $0x802e78,%rax
  803044:	00 00 00 
  803047:	ff d0                	callq  *%rax
}
  803049:	c9                   	leaveq 
  80304a:	c3                   	retq   

000000000080304b <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80304b:	55                   	push   %rbp
  80304c:	48 89 e5             	mov    %rsp,%rbp
  80304f:	48 83 ec 10          	sub    $0x10,%rsp
  803053:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803056:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80305a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80305d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803064:	00 00 00 
  803067:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80306a:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80306c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80306f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803073:	48 89 c6             	mov    %rax,%rsi
  803076:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80307d:	00 00 00 
  803080:	48 b8 27 13 80 00 00 	movabs $0x801327,%rax
  803087:	00 00 00 
  80308a:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80308c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803093:	00 00 00 
  803096:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803099:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80309c:	bf 05 00 00 00       	mov    $0x5,%edi
  8030a1:	48 b8 78 2e 80 00 00 	movabs $0x802e78,%rax
  8030a8:	00 00 00 
  8030ab:	ff d0                	callq  *%rax
}
  8030ad:	c9                   	leaveq 
  8030ae:	c3                   	retq   

00000000008030af <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8030af:	55                   	push   %rbp
  8030b0:	48 89 e5             	mov    %rsp,%rbp
  8030b3:	48 83 ec 10          	sub    $0x10,%rsp
  8030b7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8030ba:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8030bd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030c4:	00 00 00 
  8030c7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8030ca:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8030cc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030d3:	00 00 00 
  8030d6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8030d9:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8030dc:	bf 06 00 00 00       	mov    $0x6,%edi
  8030e1:	48 b8 78 2e 80 00 00 	movabs $0x802e78,%rax
  8030e8:	00 00 00 
  8030eb:	ff d0                	callq  *%rax
}
  8030ed:	c9                   	leaveq 
  8030ee:	c3                   	retq   

00000000008030ef <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8030ef:	55                   	push   %rbp
  8030f0:	48 89 e5             	mov    %rsp,%rbp
  8030f3:	48 83 ec 30          	sub    $0x30,%rsp
  8030f7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030fa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030fe:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803101:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803104:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80310b:	00 00 00 
  80310e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803111:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803113:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80311a:	00 00 00 
  80311d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803120:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803123:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80312a:	00 00 00 
  80312d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803130:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803133:	bf 07 00 00 00       	mov    $0x7,%edi
  803138:	48 b8 78 2e 80 00 00 	movabs $0x802e78,%rax
  80313f:	00 00 00 
  803142:	ff d0                	callq  *%rax
  803144:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803147:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80314b:	78 69                	js     8031b6 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80314d:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803154:	7f 08                	jg     80315e <nsipc_recv+0x6f>
  803156:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803159:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80315c:	7e 35                	jle    803193 <nsipc_recv+0xa4>
  80315e:	48 b9 f6 44 80 00 00 	movabs $0x8044f6,%rcx
  803165:	00 00 00 
  803168:	48 ba 0b 45 80 00 00 	movabs $0x80450b,%rdx
  80316f:	00 00 00 
  803172:	be 61 00 00 00       	mov    $0x61,%esi
  803177:	48 bf 20 45 80 00 00 	movabs $0x804520,%rdi
  80317e:	00 00 00 
  803181:	b8 00 00 00 00       	mov    $0x0,%eax
  803186:	49 b8 30 02 80 00 00 	movabs $0x800230,%r8
  80318d:	00 00 00 
  803190:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803193:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803196:	48 63 d0             	movslq %eax,%rdx
  803199:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80319d:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8031a4:	00 00 00 
  8031a7:	48 89 c7             	mov    %rax,%rdi
  8031aa:	48 b8 27 13 80 00 00 	movabs $0x801327,%rax
  8031b1:	00 00 00 
  8031b4:	ff d0                	callq  *%rax
	}

	return r;
  8031b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8031b9:	c9                   	leaveq 
  8031ba:	c3                   	retq   

00000000008031bb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8031bb:	55                   	push   %rbp
  8031bc:	48 89 e5             	mov    %rsp,%rbp
  8031bf:	48 83 ec 20          	sub    $0x20,%rsp
  8031c3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8031c6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8031ca:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8031cd:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8031d0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031d7:	00 00 00 
  8031da:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8031dd:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8031df:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8031e6:	7e 35                	jle    80321d <nsipc_send+0x62>
  8031e8:	48 b9 2c 45 80 00 00 	movabs $0x80452c,%rcx
  8031ef:	00 00 00 
  8031f2:	48 ba 0b 45 80 00 00 	movabs $0x80450b,%rdx
  8031f9:	00 00 00 
  8031fc:	be 6c 00 00 00       	mov    $0x6c,%esi
  803201:	48 bf 20 45 80 00 00 	movabs $0x804520,%rdi
  803208:	00 00 00 
  80320b:	b8 00 00 00 00       	mov    $0x0,%eax
  803210:	49 b8 30 02 80 00 00 	movabs $0x800230,%r8
  803217:	00 00 00 
  80321a:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80321d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803220:	48 63 d0             	movslq %eax,%rdx
  803223:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803227:	48 89 c6             	mov    %rax,%rsi
  80322a:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803231:	00 00 00 
  803234:	48 b8 27 13 80 00 00 	movabs $0x801327,%rax
  80323b:	00 00 00 
  80323e:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803240:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803247:	00 00 00 
  80324a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80324d:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803250:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803257:	00 00 00 
  80325a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80325d:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803260:	bf 08 00 00 00       	mov    $0x8,%edi
  803265:	48 b8 78 2e 80 00 00 	movabs $0x802e78,%rax
  80326c:	00 00 00 
  80326f:	ff d0                	callq  *%rax
}
  803271:	c9                   	leaveq 
  803272:	c3                   	retq   

0000000000803273 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803273:	55                   	push   %rbp
  803274:	48 89 e5             	mov    %rsp,%rbp
  803277:	48 83 ec 10          	sub    $0x10,%rsp
  80327b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80327e:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803281:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803284:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80328b:	00 00 00 
  80328e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803291:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803293:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80329a:	00 00 00 
  80329d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032a0:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8032a3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032aa:	00 00 00 
  8032ad:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8032b0:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8032b3:	bf 09 00 00 00       	mov    $0x9,%edi
  8032b8:	48 b8 78 2e 80 00 00 	movabs $0x802e78,%rax
  8032bf:	00 00 00 
  8032c2:	ff d0                	callq  *%rax
}
  8032c4:	c9                   	leaveq 
  8032c5:	c3                   	retq   

00000000008032c6 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8032c6:	55                   	push   %rbp
  8032c7:	48 89 e5             	mov    %rsp,%rbp
  8032ca:	53                   	push   %rbx
  8032cb:	48 83 ec 38          	sub    $0x38,%rsp
  8032cf:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8032d3:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8032d7:	48 89 c7             	mov    %rax,%rdi
  8032da:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  8032e1:	00 00 00 
  8032e4:	ff d0                	callq  *%rax
  8032e6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032ed:	0f 88 bf 01 00 00    	js     8034b2 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032f7:	ba 07 04 00 00       	mov    $0x407,%edx
  8032fc:	48 89 c6             	mov    %rax,%rsi
  8032ff:	bf 00 00 00 00       	mov    $0x0,%edi
  803304:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  80330b:	00 00 00 
  80330e:	ff d0                	callq  *%rax
  803310:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803313:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803317:	0f 88 95 01 00 00    	js     8034b2 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80331d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803321:	48 89 c7             	mov    %rax,%rdi
  803324:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  80332b:	00 00 00 
  80332e:	ff d0                	callq  *%rax
  803330:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803333:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803337:	0f 88 5d 01 00 00    	js     80349a <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80333d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803341:	ba 07 04 00 00       	mov    $0x407,%edx
  803346:	48 89 c6             	mov    %rax,%rsi
  803349:	bf 00 00 00 00       	mov    $0x0,%edi
  80334e:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  803355:	00 00 00 
  803358:	ff d0                	callq  *%rax
  80335a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80335d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803361:	0f 88 33 01 00 00    	js     80349a <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803367:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80336b:	48 89 c7             	mov    %rax,%rdi
  80336e:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  803375:	00 00 00 
  803378:	ff d0                	callq  *%rax
  80337a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80337e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803382:	ba 07 04 00 00       	mov    $0x407,%edx
  803387:	48 89 c6             	mov    %rax,%rsi
  80338a:	bf 00 00 00 00       	mov    $0x0,%edi
  80338f:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  803396:	00 00 00 
  803399:	ff d0                	callq  *%rax
  80339b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80339e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033a2:	79 05                	jns    8033a9 <pipe+0xe3>
		goto err2;
  8033a4:	e9 d9 00 00 00       	jmpq   803482 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033a9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033ad:	48 89 c7             	mov    %rax,%rdi
  8033b0:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  8033b7:	00 00 00 
  8033ba:	ff d0                	callq  *%rax
  8033bc:	48 89 c2             	mov    %rax,%rdx
  8033bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033c3:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8033c9:	48 89 d1             	mov    %rdx,%rcx
  8033cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8033d1:	48 89 c6             	mov    %rax,%rsi
  8033d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8033d9:	48 b8 82 19 80 00 00 	movabs $0x801982,%rax
  8033e0:	00 00 00 
  8033e3:	ff d0                	callq  *%rax
  8033e5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033ec:	79 1b                	jns    803409 <pipe+0x143>
		goto err3;
  8033ee:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8033ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033f3:	48 89 c6             	mov    %rax,%rsi
  8033f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8033fb:	48 b8 e2 19 80 00 00 	movabs $0x8019e2,%rax
  803402:	00 00 00 
  803405:	ff d0                	callq  *%rax
  803407:	eb 79                	jmp    803482 <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  803409:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80340d:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803414:	00 00 00 
  803417:	8b 12                	mov    (%rdx),%edx
  803419:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80341b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80341f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  803426:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80342a:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803431:	00 00 00 
  803434:	8b 12                	mov    (%rdx),%edx
  803436:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803438:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80343c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  803443:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803447:	48 89 c7             	mov    %rax,%rdi
  80344a:	48 b8 98 1c 80 00 00 	movabs $0x801c98,%rax
  803451:	00 00 00 
  803454:	ff d0                	callq  *%rax
  803456:	89 c2                	mov    %eax,%edx
  803458:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80345c:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80345e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803462:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803466:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80346a:	48 89 c7             	mov    %rax,%rdi
  80346d:	48 b8 98 1c 80 00 00 	movabs $0x801c98,%rax
  803474:	00 00 00 
  803477:	ff d0                	callq  *%rax
  803479:	89 03                	mov    %eax,(%rbx)
	return 0;
  80347b:	b8 00 00 00 00       	mov    $0x0,%eax
  803480:	eb 33                	jmp    8034b5 <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  803482:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803486:	48 89 c6             	mov    %rax,%rsi
  803489:	bf 00 00 00 00       	mov    $0x0,%edi
  80348e:	48 b8 e2 19 80 00 00 	movabs $0x8019e2,%rax
  803495:	00 00 00 
  803498:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80349a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80349e:	48 89 c6             	mov    %rax,%rsi
  8034a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8034a6:	48 b8 e2 19 80 00 00 	movabs $0x8019e2,%rax
  8034ad:	00 00 00 
  8034b0:	ff d0                	callq  *%rax
err:
	return r;
  8034b2:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8034b5:	48 83 c4 38          	add    $0x38,%rsp
  8034b9:	5b                   	pop    %rbx
  8034ba:	5d                   	pop    %rbp
  8034bb:	c3                   	retq   

00000000008034bc <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8034bc:	55                   	push   %rbp
  8034bd:	48 89 e5             	mov    %rsp,%rbp
  8034c0:	53                   	push   %rbx
  8034c1:	48 83 ec 28          	sub    $0x28,%rsp
  8034c5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8034c9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8034cd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8034d4:	00 00 00 
  8034d7:	48 8b 00             	mov    (%rax),%rax
  8034da:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8034e0:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8034e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034e7:	48 89 c7             	mov    %rax,%rdi
  8034ea:	48 b8 7d 3d 80 00 00 	movabs $0x803d7d,%rax
  8034f1:	00 00 00 
  8034f4:	ff d0                	callq  *%rax
  8034f6:	89 c3                	mov    %eax,%ebx
  8034f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034fc:	48 89 c7             	mov    %rax,%rdi
  8034ff:	48 b8 7d 3d 80 00 00 	movabs $0x803d7d,%rax
  803506:	00 00 00 
  803509:	ff d0                	callq  *%rax
  80350b:	39 c3                	cmp    %eax,%ebx
  80350d:	0f 94 c0             	sete   %al
  803510:	0f b6 c0             	movzbl %al,%eax
  803513:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803516:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80351d:	00 00 00 
  803520:	48 8b 00             	mov    (%rax),%rax
  803523:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803529:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80352c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80352f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803532:	75 05                	jne    803539 <_pipeisclosed+0x7d>
			return ret;
  803534:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803537:	eb 4a                	jmp    803583 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803539:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80353c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80353f:	74 3d                	je     80357e <_pipeisclosed+0xc2>
  803541:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803545:	75 37                	jne    80357e <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803547:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80354e:	00 00 00 
  803551:	48 8b 00             	mov    (%rax),%rax
  803554:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80355a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80355d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803560:	89 c6                	mov    %eax,%esi
  803562:	48 bf 3d 45 80 00 00 	movabs $0x80453d,%rdi
  803569:	00 00 00 
  80356c:	b8 00 00 00 00       	mov    $0x0,%eax
  803571:	49 b8 69 04 80 00 00 	movabs $0x800469,%r8
  803578:	00 00 00 
  80357b:	41 ff d0             	callq  *%r8
	}
  80357e:	e9 4a ff ff ff       	jmpq   8034cd <_pipeisclosed+0x11>
}
  803583:	48 83 c4 28          	add    $0x28,%rsp
  803587:	5b                   	pop    %rbx
  803588:	5d                   	pop    %rbp
  803589:	c3                   	retq   

000000000080358a <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80358a:	55                   	push   %rbp
  80358b:	48 89 e5             	mov    %rsp,%rbp
  80358e:	48 83 ec 30          	sub    $0x30,%rsp
  803592:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803595:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803599:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80359c:	48 89 d6             	mov    %rdx,%rsi
  80359f:	89 c7                	mov    %eax,%edi
  8035a1:	48 b8 7e 1d 80 00 00 	movabs $0x801d7e,%rax
  8035a8:	00 00 00 
  8035ab:	ff d0                	callq  *%rax
  8035ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035b4:	79 05                	jns    8035bb <pipeisclosed+0x31>
		return r;
  8035b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035b9:	eb 31                	jmp    8035ec <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8035bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035bf:	48 89 c7             	mov    %rax,%rdi
  8035c2:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  8035c9:	00 00 00 
  8035cc:	ff d0                	callq  *%rax
  8035ce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8035d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035d6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035da:	48 89 d6             	mov    %rdx,%rsi
  8035dd:	48 89 c7             	mov    %rax,%rdi
  8035e0:	48 b8 bc 34 80 00 00 	movabs $0x8034bc,%rax
  8035e7:	00 00 00 
  8035ea:	ff d0                	callq  *%rax
}
  8035ec:	c9                   	leaveq 
  8035ed:	c3                   	retq   

00000000008035ee <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8035ee:	55                   	push   %rbp
  8035ef:	48 89 e5             	mov    %rsp,%rbp
  8035f2:	48 83 ec 40          	sub    $0x40,%rsp
  8035f6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035fa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8035fe:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803602:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803606:	48 89 c7             	mov    %rax,%rdi
  803609:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  803610:	00 00 00 
  803613:	ff d0                	callq  *%rax
  803615:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803619:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80361d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803621:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803628:	00 
  803629:	e9 92 00 00 00       	jmpq   8036c0 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80362e:	eb 41                	jmp    803671 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803630:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803635:	74 09                	je     803640 <devpipe_read+0x52>
				return i;
  803637:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80363b:	e9 92 00 00 00       	jmpq   8036d2 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803640:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803644:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803648:	48 89 d6             	mov    %rdx,%rsi
  80364b:	48 89 c7             	mov    %rax,%rdi
  80364e:	48 b8 bc 34 80 00 00 	movabs $0x8034bc,%rax
  803655:	00 00 00 
  803658:	ff d0                	callq  *%rax
  80365a:	85 c0                	test   %eax,%eax
  80365c:	74 07                	je     803665 <devpipe_read+0x77>
				return 0;
  80365e:	b8 00 00 00 00       	mov    $0x0,%eax
  803663:	eb 6d                	jmp    8036d2 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803665:	48 b8 f4 18 80 00 00 	movabs $0x8018f4,%rax
  80366c:	00 00 00 
  80366f:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  803671:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803675:	8b 10                	mov    (%rax),%edx
  803677:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80367b:	8b 40 04             	mov    0x4(%rax),%eax
  80367e:	39 c2                	cmp    %eax,%edx
  803680:	74 ae                	je     803630 <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803682:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803686:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80368a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80368e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803692:	8b 00                	mov    (%rax),%eax
  803694:	99                   	cltd   
  803695:	c1 ea 1b             	shr    $0x1b,%edx
  803698:	01 d0                	add    %edx,%eax
  80369a:	83 e0 1f             	and    $0x1f,%eax
  80369d:	29 d0                	sub    %edx,%eax
  80369f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036a3:	48 98                	cltq   
  8036a5:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8036aa:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8036ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036b0:	8b 00                	mov    (%rax),%eax
  8036b2:	8d 50 01             	lea    0x1(%rax),%edx
  8036b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036b9:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  8036bb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8036c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036c4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8036c8:	0f 82 60 ff ff ff    	jb     80362e <devpipe_read+0x40>
	}
	return i;
  8036ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8036d2:	c9                   	leaveq 
  8036d3:	c3                   	retq   

00000000008036d4 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8036d4:	55                   	push   %rbp
  8036d5:	48 89 e5             	mov    %rsp,%rbp
  8036d8:	48 83 ec 40          	sub    $0x40,%rsp
  8036dc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8036e0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8036e4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8036e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036ec:	48 89 c7             	mov    %rax,%rdi
  8036ef:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  8036f6:	00 00 00 
  8036f9:	ff d0                	callq  *%rax
  8036fb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8036ff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803703:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803707:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80370e:	00 
  80370f:	e9 91 00 00 00       	jmpq   8037a5 <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803714:	eb 31                	jmp    803747 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803716:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80371a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80371e:	48 89 d6             	mov    %rdx,%rsi
  803721:	48 89 c7             	mov    %rax,%rdi
  803724:	48 b8 bc 34 80 00 00 	movabs $0x8034bc,%rax
  80372b:	00 00 00 
  80372e:	ff d0                	callq  *%rax
  803730:	85 c0                	test   %eax,%eax
  803732:	74 07                	je     80373b <devpipe_write+0x67>
				return 0;
  803734:	b8 00 00 00 00       	mov    $0x0,%eax
  803739:	eb 7c                	jmp    8037b7 <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80373b:	48 b8 f4 18 80 00 00 	movabs $0x8018f4,%rax
  803742:	00 00 00 
  803745:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803747:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80374b:	8b 40 04             	mov    0x4(%rax),%eax
  80374e:	48 63 d0             	movslq %eax,%rdx
  803751:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803755:	8b 00                	mov    (%rax),%eax
  803757:	48 98                	cltq   
  803759:	48 83 c0 20          	add    $0x20,%rax
  80375d:	48 39 c2             	cmp    %rax,%rdx
  803760:	73 b4                	jae    803716 <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803762:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803766:	8b 40 04             	mov    0x4(%rax),%eax
  803769:	99                   	cltd   
  80376a:	c1 ea 1b             	shr    $0x1b,%edx
  80376d:	01 d0                	add    %edx,%eax
  80376f:	83 e0 1f             	and    $0x1f,%eax
  803772:	29 d0                	sub    %edx,%eax
  803774:	89 c6                	mov    %eax,%esi
  803776:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80377a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80377e:	48 01 d0             	add    %rdx,%rax
  803781:	0f b6 08             	movzbl (%rax),%ecx
  803784:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803788:	48 63 c6             	movslq %esi,%rax
  80378b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80378f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803793:	8b 40 04             	mov    0x4(%rax),%eax
  803796:	8d 50 01             	lea    0x1(%rax),%edx
  803799:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80379d:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  8037a0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8037a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037a9:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8037ad:	0f 82 61 ff ff ff    	jb     803714 <devpipe_write+0x40>
	}

	return i;
  8037b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8037b7:	c9                   	leaveq 
  8037b8:	c3                   	retq   

00000000008037b9 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8037b9:	55                   	push   %rbp
  8037ba:	48 89 e5             	mov    %rsp,%rbp
  8037bd:	48 83 ec 20          	sub    $0x20,%rsp
  8037c1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8037c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8037c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037cd:	48 89 c7             	mov    %rax,%rdi
  8037d0:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  8037d7:	00 00 00 
  8037da:	ff d0                	callq  *%rax
  8037dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8037e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037e4:	48 be 50 45 80 00 00 	movabs $0x804550,%rsi
  8037eb:	00 00 00 
  8037ee:	48 89 c7             	mov    %rax,%rdi
  8037f1:	48 b8 03 10 80 00 00 	movabs $0x801003,%rax
  8037f8:	00 00 00 
  8037fb:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8037fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803801:	8b 50 04             	mov    0x4(%rax),%edx
  803804:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803808:	8b 00                	mov    (%rax),%eax
  80380a:	29 c2                	sub    %eax,%edx
  80380c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803810:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803816:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80381a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803821:	00 00 00 
	stat->st_dev = &devpipe;
  803824:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803828:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  80382f:	00 00 00 
  803832:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803839:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80383e:	c9                   	leaveq 
  80383f:	c3                   	retq   

0000000000803840 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803840:	55                   	push   %rbp
  803841:	48 89 e5             	mov    %rsp,%rbp
  803844:	48 83 ec 10          	sub    $0x10,%rsp
  803848:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80384c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803850:	48 89 c6             	mov    %rax,%rsi
  803853:	bf 00 00 00 00       	mov    $0x0,%edi
  803858:	48 b8 e2 19 80 00 00 	movabs $0x8019e2,%rax
  80385f:	00 00 00 
  803862:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803864:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803868:	48 89 c7             	mov    %rax,%rdi
  80386b:	48 b8 bb 1c 80 00 00 	movabs $0x801cbb,%rax
  803872:	00 00 00 
  803875:	ff d0                	callq  *%rax
  803877:	48 89 c6             	mov    %rax,%rsi
  80387a:	bf 00 00 00 00       	mov    $0x0,%edi
  80387f:	48 b8 e2 19 80 00 00 	movabs $0x8019e2,%rax
  803886:	00 00 00 
  803889:	ff d0                	callq  *%rax
}
  80388b:	c9                   	leaveq 
  80388c:	c3                   	retq   

000000000080388d <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80388d:	55                   	push   %rbp
  80388e:	48 89 e5             	mov    %rsp,%rbp
  803891:	48 83 ec 20          	sub    $0x20,%rsp
  803895:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803898:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80389b:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80389e:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8038a2:	be 01 00 00 00       	mov    $0x1,%esi
  8038a7:	48 89 c7             	mov    %rax,%rdi
  8038aa:	48 b8 ea 17 80 00 00 	movabs $0x8017ea,%rax
  8038b1:	00 00 00 
  8038b4:	ff d0                	callq  *%rax
}
  8038b6:	c9                   	leaveq 
  8038b7:	c3                   	retq   

00000000008038b8 <getchar>:

int
getchar(void)
{
  8038b8:	55                   	push   %rbp
  8038b9:	48 89 e5             	mov    %rsp,%rbp
  8038bc:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8038c0:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8038c4:	ba 01 00 00 00       	mov    $0x1,%edx
  8038c9:	48 89 c6             	mov    %rax,%rsi
  8038cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8038d1:	48 b8 b2 21 80 00 00 	movabs $0x8021b2,%rax
  8038d8:	00 00 00 
  8038db:	ff d0                	callq  *%rax
  8038dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8038e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038e4:	79 05                	jns    8038eb <getchar+0x33>
		return r;
  8038e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e9:	eb 14                	jmp    8038ff <getchar+0x47>
	if (r < 1)
  8038eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038ef:	7f 07                	jg     8038f8 <getchar+0x40>
		return -E_EOF;
  8038f1:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8038f6:	eb 07                	jmp    8038ff <getchar+0x47>
	return c;
  8038f8:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8038fc:	0f b6 c0             	movzbl %al,%eax
}
  8038ff:	c9                   	leaveq 
  803900:	c3                   	retq   

0000000000803901 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803901:	55                   	push   %rbp
  803902:	48 89 e5             	mov    %rsp,%rbp
  803905:	48 83 ec 20          	sub    $0x20,%rsp
  803909:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80390c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803910:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803913:	48 89 d6             	mov    %rdx,%rsi
  803916:	89 c7                	mov    %eax,%edi
  803918:	48 b8 7e 1d 80 00 00 	movabs $0x801d7e,%rax
  80391f:	00 00 00 
  803922:	ff d0                	callq  *%rax
  803924:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803927:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80392b:	79 05                	jns    803932 <iscons+0x31>
		return r;
  80392d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803930:	eb 1a                	jmp    80394c <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803932:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803936:	8b 10                	mov    (%rax),%edx
  803938:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  80393f:	00 00 00 
  803942:	8b 00                	mov    (%rax),%eax
  803944:	39 c2                	cmp    %eax,%edx
  803946:	0f 94 c0             	sete   %al
  803949:	0f b6 c0             	movzbl %al,%eax
}
  80394c:	c9                   	leaveq 
  80394d:	c3                   	retq   

000000000080394e <opencons>:

int
opencons(void)
{
  80394e:	55                   	push   %rbp
  80394f:	48 89 e5             	mov    %rsp,%rbp
  803952:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803956:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80395a:	48 89 c7             	mov    %rax,%rdi
  80395d:	48 b8 e6 1c 80 00 00 	movabs $0x801ce6,%rax
  803964:	00 00 00 
  803967:	ff d0                	callq  *%rax
  803969:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80396c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803970:	79 05                	jns    803977 <opencons+0x29>
		return r;
  803972:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803975:	eb 5b                	jmp    8039d2 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803977:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80397b:	ba 07 04 00 00       	mov    $0x407,%edx
  803980:	48 89 c6             	mov    %rax,%rsi
  803983:	bf 00 00 00 00       	mov    $0x0,%edi
  803988:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  80398f:	00 00 00 
  803992:	ff d0                	callq  *%rax
  803994:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803997:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80399b:	79 05                	jns    8039a2 <opencons+0x54>
		return r;
  80399d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039a0:	eb 30                	jmp    8039d2 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8039a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039a6:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  8039ad:	00 00 00 
  8039b0:	8b 12                	mov    (%rdx),%edx
  8039b2:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8039b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039b8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8039bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039c3:	48 89 c7             	mov    %rax,%rdi
  8039c6:	48 b8 98 1c 80 00 00 	movabs $0x801c98,%rax
  8039cd:	00 00 00 
  8039d0:	ff d0                	callq  *%rax
}
  8039d2:	c9                   	leaveq 
  8039d3:	c3                   	retq   

00000000008039d4 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8039d4:	55                   	push   %rbp
  8039d5:	48 89 e5             	mov    %rsp,%rbp
  8039d8:	48 83 ec 30          	sub    $0x30,%rsp
  8039dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8039e8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8039ed:	75 07                	jne    8039f6 <devcons_read+0x22>
		return 0;
  8039ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8039f4:	eb 4b                	jmp    803a41 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8039f6:	eb 0c                	jmp    803a04 <devcons_read+0x30>
		sys_yield();
  8039f8:	48 b8 f4 18 80 00 00 	movabs $0x8018f4,%rax
  8039ff:	00 00 00 
  803a02:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  803a04:	48 b8 36 18 80 00 00 	movabs $0x801836,%rax
  803a0b:	00 00 00 
  803a0e:	ff d0                	callq  *%rax
  803a10:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a17:	74 df                	je     8039f8 <devcons_read+0x24>
	if (c < 0)
  803a19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a1d:	79 05                	jns    803a24 <devcons_read+0x50>
		return c;
  803a1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a22:	eb 1d                	jmp    803a41 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803a24:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803a28:	75 07                	jne    803a31 <devcons_read+0x5d>
		return 0;
  803a2a:	b8 00 00 00 00       	mov    $0x0,%eax
  803a2f:	eb 10                	jmp    803a41 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803a31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a34:	89 c2                	mov    %eax,%edx
  803a36:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a3a:	88 10                	mov    %dl,(%rax)
	return 1;
  803a3c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803a41:	c9                   	leaveq 
  803a42:	c3                   	retq   

0000000000803a43 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a43:	55                   	push   %rbp
  803a44:	48 89 e5             	mov    %rsp,%rbp
  803a47:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803a4e:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803a55:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803a5c:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a63:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a6a:	eb 76                	jmp    803ae2 <devcons_write+0x9f>
		m = n - tot;
  803a6c:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803a73:	89 c2                	mov    %eax,%edx
  803a75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a78:	29 c2                	sub    %eax,%edx
  803a7a:	89 d0                	mov    %edx,%eax
  803a7c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803a7f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a82:	83 f8 7f             	cmp    $0x7f,%eax
  803a85:	76 07                	jbe    803a8e <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803a87:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803a8e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a91:	48 63 d0             	movslq %eax,%rdx
  803a94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a97:	48 63 c8             	movslq %eax,%rcx
  803a9a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803aa1:	48 01 c1             	add    %rax,%rcx
  803aa4:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803aab:	48 89 ce             	mov    %rcx,%rsi
  803aae:	48 89 c7             	mov    %rax,%rdi
  803ab1:	48 b8 27 13 80 00 00 	movabs $0x801327,%rax
  803ab8:	00 00 00 
  803abb:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803abd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ac0:	48 63 d0             	movslq %eax,%rdx
  803ac3:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803aca:	48 89 d6             	mov    %rdx,%rsi
  803acd:	48 89 c7             	mov    %rax,%rdi
  803ad0:	48 b8 ea 17 80 00 00 	movabs $0x8017ea,%rax
  803ad7:	00 00 00 
  803ada:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  803adc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803adf:	01 45 fc             	add    %eax,-0x4(%rbp)
  803ae2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ae5:	48 98                	cltq   
  803ae7:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803aee:	0f 82 78 ff ff ff    	jb     803a6c <devcons_write+0x29>
	}
	return tot;
  803af4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803af7:	c9                   	leaveq 
  803af8:	c3                   	retq   

0000000000803af9 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803af9:	55                   	push   %rbp
  803afa:	48 89 e5             	mov    %rsp,%rbp
  803afd:	48 83 ec 08          	sub    $0x8,%rsp
  803b01:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803b05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b0a:	c9                   	leaveq 
  803b0b:	c3                   	retq   

0000000000803b0c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803b0c:	55                   	push   %rbp
  803b0d:	48 89 e5             	mov    %rsp,%rbp
  803b10:	48 83 ec 10          	sub    $0x10,%rsp
  803b14:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803b18:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803b1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b20:	48 be 5c 45 80 00 00 	movabs $0x80455c,%rsi
  803b27:	00 00 00 
  803b2a:	48 89 c7             	mov    %rax,%rdi
  803b2d:	48 b8 03 10 80 00 00 	movabs $0x801003,%rax
  803b34:	00 00 00 
  803b37:	ff d0                	callq  *%rax
	return 0;
  803b39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b3e:	c9                   	leaveq 
  803b3f:	c3                   	retq   

0000000000803b40 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803b40:	55                   	push   %rbp
  803b41:	48 89 e5             	mov    %rsp,%rbp
  803b44:	48 83 ec 20          	sub    $0x20,%rsp
  803b48:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803b4c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803b50:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  803b54:	48 ba 68 45 80 00 00 	movabs $0x804568,%rdx
  803b5b:	00 00 00 
  803b5e:	be 1d 00 00 00       	mov    $0x1d,%esi
  803b63:	48 bf 81 45 80 00 00 	movabs $0x804581,%rdi
  803b6a:	00 00 00 
  803b6d:	b8 00 00 00 00       	mov    $0x0,%eax
  803b72:	48 b9 30 02 80 00 00 	movabs $0x800230,%rcx
  803b79:	00 00 00 
  803b7c:	ff d1                	callq  *%rcx

0000000000803b7e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803b7e:	55                   	push   %rbp
  803b7f:	48 89 e5             	mov    %rsp,%rbp
  803b82:	48 83 ec 20          	sub    $0x20,%rsp
  803b86:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b89:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803b8c:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  803b90:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  803b93:	48 ba 8b 45 80 00 00 	movabs $0x80458b,%rdx
  803b9a:	00 00 00 
  803b9d:	be 2d 00 00 00       	mov    $0x2d,%esi
  803ba2:	48 bf 81 45 80 00 00 	movabs $0x804581,%rdi
  803ba9:	00 00 00 
  803bac:	b8 00 00 00 00       	mov    $0x0,%eax
  803bb1:	48 b9 30 02 80 00 00 	movabs $0x800230,%rcx
  803bb8:	00 00 00 
  803bbb:	ff d1                	callq  *%rcx

0000000000803bbd <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803bbd:	55                   	push   %rbp
  803bbe:	48 89 e5             	mov    %rsp,%rbp
  803bc1:	53                   	push   %rbx
  803bc2:	48 83 ec 48          	sub    $0x48,%rsp
  803bc6:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  803bca:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  803bd1:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  803bd8:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  803bdd:	75 0e                	jne    803bed <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  803bdf:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803be6:	00 00 00 
  803be9:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  803bed:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803bf1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  803bf5:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803bfc:	00 
	a3 = (uint64_t) 0;
  803bfd:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  803c04:	00 
	a4 = (uint64_t) 0;
  803c05:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803c0c:	00 
	a5 = 0;
  803c0d:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  803c14:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  803c15:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c18:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803c1c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803c20:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  803c24:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  803c28:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  803c2c:	4c 89 c3             	mov    %r8,%rbx
  803c2f:	0f 01 c1             	vmcall 
  803c32:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  803c35:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c39:	7e 36                	jle    803c71 <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  803c3b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c3e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c41:	41 89 d0             	mov    %edx,%r8d
  803c44:	89 c1                	mov    %eax,%ecx
  803c46:	48 ba a8 45 80 00 00 	movabs $0x8045a8,%rdx
  803c4d:	00 00 00 
  803c50:	be 54 00 00 00       	mov    $0x54,%esi
  803c55:	48 bf 81 45 80 00 00 	movabs $0x804581,%rdi
  803c5c:	00 00 00 
  803c5f:	b8 00 00 00 00       	mov    $0x0,%eax
  803c64:	49 b9 30 02 80 00 00 	movabs $0x800230,%r9
  803c6b:	00 00 00 
  803c6e:	41 ff d1             	callq  *%r9
	return ret;
  803c71:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803c74:	48 83 c4 48          	add    $0x48,%rsp
  803c78:	5b                   	pop    %rbx
  803c79:	5d                   	pop    %rbp
  803c7a:	c3                   	retq   

0000000000803c7b <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803c7b:	55                   	push   %rbp
  803c7c:	48 89 e5             	mov    %rsp,%rbp
  803c7f:	53                   	push   %rbx
  803c80:	48 83 ec 58          	sub    $0x58,%rsp
  803c84:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  803c87:	89 75 b0             	mov    %esi,-0x50(%rbp)
  803c8a:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  803c8e:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  803c91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  803c98:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  803c9f:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  803ca4:	75 0e                	jne    803cb4 <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  803ca6:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803cad:	00 00 00 
  803cb0:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  803cb4:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  803cb7:	48 98                	cltq   
  803cb9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  803cbd:	8b 45 b0             	mov    -0x50(%rbp),%eax
  803cc0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  803cc4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803cc8:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  803ccc:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  803ccf:	48 98                	cltq   
  803cd1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  803cd5:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803cdc:	00 

	int r = -E_IPC_NOT_RECV;
  803cdd:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  803ce4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803ce7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803ceb:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803cef:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  803cf3:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803cf7:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  803cfb:	4c 89 c3             	mov    %r8,%rbx
  803cfe:	0f 01 c1             	vmcall 
  803d01:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  803d04:	48 83 c4 58          	add    $0x58,%rsp
  803d08:	5b                   	pop    %rbx
  803d09:	5d                   	pop    %rbp
  803d0a:	c3                   	retq   

0000000000803d0b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803d0b:	55                   	push   %rbp
  803d0c:	48 89 e5             	mov    %rsp,%rbp
  803d0f:	48 83 ec 18          	sub    $0x18,%rsp
  803d13:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803d16:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d1d:	eb 4e                	jmp    803d6d <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  803d1f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803d26:	00 00 00 
  803d29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d2c:	48 98                	cltq   
  803d2e:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803d35:	48 01 d0             	add    %rdx,%rax
  803d38:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803d3e:	8b 00                	mov    (%rax),%eax
  803d40:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803d43:	75 24                	jne    803d69 <ipc_find_env+0x5e>
			return envs[i].env_id;
  803d45:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803d4c:	00 00 00 
  803d4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d52:	48 98                	cltq   
  803d54:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803d5b:	48 01 d0             	add    %rdx,%rax
  803d5e:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803d64:	8b 40 08             	mov    0x8(%rax),%eax
  803d67:	eb 12                	jmp    803d7b <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  803d69:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803d6d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803d74:	7e a9                	jle    803d1f <ipc_find_env+0x14>
	}
	return 0;
  803d76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d7b:	c9                   	leaveq 
  803d7c:	c3                   	retq   

0000000000803d7d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803d7d:	55                   	push   %rbp
  803d7e:	48 89 e5             	mov    %rsp,%rbp
  803d81:	48 83 ec 18          	sub    $0x18,%rsp
  803d85:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803d89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d8d:	48 c1 e8 15          	shr    $0x15,%rax
  803d91:	48 89 c2             	mov    %rax,%rdx
  803d94:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803d9b:	01 00 00 
  803d9e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803da2:	83 e0 01             	and    $0x1,%eax
  803da5:	48 85 c0             	test   %rax,%rax
  803da8:	75 07                	jne    803db1 <pageref+0x34>
		return 0;
  803daa:	b8 00 00 00 00       	mov    $0x0,%eax
  803daf:	eb 53                	jmp    803e04 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803db1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803db5:	48 c1 e8 0c          	shr    $0xc,%rax
  803db9:	48 89 c2             	mov    %rax,%rdx
  803dbc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803dc3:	01 00 00 
  803dc6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803dca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803dce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dd2:	83 e0 01             	and    $0x1,%eax
  803dd5:	48 85 c0             	test   %rax,%rax
  803dd8:	75 07                	jne    803de1 <pageref+0x64>
		return 0;
  803dda:	b8 00 00 00 00       	mov    $0x0,%eax
  803ddf:	eb 23                	jmp    803e04 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803de1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803de5:	48 c1 e8 0c          	shr    $0xc,%rax
  803de9:	48 89 c2             	mov    %rax,%rdx
  803dec:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803df3:	00 00 00 
  803df6:	48 c1 e2 04          	shl    $0x4,%rdx
  803dfa:	48 01 d0             	add    %rdx,%rax
  803dfd:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803e01:	0f b7 c0             	movzwl %ax,%eax
}
  803e04:	c9                   	leaveq 
  803e05:	c3                   	retq   
