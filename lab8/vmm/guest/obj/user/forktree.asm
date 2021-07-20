
vmm/guest/obj/user/forktree:     formato del fichero elf64-x86-64


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
  80003c:	e8 29 01 00 00       	callq  80016a <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <forkchild>:

void forktree(const char *cur);

void
forkchild(const char *cur, char branch)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	89 f0                	mov    %esi,%eax
  800051:	88 45 e4             	mov    %al,-0x1c(%rbp)
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
  800054:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800058:	48 89 c7             	mov    %rax,%rdi
  80005b:	48 b8 40 0e 80 00 00 	movabs $0x800e40,%rax
  800062:	00 00 00 
  800065:	ff d0                	callq  *%rax
  800067:	83 f8 02             	cmp    $0x2,%eax
  80006a:	7f 65                	jg     8000d1 <forkchild+0x8e>
		return;

	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  80006c:	0f be 4d e4          	movsbl -0x1c(%rbp),%ecx
  800070:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800074:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800078:	41 89 c8             	mov    %ecx,%r8d
  80007b:	48 89 d1             	mov    %rdx,%rcx
  80007e:	48 ba c0 3e 80 00 00 	movabs $0x803ec0,%rdx
  800085:	00 00 00 
  800088:	be 04 00 00 00       	mov    $0x4,%esi
  80008d:	48 89 c7             	mov    %rax,%rdi
  800090:	b8 00 00 00 00       	mov    $0x0,%eax
  800095:	49 b9 5f 0d 80 00 00 	movabs $0x800d5f,%r9
  80009c:	00 00 00 
  80009f:	41 ff d1             	callq  *%r9
	if (fork() == 0) {
  8000a2:	48 b8 c5 1b 80 00 00 	movabs $0x801bc5,%rax
  8000a9:	00 00 00 
  8000ac:	ff d0                	callq  *%rax
  8000ae:	85 c0                	test   %eax,%eax
  8000b0:	75 1f                	jne    8000d1 <forkchild+0x8e>
		forktree(nxt);
  8000b2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8000b6:	48 89 c7             	mov    %rax,%rdi
  8000b9:	48 b8 d3 00 80 00 00 	movabs $0x8000d3,%rax
  8000c0:	00 00 00 
  8000c3:	ff d0                	callq  *%rax
		exit();
  8000c5:	48 b8 ca 01 80 00 00 	movabs $0x8001ca,%rax
  8000cc:	00 00 00 
  8000cf:	ff d0                	callq  *%rax
	}
}
  8000d1:	c9                   	leaveq 
  8000d2:	c3                   	retq   

00000000008000d3 <forktree>:

void
forktree(const char *cur)
{
  8000d3:	55                   	push   %rbp
  8000d4:	48 89 e5             	mov    %rsp,%rbp
  8000d7:	48 83 ec 10          	sub    $0x10,%rsp
  8000db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  8000df:	48 b8 61 17 80 00 00 	movabs $0x801761,%rax
  8000e6:	00 00 00 
  8000e9:	ff d0                	callq  *%rax
  8000eb:	89 c1                	mov    %eax,%ecx
  8000ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000f1:	48 89 c2             	mov    %rax,%rdx
  8000f4:	89 ce                	mov    %ecx,%esi
  8000f6:	48 bf c5 3e 80 00 00 	movabs $0x803ec5,%rdi
  8000fd:	00 00 00 
  800100:	b8 00 00 00 00       	mov    $0x0,%eax
  800105:	48 b9 12 03 80 00 00 	movabs $0x800312,%rcx
  80010c:	00 00 00 
  80010f:	ff d1                	callq  *%rcx

	forkchild(cur, '0');
  800111:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800115:	be 30 00 00 00       	mov    $0x30,%esi
  80011a:	48 89 c7             	mov    %rax,%rdi
  80011d:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800124:	00 00 00 
  800127:	ff d0                	callq  *%rax
	forkchild(cur, '1');
  800129:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80012d:	be 31 00 00 00       	mov    $0x31,%esi
  800132:	48 89 c7             	mov    %rax,%rdi
  800135:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80013c:	00 00 00 
  80013f:	ff d0                	callq  *%rax
}
  800141:	c9                   	leaveq 
  800142:	c3                   	retq   

0000000000800143 <umain>:

void
umain(int argc, char **argv)
{
  800143:	55                   	push   %rbp
  800144:	48 89 e5             	mov    %rsp,%rbp
  800147:	48 83 ec 10          	sub    $0x10,%rsp
  80014b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80014e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	forktree("");
  800152:	48 bf d6 3e 80 00 00 	movabs $0x803ed6,%rdi
  800159:	00 00 00 
  80015c:	48 b8 d3 00 80 00 00 	movabs $0x8000d3,%rax
  800163:	00 00 00 
  800166:	ff d0                	callq  *%rax
}
  800168:	c9                   	leaveq 
  800169:	c3                   	retq   

000000000080016a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80016a:	55                   	push   %rbp
  80016b:	48 89 e5             	mov    %rsp,%rbp
  80016e:	48 83 ec 10          	sub    $0x10,%rsp
  800172:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800175:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800179:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800180:	00 00 00 
  800183:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80018a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80018e:	7e 14                	jle    8001a4 <libmain+0x3a>
		binaryname = argv[0];
  800190:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800194:	48 8b 10             	mov    (%rax),%rdx
  800197:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80019e:	00 00 00 
  8001a1:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001ab:	48 89 d6             	mov    %rdx,%rsi
  8001ae:	89 c7                	mov    %eax,%edi
  8001b0:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  8001b7:	00 00 00 
  8001ba:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001bc:	48 b8 ca 01 80 00 00 	movabs $0x8001ca,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax
}
  8001c8:	c9                   	leaveq 
  8001c9:	c3                   	retq   

00000000008001ca <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ca:	55                   	push   %rbp
  8001cb:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001ce:	48 b8 64 1f 80 00 00 	movabs $0x801f64,%rax
  8001d5:	00 00 00 
  8001d8:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001da:	bf 00 00 00 00       	mov    $0x0,%edi
  8001df:	48 b8 1b 17 80 00 00 	movabs $0x80171b,%rax
  8001e6:	00 00 00 
  8001e9:	ff d0                	callq  *%rax
}
  8001eb:	5d                   	pop    %rbp
  8001ec:	c3                   	retq   

00000000008001ed <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8001ed:	55                   	push   %rbp
  8001ee:	48 89 e5             	mov    %rsp,%rbp
  8001f1:	48 83 ec 10          	sub    $0x10,%rsp
  8001f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8001fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800200:	8b 00                	mov    (%rax),%eax
  800202:	8d 48 01             	lea    0x1(%rax),%ecx
  800205:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800209:	89 0a                	mov    %ecx,(%rdx)
  80020b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80020e:	89 d1                	mov    %edx,%ecx
  800210:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800214:	48 98                	cltq   
  800216:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80021a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80021e:	8b 00                	mov    (%rax),%eax
  800220:	3d ff 00 00 00       	cmp    $0xff,%eax
  800225:	75 2c                	jne    800253 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800227:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80022b:	8b 00                	mov    (%rax),%eax
  80022d:	48 98                	cltq   
  80022f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800233:	48 83 c2 08          	add    $0x8,%rdx
  800237:	48 89 c6             	mov    %rax,%rsi
  80023a:	48 89 d7             	mov    %rdx,%rdi
  80023d:	48 b8 93 16 80 00 00 	movabs $0x801693,%rax
  800244:	00 00 00 
  800247:	ff d0                	callq  *%rax
        b->idx = 0;
  800249:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80024d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800253:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800257:	8b 40 04             	mov    0x4(%rax),%eax
  80025a:	8d 50 01             	lea    0x1(%rax),%edx
  80025d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800261:	89 50 04             	mov    %edx,0x4(%rax)
}
  800264:	c9                   	leaveq 
  800265:	c3                   	retq   

0000000000800266 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800266:	55                   	push   %rbp
  800267:	48 89 e5             	mov    %rsp,%rbp
  80026a:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800271:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800278:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80027f:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800286:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80028d:	48 8b 0a             	mov    (%rdx),%rcx
  800290:	48 89 08             	mov    %rcx,(%rax)
  800293:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800297:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80029b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80029f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8002a3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002aa:	00 00 00 
    b.cnt = 0;
  8002ad:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002b4:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8002b7:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002be:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002c5:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002cc:	48 89 c6             	mov    %rax,%rsi
  8002cf:	48 bf ed 01 80 00 00 	movabs $0x8001ed,%rdi
  8002d6:	00 00 00 
  8002d9:	48 b8 b1 06 80 00 00 	movabs $0x8006b1,%rax
  8002e0:	00 00 00 
  8002e3:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8002e5:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002eb:	48 98                	cltq   
  8002ed:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8002f4:	48 83 c2 08          	add    $0x8,%rdx
  8002f8:	48 89 c6             	mov    %rax,%rsi
  8002fb:	48 89 d7             	mov    %rdx,%rdi
  8002fe:	48 b8 93 16 80 00 00 	movabs $0x801693,%rax
  800305:	00 00 00 
  800308:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80030a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800310:	c9                   	leaveq 
  800311:	c3                   	retq   

0000000000800312 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800312:	55                   	push   %rbp
  800313:	48 89 e5             	mov    %rsp,%rbp
  800316:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80031d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800324:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80032b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800332:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800339:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800340:	84 c0                	test   %al,%al
  800342:	74 20                	je     800364 <cprintf+0x52>
  800344:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800348:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80034c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800350:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800354:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800358:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80035c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800360:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800364:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80036b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800372:	00 00 00 
  800375:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80037c:	00 00 00 
  80037f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800383:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80038a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800391:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800398:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80039f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003a6:	48 8b 0a             	mov    (%rdx),%rcx
  8003a9:	48 89 08             	mov    %rcx,(%rax)
  8003ac:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003b0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003b4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003b8:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8003bc:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003c3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003ca:	48 89 d6             	mov    %rdx,%rsi
  8003cd:	48 89 c7             	mov    %rax,%rdi
  8003d0:	48 b8 66 02 80 00 00 	movabs $0x800266,%rax
  8003d7:	00 00 00 
  8003da:	ff d0                	callq  *%rax
  8003dc:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8003e2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003e8:	c9                   	leaveq 
  8003e9:	c3                   	retq   

00000000008003ea <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003ea:	55                   	push   %rbp
  8003eb:	48 89 e5             	mov    %rsp,%rbp
  8003ee:	48 83 ec 30          	sub    $0x30,%rsp
  8003f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8003f6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8003fa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8003fe:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800401:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800405:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800409:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80040c:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800410:	77 42                	ja     800454 <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800412:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800415:	8d 78 ff             	lea    -0x1(%rax),%edi
  800418:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  80041b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80041f:	ba 00 00 00 00       	mov    $0x0,%edx
  800424:	48 f7 f6             	div    %rsi
  800427:	49 89 c2             	mov    %rax,%r10
  80042a:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80042d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800430:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800434:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800438:	41 89 c9             	mov    %ecx,%r9d
  80043b:	41 89 f8             	mov    %edi,%r8d
  80043e:	89 d1                	mov    %edx,%ecx
  800440:	4c 89 d2             	mov    %r10,%rdx
  800443:	48 89 c7             	mov    %rax,%rdi
  800446:	48 b8 ea 03 80 00 00 	movabs $0x8003ea,%rax
  80044d:	00 00 00 
  800450:	ff d0                	callq  *%rax
  800452:	eb 1e                	jmp    800472 <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800454:	eb 12                	jmp    800468 <printnum+0x7e>
			putch(padc, putdat);
  800456:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80045a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80045d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800461:	48 89 ce             	mov    %rcx,%rsi
  800464:	89 d7                	mov    %edx,%edi
  800466:	ff d0                	callq  *%rax
		while (--width > 0)
  800468:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80046c:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800470:	7f e4                	jg     800456 <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800472:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800475:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800479:	ba 00 00 00 00       	mov    $0x0,%edx
  80047e:	48 f7 f1             	div    %rcx
  800481:	48 b8 f0 40 80 00 00 	movabs $0x8040f0,%rax
  800488:	00 00 00 
  80048b:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  80048f:	0f be d0             	movsbl %al,%edx
  800492:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800496:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80049a:	48 89 ce             	mov    %rcx,%rsi
  80049d:	89 d7                	mov    %edx,%edi
  80049f:	ff d0                	callq  *%rax
}
  8004a1:	c9                   	leaveq 
  8004a2:	c3                   	retq   

00000000008004a3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004a3:	55                   	push   %rbp
  8004a4:	48 89 e5             	mov    %rsp,%rbp
  8004a7:	48 83 ec 20          	sub    $0x20,%rsp
  8004ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004af:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8004b2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004b6:	7e 4f                	jle    800507 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8004b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004bc:	8b 00                	mov    (%rax),%eax
  8004be:	83 f8 30             	cmp    $0x30,%eax
  8004c1:	73 24                	jae    8004e7 <getuint+0x44>
  8004c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004cf:	8b 00                	mov    (%rax),%eax
  8004d1:	89 c0                	mov    %eax,%eax
  8004d3:	48 01 d0             	add    %rdx,%rax
  8004d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004da:	8b 12                	mov    (%rdx),%edx
  8004dc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e3:	89 0a                	mov    %ecx,(%rdx)
  8004e5:	eb 14                	jmp    8004fb <getuint+0x58>
  8004e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004eb:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004ef:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8004f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004fb:	48 8b 00             	mov    (%rax),%rax
  8004fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800502:	e9 9d 00 00 00       	jmpq   8005a4 <getuint+0x101>
	else if (lflag)
  800507:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80050b:	74 4c                	je     800559 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  80050d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800511:	8b 00                	mov    (%rax),%eax
  800513:	83 f8 30             	cmp    $0x30,%eax
  800516:	73 24                	jae    80053c <getuint+0x99>
  800518:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80051c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800520:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800524:	8b 00                	mov    (%rax),%eax
  800526:	89 c0                	mov    %eax,%eax
  800528:	48 01 d0             	add    %rdx,%rax
  80052b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80052f:	8b 12                	mov    (%rdx),%edx
  800531:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800534:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800538:	89 0a                	mov    %ecx,(%rdx)
  80053a:	eb 14                	jmp    800550 <getuint+0xad>
  80053c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800540:	48 8b 40 08          	mov    0x8(%rax),%rax
  800544:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800548:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80054c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800550:	48 8b 00             	mov    (%rax),%rax
  800553:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800557:	eb 4b                	jmp    8005a4 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800559:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80055d:	8b 00                	mov    (%rax),%eax
  80055f:	83 f8 30             	cmp    $0x30,%eax
  800562:	73 24                	jae    800588 <getuint+0xe5>
  800564:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800568:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80056c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800570:	8b 00                	mov    (%rax),%eax
  800572:	89 c0                	mov    %eax,%eax
  800574:	48 01 d0             	add    %rdx,%rax
  800577:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80057b:	8b 12                	mov    (%rdx),%edx
  80057d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800580:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800584:	89 0a                	mov    %ecx,(%rdx)
  800586:	eb 14                	jmp    80059c <getuint+0xf9>
  800588:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800590:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800594:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800598:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80059c:	8b 00                	mov    (%rax),%eax
  80059e:	89 c0                	mov    %eax,%eax
  8005a0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005a8:	c9                   	leaveq 
  8005a9:	c3                   	retq   

00000000008005aa <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005aa:	55                   	push   %rbp
  8005ab:	48 89 e5             	mov    %rsp,%rbp
  8005ae:	48 83 ec 20          	sub    $0x20,%rsp
  8005b2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005b6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005b9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005bd:	7e 4f                	jle    80060e <getint+0x64>
		x=va_arg(*ap, long long);
  8005bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c3:	8b 00                	mov    (%rax),%eax
  8005c5:	83 f8 30             	cmp    $0x30,%eax
  8005c8:	73 24                	jae    8005ee <getint+0x44>
  8005ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ce:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d6:	8b 00                	mov    (%rax),%eax
  8005d8:	89 c0                	mov    %eax,%eax
  8005da:	48 01 d0             	add    %rdx,%rax
  8005dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005e1:	8b 12                	mov    (%rdx),%edx
  8005e3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ea:	89 0a                	mov    %ecx,(%rdx)
  8005ec:	eb 14                	jmp    800602 <getint+0x58>
  8005ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8005f6:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8005fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005fe:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800602:	48 8b 00             	mov    (%rax),%rax
  800605:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800609:	e9 9d 00 00 00       	jmpq   8006ab <getint+0x101>
	else if (lflag)
  80060e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800612:	74 4c                	je     800660 <getint+0xb6>
		x=va_arg(*ap, long);
  800614:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800618:	8b 00                	mov    (%rax),%eax
  80061a:	83 f8 30             	cmp    $0x30,%eax
  80061d:	73 24                	jae    800643 <getint+0x99>
  80061f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800623:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800627:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062b:	8b 00                	mov    (%rax),%eax
  80062d:	89 c0                	mov    %eax,%eax
  80062f:	48 01 d0             	add    %rdx,%rax
  800632:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800636:	8b 12                	mov    (%rdx),%edx
  800638:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80063b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80063f:	89 0a                	mov    %ecx,(%rdx)
  800641:	eb 14                	jmp    800657 <getint+0xad>
  800643:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800647:	48 8b 40 08          	mov    0x8(%rax),%rax
  80064b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80064f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800653:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800657:	48 8b 00             	mov    (%rax),%rax
  80065a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80065e:	eb 4b                	jmp    8006ab <getint+0x101>
	else
		x=va_arg(*ap, int);
  800660:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800664:	8b 00                	mov    (%rax),%eax
  800666:	83 f8 30             	cmp    $0x30,%eax
  800669:	73 24                	jae    80068f <getint+0xe5>
  80066b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800673:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800677:	8b 00                	mov    (%rax),%eax
  800679:	89 c0                	mov    %eax,%eax
  80067b:	48 01 d0             	add    %rdx,%rax
  80067e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800682:	8b 12                	mov    (%rdx),%edx
  800684:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800687:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068b:	89 0a                	mov    %ecx,(%rdx)
  80068d:	eb 14                	jmp    8006a3 <getint+0xf9>
  80068f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800693:	48 8b 40 08          	mov    0x8(%rax),%rax
  800697:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80069b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80069f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006a3:	8b 00                	mov    (%rax),%eax
  8006a5:	48 98                	cltq   
  8006a7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006af:	c9                   	leaveq 
  8006b0:	c3                   	retq   

