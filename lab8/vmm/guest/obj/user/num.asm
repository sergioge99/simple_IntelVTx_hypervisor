
vmm/guest/obj/user/num:     formato del fichero elf64-x86-64


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
  80003c:	e8 91 02 00 00       	callq  8002d2 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800052:	e9 da 00 00 00       	jmpq   800131 <num+0xee>
		if (bol) {
  800057:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80005e:	00 00 00 
  800061:	8b 00                	mov    (%rax),%eax
  800063:	85 c0                	test   %eax,%eax
  800065:	74 54                	je     8000bb <num+0x78>
			printf("%5d ", ++line);
  800067:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80006e:	00 00 00 
  800071:	8b 00                	mov    (%rax),%eax
  800073:	8d 50 01             	lea    0x1(%rax),%edx
  800076:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80007d:	00 00 00 
  800080:	89 10                	mov    %edx,(%rax)
  800082:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800089:	00 00 00 
  80008c:	8b 00                	mov    (%rax),%eax
  80008e:	89 c6                	mov    %eax,%esi
  800090:	48 bf 40 42 80 00 00 	movabs $0x804240,%rdi
  800097:	00 00 00 
  80009a:	b8 00 00 00 00       	mov    $0x0,%eax
  80009f:	48 ba 2b 2e 80 00 00 	movabs $0x802e2b,%rdx
  8000a6:	00 00 00 
  8000a9:	ff d2                	callq  *%rdx
			bol = 0;
  8000ab:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000b2:	00 00 00 
  8000b5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		}
		if ((r = write(1, &c, 1)) != 1)
  8000bb:	48 8d 45 f3          	lea    -0xd(%rbp),%rax
  8000bf:	ba 01 00 00 00       	mov    $0x1,%edx
  8000c4:	48 89 c6             	mov    %rax,%rsi
  8000c7:	bf 01 00 00 00       	mov    $0x1,%edi
  8000cc:	48 b8 21 24 80 00 00 	movabs $0x802421,%rax
  8000d3:	00 00 00 
  8000d6:	ff d0                	callq  *%rax
  8000d8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000db:	83 7d f4 01          	cmpl   $0x1,-0xc(%rbp)
  8000df:	74 38                	je     800119 <num+0xd6>
			panic("write error copying %s: %e", s, r);
  8000e1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8000e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000e8:	41 89 d0             	mov    %edx,%r8d
  8000eb:	48 89 c1             	mov    %rax,%rcx
  8000ee:	48 ba 45 42 80 00 00 	movabs $0x804245,%rdx
  8000f5:	00 00 00 
  8000f8:	be 13 00 00 00       	mov    $0x13,%esi
  8000fd:	48 bf 60 42 80 00 00 	movabs $0x804260,%rdi
  800104:	00 00 00 
  800107:	b8 00 00 00 00       	mov    $0x0,%eax
  80010c:	49 b9 55 03 80 00 00 	movabs $0x800355,%r9
  800113:	00 00 00 
  800116:	41 ff d1             	callq  *%r9
		if (c == '\n')
  800119:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
  80011d:	3c 0a                	cmp    $0xa,%al
  80011f:	75 10                	jne    800131 <num+0xee>
			bol = 1;
  800121:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800128:	00 00 00 
  80012b:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
	while ((n = read(f, &c, 1)) > 0) {
  800131:	48 8d 4d f3          	lea    -0xd(%rbp),%rcx
  800135:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800138:	ba 01 00 00 00       	mov    $0x1,%edx
  80013d:	48 89 ce             	mov    %rcx,%rsi
  800140:	89 c7                	mov    %eax,%edi
  800142:	48 b8 d7 22 80 00 00 	movabs $0x8022d7,%rax
  800149:	00 00 00 
  80014c:	ff d0                	callq  *%rax
  80014e:	48 98                	cltq   
  800150:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800154:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800159:	0f 8f f8 fe ff ff    	jg     800057 <num+0x14>
	}
	if (n < 0)
  80015f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800164:	79 39                	jns    80019f <num+0x15c>
		panic("error reading %s: %e", s, n);
  800166:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80016a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80016e:	49 89 d0             	mov    %rdx,%r8
  800171:	48 89 c1             	mov    %rax,%rcx
  800174:	48 ba 6b 42 80 00 00 	movabs $0x80426b,%rdx
  80017b:	00 00 00 
  80017e:	be 18 00 00 00       	mov    $0x18,%esi
  800183:	48 bf 60 42 80 00 00 	movabs $0x804260,%rdi
  80018a:	00 00 00 
  80018d:	b8 00 00 00 00       	mov    $0x0,%eax
  800192:	49 b9 55 03 80 00 00 	movabs $0x800355,%r9
  800199:	00 00 00 
  80019c:	41 ff d1             	callq  *%r9
}
  80019f:	c9                   	leaveq 
  8001a0:	c3                   	retq   

00000000008001a1 <umain>:

void
umain(int argc, char **argv)
{
  8001a1:	55                   	push   %rbp
  8001a2:	48 89 e5             	mov    %rsp,%rbp
  8001a5:	48 83 ec 20          	sub    $0x20,%rsp
  8001a9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8001ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int f, i;

	binaryname = "num";
  8001b0:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8001b7:	00 00 00 
  8001ba:	48 b9 80 42 80 00 00 	movabs $0x804280,%rcx
  8001c1:	00 00 00 
  8001c4:	48 89 08             	mov    %rcx,(%rax)
	if (argc == 1)
  8001c7:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  8001cb:	75 20                	jne    8001ed <umain+0x4c>
		num(0, "<stdin>");
  8001cd:	48 be 84 42 80 00 00 	movabs $0x804284,%rsi
  8001d4:	00 00 00 
  8001d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001dc:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001e3:	00 00 00 
  8001e6:	ff d0                	callq  *%rax
  8001e8:	e9 d7 00 00 00       	jmpq   8002c4 <umain+0x123>
	else
		for (i = 1; i < argc; i++) {
  8001ed:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  8001f4:	e9 bf 00 00 00       	jmpq   8002b8 <umain+0x117>
			f = open(argv[i], O_RDONLY);
  8001f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001fc:	48 98                	cltq   
  8001fe:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800205:	00 
  800206:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80020a:	48 01 d0             	add    %rdx,%rax
  80020d:	48 8b 00             	mov    (%rax),%rax
  800210:	be 00 00 00 00       	mov    $0x0,%esi
  800215:	48 89 c7             	mov    %rax,%rdi
  800218:	48 b8 af 27 80 00 00 	movabs $0x8027af,%rax
  80021f:	00 00 00 
  800222:	ff d0                	callq  *%rax
  800224:	89 45 f8             	mov    %eax,-0x8(%rbp)
			if (f < 0)
  800227:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80022b:	79 4b                	jns    800278 <umain+0xd7>
				panic("can't open %s: %e", argv[i], f);
  80022d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800230:	48 98                	cltq   
  800232:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800239:	00 
  80023a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80023e:	48 01 d0             	add    %rdx,%rax
  800241:	48 8b 00             	mov    (%rax),%rax
  800244:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800247:	41 89 d0             	mov    %edx,%r8d
  80024a:	48 89 c1             	mov    %rax,%rcx
  80024d:	48 ba 8c 42 80 00 00 	movabs $0x80428c,%rdx
  800254:	00 00 00 
  800257:	be 27 00 00 00       	mov    $0x27,%esi
  80025c:	48 bf 60 42 80 00 00 	movabs $0x804260,%rdi
  800263:	00 00 00 
  800266:	b8 00 00 00 00       	mov    $0x0,%eax
  80026b:	49 b9 55 03 80 00 00 	movabs $0x800355,%r9
  800272:	00 00 00 
  800275:	41 ff d1             	callq  *%r9
			else {
				num(f, argv[i]);
  800278:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80027b:	48 98                	cltq   
  80027d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800284:	00 
  800285:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800289:	48 01 d0             	add    %rdx,%rax
  80028c:	48 8b 10             	mov    (%rax),%rdx
  80028f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800292:	48 89 d6             	mov    %rdx,%rsi
  800295:	89 c7                	mov    %eax,%edi
  800297:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80029e:	00 00 00 
  8002a1:	ff d0                	callq  *%rax
				close(f);
  8002a3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002a6:	89 c7                	mov    %eax,%edi
  8002a8:	48 b8 b5 20 80 00 00 	movabs $0x8020b5,%rax
  8002af:	00 00 00 
  8002b2:	ff d0                	callq  *%rax
		for (i = 1; i < argc; i++) {
  8002b4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8002b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002bb:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8002be:	0f 8c 35 ff ff ff    	jl     8001f9 <umain+0x58>
			}
		}
	exit();
  8002c4:	48 b8 32 03 80 00 00 	movabs $0x800332,%rax
  8002cb:	00 00 00 
  8002ce:	ff d0                	callq  *%rax
}
  8002d0:	c9                   	leaveq 
  8002d1:	c3                   	retq   

00000000008002d2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002d2:	55                   	push   %rbp
  8002d3:	48 89 e5             	mov    %rsp,%rbp
  8002d6:	48 83 ec 10          	sub    $0x10,%rsp
  8002da:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8002e1:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8002e8:	00 00 00 
  8002eb:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002f6:	7e 14                	jle    80030c <libmain+0x3a>
		binaryname = argv[0];
  8002f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002fc:	48 8b 10             	mov    (%rax),%rdx
  8002ff:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800306:	00 00 00 
  800309:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80030c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800310:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800313:	48 89 d6             	mov    %rdx,%rsi
  800316:	89 c7                	mov    %eax,%edi
  800318:	48 b8 a1 01 80 00 00 	movabs $0x8001a1,%rax
  80031f:	00 00 00 
  800322:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800324:	48 b8 32 03 80 00 00 	movabs $0x800332,%rax
  80032b:	00 00 00 
  80032e:	ff d0                	callq  *%rax
}
  800330:	c9                   	leaveq 
  800331:	c3                   	retq   

0000000000800332 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800332:	55                   	push   %rbp
  800333:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800336:	48 b8 00 21 80 00 00 	movabs $0x802100,%rax
  80033d:	00 00 00 
  800340:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800342:	bf 00 00 00 00       	mov    $0x0,%edi
  800347:	48 b8 97 19 80 00 00 	movabs $0x801997,%rax
  80034e:	00 00 00 
  800351:	ff d0                	callq  *%rax
}
  800353:	5d                   	pop    %rbp
  800354:	c3                   	retq   

0000000000800355 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800355:	55                   	push   %rbp
  800356:	48 89 e5             	mov    %rsp,%rbp
  800359:	53                   	push   %rbx
  80035a:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800361:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800368:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80036e:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800375:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80037c:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800383:	84 c0                	test   %al,%al
  800385:	74 23                	je     8003aa <_panic+0x55>
  800387:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80038e:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800392:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800396:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80039a:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80039e:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8003a2:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8003a6:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8003aa:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8003b1:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8003b8:	00 00 00 
  8003bb:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8003c2:	00 00 00 
  8003c5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003c9:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8003d0:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8003d7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003de:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8003e5:	00 00 00 
  8003e8:	48 8b 18             	mov    (%rax),%rbx
  8003eb:	48 b8 dd 19 80 00 00 	movabs $0x8019dd,%rax
  8003f2:	00 00 00 
  8003f5:	ff d0                	callq  *%rax
  8003f7:	89 c6                	mov    %eax,%esi
  8003f9:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8003ff:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  800406:	41 89 d0             	mov    %edx,%r8d
  800409:	48 89 c1             	mov    %rax,%rcx
  80040c:	48 89 da             	mov    %rbx,%rdx
  80040f:	48 bf a8 42 80 00 00 	movabs $0x8042a8,%rdi
  800416:	00 00 00 
  800419:	b8 00 00 00 00       	mov    $0x0,%eax
  80041e:	49 b9 8e 05 80 00 00 	movabs $0x80058e,%r9
  800425:	00 00 00 
  800428:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80042b:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800432:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800439:	48 89 d6             	mov    %rdx,%rsi
  80043c:	48 89 c7             	mov    %rax,%rdi
  80043f:	48 b8 e2 04 80 00 00 	movabs $0x8004e2,%rax
  800446:	00 00 00 
  800449:	ff d0                	callq  *%rax
	cprintf("\n");
  80044b:	48 bf cb 42 80 00 00 	movabs $0x8042cb,%rdi
  800452:	00 00 00 
  800455:	b8 00 00 00 00       	mov    $0x0,%eax
  80045a:	48 ba 8e 05 80 00 00 	movabs $0x80058e,%rdx
  800461:	00 00 00 
  800464:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800466:	cc                   	int3   
  800467:	eb fd                	jmp    800466 <_panic+0x111>

0000000000800469 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800469:	55                   	push   %rbp
  80046a:	48 89 e5             	mov    %rsp,%rbp
  80046d:	48 83 ec 10          	sub    $0x10,%rsp
  800471:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800474:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800478:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80047c:	8b 00                	mov    (%rax),%eax
  80047e:	8d 48 01             	lea    0x1(%rax),%ecx
  800481:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800485:	89 0a                	mov    %ecx,(%rdx)
  800487:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80048a:	89 d1                	mov    %edx,%ecx
  80048c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800490:	48 98                	cltq   
  800492:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800496:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80049a:	8b 00                	mov    (%rax),%eax
  80049c:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004a1:	75 2c                	jne    8004cf <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8004a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004a7:	8b 00                	mov    (%rax),%eax
  8004a9:	48 98                	cltq   
  8004ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004af:	48 83 c2 08          	add    $0x8,%rdx
  8004b3:	48 89 c6             	mov    %rax,%rsi
  8004b6:	48 89 d7             	mov    %rdx,%rdi
  8004b9:	48 b8 0f 19 80 00 00 	movabs $0x80190f,%rax
  8004c0:	00 00 00 
  8004c3:	ff d0                	callq  *%rax
        b->idx = 0;
  8004c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004c9:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8004cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004d3:	8b 40 04             	mov    0x4(%rax),%eax
  8004d6:	8d 50 01             	lea    0x1(%rax),%edx
  8004d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004dd:	89 50 04             	mov    %edx,0x4(%rax)
}
  8004e0:	c9                   	leaveq 
  8004e1:	c3                   	retq   

00000000008004e2 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8004e2:	55                   	push   %rbp
  8004e3:	48 89 e5             	mov    %rsp,%rbp
  8004e6:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8004ed:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8004f4:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8004fb:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800502:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800509:	48 8b 0a             	mov    (%rdx),%rcx
  80050c:	48 89 08             	mov    %rcx,(%rax)
  80050f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800513:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800517:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80051b:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80051f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800526:	00 00 00 
    b.cnt = 0;
  800529:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800530:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800533:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80053a:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800541:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800548:	48 89 c6             	mov    %rax,%rsi
  80054b:	48 bf 69 04 80 00 00 	movabs $0x800469,%rdi
  800552:	00 00 00 
  800555:	48 b8 2d 09 80 00 00 	movabs $0x80092d,%rax
  80055c:	00 00 00 
  80055f:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800561:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800567:	48 98                	cltq   
  800569:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800570:	48 83 c2 08          	add    $0x8,%rdx
  800574:	48 89 c6             	mov    %rax,%rsi
  800577:	48 89 d7             	mov    %rdx,%rdi
  80057a:	48 b8 0f 19 80 00 00 	movabs $0x80190f,%rax
  800581:	00 00 00 
  800584:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800586:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80058c:	c9                   	leaveq 
  80058d:	c3                   	retq   

000000000080058e <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80058e:	55                   	push   %rbp
  80058f:	48 89 e5             	mov    %rsp,%rbp
  800592:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800599:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8005a0:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8005a7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8005ae:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8005b5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8005bc:	84 c0                	test   %al,%al
  8005be:	74 20                	je     8005e0 <cprintf+0x52>
  8005c0:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8005c4:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8005c8:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8005cc:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8005d0:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8005d4:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8005d8:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8005dc:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8005e0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8005e7:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8005ee:	00 00 00 
  8005f1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8005f8:	00 00 00 
  8005fb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005ff:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800606:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80060d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800614:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80061b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800622:	48 8b 0a             	mov    (%rdx),%rcx
  800625:	48 89 08             	mov    %rcx,(%rax)
  800628:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80062c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800630:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800634:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800638:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80063f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800646:	48 89 d6             	mov    %rdx,%rsi
  800649:	48 89 c7             	mov    %rax,%rdi
  80064c:	48 b8 e2 04 80 00 00 	movabs $0x8004e2,%rax
  800653:	00 00 00 
  800656:	ff d0                	callq  *%rax
  800658:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80065e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800664:	c9                   	leaveq 
  800665:	c3                   	retq   

0000000000800666 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800666:	55                   	push   %rbp
  800667:	48 89 e5             	mov    %rsp,%rbp
  80066a:	48 83 ec 30          	sub    $0x30,%rsp
  80066e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800672:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800676:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80067a:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80067d:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800681:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800685:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800688:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80068c:	77 42                	ja     8006d0 <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80068e:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800691:	8d 78 ff             	lea    -0x1(%rax),%edi
  800694:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800697:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069b:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a0:	48 f7 f6             	div    %rsi
  8006a3:	49 89 c2             	mov    %rax,%r10
  8006a6:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8006a9:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8006ac:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8006b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006b4:	41 89 c9             	mov    %ecx,%r9d
  8006b7:	41 89 f8             	mov    %edi,%r8d
  8006ba:	89 d1                	mov    %edx,%ecx
  8006bc:	4c 89 d2             	mov    %r10,%rdx
  8006bf:	48 89 c7             	mov    %rax,%rdi
  8006c2:	48 b8 66 06 80 00 00 	movabs $0x800666,%rax
  8006c9:	00 00 00 
  8006cc:	ff d0                	callq  *%rax
  8006ce:	eb 1e                	jmp    8006ee <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006d0:	eb 12                	jmp    8006e4 <printnum+0x7e>
			putch(padc, putdat);
  8006d2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8006d6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8006d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006dd:	48 89 ce             	mov    %rcx,%rsi
  8006e0:	89 d7                	mov    %edx,%edi
  8006e2:	ff d0                	callq  *%rax
		while (--width > 0)
  8006e4:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8006e8:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8006ec:	7f e4                	jg     8006d2 <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006ee:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8006f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fa:	48 f7 f1             	div    %rcx
  8006fd:	48 b8 f0 44 80 00 00 	movabs $0x8044f0,%rax
  800704:	00 00 00 
  800707:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  80070b:	0f be d0             	movsbl %al,%edx
  80070e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800712:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800716:	48 89 ce             	mov    %rcx,%rsi
  800719:	89 d7                	mov    %edx,%edi
  80071b:	ff d0                	callq  *%rax
}
  80071d:	c9                   	leaveq 
  80071e:	c3                   	retq   

000000000080071f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80071f:	55                   	push   %rbp
  800720:	48 89 e5             	mov    %rsp,%rbp
  800723:	48 83 ec 20          	sub    $0x20,%rsp
  800727:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80072b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80072e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800732:	7e 4f                	jle    800783 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800734:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800738:	8b 00                	mov    (%rax),%eax
  80073a:	83 f8 30             	cmp    $0x30,%eax
  80073d:	73 24                	jae    800763 <getuint+0x44>
  80073f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800743:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800747:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074b:	8b 00                	mov    (%rax),%eax
  80074d:	89 c0                	mov    %eax,%eax
  80074f:	48 01 d0             	add    %rdx,%rax
  800752:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800756:	8b 12                	mov    (%rdx),%edx
  800758:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80075b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075f:	89 0a                	mov    %ecx,(%rdx)
  800761:	eb 14                	jmp    800777 <getuint+0x58>
  800763:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800767:	48 8b 40 08          	mov    0x8(%rax),%rax
  80076b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80076f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800773:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800777:	48 8b 00             	mov    (%rax),%rax
  80077a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80077e:	e9 9d 00 00 00       	jmpq   800820 <getuint+0x101>
	else if (lflag)
  800783:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800787:	74 4c                	je     8007d5 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800789:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078d:	8b 00                	mov    (%rax),%eax
  80078f:	83 f8 30             	cmp    $0x30,%eax
  800792:	73 24                	jae    8007b8 <getuint+0x99>
  800794:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800798:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80079c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a0:	8b 00                	mov    (%rax),%eax
  8007a2:	89 c0                	mov    %eax,%eax
  8007a4:	48 01 d0             	add    %rdx,%rax
  8007a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ab:	8b 12                	mov    (%rdx),%edx
  8007ad:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b4:	89 0a                	mov    %ecx,(%rdx)
  8007b6:	eb 14                	jmp    8007cc <getuint+0xad>
  8007b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bc:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007c0:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007cc:	48 8b 00             	mov    (%rax),%rax
  8007cf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007d3:	eb 4b                	jmp    800820 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8007d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d9:	8b 00                	mov    (%rax),%eax
  8007db:	83 f8 30             	cmp    $0x30,%eax
  8007de:	73 24                	jae    800804 <getuint+0xe5>
  8007e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ec:	8b 00                	mov    (%rax),%eax
  8007ee:	89 c0                	mov    %eax,%eax
  8007f0:	48 01 d0             	add    %rdx,%rax
  8007f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f7:	8b 12                	mov    (%rdx),%edx
  8007f9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800800:	89 0a                	mov    %ecx,(%rdx)
  800802:	eb 14                	jmp    800818 <getuint+0xf9>
  800804:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800808:	48 8b 40 08          	mov    0x8(%rax),%rax
  80080c:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800810:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800814:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800818:	8b 00                	mov    (%rax),%eax
  80081a:	89 c0                	mov    %eax,%eax
  80081c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800820:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800824:	c9                   	leaveq 
  800825:	c3                   	retq   

0000000000800826 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800826:	55                   	push   %rbp
  800827:	48 89 e5             	mov    %rsp,%rbp
  80082a:	48 83 ec 20          	sub    $0x20,%rsp
  80082e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800832:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800835:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800839:	7e 4f                	jle    80088a <getint+0x64>
		x=va_arg(*ap, long long);
  80083b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083f:	8b 00                	mov    (%rax),%eax
  800841:	83 f8 30             	cmp    $0x30,%eax
  800844:	73 24                	jae    80086a <getint+0x44>
  800846:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80084e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800852:	8b 00                	mov    (%rax),%eax
  800854:	89 c0                	mov    %eax,%eax
  800856:	48 01 d0             	add    %rdx,%rax
  800859:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085d:	8b 12                	mov    (%rdx),%edx
  80085f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800862:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800866:	89 0a                	mov    %ecx,(%rdx)
  800868:	eb 14                	jmp    80087e <getint+0x58>
  80086a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800872:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800876:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80087a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80087e:	48 8b 00             	mov    (%rax),%rax
  800881:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800885:	e9 9d 00 00 00       	jmpq   800927 <getint+0x101>
	else if (lflag)
  80088a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80088e:	74 4c                	je     8008dc <getint+0xb6>
		x=va_arg(*ap, long);
  800890:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800894:	8b 00                	mov    (%rax),%eax
  800896:	83 f8 30             	cmp    $0x30,%eax
  800899:	73 24                	jae    8008bf <getint+0x99>
  80089b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a7:	8b 00                	mov    (%rax),%eax
  8008a9:	89 c0                	mov    %eax,%eax
  8008ab:	48 01 d0             	add    %rdx,%rax
  8008ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b2:	8b 12                	mov    (%rdx),%edx
  8008b4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008bb:	89 0a                	mov    %ecx,(%rdx)
  8008bd:	eb 14                	jmp    8008d3 <getint+0xad>
  8008bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8008c7:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8008cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008cf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008d3:	48 8b 00             	mov    (%rax),%rax
  8008d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008da:	eb 4b                	jmp    800927 <getint+0x101>
	else
		x=va_arg(*ap, int);
  8008dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e0:	8b 00                	mov    (%rax),%eax
  8008e2:	83 f8 30             	cmp    $0x30,%eax
  8008e5:	73 24                	jae    80090b <getint+0xe5>
  8008e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008eb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f3:	8b 00                	mov    (%rax),%eax
  8008f5:	89 c0                	mov    %eax,%eax
  8008f7:	48 01 d0             	add    %rdx,%rax
  8008fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008fe:	8b 12                	mov    (%rdx),%edx
  800900:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800903:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800907:	89 0a                	mov    %ecx,(%rdx)
  800909:	eb 14                	jmp    80091f <getint+0xf9>
  80090b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090f:	48 8b 40 08          	mov    0x8(%rax),%rax
  800913:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800917:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80091f:	8b 00                	mov    (%rax),%eax
  800921:	48 98                	cltq   
  800923:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800927:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80092b:	c9                   	leaveq 
  80092c:	c3                   	retq   

