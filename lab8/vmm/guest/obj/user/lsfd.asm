
vmm/guest/obj/user/lsfd:     formato del fichero elf64-x86-64


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
  80003c:	e8 81 01 00 00       	callq  8001c2 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
	cprintf("usage: lsfd [-1]\n");
  800047:	48 bf 00 44 80 00 00 	movabs $0x804400,%rdi
  80004e:	00 00 00 
  800051:	b8 00 00 00 00       	mov    $0x0,%eax
  800056:	48 ba 6a 03 80 00 00 	movabs $0x80036a,%rdx
  80005d:	00 00 00 
  800060:	ff d2                	callq  *%rdx
	exit();
  800062:	48 b8 22 02 80 00 00 	movabs $0x800222,%rax
  800069:	00 00 00 
  80006c:	ff d0                	callq  *%rax
}
  80006e:	5d                   	pop    %rbp
  80006f:	c3                   	retq   

0000000000800070 <umain>:

void
umain(int argc, char **argv)
{
  800070:	55                   	push   %rbp
  800071:	48 89 e5             	mov    %rsp,%rbp
  800074:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  80007b:	89 bd 3c ff ff ff    	mov    %edi,-0xc4(%rbp)
  800081:	48 89 b5 30 ff ff ff 	mov    %rsi,-0xd0(%rbp)
	int i, usefprint = 0;
  800088:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  80008f:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  800096:	48 8b 8d 30 ff ff ff 	mov    -0xd0(%rbp),%rcx
  80009d:	48 8d 85 3c ff ff ff 	lea    -0xc4(%rbp),%rax
  8000a4:	48 89 ce             	mov    %rcx,%rsi
  8000a7:	48 89 c7             	mov    %rax,%rdi
  8000aa:	48 b8 99 1b 80 00 00 	movabs $0x801b99,%rax
  8000b1:	00 00 00 
  8000b4:	ff d0                	callq  *%rax
	while ((i = argnext(&args)) >= 0)
  8000b6:	eb 1b                	jmp    8000d3 <umain+0x63>
		if (i == '1')
  8000b8:	83 7d fc 31          	cmpl   $0x31,-0x4(%rbp)
  8000bc:	75 09                	jne    8000c7 <umain+0x57>
			usefprint = 1;
  8000be:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
  8000c5:	eb 0c                	jmp    8000d3 <umain+0x63>
		else
			usage();
  8000c7:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000ce:	00 00 00 
  8000d1:	ff d0                	callq  *%rax
	while ((i = argnext(&args)) >= 0)
  8000d3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8000da:	48 89 c7             	mov    %rax,%rdi
  8000dd:	48 b8 fd 1b 80 00 00 	movabs $0x801bfd,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
  8000e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000f0:	79 c6                	jns    8000b8 <umain+0x48>

	for (i = 0; i < 32; i++)
  8000f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000f9:	e9 b8 00 00 00       	jmpq   8001b6 <umain+0x146>
		if (fstat(i, &st) >= 0) {
  8000fe:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800105:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800108:	48 89 d6             	mov    %rdx,%rsi
  80010b:	89 c7                	mov    %eax,%edi
  80010d:	48 b8 c1 26 80 00 00 	movabs $0x8026c1,%rax
  800114:	00 00 00 
  800117:	ff d0                	callq  *%rax
  800119:	85 c0                	test   %eax,%eax
  80011b:	0f 88 91 00 00 00    	js     8001b2 <umain+0x142>
			if (usefprint)
  800121:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800125:	74 4f                	je     800176 <umain+0x106>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
  800127:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  80012b:	48 8b 48 08          	mov    0x8(%rax),%rcx
  80012f:	8b 7d e0             	mov    -0x20(%rbp),%edi
  800132:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800135:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  80013c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80013f:	48 83 ec 08          	sub    $0x8,%rsp
  800143:	51                   	push   %rcx
  800144:	41 89 f9             	mov    %edi,%r9d
  800147:	41 89 f0             	mov    %esi,%r8d
  80014a:	48 89 d1             	mov    %rdx,%rcx
  80014d:	89 c2                	mov    %eax,%edx
  80014f:	48 be 18 44 80 00 00 	movabs $0x804418,%rsi
  800156:	00 00 00 
  800159:	bf 01 00 00 00       	mov    $0x1,%edi
  80015e:	b8 00 00 00 00       	mov    $0x0,%eax
  800163:	49 ba 2e 2e 80 00 00 	movabs $0x802e2e,%r10
  80016a:	00 00 00 
  80016d:	41 ff d2             	callq  *%r10
  800170:	48 83 c4 10          	add    $0x10,%rsp
  800174:	eb 3c                	jmp    8001b2 <umain+0x142>
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
  800176:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  80017a:	48 8b 78 08          	mov    0x8(%rax),%rdi
  80017e:	8b 75 e0             	mov    -0x20(%rbp),%esi
  800181:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800184:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  80018b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80018e:	49 89 f9             	mov    %rdi,%r9
  800191:	41 89 f0             	mov    %esi,%r8d
  800194:	89 c6                	mov    %eax,%esi
  800196:	48 bf 18 44 80 00 00 	movabs $0x804418,%rdi
  80019d:	00 00 00 
  8001a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a5:	49 ba 6a 03 80 00 00 	movabs $0x80036a,%r10
  8001ac:	00 00 00 
  8001af:	41 ff d2             	callq  *%r10
	for (i = 0; i < 32; i++)
  8001b2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8001b6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8001ba:	0f 8e 3e ff ff ff    	jle    8000fe <umain+0x8e>
		}
}
  8001c0:	c9                   	leaveq 
  8001c1:	c3                   	retq   

00000000008001c2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001c2:	55                   	push   %rbp
  8001c3:	48 89 e5             	mov    %rsp,%rbp
  8001c6:	48 83 ec 10          	sub    $0x10,%rsp
  8001ca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001cd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8001d1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8001d8:	00 00 00 
  8001db:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001e6:	7e 14                	jle    8001fc <libmain+0x3a>
		binaryname = argv[0];
  8001e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ec:	48 8b 10             	mov    (%rax),%rdx
  8001ef:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001f6:	00 00 00 
  8001f9:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800200:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800203:	48 89 d6             	mov    %rdx,%rsi
  800206:	89 c7                	mov    %eax,%edi
  800208:	48 b8 70 00 80 00 00 	movabs $0x800070,%rax
  80020f:	00 00 00 
  800212:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800214:	48 b8 22 02 80 00 00 	movabs $0x800222,%rax
  80021b:	00 00 00 
  80021e:	ff d0                	callq  *%rax
}
  800220:	c9                   	leaveq 
  800221:	c3                   	retq   

0000000000800222 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800222:	55                   	push   %rbp
  800223:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800226:	48 b8 bb 21 80 00 00 	movabs $0x8021bb,%rax
  80022d:	00 00 00 
  800230:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800232:	bf 00 00 00 00       	mov    $0x0,%edi
  800237:	48 b8 73 17 80 00 00 	movabs $0x801773,%rax
  80023e:	00 00 00 
  800241:	ff d0                	callq  *%rax
}
  800243:	5d                   	pop    %rbp
  800244:	c3                   	retq   

0000000000800245 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800245:	55                   	push   %rbp
  800246:	48 89 e5             	mov    %rsp,%rbp
  800249:	48 83 ec 10          	sub    $0x10,%rsp
  80024d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800250:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800254:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800258:	8b 00                	mov    (%rax),%eax
  80025a:	8d 48 01             	lea    0x1(%rax),%ecx
  80025d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800261:	89 0a                	mov    %ecx,(%rdx)
  800263:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800266:	89 d1                	mov    %edx,%ecx
  800268:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80026c:	48 98                	cltq   
  80026e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800272:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800276:	8b 00                	mov    (%rax),%eax
  800278:	3d ff 00 00 00       	cmp    $0xff,%eax
  80027d:	75 2c                	jne    8002ab <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80027f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800283:	8b 00                	mov    (%rax),%eax
  800285:	48 98                	cltq   
  800287:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80028b:	48 83 c2 08          	add    $0x8,%rdx
  80028f:	48 89 c6             	mov    %rax,%rsi
  800292:	48 89 d7             	mov    %rdx,%rdi
  800295:	48 b8 eb 16 80 00 00 	movabs $0x8016eb,%rax
  80029c:	00 00 00 
  80029f:	ff d0                	callq  *%rax
        b->idx = 0;
  8002a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002a5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8002ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002af:	8b 40 04             	mov    0x4(%rax),%eax
  8002b2:	8d 50 01             	lea    0x1(%rax),%edx
  8002b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002b9:	89 50 04             	mov    %edx,0x4(%rax)
}
  8002bc:	c9                   	leaveq 
  8002bd:	c3                   	retq   

00000000008002be <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8002be:	55                   	push   %rbp
  8002bf:	48 89 e5             	mov    %rsp,%rbp
  8002c2:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8002c9:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8002d0:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8002d7:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8002de:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8002e5:	48 8b 0a             	mov    (%rdx),%rcx
  8002e8:	48 89 08             	mov    %rcx,(%rax)
  8002eb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002ef:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002f3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002f7:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8002fb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800302:	00 00 00 
    b.cnt = 0;
  800305:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80030c:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80030f:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800316:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80031d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800324:	48 89 c6             	mov    %rax,%rsi
  800327:	48 bf 45 02 80 00 00 	movabs $0x800245,%rdi
  80032e:	00 00 00 
  800331:	48 b8 09 07 80 00 00 	movabs $0x800709,%rax
  800338:	00 00 00 
  80033b:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80033d:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800343:	48 98                	cltq   
  800345:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80034c:	48 83 c2 08          	add    $0x8,%rdx
  800350:	48 89 c6             	mov    %rax,%rsi
  800353:	48 89 d7             	mov    %rdx,%rdi
  800356:	48 b8 eb 16 80 00 00 	movabs $0x8016eb,%rax
  80035d:	00 00 00 
  800360:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800362:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800368:	c9                   	leaveq 
  800369:	c3                   	retq   

000000000080036a <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80036a:	55                   	push   %rbp
  80036b:	48 89 e5             	mov    %rsp,%rbp
  80036e:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800375:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80037c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800383:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80038a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800391:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800398:	84 c0                	test   %al,%al
  80039a:	74 20                	je     8003bc <cprintf+0x52>
  80039c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8003a0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8003a4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8003a8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8003ac:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8003b0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8003b4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8003b8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8003bc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8003c3:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8003ca:	00 00 00 
  8003cd:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8003d4:	00 00 00 
  8003d7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003db:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8003e2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8003e9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8003f0:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003f7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003fe:	48 8b 0a             	mov    (%rdx),%rcx
  800401:	48 89 08             	mov    %rcx,(%rax)
  800404:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800408:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80040c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800410:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800414:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80041b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800422:	48 89 d6             	mov    %rdx,%rsi
  800425:	48 89 c7             	mov    %rax,%rdi
  800428:	48 b8 be 02 80 00 00 	movabs $0x8002be,%rax
  80042f:	00 00 00 
  800432:	ff d0                	callq  *%rax
  800434:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80043a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800440:	c9                   	leaveq 
  800441:	c3                   	retq   

0000000000800442 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800442:	55                   	push   %rbp
  800443:	48 89 e5             	mov    %rsp,%rbp
  800446:	48 83 ec 30          	sub    $0x30,%rsp
  80044a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80044e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800452:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800456:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800459:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80045d:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800461:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800464:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800468:	77 42                	ja     8004ac <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80046a:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80046d:	8d 78 ff             	lea    -0x1(%rax),%edi
  800470:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800473:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800477:	ba 00 00 00 00       	mov    $0x0,%edx
  80047c:	48 f7 f6             	div    %rsi
  80047f:	49 89 c2             	mov    %rax,%r10
  800482:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800485:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800488:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80048c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800490:	41 89 c9             	mov    %ecx,%r9d
  800493:	41 89 f8             	mov    %edi,%r8d
  800496:	89 d1                	mov    %edx,%ecx
  800498:	4c 89 d2             	mov    %r10,%rdx
  80049b:	48 89 c7             	mov    %rax,%rdi
  80049e:	48 b8 42 04 80 00 00 	movabs $0x800442,%rax
  8004a5:	00 00 00 
  8004a8:	ff d0                	callq  *%rax
  8004aa:	eb 1e                	jmp    8004ca <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004ac:	eb 12                	jmp    8004c0 <printnum+0x7e>
			putch(padc, putdat);
  8004ae:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8004b2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8004b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004b9:	48 89 ce             	mov    %rcx,%rsi
  8004bc:	89 d7                	mov    %edx,%edi
  8004be:	ff d0                	callq  *%rax
		while (--width > 0)
  8004c0:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8004c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8004c8:	7f e4                	jg     8004ae <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004ca:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8004cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d6:	48 f7 f1             	div    %rcx
  8004d9:	48 b8 70 46 80 00 00 	movabs $0x804670,%rax
  8004e0:	00 00 00 
  8004e3:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8004e7:	0f be d0             	movsbl %al,%edx
  8004ea:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8004ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004f2:	48 89 ce             	mov    %rcx,%rsi
  8004f5:	89 d7                	mov    %edx,%edi
  8004f7:	ff d0                	callq  *%rax
}
  8004f9:	c9                   	leaveq 
  8004fa:	c3                   	retq   

00000000008004fb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004fb:	55                   	push   %rbp
  8004fc:	48 89 e5             	mov    %rsp,%rbp
  8004ff:	48 83 ec 20          	sub    $0x20,%rsp
  800503:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800507:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80050a:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80050e:	7e 4f                	jle    80055f <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800510:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800514:	8b 00                	mov    (%rax),%eax
  800516:	83 f8 30             	cmp    $0x30,%eax
  800519:	73 24                	jae    80053f <getuint+0x44>
  80051b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80051f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800523:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800527:	8b 00                	mov    (%rax),%eax
  800529:	89 c0                	mov    %eax,%eax
  80052b:	48 01 d0             	add    %rdx,%rax
  80052e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800532:	8b 12                	mov    (%rdx),%edx
  800534:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800537:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80053b:	89 0a                	mov    %ecx,(%rdx)
  80053d:	eb 14                	jmp    800553 <getuint+0x58>
  80053f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800543:	48 8b 40 08          	mov    0x8(%rax),%rax
  800547:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80054b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80054f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800553:	48 8b 00             	mov    (%rax),%rax
  800556:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80055a:	e9 9d 00 00 00       	jmpq   8005fc <getuint+0x101>
	else if (lflag)
  80055f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800563:	74 4c                	je     8005b1 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800565:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800569:	8b 00                	mov    (%rax),%eax
  80056b:	83 f8 30             	cmp    $0x30,%eax
  80056e:	73 24                	jae    800594 <getuint+0x99>
  800570:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800574:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800578:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057c:	8b 00                	mov    (%rax),%eax
  80057e:	89 c0                	mov    %eax,%eax
  800580:	48 01 d0             	add    %rdx,%rax
  800583:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800587:	8b 12                	mov    (%rdx),%edx
  800589:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80058c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800590:	89 0a                	mov    %ecx,(%rdx)
  800592:	eb 14                	jmp    8005a8 <getuint+0xad>
  800594:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800598:	48 8b 40 08          	mov    0x8(%rax),%rax
  80059c:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8005a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005a8:	48 8b 00             	mov    (%rax),%rax
  8005ab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005af:	eb 4b                	jmp    8005fc <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8005b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b5:	8b 00                	mov    (%rax),%eax
  8005b7:	83 f8 30             	cmp    $0x30,%eax
  8005ba:	73 24                	jae    8005e0 <getuint+0xe5>
  8005bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c8:	8b 00                	mov    (%rax),%eax
  8005ca:	89 c0                	mov    %eax,%eax
  8005cc:	48 01 d0             	add    %rdx,%rax
  8005cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d3:	8b 12                	mov    (%rdx),%edx
  8005d5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005dc:	89 0a                	mov    %ecx,(%rdx)
  8005de:	eb 14                	jmp    8005f4 <getuint+0xf9>
  8005e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e4:	48 8b 40 08          	mov    0x8(%rax),%rax
  8005e8:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8005ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005f4:	8b 00                	mov    (%rax),%eax
  8005f6:	89 c0                	mov    %eax,%eax
  8005f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800600:	c9                   	leaveq 
  800601:	c3                   	retq   

0000000000800602 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800602:	55                   	push   %rbp
  800603:	48 89 e5             	mov    %rsp,%rbp
  800606:	48 83 ec 20          	sub    $0x20,%rsp
  80060a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80060e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800611:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800615:	7e 4f                	jle    800666 <getint+0x64>
		x=va_arg(*ap, long long);
  800617:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061b:	8b 00                	mov    (%rax),%eax
  80061d:	83 f8 30             	cmp    $0x30,%eax
  800620:	73 24                	jae    800646 <getint+0x44>
  800622:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800626:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80062a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062e:	8b 00                	mov    (%rax),%eax
  800630:	89 c0                	mov    %eax,%eax
  800632:	48 01 d0             	add    %rdx,%rax
  800635:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800639:	8b 12                	mov    (%rdx),%edx
  80063b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80063e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800642:	89 0a                	mov    %ecx,(%rdx)
  800644:	eb 14                	jmp    80065a <getint+0x58>
  800646:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80064e:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800652:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800656:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80065a:	48 8b 00             	mov    (%rax),%rax
  80065d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800661:	e9 9d 00 00 00       	jmpq   800703 <getint+0x101>
	else if (lflag)
  800666:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80066a:	74 4c                	je     8006b8 <getint+0xb6>
		x=va_arg(*ap, long);
  80066c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800670:	8b 00                	mov    (%rax),%eax
  800672:	83 f8 30             	cmp    $0x30,%eax
  800675:	73 24                	jae    80069b <getint+0x99>
  800677:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80067f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800683:	8b 00                	mov    (%rax),%eax
  800685:	89 c0                	mov    %eax,%eax
  800687:	48 01 d0             	add    %rdx,%rax
  80068a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068e:	8b 12                	mov    (%rdx),%edx
  800690:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800693:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800697:	89 0a                	mov    %ecx,(%rdx)
  800699:	eb 14                	jmp    8006af <getint+0xad>
  80069b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069f:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006a3:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ab:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006af:	48 8b 00             	mov    (%rax),%rax
  8006b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006b6:	eb 4b                	jmp    800703 <getint+0x101>
	else
		x=va_arg(*ap, int);
  8006b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bc:	8b 00                	mov    (%rax),%eax
  8006be:	83 f8 30             	cmp    $0x30,%eax
  8006c1:	73 24                	jae    8006e7 <getint+0xe5>
  8006c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cf:	8b 00                	mov    (%rax),%eax
  8006d1:	89 c0                	mov    %eax,%eax
  8006d3:	48 01 d0             	add    %rdx,%rax
  8006d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006da:	8b 12                	mov    (%rdx),%edx
  8006dc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e3:	89 0a                	mov    %ecx,(%rdx)
  8006e5:	eb 14                	jmp    8006fb <getint+0xf9>
  8006e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006eb:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006ef:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006fb:	8b 00                	mov    (%rax),%eax
  8006fd:	48 98                	cltq   
  8006ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800703:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800707:	c9                   	leaveq 
  800708:	c3                   	retq   

