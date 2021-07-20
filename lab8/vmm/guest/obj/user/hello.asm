
vmm/guest/obj/user/hello:     formato del fichero elf64-x86-64


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
  80003c:	e8 5e 00 00 00       	callq  80009f <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	cprintf("hello, world\n");
  800052:	48 bf 00 3d 80 00 00 	movabs $0x803d00,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 47 02 80 00 00 	movabs $0x800247,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	cprintf("i am environment %08x\n", thisenv->env_id);
  80006d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800074:	00 00 00 
  800077:	48 8b 00             	mov    (%rax),%rax
  80007a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800080:	89 c6                	mov    %eax,%esi
  800082:	48 bf 0e 3d 80 00 00 	movabs $0x803d0e,%rdi
  800089:	00 00 00 
  80008c:	b8 00 00 00 00       	mov    $0x0,%eax
  800091:	48 ba 47 02 80 00 00 	movabs $0x800247,%rdx
  800098:	00 00 00 
  80009b:	ff d2                	callq  *%rdx
}
  80009d:	c9                   	leaveq 
  80009e:	c3                   	retq   

000000000080009f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80009f:	55                   	push   %rbp
  8000a0:	48 89 e5             	mov    %rsp,%rbp
  8000a3:	48 83 ec 10          	sub    $0x10,%rsp
  8000a7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8000ae:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8000b5:	00 00 00 
  8000b8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000c3:	7e 14                	jle    8000d9 <libmain+0x3a>
		binaryname = argv[0];
  8000c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000c9:	48 8b 10             	mov    (%rax),%rdx
  8000cc:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000d3:	00 00 00 
  8000d6:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000d9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000e0:	48 89 d6             	mov    %rdx,%rsi
  8000e3:	89 c7                	mov    %eax,%edi
  8000e5:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000ec:	00 00 00 
  8000ef:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000f1:	48 b8 ff 00 80 00 00 	movabs $0x8000ff,%rax
  8000f8:	00 00 00 
  8000fb:	ff d0                	callq  *%rax
}
  8000fd:	c9                   	leaveq 
  8000fe:	c3                   	retq   

00000000008000ff <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ff:	55                   	push   %rbp
  800100:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800103:	48 b8 b9 1d 80 00 00 	movabs $0x801db9,%rax
  80010a:	00 00 00 
  80010d:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80010f:	bf 00 00 00 00       	mov    $0x0,%edi
  800114:	48 b8 50 16 80 00 00 	movabs $0x801650,%rax
  80011b:	00 00 00 
  80011e:	ff d0                	callq  *%rax
}
  800120:	5d                   	pop    %rbp
  800121:	c3                   	retq   

0000000000800122 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800122:	55                   	push   %rbp
  800123:	48 89 e5             	mov    %rsp,%rbp
  800126:	48 83 ec 10          	sub    $0x10,%rsp
  80012a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80012d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800131:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800135:	8b 00                	mov    (%rax),%eax
  800137:	8d 48 01             	lea    0x1(%rax),%ecx
  80013a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80013e:	89 0a                	mov    %ecx,(%rdx)
  800140:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800143:	89 d1                	mov    %edx,%ecx
  800145:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800149:	48 98                	cltq   
  80014b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80014f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800153:	8b 00                	mov    (%rax),%eax
  800155:	3d ff 00 00 00       	cmp    $0xff,%eax
  80015a:	75 2c                	jne    800188 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80015c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800160:	8b 00                	mov    (%rax),%eax
  800162:	48 98                	cltq   
  800164:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800168:	48 83 c2 08          	add    $0x8,%rdx
  80016c:	48 89 c6             	mov    %rax,%rsi
  80016f:	48 89 d7             	mov    %rdx,%rdi
  800172:	48 b8 c8 15 80 00 00 	movabs $0x8015c8,%rax
  800179:	00 00 00 
  80017c:	ff d0                	callq  *%rax
        b->idx = 0;
  80017e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800182:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800188:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80018c:	8b 40 04             	mov    0x4(%rax),%eax
  80018f:	8d 50 01             	lea    0x1(%rax),%edx
  800192:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800196:	89 50 04             	mov    %edx,0x4(%rax)
}
  800199:	c9                   	leaveq 
  80019a:	c3                   	retq   

000000000080019b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80019b:	55                   	push   %rbp
  80019c:	48 89 e5             	mov    %rsp,%rbp
  80019f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001a6:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001ad:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8001b4:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001bb:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001c2:	48 8b 0a             	mov    (%rdx),%rcx
  8001c5:	48 89 08             	mov    %rcx,(%rax)
  8001c8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001cc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8001d0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8001d4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8001d8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8001df:	00 00 00 
    b.cnt = 0;
  8001e2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8001e9:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8001ec:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8001f3:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8001fa:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800201:	48 89 c6             	mov    %rax,%rsi
  800204:	48 bf 22 01 80 00 00 	movabs $0x800122,%rdi
  80020b:	00 00 00 
  80020e:	48 b8 e6 05 80 00 00 	movabs $0x8005e6,%rax
  800215:	00 00 00 
  800218:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80021a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800220:	48 98                	cltq   
  800222:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800229:	48 83 c2 08          	add    $0x8,%rdx
  80022d:	48 89 c6             	mov    %rax,%rsi
  800230:	48 89 d7             	mov    %rdx,%rdi
  800233:	48 b8 c8 15 80 00 00 	movabs $0x8015c8,%rax
  80023a:	00 00 00 
  80023d:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80023f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800245:	c9                   	leaveq 
  800246:	c3                   	retq   

0000000000800247 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800247:	55                   	push   %rbp
  800248:	48 89 e5             	mov    %rsp,%rbp
  80024b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800252:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800259:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800260:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800267:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80026e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800275:	84 c0                	test   %al,%al
  800277:	74 20                	je     800299 <cprintf+0x52>
  800279:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80027d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800281:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800285:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800289:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80028d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800291:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800295:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800299:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8002a0:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002a7:	00 00 00 
  8002aa:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002b1:	00 00 00 
  8002b4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002b8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002bf:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002c6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8002cd:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8002d4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8002db:	48 8b 0a             	mov    (%rdx),%rcx
  8002de:	48 89 08             	mov    %rcx,(%rax)
  8002e1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002e5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002e9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002ed:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8002f1:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8002f8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8002ff:	48 89 d6             	mov    %rdx,%rsi
  800302:	48 89 c7             	mov    %rax,%rdi
  800305:	48 b8 9b 01 80 00 00 	movabs $0x80019b,%rax
  80030c:	00 00 00 
  80030f:	ff d0                	callq  *%rax
  800311:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800317:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80031d:	c9                   	leaveq 
  80031e:	c3                   	retq   

000000000080031f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80031f:	55                   	push   %rbp
  800320:	48 89 e5             	mov    %rsp,%rbp
  800323:	48 83 ec 30          	sub    $0x30,%rsp
  800327:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80032b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80032f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800333:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800336:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80033a:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80033e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800341:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800345:	77 42                	ja     800389 <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800347:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80034a:	8d 78 ff             	lea    -0x1(%rax),%edi
  80034d:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800350:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800354:	ba 00 00 00 00       	mov    $0x0,%edx
  800359:	48 f7 f6             	div    %rsi
  80035c:	49 89 c2             	mov    %rax,%r10
  80035f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800362:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800365:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800369:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80036d:	41 89 c9             	mov    %ecx,%r9d
  800370:	41 89 f8             	mov    %edi,%r8d
  800373:	89 d1                	mov    %edx,%ecx
  800375:	4c 89 d2             	mov    %r10,%rdx
  800378:	48 89 c7             	mov    %rax,%rdi
  80037b:	48 b8 1f 03 80 00 00 	movabs $0x80031f,%rax
  800382:	00 00 00 
  800385:	ff d0                	callq  *%rax
  800387:	eb 1e                	jmp    8003a7 <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800389:	eb 12                	jmp    80039d <printnum+0x7e>
			putch(padc, putdat);
  80038b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80038f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800392:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800396:	48 89 ce             	mov    %rcx,%rsi
  800399:	89 d7                	mov    %edx,%edi
  80039b:	ff d0                	callq  *%rax
		while (--width > 0)
  80039d:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8003a1:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8003a5:	7f e4                	jg     80038b <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003a7:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8003aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b3:	48 f7 f1             	div    %rcx
  8003b6:	48 b8 30 3f 80 00 00 	movabs $0x803f30,%rax
  8003bd:	00 00 00 
  8003c0:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8003c4:	0f be d0             	movsbl %al,%edx
  8003c7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8003cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003cf:	48 89 ce             	mov    %rcx,%rsi
  8003d2:	89 d7                	mov    %edx,%edi
  8003d4:	ff d0                	callq  *%rax
}
  8003d6:	c9                   	leaveq 
  8003d7:	c3                   	retq   

00000000008003d8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003d8:	55                   	push   %rbp
  8003d9:	48 89 e5             	mov    %rsp,%rbp
  8003dc:	48 83 ec 20          	sub    $0x20,%rsp
  8003e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003e4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8003e7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8003eb:	7e 4f                	jle    80043c <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8003ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003f1:	8b 00                	mov    (%rax),%eax
  8003f3:	83 f8 30             	cmp    $0x30,%eax
  8003f6:	73 24                	jae    80041c <getuint+0x44>
  8003f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003fc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800400:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800404:	8b 00                	mov    (%rax),%eax
  800406:	89 c0                	mov    %eax,%eax
  800408:	48 01 d0             	add    %rdx,%rax
  80040b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80040f:	8b 12                	mov    (%rdx),%edx
  800411:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800414:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800418:	89 0a                	mov    %ecx,(%rdx)
  80041a:	eb 14                	jmp    800430 <getuint+0x58>
  80041c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800420:	48 8b 40 08          	mov    0x8(%rax),%rax
  800424:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800428:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800430:	48 8b 00             	mov    (%rax),%rax
  800433:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800437:	e9 9d 00 00 00       	jmpq   8004d9 <getuint+0x101>
	else if (lflag)
  80043c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800440:	74 4c                	je     80048e <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800442:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800446:	8b 00                	mov    (%rax),%eax
  800448:	83 f8 30             	cmp    $0x30,%eax
  80044b:	73 24                	jae    800471 <getuint+0x99>
  80044d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800451:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800455:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800459:	8b 00                	mov    (%rax),%eax
  80045b:	89 c0                	mov    %eax,%eax
  80045d:	48 01 d0             	add    %rdx,%rax
  800460:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800464:	8b 12                	mov    (%rdx),%edx
  800466:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800469:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80046d:	89 0a                	mov    %ecx,(%rdx)
  80046f:	eb 14                	jmp    800485 <getuint+0xad>
  800471:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800475:	48 8b 40 08          	mov    0x8(%rax),%rax
  800479:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80047d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800481:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800485:	48 8b 00             	mov    (%rax),%rax
  800488:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80048c:	eb 4b                	jmp    8004d9 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  80048e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800492:	8b 00                	mov    (%rax),%eax
  800494:	83 f8 30             	cmp    $0x30,%eax
  800497:	73 24                	jae    8004bd <getuint+0xe5>
  800499:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80049d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a5:	8b 00                	mov    (%rax),%eax
  8004a7:	89 c0                	mov    %eax,%eax
  8004a9:	48 01 d0             	add    %rdx,%rax
  8004ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004b0:	8b 12                	mov    (%rdx),%edx
  8004b2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004b9:	89 0a                	mov    %ecx,(%rdx)
  8004bb:	eb 14                	jmp    8004d1 <getuint+0xf9>
  8004bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004c5:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8004c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004cd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004d1:	8b 00                	mov    (%rax),%eax
  8004d3:	89 c0                	mov    %eax,%eax
  8004d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8004d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004dd:	c9                   	leaveq 
  8004de:	c3                   	retq   

00000000008004df <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004df:	55                   	push   %rbp
  8004e0:	48 89 e5             	mov    %rsp,%rbp
  8004e3:	48 83 ec 20          	sub    $0x20,%rsp
  8004e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004eb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8004ee:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004f2:	7e 4f                	jle    800543 <getint+0x64>
		x=va_arg(*ap, long long);
  8004f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f8:	8b 00                	mov    (%rax),%eax
  8004fa:	83 f8 30             	cmp    $0x30,%eax
  8004fd:	73 24                	jae    800523 <getint+0x44>
  8004ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800503:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800507:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80050b:	8b 00                	mov    (%rax),%eax
  80050d:	89 c0                	mov    %eax,%eax
  80050f:	48 01 d0             	add    %rdx,%rax
  800512:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800516:	8b 12                	mov    (%rdx),%edx
  800518:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80051b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80051f:	89 0a                	mov    %ecx,(%rdx)
  800521:	eb 14                	jmp    800537 <getint+0x58>
  800523:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800527:	48 8b 40 08          	mov    0x8(%rax),%rax
  80052b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80052f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800533:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800537:	48 8b 00             	mov    (%rax),%rax
  80053a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80053e:	e9 9d 00 00 00       	jmpq   8005e0 <getint+0x101>
	else if (lflag)
  800543:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800547:	74 4c                	je     800595 <getint+0xb6>
		x=va_arg(*ap, long);
  800549:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054d:	8b 00                	mov    (%rax),%eax
  80054f:	83 f8 30             	cmp    $0x30,%eax
  800552:	73 24                	jae    800578 <getint+0x99>
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
  800576:	eb 14                	jmp    80058c <getint+0xad>
  800578:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800580:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800584:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800588:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80058c:	48 8b 00             	mov    (%rax),%rax
  80058f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800593:	eb 4b                	jmp    8005e0 <getint+0x101>
	else
		x=va_arg(*ap, int);
  800595:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800599:	8b 00                	mov    (%rax),%eax
  80059b:	83 f8 30             	cmp    $0x30,%eax
  80059e:	73 24                	jae    8005c4 <getint+0xe5>
  8005a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ac:	8b 00                	mov    (%rax),%eax
  8005ae:	89 c0                	mov    %eax,%eax
  8005b0:	48 01 d0             	add    %rdx,%rax
  8005b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b7:	8b 12                	mov    (%rdx),%edx
  8005b9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c0:	89 0a                	mov    %ecx,(%rdx)
  8005c2:	eb 14                	jmp    8005d8 <getint+0xf9>
  8005c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c8:	48 8b 40 08          	mov    0x8(%rax),%rax
  8005cc:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8005d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005d8:	8b 00                	mov    (%rax),%eax
  8005da:	48 98                	cltq   
  8005dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005e4:	c9                   	leaveq 
  8005e5:	c3                   	retq   

00000000008005e6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005e6:	55                   	push   %rbp
  8005e7:	48 89 e5             	mov    %rsp,%rbp
  8005ea:	41 54                	push   %r12
  8005ec:	53                   	push   %rbx
  8005ed:	48 83 ec 60          	sub    $0x60,%rsp
  8005f1:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8005f5:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8005f9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8005fd:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800601:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800605:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800609:	48 8b 0a             	mov    (%rdx),%rcx
  80060c:	48 89 08             	mov    %rcx,(%rax)
  80060f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800613:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800617:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80061b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80061f:	eb 17                	jmp    800638 <vprintfmt+0x52>
			if (ch == '\0')
  800621:	85 db                	test   %ebx,%ebx
  800623:	0f 84 c5 04 00 00    	je     800aee <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  800629:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80062d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800631:	48 89 d6             	mov    %rdx,%rsi
  800634:	89 df                	mov    %ebx,%edi
  800636:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800638:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80063c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800640:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800644:	0f b6 00             	movzbl (%rax),%eax
  800647:	0f b6 d8             	movzbl %al,%ebx
  80064a:	83 fb 25             	cmp    $0x25,%ebx
  80064d:	75 d2                	jne    800621 <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  80064f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800653:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80065a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800661:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800668:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80066f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800673:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800677:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80067b:	0f b6 00             	movzbl (%rax),%eax
  80067e:	0f b6 d8             	movzbl %al,%ebx
  800681:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800684:	83 f8 55             	cmp    $0x55,%eax
  800687:	0f 87 2e 04 00 00    	ja     800abb <vprintfmt+0x4d5>
  80068d:	89 c0                	mov    %eax,%eax
  80068f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800696:	00 
  800697:	48 b8 58 3f 80 00 00 	movabs $0x803f58,%rax
  80069e:	00 00 00 
  8006a1:	48 01 d0             	add    %rdx,%rax
  8006a4:	48 8b 00             	mov    (%rax),%rax
  8006a7:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8006a9:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006ad:	eb c0                	jmp    80066f <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006af:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006b3:	eb ba                	jmp    80066f <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006b5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8006bc:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8006bf:	89 d0                	mov    %edx,%eax
  8006c1:	c1 e0 02             	shl    $0x2,%eax
  8006c4:	01 d0                	add    %edx,%eax
  8006c6:	01 c0                	add    %eax,%eax
  8006c8:	01 d8                	add    %ebx,%eax
  8006ca:	83 e8 30             	sub    $0x30,%eax
  8006cd:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8006d0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006d4:	0f b6 00             	movzbl (%rax),%eax
  8006d7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006da:	83 fb 2f             	cmp    $0x2f,%ebx
  8006dd:	7e 0c                	jle    8006eb <vprintfmt+0x105>
  8006df:	83 fb 39             	cmp    $0x39,%ebx
  8006e2:	7f 07                	jg     8006eb <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  8006e4:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  8006e9:	eb d1                	jmp    8006bc <vprintfmt+0xd6>
			goto process_precision;
  8006eb:	eb 50                	jmp    80073d <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  8006ed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006f0:	83 f8 30             	cmp    $0x30,%eax
  8006f3:	73 17                	jae    80070c <vprintfmt+0x126>
  8006f5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8006f9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8006fc:	89 d2                	mov    %edx,%edx
  8006fe:	48 01 d0             	add    %rdx,%rax
  800701:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800704:	83 c2 08             	add    $0x8,%edx
  800707:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80070a:	eb 0c                	jmp    800718 <vprintfmt+0x132>
  80070c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800710:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800714:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800718:	8b 00                	mov    (%rax),%eax
  80071a:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80071d:	eb 1e                	jmp    80073d <vprintfmt+0x157>

		case '.':
			if (width < 0)
  80071f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800723:	79 07                	jns    80072c <vprintfmt+0x146>
				width = 0;
  800725:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80072c:	e9 3e ff ff ff       	jmpq   80066f <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800731:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800738:	e9 32 ff ff ff       	jmpq   80066f <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80073d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800741:	79 0d                	jns    800750 <vprintfmt+0x16a>
				width = precision, precision = -1;
  800743:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800746:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800749:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800750:	e9 1a ff ff ff       	jmpq   80066f <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800755:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800759:	e9 11 ff ff ff       	jmpq   80066f <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80075e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800761:	83 f8 30             	cmp    $0x30,%eax
  800764:	73 17                	jae    80077d <vprintfmt+0x197>
  800766:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80076a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80076d:	89 d2                	mov    %edx,%edx
  80076f:	48 01 d0             	add    %rdx,%rax
  800772:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800775:	83 c2 08             	add    $0x8,%edx
  800778:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80077b:	eb 0c                	jmp    800789 <vprintfmt+0x1a3>
  80077d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800781:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800785:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800789:	8b 10                	mov    (%rax),%edx
  80078b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80078f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800793:	48 89 ce             	mov    %rcx,%rsi
  800796:	89 d7                	mov    %edx,%edi
  800798:	ff d0                	callq  *%rax
			break;
  80079a:	e9 4a 03 00 00       	jmpq   800ae9 <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80079f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007a2:	83 f8 30             	cmp    $0x30,%eax
  8007a5:	73 17                	jae    8007be <vprintfmt+0x1d8>
  8007a7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8007ab:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007ae:	89 d2                	mov    %edx,%edx
  8007b0:	48 01 d0             	add    %rdx,%rax
  8007b3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007b6:	83 c2 08             	add    $0x8,%edx
  8007b9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007bc:	eb 0c                	jmp    8007ca <vprintfmt+0x1e4>
  8007be:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8007c2:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8007c6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007ca:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8007cc:	85 db                	test   %ebx,%ebx
  8007ce:	79 02                	jns    8007d2 <vprintfmt+0x1ec>
				err = -err;
  8007d0:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007d2:	83 fb 15             	cmp    $0x15,%ebx
  8007d5:	7f 16                	jg     8007ed <vprintfmt+0x207>
  8007d7:	48 b8 80 3e 80 00 00 	movabs $0x803e80,%rax
  8007de:	00 00 00 
  8007e1:	48 63 d3             	movslq %ebx,%rdx
  8007e4:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8007e8:	4d 85 e4             	test   %r12,%r12
  8007eb:	75 2e                	jne    80081b <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  8007ed:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8007f1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007f5:	89 d9                	mov    %ebx,%ecx
  8007f7:	48 ba 41 3f 80 00 00 	movabs $0x803f41,%rdx
  8007fe:	00 00 00 
  800801:	48 89 c7             	mov    %rax,%rdi
  800804:	b8 00 00 00 00       	mov    $0x0,%eax
  800809:	49 b8 f7 0a 80 00 00 	movabs $0x800af7,%r8
  800810:	00 00 00 
  800813:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800816:	e9 ce 02 00 00       	jmpq   800ae9 <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  80081b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80081f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800823:	4c 89 e1             	mov    %r12,%rcx
  800826:	48 ba 4a 3f 80 00 00 	movabs $0x803f4a,%rdx
  80082d:	00 00 00 
  800830:	48 89 c7             	mov    %rax,%rdi
  800833:	b8 00 00 00 00       	mov    $0x0,%eax
  800838:	49 b8 f7 0a 80 00 00 	movabs $0x800af7,%r8
  80083f:	00 00 00 
  800842:	41 ff d0             	callq  *%r8
			break;
  800845:	e9 9f 02 00 00       	jmpq   800ae9 <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80084a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80084d:	83 f8 30             	cmp    $0x30,%eax
  800850:	73 17                	jae    800869 <vprintfmt+0x283>
  800852:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800856:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800859:	89 d2                	mov    %edx,%edx
  80085b:	48 01 d0             	add    %rdx,%rax
  80085e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800861:	83 c2 08             	add    $0x8,%edx
  800864:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800867:	eb 0c                	jmp    800875 <vprintfmt+0x28f>
  800869:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80086d:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800871:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800875:	4c 8b 20             	mov    (%rax),%r12
  800878:	4d 85 e4             	test   %r12,%r12
  80087b:	75 0a                	jne    800887 <vprintfmt+0x2a1>
				p = "(null)";
  80087d:	49 bc 4d 3f 80 00 00 	movabs $0x803f4d,%r12
  800884:	00 00 00 
			if (width > 0 && padc != '-')
  800887:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80088b:	7e 3f                	jle    8008cc <vprintfmt+0x2e6>
  80088d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800891:	74 39                	je     8008cc <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800893:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800896:	48 98                	cltq   
  800898:	48 89 c6             	mov    %rax,%rsi
  80089b:	4c 89 e7             	mov    %r12,%rdi
  80089e:	48 b8 a3 0d 80 00 00 	movabs $0x800da3,%rax
  8008a5:	00 00 00 
  8008a8:	ff d0                	callq  *%rax
  8008aa:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8008ad:	eb 17                	jmp    8008c6 <vprintfmt+0x2e0>
					putch(padc, putdat);
  8008af:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8008b3:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008b7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008bb:	48 89 ce             	mov    %rcx,%rsi
  8008be:	89 d7                	mov    %edx,%edi
  8008c0:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8008c6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008ca:	7f e3                	jg     8008af <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008cc:	eb 37                	jmp    800905 <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ce:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8008d2:	74 1e                	je     8008f2 <vprintfmt+0x30c>
  8008d4:	83 fb 1f             	cmp    $0x1f,%ebx
  8008d7:	7e 05                	jle    8008de <vprintfmt+0x2f8>
  8008d9:	83 fb 7e             	cmp    $0x7e,%ebx
  8008dc:	7e 14                	jle    8008f2 <vprintfmt+0x30c>
					putch('?', putdat);
  8008de:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008e2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008e6:	48 89 d6             	mov    %rdx,%rsi
  8008e9:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8008ee:	ff d0                	callq  *%rax
  8008f0:	eb 0f                	jmp    800901 <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  8008f2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008f6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008fa:	48 89 d6             	mov    %rdx,%rsi
  8008fd:	89 df                	mov    %ebx,%edi
  8008ff:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800901:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800905:	4c 89 e0             	mov    %r12,%rax
  800908:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80090c:	0f b6 00             	movzbl (%rax),%eax
  80090f:	0f be d8             	movsbl %al,%ebx
  800912:	85 db                	test   %ebx,%ebx
  800914:	74 10                	je     800926 <vprintfmt+0x340>
  800916:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80091a:	78 b2                	js     8008ce <vprintfmt+0x2e8>
  80091c:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800920:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800924:	79 a8                	jns    8008ce <vprintfmt+0x2e8>
			for (; width > 0; width--)
  800926:	eb 16                	jmp    80093e <vprintfmt+0x358>
				putch(' ', putdat);
  800928:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80092c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800930:	48 89 d6             	mov    %rdx,%rsi
  800933:	bf 20 00 00 00       	mov    $0x20,%edi
  800938:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  80093a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80093e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800942:	7f e4                	jg     800928 <vprintfmt+0x342>
			break;
  800944:	e9 a0 01 00 00       	jmpq   800ae9 <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800949:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80094d:	be 03 00 00 00       	mov    $0x3,%esi
  800952:	48 89 c7             	mov    %rax,%rdi
  800955:	48 b8 df 04 80 00 00 	movabs $0x8004df,%rax
  80095c:	00 00 00 
  80095f:	ff d0                	callq  *%rax
  800961:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800965:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800969:	48 85 c0             	test   %rax,%rax
  80096c:	79 1d                	jns    80098b <vprintfmt+0x3a5>
				putch('-', putdat);
  80096e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800972:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800976:	48 89 d6             	mov    %rdx,%rsi
  800979:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80097e:	ff d0                	callq  *%rax
				num = -(long long) num;
  800980:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800984:	48 f7 d8             	neg    %rax
  800987:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  80098b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800992:	e9 e5 00 00 00       	jmpq   800a7c <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800997:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80099b:	be 03 00 00 00       	mov    $0x3,%esi
  8009a0:	48 89 c7             	mov    %rax,%rdi
  8009a3:	48 b8 d8 03 80 00 00 	movabs $0x8003d8,%rax
  8009aa:	00 00 00 
  8009ad:	ff d0                	callq  *%rax
  8009af:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8009b3:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009ba:	e9 bd 00 00 00       	jmpq   800a7c <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009bf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009c3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009c7:	48 89 d6             	mov    %rdx,%rsi
  8009ca:	bf 58 00 00 00       	mov    $0x58,%edi
  8009cf:	ff d0                	callq  *%rax
			putch('X', putdat);
  8009d1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009d5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009d9:	48 89 d6             	mov    %rdx,%rsi
  8009dc:	bf 58 00 00 00       	mov    $0x58,%edi
  8009e1:	ff d0                	callq  *%rax
			putch('X', putdat);
  8009e3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009e7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009eb:	48 89 d6             	mov    %rdx,%rsi
  8009ee:	bf 58 00 00 00       	mov    $0x58,%edi
  8009f3:	ff d0                	callq  *%rax
			break;
  8009f5:	e9 ef 00 00 00       	jmpq   800ae9 <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  8009fa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009fe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a02:	48 89 d6             	mov    %rdx,%rsi
  800a05:	bf 30 00 00 00       	mov    $0x30,%edi
  800a0a:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a0c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a10:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a14:	48 89 d6             	mov    %rdx,%rsi
  800a17:	bf 78 00 00 00       	mov    $0x78,%edi
  800a1c:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a1e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a21:	83 f8 30             	cmp    $0x30,%eax
  800a24:	73 17                	jae    800a3d <vprintfmt+0x457>
  800a26:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a2a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a2d:	89 d2                	mov    %edx,%edx
  800a2f:	48 01 d0             	add    %rdx,%rax
  800a32:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a35:	83 c2 08             	add    $0x8,%edx
  800a38:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  800a3b:	eb 0c                	jmp    800a49 <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  800a3d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a41:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a45:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a49:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  800a4c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800a50:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800a57:	eb 23                	jmp    800a7c <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800a59:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a5d:	be 03 00 00 00       	mov    $0x3,%esi
  800a62:	48 89 c7             	mov    %rax,%rdi
  800a65:	48 b8 d8 03 80 00 00 	movabs $0x8003d8,%rax
  800a6c:	00 00 00 
  800a6f:	ff d0                	callq  *%rax
  800a71:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800a75:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a7c:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800a81:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800a84:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800a87:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a8b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a8f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a93:	45 89 c1             	mov    %r8d,%r9d
  800a96:	41 89 f8             	mov    %edi,%r8d
  800a99:	48 89 c7             	mov    %rax,%rdi
  800a9c:	48 b8 1f 03 80 00 00 	movabs $0x80031f,%rax
  800aa3:	00 00 00 
  800aa6:	ff d0                	callq  *%rax
			break;
  800aa8:	eb 3f                	jmp    800ae9 <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aaa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab2:	48 89 d6             	mov    %rdx,%rsi
  800ab5:	89 df                	mov    %ebx,%edi
  800ab7:	ff d0                	callq  *%rax
			break;
  800ab9:	eb 2e                	jmp    800ae9 <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800abb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800abf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ac3:	48 89 d6             	mov    %rdx,%rsi
  800ac6:	bf 25 00 00 00       	mov    $0x25,%edi
  800acb:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800acd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ad2:	eb 05                	jmp    800ad9 <vprintfmt+0x4f3>
  800ad4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ad9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800add:	48 83 e8 01          	sub    $0x1,%rax
  800ae1:	0f b6 00             	movzbl (%rax),%eax
  800ae4:	3c 25                	cmp    $0x25,%al
  800ae6:	75 ec                	jne    800ad4 <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  800ae8:	90                   	nop
		}
	}
  800ae9:	e9 31 fb ff ff       	jmpq   80061f <vprintfmt+0x39>
	va_end(aq);
}
  800aee:	48 83 c4 60          	add    $0x60,%rsp
  800af2:	5b                   	pop    %rbx
  800af3:	41 5c                	pop    %r12
  800af5:	5d                   	pop    %rbp
  800af6:	c3                   	retq   