00000000008006b1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006b1:	55                   	push   %rbp
  8006b2:	48 89 e5             	mov    %rsp,%rbp
  8006b5:	41 54                	push   %r12
  8006b7:	53                   	push   %rbx
  8006b8:	48 83 ec 60          	sub    $0x60,%rsp
  8006bc:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006c0:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006c4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006c8:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006cc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006d0:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006d4:	48 8b 0a             	mov    (%rdx),%rcx
  8006d7:	48 89 08             	mov    %rcx,(%rax)
  8006da:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006de:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006e2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006e6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006ea:	eb 17                	jmp    800703 <vprintfmt+0x52>
			if (ch == '\0')
  8006ec:	85 db                	test   %ebx,%ebx
  8006ee:	0f 84 c5 04 00 00    	je     800bb9 <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  8006f4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8006f8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8006fc:	48 89 d6             	mov    %rdx,%rsi
  8006ff:	89 df                	mov    %ebx,%edi
  800701:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800703:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800707:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80070b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80070f:	0f b6 00             	movzbl (%rax),%eax
  800712:	0f b6 d8             	movzbl %al,%ebx
  800715:	83 fb 25             	cmp    $0x25,%ebx
  800718:	75 d2                	jne    8006ec <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  80071a:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80071e:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800725:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80072c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800733:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80073a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80073e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800742:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800746:	0f b6 00             	movzbl (%rax),%eax
  800749:	0f b6 d8             	movzbl %al,%ebx
  80074c:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80074f:	83 f8 55             	cmp    $0x55,%eax
  800752:	0f 87 2e 04 00 00    	ja     800b86 <vprintfmt+0x4d5>
  800758:	89 c0                	mov    %eax,%eax
  80075a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800761:	00 
  800762:	48 b8 18 41 80 00 00 	movabs $0x804118,%rax
  800769:	00 00 00 
  80076c:	48 01 d0             	add    %rdx,%rax
  80076f:	48 8b 00             	mov    (%rax),%rax
  800772:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800774:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800778:	eb c0                	jmp    80073a <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80077a:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80077e:	eb ba                	jmp    80073a <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800780:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800787:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80078a:	89 d0                	mov    %edx,%eax
  80078c:	c1 e0 02             	shl    $0x2,%eax
  80078f:	01 d0                	add    %edx,%eax
  800791:	01 c0                	add    %eax,%eax
  800793:	01 d8                	add    %ebx,%eax
  800795:	83 e8 30             	sub    $0x30,%eax
  800798:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80079b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80079f:	0f b6 00             	movzbl (%rax),%eax
  8007a2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007a5:	83 fb 2f             	cmp    $0x2f,%ebx
  8007a8:	7e 0c                	jle    8007b6 <vprintfmt+0x105>
  8007aa:	83 fb 39             	cmp    $0x39,%ebx
  8007ad:	7f 07                	jg     8007b6 <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  8007af:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  8007b4:	eb d1                	jmp    800787 <vprintfmt+0xd6>
			goto process_precision;
  8007b6:	eb 50                	jmp    800808 <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  8007b8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007bb:	83 f8 30             	cmp    $0x30,%eax
  8007be:	73 17                	jae    8007d7 <vprintfmt+0x126>
  8007c0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8007c4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007c7:	89 d2                	mov    %edx,%edx
  8007c9:	48 01 d0             	add    %rdx,%rax
  8007cc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007cf:	83 c2 08             	add    $0x8,%edx
  8007d2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007d5:	eb 0c                	jmp    8007e3 <vprintfmt+0x132>
  8007d7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8007db:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8007df:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007e3:	8b 00                	mov    (%rax),%eax
  8007e5:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8007e8:	eb 1e                	jmp    800808 <vprintfmt+0x157>

		case '.':
			if (width < 0)
  8007ea:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007ee:	79 07                	jns    8007f7 <vprintfmt+0x146>
				width = 0;
  8007f0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8007f7:	e9 3e ff ff ff       	jmpq   80073a <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8007fc:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800803:	e9 32 ff ff ff       	jmpq   80073a <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800808:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80080c:	79 0d                	jns    80081b <vprintfmt+0x16a>
				width = precision, precision = -1;
  80080e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800811:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800814:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80081b:	e9 1a ff ff ff       	jmpq   80073a <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800820:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800824:	e9 11 ff ff ff       	jmpq   80073a <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800829:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80082c:	83 f8 30             	cmp    $0x30,%eax
  80082f:	73 17                	jae    800848 <vprintfmt+0x197>
  800831:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800835:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800838:	89 d2                	mov    %edx,%edx
  80083a:	48 01 d0             	add    %rdx,%rax
  80083d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800840:	83 c2 08             	add    $0x8,%edx
  800843:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800846:	eb 0c                	jmp    800854 <vprintfmt+0x1a3>
  800848:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80084c:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800850:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800854:	8b 10                	mov    (%rax),%edx
  800856:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80085a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80085e:	48 89 ce             	mov    %rcx,%rsi
  800861:	89 d7                	mov    %edx,%edi
  800863:	ff d0                	callq  *%rax
			break;
  800865:	e9 4a 03 00 00       	jmpq   800bb4 <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80086a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80086d:	83 f8 30             	cmp    $0x30,%eax
  800870:	73 17                	jae    800889 <vprintfmt+0x1d8>
  800872:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800876:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800879:	89 d2                	mov    %edx,%edx
  80087b:	48 01 d0             	add    %rdx,%rax
  80087e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800881:	83 c2 08             	add    $0x8,%edx
  800884:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800887:	eb 0c                	jmp    800895 <vprintfmt+0x1e4>
  800889:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80088d:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800891:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800895:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800897:	85 db                	test   %ebx,%ebx
  800899:	79 02                	jns    80089d <vprintfmt+0x1ec>
				err = -err;
  80089b:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80089d:	83 fb 15             	cmp    $0x15,%ebx
  8008a0:	7f 16                	jg     8008b8 <vprintfmt+0x207>
  8008a2:	48 b8 40 40 80 00 00 	movabs $0x804040,%rax
  8008a9:	00 00 00 
  8008ac:	48 63 d3             	movslq %ebx,%rdx
  8008af:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008b3:	4d 85 e4             	test   %r12,%r12
  8008b6:	75 2e                	jne    8008e6 <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  8008b8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008bc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008c0:	89 d9                	mov    %ebx,%ecx
  8008c2:	48 ba 01 41 80 00 00 	movabs $0x804101,%rdx
  8008c9:	00 00 00 
  8008cc:	48 89 c7             	mov    %rax,%rdi
  8008cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d4:	49 b8 c2 0b 80 00 00 	movabs $0x800bc2,%r8
  8008db:	00 00 00 
  8008de:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008e1:	e9 ce 02 00 00       	jmpq   800bb4 <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  8008e6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008ea:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008ee:	4c 89 e1             	mov    %r12,%rcx
  8008f1:	48 ba 0a 41 80 00 00 	movabs $0x80410a,%rdx
  8008f8:	00 00 00 
  8008fb:	48 89 c7             	mov    %rax,%rdi
  8008fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800903:	49 b8 c2 0b 80 00 00 	movabs $0x800bc2,%r8
  80090a:	00 00 00 
  80090d:	41 ff d0             	callq  *%r8
			break;
  800910:	e9 9f 02 00 00       	jmpq   800bb4 <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800915:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800918:	83 f8 30             	cmp    $0x30,%eax
  80091b:	73 17                	jae    800934 <vprintfmt+0x283>
  80091d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800921:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800924:	89 d2                	mov    %edx,%edx
  800926:	48 01 d0             	add    %rdx,%rax
  800929:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80092c:	83 c2 08             	add    $0x8,%edx
  80092f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800932:	eb 0c                	jmp    800940 <vprintfmt+0x28f>
  800934:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800938:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80093c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800940:	4c 8b 20             	mov    (%rax),%r12
  800943:	4d 85 e4             	test   %r12,%r12
  800946:	75 0a                	jne    800952 <vprintfmt+0x2a1>
				p = "(null)";
  800948:	49 bc 0d 41 80 00 00 	movabs $0x80410d,%r12
  80094f:	00 00 00 
			if (width > 0 && padc != '-')
  800952:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800956:	7e 3f                	jle    800997 <vprintfmt+0x2e6>
  800958:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80095c:	74 39                	je     800997 <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80095e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800961:	48 98                	cltq   
  800963:	48 89 c6             	mov    %rax,%rsi
  800966:	4c 89 e7             	mov    %r12,%rdi
  800969:	48 b8 6e 0e 80 00 00 	movabs $0x800e6e,%rax
  800970:	00 00 00 
  800973:	ff d0                	callq  *%rax
  800975:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800978:	eb 17                	jmp    800991 <vprintfmt+0x2e0>
					putch(padc, putdat);
  80097a:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80097e:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800982:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800986:	48 89 ce             	mov    %rcx,%rsi
  800989:	89 d7                	mov    %edx,%edi
  80098b:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  80098d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800991:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800995:	7f e3                	jg     80097a <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800997:	eb 37                	jmp    8009d0 <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  800999:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80099d:	74 1e                	je     8009bd <vprintfmt+0x30c>
  80099f:	83 fb 1f             	cmp    $0x1f,%ebx
  8009a2:	7e 05                	jle    8009a9 <vprintfmt+0x2f8>
  8009a4:	83 fb 7e             	cmp    $0x7e,%ebx
  8009a7:	7e 14                	jle    8009bd <vprintfmt+0x30c>
					putch('?', putdat);
  8009a9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009ad:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009b1:	48 89 d6             	mov    %rdx,%rsi
  8009b4:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009b9:	ff d0                	callq  *%rax
  8009bb:	eb 0f                	jmp    8009cc <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  8009bd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009c1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009c5:	48 89 d6             	mov    %rdx,%rsi
  8009c8:	89 df                	mov    %ebx,%edi
  8009ca:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009cc:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009d0:	4c 89 e0             	mov    %r12,%rax
  8009d3:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8009d7:	0f b6 00             	movzbl (%rax),%eax
  8009da:	0f be d8             	movsbl %al,%ebx
  8009dd:	85 db                	test   %ebx,%ebx
  8009df:	74 10                	je     8009f1 <vprintfmt+0x340>
  8009e1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009e5:	78 b2                	js     800999 <vprintfmt+0x2e8>
  8009e7:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8009eb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009ef:	79 a8                	jns    800999 <vprintfmt+0x2e8>
			for (; width > 0; width--)
  8009f1:	eb 16                	jmp    800a09 <vprintfmt+0x358>
				putch(' ', putdat);
  8009f3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009f7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009fb:	48 89 d6             	mov    %rdx,%rsi
  8009fe:	bf 20 00 00 00       	mov    $0x20,%edi
  800a03:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  800a05:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a09:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a0d:	7f e4                	jg     8009f3 <vprintfmt+0x342>
			break;
  800a0f:	e9 a0 01 00 00       	jmpq   800bb4 <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a14:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a18:	be 03 00 00 00       	mov    $0x3,%esi
  800a1d:	48 89 c7             	mov    %rax,%rdi
  800a20:	48 b8 aa 05 80 00 00 	movabs $0x8005aa,%rax
  800a27:	00 00 00 
  800a2a:	ff d0                	callq  *%rax
  800a2c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a34:	48 85 c0             	test   %rax,%rax
  800a37:	79 1d                	jns    800a56 <vprintfmt+0x3a5>
				putch('-', putdat);
  800a39:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a41:	48 89 d6             	mov    %rdx,%rsi
  800a44:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a49:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a4f:	48 f7 d8             	neg    %rax
  800a52:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a56:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a5d:	e9 e5 00 00 00       	jmpq   800b47 <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a62:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a66:	be 03 00 00 00       	mov    $0x3,%esi
  800a6b:	48 89 c7             	mov    %rax,%rdi
  800a6e:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800a75:	00 00 00 
  800a78:	ff d0                	callq  *%rax
  800a7a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a7e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a85:	e9 bd 00 00 00       	jmpq   800b47 <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a8a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a8e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a92:	48 89 d6             	mov    %rdx,%rsi
  800a95:	bf 58 00 00 00       	mov    $0x58,%edi
  800a9a:	ff d0                	callq  *%rax
			putch('X', putdat);
  800a9c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aa0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa4:	48 89 d6             	mov    %rdx,%rsi
  800aa7:	bf 58 00 00 00       	mov    $0x58,%edi
  800aac:	ff d0                	callq  *%rax
			putch('X', putdat);
  800aae:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ab2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab6:	48 89 d6             	mov    %rdx,%rsi
  800ab9:	bf 58 00 00 00       	mov    $0x58,%edi
  800abe:	ff d0                	callq  *%rax
			break;
  800ac0:	e9 ef 00 00 00       	jmpq   800bb4 <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  800ac5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ac9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800acd:	48 89 d6             	mov    %rdx,%rsi
  800ad0:	bf 30 00 00 00       	mov    $0x30,%edi
  800ad5:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ad7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800adb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800adf:	48 89 d6             	mov    %rdx,%rsi
  800ae2:	bf 78 00 00 00       	mov    $0x78,%edi
  800ae7:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ae9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aec:	83 f8 30             	cmp    $0x30,%eax
  800aef:	73 17                	jae    800b08 <vprintfmt+0x457>
  800af1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800af5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800af8:	89 d2                	mov    %edx,%edx
  800afa:	48 01 d0             	add    %rdx,%rax
  800afd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b00:	83 c2 08             	add    $0x8,%edx
  800b03:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  800b06:	eb 0c                	jmp    800b14 <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  800b08:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b0c:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b10:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b14:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  800b17:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b1b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b22:	eb 23                	jmp    800b47 <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b24:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b28:	be 03 00 00 00       	mov    $0x3,%esi
  800b2d:	48 89 c7             	mov    %rax,%rdi
  800b30:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800b37:	00 00 00 
  800b3a:	ff d0                	callq  *%rax
  800b3c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b40:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b47:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b4c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b4f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b52:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b56:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b5a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b5e:	45 89 c1             	mov    %r8d,%r9d
  800b61:	41 89 f8             	mov    %edi,%r8d
  800b64:	48 89 c7             	mov    %rax,%rdi
  800b67:	48 b8 ea 03 80 00 00 	movabs $0x8003ea,%rax
  800b6e:	00 00 00 
  800b71:	ff d0                	callq  *%rax
			break;
  800b73:	eb 3f                	jmp    800bb4 <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b75:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b79:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b7d:	48 89 d6             	mov    %rdx,%rsi
  800b80:	89 df                	mov    %ebx,%edi
  800b82:	ff d0                	callq  *%rax
			break;
  800b84:	eb 2e                	jmp    800bb4 <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b86:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b8a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8e:	48 89 d6             	mov    %rdx,%rsi
  800b91:	bf 25 00 00 00       	mov    $0x25,%edi
  800b96:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b98:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b9d:	eb 05                	jmp    800ba4 <vprintfmt+0x4f3>
  800b9f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ba4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ba8:	48 83 e8 01          	sub    $0x1,%rax
  800bac:	0f b6 00             	movzbl (%rax),%eax
  800baf:	3c 25                	cmp    $0x25,%al
  800bb1:	75 ec                	jne    800b9f <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  800bb3:	90                   	nop
		}
	}
  800bb4:	e9 31 fb ff ff       	jmpq   8006ea <vprintfmt+0x39>
	va_end(aq);
}
  800bb9:	48 83 c4 60          	add    $0x60,%rsp
  800bbd:	5b                   	pop    %rbx
  800bbe:	41 5c                	pop    %r12
  800bc0:	5d                   	pop    %rbp
  800bc1:	c3                   	retq   

0000000000800bc2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bc2:	55                   	push   %rbp
  800bc3:	48 89 e5             	mov    %rsp,%rbp
  800bc6:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800bcd:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800bd4:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800bdb:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800be2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800be9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800bf0:	84 c0                	test   %al,%al
  800bf2:	74 20                	je     800c14 <printfmt+0x52>
  800bf4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800bf8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800bfc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c00:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c04:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c08:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c0c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c10:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c14:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c1b:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c22:	00 00 00 
  800c25:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c2c:	00 00 00 
  800c2f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c33:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c3a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c41:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c48:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c4f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c56:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c5d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c64:	48 89 c7             	mov    %rax,%rdi
  800c67:	48 b8 b1 06 80 00 00 	movabs $0x8006b1,%rax
  800c6e:	00 00 00 
  800c71:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c73:	c9                   	leaveq 
  800c74:	c3                   	retq   

0000000000800c75 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c75:	55                   	push   %rbp
  800c76:	48 89 e5             	mov    %rsp,%rbp
  800c79:	48 83 ec 10          	sub    $0x10,%rsp
  800c7d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c80:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c88:	8b 40 10             	mov    0x10(%rax),%eax
  800c8b:	8d 50 01             	lea    0x1(%rax),%edx
  800c8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c92:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c99:	48 8b 10             	mov    (%rax),%rdx
  800c9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ca0:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ca4:	48 39 c2             	cmp    %rax,%rdx
  800ca7:	73 17                	jae    800cc0 <sprintputch+0x4b>
		*b->buf++ = ch;
  800ca9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cad:	48 8b 00             	mov    (%rax),%rax
  800cb0:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800cb4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cb8:	48 89 0a             	mov    %rcx,(%rdx)
  800cbb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800cbe:	88 10                	mov    %dl,(%rax)
}
  800cc0:	c9                   	leaveq 
  800cc1:	c3                   	retq   

0000000000800cc2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cc2:	55                   	push   %rbp
  800cc3:	48 89 e5             	mov    %rsp,%rbp
  800cc6:	48 83 ec 50          	sub    $0x50,%rsp
  800cca:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800cce:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800cd1:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800cd5:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800cd9:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800cdd:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ce1:	48 8b 0a             	mov    (%rdx),%rcx
  800ce4:	48 89 08             	mov    %rcx,(%rax)
  800ce7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ceb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800cef:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cf3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cf7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cfb:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800cff:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d02:	48 98                	cltq   
  800d04:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d08:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d0c:	48 01 d0             	add    %rdx,%rax
  800d0f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d13:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d1a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d1f:	74 06                	je     800d27 <vsnprintf+0x65>
  800d21:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d25:	7f 07                	jg     800d2e <vsnprintf+0x6c>
		return -E_INVAL;
  800d27:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d2c:	eb 2f                	jmp    800d5d <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d2e:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d32:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d36:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d3a:	48 89 c6             	mov    %rax,%rsi
  800d3d:	48 bf 75 0c 80 00 00 	movabs $0x800c75,%rdi
  800d44:	00 00 00 
  800d47:	48 b8 b1 06 80 00 00 	movabs $0x8006b1,%rax
  800d4e:	00 00 00 
  800d51:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d53:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d57:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d5a:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d5d:	c9                   	leaveq 
  800d5e:	c3                   	retq   

0000000000800d5f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d5f:	55                   	push   %rbp
  800d60:	48 89 e5             	mov    %rsp,%rbp
  800d63:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d6a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d71:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d77:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d7e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d85:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d8c:	84 c0                	test   %al,%al
  800d8e:	74 20                	je     800db0 <snprintf+0x51>
  800d90:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d94:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d98:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d9c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800da0:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800da4:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800da8:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dac:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800db0:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800db7:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800dbe:	00 00 00 
  800dc1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800dc8:	00 00 00 
  800dcb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dcf:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800dd6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ddd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800de4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800deb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800df2:	48 8b 0a             	mov    (%rdx),%rcx
  800df5:	48 89 08             	mov    %rcx,(%rax)
  800df8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dfc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e00:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e04:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e08:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e0f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e16:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e1c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e23:	48 89 c7             	mov    %rax,%rdi
  800e26:	48 b8 c2 0c 80 00 00 	movabs $0x800cc2,%rax
  800e2d:	00 00 00 
  800e30:	ff d0                	callq  *%rax
  800e32:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e38:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e3e:	c9                   	leaveq 
  800e3f:	c3                   	retq   

0000000000800e40 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e40:	55                   	push   %rbp
  800e41:	48 89 e5             	mov    %rsp,%rbp
  800e44:	48 83 ec 18          	sub    $0x18,%rsp
  800e48:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e53:	eb 09                	jmp    800e5e <strlen+0x1e>
		n++;
  800e55:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  800e59:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e62:	0f b6 00             	movzbl (%rax),%eax
  800e65:	84 c0                	test   %al,%al
  800e67:	75 ec                	jne    800e55 <strlen+0x15>
	return n;
  800e69:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e6c:	c9                   	leaveq 
  800e6d:	c3                   	retq   

0000000000800e6e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e6e:	55                   	push   %rbp
  800e6f:	48 89 e5             	mov    %rsp,%rbp
  800e72:	48 83 ec 20          	sub    $0x20,%rsp
  800e76:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e7a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e7e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e85:	eb 0e                	jmp    800e95 <strnlen+0x27>
		n++;
  800e87:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e8b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e90:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e95:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e9a:	74 0b                	je     800ea7 <strnlen+0x39>
  800e9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea0:	0f b6 00             	movzbl (%rax),%eax
  800ea3:	84 c0                	test   %al,%al
  800ea5:	75 e0                	jne    800e87 <strnlen+0x19>
	return n;
  800ea7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800eaa:	c9                   	leaveq 
  800eab:	c3                   	retq   

0000000000800eac <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800eac:	55                   	push   %rbp
  800ead:	48 89 e5             	mov    %rsp,%rbp
  800eb0:	48 83 ec 20          	sub    $0x20,%rsp
  800eb4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eb8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800ebc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800ec4:	90                   	nop
  800ec5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ecd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ed1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ed5:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800ed9:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800edd:	0f b6 12             	movzbl (%rdx),%edx
  800ee0:	88 10                	mov    %dl,(%rax)
  800ee2:	0f b6 00             	movzbl (%rax),%eax
  800ee5:	84 c0                	test   %al,%al
  800ee7:	75 dc                	jne    800ec5 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800ee9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800eed:	c9                   	leaveq 
  800eee:	c3                   	retq   

0000000000800eef <strcat>:

char *
strcat(char *dst, const char *src)
{
  800eef:	55                   	push   %rbp
  800ef0:	48 89 e5             	mov    %rsp,%rbp
  800ef3:	48 83 ec 20          	sub    $0x20,%rsp
  800ef7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800efb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800eff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f03:	48 89 c7             	mov    %rax,%rdi
  800f06:	48 b8 40 0e 80 00 00 	movabs $0x800e40,%rax
  800f0d:	00 00 00 
  800f10:	ff d0                	callq  *%rax
  800f12:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f18:	48 63 d0             	movslq %eax,%rdx
  800f1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f1f:	48 01 c2             	add    %rax,%rdx
  800f22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f26:	48 89 c6             	mov    %rax,%rsi
  800f29:	48 89 d7             	mov    %rdx,%rdi
  800f2c:	48 b8 ac 0e 80 00 00 	movabs $0x800eac,%rax
  800f33:	00 00 00 
  800f36:	ff d0                	callq  *%rax
	return dst;
  800f38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f3c:	c9                   	leaveq 
  800f3d:	c3                   	retq   

0000000000800f3e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f3e:	55                   	push   %rbp
  800f3f:	48 89 e5             	mov    %rsp,%rbp
  800f42:	48 83 ec 28          	sub    $0x28,%rsp
  800f46:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f4a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f4e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f56:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f5a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f61:	00 
  800f62:	eb 2a                	jmp    800f8e <strncpy+0x50>
		*dst++ = *src;
  800f64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f68:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f6c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f70:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f74:	0f b6 12             	movzbl (%rdx),%edx
  800f77:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f79:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f7d:	0f b6 00             	movzbl (%rax),%eax
  800f80:	84 c0                	test   %al,%al
  800f82:	74 05                	je     800f89 <strncpy+0x4b>
			src++;
  800f84:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  800f89:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f92:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f96:	72 cc                	jb     800f64 <strncpy+0x26>
	}
	return ret;
  800f98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f9c:	c9                   	leaveq 
  800f9d:	c3                   	retq   

0000000000800f9e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f9e:	55                   	push   %rbp
  800f9f:	48 89 e5             	mov    %rsp,%rbp
  800fa2:	48 83 ec 28          	sub    $0x28,%rsp
  800fa6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800faa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800fb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800fba:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fbf:	74 3d                	je     800ffe <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800fc1:	eb 1d                	jmp    800fe0 <strlcpy+0x42>
			*dst++ = *src++;
  800fc3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fc7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fcb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fcf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fd3:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fd7:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fdb:	0f b6 12             	movzbl (%rdx),%edx
  800fde:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  800fe0:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800fe5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fea:	74 0b                	je     800ff7 <strlcpy+0x59>
  800fec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ff0:	0f b6 00             	movzbl (%rax),%eax
  800ff3:	84 c0                	test   %al,%al
  800ff5:	75 cc                	jne    800fc3 <strlcpy+0x25>
		*dst = '\0';
  800ff7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ffb:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800ffe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801002:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801006:	48 29 c2             	sub    %rax,%rdx
  801009:	48 89 d0             	mov    %rdx,%rax
}
  80100c:	c9                   	leaveq 
  80100d:	c3                   	retq   

000000000080100e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80100e:	55                   	push   %rbp
  80100f:	48 89 e5             	mov    %rsp,%rbp
  801012:	48 83 ec 10          	sub    $0x10,%rsp
  801016:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80101a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80101e:	eb 0a                	jmp    80102a <strcmp+0x1c>
		p++, q++;
  801020:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801025:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  80102a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80102e:	0f b6 00             	movzbl (%rax),%eax
  801031:	84 c0                	test   %al,%al
  801033:	74 12                	je     801047 <strcmp+0x39>
  801035:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801039:	0f b6 10             	movzbl (%rax),%edx
  80103c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801040:	0f b6 00             	movzbl (%rax),%eax
  801043:	38 c2                	cmp    %al,%dl
  801045:	74 d9                	je     801020 <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801047:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80104b:	0f b6 00             	movzbl (%rax),%eax
  80104e:	0f b6 d0             	movzbl %al,%edx
  801051:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801055:	0f b6 00             	movzbl (%rax),%eax
  801058:	0f b6 c0             	movzbl %al,%eax
  80105b:	29 c2                	sub    %eax,%edx
  80105d:	89 d0                	mov    %edx,%eax
}
  80105f:	c9                   	leaveq 
  801060:	c3                   	retq   

0000000000801061 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801061:	55                   	push   %rbp
  801062:	48 89 e5             	mov    %rsp,%rbp
  801065:	48 83 ec 18          	sub    $0x18,%rsp
  801069:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80106d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801071:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801075:	eb 0f                	jmp    801086 <strncmp+0x25>
		n--, p++, q++;
  801077:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80107c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801081:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  801086:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80108b:	74 1d                	je     8010aa <strncmp+0x49>
  80108d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801091:	0f b6 00             	movzbl (%rax),%eax
  801094:	84 c0                	test   %al,%al
  801096:	74 12                	je     8010aa <strncmp+0x49>
  801098:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80109c:	0f b6 10             	movzbl (%rax),%edx
  80109f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010a3:	0f b6 00             	movzbl (%rax),%eax
  8010a6:	38 c2                	cmp    %al,%dl
  8010a8:	74 cd                	je     801077 <strncmp+0x16>
	if (n == 0)
  8010aa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010af:	75 07                	jne    8010b8 <strncmp+0x57>
		return 0;
  8010b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b6:	eb 18                	jmp    8010d0 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010bc:	0f b6 00             	movzbl (%rax),%eax
  8010bf:	0f b6 d0             	movzbl %al,%edx
  8010c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c6:	0f b6 00             	movzbl (%rax),%eax
  8010c9:	0f b6 c0             	movzbl %al,%eax
  8010cc:	29 c2                	sub    %eax,%edx
  8010ce:	89 d0                	mov    %edx,%eax
}
  8010d0:	c9                   	leaveq 
  8010d1:	c3                   	retq   

