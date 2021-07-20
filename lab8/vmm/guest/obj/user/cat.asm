
vmm/guest/obj/user/cat:     formato del fichero elf64-x86-64


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
  80003c:	e8 02 02 00 00       	callq  800243 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800052:	eb 68                	jmp    8000bc <cat+0x79>
		if ((r = write(1, buf, n)) != n)
  800054:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800058:	48 89 c2             	mov    %rax,%rdx
  80005b:	48 be 40 70 80 00 00 	movabs $0x807040,%rsi
  800062:	00 00 00 
  800065:	bf 01 00 00 00       	mov    $0x1,%edi
  80006a:	48 b8 92 23 80 00 00 	movabs $0x802392,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800079:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80007c:	48 98                	cltq   
  80007e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800082:	74 38                	je     8000bc <cat+0x79>
			panic("write error copying %s: %e", s, r);
  800084:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800087:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80008b:	41 89 d0             	mov    %edx,%r8d
  80008e:	48 89 c1             	mov    %rax,%rcx
  800091:	48 ba c0 41 80 00 00 	movabs $0x8041c0,%rdx
  800098:	00 00 00 
  80009b:	be 0d 00 00 00       	mov    $0xd,%esi
  8000a0:	48 bf db 41 80 00 00 	movabs $0x8041db,%rdi
  8000a7:	00 00 00 
  8000aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8000af:	49 b9 c6 02 80 00 00 	movabs $0x8002c6,%r9
  8000b6:	00 00 00 
  8000b9:	41 ff d1             	callq  *%r9
	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  8000bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000bf:	ba 00 20 00 00       	mov    $0x2000,%edx
  8000c4:	48 be 40 70 80 00 00 	movabs $0x807040,%rsi
  8000cb:	00 00 00 
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	48 b8 48 22 80 00 00 	movabs $0x802248,%rax
  8000d7:	00 00 00 
  8000da:	ff d0                	callq  *%rax
  8000dc:	48 98                	cltq   
  8000de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8000e2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8000e7:	0f 8f 67 ff ff ff    	jg     800054 <cat+0x11>
	if (n < 0)
  8000ed:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8000f2:	79 39                	jns    80012d <cat+0xea>
		panic("error reading %s: %e", s, n);
  8000f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000fc:	49 89 d0             	mov    %rdx,%r8
  8000ff:	48 89 c1             	mov    %rax,%rcx
  800102:	48 ba e6 41 80 00 00 	movabs $0x8041e6,%rdx
  800109:	00 00 00 
  80010c:	be 0f 00 00 00       	mov    $0xf,%esi
  800111:	48 bf db 41 80 00 00 	movabs $0x8041db,%rdi
  800118:	00 00 00 
  80011b:	b8 00 00 00 00       	mov    $0x0,%eax
  800120:	49 b9 c6 02 80 00 00 	movabs $0x8002c6,%r9
  800127:	00 00 00 
  80012a:	41 ff d1             	callq  *%r9
}
  80012d:	c9                   	leaveq 
  80012e:	c3                   	retq   

000000000080012f <umain>:

void
umain(int argc, char **argv)
{
  80012f:	55                   	push   %rbp
  800130:	48 89 e5             	mov    %rsp,%rbp
  800133:	48 83 ec 20          	sub    $0x20,%rsp
  800137:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80013a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int f, i;

	binaryname = "cat";
  80013e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800145:	00 00 00 
  800148:	48 b9 fb 41 80 00 00 	movabs $0x8041fb,%rcx
  80014f:	00 00 00 
  800152:	48 89 08             	mov    %rcx,(%rax)
	if (argc == 1)
  800155:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  800159:	75 20                	jne    80017b <umain+0x4c>
		cat(0, "<stdin>");
  80015b:	48 be ff 41 80 00 00 	movabs $0x8041ff,%rsi
  800162:	00 00 00 
  800165:	bf 00 00 00 00       	mov    $0x0,%edi
  80016a:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800171:	00 00 00 
  800174:	ff d0                	callq  *%rax
  800176:	e9 c6 00 00 00       	jmpq   800241 <umain+0x112>
	else
		for (i = 1; i < argc; i++) {
  80017b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  800182:	e9 ae 00 00 00       	jmpq   800235 <umain+0x106>
			f = open(argv[i], O_RDONLY);
  800187:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80018a:	48 98                	cltq   
  80018c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800193:	00 
  800194:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800198:	48 01 d0             	add    %rdx,%rax
  80019b:	48 8b 00             	mov    (%rax),%rax
  80019e:	be 00 00 00 00       	mov    $0x0,%esi
  8001a3:	48 89 c7             	mov    %rax,%rdi
  8001a6:	48 b8 20 27 80 00 00 	movabs $0x802720,%rax
  8001ad:	00 00 00 
  8001b0:	ff d0                	callq  *%rax
  8001b2:	89 45 f8             	mov    %eax,-0x8(%rbp)
			if (f < 0)
  8001b5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8001b9:	79 3a                	jns    8001f5 <umain+0xc6>
				printf("can't open %s: %e\n", argv[i], f);
  8001bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001be:	48 98                	cltq   
  8001c0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8001c7:	00 
  8001c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8001cc:	48 01 d0             	add    %rdx,%rax
  8001cf:	48 8b 00             	mov    (%rax),%rax
  8001d2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8001d5:	48 89 c6             	mov    %rax,%rsi
  8001d8:	48 bf 07 42 80 00 00 	movabs $0x804207,%rdi
  8001df:	00 00 00 
  8001e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e7:	48 b9 9c 2d 80 00 00 	movabs $0x802d9c,%rcx
  8001ee:	00 00 00 
  8001f1:	ff d1                	callq  *%rcx
  8001f3:	eb 3c                	jmp    800231 <umain+0x102>
			else {
				cat(f, argv[i]);
  8001f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001f8:	48 98                	cltq   
  8001fa:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800201:	00 
  800202:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800206:	48 01 d0             	add    %rdx,%rax
  800209:	48 8b 10             	mov    (%rax),%rdx
  80020c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80020f:	48 89 d6             	mov    %rdx,%rsi
  800212:	89 c7                	mov    %eax,%edi
  800214:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80021b:	00 00 00 
  80021e:	ff d0                	callq  *%rax
				close(f);
  800220:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800223:	89 c7                	mov    %eax,%edi
  800225:	48 b8 26 20 80 00 00 	movabs $0x802026,%rax
  80022c:	00 00 00 
  80022f:	ff d0                	callq  *%rax
		for (i = 1; i < argc; i++) {
  800231:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800235:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800238:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80023b:	0f 8c 46 ff ff ff    	jl     800187 <umain+0x58>
			}
		}
}
  800241:	c9                   	leaveq 
  800242:	c3                   	retq   

0000000000800243 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800243:	55                   	push   %rbp
  800244:	48 89 e5             	mov    %rsp,%rbp
  800247:	48 83 ec 10          	sub    $0x10,%rsp
  80024b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80024e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800252:	48 b8 40 90 80 00 00 	movabs $0x809040,%rax
  800259:	00 00 00 
  80025c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800263:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800267:	7e 14                	jle    80027d <libmain+0x3a>
		binaryname = argv[0];
  800269:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80026d:	48 8b 10             	mov    (%rax),%rdx
  800270:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800277:	00 00 00 
  80027a:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80027d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800281:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800284:	48 89 d6             	mov    %rdx,%rsi
  800287:	89 c7                	mov    %eax,%edi
  800289:	48 b8 2f 01 80 00 00 	movabs $0x80012f,%rax
  800290:	00 00 00 
  800293:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800295:	48 b8 a3 02 80 00 00 	movabs $0x8002a3,%rax
  80029c:	00 00 00 
  80029f:	ff d0                	callq  *%rax
}
  8002a1:	c9                   	leaveq 
  8002a2:	c3                   	retq   

00000000008002a3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002a3:	55                   	push   %rbp
  8002a4:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8002a7:	48 b8 71 20 80 00 00 	movabs $0x802071,%rax
  8002ae:	00 00 00 
  8002b1:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8002b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b8:	48 b8 08 19 80 00 00 	movabs $0x801908,%rax
  8002bf:	00 00 00 
  8002c2:	ff d0                	callq  *%rax
}
  8002c4:	5d                   	pop    %rbp
  8002c5:	c3                   	retq   

00000000008002c6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002c6:	55                   	push   %rbp
  8002c7:	48 89 e5             	mov    %rsp,%rbp
  8002ca:	53                   	push   %rbx
  8002cb:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8002d2:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8002d9:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8002df:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8002e6:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8002ed:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002f4:	84 c0                	test   %al,%al
  8002f6:	74 23                	je     80031b <_panic+0x55>
  8002f8:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002ff:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800303:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800307:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80030b:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80030f:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800313:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800317:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80031b:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800322:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800329:	00 00 00 
  80032c:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800333:	00 00 00 
  800336:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80033a:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800341:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800348:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80034f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800356:	00 00 00 
  800359:	48 8b 18             	mov    (%rax),%rbx
  80035c:	48 b8 4e 19 80 00 00 	movabs $0x80194e,%rax
  800363:	00 00 00 
  800366:	ff d0                	callq  *%rax
  800368:	89 c6                	mov    %eax,%esi
  80036a:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800370:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  800377:	41 89 d0             	mov    %edx,%r8d
  80037a:	48 89 c1             	mov    %rax,%rcx
  80037d:	48 89 da             	mov    %rbx,%rdx
  800380:	48 bf 28 42 80 00 00 	movabs $0x804228,%rdi
  800387:	00 00 00 
  80038a:	b8 00 00 00 00       	mov    $0x0,%eax
  80038f:	49 b9 ff 04 80 00 00 	movabs $0x8004ff,%r9
  800396:	00 00 00 
  800399:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80039c:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8003a3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003aa:	48 89 d6             	mov    %rdx,%rsi
  8003ad:	48 89 c7             	mov    %rax,%rdi
  8003b0:	48 b8 53 04 80 00 00 	movabs $0x800453,%rax
  8003b7:	00 00 00 
  8003ba:	ff d0                	callq  *%rax
	cprintf("\n");
  8003bc:	48 bf 4b 42 80 00 00 	movabs $0x80424b,%rdi
  8003c3:	00 00 00 
  8003c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003cb:	48 ba ff 04 80 00 00 	movabs $0x8004ff,%rdx
  8003d2:	00 00 00 
  8003d5:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003d7:	cc                   	int3   
  8003d8:	eb fd                	jmp    8003d7 <_panic+0x111>

00000000008003da <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8003da:	55                   	push   %rbp
  8003db:	48 89 e5             	mov    %rsp,%rbp
  8003de:	48 83 ec 10          	sub    $0x10,%rsp
  8003e2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003e5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8003e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ed:	8b 00                	mov    (%rax),%eax
  8003ef:	8d 48 01             	lea    0x1(%rax),%ecx
  8003f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003f6:	89 0a                	mov    %ecx,(%rdx)
  8003f8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003fb:	89 d1                	mov    %edx,%ecx
  8003fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800401:	48 98                	cltq   
  800403:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800407:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80040b:	8b 00                	mov    (%rax),%eax
  80040d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800412:	75 2c                	jne    800440 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800414:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800418:	8b 00                	mov    (%rax),%eax
  80041a:	48 98                	cltq   
  80041c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800420:	48 83 c2 08          	add    $0x8,%rdx
  800424:	48 89 c6             	mov    %rax,%rsi
  800427:	48 89 d7             	mov    %rdx,%rdi
  80042a:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  800431:	00 00 00 
  800434:	ff d0                	callq  *%rax
        b->idx = 0;
  800436:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80043a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800440:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800444:	8b 40 04             	mov    0x4(%rax),%eax
  800447:	8d 50 01             	lea    0x1(%rax),%edx
  80044a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80044e:	89 50 04             	mov    %edx,0x4(%rax)
}
  800451:	c9                   	leaveq 
  800452:	c3                   	retq   

0000000000800453 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800453:	55                   	push   %rbp
  800454:	48 89 e5             	mov    %rsp,%rbp
  800457:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80045e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800465:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80046c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800473:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80047a:	48 8b 0a             	mov    (%rdx),%rcx
  80047d:	48 89 08             	mov    %rcx,(%rax)
  800480:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800484:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800488:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80048c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800490:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800497:	00 00 00 
    b.cnt = 0;
  80049a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004a1:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8004a4:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004ab:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004b2:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004b9:	48 89 c6             	mov    %rax,%rsi
  8004bc:	48 bf da 03 80 00 00 	movabs $0x8003da,%rdi
  8004c3:	00 00 00 
  8004c6:	48 b8 9e 08 80 00 00 	movabs $0x80089e,%rax
  8004cd:	00 00 00 
  8004d0:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8004d2:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8004d8:	48 98                	cltq   
  8004da:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8004e1:	48 83 c2 08          	add    $0x8,%rdx
  8004e5:	48 89 c6             	mov    %rax,%rsi
  8004e8:	48 89 d7             	mov    %rdx,%rdi
  8004eb:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  8004f2:	00 00 00 
  8004f5:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004f7:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004fd:	c9                   	leaveq 
  8004fe:	c3                   	retq   

00000000008004ff <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004ff:	55                   	push   %rbp
  800500:	48 89 e5             	mov    %rsp,%rbp
  800503:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80050a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800511:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800518:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80051f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800526:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80052d:	84 c0                	test   %al,%al
  80052f:	74 20                	je     800551 <cprintf+0x52>
  800531:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800535:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800539:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80053d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800541:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800545:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800549:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80054d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800551:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800558:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80055f:	00 00 00 
  800562:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800569:	00 00 00 
  80056c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800570:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800577:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80057e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800585:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80058c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800593:	48 8b 0a             	mov    (%rdx),%rcx
  800596:	48 89 08             	mov    %rcx,(%rax)
  800599:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80059d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005a1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005a5:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8005a9:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005b0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005b7:	48 89 d6             	mov    %rdx,%rsi
  8005ba:	48 89 c7             	mov    %rax,%rdi
  8005bd:	48 b8 53 04 80 00 00 	movabs $0x800453,%rax
  8005c4:	00 00 00 
  8005c7:	ff d0                	callq  *%rax
  8005c9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8005cf:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8005d5:	c9                   	leaveq 
  8005d6:	c3                   	retq   

00000000008005d7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005d7:	55                   	push   %rbp
  8005d8:	48 89 e5             	mov    %rsp,%rbp
  8005db:	48 83 ec 30          	sub    $0x30,%rsp
  8005df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8005e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8005e7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8005eb:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8005ee:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8005f2:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8005f9:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8005fd:	77 42                	ja     800641 <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ff:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800602:	8d 78 ff             	lea    -0x1(%rax),%edi
  800605:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800608:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060c:	ba 00 00 00 00       	mov    $0x0,%edx
  800611:	48 f7 f6             	div    %rsi
  800614:	49 89 c2             	mov    %rax,%r10
  800617:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80061a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80061d:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800621:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800625:	41 89 c9             	mov    %ecx,%r9d
  800628:	41 89 f8             	mov    %edi,%r8d
  80062b:	89 d1                	mov    %edx,%ecx
  80062d:	4c 89 d2             	mov    %r10,%rdx
  800630:	48 89 c7             	mov    %rax,%rdi
  800633:	48 b8 d7 05 80 00 00 	movabs $0x8005d7,%rax
  80063a:	00 00 00 
  80063d:	ff d0                	callq  *%rax
  80063f:	eb 1e                	jmp    80065f <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800641:	eb 12                	jmp    800655 <printnum+0x7e>
			putch(padc, putdat);
  800643:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800647:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80064a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80064e:	48 89 ce             	mov    %rcx,%rsi
  800651:	89 d7                	mov    %edx,%edi
  800653:	ff d0                	callq  *%rax
		while (--width > 0)
  800655:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800659:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80065d:	7f e4                	jg     800643 <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80065f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800662:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800666:	ba 00 00 00 00       	mov    $0x0,%edx
  80066b:	48 f7 f1             	div    %rcx
  80066e:	48 b8 70 44 80 00 00 	movabs $0x804470,%rax
  800675:	00 00 00 
  800678:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  80067c:	0f be d0             	movsbl %al,%edx
  80067f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800683:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800687:	48 89 ce             	mov    %rcx,%rsi
  80068a:	89 d7                	mov    %edx,%edi
  80068c:	ff d0                	callq  *%rax
}
  80068e:	c9                   	leaveq 
  80068f:	c3                   	retq   

0000000000800690 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800690:	55                   	push   %rbp
  800691:	48 89 e5             	mov    %rsp,%rbp
  800694:	48 83 ec 20          	sub    $0x20,%rsp
  800698:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80069c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80069f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006a3:	7e 4f                	jle    8006f4 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8006a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a9:	8b 00                	mov    (%rax),%eax
  8006ab:	83 f8 30             	cmp    $0x30,%eax
  8006ae:	73 24                	jae    8006d4 <getuint+0x44>
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
  8006d2:	eb 14                	jmp    8006e8 <getuint+0x58>
  8006d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d8:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006dc:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006e8:	48 8b 00             	mov    (%rax),%rax
  8006eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006ef:	e9 9d 00 00 00       	jmpq   800791 <getuint+0x101>
	else if (lflag)
  8006f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006f8:	74 4c                	je     800746 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  8006fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fe:	8b 00                	mov    (%rax),%eax
  800700:	83 f8 30             	cmp    $0x30,%eax
  800703:	73 24                	jae    800729 <getuint+0x99>
  800705:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800709:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80070d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800711:	8b 00                	mov    (%rax),%eax
  800713:	89 c0                	mov    %eax,%eax
  800715:	48 01 d0             	add    %rdx,%rax
  800718:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071c:	8b 12                	mov    (%rdx),%edx
  80071e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800721:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800725:	89 0a                	mov    %ecx,(%rdx)
  800727:	eb 14                	jmp    80073d <getuint+0xad>
  800729:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800731:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800735:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800739:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80073d:	48 8b 00             	mov    (%rax),%rax
  800740:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800744:	eb 4b                	jmp    800791 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074a:	8b 00                	mov    (%rax),%eax
  80074c:	83 f8 30             	cmp    $0x30,%eax
  80074f:	73 24                	jae    800775 <getuint+0xe5>
  800751:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800755:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800759:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075d:	8b 00                	mov    (%rax),%eax
  80075f:	89 c0                	mov    %eax,%eax
  800761:	48 01 d0             	add    %rdx,%rax
  800764:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800768:	8b 12                	mov    (%rdx),%edx
  80076a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80076d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800771:	89 0a                	mov    %ecx,(%rdx)
  800773:	eb 14                	jmp    800789 <getuint+0xf9>
  800775:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800779:	48 8b 40 08          	mov    0x8(%rax),%rax
  80077d:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800781:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800785:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800789:	8b 00                	mov    (%rax),%eax
  80078b:	89 c0                	mov    %eax,%eax
  80078d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800791:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800795:	c9                   	leaveq 
  800796:	c3                   	retq   

0000000000800797 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800797:	55                   	push   %rbp
  800798:	48 89 e5             	mov    %rsp,%rbp
  80079b:	48 83 ec 20          	sub    $0x20,%rsp
  80079f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007a3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007a6:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007aa:	7e 4f                	jle    8007fb <getint+0x64>
		x=va_arg(*ap, long long);
  8007ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b0:	8b 00                	mov    (%rax),%eax
  8007b2:	83 f8 30             	cmp    $0x30,%eax
  8007b5:	73 24                	jae    8007db <getint+0x44>
  8007b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c3:	8b 00                	mov    (%rax),%eax
  8007c5:	89 c0                	mov    %eax,%eax
  8007c7:	48 01 d0             	add    %rdx,%rax
  8007ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ce:	8b 12                	mov    (%rdx),%edx
  8007d0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d7:	89 0a                	mov    %ecx,(%rdx)
  8007d9:	eb 14                	jmp    8007ef <getint+0x58>
  8007db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007df:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007e3:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007eb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007ef:	48 8b 00             	mov    (%rax),%rax
  8007f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007f6:	e9 9d 00 00 00       	jmpq   800898 <getint+0x101>
	else if (lflag)
  8007fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007ff:	74 4c                	je     80084d <getint+0xb6>
		x=va_arg(*ap, long);
  800801:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800805:	8b 00                	mov    (%rax),%eax
  800807:	83 f8 30             	cmp    $0x30,%eax
  80080a:	73 24                	jae    800830 <getint+0x99>
  80080c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800810:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800814:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800818:	8b 00                	mov    (%rax),%eax
  80081a:	89 c0                	mov    %eax,%eax
  80081c:	48 01 d0             	add    %rdx,%rax
  80081f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800823:	8b 12                	mov    (%rdx),%edx
  800825:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800828:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082c:	89 0a                	mov    %ecx,(%rdx)
  80082e:	eb 14                	jmp    800844 <getint+0xad>
  800830:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800834:	48 8b 40 08          	mov    0x8(%rax),%rax
  800838:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80083c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800840:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800844:	48 8b 00             	mov    (%rax),%rax
  800847:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80084b:	eb 4b                	jmp    800898 <getint+0x101>
	else
		x=va_arg(*ap, int);
  80084d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800851:	8b 00                	mov    (%rax),%eax
  800853:	83 f8 30             	cmp    $0x30,%eax
  800856:	73 24                	jae    80087c <getint+0xe5>
  800858:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800860:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800864:	8b 00                	mov    (%rax),%eax
  800866:	89 c0                	mov    %eax,%eax
  800868:	48 01 d0             	add    %rdx,%rax
  80086b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80086f:	8b 12                	mov    (%rdx),%edx
  800871:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800874:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800878:	89 0a                	mov    %ecx,(%rdx)
  80087a:	eb 14                	jmp    800890 <getint+0xf9>
  80087c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800880:	48 8b 40 08          	mov    0x8(%rax),%rax
  800884:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800888:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800890:	8b 00                	mov    (%rax),%eax
  800892:	48 98                	cltq   
  800894:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800898:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80089c:	c9                   	leaveq 
  80089d:	c3                   	retq   