0000000000800af7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800af7:	55                   	push   %rbp
  800af8:	48 89 e5             	mov    %rsp,%rbp
  800afb:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b02:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b09:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b10:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b17:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b1e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b25:	84 c0                	test   %al,%al
  800b27:	74 20                	je     800b49 <printfmt+0x52>
  800b29:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b2d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b31:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b35:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b39:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b3d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b41:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b45:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b49:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b50:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800b57:	00 00 00 
  800b5a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800b61:	00 00 00 
  800b64:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b68:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800b6f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800b76:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800b7d:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800b84:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800b8b:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800b92:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800b99:	48 89 c7             	mov    %rax,%rdi
  800b9c:	48 b8 e6 05 80 00 00 	movabs $0x8005e6,%rax
  800ba3:	00 00 00 
  800ba6:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ba8:	c9                   	leaveq 
  800ba9:	c3                   	retq   

0000000000800baa <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800baa:	55                   	push   %rbp
  800bab:	48 89 e5             	mov    %rsp,%rbp
  800bae:	48 83 ec 10          	sub    $0x10,%rsp
  800bb2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bb5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800bb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bbd:	8b 40 10             	mov    0x10(%rax),%eax
  800bc0:	8d 50 01             	lea    0x1(%rax),%edx
  800bc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bc7:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800bca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bce:	48 8b 10             	mov    (%rax),%rdx
  800bd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bd5:	48 8b 40 08          	mov    0x8(%rax),%rax
  800bd9:	48 39 c2             	cmp    %rax,%rdx
  800bdc:	73 17                	jae    800bf5 <sprintputch+0x4b>
		*b->buf++ = ch;
  800bde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800be2:	48 8b 00             	mov    (%rax),%rax
  800be5:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800be9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800bed:	48 89 0a             	mov    %rcx,(%rdx)
  800bf0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800bf3:	88 10                	mov    %dl,(%rax)
}
  800bf5:	c9                   	leaveq 
  800bf6:	c3                   	retq   

0000000000800bf7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bf7:	55                   	push   %rbp
  800bf8:	48 89 e5             	mov    %rsp,%rbp
  800bfb:	48 83 ec 50          	sub    $0x50,%rsp
  800bff:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c03:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c06:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c0a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c0e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c12:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c16:	48 8b 0a             	mov    (%rdx),%rcx
  800c19:	48 89 08             	mov    %rcx,(%rax)
  800c1c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c20:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c24:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c28:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c2c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c30:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c34:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c37:	48 98                	cltq   
  800c39:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c3d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c41:	48 01 d0             	add    %rdx,%rax
  800c44:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c48:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800c4f:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800c54:	74 06                	je     800c5c <vsnprintf+0x65>
  800c56:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800c5a:	7f 07                	jg     800c63 <vsnprintf+0x6c>
		return -E_INVAL;
  800c5c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c61:	eb 2f                	jmp    800c92 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800c63:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800c67:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800c6b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800c6f:	48 89 c6             	mov    %rax,%rsi
  800c72:	48 bf aa 0b 80 00 00 	movabs $0x800baa,%rdi
  800c79:	00 00 00 
  800c7c:	48 b8 e6 05 80 00 00 	movabs $0x8005e6,%rax
  800c83:	00 00 00 
  800c86:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800c88:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800c8c:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800c8f:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800c92:	c9                   	leaveq 
  800c93:	c3                   	retq   

0000000000800c94 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c94:	55                   	push   %rbp
  800c95:	48 89 e5             	mov    %rsp,%rbp
  800c98:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800c9f:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800ca6:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800cac:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cb3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cba:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800cc1:	84 c0                	test   %al,%al
  800cc3:	74 20                	je     800ce5 <snprintf+0x51>
  800cc5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800cc9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ccd:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800cd1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800cd5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800cd9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800cdd:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ce1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ce5:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800cec:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800cf3:	00 00 00 
  800cf6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800cfd:	00 00 00 
  800d00:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d04:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d0b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d12:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d19:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d20:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d27:	48 8b 0a             	mov    (%rdx),%rcx
  800d2a:	48 89 08             	mov    %rcx,(%rax)
  800d2d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d31:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d35:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d39:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d3d:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d44:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800d4b:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800d51:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800d58:	48 89 c7             	mov    %rax,%rdi
  800d5b:	48 b8 f7 0b 80 00 00 	movabs $0x800bf7,%rax
  800d62:	00 00 00 
  800d65:	ff d0                	callq  *%rax
  800d67:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800d6d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800d73:	c9                   	leaveq 
  800d74:	c3                   	retq   

0000000000800d75 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d75:	55                   	push   %rbp
  800d76:	48 89 e5             	mov    %rsp,%rbp
  800d79:	48 83 ec 18          	sub    $0x18,%rsp
  800d7d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800d81:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800d88:	eb 09                	jmp    800d93 <strlen+0x1e>
		n++;
  800d8a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  800d8e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800d93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d97:	0f b6 00             	movzbl (%rax),%eax
  800d9a:	84 c0                	test   %al,%al
  800d9c:	75 ec                	jne    800d8a <strlen+0x15>
	return n;
  800d9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800da1:	c9                   	leaveq 
  800da2:	c3                   	retq   

0000000000800da3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800da3:	55                   	push   %rbp
  800da4:	48 89 e5             	mov    %rsp,%rbp
  800da7:	48 83 ec 20          	sub    $0x20,%rsp
  800dab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800daf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800db3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800dba:	eb 0e                	jmp    800dca <strnlen+0x27>
		n++;
  800dbc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dc0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800dc5:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800dca:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800dcf:	74 0b                	je     800ddc <strnlen+0x39>
  800dd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dd5:	0f b6 00             	movzbl (%rax),%eax
  800dd8:	84 c0                	test   %al,%al
  800dda:	75 e0                	jne    800dbc <strnlen+0x19>
	return n;
  800ddc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ddf:	c9                   	leaveq 
  800de0:	c3                   	retq   

0000000000800de1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800de1:	55                   	push   %rbp
  800de2:	48 89 e5             	mov    %rsp,%rbp
  800de5:	48 83 ec 20          	sub    $0x20,%rsp
  800de9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ded:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800df1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800df5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800df9:	90                   	nop
  800dfa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dfe:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e02:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e06:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e0a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e0e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e12:	0f b6 12             	movzbl (%rdx),%edx
  800e15:	88 10                	mov    %dl,(%rax)
  800e17:	0f b6 00             	movzbl (%rax),%eax
  800e1a:	84 c0                	test   %al,%al
  800e1c:	75 dc                	jne    800dfa <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e22:	c9                   	leaveq 
  800e23:	c3                   	retq   

0000000000800e24 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e24:	55                   	push   %rbp
  800e25:	48 89 e5             	mov    %rsp,%rbp
  800e28:	48 83 ec 20          	sub    $0x20,%rsp
  800e2c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e30:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e38:	48 89 c7             	mov    %rax,%rdi
  800e3b:	48 b8 75 0d 80 00 00 	movabs $0x800d75,%rax
  800e42:	00 00 00 
  800e45:	ff d0                	callq  *%rax
  800e47:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e4d:	48 63 d0             	movslq %eax,%rdx
  800e50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e54:	48 01 c2             	add    %rax,%rdx
  800e57:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800e5b:	48 89 c6             	mov    %rax,%rsi
  800e5e:	48 89 d7             	mov    %rdx,%rdi
  800e61:	48 b8 e1 0d 80 00 00 	movabs $0x800de1,%rax
  800e68:	00 00 00 
  800e6b:	ff d0                	callq  *%rax
	return dst;
  800e6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800e71:	c9                   	leaveq 
  800e72:	c3                   	retq   

0000000000800e73 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e73:	55                   	push   %rbp
  800e74:	48 89 e5             	mov    %rsp,%rbp
  800e77:	48 83 ec 28          	sub    $0x28,%rsp
  800e7b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e7f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800e83:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800e87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800e8f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800e96:	00 
  800e97:	eb 2a                	jmp    800ec3 <strncpy+0x50>
		*dst++ = *src;
  800e99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ea1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ea5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ea9:	0f b6 12             	movzbl (%rdx),%edx
  800eac:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800eb2:	0f b6 00             	movzbl (%rax),%eax
  800eb5:	84 c0                	test   %al,%al
  800eb7:	74 05                	je     800ebe <strncpy+0x4b>
			src++;
  800eb9:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  800ebe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800ec3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ec7:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800ecb:	72 cc                	jb     800e99 <strncpy+0x26>
	}
	return ret;
  800ecd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800ed1:	c9                   	leaveq 
  800ed2:	c3                   	retq   

0000000000800ed3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ed3:	55                   	push   %rbp
  800ed4:	48 89 e5             	mov    %rsp,%rbp
  800ed7:	48 83 ec 28          	sub    $0x28,%rsp
  800edb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800edf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ee3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800ee7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eeb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800eef:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800ef4:	74 3d                	je     800f33 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800ef6:	eb 1d                	jmp    800f15 <strlcpy+0x42>
			*dst++ = *src++;
  800ef8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800efc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f00:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f04:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f08:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f0c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f10:	0f b6 12             	movzbl (%rdx),%edx
  800f13:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  800f15:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f1a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f1f:	74 0b                	je     800f2c <strlcpy+0x59>
  800f21:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f25:	0f b6 00             	movzbl (%rax),%eax
  800f28:	84 c0                	test   %al,%al
  800f2a:	75 cc                	jne    800ef8 <strlcpy+0x25>
		*dst = '\0';
  800f2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f30:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f33:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f3b:	48 29 c2             	sub    %rax,%rdx
  800f3e:	48 89 d0             	mov    %rdx,%rax
}
  800f41:	c9                   	leaveq 
  800f42:	c3                   	retq   

0000000000800f43 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f43:	55                   	push   %rbp
  800f44:	48 89 e5             	mov    %rsp,%rbp
  800f47:	48 83 ec 10          	sub    $0x10,%rsp
  800f4b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f4f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800f53:	eb 0a                	jmp    800f5f <strcmp+0x1c>
		p++, q++;
  800f55:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f5a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  800f5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f63:	0f b6 00             	movzbl (%rax),%eax
  800f66:	84 c0                	test   %al,%al
  800f68:	74 12                	je     800f7c <strcmp+0x39>
  800f6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f6e:	0f b6 10             	movzbl (%rax),%edx
  800f71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f75:	0f b6 00             	movzbl (%rax),%eax
  800f78:	38 c2                	cmp    %al,%dl
  800f7a:	74 d9                	je     800f55 <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f80:	0f b6 00             	movzbl (%rax),%eax
  800f83:	0f b6 d0             	movzbl %al,%edx
  800f86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f8a:	0f b6 00             	movzbl (%rax),%eax
  800f8d:	0f b6 c0             	movzbl %al,%eax
  800f90:	29 c2                	sub    %eax,%edx
  800f92:	89 d0                	mov    %edx,%eax
}
  800f94:	c9                   	leaveq 
  800f95:	c3                   	retq   

0000000000800f96 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800f96:	55                   	push   %rbp
  800f97:	48 89 e5             	mov    %rsp,%rbp
  800f9a:	48 83 ec 18          	sub    $0x18,%rsp
  800f9e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fa2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800fa6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800faa:	eb 0f                	jmp    800fbb <strncmp+0x25>
		n--, p++, q++;
  800fac:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800fb1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fb6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  800fbb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800fc0:	74 1d                	je     800fdf <strncmp+0x49>
  800fc2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fc6:	0f b6 00             	movzbl (%rax),%eax
  800fc9:	84 c0                	test   %al,%al
  800fcb:	74 12                	je     800fdf <strncmp+0x49>
  800fcd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fd1:	0f b6 10             	movzbl (%rax),%edx
  800fd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fd8:	0f b6 00             	movzbl (%rax),%eax
  800fdb:	38 c2                	cmp    %al,%dl
  800fdd:	74 cd                	je     800fac <strncmp+0x16>
	if (n == 0)
  800fdf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800fe4:	75 07                	jne    800fed <strncmp+0x57>
		return 0;
  800fe6:	b8 00 00 00 00       	mov    $0x0,%eax
  800feb:	eb 18                	jmp    801005 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ff1:	0f b6 00             	movzbl (%rax),%eax
  800ff4:	0f b6 d0             	movzbl %al,%edx
  800ff7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ffb:	0f b6 00             	movzbl (%rax),%eax
  800ffe:	0f b6 c0             	movzbl %al,%eax
  801001:	29 c2                	sub    %eax,%edx
  801003:	89 d0                	mov    %edx,%eax
}
  801005:	c9                   	leaveq 
  801006:	c3                   	retq   

0000000000801007 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801007:	55                   	push   %rbp
  801008:	48 89 e5             	mov    %rsp,%rbp
  80100b:	48 83 ec 10          	sub    $0x10,%rsp
  80100f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801013:	89 f0                	mov    %esi,%eax
  801015:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801018:	eb 17                	jmp    801031 <strchr+0x2a>
		if (*s == c)
  80101a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80101e:	0f b6 00             	movzbl (%rax),%eax
  801021:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801024:	75 06                	jne    80102c <strchr+0x25>
			return (char *) s;
  801026:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80102a:	eb 15                	jmp    801041 <strchr+0x3a>
	for (; *s; s++)
  80102c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801031:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801035:	0f b6 00             	movzbl (%rax),%eax
  801038:	84 c0                	test   %al,%al
  80103a:	75 de                	jne    80101a <strchr+0x13>
	return 0;
  80103c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801041:	c9                   	leaveq 
  801042:	c3                   	retq   

0000000000801043 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801043:	55                   	push   %rbp
  801044:	48 89 e5             	mov    %rsp,%rbp
  801047:	48 83 ec 10          	sub    $0x10,%rsp
  80104b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80104f:	89 f0                	mov    %esi,%eax
  801051:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801054:	eb 13                	jmp    801069 <strfind+0x26>
		if (*s == c)
  801056:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80105a:	0f b6 00             	movzbl (%rax),%eax
  80105d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801060:	75 02                	jne    801064 <strfind+0x21>
			break;
  801062:	eb 10                	jmp    801074 <strfind+0x31>
	for (; *s; s++)
  801064:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801069:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80106d:	0f b6 00             	movzbl (%rax),%eax
  801070:	84 c0                	test   %al,%al
  801072:	75 e2                	jne    801056 <strfind+0x13>
	return (char *) s;
  801074:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801078:	c9                   	leaveq 
  801079:	c3                   	retq   