00000000008010d2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010d2:	55                   	push   %rbp
  8010d3:	48 89 e5             	mov    %rsp,%rbp
  8010d6:	48 83 ec 10          	sub    $0x10,%rsp
  8010da:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010de:	89 f0                	mov    %esi,%eax
  8010e0:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010e3:	eb 17                	jmp    8010fc <strchr+0x2a>
		if (*s == c)
  8010e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e9:	0f b6 00             	movzbl (%rax),%eax
  8010ec:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010ef:	75 06                	jne    8010f7 <strchr+0x25>
			return (char *) s;
  8010f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f5:	eb 15                	jmp    80110c <strchr+0x3a>
	for (; *s; s++)
  8010f7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801100:	0f b6 00             	movzbl (%rax),%eax
  801103:	84 c0                	test   %al,%al
  801105:	75 de                	jne    8010e5 <strchr+0x13>
	return 0;
  801107:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80110c:	c9                   	leaveq 
  80110d:	c3                   	retq   

000000000080110e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80110e:	55                   	push   %rbp
  80110f:	48 89 e5             	mov    %rsp,%rbp
  801112:	48 83 ec 10          	sub    $0x10,%rsp
  801116:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80111a:	89 f0                	mov    %esi,%eax
  80111c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80111f:	eb 13                	jmp    801134 <strfind+0x26>
		if (*s == c)
  801121:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801125:	0f b6 00             	movzbl (%rax),%eax
  801128:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80112b:	75 02                	jne    80112f <strfind+0x21>
			break;
  80112d:	eb 10                	jmp    80113f <strfind+0x31>
	for (; *s; s++)
  80112f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801134:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801138:	0f b6 00             	movzbl (%rax),%eax
  80113b:	84 c0                	test   %al,%al
  80113d:	75 e2                	jne    801121 <strfind+0x13>
	return (char *) s;
  80113f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801143:	c9                   	leaveq 
  801144:	c3                   	retq   

0000000000801145 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801145:	55                   	push   %rbp
  801146:	48 89 e5             	mov    %rsp,%rbp
  801149:	48 83 ec 18          	sub    $0x18,%rsp
  80114d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801151:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801154:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801158:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80115d:	75 06                	jne    801165 <memset+0x20>
		return v;
  80115f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801163:	eb 69                	jmp    8011ce <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801165:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801169:	83 e0 03             	and    $0x3,%eax
  80116c:	48 85 c0             	test   %rax,%rax
  80116f:	75 48                	jne    8011b9 <memset+0x74>
  801171:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801175:	83 e0 03             	and    $0x3,%eax
  801178:	48 85 c0             	test   %rax,%rax
  80117b:	75 3c                	jne    8011b9 <memset+0x74>
		c &= 0xFF;
  80117d:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801184:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801187:	c1 e0 18             	shl    $0x18,%eax
  80118a:	89 c2                	mov    %eax,%edx
  80118c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80118f:	c1 e0 10             	shl    $0x10,%eax
  801192:	09 c2                	or     %eax,%edx
  801194:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801197:	c1 e0 08             	shl    $0x8,%eax
  80119a:	09 d0                	or     %edx,%eax
  80119c:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80119f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a3:	48 c1 e8 02          	shr    $0x2,%rax
  8011a7:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  8011aa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011ae:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011b1:	48 89 d7             	mov    %rdx,%rdi
  8011b4:	fc                   	cld    
  8011b5:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011b7:	eb 11                	jmp    8011ca <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011b9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011bd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011c0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011c4:	48 89 d7             	mov    %rdx,%rdi
  8011c7:	fc                   	cld    
  8011c8:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8011ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011ce:	c9                   	leaveq 
  8011cf:	c3                   	retq   

00000000008011d0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011d0:	55                   	push   %rbp
  8011d1:	48 89 e5             	mov    %rsp,%rbp
  8011d4:	48 83 ec 28          	sub    $0x28,%rsp
  8011d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011e0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8011e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011e8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8011ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8011f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f8:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011fc:	0f 83 88 00 00 00    	jae    80128a <memmove+0xba>
  801202:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801206:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80120a:	48 01 d0             	add    %rdx,%rax
  80120d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801211:	76 77                	jbe    80128a <memmove+0xba>
		s += n;
  801213:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801217:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80121b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80121f:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801223:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801227:	83 e0 03             	and    $0x3,%eax
  80122a:	48 85 c0             	test   %rax,%rax
  80122d:	75 3b                	jne    80126a <memmove+0x9a>
  80122f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801233:	83 e0 03             	and    $0x3,%eax
  801236:	48 85 c0             	test   %rax,%rax
  801239:	75 2f                	jne    80126a <memmove+0x9a>
  80123b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80123f:	83 e0 03             	and    $0x3,%eax
  801242:	48 85 c0             	test   %rax,%rax
  801245:	75 23                	jne    80126a <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801247:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80124b:	48 83 e8 04          	sub    $0x4,%rax
  80124f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801253:	48 83 ea 04          	sub    $0x4,%rdx
  801257:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80125b:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  80125f:	48 89 c7             	mov    %rax,%rdi
  801262:	48 89 d6             	mov    %rdx,%rsi
  801265:	fd                   	std    
  801266:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801268:	eb 1d                	jmp    801287 <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80126a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80126e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801272:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801276:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  80127a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80127e:	48 89 d7             	mov    %rdx,%rdi
  801281:	48 89 c1             	mov    %rax,%rcx
  801284:	fd                   	std    
  801285:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801287:	fc                   	cld    
  801288:	eb 57                	jmp    8012e1 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80128a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128e:	83 e0 03             	and    $0x3,%eax
  801291:	48 85 c0             	test   %rax,%rax
  801294:	75 36                	jne    8012cc <memmove+0xfc>
  801296:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80129a:	83 e0 03             	and    $0x3,%eax
  80129d:	48 85 c0             	test   %rax,%rax
  8012a0:	75 2a                	jne    8012cc <memmove+0xfc>
  8012a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012a6:	83 e0 03             	and    $0x3,%eax
  8012a9:	48 85 c0             	test   %rax,%rax
  8012ac:	75 1e                	jne    8012cc <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012b2:	48 c1 e8 02          	shr    $0x2,%rax
  8012b6:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  8012b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012bd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012c1:	48 89 c7             	mov    %rax,%rdi
  8012c4:	48 89 d6             	mov    %rdx,%rsi
  8012c7:	fc                   	cld    
  8012c8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012ca:	eb 15                	jmp    8012e1 <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  8012cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012d4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012d8:	48 89 c7             	mov    %rax,%rdi
  8012db:	48 89 d6             	mov    %rdx,%rsi
  8012de:	fc                   	cld    
  8012df:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8012e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012e5:	c9                   	leaveq 
  8012e6:	c3                   	retq   

00000000008012e7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8012e7:	55                   	push   %rbp
  8012e8:	48 89 e5             	mov    %rsp,%rbp
  8012eb:	48 83 ec 18          	sub    $0x18,%rsp
  8012ef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012f7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8012fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012ff:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801303:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801307:	48 89 ce             	mov    %rcx,%rsi
  80130a:	48 89 c7             	mov    %rax,%rdi
  80130d:	48 b8 d0 11 80 00 00 	movabs $0x8011d0,%rax
  801314:	00 00 00 
  801317:	ff d0                	callq  *%rax
}
  801319:	c9                   	leaveq 
  80131a:	c3                   	retq   

000000000080131b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80131b:	55                   	push   %rbp
  80131c:	48 89 e5             	mov    %rsp,%rbp
  80131f:	48 83 ec 28          	sub    $0x28,%rsp
  801323:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801327:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80132b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80132f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801333:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801337:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80133b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80133f:	eb 36                	jmp    801377 <memcmp+0x5c>
		if (*s1 != *s2)
  801341:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801345:	0f b6 10             	movzbl (%rax),%edx
  801348:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80134c:	0f b6 00             	movzbl (%rax),%eax
  80134f:	38 c2                	cmp    %al,%dl
  801351:	74 1a                	je     80136d <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801353:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801357:	0f b6 00             	movzbl (%rax),%eax
  80135a:	0f b6 d0             	movzbl %al,%edx
  80135d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801361:	0f b6 00             	movzbl (%rax),%eax
  801364:	0f b6 c0             	movzbl %al,%eax
  801367:	29 c2                	sub    %eax,%edx
  801369:	89 d0                	mov    %edx,%eax
  80136b:	eb 20                	jmp    80138d <memcmp+0x72>
		s1++, s2++;
  80136d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801372:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  801377:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80137b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80137f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801383:	48 85 c0             	test   %rax,%rax
  801386:	75 b9                	jne    801341 <memcmp+0x26>
	}

	return 0;
  801388:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80138d:	c9                   	leaveq 
  80138e:	c3                   	retq   

000000000080138f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80138f:	55                   	push   %rbp
  801390:	48 89 e5             	mov    %rsp,%rbp
  801393:	48 83 ec 28          	sub    $0x28,%rsp
  801397:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80139b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80139e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013aa:	48 01 d0             	add    %rdx,%rax
  8013ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013b1:	eb 15                	jmp    8013c8 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b7:	0f b6 00             	movzbl (%rax),%eax
  8013ba:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8013bd:	38 d0                	cmp    %dl,%al
  8013bf:	75 02                	jne    8013c3 <memfind+0x34>
			break;
  8013c1:	eb 0f                	jmp    8013d2 <memfind+0x43>
	for (; s < ends; s++)
  8013c3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013cc:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8013d0:	72 e1                	jb     8013b3 <memfind+0x24>
	return (void *) s;
  8013d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013d6:	c9                   	leaveq 
  8013d7:	c3                   	retq   

00000000008013d8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013d8:	55                   	push   %rbp
  8013d9:	48 89 e5             	mov    %rsp,%rbp
  8013dc:	48 83 ec 38          	sub    $0x38,%rsp
  8013e0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8013e4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8013e8:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8013eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8013f2:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8013f9:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013fa:	eb 05                	jmp    801401 <strtol+0x29>
		s++;
  8013fc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  801401:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801405:	0f b6 00             	movzbl (%rax),%eax
  801408:	3c 20                	cmp    $0x20,%al
  80140a:	74 f0                	je     8013fc <strtol+0x24>
  80140c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801410:	0f b6 00             	movzbl (%rax),%eax
  801413:	3c 09                	cmp    $0x9,%al
  801415:	74 e5                	je     8013fc <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  801417:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80141b:	0f b6 00             	movzbl (%rax),%eax
  80141e:	3c 2b                	cmp    $0x2b,%al
  801420:	75 07                	jne    801429 <strtol+0x51>
		s++;
  801422:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801427:	eb 17                	jmp    801440 <strtol+0x68>
	else if (*s == '-')
  801429:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142d:	0f b6 00             	movzbl (%rax),%eax
  801430:	3c 2d                	cmp    $0x2d,%al
  801432:	75 0c                	jne    801440 <strtol+0x68>
		s++, neg = 1;
  801434:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801439:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801440:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801444:	74 06                	je     80144c <strtol+0x74>
  801446:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80144a:	75 28                	jne    801474 <strtol+0x9c>
  80144c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801450:	0f b6 00             	movzbl (%rax),%eax
  801453:	3c 30                	cmp    $0x30,%al
  801455:	75 1d                	jne    801474 <strtol+0x9c>
  801457:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145b:	48 83 c0 01          	add    $0x1,%rax
  80145f:	0f b6 00             	movzbl (%rax),%eax
  801462:	3c 78                	cmp    $0x78,%al
  801464:	75 0e                	jne    801474 <strtol+0x9c>
		s += 2, base = 16;
  801466:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80146b:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801472:	eb 2c                	jmp    8014a0 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801474:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801478:	75 19                	jne    801493 <strtol+0xbb>
  80147a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147e:	0f b6 00             	movzbl (%rax),%eax
  801481:	3c 30                	cmp    $0x30,%al
  801483:	75 0e                	jne    801493 <strtol+0xbb>
		s++, base = 8;
  801485:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80148a:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801491:	eb 0d                	jmp    8014a0 <strtol+0xc8>
	else if (base == 0)
  801493:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801497:	75 07                	jne    8014a0 <strtol+0xc8>
		base = 10;
  801499:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a4:	0f b6 00             	movzbl (%rax),%eax
  8014a7:	3c 2f                	cmp    $0x2f,%al
  8014a9:	7e 1d                	jle    8014c8 <strtol+0xf0>
  8014ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014af:	0f b6 00             	movzbl (%rax),%eax
  8014b2:	3c 39                	cmp    $0x39,%al
  8014b4:	7f 12                	jg     8014c8 <strtol+0xf0>
			dig = *s - '0';
  8014b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ba:	0f b6 00             	movzbl (%rax),%eax
  8014bd:	0f be c0             	movsbl %al,%eax
  8014c0:	83 e8 30             	sub    $0x30,%eax
  8014c3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014c6:	eb 4e                	jmp    801516 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8014c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014cc:	0f b6 00             	movzbl (%rax),%eax
  8014cf:	3c 60                	cmp    $0x60,%al
  8014d1:	7e 1d                	jle    8014f0 <strtol+0x118>
  8014d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d7:	0f b6 00             	movzbl (%rax),%eax
  8014da:	3c 7a                	cmp    $0x7a,%al
  8014dc:	7f 12                	jg     8014f0 <strtol+0x118>
			dig = *s - 'a' + 10;
  8014de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e2:	0f b6 00             	movzbl (%rax),%eax
  8014e5:	0f be c0             	movsbl %al,%eax
  8014e8:	83 e8 57             	sub    $0x57,%eax
  8014eb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014ee:	eb 26                	jmp    801516 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8014f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f4:	0f b6 00             	movzbl (%rax),%eax
  8014f7:	3c 40                	cmp    $0x40,%al
  8014f9:	7e 48                	jle    801543 <strtol+0x16b>
  8014fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ff:	0f b6 00             	movzbl (%rax),%eax
  801502:	3c 5a                	cmp    $0x5a,%al
  801504:	7f 3d                	jg     801543 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801506:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150a:	0f b6 00             	movzbl (%rax),%eax
  80150d:	0f be c0             	movsbl %al,%eax
  801510:	83 e8 37             	sub    $0x37,%eax
  801513:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801516:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801519:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80151c:	7c 02                	jl     801520 <strtol+0x148>
			break;
  80151e:	eb 23                	jmp    801543 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801520:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801525:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801528:	48 98                	cltq   
  80152a:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80152f:	48 89 c2             	mov    %rax,%rdx
  801532:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801535:	48 98                	cltq   
  801537:	48 01 d0             	add    %rdx,%rax
  80153a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80153e:	e9 5d ff ff ff       	jmpq   8014a0 <strtol+0xc8>

	if (endptr)
  801543:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801548:	74 0b                	je     801555 <strtol+0x17d>
		*endptr = (char *) s;
  80154a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80154e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801552:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801555:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801559:	74 09                	je     801564 <strtol+0x18c>
  80155b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80155f:	48 f7 d8             	neg    %rax
  801562:	eb 04                	jmp    801568 <strtol+0x190>
  801564:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801568:	c9                   	leaveq 
  801569:	c3                   	retq   

000000000080156a <strstr>:

char * strstr(const char *in, const char *str)
{
  80156a:	55                   	push   %rbp
  80156b:	48 89 e5             	mov    %rsp,%rbp
  80156e:	48 83 ec 30          	sub    $0x30,%rsp
  801572:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801576:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80157a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80157e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801582:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801586:	0f b6 00             	movzbl (%rax),%eax
  801589:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80158c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801590:	75 06                	jne    801598 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801592:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801596:	eb 6b                	jmp    801603 <strstr+0x99>

	len = strlen(str);
  801598:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80159c:	48 89 c7             	mov    %rax,%rdi
  80159f:	48 b8 40 0e 80 00 00 	movabs $0x800e40,%rax
  8015a6:	00 00 00 
  8015a9:	ff d0                	callq  *%rax
  8015ab:	48 98                	cltq   
  8015ad:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8015b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015bd:	0f b6 00             	movzbl (%rax),%eax
  8015c0:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8015c3:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8015c7:	75 07                	jne    8015d0 <strstr+0x66>
				return (char *) 0;
  8015c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ce:	eb 33                	jmp    801603 <strstr+0x99>
		} while (sc != c);
  8015d0:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8015d4:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8015d7:	75 d8                	jne    8015b1 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8015d9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015dd:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8015e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e5:	48 89 ce             	mov    %rcx,%rsi
  8015e8:	48 89 c7             	mov    %rax,%rdi
  8015eb:	48 b8 61 10 80 00 00 	movabs $0x801061,%rax
  8015f2:	00 00 00 
  8015f5:	ff d0                	callq  *%rax
  8015f7:	85 c0                	test   %eax,%eax
  8015f9:	75 b6                	jne    8015b1 <strstr+0x47>

	return (char *) (in - 1);
  8015fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ff:	48 83 e8 01          	sub    $0x1,%rax
}
  801603:	c9                   	leaveq 
  801604:	c3                   	retq   

0000000000801605 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801605:	55                   	push   %rbp
  801606:	48 89 e5             	mov    %rsp,%rbp
  801609:	53                   	push   %rbx
  80160a:	48 83 ec 48          	sub    $0x48,%rsp
  80160e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801611:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801614:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801618:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80161c:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801620:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801624:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801627:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80162b:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80162f:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801633:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801637:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80163b:	4c 89 c3             	mov    %r8,%rbx
  80163e:	cd 30                	int    $0x30
  801640:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801644:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801648:	74 3e                	je     801688 <syscall+0x83>
  80164a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80164f:	7e 37                	jle    801688 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801651:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801655:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801658:	49 89 d0             	mov    %rdx,%r8
  80165b:	89 c1                	mov    %eax,%ecx
  80165d:	48 ba c8 43 80 00 00 	movabs $0x8043c8,%rdx
  801664:	00 00 00 
  801667:	be 23 00 00 00       	mov    $0x23,%esi
  80166c:	48 bf e5 43 80 00 00 	movabs $0x8043e5,%rdi
  801673:	00 00 00 
  801676:	b8 00 00 00 00       	mov    $0x0,%eax
  80167b:	49 b9 c9 3a 80 00 00 	movabs $0x803ac9,%r9
  801682:	00 00 00 
  801685:	41 ff d1             	callq  *%r9

	return ret;
  801688:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80168c:	48 83 c4 48          	add    $0x48,%rsp
  801690:	5b                   	pop    %rbx
  801691:	5d                   	pop    %rbp
  801692:	c3                   	retq   

0000000000801693 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801693:	55                   	push   %rbp
  801694:	48 89 e5             	mov    %rsp,%rbp
  801697:	48 83 ec 10          	sub    $0x10,%rsp
  80169b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80169f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016ab:	48 83 ec 08          	sub    $0x8,%rsp
  8016af:	6a 00                	pushq  $0x0
  8016b1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016b7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016bd:	48 89 d1             	mov    %rdx,%rcx
  8016c0:	48 89 c2             	mov    %rax,%rdx
  8016c3:	be 00 00 00 00       	mov    $0x0,%esi
  8016c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8016cd:	48 b8 05 16 80 00 00 	movabs $0x801605,%rax
  8016d4:	00 00 00 
  8016d7:	ff d0                	callq  *%rax
  8016d9:	48 83 c4 10          	add    $0x10,%rsp
}
  8016dd:	c9                   	leaveq 
  8016de:	c3                   	retq   

00000000008016df <sys_cgetc>:

int
sys_cgetc(void)
{
  8016df:	55                   	push   %rbp
  8016e0:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8016e3:	48 83 ec 08          	sub    $0x8,%rsp
  8016e7:	6a 00                	pushq  $0x0
  8016e9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016ef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ff:	be 00 00 00 00       	mov    $0x0,%esi
  801704:	bf 01 00 00 00       	mov    $0x1,%edi
  801709:	48 b8 05 16 80 00 00 	movabs $0x801605,%rax
  801710:	00 00 00 
  801713:	ff d0                	callq  *%rax
  801715:	48 83 c4 10          	add    $0x10,%rsp
}
  801719:	c9                   	leaveq 
  80171a:	c3                   	retq   

000000000080171b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80171b:	55                   	push   %rbp
  80171c:	48 89 e5             	mov    %rsp,%rbp
  80171f:	48 83 ec 10          	sub    $0x10,%rsp
  801723:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801726:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801729:	48 98                	cltq   
  80172b:	48 83 ec 08          	sub    $0x8,%rsp
  80172f:	6a 00                	pushq  $0x0
  801731:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801737:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80173d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801742:	48 89 c2             	mov    %rax,%rdx
  801745:	be 01 00 00 00       	mov    $0x1,%esi
  80174a:	bf 03 00 00 00       	mov    $0x3,%edi
  80174f:	48 b8 05 16 80 00 00 	movabs $0x801605,%rax
  801756:	00 00 00 
  801759:	ff d0                	callq  *%rax
  80175b:	48 83 c4 10          	add    $0x10,%rsp
}
  80175f:	c9                   	leaveq 
  801760:	c3                   	retq   

0000000000801761 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801761:	55                   	push   %rbp
  801762:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801765:	48 83 ec 08          	sub    $0x8,%rsp
  801769:	6a 00                	pushq  $0x0
  80176b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801771:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801777:	b9 00 00 00 00       	mov    $0x0,%ecx
  80177c:	ba 00 00 00 00       	mov    $0x0,%edx
  801781:	be 00 00 00 00       	mov    $0x0,%esi
  801786:	bf 02 00 00 00       	mov    $0x2,%edi
  80178b:	48 b8 05 16 80 00 00 	movabs $0x801605,%rax
  801792:	00 00 00 
  801795:	ff d0                	callq  *%rax
  801797:	48 83 c4 10          	add    $0x10,%rsp
}
  80179b:	c9                   	leaveq 
  80179c:	c3                   	retq   

000000000080179d <sys_yield>:

void
sys_yield(void)
{
  80179d:	55                   	push   %rbp
  80179e:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017a1:	48 83 ec 08          	sub    $0x8,%rsp
  8017a5:	6a 00                	pushq  $0x0
  8017a7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017ad:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017b3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017bd:	be 00 00 00 00       	mov    $0x0,%esi
  8017c2:	bf 0b 00 00 00       	mov    $0xb,%edi
  8017c7:	48 b8 05 16 80 00 00 	movabs $0x801605,%rax
  8017ce:	00 00 00 
  8017d1:	ff d0                	callq  *%rax
  8017d3:	48 83 c4 10          	add    $0x10,%rsp
}
  8017d7:	c9                   	leaveq 
  8017d8:	c3                   	retq   

00000000008017d9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8017d9:	55                   	push   %rbp
  8017da:	48 89 e5             	mov    %rsp,%rbp
  8017dd:	48 83 ec 10          	sub    $0x10,%rsp
  8017e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017e4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017e8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8017eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017ee:	48 63 c8             	movslq %eax,%rcx
  8017f1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017f8:	48 98                	cltq   
  8017fa:	48 83 ec 08          	sub    $0x8,%rsp
  8017fe:	6a 00                	pushq  $0x0
  801800:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801806:	49 89 c8             	mov    %rcx,%r8
  801809:	48 89 d1             	mov    %rdx,%rcx
  80180c:	48 89 c2             	mov    %rax,%rdx
  80180f:	be 01 00 00 00       	mov    $0x1,%esi
  801814:	bf 04 00 00 00       	mov    $0x4,%edi
  801819:	48 b8 05 16 80 00 00 	movabs $0x801605,%rax
  801820:	00 00 00 
  801823:	ff d0                	callq  *%rax
  801825:	48 83 c4 10          	add    $0x10,%rsp
}
  801829:	c9                   	leaveq 
  80182a:	c3                   	retq   