000000000080089e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80089e:	55                   	push   %rbp
  80089f:	48 89 e5             	mov    %rsp,%rbp
  8008a2:	41 54                	push   %r12
  8008a4:	53                   	push   %rbx
  8008a5:	48 83 ec 60          	sub    $0x60,%rsp
  8008a9:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008ad:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008b1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008b5:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008b9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8008bd:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8008c1:	48 8b 0a             	mov    (%rdx),%rcx
  8008c4:	48 89 08             	mov    %rcx,(%rax)
  8008c7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008cb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008cf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008d3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008d7:	eb 17                	jmp    8008f0 <vprintfmt+0x52>
			if (ch == '\0')
  8008d9:	85 db                	test   %ebx,%ebx
  8008db:	0f 84 c5 04 00 00    	je     800da6 <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  8008e1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008e5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008e9:	48 89 d6             	mov    %rdx,%rsi
  8008ec:	89 df                	mov    %ebx,%edi
  8008ee:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008f0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008f4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008f8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008fc:	0f b6 00             	movzbl (%rax),%eax
  8008ff:	0f b6 d8             	movzbl %al,%ebx
  800902:	83 fb 25             	cmp    $0x25,%ebx
  800905:	75 d2                	jne    8008d9 <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  800907:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80090b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800912:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800919:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800920:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800927:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80092b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80092f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800933:	0f b6 00             	movzbl (%rax),%eax
  800936:	0f b6 d8             	movzbl %al,%ebx
  800939:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80093c:	83 f8 55             	cmp    $0x55,%eax
  80093f:	0f 87 2e 04 00 00    	ja     800d73 <vprintfmt+0x4d5>
  800945:	89 c0                	mov    %eax,%eax
  800947:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80094e:	00 
  80094f:	48 b8 98 44 80 00 00 	movabs $0x804498,%rax
  800956:	00 00 00 
  800959:	48 01 d0             	add    %rdx,%rax
  80095c:	48 8b 00             	mov    (%rax),%rax
  80095f:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800961:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800965:	eb c0                	jmp    800927 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800967:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80096b:	eb ba                	jmp    800927 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80096d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800974:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800977:	89 d0                	mov    %edx,%eax
  800979:	c1 e0 02             	shl    $0x2,%eax
  80097c:	01 d0                	add    %edx,%eax
  80097e:	01 c0                	add    %eax,%eax
  800980:	01 d8                	add    %ebx,%eax
  800982:	83 e8 30             	sub    $0x30,%eax
  800985:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800988:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80098c:	0f b6 00             	movzbl (%rax),%eax
  80098f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800992:	83 fb 2f             	cmp    $0x2f,%ebx
  800995:	7e 0c                	jle    8009a3 <vprintfmt+0x105>
  800997:	83 fb 39             	cmp    $0x39,%ebx
  80099a:	7f 07                	jg     8009a3 <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  80099c:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  8009a1:	eb d1                	jmp    800974 <vprintfmt+0xd6>
			goto process_precision;
  8009a3:	eb 50                	jmp    8009f5 <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  8009a5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a8:	83 f8 30             	cmp    $0x30,%eax
  8009ab:	73 17                	jae    8009c4 <vprintfmt+0x126>
  8009ad:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8009b1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009b4:	89 d2                	mov    %edx,%edx
  8009b6:	48 01 d0             	add    %rdx,%rax
  8009b9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009bc:	83 c2 08             	add    $0x8,%edx
  8009bf:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009c2:	eb 0c                	jmp    8009d0 <vprintfmt+0x132>
  8009c4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8009c8:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8009cc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009d0:	8b 00                	mov    (%rax),%eax
  8009d2:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009d5:	eb 1e                	jmp    8009f5 <vprintfmt+0x157>

		case '.':
			if (width < 0)
  8009d7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009db:	79 07                	jns    8009e4 <vprintfmt+0x146>
				width = 0;
  8009dd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009e4:	e9 3e ff ff ff       	jmpq   800927 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009e9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009f0:	e9 32 ff ff ff       	jmpq   800927 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009f5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009f9:	79 0d                	jns    800a08 <vprintfmt+0x16a>
				width = precision, precision = -1;
  8009fb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009fe:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a01:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a08:	e9 1a ff ff ff       	jmpq   800927 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a0d:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a11:	e9 11 ff ff ff       	jmpq   800927 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a16:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a19:	83 f8 30             	cmp    $0x30,%eax
  800a1c:	73 17                	jae    800a35 <vprintfmt+0x197>
  800a1e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a22:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a25:	89 d2                	mov    %edx,%edx
  800a27:	48 01 d0             	add    %rdx,%rax
  800a2a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a2d:	83 c2 08             	add    $0x8,%edx
  800a30:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a33:	eb 0c                	jmp    800a41 <vprintfmt+0x1a3>
  800a35:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a39:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a3d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a41:	8b 10                	mov    (%rax),%edx
  800a43:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a47:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a4b:	48 89 ce             	mov    %rcx,%rsi
  800a4e:	89 d7                	mov    %edx,%edi
  800a50:	ff d0                	callq  *%rax
			break;
  800a52:	e9 4a 03 00 00       	jmpq   800da1 <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a57:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a5a:	83 f8 30             	cmp    $0x30,%eax
  800a5d:	73 17                	jae    800a76 <vprintfmt+0x1d8>
  800a5f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a63:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a66:	89 d2                	mov    %edx,%edx
  800a68:	48 01 d0             	add    %rdx,%rax
  800a6b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a6e:	83 c2 08             	add    $0x8,%edx
  800a71:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a74:	eb 0c                	jmp    800a82 <vprintfmt+0x1e4>
  800a76:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a7a:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a7e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a82:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a84:	85 db                	test   %ebx,%ebx
  800a86:	79 02                	jns    800a8a <vprintfmt+0x1ec>
				err = -err;
  800a88:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a8a:	83 fb 15             	cmp    $0x15,%ebx
  800a8d:	7f 16                	jg     800aa5 <vprintfmt+0x207>
  800a8f:	48 b8 c0 43 80 00 00 	movabs $0x8043c0,%rax
  800a96:	00 00 00 
  800a99:	48 63 d3             	movslq %ebx,%rdx
  800a9c:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800aa0:	4d 85 e4             	test   %r12,%r12
  800aa3:	75 2e                	jne    800ad3 <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  800aa5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aa9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aad:	89 d9                	mov    %ebx,%ecx
  800aaf:	48 ba 81 44 80 00 00 	movabs $0x804481,%rdx
  800ab6:	00 00 00 
  800ab9:	48 89 c7             	mov    %rax,%rdi
  800abc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac1:	49 b8 af 0d 80 00 00 	movabs $0x800daf,%r8
  800ac8:	00 00 00 
  800acb:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ace:	e9 ce 02 00 00       	jmpq   800da1 <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  800ad3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ad7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800adb:	4c 89 e1             	mov    %r12,%rcx
  800ade:	48 ba 8a 44 80 00 00 	movabs $0x80448a,%rdx
  800ae5:	00 00 00 
  800ae8:	48 89 c7             	mov    %rax,%rdi
  800aeb:	b8 00 00 00 00       	mov    $0x0,%eax
  800af0:	49 b8 af 0d 80 00 00 	movabs $0x800daf,%r8
  800af7:	00 00 00 
  800afa:	41 ff d0             	callq  *%r8
			break;
  800afd:	e9 9f 02 00 00       	jmpq   800da1 <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b02:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b05:	83 f8 30             	cmp    $0x30,%eax
  800b08:	73 17                	jae    800b21 <vprintfmt+0x283>
  800b0a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b0e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b11:	89 d2                	mov    %edx,%edx
  800b13:	48 01 d0             	add    %rdx,%rax
  800b16:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b19:	83 c2 08             	add    $0x8,%edx
  800b1c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b1f:	eb 0c                	jmp    800b2d <vprintfmt+0x28f>
  800b21:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b25:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b29:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b2d:	4c 8b 20             	mov    (%rax),%r12
  800b30:	4d 85 e4             	test   %r12,%r12
  800b33:	75 0a                	jne    800b3f <vprintfmt+0x2a1>
				p = "(null)";
  800b35:	49 bc 8d 44 80 00 00 	movabs $0x80448d,%r12
  800b3c:	00 00 00 
			if (width > 0 && padc != '-')
  800b3f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b43:	7e 3f                	jle    800b84 <vprintfmt+0x2e6>
  800b45:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b49:	74 39                	je     800b84 <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b4b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b4e:	48 98                	cltq   
  800b50:	48 89 c6             	mov    %rax,%rsi
  800b53:	4c 89 e7             	mov    %r12,%rdi
  800b56:	48 b8 5b 10 80 00 00 	movabs $0x80105b,%rax
  800b5d:	00 00 00 
  800b60:	ff d0                	callq  *%rax
  800b62:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b65:	eb 17                	jmp    800b7e <vprintfmt+0x2e0>
					putch(padc, putdat);
  800b67:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b6b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b6f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b73:	48 89 ce             	mov    %rcx,%rsi
  800b76:	89 d7                	mov    %edx,%edi
  800b78:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  800b7a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b7e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b82:	7f e3                	jg     800b67 <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b84:	eb 37                	jmp    800bbd <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  800b86:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b8a:	74 1e                	je     800baa <vprintfmt+0x30c>
  800b8c:	83 fb 1f             	cmp    $0x1f,%ebx
  800b8f:	7e 05                	jle    800b96 <vprintfmt+0x2f8>
  800b91:	83 fb 7e             	cmp    $0x7e,%ebx
  800b94:	7e 14                	jle    800baa <vprintfmt+0x30c>
					putch('?', putdat);
  800b96:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b9a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9e:	48 89 d6             	mov    %rdx,%rsi
  800ba1:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ba6:	ff d0                	callq  *%rax
  800ba8:	eb 0f                	jmp    800bb9 <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  800baa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb2:	48 89 d6             	mov    %rdx,%rsi
  800bb5:	89 df                	mov    %ebx,%edi
  800bb7:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bb9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bbd:	4c 89 e0             	mov    %r12,%rax
  800bc0:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800bc4:	0f b6 00             	movzbl (%rax),%eax
  800bc7:	0f be d8             	movsbl %al,%ebx
  800bca:	85 db                	test   %ebx,%ebx
  800bcc:	74 10                	je     800bde <vprintfmt+0x340>
  800bce:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bd2:	78 b2                	js     800b86 <vprintfmt+0x2e8>
  800bd4:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bd8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bdc:	79 a8                	jns    800b86 <vprintfmt+0x2e8>
			for (; width > 0; width--)
  800bde:	eb 16                	jmp    800bf6 <vprintfmt+0x358>
				putch(' ', putdat);
  800be0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800be4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be8:	48 89 d6             	mov    %rdx,%rsi
  800beb:	bf 20 00 00 00       	mov    $0x20,%edi
  800bf0:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  800bf2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bf6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bfa:	7f e4                	jg     800be0 <vprintfmt+0x342>
			break;
  800bfc:	e9 a0 01 00 00       	jmpq   800da1 <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c01:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c05:	be 03 00 00 00       	mov    $0x3,%esi
  800c0a:	48 89 c7             	mov    %rax,%rdi
  800c0d:	48 b8 97 07 80 00 00 	movabs $0x800797,%rax
  800c14:	00 00 00 
  800c17:	ff d0                	callq  *%rax
  800c19:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c21:	48 85 c0             	test   %rax,%rax
  800c24:	79 1d                	jns    800c43 <vprintfmt+0x3a5>
				putch('-', putdat);
  800c26:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c2a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c2e:	48 89 d6             	mov    %rdx,%rsi
  800c31:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c36:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c3c:	48 f7 d8             	neg    %rax
  800c3f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c43:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c4a:	e9 e5 00 00 00       	jmpq   800d34 <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c4f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c53:	be 03 00 00 00       	mov    $0x3,%esi
  800c58:	48 89 c7             	mov    %rax,%rdi
  800c5b:	48 b8 90 06 80 00 00 	movabs $0x800690,%rax
  800c62:	00 00 00 
  800c65:	ff d0                	callq  *%rax
  800c67:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c6b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c72:	e9 bd 00 00 00       	jmpq   800d34 <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c77:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c7b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c7f:	48 89 d6             	mov    %rdx,%rsi
  800c82:	bf 58 00 00 00       	mov    $0x58,%edi
  800c87:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c89:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c8d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c91:	48 89 d6             	mov    %rdx,%rsi
  800c94:	bf 58 00 00 00       	mov    $0x58,%edi
  800c99:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c9b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c9f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca3:	48 89 d6             	mov    %rdx,%rsi
  800ca6:	bf 58 00 00 00       	mov    $0x58,%edi
  800cab:	ff d0                	callq  *%rax
			break;
  800cad:	e9 ef 00 00 00       	jmpq   800da1 <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  800cb2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cb6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cba:	48 89 d6             	mov    %rdx,%rsi
  800cbd:	bf 30 00 00 00       	mov    $0x30,%edi
  800cc2:	ff d0                	callq  *%rax
			putch('x', putdat);
  800cc4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cc8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ccc:	48 89 d6             	mov    %rdx,%rsi
  800ccf:	bf 78 00 00 00       	mov    $0x78,%edi
  800cd4:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cd6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd9:	83 f8 30             	cmp    $0x30,%eax
  800cdc:	73 17                	jae    800cf5 <vprintfmt+0x457>
  800cde:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ce2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ce5:	89 d2                	mov    %edx,%edx
  800ce7:	48 01 d0             	add    %rdx,%rax
  800cea:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ced:	83 c2 08             	add    $0x8,%edx
  800cf0:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  800cf3:	eb 0c                	jmp    800d01 <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  800cf5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800cf9:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800cfd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d01:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  800d04:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d08:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d0f:	eb 23                	jmp    800d34 <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d11:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d15:	be 03 00 00 00       	mov    $0x3,%esi
  800d1a:	48 89 c7             	mov    %rax,%rdi
  800d1d:	48 b8 90 06 80 00 00 	movabs $0x800690,%rax
  800d24:	00 00 00 
  800d27:	ff d0                	callq  *%rax
  800d29:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d2d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d34:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d39:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d3c:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d3f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d43:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d47:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d4b:	45 89 c1             	mov    %r8d,%r9d
  800d4e:	41 89 f8             	mov    %edi,%r8d
  800d51:	48 89 c7             	mov    %rax,%rdi
  800d54:	48 b8 d7 05 80 00 00 	movabs $0x8005d7,%rax
  800d5b:	00 00 00 
  800d5e:	ff d0                	callq  *%rax
			break;
  800d60:	eb 3f                	jmp    800da1 <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d62:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d66:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d6a:	48 89 d6             	mov    %rdx,%rsi
  800d6d:	89 df                	mov    %ebx,%edi
  800d6f:	ff d0                	callq  *%rax
			break;
  800d71:	eb 2e                	jmp    800da1 <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d73:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d77:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d7b:	48 89 d6             	mov    %rdx,%rsi
  800d7e:	bf 25 00 00 00       	mov    $0x25,%edi
  800d83:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d85:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d8a:	eb 05                	jmp    800d91 <vprintfmt+0x4f3>
  800d8c:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d91:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d95:	48 83 e8 01          	sub    $0x1,%rax
  800d99:	0f b6 00             	movzbl (%rax),%eax
  800d9c:	3c 25                	cmp    $0x25,%al
  800d9e:	75 ec                	jne    800d8c <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  800da0:	90                   	nop
		}
	}
  800da1:	e9 31 fb ff ff       	jmpq   8008d7 <vprintfmt+0x39>
	va_end(aq);
}
  800da6:	48 83 c4 60          	add    $0x60,%rsp
  800daa:	5b                   	pop    %rbx
  800dab:	41 5c                	pop    %r12
  800dad:	5d                   	pop    %rbp
  800dae:	c3                   	retq   

0000000000800daf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800daf:	55                   	push   %rbp
  800db0:	48 89 e5             	mov    %rsp,%rbp
  800db3:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800dba:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800dc1:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800dc8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dcf:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dd6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ddd:	84 c0                	test   %al,%al
  800ddf:	74 20                	je     800e01 <printfmt+0x52>
  800de1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800de5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800de9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ded:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800df1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800df5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800df9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dfd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e01:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e08:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e0f:	00 00 00 
  800e12:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e19:	00 00 00 
  800e1c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e20:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e27:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e2e:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e35:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e3c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e43:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e4a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e51:	48 89 c7             	mov    %rax,%rdi
  800e54:	48 b8 9e 08 80 00 00 	movabs $0x80089e,%rax
  800e5b:	00 00 00 
  800e5e:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e60:	c9                   	leaveq 
  800e61:	c3                   	retq   

0000000000800e62 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e62:	55                   	push   %rbp
  800e63:	48 89 e5             	mov    %rsp,%rbp
  800e66:	48 83 ec 10          	sub    $0x10,%rsp
  800e6a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e6d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e75:	8b 40 10             	mov    0x10(%rax),%eax
  800e78:	8d 50 01             	lea    0x1(%rax),%edx
  800e7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e7f:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e86:	48 8b 10             	mov    (%rax),%rdx
  800e89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e8d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e91:	48 39 c2             	cmp    %rax,%rdx
  800e94:	73 17                	jae    800ead <sprintputch+0x4b>
		*b->buf++ = ch;
  800e96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e9a:	48 8b 00             	mov    (%rax),%rax
  800e9d:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800ea1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ea5:	48 89 0a             	mov    %rcx,(%rdx)
  800ea8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800eab:	88 10                	mov    %dl,(%rax)
}
  800ead:	c9                   	leaveq 
  800eae:	c3                   	retq   

0000000000800eaf <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800eaf:	55                   	push   %rbp
  800eb0:	48 89 e5             	mov    %rsp,%rbp
  800eb3:	48 83 ec 50          	sub    $0x50,%rsp
  800eb7:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ebb:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ebe:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ec2:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ec6:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800eca:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ece:	48 8b 0a             	mov    (%rdx),%rcx
  800ed1:	48 89 08             	mov    %rcx,(%rax)
  800ed4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ed8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800edc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ee0:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ee4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ee8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800eec:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800eef:	48 98                	cltq   
  800ef1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ef5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ef9:	48 01 d0             	add    %rdx,%rax
  800efc:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f00:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f07:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f0c:	74 06                	je     800f14 <vsnprintf+0x65>
  800f0e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f12:	7f 07                	jg     800f1b <vsnprintf+0x6c>
		return -E_INVAL;
  800f14:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f19:	eb 2f                	jmp    800f4a <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f1b:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f1f:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f23:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f27:	48 89 c6             	mov    %rax,%rsi
  800f2a:	48 bf 62 0e 80 00 00 	movabs $0x800e62,%rdi
  800f31:	00 00 00 
  800f34:	48 b8 9e 08 80 00 00 	movabs $0x80089e,%rax
  800f3b:	00 00 00 
  800f3e:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f40:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f44:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f47:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f4a:	c9                   	leaveq 
  800f4b:	c3                   	retq   

0000000000800f4c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f4c:	55                   	push   %rbp
  800f4d:	48 89 e5             	mov    %rsp,%rbp
  800f50:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f57:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f5e:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f64:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f6b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f72:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f79:	84 c0                	test   %al,%al
  800f7b:	74 20                	je     800f9d <snprintf+0x51>
  800f7d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f81:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f85:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f89:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f8d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f91:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f95:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f99:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f9d:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800fa4:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800fab:	00 00 00 
  800fae:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fb5:	00 00 00 
  800fb8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fbc:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fc3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fca:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fd1:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fd8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fdf:	48 8b 0a             	mov    (%rdx),%rcx
  800fe2:	48 89 08             	mov    %rcx,(%rax)
  800fe5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fe9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fed:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ff1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800ff5:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800ffc:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801003:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801009:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801010:	48 89 c7             	mov    %rax,%rdi
  801013:	48 b8 af 0e 80 00 00 	movabs $0x800eaf,%rax
  80101a:	00 00 00 
  80101d:	ff d0                	callq  *%rax
  80101f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801025:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80102b:	c9                   	leaveq 
  80102c:	c3                   	retq   

000000000080102d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80102d:	55                   	push   %rbp
  80102e:	48 89 e5             	mov    %rsp,%rbp
  801031:	48 83 ec 18          	sub    $0x18,%rsp
  801035:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801039:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801040:	eb 09                	jmp    80104b <strlen+0x1e>
		n++;
  801042:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  801046:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80104b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80104f:	0f b6 00             	movzbl (%rax),%eax
  801052:	84 c0                	test   %al,%al
  801054:	75 ec                	jne    801042 <strlen+0x15>
	return n;
  801056:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801059:	c9                   	leaveq 
  80105a:	c3                   	retq   

000000000080105b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80105b:	55                   	push   %rbp
  80105c:	48 89 e5             	mov    %rsp,%rbp
  80105f:	48 83 ec 20          	sub    $0x20,%rsp
  801063:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801067:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80106b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801072:	eb 0e                	jmp    801082 <strnlen+0x27>
		n++;
  801074:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801078:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80107d:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801082:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801087:	74 0b                	je     801094 <strnlen+0x39>
  801089:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108d:	0f b6 00             	movzbl (%rax),%eax
  801090:	84 c0                	test   %al,%al
  801092:	75 e0                	jne    801074 <strnlen+0x19>
	return n;
  801094:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801097:	c9                   	leaveq 
  801098:	c3                   	retq   

0000000000801099 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801099:	55                   	push   %rbp
  80109a:	48 89 e5             	mov    %rsp,%rbp
  80109d:	48 83 ec 20          	sub    $0x20,%rsp
  8010a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010b1:	90                   	nop
  8010b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010ba:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010be:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010c2:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010c6:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010ca:	0f b6 12             	movzbl (%rdx),%edx
  8010cd:	88 10                	mov    %dl,(%rax)
  8010cf:	0f b6 00             	movzbl (%rax),%eax
  8010d2:	84 c0                	test   %al,%al
  8010d4:	75 dc                	jne    8010b2 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010da:	c9                   	leaveq 
  8010db:	c3                   	retq   

00000000008010dc <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010dc:	55                   	push   %rbp
  8010dd:	48 89 e5             	mov    %rsp,%rbp
  8010e0:	48 83 ec 20          	sub    $0x20,%rsp
  8010e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f0:	48 89 c7             	mov    %rax,%rdi
  8010f3:	48 b8 2d 10 80 00 00 	movabs $0x80102d,%rax
  8010fa:	00 00 00 
  8010fd:	ff d0                	callq  *%rax
  8010ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801102:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801105:	48 63 d0             	movslq %eax,%rdx
  801108:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110c:	48 01 c2             	add    %rax,%rdx
  80110f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801113:	48 89 c6             	mov    %rax,%rsi
  801116:	48 89 d7             	mov    %rdx,%rdi
  801119:	48 b8 99 10 80 00 00 	movabs $0x801099,%rax
  801120:	00 00 00 
  801123:	ff d0                	callq  *%rax
	return dst;
  801125:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801129:	c9                   	leaveq 
  80112a:	c3                   	retq   

000000000080112b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80112b:	55                   	push   %rbp
  80112c:	48 89 e5             	mov    %rsp,%rbp
  80112f:	48 83 ec 28          	sub    $0x28,%rsp
  801133:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801137:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80113b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80113f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801143:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801147:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80114e:	00 
  80114f:	eb 2a                	jmp    80117b <strncpy+0x50>
		*dst++ = *src;
  801151:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801155:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801159:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80115d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801161:	0f b6 12             	movzbl (%rdx),%edx
  801164:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801166:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80116a:	0f b6 00             	movzbl (%rax),%eax
  80116d:	84 c0                	test   %al,%al
  80116f:	74 05                	je     801176 <strncpy+0x4b>
			src++;
  801171:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  801176:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80117b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80117f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801183:	72 cc                	jb     801151 <strncpy+0x26>
	}
	return ret;
  801185:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801189:	c9                   	leaveq 
  80118a:	c3                   	retq   

000000000080118b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80118b:	55                   	push   %rbp
  80118c:	48 89 e5             	mov    %rsp,%rbp
  80118f:	48 83 ec 28          	sub    $0x28,%rsp
  801193:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801197:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80119b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80119f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011a7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011ac:	74 3d                	je     8011eb <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011ae:	eb 1d                	jmp    8011cd <strlcpy+0x42>
			*dst++ = *src++;
  8011b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011b8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011bc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011c0:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011c4:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011c8:	0f b6 12             	movzbl (%rdx),%edx
  8011cb:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  8011cd:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011d2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011d7:	74 0b                	je     8011e4 <strlcpy+0x59>
  8011d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011dd:	0f b6 00             	movzbl (%rax),%eax
  8011e0:	84 c0                	test   %al,%al
  8011e2:	75 cc                	jne    8011b0 <strlcpy+0x25>
		*dst = '\0';
  8011e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e8:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f3:	48 29 c2             	sub    %rax,%rdx
  8011f6:	48 89 d0             	mov    %rdx,%rax
}
  8011f9:	c9                   	leaveq 
  8011fa:	c3                   	retq   