0000000000800709 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800709:	55                   	push   %rbp
  80070a:	48 89 e5             	mov    %rsp,%rbp
  80070d:	41 54                	push   %r12
  80070f:	53                   	push   %rbx
  800710:	48 83 ec 60          	sub    $0x60,%rsp
  800714:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800718:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80071c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800720:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800724:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800728:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80072c:	48 8b 0a             	mov    (%rdx),%rcx
  80072f:	48 89 08             	mov    %rcx,(%rax)
  800732:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800736:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80073a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80073e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800742:	eb 17                	jmp    80075b <vprintfmt+0x52>
			if (ch == '\0')
  800744:	85 db                	test   %ebx,%ebx
  800746:	0f 84 c5 04 00 00    	je     800c11 <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  80074c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800750:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800754:	48 89 d6             	mov    %rdx,%rsi
  800757:	89 df                	mov    %ebx,%edi
  800759:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80075b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80075f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800763:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800767:	0f b6 00             	movzbl (%rax),%eax
  80076a:	0f b6 d8             	movzbl %al,%ebx
  80076d:	83 fb 25             	cmp    $0x25,%ebx
  800770:	75 d2                	jne    800744 <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  800772:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800776:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80077d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800784:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80078b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800792:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800796:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80079a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80079e:	0f b6 00             	movzbl (%rax),%eax
  8007a1:	0f b6 d8             	movzbl %al,%ebx
  8007a4:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8007a7:	83 f8 55             	cmp    $0x55,%eax
  8007aa:	0f 87 2e 04 00 00    	ja     800bde <vprintfmt+0x4d5>
  8007b0:	89 c0                	mov    %eax,%eax
  8007b2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8007b9:	00 
  8007ba:	48 b8 98 46 80 00 00 	movabs $0x804698,%rax
  8007c1:	00 00 00 
  8007c4:	48 01 d0             	add    %rdx,%rax
  8007c7:	48 8b 00             	mov    (%rax),%rax
  8007ca:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8007cc:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8007d0:	eb c0                	jmp    800792 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007d2:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8007d6:	eb ba                	jmp    800792 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007d8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8007df:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8007e2:	89 d0                	mov    %edx,%eax
  8007e4:	c1 e0 02             	shl    $0x2,%eax
  8007e7:	01 d0                	add    %edx,%eax
  8007e9:	01 c0                	add    %eax,%eax
  8007eb:	01 d8                	add    %ebx,%eax
  8007ed:	83 e8 30             	sub    $0x30,%eax
  8007f0:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8007f3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007f7:	0f b6 00             	movzbl (%rax),%eax
  8007fa:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007fd:	83 fb 2f             	cmp    $0x2f,%ebx
  800800:	7e 0c                	jle    80080e <vprintfmt+0x105>
  800802:	83 fb 39             	cmp    $0x39,%ebx
  800805:	7f 07                	jg     80080e <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  800807:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  80080c:	eb d1                	jmp    8007df <vprintfmt+0xd6>
			goto process_precision;
  80080e:	eb 50                	jmp    800860 <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  800810:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800813:	83 f8 30             	cmp    $0x30,%eax
  800816:	73 17                	jae    80082f <vprintfmt+0x126>
  800818:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80081c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80081f:	89 d2                	mov    %edx,%edx
  800821:	48 01 d0             	add    %rdx,%rax
  800824:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800827:	83 c2 08             	add    $0x8,%edx
  80082a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80082d:	eb 0c                	jmp    80083b <vprintfmt+0x132>
  80082f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800833:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800837:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80083b:	8b 00                	mov    (%rax),%eax
  80083d:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800840:	eb 1e                	jmp    800860 <vprintfmt+0x157>

		case '.':
			if (width < 0)
  800842:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800846:	79 07                	jns    80084f <vprintfmt+0x146>
				width = 0;
  800848:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80084f:	e9 3e ff ff ff       	jmpq   800792 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800854:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80085b:	e9 32 ff ff ff       	jmpq   800792 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800860:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800864:	79 0d                	jns    800873 <vprintfmt+0x16a>
				width = precision, precision = -1;
  800866:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800869:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80086c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800873:	e9 1a ff ff ff       	jmpq   800792 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800878:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80087c:	e9 11 ff ff ff       	jmpq   800792 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800881:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800884:	83 f8 30             	cmp    $0x30,%eax
  800887:	73 17                	jae    8008a0 <vprintfmt+0x197>
  800889:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80088d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800890:	89 d2                	mov    %edx,%edx
  800892:	48 01 d0             	add    %rdx,%rax
  800895:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800898:	83 c2 08             	add    $0x8,%edx
  80089b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80089e:	eb 0c                	jmp    8008ac <vprintfmt+0x1a3>
  8008a0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8008a4:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8008a8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008ac:	8b 10                	mov    (%rax),%edx
  8008ae:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008b2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008b6:	48 89 ce             	mov    %rcx,%rsi
  8008b9:	89 d7                	mov    %edx,%edi
  8008bb:	ff d0                	callq  *%rax
			break;
  8008bd:	e9 4a 03 00 00       	jmpq   800c0c <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8008c2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008c5:	83 f8 30             	cmp    $0x30,%eax
  8008c8:	73 17                	jae    8008e1 <vprintfmt+0x1d8>
  8008ca:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8008ce:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008d1:	89 d2                	mov    %edx,%edx
  8008d3:	48 01 d0             	add    %rdx,%rax
  8008d6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008d9:	83 c2 08             	add    $0x8,%edx
  8008dc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008df:	eb 0c                	jmp    8008ed <vprintfmt+0x1e4>
  8008e1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8008e5:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8008e9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008ed:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008ef:	85 db                	test   %ebx,%ebx
  8008f1:	79 02                	jns    8008f5 <vprintfmt+0x1ec>
				err = -err;
  8008f3:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008f5:	83 fb 15             	cmp    $0x15,%ebx
  8008f8:	7f 16                	jg     800910 <vprintfmt+0x207>
  8008fa:	48 b8 c0 45 80 00 00 	movabs $0x8045c0,%rax
  800901:	00 00 00 
  800904:	48 63 d3             	movslq %ebx,%rdx
  800907:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80090b:	4d 85 e4             	test   %r12,%r12
  80090e:	75 2e                	jne    80093e <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  800910:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800914:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800918:	89 d9                	mov    %ebx,%ecx
  80091a:	48 ba 81 46 80 00 00 	movabs $0x804681,%rdx
  800921:	00 00 00 
  800924:	48 89 c7             	mov    %rax,%rdi
  800927:	b8 00 00 00 00       	mov    $0x0,%eax
  80092c:	49 b8 1a 0c 80 00 00 	movabs $0x800c1a,%r8
  800933:	00 00 00 
  800936:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800939:	e9 ce 02 00 00       	jmpq   800c0c <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  80093e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800942:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800946:	4c 89 e1             	mov    %r12,%rcx
  800949:	48 ba 8a 46 80 00 00 	movabs $0x80468a,%rdx
  800950:	00 00 00 
  800953:	48 89 c7             	mov    %rax,%rdi
  800956:	b8 00 00 00 00       	mov    $0x0,%eax
  80095b:	49 b8 1a 0c 80 00 00 	movabs $0x800c1a,%r8
  800962:	00 00 00 
  800965:	41 ff d0             	callq  *%r8
			break;
  800968:	e9 9f 02 00 00       	jmpq   800c0c <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80096d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800970:	83 f8 30             	cmp    $0x30,%eax
  800973:	73 17                	jae    80098c <vprintfmt+0x283>
  800975:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800979:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80097c:	89 d2                	mov    %edx,%edx
  80097e:	48 01 d0             	add    %rdx,%rax
  800981:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800984:	83 c2 08             	add    $0x8,%edx
  800987:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80098a:	eb 0c                	jmp    800998 <vprintfmt+0x28f>
  80098c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800990:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800994:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800998:	4c 8b 20             	mov    (%rax),%r12
  80099b:	4d 85 e4             	test   %r12,%r12
  80099e:	75 0a                	jne    8009aa <vprintfmt+0x2a1>
				p = "(null)";
  8009a0:	49 bc 8d 46 80 00 00 	movabs $0x80468d,%r12
  8009a7:	00 00 00 
			if (width > 0 && padc != '-')
  8009aa:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009ae:	7e 3f                	jle    8009ef <vprintfmt+0x2e6>
  8009b0:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8009b4:	74 39                	je     8009ef <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009b6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009b9:	48 98                	cltq   
  8009bb:	48 89 c6             	mov    %rax,%rsi
  8009be:	4c 89 e7             	mov    %r12,%rdi
  8009c1:	48 b8 c6 0e 80 00 00 	movabs $0x800ec6,%rax
  8009c8:	00 00 00 
  8009cb:	ff d0                	callq  *%rax
  8009cd:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8009d0:	eb 17                	jmp    8009e9 <vprintfmt+0x2e0>
					putch(padc, putdat);
  8009d2:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8009d6:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009da:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009de:	48 89 ce             	mov    %rcx,%rsi
  8009e1:	89 d7                	mov    %edx,%edi
  8009e3:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009e9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009ed:	7f e3                	jg     8009d2 <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ef:	eb 37                	jmp    800a28 <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  8009f1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009f5:	74 1e                	je     800a15 <vprintfmt+0x30c>
  8009f7:	83 fb 1f             	cmp    $0x1f,%ebx
  8009fa:	7e 05                	jle    800a01 <vprintfmt+0x2f8>
  8009fc:	83 fb 7e             	cmp    $0x7e,%ebx
  8009ff:	7e 14                	jle    800a15 <vprintfmt+0x30c>
					putch('?', putdat);
  800a01:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a05:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a09:	48 89 d6             	mov    %rdx,%rsi
  800a0c:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a11:	ff d0                	callq  *%rax
  800a13:	eb 0f                	jmp    800a24 <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  800a15:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a19:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a1d:	48 89 d6             	mov    %rdx,%rsi
  800a20:	89 df                	mov    %ebx,%edi
  800a22:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a24:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a28:	4c 89 e0             	mov    %r12,%rax
  800a2b:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a2f:	0f b6 00             	movzbl (%rax),%eax
  800a32:	0f be d8             	movsbl %al,%ebx
  800a35:	85 db                	test   %ebx,%ebx
  800a37:	74 10                	je     800a49 <vprintfmt+0x340>
  800a39:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a3d:	78 b2                	js     8009f1 <vprintfmt+0x2e8>
  800a3f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a43:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a47:	79 a8                	jns    8009f1 <vprintfmt+0x2e8>
			for (; width > 0; width--)
  800a49:	eb 16                	jmp    800a61 <vprintfmt+0x358>
				putch(' ', putdat);
  800a4b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a4f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a53:	48 89 d6             	mov    %rdx,%rsi
  800a56:	bf 20 00 00 00       	mov    $0x20,%edi
  800a5b:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  800a5d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a61:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a65:	7f e4                	jg     800a4b <vprintfmt+0x342>
			break;
  800a67:	e9 a0 01 00 00       	jmpq   800c0c <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a6c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a70:	be 03 00 00 00       	mov    $0x3,%esi
  800a75:	48 89 c7             	mov    %rax,%rdi
  800a78:	48 b8 02 06 80 00 00 	movabs $0x800602,%rax
  800a7f:	00 00 00 
  800a82:	ff d0                	callq  *%rax
  800a84:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8c:	48 85 c0             	test   %rax,%rax
  800a8f:	79 1d                	jns    800aae <vprintfmt+0x3a5>
				putch('-', putdat);
  800a91:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a95:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a99:	48 89 d6             	mov    %rdx,%rsi
  800a9c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800aa1:	ff d0                	callq  *%rax
				num = -(long long) num;
  800aa3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa7:	48 f7 d8             	neg    %rax
  800aaa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800aae:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ab5:	e9 e5 00 00 00       	jmpq   800b9f <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800aba:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800abe:	be 03 00 00 00       	mov    $0x3,%esi
  800ac3:	48 89 c7             	mov    %rax,%rdi
  800ac6:	48 b8 fb 04 80 00 00 	movabs $0x8004fb,%rax
  800acd:	00 00 00 
  800ad0:	ff d0                	callq  *%rax
  800ad2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ad6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800add:	e9 bd 00 00 00       	jmpq   800b9f <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ae2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ae6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aea:	48 89 d6             	mov    %rdx,%rsi
  800aed:	bf 58 00 00 00       	mov    $0x58,%edi
  800af2:	ff d0                	callq  *%rax
			putch('X', putdat);
  800af4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800af8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800afc:	48 89 d6             	mov    %rdx,%rsi
  800aff:	bf 58 00 00 00       	mov    $0x58,%edi
  800b04:	ff d0                	callq  *%rax
			putch('X', putdat);
  800b06:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b0e:	48 89 d6             	mov    %rdx,%rsi
  800b11:	bf 58 00 00 00       	mov    $0x58,%edi
  800b16:	ff d0                	callq  *%rax
			break;
  800b18:	e9 ef 00 00 00       	jmpq   800c0c <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  800b1d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b21:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b25:	48 89 d6             	mov    %rdx,%rsi
  800b28:	bf 30 00 00 00       	mov    $0x30,%edi
  800b2d:	ff d0                	callq  *%rax
			putch('x', putdat);
  800b2f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b33:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b37:	48 89 d6             	mov    %rdx,%rsi
  800b3a:	bf 78 00 00 00       	mov    $0x78,%edi
  800b3f:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b41:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b44:	83 f8 30             	cmp    $0x30,%eax
  800b47:	73 17                	jae    800b60 <vprintfmt+0x457>
  800b49:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b4d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b50:	89 d2                	mov    %edx,%edx
  800b52:	48 01 d0             	add    %rdx,%rax
  800b55:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b58:	83 c2 08             	add    $0x8,%edx
  800b5b:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  800b5e:	eb 0c                	jmp    800b6c <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  800b60:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b64:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b68:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b6c:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  800b6f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b73:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b7a:	eb 23                	jmp    800b9f <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b7c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b80:	be 03 00 00 00       	mov    $0x3,%esi
  800b85:	48 89 c7             	mov    %rax,%rdi
  800b88:	48 b8 fb 04 80 00 00 	movabs $0x8004fb,%rax
  800b8f:	00 00 00 
  800b92:	ff d0                	callq  *%rax
  800b94:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b98:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b9f:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ba4:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ba7:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800baa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bae:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bb2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb6:	45 89 c1             	mov    %r8d,%r9d
  800bb9:	41 89 f8             	mov    %edi,%r8d
  800bbc:	48 89 c7             	mov    %rax,%rdi
  800bbf:	48 b8 42 04 80 00 00 	movabs $0x800442,%rax
  800bc6:	00 00 00 
  800bc9:	ff d0                	callq  *%rax
			break;
  800bcb:	eb 3f                	jmp    800c0c <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bcd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bd1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd5:	48 89 d6             	mov    %rdx,%rsi
  800bd8:	89 df                	mov    %ebx,%edi
  800bda:	ff d0                	callq  *%rax
			break;
  800bdc:	eb 2e                	jmp    800c0c <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bde:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800be2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be6:	48 89 d6             	mov    %rdx,%rsi
  800be9:	bf 25 00 00 00       	mov    $0x25,%edi
  800bee:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bf0:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bf5:	eb 05                	jmp    800bfc <vprintfmt+0x4f3>
  800bf7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bfc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c00:	48 83 e8 01          	sub    $0x1,%rax
  800c04:	0f b6 00             	movzbl (%rax),%eax
  800c07:	3c 25                	cmp    $0x25,%al
  800c09:	75 ec                	jne    800bf7 <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  800c0b:	90                   	nop
		}
	}
  800c0c:	e9 31 fb ff ff       	jmpq   800742 <vprintfmt+0x39>
	va_end(aq);
}
  800c11:	48 83 c4 60          	add    $0x60,%rsp
  800c15:	5b                   	pop    %rbx
  800c16:	41 5c                	pop    %r12
  800c18:	5d                   	pop    %rbp
  800c19:	c3                   	retq   

0000000000800c1a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c1a:	55                   	push   %rbp
  800c1b:	48 89 e5             	mov    %rsp,%rbp
  800c1e:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800c25:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800c2c:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c33:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c3a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c41:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c48:	84 c0                	test   %al,%al
  800c4a:	74 20                	je     800c6c <printfmt+0x52>
  800c4c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c50:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c54:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c58:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c5c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c60:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c64:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c68:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c6c:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c73:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c7a:	00 00 00 
  800c7d:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c84:	00 00 00 
  800c87:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c8b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c92:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c99:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ca0:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ca7:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800cae:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800cb5:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800cbc:	48 89 c7             	mov    %rax,%rdi
  800cbf:	48 b8 09 07 80 00 00 	movabs $0x800709,%rax
  800cc6:	00 00 00 
  800cc9:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ccb:	c9                   	leaveq 
  800ccc:	c3                   	retq   

0000000000800ccd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ccd:	55                   	push   %rbp
  800cce:	48 89 e5             	mov    %rsp,%rbp
  800cd1:	48 83 ec 10          	sub    $0x10,%rsp
  800cd5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800cd8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800cdc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ce0:	8b 40 10             	mov    0x10(%rax),%eax
  800ce3:	8d 50 01             	lea    0x1(%rax),%edx
  800ce6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cea:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ced:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cf1:	48 8b 10             	mov    (%rax),%rdx
  800cf4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cf8:	48 8b 40 08          	mov    0x8(%rax),%rax
  800cfc:	48 39 c2             	cmp    %rax,%rdx
  800cff:	73 17                	jae    800d18 <sprintputch+0x4b>
		*b->buf++ = ch;
  800d01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d05:	48 8b 00             	mov    (%rax),%rax
  800d08:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800d0c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d10:	48 89 0a             	mov    %rcx,(%rdx)
  800d13:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d16:	88 10                	mov    %dl,(%rax)
}
  800d18:	c9                   	leaveq 
  800d19:	c3                   	retq   

0000000000800d1a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d1a:	55                   	push   %rbp
  800d1b:	48 89 e5             	mov    %rsp,%rbp
  800d1e:	48 83 ec 50          	sub    $0x50,%rsp
  800d22:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800d26:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800d29:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800d2d:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d31:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d35:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d39:	48 8b 0a             	mov    (%rdx),%rcx
  800d3c:	48 89 08             	mov    %rcx,(%rax)
  800d3f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d43:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d47:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d4b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d4f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d53:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d57:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d5a:	48 98                	cltq   
  800d5c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d60:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d64:	48 01 d0             	add    %rdx,%rax
  800d67:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d6b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d72:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d77:	74 06                	je     800d7f <vsnprintf+0x65>
  800d79:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d7d:	7f 07                	jg     800d86 <vsnprintf+0x6c>
		return -E_INVAL;
  800d7f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d84:	eb 2f                	jmp    800db5 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d86:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d8a:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d8e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d92:	48 89 c6             	mov    %rax,%rsi
  800d95:	48 bf cd 0c 80 00 00 	movabs $0x800ccd,%rdi
  800d9c:	00 00 00 
  800d9f:	48 b8 09 07 80 00 00 	movabs $0x800709,%rax
  800da6:	00 00 00 
  800da9:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800dab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800daf:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800db2:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800db5:	c9                   	leaveq 
  800db6:	c3                   	retq   

0000000000800db7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800db7:	55                   	push   %rbp
  800db8:	48 89 e5             	mov    %rsp,%rbp
  800dbb:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800dc2:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800dc9:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800dcf:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dd6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ddd:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800de4:	84 c0                	test   %al,%al
  800de6:	74 20                	je     800e08 <snprintf+0x51>
  800de8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dec:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800df0:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800df4:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800df8:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dfc:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e00:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e04:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e08:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e0f:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e16:	00 00 00 
  800e19:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e20:	00 00 00 
  800e23:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e27:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e2e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e35:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e3c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e43:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e4a:	48 8b 0a             	mov    (%rdx),%rcx
  800e4d:	48 89 08             	mov    %rcx,(%rax)
  800e50:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e54:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e58:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e5c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e60:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e67:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e6e:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e74:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e7b:	48 89 c7             	mov    %rax,%rdi
  800e7e:	48 b8 1a 0d 80 00 00 	movabs $0x800d1a,%rax
  800e85:	00 00 00 
  800e88:	ff d0                	callq  *%rax
  800e8a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e90:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e96:	c9                   	leaveq 
  800e97:	c3                   	retq   

0000000000800e98 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e98:	55                   	push   %rbp
  800e99:	48 89 e5             	mov    %rsp,%rbp
  800e9c:	48 83 ec 18          	sub    $0x18,%rsp
  800ea0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800ea4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800eab:	eb 09                	jmp    800eb6 <strlen+0x1e>
		n++;
  800ead:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  800eb1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800eb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eba:	0f b6 00             	movzbl (%rax),%eax
  800ebd:	84 c0                	test   %al,%al
  800ebf:	75 ec                	jne    800ead <strlen+0x15>
	return n;
  800ec1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ec4:	c9                   	leaveq 
  800ec5:	c3                   	retq   

0000000000800ec6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ec6:	55                   	push   %rbp
  800ec7:	48 89 e5             	mov    %rsp,%rbp
  800eca:	48 83 ec 20          	sub    $0x20,%rsp
  800ece:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ed2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ed6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800edd:	eb 0e                	jmp    800eed <strnlen+0x27>
		n++;
  800edf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ee3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ee8:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800eed:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800ef2:	74 0b                	je     800eff <strnlen+0x39>
  800ef4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef8:	0f b6 00             	movzbl (%rax),%eax
  800efb:	84 c0                	test   %al,%al
  800efd:	75 e0                	jne    800edf <strnlen+0x19>
	return n;
  800eff:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f02:	c9                   	leaveq 
  800f03:	c3                   	retq   

0000000000800f04 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f04:	55                   	push   %rbp
  800f05:	48 89 e5             	mov    %rsp,%rbp
  800f08:	48 83 ec 20          	sub    $0x20,%rsp
  800f0c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f10:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f18:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f1c:	90                   	nop
  800f1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f21:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f25:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f29:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f2d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f31:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f35:	0f b6 12             	movzbl (%rdx),%edx
  800f38:	88 10                	mov    %dl,(%rax)
  800f3a:	0f b6 00             	movzbl (%rax),%eax
  800f3d:	84 c0                	test   %al,%al
  800f3f:	75 dc                	jne    800f1d <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f45:	c9                   	leaveq 
  800f46:	c3                   	retq   

0000000000800f47 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f47:	55                   	push   %rbp
  800f48:	48 89 e5             	mov    %rsp,%rbp
  800f4b:	48 83 ec 20          	sub    $0x20,%rsp
  800f4f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f53:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f5b:	48 89 c7             	mov    %rax,%rdi
  800f5e:	48 b8 98 0e 80 00 00 	movabs $0x800e98,%rax
  800f65:	00 00 00 
  800f68:	ff d0                	callq  *%rax
  800f6a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f70:	48 63 d0             	movslq %eax,%rdx
  800f73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f77:	48 01 c2             	add    %rax,%rdx
  800f7a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f7e:	48 89 c6             	mov    %rax,%rsi
  800f81:	48 89 d7             	mov    %rdx,%rdi
  800f84:	48 b8 04 0f 80 00 00 	movabs $0x800f04,%rax
  800f8b:	00 00 00 
  800f8e:	ff d0                	callq  *%rax
	return dst;
  800f90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f94:	c9                   	leaveq 
  800f95:	c3                   	retq   

0000000000800f96 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f96:	55                   	push   %rbp
  800f97:	48 89 e5             	mov    %rsp,%rbp
  800f9a:	48 83 ec 28          	sub    $0x28,%rsp
  800f9e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fa2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fa6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800faa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800fb2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800fb9:	00 
  800fba:	eb 2a                	jmp    800fe6 <strncpy+0x50>
		*dst++ = *src;
  800fbc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fc0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fc4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fc8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fcc:	0f b6 12             	movzbl (%rdx),%edx
  800fcf:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fd1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fd5:	0f b6 00             	movzbl (%rax),%eax
  800fd8:	84 c0                	test   %al,%al
  800fda:	74 05                	je     800fe1 <strncpy+0x4b>
			src++;
  800fdc:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  800fe1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fe6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fea:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800fee:	72 cc                	jb     800fbc <strncpy+0x26>
	}
	return ret;
  800ff0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800ff4:	c9                   	leaveq 
  800ff5:	c3                   	retq   

0000000000800ff6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ff6:	55                   	push   %rbp
  800ff7:	48 89 e5             	mov    %rsp,%rbp
  800ffa:	48 83 ec 28          	sub    $0x28,%rsp
  800ffe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801002:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801006:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80100a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80100e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801012:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801017:	74 3d                	je     801056 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801019:	eb 1d                	jmp    801038 <strlcpy+0x42>
			*dst++ = *src++;
  80101b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80101f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801023:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801027:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80102b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80102f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801033:	0f b6 12             	movzbl (%rdx),%edx
  801036:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  801038:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80103d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801042:	74 0b                	je     80104f <strlcpy+0x59>
  801044:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801048:	0f b6 00             	movzbl (%rax),%eax
  80104b:	84 c0                	test   %al,%al
  80104d:	75 cc                	jne    80101b <strlcpy+0x25>
		*dst = '\0';
  80104f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801053:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801056:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80105a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80105e:	48 29 c2             	sub    %rax,%rdx
  801061:	48 89 d0             	mov    %rdx,%rax
}
  801064:	c9                   	leaveq 
  801065:	c3                   	retq   

0000000000801066 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801066:	55                   	push   %rbp
  801067:	48 89 e5             	mov    %rsp,%rbp
  80106a:	48 83 ec 10          	sub    $0x10,%rsp
  80106e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801072:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801076:	eb 0a                	jmp    801082 <strcmp+0x1c>
		p++, q++;
  801078:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80107d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  801082:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801086:	0f b6 00             	movzbl (%rax),%eax
  801089:	84 c0                	test   %al,%al
  80108b:	74 12                	je     80109f <strcmp+0x39>
  80108d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801091:	0f b6 10             	movzbl (%rax),%edx
  801094:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801098:	0f b6 00             	movzbl (%rax),%eax
  80109b:	38 c2                	cmp    %al,%dl
  80109d:	74 d9                	je     801078 <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80109f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010a3:	0f b6 00             	movzbl (%rax),%eax
  8010a6:	0f b6 d0             	movzbl %al,%edx
  8010a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ad:	0f b6 00             	movzbl (%rax),%eax
  8010b0:	0f b6 c0             	movzbl %al,%eax
  8010b3:	29 c2                	sub    %eax,%edx
  8010b5:	89 d0                	mov    %edx,%eax
}
  8010b7:	c9                   	leaveq 
  8010b8:	c3                   	retq   

00000000008010b9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8010b9:	55                   	push   %rbp
  8010ba:	48 89 e5             	mov    %rsp,%rbp
  8010bd:	48 83 ec 18          	sub    $0x18,%rsp
  8010c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010c5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8010c9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8010cd:	eb 0f                	jmp    8010de <strncmp+0x25>
		n--, p++, q++;
  8010cf:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8010d4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010d9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  8010de:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010e3:	74 1d                	je     801102 <strncmp+0x49>
  8010e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e9:	0f b6 00             	movzbl (%rax),%eax
  8010ec:	84 c0                	test   %al,%al
  8010ee:	74 12                	je     801102 <strncmp+0x49>
  8010f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f4:	0f b6 10             	movzbl (%rax),%edx
  8010f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010fb:	0f b6 00             	movzbl (%rax),%eax
  8010fe:	38 c2                	cmp    %al,%dl
  801100:	74 cd                	je     8010cf <strncmp+0x16>
	if (n == 0)
  801102:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801107:	75 07                	jne    801110 <strncmp+0x57>
		return 0;
  801109:	b8 00 00 00 00       	mov    $0x0,%eax
  80110e:	eb 18                	jmp    801128 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801110:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801114:	0f b6 00             	movzbl (%rax),%eax
  801117:	0f b6 d0             	movzbl %al,%edx
  80111a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80111e:	0f b6 00             	movzbl (%rax),%eax
  801121:	0f b6 c0             	movzbl %al,%eax
  801124:	29 c2                	sub    %eax,%edx
  801126:	89 d0                	mov    %edx,%eax
}
  801128:	c9                   	leaveq 
  801129:	c3                   	retq   

000000000080112a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80112a:	55                   	push   %rbp
  80112b:	48 89 e5             	mov    %rsp,%rbp
  80112e:	48 83 ec 10          	sub    $0x10,%rsp
  801132:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801136:	89 f0                	mov    %esi,%eax
  801138:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80113b:	eb 17                	jmp    801154 <strchr+0x2a>
		if (*s == c)
  80113d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801141:	0f b6 00             	movzbl (%rax),%eax
  801144:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801147:	75 06                	jne    80114f <strchr+0x25>
			return (char *) s;
  801149:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80114d:	eb 15                	jmp    801164 <strchr+0x3a>
	for (; *s; s++)
  80114f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801154:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801158:	0f b6 00             	movzbl (%rax),%eax
  80115b:	84 c0                	test   %al,%al
  80115d:	75 de                	jne    80113d <strchr+0x13>
	return 0;
  80115f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801164:	c9                   	leaveq 
  801165:	c3                   	retq   

0000000000801166 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801166:	55                   	push   %rbp
  801167:	48 89 e5             	mov    %rsp,%rbp
  80116a:	48 83 ec 10          	sub    $0x10,%rsp
  80116e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801172:	89 f0                	mov    %esi,%eax
  801174:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801177:	eb 13                	jmp    80118c <strfind+0x26>
		if (*s == c)
  801179:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80117d:	0f b6 00             	movzbl (%rax),%eax
  801180:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801183:	75 02                	jne    801187 <strfind+0x21>
			break;
  801185:	eb 10                	jmp    801197 <strfind+0x31>
	for (; *s; s++)
  801187:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80118c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801190:	0f b6 00             	movzbl (%rax),%eax
  801193:	84 c0                	test   %al,%al
  801195:	75 e2                	jne    801179 <strfind+0x13>
	return (char *) s;
  801197:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80119b:	c9                   	leaveq 
  80119c:	c3                   	retq   

000000000080119d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80119d:	55                   	push   %rbp
  80119e:	48 89 e5             	mov    %rsp,%rbp
  8011a1:	48 83 ec 18          	sub    $0x18,%rsp
  8011a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011a9:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8011ac:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8011b0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011b5:	75 06                	jne    8011bd <memset+0x20>
		return v;
  8011b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011bb:	eb 69                	jmp    801226 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8011bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c1:	83 e0 03             	and    $0x3,%eax
  8011c4:	48 85 c0             	test   %rax,%rax
  8011c7:	75 48                	jne    801211 <memset+0x74>
  8011c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011cd:	83 e0 03             	and    $0x3,%eax
  8011d0:	48 85 c0             	test   %rax,%rax
  8011d3:	75 3c                	jne    801211 <memset+0x74>
		c &= 0xFF;
  8011d5:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011dc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011df:	c1 e0 18             	shl    $0x18,%eax
  8011e2:	89 c2                	mov    %eax,%edx
  8011e4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011e7:	c1 e0 10             	shl    $0x10,%eax
  8011ea:	09 c2                	or     %eax,%edx
  8011ec:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011ef:	c1 e0 08             	shl    $0x8,%eax
  8011f2:	09 d0                	or     %edx,%eax
  8011f4:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8011f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011fb:	48 c1 e8 02          	shr    $0x2,%rax
  8011ff:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  801202:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801206:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801209:	48 89 d7             	mov    %rdx,%rdi
  80120c:	fc                   	cld    
  80120d:	f3 ab                	rep stos %eax,%es:(%rdi)
  80120f:	eb 11                	jmp    801222 <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801211:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801215:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801218:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80121c:	48 89 d7             	mov    %rdx,%rdi
  80121f:	fc                   	cld    
  801220:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801222:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801226:	c9                   	leaveq 
  801227:	c3                   	retq   