000000000080092d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80092d:	55                   	push   %rbp
  80092e:	48 89 e5             	mov    %rsp,%rbp
  800931:	41 54                	push   %r12
  800933:	53                   	push   %rbx
  800934:	48 83 ec 60          	sub    $0x60,%rsp
  800938:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80093c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800940:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800944:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800948:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80094c:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800950:	48 8b 0a             	mov    (%rdx),%rcx
  800953:	48 89 08             	mov    %rcx,(%rax)
  800956:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80095a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80095e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800962:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800966:	eb 17                	jmp    80097f <vprintfmt+0x52>
			if (ch == '\0')
  800968:	85 db                	test   %ebx,%ebx
  80096a:	0f 84 c5 04 00 00    	je     800e35 <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  800970:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800974:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800978:	48 89 d6             	mov    %rdx,%rsi
  80097b:	89 df                	mov    %ebx,%edi
  80097d:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80097f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800983:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800987:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80098b:	0f b6 00             	movzbl (%rax),%eax
  80098e:	0f b6 d8             	movzbl %al,%ebx
  800991:	83 fb 25             	cmp    $0x25,%ebx
  800994:	75 d2                	jne    800968 <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  800996:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80099a:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8009a1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8009a8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8009af:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009b6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009ba:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009be:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009c2:	0f b6 00             	movzbl (%rax),%eax
  8009c5:	0f b6 d8             	movzbl %al,%ebx
  8009c8:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8009cb:	83 f8 55             	cmp    $0x55,%eax
  8009ce:	0f 87 2e 04 00 00    	ja     800e02 <vprintfmt+0x4d5>
  8009d4:	89 c0                	mov    %eax,%eax
  8009d6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8009dd:	00 
  8009de:	48 b8 18 45 80 00 00 	movabs $0x804518,%rax
  8009e5:	00 00 00 
  8009e8:	48 01 d0             	add    %rdx,%rax
  8009eb:	48 8b 00             	mov    (%rax),%rax
  8009ee:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8009f0:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8009f4:	eb c0                	jmp    8009b6 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009f6:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8009fa:	eb ba                	jmp    8009b6 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009fc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a03:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a06:	89 d0                	mov    %edx,%eax
  800a08:	c1 e0 02             	shl    $0x2,%eax
  800a0b:	01 d0                	add    %edx,%eax
  800a0d:	01 c0                	add    %eax,%eax
  800a0f:	01 d8                	add    %ebx,%eax
  800a11:	83 e8 30             	sub    $0x30,%eax
  800a14:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a17:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a1b:	0f b6 00             	movzbl (%rax),%eax
  800a1e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a21:	83 fb 2f             	cmp    $0x2f,%ebx
  800a24:	7e 0c                	jle    800a32 <vprintfmt+0x105>
  800a26:	83 fb 39             	cmp    $0x39,%ebx
  800a29:	7f 07                	jg     800a32 <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  800a2b:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  800a30:	eb d1                	jmp    800a03 <vprintfmt+0xd6>
			goto process_precision;
  800a32:	eb 50                	jmp    800a84 <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  800a34:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a37:	83 f8 30             	cmp    $0x30,%eax
  800a3a:	73 17                	jae    800a53 <vprintfmt+0x126>
  800a3c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a40:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a43:	89 d2                	mov    %edx,%edx
  800a45:	48 01 d0             	add    %rdx,%rax
  800a48:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a4b:	83 c2 08             	add    $0x8,%edx
  800a4e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a51:	eb 0c                	jmp    800a5f <vprintfmt+0x132>
  800a53:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a57:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a5b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a5f:	8b 00                	mov    (%rax),%eax
  800a61:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a64:	eb 1e                	jmp    800a84 <vprintfmt+0x157>

		case '.':
			if (width < 0)
  800a66:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a6a:	79 07                	jns    800a73 <vprintfmt+0x146>
				width = 0;
  800a6c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a73:	e9 3e ff ff ff       	jmpq   8009b6 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800a78:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a7f:	e9 32 ff ff ff       	jmpq   8009b6 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800a84:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a88:	79 0d                	jns    800a97 <vprintfmt+0x16a>
				width = precision, precision = -1;
  800a8a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a8d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a90:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a97:	e9 1a ff ff ff       	jmpq   8009b6 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a9c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800aa0:	e9 11 ff ff ff       	jmpq   8009b6 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800aa5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa8:	83 f8 30             	cmp    $0x30,%eax
  800aab:	73 17                	jae    800ac4 <vprintfmt+0x197>
  800aad:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ab1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ab4:	89 d2                	mov    %edx,%edx
  800ab6:	48 01 d0             	add    %rdx,%rax
  800ab9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800abc:	83 c2 08             	add    $0x8,%edx
  800abf:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ac2:	eb 0c                	jmp    800ad0 <vprintfmt+0x1a3>
  800ac4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800ac8:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800acc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ad0:	8b 10                	mov    (%rax),%edx
  800ad2:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ad6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ada:	48 89 ce             	mov    %rcx,%rsi
  800add:	89 d7                	mov    %edx,%edi
  800adf:	ff d0                	callq  *%rax
			break;
  800ae1:	e9 4a 03 00 00       	jmpq   800e30 <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800ae6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae9:	83 f8 30             	cmp    $0x30,%eax
  800aec:	73 17                	jae    800b05 <vprintfmt+0x1d8>
  800aee:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800af2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800af5:	89 d2                	mov    %edx,%edx
  800af7:	48 01 d0             	add    %rdx,%rax
  800afa:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800afd:	83 c2 08             	add    $0x8,%edx
  800b00:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b03:	eb 0c                	jmp    800b11 <vprintfmt+0x1e4>
  800b05:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b09:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b0d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b11:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b13:	85 db                	test   %ebx,%ebx
  800b15:	79 02                	jns    800b19 <vprintfmt+0x1ec>
				err = -err;
  800b17:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b19:	83 fb 15             	cmp    $0x15,%ebx
  800b1c:	7f 16                	jg     800b34 <vprintfmt+0x207>
  800b1e:	48 b8 40 44 80 00 00 	movabs $0x804440,%rax
  800b25:	00 00 00 
  800b28:	48 63 d3             	movslq %ebx,%rdx
  800b2b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b2f:	4d 85 e4             	test   %r12,%r12
  800b32:	75 2e                	jne    800b62 <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  800b34:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b38:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b3c:	89 d9                	mov    %ebx,%ecx
  800b3e:	48 ba 01 45 80 00 00 	movabs $0x804501,%rdx
  800b45:	00 00 00 
  800b48:	48 89 c7             	mov    %rax,%rdi
  800b4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b50:	49 b8 3e 0e 80 00 00 	movabs $0x800e3e,%r8
  800b57:	00 00 00 
  800b5a:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b5d:	e9 ce 02 00 00       	jmpq   800e30 <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  800b62:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b66:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b6a:	4c 89 e1             	mov    %r12,%rcx
  800b6d:	48 ba 0a 45 80 00 00 	movabs $0x80450a,%rdx
  800b74:	00 00 00 
  800b77:	48 89 c7             	mov    %rax,%rdi
  800b7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7f:	49 b8 3e 0e 80 00 00 	movabs $0x800e3e,%r8
  800b86:	00 00 00 
  800b89:	41 ff d0             	callq  *%r8
			break;
  800b8c:	e9 9f 02 00 00       	jmpq   800e30 <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b91:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b94:	83 f8 30             	cmp    $0x30,%eax
  800b97:	73 17                	jae    800bb0 <vprintfmt+0x283>
  800b99:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b9d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ba0:	89 d2                	mov    %edx,%edx
  800ba2:	48 01 d0             	add    %rdx,%rax
  800ba5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ba8:	83 c2 08             	add    $0x8,%edx
  800bab:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bae:	eb 0c                	jmp    800bbc <vprintfmt+0x28f>
  800bb0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800bb4:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800bb8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bbc:	4c 8b 20             	mov    (%rax),%r12
  800bbf:	4d 85 e4             	test   %r12,%r12
  800bc2:	75 0a                	jne    800bce <vprintfmt+0x2a1>
				p = "(null)";
  800bc4:	49 bc 0d 45 80 00 00 	movabs $0x80450d,%r12
  800bcb:	00 00 00 
			if (width > 0 && padc != '-')
  800bce:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bd2:	7e 3f                	jle    800c13 <vprintfmt+0x2e6>
  800bd4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800bd8:	74 39                	je     800c13 <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bda:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800bdd:	48 98                	cltq   
  800bdf:	48 89 c6             	mov    %rax,%rsi
  800be2:	4c 89 e7             	mov    %r12,%rdi
  800be5:	48 b8 ea 10 80 00 00 	movabs $0x8010ea,%rax
  800bec:	00 00 00 
  800bef:	ff d0                	callq  *%rax
  800bf1:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800bf4:	eb 17                	jmp    800c0d <vprintfmt+0x2e0>
					putch(padc, putdat);
  800bf6:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800bfa:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bfe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c02:	48 89 ce             	mov    %rcx,%rsi
  800c05:	89 d7                	mov    %edx,%edi
  800c07:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  800c09:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c0d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c11:	7f e3                	jg     800bf6 <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c13:	eb 37                	jmp    800c4c <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  800c15:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c19:	74 1e                	je     800c39 <vprintfmt+0x30c>
  800c1b:	83 fb 1f             	cmp    $0x1f,%ebx
  800c1e:	7e 05                	jle    800c25 <vprintfmt+0x2f8>
  800c20:	83 fb 7e             	cmp    $0x7e,%ebx
  800c23:	7e 14                	jle    800c39 <vprintfmt+0x30c>
					putch('?', putdat);
  800c25:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c2d:	48 89 d6             	mov    %rdx,%rsi
  800c30:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c35:	ff d0                	callq  *%rax
  800c37:	eb 0f                	jmp    800c48 <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  800c39:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c41:	48 89 d6             	mov    %rdx,%rsi
  800c44:	89 df                	mov    %ebx,%edi
  800c46:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c48:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c4c:	4c 89 e0             	mov    %r12,%rax
  800c4f:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c53:	0f b6 00             	movzbl (%rax),%eax
  800c56:	0f be d8             	movsbl %al,%ebx
  800c59:	85 db                	test   %ebx,%ebx
  800c5b:	74 10                	je     800c6d <vprintfmt+0x340>
  800c5d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c61:	78 b2                	js     800c15 <vprintfmt+0x2e8>
  800c63:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c67:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c6b:	79 a8                	jns    800c15 <vprintfmt+0x2e8>
			for (; width > 0; width--)
  800c6d:	eb 16                	jmp    800c85 <vprintfmt+0x358>
				putch(' ', putdat);
  800c6f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c73:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c77:	48 89 d6             	mov    %rdx,%rsi
  800c7a:	bf 20 00 00 00       	mov    $0x20,%edi
  800c7f:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  800c81:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c85:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c89:	7f e4                	jg     800c6f <vprintfmt+0x342>
			break;
  800c8b:	e9 a0 01 00 00       	jmpq   800e30 <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c90:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c94:	be 03 00 00 00       	mov    $0x3,%esi
  800c99:	48 89 c7             	mov    %rax,%rdi
  800c9c:	48 b8 26 08 80 00 00 	movabs $0x800826,%rax
  800ca3:	00 00 00 
  800ca6:	ff d0                	callq  *%rax
  800ca8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800cac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cb0:	48 85 c0             	test   %rax,%rax
  800cb3:	79 1d                	jns    800cd2 <vprintfmt+0x3a5>
				putch('-', putdat);
  800cb5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cb9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cbd:	48 89 d6             	mov    %rdx,%rsi
  800cc0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800cc5:	ff d0                	callq  *%rax
				num = -(long long) num;
  800cc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ccb:	48 f7 d8             	neg    %rax
  800cce:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800cd2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cd9:	e9 e5 00 00 00       	jmpq   800dc3 <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800cde:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ce2:	be 03 00 00 00       	mov    $0x3,%esi
  800ce7:	48 89 c7             	mov    %rax,%rdi
  800cea:	48 b8 1f 07 80 00 00 	movabs $0x80071f,%rax
  800cf1:	00 00 00 
  800cf4:	ff d0                	callq  *%rax
  800cf6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800cfa:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d01:	e9 bd 00 00 00       	jmpq   800dc3 <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d06:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d0e:	48 89 d6             	mov    %rdx,%rsi
  800d11:	bf 58 00 00 00       	mov    $0x58,%edi
  800d16:	ff d0                	callq  *%rax
			putch('X', putdat);
  800d18:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d1c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d20:	48 89 d6             	mov    %rdx,%rsi
  800d23:	bf 58 00 00 00       	mov    $0x58,%edi
  800d28:	ff d0                	callq  *%rax
			putch('X', putdat);
  800d2a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d32:	48 89 d6             	mov    %rdx,%rsi
  800d35:	bf 58 00 00 00       	mov    $0x58,%edi
  800d3a:	ff d0                	callq  *%rax
			break;
  800d3c:	e9 ef 00 00 00       	jmpq   800e30 <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  800d41:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d45:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d49:	48 89 d6             	mov    %rdx,%rsi
  800d4c:	bf 30 00 00 00       	mov    $0x30,%edi
  800d51:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d53:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d57:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d5b:	48 89 d6             	mov    %rdx,%rsi
  800d5e:	bf 78 00 00 00       	mov    $0x78,%edi
  800d63:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d65:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d68:	83 f8 30             	cmp    $0x30,%eax
  800d6b:	73 17                	jae    800d84 <vprintfmt+0x457>
  800d6d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d71:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d74:	89 d2                	mov    %edx,%edx
  800d76:	48 01 d0             	add    %rdx,%rax
  800d79:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d7c:	83 c2 08             	add    $0x8,%edx
  800d7f:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  800d82:	eb 0c                	jmp    800d90 <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  800d84:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d88:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d8c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d90:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  800d93:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d97:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d9e:	eb 23                	jmp    800dc3 <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800da0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800da4:	be 03 00 00 00       	mov    $0x3,%esi
  800da9:	48 89 c7             	mov    %rax,%rdi
  800dac:	48 b8 1f 07 80 00 00 	movabs $0x80071f,%rax
  800db3:	00 00 00 
  800db6:	ff d0                	callq  *%rax
  800db8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800dbc:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800dc3:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800dc8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800dcb:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800dce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dd2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dd6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dda:	45 89 c1             	mov    %r8d,%r9d
  800ddd:	41 89 f8             	mov    %edi,%r8d
  800de0:	48 89 c7             	mov    %rax,%rdi
  800de3:	48 b8 66 06 80 00 00 	movabs $0x800666,%rax
  800dea:	00 00 00 
  800ded:	ff d0                	callq  *%rax
			break;
  800def:	eb 3f                	jmp    800e30 <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800df1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800df5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df9:	48 89 d6             	mov    %rdx,%rsi
  800dfc:	89 df                	mov    %ebx,%edi
  800dfe:	ff d0                	callq  *%rax
			break;
  800e00:	eb 2e                	jmp    800e30 <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e02:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e06:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e0a:	48 89 d6             	mov    %rdx,%rsi
  800e0d:	bf 25 00 00 00       	mov    $0x25,%edi
  800e12:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e14:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e19:	eb 05                	jmp    800e20 <vprintfmt+0x4f3>
  800e1b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e20:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e24:	48 83 e8 01          	sub    $0x1,%rax
  800e28:	0f b6 00             	movzbl (%rax),%eax
  800e2b:	3c 25                	cmp    $0x25,%al
  800e2d:	75 ec                	jne    800e1b <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  800e2f:	90                   	nop
		}
	}
  800e30:	e9 31 fb ff ff       	jmpq   800966 <vprintfmt+0x39>
	va_end(aq);
}
  800e35:	48 83 c4 60          	add    $0x60,%rsp
  800e39:	5b                   	pop    %rbx
  800e3a:	41 5c                	pop    %r12
  800e3c:	5d                   	pop    %rbp
  800e3d:	c3                   	retq   

0000000000800e3e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e3e:	55                   	push   %rbp
  800e3f:	48 89 e5             	mov    %rsp,%rbp
  800e42:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e49:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e50:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e57:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e5e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e65:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e6c:	84 c0                	test   %al,%al
  800e6e:	74 20                	je     800e90 <printfmt+0x52>
  800e70:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e74:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e78:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e7c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e80:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e84:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e88:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e8c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e90:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e97:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e9e:	00 00 00 
  800ea1:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800ea8:	00 00 00 
  800eab:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800eaf:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800eb6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ebd:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ec4:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ecb:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ed2:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800ed9:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800ee0:	48 89 c7             	mov    %rax,%rdi
  800ee3:	48 b8 2d 09 80 00 00 	movabs $0x80092d,%rax
  800eea:	00 00 00 
  800eed:	ff d0                	callq  *%rax
	va_end(ap);
}
  800eef:	c9                   	leaveq 
  800ef0:	c3                   	retq   

0000000000800ef1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ef1:	55                   	push   %rbp
  800ef2:	48 89 e5             	mov    %rsp,%rbp
  800ef5:	48 83 ec 10          	sub    $0x10,%rsp
  800ef9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800efc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f04:	8b 40 10             	mov    0x10(%rax),%eax
  800f07:	8d 50 01             	lea    0x1(%rax),%edx
  800f0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f0e:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f15:	48 8b 10             	mov    (%rax),%rdx
  800f18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f1c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f20:	48 39 c2             	cmp    %rax,%rdx
  800f23:	73 17                	jae    800f3c <sprintputch+0x4b>
		*b->buf++ = ch;
  800f25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f29:	48 8b 00             	mov    (%rax),%rax
  800f2c:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f30:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f34:	48 89 0a             	mov    %rcx,(%rdx)
  800f37:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f3a:	88 10                	mov    %dl,(%rax)
}
  800f3c:	c9                   	leaveq 
  800f3d:	c3                   	retq   

0000000000800f3e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f3e:	55                   	push   %rbp
  800f3f:	48 89 e5             	mov    %rsp,%rbp
  800f42:	48 83 ec 50          	sub    $0x50,%rsp
  800f46:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f4a:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f4d:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f51:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f55:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f59:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f5d:	48 8b 0a             	mov    (%rdx),%rcx
  800f60:	48 89 08             	mov    %rcx,(%rax)
  800f63:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f67:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f6b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f6f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f73:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f77:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f7b:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f7e:	48 98                	cltq   
  800f80:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f84:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f88:	48 01 d0             	add    %rdx,%rax
  800f8b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f8f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f96:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f9b:	74 06                	je     800fa3 <vsnprintf+0x65>
  800f9d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800fa1:	7f 07                	jg     800faa <vsnprintf+0x6c>
		return -E_INVAL;
  800fa3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fa8:	eb 2f                	jmp    800fd9 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800faa:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800fae:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800fb2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800fb6:	48 89 c6             	mov    %rax,%rsi
  800fb9:	48 bf f1 0e 80 00 00 	movabs $0x800ef1,%rdi
  800fc0:	00 00 00 
  800fc3:	48 b8 2d 09 80 00 00 	movabs $0x80092d,%rax
  800fca:	00 00 00 
  800fcd:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800fcf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fd3:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800fd6:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800fd9:	c9                   	leaveq 
  800fda:	c3                   	retq   

0000000000800fdb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fdb:	55                   	push   %rbp
  800fdc:	48 89 e5             	mov    %rsp,%rbp
  800fdf:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800fe6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800fed:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800ff3:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ffa:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801001:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801008:	84 c0                	test   %al,%al
  80100a:	74 20                	je     80102c <snprintf+0x51>
  80100c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801010:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801014:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801018:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80101c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801020:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801024:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801028:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80102c:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801033:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80103a:	00 00 00 
  80103d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801044:	00 00 00 
  801047:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80104b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801052:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801059:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801060:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801067:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80106e:	48 8b 0a             	mov    (%rdx),%rcx
  801071:	48 89 08             	mov    %rcx,(%rax)
  801074:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801078:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80107c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801080:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801084:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80108b:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801092:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801098:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80109f:	48 89 c7             	mov    %rax,%rdi
  8010a2:	48 b8 3e 0f 80 00 00 	movabs $0x800f3e,%rax
  8010a9:	00 00 00 
  8010ac:	ff d0                	callq  *%rax
  8010ae:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8010b4:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8010ba:	c9                   	leaveq 
  8010bb:	c3                   	retq   

00000000008010bc <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8010bc:	55                   	push   %rbp
  8010bd:	48 89 e5             	mov    %rsp,%rbp
  8010c0:	48 83 ec 18          	sub    $0x18,%rsp
  8010c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8010c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010cf:	eb 09                	jmp    8010da <strlen+0x1e>
		n++;
  8010d1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  8010d5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010de:	0f b6 00             	movzbl (%rax),%eax
  8010e1:	84 c0                	test   %al,%al
  8010e3:	75 ec                	jne    8010d1 <strlen+0x15>
	return n;
  8010e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010e8:	c9                   	leaveq 
  8010e9:	c3                   	retq   

00000000008010ea <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010ea:	55                   	push   %rbp
  8010eb:	48 89 e5             	mov    %rsp,%rbp
  8010ee:	48 83 ec 20          	sub    $0x20,%rsp
  8010f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801101:	eb 0e                	jmp    801111 <strnlen+0x27>
		n++;
  801103:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801107:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80110c:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801111:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801116:	74 0b                	je     801123 <strnlen+0x39>
  801118:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111c:	0f b6 00             	movzbl (%rax),%eax
  80111f:	84 c0                	test   %al,%al
  801121:	75 e0                	jne    801103 <strnlen+0x19>
	return n;
  801123:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801126:	c9                   	leaveq 
  801127:	c3                   	retq   

0000000000801128 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801128:	55                   	push   %rbp
  801129:	48 89 e5             	mov    %rsp,%rbp
  80112c:	48 83 ec 20          	sub    $0x20,%rsp
  801130:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801134:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801138:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801140:	90                   	nop
  801141:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801145:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801149:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80114d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801151:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801155:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801159:	0f b6 12             	movzbl (%rdx),%edx
  80115c:	88 10                	mov    %dl,(%rax)
  80115e:	0f b6 00             	movzbl (%rax),%eax
  801161:	84 c0                	test   %al,%al
  801163:	75 dc                	jne    801141 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801165:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801169:	c9                   	leaveq 
  80116a:	c3                   	retq   

000000000080116b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80116b:	55                   	push   %rbp
  80116c:	48 89 e5             	mov    %rsp,%rbp
  80116f:	48 83 ec 20          	sub    $0x20,%rsp
  801173:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801177:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80117b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80117f:	48 89 c7             	mov    %rax,%rdi
  801182:	48 b8 bc 10 80 00 00 	movabs $0x8010bc,%rax
  801189:	00 00 00 
  80118c:	ff d0                	callq  *%rax
  80118e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801191:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801194:	48 63 d0             	movslq %eax,%rdx
  801197:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80119b:	48 01 c2             	add    %rax,%rdx
  80119e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011a2:	48 89 c6             	mov    %rax,%rsi
  8011a5:	48 89 d7             	mov    %rdx,%rdi
  8011a8:	48 b8 28 11 80 00 00 	movabs $0x801128,%rax
  8011af:	00 00 00 
  8011b2:	ff d0                	callq  *%rax
	return dst;
  8011b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8011b8:	c9                   	leaveq 
  8011b9:	c3                   	retq   

00000000008011ba <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8011ba:	55                   	push   %rbp
  8011bb:	48 89 e5             	mov    %rsp,%rbp
  8011be:	48 83 ec 28          	sub    $0x28,%rsp
  8011c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011ca:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8011ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8011d6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8011dd:	00 
  8011de:	eb 2a                	jmp    80120a <strncpy+0x50>
		*dst++ = *src;
  8011e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011e8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011ec:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011f0:	0f b6 12             	movzbl (%rdx),%edx
  8011f3:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011f9:	0f b6 00             	movzbl (%rax),%eax
  8011fc:	84 c0                	test   %al,%al
  8011fe:	74 05                	je     801205 <strncpy+0x4b>
			src++;
  801200:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  801205:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80120a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801212:	72 cc                	jb     8011e0 <strncpy+0x26>
	}
	return ret;
  801214:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801218:	c9                   	leaveq 
  801219:	c3                   	retq   