00000000008011fb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011fb:	55                   	push   %rbp
  8011fc:	48 89 e5             	mov    %rsp,%rbp
  8011ff:	48 83 ec 10          	sub    $0x10,%rsp
  801203:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801207:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80120b:	eb 0a                	jmp    801217 <strcmp+0x1c>
		p++, q++;
  80120d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801212:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  801217:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121b:	0f b6 00             	movzbl (%rax),%eax
  80121e:	84 c0                	test   %al,%al
  801220:	74 12                	je     801234 <strcmp+0x39>
  801222:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801226:	0f b6 10             	movzbl (%rax),%edx
  801229:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80122d:	0f b6 00             	movzbl (%rax),%eax
  801230:	38 c2                	cmp    %al,%dl
  801232:	74 d9                	je     80120d <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801234:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801238:	0f b6 00             	movzbl (%rax),%eax
  80123b:	0f b6 d0             	movzbl %al,%edx
  80123e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801242:	0f b6 00             	movzbl (%rax),%eax
  801245:	0f b6 c0             	movzbl %al,%eax
  801248:	29 c2                	sub    %eax,%edx
  80124a:	89 d0                	mov    %edx,%eax
}
  80124c:	c9                   	leaveq 
  80124d:	c3                   	retq   

000000000080124e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80124e:	55                   	push   %rbp
  80124f:	48 89 e5             	mov    %rsp,%rbp
  801252:	48 83 ec 18          	sub    $0x18,%rsp
  801256:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80125a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80125e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801262:	eb 0f                	jmp    801273 <strncmp+0x25>
		n--, p++, q++;
  801264:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801269:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80126e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  801273:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801278:	74 1d                	je     801297 <strncmp+0x49>
  80127a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127e:	0f b6 00             	movzbl (%rax),%eax
  801281:	84 c0                	test   %al,%al
  801283:	74 12                	je     801297 <strncmp+0x49>
  801285:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801289:	0f b6 10             	movzbl (%rax),%edx
  80128c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801290:	0f b6 00             	movzbl (%rax),%eax
  801293:	38 c2                	cmp    %al,%dl
  801295:	74 cd                	je     801264 <strncmp+0x16>
	if (n == 0)
  801297:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80129c:	75 07                	jne    8012a5 <strncmp+0x57>
		return 0;
  80129e:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a3:	eb 18                	jmp    8012bd <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a9:	0f b6 00             	movzbl (%rax),%eax
  8012ac:	0f b6 d0             	movzbl %al,%edx
  8012af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b3:	0f b6 00             	movzbl (%rax),%eax
  8012b6:	0f b6 c0             	movzbl %al,%eax
  8012b9:	29 c2                	sub    %eax,%edx
  8012bb:	89 d0                	mov    %edx,%eax
}
  8012bd:	c9                   	leaveq 
  8012be:	c3                   	retq   

00000000008012bf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012bf:	55                   	push   %rbp
  8012c0:	48 89 e5             	mov    %rsp,%rbp
  8012c3:	48 83 ec 10          	sub    $0x10,%rsp
  8012c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012cb:	89 f0                	mov    %esi,%eax
  8012cd:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012d0:	eb 17                	jmp    8012e9 <strchr+0x2a>
		if (*s == c)
  8012d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d6:	0f b6 00             	movzbl (%rax),%eax
  8012d9:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012dc:	75 06                	jne    8012e4 <strchr+0x25>
			return (char *) s;
  8012de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e2:	eb 15                	jmp    8012f9 <strchr+0x3a>
	for (; *s; s++)
  8012e4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ed:	0f b6 00             	movzbl (%rax),%eax
  8012f0:	84 c0                	test   %al,%al
  8012f2:	75 de                	jne    8012d2 <strchr+0x13>
	return 0;
  8012f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f9:	c9                   	leaveq 
  8012fa:	c3                   	retq   

00000000008012fb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012fb:	55                   	push   %rbp
  8012fc:	48 89 e5             	mov    %rsp,%rbp
  8012ff:	48 83 ec 10          	sub    $0x10,%rsp
  801303:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801307:	89 f0                	mov    %esi,%eax
  801309:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80130c:	eb 13                	jmp    801321 <strfind+0x26>
		if (*s == c)
  80130e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801312:	0f b6 00             	movzbl (%rax),%eax
  801315:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801318:	75 02                	jne    80131c <strfind+0x21>
			break;
  80131a:	eb 10                	jmp    80132c <strfind+0x31>
	for (; *s; s++)
  80131c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801321:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801325:	0f b6 00             	movzbl (%rax),%eax
  801328:	84 c0                	test   %al,%al
  80132a:	75 e2                	jne    80130e <strfind+0x13>
	return (char *) s;
  80132c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801330:	c9                   	leaveq 
  801331:	c3                   	retq   

0000000000801332 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801332:	55                   	push   %rbp
  801333:	48 89 e5             	mov    %rsp,%rbp
  801336:	48 83 ec 18          	sub    $0x18,%rsp
  80133a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80133e:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801341:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801345:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80134a:	75 06                	jne    801352 <memset+0x20>
		return v;
  80134c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801350:	eb 69                	jmp    8013bb <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801352:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801356:	83 e0 03             	and    $0x3,%eax
  801359:	48 85 c0             	test   %rax,%rax
  80135c:	75 48                	jne    8013a6 <memset+0x74>
  80135e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801362:	83 e0 03             	and    $0x3,%eax
  801365:	48 85 c0             	test   %rax,%rax
  801368:	75 3c                	jne    8013a6 <memset+0x74>
		c &= 0xFF;
  80136a:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801371:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801374:	c1 e0 18             	shl    $0x18,%eax
  801377:	89 c2                	mov    %eax,%edx
  801379:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80137c:	c1 e0 10             	shl    $0x10,%eax
  80137f:	09 c2                	or     %eax,%edx
  801381:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801384:	c1 e0 08             	shl    $0x8,%eax
  801387:	09 d0                	or     %edx,%eax
  801389:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80138c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801390:	48 c1 e8 02          	shr    $0x2,%rax
  801394:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  801397:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80139b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80139e:	48 89 d7             	mov    %rdx,%rdi
  8013a1:	fc                   	cld    
  8013a2:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013a4:	eb 11                	jmp    8013b7 <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013a6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013aa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013ad:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013b1:	48 89 d7             	mov    %rdx,%rdi
  8013b4:	fc                   	cld    
  8013b5:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8013b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013bb:	c9                   	leaveq 
  8013bc:	c3                   	retq   

00000000008013bd <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013bd:	55                   	push   %rbp
  8013be:	48 89 e5             	mov    %rsp,%rbp
  8013c1:	48 83 ec 28          	sub    $0x28,%rsp
  8013c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013c9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013cd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013dd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e5:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013e9:	0f 83 88 00 00 00    	jae    801477 <memmove+0xba>
  8013ef:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f7:	48 01 d0             	add    %rdx,%rax
  8013fa:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013fe:	76 77                	jbe    801477 <memmove+0xba>
		s += n;
  801400:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801404:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801408:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140c:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801410:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801414:	83 e0 03             	and    $0x3,%eax
  801417:	48 85 c0             	test   %rax,%rax
  80141a:	75 3b                	jne    801457 <memmove+0x9a>
  80141c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801420:	83 e0 03             	and    $0x3,%eax
  801423:	48 85 c0             	test   %rax,%rax
  801426:	75 2f                	jne    801457 <memmove+0x9a>
  801428:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142c:	83 e0 03             	and    $0x3,%eax
  80142f:	48 85 c0             	test   %rax,%rax
  801432:	75 23                	jne    801457 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801434:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801438:	48 83 e8 04          	sub    $0x4,%rax
  80143c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801440:	48 83 ea 04          	sub    $0x4,%rdx
  801444:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801448:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  80144c:	48 89 c7             	mov    %rax,%rdi
  80144f:	48 89 d6             	mov    %rdx,%rsi
  801452:	fd                   	std    
  801453:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801455:	eb 1d                	jmp    801474 <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801457:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80145b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80145f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801463:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  801467:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146b:	48 89 d7             	mov    %rdx,%rdi
  80146e:	48 89 c1             	mov    %rax,%rcx
  801471:	fd                   	std    
  801472:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801474:	fc                   	cld    
  801475:	eb 57                	jmp    8014ce <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801477:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147b:	83 e0 03             	and    $0x3,%eax
  80147e:	48 85 c0             	test   %rax,%rax
  801481:	75 36                	jne    8014b9 <memmove+0xfc>
  801483:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801487:	83 e0 03             	and    $0x3,%eax
  80148a:	48 85 c0             	test   %rax,%rax
  80148d:	75 2a                	jne    8014b9 <memmove+0xfc>
  80148f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801493:	83 e0 03             	and    $0x3,%eax
  801496:	48 85 c0             	test   %rax,%rax
  801499:	75 1e                	jne    8014b9 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80149b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149f:	48 c1 e8 02          	shr    $0x2,%rax
  8014a3:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  8014a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014aa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014ae:	48 89 c7             	mov    %rax,%rdi
  8014b1:	48 89 d6             	mov    %rdx,%rsi
  8014b4:	fc                   	cld    
  8014b5:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014b7:	eb 15                	jmp    8014ce <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  8014b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014bd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014c1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014c5:	48 89 c7             	mov    %rax,%rdi
  8014c8:	48 89 d6             	mov    %rdx,%rsi
  8014cb:	fc                   	cld    
  8014cc:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014d2:	c9                   	leaveq 
  8014d3:	c3                   	retq   

00000000008014d4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014d4:	55                   	push   %rbp
  8014d5:	48 89 e5             	mov    %rsp,%rbp
  8014d8:	48 83 ec 18          	sub    $0x18,%rsp
  8014dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014e4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014ec:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f4:	48 89 ce             	mov    %rcx,%rsi
  8014f7:	48 89 c7             	mov    %rax,%rdi
  8014fa:	48 b8 bd 13 80 00 00 	movabs $0x8013bd,%rax
  801501:	00 00 00 
  801504:	ff d0                	callq  *%rax
}
  801506:	c9                   	leaveq 
  801507:	c3                   	retq   

0000000000801508 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801508:	55                   	push   %rbp
  801509:	48 89 e5             	mov    %rsp,%rbp
  80150c:	48 83 ec 28          	sub    $0x28,%rsp
  801510:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801514:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801518:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80151c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801520:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801524:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801528:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80152c:	eb 36                	jmp    801564 <memcmp+0x5c>
		if (*s1 != *s2)
  80152e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801532:	0f b6 10             	movzbl (%rax),%edx
  801535:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801539:	0f b6 00             	movzbl (%rax),%eax
  80153c:	38 c2                	cmp    %al,%dl
  80153e:	74 1a                	je     80155a <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801540:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801544:	0f b6 00             	movzbl (%rax),%eax
  801547:	0f b6 d0             	movzbl %al,%edx
  80154a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80154e:	0f b6 00             	movzbl (%rax),%eax
  801551:	0f b6 c0             	movzbl %al,%eax
  801554:	29 c2                	sub    %eax,%edx
  801556:	89 d0                	mov    %edx,%eax
  801558:	eb 20                	jmp    80157a <memcmp+0x72>
		s1++, s2++;
  80155a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80155f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  801564:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801568:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80156c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801570:	48 85 c0             	test   %rax,%rax
  801573:	75 b9                	jne    80152e <memcmp+0x26>
	}

	return 0;
  801575:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80157a:	c9                   	leaveq 
  80157b:	c3                   	retq   

000000000080157c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80157c:	55                   	push   %rbp
  80157d:	48 89 e5             	mov    %rsp,%rbp
  801580:	48 83 ec 28          	sub    $0x28,%rsp
  801584:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801588:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80158b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80158f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801593:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801597:	48 01 d0             	add    %rdx,%rax
  80159a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80159e:	eb 15                	jmp    8015b5 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a4:	0f b6 00             	movzbl (%rax),%eax
  8015a7:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8015aa:	38 d0                	cmp    %dl,%al
  8015ac:	75 02                	jne    8015b0 <memfind+0x34>
			break;
  8015ae:	eb 0f                	jmp    8015bf <memfind+0x43>
	for (; s < ends; s++)
  8015b0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015b9:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015bd:	72 e1                	jb     8015a0 <memfind+0x24>
	return (void *) s;
  8015bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015c3:	c9                   	leaveq 
  8015c4:	c3                   	retq   

00000000008015c5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015c5:	55                   	push   %rbp
  8015c6:	48 89 e5             	mov    %rsp,%rbp
  8015c9:	48 83 ec 38          	sub    $0x38,%rsp
  8015cd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015d1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015d5:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015df:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015e6:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015e7:	eb 05                	jmp    8015ee <strtol+0x29>
		s++;
  8015e9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  8015ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f2:	0f b6 00             	movzbl (%rax),%eax
  8015f5:	3c 20                	cmp    $0x20,%al
  8015f7:	74 f0                	je     8015e9 <strtol+0x24>
  8015f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fd:	0f b6 00             	movzbl (%rax),%eax
  801600:	3c 09                	cmp    $0x9,%al
  801602:	74 e5                	je     8015e9 <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  801604:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801608:	0f b6 00             	movzbl (%rax),%eax
  80160b:	3c 2b                	cmp    $0x2b,%al
  80160d:	75 07                	jne    801616 <strtol+0x51>
		s++;
  80160f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801614:	eb 17                	jmp    80162d <strtol+0x68>
	else if (*s == '-')
  801616:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161a:	0f b6 00             	movzbl (%rax),%eax
  80161d:	3c 2d                	cmp    $0x2d,%al
  80161f:	75 0c                	jne    80162d <strtol+0x68>
		s++, neg = 1;
  801621:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801626:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80162d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801631:	74 06                	je     801639 <strtol+0x74>
  801633:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801637:	75 28                	jne    801661 <strtol+0x9c>
  801639:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163d:	0f b6 00             	movzbl (%rax),%eax
  801640:	3c 30                	cmp    $0x30,%al
  801642:	75 1d                	jne    801661 <strtol+0x9c>
  801644:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801648:	48 83 c0 01          	add    $0x1,%rax
  80164c:	0f b6 00             	movzbl (%rax),%eax
  80164f:	3c 78                	cmp    $0x78,%al
  801651:	75 0e                	jne    801661 <strtol+0x9c>
		s += 2, base = 16;
  801653:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801658:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80165f:	eb 2c                	jmp    80168d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801661:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801665:	75 19                	jne    801680 <strtol+0xbb>
  801667:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166b:	0f b6 00             	movzbl (%rax),%eax
  80166e:	3c 30                	cmp    $0x30,%al
  801670:	75 0e                	jne    801680 <strtol+0xbb>
		s++, base = 8;
  801672:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801677:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80167e:	eb 0d                	jmp    80168d <strtol+0xc8>
	else if (base == 0)
  801680:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801684:	75 07                	jne    80168d <strtol+0xc8>
		base = 10;
  801686:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80168d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801691:	0f b6 00             	movzbl (%rax),%eax
  801694:	3c 2f                	cmp    $0x2f,%al
  801696:	7e 1d                	jle    8016b5 <strtol+0xf0>
  801698:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169c:	0f b6 00             	movzbl (%rax),%eax
  80169f:	3c 39                	cmp    $0x39,%al
  8016a1:	7f 12                	jg     8016b5 <strtol+0xf0>
			dig = *s - '0';
  8016a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a7:	0f b6 00             	movzbl (%rax),%eax
  8016aa:	0f be c0             	movsbl %al,%eax
  8016ad:	83 e8 30             	sub    $0x30,%eax
  8016b0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016b3:	eb 4e                	jmp    801703 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b9:	0f b6 00             	movzbl (%rax),%eax
  8016bc:	3c 60                	cmp    $0x60,%al
  8016be:	7e 1d                	jle    8016dd <strtol+0x118>
  8016c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c4:	0f b6 00             	movzbl (%rax),%eax
  8016c7:	3c 7a                	cmp    $0x7a,%al
  8016c9:	7f 12                	jg     8016dd <strtol+0x118>
			dig = *s - 'a' + 10;
  8016cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cf:	0f b6 00             	movzbl (%rax),%eax
  8016d2:	0f be c0             	movsbl %al,%eax
  8016d5:	83 e8 57             	sub    $0x57,%eax
  8016d8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016db:	eb 26                	jmp    801703 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e1:	0f b6 00             	movzbl (%rax),%eax
  8016e4:	3c 40                	cmp    $0x40,%al
  8016e6:	7e 48                	jle    801730 <strtol+0x16b>
  8016e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ec:	0f b6 00             	movzbl (%rax),%eax
  8016ef:	3c 5a                	cmp    $0x5a,%al
  8016f1:	7f 3d                	jg     801730 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f7:	0f b6 00             	movzbl (%rax),%eax
  8016fa:	0f be c0             	movsbl %al,%eax
  8016fd:	83 e8 37             	sub    $0x37,%eax
  801700:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801703:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801706:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801709:	7c 02                	jl     80170d <strtol+0x148>
			break;
  80170b:	eb 23                	jmp    801730 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80170d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801712:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801715:	48 98                	cltq   
  801717:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80171c:	48 89 c2             	mov    %rax,%rdx
  80171f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801722:	48 98                	cltq   
  801724:	48 01 d0             	add    %rdx,%rax
  801727:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80172b:	e9 5d ff ff ff       	jmpq   80168d <strtol+0xc8>

	if (endptr)
  801730:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801735:	74 0b                	je     801742 <strtol+0x17d>
		*endptr = (char *) s;
  801737:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80173b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80173f:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801742:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801746:	74 09                	je     801751 <strtol+0x18c>
  801748:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80174c:	48 f7 d8             	neg    %rax
  80174f:	eb 04                	jmp    801755 <strtol+0x190>
  801751:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801755:	c9                   	leaveq 
  801756:	c3                   	retq   

0000000000801757 <strstr>:

char * strstr(const char *in, const char *str)
{
  801757:	55                   	push   %rbp
  801758:	48 89 e5             	mov    %rsp,%rbp
  80175b:	48 83 ec 30          	sub    $0x30,%rsp
  80175f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801763:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801767:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80176b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80176f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801773:	0f b6 00             	movzbl (%rax),%eax
  801776:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801779:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80177d:	75 06                	jne    801785 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80177f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801783:	eb 6b                	jmp    8017f0 <strstr+0x99>

	len = strlen(str);
  801785:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801789:	48 89 c7             	mov    %rax,%rdi
  80178c:	48 b8 2d 10 80 00 00 	movabs $0x80102d,%rax
  801793:	00 00 00 
  801796:	ff d0                	callq  *%rax
  801798:	48 98                	cltq   
  80179a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80179e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017a6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017aa:	0f b6 00             	movzbl (%rax),%eax
  8017ad:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8017b0:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017b4:	75 07                	jne    8017bd <strstr+0x66>
				return (char *) 0;
  8017b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017bb:	eb 33                	jmp    8017f0 <strstr+0x99>
		} while (sc != c);
  8017bd:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017c1:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017c4:	75 d8                	jne    80179e <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8017c6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017ca:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d2:	48 89 ce             	mov    %rcx,%rsi
  8017d5:	48 89 c7             	mov    %rax,%rdi
  8017d8:	48 b8 4e 12 80 00 00 	movabs $0x80124e,%rax
  8017df:	00 00 00 
  8017e2:	ff d0                	callq  *%rax
  8017e4:	85 c0                	test   %eax,%eax
  8017e6:	75 b6                	jne    80179e <strstr+0x47>

	return (char *) (in - 1);
  8017e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ec:	48 83 e8 01          	sub    $0x1,%rax
}
  8017f0:	c9                   	leaveq 
  8017f1:	c3                   	retq   

00000000008017f2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017f2:	55                   	push   %rbp
  8017f3:	48 89 e5             	mov    %rsp,%rbp
  8017f6:	53                   	push   %rbx
  8017f7:	48 83 ec 48          	sub    $0x48,%rsp
  8017fb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017fe:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801801:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801805:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801809:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80180d:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801811:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801814:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801818:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80181c:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801820:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801824:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801828:	4c 89 c3             	mov    %r8,%rbx
  80182b:	cd 30                	int    $0x30
  80182d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801831:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801835:	74 3e                	je     801875 <syscall+0x83>
  801837:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80183c:	7e 37                	jle    801875 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80183e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801842:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801845:	49 89 d0             	mov    %rdx,%r8
  801848:	89 c1                	mov    %eax,%ecx
  80184a:	48 ba 48 47 80 00 00 	movabs $0x804748,%rdx
  801851:	00 00 00 
  801854:	be 23 00 00 00       	mov    $0x23,%esi
  801859:	48 bf 65 47 80 00 00 	movabs $0x804765,%rdi
  801860:	00 00 00 
  801863:	b8 00 00 00 00       	mov    $0x0,%eax
  801868:	49 b9 c6 02 80 00 00 	movabs $0x8002c6,%r9
  80186f:	00 00 00 
  801872:	41 ff d1             	callq  *%r9

	return ret;
  801875:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801879:	48 83 c4 48          	add    $0x48,%rsp
  80187d:	5b                   	pop    %rbx
  80187e:	5d                   	pop    %rbp
  80187f:	c3                   	retq   

0000000000801880 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801880:	55                   	push   %rbp
  801881:	48 89 e5             	mov    %rsp,%rbp
  801884:	48 83 ec 10          	sub    $0x10,%rsp
  801888:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80188c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801890:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801894:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801898:	48 83 ec 08          	sub    $0x8,%rsp
  80189c:	6a 00                	pushq  $0x0
  80189e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018a4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018aa:	48 89 d1             	mov    %rdx,%rcx
  8018ad:	48 89 c2             	mov    %rax,%rdx
  8018b0:	be 00 00 00 00       	mov    $0x0,%esi
  8018b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8018ba:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  8018c1:	00 00 00 
  8018c4:	ff d0                	callq  *%rax
  8018c6:	48 83 c4 10          	add    $0x10,%rsp
}
  8018ca:	c9                   	leaveq 
  8018cb:	c3                   	retq   

00000000008018cc <sys_cgetc>:

int
sys_cgetc(void)
{
  8018cc:	55                   	push   %rbp
  8018cd:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8018d0:	48 83 ec 08          	sub    $0x8,%rsp
  8018d4:	6a 00                	pushq  $0x0
  8018d6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018dc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ec:	be 00 00 00 00       	mov    $0x0,%esi
  8018f1:	bf 01 00 00 00       	mov    $0x1,%edi
  8018f6:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  8018fd:	00 00 00 
  801900:	ff d0                	callq  *%rax
  801902:	48 83 c4 10          	add    $0x10,%rsp
}
  801906:	c9                   	leaveq 
  801907:	c3                   	retq   

0000000000801908 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801908:	55                   	push   %rbp
  801909:	48 89 e5             	mov    %rsp,%rbp
  80190c:	48 83 ec 10          	sub    $0x10,%rsp
  801910:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801913:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801916:	48 98                	cltq   
  801918:	48 83 ec 08          	sub    $0x8,%rsp
  80191c:	6a 00                	pushq  $0x0
  80191e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801924:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80192a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80192f:	48 89 c2             	mov    %rax,%rdx
  801932:	be 01 00 00 00       	mov    $0x1,%esi
  801937:	bf 03 00 00 00       	mov    $0x3,%edi
  80193c:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  801943:	00 00 00 
  801946:	ff d0                	callq  *%rax
  801948:	48 83 c4 10          	add    $0x10,%rsp
}
  80194c:	c9                   	leaveq 
  80194d:	c3                   	retq   

000000000080194e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80194e:	55                   	push   %rbp
  80194f:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801952:	48 83 ec 08          	sub    $0x8,%rsp
  801956:	6a 00                	pushq  $0x0
  801958:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80195e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801964:	b9 00 00 00 00       	mov    $0x0,%ecx
  801969:	ba 00 00 00 00       	mov    $0x0,%edx
  80196e:	be 00 00 00 00       	mov    $0x0,%esi
  801973:	bf 02 00 00 00       	mov    $0x2,%edi
  801978:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  80197f:	00 00 00 
  801982:	ff d0                	callq  *%rax
  801984:	48 83 c4 10          	add    $0x10,%rsp
}
  801988:	c9                   	leaveq 
  801989:	c3                   	retq   