0000000000801228 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801228:	55                   	push   %rbp
  801229:	48 89 e5             	mov    %rsp,%rbp
  80122c:	48 83 ec 28          	sub    $0x28,%rsp
  801230:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801234:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801238:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80123c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801240:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801244:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801248:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80124c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801250:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801254:	0f 83 88 00 00 00    	jae    8012e2 <memmove+0xba>
  80125a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80125e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801262:	48 01 d0             	add    %rdx,%rax
  801265:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801269:	76 77                	jbe    8012e2 <memmove+0xba>
		s += n;
  80126b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80126f:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801273:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801277:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80127b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127f:	83 e0 03             	and    $0x3,%eax
  801282:	48 85 c0             	test   %rax,%rax
  801285:	75 3b                	jne    8012c2 <memmove+0x9a>
  801287:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80128b:	83 e0 03             	and    $0x3,%eax
  80128e:	48 85 c0             	test   %rax,%rax
  801291:	75 2f                	jne    8012c2 <memmove+0x9a>
  801293:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801297:	83 e0 03             	and    $0x3,%eax
  80129a:	48 85 c0             	test   %rax,%rax
  80129d:	75 23                	jne    8012c2 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80129f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012a3:	48 83 e8 04          	sub    $0x4,%rax
  8012a7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012ab:	48 83 ea 04          	sub    $0x4,%rdx
  8012af:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012b3:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  8012b7:	48 89 c7             	mov    %rax,%rdi
  8012ba:	48 89 d6             	mov    %rdx,%rsi
  8012bd:	fd                   	std    
  8012be:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012c0:	eb 1d                	jmp    8012df <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8012c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ce:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  8012d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d6:	48 89 d7             	mov    %rdx,%rdi
  8012d9:	48 89 c1             	mov    %rax,%rcx
  8012dc:	fd                   	std    
  8012dd:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012df:	fc                   	cld    
  8012e0:	eb 57                	jmp    801339 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e6:	83 e0 03             	and    $0x3,%eax
  8012e9:	48 85 c0             	test   %rax,%rax
  8012ec:	75 36                	jne    801324 <memmove+0xfc>
  8012ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f2:	83 e0 03             	and    $0x3,%eax
  8012f5:	48 85 c0             	test   %rax,%rax
  8012f8:	75 2a                	jne    801324 <memmove+0xfc>
  8012fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012fe:	83 e0 03             	and    $0x3,%eax
  801301:	48 85 c0             	test   %rax,%rax
  801304:	75 1e                	jne    801324 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801306:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80130a:	48 c1 e8 02          	shr    $0x2,%rax
  80130e:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  801311:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801315:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801319:	48 89 c7             	mov    %rax,%rdi
  80131c:	48 89 d6             	mov    %rdx,%rsi
  80131f:	fc                   	cld    
  801320:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801322:	eb 15                	jmp    801339 <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  801324:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801328:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80132c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801330:	48 89 c7             	mov    %rax,%rdi
  801333:	48 89 d6             	mov    %rdx,%rsi
  801336:	fc                   	cld    
  801337:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801339:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80133d:	c9                   	leaveq 
  80133e:	c3                   	retq   

000000000080133f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80133f:	55                   	push   %rbp
  801340:	48 89 e5             	mov    %rsp,%rbp
  801343:	48 83 ec 18          	sub    $0x18,%rsp
  801347:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80134b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80134f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801353:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801357:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80135b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135f:	48 89 ce             	mov    %rcx,%rsi
  801362:	48 89 c7             	mov    %rax,%rdi
  801365:	48 b8 28 12 80 00 00 	movabs $0x801228,%rax
  80136c:	00 00 00 
  80136f:	ff d0                	callq  *%rax
}
  801371:	c9                   	leaveq 
  801372:	c3                   	retq   

0000000000801373 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801373:	55                   	push   %rbp
  801374:	48 89 e5             	mov    %rsp,%rbp
  801377:	48 83 ec 28          	sub    $0x28,%rsp
  80137b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80137f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801383:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801387:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80138b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80138f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801393:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801397:	eb 36                	jmp    8013cf <memcmp+0x5c>
		if (*s1 != *s2)
  801399:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139d:	0f b6 10             	movzbl (%rax),%edx
  8013a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a4:	0f b6 00             	movzbl (%rax),%eax
  8013a7:	38 c2                	cmp    %al,%dl
  8013a9:	74 1a                	je     8013c5 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8013ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013af:	0f b6 00             	movzbl (%rax),%eax
  8013b2:	0f b6 d0             	movzbl %al,%edx
  8013b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013b9:	0f b6 00             	movzbl (%rax),%eax
  8013bc:	0f b6 c0             	movzbl %al,%eax
  8013bf:	29 c2                	sub    %eax,%edx
  8013c1:	89 d0                	mov    %edx,%eax
  8013c3:	eb 20                	jmp    8013e5 <memcmp+0x72>
		s1++, s2++;
  8013c5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013ca:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  8013cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013d7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8013db:	48 85 c0             	test   %rax,%rax
  8013de:	75 b9                	jne    801399 <memcmp+0x26>
	}

	return 0;
  8013e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013e5:	c9                   	leaveq 
  8013e6:	c3                   	retq   

00000000008013e7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013e7:	55                   	push   %rbp
  8013e8:	48 89 e5             	mov    %rsp,%rbp
  8013eb:	48 83 ec 28          	sub    $0x28,%rsp
  8013ef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013f3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8013f6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801402:	48 01 d0             	add    %rdx,%rax
  801405:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801409:	eb 15                	jmp    801420 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80140b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80140f:	0f b6 00             	movzbl (%rax),%eax
  801412:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801415:	38 d0                	cmp    %dl,%al
  801417:	75 02                	jne    80141b <memfind+0x34>
			break;
  801419:	eb 0f                	jmp    80142a <memfind+0x43>
	for (; s < ends; s++)
  80141b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801420:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801424:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801428:	72 e1                	jb     80140b <memfind+0x24>
	return (void *) s;
  80142a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80142e:	c9                   	leaveq 
  80142f:	c3                   	retq   

0000000000801430 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801430:	55                   	push   %rbp
  801431:	48 89 e5             	mov    %rsp,%rbp
  801434:	48 83 ec 38          	sub    $0x38,%rsp
  801438:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80143c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801440:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801443:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80144a:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801451:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801452:	eb 05                	jmp    801459 <strtol+0x29>
		s++;
  801454:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  801459:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145d:	0f b6 00             	movzbl (%rax),%eax
  801460:	3c 20                	cmp    $0x20,%al
  801462:	74 f0                	je     801454 <strtol+0x24>
  801464:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801468:	0f b6 00             	movzbl (%rax),%eax
  80146b:	3c 09                	cmp    $0x9,%al
  80146d:	74 e5                	je     801454 <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  80146f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801473:	0f b6 00             	movzbl (%rax),%eax
  801476:	3c 2b                	cmp    $0x2b,%al
  801478:	75 07                	jne    801481 <strtol+0x51>
		s++;
  80147a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80147f:	eb 17                	jmp    801498 <strtol+0x68>
	else if (*s == '-')
  801481:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801485:	0f b6 00             	movzbl (%rax),%eax
  801488:	3c 2d                	cmp    $0x2d,%al
  80148a:	75 0c                	jne    801498 <strtol+0x68>
		s++, neg = 1;
  80148c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801491:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801498:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80149c:	74 06                	je     8014a4 <strtol+0x74>
  80149e:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8014a2:	75 28                	jne    8014cc <strtol+0x9c>
  8014a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a8:	0f b6 00             	movzbl (%rax),%eax
  8014ab:	3c 30                	cmp    $0x30,%al
  8014ad:	75 1d                	jne    8014cc <strtol+0x9c>
  8014af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b3:	48 83 c0 01          	add    $0x1,%rax
  8014b7:	0f b6 00             	movzbl (%rax),%eax
  8014ba:	3c 78                	cmp    $0x78,%al
  8014bc:	75 0e                	jne    8014cc <strtol+0x9c>
		s += 2, base = 16;
  8014be:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8014c3:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8014ca:	eb 2c                	jmp    8014f8 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8014cc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014d0:	75 19                	jne    8014eb <strtol+0xbb>
  8014d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d6:	0f b6 00             	movzbl (%rax),%eax
  8014d9:	3c 30                	cmp    $0x30,%al
  8014db:	75 0e                	jne    8014eb <strtol+0xbb>
		s++, base = 8;
  8014dd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014e2:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8014e9:	eb 0d                	jmp    8014f8 <strtol+0xc8>
	else if (base == 0)
  8014eb:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014ef:	75 07                	jne    8014f8 <strtol+0xc8>
		base = 10;
  8014f1:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fc:	0f b6 00             	movzbl (%rax),%eax
  8014ff:	3c 2f                	cmp    $0x2f,%al
  801501:	7e 1d                	jle    801520 <strtol+0xf0>
  801503:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801507:	0f b6 00             	movzbl (%rax),%eax
  80150a:	3c 39                	cmp    $0x39,%al
  80150c:	7f 12                	jg     801520 <strtol+0xf0>
			dig = *s - '0';
  80150e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801512:	0f b6 00             	movzbl (%rax),%eax
  801515:	0f be c0             	movsbl %al,%eax
  801518:	83 e8 30             	sub    $0x30,%eax
  80151b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80151e:	eb 4e                	jmp    80156e <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801520:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801524:	0f b6 00             	movzbl (%rax),%eax
  801527:	3c 60                	cmp    $0x60,%al
  801529:	7e 1d                	jle    801548 <strtol+0x118>
  80152b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152f:	0f b6 00             	movzbl (%rax),%eax
  801532:	3c 7a                	cmp    $0x7a,%al
  801534:	7f 12                	jg     801548 <strtol+0x118>
			dig = *s - 'a' + 10;
  801536:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153a:	0f b6 00             	movzbl (%rax),%eax
  80153d:	0f be c0             	movsbl %al,%eax
  801540:	83 e8 57             	sub    $0x57,%eax
  801543:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801546:	eb 26                	jmp    80156e <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801548:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154c:	0f b6 00             	movzbl (%rax),%eax
  80154f:	3c 40                	cmp    $0x40,%al
  801551:	7e 48                	jle    80159b <strtol+0x16b>
  801553:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801557:	0f b6 00             	movzbl (%rax),%eax
  80155a:	3c 5a                	cmp    $0x5a,%al
  80155c:	7f 3d                	jg     80159b <strtol+0x16b>
			dig = *s - 'A' + 10;
  80155e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801562:	0f b6 00             	movzbl (%rax),%eax
  801565:	0f be c0             	movsbl %al,%eax
  801568:	83 e8 37             	sub    $0x37,%eax
  80156b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80156e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801571:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801574:	7c 02                	jl     801578 <strtol+0x148>
			break;
  801576:	eb 23                	jmp    80159b <strtol+0x16b>
		s++, val = (val * base) + dig;
  801578:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80157d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801580:	48 98                	cltq   
  801582:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801587:	48 89 c2             	mov    %rax,%rdx
  80158a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80158d:	48 98                	cltq   
  80158f:	48 01 d0             	add    %rdx,%rax
  801592:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801596:	e9 5d ff ff ff       	jmpq   8014f8 <strtol+0xc8>

	if (endptr)
  80159b:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8015a0:	74 0b                	je     8015ad <strtol+0x17d>
		*endptr = (char *) s;
  8015a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015a6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8015aa:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8015ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015b1:	74 09                	je     8015bc <strtol+0x18c>
  8015b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b7:	48 f7 d8             	neg    %rax
  8015ba:	eb 04                	jmp    8015c0 <strtol+0x190>
  8015bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8015c0:	c9                   	leaveq 
  8015c1:	c3                   	retq   

00000000008015c2 <strstr>:

char * strstr(const char *in, const char *str)
{
  8015c2:	55                   	push   %rbp
  8015c3:	48 89 e5             	mov    %rsp,%rbp
  8015c6:	48 83 ec 30          	sub    $0x30,%rsp
  8015ca:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015ce:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8015d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015d6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015da:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015de:	0f b6 00             	movzbl (%rax),%eax
  8015e1:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8015e4:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8015e8:	75 06                	jne    8015f0 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8015ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ee:	eb 6b                	jmp    80165b <strstr+0x99>

	len = strlen(str);
  8015f0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015f4:	48 89 c7             	mov    %rax,%rdi
  8015f7:	48 b8 98 0e 80 00 00 	movabs $0x800e98,%rax
  8015fe:	00 00 00 
  801601:	ff d0                	callq  *%rax
  801603:	48 98                	cltq   
  801605:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801609:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801611:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801615:	0f b6 00             	movzbl (%rax),%eax
  801618:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80161b:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80161f:	75 07                	jne    801628 <strstr+0x66>
				return (char *) 0;
  801621:	b8 00 00 00 00       	mov    $0x0,%eax
  801626:	eb 33                	jmp    80165b <strstr+0x99>
		} while (sc != c);
  801628:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80162c:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80162f:	75 d8                	jne    801609 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801631:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801635:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801639:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163d:	48 89 ce             	mov    %rcx,%rsi
  801640:	48 89 c7             	mov    %rax,%rdi
  801643:	48 b8 b9 10 80 00 00 	movabs $0x8010b9,%rax
  80164a:	00 00 00 
  80164d:	ff d0                	callq  *%rax
  80164f:	85 c0                	test   %eax,%eax
  801651:	75 b6                	jne    801609 <strstr+0x47>

	return (char *) (in - 1);
  801653:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801657:	48 83 e8 01          	sub    $0x1,%rax
}
  80165b:	c9                   	leaveq 
  80165c:	c3                   	retq   

000000000080165d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80165d:	55                   	push   %rbp
  80165e:	48 89 e5             	mov    %rsp,%rbp
  801661:	53                   	push   %rbx
  801662:	48 83 ec 48          	sub    $0x48,%rsp
  801666:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801669:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80166c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801670:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801674:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801678:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80167c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80167f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801683:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801687:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80168b:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80168f:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801693:	4c 89 c3             	mov    %r8,%rbx
  801696:	cd 30                	int    $0x30
  801698:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80169c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8016a0:	74 3e                	je     8016e0 <syscall+0x83>
  8016a2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016a7:	7e 37                	jle    8016e0 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016ad:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016b0:	49 89 d0             	mov    %rdx,%r8
  8016b3:	89 c1                	mov    %eax,%ecx
  8016b5:	48 ba 48 49 80 00 00 	movabs $0x804948,%rdx
  8016bc:	00 00 00 
  8016bf:	be 23 00 00 00       	mov    $0x23,%esi
  8016c4:	48 bf 65 49 80 00 00 	movabs $0x804965,%rdi
  8016cb:	00 00 00 
  8016ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d3:	49 b9 24 40 80 00 00 	movabs $0x804024,%r9
  8016da:	00 00 00 
  8016dd:	41 ff d1             	callq  *%r9

	return ret;
  8016e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016e4:	48 83 c4 48          	add    $0x48,%rsp
  8016e8:	5b                   	pop    %rbx
  8016e9:	5d                   	pop    %rbp
  8016ea:	c3                   	retq   

00000000008016eb <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8016eb:	55                   	push   %rbp
  8016ec:	48 89 e5             	mov    %rsp,%rbp
  8016ef:	48 83 ec 10          	sub    $0x10,%rsp
  8016f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016f7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801703:	48 83 ec 08          	sub    $0x8,%rsp
  801707:	6a 00                	pushq  $0x0
  801709:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80170f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801715:	48 89 d1             	mov    %rdx,%rcx
  801718:	48 89 c2             	mov    %rax,%rdx
  80171b:	be 00 00 00 00       	mov    $0x0,%esi
  801720:	bf 00 00 00 00       	mov    $0x0,%edi
  801725:	48 b8 5d 16 80 00 00 	movabs $0x80165d,%rax
  80172c:	00 00 00 
  80172f:	ff d0                	callq  *%rax
  801731:	48 83 c4 10          	add    $0x10,%rsp
}
  801735:	c9                   	leaveq 
  801736:	c3                   	retq   

0000000000801737 <sys_cgetc>:

int
sys_cgetc(void)
{
  801737:	55                   	push   %rbp
  801738:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80173b:	48 83 ec 08          	sub    $0x8,%rsp
  80173f:	6a 00                	pushq  $0x0
  801741:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801747:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80174d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801752:	ba 00 00 00 00       	mov    $0x0,%edx
  801757:	be 00 00 00 00       	mov    $0x0,%esi
  80175c:	bf 01 00 00 00       	mov    $0x1,%edi
  801761:	48 b8 5d 16 80 00 00 	movabs $0x80165d,%rax
  801768:	00 00 00 
  80176b:	ff d0                	callq  *%rax
  80176d:	48 83 c4 10          	add    $0x10,%rsp
}
  801771:	c9                   	leaveq 
  801772:	c3                   	retq   

0000000000801773 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801773:	55                   	push   %rbp
  801774:	48 89 e5             	mov    %rsp,%rbp
  801777:	48 83 ec 10          	sub    $0x10,%rsp
  80177b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80177e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801781:	48 98                	cltq   
  801783:	48 83 ec 08          	sub    $0x8,%rsp
  801787:	6a 00                	pushq  $0x0
  801789:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80178f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801795:	b9 00 00 00 00       	mov    $0x0,%ecx
  80179a:	48 89 c2             	mov    %rax,%rdx
  80179d:	be 01 00 00 00       	mov    $0x1,%esi
  8017a2:	bf 03 00 00 00       	mov    $0x3,%edi
  8017a7:	48 b8 5d 16 80 00 00 	movabs $0x80165d,%rax
  8017ae:	00 00 00 
  8017b1:	ff d0                	callq  *%rax
  8017b3:	48 83 c4 10          	add    $0x10,%rsp
}
  8017b7:	c9                   	leaveq 
  8017b8:	c3                   	retq   

00000000008017b9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8017b9:	55                   	push   %rbp
  8017ba:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8017bd:	48 83 ec 08          	sub    $0x8,%rsp
  8017c1:	6a 00                	pushq  $0x0
  8017c3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d9:	be 00 00 00 00       	mov    $0x0,%esi
  8017de:	bf 02 00 00 00       	mov    $0x2,%edi
  8017e3:	48 b8 5d 16 80 00 00 	movabs $0x80165d,%rax
  8017ea:	00 00 00 
  8017ed:	ff d0                	callq  *%rax
  8017ef:	48 83 c4 10          	add    $0x10,%rsp
}
  8017f3:	c9                   	leaveq 
  8017f4:	c3                   	retq   

00000000008017f5 <sys_yield>:

void
sys_yield(void)
{
  8017f5:	55                   	push   %rbp
  8017f6:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017f9:	48 83 ec 08          	sub    $0x8,%rsp
  8017fd:	6a 00                	pushq  $0x0
  8017ff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801805:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80180b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801810:	ba 00 00 00 00       	mov    $0x0,%edx
  801815:	be 00 00 00 00       	mov    $0x0,%esi
  80181a:	bf 0b 00 00 00       	mov    $0xb,%edi
  80181f:	48 b8 5d 16 80 00 00 	movabs $0x80165d,%rax
  801826:	00 00 00 
  801829:	ff d0                	callq  *%rax
  80182b:	48 83 c4 10          	add    $0x10,%rsp
}
  80182f:	c9                   	leaveq 
  801830:	c3                   	retq   

0000000000801831 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801831:	55                   	push   %rbp
  801832:	48 89 e5             	mov    %rsp,%rbp
  801835:	48 83 ec 10          	sub    $0x10,%rsp
  801839:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80183c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801840:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801843:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801846:	48 63 c8             	movslq %eax,%rcx
  801849:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80184d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801850:	48 98                	cltq   
  801852:	48 83 ec 08          	sub    $0x8,%rsp
  801856:	6a 00                	pushq  $0x0
  801858:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80185e:	49 89 c8             	mov    %rcx,%r8
  801861:	48 89 d1             	mov    %rdx,%rcx
  801864:	48 89 c2             	mov    %rax,%rdx
  801867:	be 01 00 00 00       	mov    $0x1,%esi
  80186c:	bf 04 00 00 00       	mov    $0x4,%edi
  801871:	48 b8 5d 16 80 00 00 	movabs $0x80165d,%rax
  801878:	00 00 00 
  80187b:	ff d0                	callq  *%rax
  80187d:	48 83 c4 10          	add    $0x10,%rsp
}
  801881:	c9                   	leaveq 
  801882:	c3                   	retq   

0000000000801883 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801883:	55                   	push   %rbp
  801884:	48 89 e5             	mov    %rsp,%rbp
  801887:	48 83 ec 20          	sub    $0x20,%rsp
  80188b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80188e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801892:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801895:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801899:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80189d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018a0:	48 63 c8             	movslq %eax,%rcx
  8018a3:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8018a7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018aa:	48 63 f0             	movslq %eax,%rsi
  8018ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018b4:	48 98                	cltq   
  8018b6:	48 83 ec 08          	sub    $0x8,%rsp
  8018ba:	51                   	push   %rcx
  8018bb:	49 89 f9             	mov    %rdi,%r9
  8018be:	49 89 f0             	mov    %rsi,%r8
  8018c1:	48 89 d1             	mov    %rdx,%rcx
  8018c4:	48 89 c2             	mov    %rax,%rdx
  8018c7:	be 01 00 00 00       	mov    $0x1,%esi
  8018cc:	bf 05 00 00 00       	mov    $0x5,%edi
  8018d1:	48 b8 5d 16 80 00 00 	movabs $0x80165d,%rax
  8018d8:	00 00 00 
  8018db:	ff d0                	callq  *%rax
  8018dd:	48 83 c4 10          	add    $0x10,%rsp
}
  8018e1:	c9                   	leaveq 
  8018e2:	c3                   	retq   

00000000008018e3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8018e3:	55                   	push   %rbp
  8018e4:	48 89 e5             	mov    %rsp,%rbp
  8018e7:	48 83 ec 10          	sub    $0x10,%rsp
  8018eb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018ee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8018f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018f9:	48 98                	cltq   
  8018fb:	48 83 ec 08          	sub    $0x8,%rsp
  8018ff:	6a 00                	pushq  $0x0
  801901:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801907:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80190d:	48 89 d1             	mov    %rdx,%rcx
  801910:	48 89 c2             	mov    %rax,%rdx
  801913:	be 01 00 00 00       	mov    $0x1,%esi
  801918:	bf 06 00 00 00       	mov    $0x6,%edi
  80191d:	48 b8 5d 16 80 00 00 	movabs $0x80165d,%rax
  801924:	00 00 00 
  801927:	ff d0                	callq  *%rax
  801929:	48 83 c4 10          	add    $0x10,%rsp
}
  80192d:	c9                   	leaveq 
  80192e:	c3                   	retq   

000000000080192f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80192f:	55                   	push   %rbp
  801930:	48 89 e5             	mov    %rsp,%rbp
  801933:	48 83 ec 10          	sub    $0x10,%rsp
  801937:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80193a:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80193d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801940:	48 63 d0             	movslq %eax,%rdx
  801943:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801946:	48 98                	cltq   
  801948:	48 83 ec 08          	sub    $0x8,%rsp
  80194c:	6a 00                	pushq  $0x0
  80194e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801954:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80195a:	48 89 d1             	mov    %rdx,%rcx
  80195d:	48 89 c2             	mov    %rax,%rdx
  801960:	be 01 00 00 00       	mov    $0x1,%esi
  801965:	bf 08 00 00 00       	mov    $0x8,%edi
  80196a:	48 b8 5d 16 80 00 00 	movabs $0x80165d,%rax
  801971:	00 00 00 
  801974:	ff d0                	callq  *%rax
  801976:	48 83 c4 10          	add    $0x10,%rsp
}
  80197a:	c9                   	leaveq 
  80197b:	c3                   	retq   

000000000080197c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80197c:	55                   	push   %rbp
  80197d:	48 89 e5             	mov    %rsp,%rbp
  801980:	48 83 ec 10          	sub    $0x10,%rsp
  801984:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801987:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80198b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80198f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801992:	48 98                	cltq   
  801994:	48 83 ec 08          	sub    $0x8,%rsp
  801998:	6a 00                	pushq  $0x0
  80199a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019a0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019a6:	48 89 d1             	mov    %rdx,%rcx
  8019a9:	48 89 c2             	mov    %rax,%rdx
  8019ac:	be 01 00 00 00       	mov    $0x1,%esi
  8019b1:	bf 09 00 00 00       	mov    $0x9,%edi
  8019b6:	48 b8 5d 16 80 00 00 	movabs $0x80165d,%rax
  8019bd:	00 00 00 
  8019c0:	ff d0                	callq  *%rax
  8019c2:	48 83 c4 10          	add    $0x10,%rsp
}
  8019c6:	c9                   	leaveq 
  8019c7:	c3                   	retq   