000000000080121a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80121a:	55                   	push   %rbp
  80121b:	48 89 e5             	mov    %rsp,%rbp
  80121e:	48 83 ec 28          	sub    $0x28,%rsp
  801222:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801226:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80122a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80122e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801232:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801236:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80123b:	74 3d                	je     80127a <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80123d:	eb 1d                	jmp    80125c <strlcpy+0x42>
			*dst++ = *src++;
  80123f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801243:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801247:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80124b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80124f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801253:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801257:	0f b6 12             	movzbl (%rdx),%edx
  80125a:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  80125c:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801261:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801266:	74 0b                	je     801273 <strlcpy+0x59>
  801268:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80126c:	0f b6 00             	movzbl (%rax),%eax
  80126f:	84 c0                	test   %al,%al
  801271:	75 cc                	jne    80123f <strlcpy+0x25>
		*dst = '\0';
  801273:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801277:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80127a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80127e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801282:	48 29 c2             	sub    %rax,%rdx
  801285:	48 89 d0             	mov    %rdx,%rax
}
  801288:	c9                   	leaveq 
  801289:	c3                   	retq   

000000000080128a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80128a:	55                   	push   %rbp
  80128b:	48 89 e5             	mov    %rsp,%rbp
  80128e:	48 83 ec 10          	sub    $0x10,%rsp
  801292:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801296:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80129a:	eb 0a                	jmp    8012a6 <strcmp+0x1c>
		p++, q++;
  80129c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012a1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  8012a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012aa:	0f b6 00             	movzbl (%rax),%eax
  8012ad:	84 c0                	test   %al,%al
  8012af:	74 12                	je     8012c3 <strcmp+0x39>
  8012b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b5:	0f b6 10             	movzbl (%rax),%edx
  8012b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012bc:	0f b6 00             	movzbl (%rax),%eax
  8012bf:	38 c2                	cmp    %al,%dl
  8012c1:	74 d9                	je     80129c <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8012c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c7:	0f b6 00             	movzbl (%rax),%eax
  8012ca:	0f b6 d0             	movzbl %al,%edx
  8012cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d1:	0f b6 00             	movzbl (%rax),%eax
  8012d4:	0f b6 c0             	movzbl %al,%eax
  8012d7:	29 c2                	sub    %eax,%edx
  8012d9:	89 d0                	mov    %edx,%eax
}
  8012db:	c9                   	leaveq 
  8012dc:	c3                   	retq   

00000000008012dd <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8012dd:	55                   	push   %rbp
  8012de:	48 89 e5             	mov    %rsp,%rbp
  8012e1:	48 83 ec 18          	sub    $0x18,%rsp
  8012e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012e9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012ed:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8012f1:	eb 0f                	jmp    801302 <strncmp+0x25>
		n--, p++, q++;
  8012f3:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8012f8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012fd:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  801302:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801307:	74 1d                	je     801326 <strncmp+0x49>
  801309:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130d:	0f b6 00             	movzbl (%rax),%eax
  801310:	84 c0                	test   %al,%al
  801312:	74 12                	je     801326 <strncmp+0x49>
  801314:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801318:	0f b6 10             	movzbl (%rax),%edx
  80131b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80131f:	0f b6 00             	movzbl (%rax),%eax
  801322:	38 c2                	cmp    %al,%dl
  801324:	74 cd                	je     8012f3 <strncmp+0x16>
	if (n == 0)
  801326:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80132b:	75 07                	jne    801334 <strncmp+0x57>
		return 0;
  80132d:	b8 00 00 00 00       	mov    $0x0,%eax
  801332:	eb 18                	jmp    80134c <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801334:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801338:	0f b6 00             	movzbl (%rax),%eax
  80133b:	0f b6 d0             	movzbl %al,%edx
  80133e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801342:	0f b6 00             	movzbl (%rax),%eax
  801345:	0f b6 c0             	movzbl %al,%eax
  801348:	29 c2                	sub    %eax,%edx
  80134a:	89 d0                	mov    %edx,%eax
}
  80134c:	c9                   	leaveq 
  80134d:	c3                   	retq   

000000000080134e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80134e:	55                   	push   %rbp
  80134f:	48 89 e5             	mov    %rsp,%rbp
  801352:	48 83 ec 10          	sub    $0x10,%rsp
  801356:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80135a:	89 f0                	mov    %esi,%eax
  80135c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80135f:	eb 17                	jmp    801378 <strchr+0x2a>
		if (*s == c)
  801361:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801365:	0f b6 00             	movzbl (%rax),%eax
  801368:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80136b:	75 06                	jne    801373 <strchr+0x25>
			return (char *) s;
  80136d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801371:	eb 15                	jmp    801388 <strchr+0x3a>
	for (; *s; s++)
  801373:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801378:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137c:	0f b6 00             	movzbl (%rax),%eax
  80137f:	84 c0                	test   %al,%al
  801381:	75 de                	jne    801361 <strchr+0x13>
	return 0;
  801383:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801388:	c9                   	leaveq 
  801389:	c3                   	retq   

000000000080138a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80138a:	55                   	push   %rbp
  80138b:	48 89 e5             	mov    %rsp,%rbp
  80138e:	48 83 ec 10          	sub    $0x10,%rsp
  801392:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801396:	89 f0                	mov    %esi,%eax
  801398:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80139b:	eb 13                	jmp    8013b0 <strfind+0x26>
		if (*s == c)
  80139d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a1:	0f b6 00             	movzbl (%rax),%eax
  8013a4:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013a7:	75 02                	jne    8013ab <strfind+0x21>
			break;
  8013a9:	eb 10                	jmp    8013bb <strfind+0x31>
	for (; *s; s++)
  8013ab:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b4:	0f b6 00             	movzbl (%rax),%eax
  8013b7:	84 c0                	test   %al,%al
  8013b9:	75 e2                	jne    80139d <strfind+0x13>
	return (char *) s;
  8013bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013bf:	c9                   	leaveq 
  8013c0:	c3                   	retq   

00000000008013c1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8013c1:	55                   	push   %rbp
  8013c2:	48 89 e5             	mov    %rsp,%rbp
  8013c5:	48 83 ec 18          	sub    $0x18,%rsp
  8013c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013cd:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8013d0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8013d4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013d9:	75 06                	jne    8013e1 <memset+0x20>
		return v;
  8013db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013df:	eb 69                	jmp    80144a <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8013e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e5:	83 e0 03             	and    $0x3,%eax
  8013e8:	48 85 c0             	test   %rax,%rax
  8013eb:	75 48                	jne    801435 <memset+0x74>
  8013ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f1:	83 e0 03             	and    $0x3,%eax
  8013f4:	48 85 c0             	test   %rax,%rax
  8013f7:	75 3c                	jne    801435 <memset+0x74>
		c &= 0xFF;
  8013f9:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801400:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801403:	c1 e0 18             	shl    $0x18,%eax
  801406:	89 c2                	mov    %eax,%edx
  801408:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80140b:	c1 e0 10             	shl    $0x10,%eax
  80140e:	09 c2                	or     %eax,%edx
  801410:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801413:	c1 e0 08             	shl    $0x8,%eax
  801416:	09 d0                	or     %edx,%eax
  801418:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80141b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80141f:	48 c1 e8 02          	shr    $0x2,%rax
  801423:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  801426:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80142a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80142d:	48 89 d7             	mov    %rdx,%rdi
  801430:	fc                   	cld    
  801431:	f3 ab                	rep stos %eax,%es:(%rdi)
  801433:	eb 11                	jmp    801446 <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801435:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801439:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80143c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801440:	48 89 d7             	mov    %rdx,%rdi
  801443:	fc                   	cld    
  801444:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801446:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80144a:	c9                   	leaveq 
  80144b:	c3                   	retq   

000000000080144c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80144c:	55                   	push   %rbp
  80144d:	48 89 e5             	mov    %rsp,%rbp
  801450:	48 83 ec 28          	sub    $0x28,%rsp
  801454:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801458:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80145c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801460:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801464:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801468:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80146c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801470:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801474:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801478:	0f 83 88 00 00 00    	jae    801506 <memmove+0xba>
  80147e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801482:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801486:	48 01 d0             	add    %rdx,%rax
  801489:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80148d:	76 77                	jbe    801506 <memmove+0xba>
		s += n;
  80148f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801493:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801497:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149b:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80149f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a3:	83 e0 03             	and    $0x3,%eax
  8014a6:	48 85 c0             	test   %rax,%rax
  8014a9:	75 3b                	jne    8014e6 <memmove+0x9a>
  8014ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014af:	83 e0 03             	and    $0x3,%eax
  8014b2:	48 85 c0             	test   %rax,%rax
  8014b5:	75 2f                	jne    8014e6 <memmove+0x9a>
  8014b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014bb:	83 e0 03             	and    $0x3,%eax
  8014be:	48 85 c0             	test   %rax,%rax
  8014c1:	75 23                	jne    8014e6 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8014c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c7:	48 83 e8 04          	sub    $0x4,%rax
  8014cb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014cf:	48 83 ea 04          	sub    $0x4,%rdx
  8014d3:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014d7:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  8014db:	48 89 c7             	mov    %rax,%rdi
  8014de:	48 89 d6             	mov    %rdx,%rsi
  8014e1:	fd                   	std    
  8014e2:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014e4:	eb 1d                	jmp    801503 <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ea:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f2:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  8014f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fa:	48 89 d7             	mov    %rdx,%rdi
  8014fd:	48 89 c1             	mov    %rax,%rcx
  801500:	fd                   	std    
  801501:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801503:	fc                   	cld    
  801504:	eb 57                	jmp    80155d <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801506:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80150a:	83 e0 03             	and    $0x3,%eax
  80150d:	48 85 c0             	test   %rax,%rax
  801510:	75 36                	jne    801548 <memmove+0xfc>
  801512:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801516:	83 e0 03             	and    $0x3,%eax
  801519:	48 85 c0             	test   %rax,%rax
  80151c:	75 2a                	jne    801548 <memmove+0xfc>
  80151e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801522:	83 e0 03             	and    $0x3,%eax
  801525:	48 85 c0             	test   %rax,%rax
  801528:	75 1e                	jne    801548 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80152a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152e:	48 c1 e8 02          	shr    $0x2,%rax
  801532:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  801535:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801539:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80153d:	48 89 c7             	mov    %rax,%rdi
  801540:	48 89 d6             	mov    %rdx,%rsi
  801543:	fc                   	cld    
  801544:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801546:	eb 15                	jmp    80155d <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  801548:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80154c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801550:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801554:	48 89 c7             	mov    %rax,%rdi
  801557:	48 89 d6             	mov    %rdx,%rsi
  80155a:	fc                   	cld    
  80155b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80155d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801561:	c9                   	leaveq 
  801562:	c3                   	retq   

0000000000801563 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801563:	55                   	push   %rbp
  801564:	48 89 e5             	mov    %rsp,%rbp
  801567:	48 83 ec 18          	sub    $0x18,%rsp
  80156b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80156f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801573:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801577:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80157b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80157f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801583:	48 89 ce             	mov    %rcx,%rsi
  801586:	48 89 c7             	mov    %rax,%rdi
  801589:	48 b8 4c 14 80 00 00 	movabs $0x80144c,%rax
  801590:	00 00 00 
  801593:	ff d0                	callq  *%rax
}
  801595:	c9                   	leaveq 
  801596:	c3                   	retq   

0000000000801597 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801597:	55                   	push   %rbp
  801598:	48 89 e5             	mov    %rsp,%rbp
  80159b:	48 83 ec 28          	sub    $0x28,%rsp
  80159f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015a3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015a7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8015ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015af:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8015b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015b7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8015bb:	eb 36                	jmp    8015f3 <memcmp+0x5c>
		if (*s1 != *s2)
  8015bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c1:	0f b6 10             	movzbl (%rax),%edx
  8015c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015c8:	0f b6 00             	movzbl (%rax),%eax
  8015cb:	38 c2                	cmp    %al,%dl
  8015cd:	74 1a                	je     8015e9 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8015cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d3:	0f b6 00             	movzbl (%rax),%eax
  8015d6:	0f b6 d0             	movzbl %al,%edx
  8015d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015dd:	0f b6 00             	movzbl (%rax),%eax
  8015e0:	0f b6 c0             	movzbl %al,%eax
  8015e3:	29 c2                	sub    %eax,%edx
  8015e5:	89 d0                	mov    %edx,%eax
  8015e7:	eb 20                	jmp    801609 <memcmp+0x72>
		s1++, s2++;
  8015e9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015ee:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  8015f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f7:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015fb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015ff:	48 85 c0             	test   %rax,%rax
  801602:	75 b9                	jne    8015bd <memcmp+0x26>
	}

	return 0;
  801604:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801609:	c9                   	leaveq 
  80160a:	c3                   	retq   

000000000080160b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80160b:	55                   	push   %rbp
  80160c:	48 89 e5             	mov    %rsp,%rbp
  80160f:	48 83 ec 28          	sub    $0x28,%rsp
  801613:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801617:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80161a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80161e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801622:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801626:	48 01 d0             	add    %rdx,%rax
  801629:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80162d:	eb 15                	jmp    801644 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80162f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801633:	0f b6 00             	movzbl (%rax),%eax
  801636:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801639:	38 d0                	cmp    %dl,%al
  80163b:	75 02                	jne    80163f <memfind+0x34>
			break;
  80163d:	eb 0f                	jmp    80164e <memfind+0x43>
	for (; s < ends; s++)
  80163f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801644:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801648:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80164c:	72 e1                	jb     80162f <memfind+0x24>
	return (void *) s;
  80164e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801652:	c9                   	leaveq 
  801653:	c3                   	retq   

0000000000801654 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801654:	55                   	push   %rbp
  801655:	48 89 e5             	mov    %rsp,%rbp
  801658:	48 83 ec 38          	sub    $0x38,%rsp
  80165c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801660:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801664:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801667:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80166e:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801675:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801676:	eb 05                	jmp    80167d <strtol+0x29>
		s++;
  801678:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  80167d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801681:	0f b6 00             	movzbl (%rax),%eax
  801684:	3c 20                	cmp    $0x20,%al
  801686:	74 f0                	je     801678 <strtol+0x24>
  801688:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168c:	0f b6 00             	movzbl (%rax),%eax
  80168f:	3c 09                	cmp    $0x9,%al
  801691:	74 e5                	je     801678 <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  801693:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801697:	0f b6 00             	movzbl (%rax),%eax
  80169a:	3c 2b                	cmp    $0x2b,%al
  80169c:	75 07                	jne    8016a5 <strtol+0x51>
		s++;
  80169e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016a3:	eb 17                	jmp    8016bc <strtol+0x68>
	else if (*s == '-')
  8016a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a9:	0f b6 00             	movzbl (%rax),%eax
  8016ac:	3c 2d                	cmp    $0x2d,%al
  8016ae:	75 0c                	jne    8016bc <strtol+0x68>
		s++, neg = 1;
  8016b0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016b5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016bc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016c0:	74 06                	je     8016c8 <strtol+0x74>
  8016c2:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8016c6:	75 28                	jne    8016f0 <strtol+0x9c>
  8016c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cc:	0f b6 00             	movzbl (%rax),%eax
  8016cf:	3c 30                	cmp    $0x30,%al
  8016d1:	75 1d                	jne    8016f0 <strtol+0x9c>
  8016d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d7:	48 83 c0 01          	add    $0x1,%rax
  8016db:	0f b6 00             	movzbl (%rax),%eax
  8016de:	3c 78                	cmp    $0x78,%al
  8016e0:	75 0e                	jne    8016f0 <strtol+0x9c>
		s += 2, base = 16;
  8016e2:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8016e7:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8016ee:	eb 2c                	jmp    80171c <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8016f0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016f4:	75 19                	jne    80170f <strtol+0xbb>
  8016f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fa:	0f b6 00             	movzbl (%rax),%eax
  8016fd:	3c 30                	cmp    $0x30,%al
  8016ff:	75 0e                	jne    80170f <strtol+0xbb>
		s++, base = 8;
  801701:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801706:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80170d:	eb 0d                	jmp    80171c <strtol+0xc8>
	else if (base == 0)
  80170f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801713:	75 07                	jne    80171c <strtol+0xc8>
		base = 10;
  801715:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80171c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801720:	0f b6 00             	movzbl (%rax),%eax
  801723:	3c 2f                	cmp    $0x2f,%al
  801725:	7e 1d                	jle    801744 <strtol+0xf0>
  801727:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172b:	0f b6 00             	movzbl (%rax),%eax
  80172e:	3c 39                	cmp    $0x39,%al
  801730:	7f 12                	jg     801744 <strtol+0xf0>
			dig = *s - '0';
  801732:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801736:	0f b6 00             	movzbl (%rax),%eax
  801739:	0f be c0             	movsbl %al,%eax
  80173c:	83 e8 30             	sub    $0x30,%eax
  80173f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801742:	eb 4e                	jmp    801792 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801744:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801748:	0f b6 00             	movzbl (%rax),%eax
  80174b:	3c 60                	cmp    $0x60,%al
  80174d:	7e 1d                	jle    80176c <strtol+0x118>
  80174f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801753:	0f b6 00             	movzbl (%rax),%eax
  801756:	3c 7a                	cmp    $0x7a,%al
  801758:	7f 12                	jg     80176c <strtol+0x118>
			dig = *s - 'a' + 10;
  80175a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175e:	0f b6 00             	movzbl (%rax),%eax
  801761:	0f be c0             	movsbl %al,%eax
  801764:	83 e8 57             	sub    $0x57,%eax
  801767:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80176a:	eb 26                	jmp    801792 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80176c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801770:	0f b6 00             	movzbl (%rax),%eax
  801773:	3c 40                	cmp    $0x40,%al
  801775:	7e 48                	jle    8017bf <strtol+0x16b>
  801777:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177b:	0f b6 00             	movzbl (%rax),%eax
  80177e:	3c 5a                	cmp    $0x5a,%al
  801780:	7f 3d                	jg     8017bf <strtol+0x16b>
			dig = *s - 'A' + 10;
  801782:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801786:	0f b6 00             	movzbl (%rax),%eax
  801789:	0f be c0             	movsbl %al,%eax
  80178c:	83 e8 37             	sub    $0x37,%eax
  80178f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801792:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801795:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801798:	7c 02                	jl     80179c <strtol+0x148>
			break;
  80179a:	eb 23                	jmp    8017bf <strtol+0x16b>
		s++, val = (val * base) + dig;
  80179c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017a1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8017a4:	48 98                	cltq   
  8017a6:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8017ab:	48 89 c2             	mov    %rax,%rdx
  8017ae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017b1:	48 98                	cltq   
  8017b3:	48 01 d0             	add    %rdx,%rax
  8017b6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8017ba:	e9 5d ff ff ff       	jmpq   80171c <strtol+0xc8>

	if (endptr)
  8017bf:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8017c4:	74 0b                	je     8017d1 <strtol+0x17d>
		*endptr = (char *) s;
  8017c6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017ca:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8017ce:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8017d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017d5:	74 09                	je     8017e0 <strtol+0x18c>
  8017d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017db:	48 f7 d8             	neg    %rax
  8017de:	eb 04                	jmp    8017e4 <strtol+0x190>
  8017e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017e4:	c9                   	leaveq 
  8017e5:	c3                   	retq   

00000000008017e6 <strstr>:

char * strstr(const char *in, const char *str)
{
  8017e6:	55                   	push   %rbp
  8017e7:	48 89 e5             	mov    %rsp,%rbp
  8017ea:	48 83 ec 30          	sub    $0x30,%rsp
  8017ee:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017f2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8017f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017fa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017fe:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801802:	0f b6 00             	movzbl (%rax),%eax
  801805:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801808:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80180c:	75 06                	jne    801814 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80180e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801812:	eb 6b                	jmp    80187f <strstr+0x99>

	len = strlen(str);
  801814:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801818:	48 89 c7             	mov    %rax,%rdi
  80181b:	48 b8 bc 10 80 00 00 	movabs $0x8010bc,%rax
  801822:	00 00 00 
  801825:	ff d0                	callq  *%rax
  801827:	48 98                	cltq   
  801829:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80182d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801831:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801835:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801839:	0f b6 00             	movzbl (%rax),%eax
  80183c:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80183f:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801843:	75 07                	jne    80184c <strstr+0x66>
				return (char *) 0;
  801845:	b8 00 00 00 00       	mov    $0x0,%eax
  80184a:	eb 33                	jmp    80187f <strstr+0x99>
		} while (sc != c);
  80184c:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801850:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801853:	75 d8                	jne    80182d <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801855:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801859:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80185d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801861:	48 89 ce             	mov    %rcx,%rsi
  801864:	48 89 c7             	mov    %rax,%rdi
  801867:	48 b8 dd 12 80 00 00 	movabs $0x8012dd,%rax
  80186e:	00 00 00 
  801871:	ff d0                	callq  *%rax
  801873:	85 c0                	test   %eax,%eax
  801875:	75 b6                	jne    80182d <strstr+0x47>

	return (char *) (in - 1);
  801877:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187b:	48 83 e8 01          	sub    $0x1,%rax
}
  80187f:	c9                   	leaveq 
  801880:	c3                   	retq   

0000000000801881 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801881:	55                   	push   %rbp
  801882:	48 89 e5             	mov    %rsp,%rbp
  801885:	53                   	push   %rbx
  801886:	48 83 ec 48          	sub    $0x48,%rsp
  80188a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80188d:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801890:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801894:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801898:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80189c:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018a0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018a3:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8018a7:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8018ab:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8018af:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8018b3:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8018b7:	4c 89 c3             	mov    %r8,%rbx
  8018ba:	cd 30                	int    $0x30
  8018bc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8018c0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8018c4:	74 3e                	je     801904 <syscall+0x83>
  8018c6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018cb:	7e 37                	jle    801904 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018d1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018d4:	49 89 d0             	mov    %rdx,%r8
  8018d7:	89 c1                	mov    %eax,%ecx
  8018d9:	48 ba c8 47 80 00 00 	movabs $0x8047c8,%rdx
  8018e0:	00 00 00 
  8018e3:	be 23 00 00 00       	mov    $0x23,%esi
  8018e8:	48 bf e5 47 80 00 00 	movabs $0x8047e5,%rdi
  8018ef:	00 00 00 
  8018f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f7:	49 b9 55 03 80 00 00 	movabs $0x800355,%r9
  8018fe:	00 00 00 
  801901:	41 ff d1             	callq  *%r9

	return ret;
  801904:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801908:	48 83 c4 48          	add    $0x48,%rsp
  80190c:	5b                   	pop    %rbx
  80190d:	5d                   	pop    %rbp
  80190e:	c3                   	retq   

000000000080190f <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80190f:	55                   	push   %rbp
  801910:	48 89 e5             	mov    %rsp,%rbp
  801913:	48 83 ec 10          	sub    $0x10,%rsp
  801917:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80191b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80191f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801923:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801927:	48 83 ec 08          	sub    $0x8,%rsp
  80192b:	6a 00                	pushq  $0x0
  80192d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801933:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801939:	48 89 d1             	mov    %rdx,%rcx
  80193c:	48 89 c2             	mov    %rax,%rdx
  80193f:	be 00 00 00 00       	mov    $0x0,%esi
  801944:	bf 00 00 00 00       	mov    $0x0,%edi
  801949:	48 b8 81 18 80 00 00 	movabs $0x801881,%rax
  801950:	00 00 00 
  801953:	ff d0                	callq  *%rax
  801955:	48 83 c4 10          	add    $0x10,%rsp
}
  801959:	c9                   	leaveq 
  80195a:	c3                   	retq   

000000000080195b <sys_cgetc>:

int
sys_cgetc(void)
{
  80195b:	55                   	push   %rbp
  80195c:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80195f:	48 83 ec 08          	sub    $0x8,%rsp
  801963:	6a 00                	pushq  $0x0
  801965:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80196b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801971:	b9 00 00 00 00       	mov    $0x0,%ecx
  801976:	ba 00 00 00 00       	mov    $0x0,%edx
  80197b:	be 00 00 00 00       	mov    $0x0,%esi
  801980:	bf 01 00 00 00       	mov    $0x1,%edi
  801985:	48 b8 81 18 80 00 00 	movabs $0x801881,%rax
  80198c:	00 00 00 
  80198f:	ff d0                	callq  *%rax
  801991:	48 83 c4 10          	add    $0x10,%rsp
}
  801995:	c9                   	leaveq 
  801996:	c3                   	retq   