000000000080198a <sys_yield>:

void
sys_yield(void)
{
  80198a:	55                   	push   %rbp
  80198b:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80198e:	48 83 ec 08          	sub    $0x8,%rsp
  801992:	6a 00                	pushq  $0x0
  801994:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80199a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019aa:	be 00 00 00 00       	mov    $0x0,%esi
  8019af:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019b4:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  8019bb:	00 00 00 
  8019be:	ff d0                	callq  *%rax
  8019c0:	48 83 c4 10          	add    $0x10,%rsp
}
  8019c4:	c9                   	leaveq 
  8019c5:	c3                   	retq   

00000000008019c6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8019c6:	55                   	push   %rbp
  8019c7:	48 89 e5             	mov    %rsp,%rbp
  8019ca:	48 83 ec 10          	sub    $0x10,%rsp
  8019ce:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019d1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019d5:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8019d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019db:	48 63 c8             	movslq %eax,%rcx
  8019de:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019e5:	48 98                	cltq   
  8019e7:	48 83 ec 08          	sub    $0x8,%rsp
  8019eb:	6a 00                	pushq  $0x0
  8019ed:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019f3:	49 89 c8             	mov    %rcx,%r8
  8019f6:	48 89 d1             	mov    %rdx,%rcx
  8019f9:	48 89 c2             	mov    %rax,%rdx
  8019fc:	be 01 00 00 00       	mov    $0x1,%esi
  801a01:	bf 04 00 00 00       	mov    $0x4,%edi
  801a06:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  801a0d:	00 00 00 
  801a10:	ff d0                	callq  *%rax
  801a12:	48 83 c4 10          	add    $0x10,%rsp
}
  801a16:	c9                   	leaveq 
  801a17:	c3                   	retq   

0000000000801a18 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a18:	55                   	push   %rbp
  801a19:	48 89 e5             	mov    %rsp,%rbp
  801a1c:	48 83 ec 20          	sub    $0x20,%rsp
  801a20:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a23:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a27:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a2a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a2e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a32:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a35:	48 63 c8             	movslq %eax,%rcx
  801a38:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a3c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a3f:	48 63 f0             	movslq %eax,%rsi
  801a42:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a49:	48 98                	cltq   
  801a4b:	48 83 ec 08          	sub    $0x8,%rsp
  801a4f:	51                   	push   %rcx
  801a50:	49 89 f9             	mov    %rdi,%r9
  801a53:	49 89 f0             	mov    %rsi,%r8
  801a56:	48 89 d1             	mov    %rdx,%rcx
  801a59:	48 89 c2             	mov    %rax,%rdx
  801a5c:	be 01 00 00 00       	mov    $0x1,%esi
  801a61:	bf 05 00 00 00       	mov    $0x5,%edi
  801a66:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  801a6d:	00 00 00 
  801a70:	ff d0                	callq  *%rax
  801a72:	48 83 c4 10          	add    $0x10,%rsp
}
  801a76:	c9                   	leaveq 
  801a77:	c3                   	retq   

0000000000801a78 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a78:	55                   	push   %rbp
  801a79:	48 89 e5             	mov    %rsp,%rbp
  801a7c:	48 83 ec 10          	sub    $0x10,%rsp
  801a80:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a83:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a87:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a8e:	48 98                	cltq   
  801a90:	48 83 ec 08          	sub    $0x8,%rsp
  801a94:	6a 00                	pushq  $0x0
  801a96:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a9c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aa2:	48 89 d1             	mov    %rdx,%rcx
  801aa5:	48 89 c2             	mov    %rax,%rdx
  801aa8:	be 01 00 00 00       	mov    $0x1,%esi
  801aad:	bf 06 00 00 00       	mov    $0x6,%edi
  801ab2:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  801ab9:	00 00 00 
  801abc:	ff d0                	callq  *%rax
  801abe:	48 83 c4 10          	add    $0x10,%rsp
}
  801ac2:	c9                   	leaveq 
  801ac3:	c3                   	retq   

0000000000801ac4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801ac4:	55                   	push   %rbp
  801ac5:	48 89 e5             	mov    %rsp,%rbp
  801ac8:	48 83 ec 10          	sub    $0x10,%rsp
  801acc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801acf:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801ad2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ad5:	48 63 d0             	movslq %eax,%rdx
  801ad8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801adb:	48 98                	cltq   
  801add:	48 83 ec 08          	sub    $0x8,%rsp
  801ae1:	6a 00                	pushq  $0x0
  801ae3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aef:	48 89 d1             	mov    %rdx,%rcx
  801af2:	48 89 c2             	mov    %rax,%rdx
  801af5:	be 01 00 00 00       	mov    $0x1,%esi
  801afa:	bf 08 00 00 00       	mov    $0x8,%edi
  801aff:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  801b06:	00 00 00 
  801b09:	ff d0                	callq  *%rax
  801b0b:	48 83 c4 10          	add    $0x10,%rsp
}
  801b0f:	c9                   	leaveq 
  801b10:	c3                   	retq   

0000000000801b11 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b11:	55                   	push   %rbp
  801b12:	48 89 e5             	mov    %rsp,%rbp
  801b15:	48 83 ec 10          	sub    $0x10,%rsp
  801b19:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b1c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b20:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b27:	48 98                	cltq   
  801b29:	48 83 ec 08          	sub    $0x8,%rsp
  801b2d:	6a 00                	pushq  $0x0
  801b2f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b35:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b3b:	48 89 d1             	mov    %rdx,%rcx
  801b3e:	48 89 c2             	mov    %rax,%rdx
  801b41:	be 01 00 00 00       	mov    $0x1,%esi
  801b46:	bf 09 00 00 00       	mov    $0x9,%edi
  801b4b:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  801b52:	00 00 00 
  801b55:	ff d0                	callq  *%rax
  801b57:	48 83 c4 10          	add    $0x10,%rsp
}
  801b5b:	c9                   	leaveq 
  801b5c:	c3                   	retq   

0000000000801b5d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b5d:	55                   	push   %rbp
  801b5e:	48 89 e5             	mov    %rsp,%rbp
  801b61:	48 83 ec 10          	sub    $0x10,%rsp
  801b65:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b68:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b6c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b73:	48 98                	cltq   
  801b75:	48 83 ec 08          	sub    $0x8,%rsp
  801b79:	6a 00                	pushq  $0x0
  801b7b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b81:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b87:	48 89 d1             	mov    %rdx,%rcx
  801b8a:	48 89 c2             	mov    %rax,%rdx
  801b8d:	be 01 00 00 00       	mov    $0x1,%esi
  801b92:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b97:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  801b9e:	00 00 00 
  801ba1:	ff d0                	callq  *%rax
  801ba3:	48 83 c4 10          	add    $0x10,%rsp
}
  801ba7:	c9                   	leaveq 
  801ba8:	c3                   	retq   

0000000000801ba9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ba9:	55                   	push   %rbp
  801baa:	48 89 e5             	mov    %rsp,%rbp
  801bad:	48 83 ec 20          	sub    $0x20,%rsp
  801bb1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bb4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bb8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bbc:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801bbf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bc2:	48 63 f0             	movslq %eax,%rsi
  801bc5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801bc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bcc:	48 98                	cltq   
  801bce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bd2:	48 83 ec 08          	sub    $0x8,%rsp
  801bd6:	6a 00                	pushq  $0x0
  801bd8:	49 89 f1             	mov    %rsi,%r9
  801bdb:	49 89 c8             	mov    %rcx,%r8
  801bde:	48 89 d1             	mov    %rdx,%rcx
  801be1:	48 89 c2             	mov    %rax,%rdx
  801be4:	be 00 00 00 00       	mov    $0x0,%esi
  801be9:	bf 0c 00 00 00       	mov    $0xc,%edi
  801bee:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  801bf5:	00 00 00 
  801bf8:	ff d0                	callq  *%rax
  801bfa:	48 83 c4 10          	add    $0x10,%rsp
}
  801bfe:	c9                   	leaveq 
  801bff:	c3                   	retq   

0000000000801c00 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c00:	55                   	push   %rbp
  801c01:	48 89 e5             	mov    %rsp,%rbp
  801c04:	48 83 ec 10          	sub    $0x10,%rsp
  801c08:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c10:	48 83 ec 08          	sub    $0x8,%rsp
  801c14:	6a 00                	pushq  $0x0
  801c16:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c1c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c22:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c27:	48 89 c2             	mov    %rax,%rdx
  801c2a:	be 01 00 00 00       	mov    $0x1,%esi
  801c2f:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c34:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  801c3b:	00 00 00 
  801c3e:	ff d0                	callq  *%rax
  801c40:	48 83 c4 10          	add    $0x10,%rsp
}
  801c44:	c9                   	leaveq 
  801c45:	c3                   	retq   

0000000000801c46 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801c46:	55                   	push   %rbp
  801c47:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c4a:	48 83 ec 08          	sub    $0x8,%rsp
  801c4e:	6a 00                	pushq  $0x0
  801c50:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c56:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c5c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c61:	ba 00 00 00 00       	mov    $0x0,%edx
  801c66:	be 00 00 00 00       	mov    $0x0,%esi
  801c6b:	bf 0e 00 00 00       	mov    $0xe,%edi
  801c70:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  801c77:	00 00 00 
  801c7a:	ff d0                	callq  *%rax
  801c7c:	48 83 c4 10          	add    $0x10,%rsp
}
  801c80:	c9                   	leaveq 
  801c81:	c3                   	retq   

0000000000801c82 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801c82:	55                   	push   %rbp
  801c83:	48 89 e5             	mov    %rsp,%rbp
  801c86:	48 83 ec 20          	sub    $0x20,%rsp
  801c8a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c8d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c91:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801c94:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801c98:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801c9c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c9f:	48 63 c8             	movslq %eax,%rcx
  801ca2:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ca6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ca9:	48 63 f0             	movslq %eax,%rsi
  801cac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cb3:	48 98                	cltq   
  801cb5:	48 83 ec 08          	sub    $0x8,%rsp
  801cb9:	51                   	push   %rcx
  801cba:	49 89 f9             	mov    %rdi,%r9
  801cbd:	49 89 f0             	mov    %rsi,%r8
  801cc0:	48 89 d1             	mov    %rdx,%rcx
  801cc3:	48 89 c2             	mov    %rax,%rdx
  801cc6:	be 00 00 00 00       	mov    $0x0,%esi
  801ccb:	bf 0f 00 00 00       	mov    $0xf,%edi
  801cd0:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  801cd7:	00 00 00 
  801cda:	ff d0                	callq  *%rax
  801cdc:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801ce0:	c9                   	leaveq 
  801ce1:	c3                   	retq   

0000000000801ce2 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801ce2:	55                   	push   %rbp
  801ce3:	48 89 e5             	mov    %rsp,%rbp
  801ce6:	48 83 ec 10          	sub    $0x10,%rsp
  801cea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801cf2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cf6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cfa:	48 83 ec 08          	sub    $0x8,%rsp
  801cfe:	6a 00                	pushq  $0x0
  801d00:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d06:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d0c:	48 89 d1             	mov    %rdx,%rcx
  801d0f:	48 89 c2             	mov    %rax,%rdx
  801d12:	be 00 00 00 00       	mov    $0x0,%esi
  801d17:	bf 10 00 00 00       	mov    $0x10,%edi
  801d1c:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  801d23:	00 00 00 
  801d26:	ff d0                	callq  *%rax
  801d28:	48 83 c4 10          	add    $0x10,%rsp
}
  801d2c:	c9                   	leaveq 
  801d2d:	c3                   	retq   

0000000000801d2e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d2e:	55                   	push   %rbp
  801d2f:	48 89 e5             	mov    %rsp,%rbp
  801d32:	48 83 ec 08          	sub    $0x8,%rsp
  801d36:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d3a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d3e:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d45:	ff ff ff 
  801d48:	48 01 d0             	add    %rdx,%rax
  801d4b:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d4f:	c9                   	leaveq 
  801d50:	c3                   	retq   

0000000000801d51 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d51:	55                   	push   %rbp
  801d52:	48 89 e5             	mov    %rsp,%rbp
  801d55:	48 83 ec 08          	sub    $0x8,%rsp
  801d59:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d61:	48 89 c7             	mov    %rax,%rdi
  801d64:	48 b8 2e 1d 80 00 00 	movabs $0x801d2e,%rax
  801d6b:	00 00 00 
  801d6e:	ff d0                	callq  *%rax
  801d70:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d76:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d7a:	c9                   	leaveq 
  801d7b:	c3                   	retq   

0000000000801d7c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d7c:	55                   	push   %rbp
  801d7d:	48 89 e5             	mov    %rsp,%rbp
  801d80:	48 83 ec 18          	sub    $0x18,%rsp
  801d84:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d8f:	eb 6b                	jmp    801dfc <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801d91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d94:	48 98                	cltq   
  801d96:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d9c:	48 c1 e0 0c          	shl    $0xc,%rax
  801da0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801da4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801da8:	48 c1 e8 15          	shr    $0x15,%rax
  801dac:	48 89 c2             	mov    %rax,%rdx
  801daf:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801db6:	01 00 00 
  801db9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dbd:	83 e0 01             	and    $0x1,%eax
  801dc0:	48 85 c0             	test   %rax,%rax
  801dc3:	74 21                	je     801de6 <fd_alloc+0x6a>
  801dc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dc9:	48 c1 e8 0c          	shr    $0xc,%rax
  801dcd:	48 89 c2             	mov    %rax,%rdx
  801dd0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dd7:	01 00 00 
  801dda:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dde:	83 e0 01             	and    $0x1,%eax
  801de1:	48 85 c0             	test   %rax,%rax
  801de4:	75 12                	jne    801df8 <fd_alloc+0x7c>
			*fd_store = fd;
  801de6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dee:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801df1:	b8 00 00 00 00       	mov    $0x0,%eax
  801df6:	eb 1a                	jmp    801e12 <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  801df8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801dfc:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e00:	7e 8f                	jle    801d91 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  801e02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e06:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e0d:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e12:	c9                   	leaveq 
  801e13:	c3                   	retq   

0000000000801e14 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e14:	55                   	push   %rbp
  801e15:	48 89 e5             	mov    %rsp,%rbp
  801e18:	48 83 ec 20          	sub    $0x20,%rsp
  801e1c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e1f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e23:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e27:	78 06                	js     801e2f <fd_lookup+0x1b>
  801e29:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e2d:	7e 07                	jle    801e36 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e2f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e34:	eb 6c                	jmp    801ea2 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e36:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e39:	48 98                	cltq   
  801e3b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e41:	48 c1 e0 0c          	shl    $0xc,%rax
  801e45:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e4d:	48 c1 e8 15          	shr    $0x15,%rax
  801e51:	48 89 c2             	mov    %rax,%rdx
  801e54:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e5b:	01 00 00 
  801e5e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e62:	83 e0 01             	and    $0x1,%eax
  801e65:	48 85 c0             	test   %rax,%rax
  801e68:	74 21                	je     801e8b <fd_lookup+0x77>
  801e6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e6e:	48 c1 e8 0c          	shr    $0xc,%rax
  801e72:	48 89 c2             	mov    %rax,%rdx
  801e75:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e7c:	01 00 00 
  801e7f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e83:	83 e0 01             	and    $0x1,%eax
  801e86:	48 85 c0             	test   %rax,%rax
  801e89:	75 07                	jne    801e92 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e8b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e90:	eb 10                	jmp    801ea2 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801e92:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e96:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e9a:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea2:	c9                   	leaveq 
  801ea3:	c3                   	retq   

0000000000801ea4 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801ea4:	55                   	push   %rbp
  801ea5:	48 89 e5             	mov    %rsp,%rbp
  801ea8:	48 83 ec 30          	sub    $0x30,%rsp
  801eac:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801eb0:	89 f0                	mov    %esi,%eax
  801eb2:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801eb5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eb9:	48 89 c7             	mov    %rax,%rdi
  801ebc:	48 b8 2e 1d 80 00 00 	movabs $0x801d2e,%rax
  801ec3:	00 00 00 
  801ec6:	ff d0                	callq  *%rax
  801ec8:	89 c2                	mov    %eax,%edx
  801eca:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801ece:	48 89 c6             	mov    %rax,%rsi
  801ed1:	89 d7                	mov    %edx,%edi
  801ed3:	48 b8 14 1e 80 00 00 	movabs $0x801e14,%rax
  801eda:	00 00 00 
  801edd:	ff d0                	callq  *%rax
  801edf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ee2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ee6:	78 0a                	js     801ef2 <fd_close+0x4e>
	    || fd != fd2)
  801ee8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eec:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801ef0:	74 12                	je     801f04 <fd_close+0x60>
		return (must_exist ? r : 0);
  801ef2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801ef6:	74 05                	je     801efd <fd_close+0x59>
  801ef8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801efb:	eb 70                	jmp    801f6d <fd_close+0xc9>
  801efd:	b8 00 00 00 00       	mov    $0x0,%eax
  801f02:	eb 69                	jmp    801f6d <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f04:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f08:	8b 00                	mov    (%rax),%eax
  801f0a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f0e:	48 89 d6             	mov    %rdx,%rsi
  801f11:	89 c7                	mov    %eax,%edi
  801f13:	48 b8 6f 1f 80 00 00 	movabs $0x801f6f,%rax
  801f1a:	00 00 00 
  801f1d:	ff d0                	callq  *%rax
  801f1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f26:	78 2a                	js     801f52 <fd_close+0xae>
		if (dev->dev_close)
  801f28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f2c:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f30:	48 85 c0             	test   %rax,%rax
  801f33:	74 16                	je     801f4b <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  801f35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f39:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f3d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f41:	48 89 d7             	mov    %rdx,%rdi
  801f44:	ff d0                	callq  *%rax
  801f46:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f49:	eb 07                	jmp    801f52 <fd_close+0xae>
		else
			r = 0;
  801f4b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f52:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f56:	48 89 c6             	mov    %rax,%rsi
  801f59:	bf 00 00 00 00       	mov    $0x0,%edi
  801f5e:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  801f65:	00 00 00 
  801f68:	ff d0                	callq  *%rax
	return r;
  801f6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f6d:	c9                   	leaveq 
  801f6e:	c3                   	retq   

0000000000801f6f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f6f:	55                   	push   %rbp
  801f70:	48 89 e5             	mov    %rsp,%rbp
  801f73:	48 83 ec 20          	sub    $0x20,%rsp
  801f77:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f7a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f7e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f85:	eb 41                	jmp    801fc8 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f87:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f8e:	00 00 00 
  801f91:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f94:	48 63 d2             	movslq %edx,%rdx
  801f97:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f9b:	8b 00                	mov    (%rax),%eax
  801f9d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801fa0:	75 22                	jne    801fc4 <dev_lookup+0x55>
			*dev = devtab[i];
  801fa2:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fa9:	00 00 00 
  801fac:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801faf:	48 63 d2             	movslq %edx,%rdx
  801fb2:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801fb6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fba:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801fbd:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc2:	eb 60                	jmp    802024 <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  801fc4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fc8:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fcf:	00 00 00 
  801fd2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fd5:	48 63 d2             	movslq %edx,%rdx
  801fd8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fdc:	48 85 c0             	test   %rax,%rax
  801fdf:	75 a6                	jne    801f87 <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801fe1:	48 b8 40 90 80 00 00 	movabs $0x809040,%rax
  801fe8:	00 00 00 
  801feb:	48 8b 00             	mov    (%rax),%rax
  801fee:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801ff4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ff7:	89 c6                	mov    %eax,%esi
  801ff9:	48 bf 78 47 80 00 00 	movabs $0x804778,%rdi
  802000:	00 00 00 
  802003:	b8 00 00 00 00       	mov    $0x0,%eax
  802008:	48 b9 ff 04 80 00 00 	movabs $0x8004ff,%rcx
  80200f:	00 00 00 
  802012:	ff d1                	callq  *%rcx
	*dev = 0;
  802014:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802018:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80201f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802024:	c9                   	leaveq 
  802025:	c3                   	retq   

0000000000802026 <close>:

int
close(int fdnum)
{
  802026:	55                   	push   %rbp
  802027:	48 89 e5             	mov    %rsp,%rbp
  80202a:	48 83 ec 20          	sub    $0x20,%rsp
  80202e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802031:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802035:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802038:	48 89 d6             	mov    %rdx,%rsi
  80203b:	89 c7                	mov    %eax,%edi
  80203d:	48 b8 14 1e 80 00 00 	movabs $0x801e14,%rax
  802044:	00 00 00 
  802047:	ff d0                	callq  *%rax
  802049:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80204c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802050:	79 05                	jns    802057 <close+0x31>
		return r;
  802052:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802055:	eb 18                	jmp    80206f <close+0x49>
	else
		return fd_close(fd, 1);
  802057:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80205b:	be 01 00 00 00       	mov    $0x1,%esi
  802060:	48 89 c7             	mov    %rax,%rdi
  802063:	48 b8 a4 1e 80 00 00 	movabs $0x801ea4,%rax
  80206a:	00 00 00 
  80206d:	ff d0                	callq  *%rax
}
  80206f:	c9                   	leaveq 
  802070:	c3                   	retq   

0000000000802071 <close_all>:

void
close_all(void)
{
  802071:	55                   	push   %rbp
  802072:	48 89 e5             	mov    %rsp,%rbp
  802075:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802079:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802080:	eb 15                	jmp    802097 <close_all+0x26>
		close(i);
  802082:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802085:	89 c7                	mov    %eax,%edi
  802087:	48 b8 26 20 80 00 00 	movabs $0x802026,%rax
  80208e:	00 00 00 
  802091:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  802093:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802097:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80209b:	7e e5                	jle    802082 <close_all+0x11>
}
  80209d:	c9                   	leaveq 
  80209e:	c3                   	retq   