00000000008019c8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8019c8:	55                   	push   %rbp
  8019c9:	48 89 e5             	mov    %rsp,%rbp
  8019cc:	48 83 ec 10          	sub    $0x10,%rsp
  8019d0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8019d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019de:	48 98                	cltq   
  8019e0:	48 83 ec 08          	sub    $0x8,%rsp
  8019e4:	6a 00                	pushq  $0x0
  8019e6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019f2:	48 89 d1             	mov    %rdx,%rcx
  8019f5:	48 89 c2             	mov    %rax,%rdx
  8019f8:	be 01 00 00 00       	mov    $0x1,%esi
  8019fd:	bf 0a 00 00 00       	mov    $0xa,%edi
  801a02:	48 b8 5d 16 80 00 00 	movabs $0x80165d,%rax
  801a09:	00 00 00 
  801a0c:	ff d0                	callq  *%rax
  801a0e:	48 83 c4 10          	add    $0x10,%rsp
}
  801a12:	c9                   	leaveq 
  801a13:	c3                   	retq   

0000000000801a14 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a14:	55                   	push   %rbp
  801a15:	48 89 e5             	mov    %rsp,%rbp
  801a18:	48 83 ec 20          	sub    $0x20,%rsp
  801a1c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a1f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a23:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a27:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a2a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a2d:	48 63 f0             	movslq %eax,%rsi
  801a30:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a37:	48 98                	cltq   
  801a39:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a3d:	48 83 ec 08          	sub    $0x8,%rsp
  801a41:	6a 00                	pushq  $0x0
  801a43:	49 89 f1             	mov    %rsi,%r9
  801a46:	49 89 c8             	mov    %rcx,%r8
  801a49:	48 89 d1             	mov    %rdx,%rcx
  801a4c:	48 89 c2             	mov    %rax,%rdx
  801a4f:	be 00 00 00 00       	mov    $0x0,%esi
  801a54:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a59:	48 b8 5d 16 80 00 00 	movabs $0x80165d,%rax
  801a60:	00 00 00 
  801a63:	ff d0                	callq  *%rax
  801a65:	48 83 c4 10          	add    $0x10,%rsp
}
  801a69:	c9                   	leaveq 
  801a6a:	c3                   	retq   

0000000000801a6b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a6b:	55                   	push   %rbp
  801a6c:	48 89 e5             	mov    %rsp,%rbp
  801a6f:	48 83 ec 10          	sub    $0x10,%rsp
  801a73:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a7b:	48 83 ec 08          	sub    $0x8,%rsp
  801a7f:	6a 00                	pushq  $0x0
  801a81:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a87:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a8d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a92:	48 89 c2             	mov    %rax,%rdx
  801a95:	be 01 00 00 00       	mov    $0x1,%esi
  801a9a:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a9f:	48 b8 5d 16 80 00 00 	movabs $0x80165d,%rax
  801aa6:	00 00 00 
  801aa9:	ff d0                	callq  *%rax
  801aab:	48 83 c4 10          	add    $0x10,%rsp
}
  801aaf:	c9                   	leaveq 
  801ab0:	c3                   	retq   

0000000000801ab1 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801ab1:	55                   	push   %rbp
  801ab2:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801ab5:	48 83 ec 08          	sub    $0x8,%rsp
  801ab9:	6a 00                	pushq  $0x0
  801abb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ac1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ac7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801acc:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad1:	be 00 00 00 00       	mov    $0x0,%esi
  801ad6:	bf 0e 00 00 00       	mov    $0xe,%edi
  801adb:	48 b8 5d 16 80 00 00 	movabs $0x80165d,%rax
  801ae2:	00 00 00 
  801ae5:	ff d0                	callq  *%rax
  801ae7:	48 83 c4 10          	add    $0x10,%rsp
}
  801aeb:	c9                   	leaveq 
  801aec:	c3                   	retq   

0000000000801aed <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801aed:	55                   	push   %rbp
  801aee:	48 89 e5             	mov    %rsp,%rbp
  801af1:	48 83 ec 20          	sub    $0x20,%rsp
  801af5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801af8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801afc:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801aff:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b03:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801b07:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b0a:	48 63 c8             	movslq %eax,%rcx
  801b0d:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b11:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b14:	48 63 f0             	movslq %eax,%rsi
  801b17:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b1e:	48 98                	cltq   
  801b20:	48 83 ec 08          	sub    $0x8,%rsp
  801b24:	51                   	push   %rcx
  801b25:	49 89 f9             	mov    %rdi,%r9
  801b28:	49 89 f0             	mov    %rsi,%r8
  801b2b:	48 89 d1             	mov    %rdx,%rcx
  801b2e:	48 89 c2             	mov    %rax,%rdx
  801b31:	be 00 00 00 00       	mov    $0x0,%esi
  801b36:	bf 0f 00 00 00       	mov    $0xf,%edi
  801b3b:	48 b8 5d 16 80 00 00 	movabs $0x80165d,%rax
  801b42:	00 00 00 
  801b45:	ff d0                	callq  *%rax
  801b47:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801b4b:	c9                   	leaveq 
  801b4c:	c3                   	retq   

0000000000801b4d <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801b4d:	55                   	push   %rbp
  801b4e:	48 89 e5             	mov    %rsp,%rbp
  801b51:	48 83 ec 10          	sub    $0x10,%rsp
  801b55:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b59:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801b5d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b65:	48 83 ec 08          	sub    $0x8,%rsp
  801b69:	6a 00                	pushq  $0x0
  801b6b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b71:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b77:	48 89 d1             	mov    %rdx,%rcx
  801b7a:	48 89 c2             	mov    %rax,%rdx
  801b7d:	be 00 00 00 00       	mov    $0x0,%esi
  801b82:	bf 10 00 00 00       	mov    $0x10,%edi
  801b87:	48 b8 5d 16 80 00 00 	movabs $0x80165d,%rax
  801b8e:	00 00 00 
  801b91:	ff d0                	callq  *%rax
  801b93:	48 83 c4 10          	add    $0x10,%rsp
}
  801b97:	c9                   	leaveq 
  801b98:	c3                   	retq   

0000000000801b99 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801b99:	55                   	push   %rbp
  801b9a:	48 89 e5             	mov    %rsp,%rbp
  801b9d:	48 83 ec 18          	sub    $0x18,%rsp
  801ba1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ba5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ba9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  801bad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bb1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bb5:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  801bb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bbc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bc0:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801bc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bc8:	8b 00                	mov    (%rax),%eax
  801bca:	83 f8 01             	cmp    $0x1,%eax
  801bcd:	7e 13                	jle    801be2 <argstart+0x49>
  801bcf:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  801bd4:	74 0c                	je     801be2 <argstart+0x49>
  801bd6:	48 b8 73 49 80 00 00 	movabs $0x804973,%rax
  801bdd:	00 00 00 
  801be0:	eb 05                	jmp    801be7 <argstart+0x4e>
  801be2:	b8 00 00 00 00       	mov    $0x0,%eax
  801be7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801beb:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  801bef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bf3:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801bfa:	00 
}
  801bfb:	c9                   	leaveq 
  801bfc:	c3                   	retq   

0000000000801bfd <argnext>:

int
argnext(struct Argstate *args)
{
  801bfd:	55                   	push   %rbp
  801bfe:	48 89 e5             	mov    %rsp,%rbp
  801c01:	48 83 ec 20          	sub    $0x20,%rsp
  801c05:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  801c09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c0d:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801c14:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801c15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c19:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c1d:	48 85 c0             	test   %rax,%rax
  801c20:	75 0a                	jne    801c2c <argnext+0x2f>
		return -1;
  801c22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801c27:	e9 25 01 00 00       	jmpq   801d51 <argnext+0x154>

	if (!*args->curarg) {
  801c2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c30:	48 8b 40 10          	mov    0x10(%rax),%rax
  801c34:	0f b6 00             	movzbl (%rax),%eax
  801c37:	84 c0                	test   %al,%al
  801c39:	0f 85 d7 00 00 00    	jne    801d16 <argnext+0x119>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801c3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c43:	48 8b 00             	mov    (%rax),%rax
  801c46:	8b 00                	mov    (%rax),%eax
  801c48:	83 f8 01             	cmp    $0x1,%eax
  801c4b:	0f 84 ef 00 00 00    	je     801d40 <argnext+0x143>
		    || args->argv[1][0] != '-'
  801c51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c55:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c59:	48 83 c0 08          	add    $0x8,%rax
  801c5d:	48 8b 00             	mov    (%rax),%rax
  801c60:	0f b6 00             	movzbl (%rax),%eax
  801c63:	3c 2d                	cmp    $0x2d,%al
  801c65:	0f 85 d5 00 00 00    	jne    801d40 <argnext+0x143>
		    || args->argv[1][1] == '\0')
  801c6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c6f:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c73:	48 83 c0 08          	add    $0x8,%rax
  801c77:	48 8b 00             	mov    (%rax),%rax
  801c7a:	48 83 c0 01          	add    $0x1,%rax
  801c7e:	0f b6 00             	movzbl (%rax),%eax
  801c81:	84 c0                	test   %al,%al
  801c83:	0f 84 b7 00 00 00    	je     801d40 <argnext+0x143>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801c89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c8d:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c91:	48 83 c0 08          	add    $0x8,%rax
  801c95:	48 8b 00             	mov    (%rax),%rax
  801c98:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ca0:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801ca4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ca8:	48 8b 00             	mov    (%rax),%rax
  801cab:	8b 00                	mov    (%rax),%eax
  801cad:	83 e8 01             	sub    $0x1,%eax
  801cb0:	48 98                	cltq   
  801cb2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801cb9:	00 
  801cba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cbe:	48 8b 40 08          	mov    0x8(%rax),%rax
  801cc2:	48 8d 48 10          	lea    0x10(%rax),%rcx
  801cc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cca:	48 8b 40 08          	mov    0x8(%rax),%rax
  801cce:	48 83 c0 08          	add    $0x8,%rax
  801cd2:	48 89 ce             	mov    %rcx,%rsi
  801cd5:	48 89 c7             	mov    %rax,%rdi
  801cd8:	48 b8 28 12 80 00 00 	movabs $0x801228,%rax
  801cdf:	00 00 00 
  801ce2:	ff d0                	callq  *%rax
		(*args->argc)--;
  801ce4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ce8:	48 8b 00             	mov    (%rax),%rax
  801ceb:	8b 10                	mov    (%rax),%edx
  801ced:	83 ea 01             	sub    $0x1,%edx
  801cf0:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801cf2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cf6:	48 8b 40 10          	mov    0x10(%rax),%rax
  801cfa:	0f b6 00             	movzbl (%rax),%eax
  801cfd:	3c 2d                	cmp    $0x2d,%al
  801cff:	75 15                	jne    801d16 <argnext+0x119>
  801d01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d05:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d09:	48 83 c0 01          	add    $0x1,%rax
  801d0d:	0f b6 00             	movzbl (%rax),%eax
  801d10:	84 c0                	test   %al,%al
  801d12:	75 02                	jne    801d16 <argnext+0x119>
			goto endofargs;
  801d14:	eb 2a                	jmp    801d40 <argnext+0x143>
	}

	arg = (unsigned char) *args->curarg;
  801d16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d1a:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d1e:	0f b6 00             	movzbl (%rax),%eax
  801d21:	0f b6 c0             	movzbl %al,%eax
  801d24:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  801d27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d2b:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d2f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801d33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d37:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  801d3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d3e:	eb 11                	jmp    801d51 <argnext+0x154>

endofargs:
	args->curarg = 0;
  801d40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d44:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  801d4b:	00 
	return -1;
  801d4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801d51:	c9                   	leaveq 
  801d52:	c3                   	retq   

0000000000801d53 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  801d53:	55                   	push   %rbp
  801d54:	48 89 e5             	mov    %rsp,%rbp
  801d57:	48 83 ec 10          	sub    $0x10,%rsp
  801d5b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801d5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d63:	48 8b 40 18          	mov    0x18(%rax),%rax
  801d67:	48 85 c0             	test   %rax,%rax
  801d6a:	74 0a                	je     801d76 <argvalue+0x23>
  801d6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d70:	48 8b 40 18          	mov    0x18(%rax),%rax
  801d74:	eb 13                	jmp    801d89 <argvalue+0x36>
  801d76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d7a:	48 89 c7             	mov    %rax,%rdi
  801d7d:	48 b8 8b 1d 80 00 00 	movabs $0x801d8b,%rax
  801d84:	00 00 00 
  801d87:	ff d0                	callq  *%rax
}
  801d89:	c9                   	leaveq 
  801d8a:	c3                   	retq   

0000000000801d8b <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  801d8b:	55                   	push   %rbp
  801d8c:	48 89 e5             	mov    %rsp,%rbp
  801d8f:	48 83 ec 10          	sub    $0x10,%rsp
  801d93:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (!args->curarg)
  801d97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d9b:	48 8b 40 10          	mov    0x10(%rax),%rax
  801d9f:	48 85 c0             	test   %rax,%rax
  801da2:	75 0a                	jne    801dae <argnextvalue+0x23>
		return 0;
  801da4:	b8 00 00 00 00       	mov    $0x0,%eax
  801da9:	e9 c8 00 00 00       	jmpq   801e76 <argnextvalue+0xeb>
	if (*args->curarg) {
  801dae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801db2:	48 8b 40 10          	mov    0x10(%rax),%rax
  801db6:	0f b6 00             	movzbl (%rax),%eax
  801db9:	84 c0                	test   %al,%al
  801dbb:	74 27                	je     801de4 <argnextvalue+0x59>
		args->argvalue = args->curarg;
  801dbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dc1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801dc5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dc9:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  801dcd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dd1:	48 be 73 49 80 00 00 	movabs $0x804973,%rsi
  801dd8:	00 00 00 
  801ddb:	48 89 70 10          	mov    %rsi,0x10(%rax)
  801ddf:	e9 8a 00 00 00       	jmpq   801e6e <argnextvalue+0xe3>
	} else if (*args->argc > 1) {
  801de4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801de8:	48 8b 00             	mov    (%rax),%rax
  801deb:	8b 00                	mov    (%rax),%eax
  801ded:	83 f8 01             	cmp    $0x1,%eax
  801df0:	7e 64                	jle    801e56 <argnextvalue+0xcb>
		args->argvalue = args->argv[1];
  801df2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801df6:	48 8b 40 08          	mov    0x8(%rax),%rax
  801dfa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801dfe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e02:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801e06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e0a:	48 8b 00             	mov    (%rax),%rax
  801e0d:	8b 00                	mov    (%rax),%eax
  801e0f:	83 e8 01             	sub    $0x1,%eax
  801e12:	48 98                	cltq   
  801e14:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801e1b:	00 
  801e1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e20:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e24:	48 8d 48 10          	lea    0x10(%rax),%rcx
  801e28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e2c:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e30:	48 83 c0 08          	add    $0x8,%rax
  801e34:	48 89 ce             	mov    %rcx,%rsi
  801e37:	48 89 c7             	mov    %rax,%rdi
  801e3a:	48 b8 28 12 80 00 00 	movabs $0x801228,%rax
  801e41:	00 00 00 
  801e44:	ff d0                	callq  *%rax
		(*args->argc)--;
  801e46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e4a:	48 8b 00             	mov    (%rax),%rax
  801e4d:	8b 10                	mov    (%rax),%edx
  801e4f:	83 ea 01             	sub    $0x1,%edx
  801e52:	89 10                	mov    %edx,(%rax)
  801e54:	eb 18                	jmp    801e6e <argnextvalue+0xe3>
	} else {
		args->argvalue = 0;
  801e56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e5a:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801e61:	00 
		args->curarg = 0;
  801e62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e66:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  801e6d:	00 
	}
	return (char*) args->argvalue;
  801e6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e72:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  801e76:	c9                   	leaveq 
  801e77:	c3                   	retq   

0000000000801e78 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801e78:	55                   	push   %rbp
  801e79:	48 89 e5             	mov    %rsp,%rbp
  801e7c:	48 83 ec 08          	sub    $0x8,%rsp
  801e80:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e84:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e88:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801e8f:	ff ff ff 
  801e92:	48 01 d0             	add    %rdx,%rax
  801e95:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801e99:	c9                   	leaveq 
  801e9a:	c3                   	retq   

0000000000801e9b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e9b:	55                   	push   %rbp
  801e9c:	48 89 e5             	mov    %rsp,%rbp
  801e9f:	48 83 ec 08          	sub    $0x8,%rsp
  801ea3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801ea7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eab:	48 89 c7             	mov    %rax,%rdi
  801eae:	48 b8 78 1e 80 00 00 	movabs $0x801e78,%rax
  801eb5:	00 00 00 
  801eb8:	ff d0                	callq  *%rax
  801eba:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801ec0:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ec4:	c9                   	leaveq 
  801ec5:	c3                   	retq   

0000000000801ec6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ec6:	55                   	push   %rbp
  801ec7:	48 89 e5             	mov    %rsp,%rbp
  801eca:	48 83 ec 18          	sub    $0x18,%rsp
  801ece:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ed2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ed9:	eb 6b                	jmp    801f46 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801edb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ede:	48 98                	cltq   
  801ee0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ee6:	48 c1 e0 0c          	shl    $0xc,%rax
  801eea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801eee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ef2:	48 c1 e8 15          	shr    $0x15,%rax
  801ef6:	48 89 c2             	mov    %rax,%rdx
  801ef9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f00:	01 00 00 
  801f03:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f07:	83 e0 01             	and    $0x1,%eax
  801f0a:	48 85 c0             	test   %rax,%rax
  801f0d:	74 21                	je     801f30 <fd_alloc+0x6a>
  801f0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f13:	48 c1 e8 0c          	shr    $0xc,%rax
  801f17:	48 89 c2             	mov    %rax,%rdx
  801f1a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f21:	01 00 00 
  801f24:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f28:	83 e0 01             	and    $0x1,%eax
  801f2b:	48 85 c0             	test   %rax,%rax
  801f2e:	75 12                	jne    801f42 <fd_alloc+0x7c>
			*fd_store = fd;
  801f30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f34:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f38:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f3b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f40:	eb 1a                	jmp    801f5c <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  801f42:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f46:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f4a:	7e 8f                	jle    801edb <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  801f4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f50:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801f57:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801f5c:	c9                   	leaveq 
  801f5d:	c3                   	retq   

0000000000801f5e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f5e:	55                   	push   %rbp
  801f5f:	48 89 e5             	mov    %rsp,%rbp
  801f62:	48 83 ec 20          	sub    $0x20,%rsp
  801f66:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f69:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f6d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f71:	78 06                	js     801f79 <fd_lookup+0x1b>
  801f73:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801f77:	7e 07                	jle    801f80 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f79:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f7e:	eb 6c                	jmp    801fec <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801f80:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f83:	48 98                	cltq   
  801f85:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f8b:	48 c1 e0 0c          	shl    $0xc,%rax
  801f8f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f97:	48 c1 e8 15          	shr    $0x15,%rax
  801f9b:	48 89 c2             	mov    %rax,%rdx
  801f9e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fa5:	01 00 00 
  801fa8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fac:	83 e0 01             	and    $0x1,%eax
  801faf:	48 85 c0             	test   %rax,%rax
  801fb2:	74 21                	je     801fd5 <fd_lookup+0x77>
  801fb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fb8:	48 c1 e8 0c          	shr    $0xc,%rax
  801fbc:	48 89 c2             	mov    %rax,%rdx
  801fbf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fc6:	01 00 00 
  801fc9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fcd:	83 e0 01             	and    $0x1,%eax
  801fd0:	48 85 c0             	test   %rax,%rax
  801fd3:	75 07                	jne    801fdc <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fd5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fda:	eb 10                	jmp    801fec <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801fdc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fe0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801fe4:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801fe7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fec:	c9                   	leaveq 
  801fed:	c3                   	retq   

0000000000801fee <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801fee:	55                   	push   %rbp
  801fef:	48 89 e5             	mov    %rsp,%rbp
  801ff2:	48 83 ec 30          	sub    $0x30,%rsp
  801ff6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ffa:	89 f0                	mov    %esi,%eax
  801ffc:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801fff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802003:	48 89 c7             	mov    %rax,%rdi
  802006:	48 b8 78 1e 80 00 00 	movabs $0x801e78,%rax
  80200d:	00 00 00 
  802010:	ff d0                	callq  *%rax
  802012:	89 c2                	mov    %eax,%edx
  802014:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802018:	48 89 c6             	mov    %rax,%rsi
  80201b:	89 d7                	mov    %edx,%edi
  80201d:	48 b8 5e 1f 80 00 00 	movabs $0x801f5e,%rax
  802024:	00 00 00 
  802027:	ff d0                	callq  *%rax
  802029:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80202c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802030:	78 0a                	js     80203c <fd_close+0x4e>
	    || fd != fd2)
  802032:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802036:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80203a:	74 12                	je     80204e <fd_close+0x60>
		return (must_exist ? r : 0);
  80203c:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802040:	74 05                	je     802047 <fd_close+0x59>
  802042:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802045:	eb 70                	jmp    8020b7 <fd_close+0xc9>
  802047:	b8 00 00 00 00       	mov    $0x0,%eax
  80204c:	eb 69                	jmp    8020b7 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80204e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802052:	8b 00                	mov    (%rax),%eax
  802054:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802058:	48 89 d6             	mov    %rdx,%rsi
  80205b:	89 c7                	mov    %eax,%edi
  80205d:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  802064:	00 00 00 
  802067:	ff d0                	callq  *%rax
  802069:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80206c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802070:	78 2a                	js     80209c <fd_close+0xae>
		if (dev->dev_close)
  802072:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802076:	48 8b 40 20          	mov    0x20(%rax),%rax
  80207a:	48 85 c0             	test   %rax,%rax
  80207d:	74 16                	je     802095 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  80207f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802083:	48 8b 40 20          	mov    0x20(%rax),%rax
  802087:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80208b:	48 89 d7             	mov    %rdx,%rdi
  80208e:	ff d0                	callq  *%rax
  802090:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802093:	eb 07                	jmp    80209c <fd_close+0xae>
		else
			r = 0;
  802095:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80209c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020a0:	48 89 c6             	mov    %rax,%rsi
  8020a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8020a8:	48 b8 e3 18 80 00 00 	movabs $0x8018e3,%rax
  8020af:	00 00 00 
  8020b2:	ff d0                	callq  *%rax
	return r;
  8020b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020b7:	c9                   	leaveq 
  8020b8:	c3                   	retq   

00000000008020b9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8020b9:	55                   	push   %rbp
  8020ba:	48 89 e5             	mov    %rsp,%rbp
  8020bd:	48 83 ec 20          	sub    $0x20,%rsp
  8020c1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020c4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8020c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020cf:	eb 41                	jmp    802112 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8020d1:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020d8:	00 00 00 
  8020db:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020de:	48 63 d2             	movslq %edx,%rdx
  8020e1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020e5:	8b 00                	mov    (%rax),%eax
  8020e7:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8020ea:	75 22                	jne    80210e <dev_lookup+0x55>
			*dev = devtab[i];
  8020ec:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020f3:	00 00 00 
  8020f6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020f9:	48 63 d2             	movslq %edx,%rdx
  8020fc:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802100:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802104:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802107:	b8 00 00 00 00       	mov    $0x0,%eax
  80210c:	eb 60                	jmp    80216e <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  80210e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802112:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802119:	00 00 00 
  80211c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80211f:	48 63 d2             	movslq %edx,%rdx
  802122:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802126:	48 85 c0             	test   %rax,%rax
  802129:	75 a6                	jne    8020d1 <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80212b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802132:	00 00 00 
  802135:	48 8b 00             	mov    (%rax),%rax
  802138:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80213e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802141:	89 c6                	mov    %eax,%esi
  802143:	48 bf 78 49 80 00 00 	movabs $0x804978,%rdi
  80214a:	00 00 00 
  80214d:	b8 00 00 00 00       	mov    $0x0,%eax
  802152:	48 b9 6a 03 80 00 00 	movabs $0x80036a,%rcx
  802159:	00 00 00 
  80215c:	ff d1                	callq  *%rcx
	*dev = 0;
  80215e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802162:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802169:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80216e:	c9                   	leaveq 
  80216f:	c3                   	retq   

0000000000802170 <close>:

int
close(int fdnum)
{
  802170:	55                   	push   %rbp
  802171:	48 89 e5             	mov    %rsp,%rbp
  802174:	48 83 ec 20          	sub    $0x20,%rsp
  802178:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80217b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80217f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802182:	48 89 d6             	mov    %rdx,%rsi
  802185:	89 c7                	mov    %eax,%edi
  802187:	48 b8 5e 1f 80 00 00 	movabs $0x801f5e,%rax
  80218e:	00 00 00 
  802191:	ff d0                	callq  *%rax
  802193:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802196:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80219a:	79 05                	jns    8021a1 <close+0x31>
		return r;
  80219c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80219f:	eb 18                	jmp    8021b9 <close+0x49>
	else
		return fd_close(fd, 1);
  8021a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021a5:	be 01 00 00 00       	mov    $0x1,%esi
  8021aa:	48 89 c7             	mov    %rax,%rdi
  8021ad:	48 b8 ee 1f 80 00 00 	movabs $0x801fee,%rax
  8021b4:	00 00 00 
  8021b7:	ff d0                	callq  *%rax
}
  8021b9:	c9                   	leaveq 
  8021ba:	c3                   	retq   