0000000000801997 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801997:	55                   	push   %rbp
  801998:	48 89 e5             	mov    %rsp,%rbp
  80199b:	48 83 ec 10          	sub    $0x10,%rsp
  80199f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8019a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019a5:	48 98                	cltq   
  8019a7:	48 83 ec 08          	sub    $0x8,%rsp
  8019ab:	6a 00                	pushq  $0x0
  8019ad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019be:	48 89 c2             	mov    %rax,%rdx
  8019c1:	be 01 00 00 00       	mov    $0x1,%esi
  8019c6:	bf 03 00 00 00       	mov    $0x3,%edi
  8019cb:	48 b8 81 18 80 00 00 	movabs $0x801881,%rax
  8019d2:	00 00 00 
  8019d5:	ff d0                	callq  *%rax
  8019d7:	48 83 c4 10          	add    $0x10,%rsp
}
  8019db:	c9                   	leaveq 
  8019dc:	c3                   	retq   

00000000008019dd <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8019dd:	55                   	push   %rbp
  8019de:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8019e1:	48 83 ec 08          	sub    $0x8,%rsp
  8019e5:	6a 00                	pushq  $0x0
  8019e7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019f3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8019fd:	be 00 00 00 00       	mov    $0x0,%esi
  801a02:	bf 02 00 00 00       	mov    $0x2,%edi
  801a07:	48 b8 81 18 80 00 00 	movabs $0x801881,%rax
  801a0e:	00 00 00 
  801a11:	ff d0                	callq  *%rax
  801a13:	48 83 c4 10          	add    $0x10,%rsp
}
  801a17:	c9                   	leaveq 
  801a18:	c3                   	retq   

0000000000801a19 <sys_yield>:

void
sys_yield(void)
{
  801a19:	55                   	push   %rbp
  801a1a:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a1d:	48 83 ec 08          	sub    $0x8,%rsp
  801a21:	6a 00                	pushq  $0x0
  801a23:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a29:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a2f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a34:	ba 00 00 00 00       	mov    $0x0,%edx
  801a39:	be 00 00 00 00       	mov    $0x0,%esi
  801a3e:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a43:	48 b8 81 18 80 00 00 	movabs $0x801881,%rax
  801a4a:	00 00 00 
  801a4d:	ff d0                	callq  *%rax
  801a4f:	48 83 c4 10          	add    $0x10,%rsp
}
  801a53:	c9                   	leaveq 
  801a54:	c3                   	retq   

0000000000801a55 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a55:	55                   	push   %rbp
  801a56:	48 89 e5             	mov    %rsp,%rbp
  801a59:	48 83 ec 10          	sub    $0x10,%rsp
  801a5d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a60:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a64:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a67:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a6a:	48 63 c8             	movslq %eax,%rcx
  801a6d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a74:	48 98                	cltq   
  801a76:	48 83 ec 08          	sub    $0x8,%rsp
  801a7a:	6a 00                	pushq  $0x0
  801a7c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a82:	49 89 c8             	mov    %rcx,%r8
  801a85:	48 89 d1             	mov    %rdx,%rcx
  801a88:	48 89 c2             	mov    %rax,%rdx
  801a8b:	be 01 00 00 00       	mov    $0x1,%esi
  801a90:	bf 04 00 00 00       	mov    $0x4,%edi
  801a95:	48 b8 81 18 80 00 00 	movabs $0x801881,%rax
  801a9c:	00 00 00 
  801a9f:	ff d0                	callq  *%rax
  801aa1:	48 83 c4 10          	add    $0x10,%rsp
}
  801aa5:	c9                   	leaveq 
  801aa6:	c3                   	retq   

0000000000801aa7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801aa7:	55                   	push   %rbp
  801aa8:	48 89 e5             	mov    %rsp,%rbp
  801aab:	48 83 ec 20          	sub    $0x20,%rsp
  801aaf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ab2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ab6:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801ab9:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801abd:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801ac1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ac4:	48 63 c8             	movslq %eax,%rcx
  801ac7:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801acb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ace:	48 63 f0             	movslq %eax,%rsi
  801ad1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ad5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ad8:	48 98                	cltq   
  801ada:	48 83 ec 08          	sub    $0x8,%rsp
  801ade:	51                   	push   %rcx
  801adf:	49 89 f9             	mov    %rdi,%r9
  801ae2:	49 89 f0             	mov    %rsi,%r8
  801ae5:	48 89 d1             	mov    %rdx,%rcx
  801ae8:	48 89 c2             	mov    %rax,%rdx
  801aeb:	be 01 00 00 00       	mov    $0x1,%esi
  801af0:	bf 05 00 00 00       	mov    $0x5,%edi
  801af5:	48 b8 81 18 80 00 00 	movabs $0x801881,%rax
  801afc:	00 00 00 
  801aff:	ff d0                	callq  *%rax
  801b01:	48 83 c4 10          	add    $0x10,%rsp
}
  801b05:	c9                   	leaveq 
  801b06:	c3                   	retq   

0000000000801b07 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b07:	55                   	push   %rbp
  801b08:	48 89 e5             	mov    %rsp,%rbp
  801b0b:	48 83 ec 10          	sub    $0x10,%rsp
  801b0f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b12:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b16:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b1d:	48 98                	cltq   
  801b1f:	48 83 ec 08          	sub    $0x8,%rsp
  801b23:	6a 00                	pushq  $0x0
  801b25:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b2b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b31:	48 89 d1             	mov    %rdx,%rcx
  801b34:	48 89 c2             	mov    %rax,%rdx
  801b37:	be 01 00 00 00       	mov    $0x1,%esi
  801b3c:	bf 06 00 00 00       	mov    $0x6,%edi
  801b41:	48 b8 81 18 80 00 00 	movabs $0x801881,%rax
  801b48:	00 00 00 
  801b4b:	ff d0                	callq  *%rax
  801b4d:	48 83 c4 10          	add    $0x10,%rsp
}
  801b51:	c9                   	leaveq 
  801b52:	c3                   	retq   

0000000000801b53 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b53:	55                   	push   %rbp
  801b54:	48 89 e5             	mov    %rsp,%rbp
  801b57:	48 83 ec 10          	sub    $0x10,%rsp
  801b5b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b5e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b61:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b64:	48 63 d0             	movslq %eax,%rdx
  801b67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b6a:	48 98                	cltq   
  801b6c:	48 83 ec 08          	sub    $0x8,%rsp
  801b70:	6a 00                	pushq  $0x0
  801b72:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b78:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b7e:	48 89 d1             	mov    %rdx,%rcx
  801b81:	48 89 c2             	mov    %rax,%rdx
  801b84:	be 01 00 00 00       	mov    $0x1,%esi
  801b89:	bf 08 00 00 00       	mov    $0x8,%edi
  801b8e:	48 b8 81 18 80 00 00 	movabs $0x801881,%rax
  801b95:	00 00 00 
  801b98:	ff d0                	callq  *%rax
  801b9a:	48 83 c4 10          	add    $0x10,%rsp
}
  801b9e:	c9                   	leaveq 
  801b9f:	c3                   	retq   

0000000000801ba0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ba0:	55                   	push   %rbp
  801ba1:	48 89 e5             	mov    %rsp,%rbp
  801ba4:	48 83 ec 10          	sub    $0x10,%rsp
  801ba8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801baf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb6:	48 98                	cltq   
  801bb8:	48 83 ec 08          	sub    $0x8,%rsp
  801bbc:	6a 00                	pushq  $0x0
  801bbe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bca:	48 89 d1             	mov    %rdx,%rcx
  801bcd:	48 89 c2             	mov    %rax,%rdx
  801bd0:	be 01 00 00 00       	mov    $0x1,%esi
  801bd5:	bf 09 00 00 00       	mov    $0x9,%edi
  801bda:	48 b8 81 18 80 00 00 	movabs $0x801881,%rax
  801be1:	00 00 00 
  801be4:	ff d0                	callq  *%rax
  801be6:	48 83 c4 10          	add    $0x10,%rsp
}
  801bea:	c9                   	leaveq 
  801beb:	c3                   	retq   

0000000000801bec <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801bec:	55                   	push   %rbp
  801bed:	48 89 e5             	mov    %rsp,%rbp
  801bf0:	48 83 ec 10          	sub    $0x10,%rsp
  801bf4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bf7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801bfb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c02:	48 98                	cltq   
  801c04:	48 83 ec 08          	sub    $0x8,%rsp
  801c08:	6a 00                	pushq  $0x0
  801c0a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c10:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c16:	48 89 d1             	mov    %rdx,%rcx
  801c19:	48 89 c2             	mov    %rax,%rdx
  801c1c:	be 01 00 00 00       	mov    $0x1,%esi
  801c21:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c26:	48 b8 81 18 80 00 00 	movabs $0x801881,%rax
  801c2d:	00 00 00 
  801c30:	ff d0                	callq  *%rax
  801c32:	48 83 c4 10          	add    $0x10,%rsp
}
  801c36:	c9                   	leaveq 
  801c37:	c3                   	retq   

0000000000801c38 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c38:	55                   	push   %rbp
  801c39:	48 89 e5             	mov    %rsp,%rbp
  801c3c:	48 83 ec 20          	sub    $0x20,%rsp
  801c40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c47:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c4b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c4e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c51:	48 63 f0             	movslq %eax,%rsi
  801c54:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c5b:	48 98                	cltq   
  801c5d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c61:	48 83 ec 08          	sub    $0x8,%rsp
  801c65:	6a 00                	pushq  $0x0
  801c67:	49 89 f1             	mov    %rsi,%r9
  801c6a:	49 89 c8             	mov    %rcx,%r8
  801c6d:	48 89 d1             	mov    %rdx,%rcx
  801c70:	48 89 c2             	mov    %rax,%rdx
  801c73:	be 00 00 00 00       	mov    $0x0,%esi
  801c78:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c7d:	48 b8 81 18 80 00 00 	movabs $0x801881,%rax
  801c84:	00 00 00 
  801c87:	ff d0                	callq  *%rax
  801c89:	48 83 c4 10          	add    $0x10,%rsp
}
  801c8d:	c9                   	leaveq 
  801c8e:	c3                   	retq   

0000000000801c8f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c8f:	55                   	push   %rbp
  801c90:	48 89 e5             	mov    %rsp,%rbp
  801c93:	48 83 ec 10          	sub    $0x10,%rsp
  801c97:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c9f:	48 83 ec 08          	sub    $0x8,%rsp
  801ca3:	6a 00                	pushq  $0x0
  801ca5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cb1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cb6:	48 89 c2             	mov    %rax,%rdx
  801cb9:	be 01 00 00 00       	mov    $0x1,%esi
  801cbe:	bf 0d 00 00 00       	mov    $0xd,%edi
  801cc3:	48 b8 81 18 80 00 00 	movabs $0x801881,%rax
  801cca:	00 00 00 
  801ccd:	ff d0                	callq  *%rax
  801ccf:	48 83 c4 10          	add    $0x10,%rsp
}
  801cd3:	c9                   	leaveq 
  801cd4:	c3                   	retq   

0000000000801cd5 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801cd5:	55                   	push   %rbp
  801cd6:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801cd9:	48 83 ec 08          	sub    $0x8,%rsp
  801cdd:	6a 00                	pushq  $0x0
  801cdf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ce5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ceb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cf0:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf5:	be 00 00 00 00       	mov    $0x0,%esi
  801cfa:	bf 0e 00 00 00       	mov    $0xe,%edi
  801cff:	48 b8 81 18 80 00 00 	movabs $0x801881,%rax
  801d06:	00 00 00 
  801d09:	ff d0                	callq  *%rax
  801d0b:	48 83 c4 10          	add    $0x10,%rsp
}
  801d0f:	c9                   	leaveq 
  801d10:	c3                   	retq   

0000000000801d11 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801d11:	55                   	push   %rbp
  801d12:	48 89 e5             	mov    %rsp,%rbp
  801d15:	48 83 ec 20          	sub    $0x20,%rsp
  801d19:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d1c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d20:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d23:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d27:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801d2b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d2e:	48 63 c8             	movslq %eax,%rcx
  801d31:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d35:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d38:	48 63 f0             	movslq %eax,%rsi
  801d3b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d42:	48 98                	cltq   
  801d44:	48 83 ec 08          	sub    $0x8,%rsp
  801d48:	51                   	push   %rcx
  801d49:	49 89 f9             	mov    %rdi,%r9
  801d4c:	49 89 f0             	mov    %rsi,%r8
  801d4f:	48 89 d1             	mov    %rdx,%rcx
  801d52:	48 89 c2             	mov    %rax,%rdx
  801d55:	be 00 00 00 00       	mov    $0x0,%esi
  801d5a:	bf 0f 00 00 00       	mov    $0xf,%edi
  801d5f:	48 b8 81 18 80 00 00 	movabs $0x801881,%rax
  801d66:	00 00 00 
  801d69:	ff d0                	callq  *%rax
  801d6b:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801d6f:	c9                   	leaveq 
  801d70:	c3                   	retq   

0000000000801d71 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801d71:	55                   	push   %rbp
  801d72:	48 89 e5             	mov    %rsp,%rbp
  801d75:	48 83 ec 10          	sub    $0x10,%rsp
  801d79:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d7d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801d81:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d89:	48 83 ec 08          	sub    $0x8,%rsp
  801d8d:	6a 00                	pushq  $0x0
  801d8f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d95:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d9b:	48 89 d1             	mov    %rdx,%rcx
  801d9e:	48 89 c2             	mov    %rax,%rdx
  801da1:	be 00 00 00 00       	mov    $0x0,%esi
  801da6:	bf 10 00 00 00       	mov    $0x10,%edi
  801dab:	48 b8 81 18 80 00 00 	movabs $0x801881,%rax
  801db2:	00 00 00 
  801db5:	ff d0                	callq  *%rax
  801db7:	48 83 c4 10          	add    $0x10,%rsp
}
  801dbb:	c9                   	leaveq 
  801dbc:	c3                   	retq   

0000000000801dbd <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801dbd:	55                   	push   %rbp
  801dbe:	48 89 e5             	mov    %rsp,%rbp
  801dc1:	48 83 ec 08          	sub    $0x8,%rsp
  801dc5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801dc9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801dcd:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801dd4:	ff ff ff 
  801dd7:	48 01 d0             	add    %rdx,%rax
  801dda:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801dde:	c9                   	leaveq 
  801ddf:	c3                   	retq   

0000000000801de0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801de0:	55                   	push   %rbp
  801de1:	48 89 e5             	mov    %rsp,%rbp
  801de4:	48 83 ec 08          	sub    $0x8,%rsp
  801de8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801dec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801df0:	48 89 c7             	mov    %rax,%rdi
  801df3:	48 b8 bd 1d 80 00 00 	movabs $0x801dbd,%rax
  801dfa:	00 00 00 
  801dfd:	ff d0                	callq  *%rax
  801dff:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801e05:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801e09:	c9                   	leaveq 
  801e0a:	c3                   	retq   

0000000000801e0b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e0b:	55                   	push   %rbp
  801e0c:	48 89 e5             	mov    %rsp,%rbp
  801e0f:	48 83 ec 18          	sub    $0x18,%rsp
  801e13:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e17:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e1e:	eb 6b                	jmp    801e8b <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801e20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e23:	48 98                	cltq   
  801e25:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e2b:	48 c1 e0 0c          	shl    $0xc,%rax
  801e2f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e37:	48 c1 e8 15          	shr    $0x15,%rax
  801e3b:	48 89 c2             	mov    %rax,%rdx
  801e3e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e45:	01 00 00 
  801e48:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e4c:	83 e0 01             	and    $0x1,%eax
  801e4f:	48 85 c0             	test   %rax,%rax
  801e52:	74 21                	je     801e75 <fd_alloc+0x6a>
  801e54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e58:	48 c1 e8 0c          	shr    $0xc,%rax
  801e5c:	48 89 c2             	mov    %rax,%rdx
  801e5f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e66:	01 00 00 
  801e69:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e6d:	83 e0 01             	and    $0x1,%eax
  801e70:	48 85 c0             	test   %rax,%rax
  801e73:	75 12                	jne    801e87 <fd_alloc+0x7c>
			*fd_store = fd;
  801e75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e79:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e7d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e80:	b8 00 00 00 00       	mov    $0x0,%eax
  801e85:	eb 1a                	jmp    801ea1 <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  801e87:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e8b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e8f:	7e 8f                	jle    801e20 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  801e91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e95:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e9c:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801ea1:	c9                   	leaveq 
  801ea2:	c3                   	retq   

0000000000801ea3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ea3:	55                   	push   %rbp
  801ea4:	48 89 e5             	mov    %rsp,%rbp
  801ea7:	48 83 ec 20          	sub    $0x20,%rsp
  801eab:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801eae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801eb2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801eb6:	78 06                	js     801ebe <fd_lookup+0x1b>
  801eb8:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801ebc:	7e 07                	jle    801ec5 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ebe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ec3:	eb 6c                	jmp    801f31 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801ec5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ec8:	48 98                	cltq   
  801eca:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ed0:	48 c1 e0 0c          	shl    $0xc,%rax
  801ed4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ed8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801edc:	48 c1 e8 15          	shr    $0x15,%rax
  801ee0:	48 89 c2             	mov    %rax,%rdx
  801ee3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801eea:	01 00 00 
  801eed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ef1:	83 e0 01             	and    $0x1,%eax
  801ef4:	48 85 c0             	test   %rax,%rax
  801ef7:	74 21                	je     801f1a <fd_lookup+0x77>
  801ef9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801efd:	48 c1 e8 0c          	shr    $0xc,%rax
  801f01:	48 89 c2             	mov    %rax,%rdx
  801f04:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f0b:	01 00 00 
  801f0e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f12:	83 e0 01             	and    $0x1,%eax
  801f15:	48 85 c0             	test   %rax,%rax
  801f18:	75 07                	jne    801f21 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f1a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f1f:	eb 10                	jmp    801f31 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801f21:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f25:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f29:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f31:	c9                   	leaveq 
  801f32:	c3                   	retq   

0000000000801f33 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f33:	55                   	push   %rbp
  801f34:	48 89 e5             	mov    %rsp,%rbp
  801f37:	48 83 ec 30          	sub    $0x30,%rsp
  801f3b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f3f:	89 f0                	mov    %esi,%eax
  801f41:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f48:	48 89 c7             	mov    %rax,%rdi
  801f4b:	48 b8 bd 1d 80 00 00 	movabs $0x801dbd,%rax
  801f52:	00 00 00 
  801f55:	ff d0                	callq  *%rax
  801f57:	89 c2                	mov    %eax,%edx
  801f59:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801f5d:	48 89 c6             	mov    %rax,%rsi
  801f60:	89 d7                	mov    %edx,%edi
  801f62:	48 b8 a3 1e 80 00 00 	movabs $0x801ea3,%rax
  801f69:	00 00 00 
  801f6c:	ff d0                	callq  *%rax
  801f6e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f75:	78 0a                	js     801f81 <fd_close+0x4e>
	    || fd != fd2)
  801f77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f7b:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f7f:	74 12                	je     801f93 <fd_close+0x60>
		return (must_exist ? r : 0);
  801f81:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f85:	74 05                	je     801f8c <fd_close+0x59>
  801f87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f8a:	eb 70                	jmp    801ffc <fd_close+0xc9>
  801f8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f91:	eb 69                	jmp    801ffc <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f97:	8b 00                	mov    (%rax),%eax
  801f99:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f9d:	48 89 d6             	mov    %rdx,%rsi
  801fa0:	89 c7                	mov    %eax,%edi
  801fa2:	48 b8 fe 1f 80 00 00 	movabs $0x801ffe,%rax
  801fa9:	00 00 00 
  801fac:	ff d0                	callq  *%rax
  801fae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fb1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fb5:	78 2a                	js     801fe1 <fd_close+0xae>
		if (dev->dev_close)
  801fb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fbb:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fbf:	48 85 c0             	test   %rax,%rax
  801fc2:	74 16                	je     801fda <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  801fc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fc8:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fcc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801fd0:	48 89 d7             	mov    %rdx,%rdi
  801fd3:	ff d0                	callq  *%rax
  801fd5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fd8:	eb 07                	jmp    801fe1 <fd_close+0xae>
		else
			r = 0;
  801fda:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801fe1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fe5:	48 89 c6             	mov    %rax,%rsi
  801fe8:	bf 00 00 00 00       	mov    $0x0,%edi
  801fed:	48 b8 07 1b 80 00 00 	movabs $0x801b07,%rax
  801ff4:	00 00 00 
  801ff7:	ff d0                	callq  *%rax
	return r;
  801ff9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801ffc:	c9                   	leaveq 
  801ffd:	c3                   	retq   

0000000000801ffe <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801ffe:	55                   	push   %rbp
  801fff:	48 89 e5             	mov    %rsp,%rbp
  802002:	48 83 ec 20          	sub    $0x20,%rsp
  802006:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802009:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80200d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802014:	eb 41                	jmp    802057 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802016:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80201d:	00 00 00 
  802020:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802023:	48 63 d2             	movslq %edx,%rdx
  802026:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80202a:	8b 00                	mov    (%rax),%eax
  80202c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80202f:	75 22                	jne    802053 <dev_lookup+0x55>
			*dev = devtab[i];
  802031:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802038:	00 00 00 
  80203b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80203e:	48 63 d2             	movslq %edx,%rdx
  802041:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802045:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802049:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80204c:	b8 00 00 00 00       	mov    $0x0,%eax
  802051:	eb 60                	jmp    8020b3 <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  802053:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802057:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80205e:	00 00 00 
  802061:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802064:	48 63 d2             	movslq %edx,%rdx
  802067:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80206b:	48 85 c0             	test   %rax,%rax
  80206e:	75 a6                	jne    802016 <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802070:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802077:	00 00 00 
  80207a:	48 8b 00             	mov    (%rax),%rax
  80207d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802083:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802086:	89 c6                	mov    %eax,%esi
  802088:	48 bf f8 47 80 00 00 	movabs $0x8047f8,%rdi
  80208f:	00 00 00 
  802092:	b8 00 00 00 00       	mov    $0x0,%eax
  802097:	48 b9 8e 05 80 00 00 	movabs $0x80058e,%rcx
  80209e:	00 00 00 
  8020a1:	ff d1                	callq  *%rcx
	*dev = 0;
  8020a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020a7:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8020ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8020b3:	c9                   	leaveq 
  8020b4:	c3                   	retq   

00000000008020b5 <close>:

int
close(int fdnum)
{
  8020b5:	55                   	push   %rbp
  8020b6:	48 89 e5             	mov    %rsp,%rbp
  8020b9:	48 83 ec 20          	sub    $0x20,%rsp
  8020bd:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020c0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020c4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020c7:	48 89 d6             	mov    %rdx,%rsi
  8020ca:	89 c7                	mov    %eax,%edi
  8020cc:	48 b8 a3 1e 80 00 00 	movabs $0x801ea3,%rax
  8020d3:	00 00 00 
  8020d6:	ff d0                	callq  *%rax
  8020d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020df:	79 05                	jns    8020e6 <close+0x31>
		return r;
  8020e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020e4:	eb 18                	jmp    8020fe <close+0x49>
	else
		return fd_close(fd, 1);
  8020e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020ea:	be 01 00 00 00       	mov    $0x1,%esi
  8020ef:	48 89 c7             	mov    %rax,%rdi
  8020f2:	48 b8 33 1f 80 00 00 	movabs $0x801f33,%rax
  8020f9:	00 00 00 
  8020fc:	ff d0                	callq  *%rax
}
  8020fe:	c9                   	leaveq 
  8020ff:	c3                   	retq   

0000000000802100 <close_all>:

void
close_all(void)
{
  802100:	55                   	push   %rbp
  802101:	48 89 e5             	mov    %rsp,%rbp
  802104:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802108:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80210f:	eb 15                	jmp    802126 <close_all+0x26>
		close(i);
  802111:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802114:	89 c7                	mov    %eax,%edi
  802116:	48 b8 b5 20 80 00 00 	movabs $0x8020b5,%rax
  80211d:	00 00 00 
  802120:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  802122:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802126:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80212a:	7e e5                	jle    802111 <close_all+0x11>
}
  80212c:	c9                   	leaveq 
  80212d:	c3                   	retq   

000000000080212e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80212e:	55                   	push   %rbp
  80212f:	48 89 e5             	mov    %rsp,%rbp
  802132:	48 83 ec 40          	sub    $0x40,%rsp
  802136:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802139:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80213c:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802140:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802143:	48 89 d6             	mov    %rdx,%rsi
  802146:	89 c7                	mov    %eax,%edi
  802148:	48 b8 a3 1e 80 00 00 	movabs $0x801ea3,%rax
  80214f:	00 00 00 
  802152:	ff d0                	callq  *%rax
  802154:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802157:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80215b:	79 08                	jns    802165 <dup+0x37>
		return r;
  80215d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802160:	e9 70 01 00 00       	jmpq   8022d5 <dup+0x1a7>
	close(newfdnum);
  802165:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802168:	89 c7                	mov    %eax,%edi
  80216a:	48 b8 b5 20 80 00 00 	movabs $0x8020b5,%rax
  802171:	00 00 00 
  802174:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802176:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802179:	48 98                	cltq   
  80217b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802181:	48 c1 e0 0c          	shl    $0xc,%rax
  802185:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802189:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80218d:	48 89 c7             	mov    %rax,%rdi
  802190:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  802197:	00 00 00 
  80219a:	ff d0                	callq  *%rax
  80219c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8021a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021a4:	48 89 c7             	mov    %rax,%rdi
  8021a7:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  8021ae:	00 00 00 
  8021b1:	ff d0                	callq  *%rax
  8021b3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8021b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021bb:	48 c1 e8 15          	shr    $0x15,%rax
  8021bf:	48 89 c2             	mov    %rax,%rdx
  8021c2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021c9:	01 00 00 
  8021cc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021d0:	83 e0 01             	and    $0x1,%eax
  8021d3:	48 85 c0             	test   %rax,%rax
  8021d6:	74 73                	je     80224b <dup+0x11d>
  8021d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021dc:	48 c1 e8 0c          	shr    $0xc,%rax
  8021e0:	48 89 c2             	mov    %rax,%rdx
  8021e3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021ea:	01 00 00 
  8021ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021f1:	83 e0 01             	and    $0x1,%eax
  8021f4:	48 85 c0             	test   %rax,%rax
  8021f7:	74 52                	je     80224b <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8021f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021fd:	48 c1 e8 0c          	shr    $0xc,%rax
  802201:	48 89 c2             	mov    %rax,%rdx
  802204:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80220b:	01 00 00 
  80220e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802212:	25 07 0e 00 00       	and    $0xe07,%eax
  802217:	89 c1                	mov    %eax,%ecx
  802219:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80221d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802221:	41 89 c8             	mov    %ecx,%r8d
  802224:	48 89 d1             	mov    %rdx,%rcx
  802227:	ba 00 00 00 00       	mov    $0x0,%edx
  80222c:	48 89 c6             	mov    %rax,%rsi
  80222f:	bf 00 00 00 00       	mov    $0x0,%edi
  802234:	48 b8 a7 1a 80 00 00 	movabs $0x801aa7,%rax
  80223b:	00 00 00 
  80223e:	ff d0                	callq  *%rax
  802240:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802243:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802247:	79 02                	jns    80224b <dup+0x11d>
			goto err;
  802249:	eb 57                	jmp    8022a2 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80224b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80224f:	48 c1 e8 0c          	shr    $0xc,%rax
  802253:	48 89 c2             	mov    %rax,%rdx
  802256:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80225d:	01 00 00 
  802260:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802264:	25 07 0e 00 00       	and    $0xe07,%eax
  802269:	89 c1                	mov    %eax,%ecx
  80226b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80226f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802273:	41 89 c8             	mov    %ecx,%r8d
  802276:	48 89 d1             	mov    %rdx,%rcx
  802279:	ba 00 00 00 00       	mov    $0x0,%edx
  80227e:	48 89 c6             	mov    %rax,%rsi
  802281:	bf 00 00 00 00       	mov    $0x0,%edi
  802286:	48 b8 a7 1a 80 00 00 	movabs $0x801aa7,%rax
  80228d:	00 00 00 
  802290:	ff d0                	callq  *%rax
  802292:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802295:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802299:	79 02                	jns    80229d <dup+0x16f>
		goto err;
  80229b:	eb 05                	jmp    8022a2 <dup+0x174>

	return newfdnum;
  80229d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022a0:	eb 33                	jmp    8022d5 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8022a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022a6:	48 89 c6             	mov    %rax,%rsi
  8022a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8022ae:	48 b8 07 1b 80 00 00 	movabs $0x801b07,%rax
  8022b5:	00 00 00 
  8022b8:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8022ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022be:	48 89 c6             	mov    %rax,%rsi
  8022c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8022c6:	48 b8 07 1b 80 00 00 	movabs $0x801b07,%rax
  8022cd:	00 00 00 
  8022d0:	ff d0                	callq  *%rax
	return r;
  8022d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022d5:	c9                   	leaveq 
  8022d6:	c3                   	retq   

00000000008022d7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8022d7:	55                   	push   %rbp
  8022d8:	48 89 e5             	mov    %rsp,%rbp
  8022db:	48 83 ec 40          	sub    $0x40,%rsp
  8022df:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022e2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022e6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022ea:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022ee:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022f1:	48 89 d6             	mov    %rdx,%rsi
  8022f4:	89 c7                	mov    %eax,%edi
  8022f6:	48 b8 a3 1e 80 00 00 	movabs $0x801ea3,%rax
  8022fd:	00 00 00 
  802300:	ff d0                	callq  *%rax
  802302:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802305:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802309:	78 24                	js     80232f <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80230b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80230f:	8b 00                	mov    (%rax),%eax
  802311:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802315:	48 89 d6             	mov    %rdx,%rsi
  802318:	89 c7                	mov    %eax,%edi
  80231a:	48 b8 fe 1f 80 00 00 	movabs $0x801ffe,%rax
  802321:	00 00 00 
  802324:	ff d0                	callq  *%rax
  802326:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802329:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80232d:	79 05                	jns    802334 <read+0x5d>
		return r;
  80232f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802332:	eb 76                	jmp    8023aa <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802334:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802338:	8b 40 08             	mov    0x8(%rax),%eax
  80233b:	83 e0 03             	and    $0x3,%eax
  80233e:	83 f8 01             	cmp    $0x1,%eax
  802341:	75 3a                	jne    80237d <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802343:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80234a:	00 00 00 
  80234d:	48 8b 00             	mov    (%rax),%rax
  802350:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802356:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802359:	89 c6                	mov    %eax,%esi
  80235b:	48 bf 17 48 80 00 00 	movabs $0x804817,%rdi
  802362:	00 00 00 
  802365:	b8 00 00 00 00       	mov    $0x0,%eax
  80236a:	48 b9 8e 05 80 00 00 	movabs $0x80058e,%rcx
  802371:	00 00 00 
  802374:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802376:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80237b:	eb 2d                	jmp    8023aa <read+0xd3>
	}
	if (!dev->dev_read)
  80237d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802381:	48 8b 40 10          	mov    0x10(%rax),%rax
  802385:	48 85 c0             	test   %rax,%rax
  802388:	75 07                	jne    802391 <read+0xba>
		return -E_NOT_SUPP;
  80238a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80238f:	eb 19                	jmp    8023aa <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802391:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802395:	48 8b 40 10          	mov    0x10(%rax),%rax
  802399:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80239d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023a1:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023a5:	48 89 cf             	mov    %rcx,%rdi
  8023a8:	ff d0                	callq  *%rax
}
  8023aa:	c9                   	leaveq 
  8023ab:	c3                   	retq   

00000000008023ac <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8023ac:	55                   	push   %rbp
  8023ad:	48 89 e5             	mov    %rsp,%rbp
  8023b0:	48 83 ec 30          	sub    $0x30,%rsp
  8023b4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8023bb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023c6:	eb 49                	jmp    802411 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8023c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023cb:	48 98                	cltq   
  8023cd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023d1:	48 29 c2             	sub    %rax,%rdx
  8023d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023d7:	48 63 c8             	movslq %eax,%rcx
  8023da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023de:	48 01 c1             	add    %rax,%rcx
  8023e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023e4:	48 89 ce             	mov    %rcx,%rsi
  8023e7:	89 c7                	mov    %eax,%edi
  8023e9:	48 b8 d7 22 80 00 00 	movabs $0x8022d7,%rax
  8023f0:	00 00 00 
  8023f3:	ff d0                	callq  *%rax
  8023f5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8023f8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023fc:	79 05                	jns    802403 <readn+0x57>
			return m;
  8023fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802401:	eb 1c                	jmp    80241f <readn+0x73>
		if (m == 0)
  802403:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802407:	75 02                	jne    80240b <readn+0x5f>
			break;
  802409:	eb 11                	jmp    80241c <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  80240b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80240e:	01 45 fc             	add    %eax,-0x4(%rbp)
  802411:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802414:	48 98                	cltq   
  802416:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80241a:	72 ac                	jb     8023c8 <readn+0x1c>
	}
	return tot;
  80241c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80241f:	c9                   	leaveq 
  802420:	c3                   	retq   

0000000000802421 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802421:	55                   	push   %rbp
  802422:	48 89 e5             	mov    %rsp,%rbp
  802425:	48 83 ec 40          	sub    $0x40,%rsp
  802429:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80242c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802430:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802434:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802438:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80243b:	48 89 d6             	mov    %rdx,%rsi
  80243e:	89 c7                	mov    %eax,%edi
  802440:	48 b8 a3 1e 80 00 00 	movabs $0x801ea3,%rax
  802447:	00 00 00 
  80244a:	ff d0                	callq  *%rax
  80244c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80244f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802453:	78 24                	js     802479 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802455:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802459:	8b 00                	mov    (%rax),%eax
  80245b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80245f:	48 89 d6             	mov    %rdx,%rsi
  802462:	89 c7                	mov    %eax,%edi
  802464:	48 b8 fe 1f 80 00 00 	movabs $0x801ffe,%rax
  80246b:	00 00 00 
  80246e:	ff d0                	callq  *%rax
  802470:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802473:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802477:	79 05                	jns    80247e <write+0x5d>
		return r;
  802479:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80247c:	eb 75                	jmp    8024f3 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80247e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802482:	8b 40 08             	mov    0x8(%rax),%eax
  802485:	83 e0 03             	and    $0x3,%eax
  802488:	85 c0                	test   %eax,%eax
  80248a:	75 3a                	jne    8024c6 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80248c:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  802493:	00 00 00 
  802496:	48 8b 00             	mov    (%rax),%rax
  802499:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80249f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024a2:	89 c6                	mov    %eax,%esi
  8024a4:	48 bf 33 48 80 00 00 	movabs $0x804833,%rdi
  8024ab:	00 00 00 
  8024ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b3:	48 b9 8e 05 80 00 00 	movabs $0x80058e,%rcx
  8024ba:	00 00 00 
  8024bd:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024c4:	eb 2d                	jmp    8024f3 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8024c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ca:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024ce:	48 85 c0             	test   %rax,%rax
  8024d1:	75 07                	jne    8024da <write+0xb9>
		return -E_NOT_SUPP;
  8024d3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024d8:	eb 19                	jmp    8024f3 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8024da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024de:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024e2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024e6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024ea:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024ee:	48 89 cf             	mov    %rcx,%rdi
  8024f1:	ff d0                	callq  *%rax
}
  8024f3:	c9                   	leaveq 
  8024f4:	c3                   	retq   

00000000008024f5 <seek>:

int
seek(int fdnum, off_t offset)
{
  8024f5:	55                   	push   %rbp
  8024f6:	48 89 e5             	mov    %rsp,%rbp
  8024f9:	48 83 ec 18          	sub    $0x18,%rsp
  8024fd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802500:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802503:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802507:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80250a:	48 89 d6             	mov    %rdx,%rsi
  80250d:	89 c7                	mov    %eax,%edi
  80250f:	48 b8 a3 1e 80 00 00 	movabs $0x801ea3,%rax
  802516:	00 00 00 
  802519:	ff d0                	callq  *%rax
  80251b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80251e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802522:	79 05                	jns    802529 <seek+0x34>
		return r;
  802524:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802527:	eb 0f                	jmp    802538 <seek+0x43>
	fd->fd_offset = offset;
  802529:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80252d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802530:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802533:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802538:	c9                   	leaveq 
  802539:	c3                   	retq   

000000000080253a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80253a:	55                   	push   %rbp
  80253b:	48 89 e5             	mov    %rsp,%rbp
  80253e:	48 83 ec 30          	sub    $0x30,%rsp
  802542:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802545:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802548:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80254c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80254f:	48 89 d6             	mov    %rdx,%rsi
  802552:	89 c7                	mov    %eax,%edi
  802554:	48 b8 a3 1e 80 00 00 	movabs $0x801ea3,%rax
  80255b:	00 00 00 
  80255e:	ff d0                	callq  *%rax
  802560:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802563:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802567:	78 24                	js     80258d <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802569:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80256d:	8b 00                	mov    (%rax),%eax
  80256f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802573:	48 89 d6             	mov    %rdx,%rsi
  802576:	89 c7                	mov    %eax,%edi
  802578:	48 b8 fe 1f 80 00 00 	movabs $0x801ffe,%rax
  80257f:	00 00 00 
  802582:	ff d0                	callq  *%rax
  802584:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802587:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80258b:	79 05                	jns    802592 <ftruncate+0x58>
		return r;
  80258d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802590:	eb 72                	jmp    802604 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802592:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802596:	8b 40 08             	mov    0x8(%rax),%eax
  802599:	83 e0 03             	and    $0x3,%eax
  80259c:	85 c0                	test   %eax,%eax
  80259e:	75 3a                	jne    8025da <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8025a0:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8025a7:	00 00 00 
  8025aa:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8025ad:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025b3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025b6:	89 c6                	mov    %eax,%esi
  8025b8:	48 bf 50 48 80 00 00 	movabs $0x804850,%rdi
  8025bf:	00 00 00 
  8025c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c7:	48 b9 8e 05 80 00 00 	movabs $0x80058e,%rcx
  8025ce:	00 00 00 
  8025d1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8025d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025d8:	eb 2a                	jmp    802604 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8025da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025de:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025e2:	48 85 c0             	test   %rax,%rax
  8025e5:	75 07                	jne    8025ee <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8025e7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025ec:	eb 16                	jmp    802604 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8025ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f2:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025fa:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8025fd:	89 ce                	mov    %ecx,%esi
  8025ff:	48 89 d7             	mov    %rdx,%rdi
  802602:	ff d0                	callq  *%rax
}
  802604:	c9                   	leaveq 
  802605:	c3                   	retq   

0000000000802606 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802606:	55                   	push   %rbp
  802607:	48 89 e5             	mov    %rsp,%rbp
  80260a:	48 83 ec 30          	sub    $0x30,%rsp
  80260e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802611:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802615:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802619:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80261c:	48 89 d6             	mov    %rdx,%rsi
  80261f:	89 c7                	mov    %eax,%edi
  802621:	48 b8 a3 1e 80 00 00 	movabs $0x801ea3,%rax
  802628:	00 00 00 
  80262b:	ff d0                	callq  *%rax
  80262d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802630:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802634:	78 24                	js     80265a <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802636:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80263a:	8b 00                	mov    (%rax),%eax
  80263c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802640:	48 89 d6             	mov    %rdx,%rsi
  802643:	89 c7                	mov    %eax,%edi
  802645:	48 b8 fe 1f 80 00 00 	movabs $0x801ffe,%rax
  80264c:	00 00 00 
  80264f:	ff d0                	callq  *%rax
  802651:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802654:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802658:	79 05                	jns    80265f <fstat+0x59>
		return r;
  80265a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80265d:	eb 5e                	jmp    8026bd <fstat+0xb7>
	if (!dev->dev_stat)
  80265f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802663:	48 8b 40 28          	mov    0x28(%rax),%rax
  802667:	48 85 c0             	test   %rax,%rax
  80266a:	75 07                	jne    802673 <fstat+0x6d>
		return -E_NOT_SUPP;
  80266c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802671:	eb 4a                	jmp    8026bd <fstat+0xb7>
	stat->st_name[0] = 0;
  802673:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802677:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80267a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80267e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802685:	00 00 00 
	stat->st_isdir = 0;
  802688:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80268c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802693:	00 00 00 
	stat->st_dev = dev;
  802696:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80269a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80269e:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8026a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026a9:	48 8b 40 28          	mov    0x28(%rax),%rax
  8026ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026b1:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8026b5:	48 89 ce             	mov    %rcx,%rsi
  8026b8:	48 89 d7             	mov    %rdx,%rdi
  8026bb:	ff d0                	callq  *%rax
}
  8026bd:	c9                   	leaveq 
  8026be:	c3                   	retq   

00000000008026bf <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8026bf:	55                   	push   %rbp
  8026c0:	48 89 e5             	mov    %rsp,%rbp
  8026c3:	48 83 ec 20          	sub    $0x20,%rsp
  8026c7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026cb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d3:	be 00 00 00 00       	mov    $0x0,%esi
  8026d8:	48 89 c7             	mov    %rax,%rdi
  8026db:	48 b8 af 27 80 00 00 	movabs $0x8027af,%rax
  8026e2:	00 00 00 
  8026e5:	ff d0                	callq  *%rax
  8026e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ee:	79 05                	jns    8026f5 <stat+0x36>
		return fd;
  8026f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026f3:	eb 2f                	jmp    802724 <stat+0x65>
	r = fstat(fd, stat);
  8026f5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026fc:	48 89 d6             	mov    %rdx,%rsi
  8026ff:	89 c7                	mov    %eax,%edi
  802701:	48 b8 06 26 80 00 00 	movabs $0x802606,%rax
  802708:	00 00 00 
  80270b:	ff d0                	callq  *%rax
  80270d:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802710:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802713:	89 c7                	mov    %eax,%edi
  802715:	48 b8 b5 20 80 00 00 	movabs $0x8020b5,%rax
  80271c:	00 00 00 
  80271f:	ff d0                	callq  *%rax
	return r;
  802721:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802724:	c9                   	leaveq 
  802725:	c3                   	retq   

0000000000802726 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802726:	55                   	push   %rbp
  802727:	48 89 e5             	mov    %rsp,%rbp
  80272a:	48 83 ec 10          	sub    $0x10,%rsp
  80272e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802731:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802735:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80273c:	00 00 00 
  80273f:	8b 00                	mov    (%rax),%eax
  802741:	85 c0                	test   %eax,%eax
  802743:	75 1f                	jne    802764 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802745:	bf 01 00 00 00       	mov    $0x1,%edi
  80274a:	48 b8 34 41 80 00 00 	movabs $0x804134,%rax
  802751:	00 00 00 
  802754:	ff d0                	callq  *%rax
  802756:	89 c2                	mov    %eax,%edx
  802758:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80275f:	00 00 00 
  802762:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802764:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80276b:	00 00 00 
  80276e:	8b 00                	mov    (%rax),%eax
  802770:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802773:	b9 07 00 00 00       	mov    $0x7,%ecx
  802778:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80277f:	00 00 00 
  802782:	89 c7                	mov    %eax,%edi
  802784:	48 b8 a7 3f 80 00 00 	movabs $0x803fa7,%rax
  80278b:	00 00 00 
  80278e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802790:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802794:	ba 00 00 00 00       	mov    $0x0,%edx
  802799:	48 89 c6             	mov    %rax,%rsi
  80279c:	bf 00 00 00 00       	mov    $0x0,%edi
  8027a1:	48 b8 69 3f 80 00 00 	movabs $0x803f69,%rax
  8027a8:	00 00 00 
  8027ab:	ff d0                	callq  *%rax
}
  8027ad:	c9                   	leaveq 
  8027ae:	c3                   	retq   

00000000008027af <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8027af:	55                   	push   %rbp
  8027b0:	48 89 e5             	mov    %rsp,%rbp
  8027b3:	48 83 ec 10          	sub    $0x10,%rsp
  8027b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8027bb:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  8027be:	48 ba 76 48 80 00 00 	movabs $0x804876,%rdx
  8027c5:	00 00 00 
  8027c8:	be 4c 00 00 00       	mov    $0x4c,%esi
  8027cd:	48 bf 8b 48 80 00 00 	movabs $0x80488b,%rdi
  8027d4:	00 00 00 
  8027d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027dc:	48 b9 55 03 80 00 00 	movabs $0x800355,%rcx
  8027e3:	00 00 00 
  8027e6:	ff d1                	callq  *%rcx

00000000008027e8 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8027e8:	55                   	push   %rbp
  8027e9:	48 89 e5             	mov    %rsp,%rbp
  8027ec:	48 83 ec 10          	sub    $0x10,%rsp
  8027f0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8027f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027f8:	8b 50 0c             	mov    0xc(%rax),%edx
  8027fb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802802:	00 00 00 
  802805:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802807:	be 00 00 00 00       	mov    $0x0,%esi
  80280c:	bf 06 00 00 00       	mov    $0x6,%edi
  802811:	48 b8 26 27 80 00 00 	movabs $0x802726,%rax
  802818:	00 00 00 
  80281b:	ff d0                	callq  *%rax
}
  80281d:	c9                   	leaveq 
  80281e:	c3                   	retq   

000000000080281f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80281f:	55                   	push   %rbp
  802820:	48 89 e5             	mov    %rsp,%rbp
  802823:	48 83 ec 20          	sub    $0x20,%rsp
  802827:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80282b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80282f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  802833:	48 ba 96 48 80 00 00 	movabs $0x804896,%rdx
  80283a:	00 00 00 
  80283d:	be 6b 00 00 00       	mov    $0x6b,%esi
  802842:	48 bf 8b 48 80 00 00 	movabs $0x80488b,%rdi
  802849:	00 00 00 
  80284c:	b8 00 00 00 00       	mov    $0x0,%eax
  802851:	48 b9 55 03 80 00 00 	movabs $0x800355,%rcx
  802858:	00 00 00 
  80285b:	ff d1                	callq  *%rcx

000000000080285d <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80285d:	55                   	push   %rbp
  80285e:	48 89 e5             	mov    %rsp,%rbp
  802861:	48 83 ec 20          	sub    $0x20,%rsp
  802865:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802869:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80286d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  802871:	48 ba b3 48 80 00 00 	movabs $0x8048b3,%rdx
  802878:	00 00 00 
  80287b:	be 7b 00 00 00       	mov    $0x7b,%esi
  802880:	48 bf 8b 48 80 00 00 	movabs $0x80488b,%rdi
  802887:	00 00 00 
  80288a:	b8 00 00 00 00       	mov    $0x0,%eax
  80288f:	48 b9 55 03 80 00 00 	movabs $0x800355,%rcx
  802896:	00 00 00 
  802899:	ff d1                	callq  *%rcx

000000000080289b <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80289b:	55                   	push   %rbp
  80289c:	48 89 e5             	mov    %rsp,%rbp
  80289f:	48 83 ec 20          	sub    $0x20,%rsp
  8028a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8028ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028af:	8b 50 0c             	mov    0xc(%rax),%edx
  8028b2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028b9:	00 00 00 
  8028bc:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8028be:	be 00 00 00 00       	mov    $0x0,%esi
  8028c3:	bf 05 00 00 00       	mov    $0x5,%edi
  8028c8:	48 b8 26 27 80 00 00 	movabs $0x802726,%rax
  8028cf:	00 00 00 
  8028d2:	ff d0                	callq  *%rax
  8028d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028db:	79 05                	jns    8028e2 <devfile_stat+0x47>
		return r;
  8028dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028e0:	eb 56                	jmp    802938 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8028e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028e6:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8028ed:	00 00 00 
  8028f0:	48 89 c7             	mov    %rax,%rdi
  8028f3:	48 b8 28 11 80 00 00 	movabs $0x801128,%rax
  8028fa:	00 00 00 
  8028fd:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8028ff:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802906:	00 00 00 
  802909:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80290f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802913:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802919:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802920:	00 00 00 
  802923:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802929:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80292d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802933:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802938:	c9                   	leaveq 
  802939:	c3                   	retq   