000000000080209f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80209f:	55                   	push   %rbp
  8020a0:	48 89 e5             	mov    %rsp,%rbp
  8020a3:	48 83 ec 40          	sub    $0x40,%rsp
  8020a7:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8020aa:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8020ad:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8020b1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8020b4:	48 89 d6             	mov    %rdx,%rsi
  8020b7:	89 c7                	mov    %eax,%edi
  8020b9:	48 b8 14 1e 80 00 00 	movabs $0x801e14,%rax
  8020c0:	00 00 00 
  8020c3:	ff d0                	callq  *%rax
  8020c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020cc:	79 08                	jns    8020d6 <dup+0x37>
		return r;
  8020ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020d1:	e9 70 01 00 00       	jmpq   802246 <dup+0x1a7>
	close(newfdnum);
  8020d6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020d9:	89 c7                	mov    %eax,%edi
  8020db:	48 b8 26 20 80 00 00 	movabs $0x802026,%rax
  8020e2:	00 00 00 
  8020e5:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8020e7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020ea:	48 98                	cltq   
  8020ec:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020f2:	48 c1 e0 0c          	shl    $0xc,%rax
  8020f6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8020fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020fe:	48 89 c7             	mov    %rax,%rdi
  802101:	48 b8 51 1d 80 00 00 	movabs $0x801d51,%rax
  802108:	00 00 00 
  80210b:	ff d0                	callq  *%rax
  80210d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802111:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802115:	48 89 c7             	mov    %rax,%rdi
  802118:	48 b8 51 1d 80 00 00 	movabs $0x801d51,%rax
  80211f:	00 00 00 
  802122:	ff d0                	callq  *%rax
  802124:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802128:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80212c:	48 c1 e8 15          	shr    $0x15,%rax
  802130:	48 89 c2             	mov    %rax,%rdx
  802133:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80213a:	01 00 00 
  80213d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802141:	83 e0 01             	and    $0x1,%eax
  802144:	48 85 c0             	test   %rax,%rax
  802147:	74 73                	je     8021bc <dup+0x11d>
  802149:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80214d:	48 c1 e8 0c          	shr    $0xc,%rax
  802151:	48 89 c2             	mov    %rax,%rdx
  802154:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80215b:	01 00 00 
  80215e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802162:	83 e0 01             	and    $0x1,%eax
  802165:	48 85 c0             	test   %rax,%rax
  802168:	74 52                	je     8021bc <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80216a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80216e:	48 c1 e8 0c          	shr    $0xc,%rax
  802172:	48 89 c2             	mov    %rax,%rdx
  802175:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80217c:	01 00 00 
  80217f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802183:	25 07 0e 00 00       	and    $0xe07,%eax
  802188:	89 c1                	mov    %eax,%ecx
  80218a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80218e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802192:	41 89 c8             	mov    %ecx,%r8d
  802195:	48 89 d1             	mov    %rdx,%rcx
  802198:	ba 00 00 00 00       	mov    $0x0,%edx
  80219d:	48 89 c6             	mov    %rax,%rsi
  8021a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8021a5:	48 b8 18 1a 80 00 00 	movabs $0x801a18,%rax
  8021ac:	00 00 00 
  8021af:	ff d0                	callq  *%rax
  8021b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021b8:	79 02                	jns    8021bc <dup+0x11d>
			goto err;
  8021ba:	eb 57                	jmp    802213 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8021bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021c0:	48 c1 e8 0c          	shr    $0xc,%rax
  8021c4:	48 89 c2             	mov    %rax,%rdx
  8021c7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021ce:	01 00 00 
  8021d1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021d5:	25 07 0e 00 00       	and    $0xe07,%eax
  8021da:	89 c1                	mov    %eax,%ecx
  8021dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021e0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021e4:	41 89 c8             	mov    %ecx,%r8d
  8021e7:	48 89 d1             	mov    %rdx,%rcx
  8021ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8021ef:	48 89 c6             	mov    %rax,%rsi
  8021f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8021f7:	48 b8 18 1a 80 00 00 	movabs $0x801a18,%rax
  8021fe:	00 00 00 
  802201:	ff d0                	callq  *%rax
  802203:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802206:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80220a:	79 02                	jns    80220e <dup+0x16f>
		goto err;
  80220c:	eb 05                	jmp    802213 <dup+0x174>

	return newfdnum;
  80220e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802211:	eb 33                	jmp    802246 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802213:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802217:	48 89 c6             	mov    %rax,%rsi
  80221a:	bf 00 00 00 00       	mov    $0x0,%edi
  80221f:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  802226:	00 00 00 
  802229:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80222b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80222f:	48 89 c6             	mov    %rax,%rsi
  802232:	bf 00 00 00 00       	mov    $0x0,%edi
  802237:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  80223e:	00 00 00 
  802241:	ff d0                	callq  *%rax
	return r;
  802243:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802246:	c9                   	leaveq 
  802247:	c3                   	retq   

0000000000802248 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802248:	55                   	push   %rbp
  802249:	48 89 e5             	mov    %rsp,%rbp
  80224c:	48 83 ec 40          	sub    $0x40,%rsp
  802250:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802253:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802257:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80225b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80225f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802262:	48 89 d6             	mov    %rdx,%rsi
  802265:	89 c7                	mov    %eax,%edi
  802267:	48 b8 14 1e 80 00 00 	movabs $0x801e14,%rax
  80226e:	00 00 00 
  802271:	ff d0                	callq  *%rax
  802273:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802276:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80227a:	78 24                	js     8022a0 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80227c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802280:	8b 00                	mov    (%rax),%eax
  802282:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802286:	48 89 d6             	mov    %rdx,%rsi
  802289:	89 c7                	mov    %eax,%edi
  80228b:	48 b8 6f 1f 80 00 00 	movabs $0x801f6f,%rax
  802292:	00 00 00 
  802295:	ff d0                	callq  *%rax
  802297:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80229a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80229e:	79 05                	jns    8022a5 <read+0x5d>
		return r;
  8022a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022a3:	eb 76                	jmp    80231b <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8022a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a9:	8b 40 08             	mov    0x8(%rax),%eax
  8022ac:	83 e0 03             	and    $0x3,%eax
  8022af:	83 f8 01             	cmp    $0x1,%eax
  8022b2:	75 3a                	jne    8022ee <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8022b4:	48 b8 40 90 80 00 00 	movabs $0x809040,%rax
  8022bb:	00 00 00 
  8022be:	48 8b 00             	mov    (%rax),%rax
  8022c1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022c7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022ca:	89 c6                	mov    %eax,%esi
  8022cc:	48 bf 97 47 80 00 00 	movabs $0x804797,%rdi
  8022d3:	00 00 00 
  8022d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022db:	48 b9 ff 04 80 00 00 	movabs $0x8004ff,%rcx
  8022e2:	00 00 00 
  8022e5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8022e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022ec:	eb 2d                	jmp    80231b <read+0xd3>
	}
	if (!dev->dev_read)
  8022ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022f2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022f6:	48 85 c0             	test   %rax,%rax
  8022f9:	75 07                	jne    802302 <read+0xba>
		return -E_NOT_SUPP;
  8022fb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802300:	eb 19                	jmp    80231b <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802302:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802306:	48 8b 40 10          	mov    0x10(%rax),%rax
  80230a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80230e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802312:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802316:	48 89 cf             	mov    %rcx,%rdi
  802319:	ff d0                	callq  *%rax
}
  80231b:	c9                   	leaveq 
  80231c:	c3                   	retq   

000000000080231d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80231d:	55                   	push   %rbp
  80231e:	48 89 e5             	mov    %rsp,%rbp
  802321:	48 83 ec 30          	sub    $0x30,%rsp
  802325:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802328:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80232c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802330:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802337:	eb 49                	jmp    802382 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802339:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80233c:	48 98                	cltq   
  80233e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802342:	48 29 c2             	sub    %rax,%rdx
  802345:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802348:	48 63 c8             	movslq %eax,%rcx
  80234b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80234f:	48 01 c1             	add    %rax,%rcx
  802352:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802355:	48 89 ce             	mov    %rcx,%rsi
  802358:	89 c7                	mov    %eax,%edi
  80235a:	48 b8 48 22 80 00 00 	movabs $0x802248,%rax
  802361:	00 00 00 
  802364:	ff d0                	callq  *%rax
  802366:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802369:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80236d:	79 05                	jns    802374 <readn+0x57>
			return m;
  80236f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802372:	eb 1c                	jmp    802390 <readn+0x73>
		if (m == 0)
  802374:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802378:	75 02                	jne    80237c <readn+0x5f>
			break;
  80237a:	eb 11                	jmp    80238d <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  80237c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80237f:	01 45 fc             	add    %eax,-0x4(%rbp)
  802382:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802385:	48 98                	cltq   
  802387:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80238b:	72 ac                	jb     802339 <readn+0x1c>
	}
	return tot;
  80238d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802390:	c9                   	leaveq 
  802391:	c3                   	retq   

0000000000802392 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
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
  8023b1:	48 b8 14 1e 80 00 00 	movabs $0x801e14,%rax
  8023b8:	00 00 00 
  8023bb:	ff d0                	callq  *%rax
  8023bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023c4:	78 24                	js     8023ea <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ca:	8b 00                	mov    (%rax),%eax
  8023cc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023d0:	48 89 d6             	mov    %rdx,%rsi
  8023d3:	89 c7                	mov    %eax,%edi
  8023d5:	48 b8 6f 1f 80 00 00 	movabs $0x801f6f,%rax
  8023dc:	00 00 00 
  8023df:	ff d0                	callq  *%rax
  8023e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e8:	79 05                	jns    8023ef <write+0x5d>
		return r;
  8023ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ed:	eb 75                	jmp    802464 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f3:	8b 40 08             	mov    0x8(%rax),%eax
  8023f6:	83 e0 03             	and    $0x3,%eax
  8023f9:	85 c0                	test   %eax,%eax
  8023fb:	75 3a                	jne    802437 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8023fd:	48 b8 40 90 80 00 00 	movabs $0x809040,%rax
  802404:	00 00 00 
  802407:	48 8b 00             	mov    (%rax),%rax
  80240a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802410:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802413:	89 c6                	mov    %eax,%esi
  802415:	48 bf b3 47 80 00 00 	movabs $0x8047b3,%rdi
  80241c:	00 00 00 
  80241f:	b8 00 00 00 00       	mov    $0x0,%eax
  802424:	48 b9 ff 04 80 00 00 	movabs $0x8004ff,%rcx
  80242b:	00 00 00 
  80242e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802430:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802435:	eb 2d                	jmp    802464 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802437:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80243b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80243f:	48 85 c0             	test   %rax,%rax
  802442:	75 07                	jne    80244b <write+0xb9>
		return -E_NOT_SUPP;
  802444:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802449:	eb 19                	jmp    802464 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80244b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80244f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802453:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802457:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80245b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80245f:	48 89 cf             	mov    %rcx,%rdi
  802462:	ff d0                	callq  *%rax
}
  802464:	c9                   	leaveq 
  802465:	c3                   	retq   

0000000000802466 <seek>:

int
seek(int fdnum, off_t offset)
{
  802466:	55                   	push   %rbp
  802467:	48 89 e5             	mov    %rsp,%rbp
  80246a:	48 83 ec 18          	sub    $0x18,%rsp
  80246e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802471:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802474:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802478:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80247b:	48 89 d6             	mov    %rdx,%rsi
  80247e:	89 c7                	mov    %eax,%edi
  802480:	48 b8 14 1e 80 00 00 	movabs $0x801e14,%rax
  802487:	00 00 00 
  80248a:	ff d0                	callq  *%rax
  80248c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80248f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802493:	79 05                	jns    80249a <seek+0x34>
		return r;
  802495:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802498:	eb 0f                	jmp    8024a9 <seek+0x43>
	fd->fd_offset = offset;
  80249a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80249e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8024a1:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8024a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024a9:	c9                   	leaveq 
  8024aa:	c3                   	retq   

00000000008024ab <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8024ab:	55                   	push   %rbp
  8024ac:	48 89 e5             	mov    %rsp,%rbp
  8024af:	48 83 ec 30          	sub    $0x30,%rsp
  8024b3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024b6:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024b9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024bd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024c0:	48 89 d6             	mov    %rdx,%rsi
  8024c3:	89 c7                	mov    %eax,%edi
  8024c5:	48 b8 14 1e 80 00 00 	movabs $0x801e14,%rax
  8024cc:	00 00 00 
  8024cf:	ff d0                	callq  *%rax
  8024d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024d8:	78 24                	js     8024fe <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024de:	8b 00                	mov    (%rax),%eax
  8024e0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024e4:	48 89 d6             	mov    %rdx,%rsi
  8024e7:	89 c7                	mov    %eax,%edi
  8024e9:	48 b8 6f 1f 80 00 00 	movabs $0x801f6f,%rax
  8024f0:	00 00 00 
  8024f3:	ff d0                	callq  *%rax
  8024f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024fc:	79 05                	jns    802503 <ftruncate+0x58>
		return r;
  8024fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802501:	eb 72                	jmp    802575 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802503:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802507:	8b 40 08             	mov    0x8(%rax),%eax
  80250a:	83 e0 03             	and    $0x3,%eax
  80250d:	85 c0                	test   %eax,%eax
  80250f:	75 3a                	jne    80254b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802511:	48 b8 40 90 80 00 00 	movabs $0x809040,%rax
  802518:	00 00 00 
  80251b:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80251e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802524:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802527:	89 c6                	mov    %eax,%esi
  802529:	48 bf d0 47 80 00 00 	movabs $0x8047d0,%rdi
  802530:	00 00 00 
  802533:	b8 00 00 00 00       	mov    $0x0,%eax
  802538:	48 b9 ff 04 80 00 00 	movabs $0x8004ff,%rcx
  80253f:	00 00 00 
  802542:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802544:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802549:	eb 2a                	jmp    802575 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80254b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80254f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802553:	48 85 c0             	test   %rax,%rax
  802556:	75 07                	jne    80255f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802558:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80255d:	eb 16                	jmp    802575 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80255f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802563:	48 8b 40 30          	mov    0x30(%rax),%rax
  802567:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80256b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80256e:	89 ce                	mov    %ecx,%esi
  802570:	48 89 d7             	mov    %rdx,%rdi
  802573:	ff d0                	callq  *%rax
}
  802575:	c9                   	leaveq 
  802576:	c3                   	retq   

0000000000802577 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802577:	55                   	push   %rbp
  802578:	48 89 e5             	mov    %rsp,%rbp
  80257b:	48 83 ec 30          	sub    $0x30,%rsp
  80257f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802582:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802586:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80258a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80258d:	48 89 d6             	mov    %rdx,%rsi
  802590:	89 c7                	mov    %eax,%edi
  802592:	48 b8 14 1e 80 00 00 	movabs $0x801e14,%rax
  802599:	00 00 00 
  80259c:	ff d0                	callq  *%rax
  80259e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025a5:	78 24                	js     8025cb <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ab:	8b 00                	mov    (%rax),%eax
  8025ad:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025b1:	48 89 d6             	mov    %rdx,%rsi
  8025b4:	89 c7                	mov    %eax,%edi
  8025b6:	48 b8 6f 1f 80 00 00 	movabs $0x801f6f,%rax
  8025bd:	00 00 00 
  8025c0:	ff d0                	callq  *%rax
  8025c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025c9:	79 05                	jns    8025d0 <fstat+0x59>
		return r;
  8025cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ce:	eb 5e                	jmp    80262e <fstat+0xb7>
	if (!dev->dev_stat)
  8025d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025d4:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025d8:	48 85 c0             	test   %rax,%rax
  8025db:	75 07                	jne    8025e4 <fstat+0x6d>
		return -E_NOT_SUPP;
  8025dd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025e2:	eb 4a                	jmp    80262e <fstat+0xb7>
	stat->st_name[0] = 0;
  8025e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025e8:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8025eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025ef:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8025f6:	00 00 00 
	stat->st_isdir = 0;
  8025f9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025fd:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802604:	00 00 00 
	stat->st_dev = dev;
  802607:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80260b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80260f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802616:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80261a:	48 8b 40 28          	mov    0x28(%rax),%rax
  80261e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802622:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802626:	48 89 ce             	mov    %rcx,%rsi
  802629:	48 89 d7             	mov    %rdx,%rdi
  80262c:	ff d0                	callq  *%rax
}
  80262e:	c9                   	leaveq 
  80262f:	c3                   	retq   

0000000000802630 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802630:	55                   	push   %rbp
  802631:	48 89 e5             	mov    %rsp,%rbp
  802634:	48 83 ec 20          	sub    $0x20,%rsp
  802638:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80263c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802640:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802644:	be 00 00 00 00       	mov    $0x0,%esi
  802649:	48 89 c7             	mov    %rax,%rdi
  80264c:	48 b8 20 27 80 00 00 	movabs $0x802720,%rax
  802653:	00 00 00 
  802656:	ff d0                	callq  *%rax
  802658:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80265b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80265f:	79 05                	jns    802666 <stat+0x36>
		return fd;
  802661:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802664:	eb 2f                	jmp    802695 <stat+0x65>
	r = fstat(fd, stat);
  802666:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80266a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80266d:	48 89 d6             	mov    %rdx,%rsi
  802670:	89 c7                	mov    %eax,%edi
  802672:	48 b8 77 25 80 00 00 	movabs $0x802577,%rax
  802679:	00 00 00 
  80267c:	ff d0                	callq  *%rax
  80267e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802681:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802684:	89 c7                	mov    %eax,%edi
  802686:	48 b8 26 20 80 00 00 	movabs $0x802026,%rax
  80268d:	00 00 00 
  802690:	ff d0                	callq  *%rax
	return r;
  802692:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802695:	c9                   	leaveq 
  802696:	c3                   	retq   

0000000000802697 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802697:	55                   	push   %rbp
  802698:	48 89 e5             	mov    %rsp,%rbp
  80269b:	48 83 ec 10          	sub    $0x10,%rsp
  80269f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8026a2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8026a6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026ad:	00 00 00 
  8026b0:	8b 00                	mov    (%rax),%eax
  8026b2:	85 c0                	test   %eax,%eax
  8026b4:	75 1f                	jne    8026d5 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8026b6:	bf 01 00 00 00       	mov    $0x1,%edi
  8026bb:	48 b8 a5 40 80 00 00 	movabs $0x8040a5,%rax
  8026c2:	00 00 00 
  8026c5:	ff d0                	callq  *%rax
  8026c7:	89 c2                	mov    %eax,%edx
  8026c9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026d0:	00 00 00 
  8026d3:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8026d5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026dc:	00 00 00 
  8026df:	8b 00                	mov    (%rax),%eax
  8026e1:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8026e4:	b9 07 00 00 00       	mov    $0x7,%ecx
  8026e9:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8026f0:	00 00 00 
  8026f3:	89 c7                	mov    %eax,%edi
  8026f5:	48 b8 18 3f 80 00 00 	movabs $0x803f18,%rax
  8026fc:	00 00 00 
  8026ff:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802701:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802705:	ba 00 00 00 00       	mov    $0x0,%edx
  80270a:	48 89 c6             	mov    %rax,%rsi
  80270d:	bf 00 00 00 00       	mov    $0x0,%edi
  802712:	48 b8 da 3e 80 00 00 	movabs $0x803eda,%rax
  802719:	00 00 00 
  80271c:	ff d0                	callq  *%rax
}
  80271e:	c9                   	leaveq 
  80271f:	c3                   	retq   

0000000000802720 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802720:	55                   	push   %rbp
  802721:	48 89 e5             	mov    %rsp,%rbp
  802724:	48 83 ec 10          	sub    $0x10,%rsp
  802728:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80272c:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  80272f:	48 ba f6 47 80 00 00 	movabs $0x8047f6,%rdx
  802736:	00 00 00 
  802739:	be 4c 00 00 00       	mov    $0x4c,%esi
  80273e:	48 bf 0b 48 80 00 00 	movabs $0x80480b,%rdi
  802745:	00 00 00 
  802748:	b8 00 00 00 00       	mov    $0x0,%eax
  80274d:	48 b9 c6 02 80 00 00 	movabs $0x8002c6,%rcx
  802754:	00 00 00 
  802757:	ff d1                	callq  *%rcx

0000000000802759 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802759:	55                   	push   %rbp
  80275a:	48 89 e5             	mov    %rsp,%rbp
  80275d:	48 83 ec 10          	sub    $0x10,%rsp
  802761:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802765:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802769:	8b 50 0c             	mov    0xc(%rax),%edx
  80276c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802773:	00 00 00 
  802776:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802778:	be 00 00 00 00       	mov    $0x0,%esi
  80277d:	bf 06 00 00 00       	mov    $0x6,%edi
  802782:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  802789:	00 00 00 
  80278c:	ff d0                	callq  *%rax
}
  80278e:	c9                   	leaveq 
  80278f:	c3                   	retq   

0000000000802790 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802790:	55                   	push   %rbp
  802791:	48 89 e5             	mov    %rsp,%rbp
  802794:	48 83 ec 20          	sub    $0x20,%rsp
  802798:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80279c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8027a0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  8027a4:	48 ba 16 48 80 00 00 	movabs $0x804816,%rdx
  8027ab:	00 00 00 
  8027ae:	be 6b 00 00 00       	mov    $0x6b,%esi
  8027b3:	48 bf 0b 48 80 00 00 	movabs $0x80480b,%rdi
  8027ba:	00 00 00 
  8027bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c2:	48 b9 c6 02 80 00 00 	movabs $0x8002c6,%rcx
  8027c9:	00 00 00 
  8027cc:	ff d1                	callq  *%rcx

00000000008027ce <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8027ce:	55                   	push   %rbp
  8027cf:	48 89 e5             	mov    %rsp,%rbp
  8027d2:	48 83 ec 20          	sub    $0x20,%rsp
  8027d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8027da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8027de:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  8027e2:	48 ba 33 48 80 00 00 	movabs $0x804833,%rdx
  8027e9:	00 00 00 
  8027ec:	be 7b 00 00 00       	mov    $0x7b,%esi
  8027f1:	48 bf 0b 48 80 00 00 	movabs $0x80480b,%rdi
  8027f8:	00 00 00 
  8027fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802800:	48 b9 c6 02 80 00 00 	movabs $0x8002c6,%rcx
  802807:	00 00 00 
  80280a:	ff d1                	callq  *%rcx

000000000080280c <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80280c:	55                   	push   %rbp
  80280d:	48 89 e5             	mov    %rsp,%rbp
  802810:	48 83 ec 20          	sub    $0x20,%rsp
  802814:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802818:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80281c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802820:	8b 50 0c             	mov    0xc(%rax),%edx
  802823:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80282a:	00 00 00 
  80282d:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80282f:	be 00 00 00 00       	mov    $0x0,%esi
  802834:	bf 05 00 00 00       	mov    $0x5,%edi
  802839:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  802840:	00 00 00 
  802843:	ff d0                	callq  *%rax
  802845:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802848:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80284c:	79 05                	jns    802853 <devfile_stat+0x47>
		return r;
  80284e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802851:	eb 56                	jmp    8028a9 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802853:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802857:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80285e:	00 00 00 
  802861:	48 89 c7             	mov    %rax,%rdi
  802864:	48 b8 99 10 80 00 00 	movabs $0x801099,%rax
  80286b:	00 00 00 
  80286e:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802870:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802877:	00 00 00 
  80287a:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802880:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802884:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80288a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802891:	00 00 00 
  802894:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80289a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80289e:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8028a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028a9:	c9                   	leaveq 
  8028aa:	c3                   	retq   

00000000008028ab <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8028ab:	55                   	push   %rbp
  8028ac:	48 89 e5             	mov    %rsp,%rbp
  8028af:	48 83 ec 10          	sub    $0x10,%rsp
  8028b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8028b7:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8028ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028be:	8b 50 0c             	mov    0xc(%rax),%edx
  8028c1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8028c8:	00 00 00 
  8028cb:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8028cd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8028d4:	00 00 00 
  8028d7:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8028da:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8028dd:	be 00 00 00 00       	mov    $0x0,%esi
  8028e2:	bf 02 00 00 00       	mov    $0x2,%edi
  8028e7:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  8028ee:	00 00 00 
  8028f1:	ff d0                	callq  *%rax
}
  8028f3:	c9                   	leaveq 
  8028f4:	c3                   	retq   

00000000008028f5 <remove>:

// Delete a file
int
remove(const char *path)
{
  8028f5:	55                   	push   %rbp
  8028f6:	48 89 e5             	mov    %rsp,%rbp
  8028f9:	48 83 ec 10          	sub    $0x10,%rsp
  8028fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802901:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802905:	48 89 c7             	mov    %rax,%rdi
  802908:	48 b8 2d 10 80 00 00 	movabs $0x80102d,%rax
  80290f:	00 00 00 
  802912:	ff d0                	callq  *%rax
  802914:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802919:	7e 07                	jle    802922 <remove+0x2d>
		return -E_BAD_PATH;
  80291b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802920:	eb 33                	jmp    802955 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802922:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802926:	48 89 c6             	mov    %rax,%rsi
  802929:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  802930:	00 00 00 
  802933:	48 b8 99 10 80 00 00 	movabs $0x801099,%rax
  80293a:	00 00 00 
  80293d:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80293f:	be 00 00 00 00       	mov    $0x0,%esi
  802944:	bf 07 00 00 00       	mov    $0x7,%edi
  802949:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  802950:	00 00 00 
  802953:	ff d0                	callq  *%rax
}
  802955:	c9                   	leaveq 
  802956:	c3                   	retq   