00000000008021bb <close_all>:

void
close_all(void)
{
  8021bb:	55                   	push   %rbp
  8021bc:	48 89 e5             	mov    %rsp,%rbp
  8021bf:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8021c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021ca:	eb 15                	jmp    8021e1 <close_all+0x26>
		close(i);
  8021cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021cf:	89 c7                	mov    %eax,%edi
  8021d1:	48 b8 70 21 80 00 00 	movabs $0x802170,%rax
  8021d8:	00 00 00 
  8021db:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  8021dd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021e1:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8021e5:	7e e5                	jle    8021cc <close_all+0x11>
}
  8021e7:	c9                   	leaveq 
  8021e8:	c3                   	retq   

00000000008021e9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8021e9:	55                   	push   %rbp
  8021ea:	48 89 e5             	mov    %rsp,%rbp
  8021ed:	48 83 ec 40          	sub    $0x40,%rsp
  8021f1:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8021f4:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8021f7:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8021fb:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8021fe:	48 89 d6             	mov    %rdx,%rsi
  802201:	89 c7                	mov    %eax,%edi
  802203:	48 b8 5e 1f 80 00 00 	movabs $0x801f5e,%rax
  80220a:	00 00 00 
  80220d:	ff d0                	callq  *%rax
  80220f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802212:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802216:	79 08                	jns    802220 <dup+0x37>
		return r;
  802218:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80221b:	e9 70 01 00 00       	jmpq   802390 <dup+0x1a7>
	close(newfdnum);
  802220:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802223:	89 c7                	mov    %eax,%edi
  802225:	48 b8 70 21 80 00 00 	movabs $0x802170,%rax
  80222c:	00 00 00 
  80222f:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802231:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802234:	48 98                	cltq   
  802236:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80223c:	48 c1 e0 0c          	shl    $0xc,%rax
  802240:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802244:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802248:	48 89 c7             	mov    %rax,%rdi
  80224b:	48 b8 9b 1e 80 00 00 	movabs $0x801e9b,%rax
  802252:	00 00 00 
  802255:	ff d0                	callq  *%rax
  802257:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80225b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80225f:	48 89 c7             	mov    %rax,%rdi
  802262:	48 b8 9b 1e 80 00 00 	movabs $0x801e9b,%rax
  802269:	00 00 00 
  80226c:	ff d0                	callq  *%rax
  80226e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802272:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802276:	48 c1 e8 15          	shr    $0x15,%rax
  80227a:	48 89 c2             	mov    %rax,%rdx
  80227d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802284:	01 00 00 
  802287:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80228b:	83 e0 01             	and    $0x1,%eax
  80228e:	48 85 c0             	test   %rax,%rax
  802291:	74 73                	je     802306 <dup+0x11d>
  802293:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802297:	48 c1 e8 0c          	shr    $0xc,%rax
  80229b:	48 89 c2             	mov    %rax,%rdx
  80229e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022a5:	01 00 00 
  8022a8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022ac:	83 e0 01             	and    $0x1,%eax
  8022af:	48 85 c0             	test   %rax,%rax
  8022b2:	74 52                	je     802306 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8022b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b8:	48 c1 e8 0c          	shr    $0xc,%rax
  8022bc:	48 89 c2             	mov    %rax,%rdx
  8022bf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022c6:	01 00 00 
  8022c9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022cd:	25 07 0e 00 00       	and    $0xe07,%eax
  8022d2:	89 c1                	mov    %eax,%ecx
  8022d4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022dc:	41 89 c8             	mov    %ecx,%r8d
  8022df:	48 89 d1             	mov    %rdx,%rcx
  8022e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8022e7:	48 89 c6             	mov    %rax,%rsi
  8022ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8022ef:	48 b8 83 18 80 00 00 	movabs $0x801883,%rax
  8022f6:	00 00 00 
  8022f9:	ff d0                	callq  *%rax
  8022fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802302:	79 02                	jns    802306 <dup+0x11d>
			goto err;
  802304:	eb 57                	jmp    80235d <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802306:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80230a:	48 c1 e8 0c          	shr    $0xc,%rax
  80230e:	48 89 c2             	mov    %rax,%rdx
  802311:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802318:	01 00 00 
  80231b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80231f:	25 07 0e 00 00       	and    $0xe07,%eax
  802324:	89 c1                	mov    %eax,%ecx
  802326:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80232a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80232e:	41 89 c8             	mov    %ecx,%r8d
  802331:	48 89 d1             	mov    %rdx,%rcx
  802334:	ba 00 00 00 00       	mov    $0x0,%edx
  802339:	48 89 c6             	mov    %rax,%rsi
  80233c:	bf 00 00 00 00       	mov    $0x0,%edi
  802341:	48 b8 83 18 80 00 00 	movabs $0x801883,%rax
  802348:	00 00 00 
  80234b:	ff d0                	callq  *%rax
  80234d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802350:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802354:	79 02                	jns    802358 <dup+0x16f>
		goto err;
  802356:	eb 05                	jmp    80235d <dup+0x174>

	return newfdnum;
  802358:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80235b:	eb 33                	jmp    802390 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80235d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802361:	48 89 c6             	mov    %rax,%rsi
  802364:	bf 00 00 00 00       	mov    $0x0,%edi
  802369:	48 b8 e3 18 80 00 00 	movabs $0x8018e3,%rax
  802370:	00 00 00 
  802373:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802375:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802379:	48 89 c6             	mov    %rax,%rsi
  80237c:	bf 00 00 00 00       	mov    $0x0,%edi
  802381:	48 b8 e3 18 80 00 00 	movabs $0x8018e3,%rax
  802388:	00 00 00 
  80238b:	ff d0                	callq  *%rax
	return r;
  80238d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802390:	c9                   	leaveq 
  802391:	c3                   	retq   

0000000000802392 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802392:	55                   	push   %rbp
  802393:	48 89 e5             	mov    %rsp,%rbp
  802396:	48 83 ec 40          	sub    $0x40,%rsp
  80239a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80239d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023a1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023a5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023a9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023ac:	48 89 d6             	mov    %rdx,%rsi
  8023af:	89 c7                	mov    %eax,%edi
  8023b1:	48 b8 5e 1f 80 00 00 	movabs $0x801f5e,%rax
  8023b8:	00 00 00 
  8023bb:	ff d0                	callq  *%rax
  8023bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c4:	78 24                	js     8023ea <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ca:	8b 00                	mov    (%rax),%eax
  8023cc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023d0:	48 89 d6             	mov    %rdx,%rsi
  8023d3:	89 c7                	mov    %eax,%edi
  8023d5:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  8023dc:	00 00 00 
  8023df:	ff d0                	callq  *%rax
  8023e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e8:	79 05                	jns    8023ef <read+0x5d>
		return r;
  8023ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ed:	eb 76                	jmp    802465 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8023ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f3:	8b 40 08             	mov    0x8(%rax),%eax
  8023f6:	83 e0 03             	and    $0x3,%eax
  8023f9:	83 f8 01             	cmp    $0x1,%eax
  8023fc:	75 3a                	jne    802438 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8023fe:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802405:	00 00 00 
  802408:	48 8b 00             	mov    (%rax),%rax
  80240b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802411:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802414:	89 c6                	mov    %eax,%esi
  802416:	48 bf 97 49 80 00 00 	movabs $0x804997,%rdi
  80241d:	00 00 00 
  802420:	b8 00 00 00 00       	mov    $0x0,%eax
  802425:	48 b9 6a 03 80 00 00 	movabs $0x80036a,%rcx
  80242c:	00 00 00 
  80242f:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802431:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802436:	eb 2d                	jmp    802465 <read+0xd3>
	}
	if (!dev->dev_read)
  802438:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80243c:	48 8b 40 10          	mov    0x10(%rax),%rax
  802440:	48 85 c0             	test   %rax,%rax
  802443:	75 07                	jne    80244c <read+0xba>
		return -E_NOT_SUPP;
  802445:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80244a:	eb 19                	jmp    802465 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80244c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802450:	48 8b 40 10          	mov    0x10(%rax),%rax
  802454:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802458:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80245c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802460:	48 89 cf             	mov    %rcx,%rdi
  802463:	ff d0                	callq  *%rax
}
  802465:	c9                   	leaveq 
  802466:	c3                   	retq   

0000000000802467 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802467:	55                   	push   %rbp
  802468:	48 89 e5             	mov    %rsp,%rbp
  80246b:	48 83 ec 30          	sub    $0x30,%rsp
  80246f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802472:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802476:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80247a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802481:	eb 49                	jmp    8024cc <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802483:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802486:	48 98                	cltq   
  802488:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80248c:	48 29 c2             	sub    %rax,%rdx
  80248f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802492:	48 63 c8             	movslq %eax,%rcx
  802495:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802499:	48 01 c1             	add    %rax,%rcx
  80249c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80249f:	48 89 ce             	mov    %rcx,%rsi
  8024a2:	89 c7                	mov    %eax,%edi
  8024a4:	48 b8 92 23 80 00 00 	movabs $0x802392,%rax
  8024ab:	00 00 00 
  8024ae:	ff d0                	callq  *%rax
  8024b0:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8024b3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024b7:	79 05                	jns    8024be <readn+0x57>
			return m;
  8024b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024bc:	eb 1c                	jmp    8024da <readn+0x73>
		if (m == 0)
  8024be:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024c2:	75 02                	jne    8024c6 <readn+0x5f>
			break;
  8024c4:	eb 11                	jmp    8024d7 <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  8024c6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024c9:	01 45 fc             	add    %eax,-0x4(%rbp)
  8024cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024cf:	48 98                	cltq   
  8024d1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8024d5:	72 ac                	jb     802483 <readn+0x1c>
	}
	return tot;
  8024d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024da:	c9                   	leaveq 
  8024db:	c3                   	retq   

00000000008024dc <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8024dc:	55                   	push   %rbp
  8024dd:	48 89 e5             	mov    %rsp,%rbp
  8024e0:	48 83 ec 40          	sub    $0x40,%rsp
  8024e4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024e7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8024eb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024ef:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024f3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024f6:	48 89 d6             	mov    %rdx,%rsi
  8024f9:	89 c7                	mov    %eax,%edi
  8024fb:	48 b8 5e 1f 80 00 00 	movabs $0x801f5e,%rax
  802502:	00 00 00 
  802505:	ff d0                	callq  *%rax
  802507:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80250a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80250e:	78 24                	js     802534 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802510:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802514:	8b 00                	mov    (%rax),%eax
  802516:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80251a:	48 89 d6             	mov    %rdx,%rsi
  80251d:	89 c7                	mov    %eax,%edi
  80251f:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  802526:	00 00 00 
  802529:	ff d0                	callq  *%rax
  80252b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80252e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802532:	79 05                	jns    802539 <write+0x5d>
		return r;
  802534:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802537:	eb 75                	jmp    8025ae <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802539:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80253d:	8b 40 08             	mov    0x8(%rax),%eax
  802540:	83 e0 03             	and    $0x3,%eax
  802543:	85 c0                	test   %eax,%eax
  802545:	75 3a                	jne    802581 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802547:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80254e:	00 00 00 
  802551:	48 8b 00             	mov    (%rax),%rax
  802554:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80255a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80255d:	89 c6                	mov    %eax,%esi
  80255f:	48 bf b3 49 80 00 00 	movabs $0x8049b3,%rdi
  802566:	00 00 00 
  802569:	b8 00 00 00 00       	mov    $0x0,%eax
  80256e:	48 b9 6a 03 80 00 00 	movabs $0x80036a,%rcx
  802575:	00 00 00 
  802578:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80257a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80257f:	eb 2d                	jmp    8025ae <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802581:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802585:	48 8b 40 18          	mov    0x18(%rax),%rax
  802589:	48 85 c0             	test   %rax,%rax
  80258c:	75 07                	jne    802595 <write+0xb9>
		return -E_NOT_SUPP;
  80258e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802593:	eb 19                	jmp    8025ae <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802595:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802599:	48 8b 40 18          	mov    0x18(%rax),%rax
  80259d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8025a1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025a5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025a9:	48 89 cf             	mov    %rcx,%rdi
  8025ac:	ff d0                	callq  *%rax
}
  8025ae:	c9                   	leaveq 
  8025af:	c3                   	retq   

00000000008025b0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8025b0:	55                   	push   %rbp
  8025b1:	48 89 e5             	mov    %rsp,%rbp
  8025b4:	48 83 ec 18          	sub    $0x18,%rsp
  8025b8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025bb:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025be:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025c5:	48 89 d6             	mov    %rdx,%rsi
  8025c8:	89 c7                	mov    %eax,%edi
  8025ca:	48 b8 5e 1f 80 00 00 	movabs $0x801f5e,%rax
  8025d1:	00 00 00 
  8025d4:	ff d0                	callq  *%rax
  8025d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025dd:	79 05                	jns    8025e4 <seek+0x34>
		return r;
  8025df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e2:	eb 0f                	jmp    8025f3 <seek+0x43>
	fd->fd_offset = offset;
  8025e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8025eb:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8025ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025f3:	c9                   	leaveq 
  8025f4:	c3                   	retq   

00000000008025f5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8025f5:	55                   	push   %rbp
  8025f6:	48 89 e5             	mov    %rsp,%rbp
  8025f9:	48 83 ec 30          	sub    $0x30,%rsp
  8025fd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802600:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802603:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802607:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80260a:	48 89 d6             	mov    %rdx,%rsi
  80260d:	89 c7                	mov    %eax,%edi
  80260f:	48 b8 5e 1f 80 00 00 	movabs $0x801f5e,%rax
  802616:	00 00 00 
  802619:	ff d0                	callq  *%rax
  80261b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802622:	78 24                	js     802648 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802624:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802628:	8b 00                	mov    (%rax),%eax
  80262a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80262e:	48 89 d6             	mov    %rdx,%rsi
  802631:	89 c7                	mov    %eax,%edi
  802633:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  80263a:	00 00 00 
  80263d:	ff d0                	callq  *%rax
  80263f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802642:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802646:	79 05                	jns    80264d <ftruncate+0x58>
		return r;
  802648:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80264b:	eb 72                	jmp    8026bf <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80264d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802651:	8b 40 08             	mov    0x8(%rax),%eax
  802654:	83 e0 03             	and    $0x3,%eax
  802657:	85 c0                	test   %eax,%eax
  802659:	75 3a                	jne    802695 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80265b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802662:	00 00 00 
  802665:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802668:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80266e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802671:	89 c6                	mov    %eax,%esi
  802673:	48 bf d0 49 80 00 00 	movabs $0x8049d0,%rdi
  80267a:	00 00 00 
  80267d:	b8 00 00 00 00       	mov    $0x0,%eax
  802682:	48 b9 6a 03 80 00 00 	movabs $0x80036a,%rcx
  802689:	00 00 00 
  80268c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80268e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802693:	eb 2a                	jmp    8026bf <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802695:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802699:	48 8b 40 30          	mov    0x30(%rax),%rax
  80269d:	48 85 c0             	test   %rax,%rax
  8026a0:	75 07                	jne    8026a9 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8026a2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026a7:	eb 16                	jmp    8026bf <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8026a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ad:	48 8b 40 30          	mov    0x30(%rax),%rax
  8026b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026b5:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8026b8:	89 ce                	mov    %ecx,%esi
  8026ba:	48 89 d7             	mov    %rdx,%rdi
  8026bd:	ff d0                	callq  *%rax
}
  8026bf:	c9                   	leaveq 
  8026c0:	c3                   	retq   

00000000008026c1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8026c1:	55                   	push   %rbp
  8026c2:	48 89 e5             	mov    %rsp,%rbp
  8026c5:	48 83 ec 30          	sub    $0x30,%rsp
  8026c9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026cc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026d0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026d4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026d7:	48 89 d6             	mov    %rdx,%rsi
  8026da:	89 c7                	mov    %eax,%edi
  8026dc:	48 b8 5e 1f 80 00 00 	movabs $0x801f5e,%rax
  8026e3:	00 00 00 
  8026e6:	ff d0                	callq  *%rax
  8026e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ef:	78 24                	js     802715 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f5:	8b 00                	mov    (%rax),%eax
  8026f7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026fb:	48 89 d6             	mov    %rdx,%rsi
  8026fe:	89 c7                	mov    %eax,%edi
  802700:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  802707:	00 00 00 
  80270a:	ff d0                	callq  *%rax
  80270c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80270f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802713:	79 05                	jns    80271a <fstat+0x59>
		return r;
  802715:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802718:	eb 5e                	jmp    802778 <fstat+0xb7>
	if (!dev->dev_stat)
  80271a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80271e:	48 8b 40 28          	mov    0x28(%rax),%rax
  802722:	48 85 c0             	test   %rax,%rax
  802725:	75 07                	jne    80272e <fstat+0x6d>
		return -E_NOT_SUPP;
  802727:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80272c:	eb 4a                	jmp    802778 <fstat+0xb7>
	stat->st_name[0] = 0;
  80272e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802732:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802735:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802739:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802740:	00 00 00 
	stat->st_isdir = 0;
  802743:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802747:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80274e:	00 00 00 
	stat->st_dev = dev;
  802751:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802755:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802759:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802760:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802764:	48 8b 40 28          	mov    0x28(%rax),%rax
  802768:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80276c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802770:	48 89 ce             	mov    %rcx,%rsi
  802773:	48 89 d7             	mov    %rdx,%rdi
  802776:	ff d0                	callq  *%rax
}
  802778:	c9                   	leaveq 
  802779:	c3                   	retq   

000000000080277a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80277a:	55                   	push   %rbp
  80277b:	48 89 e5             	mov    %rsp,%rbp
  80277e:	48 83 ec 20          	sub    $0x20,%rsp
  802782:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802786:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80278a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80278e:	be 00 00 00 00       	mov    $0x0,%esi
  802793:	48 89 c7             	mov    %rax,%rdi
  802796:	48 b8 6a 28 80 00 00 	movabs $0x80286a,%rax
  80279d:	00 00 00 
  8027a0:	ff d0                	callq  *%rax
  8027a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a9:	79 05                	jns    8027b0 <stat+0x36>
		return fd;
  8027ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ae:	eb 2f                	jmp    8027df <stat+0x65>
	r = fstat(fd, stat);
  8027b0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b7:	48 89 d6             	mov    %rdx,%rsi
  8027ba:	89 c7                	mov    %eax,%edi
  8027bc:	48 b8 c1 26 80 00 00 	movabs $0x8026c1,%rax
  8027c3:	00 00 00 
  8027c6:	ff d0                	callq  *%rax
  8027c8:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8027cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ce:	89 c7                	mov    %eax,%edi
  8027d0:	48 b8 70 21 80 00 00 	movabs $0x802170,%rax
  8027d7:	00 00 00 
  8027da:	ff d0                	callq  *%rax
	return r;
  8027dc:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8027df:	c9                   	leaveq 
  8027e0:	c3                   	retq   

00000000008027e1 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8027e1:	55                   	push   %rbp
  8027e2:	48 89 e5             	mov    %rsp,%rbp
  8027e5:	48 83 ec 10          	sub    $0x10,%rsp
  8027e9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8027ec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8027f0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027f7:	00 00 00 
  8027fa:	8b 00                	mov    (%rax),%eax
  8027fc:	85 c0                	test   %eax,%eax
  8027fe:	75 1f                	jne    80281f <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802800:	bf 01 00 00 00       	mov    $0x1,%edi
  802805:	48 b8 03 43 80 00 00 	movabs $0x804303,%rax
  80280c:	00 00 00 
  80280f:	ff d0                	callq  *%rax
  802811:	89 c2                	mov    %eax,%edx
  802813:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80281a:	00 00 00 
  80281d:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80281f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802826:	00 00 00 
  802829:	8b 00                	mov    (%rax),%eax
  80282b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80282e:	b9 07 00 00 00       	mov    $0x7,%ecx
  802833:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80283a:	00 00 00 
  80283d:	89 c7                	mov    %eax,%edi
  80283f:	48 b8 76 41 80 00 00 	movabs $0x804176,%rax
  802846:	00 00 00 
  802849:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80284b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80284f:	ba 00 00 00 00       	mov    $0x0,%edx
  802854:	48 89 c6             	mov    %rax,%rsi
  802857:	bf 00 00 00 00       	mov    $0x0,%edi
  80285c:	48 b8 38 41 80 00 00 	movabs $0x804138,%rax
  802863:	00 00 00 
  802866:	ff d0                	callq  *%rax
}
  802868:	c9                   	leaveq 
  802869:	c3                   	retq   

000000000080286a <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80286a:	55                   	push   %rbp
  80286b:	48 89 e5             	mov    %rsp,%rbp
  80286e:	48 83 ec 10          	sub    $0x10,%rsp
  802872:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802876:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  802879:	48 ba f6 49 80 00 00 	movabs $0x8049f6,%rdx
  802880:	00 00 00 
  802883:	be 4c 00 00 00       	mov    $0x4c,%esi
  802888:	48 bf 0b 4a 80 00 00 	movabs $0x804a0b,%rdi
  80288f:	00 00 00 
  802892:	b8 00 00 00 00       	mov    $0x0,%eax
  802897:	48 b9 24 40 80 00 00 	movabs $0x804024,%rcx
  80289e:	00 00 00 
  8028a1:	ff d1                	callq  *%rcx

00000000008028a3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8028a3:	55                   	push   %rbp
  8028a4:	48 89 e5             	mov    %rsp,%rbp
  8028a7:	48 83 ec 10          	sub    $0x10,%rsp
  8028ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8028af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028b3:	8b 50 0c             	mov    0xc(%rax),%edx
  8028b6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028bd:	00 00 00 
  8028c0:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8028c2:	be 00 00 00 00       	mov    $0x0,%esi
  8028c7:	bf 06 00 00 00       	mov    $0x6,%edi
  8028cc:	48 b8 e1 27 80 00 00 	movabs $0x8027e1,%rax
  8028d3:	00 00 00 
  8028d6:	ff d0                	callq  *%rax
}
  8028d8:	c9                   	leaveq 
  8028d9:	c3                   	retq   

00000000008028da <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8028da:	55                   	push   %rbp
  8028db:	48 89 e5             	mov    %rsp,%rbp
  8028de:	48 83 ec 20          	sub    $0x20,%rsp
  8028e2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8028e6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8028ea:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  8028ee:	48 ba 16 4a 80 00 00 	movabs $0x804a16,%rdx
  8028f5:	00 00 00 
  8028f8:	be 6b 00 00 00       	mov    $0x6b,%esi
  8028fd:	48 bf 0b 4a 80 00 00 	movabs $0x804a0b,%rdi
  802904:	00 00 00 
  802907:	b8 00 00 00 00       	mov    $0x0,%eax
  80290c:	48 b9 24 40 80 00 00 	movabs $0x804024,%rcx
  802913:	00 00 00 
  802916:	ff d1                	callq  *%rcx

0000000000802918 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802918:	55                   	push   %rbp
  802919:	48 89 e5             	mov    %rsp,%rbp
  80291c:	48 83 ec 20          	sub    $0x20,%rsp
  802920:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802924:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802928:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  80292c:	48 ba 33 4a 80 00 00 	movabs $0x804a33,%rdx
  802933:	00 00 00 
  802936:	be 7b 00 00 00       	mov    $0x7b,%esi
  80293b:	48 bf 0b 4a 80 00 00 	movabs $0x804a0b,%rdi
  802942:	00 00 00 
  802945:	b8 00 00 00 00       	mov    $0x0,%eax
  80294a:	48 b9 24 40 80 00 00 	movabs $0x804024,%rcx
  802951:	00 00 00 
  802954:	ff d1                	callq  *%rcx

0000000000802956 <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802956:	55                   	push   %rbp
  802957:	48 89 e5             	mov    %rsp,%rbp
  80295a:	48 83 ec 20          	sub    $0x20,%rsp
  80295e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802962:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802966:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80296a:	8b 50 0c             	mov    0xc(%rax),%edx
  80296d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802974:	00 00 00 
  802977:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802979:	be 00 00 00 00       	mov    $0x0,%esi
  80297e:	bf 05 00 00 00       	mov    $0x5,%edi
  802983:	48 b8 e1 27 80 00 00 	movabs $0x8027e1,%rax
  80298a:	00 00 00 
  80298d:	ff d0                	callq  *%rax
  80298f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802992:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802996:	79 05                	jns    80299d <devfile_stat+0x47>
		return r;
  802998:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80299b:	eb 56                	jmp    8029f3 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80299d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029a1:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8029a8:	00 00 00 
  8029ab:	48 89 c7             	mov    %rax,%rdi
  8029ae:	48 b8 04 0f 80 00 00 	movabs $0x800f04,%rax
  8029b5:	00 00 00 
  8029b8:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8029ba:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029c1:	00 00 00 
  8029c4:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8029ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029ce:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8029d4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029db:	00 00 00 
  8029de:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8029e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029e8:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8029ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029f3:	c9                   	leaveq 
  8029f4:	c3                   	retq   