000000000080107a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80107a:	55                   	push   %rbp
  80107b:	48 89 e5             	mov    %rsp,%rbp
  80107e:	48 83 ec 18          	sub    $0x18,%rsp
  801082:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801086:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801089:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80108d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801092:	75 06                	jne    80109a <memset+0x20>
		return v;
  801094:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801098:	eb 69                	jmp    801103 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80109a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80109e:	83 e0 03             	and    $0x3,%eax
  8010a1:	48 85 c0             	test   %rax,%rax
  8010a4:	75 48                	jne    8010ee <memset+0x74>
  8010a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010aa:	83 e0 03             	and    $0x3,%eax
  8010ad:	48 85 c0             	test   %rax,%rax
  8010b0:	75 3c                	jne    8010ee <memset+0x74>
		c &= 0xFF;
  8010b2:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010b9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010bc:	c1 e0 18             	shl    $0x18,%eax
  8010bf:	89 c2                	mov    %eax,%edx
  8010c1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010c4:	c1 e0 10             	shl    $0x10,%eax
  8010c7:	09 c2                	or     %eax,%edx
  8010c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010cc:	c1 e0 08             	shl    $0x8,%eax
  8010cf:	09 d0                	or     %edx,%eax
  8010d1:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8010d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d8:	48 c1 e8 02          	shr    $0x2,%rax
  8010dc:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  8010df:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8010e3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010e6:	48 89 d7             	mov    %rdx,%rdi
  8010e9:	fc                   	cld    
  8010ea:	f3 ab                	rep stos %eax,%es:(%rdi)
  8010ec:	eb 11                	jmp    8010ff <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8010ee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8010f2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010f5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8010f9:	48 89 d7             	mov    %rdx,%rdi
  8010fc:	fc                   	cld    
  8010fd:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8010ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801103:	c9                   	leaveq 
  801104:	c3                   	retq   

0000000000801105 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801105:	55                   	push   %rbp
  801106:	48 89 e5             	mov    %rsp,%rbp
  801109:	48 83 ec 28          	sub    $0x28,%rsp
  80110d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801111:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801115:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801119:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80111d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801121:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801125:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801129:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80112d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801131:	0f 83 88 00 00 00    	jae    8011bf <memmove+0xba>
  801137:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80113b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80113f:	48 01 d0             	add    %rdx,%rax
  801142:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801146:	76 77                	jbe    8011bf <memmove+0xba>
		s += n;
  801148:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80114c:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801150:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801154:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801158:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80115c:	83 e0 03             	and    $0x3,%eax
  80115f:	48 85 c0             	test   %rax,%rax
  801162:	75 3b                	jne    80119f <memmove+0x9a>
  801164:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801168:	83 e0 03             	and    $0x3,%eax
  80116b:	48 85 c0             	test   %rax,%rax
  80116e:	75 2f                	jne    80119f <memmove+0x9a>
  801170:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801174:	83 e0 03             	and    $0x3,%eax
  801177:	48 85 c0             	test   %rax,%rax
  80117a:	75 23                	jne    80119f <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80117c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801180:	48 83 e8 04          	sub    $0x4,%rax
  801184:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801188:	48 83 ea 04          	sub    $0x4,%rdx
  80118c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801190:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  801194:	48 89 c7             	mov    %rax,%rdi
  801197:	48 89 d6             	mov    %rdx,%rsi
  80119a:	fd                   	std    
  80119b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80119d:	eb 1d                	jmp    8011bc <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80119f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011a3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ab:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  8011af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011b3:	48 89 d7             	mov    %rdx,%rdi
  8011b6:	48 89 c1             	mov    %rax,%rcx
  8011b9:	fd                   	std    
  8011ba:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8011bc:	fc                   	cld    
  8011bd:	eb 57                	jmp    801216 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c3:	83 e0 03             	and    $0x3,%eax
  8011c6:	48 85 c0             	test   %rax,%rax
  8011c9:	75 36                	jne    801201 <memmove+0xfc>
  8011cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011cf:	83 e0 03             	and    $0x3,%eax
  8011d2:	48 85 c0             	test   %rax,%rax
  8011d5:	75 2a                	jne    801201 <memmove+0xfc>
  8011d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011db:	83 e0 03             	and    $0x3,%eax
  8011de:	48 85 c0             	test   %rax,%rax
  8011e1:	75 1e                	jne    801201 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8011e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011e7:	48 c1 e8 02          	shr    $0x2,%rax
  8011eb:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  8011ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011f6:	48 89 c7             	mov    %rax,%rdi
  8011f9:	48 89 d6             	mov    %rdx,%rsi
  8011fc:	fc                   	cld    
  8011fd:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011ff:	eb 15                	jmp    801216 <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  801201:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801205:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801209:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80120d:	48 89 c7             	mov    %rax,%rdi
  801210:	48 89 d6             	mov    %rdx,%rsi
  801213:	fc                   	cld    
  801214:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801216:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80121a:	c9                   	leaveq 
  80121b:	c3                   	retq   

000000000080121c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80121c:	55                   	push   %rbp
  80121d:	48 89 e5             	mov    %rsp,%rbp
  801220:	48 83 ec 18          	sub    $0x18,%rsp
  801224:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801228:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80122c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801230:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801234:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801238:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123c:	48 89 ce             	mov    %rcx,%rsi
  80123f:	48 89 c7             	mov    %rax,%rdi
  801242:	48 b8 05 11 80 00 00 	movabs $0x801105,%rax
  801249:	00 00 00 
  80124c:	ff d0                	callq  *%rax
}
  80124e:	c9                   	leaveq 
  80124f:	c3                   	retq   

0000000000801250 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801250:	55                   	push   %rbp
  801251:	48 89 e5             	mov    %rsp,%rbp
  801254:	48 83 ec 28          	sub    $0x28,%rsp
  801258:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80125c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801260:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801264:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801268:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80126c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801270:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801274:	eb 36                	jmp    8012ac <memcmp+0x5c>
		if (*s1 != *s2)
  801276:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127a:	0f b6 10             	movzbl (%rax),%edx
  80127d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801281:	0f b6 00             	movzbl (%rax),%eax
  801284:	38 c2                	cmp    %al,%dl
  801286:	74 1a                	je     8012a2 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801288:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128c:	0f b6 00             	movzbl (%rax),%eax
  80128f:	0f b6 d0             	movzbl %al,%edx
  801292:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801296:	0f b6 00             	movzbl (%rax),%eax
  801299:	0f b6 c0             	movzbl %al,%eax
  80129c:	29 c2                	sub    %eax,%edx
  80129e:	89 d0                	mov    %edx,%eax
  8012a0:	eb 20                	jmp    8012c2 <memcmp+0x72>
		s1++, s2++;
  8012a2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012a7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  8012ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012b0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012b4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8012b8:	48 85 c0             	test   %rax,%rax
  8012bb:	75 b9                	jne    801276 <memcmp+0x26>
	}

	return 0;
  8012bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012c2:	c9                   	leaveq 
  8012c3:	c3                   	retq   

00000000008012c4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8012c4:	55                   	push   %rbp
  8012c5:	48 89 e5             	mov    %rsp,%rbp
  8012c8:	48 83 ec 28          	sub    $0x28,%rsp
  8012cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012d0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8012d3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8012d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012df:	48 01 d0             	add    %rdx,%rax
  8012e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8012e6:	eb 15                	jmp    8012fd <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8012e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ec:	0f b6 00             	movzbl (%rax),%eax
  8012ef:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8012f2:	38 d0                	cmp    %dl,%al
  8012f4:	75 02                	jne    8012f8 <memfind+0x34>
			break;
  8012f6:	eb 0f                	jmp    801307 <memfind+0x43>
	for (; s < ends; s++)
  8012f8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801301:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801305:	72 e1                	jb     8012e8 <memfind+0x24>
	return (void *) s;
  801307:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80130b:	c9                   	leaveq 
  80130c:	c3                   	retq   

000000000080130d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80130d:	55                   	push   %rbp
  80130e:	48 89 e5             	mov    %rsp,%rbp
  801311:	48 83 ec 38          	sub    $0x38,%rsp
  801315:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801319:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80131d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801320:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801327:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80132e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80132f:	eb 05                	jmp    801336 <strtol+0x29>
		s++;
  801331:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  801336:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80133a:	0f b6 00             	movzbl (%rax),%eax
  80133d:	3c 20                	cmp    $0x20,%al
  80133f:	74 f0                	je     801331 <strtol+0x24>
  801341:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801345:	0f b6 00             	movzbl (%rax),%eax
  801348:	3c 09                	cmp    $0x9,%al
  80134a:	74 e5                	je     801331 <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  80134c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801350:	0f b6 00             	movzbl (%rax),%eax
  801353:	3c 2b                	cmp    $0x2b,%al
  801355:	75 07                	jne    80135e <strtol+0x51>
		s++;
  801357:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80135c:	eb 17                	jmp    801375 <strtol+0x68>
	else if (*s == '-')
  80135e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801362:	0f b6 00             	movzbl (%rax),%eax
  801365:	3c 2d                	cmp    $0x2d,%al
  801367:	75 0c                	jne    801375 <strtol+0x68>
		s++, neg = 1;
  801369:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80136e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801375:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801379:	74 06                	je     801381 <strtol+0x74>
  80137b:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80137f:	75 28                	jne    8013a9 <strtol+0x9c>
  801381:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801385:	0f b6 00             	movzbl (%rax),%eax
  801388:	3c 30                	cmp    $0x30,%al
  80138a:	75 1d                	jne    8013a9 <strtol+0x9c>
  80138c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801390:	48 83 c0 01          	add    $0x1,%rax
  801394:	0f b6 00             	movzbl (%rax),%eax
  801397:	3c 78                	cmp    $0x78,%al
  801399:	75 0e                	jne    8013a9 <strtol+0x9c>
		s += 2, base = 16;
  80139b:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8013a0:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013a7:	eb 2c                	jmp    8013d5 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013a9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013ad:	75 19                	jne    8013c8 <strtol+0xbb>
  8013af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b3:	0f b6 00             	movzbl (%rax),%eax
  8013b6:	3c 30                	cmp    $0x30,%al
  8013b8:	75 0e                	jne    8013c8 <strtol+0xbb>
		s++, base = 8;
  8013ba:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013bf:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8013c6:	eb 0d                	jmp    8013d5 <strtol+0xc8>
	else if (base == 0)
  8013c8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013cc:	75 07                	jne    8013d5 <strtol+0xc8>
		base = 10;
  8013ce:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d9:	0f b6 00             	movzbl (%rax),%eax
  8013dc:	3c 2f                	cmp    $0x2f,%al
  8013de:	7e 1d                	jle    8013fd <strtol+0xf0>
  8013e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e4:	0f b6 00             	movzbl (%rax),%eax
  8013e7:	3c 39                	cmp    $0x39,%al
  8013e9:	7f 12                	jg     8013fd <strtol+0xf0>
			dig = *s - '0';
  8013eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ef:	0f b6 00             	movzbl (%rax),%eax
  8013f2:	0f be c0             	movsbl %al,%eax
  8013f5:	83 e8 30             	sub    $0x30,%eax
  8013f8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8013fb:	eb 4e                	jmp    80144b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8013fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801401:	0f b6 00             	movzbl (%rax),%eax
  801404:	3c 60                	cmp    $0x60,%al
  801406:	7e 1d                	jle    801425 <strtol+0x118>
  801408:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140c:	0f b6 00             	movzbl (%rax),%eax
  80140f:	3c 7a                	cmp    $0x7a,%al
  801411:	7f 12                	jg     801425 <strtol+0x118>
			dig = *s - 'a' + 10;
  801413:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801417:	0f b6 00             	movzbl (%rax),%eax
  80141a:	0f be c0             	movsbl %al,%eax
  80141d:	83 e8 57             	sub    $0x57,%eax
  801420:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801423:	eb 26                	jmp    80144b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801425:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801429:	0f b6 00             	movzbl (%rax),%eax
  80142c:	3c 40                	cmp    $0x40,%al
  80142e:	7e 48                	jle    801478 <strtol+0x16b>
  801430:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801434:	0f b6 00             	movzbl (%rax),%eax
  801437:	3c 5a                	cmp    $0x5a,%al
  801439:	7f 3d                	jg     801478 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80143b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143f:	0f b6 00             	movzbl (%rax),%eax
  801442:	0f be c0             	movsbl %al,%eax
  801445:	83 e8 37             	sub    $0x37,%eax
  801448:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80144b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80144e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801451:	7c 02                	jl     801455 <strtol+0x148>
			break;
  801453:	eb 23                	jmp    801478 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801455:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80145a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80145d:	48 98                	cltq   
  80145f:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801464:	48 89 c2             	mov    %rax,%rdx
  801467:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80146a:	48 98                	cltq   
  80146c:	48 01 d0             	add    %rdx,%rax
  80146f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801473:	e9 5d ff ff ff       	jmpq   8013d5 <strtol+0xc8>

	if (endptr)
  801478:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80147d:	74 0b                	je     80148a <strtol+0x17d>
		*endptr = (char *) s;
  80147f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801483:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801487:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80148a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80148e:	74 09                	je     801499 <strtol+0x18c>
  801490:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801494:	48 f7 d8             	neg    %rax
  801497:	eb 04                	jmp    80149d <strtol+0x190>
  801499:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80149d:	c9                   	leaveq 
  80149e:	c3                   	retq   

000000000080149f <strstr>:

char * strstr(const char *in, const char *str)
{
  80149f:	55                   	push   %rbp
  8014a0:	48 89 e5             	mov    %rsp,%rbp
  8014a3:	48 83 ec 30          	sub    $0x30,%rsp
  8014a7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014ab:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8014af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014b3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014b7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8014bb:	0f b6 00             	movzbl (%rax),%eax
  8014be:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8014c1:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8014c5:	75 06                	jne    8014cd <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8014c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014cb:	eb 6b                	jmp    801538 <strstr+0x99>

	len = strlen(str);
  8014cd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014d1:	48 89 c7             	mov    %rax,%rdi
  8014d4:	48 b8 75 0d 80 00 00 	movabs $0x800d75,%rax
  8014db:	00 00 00 
  8014de:	ff d0                	callq  *%rax
  8014e0:	48 98                	cltq   
  8014e2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8014e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ea:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014ee:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8014f2:	0f b6 00             	movzbl (%rax),%eax
  8014f5:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8014f8:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8014fc:	75 07                	jne    801505 <strstr+0x66>
				return (char *) 0;
  8014fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801503:	eb 33                	jmp    801538 <strstr+0x99>
		} while (sc != c);
  801505:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801509:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80150c:	75 d8                	jne    8014e6 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80150e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801512:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801516:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151a:	48 89 ce             	mov    %rcx,%rsi
  80151d:	48 89 c7             	mov    %rax,%rdi
  801520:	48 b8 96 0f 80 00 00 	movabs $0x800f96,%rax
  801527:	00 00 00 
  80152a:	ff d0                	callq  *%rax
  80152c:	85 c0                	test   %eax,%eax
  80152e:	75 b6                	jne    8014e6 <strstr+0x47>

	return (char *) (in - 1);
  801530:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801534:	48 83 e8 01          	sub    $0x1,%rax
}
  801538:	c9                   	leaveq 
  801539:	c3                   	retq   

000000000080153a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80153a:	55                   	push   %rbp
  80153b:	48 89 e5             	mov    %rsp,%rbp
  80153e:	53                   	push   %rbx
  80153f:	48 83 ec 48          	sub    $0x48,%rsp
  801543:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801546:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801549:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80154d:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801551:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801555:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801559:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80155c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801560:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801564:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801568:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80156c:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801570:	4c 89 c3             	mov    %r8,%rbx
  801573:	cd 30                	int    $0x30
  801575:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801579:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80157d:	74 3e                	je     8015bd <syscall+0x83>
  80157f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801584:	7e 37                	jle    8015bd <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801586:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80158a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80158d:	49 89 d0             	mov    %rdx,%r8
  801590:	89 c1                	mov    %eax,%ecx
  801592:	48 ba 08 42 80 00 00 	movabs $0x804208,%rdx
  801599:	00 00 00 
  80159c:	be 23 00 00 00       	mov    $0x23,%esi
  8015a1:	48 bf 25 42 80 00 00 	movabs $0x804225,%rdi
  8015a8:	00 00 00 
  8015ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b0:	49 b9 1e 39 80 00 00 	movabs $0x80391e,%r9
  8015b7:	00 00 00 
  8015ba:	41 ff d1             	callq  *%r9

	return ret;
  8015bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015c1:	48 83 c4 48          	add    $0x48,%rsp
  8015c5:	5b                   	pop    %rbx
  8015c6:	5d                   	pop    %rbp
  8015c7:	c3                   	retq   

00000000008015c8 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8015c8:	55                   	push   %rbp
  8015c9:	48 89 e5             	mov    %rsp,%rbp
  8015cc:	48 83 ec 10          	sub    $0x10,%rsp
  8015d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015d4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8015d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015e0:	48 83 ec 08          	sub    $0x8,%rsp
  8015e4:	6a 00                	pushq  $0x0
  8015e6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8015ec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8015f2:	48 89 d1             	mov    %rdx,%rcx
  8015f5:	48 89 c2             	mov    %rax,%rdx
  8015f8:	be 00 00 00 00       	mov    $0x0,%esi
  8015fd:	bf 00 00 00 00       	mov    $0x0,%edi
  801602:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  801609:	00 00 00 
  80160c:	ff d0                	callq  *%rax
  80160e:	48 83 c4 10          	add    $0x10,%rsp
}
  801612:	c9                   	leaveq 
  801613:	c3                   	retq   

0000000000801614 <sys_cgetc>:

int
sys_cgetc(void)
{
  801614:	55                   	push   %rbp
  801615:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801618:	48 83 ec 08          	sub    $0x8,%rsp
  80161c:	6a 00                	pushq  $0x0
  80161e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801624:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80162a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80162f:	ba 00 00 00 00       	mov    $0x0,%edx
  801634:	be 00 00 00 00       	mov    $0x0,%esi
  801639:	bf 01 00 00 00       	mov    $0x1,%edi
  80163e:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  801645:	00 00 00 
  801648:	ff d0                	callq  *%rax
  80164a:	48 83 c4 10          	add    $0x10,%rsp
}
  80164e:	c9                   	leaveq 
  80164f:	c3                   	retq   

0000000000801650 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801650:	55                   	push   %rbp
  801651:	48 89 e5             	mov    %rsp,%rbp
  801654:	48 83 ec 10          	sub    $0x10,%rsp
  801658:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80165b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80165e:	48 98                	cltq   
  801660:	48 83 ec 08          	sub    $0x8,%rsp
  801664:	6a 00                	pushq  $0x0
  801666:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80166c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801672:	b9 00 00 00 00       	mov    $0x0,%ecx
  801677:	48 89 c2             	mov    %rax,%rdx
  80167a:	be 01 00 00 00       	mov    $0x1,%esi
  80167f:	bf 03 00 00 00       	mov    $0x3,%edi
  801684:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  80168b:	00 00 00 
  80168e:	ff d0                	callq  *%rax
  801690:	48 83 c4 10          	add    $0x10,%rsp
}
  801694:	c9                   	leaveq 
  801695:	c3                   	retq   

0000000000801696 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801696:	55                   	push   %rbp
  801697:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80169a:	48 83 ec 08          	sub    $0x8,%rsp
  80169e:	6a 00                	pushq  $0x0
  8016a0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016a6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b6:	be 00 00 00 00       	mov    $0x0,%esi
  8016bb:	bf 02 00 00 00       	mov    $0x2,%edi
  8016c0:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  8016c7:	00 00 00 
  8016ca:	ff d0                	callq  *%rax
  8016cc:	48 83 c4 10          	add    $0x10,%rsp
}
  8016d0:	c9                   	leaveq 
  8016d1:	c3                   	retq   

00000000008016d2 <sys_yield>:

void
sys_yield(void)
{
  8016d2:	55                   	push   %rbp
  8016d3:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8016d6:	48 83 ec 08          	sub    $0x8,%rsp
  8016da:	6a 00                	pushq  $0x0
  8016dc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016e2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f2:	be 00 00 00 00       	mov    $0x0,%esi
  8016f7:	bf 0b 00 00 00       	mov    $0xb,%edi
  8016fc:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  801703:	00 00 00 
  801706:	ff d0                	callq  *%rax
  801708:	48 83 c4 10          	add    $0x10,%rsp
}
  80170c:	c9                   	leaveq 
  80170d:	c3                   	retq   

000000000080170e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80170e:	55                   	push   %rbp
  80170f:	48 89 e5             	mov    %rsp,%rbp
  801712:	48 83 ec 10          	sub    $0x10,%rsp
  801716:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801719:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80171d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801720:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801723:	48 63 c8             	movslq %eax,%rcx
  801726:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80172a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80172d:	48 98                	cltq   
  80172f:	48 83 ec 08          	sub    $0x8,%rsp
  801733:	6a 00                	pushq  $0x0
  801735:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80173b:	49 89 c8             	mov    %rcx,%r8
  80173e:	48 89 d1             	mov    %rdx,%rcx
  801741:	48 89 c2             	mov    %rax,%rdx
  801744:	be 01 00 00 00       	mov    $0x1,%esi
  801749:	bf 04 00 00 00       	mov    $0x4,%edi
  80174e:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  801755:	00 00 00 
  801758:	ff d0                	callq  *%rax
  80175a:	48 83 c4 10          	add    $0x10,%rsp
}
  80175e:	c9                   	leaveq 
  80175f:	c3                   	retq   

0000000000801760 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801760:	55                   	push   %rbp
  801761:	48 89 e5             	mov    %rsp,%rbp
  801764:	48 83 ec 20          	sub    $0x20,%rsp
  801768:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80176b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80176f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801772:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801776:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80177a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80177d:	48 63 c8             	movslq %eax,%rcx
  801780:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801784:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801787:	48 63 f0             	movslq %eax,%rsi
  80178a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80178e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801791:	48 98                	cltq   
  801793:	48 83 ec 08          	sub    $0x8,%rsp
  801797:	51                   	push   %rcx
  801798:	49 89 f9             	mov    %rdi,%r9
  80179b:	49 89 f0             	mov    %rsi,%r8
  80179e:	48 89 d1             	mov    %rdx,%rcx
  8017a1:	48 89 c2             	mov    %rax,%rdx
  8017a4:	be 01 00 00 00       	mov    $0x1,%esi
  8017a9:	bf 05 00 00 00       	mov    $0x5,%edi
  8017ae:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  8017b5:	00 00 00 
  8017b8:	ff d0                	callq  *%rax
  8017ba:	48 83 c4 10          	add    $0x10,%rsp
}
  8017be:	c9                   	leaveq 
  8017bf:	c3                   	retq   