000000000080182b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80182b:	55                   	push   %rbp
  80182c:	48 89 e5             	mov    %rsp,%rbp
  80182f:	48 83 ec 20          	sub    $0x20,%rsp
  801833:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801836:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80183a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80183d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801841:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801845:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801848:	48 63 c8             	movslq %eax,%rcx
  80184b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80184f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801852:	48 63 f0             	movslq %eax,%rsi
  801855:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801859:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80185c:	48 98                	cltq   
  80185e:	48 83 ec 08          	sub    $0x8,%rsp
  801862:	51                   	push   %rcx
  801863:	49 89 f9             	mov    %rdi,%r9
  801866:	49 89 f0             	mov    %rsi,%r8
  801869:	48 89 d1             	mov    %rdx,%rcx
  80186c:	48 89 c2             	mov    %rax,%rdx
  80186f:	be 01 00 00 00       	mov    $0x1,%esi
  801874:	bf 05 00 00 00       	mov    $0x5,%edi
  801879:	48 b8 05 16 80 00 00 	movabs $0x801605,%rax
  801880:	00 00 00 
  801883:	ff d0                	callq  *%rax
  801885:	48 83 c4 10          	add    $0x10,%rsp
}
  801889:	c9                   	leaveq 
  80188a:	c3                   	retq   

000000000080188b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80188b:	55                   	push   %rbp
  80188c:	48 89 e5             	mov    %rsp,%rbp
  80188f:	48 83 ec 10          	sub    $0x10,%rsp
  801893:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801896:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80189a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80189e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018a1:	48 98                	cltq   
  8018a3:	48 83 ec 08          	sub    $0x8,%rsp
  8018a7:	6a 00                	pushq  $0x0
  8018a9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018af:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018b5:	48 89 d1             	mov    %rdx,%rcx
  8018b8:	48 89 c2             	mov    %rax,%rdx
  8018bb:	be 01 00 00 00       	mov    $0x1,%esi
  8018c0:	bf 06 00 00 00       	mov    $0x6,%edi
  8018c5:	48 b8 05 16 80 00 00 	movabs $0x801605,%rax
  8018cc:	00 00 00 
  8018cf:	ff d0                	callq  *%rax
  8018d1:	48 83 c4 10          	add    $0x10,%rsp
}
  8018d5:	c9                   	leaveq 
  8018d6:	c3                   	retq   

00000000008018d7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018d7:	55                   	push   %rbp
  8018d8:	48 89 e5             	mov    %rsp,%rbp
  8018db:	48 83 ec 10          	sub    $0x10,%rsp
  8018df:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018e2:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8018e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018e8:	48 63 d0             	movslq %eax,%rdx
  8018eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ee:	48 98                	cltq   
  8018f0:	48 83 ec 08          	sub    $0x8,%rsp
  8018f4:	6a 00                	pushq  $0x0
  8018f6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018fc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801902:	48 89 d1             	mov    %rdx,%rcx
  801905:	48 89 c2             	mov    %rax,%rdx
  801908:	be 01 00 00 00       	mov    $0x1,%esi
  80190d:	bf 08 00 00 00       	mov    $0x8,%edi
  801912:	48 b8 05 16 80 00 00 	movabs $0x801605,%rax
  801919:	00 00 00 
  80191c:	ff d0                	callq  *%rax
  80191e:	48 83 c4 10          	add    $0x10,%rsp
}
  801922:	c9                   	leaveq 
  801923:	c3                   	retq   

0000000000801924 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801924:	55                   	push   %rbp
  801925:	48 89 e5             	mov    %rsp,%rbp
  801928:	48 83 ec 10          	sub    $0x10,%rsp
  80192c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80192f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801933:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801937:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80193a:	48 98                	cltq   
  80193c:	48 83 ec 08          	sub    $0x8,%rsp
  801940:	6a 00                	pushq  $0x0
  801942:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801948:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80194e:	48 89 d1             	mov    %rdx,%rcx
  801951:	48 89 c2             	mov    %rax,%rdx
  801954:	be 01 00 00 00       	mov    $0x1,%esi
  801959:	bf 09 00 00 00       	mov    $0x9,%edi
  80195e:	48 b8 05 16 80 00 00 	movabs $0x801605,%rax
  801965:	00 00 00 
  801968:	ff d0                	callq  *%rax
  80196a:	48 83 c4 10          	add    $0x10,%rsp
}
  80196e:	c9                   	leaveq 
  80196f:	c3                   	retq   

0000000000801970 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801970:	55                   	push   %rbp
  801971:	48 89 e5             	mov    %rsp,%rbp
  801974:	48 83 ec 10          	sub    $0x10,%rsp
  801978:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80197b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80197f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801983:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801986:	48 98                	cltq   
  801988:	48 83 ec 08          	sub    $0x8,%rsp
  80198c:	6a 00                	pushq  $0x0
  80198e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801994:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80199a:	48 89 d1             	mov    %rdx,%rcx
  80199d:	48 89 c2             	mov    %rax,%rdx
  8019a0:	be 01 00 00 00       	mov    $0x1,%esi
  8019a5:	bf 0a 00 00 00       	mov    $0xa,%edi
  8019aa:	48 b8 05 16 80 00 00 	movabs $0x801605,%rax
  8019b1:	00 00 00 
  8019b4:	ff d0                	callq  *%rax
  8019b6:	48 83 c4 10          	add    $0x10,%rsp
}
  8019ba:	c9                   	leaveq 
  8019bb:	c3                   	retq   

00000000008019bc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8019bc:	55                   	push   %rbp
  8019bd:	48 89 e5             	mov    %rsp,%rbp
  8019c0:	48 83 ec 20          	sub    $0x20,%rsp
  8019c4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019cb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019cf:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8019d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019d5:	48 63 f0             	movslq %eax,%rsi
  8019d8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019df:	48 98                	cltq   
  8019e1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019e5:	48 83 ec 08          	sub    $0x8,%rsp
  8019e9:	6a 00                	pushq  $0x0
  8019eb:	49 89 f1             	mov    %rsi,%r9
  8019ee:	49 89 c8             	mov    %rcx,%r8
  8019f1:	48 89 d1             	mov    %rdx,%rcx
  8019f4:	48 89 c2             	mov    %rax,%rdx
  8019f7:	be 00 00 00 00       	mov    $0x0,%esi
  8019fc:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a01:	48 b8 05 16 80 00 00 	movabs $0x801605,%rax
  801a08:	00 00 00 
  801a0b:	ff d0                	callq  *%rax
  801a0d:	48 83 c4 10          	add    $0x10,%rsp
}
  801a11:	c9                   	leaveq 
  801a12:	c3                   	retq   

0000000000801a13 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a13:	55                   	push   %rbp
  801a14:	48 89 e5             	mov    %rsp,%rbp
  801a17:	48 83 ec 10          	sub    $0x10,%rsp
  801a1b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a23:	48 83 ec 08          	sub    $0x8,%rsp
  801a27:	6a 00                	pushq  $0x0
  801a29:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a2f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a35:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a3a:	48 89 c2             	mov    %rax,%rdx
  801a3d:	be 01 00 00 00       	mov    $0x1,%esi
  801a42:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a47:	48 b8 05 16 80 00 00 	movabs $0x801605,%rax
  801a4e:	00 00 00 
  801a51:	ff d0                	callq  *%rax
  801a53:	48 83 c4 10          	add    $0x10,%rsp
}
  801a57:	c9                   	leaveq 
  801a58:	c3                   	retq   

0000000000801a59 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801a59:	55                   	push   %rbp
  801a5a:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801a5d:	48 83 ec 08          	sub    $0x8,%rsp
  801a61:	6a 00                	pushq  $0x0
  801a63:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a69:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a6f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a74:	ba 00 00 00 00       	mov    $0x0,%edx
  801a79:	be 00 00 00 00       	mov    $0x0,%esi
  801a7e:	bf 0e 00 00 00       	mov    $0xe,%edi
  801a83:	48 b8 05 16 80 00 00 	movabs $0x801605,%rax
  801a8a:	00 00 00 
  801a8d:	ff d0                	callq  *%rax
  801a8f:	48 83 c4 10          	add    $0x10,%rsp
}
  801a93:	c9                   	leaveq 
  801a94:	c3                   	retq   

0000000000801a95 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801a95:	55                   	push   %rbp
  801a96:	48 89 e5             	mov    %rsp,%rbp
  801a99:	48 83 ec 20          	sub    $0x20,%rsp
  801a9d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aa0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801aa4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801aa7:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801aab:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801aaf:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ab2:	48 63 c8             	movslq %eax,%rcx
  801ab5:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ab9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801abc:	48 63 f0             	movslq %eax,%rsi
  801abf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ac3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac6:	48 98                	cltq   
  801ac8:	48 83 ec 08          	sub    $0x8,%rsp
  801acc:	51                   	push   %rcx
  801acd:	49 89 f9             	mov    %rdi,%r9
  801ad0:	49 89 f0             	mov    %rsi,%r8
  801ad3:	48 89 d1             	mov    %rdx,%rcx
  801ad6:	48 89 c2             	mov    %rax,%rdx
  801ad9:	be 00 00 00 00       	mov    $0x0,%esi
  801ade:	bf 0f 00 00 00       	mov    $0xf,%edi
  801ae3:	48 b8 05 16 80 00 00 	movabs $0x801605,%rax
  801aea:	00 00 00 
  801aed:	ff d0                	callq  *%rax
  801aef:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801af3:	c9                   	leaveq 
  801af4:	c3                   	retq   

0000000000801af5 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801af5:	55                   	push   %rbp
  801af6:	48 89 e5             	mov    %rsp,%rbp
  801af9:	48 83 ec 10          	sub    $0x10,%rsp
  801afd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b01:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801b05:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b0d:	48 83 ec 08          	sub    $0x8,%rsp
  801b11:	6a 00                	pushq  $0x0
  801b13:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b19:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b1f:	48 89 d1             	mov    %rdx,%rcx
  801b22:	48 89 c2             	mov    %rax,%rdx
  801b25:	be 00 00 00 00       	mov    $0x0,%esi
  801b2a:	bf 10 00 00 00       	mov    $0x10,%edi
  801b2f:	48 b8 05 16 80 00 00 	movabs $0x801605,%rax
  801b36:	00 00 00 
  801b39:	ff d0                	callq  *%rax
  801b3b:	48 83 c4 10          	add    $0x10,%rsp
}
  801b3f:	c9                   	leaveq 
  801b40:	c3                   	retq   

0000000000801b41 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801b41:	55                   	push   %rbp
  801b42:	48 89 e5             	mov    %rsp,%rbp
  801b45:	48 83 ec 20          	sub    $0x20,%rsp
  801b49:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801b4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b51:	48 8b 00             	mov    (%rax),%rax
  801b54:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801b58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b5c:	48 8b 40 08          	mov    0x8(%rax),%rax
  801b60:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  801b63:	48 ba f3 43 80 00 00 	movabs $0x8043f3,%rdx
  801b6a:	00 00 00 
  801b6d:	be 26 00 00 00       	mov    $0x26,%esi
  801b72:	48 bf 0b 44 80 00 00 	movabs $0x80440b,%rdi
  801b79:	00 00 00 
  801b7c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b81:	48 b9 c9 3a 80 00 00 	movabs $0x803ac9,%rcx
  801b88:	00 00 00 
  801b8b:	ff d1                	callq  *%rcx

0000000000801b8d <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801b8d:	55                   	push   %rbp
  801b8e:	48 89 e5             	mov    %rsp,%rbp
  801b91:	48 83 ec 10          	sub    $0x10,%rsp
  801b95:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b98:	89 75 f8             	mov    %esi,-0x8(%rbp)
	int r;

	// LAB 4: Your code here.
	panic("duppage not implemented");
  801b9b:	48 ba 16 44 80 00 00 	movabs $0x804416,%rdx
  801ba2:	00 00 00 
  801ba5:	be 3a 00 00 00       	mov    $0x3a,%esi
  801baa:	48 bf 0b 44 80 00 00 	movabs $0x80440b,%rdi
  801bb1:	00 00 00 
  801bb4:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb9:	48 b9 c9 3a 80 00 00 	movabs $0x803ac9,%rcx
  801bc0:	00 00 00 
  801bc3:	ff d1                	callq  *%rcx

0000000000801bc5 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801bc5:	55                   	push   %rbp
  801bc6:	48 89 e5             	mov    %rsp,%rbp
	// LAB 4: Your code here.
	panic("fork not implemented");
  801bc9:	48 ba 2e 44 80 00 00 	movabs $0x80442e,%rdx
  801bd0:	00 00 00 
  801bd3:	be 52 00 00 00       	mov    $0x52,%esi
  801bd8:	48 bf 0b 44 80 00 00 	movabs $0x80440b,%rdi
  801bdf:	00 00 00 
  801be2:	b8 00 00 00 00       	mov    $0x0,%eax
  801be7:	48 b9 c9 3a 80 00 00 	movabs $0x803ac9,%rcx
  801bee:	00 00 00 
  801bf1:	ff d1                	callq  *%rcx

0000000000801bf3 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801bf3:	55                   	push   %rbp
  801bf4:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  801bf7:	48 ba 43 44 80 00 00 	movabs $0x804443,%rdx
  801bfe:	00 00 00 
  801c01:	be 59 00 00 00       	mov    $0x59,%esi
  801c06:	48 bf 0b 44 80 00 00 	movabs $0x80440b,%rdi
  801c0d:	00 00 00 
  801c10:	b8 00 00 00 00       	mov    $0x0,%eax
  801c15:	48 b9 c9 3a 80 00 00 	movabs $0x803ac9,%rcx
  801c1c:	00 00 00 
  801c1f:	ff d1                	callq  *%rcx

0000000000801c21 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801c21:	55                   	push   %rbp
  801c22:	48 89 e5             	mov    %rsp,%rbp
  801c25:	48 83 ec 08          	sub    $0x8,%rsp
  801c29:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801c2d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c31:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801c38:	ff ff ff 
  801c3b:	48 01 d0             	add    %rdx,%rax
  801c3e:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801c42:	c9                   	leaveq 
  801c43:	c3                   	retq   

0000000000801c44 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801c44:	55                   	push   %rbp
  801c45:	48 89 e5             	mov    %rsp,%rbp
  801c48:	48 83 ec 08          	sub    $0x8,%rsp
  801c4c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801c50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c54:	48 89 c7             	mov    %rax,%rdi
  801c57:	48 b8 21 1c 80 00 00 	movabs $0x801c21,%rax
  801c5e:	00 00 00 
  801c61:	ff d0                	callq  *%rax
  801c63:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801c69:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801c6d:	c9                   	leaveq 
  801c6e:	c3                   	retq   

0000000000801c6f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801c6f:	55                   	push   %rbp
  801c70:	48 89 e5             	mov    %rsp,%rbp
  801c73:	48 83 ec 18          	sub    $0x18,%rsp
  801c77:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801c7b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c82:	eb 6b                	jmp    801cef <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801c84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c87:	48 98                	cltq   
  801c89:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801c8f:	48 c1 e0 0c          	shl    $0xc,%rax
  801c93:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801c97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c9b:	48 c1 e8 15          	shr    $0x15,%rax
  801c9f:	48 89 c2             	mov    %rax,%rdx
  801ca2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ca9:	01 00 00 
  801cac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cb0:	83 e0 01             	and    $0x1,%eax
  801cb3:	48 85 c0             	test   %rax,%rax
  801cb6:	74 21                	je     801cd9 <fd_alloc+0x6a>
  801cb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cbc:	48 c1 e8 0c          	shr    $0xc,%rax
  801cc0:	48 89 c2             	mov    %rax,%rdx
  801cc3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801cca:	01 00 00 
  801ccd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cd1:	83 e0 01             	and    $0x1,%eax
  801cd4:	48 85 c0             	test   %rax,%rax
  801cd7:	75 12                	jne    801ceb <fd_alloc+0x7c>
			*fd_store = fd;
  801cd9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cdd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ce1:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801ce4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce9:	eb 1a                	jmp    801d05 <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  801ceb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801cef:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801cf3:	7e 8f                	jle    801c84 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  801cf5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cf9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801d00:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801d05:	c9                   	leaveq 
  801d06:	c3                   	retq   

0000000000801d07 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d07:	55                   	push   %rbp
  801d08:	48 89 e5             	mov    %rsp,%rbp
  801d0b:	48 83 ec 20          	sub    $0x20,%rsp
  801d0f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d12:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801d16:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d1a:	78 06                	js     801d22 <fd_lookup+0x1b>
  801d1c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801d20:	7e 07                	jle    801d29 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d22:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d27:	eb 6c                	jmp    801d95 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801d29:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d2c:	48 98                	cltq   
  801d2e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d34:	48 c1 e0 0c          	shl    $0xc,%rax
  801d38:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801d3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d40:	48 c1 e8 15          	shr    $0x15,%rax
  801d44:	48 89 c2             	mov    %rax,%rdx
  801d47:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d4e:	01 00 00 
  801d51:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d55:	83 e0 01             	and    $0x1,%eax
  801d58:	48 85 c0             	test   %rax,%rax
  801d5b:	74 21                	je     801d7e <fd_lookup+0x77>
  801d5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d61:	48 c1 e8 0c          	shr    $0xc,%rax
  801d65:	48 89 c2             	mov    %rax,%rdx
  801d68:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d6f:	01 00 00 
  801d72:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d76:	83 e0 01             	and    $0x1,%eax
  801d79:	48 85 c0             	test   %rax,%rax
  801d7c:	75 07                	jne    801d85 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d7e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d83:	eb 10                	jmp    801d95 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801d85:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d89:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d8d:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801d90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d95:	c9                   	leaveq 
  801d96:	c3                   	retq   

0000000000801d97 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801d97:	55                   	push   %rbp
  801d98:	48 89 e5             	mov    %rsp,%rbp
  801d9b:	48 83 ec 30          	sub    $0x30,%rsp
  801d9f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801da3:	89 f0                	mov    %esi,%eax
  801da5:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801da8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dac:	48 89 c7             	mov    %rax,%rdi
  801daf:	48 b8 21 1c 80 00 00 	movabs $0x801c21,%rax
  801db6:	00 00 00 
  801db9:	ff d0                	callq  *%rax
  801dbb:	89 c2                	mov    %eax,%edx
  801dbd:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801dc1:	48 89 c6             	mov    %rax,%rsi
  801dc4:	89 d7                	mov    %edx,%edi
  801dc6:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  801dcd:	00 00 00 
  801dd0:	ff d0                	callq  *%rax
  801dd2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801dd5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801dd9:	78 0a                	js     801de5 <fd_close+0x4e>
	    || fd != fd2)
  801ddb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ddf:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801de3:	74 12                	je     801df7 <fd_close+0x60>
		return (must_exist ? r : 0);
  801de5:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801de9:	74 05                	je     801df0 <fd_close+0x59>
  801deb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dee:	eb 70                	jmp    801e60 <fd_close+0xc9>
  801df0:	b8 00 00 00 00       	mov    $0x0,%eax
  801df5:	eb 69                	jmp    801e60 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801df7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dfb:	8b 00                	mov    (%rax),%eax
  801dfd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e01:	48 89 d6             	mov    %rdx,%rsi
  801e04:	89 c7                	mov    %eax,%edi
  801e06:	48 b8 62 1e 80 00 00 	movabs $0x801e62,%rax
  801e0d:	00 00 00 
  801e10:	ff d0                	callq  *%rax
  801e12:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e15:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e19:	78 2a                	js     801e45 <fd_close+0xae>
		if (dev->dev_close)
  801e1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e1f:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e23:	48 85 c0             	test   %rax,%rax
  801e26:	74 16                	je     801e3e <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  801e28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e2c:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e30:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801e34:	48 89 d7             	mov    %rdx,%rdi
  801e37:	ff d0                	callq  *%rax
  801e39:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e3c:	eb 07                	jmp    801e45 <fd_close+0xae>
		else
			r = 0;
  801e3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801e45:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e49:	48 89 c6             	mov    %rax,%rsi
  801e4c:	bf 00 00 00 00       	mov    $0x0,%edi
  801e51:	48 b8 8b 18 80 00 00 	movabs $0x80188b,%rax
  801e58:	00 00 00 
  801e5b:	ff d0                	callq  *%rax
	return r;
  801e5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801e60:	c9                   	leaveq 
  801e61:	c3                   	retq   

0000000000801e62 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801e62:	55                   	push   %rbp
  801e63:	48 89 e5             	mov    %rsp,%rbp
  801e66:	48 83 ec 20          	sub    $0x20,%rsp
  801e6a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e6d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801e71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e78:	eb 41                	jmp    801ebb <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801e7a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801e81:	00 00 00 
  801e84:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e87:	48 63 d2             	movslq %edx,%rdx
  801e8a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e8e:	8b 00                	mov    (%rax),%eax
  801e90:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801e93:	75 22                	jne    801eb7 <dev_lookup+0x55>
			*dev = devtab[i];
  801e95:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801e9c:	00 00 00 
  801e9f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ea2:	48 63 d2             	movslq %edx,%rdx
  801ea5:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801ea9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ead:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801eb0:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb5:	eb 60                	jmp    801f17 <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  801eb7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ebb:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801ec2:	00 00 00 
  801ec5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ec8:	48 63 d2             	movslq %edx,%rdx
  801ecb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ecf:	48 85 c0             	test   %rax,%rax
  801ed2:	75 a6                	jne    801e7a <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801ed4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801edb:	00 00 00 
  801ede:	48 8b 00             	mov    (%rax),%rax
  801ee1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801ee7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801eea:	89 c6                	mov    %eax,%esi
  801eec:	48 bf 60 44 80 00 00 	movabs $0x804460,%rdi
  801ef3:	00 00 00 
  801ef6:	b8 00 00 00 00       	mov    $0x0,%eax
  801efb:	48 b9 12 03 80 00 00 	movabs $0x800312,%rcx
  801f02:	00 00 00 
  801f05:	ff d1                	callq  *%rcx
	*dev = 0;
  801f07:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f0b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801f12:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801f17:	c9                   	leaveq 
  801f18:	c3                   	retq   

0000000000801f19 <close>:

int
close(int fdnum)
{
  801f19:	55                   	push   %rbp
  801f1a:	48 89 e5             	mov    %rsp,%rbp
  801f1d:	48 83 ec 20          	sub    $0x20,%rsp
  801f21:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f24:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f28:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f2b:	48 89 d6             	mov    %rdx,%rsi
  801f2e:	89 c7                	mov    %eax,%edi
  801f30:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  801f37:	00 00 00 
  801f3a:	ff d0                	callq  *%rax
  801f3c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f43:	79 05                	jns    801f4a <close+0x31>
		return r;
  801f45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f48:	eb 18                	jmp    801f62 <close+0x49>
	else
		return fd_close(fd, 1);
  801f4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f4e:	be 01 00 00 00       	mov    $0x1,%esi
  801f53:	48 89 c7             	mov    %rax,%rdi
  801f56:	48 b8 97 1d 80 00 00 	movabs $0x801d97,%rax
  801f5d:	00 00 00 
  801f60:	ff d0                	callq  *%rax
}
  801f62:	c9                   	leaveq 
  801f63:	c3                   	retq   