000000000080293a <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80293a:	55                   	push   %rbp
  80293b:	48 89 e5             	mov    %rsp,%rbp
  80293e:	48 83 ec 10          	sub    $0x10,%rsp
  802942:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802946:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802949:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80294d:	8b 50 0c             	mov    0xc(%rax),%edx
  802950:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802957:	00 00 00 
  80295a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80295c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802963:	00 00 00 
  802966:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802969:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80296c:	be 00 00 00 00       	mov    $0x0,%esi
  802971:	bf 02 00 00 00       	mov    $0x2,%edi
  802976:	48 b8 26 27 80 00 00 	movabs $0x802726,%rax
  80297d:	00 00 00 
  802980:	ff d0                	callq  *%rax
}
  802982:	c9                   	leaveq 
  802983:	c3                   	retq   

0000000000802984 <remove>:

// Delete a file
int
remove(const char *path)
{
  802984:	55                   	push   %rbp
  802985:	48 89 e5             	mov    %rsp,%rbp
  802988:	48 83 ec 10          	sub    $0x10,%rsp
  80298c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802990:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802994:	48 89 c7             	mov    %rax,%rdi
  802997:	48 b8 bc 10 80 00 00 	movabs $0x8010bc,%rax
  80299e:	00 00 00 
  8029a1:	ff d0                	callq  *%rax
  8029a3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8029a8:	7e 07                	jle    8029b1 <remove+0x2d>
		return -E_BAD_PATH;
  8029aa:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8029af:	eb 33                	jmp    8029e4 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8029b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029b5:	48 89 c6             	mov    %rax,%rsi
  8029b8:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8029bf:	00 00 00 
  8029c2:	48 b8 28 11 80 00 00 	movabs $0x801128,%rax
  8029c9:	00 00 00 
  8029cc:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8029ce:	be 00 00 00 00       	mov    $0x0,%esi
  8029d3:	bf 07 00 00 00       	mov    $0x7,%edi
  8029d8:	48 b8 26 27 80 00 00 	movabs $0x802726,%rax
  8029df:	00 00 00 
  8029e2:	ff d0                	callq  *%rax
}
  8029e4:	c9                   	leaveq 
  8029e5:	c3                   	retq   

00000000008029e6 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8029e6:	55                   	push   %rbp
  8029e7:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8029ea:	be 00 00 00 00       	mov    $0x0,%esi
  8029ef:	bf 08 00 00 00       	mov    $0x8,%edi
  8029f4:	48 b8 26 27 80 00 00 	movabs $0x802726,%rax
  8029fb:	00 00 00 
  8029fe:	ff d0                	callq  *%rax
}
  802a00:	5d                   	pop    %rbp
  802a01:	c3                   	retq   

0000000000802a02 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802a02:	55                   	push   %rbp
  802a03:	48 89 e5             	mov    %rsp,%rbp
  802a06:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802a0d:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802a14:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802a1b:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802a22:	be 00 00 00 00       	mov    $0x0,%esi
  802a27:	48 89 c7             	mov    %rax,%rdi
  802a2a:	48 b8 af 27 80 00 00 	movabs $0x8027af,%rax
  802a31:	00 00 00 
  802a34:	ff d0                	callq  *%rax
  802a36:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802a39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a3d:	79 28                	jns    802a67 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802a3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a42:	89 c6                	mov    %eax,%esi
  802a44:	48 bf d1 48 80 00 00 	movabs $0x8048d1,%rdi
  802a4b:	00 00 00 
  802a4e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a53:	48 ba 8e 05 80 00 00 	movabs $0x80058e,%rdx
  802a5a:	00 00 00 
  802a5d:	ff d2                	callq  *%rdx
		return fd_src;
  802a5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a62:	e9 74 01 00 00       	jmpq   802bdb <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802a67:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802a6e:	be 01 01 00 00       	mov    $0x101,%esi
  802a73:	48 89 c7             	mov    %rax,%rdi
  802a76:	48 b8 af 27 80 00 00 	movabs $0x8027af,%rax
  802a7d:	00 00 00 
  802a80:	ff d0                	callq  *%rax
  802a82:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802a85:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a89:	79 39                	jns    802ac4 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802a8b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a8e:	89 c6                	mov    %eax,%esi
  802a90:	48 bf e7 48 80 00 00 	movabs $0x8048e7,%rdi
  802a97:	00 00 00 
  802a9a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a9f:	48 ba 8e 05 80 00 00 	movabs $0x80058e,%rdx
  802aa6:	00 00 00 
  802aa9:	ff d2                	callq  *%rdx
		close(fd_src);
  802aab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aae:	89 c7                	mov    %eax,%edi
  802ab0:	48 b8 b5 20 80 00 00 	movabs $0x8020b5,%rax
  802ab7:	00 00 00 
  802aba:	ff d0                	callq  *%rax
		return fd_dest;
  802abc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802abf:	e9 17 01 00 00       	jmpq   802bdb <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802ac4:	eb 74                	jmp    802b3a <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802ac6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ac9:	48 63 d0             	movslq %eax,%rdx
  802acc:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802ad3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ad6:	48 89 ce             	mov    %rcx,%rsi
  802ad9:	89 c7                	mov    %eax,%edi
  802adb:	48 b8 21 24 80 00 00 	movabs $0x802421,%rax
  802ae2:	00 00 00 
  802ae5:	ff d0                	callq  *%rax
  802ae7:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802aea:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802aee:	79 4a                	jns    802b3a <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802af0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802af3:	89 c6                	mov    %eax,%esi
  802af5:	48 bf 01 49 80 00 00 	movabs $0x804901,%rdi
  802afc:	00 00 00 
  802aff:	b8 00 00 00 00       	mov    $0x0,%eax
  802b04:	48 ba 8e 05 80 00 00 	movabs $0x80058e,%rdx
  802b0b:	00 00 00 
  802b0e:	ff d2                	callq  *%rdx
			close(fd_src);
  802b10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b13:	89 c7                	mov    %eax,%edi
  802b15:	48 b8 b5 20 80 00 00 	movabs $0x8020b5,%rax
  802b1c:	00 00 00 
  802b1f:	ff d0                	callq  *%rax
			close(fd_dest);
  802b21:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b24:	89 c7                	mov    %eax,%edi
  802b26:	48 b8 b5 20 80 00 00 	movabs $0x8020b5,%rax
  802b2d:	00 00 00 
  802b30:	ff d0                	callq  *%rax
			return write_size;
  802b32:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802b35:	e9 a1 00 00 00       	jmpq   802bdb <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802b3a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802b41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b44:	ba 00 02 00 00       	mov    $0x200,%edx
  802b49:	48 89 ce             	mov    %rcx,%rsi
  802b4c:	89 c7                	mov    %eax,%edi
  802b4e:	48 b8 d7 22 80 00 00 	movabs $0x8022d7,%rax
  802b55:	00 00 00 
  802b58:	ff d0                	callq  *%rax
  802b5a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802b5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802b61:	0f 8f 5f ff ff ff    	jg     802ac6 <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  802b67:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802b6b:	79 47                	jns    802bb4 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802b6d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b70:	89 c6                	mov    %eax,%esi
  802b72:	48 bf 14 49 80 00 00 	movabs $0x804914,%rdi
  802b79:	00 00 00 
  802b7c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b81:	48 ba 8e 05 80 00 00 	movabs $0x80058e,%rdx
  802b88:	00 00 00 
  802b8b:	ff d2                	callq  *%rdx
		close(fd_src);
  802b8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b90:	89 c7                	mov    %eax,%edi
  802b92:	48 b8 b5 20 80 00 00 	movabs $0x8020b5,%rax
  802b99:	00 00 00 
  802b9c:	ff d0                	callq  *%rax
		close(fd_dest);
  802b9e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ba1:	89 c7                	mov    %eax,%edi
  802ba3:	48 b8 b5 20 80 00 00 	movabs $0x8020b5,%rax
  802baa:	00 00 00 
  802bad:	ff d0                	callq  *%rax
		return read_size;
  802baf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802bb2:	eb 27                	jmp    802bdb <copy+0x1d9>
	}
	close(fd_src);
  802bb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb7:	89 c7                	mov    %eax,%edi
  802bb9:	48 b8 b5 20 80 00 00 	movabs $0x8020b5,%rax
  802bc0:	00 00 00 
  802bc3:	ff d0                	callq  *%rax
	close(fd_dest);
  802bc5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bc8:	89 c7                	mov    %eax,%edi
  802bca:	48 b8 b5 20 80 00 00 	movabs $0x8020b5,%rax
  802bd1:	00 00 00 
  802bd4:	ff d0                	callq  *%rax
	return 0;
  802bd6:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802bdb:	c9                   	leaveq 
  802bdc:	c3                   	retq   

0000000000802bdd <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802bdd:	55                   	push   %rbp
  802bde:	48 89 e5             	mov    %rsp,%rbp
  802be1:	48 83 ec 20          	sub    $0x20,%rsp
  802be5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802be9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bed:	8b 40 0c             	mov    0xc(%rax),%eax
  802bf0:	85 c0                	test   %eax,%eax
  802bf2:	7e 67                	jle    802c5b <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802bf4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf8:	8b 40 04             	mov    0x4(%rax),%eax
  802bfb:	48 63 d0             	movslq %eax,%rdx
  802bfe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c02:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802c06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c0a:	8b 00                	mov    (%rax),%eax
  802c0c:	48 89 ce             	mov    %rcx,%rsi
  802c0f:	89 c7                	mov    %eax,%edi
  802c11:	48 b8 21 24 80 00 00 	movabs $0x802421,%rax
  802c18:	00 00 00 
  802c1b:	ff d0                	callq  *%rax
  802c1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802c20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c24:	7e 13                	jle    802c39 <writebuf+0x5c>
			b->result += result;
  802c26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c2a:	8b 50 08             	mov    0x8(%rax),%edx
  802c2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c30:	01 c2                	add    %eax,%edx
  802c32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c36:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802c39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c3d:	8b 40 04             	mov    0x4(%rax),%eax
  802c40:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802c43:	74 16                	je     802c5b <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802c45:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c4e:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802c52:	89 c2                	mov    %eax,%edx
  802c54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c58:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802c5b:	c9                   	leaveq 
  802c5c:	c3                   	retq   

0000000000802c5d <putch>:

static void
putch(int ch, void *thunk)
{
  802c5d:	55                   	push   %rbp
  802c5e:	48 89 e5             	mov    %rsp,%rbp
  802c61:	48 83 ec 20          	sub    $0x20,%rsp
  802c65:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c68:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802c6c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c70:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802c74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c78:	8b 40 04             	mov    0x4(%rax),%eax
  802c7b:	8d 48 01             	lea    0x1(%rax),%ecx
  802c7e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802c82:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802c85:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802c88:	89 d1                	mov    %edx,%ecx
  802c8a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802c8e:	48 98                	cltq   
  802c90:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802c94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c98:	8b 40 04             	mov    0x4(%rax),%eax
  802c9b:	3d 00 01 00 00       	cmp    $0x100,%eax
  802ca0:	75 1e                	jne    802cc0 <putch+0x63>
		writebuf(b);
  802ca2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ca6:	48 89 c7             	mov    %rax,%rdi
  802ca9:	48 b8 dd 2b 80 00 00 	movabs $0x802bdd,%rax
  802cb0:	00 00 00 
  802cb3:	ff d0                	callq  *%rax
		b->idx = 0;
  802cb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cb9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802cc0:	c9                   	leaveq 
  802cc1:	c3                   	retq   

0000000000802cc2 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802cc2:	55                   	push   %rbp
  802cc3:	48 89 e5             	mov    %rsp,%rbp
  802cc6:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802ccd:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802cd3:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802cda:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802ce1:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802ce7:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802ced:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802cf4:	00 00 00 
	b.result = 0;
  802cf7:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802cfe:	00 00 00 
	b.error = 1;
  802d01:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802d08:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802d0b:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802d12:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802d19:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802d20:	48 89 c6             	mov    %rax,%rsi
  802d23:	48 bf 5d 2c 80 00 00 	movabs $0x802c5d,%rdi
  802d2a:	00 00 00 
  802d2d:	48 b8 2d 09 80 00 00 	movabs $0x80092d,%rax
  802d34:	00 00 00 
  802d37:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802d39:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802d3f:	85 c0                	test   %eax,%eax
  802d41:	7e 16                	jle    802d59 <vfprintf+0x97>
		writebuf(&b);
  802d43:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802d4a:	48 89 c7             	mov    %rax,%rdi
  802d4d:	48 b8 dd 2b 80 00 00 	movabs $0x802bdd,%rax
  802d54:	00 00 00 
  802d57:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802d59:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802d5f:	85 c0                	test   %eax,%eax
  802d61:	74 08                	je     802d6b <vfprintf+0xa9>
  802d63:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802d69:	eb 06                	jmp    802d71 <vfprintf+0xaf>
  802d6b:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802d71:	c9                   	leaveq 
  802d72:	c3                   	retq   

0000000000802d73 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802d73:	55                   	push   %rbp
  802d74:	48 89 e5             	mov    %rsp,%rbp
  802d77:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802d7e:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802d84:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802d8b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802d92:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802d99:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802da0:	84 c0                	test   %al,%al
  802da2:	74 20                	je     802dc4 <fprintf+0x51>
  802da4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802da8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802dac:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802db0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802db4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802db8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802dbc:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802dc0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802dc4:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802dcb:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802dd2:	00 00 00 
  802dd5:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802ddc:	00 00 00 
  802ddf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802de3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802dea:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802df1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802df8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802dff:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  802e06:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802e0c:	48 89 ce             	mov    %rcx,%rsi
  802e0f:	89 c7                	mov    %eax,%edi
  802e11:	48 b8 c2 2c 80 00 00 	movabs $0x802cc2,%rax
  802e18:	00 00 00 
  802e1b:	ff d0                	callq  *%rax
  802e1d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802e23:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802e29:	c9                   	leaveq 
  802e2a:	c3                   	retq   

0000000000802e2b <printf>:

int
printf(const char *fmt, ...)
{
  802e2b:	55                   	push   %rbp
  802e2c:	48 89 e5             	mov    %rsp,%rbp
  802e2f:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802e36:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802e3d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802e44:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802e4b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802e52:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802e59:	84 c0                	test   %al,%al
  802e5b:	74 20                	je     802e7d <printf+0x52>
  802e5d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802e61:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802e65:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802e69:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802e6d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802e71:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802e75:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802e79:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802e7d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802e84:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802e8b:	00 00 00 
  802e8e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802e95:	00 00 00 
  802e98:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802e9c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802ea3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802eaa:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  802eb1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802eb8:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802ebf:	48 89 c6             	mov    %rax,%rsi
  802ec2:	bf 01 00 00 00       	mov    $0x1,%edi
  802ec7:	48 b8 c2 2c 80 00 00 	movabs $0x802cc2,%rax
  802ece:	00 00 00 
  802ed1:	ff d0                	callq  *%rax
  802ed3:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802ed9:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802edf:	c9                   	leaveq 
  802ee0:	c3                   	retq   

0000000000802ee1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802ee1:	55                   	push   %rbp
  802ee2:	48 89 e5             	mov    %rsp,%rbp
  802ee5:	48 83 ec 20          	sub    $0x20,%rsp
  802ee9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802eec:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ef0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ef3:	48 89 d6             	mov    %rdx,%rsi
  802ef6:	89 c7                	mov    %eax,%edi
  802ef8:	48 b8 a3 1e 80 00 00 	movabs $0x801ea3,%rax
  802eff:	00 00 00 
  802f02:	ff d0                	callq  *%rax
  802f04:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f07:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f0b:	79 05                	jns    802f12 <fd2sockid+0x31>
		return r;
  802f0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f10:	eb 24                	jmp    802f36 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802f12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f16:	8b 10                	mov    (%rax),%edx
  802f18:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802f1f:	00 00 00 
  802f22:	8b 00                	mov    (%rax),%eax
  802f24:	39 c2                	cmp    %eax,%edx
  802f26:	74 07                	je     802f2f <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802f28:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f2d:	eb 07                	jmp    802f36 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802f2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f33:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802f36:	c9                   	leaveq 
  802f37:	c3                   	retq   

0000000000802f38 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802f38:	55                   	push   %rbp
  802f39:	48 89 e5             	mov    %rsp,%rbp
  802f3c:	48 83 ec 20          	sub    $0x20,%rsp
  802f40:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802f43:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802f47:	48 89 c7             	mov    %rax,%rdi
  802f4a:	48 b8 0b 1e 80 00 00 	movabs $0x801e0b,%rax
  802f51:	00 00 00 
  802f54:	ff d0                	callq  *%rax
  802f56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f5d:	78 26                	js     802f85 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802f5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f63:	ba 07 04 00 00       	mov    $0x407,%edx
  802f68:	48 89 c6             	mov    %rax,%rsi
  802f6b:	bf 00 00 00 00       	mov    $0x0,%edi
  802f70:	48 b8 55 1a 80 00 00 	movabs $0x801a55,%rax
  802f77:	00 00 00 
  802f7a:	ff d0                	callq  *%rax
  802f7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f83:	79 16                	jns    802f9b <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802f85:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f88:	89 c7                	mov    %eax,%edi
  802f8a:	48 b8 47 34 80 00 00 	movabs $0x803447,%rax
  802f91:	00 00 00 
  802f94:	ff d0                	callq  *%rax
		return r;
  802f96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f99:	eb 3a                	jmp    802fd5 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802f9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f9f:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802fa6:	00 00 00 
  802fa9:	8b 12                	mov    (%rdx),%edx
  802fab:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802fad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802fb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fbc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802fbf:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802fc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fc6:	48 89 c7             	mov    %rax,%rdi
  802fc9:	48 b8 bd 1d 80 00 00 	movabs $0x801dbd,%rax
  802fd0:	00 00 00 
  802fd3:	ff d0                	callq  *%rax
}
  802fd5:	c9                   	leaveq 
  802fd6:	c3                   	retq   

0000000000802fd7 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802fd7:	55                   	push   %rbp
  802fd8:	48 89 e5             	mov    %rsp,%rbp
  802fdb:	48 83 ec 30          	sub    $0x30,%rsp
  802fdf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fe2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fe6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fed:	89 c7                	mov    %eax,%edi
  802fef:	48 b8 e1 2e 80 00 00 	movabs $0x802ee1,%rax
  802ff6:	00 00 00 
  802ff9:	ff d0                	callq  *%rax
  802ffb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ffe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803002:	79 05                	jns    803009 <accept+0x32>
		return r;
  803004:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803007:	eb 3b                	jmp    803044 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803009:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80300d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803011:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803014:	48 89 ce             	mov    %rcx,%rsi
  803017:	89 c7                	mov    %eax,%edi
  803019:	48 b8 24 33 80 00 00 	movabs $0x803324,%rax
  803020:	00 00 00 
  803023:	ff d0                	callq  *%rax
  803025:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803028:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80302c:	79 05                	jns    803033 <accept+0x5c>
		return r;
  80302e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803031:	eb 11                	jmp    803044 <accept+0x6d>
	return alloc_sockfd(r);
  803033:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803036:	89 c7                	mov    %eax,%edi
  803038:	48 b8 38 2f 80 00 00 	movabs $0x802f38,%rax
  80303f:	00 00 00 
  803042:	ff d0                	callq  *%rax
}
  803044:	c9                   	leaveq 
  803045:	c3                   	retq   

0000000000803046 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803046:	55                   	push   %rbp
  803047:	48 89 e5             	mov    %rsp,%rbp
  80304a:	48 83 ec 20          	sub    $0x20,%rsp
  80304e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803051:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803055:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803058:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80305b:	89 c7                	mov    %eax,%edi
  80305d:	48 b8 e1 2e 80 00 00 	movabs $0x802ee1,%rax
  803064:	00 00 00 
  803067:	ff d0                	callq  *%rax
  803069:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80306c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803070:	79 05                	jns    803077 <bind+0x31>
		return r;
  803072:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803075:	eb 1b                	jmp    803092 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803077:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80307a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80307e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803081:	48 89 ce             	mov    %rcx,%rsi
  803084:	89 c7                	mov    %eax,%edi
  803086:	48 b8 a3 33 80 00 00 	movabs $0x8033a3,%rax
  80308d:	00 00 00 
  803090:	ff d0                	callq  *%rax
}
  803092:	c9                   	leaveq 
  803093:	c3                   	retq   

0000000000803094 <shutdown>:

int
shutdown(int s, int how)
{
  803094:	55                   	push   %rbp
  803095:	48 89 e5             	mov    %rsp,%rbp
  803098:	48 83 ec 20          	sub    $0x20,%rsp
  80309c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80309f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8030a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030a5:	89 c7                	mov    %eax,%edi
  8030a7:	48 b8 e1 2e 80 00 00 	movabs $0x802ee1,%rax
  8030ae:	00 00 00 
  8030b1:	ff d0                	callq  *%rax
  8030b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ba:	79 05                	jns    8030c1 <shutdown+0x2d>
		return r;
  8030bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030bf:	eb 16                	jmp    8030d7 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8030c1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030c7:	89 d6                	mov    %edx,%esi
  8030c9:	89 c7                	mov    %eax,%edi
  8030cb:	48 b8 07 34 80 00 00 	movabs $0x803407,%rax
  8030d2:	00 00 00 
  8030d5:	ff d0                	callq  *%rax
}
  8030d7:	c9                   	leaveq 
  8030d8:	c3                   	retq   

00000000008030d9 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8030d9:	55                   	push   %rbp
  8030da:	48 89 e5             	mov    %rsp,%rbp
  8030dd:	48 83 ec 10          	sub    $0x10,%rsp
  8030e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8030e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030e9:	48 89 c7             	mov    %rax,%rdi
  8030ec:	48 b8 a6 41 80 00 00 	movabs $0x8041a6,%rax
  8030f3:	00 00 00 
  8030f6:	ff d0                	callq  *%rax
  8030f8:	83 f8 01             	cmp    $0x1,%eax
  8030fb:	75 17                	jne    803114 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8030fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803101:	8b 40 0c             	mov    0xc(%rax),%eax
  803104:	89 c7                	mov    %eax,%edi
  803106:	48 b8 47 34 80 00 00 	movabs $0x803447,%rax
  80310d:	00 00 00 
  803110:	ff d0                	callq  *%rax
  803112:	eb 05                	jmp    803119 <devsock_close+0x40>
	else
		return 0;
  803114:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803119:	c9                   	leaveq 
  80311a:	c3                   	retq   

000000000080311b <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80311b:	55                   	push   %rbp
  80311c:	48 89 e5             	mov    %rsp,%rbp
  80311f:	48 83 ec 20          	sub    $0x20,%rsp
  803123:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803126:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80312a:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80312d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803130:	89 c7                	mov    %eax,%edi
  803132:	48 b8 e1 2e 80 00 00 	movabs $0x802ee1,%rax
  803139:	00 00 00 
  80313c:	ff d0                	callq  *%rax
  80313e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803141:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803145:	79 05                	jns    80314c <connect+0x31>
		return r;
  803147:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80314a:	eb 1b                	jmp    803167 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80314c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80314f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803153:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803156:	48 89 ce             	mov    %rcx,%rsi
  803159:	89 c7                	mov    %eax,%edi
  80315b:	48 b8 74 34 80 00 00 	movabs $0x803474,%rax
  803162:	00 00 00 
  803165:	ff d0                	callq  *%rax
}
  803167:	c9                   	leaveq 
  803168:	c3                   	retq   

0000000000803169 <listen>:

int
listen(int s, int backlog)
{
  803169:	55                   	push   %rbp
  80316a:	48 89 e5             	mov    %rsp,%rbp
  80316d:	48 83 ec 20          	sub    $0x20,%rsp
  803171:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803174:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803177:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80317a:	89 c7                	mov    %eax,%edi
  80317c:	48 b8 e1 2e 80 00 00 	movabs $0x802ee1,%rax
  803183:	00 00 00 
  803186:	ff d0                	callq  *%rax
  803188:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80318b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80318f:	79 05                	jns    803196 <listen+0x2d>
		return r;
  803191:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803194:	eb 16                	jmp    8031ac <listen+0x43>
	return nsipc_listen(r, backlog);
  803196:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803199:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80319c:	89 d6                	mov    %edx,%esi
  80319e:	89 c7                	mov    %eax,%edi
  8031a0:	48 b8 d8 34 80 00 00 	movabs $0x8034d8,%rax
  8031a7:	00 00 00 
  8031aa:	ff d0                	callq  *%rax
}
  8031ac:	c9                   	leaveq 
  8031ad:	c3                   	retq   