00000000008017c0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8017c0:	55                   	push   %rbp
  8017c1:	48 89 e5             	mov    %rsp,%rbp
  8017c4:	48 83 ec 10          	sub    $0x10,%rsp
  8017c8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017cb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8017cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017d6:	48 98                	cltq   
  8017d8:	48 83 ec 08          	sub    $0x8,%rsp
  8017dc:	6a 00                	pushq  $0x0
  8017de:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017e4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017ea:	48 89 d1             	mov    %rdx,%rcx
  8017ed:	48 89 c2             	mov    %rax,%rdx
  8017f0:	be 01 00 00 00       	mov    $0x1,%esi
  8017f5:	bf 06 00 00 00       	mov    $0x6,%edi
  8017fa:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  801801:	00 00 00 
  801804:	ff d0                	callq  *%rax
  801806:	48 83 c4 10          	add    $0x10,%rsp
}
  80180a:	c9                   	leaveq 
  80180b:	c3                   	retq   

000000000080180c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80180c:	55                   	push   %rbp
  80180d:	48 89 e5             	mov    %rsp,%rbp
  801810:	48 83 ec 10          	sub    $0x10,%rsp
  801814:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801817:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80181a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80181d:	48 63 d0             	movslq %eax,%rdx
  801820:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801823:	48 98                	cltq   
  801825:	48 83 ec 08          	sub    $0x8,%rsp
  801829:	6a 00                	pushq  $0x0
  80182b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801831:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801837:	48 89 d1             	mov    %rdx,%rcx
  80183a:	48 89 c2             	mov    %rax,%rdx
  80183d:	be 01 00 00 00       	mov    $0x1,%esi
  801842:	bf 08 00 00 00       	mov    $0x8,%edi
  801847:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  80184e:	00 00 00 
  801851:	ff d0                	callq  *%rax
  801853:	48 83 c4 10          	add    $0x10,%rsp
}
  801857:	c9                   	leaveq 
  801858:	c3                   	retq   

0000000000801859 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801859:	55                   	push   %rbp
  80185a:	48 89 e5             	mov    %rsp,%rbp
  80185d:	48 83 ec 10          	sub    $0x10,%rsp
  801861:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801864:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801868:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80186c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80186f:	48 98                	cltq   
  801871:	48 83 ec 08          	sub    $0x8,%rsp
  801875:	6a 00                	pushq  $0x0
  801877:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80187d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801883:	48 89 d1             	mov    %rdx,%rcx
  801886:	48 89 c2             	mov    %rax,%rdx
  801889:	be 01 00 00 00       	mov    $0x1,%esi
  80188e:	bf 09 00 00 00       	mov    $0x9,%edi
  801893:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  80189a:	00 00 00 
  80189d:	ff d0                	callq  *%rax
  80189f:	48 83 c4 10          	add    $0x10,%rsp
}
  8018a3:	c9                   	leaveq 
  8018a4:	c3                   	retq   

00000000008018a5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8018a5:	55                   	push   %rbp
  8018a6:	48 89 e5             	mov    %rsp,%rbp
  8018a9:	48 83 ec 10          	sub    $0x10,%rsp
  8018ad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018b0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8018b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018bb:	48 98                	cltq   
  8018bd:	48 83 ec 08          	sub    $0x8,%rsp
  8018c1:	6a 00                	pushq  $0x0
  8018c3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018cf:	48 89 d1             	mov    %rdx,%rcx
  8018d2:	48 89 c2             	mov    %rax,%rdx
  8018d5:	be 01 00 00 00       	mov    $0x1,%esi
  8018da:	bf 0a 00 00 00       	mov    $0xa,%edi
  8018df:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  8018e6:	00 00 00 
  8018e9:	ff d0                	callq  *%rax
  8018eb:	48 83 c4 10          	add    $0x10,%rsp
}
  8018ef:	c9                   	leaveq 
  8018f0:	c3                   	retq   

00000000008018f1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8018f1:	55                   	push   %rbp
  8018f2:	48 89 e5             	mov    %rsp,%rbp
  8018f5:	48 83 ec 20          	sub    $0x20,%rsp
  8018f9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018fc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801900:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801904:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801907:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80190a:	48 63 f0             	movslq %eax,%rsi
  80190d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801911:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801914:	48 98                	cltq   
  801916:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80191a:	48 83 ec 08          	sub    $0x8,%rsp
  80191e:	6a 00                	pushq  $0x0
  801920:	49 89 f1             	mov    %rsi,%r9
  801923:	49 89 c8             	mov    %rcx,%r8
  801926:	48 89 d1             	mov    %rdx,%rcx
  801929:	48 89 c2             	mov    %rax,%rdx
  80192c:	be 00 00 00 00       	mov    $0x0,%esi
  801931:	bf 0c 00 00 00       	mov    $0xc,%edi
  801936:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  80193d:	00 00 00 
  801940:	ff d0                	callq  *%rax
  801942:	48 83 c4 10          	add    $0x10,%rsp
}
  801946:	c9                   	leaveq 
  801947:	c3                   	retq   

0000000000801948 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801948:	55                   	push   %rbp
  801949:	48 89 e5             	mov    %rsp,%rbp
  80194c:	48 83 ec 10          	sub    $0x10,%rsp
  801950:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801954:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801958:	48 83 ec 08          	sub    $0x8,%rsp
  80195c:	6a 00                	pushq  $0x0
  80195e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801964:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80196a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80196f:	48 89 c2             	mov    %rax,%rdx
  801972:	be 01 00 00 00       	mov    $0x1,%esi
  801977:	bf 0d 00 00 00       	mov    $0xd,%edi
  80197c:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  801983:	00 00 00 
  801986:	ff d0                	callq  *%rax
  801988:	48 83 c4 10          	add    $0x10,%rsp
}
  80198c:	c9                   	leaveq 
  80198d:	c3                   	retq   

000000000080198e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80198e:	55                   	push   %rbp
  80198f:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801992:	48 83 ec 08          	sub    $0x8,%rsp
  801996:	6a 00                	pushq  $0x0
  801998:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80199e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ae:	be 00 00 00 00       	mov    $0x0,%esi
  8019b3:	bf 0e 00 00 00       	mov    $0xe,%edi
  8019b8:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  8019bf:	00 00 00 
  8019c2:	ff d0                	callq  *%rax
  8019c4:	48 83 c4 10          	add    $0x10,%rsp
}
  8019c8:	c9                   	leaveq 
  8019c9:	c3                   	retq   

00000000008019ca <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  8019ca:	55                   	push   %rbp
  8019cb:	48 89 e5             	mov    %rsp,%rbp
  8019ce:	48 83 ec 20          	sub    $0x20,%rsp
  8019d2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019d5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019d9:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019dc:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019e0:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  8019e4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019e7:	48 63 c8             	movslq %eax,%rcx
  8019ea:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019f1:	48 63 f0             	movslq %eax,%rsi
  8019f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019fb:	48 98                	cltq   
  8019fd:	48 83 ec 08          	sub    $0x8,%rsp
  801a01:	51                   	push   %rcx
  801a02:	49 89 f9             	mov    %rdi,%r9
  801a05:	49 89 f0             	mov    %rsi,%r8
  801a08:	48 89 d1             	mov    %rdx,%rcx
  801a0b:	48 89 c2             	mov    %rax,%rdx
  801a0e:	be 00 00 00 00       	mov    $0x0,%esi
  801a13:	bf 0f 00 00 00       	mov    $0xf,%edi
  801a18:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  801a1f:	00 00 00 
  801a22:	ff d0                	callq  *%rax
  801a24:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801a28:	c9                   	leaveq 
  801a29:	c3                   	retq   

0000000000801a2a <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801a2a:	55                   	push   %rbp
  801a2b:	48 89 e5             	mov    %rsp,%rbp
  801a2e:	48 83 ec 10          	sub    $0x10,%rsp
  801a32:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a36:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801a3a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a42:	48 83 ec 08          	sub    $0x8,%rsp
  801a46:	6a 00                	pushq  $0x0
  801a48:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a4e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a54:	48 89 d1             	mov    %rdx,%rcx
  801a57:	48 89 c2             	mov    %rax,%rdx
  801a5a:	be 00 00 00 00       	mov    $0x0,%esi
  801a5f:	bf 10 00 00 00       	mov    $0x10,%edi
  801a64:	48 b8 3a 15 80 00 00 	movabs $0x80153a,%rax
  801a6b:	00 00 00 
  801a6e:	ff d0                	callq  *%rax
  801a70:	48 83 c4 10          	add    $0x10,%rsp
}
  801a74:	c9                   	leaveq 
  801a75:	c3                   	retq   

0000000000801a76 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801a76:	55                   	push   %rbp
  801a77:	48 89 e5             	mov    %rsp,%rbp
  801a7a:	48 83 ec 08          	sub    $0x8,%rsp
  801a7e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801a82:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a86:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801a8d:	ff ff ff 
  801a90:	48 01 d0             	add    %rdx,%rax
  801a93:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801a97:	c9                   	leaveq 
  801a98:	c3                   	retq   

0000000000801a99 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801a99:	55                   	push   %rbp
  801a9a:	48 89 e5             	mov    %rsp,%rbp
  801a9d:	48 83 ec 08          	sub    $0x8,%rsp
  801aa1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801aa5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aa9:	48 89 c7             	mov    %rax,%rdi
  801aac:	48 b8 76 1a 80 00 00 	movabs $0x801a76,%rax
  801ab3:	00 00 00 
  801ab6:	ff d0                	callq  *%rax
  801ab8:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801abe:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ac2:	c9                   	leaveq 
  801ac3:	c3                   	retq   

0000000000801ac4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ac4:	55                   	push   %rbp
  801ac5:	48 89 e5             	mov    %rsp,%rbp
  801ac8:	48 83 ec 18          	sub    $0x18,%rsp
  801acc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ad0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ad7:	eb 6b                	jmp    801b44 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801ad9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801adc:	48 98                	cltq   
  801ade:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ae4:	48 c1 e0 0c          	shl    $0xc,%rax
  801ae8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801aec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801af0:	48 c1 e8 15          	shr    $0x15,%rax
  801af4:	48 89 c2             	mov    %rax,%rdx
  801af7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801afe:	01 00 00 
  801b01:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b05:	83 e0 01             	and    $0x1,%eax
  801b08:	48 85 c0             	test   %rax,%rax
  801b0b:	74 21                	je     801b2e <fd_alloc+0x6a>
  801b0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b11:	48 c1 e8 0c          	shr    $0xc,%rax
  801b15:	48 89 c2             	mov    %rax,%rdx
  801b18:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801b1f:	01 00 00 
  801b22:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b26:	83 e0 01             	and    $0x1,%eax
  801b29:	48 85 c0             	test   %rax,%rax
  801b2c:	75 12                	jne    801b40 <fd_alloc+0x7c>
			*fd_store = fd;
  801b2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b32:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b36:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801b39:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3e:	eb 1a                	jmp    801b5a <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  801b40:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801b44:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801b48:	7e 8f                	jle    801ad9 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  801b4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b4e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801b55:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801b5a:	c9                   	leaveq 
  801b5b:	c3                   	retq   

0000000000801b5c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801b5c:	55                   	push   %rbp
  801b5d:	48 89 e5             	mov    %rsp,%rbp
  801b60:	48 83 ec 20          	sub    $0x20,%rsp
  801b64:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801b67:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801b6b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801b6f:	78 06                	js     801b77 <fd_lookup+0x1b>
  801b71:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801b75:	7e 07                	jle    801b7e <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801b77:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b7c:	eb 6c                	jmp    801bea <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801b7e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b81:	48 98                	cltq   
  801b83:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801b89:	48 c1 e0 0c          	shl    $0xc,%rax
  801b8d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801b91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b95:	48 c1 e8 15          	shr    $0x15,%rax
  801b99:	48 89 c2             	mov    %rax,%rdx
  801b9c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ba3:	01 00 00 
  801ba6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801baa:	83 e0 01             	and    $0x1,%eax
  801bad:	48 85 c0             	test   %rax,%rax
  801bb0:	74 21                	je     801bd3 <fd_lookup+0x77>
  801bb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bb6:	48 c1 e8 0c          	shr    $0xc,%rax
  801bba:	48 89 c2             	mov    %rax,%rdx
  801bbd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801bc4:	01 00 00 
  801bc7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bcb:	83 e0 01             	and    $0x1,%eax
  801bce:	48 85 c0             	test   %rax,%rax
  801bd1:	75 07                	jne    801bda <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801bd3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bd8:	eb 10                	jmp    801bea <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801bda:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bde:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801be2:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801be5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bea:	c9                   	leaveq 
  801beb:	c3                   	retq   

0000000000801bec <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801bec:	55                   	push   %rbp
  801bed:	48 89 e5             	mov    %rsp,%rbp
  801bf0:	48 83 ec 30          	sub    $0x30,%rsp
  801bf4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801bf8:	89 f0                	mov    %esi,%eax
  801bfa:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801bfd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c01:	48 89 c7             	mov    %rax,%rdi
  801c04:	48 b8 76 1a 80 00 00 	movabs $0x801a76,%rax
  801c0b:	00 00 00 
  801c0e:	ff d0                	callq  *%rax
  801c10:	89 c2                	mov    %eax,%edx
  801c12:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801c16:	48 89 c6             	mov    %rax,%rsi
  801c19:	89 d7                	mov    %edx,%edi
  801c1b:	48 b8 5c 1b 80 00 00 	movabs $0x801b5c,%rax
  801c22:	00 00 00 
  801c25:	ff d0                	callq  *%rax
  801c27:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c2e:	78 0a                	js     801c3a <fd_close+0x4e>
	    || fd != fd2)
  801c30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c34:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801c38:	74 12                	je     801c4c <fd_close+0x60>
		return (must_exist ? r : 0);
  801c3a:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801c3e:	74 05                	je     801c45 <fd_close+0x59>
  801c40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c43:	eb 70                	jmp    801cb5 <fd_close+0xc9>
  801c45:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4a:	eb 69                	jmp    801cb5 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801c4c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c50:	8b 00                	mov    (%rax),%eax
  801c52:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801c56:	48 89 d6             	mov    %rdx,%rsi
  801c59:	89 c7                	mov    %eax,%edi
  801c5b:	48 b8 b7 1c 80 00 00 	movabs $0x801cb7,%rax
  801c62:	00 00 00 
  801c65:	ff d0                	callq  *%rax
  801c67:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c6e:	78 2a                	js     801c9a <fd_close+0xae>
		if (dev->dev_close)
  801c70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c74:	48 8b 40 20          	mov    0x20(%rax),%rax
  801c78:	48 85 c0             	test   %rax,%rax
  801c7b:	74 16                	je     801c93 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  801c7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c81:	48 8b 40 20          	mov    0x20(%rax),%rax
  801c85:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801c89:	48 89 d7             	mov    %rdx,%rdi
  801c8c:	ff d0                	callq  *%rax
  801c8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c91:	eb 07                	jmp    801c9a <fd_close+0xae>
		else
			r = 0;
  801c93:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801c9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c9e:	48 89 c6             	mov    %rax,%rsi
  801ca1:	bf 00 00 00 00       	mov    $0x0,%edi
  801ca6:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  801cad:	00 00 00 
  801cb0:	ff d0                	callq  *%rax
	return r;
  801cb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801cb5:	c9                   	leaveq 
  801cb6:	c3                   	retq   

0000000000801cb7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801cb7:	55                   	push   %rbp
  801cb8:	48 89 e5             	mov    %rsp,%rbp
  801cbb:	48 83 ec 20          	sub    $0x20,%rsp
  801cbf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801cc2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801cc6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ccd:	eb 41                	jmp    801d10 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801ccf:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801cd6:	00 00 00 
  801cd9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801cdc:	48 63 d2             	movslq %edx,%rdx
  801cdf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ce3:	8b 00                	mov    (%rax),%eax
  801ce5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801ce8:	75 22                	jne    801d0c <dev_lookup+0x55>
			*dev = devtab[i];
  801cea:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801cf1:	00 00 00 
  801cf4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801cf7:	48 63 d2             	movslq %edx,%rdx
  801cfa:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801cfe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d02:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801d05:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0a:	eb 60                	jmp    801d6c <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  801d0c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d10:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801d17:	00 00 00 
  801d1a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d1d:	48 63 d2             	movslq %edx,%rdx
  801d20:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d24:	48 85 c0             	test   %rax,%rax
  801d27:	75 a6                	jne    801ccf <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801d29:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801d30:	00 00 00 
  801d33:	48 8b 00             	mov    (%rax),%rax
  801d36:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801d3c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d3f:	89 c6                	mov    %eax,%esi
  801d41:	48 bf 38 42 80 00 00 	movabs $0x804238,%rdi
  801d48:	00 00 00 
  801d4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d50:	48 b9 47 02 80 00 00 	movabs $0x800247,%rcx
  801d57:	00 00 00 
  801d5a:	ff d1                	callq  *%rcx
	*dev = 0;
  801d5c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d60:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801d67:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801d6c:	c9                   	leaveq 
  801d6d:	c3                   	retq   

0000000000801d6e <close>:

int
close(int fdnum)
{
  801d6e:	55                   	push   %rbp
  801d6f:	48 89 e5             	mov    %rsp,%rbp
  801d72:	48 83 ec 20          	sub    $0x20,%rsp
  801d76:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d79:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801d7d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d80:	48 89 d6             	mov    %rdx,%rsi
  801d83:	89 c7                	mov    %eax,%edi
  801d85:	48 b8 5c 1b 80 00 00 	movabs $0x801b5c,%rax
  801d8c:	00 00 00 
  801d8f:	ff d0                	callq  *%rax
  801d91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d98:	79 05                	jns    801d9f <close+0x31>
		return r;
  801d9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d9d:	eb 18                	jmp    801db7 <close+0x49>
	else
		return fd_close(fd, 1);
  801d9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801da3:	be 01 00 00 00       	mov    $0x1,%esi
  801da8:	48 89 c7             	mov    %rax,%rdi
  801dab:	48 b8 ec 1b 80 00 00 	movabs $0x801bec,%rax
  801db2:	00 00 00 
  801db5:	ff d0                	callq  *%rax
}
  801db7:	c9                   	leaveq 
  801db8:	c3                   	retq   

0000000000801db9 <close_all>:

void
close_all(void)
{
  801db9:	55                   	push   %rbp
  801dba:	48 89 e5             	mov    %rsp,%rbp
  801dbd:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801dc1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801dc8:	eb 15                	jmp    801ddf <close_all+0x26>
		close(i);
  801dca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dcd:	89 c7                	mov    %eax,%edi
  801dcf:	48 b8 6e 1d 80 00 00 	movabs $0x801d6e,%rax
  801dd6:	00 00 00 
  801dd9:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  801ddb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ddf:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801de3:	7e e5                	jle    801dca <close_all+0x11>
}
  801de5:	c9                   	leaveq 
  801de6:	c3                   	retq   

0000000000801de7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801de7:	55                   	push   %rbp
  801de8:	48 89 e5             	mov    %rsp,%rbp
  801deb:	48 83 ec 40          	sub    $0x40,%rsp
  801def:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801df2:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801df5:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801df9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801dfc:	48 89 d6             	mov    %rdx,%rsi
  801dff:	89 c7                	mov    %eax,%edi
  801e01:	48 b8 5c 1b 80 00 00 	movabs $0x801b5c,%rax
  801e08:	00 00 00 
  801e0b:	ff d0                	callq  *%rax
  801e0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e14:	79 08                	jns    801e1e <dup+0x37>
		return r;
  801e16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e19:	e9 70 01 00 00       	jmpq   801f8e <dup+0x1a7>
	close(newfdnum);
  801e1e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801e21:	89 c7                	mov    %eax,%edi
  801e23:	48 b8 6e 1d 80 00 00 	movabs $0x801d6e,%rax
  801e2a:	00 00 00 
  801e2d:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801e2f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801e32:	48 98                	cltq   
  801e34:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e3a:	48 c1 e0 0c          	shl    $0xc,%rax
  801e3e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801e42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e46:	48 89 c7             	mov    %rax,%rdi
  801e49:	48 b8 99 1a 80 00 00 	movabs $0x801a99,%rax
  801e50:	00 00 00 
  801e53:	ff d0                	callq  *%rax
  801e55:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801e59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e5d:	48 89 c7             	mov    %rax,%rdi
  801e60:	48 b8 99 1a 80 00 00 	movabs $0x801a99,%rax
  801e67:	00 00 00 
  801e6a:	ff d0                	callq  *%rax
  801e6c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801e70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e74:	48 c1 e8 15          	shr    $0x15,%rax
  801e78:	48 89 c2             	mov    %rax,%rdx
  801e7b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e82:	01 00 00 
  801e85:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e89:	83 e0 01             	and    $0x1,%eax
  801e8c:	48 85 c0             	test   %rax,%rax
  801e8f:	74 73                	je     801f04 <dup+0x11d>
  801e91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e95:	48 c1 e8 0c          	shr    $0xc,%rax
  801e99:	48 89 c2             	mov    %rax,%rdx
  801e9c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ea3:	01 00 00 
  801ea6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eaa:	83 e0 01             	and    $0x1,%eax
  801ead:	48 85 c0             	test   %rax,%rax
  801eb0:	74 52                	je     801f04 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801eb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eb6:	48 c1 e8 0c          	shr    $0xc,%rax
  801eba:	48 89 c2             	mov    %rax,%rdx
  801ebd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ec4:	01 00 00 
  801ec7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ecb:	25 07 0e 00 00       	and    $0xe07,%eax
  801ed0:	89 c1                	mov    %eax,%ecx
  801ed2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801ed6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eda:	41 89 c8             	mov    %ecx,%r8d
  801edd:	48 89 d1             	mov    %rdx,%rcx
  801ee0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ee5:	48 89 c6             	mov    %rax,%rsi
  801ee8:	bf 00 00 00 00       	mov    $0x0,%edi
  801eed:	48 b8 60 17 80 00 00 	movabs $0x801760,%rax
  801ef4:	00 00 00 
  801ef7:	ff d0                	callq  *%rax
  801ef9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801efc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f00:	79 02                	jns    801f04 <dup+0x11d>
			goto err;
  801f02:	eb 57                	jmp    801f5b <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801f04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f08:	48 c1 e8 0c          	shr    $0xc,%rax
  801f0c:	48 89 c2             	mov    %rax,%rdx
  801f0f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f16:	01 00 00 
  801f19:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f1d:	25 07 0e 00 00       	and    $0xe07,%eax
  801f22:	89 c1                	mov    %eax,%ecx
  801f24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f28:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f2c:	41 89 c8             	mov    %ecx,%r8d
  801f2f:	48 89 d1             	mov    %rdx,%rcx
  801f32:	ba 00 00 00 00       	mov    $0x0,%edx
  801f37:	48 89 c6             	mov    %rax,%rsi
  801f3a:	bf 00 00 00 00       	mov    $0x0,%edi
  801f3f:	48 b8 60 17 80 00 00 	movabs $0x801760,%rax
  801f46:	00 00 00 
  801f49:	ff d0                	callq  *%rax
  801f4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f52:	79 02                	jns    801f56 <dup+0x16f>
		goto err;
  801f54:	eb 05                	jmp    801f5b <dup+0x174>

	return newfdnum;
  801f56:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801f59:	eb 33                	jmp    801f8e <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  801f5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f5f:	48 89 c6             	mov    %rax,%rsi
  801f62:	bf 00 00 00 00       	mov    $0x0,%edi
  801f67:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  801f6e:	00 00 00 
  801f71:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  801f73:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f77:	48 89 c6             	mov    %rax,%rsi
  801f7a:	bf 00 00 00 00       	mov    $0x0,%edi
  801f7f:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  801f86:	00 00 00 
  801f89:	ff d0                	callq  *%rax
	return r;
  801f8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f8e:	c9                   	leaveq 
  801f8f:	c3                   	retq   