00000000008029f5 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8029f5:	55                   	push   %rbp
  8029f6:	48 89 e5             	mov    %rsp,%rbp
  8029f9:	48 83 ec 10          	sub    $0x10,%rsp
  8029fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a01:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802a04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a08:	8b 50 0c             	mov    0xc(%rax),%edx
  802a0b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a12:	00 00 00 
  802a15:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802a17:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a1e:	00 00 00 
  802a21:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802a24:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802a27:	be 00 00 00 00       	mov    $0x0,%esi
  802a2c:	bf 02 00 00 00       	mov    $0x2,%edi
  802a31:	48 b8 e1 27 80 00 00 	movabs $0x8027e1,%rax
  802a38:	00 00 00 
  802a3b:	ff d0                	callq  *%rax
}
  802a3d:	c9                   	leaveq 
  802a3e:	c3                   	retq   

0000000000802a3f <remove>:

// Delete a file
int
remove(const char *path)
{
  802a3f:	55                   	push   %rbp
  802a40:	48 89 e5             	mov    %rsp,%rbp
  802a43:	48 83 ec 10          	sub    $0x10,%rsp
  802a47:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802a4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a4f:	48 89 c7             	mov    %rax,%rdi
  802a52:	48 b8 98 0e 80 00 00 	movabs $0x800e98,%rax
  802a59:	00 00 00 
  802a5c:	ff d0                	callq  *%rax
  802a5e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802a63:	7e 07                	jle    802a6c <remove+0x2d>
		return -E_BAD_PATH;
  802a65:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802a6a:	eb 33                	jmp    802a9f <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802a6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a70:	48 89 c6             	mov    %rax,%rsi
  802a73:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802a7a:	00 00 00 
  802a7d:	48 b8 04 0f 80 00 00 	movabs $0x800f04,%rax
  802a84:	00 00 00 
  802a87:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802a89:	be 00 00 00 00       	mov    $0x0,%esi
  802a8e:	bf 07 00 00 00       	mov    $0x7,%edi
  802a93:	48 b8 e1 27 80 00 00 	movabs $0x8027e1,%rax
  802a9a:	00 00 00 
  802a9d:	ff d0                	callq  *%rax
}
  802a9f:	c9                   	leaveq 
  802aa0:	c3                   	retq   

0000000000802aa1 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802aa1:	55                   	push   %rbp
  802aa2:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802aa5:	be 00 00 00 00       	mov    $0x0,%esi
  802aaa:	bf 08 00 00 00       	mov    $0x8,%edi
  802aaf:	48 b8 e1 27 80 00 00 	movabs $0x8027e1,%rax
  802ab6:	00 00 00 
  802ab9:	ff d0                	callq  *%rax
}
  802abb:	5d                   	pop    %rbp
  802abc:	c3                   	retq   

0000000000802abd <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802abd:	55                   	push   %rbp
  802abe:	48 89 e5             	mov    %rsp,%rbp
  802ac1:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802ac8:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802acf:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802ad6:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802add:	be 00 00 00 00       	mov    $0x0,%esi
  802ae2:	48 89 c7             	mov    %rax,%rdi
  802ae5:	48 b8 6a 28 80 00 00 	movabs $0x80286a,%rax
  802aec:	00 00 00 
  802aef:	ff d0                	callq  *%rax
  802af1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802af4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802af8:	79 28                	jns    802b22 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802afa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802afd:	89 c6                	mov    %eax,%esi
  802aff:	48 bf 51 4a 80 00 00 	movabs $0x804a51,%rdi
  802b06:	00 00 00 
  802b09:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0e:	48 ba 6a 03 80 00 00 	movabs $0x80036a,%rdx
  802b15:	00 00 00 
  802b18:	ff d2                	callq  *%rdx
		return fd_src;
  802b1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b1d:	e9 74 01 00 00       	jmpq   802c96 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802b22:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802b29:	be 01 01 00 00       	mov    $0x101,%esi
  802b2e:	48 89 c7             	mov    %rax,%rdi
  802b31:	48 b8 6a 28 80 00 00 	movabs $0x80286a,%rax
  802b38:	00 00 00 
  802b3b:	ff d0                	callq  *%rax
  802b3d:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802b40:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b44:	79 39                	jns    802b7f <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802b46:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b49:	89 c6                	mov    %eax,%esi
  802b4b:	48 bf 67 4a 80 00 00 	movabs $0x804a67,%rdi
  802b52:	00 00 00 
  802b55:	b8 00 00 00 00       	mov    $0x0,%eax
  802b5a:	48 ba 6a 03 80 00 00 	movabs $0x80036a,%rdx
  802b61:	00 00 00 
  802b64:	ff d2                	callq  *%rdx
		close(fd_src);
  802b66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b69:	89 c7                	mov    %eax,%edi
  802b6b:	48 b8 70 21 80 00 00 	movabs $0x802170,%rax
  802b72:	00 00 00 
  802b75:	ff d0                	callq  *%rax
		return fd_dest;
  802b77:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b7a:	e9 17 01 00 00       	jmpq   802c96 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802b7f:	eb 74                	jmp    802bf5 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802b81:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b84:	48 63 d0             	movslq %eax,%rdx
  802b87:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802b8e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b91:	48 89 ce             	mov    %rcx,%rsi
  802b94:	89 c7                	mov    %eax,%edi
  802b96:	48 b8 dc 24 80 00 00 	movabs $0x8024dc,%rax
  802b9d:	00 00 00 
  802ba0:	ff d0                	callq  *%rax
  802ba2:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802ba5:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802ba9:	79 4a                	jns    802bf5 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802bab:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802bae:	89 c6                	mov    %eax,%esi
  802bb0:	48 bf 81 4a 80 00 00 	movabs $0x804a81,%rdi
  802bb7:	00 00 00 
  802bba:	b8 00 00 00 00       	mov    $0x0,%eax
  802bbf:	48 ba 6a 03 80 00 00 	movabs $0x80036a,%rdx
  802bc6:	00 00 00 
  802bc9:	ff d2                	callq  *%rdx
			close(fd_src);
  802bcb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bce:	89 c7                	mov    %eax,%edi
  802bd0:	48 b8 70 21 80 00 00 	movabs $0x802170,%rax
  802bd7:	00 00 00 
  802bda:	ff d0                	callq  *%rax
			close(fd_dest);
  802bdc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bdf:	89 c7                	mov    %eax,%edi
  802be1:	48 b8 70 21 80 00 00 	movabs $0x802170,%rax
  802be8:	00 00 00 
  802beb:	ff d0                	callq  *%rax
			return write_size;
  802bed:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802bf0:	e9 a1 00 00 00       	jmpq   802c96 <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802bf5:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802bfc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bff:	ba 00 02 00 00       	mov    $0x200,%edx
  802c04:	48 89 ce             	mov    %rcx,%rsi
  802c07:	89 c7                	mov    %eax,%edi
  802c09:	48 b8 92 23 80 00 00 	movabs $0x802392,%rax
  802c10:	00 00 00 
  802c13:	ff d0                	callq  *%rax
  802c15:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802c18:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c1c:	0f 8f 5f ff ff ff    	jg     802b81 <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  802c22:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c26:	79 47                	jns    802c6f <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802c28:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c2b:	89 c6                	mov    %eax,%esi
  802c2d:	48 bf 94 4a 80 00 00 	movabs $0x804a94,%rdi
  802c34:	00 00 00 
  802c37:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3c:	48 ba 6a 03 80 00 00 	movabs $0x80036a,%rdx
  802c43:	00 00 00 
  802c46:	ff d2                	callq  *%rdx
		close(fd_src);
  802c48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c4b:	89 c7                	mov    %eax,%edi
  802c4d:	48 b8 70 21 80 00 00 	movabs $0x802170,%rax
  802c54:	00 00 00 
  802c57:	ff d0                	callq  *%rax
		close(fd_dest);
  802c59:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c5c:	89 c7                	mov    %eax,%edi
  802c5e:	48 b8 70 21 80 00 00 	movabs $0x802170,%rax
  802c65:	00 00 00 
  802c68:	ff d0                	callq  *%rax
		return read_size;
  802c6a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c6d:	eb 27                	jmp    802c96 <copy+0x1d9>
	}
	close(fd_src);
  802c6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c72:	89 c7                	mov    %eax,%edi
  802c74:	48 b8 70 21 80 00 00 	movabs $0x802170,%rax
  802c7b:	00 00 00 
  802c7e:	ff d0                	callq  *%rax
	close(fd_dest);
  802c80:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c83:	89 c7                	mov    %eax,%edi
  802c85:	48 b8 70 21 80 00 00 	movabs $0x802170,%rax
  802c8c:	00 00 00 
  802c8f:	ff d0                	callq  *%rax
	return 0;
  802c91:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802c96:	c9                   	leaveq 
  802c97:	c3                   	retq   

0000000000802c98 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802c98:	55                   	push   %rbp
  802c99:	48 89 e5             	mov    %rsp,%rbp
  802c9c:	48 83 ec 20          	sub    $0x20,%rsp
  802ca0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802ca4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca8:	8b 40 0c             	mov    0xc(%rax),%eax
  802cab:	85 c0                	test   %eax,%eax
  802cad:	7e 67                	jle    802d16 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802caf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb3:	8b 40 04             	mov    0x4(%rax),%eax
  802cb6:	48 63 d0             	movslq %eax,%rdx
  802cb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cbd:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802cc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cc5:	8b 00                	mov    (%rax),%eax
  802cc7:	48 89 ce             	mov    %rcx,%rsi
  802cca:	89 c7                	mov    %eax,%edi
  802ccc:	48 b8 dc 24 80 00 00 	movabs $0x8024dc,%rax
  802cd3:	00 00 00 
  802cd6:	ff d0                	callq  *%rax
  802cd8:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802cdb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cdf:	7e 13                	jle    802cf4 <writebuf+0x5c>
			b->result += result;
  802ce1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce5:	8b 50 08             	mov    0x8(%rax),%edx
  802ce8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ceb:	01 c2                	add    %eax,%edx
  802ced:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf1:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802cf4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf8:	8b 40 04             	mov    0x4(%rax),%eax
  802cfb:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802cfe:	74 16                	je     802d16 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802d00:	b8 00 00 00 00       	mov    $0x0,%eax
  802d05:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d09:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802d0d:	89 c2                	mov    %eax,%edx
  802d0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d13:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802d16:	c9                   	leaveq 
  802d17:	c3                   	retq   

0000000000802d18 <putch>:

static void
putch(int ch, void *thunk)
{
  802d18:	55                   	push   %rbp
  802d19:	48 89 e5             	mov    %rsp,%rbp
  802d1c:	48 83 ec 20          	sub    $0x20,%rsp
  802d20:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d23:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802d27:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d2b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802d2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d33:	8b 40 04             	mov    0x4(%rax),%eax
  802d36:	8d 48 01             	lea    0x1(%rax),%ecx
  802d39:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802d3d:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802d40:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802d43:	89 d1                	mov    %edx,%ecx
  802d45:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802d49:	48 98                	cltq   
  802d4b:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802d4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d53:	8b 40 04             	mov    0x4(%rax),%eax
  802d56:	3d 00 01 00 00       	cmp    $0x100,%eax
  802d5b:	75 1e                	jne    802d7b <putch+0x63>
		writebuf(b);
  802d5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d61:	48 89 c7             	mov    %rax,%rdi
  802d64:	48 b8 98 2c 80 00 00 	movabs $0x802c98,%rax
  802d6b:	00 00 00 
  802d6e:	ff d0                	callq  *%rax
		b->idx = 0;
  802d70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802d7b:	c9                   	leaveq 
  802d7c:	c3                   	retq   

0000000000802d7d <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802d7d:	55                   	push   %rbp
  802d7e:	48 89 e5             	mov    %rsp,%rbp
  802d81:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802d88:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802d8e:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802d95:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802d9c:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802da2:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802da8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802daf:	00 00 00 
	b.result = 0;
  802db2:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802db9:	00 00 00 
	b.error = 1;
  802dbc:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802dc3:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802dc6:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802dcd:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802dd4:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802ddb:	48 89 c6             	mov    %rax,%rsi
  802dde:	48 bf 18 2d 80 00 00 	movabs $0x802d18,%rdi
  802de5:	00 00 00 
  802de8:	48 b8 09 07 80 00 00 	movabs $0x800709,%rax
  802def:	00 00 00 
  802df2:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802df4:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802dfa:	85 c0                	test   %eax,%eax
  802dfc:	7e 16                	jle    802e14 <vfprintf+0x97>
		writebuf(&b);
  802dfe:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802e05:	48 89 c7             	mov    %rax,%rdi
  802e08:	48 b8 98 2c 80 00 00 	movabs $0x802c98,%rax
  802e0f:	00 00 00 
  802e12:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802e14:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802e1a:	85 c0                	test   %eax,%eax
  802e1c:	74 08                	je     802e26 <vfprintf+0xa9>
  802e1e:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802e24:	eb 06                	jmp    802e2c <vfprintf+0xaf>
  802e26:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802e2c:	c9                   	leaveq 
  802e2d:	c3                   	retq   

0000000000802e2e <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802e2e:	55                   	push   %rbp
  802e2f:	48 89 e5             	mov    %rsp,%rbp
  802e32:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802e39:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802e3f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802e46:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802e4d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802e54:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802e5b:	84 c0                	test   %al,%al
  802e5d:	74 20                	je     802e7f <fprintf+0x51>
  802e5f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802e63:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802e67:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802e6b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802e6f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802e73:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802e77:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802e7b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802e7f:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802e86:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802e8d:	00 00 00 
  802e90:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802e97:	00 00 00 
  802e9a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802e9e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802ea5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802eac:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802eb3:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802eba:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  802ec1:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802ec7:	48 89 ce             	mov    %rcx,%rsi
  802eca:	89 c7                	mov    %eax,%edi
  802ecc:	48 b8 7d 2d 80 00 00 	movabs $0x802d7d,%rax
  802ed3:	00 00 00 
  802ed6:	ff d0                	callq  *%rax
  802ed8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802ede:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802ee4:	c9                   	leaveq 
  802ee5:	c3                   	retq   

0000000000802ee6 <printf>:

int
printf(const char *fmt, ...)
{
  802ee6:	55                   	push   %rbp
  802ee7:	48 89 e5             	mov    %rsp,%rbp
  802eea:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802ef1:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802ef8:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802eff:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802f06:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802f0d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802f14:	84 c0                	test   %al,%al
  802f16:	74 20                	je     802f38 <printf+0x52>
  802f18:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802f1c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802f20:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802f24:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802f28:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802f2c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802f30:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802f34:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802f38:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802f3f:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802f46:	00 00 00 
  802f49:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802f50:	00 00 00 
  802f53:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802f57:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802f5e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802f65:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  802f6c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802f73:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802f7a:	48 89 c6             	mov    %rax,%rsi
  802f7d:	bf 01 00 00 00       	mov    $0x1,%edi
  802f82:	48 b8 7d 2d 80 00 00 	movabs $0x802d7d,%rax
  802f89:	00 00 00 
  802f8c:	ff d0                	callq  *%rax
  802f8e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802f94:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802f9a:	c9                   	leaveq 
  802f9b:	c3                   	retq   

0000000000802f9c <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802f9c:	55                   	push   %rbp
  802f9d:	48 89 e5             	mov    %rsp,%rbp
  802fa0:	48 83 ec 20          	sub    $0x20,%rsp
  802fa4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802fa7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fae:	48 89 d6             	mov    %rdx,%rsi
  802fb1:	89 c7                	mov    %eax,%edi
  802fb3:	48 b8 5e 1f 80 00 00 	movabs $0x801f5e,%rax
  802fba:	00 00 00 
  802fbd:	ff d0                	callq  *%rax
  802fbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fc6:	79 05                	jns    802fcd <fd2sockid+0x31>
		return r;
  802fc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fcb:	eb 24                	jmp    802ff1 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802fcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fd1:	8b 10                	mov    (%rax),%edx
  802fd3:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802fda:	00 00 00 
  802fdd:	8b 00                	mov    (%rax),%eax
  802fdf:	39 c2                	cmp    %eax,%edx
  802fe1:	74 07                	je     802fea <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802fe3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802fe8:	eb 07                	jmp    802ff1 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802fea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fee:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802ff1:	c9                   	leaveq 
  802ff2:	c3                   	retq   

0000000000802ff3 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802ff3:	55                   	push   %rbp
  802ff4:	48 89 e5             	mov    %rsp,%rbp
  802ff7:	48 83 ec 20          	sub    $0x20,%rsp
  802ffb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802ffe:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803002:	48 89 c7             	mov    %rax,%rdi
  803005:	48 b8 c6 1e 80 00 00 	movabs $0x801ec6,%rax
  80300c:	00 00 00 
  80300f:	ff d0                	callq  *%rax
  803011:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803014:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803018:	78 26                	js     803040 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80301a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80301e:	ba 07 04 00 00       	mov    $0x407,%edx
  803023:	48 89 c6             	mov    %rax,%rsi
  803026:	bf 00 00 00 00       	mov    $0x0,%edi
  80302b:	48 b8 31 18 80 00 00 	movabs $0x801831,%rax
  803032:	00 00 00 
  803035:	ff d0                	callq  *%rax
  803037:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80303a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80303e:	79 16                	jns    803056 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803040:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803043:	89 c7                	mov    %eax,%edi
  803045:	48 b8 02 35 80 00 00 	movabs $0x803502,%rax
  80304c:	00 00 00 
  80304f:	ff d0                	callq  *%rax
		return r;
  803051:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803054:	eb 3a                	jmp    803090 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803056:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80305a:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  803061:	00 00 00 
  803064:	8b 12                	mov    (%rdx),%edx
  803066:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803068:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80306c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803073:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803077:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80307a:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80307d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803081:	48 89 c7             	mov    %rax,%rdi
  803084:	48 b8 78 1e 80 00 00 	movabs $0x801e78,%rax
  80308b:	00 00 00 
  80308e:	ff d0                	callq  *%rax
}
  803090:	c9                   	leaveq 
  803091:	c3                   	retq   

0000000000803092 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803092:	55                   	push   %rbp
  803093:	48 89 e5             	mov    %rsp,%rbp
  803096:	48 83 ec 30          	sub    $0x30,%rsp
  80309a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80309d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8030a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030a8:	89 c7                	mov    %eax,%edi
  8030aa:	48 b8 9c 2f 80 00 00 	movabs $0x802f9c,%rax
  8030b1:	00 00 00 
  8030b4:	ff d0                	callq  *%rax
  8030b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030bd:	79 05                	jns    8030c4 <accept+0x32>
		return r;
  8030bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030c2:	eb 3b                	jmp    8030ff <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8030c4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030c8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8030cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030cf:	48 89 ce             	mov    %rcx,%rsi
  8030d2:	89 c7                	mov    %eax,%edi
  8030d4:	48 b8 df 33 80 00 00 	movabs $0x8033df,%rax
  8030db:	00 00 00 
  8030de:	ff d0                	callq  *%rax
  8030e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030e7:	79 05                	jns    8030ee <accept+0x5c>
		return r;
  8030e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ec:	eb 11                	jmp    8030ff <accept+0x6d>
	return alloc_sockfd(r);
  8030ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f1:	89 c7                	mov    %eax,%edi
  8030f3:	48 b8 f3 2f 80 00 00 	movabs $0x802ff3,%rax
  8030fa:	00 00 00 
  8030fd:	ff d0                	callq  *%rax
}
  8030ff:	c9                   	leaveq 
  803100:	c3                   	retq   

0000000000803101 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803101:	55                   	push   %rbp
  803102:	48 89 e5             	mov    %rsp,%rbp
  803105:	48 83 ec 20          	sub    $0x20,%rsp
  803109:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80310c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803110:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803113:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803116:	89 c7                	mov    %eax,%edi
  803118:	48 b8 9c 2f 80 00 00 	movabs $0x802f9c,%rax
  80311f:	00 00 00 
  803122:	ff d0                	callq  *%rax
  803124:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803127:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80312b:	79 05                	jns    803132 <bind+0x31>
		return r;
  80312d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803130:	eb 1b                	jmp    80314d <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803132:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803135:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803139:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80313c:	48 89 ce             	mov    %rcx,%rsi
  80313f:	89 c7                	mov    %eax,%edi
  803141:	48 b8 5e 34 80 00 00 	movabs $0x80345e,%rax
  803148:	00 00 00 
  80314b:	ff d0                	callq  *%rax
}
  80314d:	c9                   	leaveq 
  80314e:	c3                   	retq   

000000000080314f <shutdown>:

int
shutdown(int s, int how)
{
  80314f:	55                   	push   %rbp
  803150:	48 89 e5             	mov    %rsp,%rbp
  803153:	48 83 ec 20          	sub    $0x20,%rsp
  803157:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80315a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80315d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803160:	89 c7                	mov    %eax,%edi
  803162:	48 b8 9c 2f 80 00 00 	movabs $0x802f9c,%rax
  803169:	00 00 00 
  80316c:	ff d0                	callq  *%rax
  80316e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803171:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803175:	79 05                	jns    80317c <shutdown+0x2d>
		return r;
  803177:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80317a:	eb 16                	jmp    803192 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80317c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80317f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803182:	89 d6                	mov    %edx,%esi
  803184:	89 c7                	mov    %eax,%edi
  803186:	48 b8 c2 34 80 00 00 	movabs $0x8034c2,%rax
  80318d:	00 00 00 
  803190:	ff d0                	callq  *%rax
}
  803192:	c9                   	leaveq 
  803193:	c3                   	retq   

0000000000803194 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803194:	55                   	push   %rbp
  803195:	48 89 e5             	mov    %rsp,%rbp
  803198:	48 83 ec 10          	sub    $0x10,%rsp
  80319c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8031a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031a4:	48 89 c7             	mov    %rax,%rdi
  8031a7:	48 b8 75 43 80 00 00 	movabs $0x804375,%rax
  8031ae:	00 00 00 
  8031b1:	ff d0                	callq  *%rax
  8031b3:	83 f8 01             	cmp    $0x1,%eax
  8031b6:	75 17                	jne    8031cf <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8031b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031bc:	8b 40 0c             	mov    0xc(%rax),%eax
  8031bf:	89 c7                	mov    %eax,%edi
  8031c1:	48 b8 02 35 80 00 00 	movabs $0x803502,%rax
  8031c8:	00 00 00 
  8031cb:	ff d0                	callq  *%rax
  8031cd:	eb 05                	jmp    8031d4 <devsock_close+0x40>
	else
		return 0;
  8031cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031d4:	c9                   	leaveq 
  8031d5:	c3                   	retq   

00000000008031d6 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8031d6:	55                   	push   %rbp
  8031d7:	48 89 e5             	mov    %rsp,%rbp
  8031da:	48 83 ec 20          	sub    $0x20,%rsp
  8031de:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031e1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031e5:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8031e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031eb:	89 c7                	mov    %eax,%edi
  8031ed:	48 b8 9c 2f 80 00 00 	movabs $0x802f9c,%rax
  8031f4:	00 00 00 
  8031f7:	ff d0                	callq  *%rax
  8031f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803200:	79 05                	jns    803207 <connect+0x31>
		return r;
  803202:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803205:	eb 1b                	jmp    803222 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803207:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80320a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80320e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803211:	48 89 ce             	mov    %rcx,%rsi
  803214:	89 c7                	mov    %eax,%edi
  803216:	48 b8 2f 35 80 00 00 	movabs $0x80352f,%rax
  80321d:	00 00 00 
  803220:	ff d0                	callq  *%rax
}
  803222:	c9                   	leaveq 
  803223:	c3                   	retq   

0000000000803224 <listen>:

int
listen(int s, int backlog)
{
  803224:	55                   	push   %rbp
  803225:	48 89 e5             	mov    %rsp,%rbp
  803228:	48 83 ec 20          	sub    $0x20,%rsp
  80322c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80322f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803232:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803235:	89 c7                	mov    %eax,%edi
  803237:	48 b8 9c 2f 80 00 00 	movabs $0x802f9c,%rax
  80323e:	00 00 00 
  803241:	ff d0                	callq  *%rax
  803243:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803246:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80324a:	79 05                	jns    803251 <listen+0x2d>
		return r;
  80324c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80324f:	eb 16                	jmp    803267 <listen+0x43>
	return nsipc_listen(r, backlog);
  803251:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803254:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803257:	89 d6                	mov    %edx,%esi
  803259:	89 c7                	mov    %eax,%edi
  80325b:	48 b8 93 35 80 00 00 	movabs $0x803593,%rax
  803262:	00 00 00 
  803265:	ff d0                	callq  *%rax
}
  803267:	c9                   	leaveq 
  803268:	c3                   	retq   