0000000000801f64 <close_all>:

void
close_all(void)
{
  801f64:	55                   	push   %rbp
  801f65:	48 89 e5             	mov    %rsp,%rbp
  801f68:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801f6c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f73:	eb 15                	jmp    801f8a <close_all+0x26>
		close(i);
  801f75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f78:	89 c7                	mov    %eax,%edi
  801f7a:	48 b8 19 1f 80 00 00 	movabs $0x801f19,%rax
  801f81:	00 00 00 
  801f84:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  801f86:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f8a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f8e:	7e e5                	jle    801f75 <close_all+0x11>
}
  801f90:	c9                   	leaveq 
  801f91:	c3                   	retq   

0000000000801f92 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801f92:	55                   	push   %rbp
  801f93:	48 89 e5             	mov    %rsp,%rbp
  801f96:	48 83 ec 40          	sub    $0x40,%rsp
  801f9a:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801f9d:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801fa0:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801fa4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801fa7:	48 89 d6             	mov    %rdx,%rsi
  801faa:	89 c7                	mov    %eax,%edi
  801fac:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  801fb3:	00 00 00 
  801fb6:	ff d0                	callq  *%rax
  801fb8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fbb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fbf:	79 08                	jns    801fc9 <dup+0x37>
		return r;
  801fc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fc4:	e9 70 01 00 00       	jmpq   802139 <dup+0x1a7>
	close(newfdnum);
  801fc9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801fcc:	89 c7                	mov    %eax,%edi
  801fce:	48 b8 19 1f 80 00 00 	movabs $0x801f19,%rax
  801fd5:	00 00 00 
  801fd8:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801fda:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801fdd:	48 98                	cltq   
  801fdf:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801fe5:	48 c1 e0 0c          	shl    $0xc,%rax
  801fe9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801fed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ff1:	48 89 c7             	mov    %rax,%rdi
  801ff4:	48 b8 44 1c 80 00 00 	movabs $0x801c44,%rax
  801ffb:	00 00 00 
  801ffe:	ff d0                	callq  *%rax
  802000:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802004:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802008:	48 89 c7             	mov    %rax,%rdi
  80200b:	48 b8 44 1c 80 00 00 	movabs $0x801c44,%rax
  802012:	00 00 00 
  802015:	ff d0                	callq  *%rax
  802017:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80201b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80201f:	48 c1 e8 15          	shr    $0x15,%rax
  802023:	48 89 c2             	mov    %rax,%rdx
  802026:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80202d:	01 00 00 
  802030:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802034:	83 e0 01             	and    $0x1,%eax
  802037:	48 85 c0             	test   %rax,%rax
  80203a:	74 73                	je     8020af <dup+0x11d>
  80203c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802040:	48 c1 e8 0c          	shr    $0xc,%rax
  802044:	48 89 c2             	mov    %rax,%rdx
  802047:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80204e:	01 00 00 
  802051:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802055:	83 e0 01             	and    $0x1,%eax
  802058:	48 85 c0             	test   %rax,%rax
  80205b:	74 52                	je     8020af <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80205d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802061:	48 c1 e8 0c          	shr    $0xc,%rax
  802065:	48 89 c2             	mov    %rax,%rdx
  802068:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80206f:	01 00 00 
  802072:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802076:	25 07 0e 00 00       	and    $0xe07,%eax
  80207b:	89 c1                	mov    %eax,%ecx
  80207d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802081:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802085:	41 89 c8             	mov    %ecx,%r8d
  802088:	48 89 d1             	mov    %rdx,%rcx
  80208b:	ba 00 00 00 00       	mov    $0x0,%edx
  802090:	48 89 c6             	mov    %rax,%rsi
  802093:	bf 00 00 00 00       	mov    $0x0,%edi
  802098:	48 b8 2b 18 80 00 00 	movabs $0x80182b,%rax
  80209f:	00 00 00 
  8020a2:	ff d0                	callq  *%rax
  8020a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020ab:	79 02                	jns    8020af <dup+0x11d>
			goto err;
  8020ad:	eb 57                	jmp    802106 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8020af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020b3:	48 c1 e8 0c          	shr    $0xc,%rax
  8020b7:	48 89 c2             	mov    %rax,%rdx
  8020ba:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020c1:	01 00 00 
  8020c4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020c8:	25 07 0e 00 00       	and    $0xe07,%eax
  8020cd:	89 c1                	mov    %eax,%ecx
  8020cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020d3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020d7:	41 89 c8             	mov    %ecx,%r8d
  8020da:	48 89 d1             	mov    %rdx,%rcx
  8020dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8020e2:	48 89 c6             	mov    %rax,%rsi
  8020e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8020ea:	48 b8 2b 18 80 00 00 	movabs $0x80182b,%rax
  8020f1:	00 00 00 
  8020f4:	ff d0                	callq  *%rax
  8020f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020fd:	79 02                	jns    802101 <dup+0x16f>
		goto err;
  8020ff:	eb 05                	jmp    802106 <dup+0x174>

	return newfdnum;
  802101:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802104:	eb 33                	jmp    802139 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802106:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80210a:	48 89 c6             	mov    %rax,%rsi
  80210d:	bf 00 00 00 00       	mov    $0x0,%edi
  802112:	48 b8 8b 18 80 00 00 	movabs $0x80188b,%rax
  802119:	00 00 00 
  80211c:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80211e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802122:	48 89 c6             	mov    %rax,%rsi
  802125:	bf 00 00 00 00       	mov    $0x0,%edi
  80212a:	48 b8 8b 18 80 00 00 	movabs $0x80188b,%rax
  802131:	00 00 00 
  802134:	ff d0                	callq  *%rax
	return r;
  802136:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802139:	c9                   	leaveq 
  80213a:	c3                   	retq   

000000000080213b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80213b:	55                   	push   %rbp
  80213c:	48 89 e5             	mov    %rsp,%rbp
  80213f:	48 83 ec 40          	sub    $0x40,%rsp
  802143:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802146:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80214a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80214e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802152:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802155:	48 89 d6             	mov    %rdx,%rsi
  802158:	89 c7                	mov    %eax,%edi
  80215a:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  802161:	00 00 00 
  802164:	ff d0                	callq  *%rax
  802166:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802169:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80216d:	78 24                	js     802193 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80216f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802173:	8b 00                	mov    (%rax),%eax
  802175:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802179:	48 89 d6             	mov    %rdx,%rsi
  80217c:	89 c7                	mov    %eax,%edi
  80217e:	48 b8 62 1e 80 00 00 	movabs $0x801e62,%rax
  802185:	00 00 00 
  802188:	ff d0                	callq  *%rax
  80218a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80218d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802191:	79 05                	jns    802198 <read+0x5d>
		return r;
  802193:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802196:	eb 76                	jmp    80220e <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802198:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80219c:	8b 40 08             	mov    0x8(%rax),%eax
  80219f:	83 e0 03             	and    $0x3,%eax
  8021a2:	83 f8 01             	cmp    $0x1,%eax
  8021a5:	75 3a                	jne    8021e1 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8021a7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021ae:	00 00 00 
  8021b1:	48 8b 00             	mov    (%rax),%rax
  8021b4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021ba:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021bd:	89 c6                	mov    %eax,%esi
  8021bf:	48 bf 7f 44 80 00 00 	movabs $0x80447f,%rdi
  8021c6:	00 00 00 
  8021c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ce:	48 b9 12 03 80 00 00 	movabs $0x800312,%rcx
  8021d5:	00 00 00 
  8021d8:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8021da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021df:	eb 2d                	jmp    80220e <read+0xd3>
	}
	if (!dev->dev_read)
  8021e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021e5:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021e9:	48 85 c0             	test   %rax,%rax
  8021ec:	75 07                	jne    8021f5 <read+0xba>
		return -E_NOT_SUPP;
  8021ee:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8021f3:	eb 19                	jmp    80220e <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8021f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021f9:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021fd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802201:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802205:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802209:	48 89 cf             	mov    %rcx,%rdi
  80220c:	ff d0                	callq  *%rax
}
  80220e:	c9                   	leaveq 
  80220f:	c3                   	retq   

0000000000802210 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802210:	55                   	push   %rbp
  802211:	48 89 e5             	mov    %rsp,%rbp
  802214:	48 83 ec 30          	sub    $0x30,%rsp
  802218:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80221b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80221f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802223:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80222a:	eb 49                	jmp    802275 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80222c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80222f:	48 98                	cltq   
  802231:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802235:	48 29 c2             	sub    %rax,%rdx
  802238:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80223b:	48 63 c8             	movslq %eax,%rcx
  80223e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802242:	48 01 c1             	add    %rax,%rcx
  802245:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802248:	48 89 ce             	mov    %rcx,%rsi
  80224b:	89 c7                	mov    %eax,%edi
  80224d:	48 b8 3b 21 80 00 00 	movabs $0x80213b,%rax
  802254:	00 00 00 
  802257:	ff d0                	callq  *%rax
  802259:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80225c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802260:	79 05                	jns    802267 <readn+0x57>
			return m;
  802262:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802265:	eb 1c                	jmp    802283 <readn+0x73>
		if (m == 0)
  802267:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80226b:	75 02                	jne    80226f <readn+0x5f>
			break;
  80226d:	eb 11                	jmp    802280 <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  80226f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802272:	01 45 fc             	add    %eax,-0x4(%rbp)
  802275:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802278:	48 98                	cltq   
  80227a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80227e:	72 ac                	jb     80222c <readn+0x1c>
	}
	return tot;
  802280:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802283:	c9                   	leaveq 
  802284:	c3                   	retq   

0000000000802285 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802285:	55                   	push   %rbp
  802286:	48 89 e5             	mov    %rsp,%rbp
  802289:	48 83 ec 40          	sub    $0x40,%rsp
  80228d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802290:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802294:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802298:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80229c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80229f:	48 89 d6             	mov    %rdx,%rsi
  8022a2:	89 c7                	mov    %eax,%edi
  8022a4:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  8022ab:	00 00 00 
  8022ae:	ff d0                	callq  *%rax
  8022b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022b7:	78 24                	js     8022dd <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022bd:	8b 00                	mov    (%rax),%eax
  8022bf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022c3:	48 89 d6             	mov    %rdx,%rsi
  8022c6:	89 c7                	mov    %eax,%edi
  8022c8:	48 b8 62 1e 80 00 00 	movabs $0x801e62,%rax
  8022cf:	00 00 00 
  8022d2:	ff d0                	callq  *%rax
  8022d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022db:	79 05                	jns    8022e2 <write+0x5d>
		return r;
  8022dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022e0:	eb 75                	jmp    802357 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8022e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e6:	8b 40 08             	mov    0x8(%rax),%eax
  8022e9:	83 e0 03             	and    $0x3,%eax
  8022ec:	85 c0                	test   %eax,%eax
  8022ee:	75 3a                	jne    80232a <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8022f0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8022f7:	00 00 00 
  8022fa:	48 8b 00             	mov    (%rax),%rax
  8022fd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802303:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802306:	89 c6                	mov    %eax,%esi
  802308:	48 bf 9b 44 80 00 00 	movabs $0x80449b,%rdi
  80230f:	00 00 00 
  802312:	b8 00 00 00 00       	mov    $0x0,%eax
  802317:	48 b9 12 03 80 00 00 	movabs $0x800312,%rcx
  80231e:	00 00 00 
  802321:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802323:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802328:	eb 2d                	jmp    802357 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80232a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80232e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802332:	48 85 c0             	test   %rax,%rax
  802335:	75 07                	jne    80233e <write+0xb9>
		return -E_NOT_SUPP;
  802337:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80233c:	eb 19                	jmp    802357 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80233e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802342:	48 8b 40 18          	mov    0x18(%rax),%rax
  802346:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80234a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80234e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802352:	48 89 cf             	mov    %rcx,%rdi
  802355:	ff d0                	callq  *%rax
}
  802357:	c9                   	leaveq 
  802358:	c3                   	retq   

0000000000802359 <seek>:

int
seek(int fdnum, off_t offset)
{
  802359:	55                   	push   %rbp
  80235a:	48 89 e5             	mov    %rsp,%rbp
  80235d:	48 83 ec 18          	sub    $0x18,%rsp
  802361:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802364:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802367:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80236b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80236e:	48 89 d6             	mov    %rdx,%rsi
  802371:	89 c7                	mov    %eax,%edi
  802373:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  80237a:	00 00 00 
  80237d:	ff d0                	callq  *%rax
  80237f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802382:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802386:	79 05                	jns    80238d <seek+0x34>
		return r;
  802388:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80238b:	eb 0f                	jmp    80239c <seek+0x43>
	fd->fd_offset = offset;
  80238d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802391:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802394:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802397:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80239c:	c9                   	leaveq 
  80239d:	c3                   	retq   

000000000080239e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80239e:	55                   	push   %rbp
  80239f:	48 89 e5             	mov    %rsp,%rbp
  8023a2:	48 83 ec 30          	sub    $0x30,%rsp
  8023a6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023a9:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023ac:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023b0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023b3:	48 89 d6             	mov    %rdx,%rsi
  8023b6:	89 c7                	mov    %eax,%edi
  8023b8:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  8023bf:	00 00 00 
  8023c2:	ff d0                	callq  *%rax
  8023c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023cb:	78 24                	js     8023f1 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d1:	8b 00                	mov    (%rax),%eax
  8023d3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023d7:	48 89 d6             	mov    %rdx,%rsi
  8023da:	89 c7                	mov    %eax,%edi
  8023dc:	48 b8 62 1e 80 00 00 	movabs $0x801e62,%rax
  8023e3:	00 00 00 
  8023e6:	ff d0                	callq  *%rax
  8023e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023ef:	79 05                	jns    8023f6 <ftruncate+0x58>
		return r;
  8023f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023f4:	eb 72                	jmp    802468 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023fa:	8b 40 08             	mov    0x8(%rax),%eax
  8023fd:	83 e0 03             	and    $0x3,%eax
  802400:	85 c0                	test   %eax,%eax
  802402:	75 3a                	jne    80243e <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802404:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80240b:	00 00 00 
  80240e:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802411:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802417:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80241a:	89 c6                	mov    %eax,%esi
  80241c:	48 bf b8 44 80 00 00 	movabs $0x8044b8,%rdi
  802423:	00 00 00 
  802426:	b8 00 00 00 00       	mov    $0x0,%eax
  80242b:	48 b9 12 03 80 00 00 	movabs $0x800312,%rcx
  802432:	00 00 00 
  802435:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802437:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80243c:	eb 2a                	jmp    802468 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80243e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802442:	48 8b 40 30          	mov    0x30(%rax),%rax
  802446:	48 85 c0             	test   %rax,%rax
  802449:	75 07                	jne    802452 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80244b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802450:	eb 16                	jmp    802468 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802452:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802456:	48 8b 40 30          	mov    0x30(%rax),%rax
  80245a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80245e:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802461:	89 ce                	mov    %ecx,%esi
  802463:	48 89 d7             	mov    %rdx,%rdi
  802466:	ff d0                	callq  *%rax
}
  802468:	c9                   	leaveq 
  802469:	c3                   	retq   

000000000080246a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80246a:	55                   	push   %rbp
  80246b:	48 89 e5             	mov    %rsp,%rbp
  80246e:	48 83 ec 30          	sub    $0x30,%rsp
  802472:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802475:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802479:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80247d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802480:	48 89 d6             	mov    %rdx,%rsi
  802483:	89 c7                	mov    %eax,%edi
  802485:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  80248c:	00 00 00 
  80248f:	ff d0                	callq  *%rax
  802491:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802494:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802498:	78 24                	js     8024be <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80249a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80249e:	8b 00                	mov    (%rax),%eax
  8024a0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024a4:	48 89 d6             	mov    %rdx,%rsi
  8024a7:	89 c7                	mov    %eax,%edi
  8024a9:	48 b8 62 1e 80 00 00 	movabs $0x801e62,%rax
  8024b0:	00 00 00 
  8024b3:	ff d0                	callq  *%rax
  8024b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024bc:	79 05                	jns    8024c3 <fstat+0x59>
		return r;
  8024be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024c1:	eb 5e                	jmp    802521 <fstat+0xb7>
	if (!dev->dev_stat)
  8024c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024c7:	48 8b 40 28          	mov    0x28(%rax),%rax
  8024cb:	48 85 c0             	test   %rax,%rax
  8024ce:	75 07                	jne    8024d7 <fstat+0x6d>
		return -E_NOT_SUPP;
  8024d0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024d5:	eb 4a                	jmp    802521 <fstat+0xb7>
	stat->st_name[0] = 0;
  8024d7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024db:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8024de:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024e2:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8024e9:	00 00 00 
	stat->st_isdir = 0;
  8024ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024f0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8024f7:	00 00 00 
	stat->st_dev = dev;
  8024fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802502:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802509:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80250d:	48 8b 40 28          	mov    0x28(%rax),%rax
  802511:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802515:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802519:	48 89 ce             	mov    %rcx,%rsi
  80251c:	48 89 d7             	mov    %rdx,%rdi
  80251f:	ff d0                	callq  *%rax
}
  802521:	c9                   	leaveq 
  802522:	c3                   	retq   

0000000000802523 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802523:	55                   	push   %rbp
  802524:	48 89 e5             	mov    %rsp,%rbp
  802527:	48 83 ec 20          	sub    $0x20,%rsp
  80252b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80252f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802533:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802537:	be 00 00 00 00       	mov    $0x0,%esi
  80253c:	48 89 c7             	mov    %rax,%rdi
  80253f:	48 b8 13 26 80 00 00 	movabs $0x802613,%rax
  802546:	00 00 00 
  802549:	ff d0                	callq  *%rax
  80254b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80254e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802552:	79 05                	jns    802559 <stat+0x36>
		return fd;
  802554:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802557:	eb 2f                	jmp    802588 <stat+0x65>
	r = fstat(fd, stat);
  802559:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80255d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802560:	48 89 d6             	mov    %rdx,%rsi
  802563:	89 c7                	mov    %eax,%edi
  802565:	48 b8 6a 24 80 00 00 	movabs $0x80246a,%rax
  80256c:	00 00 00 
  80256f:	ff d0                	callq  *%rax
  802571:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802574:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802577:	89 c7                	mov    %eax,%edi
  802579:	48 b8 19 1f 80 00 00 	movabs $0x801f19,%rax
  802580:	00 00 00 
  802583:	ff d0                	callq  *%rax
	return r;
  802585:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802588:	c9                   	leaveq 
  802589:	c3                   	retq   

000000000080258a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80258a:	55                   	push   %rbp
  80258b:	48 89 e5             	mov    %rsp,%rbp
  80258e:	48 83 ec 10          	sub    $0x10,%rsp
  802592:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802595:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802599:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8025a0:	00 00 00 
  8025a3:	8b 00                	mov    (%rax),%eax
  8025a5:	85 c0                	test   %eax,%eax
  8025a7:	75 1f                	jne    8025c8 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8025a9:	bf 01 00 00 00       	mov    $0x1,%edi
  8025ae:	48 b8 a8 3d 80 00 00 	movabs $0x803da8,%rax
  8025b5:	00 00 00 
  8025b8:	ff d0                	callq  *%rax
  8025ba:	89 c2                	mov    %eax,%edx
  8025bc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8025c3:	00 00 00 
  8025c6:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8025c8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8025cf:	00 00 00 
  8025d2:	8b 00                	mov    (%rax),%eax
  8025d4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8025d7:	b9 07 00 00 00       	mov    $0x7,%ecx
  8025dc:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8025e3:	00 00 00 
  8025e6:	89 c7                	mov    %eax,%edi
  8025e8:	48 b8 1b 3c 80 00 00 	movabs $0x803c1b,%rax
  8025ef:	00 00 00 
  8025f2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8025f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8025fd:	48 89 c6             	mov    %rax,%rsi
  802600:	bf 00 00 00 00       	mov    $0x0,%edi
  802605:	48 b8 dd 3b 80 00 00 	movabs $0x803bdd,%rax
  80260c:	00 00 00 
  80260f:	ff d0                	callq  *%rax
}
  802611:	c9                   	leaveq 
  802612:	c3                   	retq   

0000000000802613 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802613:	55                   	push   %rbp
  802614:	48 89 e5             	mov    %rsp,%rbp
  802617:	48 83 ec 10          	sub    $0x10,%rsp
  80261b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80261f:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  802622:	48 ba de 44 80 00 00 	movabs $0x8044de,%rdx
  802629:	00 00 00 
  80262c:	be 4c 00 00 00       	mov    $0x4c,%esi
  802631:	48 bf f3 44 80 00 00 	movabs $0x8044f3,%rdi
  802638:	00 00 00 
  80263b:	b8 00 00 00 00       	mov    $0x0,%eax
  802640:	48 b9 c9 3a 80 00 00 	movabs $0x803ac9,%rcx
  802647:	00 00 00 
  80264a:	ff d1                	callq  *%rcx

000000000080264c <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80264c:	55                   	push   %rbp
  80264d:	48 89 e5             	mov    %rsp,%rbp
  802650:	48 83 ec 10          	sub    $0x10,%rsp
  802654:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802658:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80265c:	8b 50 0c             	mov    0xc(%rax),%edx
  80265f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802666:	00 00 00 
  802669:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80266b:	be 00 00 00 00       	mov    $0x0,%esi
  802670:	bf 06 00 00 00       	mov    $0x6,%edi
  802675:	48 b8 8a 25 80 00 00 	movabs $0x80258a,%rax
  80267c:	00 00 00 
  80267f:	ff d0                	callq  *%rax
}
  802681:	c9                   	leaveq 
  802682:	c3                   	retq   

0000000000802683 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802683:	55                   	push   %rbp
  802684:	48 89 e5             	mov    %rsp,%rbp
  802687:	48 83 ec 20          	sub    $0x20,%rsp
  80268b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80268f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802693:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  802697:	48 ba fe 44 80 00 00 	movabs $0x8044fe,%rdx
  80269e:	00 00 00 
  8026a1:	be 6b 00 00 00       	mov    $0x6b,%esi
  8026a6:	48 bf f3 44 80 00 00 	movabs $0x8044f3,%rdi
  8026ad:	00 00 00 
  8026b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b5:	48 b9 c9 3a 80 00 00 	movabs $0x803ac9,%rcx
  8026bc:	00 00 00 
  8026bf:	ff d1                	callq  *%rcx

00000000008026c1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8026c1:	55                   	push   %rbp
  8026c2:	48 89 e5             	mov    %rsp,%rbp
  8026c5:	48 83 ec 20          	sub    $0x20,%rsp
  8026c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8026cd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8026d1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  8026d5:	48 ba 1b 45 80 00 00 	movabs $0x80451b,%rdx
  8026dc:	00 00 00 
  8026df:	be 7b 00 00 00       	mov    $0x7b,%esi
  8026e4:	48 bf f3 44 80 00 00 	movabs $0x8044f3,%rdi
  8026eb:	00 00 00 
  8026ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f3:	48 b9 c9 3a 80 00 00 	movabs $0x803ac9,%rcx
  8026fa:	00 00 00 
  8026fd:	ff d1                	callq  *%rcx