0000000000801f90 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801f90:	55                   	push   %rbp
  801f91:	48 89 e5             	mov    %rsp,%rbp
  801f94:	48 83 ec 40          	sub    $0x40,%rsp
  801f98:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801f9b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801f9f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801fa3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801fa7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801faa:	48 89 d6             	mov    %rdx,%rsi
  801fad:	89 c7                	mov    %eax,%edi
  801faf:	48 b8 5c 1b 80 00 00 	movabs $0x801b5c,%rax
  801fb6:	00 00 00 
  801fb9:	ff d0                	callq  *%rax
  801fbb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fbe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fc2:	78 24                	js     801fe8 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801fc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fc8:	8b 00                	mov    (%rax),%eax
  801fca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801fce:	48 89 d6             	mov    %rdx,%rsi
  801fd1:	89 c7                	mov    %eax,%edi
  801fd3:	48 b8 b7 1c 80 00 00 	movabs $0x801cb7,%rax
  801fda:	00 00 00 
  801fdd:	ff d0                	callq  *%rax
  801fdf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fe2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fe6:	79 05                	jns    801fed <read+0x5d>
		return r;
  801fe8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801feb:	eb 76                	jmp    802063 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801fed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ff1:	8b 40 08             	mov    0x8(%rax),%eax
  801ff4:	83 e0 03             	and    $0x3,%eax
  801ff7:	83 f8 01             	cmp    $0x1,%eax
  801ffa:	75 3a                	jne    802036 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801ffc:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802003:	00 00 00 
  802006:	48 8b 00             	mov    (%rax),%rax
  802009:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80200f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802012:	89 c6                	mov    %eax,%esi
  802014:	48 bf 57 42 80 00 00 	movabs $0x804257,%rdi
  80201b:	00 00 00 
  80201e:	b8 00 00 00 00       	mov    $0x0,%eax
  802023:	48 b9 47 02 80 00 00 	movabs $0x800247,%rcx
  80202a:	00 00 00 
  80202d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80202f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802034:	eb 2d                	jmp    802063 <read+0xd3>
	}
	if (!dev->dev_read)
  802036:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80203a:	48 8b 40 10          	mov    0x10(%rax),%rax
  80203e:	48 85 c0             	test   %rax,%rax
  802041:	75 07                	jne    80204a <read+0xba>
		return -E_NOT_SUPP;
  802043:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802048:	eb 19                	jmp    802063 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80204a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80204e:	48 8b 40 10          	mov    0x10(%rax),%rax
  802052:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802056:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80205a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80205e:	48 89 cf             	mov    %rcx,%rdi
  802061:	ff d0                	callq  *%rax
}
  802063:	c9                   	leaveq 
  802064:	c3                   	retq   

0000000000802065 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802065:	55                   	push   %rbp
  802066:	48 89 e5             	mov    %rsp,%rbp
  802069:	48 83 ec 30          	sub    $0x30,%rsp
  80206d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802070:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802074:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802078:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80207f:	eb 49                	jmp    8020ca <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802081:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802084:	48 98                	cltq   
  802086:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80208a:	48 29 c2             	sub    %rax,%rdx
  80208d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802090:	48 63 c8             	movslq %eax,%rcx
  802093:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802097:	48 01 c1             	add    %rax,%rcx
  80209a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80209d:	48 89 ce             	mov    %rcx,%rsi
  8020a0:	89 c7                	mov    %eax,%edi
  8020a2:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  8020a9:	00 00 00 
  8020ac:	ff d0                	callq  *%rax
  8020ae:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8020b1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8020b5:	79 05                	jns    8020bc <readn+0x57>
			return m;
  8020b7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020ba:	eb 1c                	jmp    8020d8 <readn+0x73>
		if (m == 0)
  8020bc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8020c0:	75 02                	jne    8020c4 <readn+0x5f>
			break;
  8020c2:	eb 11                	jmp    8020d5 <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  8020c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020c7:	01 45 fc             	add    %eax,-0x4(%rbp)
  8020ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020cd:	48 98                	cltq   
  8020cf:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8020d3:	72 ac                	jb     802081 <readn+0x1c>
	}
	return tot;
  8020d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020d8:	c9                   	leaveq 
  8020d9:	c3                   	retq   

00000000008020da <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8020da:	55                   	push   %rbp
  8020db:	48 89 e5             	mov    %rsp,%rbp
  8020de:	48 83 ec 40          	sub    $0x40,%rsp
  8020e2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8020e5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8020e9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8020ed:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8020f1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8020f4:	48 89 d6             	mov    %rdx,%rsi
  8020f7:	89 c7                	mov    %eax,%edi
  8020f9:	48 b8 5c 1b 80 00 00 	movabs $0x801b5c,%rax
  802100:	00 00 00 
  802103:	ff d0                	callq  *%rax
  802105:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802108:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80210c:	78 24                	js     802132 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80210e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802112:	8b 00                	mov    (%rax),%eax
  802114:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802118:	48 89 d6             	mov    %rdx,%rsi
  80211b:	89 c7                	mov    %eax,%edi
  80211d:	48 b8 b7 1c 80 00 00 	movabs $0x801cb7,%rax
  802124:	00 00 00 
  802127:	ff d0                	callq  *%rax
  802129:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80212c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802130:	79 05                	jns    802137 <write+0x5d>
		return r;
  802132:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802135:	eb 75                	jmp    8021ac <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802137:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80213b:	8b 40 08             	mov    0x8(%rax),%eax
  80213e:	83 e0 03             	and    $0x3,%eax
  802141:	85 c0                	test   %eax,%eax
  802143:	75 3a                	jne    80217f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802145:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80214c:	00 00 00 
  80214f:	48 8b 00             	mov    (%rax),%rax
  802152:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802158:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80215b:	89 c6                	mov    %eax,%esi
  80215d:	48 bf 73 42 80 00 00 	movabs $0x804273,%rdi
  802164:	00 00 00 
  802167:	b8 00 00 00 00       	mov    $0x0,%eax
  80216c:	48 b9 47 02 80 00 00 	movabs $0x800247,%rcx
  802173:	00 00 00 
  802176:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802178:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80217d:	eb 2d                	jmp    8021ac <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80217f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802183:	48 8b 40 18          	mov    0x18(%rax),%rax
  802187:	48 85 c0             	test   %rax,%rax
  80218a:	75 07                	jne    802193 <write+0xb9>
		return -E_NOT_SUPP;
  80218c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802191:	eb 19                	jmp    8021ac <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802193:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802197:	48 8b 40 18          	mov    0x18(%rax),%rax
  80219b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80219f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8021a3:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8021a7:	48 89 cf             	mov    %rcx,%rdi
  8021aa:	ff d0                	callq  *%rax
}
  8021ac:	c9                   	leaveq 
  8021ad:	c3                   	retq   

00000000008021ae <seek>:

int
seek(int fdnum, off_t offset)
{
  8021ae:	55                   	push   %rbp
  8021af:	48 89 e5             	mov    %rsp,%rbp
  8021b2:	48 83 ec 18          	sub    $0x18,%rsp
  8021b6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021b9:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021bc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021c0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021c3:	48 89 d6             	mov    %rdx,%rsi
  8021c6:	89 c7                	mov    %eax,%edi
  8021c8:	48 b8 5c 1b 80 00 00 	movabs $0x801b5c,%rax
  8021cf:	00 00 00 
  8021d2:	ff d0                	callq  *%rax
  8021d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021db:	79 05                	jns    8021e2 <seek+0x34>
		return r;
  8021dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021e0:	eb 0f                	jmp    8021f1 <seek+0x43>
	fd->fd_offset = offset;
  8021e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021e6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8021e9:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8021ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021f1:	c9                   	leaveq 
  8021f2:	c3                   	retq   

00000000008021f3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8021f3:	55                   	push   %rbp
  8021f4:	48 89 e5             	mov    %rsp,%rbp
  8021f7:	48 83 ec 30          	sub    $0x30,%rsp
  8021fb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8021fe:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802201:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802205:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802208:	48 89 d6             	mov    %rdx,%rsi
  80220b:	89 c7                	mov    %eax,%edi
  80220d:	48 b8 5c 1b 80 00 00 	movabs $0x801b5c,%rax
  802214:	00 00 00 
  802217:	ff d0                	callq  *%rax
  802219:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80221c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802220:	78 24                	js     802246 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802222:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802226:	8b 00                	mov    (%rax),%eax
  802228:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80222c:	48 89 d6             	mov    %rdx,%rsi
  80222f:	89 c7                	mov    %eax,%edi
  802231:	48 b8 b7 1c 80 00 00 	movabs $0x801cb7,%rax
  802238:	00 00 00 
  80223b:	ff d0                	callq  *%rax
  80223d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802240:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802244:	79 05                	jns    80224b <ftruncate+0x58>
		return r;
  802246:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802249:	eb 72                	jmp    8022bd <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80224b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80224f:	8b 40 08             	mov    0x8(%rax),%eax
  802252:	83 e0 03             	and    $0x3,%eax
  802255:	85 c0                	test   %eax,%eax
  802257:	75 3a                	jne    802293 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802259:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802260:	00 00 00 
  802263:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802266:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80226c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80226f:	89 c6                	mov    %eax,%esi
  802271:	48 bf 90 42 80 00 00 	movabs $0x804290,%rdi
  802278:	00 00 00 
  80227b:	b8 00 00 00 00       	mov    $0x0,%eax
  802280:	48 b9 47 02 80 00 00 	movabs $0x800247,%rcx
  802287:	00 00 00 
  80228a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80228c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802291:	eb 2a                	jmp    8022bd <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802293:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802297:	48 8b 40 30          	mov    0x30(%rax),%rax
  80229b:	48 85 c0             	test   %rax,%rax
  80229e:	75 07                	jne    8022a7 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8022a0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022a5:	eb 16                	jmp    8022bd <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8022a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ab:	48 8b 40 30          	mov    0x30(%rax),%rax
  8022af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022b3:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8022b6:	89 ce                	mov    %ecx,%esi
  8022b8:	48 89 d7             	mov    %rdx,%rdi
  8022bb:	ff d0                	callq  *%rax
}
  8022bd:	c9                   	leaveq 
  8022be:	c3                   	retq   

00000000008022bf <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8022bf:	55                   	push   %rbp
  8022c0:	48 89 e5             	mov    %rsp,%rbp
  8022c3:	48 83 ec 30          	sub    $0x30,%rsp
  8022c7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022ca:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022ce:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022d2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022d5:	48 89 d6             	mov    %rdx,%rsi
  8022d8:	89 c7                	mov    %eax,%edi
  8022da:	48 b8 5c 1b 80 00 00 	movabs $0x801b5c,%rax
  8022e1:	00 00 00 
  8022e4:	ff d0                	callq  *%rax
  8022e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022ed:	78 24                	js     802313 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022f3:	8b 00                	mov    (%rax),%eax
  8022f5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022f9:	48 89 d6             	mov    %rdx,%rsi
  8022fc:	89 c7                	mov    %eax,%edi
  8022fe:	48 b8 b7 1c 80 00 00 	movabs $0x801cb7,%rax
  802305:	00 00 00 
  802308:	ff d0                	callq  *%rax
  80230a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80230d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802311:	79 05                	jns    802318 <fstat+0x59>
		return r;
  802313:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802316:	eb 5e                	jmp    802376 <fstat+0xb7>
	if (!dev->dev_stat)
  802318:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80231c:	48 8b 40 28          	mov    0x28(%rax),%rax
  802320:	48 85 c0             	test   %rax,%rax
  802323:	75 07                	jne    80232c <fstat+0x6d>
		return -E_NOT_SUPP;
  802325:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80232a:	eb 4a                	jmp    802376 <fstat+0xb7>
	stat->st_name[0] = 0;
  80232c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802330:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802333:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802337:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80233e:	00 00 00 
	stat->st_isdir = 0;
  802341:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802345:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80234c:	00 00 00 
	stat->st_dev = dev;
  80234f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802353:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802357:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80235e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802362:	48 8b 40 28          	mov    0x28(%rax),%rax
  802366:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80236a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80236e:	48 89 ce             	mov    %rcx,%rsi
  802371:	48 89 d7             	mov    %rdx,%rdi
  802374:	ff d0                	callq  *%rax
}
  802376:	c9                   	leaveq 
  802377:	c3                   	retq   

0000000000802378 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802378:	55                   	push   %rbp
  802379:	48 89 e5             	mov    %rsp,%rbp
  80237c:	48 83 ec 20          	sub    $0x20,%rsp
  802380:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802384:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802388:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80238c:	be 00 00 00 00       	mov    $0x0,%esi
  802391:	48 89 c7             	mov    %rax,%rdi
  802394:	48 b8 68 24 80 00 00 	movabs $0x802468,%rax
  80239b:	00 00 00 
  80239e:	ff d0                	callq  *%rax
  8023a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023a7:	79 05                	jns    8023ae <stat+0x36>
		return fd;
  8023a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ac:	eb 2f                	jmp    8023dd <stat+0x65>
	r = fstat(fd, stat);
  8023ae:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8023b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023b5:	48 89 d6             	mov    %rdx,%rsi
  8023b8:	89 c7                	mov    %eax,%edi
  8023ba:	48 b8 bf 22 80 00 00 	movabs $0x8022bf,%rax
  8023c1:	00 00 00 
  8023c4:	ff d0                	callq  *%rax
  8023c6:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8023c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023cc:	89 c7                	mov    %eax,%edi
  8023ce:	48 b8 6e 1d 80 00 00 	movabs $0x801d6e,%rax
  8023d5:	00 00 00 
  8023d8:	ff d0                	callq  *%rax
	return r;
  8023da:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8023dd:	c9                   	leaveq 
  8023de:	c3                   	retq   

00000000008023df <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8023df:	55                   	push   %rbp
  8023e0:	48 89 e5             	mov    %rsp,%rbp
  8023e3:	48 83 ec 10          	sub    $0x10,%rsp
  8023e7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8023ee:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8023f5:	00 00 00 
  8023f8:	8b 00                	mov    (%rax),%eax
  8023fa:	85 c0                	test   %eax,%eax
  8023fc:	75 1f                	jne    80241d <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8023fe:	bf 01 00 00 00       	mov    $0x1,%edi
  802403:	48 b8 fd 3b 80 00 00 	movabs $0x803bfd,%rax
  80240a:	00 00 00 
  80240d:	ff d0                	callq  *%rax
  80240f:	89 c2                	mov    %eax,%edx
  802411:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802418:	00 00 00 
  80241b:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80241d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802424:	00 00 00 
  802427:	8b 00                	mov    (%rax),%eax
  802429:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80242c:	b9 07 00 00 00       	mov    $0x7,%ecx
  802431:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802438:	00 00 00 
  80243b:	89 c7                	mov    %eax,%edi
  80243d:	48 b8 70 3a 80 00 00 	movabs $0x803a70,%rax
  802444:	00 00 00 
  802447:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802449:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80244d:	ba 00 00 00 00       	mov    $0x0,%edx
  802452:	48 89 c6             	mov    %rax,%rsi
  802455:	bf 00 00 00 00       	mov    $0x0,%edi
  80245a:	48 b8 32 3a 80 00 00 	movabs $0x803a32,%rax
  802461:	00 00 00 
  802464:	ff d0                	callq  *%rax
}
  802466:	c9                   	leaveq 
  802467:	c3                   	retq   

0000000000802468 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802468:	55                   	push   %rbp
  802469:	48 89 e5             	mov    %rsp,%rbp
  80246c:	48 83 ec 10          	sub    $0x10,%rsp
  802470:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802474:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  802477:	48 ba b6 42 80 00 00 	movabs $0x8042b6,%rdx
  80247e:	00 00 00 
  802481:	be 4c 00 00 00       	mov    $0x4c,%esi
  802486:	48 bf cb 42 80 00 00 	movabs $0x8042cb,%rdi
  80248d:	00 00 00 
  802490:	b8 00 00 00 00       	mov    $0x0,%eax
  802495:	48 b9 1e 39 80 00 00 	movabs $0x80391e,%rcx
  80249c:	00 00 00 
  80249f:	ff d1                	callq  *%rcx

00000000008024a1 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8024a1:	55                   	push   %rbp
  8024a2:	48 89 e5             	mov    %rsp,%rbp
  8024a5:	48 83 ec 10          	sub    $0x10,%rsp
  8024a9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8024ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024b1:	8b 50 0c             	mov    0xc(%rax),%edx
  8024b4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8024bb:	00 00 00 
  8024be:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8024c0:	be 00 00 00 00       	mov    $0x0,%esi
  8024c5:	bf 06 00 00 00       	mov    $0x6,%edi
  8024ca:	48 b8 df 23 80 00 00 	movabs $0x8023df,%rax
  8024d1:	00 00 00 
  8024d4:	ff d0                	callq  *%rax
}
  8024d6:	c9                   	leaveq 
  8024d7:	c3                   	retq   

00000000008024d8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8024d8:	55                   	push   %rbp
  8024d9:	48 89 e5             	mov    %rsp,%rbp
  8024dc:	48 83 ec 20          	sub    $0x20,%rsp
  8024e0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8024e4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8024e8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  8024ec:	48 ba d6 42 80 00 00 	movabs $0x8042d6,%rdx
  8024f3:	00 00 00 
  8024f6:	be 6b 00 00 00       	mov    $0x6b,%esi
  8024fb:	48 bf cb 42 80 00 00 	movabs $0x8042cb,%rdi
  802502:	00 00 00 
  802505:	b8 00 00 00 00       	mov    $0x0,%eax
  80250a:	48 b9 1e 39 80 00 00 	movabs $0x80391e,%rcx
  802511:	00 00 00 
  802514:	ff d1                	callq  *%rcx

0000000000802516 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802516:	55                   	push   %rbp
  802517:	48 89 e5             	mov    %rsp,%rbp
  80251a:	48 83 ec 20          	sub    $0x20,%rsp
  80251e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802522:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802526:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  80252a:	48 ba f3 42 80 00 00 	movabs $0x8042f3,%rdx
  802531:	00 00 00 
  802534:	be 7b 00 00 00       	mov    $0x7b,%esi
  802539:	48 bf cb 42 80 00 00 	movabs $0x8042cb,%rdi
  802540:	00 00 00 
  802543:	b8 00 00 00 00       	mov    $0x0,%eax
  802548:	48 b9 1e 39 80 00 00 	movabs $0x80391e,%rcx
  80254f:	00 00 00 
  802552:	ff d1                	callq  *%rcx

0000000000802554 <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802554:	55                   	push   %rbp
  802555:	48 89 e5             	mov    %rsp,%rbp
  802558:	48 83 ec 20          	sub    $0x20,%rsp
  80255c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802560:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802564:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802568:	8b 50 0c             	mov    0xc(%rax),%edx
  80256b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802572:	00 00 00 
  802575:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802577:	be 00 00 00 00       	mov    $0x0,%esi
  80257c:	bf 05 00 00 00       	mov    $0x5,%edi
  802581:	48 b8 df 23 80 00 00 	movabs $0x8023df,%rax
  802588:	00 00 00 
  80258b:	ff d0                	callq  *%rax
  80258d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802590:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802594:	79 05                	jns    80259b <devfile_stat+0x47>
		return r;
  802596:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802599:	eb 56                	jmp    8025f1 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80259b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80259f:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8025a6:	00 00 00 
  8025a9:	48 89 c7             	mov    %rax,%rdi
  8025ac:	48 b8 e1 0d 80 00 00 	movabs $0x800de1,%rax
  8025b3:	00 00 00 
  8025b6:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8025b8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8025bf:	00 00 00 
  8025c2:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8025c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025cc:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8025d2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8025d9:	00 00 00 
  8025dc:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8025e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025e6:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8025ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025f1:	c9                   	leaveq 
  8025f2:	c3                   	retq   

00000000008025f3 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8025f3:	55                   	push   %rbp
  8025f4:	48 89 e5             	mov    %rsp,%rbp
  8025f7:	48 83 ec 10          	sub    $0x10,%rsp
  8025fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8025ff:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802602:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802606:	8b 50 0c             	mov    0xc(%rax),%edx
  802609:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802610:	00 00 00 
  802613:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802615:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80261c:	00 00 00 
  80261f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802622:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802625:	be 00 00 00 00       	mov    $0x0,%esi
  80262a:	bf 02 00 00 00       	mov    $0x2,%edi
  80262f:	48 b8 df 23 80 00 00 	movabs $0x8023df,%rax
  802636:	00 00 00 
  802639:	ff d0                	callq  *%rax
}
  80263b:	c9                   	leaveq 
  80263c:	c3                   	retq   

000000000080263d <remove>:

// Delete a file
int
remove(const char *path)
{
  80263d:	55                   	push   %rbp
  80263e:	48 89 e5             	mov    %rsp,%rbp
  802641:	48 83 ec 10          	sub    $0x10,%rsp
  802645:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802649:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80264d:	48 89 c7             	mov    %rax,%rdi
  802650:	48 b8 75 0d 80 00 00 	movabs $0x800d75,%rax
  802657:	00 00 00 
  80265a:	ff d0                	callq  *%rax
  80265c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802661:	7e 07                	jle    80266a <remove+0x2d>
		return -E_BAD_PATH;
  802663:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802668:	eb 33                	jmp    80269d <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80266a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80266e:	48 89 c6             	mov    %rax,%rsi
  802671:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802678:	00 00 00 
  80267b:	48 b8 e1 0d 80 00 00 	movabs $0x800de1,%rax
  802682:	00 00 00 
  802685:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802687:	be 00 00 00 00       	mov    $0x0,%esi
  80268c:	bf 07 00 00 00       	mov    $0x7,%edi
  802691:	48 b8 df 23 80 00 00 	movabs $0x8023df,%rax
  802698:	00 00 00 
  80269b:	ff d0                	callq  *%rax
}
  80269d:	c9                   	leaveq 
  80269e:	c3                   	retq   

000000000080269f <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80269f:	55                   	push   %rbp
  8026a0:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8026a3:	be 00 00 00 00       	mov    $0x0,%esi
  8026a8:	bf 08 00 00 00       	mov    $0x8,%edi
  8026ad:	48 b8 df 23 80 00 00 	movabs $0x8023df,%rax
  8026b4:	00 00 00 
  8026b7:	ff d0                	callq  *%rax
}
  8026b9:	5d                   	pop    %rbp
  8026ba:	c3                   	retq   

00000000008026bb <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8026bb:	55                   	push   %rbp
  8026bc:	48 89 e5             	mov    %rsp,%rbp
  8026bf:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8026c6:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8026cd:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8026d4:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8026db:	be 00 00 00 00       	mov    $0x0,%esi
  8026e0:	48 89 c7             	mov    %rax,%rdi
  8026e3:	48 b8 68 24 80 00 00 	movabs $0x802468,%rax
  8026ea:	00 00 00 
  8026ed:	ff d0                	callq  *%rax
  8026ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8026f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026f6:	79 28                	jns    802720 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8026f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026fb:	89 c6                	mov    %eax,%esi
  8026fd:	48 bf 11 43 80 00 00 	movabs $0x804311,%rdi
  802704:	00 00 00 
  802707:	b8 00 00 00 00       	mov    $0x0,%eax
  80270c:	48 ba 47 02 80 00 00 	movabs $0x800247,%rdx
  802713:	00 00 00 
  802716:	ff d2                	callq  *%rdx
		return fd_src;
  802718:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80271b:	e9 74 01 00 00       	jmpq   802894 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802720:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802727:	be 01 01 00 00       	mov    $0x101,%esi
  80272c:	48 89 c7             	mov    %rax,%rdi
  80272f:	48 b8 68 24 80 00 00 	movabs $0x802468,%rax
  802736:	00 00 00 
  802739:	ff d0                	callq  *%rax
  80273b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80273e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802742:	79 39                	jns    80277d <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802744:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802747:	89 c6                	mov    %eax,%esi
  802749:	48 bf 27 43 80 00 00 	movabs $0x804327,%rdi
  802750:	00 00 00 
  802753:	b8 00 00 00 00       	mov    $0x0,%eax
  802758:	48 ba 47 02 80 00 00 	movabs $0x800247,%rdx
  80275f:	00 00 00 
  802762:	ff d2                	callq  *%rdx
		close(fd_src);
  802764:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802767:	89 c7                	mov    %eax,%edi
  802769:	48 b8 6e 1d 80 00 00 	movabs $0x801d6e,%rax
  802770:	00 00 00 
  802773:	ff d0                	callq  *%rax
		return fd_dest;
  802775:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802778:	e9 17 01 00 00       	jmpq   802894 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80277d:	eb 74                	jmp    8027f3 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80277f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802782:	48 63 d0             	movslq %eax,%rdx
  802785:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80278c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80278f:	48 89 ce             	mov    %rcx,%rsi
  802792:	89 c7                	mov    %eax,%edi
  802794:	48 b8 da 20 80 00 00 	movabs $0x8020da,%rax
  80279b:	00 00 00 
  80279e:	ff d0                	callq  *%rax
  8027a0:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8027a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8027a7:	79 4a                	jns    8027f3 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8027a9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8027ac:	89 c6                	mov    %eax,%esi
  8027ae:	48 bf 41 43 80 00 00 	movabs $0x804341,%rdi
  8027b5:	00 00 00 
  8027b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bd:	48 ba 47 02 80 00 00 	movabs $0x800247,%rdx
  8027c4:	00 00 00 
  8027c7:	ff d2                	callq  *%rdx
			close(fd_src);
  8027c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027cc:	89 c7                	mov    %eax,%edi
  8027ce:	48 b8 6e 1d 80 00 00 	movabs $0x801d6e,%rax
  8027d5:	00 00 00 
  8027d8:	ff d0                	callq  *%rax
			close(fd_dest);
  8027da:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027dd:	89 c7                	mov    %eax,%edi
  8027df:	48 b8 6e 1d 80 00 00 	movabs $0x801d6e,%rax
  8027e6:	00 00 00 
  8027e9:	ff d0                	callq  *%rax
			return write_size;
  8027eb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8027ee:	e9 a1 00 00 00       	jmpq   802894 <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8027f3:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8027fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027fd:	ba 00 02 00 00       	mov    $0x200,%edx
  802802:	48 89 ce             	mov    %rcx,%rsi
  802805:	89 c7                	mov    %eax,%edi
  802807:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  80280e:	00 00 00 
  802811:	ff d0                	callq  *%rax
  802813:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802816:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80281a:	0f 8f 5f ff ff ff    	jg     80277f <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  802820:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802824:	79 47                	jns    80286d <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802826:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802829:	89 c6                	mov    %eax,%esi
  80282b:	48 bf 54 43 80 00 00 	movabs $0x804354,%rdi
  802832:	00 00 00 
  802835:	b8 00 00 00 00       	mov    $0x0,%eax
  80283a:	48 ba 47 02 80 00 00 	movabs $0x800247,%rdx
  802841:	00 00 00 
  802844:	ff d2                	callq  *%rdx
		close(fd_src);
  802846:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802849:	89 c7                	mov    %eax,%edi
  80284b:	48 b8 6e 1d 80 00 00 	movabs $0x801d6e,%rax
  802852:	00 00 00 
  802855:	ff d0                	callq  *%rax
		close(fd_dest);
  802857:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80285a:	89 c7                	mov    %eax,%edi
  80285c:	48 b8 6e 1d 80 00 00 	movabs $0x801d6e,%rax
  802863:	00 00 00 
  802866:	ff d0                	callq  *%rax
		return read_size;
  802868:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80286b:	eb 27                	jmp    802894 <copy+0x1d9>
	}
	close(fd_src);
  80286d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802870:	89 c7                	mov    %eax,%edi
  802872:	48 b8 6e 1d 80 00 00 	movabs $0x801d6e,%rax
  802879:	00 00 00 
  80287c:	ff d0                	callq  *%rax
	close(fd_dest);
  80287e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802881:	89 c7                	mov    %eax,%edi
  802883:	48 b8 6e 1d 80 00 00 	movabs $0x801d6e,%rax
  80288a:	00 00 00 
  80288d:	ff d0                	callq  *%rax
	return 0;
  80288f:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802894:	c9                   	leaveq 
  802895:	c3                   	retq   

0000000000802896 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802896:	55                   	push   %rbp
  802897:	48 89 e5             	mov    %rsp,%rbp
  80289a:	48 83 ec 20          	sub    $0x20,%rsp
  80289e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8028a1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028a8:	48 89 d6             	mov    %rdx,%rsi
  8028ab:	89 c7                	mov    %eax,%edi
  8028ad:	48 b8 5c 1b 80 00 00 	movabs $0x801b5c,%rax
  8028b4:	00 00 00 
  8028b7:	ff d0                	callq  *%rax
  8028b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028c0:	79 05                	jns    8028c7 <fd2sockid+0x31>
		return r;
  8028c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028c5:	eb 24                	jmp    8028eb <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8028c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028cb:	8b 10                	mov    (%rax),%edx
  8028cd:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  8028d4:	00 00 00 
  8028d7:	8b 00                	mov    (%rax),%eax
  8028d9:	39 c2                	cmp    %eax,%edx
  8028db:	74 07                	je     8028e4 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8028dd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028e2:	eb 07                	jmp    8028eb <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8028e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028e8:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8028eb:	c9                   	leaveq 
  8028ec:	c3                   	retq   

00000000008028ed <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8028ed:	55                   	push   %rbp
  8028ee:	48 89 e5             	mov    %rsp,%rbp
  8028f1:	48 83 ec 20          	sub    $0x20,%rsp
  8028f5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8028f8:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8028fc:	48 89 c7             	mov    %rax,%rdi
  8028ff:	48 b8 c4 1a 80 00 00 	movabs $0x801ac4,%rax
  802906:	00 00 00 
  802909:	ff d0                	callq  *%rax
  80290b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80290e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802912:	78 26                	js     80293a <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802914:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802918:	ba 07 04 00 00       	mov    $0x407,%edx
  80291d:	48 89 c6             	mov    %rax,%rsi
  802920:	bf 00 00 00 00       	mov    $0x0,%edi
  802925:	48 b8 0e 17 80 00 00 	movabs $0x80170e,%rax
  80292c:	00 00 00 
  80292f:	ff d0                	callq  *%rax
  802931:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802934:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802938:	79 16                	jns    802950 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  80293a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80293d:	89 c7                	mov    %eax,%edi
  80293f:	48 b8 fc 2d 80 00 00 	movabs $0x802dfc,%rax
  802946:	00 00 00 
  802949:	ff d0                	callq  *%rax
		return r;
  80294b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80294e:	eb 3a                	jmp    80298a <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802950:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802954:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  80295b:	00 00 00 
  80295e:	8b 12                	mov    (%rdx),%edx
  802960:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802962:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802966:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80296d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802971:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802974:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802977:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80297b:	48 89 c7             	mov    %rax,%rdi
  80297e:	48 b8 76 1a 80 00 00 	movabs $0x801a76,%rax
  802985:	00 00 00 
  802988:	ff d0                	callq  *%rax
}
  80298a:	c9                   	leaveq 
  80298b:	c3                   	retq   

000000000080298c <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80298c:	55                   	push   %rbp
  80298d:	48 89 e5             	mov    %rsp,%rbp
  802990:	48 83 ec 30          	sub    $0x30,%rsp
  802994:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802997:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80299b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80299f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029a2:	89 c7                	mov    %eax,%edi
  8029a4:	48 b8 96 28 80 00 00 	movabs $0x802896,%rax
  8029ab:	00 00 00 
  8029ae:	ff d0                	callq  *%rax
  8029b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b7:	79 05                	jns    8029be <accept+0x32>
		return r;
  8029b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029bc:	eb 3b                	jmp    8029f9 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8029be:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029c2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8029c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c9:	48 89 ce             	mov    %rcx,%rsi
  8029cc:	89 c7                	mov    %eax,%edi
  8029ce:	48 b8 d9 2c 80 00 00 	movabs $0x802cd9,%rax
  8029d5:	00 00 00 
  8029d8:	ff d0                	callq  *%rax
  8029da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e1:	79 05                	jns    8029e8 <accept+0x5c>
		return r;
  8029e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e6:	eb 11                	jmp    8029f9 <accept+0x6d>
	return alloc_sockfd(r);
  8029e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029eb:	89 c7                	mov    %eax,%edi
  8029ed:	48 b8 ed 28 80 00 00 	movabs $0x8028ed,%rax
  8029f4:	00 00 00 
  8029f7:	ff d0                	callq  *%rax
}
  8029f9:	c9                   	leaveq 
  8029fa:	c3                   	retq   

00000000008029fb <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8029fb:	55                   	push   %rbp
  8029fc:	48 89 e5             	mov    %rsp,%rbp
  8029ff:	48 83 ec 20          	sub    $0x20,%rsp
  802a03:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a06:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a0a:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802a0d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a10:	89 c7                	mov    %eax,%edi
  802a12:	48 b8 96 28 80 00 00 	movabs $0x802896,%rax
  802a19:	00 00 00 
  802a1c:	ff d0                	callq  *%rax
  802a1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a25:	79 05                	jns    802a2c <bind+0x31>
		return r;
  802a27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a2a:	eb 1b                	jmp    802a47 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802a2c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802a2f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802a33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a36:	48 89 ce             	mov    %rcx,%rsi
  802a39:	89 c7                	mov    %eax,%edi
  802a3b:	48 b8 58 2d 80 00 00 	movabs $0x802d58,%rax
  802a42:	00 00 00 
  802a45:	ff d0                	callq  *%rax
}
  802a47:	c9                   	leaveq 
  802a48:	c3                   	retq   

0000000000802a49 <shutdown>:

int
shutdown(int s, int how)
{
  802a49:	55                   	push   %rbp
  802a4a:	48 89 e5             	mov    %rsp,%rbp
  802a4d:	48 83 ec 20          	sub    $0x20,%rsp
  802a51:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a54:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802a57:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a5a:	89 c7                	mov    %eax,%edi
  802a5c:	48 b8 96 28 80 00 00 	movabs $0x802896,%rax
  802a63:	00 00 00 
  802a66:	ff d0                	callq  *%rax
  802a68:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a6f:	79 05                	jns    802a76 <shutdown+0x2d>
		return r;
  802a71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a74:	eb 16                	jmp    802a8c <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802a76:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802a79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a7c:	89 d6                	mov    %edx,%esi
  802a7e:	89 c7                	mov    %eax,%edi
  802a80:	48 b8 bc 2d 80 00 00 	movabs $0x802dbc,%rax
  802a87:	00 00 00 
  802a8a:	ff d0                	callq  *%rax
}
  802a8c:	c9                   	leaveq 
  802a8d:	c3                   	retq   

0000000000802a8e <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802a8e:	55                   	push   %rbp
  802a8f:	48 89 e5             	mov    %rsp,%rbp
  802a92:	48 83 ec 10          	sub    $0x10,%rsp
  802a96:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802a9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a9e:	48 89 c7             	mov    %rax,%rdi
  802aa1:	48 b8 6f 3c 80 00 00 	movabs $0x803c6f,%rax
  802aa8:	00 00 00 
  802aab:	ff d0                	callq  *%rax
  802aad:	83 f8 01             	cmp    $0x1,%eax
  802ab0:	75 17                	jne    802ac9 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802ab2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ab6:	8b 40 0c             	mov    0xc(%rax),%eax
  802ab9:	89 c7                	mov    %eax,%edi
  802abb:	48 b8 fc 2d 80 00 00 	movabs $0x802dfc,%rax
  802ac2:	00 00 00 
  802ac5:	ff d0                	callq  *%rax
  802ac7:	eb 05                	jmp    802ace <devsock_close+0x40>
	else
		return 0;
  802ac9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ace:	c9                   	leaveq 
  802acf:	c3                   	retq   

0000000000802ad0 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802ad0:	55                   	push   %rbp
  802ad1:	48 89 e5             	mov    %rsp,%rbp
  802ad4:	48 83 ec 20          	sub    $0x20,%rsp
  802ad8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802adb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802adf:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ae2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ae5:	89 c7                	mov    %eax,%edi
  802ae7:	48 b8 96 28 80 00 00 	movabs $0x802896,%rax
  802aee:	00 00 00 
  802af1:	ff d0                	callq  *%rax
  802af3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802af6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802afa:	79 05                	jns    802b01 <connect+0x31>
		return r;
  802afc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aff:	eb 1b                	jmp    802b1c <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802b01:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802b04:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802b08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b0b:	48 89 ce             	mov    %rcx,%rsi
  802b0e:	89 c7                	mov    %eax,%edi
  802b10:	48 b8 29 2e 80 00 00 	movabs $0x802e29,%rax
  802b17:	00 00 00 
  802b1a:	ff d0                	callq  *%rax
}
  802b1c:	c9                   	leaveq 
  802b1d:	c3                   	retq   

0000000000802b1e <listen>:

int
listen(int s, int backlog)
{
  802b1e:	55                   	push   %rbp
  802b1f:	48 89 e5             	mov    %rsp,%rbp
  802b22:	48 83 ec 20          	sub    $0x20,%rsp
  802b26:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b29:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802b2c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b2f:	89 c7                	mov    %eax,%edi
  802b31:	48 b8 96 28 80 00 00 	movabs $0x802896,%rax
  802b38:	00 00 00 
  802b3b:	ff d0                	callq  *%rax
  802b3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b44:	79 05                	jns    802b4b <listen+0x2d>
		return r;
  802b46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b49:	eb 16                	jmp    802b61 <listen+0x43>
	return nsipc_listen(r, backlog);
  802b4b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802b4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b51:	89 d6                	mov    %edx,%esi
  802b53:	89 c7                	mov    %eax,%edi
  802b55:	48 b8 8d 2e 80 00 00 	movabs $0x802e8d,%rax
  802b5c:	00 00 00 
  802b5f:	ff d0                	callq  *%rax
}
  802b61:	c9                   	leaveq 
  802b62:	c3                   	retq   

0000000000802b63 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802b63:	55                   	push   %rbp
  802b64:	48 89 e5             	mov    %rsp,%rbp
  802b67:	48 83 ec 20          	sub    $0x20,%rsp
  802b6b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b6f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802b73:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802b77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b7b:	89 c2                	mov    %eax,%edx
  802b7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b81:	8b 40 0c             	mov    0xc(%rax),%eax
  802b84:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802b88:	b9 00 00 00 00       	mov    $0x0,%ecx
  802b8d:	89 c7                	mov    %eax,%edi
  802b8f:	48 b8 cd 2e 80 00 00 	movabs $0x802ecd,%rax
  802b96:	00 00 00 
  802b99:	ff d0                	callq  *%rax
}
  802b9b:	c9                   	leaveq 
  802b9c:	c3                   	retq   

0000000000802b9d <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802b9d:	55                   	push   %rbp
  802b9e:	48 89 e5             	mov    %rsp,%rbp
  802ba1:	48 83 ec 20          	sub    $0x20,%rsp
  802ba5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ba9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802bad:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802bb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bb5:	89 c2                	mov    %eax,%edx
  802bb7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bbb:	8b 40 0c             	mov    0xc(%rax),%eax
  802bbe:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802bc2:	b9 00 00 00 00       	mov    $0x0,%ecx
  802bc7:	89 c7                	mov    %eax,%edi
  802bc9:	48 b8 99 2f 80 00 00 	movabs $0x802f99,%rax
  802bd0:	00 00 00 
  802bd3:	ff d0                	callq  *%rax
}
  802bd5:	c9                   	leaveq 
  802bd6:	c3                   	retq   

0000000000802bd7 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802bd7:	55                   	push   %rbp
  802bd8:	48 89 e5             	mov    %rsp,%rbp
  802bdb:	48 83 ec 10          	sub    $0x10,%rsp
  802bdf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802be3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802be7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802beb:	48 be 6f 43 80 00 00 	movabs $0x80436f,%rsi
  802bf2:	00 00 00 
  802bf5:	48 89 c7             	mov    %rax,%rdi
  802bf8:	48 b8 e1 0d 80 00 00 	movabs $0x800de1,%rax
  802bff:	00 00 00 
  802c02:	ff d0                	callq  *%rax
	return 0;
  802c04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c09:	c9                   	leaveq 
  802c0a:	c3                   	retq   

0000000000802c0b <socket>:

int
socket(int domain, int type, int protocol)
{
  802c0b:	55                   	push   %rbp
  802c0c:	48 89 e5             	mov    %rsp,%rbp
  802c0f:	48 83 ec 20          	sub    $0x20,%rsp
  802c13:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c16:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802c19:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802c1c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802c1f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802c22:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c25:	89 ce                	mov    %ecx,%esi
  802c27:	89 c7                	mov    %eax,%edi
  802c29:	48 b8 51 30 80 00 00 	movabs $0x803051,%rax
  802c30:	00 00 00 
  802c33:	ff d0                	callq  *%rax
  802c35:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c3c:	79 05                	jns    802c43 <socket+0x38>
		return r;
  802c3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c41:	eb 11                	jmp    802c54 <socket+0x49>
	return alloc_sockfd(r);
  802c43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c46:	89 c7                	mov    %eax,%edi
  802c48:	48 b8 ed 28 80 00 00 	movabs $0x8028ed,%rax
  802c4f:	00 00 00 
  802c52:	ff d0                	callq  *%rax
}
  802c54:	c9                   	leaveq 
  802c55:	c3                   	retq   

0000000000802c56 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802c56:	55                   	push   %rbp
  802c57:	48 89 e5             	mov    %rsp,%rbp
  802c5a:	48 83 ec 10          	sub    $0x10,%rsp
  802c5e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  802c61:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802c68:	00 00 00 
  802c6b:	8b 00                	mov    (%rax),%eax
  802c6d:	85 c0                	test   %eax,%eax
  802c6f:	75 1f                	jne    802c90 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802c71:	bf 02 00 00 00       	mov    $0x2,%edi
  802c76:	48 b8 fd 3b 80 00 00 	movabs $0x803bfd,%rax
  802c7d:	00 00 00 
  802c80:	ff d0                	callq  *%rax
  802c82:	89 c2                	mov    %eax,%edx
  802c84:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802c8b:	00 00 00 
  802c8e:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802c90:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  802c97:	00 00 00 
  802c9a:	8b 00                	mov    (%rax),%eax
  802c9c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802c9f:	b9 07 00 00 00       	mov    $0x7,%ecx
  802ca4:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802cab:	00 00 00 
  802cae:	89 c7                	mov    %eax,%edi
  802cb0:	48 b8 70 3a 80 00 00 	movabs $0x803a70,%rax
  802cb7:	00 00 00 
  802cba:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  802cbc:	ba 00 00 00 00       	mov    $0x0,%edx
  802cc1:	be 00 00 00 00       	mov    $0x0,%esi
  802cc6:	bf 00 00 00 00       	mov    $0x0,%edi
  802ccb:	48 b8 32 3a 80 00 00 	movabs $0x803a32,%rax
  802cd2:	00 00 00 
  802cd5:	ff d0                	callq  *%rax
}
  802cd7:	c9                   	leaveq 
  802cd8:	c3                   	retq   