0000000000802957 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802957:	55                   	push   %rbp
  802958:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80295b:	be 00 00 00 00       	mov    $0x0,%esi
  802960:	bf 08 00 00 00       	mov    $0x8,%edi
  802965:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  80296c:	00 00 00 
  80296f:	ff d0                	callq  *%rax
}
  802971:	5d                   	pop    %rbp
  802972:	c3                   	retq   

0000000000802973 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802973:	55                   	push   %rbp
  802974:	48 89 e5             	mov    %rsp,%rbp
  802977:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80297e:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802985:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80298c:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802993:	be 00 00 00 00       	mov    $0x0,%esi
  802998:	48 89 c7             	mov    %rax,%rdi
  80299b:	48 b8 20 27 80 00 00 	movabs $0x802720,%rax
  8029a2:	00 00 00 
  8029a5:	ff d0                	callq  *%rax
  8029a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8029aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029ae:	79 28                	jns    8029d8 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8029b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b3:	89 c6                	mov    %eax,%esi
  8029b5:	48 bf 51 48 80 00 00 	movabs $0x804851,%rdi
  8029bc:	00 00 00 
  8029bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c4:	48 ba ff 04 80 00 00 	movabs $0x8004ff,%rdx
  8029cb:	00 00 00 
  8029ce:	ff d2                	callq  *%rdx
		return fd_src;
  8029d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d3:	e9 74 01 00 00       	jmpq   802b4c <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8029d8:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8029df:	be 01 01 00 00       	mov    $0x101,%esi
  8029e4:	48 89 c7             	mov    %rax,%rdi
  8029e7:	48 b8 20 27 80 00 00 	movabs $0x802720,%rax
  8029ee:	00 00 00 
  8029f1:	ff d0                	callq  *%rax
  8029f3:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8029f6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029fa:	79 39                	jns    802a35 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8029fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029ff:	89 c6                	mov    %eax,%esi
  802a01:	48 bf 67 48 80 00 00 	movabs $0x804867,%rdi
  802a08:	00 00 00 
  802a0b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a10:	48 ba ff 04 80 00 00 	movabs $0x8004ff,%rdx
  802a17:	00 00 00 
  802a1a:	ff d2                	callq  *%rdx
		close(fd_src);
  802a1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a1f:	89 c7                	mov    %eax,%edi
  802a21:	48 b8 26 20 80 00 00 	movabs $0x802026,%rax
  802a28:	00 00 00 
  802a2b:	ff d0                	callq  *%rax
		return fd_dest;
  802a2d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a30:	e9 17 01 00 00       	jmpq   802b4c <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802a35:	eb 74                	jmp    802aab <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802a37:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a3a:	48 63 d0             	movslq %eax,%rdx
  802a3d:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802a44:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a47:	48 89 ce             	mov    %rcx,%rsi
  802a4a:	89 c7                	mov    %eax,%edi
  802a4c:	48 b8 92 23 80 00 00 	movabs $0x802392,%rax
  802a53:	00 00 00 
  802a56:	ff d0                	callq  *%rax
  802a58:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802a5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802a5f:	79 4a                	jns    802aab <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802a61:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802a64:	89 c6                	mov    %eax,%esi
  802a66:	48 bf 81 48 80 00 00 	movabs $0x804881,%rdi
  802a6d:	00 00 00 
  802a70:	b8 00 00 00 00       	mov    $0x0,%eax
  802a75:	48 ba ff 04 80 00 00 	movabs $0x8004ff,%rdx
  802a7c:	00 00 00 
  802a7f:	ff d2                	callq  *%rdx
			close(fd_src);
  802a81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a84:	89 c7                	mov    %eax,%edi
  802a86:	48 b8 26 20 80 00 00 	movabs $0x802026,%rax
  802a8d:	00 00 00 
  802a90:	ff d0                	callq  *%rax
			close(fd_dest);
  802a92:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a95:	89 c7                	mov    %eax,%edi
  802a97:	48 b8 26 20 80 00 00 	movabs $0x802026,%rax
  802a9e:	00 00 00 
  802aa1:	ff d0                	callq  *%rax
			return write_size;
  802aa3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802aa6:	e9 a1 00 00 00       	jmpq   802b4c <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802aab:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802ab2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab5:	ba 00 02 00 00       	mov    $0x200,%edx
  802aba:	48 89 ce             	mov    %rcx,%rsi
  802abd:	89 c7                	mov    %eax,%edi
  802abf:	48 b8 48 22 80 00 00 	movabs $0x802248,%rax
  802ac6:	00 00 00 
  802ac9:	ff d0                	callq  *%rax
  802acb:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802ace:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802ad2:	0f 8f 5f ff ff ff    	jg     802a37 <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  802ad8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802adc:	79 47                	jns    802b25 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802ade:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ae1:	89 c6                	mov    %eax,%esi
  802ae3:	48 bf 94 48 80 00 00 	movabs $0x804894,%rdi
  802aea:	00 00 00 
  802aed:	b8 00 00 00 00       	mov    $0x0,%eax
  802af2:	48 ba ff 04 80 00 00 	movabs $0x8004ff,%rdx
  802af9:	00 00 00 
  802afc:	ff d2                	callq  *%rdx
		close(fd_src);
  802afe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b01:	89 c7                	mov    %eax,%edi
  802b03:	48 b8 26 20 80 00 00 	movabs $0x802026,%rax
  802b0a:	00 00 00 
  802b0d:	ff d0                	callq  *%rax
		close(fd_dest);
  802b0f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b12:	89 c7                	mov    %eax,%edi
  802b14:	48 b8 26 20 80 00 00 	movabs $0x802026,%rax
  802b1b:	00 00 00 
  802b1e:	ff d0                	callq  *%rax
		return read_size;
  802b20:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b23:	eb 27                	jmp    802b4c <copy+0x1d9>
	}
	close(fd_src);
  802b25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b28:	89 c7                	mov    %eax,%edi
  802b2a:	48 b8 26 20 80 00 00 	movabs $0x802026,%rax
  802b31:	00 00 00 
  802b34:	ff d0                	callq  *%rax
	close(fd_dest);
  802b36:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b39:	89 c7                	mov    %eax,%edi
  802b3b:	48 b8 26 20 80 00 00 	movabs $0x802026,%rax
  802b42:	00 00 00 
  802b45:	ff d0                	callq  *%rax
	return 0;
  802b47:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802b4c:	c9                   	leaveq 
  802b4d:	c3                   	retq   

0000000000802b4e <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802b4e:	55                   	push   %rbp
  802b4f:	48 89 e5             	mov    %rsp,%rbp
  802b52:	48 83 ec 20          	sub    $0x20,%rsp
  802b56:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802b5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b5e:	8b 40 0c             	mov    0xc(%rax),%eax
  802b61:	85 c0                	test   %eax,%eax
  802b63:	7e 67                	jle    802bcc <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802b65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b69:	8b 40 04             	mov    0x4(%rax),%eax
  802b6c:	48 63 d0             	movslq %eax,%rdx
  802b6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b73:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802b77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b7b:	8b 00                	mov    (%rax),%eax
  802b7d:	48 89 ce             	mov    %rcx,%rsi
  802b80:	89 c7                	mov    %eax,%edi
  802b82:	48 b8 92 23 80 00 00 	movabs $0x802392,%rax
  802b89:	00 00 00 
  802b8c:	ff d0                	callq  *%rax
  802b8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802b91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b95:	7e 13                	jle    802baa <writebuf+0x5c>
			b->result += result;
  802b97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b9b:	8b 50 08             	mov    0x8(%rax),%edx
  802b9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba1:	01 c2                	add    %eax,%edx
  802ba3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ba7:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802baa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bae:	8b 40 04             	mov    0x4(%rax),%eax
  802bb1:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802bb4:	74 16                	je     802bcc <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802bb6:	b8 00 00 00 00       	mov    $0x0,%eax
  802bbb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bbf:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802bc3:	89 c2                	mov    %eax,%edx
  802bc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc9:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802bcc:	c9                   	leaveq 
  802bcd:	c3                   	retq   

0000000000802bce <putch>:

static void
putch(int ch, void *thunk)
{
  802bce:	55                   	push   %rbp
  802bcf:	48 89 e5             	mov    %rsp,%rbp
  802bd2:	48 83 ec 20          	sub    $0x20,%rsp
  802bd6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bd9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802bdd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802be1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802be5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802be9:	8b 40 04             	mov    0x4(%rax),%eax
  802bec:	8d 48 01             	lea    0x1(%rax),%ecx
  802bef:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802bf3:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802bf6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802bf9:	89 d1                	mov    %edx,%ecx
  802bfb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802bff:	48 98                	cltq   
  802c01:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802c05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c09:	8b 40 04             	mov    0x4(%rax),%eax
  802c0c:	3d 00 01 00 00       	cmp    $0x100,%eax
  802c11:	75 1e                	jne    802c31 <putch+0x63>
		writebuf(b);
  802c13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c17:	48 89 c7             	mov    %rax,%rdi
  802c1a:	48 b8 4e 2b 80 00 00 	movabs $0x802b4e,%rax
  802c21:	00 00 00 
  802c24:	ff d0                	callq  *%rax
		b->idx = 0;
  802c26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802c31:	c9                   	leaveq 
  802c32:	c3                   	retq   

0000000000802c33 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802c33:	55                   	push   %rbp
  802c34:	48 89 e5             	mov    %rsp,%rbp
  802c37:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802c3e:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802c44:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802c4b:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802c52:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802c58:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802c5e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802c65:	00 00 00 
	b.result = 0;
  802c68:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802c6f:	00 00 00 
	b.error = 1;
  802c72:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802c79:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802c7c:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802c83:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802c8a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802c91:	48 89 c6             	mov    %rax,%rsi
  802c94:	48 bf ce 2b 80 00 00 	movabs $0x802bce,%rdi
  802c9b:	00 00 00 
  802c9e:	48 b8 9e 08 80 00 00 	movabs $0x80089e,%rax
  802ca5:	00 00 00 
  802ca8:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802caa:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802cb0:	85 c0                	test   %eax,%eax
  802cb2:	7e 16                	jle    802cca <vfprintf+0x97>
		writebuf(&b);
  802cb4:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802cbb:	48 89 c7             	mov    %rax,%rdi
  802cbe:	48 b8 4e 2b 80 00 00 	movabs $0x802b4e,%rax
  802cc5:	00 00 00 
  802cc8:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802cca:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802cd0:	85 c0                	test   %eax,%eax
  802cd2:	74 08                	je     802cdc <vfprintf+0xa9>
  802cd4:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802cda:	eb 06                	jmp    802ce2 <vfprintf+0xaf>
  802cdc:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802ce2:	c9                   	leaveq 
  802ce3:	c3                   	retq   

0000000000802ce4 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802ce4:	55                   	push   %rbp
  802ce5:	48 89 e5             	mov    %rsp,%rbp
  802ce8:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802cef:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802cf5:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802cfc:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802d03:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802d0a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802d11:	84 c0                	test   %al,%al
  802d13:	74 20                	je     802d35 <fprintf+0x51>
  802d15:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802d19:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802d1d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802d21:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802d25:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802d29:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802d2d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802d31:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802d35:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802d3c:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802d43:	00 00 00 
  802d46:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802d4d:	00 00 00 
  802d50:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802d54:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802d5b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802d62:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802d69:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802d70:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  802d77:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802d7d:	48 89 ce             	mov    %rcx,%rsi
  802d80:	89 c7                	mov    %eax,%edi
  802d82:	48 b8 33 2c 80 00 00 	movabs $0x802c33,%rax
  802d89:	00 00 00 
  802d8c:	ff d0                	callq  *%rax
  802d8e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802d94:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802d9a:	c9                   	leaveq 
  802d9b:	c3                   	retq   

0000000000802d9c <printf>:

int
printf(const char *fmt, ...)
{
  802d9c:	55                   	push   %rbp
  802d9d:	48 89 e5             	mov    %rsp,%rbp
  802da0:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802da7:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802dae:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802db5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802dbc:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802dc3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802dca:	84 c0                	test   %al,%al
  802dcc:	74 20                	je     802dee <printf+0x52>
  802dce:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802dd2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802dd6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802dda:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802dde:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802de2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802de6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802dea:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802dee:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802df5:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802dfc:	00 00 00 
  802dff:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802e06:	00 00 00 
  802e09:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802e0d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802e14:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802e1b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  802e22:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802e29:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802e30:	48 89 c6             	mov    %rax,%rsi
  802e33:	bf 01 00 00 00       	mov    $0x1,%edi
  802e38:	48 b8 33 2c 80 00 00 	movabs $0x802c33,%rax
  802e3f:	00 00 00 
  802e42:	ff d0                	callq  *%rax
  802e44:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802e4a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802e50:	c9                   	leaveq 
  802e51:	c3                   	retq   

0000000000802e52 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802e52:	55                   	push   %rbp
  802e53:	48 89 e5             	mov    %rsp,%rbp
  802e56:	48 83 ec 20          	sub    $0x20,%rsp
  802e5a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802e5d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e61:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e64:	48 89 d6             	mov    %rdx,%rsi
  802e67:	89 c7                	mov    %eax,%edi
  802e69:	48 b8 14 1e 80 00 00 	movabs $0x801e14,%rax
  802e70:	00 00 00 
  802e73:	ff d0                	callq  *%rax
  802e75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e7c:	79 05                	jns    802e83 <fd2sockid+0x31>
		return r;
  802e7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e81:	eb 24                	jmp    802ea7 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802e83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e87:	8b 10                	mov    (%rax),%edx
  802e89:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802e90:	00 00 00 
  802e93:	8b 00                	mov    (%rax),%eax
  802e95:	39 c2                	cmp    %eax,%edx
  802e97:	74 07                	je     802ea0 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802e99:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e9e:	eb 07                	jmp    802ea7 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802ea0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ea4:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802ea7:	c9                   	leaveq 
  802ea8:	c3                   	retq   

0000000000802ea9 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802ea9:	55                   	push   %rbp
  802eaa:	48 89 e5             	mov    %rsp,%rbp
  802ead:	48 83 ec 20          	sub    $0x20,%rsp
  802eb1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802eb4:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802eb8:	48 89 c7             	mov    %rax,%rdi
  802ebb:	48 b8 7c 1d 80 00 00 	movabs $0x801d7c,%rax
  802ec2:	00 00 00 
  802ec5:	ff d0                	callq  *%rax
  802ec7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ece:	78 26                	js     802ef6 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802ed0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ed4:	ba 07 04 00 00       	mov    $0x407,%edx
  802ed9:	48 89 c6             	mov    %rax,%rsi
  802edc:	bf 00 00 00 00       	mov    $0x0,%edi
  802ee1:	48 b8 c6 19 80 00 00 	movabs $0x8019c6,%rax
  802ee8:	00 00 00 
  802eeb:	ff d0                	callq  *%rax
  802eed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ef0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ef4:	79 16                	jns    802f0c <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802ef6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ef9:	89 c7                	mov    %eax,%edi
  802efb:	48 b8 b8 33 80 00 00 	movabs $0x8033b8,%rax
  802f02:	00 00 00 
  802f05:	ff d0                	callq  *%rax
		return r;
  802f07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f0a:	eb 3a                	jmp    802f46 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802f0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f10:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802f17:	00 00 00 
  802f1a:	8b 12                	mov    (%rdx),%edx
  802f1c:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802f1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f22:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802f29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f2d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802f30:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802f33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f37:	48 89 c7             	mov    %rax,%rdi
  802f3a:	48 b8 2e 1d 80 00 00 	movabs $0x801d2e,%rax
  802f41:	00 00 00 
  802f44:	ff d0                	callq  *%rax
}
  802f46:	c9                   	leaveq 
  802f47:	c3                   	retq   

0000000000802f48 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802f48:	55                   	push   %rbp
  802f49:	48 89 e5             	mov    %rsp,%rbp
  802f4c:	48 83 ec 30          	sub    $0x30,%rsp
  802f50:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f53:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f57:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f5b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f5e:	89 c7                	mov    %eax,%edi
  802f60:	48 b8 52 2e 80 00 00 	movabs $0x802e52,%rax
  802f67:	00 00 00 
  802f6a:	ff d0                	callq  *%rax
  802f6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f73:	79 05                	jns    802f7a <accept+0x32>
		return r;
  802f75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f78:	eb 3b                	jmp    802fb5 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802f7a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f7e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f85:	48 89 ce             	mov    %rcx,%rsi
  802f88:	89 c7                	mov    %eax,%edi
  802f8a:	48 b8 95 32 80 00 00 	movabs $0x803295,%rax
  802f91:	00 00 00 
  802f94:	ff d0                	callq  *%rax
  802f96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f9d:	79 05                	jns    802fa4 <accept+0x5c>
		return r;
  802f9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa2:	eb 11                	jmp    802fb5 <accept+0x6d>
	return alloc_sockfd(r);
  802fa4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa7:	89 c7                	mov    %eax,%edi
  802fa9:	48 b8 a9 2e 80 00 00 	movabs $0x802ea9,%rax
  802fb0:	00 00 00 
  802fb3:	ff d0                	callq  *%rax
}
  802fb5:	c9                   	leaveq 
  802fb6:	c3                   	retq   

0000000000802fb7 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802fb7:	55                   	push   %rbp
  802fb8:	48 89 e5             	mov    %rsp,%rbp
  802fbb:	48 83 ec 20          	sub    $0x20,%rsp
  802fbf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fc2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fc6:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fc9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fcc:	89 c7                	mov    %eax,%edi
  802fce:	48 b8 52 2e 80 00 00 	movabs $0x802e52,%rax
  802fd5:	00 00 00 
  802fd8:	ff d0                	callq  *%rax
  802fda:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fdd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fe1:	79 05                	jns    802fe8 <bind+0x31>
		return r;
  802fe3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fe6:	eb 1b                	jmp    803003 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802fe8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802feb:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802fef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff2:	48 89 ce             	mov    %rcx,%rsi
  802ff5:	89 c7                	mov    %eax,%edi
  802ff7:	48 b8 14 33 80 00 00 	movabs $0x803314,%rax
  802ffe:	00 00 00 
  803001:	ff d0                	callq  *%rax
}
  803003:	c9                   	leaveq 
  803004:	c3                   	retq   

0000000000803005 <shutdown>:

int
shutdown(int s, int how)
{
  803005:	55                   	push   %rbp
  803006:	48 89 e5             	mov    %rsp,%rbp
  803009:	48 83 ec 20          	sub    $0x20,%rsp
  80300d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803010:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803013:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803016:	89 c7                	mov    %eax,%edi
  803018:	48 b8 52 2e 80 00 00 	movabs $0x802e52,%rax
  80301f:	00 00 00 
  803022:	ff d0                	callq  *%rax
  803024:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803027:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80302b:	79 05                	jns    803032 <shutdown+0x2d>
		return r;
  80302d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803030:	eb 16                	jmp    803048 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803032:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803035:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803038:	89 d6                	mov    %edx,%esi
  80303a:	89 c7                	mov    %eax,%edi
  80303c:	48 b8 78 33 80 00 00 	movabs $0x803378,%rax
  803043:	00 00 00 
  803046:	ff d0                	callq  *%rax
}
  803048:	c9                   	leaveq 
  803049:	c3                   	retq   

000000000080304a <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80304a:	55                   	push   %rbp
  80304b:	48 89 e5             	mov    %rsp,%rbp
  80304e:	48 83 ec 10          	sub    $0x10,%rsp
  803052:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803056:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80305a:	48 89 c7             	mov    %rax,%rdi
  80305d:	48 b8 17 41 80 00 00 	movabs $0x804117,%rax
  803064:	00 00 00 
  803067:	ff d0                	callq  *%rax
  803069:	83 f8 01             	cmp    $0x1,%eax
  80306c:	75 17                	jne    803085 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80306e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803072:	8b 40 0c             	mov    0xc(%rax),%eax
  803075:	89 c7                	mov    %eax,%edi
  803077:	48 b8 b8 33 80 00 00 	movabs $0x8033b8,%rax
  80307e:	00 00 00 
  803081:	ff d0                	callq  *%rax
  803083:	eb 05                	jmp    80308a <devsock_close+0x40>
	else
		return 0;
  803085:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80308a:	c9                   	leaveq 
  80308b:	c3                   	retq   

000000000080308c <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80308c:	55                   	push   %rbp
  80308d:	48 89 e5             	mov    %rsp,%rbp
  803090:	48 83 ec 20          	sub    $0x20,%rsp
  803094:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803097:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80309b:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80309e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030a1:	89 c7                	mov    %eax,%edi
  8030a3:	48 b8 52 2e 80 00 00 	movabs $0x802e52,%rax
  8030aa:	00 00 00 
  8030ad:	ff d0                	callq  *%rax
  8030af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030b6:	79 05                	jns    8030bd <connect+0x31>
		return r;
  8030b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030bb:	eb 1b                	jmp    8030d8 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8030bd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030c0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8030c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030c7:	48 89 ce             	mov    %rcx,%rsi
  8030ca:	89 c7                	mov    %eax,%edi
  8030cc:	48 b8 e5 33 80 00 00 	movabs $0x8033e5,%rax
  8030d3:	00 00 00 
  8030d6:	ff d0                	callq  *%rax
}
  8030d8:	c9                   	leaveq 
  8030d9:	c3                   	retq   

00000000008030da <listen>:

int
listen(int s, int backlog)
{
  8030da:	55                   	push   %rbp
  8030db:	48 89 e5             	mov    %rsp,%rbp
  8030de:	48 83 ec 20          	sub    $0x20,%rsp
  8030e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030e5:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8030e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030eb:	89 c7                	mov    %eax,%edi
  8030ed:	48 b8 52 2e 80 00 00 	movabs $0x802e52,%rax
  8030f4:	00 00 00 
  8030f7:	ff d0                	callq  *%rax
  8030f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803100:	79 05                	jns    803107 <listen+0x2d>
		return r;
  803102:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803105:	eb 16                	jmp    80311d <listen+0x43>
	return nsipc_listen(r, backlog);
  803107:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80310a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80310d:	89 d6                	mov    %edx,%esi
  80310f:	89 c7                	mov    %eax,%edi
  803111:	48 b8 49 34 80 00 00 	movabs $0x803449,%rax
  803118:	00 00 00 
  80311b:	ff d0                	callq  *%rax
}
  80311d:	c9                   	leaveq 
  80311e:	c3                   	retq   

000000000080311f <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80311f:	55                   	push   %rbp
  803120:	48 89 e5             	mov    %rsp,%rbp
  803123:	48 83 ec 20          	sub    $0x20,%rsp
  803127:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80312b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80312f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803133:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803137:	89 c2                	mov    %eax,%edx
  803139:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80313d:	8b 40 0c             	mov    0xc(%rax),%eax
  803140:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803144:	b9 00 00 00 00       	mov    $0x0,%ecx
  803149:	89 c7                	mov    %eax,%edi
  80314b:	48 b8 89 34 80 00 00 	movabs $0x803489,%rax
  803152:	00 00 00 
  803155:	ff d0                	callq  *%rax
}
  803157:	c9                   	leaveq 
  803158:	c3                   	retq   

0000000000803159 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803159:	55                   	push   %rbp
  80315a:	48 89 e5             	mov    %rsp,%rbp
  80315d:	48 83 ec 20          	sub    $0x20,%rsp
  803161:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803165:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803169:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80316d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803171:	89 c2                	mov    %eax,%edx
  803173:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803177:	8b 40 0c             	mov    0xc(%rax),%eax
  80317a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80317e:	b9 00 00 00 00       	mov    $0x0,%ecx
  803183:	89 c7                	mov    %eax,%edi
  803185:	48 b8 55 35 80 00 00 	movabs $0x803555,%rax
  80318c:	00 00 00 
  80318f:	ff d0                	callq  *%rax
}
  803191:	c9                   	leaveq 
  803192:	c3                   	retq   