00000000008031ae <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8031ae:	55                   	push   %rbp
  8031af:	48 89 e5             	mov    %rsp,%rbp
  8031b2:	48 83 ec 20          	sub    $0x20,%rsp
  8031b6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031ba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8031be:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8031c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031c6:	89 c2                	mov    %eax,%edx
  8031c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031cc:	8b 40 0c             	mov    0xc(%rax),%eax
  8031cf:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8031d3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8031d8:	89 c7                	mov    %eax,%edi
  8031da:	48 b8 18 35 80 00 00 	movabs $0x803518,%rax
  8031e1:	00 00 00 
  8031e4:	ff d0                	callq  *%rax
}
  8031e6:	c9                   	leaveq 
  8031e7:	c3                   	retq   

00000000008031e8 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8031e8:	55                   	push   %rbp
  8031e9:	48 89 e5             	mov    %rsp,%rbp
  8031ec:	48 83 ec 20          	sub    $0x20,%rsp
  8031f0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031f4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8031f8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8031fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803200:	89 c2                	mov    %eax,%edx
  803202:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803206:	8b 40 0c             	mov    0xc(%rax),%eax
  803209:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80320d:	b9 00 00 00 00       	mov    $0x0,%ecx
  803212:	89 c7                	mov    %eax,%edi
  803214:	48 b8 e4 35 80 00 00 	movabs $0x8035e4,%rax
  80321b:	00 00 00 
  80321e:	ff d0                	callq  *%rax
}
  803220:	c9                   	leaveq 
  803221:	c3                   	retq   

0000000000803222 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803222:	55                   	push   %rbp
  803223:	48 89 e5             	mov    %rsp,%rbp
  803226:	48 83 ec 10          	sub    $0x10,%rsp
  80322a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80322e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803232:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803236:	48 be 2f 49 80 00 00 	movabs $0x80492f,%rsi
  80323d:	00 00 00 
  803240:	48 89 c7             	mov    %rax,%rdi
  803243:	48 b8 28 11 80 00 00 	movabs $0x801128,%rax
  80324a:	00 00 00 
  80324d:	ff d0                	callq  *%rax
	return 0;
  80324f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803254:	c9                   	leaveq 
  803255:	c3                   	retq   

0000000000803256 <socket>:

int
socket(int domain, int type, int protocol)
{
  803256:	55                   	push   %rbp
  803257:	48 89 e5             	mov    %rsp,%rbp
  80325a:	48 83 ec 20          	sub    $0x20,%rsp
  80325e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803261:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803264:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803267:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80326a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80326d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803270:	89 ce                	mov    %ecx,%esi
  803272:	89 c7                	mov    %eax,%edi
  803274:	48 b8 9c 36 80 00 00 	movabs $0x80369c,%rax
  80327b:	00 00 00 
  80327e:	ff d0                	callq  *%rax
  803280:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803283:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803287:	79 05                	jns    80328e <socket+0x38>
		return r;
  803289:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80328c:	eb 11                	jmp    80329f <socket+0x49>
	return alloc_sockfd(r);
  80328e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803291:	89 c7                	mov    %eax,%edi
  803293:	48 b8 38 2f 80 00 00 	movabs $0x802f38,%rax
  80329a:	00 00 00 
  80329d:	ff d0                	callq  *%rax
}
  80329f:	c9                   	leaveq 
  8032a0:	c3                   	retq   

00000000008032a1 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8032a1:	55                   	push   %rbp
  8032a2:	48 89 e5             	mov    %rsp,%rbp
  8032a5:	48 83 ec 10          	sub    $0x10,%rsp
  8032a9:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8032ac:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8032b3:	00 00 00 
  8032b6:	8b 00                	mov    (%rax),%eax
  8032b8:	85 c0                	test   %eax,%eax
  8032ba:	75 1f                	jne    8032db <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8032bc:	bf 02 00 00 00       	mov    $0x2,%edi
  8032c1:	48 b8 34 41 80 00 00 	movabs $0x804134,%rax
  8032c8:	00 00 00 
  8032cb:	ff d0                	callq  *%rax
  8032cd:	89 c2                	mov    %eax,%edx
  8032cf:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8032d6:	00 00 00 
  8032d9:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8032db:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8032e2:	00 00 00 
  8032e5:	8b 00                	mov    (%rax),%eax
  8032e7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8032ea:	b9 07 00 00 00       	mov    $0x7,%ecx
  8032ef:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8032f6:	00 00 00 
  8032f9:	89 c7                	mov    %eax,%edi
  8032fb:	48 b8 a7 3f 80 00 00 	movabs $0x803fa7,%rax
  803302:	00 00 00 
  803305:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803307:	ba 00 00 00 00       	mov    $0x0,%edx
  80330c:	be 00 00 00 00       	mov    $0x0,%esi
  803311:	bf 00 00 00 00       	mov    $0x0,%edi
  803316:	48 b8 69 3f 80 00 00 	movabs $0x803f69,%rax
  80331d:	00 00 00 
  803320:	ff d0                	callq  *%rax
}
  803322:	c9                   	leaveq 
  803323:	c3                   	retq   

0000000000803324 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803324:	55                   	push   %rbp
  803325:	48 89 e5             	mov    %rsp,%rbp
  803328:	48 83 ec 30          	sub    $0x30,%rsp
  80332c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80332f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803333:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803337:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80333e:	00 00 00 
  803341:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803344:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803346:	bf 01 00 00 00       	mov    $0x1,%edi
  80334b:	48 b8 a1 32 80 00 00 	movabs $0x8032a1,%rax
  803352:	00 00 00 
  803355:	ff d0                	callq  *%rax
  803357:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80335a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80335e:	78 3e                	js     80339e <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803360:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803367:	00 00 00 
  80336a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80336e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803372:	8b 40 10             	mov    0x10(%rax),%eax
  803375:	89 c2                	mov    %eax,%edx
  803377:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80337b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80337f:	48 89 ce             	mov    %rcx,%rsi
  803382:	48 89 c7             	mov    %rax,%rdi
  803385:	48 b8 4c 14 80 00 00 	movabs $0x80144c,%rax
  80338c:	00 00 00 
  80338f:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803391:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803395:	8b 50 10             	mov    0x10(%rax),%edx
  803398:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80339c:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80339e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8033a1:	c9                   	leaveq 
  8033a2:	c3                   	retq   

00000000008033a3 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8033a3:	55                   	push   %rbp
  8033a4:	48 89 e5             	mov    %rsp,%rbp
  8033a7:	48 83 ec 10          	sub    $0x10,%rsp
  8033ab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033ae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033b2:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8033b5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033bc:	00 00 00 
  8033bf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033c2:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8033c4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033cb:	48 89 c6             	mov    %rax,%rsi
  8033ce:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8033d5:	00 00 00 
  8033d8:	48 b8 4c 14 80 00 00 	movabs $0x80144c,%rax
  8033df:	00 00 00 
  8033e2:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8033e4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033eb:	00 00 00 
  8033ee:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033f1:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8033f4:	bf 02 00 00 00       	mov    $0x2,%edi
  8033f9:	48 b8 a1 32 80 00 00 	movabs $0x8032a1,%rax
  803400:	00 00 00 
  803403:	ff d0                	callq  *%rax
}
  803405:	c9                   	leaveq 
  803406:	c3                   	retq   

0000000000803407 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803407:	55                   	push   %rbp
  803408:	48 89 e5             	mov    %rsp,%rbp
  80340b:	48 83 ec 10          	sub    $0x10,%rsp
  80340f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803412:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803415:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80341c:	00 00 00 
  80341f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803422:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803424:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80342b:	00 00 00 
  80342e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803431:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803434:	bf 03 00 00 00       	mov    $0x3,%edi
  803439:	48 b8 a1 32 80 00 00 	movabs $0x8032a1,%rax
  803440:	00 00 00 
  803443:	ff d0                	callq  *%rax
}
  803445:	c9                   	leaveq 
  803446:	c3                   	retq   

0000000000803447 <nsipc_close>:

int
nsipc_close(int s)
{
  803447:	55                   	push   %rbp
  803448:	48 89 e5             	mov    %rsp,%rbp
  80344b:	48 83 ec 10          	sub    $0x10,%rsp
  80344f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803452:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803459:	00 00 00 
  80345c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80345f:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803461:	bf 04 00 00 00       	mov    $0x4,%edi
  803466:	48 b8 a1 32 80 00 00 	movabs $0x8032a1,%rax
  80346d:	00 00 00 
  803470:	ff d0                	callq  *%rax
}
  803472:	c9                   	leaveq 
  803473:	c3                   	retq   

0000000000803474 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803474:	55                   	push   %rbp
  803475:	48 89 e5             	mov    %rsp,%rbp
  803478:	48 83 ec 10          	sub    $0x10,%rsp
  80347c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80347f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803483:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803486:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80348d:	00 00 00 
  803490:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803493:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803495:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803498:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80349c:	48 89 c6             	mov    %rax,%rsi
  80349f:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8034a6:	00 00 00 
  8034a9:	48 b8 4c 14 80 00 00 	movabs $0x80144c,%rax
  8034b0:	00 00 00 
  8034b3:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8034b5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034bc:	00 00 00 
  8034bf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034c2:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8034c5:	bf 05 00 00 00       	mov    $0x5,%edi
  8034ca:	48 b8 a1 32 80 00 00 	movabs $0x8032a1,%rax
  8034d1:	00 00 00 
  8034d4:	ff d0                	callq  *%rax
}
  8034d6:	c9                   	leaveq 
  8034d7:	c3                   	retq   

00000000008034d8 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8034d8:	55                   	push   %rbp
  8034d9:	48 89 e5             	mov    %rsp,%rbp
  8034dc:	48 83 ec 10          	sub    $0x10,%rsp
  8034e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034e3:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8034e6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034ed:	00 00 00 
  8034f0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034f3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8034f5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034fc:	00 00 00 
  8034ff:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803502:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803505:	bf 06 00 00 00       	mov    $0x6,%edi
  80350a:	48 b8 a1 32 80 00 00 	movabs $0x8032a1,%rax
  803511:	00 00 00 
  803514:	ff d0                	callq  *%rax
}
  803516:	c9                   	leaveq 
  803517:	c3                   	retq   

0000000000803518 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803518:	55                   	push   %rbp
  803519:	48 89 e5             	mov    %rsp,%rbp
  80351c:	48 83 ec 30          	sub    $0x30,%rsp
  803520:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803523:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803527:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80352a:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80352d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803534:	00 00 00 
  803537:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80353a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80353c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803543:	00 00 00 
  803546:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803549:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80354c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803553:	00 00 00 
  803556:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803559:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80355c:	bf 07 00 00 00       	mov    $0x7,%edi
  803561:	48 b8 a1 32 80 00 00 	movabs $0x8032a1,%rax
  803568:	00 00 00 
  80356b:	ff d0                	callq  *%rax
  80356d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803570:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803574:	78 69                	js     8035df <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803576:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80357d:	7f 08                	jg     803587 <nsipc_recv+0x6f>
  80357f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803582:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803585:	7e 35                	jle    8035bc <nsipc_recv+0xa4>
  803587:	48 b9 36 49 80 00 00 	movabs $0x804936,%rcx
  80358e:	00 00 00 
  803591:	48 ba 4b 49 80 00 00 	movabs $0x80494b,%rdx
  803598:	00 00 00 
  80359b:	be 61 00 00 00       	mov    $0x61,%esi
  8035a0:	48 bf 60 49 80 00 00 	movabs $0x804960,%rdi
  8035a7:	00 00 00 
  8035aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8035af:	49 b8 55 03 80 00 00 	movabs $0x800355,%r8
  8035b6:	00 00 00 
  8035b9:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8035bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035bf:	48 63 d0             	movslq %eax,%rdx
  8035c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035c6:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8035cd:	00 00 00 
  8035d0:	48 89 c7             	mov    %rax,%rdi
  8035d3:	48 b8 4c 14 80 00 00 	movabs $0x80144c,%rax
  8035da:	00 00 00 
  8035dd:	ff d0                	callq  *%rax
	}

	return r;
  8035df:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8035e2:	c9                   	leaveq 
  8035e3:	c3                   	retq   

00000000008035e4 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8035e4:	55                   	push   %rbp
  8035e5:	48 89 e5             	mov    %rsp,%rbp
  8035e8:	48 83 ec 20          	sub    $0x20,%rsp
  8035ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8035ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8035f3:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8035f6:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8035f9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803600:	00 00 00 
  803603:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803606:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803608:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80360f:	7e 35                	jle    803646 <nsipc_send+0x62>
  803611:	48 b9 6c 49 80 00 00 	movabs $0x80496c,%rcx
  803618:	00 00 00 
  80361b:	48 ba 4b 49 80 00 00 	movabs $0x80494b,%rdx
  803622:	00 00 00 
  803625:	be 6c 00 00 00       	mov    $0x6c,%esi
  80362a:	48 bf 60 49 80 00 00 	movabs $0x804960,%rdi
  803631:	00 00 00 
  803634:	b8 00 00 00 00       	mov    $0x0,%eax
  803639:	49 b8 55 03 80 00 00 	movabs $0x800355,%r8
  803640:	00 00 00 
  803643:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803646:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803649:	48 63 d0             	movslq %eax,%rdx
  80364c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803650:	48 89 c6             	mov    %rax,%rsi
  803653:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80365a:	00 00 00 
  80365d:	48 b8 4c 14 80 00 00 	movabs $0x80144c,%rax
  803664:	00 00 00 
  803667:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803669:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803670:	00 00 00 
  803673:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803676:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803679:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803680:	00 00 00 
  803683:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803686:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803689:	bf 08 00 00 00       	mov    $0x8,%edi
  80368e:	48 b8 a1 32 80 00 00 	movabs $0x8032a1,%rax
  803695:	00 00 00 
  803698:	ff d0                	callq  *%rax
}
  80369a:	c9                   	leaveq 
  80369b:	c3                   	retq   

000000000080369c <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80369c:	55                   	push   %rbp
  80369d:	48 89 e5             	mov    %rsp,%rbp
  8036a0:	48 83 ec 10          	sub    $0x10,%rsp
  8036a4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036a7:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8036aa:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8036ad:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036b4:	00 00 00 
  8036b7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036ba:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8036bc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036c3:	00 00 00 
  8036c6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036c9:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8036cc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036d3:	00 00 00 
  8036d6:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8036d9:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8036dc:	bf 09 00 00 00       	mov    $0x9,%edi
  8036e1:	48 b8 a1 32 80 00 00 	movabs $0x8032a1,%rax
  8036e8:	00 00 00 
  8036eb:	ff d0                	callq  *%rax
}
  8036ed:	c9                   	leaveq 
  8036ee:	c3                   	retq   

00000000008036ef <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8036ef:	55                   	push   %rbp
  8036f0:	48 89 e5             	mov    %rsp,%rbp
  8036f3:	53                   	push   %rbx
  8036f4:	48 83 ec 38          	sub    $0x38,%rsp
  8036f8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8036fc:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803700:	48 89 c7             	mov    %rax,%rdi
  803703:	48 b8 0b 1e 80 00 00 	movabs $0x801e0b,%rax
  80370a:	00 00 00 
  80370d:	ff d0                	callq  *%rax
  80370f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803712:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803716:	0f 88 bf 01 00 00    	js     8038db <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80371c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803720:	ba 07 04 00 00       	mov    $0x407,%edx
  803725:	48 89 c6             	mov    %rax,%rsi
  803728:	bf 00 00 00 00       	mov    $0x0,%edi
  80372d:	48 b8 55 1a 80 00 00 	movabs $0x801a55,%rax
  803734:	00 00 00 
  803737:	ff d0                	callq  *%rax
  803739:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80373c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803740:	0f 88 95 01 00 00    	js     8038db <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803746:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80374a:	48 89 c7             	mov    %rax,%rdi
  80374d:	48 b8 0b 1e 80 00 00 	movabs $0x801e0b,%rax
  803754:	00 00 00 
  803757:	ff d0                	callq  *%rax
  803759:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80375c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803760:	0f 88 5d 01 00 00    	js     8038c3 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803766:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80376a:	ba 07 04 00 00       	mov    $0x407,%edx
  80376f:	48 89 c6             	mov    %rax,%rsi
  803772:	bf 00 00 00 00       	mov    $0x0,%edi
  803777:	48 b8 55 1a 80 00 00 	movabs $0x801a55,%rax
  80377e:	00 00 00 
  803781:	ff d0                	callq  *%rax
  803783:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803786:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80378a:	0f 88 33 01 00 00    	js     8038c3 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803790:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803794:	48 89 c7             	mov    %rax,%rdi
  803797:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  80379e:	00 00 00 
  8037a1:	ff d0                	callq  *%rax
  8037a3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037ab:	ba 07 04 00 00       	mov    $0x407,%edx
  8037b0:	48 89 c6             	mov    %rax,%rsi
  8037b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8037b8:	48 b8 55 1a 80 00 00 	movabs $0x801a55,%rax
  8037bf:	00 00 00 
  8037c2:	ff d0                	callq  *%rax
  8037c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037cb:	79 05                	jns    8037d2 <pipe+0xe3>
		goto err2;
  8037cd:	e9 d9 00 00 00       	jmpq   8038ab <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037d2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037d6:	48 89 c7             	mov    %rax,%rdi
  8037d9:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  8037e0:	00 00 00 
  8037e3:	ff d0                	callq  *%rax
  8037e5:	48 89 c2             	mov    %rax,%rdx
  8037e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037ec:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8037f2:	48 89 d1             	mov    %rdx,%rcx
  8037f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8037fa:	48 89 c6             	mov    %rax,%rsi
  8037fd:	bf 00 00 00 00       	mov    $0x0,%edi
  803802:	48 b8 a7 1a 80 00 00 	movabs $0x801aa7,%rax
  803809:	00 00 00 
  80380c:	ff d0                	callq  *%rax
  80380e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803811:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803815:	79 1b                	jns    803832 <pipe+0x143>
		goto err3;
  803817:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803818:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80381c:	48 89 c6             	mov    %rax,%rsi
  80381f:	bf 00 00 00 00       	mov    $0x0,%edi
  803824:	48 b8 07 1b 80 00 00 	movabs $0x801b07,%rax
  80382b:	00 00 00 
  80382e:	ff d0                	callq  *%rax
  803830:	eb 79                	jmp    8038ab <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  803832:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803836:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80383d:	00 00 00 
  803840:	8b 12                	mov    (%rdx),%edx
  803842:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803844:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803848:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  80384f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803853:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80385a:	00 00 00 
  80385d:	8b 12                	mov    (%rdx),%edx
  80385f:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803861:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803865:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  80386c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803870:	48 89 c7             	mov    %rax,%rdi
  803873:	48 b8 bd 1d 80 00 00 	movabs $0x801dbd,%rax
  80387a:	00 00 00 
  80387d:	ff d0                	callq  *%rax
  80387f:	89 c2                	mov    %eax,%edx
  803881:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803885:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803887:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80388b:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80388f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803893:	48 89 c7             	mov    %rax,%rdi
  803896:	48 b8 bd 1d 80 00 00 	movabs $0x801dbd,%rax
  80389d:	00 00 00 
  8038a0:	ff d0                	callq  *%rax
  8038a2:	89 03                	mov    %eax,(%rbx)
	return 0;
  8038a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8038a9:	eb 33                	jmp    8038de <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  8038ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038af:	48 89 c6             	mov    %rax,%rsi
  8038b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8038b7:	48 b8 07 1b 80 00 00 	movabs $0x801b07,%rax
  8038be:	00 00 00 
  8038c1:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8038c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038c7:	48 89 c6             	mov    %rax,%rsi
  8038ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8038cf:	48 b8 07 1b 80 00 00 	movabs $0x801b07,%rax
  8038d6:	00 00 00 
  8038d9:	ff d0                	callq  *%rax
err:
	return r;
  8038db:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8038de:	48 83 c4 38          	add    $0x38,%rsp
  8038e2:	5b                   	pop    %rbx
  8038e3:	5d                   	pop    %rbp
  8038e4:	c3                   	retq   

00000000008038e5 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8038e5:	55                   	push   %rbp
  8038e6:	48 89 e5             	mov    %rsp,%rbp
  8038e9:	53                   	push   %rbx
  8038ea:	48 83 ec 28          	sub    $0x28,%rsp
  8038ee:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038f2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8038f6:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8038fd:	00 00 00 
  803900:	48 8b 00             	mov    (%rax),%rax
  803903:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803909:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80390c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803910:	48 89 c7             	mov    %rax,%rdi
  803913:	48 b8 a6 41 80 00 00 	movabs $0x8041a6,%rax
  80391a:	00 00 00 
  80391d:	ff d0                	callq  *%rax
  80391f:	89 c3                	mov    %eax,%ebx
  803921:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803925:	48 89 c7             	mov    %rax,%rdi
  803928:	48 b8 a6 41 80 00 00 	movabs $0x8041a6,%rax
  80392f:	00 00 00 
  803932:	ff d0                	callq  *%rax
  803934:	39 c3                	cmp    %eax,%ebx
  803936:	0f 94 c0             	sete   %al
  803939:	0f b6 c0             	movzbl %al,%eax
  80393c:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80393f:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803946:	00 00 00 
  803949:	48 8b 00             	mov    (%rax),%rax
  80394c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803952:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803955:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803958:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80395b:	75 05                	jne    803962 <_pipeisclosed+0x7d>
			return ret;
  80395d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803960:	eb 4a                	jmp    8039ac <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803962:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803965:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803968:	74 3d                	je     8039a7 <_pipeisclosed+0xc2>
  80396a:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80396e:	75 37                	jne    8039a7 <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803970:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  803977:	00 00 00 
  80397a:	48 8b 00             	mov    (%rax),%rax
  80397d:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803983:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803986:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803989:	89 c6                	mov    %eax,%esi
  80398b:	48 bf 7d 49 80 00 00 	movabs $0x80497d,%rdi
  803992:	00 00 00 
  803995:	b8 00 00 00 00       	mov    $0x0,%eax
  80399a:	49 b8 8e 05 80 00 00 	movabs $0x80058e,%r8
  8039a1:	00 00 00 
  8039a4:	41 ff d0             	callq  *%r8
	}
  8039a7:	e9 4a ff ff ff       	jmpq   8038f6 <_pipeisclosed+0x11>
}
  8039ac:	48 83 c4 28          	add    $0x28,%rsp
  8039b0:	5b                   	pop    %rbx
  8039b1:	5d                   	pop    %rbp
  8039b2:	c3                   	retq   

00000000008039b3 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8039b3:	55                   	push   %rbp
  8039b4:	48 89 e5             	mov    %rsp,%rbp
  8039b7:	48 83 ec 30          	sub    $0x30,%rsp
  8039bb:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8039be:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8039c2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8039c5:	48 89 d6             	mov    %rdx,%rsi
  8039c8:	89 c7                	mov    %eax,%edi
  8039ca:	48 b8 a3 1e 80 00 00 	movabs $0x801ea3,%rax
  8039d1:	00 00 00 
  8039d4:	ff d0                	callq  *%rax
  8039d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039dd:	79 05                	jns    8039e4 <pipeisclosed+0x31>
		return r;
  8039df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039e2:	eb 31                	jmp    803a15 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8039e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039e8:	48 89 c7             	mov    %rax,%rdi
  8039eb:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  8039f2:	00 00 00 
  8039f5:	ff d0                	callq  *%rax
  8039f7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8039fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a03:	48 89 d6             	mov    %rdx,%rsi
  803a06:	48 89 c7             	mov    %rax,%rdi
  803a09:	48 b8 e5 38 80 00 00 	movabs $0x8038e5,%rax
  803a10:	00 00 00 
  803a13:	ff d0                	callq  *%rax
}
  803a15:	c9                   	leaveq 
  803a16:	c3                   	retq   