0000000000802cd9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802cd9:	55                   	push   %rbp
  802cda:	48 89 e5             	mov    %rsp,%rbp
  802cdd:	48 83 ec 30          	sub    $0x30,%rsp
  802ce1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ce4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ce8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  802cec:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802cf3:	00 00 00 
  802cf6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802cf9:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802cfb:	bf 01 00 00 00       	mov    $0x1,%edi
  802d00:	48 b8 56 2c 80 00 00 	movabs $0x802c56,%rax
  802d07:	00 00 00 
  802d0a:	ff d0                	callq  *%rax
  802d0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d13:	78 3e                	js     802d53 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802d15:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802d1c:	00 00 00 
  802d1f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802d23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d27:	8b 40 10             	mov    0x10(%rax),%eax
  802d2a:	89 c2                	mov    %eax,%edx
  802d2c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802d30:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d34:	48 89 ce             	mov    %rcx,%rsi
  802d37:	48 89 c7             	mov    %rax,%rdi
  802d3a:	48 b8 05 11 80 00 00 	movabs $0x801105,%rax
  802d41:	00 00 00 
  802d44:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  802d46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d4a:	8b 50 10             	mov    0x10(%rax),%edx
  802d4d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d51:	89 10                	mov    %edx,(%rax)
	}
	return r;
  802d53:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d56:	c9                   	leaveq 
  802d57:	c3                   	retq   

0000000000802d58 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802d58:	55                   	push   %rbp
  802d59:	48 89 e5             	mov    %rsp,%rbp
  802d5c:	48 83 ec 10          	sub    $0x10,%rsp
  802d60:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d63:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802d67:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  802d6a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802d71:	00 00 00 
  802d74:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d77:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802d79:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802d7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d80:	48 89 c6             	mov    %rax,%rsi
  802d83:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802d8a:	00 00 00 
  802d8d:	48 b8 05 11 80 00 00 	movabs $0x801105,%rax
  802d94:	00 00 00 
  802d97:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  802d99:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802da0:	00 00 00 
  802da3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802da6:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  802da9:	bf 02 00 00 00       	mov    $0x2,%edi
  802dae:	48 b8 56 2c 80 00 00 	movabs $0x802c56,%rax
  802db5:	00 00 00 
  802db8:	ff d0                	callq  *%rax
}
  802dba:	c9                   	leaveq 
  802dbb:	c3                   	retq   

0000000000802dbc <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802dbc:	55                   	push   %rbp
  802dbd:	48 89 e5             	mov    %rsp,%rbp
  802dc0:	48 83 ec 10          	sub    $0x10,%rsp
  802dc4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802dc7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  802dca:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802dd1:	00 00 00 
  802dd4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802dd7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  802dd9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802de0:	00 00 00 
  802de3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802de6:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  802de9:	bf 03 00 00 00       	mov    $0x3,%edi
  802dee:	48 b8 56 2c 80 00 00 	movabs $0x802c56,%rax
  802df5:	00 00 00 
  802df8:	ff d0                	callq  *%rax
}
  802dfa:	c9                   	leaveq 
  802dfb:	c3                   	retq   

0000000000802dfc <nsipc_close>:

int
nsipc_close(int s)
{
  802dfc:	55                   	push   %rbp
  802dfd:	48 89 e5             	mov    %rsp,%rbp
  802e00:	48 83 ec 10          	sub    $0x10,%rsp
  802e04:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  802e07:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e0e:	00 00 00 
  802e11:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802e14:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  802e16:	bf 04 00 00 00       	mov    $0x4,%edi
  802e1b:	48 b8 56 2c 80 00 00 	movabs $0x802c56,%rax
  802e22:	00 00 00 
  802e25:	ff d0                	callq  *%rax
}
  802e27:	c9                   	leaveq 
  802e28:	c3                   	retq   

0000000000802e29 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802e29:	55                   	push   %rbp
  802e2a:	48 89 e5             	mov    %rsp,%rbp
  802e2d:	48 83 ec 10          	sub    $0x10,%rsp
  802e31:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e34:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802e38:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  802e3b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e42:	00 00 00 
  802e45:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802e48:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802e4a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802e4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e51:	48 89 c6             	mov    %rax,%rsi
  802e54:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802e5b:	00 00 00 
  802e5e:	48 b8 05 11 80 00 00 	movabs $0x801105,%rax
  802e65:	00 00 00 
  802e68:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  802e6a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e71:	00 00 00 
  802e74:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802e77:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  802e7a:	bf 05 00 00 00       	mov    $0x5,%edi
  802e7f:	48 b8 56 2c 80 00 00 	movabs $0x802c56,%rax
  802e86:	00 00 00 
  802e89:	ff d0                	callq  *%rax
}
  802e8b:	c9                   	leaveq 
  802e8c:	c3                   	retq   

0000000000802e8d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802e8d:	55                   	push   %rbp
  802e8e:	48 89 e5             	mov    %rsp,%rbp
  802e91:	48 83 ec 10          	sub    $0x10,%rsp
  802e95:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e98:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  802e9b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ea2:	00 00 00 
  802ea5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ea8:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  802eaa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802eb1:	00 00 00 
  802eb4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802eb7:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  802eba:	bf 06 00 00 00       	mov    $0x6,%edi
  802ebf:	48 b8 56 2c 80 00 00 	movabs $0x802c56,%rax
  802ec6:	00 00 00 
  802ec9:	ff d0                	callq  *%rax
}
  802ecb:	c9                   	leaveq 
  802ecc:	c3                   	retq   

0000000000802ecd <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802ecd:	55                   	push   %rbp
  802ece:	48 89 e5             	mov    %rsp,%rbp
  802ed1:	48 83 ec 30          	sub    $0x30,%rsp
  802ed5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ed8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802edc:	89 55 e8             	mov    %edx,-0x18(%rbp)
  802edf:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  802ee2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ee9:	00 00 00 
  802eec:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802eef:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  802ef1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ef8:	00 00 00 
  802efb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802efe:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  802f01:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f08:	00 00 00 
  802f0b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f0e:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802f11:	bf 07 00 00 00       	mov    $0x7,%edi
  802f16:	48 b8 56 2c 80 00 00 	movabs $0x802c56,%rax
  802f1d:	00 00 00 
  802f20:	ff d0                	callq  *%rax
  802f22:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f25:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f29:	78 69                	js     802f94 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  802f2b:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  802f32:	7f 08                	jg     802f3c <nsipc_recv+0x6f>
  802f34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f37:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  802f3a:	7e 35                	jle    802f71 <nsipc_recv+0xa4>
  802f3c:	48 b9 76 43 80 00 00 	movabs $0x804376,%rcx
  802f43:	00 00 00 
  802f46:	48 ba 8b 43 80 00 00 	movabs $0x80438b,%rdx
  802f4d:	00 00 00 
  802f50:	be 61 00 00 00       	mov    $0x61,%esi
  802f55:	48 bf a0 43 80 00 00 	movabs $0x8043a0,%rdi
  802f5c:	00 00 00 
  802f5f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f64:	49 b8 1e 39 80 00 00 	movabs $0x80391e,%r8
  802f6b:	00 00 00 
  802f6e:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802f71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f74:	48 63 d0             	movslq %eax,%rdx
  802f77:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f7b:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  802f82:	00 00 00 
  802f85:	48 89 c7             	mov    %rax,%rdi
  802f88:	48 b8 05 11 80 00 00 	movabs $0x801105,%rax
  802f8f:	00 00 00 
  802f92:	ff d0                	callq  *%rax
	}

	return r;
  802f94:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f97:	c9                   	leaveq 
  802f98:	c3                   	retq   

0000000000802f99 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802f99:	55                   	push   %rbp
  802f9a:	48 89 e5             	mov    %rsp,%rbp
  802f9d:	48 83 ec 20          	sub    $0x20,%rsp
  802fa1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802fa4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802fa8:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802fab:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  802fae:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fb5:	00 00 00 
  802fb8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802fbb:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  802fbd:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  802fc4:	7e 35                	jle    802ffb <nsipc_send+0x62>
  802fc6:	48 b9 ac 43 80 00 00 	movabs $0x8043ac,%rcx
  802fcd:	00 00 00 
  802fd0:	48 ba 8b 43 80 00 00 	movabs $0x80438b,%rdx
  802fd7:	00 00 00 
  802fda:	be 6c 00 00 00       	mov    $0x6c,%esi
  802fdf:	48 bf a0 43 80 00 00 	movabs $0x8043a0,%rdi
  802fe6:	00 00 00 
  802fe9:	b8 00 00 00 00       	mov    $0x0,%eax
  802fee:	49 b8 1e 39 80 00 00 	movabs $0x80391e,%r8
  802ff5:	00 00 00 
  802ff8:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802ffb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ffe:	48 63 d0             	movslq %eax,%rdx
  803001:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803005:	48 89 c6             	mov    %rax,%rsi
  803008:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80300f:	00 00 00 
  803012:	48 b8 05 11 80 00 00 	movabs $0x801105,%rax
  803019:	00 00 00 
  80301c:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80301e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803025:	00 00 00 
  803028:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80302b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80302e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803035:	00 00 00 
  803038:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80303b:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80303e:	bf 08 00 00 00       	mov    $0x8,%edi
  803043:	48 b8 56 2c 80 00 00 	movabs $0x802c56,%rax
  80304a:	00 00 00 
  80304d:	ff d0                	callq  *%rax
}
  80304f:	c9                   	leaveq 
  803050:	c3                   	retq   

0000000000803051 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803051:	55                   	push   %rbp
  803052:	48 89 e5             	mov    %rsp,%rbp
  803055:	48 83 ec 10          	sub    $0x10,%rsp
  803059:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80305c:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80305f:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803062:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803069:	00 00 00 
  80306c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80306f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803071:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803078:	00 00 00 
  80307b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80307e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803081:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803088:	00 00 00 
  80308b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80308e:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803091:	bf 09 00 00 00       	mov    $0x9,%edi
  803096:	48 b8 56 2c 80 00 00 	movabs $0x802c56,%rax
  80309d:	00 00 00 
  8030a0:	ff d0                	callq  *%rax
}
  8030a2:	c9                   	leaveq 
  8030a3:	c3                   	retq   

00000000008030a4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8030a4:	55                   	push   %rbp
  8030a5:	48 89 e5             	mov    %rsp,%rbp
  8030a8:	53                   	push   %rbx
  8030a9:	48 83 ec 38          	sub    $0x38,%rsp
  8030ad:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8030b1:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8030b5:	48 89 c7             	mov    %rax,%rdi
  8030b8:	48 b8 c4 1a 80 00 00 	movabs $0x801ac4,%rax
  8030bf:	00 00 00 
  8030c2:	ff d0                	callq  *%rax
  8030c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030cb:	0f 88 bf 01 00 00    	js     803290 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030d5:	ba 07 04 00 00       	mov    $0x407,%edx
  8030da:	48 89 c6             	mov    %rax,%rsi
  8030dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8030e2:	48 b8 0e 17 80 00 00 	movabs $0x80170e,%rax
  8030e9:	00 00 00 
  8030ec:	ff d0                	callq  *%rax
  8030ee:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030f5:	0f 88 95 01 00 00    	js     803290 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8030fb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8030ff:	48 89 c7             	mov    %rax,%rdi
  803102:	48 b8 c4 1a 80 00 00 	movabs $0x801ac4,%rax
  803109:	00 00 00 
  80310c:	ff d0                	callq  *%rax
  80310e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803111:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803115:	0f 88 5d 01 00 00    	js     803278 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80311b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80311f:	ba 07 04 00 00       	mov    $0x407,%edx
  803124:	48 89 c6             	mov    %rax,%rsi
  803127:	bf 00 00 00 00       	mov    $0x0,%edi
  80312c:	48 b8 0e 17 80 00 00 	movabs $0x80170e,%rax
  803133:	00 00 00 
  803136:	ff d0                	callq  *%rax
  803138:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80313b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80313f:	0f 88 33 01 00 00    	js     803278 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803145:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803149:	48 89 c7             	mov    %rax,%rdi
  80314c:	48 b8 99 1a 80 00 00 	movabs $0x801a99,%rax
  803153:	00 00 00 
  803156:	ff d0                	callq  *%rax
  803158:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80315c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803160:	ba 07 04 00 00       	mov    $0x407,%edx
  803165:	48 89 c6             	mov    %rax,%rsi
  803168:	bf 00 00 00 00       	mov    $0x0,%edi
  80316d:	48 b8 0e 17 80 00 00 	movabs $0x80170e,%rax
  803174:	00 00 00 
  803177:	ff d0                	callq  *%rax
  803179:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80317c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803180:	79 05                	jns    803187 <pipe+0xe3>
		goto err2;
  803182:	e9 d9 00 00 00       	jmpq   803260 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803187:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80318b:	48 89 c7             	mov    %rax,%rdi
  80318e:	48 b8 99 1a 80 00 00 	movabs $0x801a99,%rax
  803195:	00 00 00 
  803198:	ff d0                	callq  *%rax
  80319a:	48 89 c2             	mov    %rax,%rdx
  80319d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031a1:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8031a7:	48 89 d1             	mov    %rdx,%rcx
  8031aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8031af:	48 89 c6             	mov    %rax,%rsi
  8031b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8031b7:	48 b8 60 17 80 00 00 	movabs $0x801760,%rax
  8031be:	00 00 00 
  8031c1:	ff d0                	callq  *%rax
  8031c3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031ca:	79 1b                	jns    8031e7 <pipe+0x143>
		goto err3;
  8031cc:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8031cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031d1:	48 89 c6             	mov    %rax,%rsi
  8031d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8031d9:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  8031e0:	00 00 00 
  8031e3:	ff d0                	callq  *%rax
  8031e5:	eb 79                	jmp    803260 <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  8031e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031eb:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8031f2:	00 00 00 
  8031f5:	8b 12                	mov    (%rdx),%edx
  8031f7:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8031f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031fd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  803204:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803208:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80320f:	00 00 00 
  803212:	8b 12                	mov    (%rdx),%edx
  803214:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803216:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80321a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  803221:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803225:	48 89 c7             	mov    %rax,%rdi
  803228:	48 b8 76 1a 80 00 00 	movabs $0x801a76,%rax
  80322f:	00 00 00 
  803232:	ff d0                	callq  *%rax
  803234:	89 c2                	mov    %eax,%edx
  803236:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80323a:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80323c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803240:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803244:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803248:	48 89 c7             	mov    %rax,%rdi
  80324b:	48 b8 76 1a 80 00 00 	movabs $0x801a76,%rax
  803252:	00 00 00 
  803255:	ff d0                	callq  *%rax
  803257:	89 03                	mov    %eax,(%rbx)
	return 0;
  803259:	b8 00 00 00 00       	mov    $0x0,%eax
  80325e:	eb 33                	jmp    803293 <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  803260:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803264:	48 89 c6             	mov    %rax,%rsi
  803267:	bf 00 00 00 00       	mov    $0x0,%edi
  80326c:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  803273:	00 00 00 
  803276:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803278:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80327c:	48 89 c6             	mov    %rax,%rsi
  80327f:	bf 00 00 00 00       	mov    $0x0,%edi
  803284:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  80328b:	00 00 00 
  80328e:	ff d0                	callq  *%rax
err:
	return r;
  803290:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803293:	48 83 c4 38          	add    $0x38,%rsp
  803297:	5b                   	pop    %rbx
  803298:	5d                   	pop    %rbp
  803299:	c3                   	retq   

000000000080329a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80329a:	55                   	push   %rbp
  80329b:	48 89 e5             	mov    %rsp,%rbp
  80329e:	53                   	push   %rbx
  80329f:	48 83 ec 28          	sub    $0x28,%rsp
  8032a3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8032a7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8032ab:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8032b2:	00 00 00 
  8032b5:	48 8b 00             	mov    (%rax),%rax
  8032b8:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8032be:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8032c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032c5:	48 89 c7             	mov    %rax,%rdi
  8032c8:	48 b8 6f 3c 80 00 00 	movabs $0x803c6f,%rax
  8032cf:	00 00 00 
  8032d2:	ff d0                	callq  *%rax
  8032d4:	89 c3                	mov    %eax,%ebx
  8032d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032da:	48 89 c7             	mov    %rax,%rdi
  8032dd:	48 b8 6f 3c 80 00 00 	movabs $0x803c6f,%rax
  8032e4:	00 00 00 
  8032e7:	ff d0                	callq  *%rax
  8032e9:	39 c3                	cmp    %eax,%ebx
  8032eb:	0f 94 c0             	sete   %al
  8032ee:	0f b6 c0             	movzbl %al,%eax
  8032f1:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8032f4:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8032fb:	00 00 00 
  8032fe:	48 8b 00             	mov    (%rax),%rax
  803301:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803307:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80330a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80330d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803310:	75 05                	jne    803317 <_pipeisclosed+0x7d>
			return ret;
  803312:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803315:	eb 4a                	jmp    803361 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803317:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80331a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80331d:	74 3d                	je     80335c <_pipeisclosed+0xc2>
  80331f:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803323:	75 37                	jne    80335c <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803325:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80332c:	00 00 00 
  80332f:	48 8b 00             	mov    (%rax),%rax
  803332:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803338:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80333b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80333e:	89 c6                	mov    %eax,%esi
  803340:	48 bf bd 43 80 00 00 	movabs $0x8043bd,%rdi
  803347:	00 00 00 
  80334a:	b8 00 00 00 00       	mov    $0x0,%eax
  80334f:	49 b8 47 02 80 00 00 	movabs $0x800247,%r8
  803356:	00 00 00 
  803359:	41 ff d0             	callq  *%r8
	}
  80335c:	e9 4a ff ff ff       	jmpq   8032ab <_pipeisclosed+0x11>
}
  803361:	48 83 c4 28          	add    $0x28,%rsp
  803365:	5b                   	pop    %rbx
  803366:	5d                   	pop    %rbp
  803367:	c3                   	retq   

0000000000803368 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803368:	55                   	push   %rbp
  803369:	48 89 e5             	mov    %rsp,%rbp
  80336c:	48 83 ec 30          	sub    $0x30,%rsp
  803370:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803373:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803377:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80337a:	48 89 d6             	mov    %rdx,%rsi
  80337d:	89 c7                	mov    %eax,%edi
  80337f:	48 b8 5c 1b 80 00 00 	movabs $0x801b5c,%rax
  803386:	00 00 00 
  803389:	ff d0                	callq  *%rax
  80338b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80338e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803392:	79 05                	jns    803399 <pipeisclosed+0x31>
		return r;
  803394:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803397:	eb 31                	jmp    8033ca <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803399:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80339d:	48 89 c7             	mov    %rax,%rdi
  8033a0:	48 b8 99 1a 80 00 00 	movabs $0x801a99,%rax
  8033a7:	00 00 00 
  8033aa:	ff d0                	callq  *%rax
  8033ac:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8033b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033b8:	48 89 d6             	mov    %rdx,%rsi
  8033bb:	48 89 c7             	mov    %rax,%rdi
  8033be:	48 b8 9a 32 80 00 00 	movabs $0x80329a,%rax
  8033c5:	00 00 00 
  8033c8:	ff d0                	callq  *%rax
}
  8033ca:	c9                   	leaveq 
  8033cb:	c3                   	retq   

00000000008033cc <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8033cc:	55                   	push   %rbp
  8033cd:	48 89 e5             	mov    %rsp,%rbp
  8033d0:	48 83 ec 40          	sub    $0x40,%rsp
  8033d4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8033d8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8033dc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8033e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033e4:	48 89 c7             	mov    %rax,%rdi
  8033e7:	48 b8 99 1a 80 00 00 	movabs $0x801a99,%rax
  8033ee:	00 00 00 
  8033f1:	ff d0                	callq  *%rax
  8033f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8033f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033fb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8033ff:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803406:	00 
  803407:	e9 92 00 00 00       	jmpq   80349e <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80340c:	eb 41                	jmp    80344f <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80340e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803413:	74 09                	je     80341e <devpipe_read+0x52>
				return i;
  803415:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803419:	e9 92 00 00 00       	jmpq   8034b0 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80341e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803422:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803426:	48 89 d6             	mov    %rdx,%rsi
  803429:	48 89 c7             	mov    %rax,%rdi
  80342c:	48 b8 9a 32 80 00 00 	movabs $0x80329a,%rax
  803433:	00 00 00 
  803436:	ff d0                	callq  *%rax
  803438:	85 c0                	test   %eax,%eax
  80343a:	74 07                	je     803443 <devpipe_read+0x77>
				return 0;
  80343c:	b8 00 00 00 00       	mov    $0x0,%eax
  803441:	eb 6d                	jmp    8034b0 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803443:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  80344a:	00 00 00 
  80344d:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  80344f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803453:	8b 10                	mov    (%rax),%edx
  803455:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803459:	8b 40 04             	mov    0x4(%rax),%eax
  80345c:	39 c2                	cmp    %eax,%edx
  80345e:	74 ae                	je     80340e <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803460:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803464:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803468:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80346c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803470:	8b 00                	mov    (%rax),%eax
  803472:	99                   	cltd   
  803473:	c1 ea 1b             	shr    $0x1b,%edx
  803476:	01 d0                	add    %edx,%eax
  803478:	83 e0 1f             	and    $0x1f,%eax
  80347b:	29 d0                	sub    %edx,%eax
  80347d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803481:	48 98                	cltq   
  803483:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803488:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80348a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80348e:	8b 00                	mov    (%rax),%eax
  803490:	8d 50 01             	lea    0x1(%rax),%edx
  803493:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803497:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  803499:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80349e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034a2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8034a6:	0f 82 60 ff ff ff    	jb     80340c <devpipe_read+0x40>
	}
	return i;
  8034ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8034b0:	c9                   	leaveq 
  8034b1:	c3                   	retq   