0000000000803269 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803269:	55                   	push   %rbp
  80326a:	48 89 e5             	mov    %rsp,%rbp
  80326d:	48 83 ec 20          	sub    $0x20,%rsp
  803271:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803275:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803279:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80327d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803281:	89 c2                	mov    %eax,%edx
  803283:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803287:	8b 40 0c             	mov    0xc(%rax),%eax
  80328a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80328e:	b9 00 00 00 00       	mov    $0x0,%ecx
  803293:	89 c7                	mov    %eax,%edi
  803295:	48 b8 d3 35 80 00 00 	movabs $0x8035d3,%rax
  80329c:	00 00 00 
  80329f:	ff d0                	callq  *%rax
}
  8032a1:	c9                   	leaveq 
  8032a2:	c3                   	retq   

00000000008032a3 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8032a3:	55                   	push   %rbp
  8032a4:	48 89 e5             	mov    %rsp,%rbp
  8032a7:	48 83 ec 20          	sub    $0x20,%rsp
  8032ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8032af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8032b3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8032b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032bb:	89 c2                	mov    %eax,%edx
  8032bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032c1:	8b 40 0c             	mov    0xc(%rax),%eax
  8032c4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8032c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8032cd:	89 c7                	mov    %eax,%edi
  8032cf:	48 b8 9f 36 80 00 00 	movabs $0x80369f,%rax
  8032d6:	00 00 00 
  8032d9:	ff d0                	callq  *%rax
}
  8032db:	c9                   	leaveq 
  8032dc:	c3                   	retq   

00000000008032dd <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8032dd:	55                   	push   %rbp
  8032de:	48 89 e5             	mov    %rsp,%rbp
  8032e1:	48 83 ec 10          	sub    $0x10,%rsp
  8032e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8032e9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8032ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032f1:	48 be af 4a 80 00 00 	movabs $0x804aaf,%rsi
  8032f8:	00 00 00 
  8032fb:	48 89 c7             	mov    %rax,%rdi
  8032fe:	48 b8 04 0f 80 00 00 	movabs $0x800f04,%rax
  803305:	00 00 00 
  803308:	ff d0                	callq  *%rax
	return 0;
  80330a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80330f:	c9                   	leaveq 
  803310:	c3                   	retq   

0000000000803311 <socket>:

int
socket(int domain, int type, int protocol)
{
  803311:	55                   	push   %rbp
  803312:	48 89 e5             	mov    %rsp,%rbp
  803315:	48 83 ec 20          	sub    $0x20,%rsp
  803319:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80331c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80331f:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803322:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803325:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803328:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80332b:	89 ce                	mov    %ecx,%esi
  80332d:	89 c7                	mov    %eax,%edi
  80332f:	48 b8 57 37 80 00 00 	movabs $0x803757,%rax
  803336:	00 00 00 
  803339:	ff d0                	callq  *%rax
  80333b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80333e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803342:	79 05                	jns    803349 <socket+0x38>
		return r;
  803344:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803347:	eb 11                	jmp    80335a <socket+0x49>
	return alloc_sockfd(r);
  803349:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80334c:	89 c7                	mov    %eax,%edi
  80334e:	48 b8 f3 2f 80 00 00 	movabs $0x802ff3,%rax
  803355:	00 00 00 
  803358:	ff d0                	callq  *%rax
}
  80335a:	c9                   	leaveq 
  80335b:	c3                   	retq   

000000000080335c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80335c:	55                   	push   %rbp
  80335d:	48 89 e5             	mov    %rsp,%rbp
  803360:	48 83 ec 10          	sub    $0x10,%rsp
  803364:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803367:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80336e:	00 00 00 
  803371:	8b 00                	mov    (%rax),%eax
  803373:	85 c0                	test   %eax,%eax
  803375:	75 1f                	jne    803396 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803377:	bf 02 00 00 00       	mov    $0x2,%edi
  80337c:	48 b8 03 43 80 00 00 	movabs $0x804303,%rax
  803383:	00 00 00 
  803386:	ff d0                	callq  *%rax
  803388:	89 c2                	mov    %eax,%edx
  80338a:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803391:	00 00 00 
  803394:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803396:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80339d:	00 00 00 
  8033a0:	8b 00                	mov    (%rax),%eax
  8033a2:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8033a5:	b9 07 00 00 00       	mov    $0x7,%ecx
  8033aa:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8033b1:	00 00 00 
  8033b4:	89 c7                	mov    %eax,%edi
  8033b6:	48 b8 76 41 80 00 00 	movabs $0x804176,%rax
  8033bd:	00 00 00 
  8033c0:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8033c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8033c7:	be 00 00 00 00       	mov    $0x0,%esi
  8033cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8033d1:	48 b8 38 41 80 00 00 	movabs $0x804138,%rax
  8033d8:	00 00 00 
  8033db:	ff d0                	callq  *%rax
}
  8033dd:	c9                   	leaveq 
  8033de:	c3                   	retq   

00000000008033df <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8033df:	55                   	push   %rbp
  8033e0:	48 89 e5             	mov    %rsp,%rbp
  8033e3:	48 83 ec 30          	sub    $0x30,%rsp
  8033e7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033ee:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8033f2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033f9:	00 00 00 
  8033fc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8033ff:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803401:	bf 01 00 00 00       	mov    $0x1,%edi
  803406:	48 b8 5c 33 80 00 00 	movabs $0x80335c,%rax
  80340d:	00 00 00 
  803410:	ff d0                	callq  *%rax
  803412:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803415:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803419:	78 3e                	js     803459 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80341b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803422:	00 00 00 
  803425:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803429:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80342d:	8b 40 10             	mov    0x10(%rax),%eax
  803430:	89 c2                	mov    %eax,%edx
  803432:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803436:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80343a:	48 89 ce             	mov    %rcx,%rsi
  80343d:	48 89 c7             	mov    %rax,%rdi
  803440:	48 b8 28 12 80 00 00 	movabs $0x801228,%rax
  803447:	00 00 00 
  80344a:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80344c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803450:	8b 50 10             	mov    0x10(%rax),%edx
  803453:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803457:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803459:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80345c:	c9                   	leaveq 
  80345d:	c3                   	retq   

000000000080345e <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80345e:	55                   	push   %rbp
  80345f:	48 89 e5             	mov    %rsp,%rbp
  803462:	48 83 ec 10          	sub    $0x10,%rsp
  803466:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803469:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80346d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803470:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803477:	00 00 00 
  80347a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80347d:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80347f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803482:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803486:	48 89 c6             	mov    %rax,%rsi
  803489:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803490:	00 00 00 
  803493:	48 b8 28 12 80 00 00 	movabs $0x801228,%rax
  80349a:	00 00 00 
  80349d:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80349f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034a6:	00 00 00 
  8034a9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034ac:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8034af:	bf 02 00 00 00       	mov    $0x2,%edi
  8034b4:	48 b8 5c 33 80 00 00 	movabs $0x80335c,%rax
  8034bb:	00 00 00 
  8034be:	ff d0                	callq  *%rax
}
  8034c0:	c9                   	leaveq 
  8034c1:	c3                   	retq   

00000000008034c2 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8034c2:	55                   	push   %rbp
  8034c3:	48 89 e5             	mov    %rsp,%rbp
  8034c6:	48 83 ec 10          	sub    $0x10,%rsp
  8034ca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034cd:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8034d0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034d7:	00 00 00 
  8034da:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034dd:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8034df:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034e6:	00 00 00 
  8034e9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034ec:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8034ef:	bf 03 00 00 00       	mov    $0x3,%edi
  8034f4:	48 b8 5c 33 80 00 00 	movabs $0x80335c,%rax
  8034fb:	00 00 00 
  8034fe:	ff d0                	callq  *%rax
}
  803500:	c9                   	leaveq 
  803501:	c3                   	retq   

0000000000803502 <nsipc_close>:

int
nsipc_close(int s)
{
  803502:	55                   	push   %rbp
  803503:	48 89 e5             	mov    %rsp,%rbp
  803506:	48 83 ec 10          	sub    $0x10,%rsp
  80350a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80350d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803514:	00 00 00 
  803517:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80351a:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80351c:	bf 04 00 00 00       	mov    $0x4,%edi
  803521:	48 b8 5c 33 80 00 00 	movabs $0x80335c,%rax
  803528:	00 00 00 
  80352b:	ff d0                	callq  *%rax
}
  80352d:	c9                   	leaveq 
  80352e:	c3                   	retq   

000000000080352f <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80352f:	55                   	push   %rbp
  803530:	48 89 e5             	mov    %rsp,%rbp
  803533:	48 83 ec 10          	sub    $0x10,%rsp
  803537:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80353a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80353e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803541:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803548:	00 00 00 
  80354b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80354e:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803550:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803553:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803557:	48 89 c6             	mov    %rax,%rsi
  80355a:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803561:	00 00 00 
  803564:	48 b8 28 12 80 00 00 	movabs $0x801228,%rax
  80356b:	00 00 00 
  80356e:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803570:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803577:	00 00 00 
  80357a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80357d:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803580:	bf 05 00 00 00       	mov    $0x5,%edi
  803585:	48 b8 5c 33 80 00 00 	movabs $0x80335c,%rax
  80358c:	00 00 00 
  80358f:	ff d0                	callq  *%rax
}
  803591:	c9                   	leaveq 
  803592:	c3                   	retq   

0000000000803593 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803593:	55                   	push   %rbp
  803594:	48 89 e5             	mov    %rsp,%rbp
  803597:	48 83 ec 10          	sub    $0x10,%rsp
  80359b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80359e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8035a1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035a8:	00 00 00 
  8035ab:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035ae:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8035b0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035b7:	00 00 00 
  8035ba:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035bd:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8035c0:	bf 06 00 00 00       	mov    $0x6,%edi
  8035c5:	48 b8 5c 33 80 00 00 	movabs $0x80335c,%rax
  8035cc:	00 00 00 
  8035cf:	ff d0                	callq  *%rax
}
  8035d1:	c9                   	leaveq 
  8035d2:	c3                   	retq   

00000000008035d3 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8035d3:	55                   	push   %rbp
  8035d4:	48 89 e5             	mov    %rsp,%rbp
  8035d7:	48 83 ec 30          	sub    $0x30,%rsp
  8035db:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035e2:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8035e5:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8035e8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035ef:	00 00 00 
  8035f2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8035f5:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8035f7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035fe:	00 00 00 
  803601:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803604:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803607:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80360e:	00 00 00 
  803611:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803614:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803617:	bf 07 00 00 00       	mov    $0x7,%edi
  80361c:	48 b8 5c 33 80 00 00 	movabs $0x80335c,%rax
  803623:	00 00 00 
  803626:	ff d0                	callq  *%rax
  803628:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80362b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80362f:	78 69                	js     80369a <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803631:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803638:	7f 08                	jg     803642 <nsipc_recv+0x6f>
  80363a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80363d:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803640:	7e 35                	jle    803677 <nsipc_recv+0xa4>
  803642:	48 b9 b6 4a 80 00 00 	movabs $0x804ab6,%rcx
  803649:	00 00 00 
  80364c:	48 ba cb 4a 80 00 00 	movabs $0x804acb,%rdx
  803653:	00 00 00 
  803656:	be 61 00 00 00       	mov    $0x61,%esi
  80365b:	48 bf e0 4a 80 00 00 	movabs $0x804ae0,%rdi
  803662:	00 00 00 
  803665:	b8 00 00 00 00       	mov    $0x0,%eax
  80366a:	49 b8 24 40 80 00 00 	movabs $0x804024,%r8
  803671:	00 00 00 
  803674:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803677:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80367a:	48 63 d0             	movslq %eax,%rdx
  80367d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803681:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803688:	00 00 00 
  80368b:	48 89 c7             	mov    %rax,%rdi
  80368e:	48 b8 28 12 80 00 00 	movabs $0x801228,%rax
  803695:	00 00 00 
  803698:	ff d0                	callq  *%rax
	}

	return r;
  80369a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80369d:	c9                   	leaveq 
  80369e:	c3                   	retq   

000000000080369f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80369f:	55                   	push   %rbp
  8036a0:	48 89 e5             	mov    %rsp,%rbp
  8036a3:	48 83 ec 20          	sub    $0x20,%rsp
  8036a7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036ae:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8036b1:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8036b4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036bb:	00 00 00 
  8036be:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036c1:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8036c3:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8036ca:	7e 35                	jle    803701 <nsipc_send+0x62>
  8036cc:	48 b9 ec 4a 80 00 00 	movabs $0x804aec,%rcx
  8036d3:	00 00 00 
  8036d6:	48 ba cb 4a 80 00 00 	movabs $0x804acb,%rdx
  8036dd:	00 00 00 
  8036e0:	be 6c 00 00 00       	mov    $0x6c,%esi
  8036e5:	48 bf e0 4a 80 00 00 	movabs $0x804ae0,%rdi
  8036ec:	00 00 00 
  8036ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8036f4:	49 b8 24 40 80 00 00 	movabs $0x804024,%r8
  8036fb:	00 00 00 
  8036fe:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803701:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803704:	48 63 d0             	movslq %eax,%rdx
  803707:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80370b:	48 89 c6             	mov    %rax,%rsi
  80370e:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803715:	00 00 00 
  803718:	48 b8 28 12 80 00 00 	movabs $0x801228,%rax
  80371f:	00 00 00 
  803722:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803724:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80372b:	00 00 00 
  80372e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803731:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803734:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80373b:	00 00 00 
  80373e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803741:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803744:	bf 08 00 00 00       	mov    $0x8,%edi
  803749:	48 b8 5c 33 80 00 00 	movabs $0x80335c,%rax
  803750:	00 00 00 
  803753:	ff d0                	callq  *%rax
}
  803755:	c9                   	leaveq 
  803756:	c3                   	retq   

0000000000803757 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803757:	55                   	push   %rbp
  803758:	48 89 e5             	mov    %rsp,%rbp
  80375b:	48 83 ec 10          	sub    $0x10,%rsp
  80375f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803762:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803765:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803768:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80376f:	00 00 00 
  803772:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803775:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803777:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80377e:	00 00 00 
  803781:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803784:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803787:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80378e:	00 00 00 
  803791:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803794:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803797:	bf 09 00 00 00       	mov    $0x9,%edi
  80379c:	48 b8 5c 33 80 00 00 	movabs $0x80335c,%rax
  8037a3:	00 00 00 
  8037a6:	ff d0                	callq  *%rax
}
  8037a8:	c9                   	leaveq 
  8037a9:	c3                   	retq   

00000000008037aa <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8037aa:	55                   	push   %rbp
  8037ab:	48 89 e5             	mov    %rsp,%rbp
  8037ae:	53                   	push   %rbx
  8037af:	48 83 ec 38          	sub    $0x38,%rsp
  8037b3:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8037b7:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8037bb:	48 89 c7             	mov    %rax,%rdi
  8037be:	48 b8 c6 1e 80 00 00 	movabs $0x801ec6,%rax
  8037c5:	00 00 00 
  8037c8:	ff d0                	callq  *%rax
  8037ca:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037d1:	0f 88 bf 01 00 00    	js     803996 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037db:	ba 07 04 00 00       	mov    $0x407,%edx
  8037e0:	48 89 c6             	mov    %rax,%rsi
  8037e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8037e8:	48 b8 31 18 80 00 00 	movabs $0x801831,%rax
  8037ef:	00 00 00 
  8037f2:	ff d0                	callq  *%rax
  8037f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037fb:	0f 88 95 01 00 00    	js     803996 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803801:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803805:	48 89 c7             	mov    %rax,%rdi
  803808:	48 b8 c6 1e 80 00 00 	movabs $0x801ec6,%rax
  80380f:	00 00 00 
  803812:	ff d0                	callq  *%rax
  803814:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803817:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80381b:	0f 88 5d 01 00 00    	js     80397e <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803821:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803825:	ba 07 04 00 00       	mov    $0x407,%edx
  80382a:	48 89 c6             	mov    %rax,%rsi
  80382d:	bf 00 00 00 00       	mov    $0x0,%edi
  803832:	48 b8 31 18 80 00 00 	movabs $0x801831,%rax
  803839:	00 00 00 
  80383c:	ff d0                	callq  *%rax
  80383e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803841:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803845:	0f 88 33 01 00 00    	js     80397e <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80384b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80384f:	48 89 c7             	mov    %rax,%rdi
  803852:	48 b8 9b 1e 80 00 00 	movabs $0x801e9b,%rax
  803859:	00 00 00 
  80385c:	ff d0                	callq  *%rax
  80385e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803862:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803866:	ba 07 04 00 00       	mov    $0x407,%edx
  80386b:	48 89 c6             	mov    %rax,%rsi
  80386e:	bf 00 00 00 00       	mov    $0x0,%edi
  803873:	48 b8 31 18 80 00 00 	movabs $0x801831,%rax
  80387a:	00 00 00 
  80387d:	ff d0                	callq  *%rax
  80387f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803882:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803886:	79 05                	jns    80388d <pipe+0xe3>
		goto err2;
  803888:	e9 d9 00 00 00       	jmpq   803966 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80388d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803891:	48 89 c7             	mov    %rax,%rdi
  803894:	48 b8 9b 1e 80 00 00 	movabs $0x801e9b,%rax
  80389b:	00 00 00 
  80389e:	ff d0                	callq  *%rax
  8038a0:	48 89 c2             	mov    %rax,%rdx
  8038a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038a7:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8038ad:	48 89 d1             	mov    %rdx,%rcx
  8038b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8038b5:	48 89 c6             	mov    %rax,%rsi
  8038b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8038bd:	48 b8 83 18 80 00 00 	movabs $0x801883,%rax
  8038c4:	00 00 00 
  8038c7:	ff d0                	callq  *%rax
  8038c9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038d0:	79 1b                	jns    8038ed <pipe+0x143>
		goto err3;
  8038d2:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8038d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038d7:	48 89 c6             	mov    %rax,%rsi
  8038da:	bf 00 00 00 00       	mov    $0x0,%edi
  8038df:	48 b8 e3 18 80 00 00 	movabs $0x8018e3,%rax
  8038e6:	00 00 00 
  8038e9:	ff d0                	callq  *%rax
  8038eb:	eb 79                	jmp    803966 <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  8038ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038f1:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8038f8:	00 00 00 
  8038fb:	8b 12                	mov    (%rdx),%edx
  8038fd:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8038ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803903:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  80390a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80390e:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803915:	00 00 00 
  803918:	8b 12                	mov    (%rdx),%edx
  80391a:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80391c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803920:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  803927:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80392b:	48 89 c7             	mov    %rax,%rdi
  80392e:	48 b8 78 1e 80 00 00 	movabs $0x801e78,%rax
  803935:	00 00 00 
  803938:	ff d0                	callq  *%rax
  80393a:	89 c2                	mov    %eax,%edx
  80393c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803940:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803942:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803946:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80394a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80394e:	48 89 c7             	mov    %rax,%rdi
  803951:	48 b8 78 1e 80 00 00 	movabs $0x801e78,%rax
  803958:	00 00 00 
  80395b:	ff d0                	callq  *%rax
  80395d:	89 03                	mov    %eax,(%rbx)
	return 0;
  80395f:	b8 00 00 00 00       	mov    $0x0,%eax
  803964:	eb 33                	jmp    803999 <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  803966:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80396a:	48 89 c6             	mov    %rax,%rsi
  80396d:	bf 00 00 00 00       	mov    $0x0,%edi
  803972:	48 b8 e3 18 80 00 00 	movabs $0x8018e3,%rax
  803979:	00 00 00 
  80397c:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80397e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803982:	48 89 c6             	mov    %rax,%rsi
  803985:	bf 00 00 00 00       	mov    $0x0,%edi
  80398a:	48 b8 e3 18 80 00 00 	movabs $0x8018e3,%rax
  803991:	00 00 00 
  803994:	ff d0                	callq  *%rax
err:
	return r;
  803996:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803999:	48 83 c4 38          	add    $0x38,%rsp
  80399d:	5b                   	pop    %rbx
  80399e:	5d                   	pop    %rbp
  80399f:	c3                   	retq   

00000000008039a0 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8039a0:	55                   	push   %rbp
  8039a1:	48 89 e5             	mov    %rsp,%rbp
  8039a4:	53                   	push   %rbx
  8039a5:	48 83 ec 28          	sub    $0x28,%rsp
  8039a9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039ad:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8039b1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8039b8:	00 00 00 
  8039bb:	48 8b 00             	mov    (%rax),%rax
  8039be:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8039c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8039c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039cb:	48 89 c7             	mov    %rax,%rdi
  8039ce:	48 b8 75 43 80 00 00 	movabs $0x804375,%rax
  8039d5:	00 00 00 
  8039d8:	ff d0                	callq  *%rax
  8039da:	89 c3                	mov    %eax,%ebx
  8039dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039e0:	48 89 c7             	mov    %rax,%rdi
  8039e3:	48 b8 75 43 80 00 00 	movabs $0x804375,%rax
  8039ea:	00 00 00 
  8039ed:	ff d0                	callq  *%rax
  8039ef:	39 c3                	cmp    %eax,%ebx
  8039f1:	0f 94 c0             	sete   %al
  8039f4:	0f b6 c0             	movzbl %al,%eax
  8039f7:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8039fa:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a01:	00 00 00 
  803a04:	48 8b 00             	mov    (%rax),%rax
  803a07:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803a0d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803a10:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a13:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803a16:	75 05                	jne    803a1d <_pipeisclosed+0x7d>
			return ret;
  803a18:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803a1b:	eb 4a                	jmp    803a67 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803a1d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a20:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803a23:	74 3d                	je     803a62 <_pipeisclosed+0xc2>
  803a25:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803a29:	75 37                	jne    803a62 <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803a2b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a32:	00 00 00 
  803a35:	48 8b 00             	mov    (%rax),%rax
  803a38:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803a3e:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803a41:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a44:	89 c6                	mov    %eax,%esi
  803a46:	48 bf fd 4a 80 00 00 	movabs $0x804afd,%rdi
  803a4d:	00 00 00 
  803a50:	b8 00 00 00 00       	mov    $0x0,%eax
  803a55:	49 b8 6a 03 80 00 00 	movabs $0x80036a,%r8
  803a5c:	00 00 00 
  803a5f:	41 ff d0             	callq  *%r8
	}
  803a62:	e9 4a ff ff ff       	jmpq   8039b1 <_pipeisclosed+0x11>
}
  803a67:	48 83 c4 28          	add    $0x28,%rsp
  803a6b:	5b                   	pop    %rbx
  803a6c:	5d                   	pop    %rbp
  803a6d:	c3                   	retq   

0000000000803a6e <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803a6e:	55                   	push   %rbp
  803a6f:	48 89 e5             	mov    %rsp,%rbp
  803a72:	48 83 ec 30          	sub    $0x30,%rsp
  803a76:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803a79:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803a7d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803a80:	48 89 d6             	mov    %rdx,%rsi
  803a83:	89 c7                	mov    %eax,%edi
  803a85:	48 b8 5e 1f 80 00 00 	movabs $0x801f5e,%rax
  803a8c:	00 00 00 
  803a8f:	ff d0                	callq  *%rax
  803a91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a98:	79 05                	jns    803a9f <pipeisclosed+0x31>
		return r;
  803a9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a9d:	eb 31                	jmp    803ad0 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803a9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803aa3:	48 89 c7             	mov    %rax,%rdi
  803aa6:	48 b8 9b 1e 80 00 00 	movabs $0x801e9b,%rax
  803aad:	00 00 00 
  803ab0:	ff d0                	callq  *%rax
  803ab2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803ab6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803aba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803abe:	48 89 d6             	mov    %rdx,%rsi
  803ac1:	48 89 c7             	mov    %rax,%rdi
  803ac4:	48 b8 a0 39 80 00 00 	movabs $0x8039a0,%rax
  803acb:	00 00 00 
  803ace:	ff d0                	callq  *%rax
}
  803ad0:	c9                   	leaveq 
  803ad1:	c3                   	retq   

0000000000803ad2 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803ad2:	55                   	push   %rbp
  803ad3:	48 89 e5             	mov    %rsp,%rbp
  803ad6:	48 83 ec 40          	sub    $0x40,%rsp
  803ada:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803ade:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ae2:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803ae6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aea:	48 89 c7             	mov    %rax,%rdi
  803aed:	48 b8 9b 1e 80 00 00 	movabs $0x801e9b,%rax
  803af4:	00 00 00 
  803af7:	ff d0                	callq  *%rax
  803af9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803afd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b01:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803b05:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803b0c:	00 
  803b0d:	e9 92 00 00 00       	jmpq   803ba4 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803b12:	eb 41                	jmp    803b55 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803b14:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803b19:	74 09                	je     803b24 <devpipe_read+0x52>
				return i;
  803b1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b1f:	e9 92 00 00 00       	jmpq   803bb6 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803b24:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b2c:	48 89 d6             	mov    %rdx,%rsi
  803b2f:	48 89 c7             	mov    %rax,%rdi
  803b32:	48 b8 a0 39 80 00 00 	movabs $0x8039a0,%rax
  803b39:	00 00 00 
  803b3c:	ff d0                	callq  *%rax
  803b3e:	85 c0                	test   %eax,%eax
  803b40:	74 07                	je     803b49 <devpipe_read+0x77>
				return 0;
  803b42:	b8 00 00 00 00       	mov    $0x0,%eax
  803b47:	eb 6d                	jmp    803bb6 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803b49:	48 b8 f5 17 80 00 00 	movabs $0x8017f5,%rax
  803b50:	00 00 00 
  803b53:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  803b55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b59:	8b 10                	mov    (%rax),%edx
  803b5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b5f:	8b 40 04             	mov    0x4(%rax),%eax
  803b62:	39 c2                	cmp    %eax,%edx
  803b64:	74 ae                	je     803b14 <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803b66:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803b6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b6e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803b72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b76:	8b 00                	mov    (%rax),%eax
  803b78:	99                   	cltd   
  803b79:	c1 ea 1b             	shr    $0x1b,%edx
  803b7c:	01 d0                	add    %edx,%eax
  803b7e:	83 e0 1f             	and    $0x1f,%eax
  803b81:	29 d0                	sub    %edx,%eax
  803b83:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b87:	48 98                	cltq   
  803b89:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803b8e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803b90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b94:	8b 00                	mov    (%rax),%eax
  803b96:	8d 50 01             	lea    0x1(%rax),%edx
  803b99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b9d:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  803b9f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ba4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ba8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803bac:	0f 82 60 ff ff ff    	jb     803b12 <devpipe_read+0x40>
	}
	return i;
  803bb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803bb6:	c9                   	leaveq 
  803bb7:	c3                   	retq   