00000000008026ff <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8026ff:	55                   	push   %rbp
  802700:	48 89 e5             	mov    %rsp,%rbp
  802703:	48 83 ec 20          	sub    $0x20,%rsp
  802707:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80270b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80270f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802713:	8b 50 0c             	mov    0xc(%rax),%edx
  802716:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80271d:	00 00 00 
  802720:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802722:	be 00 00 00 00       	mov    $0x0,%esi
  802727:	bf 05 00 00 00       	mov    $0x5,%edi
  80272c:	48 b8 8a 25 80 00 00 	movabs $0x80258a,%rax
  802733:	00 00 00 
  802736:	ff d0                	callq  *%rax
  802738:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80273b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80273f:	79 05                	jns    802746 <devfile_stat+0x47>
		return r;
  802741:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802744:	eb 56                	jmp    80279c <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802746:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80274a:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802751:	00 00 00 
  802754:	48 89 c7             	mov    %rax,%rdi
  802757:	48 b8 ac 0e 80 00 00 	movabs $0x800eac,%rax
  80275e:	00 00 00 
  802761:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802763:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80276a:	00 00 00 
  80276d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802773:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802777:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80277d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802784:	00 00 00 
  802787:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80278d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802791:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802797:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80279c:	c9                   	leaveq 
  80279d:	c3                   	retq   

000000000080279e <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80279e:	55                   	push   %rbp
  80279f:	48 89 e5             	mov    %rsp,%rbp
  8027a2:	48 83 ec 10          	sub    $0x10,%rsp
  8027a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8027aa:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8027ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027b1:	8b 50 0c             	mov    0xc(%rax),%edx
  8027b4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027bb:	00 00 00 
  8027be:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8027c0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027c7:	00 00 00 
  8027ca:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8027cd:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8027d0:	be 00 00 00 00       	mov    $0x0,%esi
  8027d5:	bf 02 00 00 00       	mov    $0x2,%edi
  8027da:	48 b8 8a 25 80 00 00 	movabs $0x80258a,%rax
  8027e1:	00 00 00 
  8027e4:	ff d0                	callq  *%rax
}
  8027e6:	c9                   	leaveq 
  8027e7:	c3                   	retq   

00000000008027e8 <remove>:

// Delete a file
int
remove(const char *path)
{
  8027e8:	55                   	push   %rbp
  8027e9:	48 89 e5             	mov    %rsp,%rbp
  8027ec:	48 83 ec 10          	sub    $0x10,%rsp
  8027f0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8027f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027f8:	48 89 c7             	mov    %rax,%rdi
  8027fb:	48 b8 40 0e 80 00 00 	movabs $0x800e40,%rax
  802802:	00 00 00 
  802805:	ff d0                	callq  *%rax
  802807:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80280c:	7e 07                	jle    802815 <remove+0x2d>
		return -E_BAD_PATH;
  80280e:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802813:	eb 33                	jmp    802848 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802815:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802819:	48 89 c6             	mov    %rax,%rsi
  80281c:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802823:	00 00 00 
  802826:	48 b8 ac 0e 80 00 00 	movabs $0x800eac,%rax
  80282d:	00 00 00 
  802830:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802832:	be 00 00 00 00       	mov    $0x0,%esi
  802837:	bf 07 00 00 00       	mov    $0x7,%edi
  80283c:	48 b8 8a 25 80 00 00 	movabs $0x80258a,%rax
  802843:	00 00 00 
  802846:	ff d0                	callq  *%rax
}
  802848:	c9                   	leaveq 
  802849:	c3                   	retq   

000000000080284a <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80284a:	55                   	push   %rbp
  80284b:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80284e:	be 00 00 00 00       	mov    $0x0,%esi
  802853:	bf 08 00 00 00       	mov    $0x8,%edi
  802858:	48 b8 8a 25 80 00 00 	movabs $0x80258a,%rax
  80285f:	00 00 00 
  802862:	ff d0                	callq  *%rax
}
  802864:	5d                   	pop    %rbp
  802865:	c3                   	retq   

0000000000802866 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802866:	55                   	push   %rbp
  802867:	48 89 e5             	mov    %rsp,%rbp
  80286a:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802871:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802878:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80287f:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802886:	be 00 00 00 00       	mov    $0x0,%esi
  80288b:	48 89 c7             	mov    %rax,%rdi
  80288e:	48 b8 13 26 80 00 00 	movabs $0x802613,%rax
  802895:	00 00 00 
  802898:	ff d0                	callq  *%rax
  80289a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80289d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028a1:	79 28                	jns    8028cb <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8028a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a6:	89 c6                	mov    %eax,%esi
  8028a8:	48 bf 39 45 80 00 00 	movabs $0x804539,%rdi
  8028af:	00 00 00 
  8028b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b7:	48 ba 12 03 80 00 00 	movabs $0x800312,%rdx
  8028be:	00 00 00 
  8028c1:	ff d2                	callq  *%rdx
		return fd_src;
  8028c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028c6:	e9 74 01 00 00       	jmpq   802a3f <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8028cb:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8028d2:	be 01 01 00 00       	mov    $0x101,%esi
  8028d7:	48 89 c7             	mov    %rax,%rdi
  8028da:	48 b8 13 26 80 00 00 	movabs $0x802613,%rax
  8028e1:	00 00 00 
  8028e4:	ff d0                	callq  *%rax
  8028e6:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8028e9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8028ed:	79 39                	jns    802928 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8028ef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028f2:	89 c6                	mov    %eax,%esi
  8028f4:	48 bf 4f 45 80 00 00 	movabs $0x80454f,%rdi
  8028fb:	00 00 00 
  8028fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802903:	48 ba 12 03 80 00 00 	movabs $0x800312,%rdx
  80290a:	00 00 00 
  80290d:	ff d2                	callq  *%rdx
		close(fd_src);
  80290f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802912:	89 c7                	mov    %eax,%edi
  802914:	48 b8 19 1f 80 00 00 	movabs $0x801f19,%rax
  80291b:	00 00 00 
  80291e:	ff d0                	callq  *%rax
		return fd_dest;
  802920:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802923:	e9 17 01 00 00       	jmpq   802a3f <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802928:	eb 74                	jmp    80299e <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80292a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80292d:	48 63 d0             	movslq %eax,%rdx
  802930:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802937:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80293a:	48 89 ce             	mov    %rcx,%rsi
  80293d:	89 c7                	mov    %eax,%edi
  80293f:	48 b8 85 22 80 00 00 	movabs $0x802285,%rax
  802946:	00 00 00 
  802949:	ff d0                	callq  *%rax
  80294b:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80294e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802952:	79 4a                	jns    80299e <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802954:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802957:	89 c6                	mov    %eax,%esi
  802959:	48 bf 69 45 80 00 00 	movabs $0x804569,%rdi
  802960:	00 00 00 
  802963:	b8 00 00 00 00       	mov    $0x0,%eax
  802968:	48 ba 12 03 80 00 00 	movabs $0x800312,%rdx
  80296f:	00 00 00 
  802972:	ff d2                	callq  *%rdx
			close(fd_src);
  802974:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802977:	89 c7                	mov    %eax,%edi
  802979:	48 b8 19 1f 80 00 00 	movabs $0x801f19,%rax
  802980:	00 00 00 
  802983:	ff d0                	callq  *%rax
			close(fd_dest);
  802985:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802988:	89 c7                	mov    %eax,%edi
  80298a:	48 b8 19 1f 80 00 00 	movabs $0x801f19,%rax
  802991:	00 00 00 
  802994:	ff d0                	callq  *%rax
			return write_size;
  802996:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802999:	e9 a1 00 00 00       	jmpq   802a3f <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80299e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8029a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a8:	ba 00 02 00 00       	mov    $0x200,%edx
  8029ad:	48 89 ce             	mov    %rcx,%rsi
  8029b0:	89 c7                	mov    %eax,%edi
  8029b2:	48 b8 3b 21 80 00 00 	movabs $0x80213b,%rax
  8029b9:	00 00 00 
  8029bc:	ff d0                	callq  *%rax
  8029be:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8029c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8029c5:	0f 8f 5f ff ff ff    	jg     80292a <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  8029cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8029cf:	79 47                	jns    802a18 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8029d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8029d4:	89 c6                	mov    %eax,%esi
  8029d6:	48 bf 7c 45 80 00 00 	movabs $0x80457c,%rdi
  8029dd:	00 00 00 
  8029e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e5:	48 ba 12 03 80 00 00 	movabs $0x800312,%rdx
  8029ec:	00 00 00 
  8029ef:	ff d2                	callq  *%rdx
		close(fd_src);
  8029f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029f4:	89 c7                	mov    %eax,%edi
  8029f6:	48 b8 19 1f 80 00 00 	movabs $0x801f19,%rax
  8029fd:	00 00 00 
  802a00:	ff d0                	callq  *%rax
		close(fd_dest);
  802a02:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a05:	89 c7                	mov    %eax,%edi
  802a07:	48 b8 19 1f 80 00 00 	movabs $0x801f19,%rax
  802a0e:	00 00 00 
  802a11:	ff d0                	callq  *%rax
		return read_size;
  802a13:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a16:	eb 27                	jmp    802a3f <copy+0x1d9>
	}
	close(fd_src);
  802a18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a1b:	89 c7                	mov    %eax,%edi
  802a1d:	48 b8 19 1f 80 00 00 	movabs $0x801f19,%rax
  802a24:	00 00 00 
  802a27:	ff d0                	callq  *%rax
	close(fd_dest);
  802a29:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a2c:	89 c7                	mov    %eax,%edi
  802a2e:	48 b8 19 1f 80 00 00 	movabs $0x801f19,%rax
  802a35:	00 00 00 
  802a38:	ff d0                	callq  *%rax
	return 0;
  802a3a:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802a3f:	c9                   	leaveq 
  802a40:	c3                   	retq   

0000000000802a41 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802a41:	55                   	push   %rbp
  802a42:	48 89 e5             	mov    %rsp,%rbp
  802a45:	48 83 ec 20          	sub    $0x20,%rsp
  802a49:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802a4c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a50:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a53:	48 89 d6             	mov    %rdx,%rsi
  802a56:	89 c7                	mov    %eax,%edi
  802a58:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  802a5f:	00 00 00 
  802a62:	ff d0                	callq  *%rax
  802a64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a6b:	79 05                	jns    802a72 <fd2sockid+0x31>
		return r;
  802a6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a70:	eb 24                	jmp    802a96 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802a72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a76:	8b 10                	mov    (%rax),%edx
  802a78:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802a7f:	00 00 00 
  802a82:	8b 00                	mov    (%rax),%eax
  802a84:	39 c2                	cmp    %eax,%edx
  802a86:	74 07                	je     802a8f <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802a88:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a8d:	eb 07                	jmp    802a96 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802a8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a93:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802a96:	c9                   	leaveq 
  802a97:	c3                   	retq   

0000000000802a98 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802a98:	55                   	push   %rbp
  802a99:	48 89 e5             	mov    %rsp,%rbp
  802a9c:	48 83 ec 20          	sub    $0x20,%rsp
  802aa0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802aa3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802aa7:	48 89 c7             	mov    %rax,%rdi
  802aaa:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  802ab1:	00 00 00 
  802ab4:	ff d0                	callq  *%rax
  802ab6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802abd:	78 26                	js     802ae5 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802abf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ac3:	ba 07 04 00 00       	mov    $0x407,%edx
  802ac8:	48 89 c6             	mov    %rax,%rsi
  802acb:	bf 00 00 00 00       	mov    $0x0,%edi
  802ad0:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  802ad7:	00 00 00 
  802ada:	ff d0                	callq  *%rax
  802adc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802adf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ae3:	79 16                	jns    802afb <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802ae5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ae8:	89 c7                	mov    %eax,%edi
  802aea:	48 b8 a7 2f 80 00 00 	movabs $0x802fa7,%rax
  802af1:	00 00 00 
  802af4:	ff d0                	callq  *%rax
		return r;
  802af6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af9:	eb 3a                	jmp    802b35 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802afb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aff:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802b06:	00 00 00 
  802b09:	8b 12                	mov    (%rdx),%edx
  802b0b:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802b0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b11:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802b18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b1c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802b1f:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802b22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b26:	48 89 c7             	mov    %rax,%rdi
  802b29:	48 b8 21 1c 80 00 00 	movabs $0x801c21,%rax
  802b30:	00 00 00 
  802b33:	ff d0                	callq  *%rax
}
  802b35:	c9                   	leaveq 
  802b36:	c3                   	retq   

0000000000802b37 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802b37:	55                   	push   %rbp
  802b38:	48 89 e5             	mov    %rsp,%rbp
  802b3b:	48 83 ec 30          	sub    $0x30,%rsp
  802b3f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b42:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b46:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802b4a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b4d:	89 c7                	mov    %eax,%edi
  802b4f:	48 b8 41 2a 80 00 00 	movabs $0x802a41,%rax
  802b56:	00 00 00 
  802b59:	ff d0                	callq  *%rax
  802b5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b62:	79 05                	jns    802b69 <accept+0x32>
		return r;
  802b64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b67:	eb 3b                	jmp    802ba4 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802b69:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b6d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802b71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b74:	48 89 ce             	mov    %rcx,%rsi
  802b77:	89 c7                	mov    %eax,%edi
  802b79:	48 b8 84 2e 80 00 00 	movabs $0x802e84,%rax
  802b80:	00 00 00 
  802b83:	ff d0                	callq  *%rax
  802b85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b8c:	79 05                	jns    802b93 <accept+0x5c>
		return r;
  802b8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b91:	eb 11                	jmp    802ba4 <accept+0x6d>
	return alloc_sockfd(r);
  802b93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b96:	89 c7                	mov    %eax,%edi
  802b98:	48 b8 98 2a 80 00 00 	movabs $0x802a98,%rax
  802b9f:	00 00 00 
  802ba2:	ff d0                	callq  *%rax
}
  802ba4:	c9                   	leaveq 
  802ba5:	c3                   	retq   

0000000000802ba6 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802ba6:	55                   	push   %rbp
  802ba7:	48 89 e5             	mov    %rsp,%rbp
  802baa:	48 83 ec 20          	sub    $0x20,%rsp
  802bae:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bb1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802bb5:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802bb8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bbb:	89 c7                	mov    %eax,%edi
  802bbd:	48 b8 41 2a 80 00 00 	movabs $0x802a41,%rax
  802bc4:	00 00 00 
  802bc7:	ff d0                	callq  *%rax
  802bc9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bcc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd0:	79 05                	jns    802bd7 <bind+0x31>
		return r;
  802bd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd5:	eb 1b                	jmp    802bf2 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802bd7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802bda:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802bde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be1:	48 89 ce             	mov    %rcx,%rsi
  802be4:	89 c7                	mov    %eax,%edi
  802be6:	48 b8 03 2f 80 00 00 	movabs $0x802f03,%rax
  802bed:	00 00 00 
  802bf0:	ff d0                	callq  *%rax
}
  802bf2:	c9                   	leaveq 
  802bf3:	c3                   	retq   

0000000000802bf4 <shutdown>:

int
shutdown(int s, int how)
{
  802bf4:	55                   	push   %rbp
  802bf5:	48 89 e5             	mov    %rsp,%rbp
  802bf8:	48 83 ec 20          	sub    $0x20,%rsp
  802bfc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bff:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802c02:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c05:	89 c7                	mov    %eax,%edi
  802c07:	48 b8 41 2a 80 00 00 	movabs $0x802a41,%rax
  802c0e:	00 00 00 
  802c11:	ff d0                	callq  *%rax
  802c13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c1a:	79 05                	jns    802c21 <shutdown+0x2d>
		return r;
  802c1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c1f:	eb 16                	jmp    802c37 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802c21:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c27:	89 d6                	mov    %edx,%esi
  802c29:	89 c7                	mov    %eax,%edi
  802c2b:	48 b8 67 2f 80 00 00 	movabs $0x802f67,%rax
  802c32:	00 00 00 
  802c35:	ff d0                	callq  *%rax
}
  802c37:	c9                   	leaveq 
  802c38:	c3                   	retq   

0000000000802c39 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802c39:	55                   	push   %rbp
  802c3a:	48 89 e5             	mov    %rsp,%rbp
  802c3d:	48 83 ec 10          	sub    $0x10,%rsp
  802c41:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802c45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c49:	48 89 c7             	mov    %rax,%rdi
  802c4c:	48 b8 1a 3e 80 00 00 	movabs $0x803e1a,%rax
  802c53:	00 00 00 
  802c56:	ff d0                	callq  *%rax
  802c58:	83 f8 01             	cmp    $0x1,%eax
  802c5b:	75 17                	jne    802c74 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802c5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c61:	8b 40 0c             	mov    0xc(%rax),%eax
  802c64:	89 c7                	mov    %eax,%edi
  802c66:	48 b8 a7 2f 80 00 00 	movabs $0x802fa7,%rax
  802c6d:	00 00 00 
  802c70:	ff d0                	callq  *%rax
  802c72:	eb 05                	jmp    802c79 <devsock_close+0x40>
	else
		return 0;
  802c74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c79:	c9                   	leaveq 
  802c7a:	c3                   	retq   

0000000000802c7b <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802c7b:	55                   	push   %rbp
  802c7c:	48 89 e5             	mov    %rsp,%rbp
  802c7f:	48 83 ec 20          	sub    $0x20,%rsp
  802c83:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c86:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c8a:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802c8d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c90:	89 c7                	mov    %eax,%edi
  802c92:	48 b8 41 2a 80 00 00 	movabs $0x802a41,%rax
  802c99:	00 00 00 
  802c9c:	ff d0                	callq  *%rax
  802c9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ca1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca5:	79 05                	jns    802cac <connect+0x31>
		return r;
  802ca7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802caa:	eb 1b                	jmp    802cc7 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802cac:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802caf:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802cb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb6:	48 89 ce             	mov    %rcx,%rsi
  802cb9:	89 c7                	mov    %eax,%edi
  802cbb:	48 b8 d4 2f 80 00 00 	movabs $0x802fd4,%rax
  802cc2:	00 00 00 
  802cc5:	ff d0                	callq  *%rax
}
  802cc7:	c9                   	leaveq 
  802cc8:	c3                   	retq   

0000000000802cc9 <listen>:

int
listen(int s, int backlog)
{
  802cc9:	55                   	push   %rbp
  802cca:	48 89 e5             	mov    %rsp,%rbp
  802ccd:	48 83 ec 20          	sub    $0x20,%rsp
  802cd1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cd4:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802cd7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cda:	89 c7                	mov    %eax,%edi
  802cdc:	48 b8 41 2a 80 00 00 	movabs $0x802a41,%rax
  802ce3:	00 00 00 
  802ce6:	ff d0                	callq  *%rax
  802ce8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ceb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cef:	79 05                	jns    802cf6 <listen+0x2d>
		return r;
  802cf1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf4:	eb 16                	jmp    802d0c <listen+0x43>
	return nsipc_listen(r, backlog);
  802cf6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802cf9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cfc:	89 d6                	mov    %edx,%esi
  802cfe:	89 c7                	mov    %eax,%edi
  802d00:	48 b8 38 30 80 00 00 	movabs $0x803038,%rax
  802d07:	00 00 00 
  802d0a:	ff d0                	callq  *%rax
}
  802d0c:	c9                   	leaveq 
  802d0d:	c3                   	retq   

0000000000802d0e <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802d0e:	55                   	push   %rbp
  802d0f:	48 89 e5             	mov    %rsp,%rbp
  802d12:	48 83 ec 20          	sub    $0x20,%rsp
  802d16:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d1a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802d1e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802d22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d26:	89 c2                	mov    %eax,%edx
  802d28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d2c:	8b 40 0c             	mov    0xc(%rax),%eax
  802d2f:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802d33:	b9 00 00 00 00       	mov    $0x0,%ecx
  802d38:	89 c7                	mov    %eax,%edi
  802d3a:	48 b8 78 30 80 00 00 	movabs $0x803078,%rax
  802d41:	00 00 00 
  802d44:	ff d0                	callq  *%rax
}
  802d46:	c9                   	leaveq 
  802d47:	c3                   	retq   

0000000000802d48 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802d48:	55                   	push   %rbp
  802d49:	48 89 e5             	mov    %rsp,%rbp
  802d4c:	48 83 ec 20          	sub    $0x20,%rsp
  802d50:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d54:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802d58:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802d5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d60:	89 c2                	mov    %eax,%edx
  802d62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d66:	8b 40 0c             	mov    0xc(%rax),%eax
  802d69:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802d6d:	b9 00 00 00 00       	mov    $0x0,%ecx
  802d72:	89 c7                	mov    %eax,%edi
  802d74:	48 b8 44 31 80 00 00 	movabs $0x803144,%rax
  802d7b:	00 00 00 
  802d7e:	ff d0                	callq  *%rax
}
  802d80:	c9                   	leaveq 
  802d81:	c3                   	retq   

0000000000802d82 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802d82:	55                   	push   %rbp
  802d83:	48 89 e5             	mov    %rsp,%rbp
  802d86:	48 83 ec 10          	sub    $0x10,%rsp
  802d8a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d8e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802d92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d96:	48 be 97 45 80 00 00 	movabs $0x804597,%rsi
  802d9d:	00 00 00 
  802da0:	48 89 c7             	mov    %rax,%rdi
  802da3:	48 b8 ac 0e 80 00 00 	movabs $0x800eac,%rax
  802daa:	00 00 00 
  802dad:	ff d0                	callq  *%rax
	return 0;
  802daf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802db4:	c9                   	leaveq 
  802db5:	c3                   	retq   

0000000000802db6 <socket>:

int
socket(int domain, int type, int protocol)
{
  802db6:	55                   	push   %rbp
  802db7:	48 89 e5             	mov    %rsp,%rbp
  802dba:	48 83 ec 20          	sub    $0x20,%rsp
  802dbe:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802dc1:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802dc4:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802dc7:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802dca:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802dcd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dd0:	89 ce                	mov    %ecx,%esi
  802dd2:	89 c7                	mov    %eax,%edi
  802dd4:	48 b8 fc 31 80 00 00 	movabs $0x8031fc,%rax
  802ddb:	00 00 00 
  802dde:	ff d0                	callq  *%rax
  802de0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802de3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802de7:	79 05                	jns    802dee <socket+0x38>
		return r;
  802de9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dec:	eb 11                	jmp    802dff <socket+0x49>
	return alloc_sockfd(r);
  802dee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df1:	89 c7                	mov    %eax,%edi
  802df3:	48 b8 98 2a 80 00 00 	movabs $0x802a98,%rax
  802dfa:	00 00 00 
  802dfd:	ff d0                	callq  *%rax
}
  802dff:	c9                   	leaveq 
  802e00:	c3                   	retq   