00000000008034b2 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8034b2:	55                   	push   %rbp
  8034b3:	48 89 e5             	mov    %rsp,%rbp
  8034b6:	48 83 ec 40          	sub    $0x40,%rsp
  8034ba:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8034be:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8034c2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8034c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034ca:	48 89 c7             	mov    %rax,%rdi
  8034cd:	48 b8 99 1a 80 00 00 	movabs $0x801a99,%rax
  8034d4:	00 00 00 
  8034d7:	ff d0                	callq  *%rax
  8034d9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8034dd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034e1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8034e5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8034ec:	00 
  8034ed:	e9 91 00 00 00       	jmpq   803583 <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8034f2:	eb 31                	jmp    803525 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8034f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034fc:	48 89 d6             	mov    %rdx,%rsi
  8034ff:	48 89 c7             	mov    %rax,%rdi
  803502:	48 b8 9a 32 80 00 00 	movabs $0x80329a,%rax
  803509:	00 00 00 
  80350c:	ff d0                	callq  *%rax
  80350e:	85 c0                	test   %eax,%eax
  803510:	74 07                	je     803519 <devpipe_write+0x67>
				return 0;
  803512:	b8 00 00 00 00       	mov    $0x0,%eax
  803517:	eb 7c                	jmp    803595 <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803519:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  803520:	00 00 00 
  803523:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803525:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803529:	8b 40 04             	mov    0x4(%rax),%eax
  80352c:	48 63 d0             	movslq %eax,%rdx
  80352f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803533:	8b 00                	mov    (%rax),%eax
  803535:	48 98                	cltq   
  803537:	48 83 c0 20          	add    $0x20,%rax
  80353b:	48 39 c2             	cmp    %rax,%rdx
  80353e:	73 b4                	jae    8034f4 <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803540:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803544:	8b 40 04             	mov    0x4(%rax),%eax
  803547:	99                   	cltd   
  803548:	c1 ea 1b             	shr    $0x1b,%edx
  80354b:	01 d0                	add    %edx,%eax
  80354d:	83 e0 1f             	and    $0x1f,%eax
  803550:	29 d0                	sub    %edx,%eax
  803552:	89 c6                	mov    %eax,%esi
  803554:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803558:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80355c:	48 01 d0             	add    %rdx,%rax
  80355f:	0f b6 08             	movzbl (%rax),%ecx
  803562:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803566:	48 63 c6             	movslq %esi,%rax
  803569:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80356d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803571:	8b 40 04             	mov    0x4(%rax),%eax
  803574:	8d 50 01             	lea    0x1(%rax),%edx
  803577:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80357b:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  80357e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803583:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803587:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80358b:	0f 82 61 ff ff ff    	jb     8034f2 <devpipe_write+0x40>
	}

	return i;
  803591:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803595:	c9                   	leaveq 
  803596:	c3                   	retq   

0000000000803597 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803597:	55                   	push   %rbp
  803598:	48 89 e5             	mov    %rsp,%rbp
  80359b:	48 83 ec 20          	sub    $0x20,%rsp
  80359f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035a3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8035a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035ab:	48 89 c7             	mov    %rax,%rdi
  8035ae:	48 b8 99 1a 80 00 00 	movabs $0x801a99,%rax
  8035b5:	00 00 00 
  8035b8:	ff d0                	callq  *%rax
  8035ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8035be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035c2:	48 be d0 43 80 00 00 	movabs $0x8043d0,%rsi
  8035c9:	00 00 00 
  8035cc:	48 89 c7             	mov    %rax,%rdi
  8035cf:	48 b8 e1 0d 80 00 00 	movabs $0x800de1,%rax
  8035d6:	00 00 00 
  8035d9:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8035db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035df:	8b 50 04             	mov    0x4(%rax),%edx
  8035e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035e6:	8b 00                	mov    (%rax),%eax
  8035e8:	29 c2                	sub    %eax,%edx
  8035ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035ee:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8035f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035f8:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8035ff:	00 00 00 
	stat->st_dev = &devpipe;
  803602:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803606:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  80360d:	00 00 00 
  803610:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803617:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80361c:	c9                   	leaveq 
  80361d:	c3                   	retq   

000000000080361e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80361e:	55                   	push   %rbp
  80361f:	48 89 e5             	mov    %rsp,%rbp
  803622:	48 83 ec 10          	sub    $0x10,%rsp
  803626:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80362a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80362e:	48 89 c6             	mov    %rax,%rsi
  803631:	bf 00 00 00 00       	mov    $0x0,%edi
  803636:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  80363d:	00 00 00 
  803640:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803642:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803646:	48 89 c7             	mov    %rax,%rdi
  803649:	48 b8 99 1a 80 00 00 	movabs $0x801a99,%rax
  803650:	00 00 00 
  803653:	ff d0                	callq  *%rax
  803655:	48 89 c6             	mov    %rax,%rsi
  803658:	bf 00 00 00 00       	mov    $0x0,%edi
  80365d:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  803664:	00 00 00 
  803667:	ff d0                	callq  *%rax
}
  803669:	c9                   	leaveq 
  80366a:	c3                   	retq   

000000000080366b <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80366b:	55                   	push   %rbp
  80366c:	48 89 e5             	mov    %rsp,%rbp
  80366f:	48 83 ec 20          	sub    $0x20,%rsp
  803673:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803676:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803679:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80367c:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803680:	be 01 00 00 00       	mov    $0x1,%esi
  803685:	48 89 c7             	mov    %rax,%rdi
  803688:	48 b8 c8 15 80 00 00 	movabs $0x8015c8,%rax
  80368f:	00 00 00 
  803692:	ff d0                	callq  *%rax
}
  803694:	c9                   	leaveq 
  803695:	c3                   	retq   

0000000000803696 <getchar>:

int
getchar(void)
{
  803696:	55                   	push   %rbp
  803697:	48 89 e5             	mov    %rsp,%rbp
  80369a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80369e:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8036a2:	ba 01 00 00 00       	mov    $0x1,%edx
  8036a7:	48 89 c6             	mov    %rax,%rsi
  8036aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8036af:	48 b8 90 1f 80 00 00 	movabs $0x801f90,%rax
  8036b6:	00 00 00 
  8036b9:	ff d0                	callq  *%rax
  8036bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8036be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036c2:	79 05                	jns    8036c9 <getchar+0x33>
		return r;
  8036c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c7:	eb 14                	jmp    8036dd <getchar+0x47>
	if (r < 1)
  8036c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036cd:	7f 07                	jg     8036d6 <getchar+0x40>
		return -E_EOF;
  8036cf:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8036d4:	eb 07                	jmp    8036dd <getchar+0x47>
	return c;
  8036d6:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8036da:	0f b6 c0             	movzbl %al,%eax
}
  8036dd:	c9                   	leaveq 
  8036de:	c3                   	retq   

00000000008036df <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8036df:	55                   	push   %rbp
  8036e0:	48 89 e5             	mov    %rsp,%rbp
  8036e3:	48 83 ec 20          	sub    $0x20,%rsp
  8036e7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8036ea:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8036ee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036f1:	48 89 d6             	mov    %rdx,%rsi
  8036f4:	89 c7                	mov    %eax,%edi
  8036f6:	48 b8 5c 1b 80 00 00 	movabs $0x801b5c,%rax
  8036fd:	00 00 00 
  803700:	ff d0                	callq  *%rax
  803702:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803705:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803709:	79 05                	jns    803710 <iscons+0x31>
		return r;
  80370b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80370e:	eb 1a                	jmp    80372a <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803710:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803714:	8b 10                	mov    (%rax),%edx
  803716:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  80371d:	00 00 00 
  803720:	8b 00                	mov    (%rax),%eax
  803722:	39 c2                	cmp    %eax,%edx
  803724:	0f 94 c0             	sete   %al
  803727:	0f b6 c0             	movzbl %al,%eax
}
  80372a:	c9                   	leaveq 
  80372b:	c3                   	retq   

000000000080372c <opencons>:

int
opencons(void)
{
  80372c:	55                   	push   %rbp
  80372d:	48 89 e5             	mov    %rsp,%rbp
  803730:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803734:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803738:	48 89 c7             	mov    %rax,%rdi
  80373b:	48 b8 c4 1a 80 00 00 	movabs $0x801ac4,%rax
  803742:	00 00 00 
  803745:	ff d0                	callq  *%rax
  803747:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80374a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80374e:	79 05                	jns    803755 <opencons+0x29>
		return r;
  803750:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803753:	eb 5b                	jmp    8037b0 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803755:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803759:	ba 07 04 00 00       	mov    $0x407,%edx
  80375e:	48 89 c6             	mov    %rax,%rsi
  803761:	bf 00 00 00 00       	mov    $0x0,%edi
  803766:	48 b8 0e 17 80 00 00 	movabs $0x80170e,%rax
  80376d:	00 00 00 
  803770:	ff d0                	callq  *%rax
  803772:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803775:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803779:	79 05                	jns    803780 <opencons+0x54>
		return r;
  80377b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80377e:	eb 30                	jmp    8037b0 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803780:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803784:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  80378b:	00 00 00 
  80378e:	8b 12                	mov    (%rdx),%edx
  803790:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803792:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803796:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80379d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037a1:	48 89 c7             	mov    %rax,%rdi
  8037a4:	48 b8 76 1a 80 00 00 	movabs $0x801a76,%rax
  8037ab:	00 00 00 
  8037ae:	ff d0                	callq  *%rax
}
  8037b0:	c9                   	leaveq 
  8037b1:	c3                   	retq   

00000000008037b2 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8037b2:	55                   	push   %rbp
  8037b3:	48 89 e5             	mov    %rsp,%rbp
  8037b6:	48 83 ec 30          	sub    $0x30,%rsp
  8037ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8037be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8037c6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8037cb:	75 07                	jne    8037d4 <devcons_read+0x22>
		return 0;
  8037cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8037d2:	eb 4b                	jmp    80381f <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8037d4:	eb 0c                	jmp    8037e2 <devcons_read+0x30>
		sys_yield();
  8037d6:	48 b8 d2 16 80 00 00 	movabs $0x8016d2,%rax
  8037dd:	00 00 00 
  8037e0:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  8037e2:	48 b8 14 16 80 00 00 	movabs $0x801614,%rax
  8037e9:	00 00 00 
  8037ec:	ff d0                	callq  *%rax
  8037ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037f5:	74 df                	je     8037d6 <devcons_read+0x24>
	if (c < 0)
  8037f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037fb:	79 05                	jns    803802 <devcons_read+0x50>
		return c;
  8037fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803800:	eb 1d                	jmp    80381f <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803802:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803806:	75 07                	jne    80380f <devcons_read+0x5d>
		return 0;
  803808:	b8 00 00 00 00       	mov    $0x0,%eax
  80380d:	eb 10                	jmp    80381f <devcons_read+0x6d>
	*(char*)vbuf = c;
  80380f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803812:	89 c2                	mov    %eax,%edx
  803814:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803818:	88 10                	mov    %dl,(%rax)
	return 1;
  80381a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80381f:	c9                   	leaveq 
  803820:	c3                   	retq   

0000000000803821 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803821:	55                   	push   %rbp
  803822:	48 89 e5             	mov    %rsp,%rbp
  803825:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80382c:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803833:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80383a:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803841:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803848:	eb 76                	jmp    8038c0 <devcons_write+0x9f>
		m = n - tot;
  80384a:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803851:	89 c2                	mov    %eax,%edx
  803853:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803856:	29 c2                	sub    %eax,%edx
  803858:	89 d0                	mov    %edx,%eax
  80385a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80385d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803860:	83 f8 7f             	cmp    $0x7f,%eax
  803863:	76 07                	jbe    80386c <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803865:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80386c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80386f:	48 63 d0             	movslq %eax,%rdx
  803872:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803875:	48 63 c8             	movslq %eax,%rcx
  803878:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80387f:	48 01 c1             	add    %rax,%rcx
  803882:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803889:	48 89 ce             	mov    %rcx,%rsi
  80388c:	48 89 c7             	mov    %rax,%rdi
  80388f:	48 b8 05 11 80 00 00 	movabs $0x801105,%rax
  803896:	00 00 00 
  803899:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80389b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80389e:	48 63 d0             	movslq %eax,%rdx
  8038a1:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8038a8:	48 89 d6             	mov    %rdx,%rsi
  8038ab:	48 89 c7             	mov    %rax,%rdi
  8038ae:	48 b8 c8 15 80 00 00 	movabs $0x8015c8,%rax
  8038b5:	00 00 00 
  8038b8:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  8038ba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038bd:	01 45 fc             	add    %eax,-0x4(%rbp)
  8038c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038c3:	48 98                	cltq   
  8038c5:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8038cc:	0f 82 78 ff ff ff    	jb     80384a <devcons_write+0x29>
	}
	return tot;
  8038d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8038d5:	c9                   	leaveq 
  8038d6:	c3                   	retq   

00000000008038d7 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8038d7:	55                   	push   %rbp
  8038d8:	48 89 e5             	mov    %rsp,%rbp
  8038db:	48 83 ec 08          	sub    $0x8,%rsp
  8038df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8038e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038e8:	c9                   	leaveq 
  8038e9:	c3                   	retq   

00000000008038ea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8038ea:	55                   	push   %rbp
  8038eb:	48 89 e5             	mov    %rsp,%rbp
  8038ee:	48 83 ec 10          	sub    $0x10,%rsp
  8038f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8038f6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8038fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038fe:	48 be dc 43 80 00 00 	movabs $0x8043dc,%rsi
  803905:	00 00 00 
  803908:	48 89 c7             	mov    %rax,%rdi
  80390b:	48 b8 e1 0d 80 00 00 	movabs $0x800de1,%rax
  803912:	00 00 00 
  803915:	ff d0                	callq  *%rax
	return 0;
  803917:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80391c:	c9                   	leaveq 
  80391d:	c3                   	retq   

000000000080391e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80391e:	55                   	push   %rbp
  80391f:	48 89 e5             	mov    %rsp,%rbp
  803922:	53                   	push   %rbx
  803923:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80392a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803931:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803937:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80393e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803945:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80394c:	84 c0                	test   %al,%al
  80394e:	74 23                	je     803973 <_panic+0x55>
  803950:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803957:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80395b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80395f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803963:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803967:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80396b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80396f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803973:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80397a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803981:	00 00 00 
  803984:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80398b:	00 00 00 
  80398e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803992:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803999:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8039a0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8039a7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8039ae:	00 00 00 
  8039b1:	48 8b 18             	mov    (%rax),%rbx
  8039b4:	48 b8 96 16 80 00 00 	movabs $0x801696,%rax
  8039bb:	00 00 00 
  8039be:	ff d0                	callq  *%rax
  8039c0:	89 c6                	mov    %eax,%esi
  8039c2:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8039c8:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8039cf:	41 89 d0             	mov    %edx,%r8d
  8039d2:	48 89 c1             	mov    %rax,%rcx
  8039d5:	48 89 da             	mov    %rbx,%rdx
  8039d8:	48 bf e8 43 80 00 00 	movabs $0x8043e8,%rdi
  8039df:	00 00 00 
  8039e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8039e7:	49 b9 47 02 80 00 00 	movabs $0x800247,%r9
  8039ee:	00 00 00 
  8039f1:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8039f4:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8039fb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803a02:	48 89 d6             	mov    %rdx,%rsi
  803a05:	48 89 c7             	mov    %rax,%rdi
  803a08:	48 b8 9b 01 80 00 00 	movabs $0x80019b,%rax
  803a0f:	00 00 00 
  803a12:	ff d0                	callq  *%rax
	cprintf("\n");
  803a14:	48 bf 0b 44 80 00 00 	movabs $0x80440b,%rdi
  803a1b:	00 00 00 
  803a1e:	b8 00 00 00 00       	mov    $0x0,%eax
  803a23:	48 ba 47 02 80 00 00 	movabs $0x800247,%rdx
  803a2a:	00 00 00 
  803a2d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803a2f:	cc                   	int3   
  803a30:	eb fd                	jmp    803a2f <_panic+0x111>

0000000000803a32 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803a32:	55                   	push   %rbp
  803a33:	48 89 e5             	mov    %rsp,%rbp
  803a36:	48 83 ec 20          	sub    $0x20,%rsp
  803a3a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a3e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a42:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  803a46:	48 ba 10 44 80 00 00 	movabs $0x804410,%rdx
  803a4d:	00 00 00 
  803a50:	be 1d 00 00 00       	mov    $0x1d,%esi
  803a55:	48 bf 29 44 80 00 00 	movabs $0x804429,%rdi
  803a5c:	00 00 00 
  803a5f:	b8 00 00 00 00       	mov    $0x0,%eax
  803a64:	48 b9 1e 39 80 00 00 	movabs $0x80391e,%rcx
  803a6b:	00 00 00 
  803a6e:	ff d1                	callq  *%rcx

0000000000803a70 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803a70:	55                   	push   %rbp
  803a71:	48 89 e5             	mov    %rsp,%rbp
  803a74:	48 83 ec 20          	sub    $0x20,%rsp
  803a78:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a7b:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803a7e:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  803a82:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  803a85:	48 ba 33 44 80 00 00 	movabs $0x804433,%rdx
  803a8c:	00 00 00 
  803a8f:	be 2d 00 00 00       	mov    $0x2d,%esi
  803a94:	48 bf 29 44 80 00 00 	movabs $0x804429,%rdi
  803a9b:	00 00 00 
  803a9e:	b8 00 00 00 00       	mov    $0x0,%eax
  803aa3:	48 b9 1e 39 80 00 00 	movabs $0x80391e,%rcx
  803aaa:	00 00 00 
  803aad:	ff d1                	callq  *%rcx

0000000000803aaf <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803aaf:	55                   	push   %rbp
  803ab0:	48 89 e5             	mov    %rsp,%rbp
  803ab3:	53                   	push   %rbx
  803ab4:	48 83 ec 48          	sub    $0x48,%rsp
  803ab8:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  803abc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  803ac3:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  803aca:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  803acf:	75 0e                	jne    803adf <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  803ad1:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803ad8:	00 00 00 
  803adb:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  803adf:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803ae3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  803ae7:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803aee:	00 
	a3 = (uint64_t) 0;
  803aef:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  803af6:	00 
	a4 = (uint64_t) 0;
  803af7:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803afe:	00 
	a5 = 0;
  803aff:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  803b06:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  803b07:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803b0a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803b0e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803b12:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  803b16:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  803b1a:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  803b1e:	4c 89 c3             	mov    %r8,%rbx
  803b21:	0f 01 c1             	vmcall 
  803b24:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  803b27:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b2b:	7e 36                	jle    803b63 <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  803b2d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b30:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803b33:	41 89 d0             	mov    %edx,%r8d
  803b36:	89 c1                	mov    %eax,%ecx
  803b38:	48 ba 50 44 80 00 00 	movabs $0x804450,%rdx
  803b3f:	00 00 00 
  803b42:	be 54 00 00 00       	mov    $0x54,%esi
  803b47:	48 bf 29 44 80 00 00 	movabs $0x804429,%rdi
  803b4e:	00 00 00 
  803b51:	b8 00 00 00 00       	mov    $0x0,%eax
  803b56:	49 b9 1e 39 80 00 00 	movabs $0x80391e,%r9
  803b5d:	00 00 00 
  803b60:	41 ff d1             	callq  *%r9
	return ret;
  803b63:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803b66:	48 83 c4 48          	add    $0x48,%rsp
  803b6a:	5b                   	pop    %rbx
  803b6b:	5d                   	pop    %rbp
  803b6c:	c3                   	retq   

0000000000803b6d <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803b6d:	55                   	push   %rbp
  803b6e:	48 89 e5             	mov    %rsp,%rbp
  803b71:	53                   	push   %rbx
  803b72:	48 83 ec 58          	sub    $0x58,%rsp
  803b76:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  803b79:	89 75 b0             	mov    %esi,-0x50(%rbp)
  803b7c:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  803b80:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  803b83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  803b8a:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  803b91:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  803b96:	75 0e                	jne    803ba6 <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  803b98:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803b9f:	00 00 00 
  803ba2:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  803ba6:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  803ba9:	48 98                	cltq   
  803bab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  803baf:	8b 45 b0             	mov    -0x50(%rbp),%eax
  803bb2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  803bb6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803bba:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  803bbe:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  803bc1:	48 98                	cltq   
  803bc3:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  803bc7:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803bce:	00 

	int r = -E_IPC_NOT_RECV;
  803bcf:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  803bd6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803bd9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803bdd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803be1:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  803be5:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803be9:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  803bed:	4c 89 c3             	mov    %r8,%rbx
  803bf0:	0f 01 c1             	vmcall 
  803bf3:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  803bf6:	48 83 c4 58          	add    $0x58,%rsp
  803bfa:	5b                   	pop    %rbx
  803bfb:	5d                   	pop    %rbp
  803bfc:	c3                   	retq   

0000000000803bfd <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803bfd:	55                   	push   %rbp
  803bfe:	48 89 e5             	mov    %rsp,%rbp
  803c01:	48 83 ec 18          	sub    $0x18,%rsp
  803c05:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803c08:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c0f:	eb 4e                	jmp    803c5f <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  803c11:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803c18:	00 00 00 
  803c1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c1e:	48 98                	cltq   
  803c20:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803c27:	48 01 d0             	add    %rdx,%rax
  803c2a:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803c30:	8b 00                	mov    (%rax),%eax
  803c32:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803c35:	75 24                	jne    803c5b <ipc_find_env+0x5e>
			return envs[i].env_id;
  803c37:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803c3e:	00 00 00 
  803c41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c44:	48 98                	cltq   
  803c46:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803c4d:	48 01 d0             	add    %rdx,%rax
  803c50:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803c56:	8b 40 08             	mov    0x8(%rax),%eax
  803c59:	eb 12                	jmp    803c6d <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  803c5b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803c5f:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803c66:	7e a9                	jle    803c11 <ipc_find_env+0x14>
	}
	return 0;
  803c68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c6d:	c9                   	leaveq 
  803c6e:	c3                   	retq   

0000000000803c6f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803c6f:	55                   	push   %rbp
  803c70:	48 89 e5             	mov    %rsp,%rbp
  803c73:	48 83 ec 18          	sub    $0x18,%rsp
  803c77:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803c7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c7f:	48 c1 e8 15          	shr    $0x15,%rax
  803c83:	48 89 c2             	mov    %rax,%rdx
  803c86:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c8d:	01 00 00 
  803c90:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c94:	83 e0 01             	and    $0x1,%eax
  803c97:	48 85 c0             	test   %rax,%rax
  803c9a:	75 07                	jne    803ca3 <pageref+0x34>
		return 0;
  803c9c:	b8 00 00 00 00       	mov    $0x0,%eax
  803ca1:	eb 53                	jmp    803cf6 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803ca3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ca7:	48 c1 e8 0c          	shr    $0xc,%rax
  803cab:	48 89 c2             	mov    %rax,%rdx
  803cae:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803cb5:	01 00 00 
  803cb8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803cbc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803cc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cc4:	83 e0 01             	and    $0x1,%eax
  803cc7:	48 85 c0             	test   %rax,%rax
  803cca:	75 07                	jne    803cd3 <pageref+0x64>
		return 0;
  803ccc:	b8 00 00 00 00       	mov    $0x0,%eax
  803cd1:	eb 23                	jmp    803cf6 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803cd3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cd7:	48 c1 e8 0c          	shr    $0xc,%rax
  803cdb:	48 89 c2             	mov    %rax,%rdx
  803cde:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803ce5:	00 00 00 
  803ce8:	48 c1 e2 04          	shl    $0x4,%rdx
  803cec:	48 01 d0             	add    %rdx,%rax
  803cef:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803cf3:	0f b7 c0             	movzwl %ax,%eax
}
  803cf6:	c9                   	leaveq 
  803cf7:	c3                   	retq   