0000000000803193 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803193:	55                   	push   %rbp
  803194:	48 89 e5             	mov    %rsp,%rbp
  803197:	48 83 ec 10          	sub    $0x10,%rsp
  80319b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80319f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8031a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031a7:	48 be af 48 80 00 00 	movabs $0x8048af,%rsi
  8031ae:	00 00 00 
  8031b1:	48 89 c7             	mov    %rax,%rdi
  8031b4:	48 b8 99 10 80 00 00 	movabs $0x801099,%rax
  8031bb:	00 00 00 
  8031be:	ff d0                	callq  *%rax
	return 0;
  8031c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031c5:	c9                   	leaveq 
  8031c6:	c3                   	retq   

00000000008031c7 <socket>:

int
socket(int domain, int type, int protocol)
{
  8031c7:	55                   	push   %rbp
  8031c8:	48 89 e5             	mov    %rsp,%rbp
  8031cb:	48 83 ec 20          	sub    $0x20,%rsp
  8031cf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031d2:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8031d5:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8031d8:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8031db:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8031de:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031e1:	89 ce                	mov    %ecx,%esi
  8031e3:	89 c7                	mov    %eax,%edi
  8031e5:	48 b8 0d 36 80 00 00 	movabs $0x80360d,%rax
  8031ec:	00 00 00 
  8031ef:	ff d0                	callq  *%rax
  8031f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031f8:	79 05                	jns    8031ff <socket+0x38>
		return r;
  8031fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031fd:	eb 11                	jmp    803210 <socket+0x49>
	return alloc_sockfd(r);
  8031ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803202:	89 c7                	mov    %eax,%edi
  803204:	48 b8 a9 2e 80 00 00 	movabs $0x802ea9,%rax
  80320b:	00 00 00 
  80320e:	ff d0                	callq  *%rax
}
  803210:	c9                   	leaveq 
  803211:	c3                   	retq   

0000000000803212 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803212:	55                   	push   %rbp
  803213:	48 89 e5             	mov    %rsp,%rbp
  803216:	48 83 ec 10          	sub    $0x10,%rsp
  80321a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80321d:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803224:	00 00 00 
  803227:	8b 00                	mov    (%rax),%eax
  803229:	85 c0                	test   %eax,%eax
  80322b:	75 1f                	jne    80324c <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80322d:	bf 02 00 00 00       	mov    $0x2,%edi
  803232:	48 b8 a5 40 80 00 00 	movabs $0x8040a5,%rax
  803239:	00 00 00 
  80323c:	ff d0                	callq  *%rax
  80323e:	89 c2                	mov    %eax,%edx
  803240:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803247:	00 00 00 
  80324a:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80324c:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803253:	00 00 00 
  803256:	8b 00                	mov    (%rax),%eax
  803258:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80325b:	b9 07 00 00 00       	mov    $0x7,%ecx
  803260:	48 ba 00 c0 80 00 00 	movabs $0x80c000,%rdx
  803267:	00 00 00 
  80326a:	89 c7                	mov    %eax,%edi
  80326c:	48 b8 18 3f 80 00 00 	movabs $0x803f18,%rax
  803273:	00 00 00 
  803276:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803278:	ba 00 00 00 00       	mov    $0x0,%edx
  80327d:	be 00 00 00 00       	mov    $0x0,%esi
  803282:	bf 00 00 00 00       	mov    $0x0,%edi
  803287:	48 b8 da 3e 80 00 00 	movabs $0x803eda,%rax
  80328e:	00 00 00 
  803291:	ff d0                	callq  *%rax
}
  803293:	c9                   	leaveq 
  803294:	c3                   	retq   

0000000000803295 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803295:	55                   	push   %rbp
  803296:	48 89 e5             	mov    %rsp,%rbp
  803299:	48 83 ec 30          	sub    $0x30,%rsp
  80329d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032a4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8032a8:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8032af:	00 00 00 
  8032b2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8032b5:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8032b7:	bf 01 00 00 00       	mov    $0x1,%edi
  8032bc:	48 b8 12 32 80 00 00 	movabs $0x803212,%rax
  8032c3:	00 00 00 
  8032c6:	ff d0                	callq  *%rax
  8032c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032cf:	78 3e                	js     80330f <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8032d1:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8032d8:	00 00 00 
  8032db:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8032df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e3:	8b 40 10             	mov    0x10(%rax),%eax
  8032e6:	89 c2                	mov    %eax,%edx
  8032e8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8032ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032f0:	48 89 ce             	mov    %rcx,%rsi
  8032f3:	48 89 c7             	mov    %rax,%rdi
  8032f6:	48 b8 bd 13 80 00 00 	movabs $0x8013bd,%rax
  8032fd:	00 00 00 
  803300:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803302:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803306:	8b 50 10             	mov    0x10(%rax),%edx
  803309:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80330d:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80330f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803312:	c9                   	leaveq 
  803313:	c3                   	retq   

0000000000803314 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803314:	55                   	push   %rbp
  803315:	48 89 e5             	mov    %rsp,%rbp
  803318:	48 83 ec 10          	sub    $0x10,%rsp
  80331c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80331f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803323:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803326:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80332d:	00 00 00 
  803330:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803333:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803335:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803338:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80333c:	48 89 c6             	mov    %rax,%rsi
  80333f:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  803346:	00 00 00 
  803349:	48 b8 bd 13 80 00 00 	movabs $0x8013bd,%rax
  803350:	00 00 00 
  803353:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803355:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80335c:	00 00 00 
  80335f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803362:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803365:	bf 02 00 00 00       	mov    $0x2,%edi
  80336a:	48 b8 12 32 80 00 00 	movabs $0x803212,%rax
  803371:	00 00 00 
  803374:	ff d0                	callq  *%rax
}
  803376:	c9                   	leaveq 
  803377:	c3                   	retq   

0000000000803378 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803378:	55                   	push   %rbp
  803379:	48 89 e5             	mov    %rsp,%rbp
  80337c:	48 83 ec 10          	sub    $0x10,%rsp
  803380:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803383:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803386:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80338d:	00 00 00 
  803390:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803393:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803395:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80339c:	00 00 00 
  80339f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033a2:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8033a5:	bf 03 00 00 00       	mov    $0x3,%edi
  8033aa:	48 b8 12 32 80 00 00 	movabs $0x803212,%rax
  8033b1:	00 00 00 
  8033b4:	ff d0                	callq  *%rax
}
  8033b6:	c9                   	leaveq 
  8033b7:	c3                   	retq   

00000000008033b8 <nsipc_close>:

int
nsipc_close(int s)
{
  8033b8:	55                   	push   %rbp
  8033b9:	48 89 e5             	mov    %rsp,%rbp
  8033bc:	48 83 ec 10          	sub    $0x10,%rsp
  8033c0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8033c3:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8033ca:	00 00 00 
  8033cd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033d0:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8033d2:	bf 04 00 00 00       	mov    $0x4,%edi
  8033d7:	48 b8 12 32 80 00 00 	movabs $0x803212,%rax
  8033de:	00 00 00 
  8033e1:	ff d0                	callq  *%rax
}
  8033e3:	c9                   	leaveq 
  8033e4:	c3                   	retq   

00000000008033e5 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8033e5:	55                   	push   %rbp
  8033e6:	48 89 e5             	mov    %rsp,%rbp
  8033e9:	48 83 ec 10          	sub    $0x10,%rsp
  8033ed:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033f0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033f4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8033f7:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8033fe:	00 00 00 
  803401:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803404:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803406:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803409:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80340d:	48 89 c6             	mov    %rax,%rsi
  803410:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  803417:	00 00 00 
  80341a:	48 b8 bd 13 80 00 00 	movabs $0x8013bd,%rax
  803421:	00 00 00 
  803424:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803426:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80342d:	00 00 00 
  803430:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803433:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803436:	bf 05 00 00 00       	mov    $0x5,%edi
  80343b:	48 b8 12 32 80 00 00 	movabs $0x803212,%rax
  803442:	00 00 00 
  803445:	ff d0                	callq  *%rax
}
  803447:	c9                   	leaveq 
  803448:	c3                   	retq   

0000000000803449 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803449:	55                   	push   %rbp
  80344a:	48 89 e5             	mov    %rsp,%rbp
  80344d:	48 83 ec 10          	sub    $0x10,%rsp
  803451:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803454:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803457:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80345e:	00 00 00 
  803461:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803464:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803466:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80346d:	00 00 00 
  803470:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803473:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803476:	bf 06 00 00 00       	mov    $0x6,%edi
  80347b:	48 b8 12 32 80 00 00 	movabs $0x803212,%rax
  803482:	00 00 00 
  803485:	ff d0                	callq  *%rax
}
  803487:	c9                   	leaveq 
  803488:	c3                   	retq   

0000000000803489 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803489:	55                   	push   %rbp
  80348a:	48 89 e5             	mov    %rsp,%rbp
  80348d:	48 83 ec 30          	sub    $0x30,%rsp
  803491:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803494:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803498:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80349b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80349e:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8034a5:	00 00 00 
  8034a8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8034ab:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8034ad:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8034b4:	00 00 00 
  8034b7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034ba:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8034bd:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8034c4:	00 00 00 
  8034c7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8034ca:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8034cd:	bf 07 00 00 00       	mov    $0x7,%edi
  8034d2:	48 b8 12 32 80 00 00 	movabs $0x803212,%rax
  8034d9:	00 00 00 
  8034dc:	ff d0                	callq  *%rax
  8034de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034e5:	78 69                	js     803550 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8034e7:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8034ee:	7f 08                	jg     8034f8 <nsipc_recv+0x6f>
  8034f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f3:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8034f6:	7e 35                	jle    80352d <nsipc_recv+0xa4>
  8034f8:	48 b9 b6 48 80 00 00 	movabs $0x8048b6,%rcx
  8034ff:	00 00 00 
  803502:	48 ba cb 48 80 00 00 	movabs $0x8048cb,%rdx
  803509:	00 00 00 
  80350c:	be 61 00 00 00       	mov    $0x61,%esi
  803511:	48 bf e0 48 80 00 00 	movabs $0x8048e0,%rdi
  803518:	00 00 00 
  80351b:	b8 00 00 00 00       	mov    $0x0,%eax
  803520:	49 b8 c6 02 80 00 00 	movabs $0x8002c6,%r8
  803527:	00 00 00 
  80352a:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80352d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803530:	48 63 d0             	movslq %eax,%rdx
  803533:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803537:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  80353e:	00 00 00 
  803541:	48 89 c7             	mov    %rax,%rdi
  803544:	48 b8 bd 13 80 00 00 	movabs $0x8013bd,%rax
  80354b:	00 00 00 
  80354e:	ff d0                	callq  *%rax
	}

	return r;
  803550:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803553:	c9                   	leaveq 
  803554:	c3                   	retq   

0000000000803555 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803555:	55                   	push   %rbp
  803556:	48 89 e5             	mov    %rsp,%rbp
  803559:	48 83 ec 20          	sub    $0x20,%rsp
  80355d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803560:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803564:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803567:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80356a:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803571:	00 00 00 
  803574:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803577:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803579:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803580:	7e 35                	jle    8035b7 <nsipc_send+0x62>
  803582:	48 b9 ec 48 80 00 00 	movabs $0x8048ec,%rcx
  803589:	00 00 00 
  80358c:	48 ba cb 48 80 00 00 	movabs $0x8048cb,%rdx
  803593:	00 00 00 
  803596:	be 6c 00 00 00       	mov    $0x6c,%esi
  80359b:	48 bf e0 48 80 00 00 	movabs $0x8048e0,%rdi
  8035a2:	00 00 00 
  8035a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8035aa:	49 b8 c6 02 80 00 00 	movabs $0x8002c6,%r8
  8035b1:	00 00 00 
  8035b4:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8035b7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035ba:	48 63 d0             	movslq %eax,%rdx
  8035bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035c1:	48 89 c6             	mov    %rax,%rsi
  8035c4:	48 bf 0c c0 80 00 00 	movabs $0x80c00c,%rdi
  8035cb:	00 00 00 
  8035ce:	48 b8 bd 13 80 00 00 	movabs $0x8013bd,%rax
  8035d5:	00 00 00 
  8035d8:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8035da:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8035e1:	00 00 00 
  8035e4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035e7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8035ea:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8035f1:	00 00 00 
  8035f4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8035f7:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8035fa:	bf 08 00 00 00       	mov    $0x8,%edi
  8035ff:	48 b8 12 32 80 00 00 	movabs $0x803212,%rax
  803606:	00 00 00 
  803609:	ff d0                	callq  *%rax
}
  80360b:	c9                   	leaveq 
  80360c:	c3                   	retq   

000000000080360d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80360d:	55                   	push   %rbp
  80360e:	48 89 e5             	mov    %rsp,%rbp
  803611:	48 83 ec 10          	sub    $0x10,%rsp
  803615:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803618:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80361b:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80361e:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803625:	00 00 00 
  803628:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80362b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80362d:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803634:	00 00 00 
  803637:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80363a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80363d:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803644:	00 00 00 
  803647:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80364a:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  80364d:	bf 09 00 00 00       	mov    $0x9,%edi
  803652:	48 b8 12 32 80 00 00 	movabs $0x803212,%rax
  803659:	00 00 00 
  80365c:	ff d0                	callq  *%rax
}
  80365e:	c9                   	leaveq 
  80365f:	c3                   	retq   

0000000000803660 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803660:	55                   	push   %rbp
  803661:	48 89 e5             	mov    %rsp,%rbp
  803664:	53                   	push   %rbx
  803665:	48 83 ec 38          	sub    $0x38,%rsp
  803669:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80366d:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803671:	48 89 c7             	mov    %rax,%rdi
  803674:	48 b8 7c 1d 80 00 00 	movabs $0x801d7c,%rax
  80367b:	00 00 00 
  80367e:	ff d0                	callq  *%rax
  803680:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803683:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803687:	0f 88 bf 01 00 00    	js     80384c <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80368d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803691:	ba 07 04 00 00       	mov    $0x407,%edx
  803696:	48 89 c6             	mov    %rax,%rsi
  803699:	bf 00 00 00 00       	mov    $0x0,%edi
  80369e:	48 b8 c6 19 80 00 00 	movabs $0x8019c6,%rax
  8036a5:	00 00 00 
  8036a8:	ff d0                	callq  *%rax
  8036aa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036b1:	0f 88 95 01 00 00    	js     80384c <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8036b7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8036bb:	48 89 c7             	mov    %rax,%rdi
  8036be:	48 b8 7c 1d 80 00 00 	movabs $0x801d7c,%rax
  8036c5:	00 00 00 
  8036c8:	ff d0                	callq  *%rax
  8036ca:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036d1:	0f 88 5d 01 00 00    	js     803834 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036d7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036db:	ba 07 04 00 00       	mov    $0x407,%edx
  8036e0:	48 89 c6             	mov    %rax,%rsi
  8036e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8036e8:	48 b8 c6 19 80 00 00 	movabs $0x8019c6,%rax
  8036ef:	00 00 00 
  8036f2:	ff d0                	callq  *%rax
  8036f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036fb:	0f 88 33 01 00 00    	js     803834 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803701:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803705:	48 89 c7             	mov    %rax,%rdi
  803708:	48 b8 51 1d 80 00 00 	movabs $0x801d51,%rax
  80370f:	00 00 00 
  803712:	ff d0                	callq  *%rax
  803714:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803718:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80371c:	ba 07 04 00 00       	mov    $0x407,%edx
  803721:	48 89 c6             	mov    %rax,%rsi
  803724:	bf 00 00 00 00       	mov    $0x0,%edi
  803729:	48 b8 c6 19 80 00 00 	movabs $0x8019c6,%rax
  803730:	00 00 00 
  803733:	ff d0                	callq  *%rax
  803735:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803738:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80373c:	79 05                	jns    803743 <pipe+0xe3>
		goto err2;
  80373e:	e9 d9 00 00 00       	jmpq   80381c <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803743:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803747:	48 89 c7             	mov    %rax,%rdi
  80374a:	48 b8 51 1d 80 00 00 	movabs $0x801d51,%rax
  803751:	00 00 00 
  803754:	ff d0                	callq  *%rax
  803756:	48 89 c2             	mov    %rax,%rdx
  803759:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80375d:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803763:	48 89 d1             	mov    %rdx,%rcx
  803766:	ba 00 00 00 00       	mov    $0x0,%edx
  80376b:	48 89 c6             	mov    %rax,%rsi
  80376e:	bf 00 00 00 00       	mov    $0x0,%edi
  803773:	48 b8 18 1a 80 00 00 	movabs $0x801a18,%rax
  80377a:	00 00 00 
  80377d:	ff d0                	callq  *%rax
  80377f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803782:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803786:	79 1b                	jns    8037a3 <pipe+0x143>
		goto err3;
  803788:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803789:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80378d:	48 89 c6             	mov    %rax,%rsi
  803790:	bf 00 00 00 00       	mov    $0x0,%edi
  803795:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  80379c:	00 00 00 
  80379f:	ff d0                	callq  *%rax
  8037a1:	eb 79                	jmp    80381c <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  8037a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037a7:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8037ae:	00 00 00 
  8037b1:	8b 12                	mov    (%rdx),%edx
  8037b3:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8037b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037b9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  8037c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037c4:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8037cb:	00 00 00 
  8037ce:	8b 12                	mov    (%rdx),%edx
  8037d0:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8037d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037d6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  8037dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037e1:	48 89 c7             	mov    %rax,%rdi
  8037e4:	48 b8 2e 1d 80 00 00 	movabs $0x801d2e,%rax
  8037eb:	00 00 00 
  8037ee:	ff d0                	callq  *%rax
  8037f0:	89 c2                	mov    %eax,%edx
  8037f2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8037f6:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8037f8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8037fc:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803800:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803804:	48 89 c7             	mov    %rax,%rdi
  803807:	48 b8 2e 1d 80 00 00 	movabs $0x801d2e,%rax
  80380e:	00 00 00 
  803811:	ff d0                	callq  *%rax
  803813:	89 03                	mov    %eax,(%rbx)
	return 0;
  803815:	b8 00 00 00 00       	mov    $0x0,%eax
  80381a:	eb 33                	jmp    80384f <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  80381c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803820:	48 89 c6             	mov    %rax,%rsi
  803823:	bf 00 00 00 00       	mov    $0x0,%edi
  803828:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  80382f:	00 00 00 
  803832:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803834:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803838:	48 89 c6             	mov    %rax,%rsi
  80383b:	bf 00 00 00 00       	mov    $0x0,%edi
  803840:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  803847:	00 00 00 
  80384a:	ff d0                	callq  *%rax
err:
	return r;
  80384c:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80384f:	48 83 c4 38          	add    $0x38,%rsp
  803853:	5b                   	pop    %rbx
  803854:	5d                   	pop    %rbp
  803855:	c3                   	retq   

0000000000803856 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803856:	55                   	push   %rbp
  803857:	48 89 e5             	mov    %rsp,%rbp
  80385a:	53                   	push   %rbx
  80385b:	48 83 ec 28          	sub    $0x28,%rsp
  80385f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803863:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803867:	48 b8 40 90 80 00 00 	movabs $0x809040,%rax
  80386e:	00 00 00 
  803871:	48 8b 00             	mov    (%rax),%rax
  803874:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80387a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80387d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803881:	48 89 c7             	mov    %rax,%rdi
  803884:	48 b8 17 41 80 00 00 	movabs $0x804117,%rax
  80388b:	00 00 00 
  80388e:	ff d0                	callq  *%rax
  803890:	89 c3                	mov    %eax,%ebx
  803892:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803896:	48 89 c7             	mov    %rax,%rdi
  803899:	48 b8 17 41 80 00 00 	movabs $0x804117,%rax
  8038a0:	00 00 00 
  8038a3:	ff d0                	callq  *%rax
  8038a5:	39 c3                	cmp    %eax,%ebx
  8038a7:	0f 94 c0             	sete   %al
  8038aa:	0f b6 c0             	movzbl %al,%eax
  8038ad:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8038b0:	48 b8 40 90 80 00 00 	movabs $0x809040,%rax
  8038b7:	00 00 00 
  8038ba:	48 8b 00             	mov    (%rax),%rax
  8038bd:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8038c3:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8038c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038c9:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8038cc:	75 05                	jne    8038d3 <_pipeisclosed+0x7d>
			return ret;
  8038ce:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8038d1:	eb 4a                	jmp    80391d <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  8038d3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038d6:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8038d9:	74 3d                	je     803918 <_pipeisclosed+0xc2>
  8038db:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8038df:	75 37                	jne    803918 <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8038e1:	48 b8 40 90 80 00 00 	movabs $0x809040,%rax
  8038e8:	00 00 00 
  8038eb:	48 8b 00             	mov    (%rax),%rax
  8038ee:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8038f4:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8038f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038fa:	89 c6                	mov    %eax,%esi
  8038fc:	48 bf fd 48 80 00 00 	movabs $0x8048fd,%rdi
  803903:	00 00 00 
  803906:	b8 00 00 00 00       	mov    $0x0,%eax
  80390b:	49 b8 ff 04 80 00 00 	movabs $0x8004ff,%r8
  803912:	00 00 00 
  803915:	41 ff d0             	callq  *%r8
	}
  803918:	e9 4a ff ff ff       	jmpq   803867 <_pipeisclosed+0x11>
}
  80391d:	48 83 c4 28          	add    $0x28,%rsp
  803921:	5b                   	pop    %rbx
  803922:	5d                   	pop    %rbp
  803923:	c3                   	retq   

0000000000803924 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803924:	55                   	push   %rbp
  803925:	48 89 e5             	mov    %rsp,%rbp
  803928:	48 83 ec 30          	sub    $0x30,%rsp
  80392c:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80392f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803933:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803936:	48 89 d6             	mov    %rdx,%rsi
  803939:	89 c7                	mov    %eax,%edi
  80393b:	48 b8 14 1e 80 00 00 	movabs $0x801e14,%rax
  803942:	00 00 00 
  803945:	ff d0                	callq  *%rax
  803947:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80394a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80394e:	79 05                	jns    803955 <pipeisclosed+0x31>
		return r;
  803950:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803953:	eb 31                	jmp    803986 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803955:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803959:	48 89 c7             	mov    %rax,%rdi
  80395c:	48 b8 51 1d 80 00 00 	movabs $0x801d51,%rax
  803963:	00 00 00 
  803966:	ff d0                	callq  *%rax
  803968:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80396c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803970:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803974:	48 89 d6             	mov    %rdx,%rsi
  803977:	48 89 c7             	mov    %rax,%rdi
  80397a:	48 b8 56 38 80 00 00 	movabs $0x803856,%rax
  803981:	00 00 00 
  803984:	ff d0                	callq  *%rax
}
  803986:	c9                   	leaveq 
  803987:	c3                   	retq   