0000000000802e01 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802e01:	55                   	push   %rbp
  802e02:	48 89 e5             	mov    %rsp,%rbp
  802e05:	48 83 ec 10          	sub    $0x10,%rsp
  802e09:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  802e0c:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802e13:	00 00 00 
  802e16:	8b 00                	mov    (%rax),%eax
  802e18:	85 c0                	test   %eax,%eax
  802e1a:	75 1f                	jne    802e3b <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802e1c:	bf 02 00 00 00       	mov    $0x2,%edi
  802e21:	48 b8 a8 3d 80 00 00 	movabs $0x803da8,%rax
  802e28:	00 00 00 
  802e2b:	ff d0                	callq  *%rax
  802e2d:	89 c2                	mov    %eax,%edx
  802e2f:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802e36:	00 00 00 
  802e39:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802e3b:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802e42:	00 00 00 
  802e45:	8b 00                	mov    (%rax),%eax
  802e47:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e4a:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e4f:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802e56:	00 00 00 
  802e59:	89 c7                	mov    %eax,%edi
  802e5b:	48 b8 1b 3c 80 00 00 	movabs $0x803c1b,%rax
  802e62:	00 00 00 
  802e65:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  802e67:	ba 00 00 00 00       	mov    $0x0,%edx
  802e6c:	be 00 00 00 00       	mov    $0x0,%esi
  802e71:	bf 00 00 00 00       	mov    $0x0,%edi
  802e76:	48 b8 dd 3b 80 00 00 	movabs $0x803bdd,%rax
  802e7d:	00 00 00 
  802e80:	ff d0                	callq  *%rax
}
  802e82:	c9                   	leaveq 
  802e83:	c3                   	retq   

0000000000802e84 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802e84:	55                   	push   %rbp
  802e85:	48 89 e5             	mov    %rsp,%rbp
  802e88:	48 83 ec 30          	sub    $0x30,%rsp
  802e8c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e8f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e93:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  802e97:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e9e:	00 00 00 
  802ea1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ea4:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802ea6:	bf 01 00 00 00       	mov    $0x1,%edi
  802eab:	48 b8 01 2e 80 00 00 	movabs $0x802e01,%rax
  802eb2:	00 00 00 
  802eb5:	ff d0                	callq  *%rax
  802eb7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ebe:	78 3e                	js     802efe <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802ec0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ec7:	00 00 00 
  802eca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802ece:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ed2:	8b 40 10             	mov    0x10(%rax),%eax
  802ed5:	89 c2                	mov    %eax,%edx
  802ed7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802edb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802edf:	48 89 ce             	mov    %rcx,%rsi
  802ee2:	48 89 c7             	mov    %rax,%rdi
  802ee5:	48 b8 d0 11 80 00 00 	movabs $0x8011d0,%rax
  802eec:	00 00 00 
  802eef:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  802ef1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ef5:	8b 50 10             	mov    0x10(%rax),%edx
  802ef8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802efc:	89 10                	mov    %edx,(%rax)
	}
	return r;
  802efe:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f01:	c9                   	leaveq 
  802f02:	c3                   	retq   

0000000000802f03 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802f03:	55                   	push   %rbp
  802f04:	48 89 e5             	mov    %rsp,%rbp
  802f07:	48 83 ec 10          	sub    $0x10,%rsp
  802f0b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f0e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802f12:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  802f15:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f1c:	00 00 00 
  802f1f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f22:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802f24:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802f27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f2b:	48 89 c6             	mov    %rax,%rsi
  802f2e:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802f35:	00 00 00 
  802f38:	48 b8 d0 11 80 00 00 	movabs $0x8011d0,%rax
  802f3f:	00 00 00 
  802f42:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  802f44:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f4b:	00 00 00 
  802f4e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802f51:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  802f54:	bf 02 00 00 00       	mov    $0x2,%edi
  802f59:	48 b8 01 2e 80 00 00 	movabs $0x802e01,%rax
  802f60:	00 00 00 
  802f63:	ff d0                	callq  *%rax
}
  802f65:	c9                   	leaveq 
  802f66:	c3                   	retq   

0000000000802f67 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802f67:	55                   	push   %rbp
  802f68:	48 89 e5             	mov    %rsp,%rbp
  802f6b:	48 83 ec 10          	sub    $0x10,%rsp
  802f6f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f72:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  802f75:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f7c:	00 00 00 
  802f7f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f82:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  802f84:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f8b:	00 00 00 
  802f8e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802f91:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  802f94:	bf 03 00 00 00       	mov    $0x3,%edi
  802f99:	48 b8 01 2e 80 00 00 	movabs $0x802e01,%rax
  802fa0:	00 00 00 
  802fa3:	ff d0                	callq  *%rax
}
  802fa5:	c9                   	leaveq 
  802fa6:	c3                   	retq   

0000000000802fa7 <nsipc_close>:

int
nsipc_close(int s)
{
  802fa7:	55                   	push   %rbp
  802fa8:	48 89 e5             	mov    %rsp,%rbp
  802fab:	48 83 ec 10          	sub    $0x10,%rsp
  802faf:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  802fb2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fb9:	00 00 00 
  802fbc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802fbf:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  802fc1:	bf 04 00 00 00       	mov    $0x4,%edi
  802fc6:	48 b8 01 2e 80 00 00 	movabs $0x802e01,%rax
  802fcd:	00 00 00 
  802fd0:	ff d0                	callq  *%rax
}
  802fd2:	c9                   	leaveq 
  802fd3:	c3                   	retq   

0000000000802fd4 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802fd4:	55                   	push   %rbp
  802fd5:	48 89 e5             	mov    %rsp,%rbp
  802fd8:	48 83 ec 10          	sub    $0x10,%rsp
  802fdc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802fdf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802fe3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  802fe6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fed:	00 00 00 
  802ff0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ff3:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802ff5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802ff8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ffc:	48 89 c6             	mov    %rax,%rsi
  802fff:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803006:	00 00 00 
  803009:	48 b8 d0 11 80 00 00 	movabs $0x8011d0,%rax
  803010:	00 00 00 
  803013:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803015:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80301c:	00 00 00 
  80301f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803022:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803025:	bf 05 00 00 00       	mov    $0x5,%edi
  80302a:	48 b8 01 2e 80 00 00 	movabs $0x802e01,%rax
  803031:	00 00 00 
  803034:	ff d0                	callq  *%rax
}
  803036:	c9                   	leaveq 
  803037:	c3                   	retq   

0000000000803038 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803038:	55                   	push   %rbp
  803039:	48 89 e5             	mov    %rsp,%rbp
  80303c:	48 83 ec 10          	sub    $0x10,%rsp
  803040:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803043:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803046:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80304d:	00 00 00 
  803050:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803053:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803055:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80305c:	00 00 00 
  80305f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803062:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803065:	bf 06 00 00 00       	mov    $0x6,%edi
  80306a:	48 b8 01 2e 80 00 00 	movabs $0x802e01,%rax
  803071:	00 00 00 
  803074:	ff d0                	callq  *%rax
}
  803076:	c9                   	leaveq 
  803077:	c3                   	retq   

0000000000803078 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803078:	55                   	push   %rbp
  803079:	48 89 e5             	mov    %rsp,%rbp
  80307c:	48 83 ec 30          	sub    $0x30,%rsp
  803080:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803083:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803087:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80308a:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80308d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803094:	00 00 00 
  803097:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80309a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80309c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030a3:	00 00 00 
  8030a6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030a9:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8030ac:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030b3:	00 00 00 
  8030b6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8030b9:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8030bc:	bf 07 00 00 00       	mov    $0x7,%edi
  8030c1:	48 b8 01 2e 80 00 00 	movabs $0x802e01,%rax
  8030c8:	00 00 00 
  8030cb:	ff d0                	callq  *%rax
  8030cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030d4:	78 69                	js     80313f <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8030d6:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8030dd:	7f 08                	jg     8030e7 <nsipc_recv+0x6f>
  8030df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e2:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8030e5:	7e 35                	jle    80311c <nsipc_recv+0xa4>
  8030e7:	48 b9 9e 45 80 00 00 	movabs $0x80459e,%rcx
  8030ee:	00 00 00 
  8030f1:	48 ba b3 45 80 00 00 	movabs $0x8045b3,%rdx
  8030f8:	00 00 00 
  8030fb:	be 61 00 00 00       	mov    $0x61,%esi
  803100:	48 bf c8 45 80 00 00 	movabs $0x8045c8,%rdi
  803107:	00 00 00 
  80310a:	b8 00 00 00 00       	mov    $0x0,%eax
  80310f:	49 b8 c9 3a 80 00 00 	movabs $0x803ac9,%r8
  803116:	00 00 00 
  803119:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80311c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80311f:	48 63 d0             	movslq %eax,%rdx
  803122:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803126:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80312d:	00 00 00 
  803130:	48 89 c7             	mov    %rax,%rdi
  803133:	48 b8 d0 11 80 00 00 	movabs $0x8011d0,%rax
  80313a:	00 00 00 
  80313d:	ff d0                	callq  *%rax
	}

	return r;
  80313f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803142:	c9                   	leaveq 
  803143:	c3                   	retq   

0000000000803144 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803144:	55                   	push   %rbp
  803145:	48 89 e5             	mov    %rsp,%rbp
  803148:	48 83 ec 20          	sub    $0x20,%rsp
  80314c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80314f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803153:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803156:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803159:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803160:	00 00 00 
  803163:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803166:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803168:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80316f:	7e 35                	jle    8031a6 <nsipc_send+0x62>
  803171:	48 b9 d4 45 80 00 00 	movabs $0x8045d4,%rcx
  803178:	00 00 00 
  80317b:	48 ba b3 45 80 00 00 	movabs $0x8045b3,%rdx
  803182:	00 00 00 
  803185:	be 6c 00 00 00       	mov    $0x6c,%esi
  80318a:	48 bf c8 45 80 00 00 	movabs $0x8045c8,%rdi
  803191:	00 00 00 
  803194:	b8 00 00 00 00       	mov    $0x0,%eax
  803199:	49 b8 c9 3a 80 00 00 	movabs $0x803ac9,%r8
  8031a0:	00 00 00 
  8031a3:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8031a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031a9:	48 63 d0             	movslq %eax,%rdx
  8031ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031b0:	48 89 c6             	mov    %rax,%rsi
  8031b3:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8031ba:	00 00 00 
  8031bd:	48 b8 d0 11 80 00 00 	movabs $0x8011d0,%rax
  8031c4:	00 00 00 
  8031c7:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8031c9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031d0:	00 00 00 
  8031d3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8031d6:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8031d9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031e0:	00 00 00 
  8031e3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8031e6:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8031e9:	bf 08 00 00 00       	mov    $0x8,%edi
  8031ee:	48 b8 01 2e 80 00 00 	movabs $0x802e01,%rax
  8031f5:	00 00 00 
  8031f8:	ff d0                	callq  *%rax
}
  8031fa:	c9                   	leaveq 
  8031fb:	c3                   	retq   

00000000008031fc <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8031fc:	55                   	push   %rbp
  8031fd:	48 89 e5             	mov    %rsp,%rbp
  803200:	48 83 ec 10          	sub    $0x10,%rsp
  803204:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803207:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80320a:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80320d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803214:	00 00 00 
  803217:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80321a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80321c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803223:	00 00 00 
  803226:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803229:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80322c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803233:	00 00 00 
  803236:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803239:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  80323c:	bf 09 00 00 00       	mov    $0x9,%edi
  803241:	48 b8 01 2e 80 00 00 	movabs $0x802e01,%rax
  803248:	00 00 00 
  80324b:	ff d0                	callq  *%rax
}
  80324d:	c9                   	leaveq 
  80324e:	c3                   	retq   

000000000080324f <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80324f:	55                   	push   %rbp
  803250:	48 89 e5             	mov    %rsp,%rbp
  803253:	53                   	push   %rbx
  803254:	48 83 ec 38          	sub    $0x38,%rsp
  803258:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80325c:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803260:	48 89 c7             	mov    %rax,%rdi
  803263:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  80326a:	00 00 00 
  80326d:	ff d0                	callq  *%rax
  80326f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803272:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803276:	0f 88 bf 01 00 00    	js     80343b <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80327c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803280:	ba 07 04 00 00       	mov    $0x407,%edx
  803285:	48 89 c6             	mov    %rax,%rsi
  803288:	bf 00 00 00 00       	mov    $0x0,%edi
  80328d:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  803294:	00 00 00 
  803297:	ff d0                	callq  *%rax
  803299:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80329c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032a0:	0f 88 95 01 00 00    	js     80343b <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8032a6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8032aa:	48 89 c7             	mov    %rax,%rdi
  8032ad:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  8032b4:	00 00 00 
  8032b7:	ff d0                	callq  *%rax
  8032b9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032c0:	0f 88 5d 01 00 00    	js     803423 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032c6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032ca:	ba 07 04 00 00       	mov    $0x407,%edx
  8032cf:	48 89 c6             	mov    %rax,%rsi
  8032d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8032d7:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  8032de:	00 00 00 
  8032e1:	ff d0                	callq  *%rax
  8032e3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032ea:	0f 88 33 01 00 00    	js     803423 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8032f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032f4:	48 89 c7             	mov    %rax,%rdi
  8032f7:	48 b8 44 1c 80 00 00 	movabs $0x801c44,%rax
  8032fe:	00 00 00 
  803301:	ff d0                	callq  *%rax
  803303:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803307:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80330b:	ba 07 04 00 00       	mov    $0x407,%edx
  803310:	48 89 c6             	mov    %rax,%rsi
  803313:	bf 00 00 00 00       	mov    $0x0,%edi
  803318:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  80331f:	00 00 00 
  803322:	ff d0                	callq  *%rax
  803324:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803327:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80332b:	79 05                	jns    803332 <pipe+0xe3>
		goto err2;
  80332d:	e9 d9 00 00 00       	jmpq   80340b <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803332:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803336:	48 89 c7             	mov    %rax,%rdi
  803339:	48 b8 44 1c 80 00 00 	movabs $0x801c44,%rax
  803340:	00 00 00 
  803343:	ff d0                	callq  *%rax
  803345:	48 89 c2             	mov    %rax,%rdx
  803348:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80334c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803352:	48 89 d1             	mov    %rdx,%rcx
  803355:	ba 00 00 00 00       	mov    $0x0,%edx
  80335a:	48 89 c6             	mov    %rax,%rsi
  80335d:	bf 00 00 00 00       	mov    $0x0,%edi
  803362:	48 b8 2b 18 80 00 00 	movabs $0x80182b,%rax
  803369:	00 00 00 
  80336c:	ff d0                	callq  *%rax
  80336e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803371:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803375:	79 1b                	jns    803392 <pipe+0x143>
		goto err3;
  803377:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803378:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80337c:	48 89 c6             	mov    %rax,%rsi
  80337f:	bf 00 00 00 00       	mov    $0x0,%edi
  803384:	48 b8 8b 18 80 00 00 	movabs $0x80188b,%rax
  80338b:	00 00 00 
  80338e:	ff d0                	callq  *%rax
  803390:	eb 79                	jmp    80340b <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  803392:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803396:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80339d:	00 00 00 
  8033a0:	8b 12                	mov    (%rdx),%edx
  8033a2:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8033a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033a8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  8033af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033b3:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8033ba:	00 00 00 
  8033bd:	8b 12                	mov    (%rdx),%edx
  8033bf:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8033c1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033c5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  8033cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033d0:	48 89 c7             	mov    %rax,%rdi
  8033d3:	48 b8 21 1c 80 00 00 	movabs $0x801c21,%rax
  8033da:	00 00 00 
  8033dd:	ff d0                	callq  *%rax
  8033df:	89 c2                	mov    %eax,%edx
  8033e1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033e5:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8033e7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033eb:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8033ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033f3:	48 89 c7             	mov    %rax,%rdi
  8033f6:	48 b8 21 1c 80 00 00 	movabs $0x801c21,%rax
  8033fd:	00 00 00 
  803400:	ff d0                	callq  *%rax
  803402:	89 03                	mov    %eax,(%rbx)
	return 0;
  803404:	b8 00 00 00 00       	mov    $0x0,%eax
  803409:	eb 33                	jmp    80343e <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  80340b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80340f:	48 89 c6             	mov    %rax,%rsi
  803412:	bf 00 00 00 00       	mov    $0x0,%edi
  803417:	48 b8 8b 18 80 00 00 	movabs $0x80188b,%rax
  80341e:	00 00 00 
  803421:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803423:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803427:	48 89 c6             	mov    %rax,%rsi
  80342a:	bf 00 00 00 00       	mov    $0x0,%edi
  80342f:	48 b8 8b 18 80 00 00 	movabs $0x80188b,%rax
  803436:	00 00 00 
  803439:	ff d0                	callq  *%rax
err:
	return r;
  80343b:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80343e:	48 83 c4 38          	add    $0x38,%rsp
  803442:	5b                   	pop    %rbx
  803443:	5d                   	pop    %rbp
  803444:	c3                   	retq   

0000000000803445 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803445:	55                   	push   %rbp
  803446:	48 89 e5             	mov    %rsp,%rbp
  803449:	53                   	push   %rbx
  80344a:	48 83 ec 28          	sub    $0x28,%rsp
  80344e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803452:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803456:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80345d:	00 00 00 
  803460:	48 8b 00             	mov    (%rax),%rax
  803463:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803469:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80346c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803470:	48 89 c7             	mov    %rax,%rdi
  803473:	48 b8 1a 3e 80 00 00 	movabs $0x803e1a,%rax
  80347a:	00 00 00 
  80347d:	ff d0                	callq  *%rax
  80347f:	89 c3                	mov    %eax,%ebx
  803481:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803485:	48 89 c7             	mov    %rax,%rdi
  803488:	48 b8 1a 3e 80 00 00 	movabs $0x803e1a,%rax
  80348f:	00 00 00 
  803492:	ff d0                	callq  *%rax
  803494:	39 c3                	cmp    %eax,%ebx
  803496:	0f 94 c0             	sete   %al
  803499:	0f b6 c0             	movzbl %al,%eax
  80349c:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80349f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8034a6:	00 00 00 
  8034a9:	48 8b 00             	mov    (%rax),%rax
  8034ac:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8034b2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8034b5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034b8:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8034bb:	75 05                	jne    8034c2 <_pipeisclosed+0x7d>
			return ret;
  8034bd:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8034c0:	eb 4a                	jmp    80350c <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  8034c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034c5:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8034c8:	74 3d                	je     803507 <_pipeisclosed+0xc2>
  8034ca:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8034ce:	75 37                	jne    803507 <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8034d0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8034d7:	00 00 00 
  8034da:	48 8b 00             	mov    (%rax),%rax
  8034dd:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8034e3:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8034e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034e9:	89 c6                	mov    %eax,%esi
  8034eb:	48 bf e5 45 80 00 00 	movabs $0x8045e5,%rdi
  8034f2:	00 00 00 
  8034f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8034fa:	49 b8 12 03 80 00 00 	movabs $0x800312,%r8
  803501:	00 00 00 
  803504:	41 ff d0             	callq  *%r8
	}
  803507:	e9 4a ff ff ff       	jmpq   803456 <_pipeisclosed+0x11>
}
  80350c:	48 83 c4 28          	add    $0x28,%rsp
  803510:	5b                   	pop    %rbx
  803511:	5d                   	pop    %rbp
  803512:	c3                   	retq   

0000000000803513 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803513:	55                   	push   %rbp
  803514:	48 89 e5             	mov    %rsp,%rbp
  803517:	48 83 ec 30          	sub    $0x30,%rsp
  80351b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80351e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803522:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803525:	48 89 d6             	mov    %rdx,%rsi
  803528:	89 c7                	mov    %eax,%edi
  80352a:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  803531:	00 00 00 
  803534:	ff d0                	callq  *%rax
  803536:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803539:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80353d:	79 05                	jns    803544 <pipeisclosed+0x31>
		return r;
  80353f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803542:	eb 31                	jmp    803575 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803544:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803548:	48 89 c7             	mov    %rax,%rdi
  80354b:	48 b8 44 1c 80 00 00 	movabs $0x801c44,%rax
  803552:	00 00 00 
  803555:	ff d0                	callq  *%rax
  803557:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80355b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80355f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803563:	48 89 d6             	mov    %rdx,%rsi
  803566:	48 89 c7             	mov    %rax,%rdi
  803569:	48 b8 45 34 80 00 00 	movabs $0x803445,%rax
  803570:	00 00 00 
  803573:	ff d0                	callq  *%rax
}
  803575:	c9                   	leaveq 
  803576:	c3                   	retq   

0000000000803577 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803577:	55                   	push   %rbp
  803578:	48 89 e5             	mov    %rsp,%rbp
  80357b:	48 83 ec 40          	sub    $0x40,%rsp
  80357f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803583:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803587:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80358b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80358f:	48 89 c7             	mov    %rax,%rdi
  803592:	48 b8 44 1c 80 00 00 	movabs $0x801c44,%rax
  803599:	00 00 00 
  80359c:	ff d0                	callq  *%rax
  80359e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8035a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035a6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8035aa:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8035b1:	00 
  8035b2:	e9 92 00 00 00       	jmpq   803649 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8035b7:	eb 41                	jmp    8035fa <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8035b9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8035be:	74 09                	je     8035c9 <devpipe_read+0x52>
				return i;
  8035c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035c4:	e9 92 00 00 00       	jmpq   80365b <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8035c9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035d1:	48 89 d6             	mov    %rdx,%rsi
  8035d4:	48 89 c7             	mov    %rax,%rdi
  8035d7:	48 b8 45 34 80 00 00 	movabs $0x803445,%rax
  8035de:	00 00 00 
  8035e1:	ff d0                	callq  *%rax
  8035e3:	85 c0                	test   %eax,%eax
  8035e5:	74 07                	je     8035ee <devpipe_read+0x77>
				return 0;
  8035e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ec:	eb 6d                	jmp    80365b <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8035ee:	48 b8 9d 17 80 00 00 	movabs $0x80179d,%rax
  8035f5:	00 00 00 
  8035f8:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  8035fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035fe:	8b 10                	mov    (%rax),%edx
  803600:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803604:	8b 40 04             	mov    0x4(%rax),%eax
  803607:	39 c2                	cmp    %eax,%edx
  803609:	74 ae                	je     8035b9 <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80360b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80360f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803613:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803617:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80361b:	8b 00                	mov    (%rax),%eax
  80361d:	99                   	cltd   
  80361e:	c1 ea 1b             	shr    $0x1b,%edx
  803621:	01 d0                	add    %edx,%eax
  803623:	83 e0 1f             	and    $0x1f,%eax
  803626:	29 d0                	sub    %edx,%eax
  803628:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80362c:	48 98                	cltq   
  80362e:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803633:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803635:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803639:	8b 00                	mov    (%rax),%eax
  80363b:	8d 50 01             	lea    0x1(%rax),%edx
  80363e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803642:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  803644:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803649:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80364d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803651:	0f 82 60 ff ff ff    	jb     8035b7 <devpipe_read+0x40>
	}
	return i;
  803657:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80365b:	c9                   	leaveq 
  80365c:	c3                   	retq   