0000000000803a17 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803a17:	55                   	push   %rbp
  803a18:	48 89 e5             	mov    %rsp,%rbp
  803a1b:	48 83 ec 40          	sub    $0x40,%rsp
  803a1f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a23:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a27:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803a2b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a2f:	48 89 c7             	mov    %rax,%rdi
  803a32:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  803a39:	00 00 00 
  803a3c:	ff d0                	callq  *%rax
  803a3e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803a42:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a46:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803a4a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a51:	00 
  803a52:	e9 92 00 00 00       	jmpq   803ae9 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803a57:	eb 41                	jmp    803a9a <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803a59:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803a5e:	74 09                	je     803a69 <devpipe_read+0x52>
				return i;
  803a60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a64:	e9 92 00 00 00       	jmpq   803afb <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803a69:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a71:	48 89 d6             	mov    %rdx,%rsi
  803a74:	48 89 c7             	mov    %rax,%rdi
  803a77:	48 b8 e5 38 80 00 00 	movabs $0x8038e5,%rax
  803a7e:	00 00 00 
  803a81:	ff d0                	callq  *%rax
  803a83:	85 c0                	test   %eax,%eax
  803a85:	74 07                	je     803a8e <devpipe_read+0x77>
				return 0;
  803a87:	b8 00 00 00 00       	mov    $0x0,%eax
  803a8c:	eb 6d                	jmp    803afb <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803a8e:	48 b8 19 1a 80 00 00 	movabs $0x801a19,%rax
  803a95:	00 00 00 
  803a98:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  803a9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a9e:	8b 10                	mov    (%rax),%edx
  803aa0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aa4:	8b 40 04             	mov    0x4(%rax),%eax
  803aa7:	39 c2                	cmp    %eax,%edx
  803aa9:	74 ae                	je     803a59 <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803aab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803aaf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ab3:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803ab7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803abb:	8b 00                	mov    (%rax),%eax
  803abd:	99                   	cltd   
  803abe:	c1 ea 1b             	shr    $0x1b,%edx
  803ac1:	01 d0                	add    %edx,%eax
  803ac3:	83 e0 1f             	and    $0x1f,%eax
  803ac6:	29 d0                	sub    %edx,%eax
  803ac8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803acc:	48 98                	cltq   
  803ace:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803ad3:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803ad5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ad9:	8b 00                	mov    (%rax),%eax
  803adb:	8d 50 01             	lea    0x1(%rax),%edx
  803ade:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ae2:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  803ae4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ae9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803aed:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803af1:	0f 82 60 ff ff ff    	jb     803a57 <devpipe_read+0x40>
	}
	return i;
  803af7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803afb:	c9                   	leaveq 
  803afc:	c3                   	retq   

0000000000803afd <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803afd:	55                   	push   %rbp
  803afe:	48 89 e5             	mov    %rsp,%rbp
  803b01:	48 83 ec 40          	sub    $0x40,%rsp
  803b05:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b09:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b0d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803b11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b15:	48 89 c7             	mov    %rax,%rdi
  803b18:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  803b1f:	00 00 00 
  803b22:	ff d0                	callq  *%rax
  803b24:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803b28:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b2c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803b30:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803b37:	00 
  803b38:	e9 91 00 00 00       	jmpq   803bce <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803b3d:	eb 31                	jmp    803b70 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803b3f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b43:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b47:	48 89 d6             	mov    %rdx,%rsi
  803b4a:	48 89 c7             	mov    %rax,%rdi
  803b4d:	48 b8 e5 38 80 00 00 	movabs $0x8038e5,%rax
  803b54:	00 00 00 
  803b57:	ff d0                	callq  *%rax
  803b59:	85 c0                	test   %eax,%eax
  803b5b:	74 07                	je     803b64 <devpipe_write+0x67>
				return 0;
  803b5d:	b8 00 00 00 00       	mov    $0x0,%eax
  803b62:	eb 7c                	jmp    803be0 <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803b64:	48 b8 19 1a 80 00 00 	movabs $0x801a19,%rax
  803b6b:	00 00 00 
  803b6e:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803b70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b74:	8b 40 04             	mov    0x4(%rax),%eax
  803b77:	48 63 d0             	movslq %eax,%rdx
  803b7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b7e:	8b 00                	mov    (%rax),%eax
  803b80:	48 98                	cltq   
  803b82:	48 83 c0 20          	add    $0x20,%rax
  803b86:	48 39 c2             	cmp    %rax,%rdx
  803b89:	73 b4                	jae    803b3f <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803b8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b8f:	8b 40 04             	mov    0x4(%rax),%eax
  803b92:	99                   	cltd   
  803b93:	c1 ea 1b             	shr    $0x1b,%edx
  803b96:	01 d0                	add    %edx,%eax
  803b98:	83 e0 1f             	and    $0x1f,%eax
  803b9b:	29 d0                	sub    %edx,%eax
  803b9d:	89 c6                	mov    %eax,%esi
  803b9f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803ba3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ba7:	48 01 d0             	add    %rdx,%rax
  803baa:	0f b6 08             	movzbl (%rax),%ecx
  803bad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803bb1:	48 63 c6             	movslq %esi,%rax
  803bb4:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803bb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bbc:	8b 40 04             	mov    0x4(%rax),%eax
  803bbf:	8d 50 01             	lea    0x1(%rax),%edx
  803bc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bc6:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  803bc9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803bce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bd2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803bd6:	0f 82 61 ff ff ff    	jb     803b3d <devpipe_write+0x40>
	}

	return i;
  803bdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803be0:	c9                   	leaveq 
  803be1:	c3                   	retq   

0000000000803be2 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803be2:	55                   	push   %rbp
  803be3:	48 89 e5             	mov    %rsp,%rbp
  803be6:	48 83 ec 20          	sub    $0x20,%rsp
  803bea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803bf2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bf6:	48 89 c7             	mov    %rax,%rdi
  803bf9:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  803c00:	00 00 00 
  803c03:	ff d0                	callq  *%rax
  803c05:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803c09:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c0d:	48 be 90 49 80 00 00 	movabs $0x804990,%rsi
  803c14:	00 00 00 
  803c17:	48 89 c7             	mov    %rax,%rdi
  803c1a:	48 b8 28 11 80 00 00 	movabs $0x801128,%rax
  803c21:	00 00 00 
  803c24:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803c26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c2a:	8b 50 04             	mov    0x4(%rax),%edx
  803c2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c31:	8b 00                	mov    (%rax),%eax
  803c33:	29 c2                	sub    %eax,%edx
  803c35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c39:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803c3f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c43:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803c4a:	00 00 00 
	stat->st_dev = &devpipe;
  803c4d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c51:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803c58:	00 00 00 
  803c5b:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803c62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c67:	c9                   	leaveq 
  803c68:	c3                   	retq   

0000000000803c69 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803c69:	55                   	push   %rbp
  803c6a:	48 89 e5             	mov    %rsp,%rbp
  803c6d:	48 83 ec 10          	sub    $0x10,%rsp
  803c71:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803c75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c79:	48 89 c6             	mov    %rax,%rsi
  803c7c:	bf 00 00 00 00       	mov    $0x0,%edi
  803c81:	48 b8 07 1b 80 00 00 	movabs $0x801b07,%rax
  803c88:	00 00 00 
  803c8b:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803c8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c91:	48 89 c7             	mov    %rax,%rdi
  803c94:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  803c9b:	00 00 00 
  803c9e:	ff d0                	callq  *%rax
  803ca0:	48 89 c6             	mov    %rax,%rsi
  803ca3:	bf 00 00 00 00       	mov    $0x0,%edi
  803ca8:	48 b8 07 1b 80 00 00 	movabs $0x801b07,%rax
  803caf:	00 00 00 
  803cb2:	ff d0                	callq  *%rax
}
  803cb4:	c9                   	leaveq 
  803cb5:	c3                   	retq   

0000000000803cb6 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803cb6:	55                   	push   %rbp
  803cb7:	48 89 e5             	mov    %rsp,%rbp
  803cba:	48 83 ec 20          	sub    $0x20,%rsp
  803cbe:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803cc1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cc4:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803cc7:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803ccb:	be 01 00 00 00       	mov    $0x1,%esi
  803cd0:	48 89 c7             	mov    %rax,%rdi
  803cd3:	48 b8 0f 19 80 00 00 	movabs $0x80190f,%rax
  803cda:	00 00 00 
  803cdd:	ff d0                	callq  *%rax
}
  803cdf:	c9                   	leaveq 
  803ce0:	c3                   	retq   

0000000000803ce1 <getchar>:

int
getchar(void)
{
  803ce1:	55                   	push   %rbp
  803ce2:	48 89 e5             	mov    %rsp,%rbp
  803ce5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803ce9:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803ced:	ba 01 00 00 00       	mov    $0x1,%edx
  803cf2:	48 89 c6             	mov    %rax,%rsi
  803cf5:	bf 00 00 00 00       	mov    $0x0,%edi
  803cfa:	48 b8 d7 22 80 00 00 	movabs $0x8022d7,%rax
  803d01:	00 00 00 
  803d04:	ff d0                	callq  *%rax
  803d06:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803d09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d0d:	79 05                	jns    803d14 <getchar+0x33>
		return r;
  803d0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d12:	eb 14                	jmp    803d28 <getchar+0x47>
	if (r < 1)
  803d14:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d18:	7f 07                	jg     803d21 <getchar+0x40>
		return -E_EOF;
  803d1a:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803d1f:	eb 07                	jmp    803d28 <getchar+0x47>
	return c;
  803d21:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803d25:	0f b6 c0             	movzbl %al,%eax
}
  803d28:	c9                   	leaveq 
  803d29:	c3                   	retq   

0000000000803d2a <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803d2a:	55                   	push   %rbp
  803d2b:	48 89 e5             	mov    %rsp,%rbp
  803d2e:	48 83 ec 20          	sub    $0x20,%rsp
  803d32:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803d35:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803d39:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d3c:	48 89 d6             	mov    %rdx,%rsi
  803d3f:	89 c7                	mov    %eax,%edi
  803d41:	48 b8 a3 1e 80 00 00 	movabs $0x801ea3,%rax
  803d48:	00 00 00 
  803d4b:	ff d0                	callq  *%rax
  803d4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d54:	79 05                	jns    803d5b <iscons+0x31>
		return r;
  803d56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d59:	eb 1a                	jmp    803d75 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803d5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d5f:	8b 10                	mov    (%rax),%edx
  803d61:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803d68:	00 00 00 
  803d6b:	8b 00                	mov    (%rax),%eax
  803d6d:	39 c2                	cmp    %eax,%edx
  803d6f:	0f 94 c0             	sete   %al
  803d72:	0f b6 c0             	movzbl %al,%eax
}
  803d75:	c9                   	leaveq 
  803d76:	c3                   	retq   

0000000000803d77 <opencons>:

int
opencons(void)
{
  803d77:	55                   	push   %rbp
  803d78:	48 89 e5             	mov    %rsp,%rbp
  803d7b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803d7f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803d83:	48 89 c7             	mov    %rax,%rdi
  803d86:	48 b8 0b 1e 80 00 00 	movabs $0x801e0b,%rax
  803d8d:	00 00 00 
  803d90:	ff d0                	callq  *%rax
  803d92:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d95:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d99:	79 05                	jns    803da0 <opencons+0x29>
		return r;
  803d9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d9e:	eb 5b                	jmp    803dfb <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803da0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803da4:	ba 07 04 00 00       	mov    $0x407,%edx
  803da9:	48 89 c6             	mov    %rax,%rsi
  803dac:	bf 00 00 00 00       	mov    $0x0,%edi
  803db1:	48 b8 55 1a 80 00 00 	movabs $0x801a55,%rax
  803db8:	00 00 00 
  803dbb:	ff d0                	callq  *%rax
  803dbd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dc4:	79 05                	jns    803dcb <opencons+0x54>
		return r;
  803dc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dc9:	eb 30                	jmp    803dfb <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803dcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dcf:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803dd6:	00 00 00 
  803dd9:	8b 12                	mov    (%rdx),%edx
  803ddb:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803ddd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803de1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803de8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dec:	48 89 c7             	mov    %rax,%rdi
  803def:	48 b8 bd 1d 80 00 00 	movabs $0x801dbd,%rax
  803df6:	00 00 00 
  803df9:	ff d0                	callq  *%rax
}
  803dfb:	c9                   	leaveq 
  803dfc:	c3                   	retq   

0000000000803dfd <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803dfd:	55                   	push   %rbp
  803dfe:	48 89 e5             	mov    %rsp,%rbp
  803e01:	48 83 ec 30          	sub    $0x30,%rsp
  803e05:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e09:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e0d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803e11:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e16:	75 07                	jne    803e1f <devcons_read+0x22>
		return 0;
  803e18:	b8 00 00 00 00       	mov    $0x0,%eax
  803e1d:	eb 4b                	jmp    803e6a <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803e1f:	eb 0c                	jmp    803e2d <devcons_read+0x30>
		sys_yield();
  803e21:	48 b8 19 1a 80 00 00 	movabs $0x801a19,%rax
  803e28:	00 00 00 
  803e2b:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  803e2d:	48 b8 5b 19 80 00 00 	movabs $0x80195b,%rax
  803e34:	00 00 00 
  803e37:	ff d0                	callq  *%rax
  803e39:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e40:	74 df                	je     803e21 <devcons_read+0x24>
	if (c < 0)
  803e42:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e46:	79 05                	jns    803e4d <devcons_read+0x50>
		return c;
  803e48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e4b:	eb 1d                	jmp    803e6a <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803e4d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803e51:	75 07                	jne    803e5a <devcons_read+0x5d>
		return 0;
  803e53:	b8 00 00 00 00       	mov    $0x0,%eax
  803e58:	eb 10                	jmp    803e6a <devcons_read+0x6d>
	*(char*)vbuf = c;
  803e5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e5d:	89 c2                	mov    %eax,%edx
  803e5f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e63:	88 10                	mov    %dl,(%rax)
	return 1;
  803e65:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803e6a:	c9                   	leaveq 
  803e6b:	c3                   	retq   

0000000000803e6c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803e6c:	55                   	push   %rbp
  803e6d:	48 89 e5             	mov    %rsp,%rbp
  803e70:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803e77:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803e7e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803e85:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e93:	eb 76                	jmp    803f0b <devcons_write+0x9f>
		m = n - tot;
  803e95:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803e9c:	89 c2                	mov    %eax,%edx
  803e9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ea1:	29 c2                	sub    %eax,%edx
  803ea3:	89 d0                	mov    %edx,%eax
  803ea5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803ea8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803eab:	83 f8 7f             	cmp    $0x7f,%eax
  803eae:	76 07                	jbe    803eb7 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803eb0:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803eb7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803eba:	48 63 d0             	movslq %eax,%rdx
  803ebd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ec0:	48 63 c8             	movslq %eax,%rcx
  803ec3:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803eca:	48 01 c1             	add    %rax,%rcx
  803ecd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803ed4:	48 89 ce             	mov    %rcx,%rsi
  803ed7:	48 89 c7             	mov    %rax,%rdi
  803eda:	48 b8 4c 14 80 00 00 	movabs $0x80144c,%rax
  803ee1:	00 00 00 
  803ee4:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803ee6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ee9:	48 63 d0             	movslq %eax,%rdx
  803eec:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803ef3:	48 89 d6             	mov    %rdx,%rsi
  803ef6:	48 89 c7             	mov    %rax,%rdi
  803ef9:	48 b8 0f 19 80 00 00 	movabs $0x80190f,%rax
  803f00:	00 00 00 
  803f03:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  803f05:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f08:	01 45 fc             	add    %eax,-0x4(%rbp)
  803f0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f0e:	48 98                	cltq   
  803f10:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803f17:	0f 82 78 ff ff ff    	jb     803e95 <devcons_write+0x29>
	}
	return tot;
  803f1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803f20:	c9                   	leaveq 
  803f21:	c3                   	retq   

0000000000803f22 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803f22:	55                   	push   %rbp
  803f23:	48 89 e5             	mov    %rsp,%rbp
  803f26:	48 83 ec 08          	sub    $0x8,%rsp
  803f2a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803f2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f33:	c9                   	leaveq 
  803f34:	c3                   	retq   

0000000000803f35 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803f35:	55                   	push   %rbp
  803f36:	48 89 e5             	mov    %rsp,%rbp
  803f39:	48 83 ec 10          	sub    $0x10,%rsp
  803f3d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803f41:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803f45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f49:	48 be 9c 49 80 00 00 	movabs $0x80499c,%rsi
  803f50:	00 00 00 
  803f53:	48 89 c7             	mov    %rax,%rdi
  803f56:	48 b8 28 11 80 00 00 	movabs $0x801128,%rax
  803f5d:	00 00 00 
  803f60:	ff d0                	callq  *%rax
	return 0;
  803f62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f67:	c9                   	leaveq 
  803f68:	c3                   	retq   

0000000000803f69 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803f69:	55                   	push   %rbp
  803f6a:	48 89 e5             	mov    %rsp,%rbp
  803f6d:	48 83 ec 20          	sub    $0x20,%rsp
  803f71:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803f75:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803f79:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  803f7d:	48 ba a8 49 80 00 00 	movabs $0x8049a8,%rdx
  803f84:	00 00 00 
  803f87:	be 1d 00 00 00       	mov    $0x1d,%esi
  803f8c:	48 bf c1 49 80 00 00 	movabs $0x8049c1,%rdi
  803f93:	00 00 00 
  803f96:	b8 00 00 00 00       	mov    $0x0,%eax
  803f9b:	48 b9 55 03 80 00 00 	movabs $0x800355,%rcx
  803fa2:	00 00 00 
  803fa5:	ff d1                	callq  *%rcx

0000000000803fa7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803fa7:	55                   	push   %rbp
  803fa8:	48 89 e5             	mov    %rsp,%rbp
  803fab:	48 83 ec 20          	sub    $0x20,%rsp
  803faf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803fb2:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803fb5:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  803fb9:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  803fbc:	48 ba cb 49 80 00 00 	movabs $0x8049cb,%rdx
  803fc3:	00 00 00 
  803fc6:	be 2d 00 00 00       	mov    $0x2d,%esi
  803fcb:	48 bf c1 49 80 00 00 	movabs $0x8049c1,%rdi
  803fd2:	00 00 00 
  803fd5:	b8 00 00 00 00       	mov    $0x0,%eax
  803fda:	48 b9 55 03 80 00 00 	movabs $0x800355,%rcx
  803fe1:	00 00 00 
  803fe4:	ff d1                	callq  *%rcx

0000000000803fe6 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803fe6:	55                   	push   %rbp
  803fe7:	48 89 e5             	mov    %rsp,%rbp
  803fea:	53                   	push   %rbx
  803feb:	48 83 ec 48          	sub    $0x48,%rsp
  803fef:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  803ff3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  803ffa:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  804001:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  804006:	75 0e                	jne    804016 <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  804008:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  80400f:	00 00 00 
  804012:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  804016:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80401a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  80401e:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  804025:	00 
	a3 = (uint64_t) 0;
  804026:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  80402d:	00 
	a4 = (uint64_t) 0;
  80402e:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  804035:	00 
	a5 = 0;
  804036:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  80403d:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  80403e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804041:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804045:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  804049:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  80404d:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  804051:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  804055:	4c 89 c3             	mov    %r8,%rbx
  804058:	0f 01 c1             	vmcall 
  80405b:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  80405e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804062:	7e 36                	jle    80409a <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  804064:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804067:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80406a:	41 89 d0             	mov    %edx,%r8d
  80406d:	89 c1                	mov    %eax,%ecx
  80406f:	48 ba e8 49 80 00 00 	movabs $0x8049e8,%rdx
  804076:	00 00 00 
  804079:	be 54 00 00 00       	mov    $0x54,%esi
  80407e:	48 bf c1 49 80 00 00 	movabs $0x8049c1,%rdi
  804085:	00 00 00 
  804088:	b8 00 00 00 00       	mov    $0x0,%eax
  80408d:	49 b9 55 03 80 00 00 	movabs $0x800355,%r9
  804094:	00 00 00 
  804097:	41 ff d1             	callq  *%r9
	return ret;
  80409a:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80409d:	48 83 c4 48          	add    $0x48,%rsp
  8040a1:	5b                   	pop    %rbx
  8040a2:	5d                   	pop    %rbp
  8040a3:	c3                   	retq   

00000000008040a4 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8040a4:	55                   	push   %rbp
  8040a5:	48 89 e5             	mov    %rsp,%rbp
  8040a8:	53                   	push   %rbx
  8040a9:	48 83 ec 58          	sub    $0x58,%rsp
  8040ad:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  8040b0:	89 75 b0             	mov    %esi,-0x50(%rbp)
  8040b3:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  8040b7:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  8040ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  8040c1:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  8040c8:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  8040cd:	75 0e                	jne    8040dd <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  8040cf:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8040d6:	00 00 00 
  8040d9:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  8040dd:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8040e0:	48 98                	cltq   
  8040e2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  8040e6:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8040e9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  8040ed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8040f1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  8040f5:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  8040f8:	48 98                	cltq   
  8040fa:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  8040fe:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  804105:	00 

	int r = -E_IPC_NOT_RECV;
  804106:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  80410d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804110:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804114:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  804118:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  80411c:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  804120:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  804124:	4c 89 c3             	mov    %r8,%rbx
  804127:	0f 01 c1             	vmcall 
  80412a:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  80412d:	48 83 c4 58          	add    $0x58,%rsp
  804131:	5b                   	pop    %rbx
  804132:	5d                   	pop    %rbp
  804133:	c3                   	retq   

0000000000804134 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804134:	55                   	push   %rbp
  804135:	48 89 e5             	mov    %rsp,%rbp
  804138:	48 83 ec 18          	sub    $0x18,%rsp
  80413c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80413f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804146:	eb 4e                	jmp    804196 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  804148:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80414f:	00 00 00 
  804152:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804155:	48 98                	cltq   
  804157:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80415e:	48 01 d0             	add    %rdx,%rax
  804161:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804167:	8b 00                	mov    (%rax),%eax
  804169:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80416c:	75 24                	jne    804192 <ipc_find_env+0x5e>
			return envs[i].env_id;
  80416e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804175:	00 00 00 
  804178:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80417b:	48 98                	cltq   
  80417d:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804184:	48 01 d0             	add    %rdx,%rax
  804187:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80418d:	8b 40 08             	mov    0x8(%rax),%eax
  804190:	eb 12                	jmp    8041a4 <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  804192:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804196:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80419d:	7e a9                	jle    804148 <ipc_find_env+0x14>
	}
	return 0;
  80419f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041a4:	c9                   	leaveq 
  8041a5:	c3                   	retq   

00000000008041a6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8041a6:	55                   	push   %rbp
  8041a7:	48 89 e5             	mov    %rsp,%rbp
  8041aa:	48 83 ec 18          	sub    $0x18,%rsp
  8041ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8041b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041b6:	48 c1 e8 15          	shr    $0x15,%rax
  8041ba:	48 89 c2             	mov    %rax,%rdx
  8041bd:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8041c4:	01 00 00 
  8041c7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041cb:	83 e0 01             	and    $0x1,%eax
  8041ce:	48 85 c0             	test   %rax,%rax
  8041d1:	75 07                	jne    8041da <pageref+0x34>
		return 0;
  8041d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8041d8:	eb 53                	jmp    80422d <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8041da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041de:	48 c1 e8 0c          	shr    $0xc,%rax
  8041e2:	48 89 c2             	mov    %rax,%rdx
  8041e5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8041ec:	01 00 00 
  8041ef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8041f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041fb:	83 e0 01             	and    $0x1,%eax
  8041fe:	48 85 c0             	test   %rax,%rax
  804201:	75 07                	jne    80420a <pageref+0x64>
		return 0;
  804203:	b8 00 00 00 00       	mov    $0x0,%eax
  804208:	eb 23                	jmp    80422d <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80420a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80420e:	48 c1 e8 0c          	shr    $0xc,%rax
  804212:	48 89 c2             	mov    %rax,%rdx
  804215:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80421c:	00 00 00 
  80421f:	48 c1 e2 04          	shl    $0x4,%rdx
  804223:	48 01 d0             	add    %rdx,%rax
  804226:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80422a:	0f b7 c0             	movzwl %ax,%eax
}
  80422d:	c9                   	leaveq 
  80422e:	c3                   	retq   