0000000000803bb8 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803bb8:	55                   	push   %rbp
  803bb9:	48 89 e5             	mov    %rsp,%rbp
  803bbc:	48 83 ec 40          	sub    $0x40,%rsp
  803bc0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803bc4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803bc8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803bcc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bd0:	48 89 c7             	mov    %rax,%rdi
  803bd3:	48 b8 9b 1e 80 00 00 	movabs $0x801e9b,%rax
  803bda:	00 00 00 
  803bdd:	ff d0                	callq  *%rax
  803bdf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803be3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803be7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803beb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803bf2:	00 
  803bf3:	e9 91 00 00 00       	jmpq   803c89 <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803bf8:	eb 31                	jmp    803c2b <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803bfa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803bfe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c02:	48 89 d6             	mov    %rdx,%rsi
  803c05:	48 89 c7             	mov    %rax,%rdi
  803c08:	48 b8 a0 39 80 00 00 	movabs $0x8039a0,%rax
  803c0f:	00 00 00 
  803c12:	ff d0                	callq  *%rax
  803c14:	85 c0                	test   %eax,%eax
  803c16:	74 07                	je     803c1f <devpipe_write+0x67>
				return 0;
  803c18:	b8 00 00 00 00       	mov    $0x0,%eax
  803c1d:	eb 7c                	jmp    803c9b <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803c1f:	48 b8 f5 17 80 00 00 	movabs $0x8017f5,%rax
  803c26:	00 00 00 
  803c29:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803c2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c2f:	8b 40 04             	mov    0x4(%rax),%eax
  803c32:	48 63 d0             	movslq %eax,%rdx
  803c35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c39:	8b 00                	mov    (%rax),%eax
  803c3b:	48 98                	cltq   
  803c3d:	48 83 c0 20          	add    $0x20,%rax
  803c41:	48 39 c2             	cmp    %rax,%rdx
  803c44:	73 b4                	jae    803bfa <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803c46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c4a:	8b 40 04             	mov    0x4(%rax),%eax
  803c4d:	99                   	cltd   
  803c4e:	c1 ea 1b             	shr    $0x1b,%edx
  803c51:	01 d0                	add    %edx,%eax
  803c53:	83 e0 1f             	and    $0x1f,%eax
  803c56:	29 d0                	sub    %edx,%eax
  803c58:	89 c6                	mov    %eax,%esi
  803c5a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803c5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c62:	48 01 d0             	add    %rdx,%rax
  803c65:	0f b6 08             	movzbl (%rax),%ecx
  803c68:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c6c:	48 63 c6             	movslq %esi,%rax
  803c6f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803c73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c77:	8b 40 04             	mov    0x4(%rax),%eax
  803c7a:	8d 50 01             	lea    0x1(%rax),%edx
  803c7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c81:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  803c84:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803c89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c8d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803c91:	0f 82 61 ff ff ff    	jb     803bf8 <devpipe_write+0x40>
	}

	return i;
  803c97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803c9b:	c9                   	leaveq 
  803c9c:	c3                   	retq   

0000000000803c9d <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803c9d:	55                   	push   %rbp
  803c9e:	48 89 e5             	mov    %rsp,%rbp
  803ca1:	48 83 ec 20          	sub    $0x20,%rsp
  803ca5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ca9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803cad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cb1:	48 89 c7             	mov    %rax,%rdi
  803cb4:	48 b8 9b 1e 80 00 00 	movabs $0x801e9b,%rax
  803cbb:	00 00 00 
  803cbe:	ff d0                	callq  *%rax
  803cc0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803cc4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cc8:	48 be 10 4b 80 00 00 	movabs $0x804b10,%rsi
  803ccf:	00 00 00 
  803cd2:	48 89 c7             	mov    %rax,%rdi
  803cd5:	48 b8 04 0f 80 00 00 	movabs $0x800f04,%rax
  803cdc:	00 00 00 
  803cdf:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803ce1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ce5:	8b 50 04             	mov    0x4(%rax),%edx
  803ce8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cec:	8b 00                	mov    (%rax),%eax
  803cee:	29 c2                	sub    %eax,%edx
  803cf0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cf4:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803cfa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cfe:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803d05:	00 00 00 
	stat->st_dev = &devpipe;
  803d08:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d0c:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803d13:	00 00 00 
  803d16:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803d1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d22:	c9                   	leaveq 
  803d23:	c3                   	retq   

0000000000803d24 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803d24:	55                   	push   %rbp
  803d25:	48 89 e5             	mov    %rsp,%rbp
  803d28:	48 83 ec 10          	sub    $0x10,%rsp
  803d2c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803d30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d34:	48 89 c6             	mov    %rax,%rsi
  803d37:	bf 00 00 00 00       	mov    $0x0,%edi
  803d3c:	48 b8 e3 18 80 00 00 	movabs $0x8018e3,%rax
  803d43:	00 00 00 
  803d46:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803d48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d4c:	48 89 c7             	mov    %rax,%rdi
  803d4f:	48 b8 9b 1e 80 00 00 	movabs $0x801e9b,%rax
  803d56:	00 00 00 
  803d59:	ff d0                	callq  *%rax
  803d5b:	48 89 c6             	mov    %rax,%rsi
  803d5e:	bf 00 00 00 00       	mov    $0x0,%edi
  803d63:	48 b8 e3 18 80 00 00 	movabs $0x8018e3,%rax
  803d6a:	00 00 00 
  803d6d:	ff d0                	callq  *%rax
}
  803d6f:	c9                   	leaveq 
  803d70:	c3                   	retq   

0000000000803d71 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803d71:	55                   	push   %rbp
  803d72:	48 89 e5             	mov    %rsp,%rbp
  803d75:	48 83 ec 20          	sub    $0x20,%rsp
  803d79:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803d7c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d7f:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803d82:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803d86:	be 01 00 00 00       	mov    $0x1,%esi
  803d8b:	48 89 c7             	mov    %rax,%rdi
  803d8e:	48 b8 eb 16 80 00 00 	movabs $0x8016eb,%rax
  803d95:	00 00 00 
  803d98:	ff d0                	callq  *%rax
}
  803d9a:	c9                   	leaveq 
  803d9b:	c3                   	retq   

0000000000803d9c <getchar>:

int
getchar(void)
{
  803d9c:	55                   	push   %rbp
  803d9d:	48 89 e5             	mov    %rsp,%rbp
  803da0:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803da4:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803da8:	ba 01 00 00 00       	mov    $0x1,%edx
  803dad:	48 89 c6             	mov    %rax,%rsi
  803db0:	bf 00 00 00 00       	mov    $0x0,%edi
  803db5:	48 b8 92 23 80 00 00 	movabs $0x802392,%rax
  803dbc:	00 00 00 
  803dbf:	ff d0                	callq  *%rax
  803dc1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803dc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dc8:	79 05                	jns    803dcf <getchar+0x33>
		return r;
  803dca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dcd:	eb 14                	jmp    803de3 <getchar+0x47>
	if (r < 1)
  803dcf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dd3:	7f 07                	jg     803ddc <getchar+0x40>
		return -E_EOF;
  803dd5:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803dda:	eb 07                	jmp    803de3 <getchar+0x47>
	return c;
  803ddc:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803de0:	0f b6 c0             	movzbl %al,%eax
}
  803de3:	c9                   	leaveq 
  803de4:	c3                   	retq   

0000000000803de5 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803de5:	55                   	push   %rbp
  803de6:	48 89 e5             	mov    %rsp,%rbp
  803de9:	48 83 ec 20          	sub    $0x20,%rsp
  803ded:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803df0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803df4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803df7:	48 89 d6             	mov    %rdx,%rsi
  803dfa:	89 c7                	mov    %eax,%edi
  803dfc:	48 b8 5e 1f 80 00 00 	movabs $0x801f5e,%rax
  803e03:	00 00 00 
  803e06:	ff d0                	callq  *%rax
  803e08:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e0f:	79 05                	jns    803e16 <iscons+0x31>
		return r;
  803e11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e14:	eb 1a                	jmp    803e30 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803e16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e1a:	8b 10                	mov    (%rax),%edx
  803e1c:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803e23:	00 00 00 
  803e26:	8b 00                	mov    (%rax),%eax
  803e28:	39 c2                	cmp    %eax,%edx
  803e2a:	0f 94 c0             	sete   %al
  803e2d:	0f b6 c0             	movzbl %al,%eax
}
  803e30:	c9                   	leaveq 
  803e31:	c3                   	retq   

0000000000803e32 <opencons>:

int
opencons(void)
{
  803e32:	55                   	push   %rbp
  803e33:	48 89 e5             	mov    %rsp,%rbp
  803e36:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803e3a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803e3e:	48 89 c7             	mov    %rax,%rdi
  803e41:	48 b8 c6 1e 80 00 00 	movabs $0x801ec6,%rax
  803e48:	00 00 00 
  803e4b:	ff d0                	callq  *%rax
  803e4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e54:	79 05                	jns    803e5b <opencons+0x29>
		return r;
  803e56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e59:	eb 5b                	jmp    803eb6 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803e5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e5f:	ba 07 04 00 00       	mov    $0x407,%edx
  803e64:	48 89 c6             	mov    %rax,%rsi
  803e67:	bf 00 00 00 00       	mov    $0x0,%edi
  803e6c:	48 b8 31 18 80 00 00 	movabs $0x801831,%rax
  803e73:	00 00 00 
  803e76:	ff d0                	callq  *%rax
  803e78:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e7f:	79 05                	jns    803e86 <opencons+0x54>
		return r;
  803e81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e84:	eb 30                	jmp    803eb6 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803e86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e8a:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803e91:	00 00 00 
  803e94:	8b 12                	mov    (%rdx),%edx
  803e96:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803e98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e9c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803ea3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ea7:	48 89 c7             	mov    %rax,%rdi
  803eaa:	48 b8 78 1e 80 00 00 	movabs $0x801e78,%rax
  803eb1:	00 00 00 
  803eb4:	ff d0                	callq  *%rax
}
  803eb6:	c9                   	leaveq 
  803eb7:	c3                   	retq   

0000000000803eb8 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803eb8:	55                   	push   %rbp
  803eb9:	48 89 e5             	mov    %rsp,%rbp
  803ebc:	48 83 ec 30          	sub    $0x30,%rsp
  803ec0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ec4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ec8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803ecc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803ed1:	75 07                	jne    803eda <devcons_read+0x22>
		return 0;
  803ed3:	b8 00 00 00 00       	mov    $0x0,%eax
  803ed8:	eb 4b                	jmp    803f25 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803eda:	eb 0c                	jmp    803ee8 <devcons_read+0x30>
		sys_yield();
  803edc:	48 b8 f5 17 80 00 00 	movabs $0x8017f5,%rax
  803ee3:	00 00 00 
  803ee6:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  803ee8:	48 b8 37 17 80 00 00 	movabs $0x801737,%rax
  803eef:	00 00 00 
  803ef2:	ff d0                	callq  *%rax
  803ef4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ef7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803efb:	74 df                	je     803edc <devcons_read+0x24>
	if (c < 0)
  803efd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f01:	79 05                	jns    803f08 <devcons_read+0x50>
		return c;
  803f03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f06:	eb 1d                	jmp    803f25 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803f08:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803f0c:	75 07                	jne    803f15 <devcons_read+0x5d>
		return 0;
  803f0e:	b8 00 00 00 00       	mov    $0x0,%eax
  803f13:	eb 10                	jmp    803f25 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803f15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f18:	89 c2                	mov    %eax,%edx
  803f1a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f1e:	88 10                	mov    %dl,(%rax)
	return 1;
  803f20:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803f25:	c9                   	leaveq 
  803f26:	c3                   	retq   

0000000000803f27 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803f27:	55                   	push   %rbp
  803f28:	48 89 e5             	mov    %rsp,%rbp
  803f2b:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803f32:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803f39:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803f40:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803f47:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f4e:	eb 76                	jmp    803fc6 <devcons_write+0x9f>
		m = n - tot;
  803f50:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803f57:	89 c2                	mov    %eax,%edx
  803f59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f5c:	29 c2                	sub    %eax,%edx
  803f5e:	89 d0                	mov    %edx,%eax
  803f60:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803f63:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f66:	83 f8 7f             	cmp    $0x7f,%eax
  803f69:	76 07                	jbe    803f72 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803f6b:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803f72:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f75:	48 63 d0             	movslq %eax,%rdx
  803f78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f7b:	48 63 c8             	movslq %eax,%rcx
  803f7e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803f85:	48 01 c1             	add    %rax,%rcx
  803f88:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803f8f:	48 89 ce             	mov    %rcx,%rsi
  803f92:	48 89 c7             	mov    %rax,%rdi
  803f95:	48 b8 28 12 80 00 00 	movabs $0x801228,%rax
  803f9c:	00 00 00 
  803f9f:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803fa1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fa4:	48 63 d0             	movslq %eax,%rdx
  803fa7:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803fae:	48 89 d6             	mov    %rdx,%rsi
  803fb1:	48 89 c7             	mov    %rax,%rdi
  803fb4:	48 b8 eb 16 80 00 00 	movabs $0x8016eb,%rax
  803fbb:	00 00 00 
  803fbe:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  803fc0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fc3:	01 45 fc             	add    %eax,-0x4(%rbp)
  803fc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fc9:	48 98                	cltq   
  803fcb:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803fd2:	0f 82 78 ff ff ff    	jb     803f50 <devcons_write+0x29>
	}
	return tot;
  803fd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803fdb:	c9                   	leaveq 
  803fdc:	c3                   	retq   

0000000000803fdd <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803fdd:	55                   	push   %rbp
  803fde:	48 89 e5             	mov    %rsp,%rbp
  803fe1:	48 83 ec 08          	sub    $0x8,%rsp
  803fe5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803fe9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fee:	c9                   	leaveq 
  803fef:	c3                   	retq   

0000000000803ff0 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803ff0:	55                   	push   %rbp
  803ff1:	48 89 e5             	mov    %rsp,%rbp
  803ff4:	48 83 ec 10          	sub    $0x10,%rsp
  803ff8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ffc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804000:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804004:	48 be 1c 4b 80 00 00 	movabs $0x804b1c,%rsi
  80400b:	00 00 00 
  80400e:	48 89 c7             	mov    %rax,%rdi
  804011:	48 b8 04 0f 80 00 00 	movabs $0x800f04,%rax
  804018:	00 00 00 
  80401b:	ff d0                	callq  *%rax
	return 0;
  80401d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804022:	c9                   	leaveq 
  804023:	c3                   	retq   

0000000000804024 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  804024:	55                   	push   %rbp
  804025:	48 89 e5             	mov    %rsp,%rbp
  804028:	53                   	push   %rbx
  804029:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  804030:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  804037:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80403d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  804044:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80404b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  804052:	84 c0                	test   %al,%al
  804054:	74 23                	je     804079 <_panic+0x55>
  804056:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80405d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  804061:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  804065:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  804069:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80406d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  804071:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  804075:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  804079:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  804080:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  804087:	00 00 00 
  80408a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  804091:	00 00 00 
  804094:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804098:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80409f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8040a6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8040ad:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8040b4:	00 00 00 
  8040b7:	48 8b 18             	mov    (%rax),%rbx
  8040ba:	48 b8 b9 17 80 00 00 	movabs $0x8017b9,%rax
  8040c1:	00 00 00 
  8040c4:	ff d0                	callq  *%rax
  8040c6:	89 c6                	mov    %eax,%esi
  8040c8:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8040ce:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8040d5:	41 89 d0             	mov    %edx,%r8d
  8040d8:	48 89 c1             	mov    %rax,%rcx
  8040db:	48 89 da             	mov    %rbx,%rdx
  8040de:	48 bf 28 4b 80 00 00 	movabs $0x804b28,%rdi
  8040e5:	00 00 00 
  8040e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8040ed:	49 b9 6a 03 80 00 00 	movabs $0x80036a,%r9
  8040f4:	00 00 00 
  8040f7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8040fa:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  804101:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  804108:	48 89 d6             	mov    %rdx,%rsi
  80410b:	48 89 c7             	mov    %rax,%rdi
  80410e:	48 b8 be 02 80 00 00 	movabs $0x8002be,%rax
  804115:	00 00 00 
  804118:	ff d0                	callq  *%rax
	cprintf("\n");
  80411a:	48 bf 4b 4b 80 00 00 	movabs $0x804b4b,%rdi
  804121:	00 00 00 
  804124:	b8 00 00 00 00       	mov    $0x0,%eax
  804129:	48 ba 6a 03 80 00 00 	movabs $0x80036a,%rdx
  804130:	00 00 00 
  804133:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  804135:	cc                   	int3   
  804136:	eb fd                	jmp    804135 <_panic+0x111>

0000000000804138 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804138:	55                   	push   %rbp
  804139:	48 89 e5             	mov    %rsp,%rbp
  80413c:	48 83 ec 20          	sub    $0x20,%rsp
  804140:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804144:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804148:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  80414c:	48 ba 50 4b 80 00 00 	movabs $0x804b50,%rdx
  804153:	00 00 00 
  804156:	be 1d 00 00 00       	mov    $0x1d,%esi
  80415b:	48 bf 69 4b 80 00 00 	movabs $0x804b69,%rdi
  804162:	00 00 00 
  804165:	b8 00 00 00 00       	mov    $0x0,%eax
  80416a:	48 b9 24 40 80 00 00 	movabs $0x804024,%rcx
  804171:	00 00 00 
  804174:	ff d1                	callq  *%rcx

0000000000804176 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804176:	55                   	push   %rbp
  804177:	48 89 e5             	mov    %rsp,%rbp
  80417a:	48 83 ec 20          	sub    $0x20,%rsp
  80417e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804181:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804184:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  804188:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  80418b:	48 ba 73 4b 80 00 00 	movabs $0x804b73,%rdx
  804192:	00 00 00 
  804195:	be 2d 00 00 00       	mov    $0x2d,%esi
  80419a:	48 bf 69 4b 80 00 00 	movabs $0x804b69,%rdi
  8041a1:	00 00 00 
  8041a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8041a9:	48 b9 24 40 80 00 00 	movabs $0x804024,%rcx
  8041b0:	00 00 00 
  8041b3:	ff d1                	callq  *%rcx

00000000008041b5 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8041b5:	55                   	push   %rbp
  8041b6:	48 89 e5             	mov    %rsp,%rbp
  8041b9:	53                   	push   %rbx
  8041ba:	48 83 ec 48          	sub    $0x48,%rsp
  8041be:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  8041c2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  8041c9:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  8041d0:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  8041d5:	75 0e                	jne    8041e5 <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  8041d7:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8041de:	00 00 00 
  8041e1:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  8041e5:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8041e9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  8041ed:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8041f4:	00 
	a3 = (uint64_t) 0;
  8041f5:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  8041fc:	00 
	a4 = (uint64_t) 0;
  8041fd:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  804204:	00 
	a5 = 0;
  804205:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  80420c:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  80420d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804210:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804214:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  804218:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  80421c:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  804220:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  804224:	4c 89 c3             	mov    %r8,%rbx
  804227:	0f 01 c1             	vmcall 
  80422a:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  80422d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804231:	7e 36                	jle    804269 <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  804233:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804236:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804239:	41 89 d0             	mov    %edx,%r8d
  80423c:	89 c1                	mov    %eax,%ecx
  80423e:	48 ba 90 4b 80 00 00 	movabs $0x804b90,%rdx
  804245:	00 00 00 
  804248:	be 54 00 00 00       	mov    $0x54,%esi
  80424d:	48 bf 69 4b 80 00 00 	movabs $0x804b69,%rdi
  804254:	00 00 00 
  804257:	b8 00 00 00 00       	mov    $0x0,%eax
  80425c:	49 b9 24 40 80 00 00 	movabs $0x804024,%r9
  804263:	00 00 00 
  804266:	41 ff d1             	callq  *%r9
	return ret;
  804269:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80426c:	48 83 c4 48          	add    $0x48,%rsp
  804270:	5b                   	pop    %rbx
  804271:	5d                   	pop    %rbp
  804272:	c3                   	retq   

0000000000804273 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804273:	55                   	push   %rbp
  804274:	48 89 e5             	mov    %rsp,%rbp
  804277:	53                   	push   %rbx
  804278:	48 83 ec 58          	sub    $0x58,%rsp
  80427c:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  80427f:	89 75 b0             	mov    %esi,-0x50(%rbp)
  804282:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  804286:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  804289:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  804290:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  804297:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  80429c:	75 0e                	jne    8042ac <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  80429e:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8042a5:	00 00 00 
  8042a8:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  8042ac:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8042af:	48 98                	cltq   
  8042b1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  8042b5:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8042b8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  8042bc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8042c0:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  8042c4:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  8042c7:	48 98                	cltq   
  8042c9:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  8042cd:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  8042d4:	00 

	int r = -E_IPC_NOT_RECV;
  8042d5:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  8042dc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8042df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8042e3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8042e7:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  8042eb:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8042ef:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8042f3:	4c 89 c3             	mov    %r8,%rbx
  8042f6:	0f 01 c1             	vmcall 
  8042f9:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  8042fc:	48 83 c4 58          	add    $0x58,%rsp
  804300:	5b                   	pop    %rbx
  804301:	5d                   	pop    %rbp
  804302:	c3                   	retq   

0000000000804303 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804303:	55                   	push   %rbp
  804304:	48 89 e5             	mov    %rsp,%rbp
  804307:	48 83 ec 18          	sub    $0x18,%rsp
  80430b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80430e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804315:	eb 4e                	jmp    804365 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  804317:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80431e:	00 00 00 
  804321:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804324:	48 98                	cltq   
  804326:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80432d:	48 01 d0             	add    %rdx,%rax
  804330:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804336:	8b 00                	mov    (%rax),%eax
  804338:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80433b:	75 24                	jne    804361 <ipc_find_env+0x5e>
			return envs[i].env_id;
  80433d:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804344:	00 00 00 
  804347:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80434a:	48 98                	cltq   
  80434c:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804353:	48 01 d0             	add    %rdx,%rax
  804356:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80435c:	8b 40 08             	mov    0x8(%rax),%eax
  80435f:	eb 12                	jmp    804373 <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  804361:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804365:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80436c:	7e a9                	jle    804317 <ipc_find_env+0x14>
	}
	return 0;
  80436e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804373:	c9                   	leaveq 
  804374:	c3                   	retq   

0000000000804375 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804375:	55                   	push   %rbp
  804376:	48 89 e5             	mov    %rsp,%rbp
  804379:	48 83 ec 18          	sub    $0x18,%rsp
  80437d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804381:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804385:	48 c1 e8 15          	shr    $0x15,%rax
  804389:	48 89 c2             	mov    %rax,%rdx
  80438c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804393:	01 00 00 
  804396:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80439a:	83 e0 01             	and    $0x1,%eax
  80439d:	48 85 c0             	test   %rax,%rax
  8043a0:	75 07                	jne    8043a9 <pageref+0x34>
		return 0;
  8043a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8043a7:	eb 53                	jmp    8043fc <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8043a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043ad:	48 c1 e8 0c          	shr    $0xc,%rax
  8043b1:	48 89 c2             	mov    %rax,%rdx
  8043b4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8043bb:	01 00 00 
  8043be:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8043c2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8043c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043ca:	83 e0 01             	and    $0x1,%eax
  8043cd:	48 85 c0             	test   %rax,%rax
  8043d0:	75 07                	jne    8043d9 <pageref+0x64>
		return 0;
  8043d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8043d7:	eb 23                	jmp    8043fc <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8043d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043dd:	48 c1 e8 0c          	shr    $0xc,%rax
  8043e1:	48 89 c2             	mov    %rax,%rdx
  8043e4:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8043eb:	00 00 00 
  8043ee:	48 c1 e2 04          	shl    $0x4,%rdx
  8043f2:	48 01 d0             	add    %rdx,%rax
  8043f5:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8043f9:	0f b7 c0             	movzwl %ax,%eax
}
  8043fc:	c9                   	leaveq 
  8043fd:	c3                   	retq   