000000000080365d <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80365d:	55                   	push   %rbp
  80365e:	48 89 e5             	mov    %rsp,%rbp
  803661:	48 83 ec 40          	sub    $0x40,%rsp
  803665:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803669:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80366d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803671:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803675:	48 89 c7             	mov    %rax,%rdi
  803678:	48 b8 44 1c 80 00 00 	movabs $0x801c44,%rax
  80367f:	00 00 00 
  803682:	ff d0                	callq  *%rax
  803684:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803688:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80368c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803690:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803697:	00 
  803698:	e9 91 00 00 00       	jmpq   80372e <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80369d:	eb 31                	jmp    8036d0 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80369f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036a7:	48 89 d6             	mov    %rdx,%rsi
  8036aa:	48 89 c7             	mov    %rax,%rdi
  8036ad:	48 b8 45 34 80 00 00 	movabs $0x803445,%rax
  8036b4:	00 00 00 
  8036b7:	ff d0                	callq  *%rax
  8036b9:	85 c0                	test   %eax,%eax
  8036bb:	74 07                	je     8036c4 <devpipe_write+0x67>
				return 0;
  8036bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8036c2:	eb 7c                	jmp    803740 <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8036c4:	48 b8 9d 17 80 00 00 	movabs $0x80179d,%rax
  8036cb:	00 00 00 
  8036ce:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8036d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036d4:	8b 40 04             	mov    0x4(%rax),%eax
  8036d7:	48 63 d0             	movslq %eax,%rdx
  8036da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036de:	8b 00                	mov    (%rax),%eax
  8036e0:	48 98                	cltq   
  8036e2:	48 83 c0 20          	add    $0x20,%rax
  8036e6:	48 39 c2             	cmp    %rax,%rdx
  8036e9:	73 b4                	jae    80369f <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8036eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ef:	8b 40 04             	mov    0x4(%rax),%eax
  8036f2:	99                   	cltd   
  8036f3:	c1 ea 1b             	shr    $0x1b,%edx
  8036f6:	01 d0                	add    %edx,%eax
  8036f8:	83 e0 1f             	and    $0x1f,%eax
  8036fb:	29 d0                	sub    %edx,%eax
  8036fd:	89 c6                	mov    %eax,%esi
  8036ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803703:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803707:	48 01 d0             	add    %rdx,%rax
  80370a:	0f b6 08             	movzbl (%rax),%ecx
  80370d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803711:	48 63 c6             	movslq %esi,%rax
  803714:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803718:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80371c:	8b 40 04             	mov    0x4(%rax),%eax
  80371f:	8d 50 01             	lea    0x1(%rax),%edx
  803722:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803726:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  803729:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80372e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803732:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803736:	0f 82 61 ff ff ff    	jb     80369d <devpipe_write+0x40>
	}

	return i;
  80373c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803740:	c9                   	leaveq 
  803741:	c3                   	retq   

0000000000803742 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803742:	55                   	push   %rbp
  803743:	48 89 e5             	mov    %rsp,%rbp
  803746:	48 83 ec 20          	sub    $0x20,%rsp
  80374a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80374e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803752:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803756:	48 89 c7             	mov    %rax,%rdi
  803759:	48 b8 44 1c 80 00 00 	movabs $0x801c44,%rax
  803760:	00 00 00 
  803763:	ff d0                	callq  *%rax
  803765:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803769:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80376d:	48 be f8 45 80 00 00 	movabs $0x8045f8,%rsi
  803774:	00 00 00 
  803777:	48 89 c7             	mov    %rax,%rdi
  80377a:	48 b8 ac 0e 80 00 00 	movabs $0x800eac,%rax
  803781:	00 00 00 
  803784:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803786:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80378a:	8b 50 04             	mov    0x4(%rax),%edx
  80378d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803791:	8b 00                	mov    (%rax),%eax
  803793:	29 c2                	sub    %eax,%edx
  803795:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803799:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80379f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037a3:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8037aa:	00 00 00 
	stat->st_dev = &devpipe;
  8037ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037b1:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  8037b8:	00 00 00 
  8037bb:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8037c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037c7:	c9                   	leaveq 
  8037c8:	c3                   	retq   

00000000008037c9 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8037c9:	55                   	push   %rbp
  8037ca:	48 89 e5             	mov    %rsp,%rbp
  8037cd:	48 83 ec 10          	sub    $0x10,%rsp
  8037d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8037d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037d9:	48 89 c6             	mov    %rax,%rsi
  8037dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8037e1:	48 b8 8b 18 80 00 00 	movabs $0x80188b,%rax
  8037e8:	00 00 00 
  8037eb:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8037ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037f1:	48 89 c7             	mov    %rax,%rdi
  8037f4:	48 b8 44 1c 80 00 00 	movabs $0x801c44,%rax
  8037fb:	00 00 00 
  8037fe:	ff d0                	callq  *%rax
  803800:	48 89 c6             	mov    %rax,%rsi
  803803:	bf 00 00 00 00       	mov    $0x0,%edi
  803808:	48 b8 8b 18 80 00 00 	movabs $0x80188b,%rax
  80380f:	00 00 00 
  803812:	ff d0                	callq  *%rax
}
  803814:	c9                   	leaveq 
  803815:	c3                   	retq   

0000000000803816 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803816:	55                   	push   %rbp
  803817:	48 89 e5             	mov    %rsp,%rbp
  80381a:	48 83 ec 20          	sub    $0x20,%rsp
  80381e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803821:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803824:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803827:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80382b:	be 01 00 00 00       	mov    $0x1,%esi
  803830:	48 89 c7             	mov    %rax,%rdi
  803833:	48 b8 93 16 80 00 00 	movabs $0x801693,%rax
  80383a:	00 00 00 
  80383d:	ff d0                	callq  *%rax
}
  80383f:	c9                   	leaveq 
  803840:	c3                   	retq   

0000000000803841 <getchar>:

int
getchar(void)
{
  803841:	55                   	push   %rbp
  803842:	48 89 e5             	mov    %rsp,%rbp
  803845:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803849:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80384d:	ba 01 00 00 00       	mov    $0x1,%edx
  803852:	48 89 c6             	mov    %rax,%rsi
  803855:	bf 00 00 00 00       	mov    $0x0,%edi
  80385a:	48 b8 3b 21 80 00 00 	movabs $0x80213b,%rax
  803861:	00 00 00 
  803864:	ff d0                	callq  *%rax
  803866:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803869:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80386d:	79 05                	jns    803874 <getchar+0x33>
		return r;
  80386f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803872:	eb 14                	jmp    803888 <getchar+0x47>
	if (r < 1)
  803874:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803878:	7f 07                	jg     803881 <getchar+0x40>
		return -E_EOF;
  80387a:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80387f:	eb 07                	jmp    803888 <getchar+0x47>
	return c;
  803881:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803885:	0f b6 c0             	movzbl %al,%eax
}
  803888:	c9                   	leaveq 
  803889:	c3                   	retq   

000000000080388a <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80388a:	55                   	push   %rbp
  80388b:	48 89 e5             	mov    %rsp,%rbp
  80388e:	48 83 ec 20          	sub    $0x20,%rsp
  803892:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803895:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803899:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80389c:	48 89 d6             	mov    %rdx,%rsi
  80389f:	89 c7                	mov    %eax,%edi
  8038a1:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  8038a8:	00 00 00 
  8038ab:	ff d0                	callq  *%rax
  8038ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038b4:	79 05                	jns    8038bb <iscons+0x31>
		return r;
  8038b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038b9:	eb 1a                	jmp    8038d5 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8038bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038bf:	8b 10                	mov    (%rax),%edx
  8038c1:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8038c8:	00 00 00 
  8038cb:	8b 00                	mov    (%rax),%eax
  8038cd:	39 c2                	cmp    %eax,%edx
  8038cf:	0f 94 c0             	sete   %al
  8038d2:	0f b6 c0             	movzbl %al,%eax
}
  8038d5:	c9                   	leaveq 
  8038d6:	c3                   	retq   

00000000008038d7 <opencons>:

int
opencons(void)
{
  8038d7:	55                   	push   %rbp
  8038d8:	48 89 e5             	mov    %rsp,%rbp
  8038db:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8038df:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8038e3:	48 89 c7             	mov    %rax,%rdi
  8038e6:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  8038ed:	00 00 00 
  8038f0:	ff d0                	callq  *%rax
  8038f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038f9:	79 05                	jns    803900 <opencons+0x29>
		return r;
  8038fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038fe:	eb 5b                	jmp    80395b <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803900:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803904:	ba 07 04 00 00       	mov    $0x407,%edx
  803909:	48 89 c6             	mov    %rax,%rsi
  80390c:	bf 00 00 00 00       	mov    $0x0,%edi
  803911:	48 b8 d9 17 80 00 00 	movabs $0x8017d9,%rax
  803918:	00 00 00 
  80391b:	ff d0                	callq  *%rax
  80391d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803920:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803924:	79 05                	jns    80392b <opencons+0x54>
		return r;
  803926:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803929:	eb 30                	jmp    80395b <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80392b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80392f:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803936:	00 00 00 
  803939:	8b 12                	mov    (%rdx),%edx
  80393b:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80393d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803941:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803948:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80394c:	48 89 c7             	mov    %rax,%rdi
  80394f:	48 b8 21 1c 80 00 00 	movabs $0x801c21,%rax
  803956:	00 00 00 
  803959:	ff d0                	callq  *%rax
}
  80395b:	c9                   	leaveq 
  80395c:	c3                   	retq   

000000000080395d <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80395d:	55                   	push   %rbp
  80395e:	48 89 e5             	mov    %rsp,%rbp
  803961:	48 83 ec 30          	sub    $0x30,%rsp
  803965:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803969:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80396d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803971:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803976:	75 07                	jne    80397f <devcons_read+0x22>
		return 0;
  803978:	b8 00 00 00 00       	mov    $0x0,%eax
  80397d:	eb 4b                	jmp    8039ca <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80397f:	eb 0c                	jmp    80398d <devcons_read+0x30>
		sys_yield();
  803981:	48 b8 9d 17 80 00 00 	movabs $0x80179d,%rax
  803988:	00 00 00 
  80398b:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  80398d:	48 b8 df 16 80 00 00 	movabs $0x8016df,%rax
  803994:	00 00 00 
  803997:	ff d0                	callq  *%rax
  803999:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80399c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039a0:	74 df                	je     803981 <devcons_read+0x24>
	if (c < 0)
  8039a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039a6:	79 05                	jns    8039ad <devcons_read+0x50>
		return c;
  8039a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039ab:	eb 1d                	jmp    8039ca <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8039ad:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8039b1:	75 07                	jne    8039ba <devcons_read+0x5d>
		return 0;
  8039b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8039b8:	eb 10                	jmp    8039ca <devcons_read+0x6d>
	*(char*)vbuf = c;
  8039ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039bd:	89 c2                	mov    %eax,%edx
  8039bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039c3:	88 10                	mov    %dl,(%rax)
	return 1;
  8039c5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8039ca:	c9                   	leaveq 
  8039cb:	c3                   	retq   

00000000008039cc <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8039cc:	55                   	push   %rbp
  8039cd:	48 89 e5             	mov    %rsp,%rbp
  8039d0:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8039d7:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8039de:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8039e5:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8039ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8039f3:	eb 76                	jmp    803a6b <devcons_write+0x9f>
		m = n - tot;
  8039f5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8039fc:	89 c2                	mov    %eax,%edx
  8039fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a01:	29 c2                	sub    %eax,%edx
  803a03:	89 d0                	mov    %edx,%eax
  803a05:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803a08:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a0b:	83 f8 7f             	cmp    $0x7f,%eax
  803a0e:	76 07                	jbe    803a17 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803a10:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803a17:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a1a:	48 63 d0             	movslq %eax,%rdx
  803a1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a20:	48 63 c8             	movslq %eax,%rcx
  803a23:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803a2a:	48 01 c1             	add    %rax,%rcx
  803a2d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a34:	48 89 ce             	mov    %rcx,%rsi
  803a37:	48 89 c7             	mov    %rax,%rdi
  803a3a:	48 b8 d0 11 80 00 00 	movabs $0x8011d0,%rax
  803a41:	00 00 00 
  803a44:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803a46:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a49:	48 63 d0             	movslq %eax,%rdx
  803a4c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a53:	48 89 d6             	mov    %rdx,%rsi
  803a56:	48 89 c7             	mov    %rax,%rdi
  803a59:	48 b8 93 16 80 00 00 	movabs $0x801693,%rax
  803a60:	00 00 00 
  803a63:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  803a65:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a68:	01 45 fc             	add    %eax,-0x4(%rbp)
  803a6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a6e:	48 98                	cltq   
  803a70:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803a77:	0f 82 78 ff ff ff    	jb     8039f5 <devcons_write+0x29>
	}
	return tot;
  803a7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a80:	c9                   	leaveq 
  803a81:	c3                   	retq   

0000000000803a82 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803a82:	55                   	push   %rbp
  803a83:	48 89 e5             	mov    %rsp,%rbp
  803a86:	48 83 ec 08          	sub    $0x8,%rsp
  803a8a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803a8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a93:	c9                   	leaveq 
  803a94:	c3                   	retq   

0000000000803a95 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803a95:	55                   	push   %rbp
  803a96:	48 89 e5             	mov    %rsp,%rbp
  803a99:	48 83 ec 10          	sub    $0x10,%rsp
  803a9d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803aa1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803aa5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aa9:	48 be 04 46 80 00 00 	movabs $0x804604,%rsi
  803ab0:	00 00 00 
  803ab3:	48 89 c7             	mov    %rax,%rdi
  803ab6:	48 b8 ac 0e 80 00 00 	movabs $0x800eac,%rax
  803abd:	00 00 00 
  803ac0:	ff d0                	callq  *%rax
	return 0;
  803ac2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ac7:	c9                   	leaveq 
  803ac8:	c3                   	retq   

0000000000803ac9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803ac9:	55                   	push   %rbp
  803aca:	48 89 e5             	mov    %rsp,%rbp
  803acd:	53                   	push   %rbx
  803ace:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803ad5:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803adc:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803ae2:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803ae9:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803af0:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803af7:	84 c0                	test   %al,%al
  803af9:	74 23                	je     803b1e <_panic+0x55>
  803afb:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803b02:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803b06:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803b0a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803b0e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803b12:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803b16:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803b1a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803b1e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803b25:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803b2c:	00 00 00 
  803b2f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803b36:	00 00 00 
  803b39:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803b3d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803b44:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803b4b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803b52:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803b59:	00 00 00 
  803b5c:	48 8b 18             	mov    (%rax),%rbx
  803b5f:	48 b8 61 17 80 00 00 	movabs $0x801761,%rax
  803b66:	00 00 00 
  803b69:	ff d0                	callq  *%rax
  803b6b:	89 c6                	mov    %eax,%esi
  803b6d:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  803b73:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803b7a:	41 89 d0             	mov    %edx,%r8d
  803b7d:	48 89 c1             	mov    %rax,%rcx
  803b80:	48 89 da             	mov    %rbx,%rdx
  803b83:	48 bf 10 46 80 00 00 	movabs $0x804610,%rdi
  803b8a:	00 00 00 
  803b8d:	b8 00 00 00 00       	mov    $0x0,%eax
  803b92:	49 b9 12 03 80 00 00 	movabs $0x800312,%r9
  803b99:	00 00 00 
  803b9c:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803b9f:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803ba6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803bad:	48 89 d6             	mov    %rdx,%rsi
  803bb0:	48 89 c7             	mov    %rax,%rdi
  803bb3:	48 b8 66 02 80 00 00 	movabs $0x800266,%rax
  803bba:	00 00 00 
  803bbd:	ff d0                	callq  *%rax
	cprintf("\n");
  803bbf:	48 bf 33 46 80 00 00 	movabs $0x804633,%rdi
  803bc6:	00 00 00 
  803bc9:	b8 00 00 00 00       	mov    $0x0,%eax
  803bce:	48 ba 12 03 80 00 00 	movabs $0x800312,%rdx
  803bd5:	00 00 00 
  803bd8:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803bda:	cc                   	int3   
  803bdb:	eb fd                	jmp    803bda <_panic+0x111>

0000000000803bdd <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803bdd:	55                   	push   %rbp
  803bde:	48 89 e5             	mov    %rsp,%rbp
  803be1:	48 83 ec 20          	sub    $0x20,%rsp
  803be5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803be9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803bed:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  803bf1:	48 ba 38 46 80 00 00 	movabs $0x804638,%rdx
  803bf8:	00 00 00 
  803bfb:	be 1d 00 00 00       	mov    $0x1d,%esi
  803c00:	48 bf 51 46 80 00 00 	movabs $0x804651,%rdi
  803c07:	00 00 00 
  803c0a:	b8 00 00 00 00       	mov    $0x0,%eax
  803c0f:	48 b9 c9 3a 80 00 00 	movabs $0x803ac9,%rcx
  803c16:	00 00 00 
  803c19:	ff d1                	callq  *%rcx

0000000000803c1b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803c1b:	55                   	push   %rbp
  803c1c:	48 89 e5             	mov    %rsp,%rbp
  803c1f:	48 83 ec 20          	sub    $0x20,%rsp
  803c23:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c26:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803c29:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  803c2d:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  803c30:	48 ba 5b 46 80 00 00 	movabs $0x80465b,%rdx
  803c37:	00 00 00 
  803c3a:	be 2d 00 00 00       	mov    $0x2d,%esi
  803c3f:	48 bf 51 46 80 00 00 	movabs $0x804651,%rdi
  803c46:	00 00 00 
  803c49:	b8 00 00 00 00       	mov    $0x0,%eax
  803c4e:	48 b9 c9 3a 80 00 00 	movabs $0x803ac9,%rcx
  803c55:	00 00 00 
  803c58:	ff d1                	callq  *%rcx

0000000000803c5a <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803c5a:	55                   	push   %rbp
  803c5b:	48 89 e5             	mov    %rsp,%rbp
  803c5e:	53                   	push   %rbx
  803c5f:	48 83 ec 48          	sub    $0x48,%rsp
  803c63:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  803c67:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  803c6e:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  803c75:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  803c7a:	75 0e                	jne    803c8a <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  803c7c:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803c83:	00 00 00 
  803c86:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  803c8a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803c8e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  803c92:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803c99:	00 
	a3 = (uint64_t) 0;
  803c9a:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  803ca1:	00 
	a4 = (uint64_t) 0;
  803ca2:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803ca9:	00 
	a5 = 0;
  803caa:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  803cb1:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  803cb2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803cb5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803cb9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803cbd:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  803cc1:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  803cc5:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  803cc9:	4c 89 c3             	mov    %r8,%rbx
  803ccc:	0f 01 c1             	vmcall 
  803ccf:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  803cd2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cd6:	7e 36                	jle    803d0e <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  803cd8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803cdb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803cde:	41 89 d0             	mov    %edx,%r8d
  803ce1:	89 c1                	mov    %eax,%ecx
  803ce3:	48 ba 78 46 80 00 00 	movabs $0x804678,%rdx
  803cea:	00 00 00 
  803ced:	be 54 00 00 00       	mov    $0x54,%esi
  803cf2:	48 bf 51 46 80 00 00 	movabs $0x804651,%rdi
  803cf9:	00 00 00 
  803cfc:	b8 00 00 00 00       	mov    $0x0,%eax
  803d01:	49 b9 c9 3a 80 00 00 	movabs $0x803ac9,%r9
  803d08:	00 00 00 
  803d0b:	41 ff d1             	callq  *%r9
	return ret;
  803d0e:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803d11:	48 83 c4 48          	add    $0x48,%rsp
  803d15:	5b                   	pop    %rbx
  803d16:	5d                   	pop    %rbp
  803d17:	c3                   	retq   

0000000000803d18 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803d18:	55                   	push   %rbp
  803d19:	48 89 e5             	mov    %rsp,%rbp
  803d1c:	53                   	push   %rbx
  803d1d:	48 83 ec 58          	sub    $0x58,%rsp
  803d21:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  803d24:	89 75 b0             	mov    %esi,-0x50(%rbp)
  803d27:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  803d2b:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  803d2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  803d35:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  803d3c:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  803d41:	75 0e                	jne    803d51 <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  803d43:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803d4a:	00 00 00 
  803d4d:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  803d51:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  803d54:	48 98                	cltq   
  803d56:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  803d5a:	8b 45 b0             	mov    -0x50(%rbp),%eax
  803d5d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  803d61:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803d65:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  803d69:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  803d6c:	48 98                	cltq   
  803d6e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  803d72:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803d79:	00 

	int r = -E_IPC_NOT_RECV;
  803d7a:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  803d81:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803d84:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803d88:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803d8c:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  803d90:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803d94:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  803d98:	4c 89 c3             	mov    %r8,%rbx
  803d9b:	0f 01 c1             	vmcall 
  803d9e:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  803da1:	48 83 c4 58          	add    $0x58,%rsp
  803da5:	5b                   	pop    %rbx
  803da6:	5d                   	pop    %rbp
  803da7:	c3                   	retq   

0000000000803da8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803da8:	55                   	push   %rbp
  803da9:	48 89 e5             	mov    %rsp,%rbp
  803dac:	48 83 ec 18          	sub    $0x18,%rsp
  803db0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803db3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803dba:	eb 4e                	jmp    803e0a <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  803dbc:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803dc3:	00 00 00 
  803dc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dc9:	48 98                	cltq   
  803dcb:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803dd2:	48 01 d0             	add    %rdx,%rax
  803dd5:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803ddb:	8b 00                	mov    (%rax),%eax
  803ddd:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803de0:	75 24                	jne    803e06 <ipc_find_env+0x5e>
			return envs[i].env_id;
  803de2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803de9:	00 00 00 
  803dec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803def:	48 98                	cltq   
  803df1:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803df8:	48 01 d0             	add    %rdx,%rax
  803dfb:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803e01:	8b 40 08             	mov    0x8(%rax),%eax
  803e04:	eb 12                	jmp    803e18 <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  803e06:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803e0a:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803e11:	7e a9                	jle    803dbc <ipc_find_env+0x14>
	}
	return 0;
  803e13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e18:	c9                   	leaveq 
  803e19:	c3                   	retq   

0000000000803e1a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803e1a:	55                   	push   %rbp
  803e1b:	48 89 e5             	mov    %rsp,%rbp
  803e1e:	48 83 ec 18          	sub    $0x18,%rsp
  803e22:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803e26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e2a:	48 c1 e8 15          	shr    $0x15,%rax
  803e2e:	48 89 c2             	mov    %rax,%rdx
  803e31:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803e38:	01 00 00 
  803e3b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e3f:	83 e0 01             	and    $0x1,%eax
  803e42:	48 85 c0             	test   %rax,%rax
  803e45:	75 07                	jne    803e4e <pageref+0x34>
		return 0;
  803e47:	b8 00 00 00 00       	mov    $0x0,%eax
  803e4c:	eb 53                	jmp    803ea1 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803e4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e52:	48 c1 e8 0c          	shr    $0xc,%rax
  803e56:	48 89 c2             	mov    %rax,%rdx
  803e59:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803e60:	01 00 00 
  803e63:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e67:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803e6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e6f:	83 e0 01             	and    $0x1,%eax
  803e72:	48 85 c0             	test   %rax,%rax
  803e75:	75 07                	jne    803e7e <pageref+0x64>
		return 0;
  803e77:	b8 00 00 00 00       	mov    $0x0,%eax
  803e7c:	eb 23                	jmp    803ea1 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803e7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e82:	48 c1 e8 0c          	shr    $0xc,%rax
  803e86:	48 89 c2             	mov    %rax,%rdx
  803e89:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803e90:	00 00 00 
  803e93:	48 c1 e2 04          	shl    $0x4,%rdx
  803e97:	48 01 d0             	add    %rdx,%rax
  803e9a:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803e9e:	0f b7 c0             	movzwl %ax,%eax
}
  803ea1:	c9                   	leaveq 
  803ea2:	c3                   	retq   