0000000000803988 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803988:	55                   	push   %rbp
  803989:	48 89 e5             	mov    %rsp,%rbp
  80398c:	48 83 ec 40          	sub    $0x40,%rsp
  803990:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803994:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803998:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80399c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039a0:	48 89 c7             	mov    %rax,%rdi
  8039a3:	48 b8 51 1d 80 00 00 	movabs $0x801d51,%rax
  8039aa:	00 00 00 
  8039ad:	ff d0                	callq  *%rax
  8039af:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8039b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039b7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8039bb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8039c2:	00 
  8039c3:	e9 92 00 00 00       	jmpq   803a5a <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8039c8:	eb 41                	jmp    803a0b <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8039ca:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8039cf:	74 09                	je     8039da <devpipe_read+0x52>
				return i;
  8039d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039d5:	e9 92 00 00 00       	jmpq   803a6c <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8039da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039e2:	48 89 d6             	mov    %rdx,%rsi
  8039e5:	48 89 c7             	mov    %rax,%rdi
  8039e8:	48 b8 56 38 80 00 00 	movabs $0x803856,%rax
  8039ef:	00 00 00 
  8039f2:	ff d0                	callq  *%rax
  8039f4:	85 c0                	test   %eax,%eax
  8039f6:	74 07                	je     8039ff <devpipe_read+0x77>
				return 0;
  8039f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8039fd:	eb 6d                	jmp    803a6c <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8039ff:	48 b8 8a 19 80 00 00 	movabs $0x80198a,%rax
  803a06:	00 00 00 
  803a09:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  803a0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a0f:	8b 10                	mov    (%rax),%edx
  803a11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a15:	8b 40 04             	mov    0x4(%rax),%eax
  803a18:	39 c2                	cmp    %eax,%edx
  803a1a:	74 ae                	je     8039ca <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803a1c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a24:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803a28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a2c:	8b 00                	mov    (%rax),%eax
  803a2e:	99                   	cltd   
  803a2f:	c1 ea 1b             	shr    $0x1b,%edx
  803a32:	01 d0                	add    %edx,%eax
  803a34:	83 e0 1f             	and    $0x1f,%eax
  803a37:	29 d0                	sub    %edx,%eax
  803a39:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a3d:	48 98                	cltq   
  803a3f:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803a44:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803a46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a4a:	8b 00                	mov    (%rax),%eax
  803a4c:	8d 50 01             	lea    0x1(%rax),%edx
  803a4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a53:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  803a55:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a5e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a62:	0f 82 60 ff ff ff    	jb     8039c8 <devpipe_read+0x40>
	}
	return i;
  803a68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a6c:	c9                   	leaveq 
  803a6d:	c3                   	retq   

0000000000803a6e <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a6e:	55                   	push   %rbp
  803a6f:	48 89 e5             	mov    %rsp,%rbp
  803a72:	48 83 ec 40          	sub    $0x40,%rsp
  803a76:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a7a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a7e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803a82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a86:	48 89 c7             	mov    %rax,%rdi
  803a89:	48 b8 51 1d 80 00 00 	movabs $0x801d51,%rax
  803a90:	00 00 00 
  803a93:	ff d0                	callq  *%rax
  803a95:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803a99:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a9d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803aa1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803aa8:	00 
  803aa9:	e9 91 00 00 00       	jmpq   803b3f <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803aae:	eb 31                	jmp    803ae1 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803ab0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ab4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ab8:	48 89 d6             	mov    %rdx,%rsi
  803abb:	48 89 c7             	mov    %rax,%rdi
  803abe:	48 b8 56 38 80 00 00 	movabs $0x803856,%rax
  803ac5:	00 00 00 
  803ac8:	ff d0                	callq  *%rax
  803aca:	85 c0                	test   %eax,%eax
  803acc:	74 07                	je     803ad5 <devpipe_write+0x67>
				return 0;
  803ace:	b8 00 00 00 00       	mov    $0x0,%eax
  803ad3:	eb 7c                	jmp    803b51 <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803ad5:	48 b8 8a 19 80 00 00 	movabs $0x80198a,%rax
  803adc:	00 00 00 
  803adf:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803ae1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ae5:	8b 40 04             	mov    0x4(%rax),%eax
  803ae8:	48 63 d0             	movslq %eax,%rdx
  803aeb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aef:	8b 00                	mov    (%rax),%eax
  803af1:	48 98                	cltq   
  803af3:	48 83 c0 20          	add    $0x20,%rax
  803af7:	48 39 c2             	cmp    %rax,%rdx
  803afa:	73 b4                	jae    803ab0 <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803afc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b00:	8b 40 04             	mov    0x4(%rax),%eax
  803b03:	99                   	cltd   
  803b04:	c1 ea 1b             	shr    $0x1b,%edx
  803b07:	01 d0                	add    %edx,%eax
  803b09:	83 e0 1f             	and    $0x1f,%eax
  803b0c:	29 d0                	sub    %edx,%eax
  803b0e:	89 c6                	mov    %eax,%esi
  803b10:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803b14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b18:	48 01 d0             	add    %rdx,%rax
  803b1b:	0f b6 08             	movzbl (%rax),%ecx
  803b1e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b22:	48 63 c6             	movslq %esi,%rax
  803b25:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803b29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b2d:	8b 40 04             	mov    0x4(%rax),%eax
  803b30:	8d 50 01             	lea    0x1(%rax),%edx
  803b33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b37:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  803b3a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803b3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b43:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b47:	0f 82 61 ff ff ff    	jb     803aae <devpipe_write+0x40>
	}

	return i;
  803b4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803b51:	c9                   	leaveq 
  803b52:	c3                   	retq   

0000000000803b53 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803b53:	55                   	push   %rbp
  803b54:	48 89 e5             	mov    %rsp,%rbp
  803b57:	48 83 ec 20          	sub    $0x20,%rsp
  803b5b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b5f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803b63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b67:	48 89 c7             	mov    %rax,%rdi
  803b6a:	48 b8 51 1d 80 00 00 	movabs $0x801d51,%rax
  803b71:	00 00 00 
  803b74:	ff d0                	callq  *%rax
  803b76:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803b7a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b7e:	48 be 10 49 80 00 00 	movabs $0x804910,%rsi
  803b85:	00 00 00 
  803b88:	48 89 c7             	mov    %rax,%rdi
  803b8b:	48 b8 99 10 80 00 00 	movabs $0x801099,%rax
  803b92:	00 00 00 
  803b95:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803b97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b9b:	8b 50 04             	mov    0x4(%rax),%edx
  803b9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ba2:	8b 00                	mov    (%rax),%eax
  803ba4:	29 c2                	sub    %eax,%edx
  803ba6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803baa:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803bb0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bb4:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803bbb:	00 00 00 
	stat->st_dev = &devpipe;
  803bbe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bc2:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803bc9:	00 00 00 
  803bcc:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803bd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803bd8:	c9                   	leaveq 
  803bd9:	c3                   	retq   

0000000000803bda <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803bda:	55                   	push   %rbp
  803bdb:	48 89 e5             	mov    %rsp,%rbp
  803bde:	48 83 ec 10          	sub    $0x10,%rsp
  803be2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803be6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bea:	48 89 c6             	mov    %rax,%rsi
  803bed:	bf 00 00 00 00       	mov    $0x0,%edi
  803bf2:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  803bf9:	00 00 00 
  803bfc:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803bfe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c02:	48 89 c7             	mov    %rax,%rdi
  803c05:	48 b8 51 1d 80 00 00 	movabs $0x801d51,%rax
  803c0c:	00 00 00 
  803c0f:	ff d0                	callq  *%rax
  803c11:	48 89 c6             	mov    %rax,%rsi
  803c14:	bf 00 00 00 00       	mov    $0x0,%edi
  803c19:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  803c20:	00 00 00 
  803c23:	ff d0                	callq  *%rax
}
  803c25:	c9                   	leaveq 
  803c26:	c3                   	retq   

0000000000803c27 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803c27:	55                   	push   %rbp
  803c28:	48 89 e5             	mov    %rsp,%rbp
  803c2b:	48 83 ec 20          	sub    $0x20,%rsp
  803c2f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803c32:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c35:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803c38:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803c3c:	be 01 00 00 00       	mov    $0x1,%esi
  803c41:	48 89 c7             	mov    %rax,%rdi
  803c44:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  803c4b:	00 00 00 
  803c4e:	ff d0                	callq  *%rax
}
  803c50:	c9                   	leaveq 
  803c51:	c3                   	retq   

0000000000803c52 <getchar>:

int
getchar(void)
{
  803c52:	55                   	push   %rbp
  803c53:	48 89 e5             	mov    %rsp,%rbp
  803c56:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803c5a:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803c5e:	ba 01 00 00 00       	mov    $0x1,%edx
  803c63:	48 89 c6             	mov    %rax,%rsi
  803c66:	bf 00 00 00 00       	mov    $0x0,%edi
  803c6b:	48 b8 48 22 80 00 00 	movabs $0x802248,%rax
  803c72:	00 00 00 
  803c75:	ff d0                	callq  *%rax
  803c77:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803c7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c7e:	79 05                	jns    803c85 <getchar+0x33>
		return r;
  803c80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c83:	eb 14                	jmp    803c99 <getchar+0x47>
	if (r < 1)
  803c85:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c89:	7f 07                	jg     803c92 <getchar+0x40>
		return -E_EOF;
  803c8b:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803c90:	eb 07                	jmp    803c99 <getchar+0x47>
	return c;
  803c92:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803c96:	0f b6 c0             	movzbl %al,%eax
}
  803c99:	c9                   	leaveq 
  803c9a:	c3                   	retq   

0000000000803c9b <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803c9b:	55                   	push   %rbp
  803c9c:	48 89 e5             	mov    %rsp,%rbp
  803c9f:	48 83 ec 20          	sub    $0x20,%rsp
  803ca3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ca6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803caa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cad:	48 89 d6             	mov    %rdx,%rsi
  803cb0:	89 c7                	mov    %eax,%edi
  803cb2:	48 b8 14 1e 80 00 00 	movabs $0x801e14,%rax
  803cb9:	00 00 00 
  803cbc:	ff d0                	callq  *%rax
  803cbe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cc1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cc5:	79 05                	jns    803ccc <iscons+0x31>
		return r;
  803cc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cca:	eb 1a                	jmp    803ce6 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803ccc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cd0:	8b 10                	mov    (%rax),%edx
  803cd2:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803cd9:	00 00 00 
  803cdc:	8b 00                	mov    (%rax),%eax
  803cde:	39 c2                	cmp    %eax,%edx
  803ce0:	0f 94 c0             	sete   %al
  803ce3:	0f b6 c0             	movzbl %al,%eax
}
  803ce6:	c9                   	leaveq 
  803ce7:	c3                   	retq   

0000000000803ce8 <opencons>:

int
opencons(void)
{
  803ce8:	55                   	push   %rbp
  803ce9:	48 89 e5             	mov    %rsp,%rbp
  803cec:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803cf0:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803cf4:	48 89 c7             	mov    %rax,%rdi
  803cf7:	48 b8 7c 1d 80 00 00 	movabs $0x801d7c,%rax
  803cfe:	00 00 00 
  803d01:	ff d0                	callq  *%rax
  803d03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d0a:	79 05                	jns    803d11 <opencons+0x29>
		return r;
  803d0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d0f:	eb 5b                	jmp    803d6c <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803d11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d15:	ba 07 04 00 00       	mov    $0x407,%edx
  803d1a:	48 89 c6             	mov    %rax,%rsi
  803d1d:	bf 00 00 00 00       	mov    $0x0,%edi
  803d22:	48 b8 c6 19 80 00 00 	movabs $0x8019c6,%rax
  803d29:	00 00 00 
  803d2c:	ff d0                	callq  *%rax
  803d2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d35:	79 05                	jns    803d3c <opencons+0x54>
		return r;
  803d37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d3a:	eb 30                	jmp    803d6c <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803d3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d40:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803d47:	00 00 00 
  803d4a:	8b 12                	mov    (%rdx),%edx
  803d4c:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803d4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d52:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803d59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d5d:	48 89 c7             	mov    %rax,%rdi
  803d60:	48 b8 2e 1d 80 00 00 	movabs $0x801d2e,%rax
  803d67:	00 00 00 
  803d6a:	ff d0                	callq  *%rax
}
  803d6c:	c9                   	leaveq 
  803d6d:	c3                   	retq   

0000000000803d6e <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d6e:	55                   	push   %rbp
  803d6f:	48 89 e5             	mov    %rsp,%rbp
  803d72:	48 83 ec 30          	sub    $0x30,%rsp
  803d76:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d7a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d7e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803d82:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d87:	75 07                	jne    803d90 <devcons_read+0x22>
		return 0;
  803d89:	b8 00 00 00 00       	mov    $0x0,%eax
  803d8e:	eb 4b                	jmp    803ddb <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803d90:	eb 0c                	jmp    803d9e <devcons_read+0x30>
		sys_yield();
  803d92:	48 b8 8a 19 80 00 00 	movabs $0x80198a,%rax
  803d99:	00 00 00 
  803d9c:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  803d9e:	48 b8 cc 18 80 00 00 	movabs $0x8018cc,%rax
  803da5:	00 00 00 
  803da8:	ff d0                	callq  *%rax
  803daa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803db1:	74 df                	je     803d92 <devcons_read+0x24>
	if (c < 0)
  803db3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803db7:	79 05                	jns    803dbe <devcons_read+0x50>
		return c;
  803db9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dbc:	eb 1d                	jmp    803ddb <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803dbe:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803dc2:	75 07                	jne    803dcb <devcons_read+0x5d>
		return 0;
  803dc4:	b8 00 00 00 00       	mov    $0x0,%eax
  803dc9:	eb 10                	jmp    803ddb <devcons_read+0x6d>
	*(char*)vbuf = c;
  803dcb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dce:	89 c2                	mov    %eax,%edx
  803dd0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dd4:	88 10                	mov    %dl,(%rax)
	return 1;
  803dd6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803ddb:	c9                   	leaveq 
  803ddc:	c3                   	retq   

0000000000803ddd <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803ddd:	55                   	push   %rbp
  803dde:	48 89 e5             	mov    %rsp,%rbp
  803de1:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803de8:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803def:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803df6:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803dfd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e04:	eb 76                	jmp    803e7c <devcons_write+0x9f>
		m = n - tot;
  803e06:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803e0d:	89 c2                	mov    %eax,%edx
  803e0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e12:	29 c2                	sub    %eax,%edx
  803e14:	89 d0                	mov    %edx,%eax
  803e16:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803e19:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e1c:	83 f8 7f             	cmp    $0x7f,%eax
  803e1f:	76 07                	jbe    803e28 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803e21:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803e28:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e2b:	48 63 d0             	movslq %eax,%rdx
  803e2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e31:	48 63 c8             	movslq %eax,%rcx
  803e34:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803e3b:	48 01 c1             	add    %rax,%rcx
  803e3e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e45:	48 89 ce             	mov    %rcx,%rsi
  803e48:	48 89 c7             	mov    %rax,%rdi
  803e4b:	48 b8 bd 13 80 00 00 	movabs $0x8013bd,%rax
  803e52:	00 00 00 
  803e55:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803e57:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e5a:	48 63 d0             	movslq %eax,%rdx
  803e5d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e64:	48 89 d6             	mov    %rdx,%rsi
  803e67:	48 89 c7             	mov    %rax,%rdi
  803e6a:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  803e71:	00 00 00 
  803e74:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  803e76:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e79:	01 45 fc             	add    %eax,-0x4(%rbp)
  803e7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e7f:	48 98                	cltq   
  803e81:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803e88:	0f 82 78 ff ff ff    	jb     803e06 <devcons_write+0x29>
	}
	return tot;
  803e8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e91:	c9                   	leaveq 
  803e92:	c3                   	retq   

0000000000803e93 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803e93:	55                   	push   %rbp
  803e94:	48 89 e5             	mov    %rsp,%rbp
  803e97:	48 83 ec 08          	sub    $0x8,%rsp
  803e9b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803e9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ea4:	c9                   	leaveq 
  803ea5:	c3                   	retq   

0000000000803ea6 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803ea6:	55                   	push   %rbp
  803ea7:	48 89 e5             	mov    %rsp,%rbp
  803eaa:	48 83 ec 10          	sub    $0x10,%rsp
  803eae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803eb2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803eb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eba:	48 be 1c 49 80 00 00 	movabs $0x80491c,%rsi
  803ec1:	00 00 00 
  803ec4:	48 89 c7             	mov    %rax,%rdi
  803ec7:	48 b8 99 10 80 00 00 	movabs $0x801099,%rax
  803ece:	00 00 00 
  803ed1:	ff d0                	callq  *%rax
	return 0;
  803ed3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ed8:	c9                   	leaveq 
  803ed9:	c3                   	retq   

0000000000803eda <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803eda:	55                   	push   %rbp
  803edb:	48 89 e5             	mov    %rsp,%rbp
  803ede:	48 83 ec 20          	sub    $0x20,%rsp
  803ee2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ee6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803eea:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  803eee:	48 ba 28 49 80 00 00 	movabs $0x804928,%rdx
  803ef5:	00 00 00 
  803ef8:	be 1d 00 00 00       	mov    $0x1d,%esi
  803efd:	48 bf 41 49 80 00 00 	movabs $0x804941,%rdi
  803f04:	00 00 00 
  803f07:	b8 00 00 00 00       	mov    $0x0,%eax
  803f0c:	48 b9 c6 02 80 00 00 	movabs $0x8002c6,%rcx
  803f13:	00 00 00 
  803f16:	ff d1                	callq  *%rcx

0000000000803f18 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803f18:	55                   	push   %rbp
  803f19:	48 89 e5             	mov    %rsp,%rbp
  803f1c:	48 83 ec 20          	sub    $0x20,%rsp
  803f20:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f23:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803f26:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  803f2a:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  803f2d:	48 ba 4b 49 80 00 00 	movabs $0x80494b,%rdx
  803f34:	00 00 00 
  803f37:	be 2d 00 00 00       	mov    $0x2d,%esi
  803f3c:	48 bf 41 49 80 00 00 	movabs $0x804941,%rdi
  803f43:	00 00 00 
  803f46:	b8 00 00 00 00       	mov    $0x0,%eax
  803f4b:	48 b9 c6 02 80 00 00 	movabs $0x8002c6,%rcx
  803f52:	00 00 00 
  803f55:	ff d1                	callq  *%rcx

0000000000803f57 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803f57:	55                   	push   %rbp
  803f58:	48 89 e5             	mov    %rsp,%rbp
  803f5b:	53                   	push   %rbx
  803f5c:	48 83 ec 48          	sub    $0x48,%rsp
  803f60:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  803f64:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  803f6b:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  803f72:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  803f77:	75 0e                	jne    803f87 <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  803f79:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803f80:	00 00 00 
  803f83:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  803f87:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803f8b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  803f8f:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803f96:	00 
	a3 = (uint64_t) 0;
  803f97:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  803f9e:	00 
	a4 = (uint64_t) 0;
  803f9f:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803fa6:	00 
	a5 = 0;
  803fa7:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  803fae:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  803faf:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803fb2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803fb6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803fba:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  803fbe:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  803fc2:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  803fc6:	4c 89 c3             	mov    %r8,%rbx
  803fc9:	0f 01 c1             	vmcall 
  803fcc:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  803fcf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fd3:	7e 36                	jle    80400b <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  803fd5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803fd8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803fdb:	41 89 d0             	mov    %edx,%r8d
  803fde:	89 c1                	mov    %eax,%ecx
  803fe0:	48 ba 68 49 80 00 00 	movabs $0x804968,%rdx
  803fe7:	00 00 00 
  803fea:	be 54 00 00 00       	mov    $0x54,%esi
  803fef:	48 bf 41 49 80 00 00 	movabs $0x804941,%rdi
  803ff6:	00 00 00 
  803ff9:	b8 00 00 00 00       	mov    $0x0,%eax
  803ffe:	49 b9 c6 02 80 00 00 	movabs $0x8002c6,%r9
  804005:	00 00 00 
  804008:	41 ff d1             	callq  *%r9
	return ret;
  80400b:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80400e:	48 83 c4 48          	add    $0x48,%rsp
  804012:	5b                   	pop    %rbx
  804013:	5d                   	pop    %rbp
  804014:	c3                   	retq   

0000000000804015 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804015:	55                   	push   %rbp
  804016:	48 89 e5             	mov    %rsp,%rbp
  804019:	53                   	push   %rbx
  80401a:	48 83 ec 58          	sub    $0x58,%rsp
  80401e:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  804021:	89 75 b0             	mov    %esi,-0x50(%rbp)
  804024:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  804028:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  80402b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  804032:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  804039:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  80403e:	75 0e                	jne    80404e <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  804040:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  804047:	00 00 00 
  80404a:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  80404e:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  804051:	48 98                	cltq   
  804053:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  804057:	8b 45 b0             	mov    -0x50(%rbp),%eax
  80405a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  80405e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804062:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  804066:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  804069:	48 98                	cltq   
  80406b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  80406f:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  804076:	00 

	int r = -E_IPC_NOT_RECV;
  804077:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  80407e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804081:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804085:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  804089:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  80408d:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  804091:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  804095:	4c 89 c3             	mov    %r8,%rbx
  804098:	0f 01 c1             	vmcall 
  80409b:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  80409e:	48 83 c4 58          	add    $0x58,%rsp
  8040a2:	5b                   	pop    %rbx
  8040a3:	5d                   	pop    %rbp
  8040a4:	c3                   	retq   

00000000008040a5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8040a5:	55                   	push   %rbp
  8040a6:	48 89 e5             	mov    %rsp,%rbp
  8040a9:	48 83 ec 18          	sub    $0x18,%rsp
  8040ad:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8040b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8040b7:	eb 4e                	jmp    804107 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8040b9:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8040c0:	00 00 00 
  8040c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040c6:	48 98                	cltq   
  8040c8:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8040cf:	48 01 d0             	add    %rdx,%rax
  8040d2:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8040d8:	8b 00                	mov    (%rax),%eax
  8040da:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8040dd:	75 24                	jne    804103 <ipc_find_env+0x5e>
			return envs[i].env_id;
  8040df:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8040e6:	00 00 00 
  8040e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040ec:	48 98                	cltq   
  8040ee:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8040f5:	48 01 d0             	add    %rdx,%rax
  8040f8:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8040fe:	8b 40 08             	mov    0x8(%rax),%eax
  804101:	eb 12                	jmp    804115 <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  804103:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804107:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80410e:	7e a9                	jle    8040b9 <ipc_find_env+0x14>
	}
	return 0;
  804110:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804115:	c9                   	leaveq 
  804116:	c3                   	retq   

0000000000804117 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804117:	55                   	push   %rbp
  804118:	48 89 e5             	mov    %rsp,%rbp
  80411b:	48 83 ec 18          	sub    $0x18,%rsp
  80411f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804123:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804127:	48 c1 e8 15          	shr    $0x15,%rax
  80412b:	48 89 c2             	mov    %rax,%rdx
  80412e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804135:	01 00 00 
  804138:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80413c:	83 e0 01             	and    $0x1,%eax
  80413f:	48 85 c0             	test   %rax,%rax
  804142:	75 07                	jne    80414b <pageref+0x34>
		return 0;
  804144:	b8 00 00 00 00       	mov    $0x0,%eax
  804149:	eb 53                	jmp    80419e <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80414b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80414f:	48 c1 e8 0c          	shr    $0xc,%rax
  804153:	48 89 c2             	mov    %rax,%rdx
  804156:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80415d:	01 00 00 
  804160:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804164:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804168:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80416c:	83 e0 01             	and    $0x1,%eax
  80416f:	48 85 c0             	test   %rax,%rax
  804172:	75 07                	jne    80417b <pageref+0x64>
		return 0;
  804174:	b8 00 00 00 00       	mov    $0x0,%eax
  804179:	eb 23                	jmp    80419e <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80417b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80417f:	48 c1 e8 0c          	shr    $0xc,%rax
  804183:	48 89 c2             	mov    %rax,%rdx
  804186:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80418d:	00 00 00 
  804190:	48 c1 e2 04          	shl    $0x4,%rdx
  804194:	48 01 d0             	add    %rdx,%rax
  804197:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80419b:	0f b7 c0             	movzwl %ax,%eax
}
  80419e:	c9                   	leaveq 
  80419f:	c3                   	retq   
