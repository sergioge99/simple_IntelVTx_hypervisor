
vmm/guest/obj/user/testpteshare:     formato del fichero elf64-x86-64


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
  80003c:	e8 67 02 00 00       	callq  8002a8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

void childofspawn(void);

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	if (argc != 0)
  800052:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800056:	74 0c                	je     800064 <umain+0x21>
		childofspawn();
  800058:	48 b8 75 02 80 00 00 	movabs $0x800275,%rax
  80005f:	00 00 00 
  800062:	ff d0                	callq  *%rax

	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800064:	ba 07 04 00 00       	mov    $0x407,%edx
  800069:	be 00 00 00 a0       	mov    $0xa0000000,%esi
  80006e:	bf 00 00 00 00       	mov    $0x0,%edi
  800073:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  80007a:	00 00 00 
  80007d:	ff d0                	callq  *%rax
  80007f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800082:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800086:	79 30                	jns    8000b8 <umain+0x75>
		panic("sys_page_alloc: %e", r);
  800088:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80008b:	89 c1                	mov    %eax,%ecx
  80008d:	48 ba 1e 4b 80 00 00 	movabs $0x804b1e,%rdx
  800094:	00 00 00 
  800097:	be 13 00 00 00       	mov    $0x13,%esi
  80009c:	48 bf 31 4b 80 00 00 	movabs $0x804b31,%rdi
  8000a3:	00 00 00 
  8000a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ab:	49 b8 2b 03 80 00 00 	movabs $0x80032b,%r8
  8000b2:	00 00 00 
  8000b5:	41 ff d0             	callq  *%r8

	// check fork
	if ((r = fork()) < 0)
  8000b8:	48 b8 17 1e 80 00 00 	movabs $0x801e17,%rax
  8000bf:	00 00 00 
  8000c2:	ff d0                	callq  *%rax
  8000c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000cb:	79 30                	jns    8000fd <umain+0xba>
		panic("fork: %e", r);
  8000cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba 45 4b 80 00 00 	movabs $0x804b45,%rdx
  8000d9:	00 00 00 
  8000dc:	be 17 00 00 00       	mov    $0x17,%esi
  8000e1:	48 bf 31 4b 80 00 00 	movabs $0x804b31,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 2b 03 80 00 00 	movabs $0x80032b,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8
	if (r == 0) {
  8000fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800101:	75 2d                	jne    800130 <umain+0xed>
		strcpy(VA, msg);
  800103:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80010a:	00 00 00 
  80010d:	48 8b 00             	mov    (%rax),%rax
  800110:	48 89 c6             	mov    %rax,%rsi
  800113:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800118:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  80011f:	00 00 00 
  800122:	ff d0                	callq  *%rax
		exit();
  800124:	48 b8 08 03 80 00 00 	movabs $0x800308,%rax
  80012b:	00 00 00 
  80012e:	ff d0                	callq  *%rax
	}
	wait(r);
  800130:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800133:	89 c7                	mov    %eax,%edi
  800135:	48 b8 cd 44 80 00 00 	movabs $0x8044cd,%rax
  80013c:	00 00 00 
  80013f:	ff d0                	callq  *%rax
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  800141:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800148:	00 00 00 
  80014b:	48 8b 00             	mov    (%rax),%rax
  80014e:	48 89 c6             	mov    %rax,%rsi
  800151:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800156:	48 b8 60 12 80 00 00 	movabs $0x801260,%rax
  80015d:	00 00 00 
  800160:	ff d0                	callq  *%rax
  800162:	85 c0                	test   %eax,%eax
  800164:	75 0c                	jne    800172 <umain+0x12f>
  800166:	48 b8 4e 4b 80 00 00 	movabs $0x804b4e,%rax
  80016d:	00 00 00 
  800170:	eb 0a                	jmp    80017c <umain+0x139>
  800172:	48 b8 54 4b 80 00 00 	movabs $0x804b54,%rax
  800179:	00 00 00 
  80017c:	48 89 c6             	mov    %rax,%rsi
  80017f:	48 bf 5a 4b 80 00 00 	movabs $0x804b5a,%rdi
  800186:	00 00 00 
  800189:	b8 00 00 00 00       	mov    $0x0,%eax
  80018e:	48 ba 64 05 80 00 00 	movabs $0x800564,%rdx
  800195:	00 00 00 
  800198:	ff d2                	callq  *%rdx

	// check spawn
	if ((r = spawnl("/bin/testpteshare", "testpteshare", "arg", 0)) < 0)
  80019a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80019f:	48 ba 75 4b 80 00 00 	movabs $0x804b75,%rdx
  8001a6:	00 00 00 
  8001a9:	48 be 79 4b 80 00 00 	movabs $0x804b79,%rsi
  8001b0:	00 00 00 
  8001b3:	48 bf 86 4b 80 00 00 	movabs $0x804b86,%rdi
  8001ba:	00 00 00 
  8001bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c2:	49 b8 ec 2f 80 00 00 	movabs $0x802fec,%r8
  8001c9:	00 00 00 
  8001cc:	41 ff d0             	callq  *%r8
  8001cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001d6:	79 30                	jns    800208 <umain+0x1c5>
		panic("spawn: %e", r);
  8001d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001db:	89 c1                	mov    %eax,%ecx
  8001dd:	48 ba 98 4b 80 00 00 	movabs $0x804b98,%rdx
  8001e4:	00 00 00 
  8001e7:	be 21 00 00 00       	mov    $0x21,%esi
  8001ec:	48 bf 31 4b 80 00 00 	movabs $0x804b31,%rdi
  8001f3:	00 00 00 
  8001f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8001fb:	49 b8 2b 03 80 00 00 	movabs $0x80032b,%r8
  800202:	00 00 00 
  800205:	41 ff d0             	callq  *%r8
	wait(r);
  800208:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80020b:	89 c7                	mov    %eax,%edi
  80020d:	48 b8 cd 44 80 00 00 	movabs $0x8044cd,%rax
  800214:	00 00 00 
  800217:	ff d0                	callq  *%rax
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  800219:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800220:	00 00 00 
  800223:	48 8b 00             	mov    (%rax),%rax
  800226:	48 89 c6             	mov    %rax,%rsi
  800229:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  80022e:	48 b8 60 12 80 00 00 	movabs $0x801260,%rax
  800235:	00 00 00 
  800238:	ff d0                	callq  *%rax
  80023a:	85 c0                	test   %eax,%eax
  80023c:	75 0c                	jne    80024a <umain+0x207>
  80023e:	48 b8 4e 4b 80 00 00 	movabs $0x804b4e,%rax
  800245:	00 00 00 
  800248:	eb 0a                	jmp    800254 <umain+0x211>
  80024a:	48 b8 54 4b 80 00 00 	movabs $0x804b54,%rax
  800251:	00 00 00 
  800254:	48 89 c6             	mov    %rax,%rsi
  800257:	48 bf a2 4b 80 00 00 	movabs $0x804ba2,%rdi
  80025e:	00 00 00 
  800261:	b8 00 00 00 00       	mov    $0x0,%eax
  800266:	48 ba 64 05 80 00 00 	movabs $0x800564,%rdx
  80026d:	00 00 00 
  800270:	ff d2                	callq  *%rdx
static __inline void read_gdtr (uint64_t *gdtbase, uint16_t *gdtlimit) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800272:	cc                   	int3   

	breakpoint();
}
  800273:	c9                   	leaveq 
  800274:	c3                   	retq   

0000000000800275 <childofspawn>:

void
childofspawn(void)
{
  800275:	55                   	push   %rbp
  800276:	48 89 e5             	mov    %rsp,%rbp
	strcpy(VA, msg2);
  800279:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800280:	00 00 00 
  800283:	48 8b 00             	mov    (%rax),%rax
  800286:	48 89 c6             	mov    %rax,%rsi
  800289:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  80028e:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
	exit();
  80029a:	48 b8 08 03 80 00 00 	movabs $0x800308,%rax
  8002a1:	00 00 00 
  8002a4:	ff d0                	callq  *%rax
}
  8002a6:	5d                   	pop    %rbp
  8002a7:	c3                   	retq   

00000000008002a8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002a8:	55                   	push   %rbp
  8002a9:	48 89 e5             	mov    %rsp,%rbp
  8002ac:	48 83 ec 10          	sub    $0x10,%rsp
  8002b0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8002b7:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8002be:	00 00 00 
  8002c1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002cc:	7e 14                	jle    8002e2 <libmain+0x3a>
		binaryname = argv[0];
  8002ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d2:	48 8b 10             	mov    (%rax),%rdx
  8002d5:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8002dc:	00 00 00 
  8002df:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8002e2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002e9:	48 89 d6             	mov    %rdx,%rsi
  8002ec:	89 c7                	mov    %eax,%edi
  8002ee:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002f5:	00 00 00 
  8002f8:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8002fa:	48 b8 08 03 80 00 00 	movabs $0x800308,%rax
  800301:	00 00 00 
  800304:	ff d0                	callq  *%rax
}
  800306:	c9                   	leaveq 
  800307:	c3                   	retq   

0000000000800308 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800308:	55                   	push   %rbp
  800309:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80030c:	48 b8 b6 21 80 00 00 	movabs $0x8021b6,%rax
  800313:	00 00 00 
  800316:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800318:	bf 00 00 00 00       	mov    $0x0,%edi
  80031d:	48 b8 6d 19 80 00 00 	movabs $0x80196d,%rax
  800324:	00 00 00 
  800327:	ff d0                	callq  *%rax
}
  800329:	5d                   	pop    %rbp
  80032a:	c3                   	retq   

000000000080032b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80032b:	55                   	push   %rbp
  80032c:	48 89 e5             	mov    %rsp,%rbp
  80032f:	53                   	push   %rbx
  800330:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800337:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80033e:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800344:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80034b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800352:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800359:	84 c0                	test   %al,%al
  80035b:	74 23                	je     800380 <_panic+0x55>
  80035d:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800364:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800368:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80036c:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800370:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800374:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800378:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80037c:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800380:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800387:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80038e:	00 00 00 
  800391:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800398:	00 00 00 
  80039b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80039f:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8003a6:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8003ad:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003b4:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8003bb:	00 00 00 
  8003be:	48 8b 18             	mov    (%rax),%rbx
  8003c1:	48 b8 b3 19 80 00 00 	movabs $0x8019b3,%rax
  8003c8:	00 00 00 
  8003cb:	ff d0                	callq  *%rax
  8003cd:	89 c6                	mov    %eax,%esi
  8003cf:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8003d5:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8003dc:	41 89 d0             	mov    %edx,%r8d
  8003df:	48 89 c1             	mov    %rax,%rcx
  8003e2:	48 89 da             	mov    %rbx,%rdx
  8003e5:	48 bf c8 4b 80 00 00 	movabs $0x804bc8,%rdi
  8003ec:	00 00 00 
  8003ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f4:	49 b9 64 05 80 00 00 	movabs $0x800564,%r9
  8003fb:	00 00 00 
  8003fe:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800401:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800408:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80040f:	48 89 d6             	mov    %rdx,%rsi
  800412:	48 89 c7             	mov    %rax,%rdi
  800415:	48 b8 b8 04 80 00 00 	movabs $0x8004b8,%rax
  80041c:	00 00 00 
  80041f:	ff d0                	callq  *%rax
	cprintf("\n");
  800421:	48 bf eb 4b 80 00 00 	movabs $0x804beb,%rdi
  800428:	00 00 00 
  80042b:	b8 00 00 00 00       	mov    $0x0,%eax
  800430:	48 ba 64 05 80 00 00 	movabs $0x800564,%rdx
  800437:	00 00 00 
  80043a:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80043c:	cc                   	int3   
  80043d:	eb fd                	jmp    80043c <_panic+0x111>

000000000080043f <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80043f:	55                   	push   %rbp
  800440:	48 89 e5             	mov    %rsp,%rbp
  800443:	48 83 ec 10          	sub    $0x10,%rsp
  800447:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80044a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80044e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800452:	8b 00                	mov    (%rax),%eax
  800454:	8d 48 01             	lea    0x1(%rax),%ecx
  800457:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80045b:	89 0a                	mov    %ecx,(%rdx)
  80045d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800460:	89 d1                	mov    %edx,%ecx
  800462:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800466:	48 98                	cltq   
  800468:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80046c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800470:	8b 00                	mov    (%rax),%eax
  800472:	3d ff 00 00 00       	cmp    $0xff,%eax
  800477:	75 2c                	jne    8004a5 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800479:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80047d:	8b 00                	mov    (%rax),%eax
  80047f:	48 98                	cltq   
  800481:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800485:	48 83 c2 08          	add    $0x8,%rdx
  800489:	48 89 c6             	mov    %rax,%rsi
  80048c:	48 89 d7             	mov    %rdx,%rdi
  80048f:	48 b8 e5 18 80 00 00 	movabs $0x8018e5,%rax
  800496:	00 00 00 
  800499:	ff d0                	callq  *%rax
        b->idx = 0;
  80049b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80049f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8004a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004a9:	8b 40 04             	mov    0x4(%rax),%eax
  8004ac:	8d 50 01             	lea    0x1(%rax),%edx
  8004af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004b3:	89 50 04             	mov    %edx,0x4(%rax)
}
  8004b6:	c9                   	leaveq 
  8004b7:	c3                   	retq   

00000000008004b8 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8004b8:	55                   	push   %rbp
  8004b9:	48 89 e5             	mov    %rsp,%rbp
  8004bc:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8004c3:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8004ca:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8004d1:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8004d8:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8004df:	48 8b 0a             	mov    (%rdx),%rcx
  8004e2:	48 89 08             	mov    %rcx,(%rax)
  8004e5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004e9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004ed:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004f1:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8004f5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004fc:	00 00 00 
    b.cnt = 0;
  8004ff:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800506:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800509:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800510:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800517:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80051e:	48 89 c6             	mov    %rax,%rsi
  800521:	48 bf 3f 04 80 00 00 	movabs $0x80043f,%rdi
  800528:	00 00 00 
  80052b:	48 b8 03 09 80 00 00 	movabs $0x800903,%rax
  800532:	00 00 00 
  800535:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800537:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80053d:	48 98                	cltq   
  80053f:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800546:	48 83 c2 08          	add    $0x8,%rdx
  80054a:	48 89 c6             	mov    %rax,%rsi
  80054d:	48 89 d7             	mov    %rdx,%rdi
  800550:	48 b8 e5 18 80 00 00 	movabs $0x8018e5,%rax
  800557:	00 00 00 
  80055a:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80055c:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800562:	c9                   	leaveq 
  800563:	c3                   	retq   

0000000000800564 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800564:	55                   	push   %rbp
  800565:	48 89 e5             	mov    %rsp,%rbp
  800568:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80056f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800576:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80057d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800584:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80058b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800592:	84 c0                	test   %al,%al
  800594:	74 20                	je     8005b6 <cprintf+0x52>
  800596:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80059a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80059e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8005a2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8005a6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8005aa:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8005ae:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8005b2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8005b6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8005bd:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8005c4:	00 00 00 
  8005c7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8005ce:	00 00 00 
  8005d1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005d5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8005dc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8005e3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8005ea:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8005f1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005f8:	48 8b 0a             	mov    (%rdx),%rcx
  8005fb:	48 89 08             	mov    %rcx,(%rax)
  8005fe:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800602:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800606:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80060a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80060e:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800615:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80061c:	48 89 d6             	mov    %rdx,%rsi
  80061f:	48 89 c7             	mov    %rax,%rdi
  800622:	48 b8 b8 04 80 00 00 	movabs $0x8004b8,%rax
  800629:	00 00 00 
  80062c:	ff d0                	callq  *%rax
  80062e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800634:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80063a:	c9                   	leaveq 
  80063b:	c3                   	retq   

000000000080063c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80063c:	55                   	push   %rbp
  80063d:	48 89 e5             	mov    %rsp,%rbp
  800640:	48 83 ec 30          	sub    $0x30,%rsp
  800644:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800648:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80064c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800650:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800653:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800657:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80065b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80065e:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800662:	77 42                	ja     8006a6 <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800664:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800667:	8d 78 ff             	lea    -0x1(%rax),%edi
  80066a:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  80066d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800671:	ba 00 00 00 00       	mov    $0x0,%edx
  800676:	48 f7 f6             	div    %rsi
  800679:	49 89 c2             	mov    %rax,%r10
  80067c:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80067f:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800682:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800686:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80068a:	41 89 c9             	mov    %ecx,%r9d
  80068d:	41 89 f8             	mov    %edi,%r8d
  800690:	89 d1                	mov    %edx,%ecx
  800692:	4c 89 d2             	mov    %r10,%rdx
  800695:	48 89 c7             	mov    %rax,%rdi
  800698:	48 b8 3c 06 80 00 00 	movabs $0x80063c,%rax
  80069f:	00 00 00 
  8006a2:	ff d0                	callq  *%rax
  8006a4:	eb 1e                	jmp    8006c4 <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006a6:	eb 12                	jmp    8006ba <printnum+0x7e>
			putch(padc, putdat);
  8006a8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8006ac:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8006af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006b3:	48 89 ce             	mov    %rcx,%rsi
  8006b6:	89 d7                	mov    %edx,%edi
  8006b8:	ff d0                	callq  *%rax
		while (--width > 0)
  8006ba:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8006be:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8006c2:	7f e4                	jg     8006a8 <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006c4:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8006c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d0:	48 f7 f1             	div    %rcx
  8006d3:	48 b8 f0 4d 80 00 00 	movabs $0x804df0,%rax
  8006da:	00 00 00 
  8006dd:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8006e1:	0f be d0             	movsbl %al,%edx
  8006e4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8006e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006ec:	48 89 ce             	mov    %rcx,%rsi
  8006ef:	89 d7                	mov    %edx,%edi
  8006f1:	ff d0                	callq  *%rax
}
  8006f3:	c9                   	leaveq 
  8006f4:	c3                   	retq   

00000000008006f5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006f5:	55                   	push   %rbp
  8006f6:	48 89 e5             	mov    %rsp,%rbp
  8006f9:	48 83 ec 20          	sub    $0x20,%rsp
  8006fd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800701:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800704:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800708:	7e 4f                	jle    800759 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  80070a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070e:	8b 00                	mov    (%rax),%eax
  800710:	83 f8 30             	cmp    $0x30,%eax
  800713:	73 24                	jae    800739 <getuint+0x44>
  800715:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800719:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80071d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800721:	8b 00                	mov    (%rax),%eax
  800723:	89 c0                	mov    %eax,%eax
  800725:	48 01 d0             	add    %rdx,%rax
  800728:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072c:	8b 12                	mov    (%rdx),%edx
  80072e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800731:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800735:	89 0a                	mov    %ecx,(%rdx)
  800737:	eb 14                	jmp    80074d <getuint+0x58>
  800739:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800741:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800745:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800749:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80074d:	48 8b 00             	mov    (%rax),%rax
  800750:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800754:	e9 9d 00 00 00       	jmpq   8007f6 <getuint+0x101>
	else if (lflag)
  800759:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80075d:	74 4c                	je     8007ab <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  80075f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800763:	8b 00                	mov    (%rax),%eax
  800765:	83 f8 30             	cmp    $0x30,%eax
  800768:	73 24                	jae    80078e <getuint+0x99>
  80076a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800772:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800776:	8b 00                	mov    (%rax),%eax
  800778:	89 c0                	mov    %eax,%eax
  80077a:	48 01 d0             	add    %rdx,%rax
  80077d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800781:	8b 12                	mov    (%rdx),%edx
  800783:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800786:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078a:	89 0a                	mov    %ecx,(%rdx)
  80078c:	eb 14                	jmp    8007a2 <getuint+0xad>
  80078e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800792:	48 8b 40 08          	mov    0x8(%rax),%rax
  800796:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80079a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007a2:	48 8b 00             	mov    (%rax),%rax
  8007a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007a9:	eb 4b                	jmp    8007f6 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8007ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007af:	8b 00                	mov    (%rax),%eax
  8007b1:	83 f8 30             	cmp    $0x30,%eax
  8007b4:	73 24                	jae    8007da <getuint+0xe5>
  8007b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ba:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c2:	8b 00                	mov    (%rax),%eax
  8007c4:	89 c0                	mov    %eax,%eax
  8007c6:	48 01 d0             	add    %rdx,%rax
  8007c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007cd:	8b 12                	mov    (%rdx),%edx
  8007cf:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d6:	89 0a                	mov    %ecx,(%rdx)
  8007d8:	eb 14                	jmp    8007ee <getuint+0xf9>
  8007da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007de:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007e2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ea:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007ee:	8b 00                	mov    (%rax),%eax
  8007f0:	89 c0                	mov    %eax,%eax
  8007f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007fa:	c9                   	leaveq 
  8007fb:	c3                   	retq   

00000000008007fc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007fc:	55                   	push   %rbp
  8007fd:	48 89 e5             	mov    %rsp,%rbp
  800800:	48 83 ec 20          	sub    $0x20,%rsp
  800804:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800808:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80080b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80080f:	7e 4f                	jle    800860 <getint+0x64>
		x=va_arg(*ap, long long);
  800811:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800815:	8b 00                	mov    (%rax),%eax
  800817:	83 f8 30             	cmp    $0x30,%eax
  80081a:	73 24                	jae    800840 <getint+0x44>
  80081c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800820:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800824:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800828:	8b 00                	mov    (%rax),%eax
  80082a:	89 c0                	mov    %eax,%eax
  80082c:	48 01 d0             	add    %rdx,%rax
  80082f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800833:	8b 12                	mov    (%rdx),%edx
  800835:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800838:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083c:	89 0a                	mov    %ecx,(%rdx)
  80083e:	eb 14                	jmp    800854 <getint+0x58>
  800840:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800844:	48 8b 40 08          	mov    0x8(%rax),%rax
  800848:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80084c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800850:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800854:	48 8b 00             	mov    (%rax),%rax
  800857:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80085b:	e9 9d 00 00 00       	jmpq   8008fd <getint+0x101>
	else if (lflag)
  800860:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800864:	74 4c                	je     8008b2 <getint+0xb6>
		x=va_arg(*ap, long);
  800866:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086a:	8b 00                	mov    (%rax),%eax
  80086c:	83 f8 30             	cmp    $0x30,%eax
  80086f:	73 24                	jae    800895 <getint+0x99>
  800871:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800875:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800879:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087d:	8b 00                	mov    (%rax),%eax
  80087f:	89 c0                	mov    %eax,%eax
  800881:	48 01 d0             	add    %rdx,%rax
  800884:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800888:	8b 12                	mov    (%rdx),%edx
  80088a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80088d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800891:	89 0a                	mov    %ecx,(%rdx)
  800893:	eb 14                	jmp    8008a9 <getint+0xad>
  800895:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800899:	48 8b 40 08          	mov    0x8(%rax),%rax
  80089d:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8008a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008a9:	48 8b 00             	mov    (%rax),%rax
  8008ac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008b0:	eb 4b                	jmp    8008fd <getint+0x101>
	else
		x=va_arg(*ap, int);
  8008b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b6:	8b 00                	mov    (%rax),%eax
  8008b8:	83 f8 30             	cmp    $0x30,%eax
  8008bb:	73 24                	jae    8008e1 <getint+0xe5>
  8008bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c9:	8b 00                	mov    (%rax),%eax
  8008cb:	89 c0                	mov    %eax,%eax
  8008cd:	48 01 d0             	add    %rdx,%rax
  8008d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d4:	8b 12                	mov    (%rdx),%edx
  8008d6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008dd:	89 0a                	mov    %ecx,(%rdx)
  8008df:	eb 14                	jmp    8008f5 <getint+0xf9>
  8008e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8008e9:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8008ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008f5:	8b 00                	mov    (%rax),%eax
  8008f7:	48 98                	cltq   
  8008f9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800901:	c9                   	leaveq 
  800902:	c3                   	retq   

0000000000800903 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800903:	55                   	push   %rbp
  800904:	48 89 e5             	mov    %rsp,%rbp
  800907:	41 54                	push   %r12
  800909:	53                   	push   %rbx
  80090a:	48 83 ec 60          	sub    $0x60,%rsp
  80090e:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800912:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800916:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80091a:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80091e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800922:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800926:	48 8b 0a             	mov    (%rdx),%rcx
  800929:	48 89 08             	mov    %rcx,(%rax)
  80092c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800930:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800934:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800938:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80093c:	eb 17                	jmp    800955 <vprintfmt+0x52>
			if (ch == '\0')
  80093e:	85 db                	test   %ebx,%ebx
  800940:	0f 84 c5 04 00 00    	je     800e0b <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  800946:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80094a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80094e:	48 89 d6             	mov    %rdx,%rsi
  800951:	89 df                	mov    %ebx,%edi
  800953:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800955:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800959:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80095d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800961:	0f b6 00             	movzbl (%rax),%eax
  800964:	0f b6 d8             	movzbl %al,%ebx
  800967:	83 fb 25             	cmp    $0x25,%ebx
  80096a:	75 d2                	jne    80093e <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  80096c:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800970:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800977:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80097e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800985:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80098c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800990:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800994:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800998:	0f b6 00             	movzbl (%rax),%eax
  80099b:	0f b6 d8             	movzbl %al,%ebx
  80099e:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8009a1:	83 f8 55             	cmp    $0x55,%eax
  8009a4:	0f 87 2e 04 00 00    	ja     800dd8 <vprintfmt+0x4d5>
  8009aa:	89 c0                	mov    %eax,%eax
  8009ac:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8009b3:	00 
  8009b4:	48 b8 18 4e 80 00 00 	movabs $0x804e18,%rax
  8009bb:	00 00 00 
  8009be:	48 01 d0             	add    %rdx,%rax
  8009c1:	48 8b 00             	mov    (%rax),%rax
  8009c4:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8009c6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8009ca:	eb c0                	jmp    80098c <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009cc:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8009d0:	eb ba                	jmp    80098c <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8009d9:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8009dc:	89 d0                	mov    %edx,%eax
  8009de:	c1 e0 02             	shl    $0x2,%eax
  8009e1:	01 d0                	add    %edx,%eax
  8009e3:	01 c0                	add    %eax,%eax
  8009e5:	01 d8                	add    %ebx,%eax
  8009e7:	83 e8 30             	sub    $0x30,%eax
  8009ea:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009ed:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009f1:	0f b6 00             	movzbl (%rax),%eax
  8009f4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009f7:	83 fb 2f             	cmp    $0x2f,%ebx
  8009fa:	7e 0c                	jle    800a08 <vprintfmt+0x105>
  8009fc:	83 fb 39             	cmp    $0x39,%ebx
  8009ff:	7f 07                	jg     800a08 <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  800a01:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  800a06:	eb d1                	jmp    8009d9 <vprintfmt+0xd6>
			goto process_precision;
  800a08:	eb 50                	jmp    800a5a <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  800a0a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a0d:	83 f8 30             	cmp    $0x30,%eax
  800a10:	73 17                	jae    800a29 <vprintfmt+0x126>
  800a12:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a16:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a19:	89 d2                	mov    %edx,%edx
  800a1b:	48 01 d0             	add    %rdx,%rax
  800a1e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a21:	83 c2 08             	add    $0x8,%edx
  800a24:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a27:	eb 0c                	jmp    800a35 <vprintfmt+0x132>
  800a29:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a2d:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800a31:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a35:	8b 00                	mov    (%rax),%eax
  800a37:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a3a:	eb 1e                	jmp    800a5a <vprintfmt+0x157>

		case '.':
			if (width < 0)
  800a3c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a40:	79 07                	jns    800a49 <vprintfmt+0x146>
				width = 0;
  800a42:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a49:	e9 3e ff ff ff       	jmpq   80098c <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800a4e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a55:	e9 32 ff ff ff       	jmpq   80098c <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800a5a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a5e:	79 0d                	jns    800a6d <vprintfmt+0x16a>
				width = precision, precision = -1;
  800a60:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a63:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a66:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a6d:	e9 1a ff ff ff       	jmpq   80098c <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a72:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a76:	e9 11 ff ff ff       	jmpq   80098c <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a7b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a7e:	83 f8 30             	cmp    $0x30,%eax
  800a81:	73 17                	jae    800a9a <vprintfmt+0x197>
  800a83:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800a87:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a8a:	89 d2                	mov    %edx,%edx
  800a8c:	48 01 d0             	add    %rdx,%rax
  800a8f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a92:	83 c2 08             	add    $0x8,%edx
  800a95:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a98:	eb 0c                	jmp    800aa6 <vprintfmt+0x1a3>
  800a9a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800a9e:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800aa2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800aa6:	8b 10                	mov    (%rax),%edx
  800aa8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800aac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab0:	48 89 ce             	mov    %rcx,%rsi
  800ab3:	89 d7                	mov    %edx,%edi
  800ab5:	ff d0                	callq  *%rax
			break;
  800ab7:	e9 4a 03 00 00       	jmpq   800e06 <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800abc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800abf:	83 f8 30             	cmp    $0x30,%eax
  800ac2:	73 17                	jae    800adb <vprintfmt+0x1d8>
  800ac4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ac8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800acb:	89 d2                	mov    %edx,%edx
  800acd:	48 01 d0             	add    %rdx,%rax
  800ad0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ad3:	83 c2 08             	add    $0x8,%edx
  800ad6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ad9:	eb 0c                	jmp    800ae7 <vprintfmt+0x1e4>
  800adb:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800adf:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ae3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ae7:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800ae9:	85 db                	test   %ebx,%ebx
  800aeb:	79 02                	jns    800aef <vprintfmt+0x1ec>
				err = -err;
  800aed:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800aef:	83 fb 15             	cmp    $0x15,%ebx
  800af2:	7f 16                	jg     800b0a <vprintfmt+0x207>
  800af4:	48 b8 40 4d 80 00 00 	movabs $0x804d40,%rax
  800afb:	00 00 00 
  800afe:	48 63 d3             	movslq %ebx,%rdx
  800b01:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b05:	4d 85 e4             	test   %r12,%r12
  800b08:	75 2e                	jne    800b38 <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  800b0a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b0e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b12:	89 d9                	mov    %ebx,%ecx
  800b14:	48 ba 01 4e 80 00 00 	movabs $0x804e01,%rdx
  800b1b:	00 00 00 
  800b1e:	48 89 c7             	mov    %rax,%rdi
  800b21:	b8 00 00 00 00       	mov    $0x0,%eax
  800b26:	49 b8 14 0e 80 00 00 	movabs $0x800e14,%r8
  800b2d:	00 00 00 
  800b30:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b33:	e9 ce 02 00 00       	jmpq   800e06 <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  800b38:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b3c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b40:	4c 89 e1             	mov    %r12,%rcx
  800b43:	48 ba 0a 4e 80 00 00 	movabs $0x804e0a,%rdx
  800b4a:	00 00 00 
  800b4d:	48 89 c7             	mov    %rax,%rdi
  800b50:	b8 00 00 00 00       	mov    $0x0,%eax
  800b55:	49 b8 14 0e 80 00 00 	movabs $0x800e14,%r8
  800b5c:	00 00 00 
  800b5f:	41 ff d0             	callq  *%r8
			break;
  800b62:	e9 9f 02 00 00       	jmpq   800e06 <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b67:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b6a:	83 f8 30             	cmp    $0x30,%eax
  800b6d:	73 17                	jae    800b86 <vprintfmt+0x283>
  800b6f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b73:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b76:	89 d2                	mov    %edx,%edx
  800b78:	48 01 d0             	add    %rdx,%rax
  800b7b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b7e:	83 c2 08             	add    $0x8,%edx
  800b81:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b84:	eb 0c                	jmp    800b92 <vprintfmt+0x28f>
  800b86:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b8a:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b8e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b92:	4c 8b 20             	mov    (%rax),%r12
  800b95:	4d 85 e4             	test   %r12,%r12
  800b98:	75 0a                	jne    800ba4 <vprintfmt+0x2a1>
				p = "(null)";
  800b9a:	49 bc 0d 4e 80 00 00 	movabs $0x804e0d,%r12
  800ba1:	00 00 00 
			if (width > 0 && padc != '-')
  800ba4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ba8:	7e 3f                	jle    800be9 <vprintfmt+0x2e6>
  800baa:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800bae:	74 39                	je     800be9 <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bb0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800bb3:	48 98                	cltq   
  800bb5:	48 89 c6             	mov    %rax,%rsi
  800bb8:	4c 89 e7             	mov    %r12,%rdi
  800bbb:	48 b8 c0 10 80 00 00 	movabs $0x8010c0,%rax
  800bc2:	00 00 00 
  800bc5:	ff d0                	callq  *%rax
  800bc7:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800bca:	eb 17                	jmp    800be3 <vprintfmt+0x2e0>
					putch(padc, putdat);
  800bcc:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800bd0:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bd4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd8:	48 89 ce             	mov    %rcx,%rsi
  800bdb:	89 d7                	mov    %edx,%edi
  800bdd:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  800bdf:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800be3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800be7:	7f e3                	jg     800bcc <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800be9:	eb 37                	jmp    800c22 <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  800beb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800bef:	74 1e                	je     800c0f <vprintfmt+0x30c>
  800bf1:	83 fb 1f             	cmp    $0x1f,%ebx
  800bf4:	7e 05                	jle    800bfb <vprintfmt+0x2f8>
  800bf6:	83 fb 7e             	cmp    $0x7e,%ebx
  800bf9:	7e 14                	jle    800c0f <vprintfmt+0x30c>
					putch('?', putdat);
  800bfb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c03:	48 89 d6             	mov    %rdx,%rsi
  800c06:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c0b:	ff d0                	callq  *%rax
  800c0d:	eb 0f                	jmp    800c1e <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  800c0f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c13:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c17:	48 89 d6             	mov    %rdx,%rsi
  800c1a:	89 df                	mov    %ebx,%edi
  800c1c:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c1e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c22:	4c 89 e0             	mov    %r12,%rax
  800c25:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c29:	0f b6 00             	movzbl (%rax),%eax
  800c2c:	0f be d8             	movsbl %al,%ebx
  800c2f:	85 db                	test   %ebx,%ebx
  800c31:	74 10                	je     800c43 <vprintfmt+0x340>
  800c33:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c37:	78 b2                	js     800beb <vprintfmt+0x2e8>
  800c39:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c3d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c41:	79 a8                	jns    800beb <vprintfmt+0x2e8>
			for (; width > 0; width--)
  800c43:	eb 16                	jmp    800c5b <vprintfmt+0x358>
				putch(' ', putdat);
  800c45:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c49:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c4d:	48 89 d6             	mov    %rdx,%rsi
  800c50:	bf 20 00 00 00       	mov    $0x20,%edi
  800c55:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  800c57:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c5b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c5f:	7f e4                	jg     800c45 <vprintfmt+0x342>
			break;
  800c61:	e9 a0 01 00 00       	jmpq   800e06 <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c66:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c6a:	be 03 00 00 00       	mov    $0x3,%esi
  800c6f:	48 89 c7             	mov    %rax,%rdi
  800c72:	48 b8 fc 07 80 00 00 	movabs $0x8007fc,%rax
  800c79:	00 00 00 
  800c7c:	ff d0                	callq  *%rax
  800c7e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c86:	48 85 c0             	test   %rax,%rax
  800c89:	79 1d                	jns    800ca8 <vprintfmt+0x3a5>
				putch('-', putdat);
  800c8b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c8f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c93:	48 89 d6             	mov    %rdx,%rsi
  800c96:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c9b:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ca1:	48 f7 d8             	neg    %rax
  800ca4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ca8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800caf:	e9 e5 00 00 00       	jmpq   800d99 <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800cb4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cb8:	be 03 00 00 00       	mov    $0x3,%esi
  800cbd:	48 89 c7             	mov    %rax,%rdi
  800cc0:	48 b8 f5 06 80 00 00 	movabs $0x8006f5,%rax
  800cc7:	00 00 00 
  800cca:	ff d0                	callq  *%rax
  800ccc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800cd0:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cd7:	e9 bd 00 00 00       	jmpq   800d99 <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800cdc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ce0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce4:	48 89 d6             	mov    %rdx,%rsi
  800ce7:	bf 58 00 00 00       	mov    $0x58,%edi
  800cec:	ff d0                	callq  *%rax
			putch('X', putdat);
  800cee:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cf2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf6:	48 89 d6             	mov    %rdx,%rsi
  800cf9:	bf 58 00 00 00       	mov    $0x58,%edi
  800cfe:	ff d0                	callq  *%rax
			putch('X', putdat);
  800d00:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d04:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d08:	48 89 d6             	mov    %rdx,%rsi
  800d0b:	bf 58 00 00 00       	mov    $0x58,%edi
  800d10:	ff d0                	callq  *%rax
			break;
  800d12:	e9 ef 00 00 00       	jmpq   800e06 <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  800d17:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d1b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d1f:	48 89 d6             	mov    %rdx,%rsi
  800d22:	bf 30 00 00 00       	mov    $0x30,%edi
  800d27:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d29:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d2d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d31:	48 89 d6             	mov    %rdx,%rsi
  800d34:	bf 78 00 00 00       	mov    $0x78,%edi
  800d39:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d3b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d3e:	83 f8 30             	cmp    $0x30,%eax
  800d41:	73 17                	jae    800d5a <vprintfmt+0x457>
  800d43:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d47:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d4a:	89 d2                	mov    %edx,%edx
  800d4c:	48 01 d0             	add    %rdx,%rax
  800d4f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d52:	83 c2 08             	add    $0x8,%edx
  800d55:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  800d58:	eb 0c                	jmp    800d66 <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  800d5a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d5e:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d62:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d66:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  800d69:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d6d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d74:	eb 23                	jmp    800d99 <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d76:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d7a:	be 03 00 00 00       	mov    $0x3,%esi
  800d7f:	48 89 c7             	mov    %rax,%rdi
  800d82:	48 b8 f5 06 80 00 00 	movabs $0x8006f5,%rax
  800d89:	00 00 00 
  800d8c:	ff d0                	callq  *%rax
  800d8e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d92:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d99:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d9e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800da1:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800da4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800da8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800db0:	45 89 c1             	mov    %r8d,%r9d
  800db3:	41 89 f8             	mov    %edi,%r8d
  800db6:	48 89 c7             	mov    %rax,%rdi
  800db9:	48 b8 3c 06 80 00 00 	movabs $0x80063c,%rax
  800dc0:	00 00 00 
  800dc3:	ff d0                	callq  *%rax
			break;
  800dc5:	eb 3f                	jmp    800e06 <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dc7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dcb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dcf:	48 89 d6             	mov    %rdx,%rsi
  800dd2:	89 df                	mov    %ebx,%edi
  800dd4:	ff d0                	callq  *%rax
			break;
  800dd6:	eb 2e                	jmp    800e06 <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dd8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ddc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de0:	48 89 d6             	mov    %rdx,%rsi
  800de3:	bf 25 00 00 00       	mov    $0x25,%edi
  800de8:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dea:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800def:	eb 05                	jmp    800df6 <vprintfmt+0x4f3>
  800df1:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800df6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800dfa:	48 83 e8 01          	sub    $0x1,%rax
  800dfe:	0f b6 00             	movzbl (%rax),%eax
  800e01:	3c 25                	cmp    $0x25,%al
  800e03:	75 ec                	jne    800df1 <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  800e05:	90                   	nop
		}
	}
  800e06:	e9 31 fb ff ff       	jmpq   80093c <vprintfmt+0x39>
	va_end(aq);
}
  800e0b:	48 83 c4 60          	add    $0x60,%rsp
  800e0f:	5b                   	pop    %rbx
  800e10:	41 5c                	pop    %r12
  800e12:	5d                   	pop    %rbp
  800e13:	c3                   	retq   

0000000000800e14 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e14:	55                   	push   %rbp
  800e15:	48 89 e5             	mov    %rsp,%rbp
  800e18:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e1f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e26:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e2d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e34:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e3b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e42:	84 c0                	test   %al,%al
  800e44:	74 20                	je     800e66 <printfmt+0x52>
  800e46:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e4a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e4e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e52:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e56:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e5a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e5e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e62:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e66:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e6d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e74:	00 00 00 
  800e77:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e7e:	00 00 00 
  800e81:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e85:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e8c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e93:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e9a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ea1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ea8:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800eaf:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800eb6:	48 89 c7             	mov    %rax,%rdi
  800eb9:	48 b8 03 09 80 00 00 	movabs $0x800903,%rax
  800ec0:	00 00 00 
  800ec3:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ec5:	c9                   	leaveq 
  800ec6:	c3                   	retq   

0000000000800ec7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ec7:	55                   	push   %rbp
  800ec8:	48 89 e5             	mov    %rsp,%rbp
  800ecb:	48 83 ec 10          	sub    $0x10,%rsp
  800ecf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ed2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ed6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eda:	8b 40 10             	mov    0x10(%rax),%eax
  800edd:	8d 50 01             	lea    0x1(%rax),%edx
  800ee0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ee4:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ee7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eeb:	48 8b 10             	mov    (%rax),%rdx
  800eee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ef2:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ef6:	48 39 c2             	cmp    %rax,%rdx
  800ef9:	73 17                	jae    800f12 <sprintputch+0x4b>
		*b->buf++ = ch;
  800efb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eff:	48 8b 00             	mov    (%rax),%rax
  800f02:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f06:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f0a:	48 89 0a             	mov    %rcx,(%rdx)
  800f0d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f10:	88 10                	mov    %dl,(%rax)
}
  800f12:	c9                   	leaveq 
  800f13:	c3                   	retq   

0000000000800f14 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f14:	55                   	push   %rbp
  800f15:	48 89 e5             	mov    %rsp,%rbp
  800f18:	48 83 ec 50          	sub    $0x50,%rsp
  800f1c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f20:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f23:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f27:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f2b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f2f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f33:	48 8b 0a             	mov    (%rdx),%rcx
  800f36:	48 89 08             	mov    %rcx,(%rax)
  800f39:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f3d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f41:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f45:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f49:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f4d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f51:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f54:	48 98                	cltq   
  800f56:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f5a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f5e:	48 01 d0             	add    %rdx,%rax
  800f61:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f65:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f6c:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f71:	74 06                	je     800f79 <vsnprintf+0x65>
  800f73:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f77:	7f 07                	jg     800f80 <vsnprintf+0x6c>
		return -E_INVAL;
  800f79:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f7e:	eb 2f                	jmp    800faf <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f80:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f84:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f88:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f8c:	48 89 c6             	mov    %rax,%rsi
  800f8f:	48 bf c7 0e 80 00 00 	movabs $0x800ec7,%rdi
  800f96:	00 00 00 
  800f99:	48 b8 03 09 80 00 00 	movabs $0x800903,%rax
  800fa0:	00 00 00 
  800fa3:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800fa5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800fa9:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800fac:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800faf:	c9                   	leaveq 
  800fb0:	c3                   	retq   

0000000000800fb1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fb1:	55                   	push   %rbp
  800fb2:	48 89 e5             	mov    %rsp,%rbp
  800fb5:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800fbc:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800fc3:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800fc9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fd0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fd7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fde:	84 c0                	test   %al,%al
  800fe0:	74 20                	je     801002 <snprintf+0x51>
  800fe2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fe6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fea:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fee:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ff2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ff6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ffa:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ffe:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801002:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801009:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801010:	00 00 00 
  801013:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80101a:	00 00 00 
  80101d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801021:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801028:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80102f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801036:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80103d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801044:	48 8b 0a             	mov    (%rdx),%rcx
  801047:	48 89 08             	mov    %rcx,(%rax)
  80104a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80104e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801052:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801056:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80105a:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801061:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801068:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80106e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801075:	48 89 c7             	mov    %rax,%rdi
  801078:	48 b8 14 0f 80 00 00 	movabs $0x800f14,%rax
  80107f:	00 00 00 
  801082:	ff d0                	callq  *%rax
  801084:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80108a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801090:	c9                   	leaveq 
  801091:	c3                   	retq   

0000000000801092 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801092:	55                   	push   %rbp
  801093:	48 89 e5             	mov    %rsp,%rbp
  801096:	48 83 ec 18          	sub    $0x18,%rsp
  80109a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80109e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010a5:	eb 09                	jmp    8010b0 <strlen+0x1e>
		n++;
  8010a7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  8010ab:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b4:	0f b6 00             	movzbl (%rax),%eax
  8010b7:	84 c0                	test   %al,%al
  8010b9:	75 ec                	jne    8010a7 <strlen+0x15>
	return n;
  8010bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010be:	c9                   	leaveq 
  8010bf:	c3                   	retq   

00000000008010c0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010c0:	55                   	push   %rbp
  8010c1:	48 89 e5             	mov    %rsp,%rbp
  8010c4:	48 83 ec 20          	sub    $0x20,%rsp
  8010c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010d7:	eb 0e                	jmp    8010e7 <strnlen+0x27>
		n++;
  8010d9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010dd:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010e2:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8010e7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010ec:	74 0b                	je     8010f9 <strnlen+0x39>
  8010ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f2:	0f b6 00             	movzbl (%rax),%eax
  8010f5:	84 c0                	test   %al,%al
  8010f7:	75 e0                	jne    8010d9 <strnlen+0x19>
	return n;
  8010f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010fc:	c9                   	leaveq 
  8010fd:	c3                   	retq   

00000000008010fe <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010fe:	55                   	push   %rbp
  8010ff:	48 89 e5             	mov    %rsp,%rbp
  801102:	48 83 ec 20          	sub    $0x20,%rsp
  801106:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80110a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80110e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801112:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801116:	90                   	nop
  801117:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80111f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801123:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801127:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80112b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80112f:	0f b6 12             	movzbl (%rdx),%edx
  801132:	88 10                	mov    %dl,(%rax)
  801134:	0f b6 00             	movzbl (%rax),%eax
  801137:	84 c0                	test   %al,%al
  801139:	75 dc                	jne    801117 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80113b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80113f:	c9                   	leaveq 
  801140:	c3                   	retq   

0000000000801141 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801141:	55                   	push   %rbp
  801142:	48 89 e5             	mov    %rsp,%rbp
  801145:	48 83 ec 20          	sub    $0x20,%rsp
  801149:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80114d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801151:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801155:	48 89 c7             	mov    %rax,%rdi
  801158:	48 b8 92 10 80 00 00 	movabs $0x801092,%rax
  80115f:	00 00 00 
  801162:	ff d0                	callq  *%rax
  801164:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801167:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80116a:	48 63 d0             	movslq %eax,%rdx
  80116d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801171:	48 01 c2             	add    %rax,%rdx
  801174:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801178:	48 89 c6             	mov    %rax,%rsi
  80117b:	48 89 d7             	mov    %rdx,%rdi
  80117e:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  801185:	00 00 00 
  801188:	ff d0                	callq  *%rax
	return dst;
  80118a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80118e:	c9                   	leaveq 
  80118f:	c3                   	retq   

0000000000801190 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801190:	55                   	push   %rbp
  801191:	48 89 e5             	mov    %rsp,%rbp
  801194:	48 83 ec 28          	sub    $0x28,%rsp
  801198:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80119c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8011a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8011ac:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8011b3:	00 
  8011b4:	eb 2a                	jmp    8011e0 <strncpy+0x50>
		*dst++ = *src;
  8011b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ba:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011be:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011c2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011c6:	0f b6 12             	movzbl (%rdx),%edx
  8011c9:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011cf:	0f b6 00             	movzbl (%rax),%eax
  8011d2:	84 c0                	test   %al,%al
  8011d4:	74 05                	je     8011db <strncpy+0x4b>
			src++;
  8011d6:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  8011db:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8011e8:	72 cc                	jb     8011b6 <strncpy+0x26>
	}
	return ret;
  8011ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8011ee:	c9                   	leaveq 
  8011ef:	c3                   	retq   

00000000008011f0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011f0:	55                   	push   %rbp
  8011f1:	48 89 e5             	mov    %rsp,%rbp
  8011f4:	48 83 ec 28          	sub    $0x28,%rsp
  8011f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801200:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801204:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801208:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80120c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801211:	74 3d                	je     801250 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801213:	eb 1d                	jmp    801232 <strlcpy+0x42>
			*dst++ = *src++;
  801215:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801219:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80121d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801221:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801225:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801229:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80122d:	0f b6 12             	movzbl (%rdx),%edx
  801230:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  801232:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801237:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80123c:	74 0b                	je     801249 <strlcpy+0x59>
  80123e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801242:	0f b6 00             	movzbl (%rax),%eax
  801245:	84 c0                	test   %al,%al
  801247:	75 cc                	jne    801215 <strlcpy+0x25>
		*dst = '\0';
  801249:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801250:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801254:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801258:	48 29 c2             	sub    %rax,%rdx
  80125b:	48 89 d0             	mov    %rdx,%rax
}
  80125e:	c9                   	leaveq 
  80125f:	c3                   	retq   

0000000000801260 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801260:	55                   	push   %rbp
  801261:	48 89 e5             	mov    %rsp,%rbp
  801264:	48 83 ec 10          	sub    $0x10,%rsp
  801268:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80126c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801270:	eb 0a                	jmp    80127c <strcmp+0x1c>
		p++, q++;
  801272:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801277:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  80127c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801280:	0f b6 00             	movzbl (%rax),%eax
  801283:	84 c0                	test   %al,%al
  801285:	74 12                	je     801299 <strcmp+0x39>
  801287:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128b:	0f b6 10             	movzbl (%rax),%edx
  80128e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801292:	0f b6 00             	movzbl (%rax),%eax
  801295:	38 c2                	cmp    %al,%dl
  801297:	74 d9                	je     801272 <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801299:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129d:	0f b6 00             	movzbl (%rax),%eax
  8012a0:	0f b6 d0             	movzbl %al,%edx
  8012a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012a7:	0f b6 00             	movzbl (%rax),%eax
  8012aa:	0f b6 c0             	movzbl %al,%eax
  8012ad:	29 c2                	sub    %eax,%edx
  8012af:	89 d0                	mov    %edx,%eax
}
  8012b1:	c9                   	leaveq 
  8012b2:	c3                   	retq   

00000000008012b3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8012b3:	55                   	push   %rbp
  8012b4:	48 89 e5             	mov    %rsp,%rbp
  8012b7:	48 83 ec 18          	sub    $0x18,%rsp
  8012bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012c3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8012c7:	eb 0f                	jmp    8012d8 <strncmp+0x25>
		n--, p++, q++;
  8012c9:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8012ce:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012d3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  8012d8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012dd:	74 1d                	je     8012fc <strncmp+0x49>
  8012df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e3:	0f b6 00             	movzbl (%rax),%eax
  8012e6:	84 c0                	test   %al,%al
  8012e8:	74 12                	je     8012fc <strncmp+0x49>
  8012ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ee:	0f b6 10             	movzbl (%rax),%edx
  8012f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f5:	0f b6 00             	movzbl (%rax),%eax
  8012f8:	38 c2                	cmp    %al,%dl
  8012fa:	74 cd                	je     8012c9 <strncmp+0x16>
	if (n == 0)
  8012fc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801301:	75 07                	jne    80130a <strncmp+0x57>
		return 0;
  801303:	b8 00 00 00 00       	mov    $0x0,%eax
  801308:	eb 18                	jmp    801322 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80130a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130e:	0f b6 00             	movzbl (%rax),%eax
  801311:	0f b6 d0             	movzbl %al,%edx
  801314:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801318:	0f b6 00             	movzbl (%rax),%eax
  80131b:	0f b6 c0             	movzbl %al,%eax
  80131e:	29 c2                	sub    %eax,%edx
  801320:	89 d0                	mov    %edx,%eax
}
  801322:	c9                   	leaveq 
  801323:	c3                   	retq   

0000000000801324 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801324:	55                   	push   %rbp
  801325:	48 89 e5             	mov    %rsp,%rbp
  801328:	48 83 ec 10          	sub    $0x10,%rsp
  80132c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801330:	89 f0                	mov    %esi,%eax
  801332:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801335:	eb 17                	jmp    80134e <strchr+0x2a>
		if (*s == c)
  801337:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133b:	0f b6 00             	movzbl (%rax),%eax
  80133e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801341:	75 06                	jne    801349 <strchr+0x25>
			return (char *) s;
  801343:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801347:	eb 15                	jmp    80135e <strchr+0x3a>
	for (; *s; s++)
  801349:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80134e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801352:	0f b6 00             	movzbl (%rax),%eax
  801355:	84 c0                	test   %al,%al
  801357:	75 de                	jne    801337 <strchr+0x13>
	return 0;
  801359:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80135e:	c9                   	leaveq 
  80135f:	c3                   	retq   

0000000000801360 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801360:	55                   	push   %rbp
  801361:	48 89 e5             	mov    %rsp,%rbp
  801364:	48 83 ec 10          	sub    $0x10,%rsp
  801368:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80136c:	89 f0                	mov    %esi,%eax
  80136e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801371:	eb 13                	jmp    801386 <strfind+0x26>
		if (*s == c)
  801373:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801377:	0f b6 00             	movzbl (%rax),%eax
  80137a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80137d:	75 02                	jne    801381 <strfind+0x21>
			break;
  80137f:	eb 10                	jmp    801391 <strfind+0x31>
	for (; *s; s++)
  801381:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801386:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138a:	0f b6 00             	movzbl (%rax),%eax
  80138d:	84 c0                	test   %al,%al
  80138f:	75 e2                	jne    801373 <strfind+0x13>
	return (char *) s;
  801391:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801395:	c9                   	leaveq 
  801396:	c3                   	retq   

0000000000801397 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801397:	55                   	push   %rbp
  801398:	48 89 e5             	mov    %rsp,%rbp
  80139b:	48 83 ec 18          	sub    $0x18,%rsp
  80139f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013a3:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8013a6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8013aa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013af:	75 06                	jne    8013b7 <memset+0x20>
		return v;
  8013b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b5:	eb 69                	jmp    801420 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8013b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bb:	83 e0 03             	and    $0x3,%eax
  8013be:	48 85 c0             	test   %rax,%rax
  8013c1:	75 48                	jne    80140b <memset+0x74>
  8013c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c7:	83 e0 03             	and    $0x3,%eax
  8013ca:	48 85 c0             	test   %rax,%rax
  8013cd:	75 3c                	jne    80140b <memset+0x74>
		c &= 0xFF;
  8013cf:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013d9:	c1 e0 18             	shl    $0x18,%eax
  8013dc:	89 c2                	mov    %eax,%edx
  8013de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013e1:	c1 e0 10             	shl    $0x10,%eax
  8013e4:	09 c2                	or     %eax,%edx
  8013e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013e9:	c1 e0 08             	shl    $0x8,%eax
  8013ec:	09 d0                	or     %edx,%eax
  8013ee:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8013f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f5:	48 c1 e8 02          	shr    $0x2,%rax
  8013f9:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  8013fc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801400:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801403:	48 89 d7             	mov    %rdx,%rdi
  801406:	fc                   	cld    
  801407:	f3 ab                	rep stos %eax,%es:(%rdi)
  801409:	eb 11                	jmp    80141c <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80140b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80140f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801412:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801416:	48 89 d7             	mov    %rdx,%rdi
  801419:	fc                   	cld    
  80141a:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80141c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801420:	c9                   	leaveq 
  801421:	c3                   	retq   

0000000000801422 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801422:	55                   	push   %rbp
  801423:	48 89 e5             	mov    %rsp,%rbp
  801426:	48 83 ec 28          	sub    $0x28,%rsp
  80142a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80142e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801432:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801436:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80143a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80143e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801442:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801446:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80144e:	0f 83 88 00 00 00    	jae    8014dc <memmove+0xba>
  801454:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801458:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145c:	48 01 d0             	add    %rdx,%rax
  80145f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801463:	76 77                	jbe    8014dc <memmove+0xba>
		s += n;
  801465:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801469:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80146d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801471:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801475:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801479:	83 e0 03             	and    $0x3,%eax
  80147c:	48 85 c0             	test   %rax,%rax
  80147f:	75 3b                	jne    8014bc <memmove+0x9a>
  801481:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801485:	83 e0 03             	and    $0x3,%eax
  801488:	48 85 c0             	test   %rax,%rax
  80148b:	75 2f                	jne    8014bc <memmove+0x9a>
  80148d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801491:	83 e0 03             	and    $0x3,%eax
  801494:	48 85 c0             	test   %rax,%rax
  801497:	75 23                	jne    8014bc <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801499:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149d:	48 83 e8 04          	sub    $0x4,%rax
  8014a1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014a5:	48 83 ea 04          	sub    $0x4,%rdx
  8014a9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014ad:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  8014b1:	48 89 c7             	mov    %rax,%rdi
  8014b4:	48 89 d6             	mov    %rdx,%rsi
  8014b7:	fd                   	std    
  8014b8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014ba:	eb 1d                	jmp    8014d9 <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c8:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  8014cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d0:	48 89 d7             	mov    %rdx,%rdi
  8014d3:	48 89 c1             	mov    %rax,%rcx
  8014d6:	fd                   	std    
  8014d7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014d9:	fc                   	cld    
  8014da:	eb 57                	jmp    801533 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e0:	83 e0 03             	and    $0x3,%eax
  8014e3:	48 85 c0             	test   %rax,%rax
  8014e6:	75 36                	jne    80151e <memmove+0xfc>
  8014e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ec:	83 e0 03             	and    $0x3,%eax
  8014ef:	48 85 c0             	test   %rax,%rax
  8014f2:	75 2a                	jne    80151e <memmove+0xfc>
  8014f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f8:	83 e0 03             	and    $0x3,%eax
  8014fb:	48 85 c0             	test   %rax,%rax
  8014fe:	75 1e                	jne    80151e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801500:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801504:	48 c1 e8 02          	shr    $0x2,%rax
  801508:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  80150b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80150f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801513:	48 89 c7             	mov    %rax,%rdi
  801516:	48 89 d6             	mov    %rdx,%rsi
  801519:	fc                   	cld    
  80151a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80151c:	eb 15                	jmp    801533 <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  80151e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801522:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801526:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80152a:	48 89 c7             	mov    %rax,%rdi
  80152d:	48 89 d6             	mov    %rdx,%rsi
  801530:	fc                   	cld    
  801531:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801533:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801537:	c9                   	leaveq 
  801538:	c3                   	retq   

0000000000801539 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801539:	55                   	push   %rbp
  80153a:	48 89 e5             	mov    %rsp,%rbp
  80153d:	48 83 ec 18          	sub    $0x18,%rsp
  801541:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801545:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801549:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80154d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801551:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801555:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801559:	48 89 ce             	mov    %rcx,%rsi
  80155c:	48 89 c7             	mov    %rax,%rdi
  80155f:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  801566:	00 00 00 
  801569:	ff d0                	callq  *%rax
}
  80156b:	c9                   	leaveq 
  80156c:	c3                   	retq   

000000000080156d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80156d:	55                   	push   %rbp
  80156e:	48 89 e5             	mov    %rsp,%rbp
  801571:	48 83 ec 28          	sub    $0x28,%rsp
  801575:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801579:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80157d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801585:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801589:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80158d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801591:	eb 36                	jmp    8015c9 <memcmp+0x5c>
		if (*s1 != *s2)
  801593:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801597:	0f b6 10             	movzbl (%rax),%edx
  80159a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159e:	0f b6 00             	movzbl (%rax),%eax
  8015a1:	38 c2                	cmp    %al,%dl
  8015a3:	74 1a                	je     8015bf <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8015a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a9:	0f b6 00             	movzbl (%rax),%eax
  8015ac:	0f b6 d0             	movzbl %al,%edx
  8015af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b3:	0f b6 00             	movzbl (%rax),%eax
  8015b6:	0f b6 c0             	movzbl %al,%eax
  8015b9:	29 c2                	sub    %eax,%edx
  8015bb:	89 d0                	mov    %edx,%eax
  8015bd:	eb 20                	jmp    8015df <memcmp+0x72>
		s1++, s2++;
  8015bf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015c4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  8015c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015d1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015d5:	48 85 c0             	test   %rax,%rax
  8015d8:	75 b9                	jne    801593 <memcmp+0x26>
	}

	return 0;
  8015da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015df:	c9                   	leaveq 
  8015e0:	c3                   	retq   

00000000008015e1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015e1:	55                   	push   %rbp
  8015e2:	48 89 e5             	mov    %rsp,%rbp
  8015e5:	48 83 ec 28          	sub    $0x28,%rsp
  8015e9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015ed:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fc:	48 01 d0             	add    %rdx,%rax
  8015ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801603:	eb 15                	jmp    80161a <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801605:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801609:	0f b6 00             	movzbl (%rax),%eax
  80160c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80160f:	38 d0                	cmp    %dl,%al
  801611:	75 02                	jne    801615 <memfind+0x34>
			break;
  801613:	eb 0f                	jmp    801624 <memfind+0x43>
	for (; s < ends; s++)
  801615:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80161a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80161e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801622:	72 e1                	jb     801605 <memfind+0x24>
	return (void *) s;
  801624:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801628:	c9                   	leaveq 
  801629:	c3                   	retq   

000000000080162a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80162a:	55                   	push   %rbp
  80162b:	48 89 e5             	mov    %rsp,%rbp
  80162e:	48 83 ec 38          	sub    $0x38,%rsp
  801632:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801636:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80163a:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80163d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801644:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80164b:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80164c:	eb 05                	jmp    801653 <strtol+0x29>
		s++;
  80164e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  801653:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801657:	0f b6 00             	movzbl (%rax),%eax
  80165a:	3c 20                	cmp    $0x20,%al
  80165c:	74 f0                	je     80164e <strtol+0x24>
  80165e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801662:	0f b6 00             	movzbl (%rax),%eax
  801665:	3c 09                	cmp    $0x9,%al
  801667:	74 e5                	je     80164e <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  801669:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166d:	0f b6 00             	movzbl (%rax),%eax
  801670:	3c 2b                	cmp    $0x2b,%al
  801672:	75 07                	jne    80167b <strtol+0x51>
		s++;
  801674:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801679:	eb 17                	jmp    801692 <strtol+0x68>
	else if (*s == '-')
  80167b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167f:	0f b6 00             	movzbl (%rax),%eax
  801682:	3c 2d                	cmp    $0x2d,%al
  801684:	75 0c                	jne    801692 <strtol+0x68>
		s++, neg = 1;
  801686:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80168b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801692:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801696:	74 06                	je     80169e <strtol+0x74>
  801698:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80169c:	75 28                	jne    8016c6 <strtol+0x9c>
  80169e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a2:	0f b6 00             	movzbl (%rax),%eax
  8016a5:	3c 30                	cmp    $0x30,%al
  8016a7:	75 1d                	jne    8016c6 <strtol+0x9c>
  8016a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ad:	48 83 c0 01          	add    $0x1,%rax
  8016b1:	0f b6 00             	movzbl (%rax),%eax
  8016b4:	3c 78                	cmp    $0x78,%al
  8016b6:	75 0e                	jne    8016c6 <strtol+0x9c>
		s += 2, base = 16;
  8016b8:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8016bd:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8016c4:	eb 2c                	jmp    8016f2 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8016c6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016ca:	75 19                	jne    8016e5 <strtol+0xbb>
  8016cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d0:	0f b6 00             	movzbl (%rax),%eax
  8016d3:	3c 30                	cmp    $0x30,%al
  8016d5:	75 0e                	jne    8016e5 <strtol+0xbb>
		s++, base = 8;
  8016d7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016dc:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8016e3:	eb 0d                	jmp    8016f2 <strtol+0xc8>
	else if (base == 0)
  8016e5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016e9:	75 07                	jne    8016f2 <strtol+0xc8>
		base = 10;
  8016eb:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f6:	0f b6 00             	movzbl (%rax),%eax
  8016f9:	3c 2f                	cmp    $0x2f,%al
  8016fb:	7e 1d                	jle    80171a <strtol+0xf0>
  8016fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801701:	0f b6 00             	movzbl (%rax),%eax
  801704:	3c 39                	cmp    $0x39,%al
  801706:	7f 12                	jg     80171a <strtol+0xf0>
			dig = *s - '0';
  801708:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170c:	0f b6 00             	movzbl (%rax),%eax
  80170f:	0f be c0             	movsbl %al,%eax
  801712:	83 e8 30             	sub    $0x30,%eax
  801715:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801718:	eb 4e                	jmp    801768 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80171a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171e:	0f b6 00             	movzbl (%rax),%eax
  801721:	3c 60                	cmp    $0x60,%al
  801723:	7e 1d                	jle    801742 <strtol+0x118>
  801725:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801729:	0f b6 00             	movzbl (%rax),%eax
  80172c:	3c 7a                	cmp    $0x7a,%al
  80172e:	7f 12                	jg     801742 <strtol+0x118>
			dig = *s - 'a' + 10;
  801730:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801734:	0f b6 00             	movzbl (%rax),%eax
  801737:	0f be c0             	movsbl %al,%eax
  80173a:	83 e8 57             	sub    $0x57,%eax
  80173d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801740:	eb 26                	jmp    801768 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801742:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801746:	0f b6 00             	movzbl (%rax),%eax
  801749:	3c 40                	cmp    $0x40,%al
  80174b:	7e 48                	jle    801795 <strtol+0x16b>
  80174d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801751:	0f b6 00             	movzbl (%rax),%eax
  801754:	3c 5a                	cmp    $0x5a,%al
  801756:	7f 3d                	jg     801795 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801758:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175c:	0f b6 00             	movzbl (%rax),%eax
  80175f:	0f be c0             	movsbl %al,%eax
  801762:	83 e8 37             	sub    $0x37,%eax
  801765:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801768:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80176b:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80176e:	7c 02                	jl     801772 <strtol+0x148>
			break;
  801770:	eb 23                	jmp    801795 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801772:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801777:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80177a:	48 98                	cltq   
  80177c:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801781:	48 89 c2             	mov    %rax,%rdx
  801784:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801787:	48 98                	cltq   
  801789:	48 01 d0             	add    %rdx,%rax
  80178c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801790:	e9 5d ff ff ff       	jmpq   8016f2 <strtol+0xc8>

	if (endptr)
  801795:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80179a:	74 0b                	je     8017a7 <strtol+0x17d>
		*endptr = (char *) s;
  80179c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017a0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8017a4:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8017a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017ab:	74 09                	je     8017b6 <strtol+0x18c>
  8017ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b1:	48 f7 d8             	neg    %rax
  8017b4:	eb 04                	jmp    8017ba <strtol+0x190>
  8017b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017ba:	c9                   	leaveq 
  8017bb:	c3                   	retq   

00000000008017bc <strstr>:

char * strstr(const char *in, const char *str)
{
  8017bc:	55                   	push   %rbp
  8017bd:	48 89 e5             	mov    %rsp,%rbp
  8017c0:	48 83 ec 30          	sub    $0x30,%rsp
  8017c4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017c8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8017cc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017d0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017d4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017d8:	0f b6 00             	movzbl (%rax),%eax
  8017db:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8017de:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8017e2:	75 06                	jne    8017ea <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8017e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e8:	eb 6b                	jmp    801855 <strstr+0x99>

	len = strlen(str);
  8017ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017ee:	48 89 c7             	mov    %rax,%rdi
  8017f1:	48 b8 92 10 80 00 00 	movabs $0x801092,%rax
  8017f8:	00 00 00 
  8017fb:	ff d0                	callq  *%rax
  8017fd:	48 98                	cltq   
  8017ff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801803:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801807:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80180b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80180f:	0f b6 00             	movzbl (%rax),%eax
  801812:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801815:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801819:	75 07                	jne    801822 <strstr+0x66>
				return (char *) 0;
  80181b:	b8 00 00 00 00       	mov    $0x0,%eax
  801820:	eb 33                	jmp    801855 <strstr+0x99>
		} while (sc != c);
  801822:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801826:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801829:	75 d8                	jne    801803 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80182b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80182f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801833:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801837:	48 89 ce             	mov    %rcx,%rsi
  80183a:	48 89 c7             	mov    %rax,%rdi
  80183d:	48 b8 b3 12 80 00 00 	movabs $0x8012b3,%rax
  801844:	00 00 00 
  801847:	ff d0                	callq  *%rax
  801849:	85 c0                	test   %eax,%eax
  80184b:	75 b6                	jne    801803 <strstr+0x47>

	return (char *) (in - 1);
  80184d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801851:	48 83 e8 01          	sub    $0x1,%rax
}
  801855:	c9                   	leaveq 
  801856:	c3                   	retq   

0000000000801857 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801857:	55                   	push   %rbp
  801858:	48 89 e5             	mov    %rsp,%rbp
  80185b:	53                   	push   %rbx
  80185c:	48 83 ec 48          	sub    $0x48,%rsp
  801860:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801863:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801866:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80186a:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80186e:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801872:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801876:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801879:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80187d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801881:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801885:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801889:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80188d:	4c 89 c3             	mov    %r8,%rbx
  801890:	cd 30                	int    $0x30
  801892:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801896:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80189a:	74 3e                	je     8018da <syscall+0x83>
  80189c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018a1:	7e 37                	jle    8018da <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018a7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018aa:	49 89 d0             	mov    %rdx,%r8
  8018ad:	89 c1                	mov    %eax,%ecx
  8018af:	48 ba c8 50 80 00 00 	movabs $0x8050c8,%rdx
  8018b6:	00 00 00 
  8018b9:	be 23 00 00 00       	mov    $0x23,%esi
  8018be:	48 bf e5 50 80 00 00 	movabs $0x8050e5,%rdi
  8018c5:	00 00 00 
  8018c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8018cd:	49 b9 2b 03 80 00 00 	movabs $0x80032b,%r9
  8018d4:	00 00 00 
  8018d7:	41 ff d1             	callq  *%r9

	return ret;
  8018da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018de:	48 83 c4 48          	add    $0x48,%rsp
  8018e2:	5b                   	pop    %rbx
  8018e3:	5d                   	pop    %rbp
  8018e4:	c3                   	retq   

00000000008018e5 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018e5:	55                   	push   %rbp
  8018e6:	48 89 e5             	mov    %rsp,%rbp
  8018e9:	48 83 ec 10          	sub    $0x10,%rsp
  8018ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018f1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8018f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018fd:	48 83 ec 08          	sub    $0x8,%rsp
  801901:	6a 00                	pushq  $0x0
  801903:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801909:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80190f:	48 89 d1             	mov    %rdx,%rcx
  801912:	48 89 c2             	mov    %rax,%rdx
  801915:	be 00 00 00 00       	mov    $0x0,%esi
  80191a:	bf 00 00 00 00       	mov    $0x0,%edi
  80191f:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801926:	00 00 00 
  801929:	ff d0                	callq  *%rax
  80192b:	48 83 c4 10          	add    $0x10,%rsp
}
  80192f:	c9                   	leaveq 
  801930:	c3                   	retq   

0000000000801931 <sys_cgetc>:

int
sys_cgetc(void)
{
  801931:	55                   	push   %rbp
  801932:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801935:	48 83 ec 08          	sub    $0x8,%rsp
  801939:	6a 00                	pushq  $0x0
  80193b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801941:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801947:	b9 00 00 00 00       	mov    $0x0,%ecx
  80194c:	ba 00 00 00 00       	mov    $0x0,%edx
  801951:	be 00 00 00 00       	mov    $0x0,%esi
  801956:	bf 01 00 00 00       	mov    $0x1,%edi
  80195b:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801962:	00 00 00 
  801965:	ff d0                	callq  *%rax
  801967:	48 83 c4 10          	add    $0x10,%rsp
}
  80196b:	c9                   	leaveq 
  80196c:	c3                   	retq   

000000000080196d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80196d:	55                   	push   %rbp
  80196e:	48 89 e5             	mov    %rsp,%rbp
  801971:	48 83 ec 10          	sub    $0x10,%rsp
  801975:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801978:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80197b:	48 98                	cltq   
  80197d:	48 83 ec 08          	sub    $0x8,%rsp
  801981:	6a 00                	pushq  $0x0
  801983:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801989:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80198f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801994:	48 89 c2             	mov    %rax,%rdx
  801997:	be 01 00 00 00       	mov    $0x1,%esi
  80199c:	bf 03 00 00 00       	mov    $0x3,%edi
  8019a1:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  8019a8:	00 00 00 
  8019ab:	ff d0                	callq  *%rax
  8019ad:	48 83 c4 10          	add    $0x10,%rsp
}
  8019b1:	c9                   	leaveq 
  8019b2:	c3                   	retq   

00000000008019b3 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8019b3:	55                   	push   %rbp
  8019b4:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8019b7:	48 83 ec 08          	sub    $0x8,%rsp
  8019bb:	6a 00                	pushq  $0x0
  8019bd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019c9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d3:	be 00 00 00 00       	mov    $0x0,%esi
  8019d8:	bf 02 00 00 00       	mov    $0x2,%edi
  8019dd:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  8019e4:	00 00 00 
  8019e7:	ff d0                	callq  *%rax
  8019e9:	48 83 c4 10          	add    $0x10,%rsp
}
  8019ed:	c9                   	leaveq 
  8019ee:	c3                   	retq   

00000000008019ef <sys_yield>:

void
sys_yield(void)
{
  8019ef:	55                   	push   %rbp
  8019f0:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8019f3:	48 83 ec 08          	sub    $0x8,%rsp
  8019f7:	6a 00                	pushq  $0x0
  8019f9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a05:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a0a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a0f:	be 00 00 00 00       	mov    $0x0,%esi
  801a14:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a19:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801a20:	00 00 00 
  801a23:	ff d0                	callq  *%rax
  801a25:	48 83 c4 10          	add    $0x10,%rsp
}
  801a29:	c9                   	leaveq 
  801a2a:	c3                   	retq   

0000000000801a2b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a2b:	55                   	push   %rbp
  801a2c:	48 89 e5             	mov    %rsp,%rbp
  801a2f:	48 83 ec 10          	sub    $0x10,%rsp
  801a33:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a36:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a3a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a3d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a40:	48 63 c8             	movslq %eax,%rcx
  801a43:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a4a:	48 98                	cltq   
  801a4c:	48 83 ec 08          	sub    $0x8,%rsp
  801a50:	6a 00                	pushq  $0x0
  801a52:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a58:	49 89 c8             	mov    %rcx,%r8
  801a5b:	48 89 d1             	mov    %rdx,%rcx
  801a5e:	48 89 c2             	mov    %rax,%rdx
  801a61:	be 01 00 00 00       	mov    $0x1,%esi
  801a66:	bf 04 00 00 00       	mov    $0x4,%edi
  801a6b:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801a72:	00 00 00 
  801a75:	ff d0                	callq  *%rax
  801a77:	48 83 c4 10          	add    $0x10,%rsp
}
  801a7b:	c9                   	leaveq 
  801a7c:	c3                   	retq   

0000000000801a7d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a7d:	55                   	push   %rbp
  801a7e:	48 89 e5             	mov    %rsp,%rbp
  801a81:	48 83 ec 20          	sub    $0x20,%rsp
  801a85:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a88:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a8c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a8f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a93:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a97:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a9a:	48 63 c8             	movslq %eax,%rcx
  801a9d:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801aa1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aa4:	48 63 f0             	movslq %eax,%rsi
  801aa7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aae:	48 98                	cltq   
  801ab0:	48 83 ec 08          	sub    $0x8,%rsp
  801ab4:	51                   	push   %rcx
  801ab5:	49 89 f9             	mov    %rdi,%r9
  801ab8:	49 89 f0             	mov    %rsi,%r8
  801abb:	48 89 d1             	mov    %rdx,%rcx
  801abe:	48 89 c2             	mov    %rax,%rdx
  801ac1:	be 01 00 00 00       	mov    $0x1,%esi
  801ac6:	bf 05 00 00 00       	mov    $0x5,%edi
  801acb:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801ad2:	00 00 00 
  801ad5:	ff d0                	callq  *%rax
  801ad7:	48 83 c4 10          	add    $0x10,%rsp
}
  801adb:	c9                   	leaveq 
  801adc:	c3                   	retq   

0000000000801add <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801add:	55                   	push   %rbp
  801ade:	48 89 e5             	mov    %rsp,%rbp
  801ae1:	48 83 ec 10          	sub    $0x10,%rsp
  801ae5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ae8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801aec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801af0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801af3:	48 98                	cltq   
  801af5:	48 83 ec 08          	sub    $0x8,%rsp
  801af9:	6a 00                	pushq  $0x0
  801afb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b01:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b07:	48 89 d1             	mov    %rdx,%rcx
  801b0a:	48 89 c2             	mov    %rax,%rdx
  801b0d:	be 01 00 00 00       	mov    $0x1,%esi
  801b12:	bf 06 00 00 00       	mov    $0x6,%edi
  801b17:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801b1e:	00 00 00 
  801b21:	ff d0                	callq  *%rax
  801b23:	48 83 c4 10          	add    $0x10,%rsp
}
  801b27:	c9                   	leaveq 
  801b28:	c3                   	retq   

0000000000801b29 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b29:	55                   	push   %rbp
  801b2a:	48 89 e5             	mov    %rsp,%rbp
  801b2d:	48 83 ec 10          	sub    $0x10,%rsp
  801b31:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b34:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b37:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b3a:	48 63 d0             	movslq %eax,%rdx
  801b3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b40:	48 98                	cltq   
  801b42:	48 83 ec 08          	sub    $0x8,%rsp
  801b46:	6a 00                	pushq  $0x0
  801b48:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b4e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b54:	48 89 d1             	mov    %rdx,%rcx
  801b57:	48 89 c2             	mov    %rax,%rdx
  801b5a:	be 01 00 00 00       	mov    $0x1,%esi
  801b5f:	bf 08 00 00 00       	mov    $0x8,%edi
  801b64:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801b6b:	00 00 00 
  801b6e:	ff d0                	callq  *%rax
  801b70:	48 83 c4 10          	add    $0x10,%rsp
}
  801b74:	c9                   	leaveq 
  801b75:	c3                   	retq   

0000000000801b76 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b76:	55                   	push   %rbp
  801b77:	48 89 e5             	mov    %rsp,%rbp
  801b7a:	48 83 ec 10          	sub    $0x10,%rsp
  801b7e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b81:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b85:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b8c:	48 98                	cltq   
  801b8e:	48 83 ec 08          	sub    $0x8,%rsp
  801b92:	6a 00                	pushq  $0x0
  801b94:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b9a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ba0:	48 89 d1             	mov    %rdx,%rcx
  801ba3:	48 89 c2             	mov    %rax,%rdx
  801ba6:	be 01 00 00 00       	mov    $0x1,%esi
  801bab:	bf 09 00 00 00       	mov    $0x9,%edi
  801bb0:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801bb7:	00 00 00 
  801bba:	ff d0                	callq  *%rax
  801bbc:	48 83 c4 10          	add    $0x10,%rsp
}
  801bc0:	c9                   	leaveq 
  801bc1:	c3                   	retq   

0000000000801bc2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801bc2:	55                   	push   %rbp
  801bc3:	48 89 e5             	mov    %rsp,%rbp
  801bc6:	48 83 ec 10          	sub    $0x10,%rsp
  801bca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bcd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801bd1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bd8:	48 98                	cltq   
  801bda:	48 83 ec 08          	sub    $0x8,%rsp
  801bde:	6a 00                	pushq  $0x0
  801be0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801be6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bec:	48 89 d1             	mov    %rdx,%rcx
  801bef:	48 89 c2             	mov    %rax,%rdx
  801bf2:	be 01 00 00 00       	mov    $0x1,%esi
  801bf7:	bf 0a 00 00 00       	mov    $0xa,%edi
  801bfc:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801c03:	00 00 00 
  801c06:	ff d0                	callq  *%rax
  801c08:	48 83 c4 10          	add    $0x10,%rsp
}
  801c0c:	c9                   	leaveq 
  801c0d:	c3                   	retq   

0000000000801c0e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c0e:	55                   	push   %rbp
  801c0f:	48 89 e5             	mov    %rsp,%rbp
  801c12:	48 83 ec 20          	sub    $0x20,%rsp
  801c16:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c19:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c1d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c21:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c24:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c27:	48 63 f0             	movslq %eax,%rsi
  801c2a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c31:	48 98                	cltq   
  801c33:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c37:	48 83 ec 08          	sub    $0x8,%rsp
  801c3b:	6a 00                	pushq  $0x0
  801c3d:	49 89 f1             	mov    %rsi,%r9
  801c40:	49 89 c8             	mov    %rcx,%r8
  801c43:	48 89 d1             	mov    %rdx,%rcx
  801c46:	48 89 c2             	mov    %rax,%rdx
  801c49:	be 00 00 00 00       	mov    $0x0,%esi
  801c4e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c53:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801c5a:	00 00 00 
  801c5d:	ff d0                	callq  *%rax
  801c5f:	48 83 c4 10          	add    $0x10,%rsp
}
  801c63:	c9                   	leaveq 
  801c64:	c3                   	retq   

0000000000801c65 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c65:	55                   	push   %rbp
  801c66:	48 89 e5             	mov    %rsp,%rbp
  801c69:	48 83 ec 10          	sub    $0x10,%rsp
  801c6d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c75:	48 83 ec 08          	sub    $0x8,%rsp
  801c79:	6a 00                	pushq  $0x0
  801c7b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c81:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c87:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c8c:	48 89 c2             	mov    %rax,%rdx
  801c8f:	be 01 00 00 00       	mov    $0x1,%esi
  801c94:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c99:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801ca0:	00 00 00 
  801ca3:	ff d0                	callq  *%rax
  801ca5:	48 83 c4 10          	add    $0x10,%rsp
}
  801ca9:	c9                   	leaveq 
  801caa:	c3                   	retq   

0000000000801cab <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801cab:	55                   	push   %rbp
  801cac:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801caf:	48 83 ec 08          	sub    $0x8,%rsp
  801cb3:	6a 00                	pushq  $0x0
  801cb5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cbb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cc6:	ba 00 00 00 00       	mov    $0x0,%edx
  801ccb:	be 00 00 00 00       	mov    $0x0,%esi
  801cd0:	bf 0e 00 00 00       	mov    $0xe,%edi
  801cd5:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801cdc:	00 00 00 
  801cdf:	ff d0                	callq  *%rax
  801ce1:	48 83 c4 10          	add    $0x10,%rsp
}
  801ce5:	c9                   	leaveq 
  801ce6:	c3                   	retq   

0000000000801ce7 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801ce7:	55                   	push   %rbp
  801ce8:	48 89 e5             	mov    %rsp,%rbp
  801ceb:	48 83 ec 20          	sub    $0x20,%rsp
  801cef:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cf2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cf6:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801cf9:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801cfd:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801d01:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d04:	48 63 c8             	movslq %eax,%rcx
  801d07:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d0b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d0e:	48 63 f0             	movslq %eax,%rsi
  801d11:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d18:	48 98                	cltq   
  801d1a:	48 83 ec 08          	sub    $0x8,%rsp
  801d1e:	51                   	push   %rcx
  801d1f:	49 89 f9             	mov    %rdi,%r9
  801d22:	49 89 f0             	mov    %rsi,%r8
  801d25:	48 89 d1             	mov    %rdx,%rcx
  801d28:	48 89 c2             	mov    %rax,%rdx
  801d2b:	be 00 00 00 00       	mov    $0x0,%esi
  801d30:	bf 0f 00 00 00       	mov    $0xf,%edi
  801d35:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801d3c:	00 00 00 
  801d3f:	ff d0                	callq  *%rax
  801d41:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801d45:	c9                   	leaveq 
  801d46:	c3                   	retq   

0000000000801d47 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801d47:	55                   	push   %rbp
  801d48:	48 89 e5             	mov    %rsp,%rbp
  801d4b:	48 83 ec 10          	sub    $0x10,%rsp
  801d4f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d53:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801d57:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d5f:	48 83 ec 08          	sub    $0x8,%rsp
  801d63:	6a 00                	pushq  $0x0
  801d65:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d6b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d71:	48 89 d1             	mov    %rdx,%rcx
  801d74:	48 89 c2             	mov    %rax,%rdx
  801d77:	be 00 00 00 00       	mov    $0x0,%esi
  801d7c:	bf 10 00 00 00       	mov    $0x10,%edi
  801d81:	48 b8 57 18 80 00 00 	movabs $0x801857,%rax
  801d88:	00 00 00 
  801d8b:	ff d0                	callq  *%rax
  801d8d:	48 83 c4 10          	add    $0x10,%rsp
}
  801d91:	c9                   	leaveq 
  801d92:	c3                   	retq   

0000000000801d93 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801d93:	55                   	push   %rbp
  801d94:	48 89 e5             	mov    %rsp,%rbp
  801d97:	48 83 ec 20          	sub    $0x20,%rsp
  801d9b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801d9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801da3:	48 8b 00             	mov    (%rax),%rax
  801da6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801daa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dae:	48 8b 40 08          	mov    0x8(%rax),%rax
  801db2:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  801db5:	48 ba f3 50 80 00 00 	movabs $0x8050f3,%rdx
  801dbc:	00 00 00 
  801dbf:	be 26 00 00 00       	mov    $0x26,%esi
  801dc4:	48 bf 0b 51 80 00 00 	movabs $0x80510b,%rdi
  801dcb:	00 00 00 
  801dce:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd3:	48 b9 2b 03 80 00 00 	movabs $0x80032b,%rcx
  801dda:	00 00 00 
  801ddd:	ff d1                	callq  *%rcx

0000000000801ddf <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801ddf:	55                   	push   %rbp
  801de0:	48 89 e5             	mov    %rsp,%rbp
  801de3:	48 83 ec 10          	sub    $0x10,%rsp
  801de7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dea:	89 75 f8             	mov    %esi,-0x8(%rbp)
	int r;

	// LAB 4: Your code here.
	panic("duppage not implemented");
  801ded:	48 ba 16 51 80 00 00 	movabs $0x805116,%rdx
  801df4:	00 00 00 
  801df7:	be 3a 00 00 00       	mov    $0x3a,%esi
  801dfc:	48 bf 0b 51 80 00 00 	movabs $0x80510b,%rdi
  801e03:	00 00 00 
  801e06:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0b:	48 b9 2b 03 80 00 00 	movabs $0x80032b,%rcx
  801e12:	00 00 00 
  801e15:	ff d1                	callq  *%rcx

0000000000801e17 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801e17:	55                   	push   %rbp
  801e18:	48 89 e5             	mov    %rsp,%rbp
	// LAB 4: Your code here.
	panic("fork not implemented");
  801e1b:	48 ba 2e 51 80 00 00 	movabs $0x80512e,%rdx
  801e22:	00 00 00 
  801e25:	be 52 00 00 00       	mov    $0x52,%esi
  801e2a:	48 bf 0b 51 80 00 00 	movabs $0x80510b,%rdi
  801e31:	00 00 00 
  801e34:	b8 00 00 00 00       	mov    $0x0,%eax
  801e39:	48 b9 2b 03 80 00 00 	movabs $0x80032b,%rcx
  801e40:	00 00 00 
  801e43:	ff d1                	callq  *%rcx

0000000000801e45 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801e45:	55                   	push   %rbp
  801e46:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  801e49:	48 ba 43 51 80 00 00 	movabs $0x805143,%rdx
  801e50:	00 00 00 
  801e53:	be 59 00 00 00       	mov    $0x59,%esi
  801e58:	48 bf 0b 51 80 00 00 	movabs $0x80510b,%rdi
  801e5f:	00 00 00 
  801e62:	b8 00 00 00 00       	mov    $0x0,%eax
  801e67:	48 b9 2b 03 80 00 00 	movabs $0x80032b,%rcx
  801e6e:	00 00 00 
  801e71:	ff d1                	callq  *%rcx

0000000000801e73 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801e73:	55                   	push   %rbp
  801e74:	48 89 e5             	mov    %rsp,%rbp
  801e77:	48 83 ec 08          	sub    $0x8,%rsp
  801e7b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e7f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e83:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801e8a:	ff ff ff 
  801e8d:	48 01 d0             	add    %rdx,%rax
  801e90:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801e94:	c9                   	leaveq 
  801e95:	c3                   	retq   

0000000000801e96 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e96:	55                   	push   %rbp
  801e97:	48 89 e5             	mov    %rsp,%rbp
  801e9a:	48 83 ec 08          	sub    $0x8,%rsp
  801e9e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801ea2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ea6:	48 89 c7             	mov    %rax,%rdi
  801ea9:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  801eb0:	00 00 00 
  801eb3:	ff d0                	callq  *%rax
  801eb5:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801ebb:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ebf:	c9                   	leaveq 
  801ec0:	c3                   	retq   

0000000000801ec1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ec1:	55                   	push   %rbp
  801ec2:	48 89 e5             	mov    %rsp,%rbp
  801ec5:	48 83 ec 18          	sub    $0x18,%rsp
  801ec9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ecd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ed4:	eb 6b                	jmp    801f41 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801ed6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ed9:	48 98                	cltq   
  801edb:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ee1:	48 c1 e0 0c          	shl    $0xc,%rax
  801ee5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801ee9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eed:	48 c1 e8 15          	shr    $0x15,%rax
  801ef1:	48 89 c2             	mov    %rax,%rdx
  801ef4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801efb:	01 00 00 
  801efe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f02:	83 e0 01             	and    $0x1,%eax
  801f05:	48 85 c0             	test   %rax,%rax
  801f08:	74 21                	je     801f2b <fd_alloc+0x6a>
  801f0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f0e:	48 c1 e8 0c          	shr    $0xc,%rax
  801f12:	48 89 c2             	mov    %rax,%rdx
  801f15:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f1c:	01 00 00 
  801f1f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f23:	83 e0 01             	and    $0x1,%eax
  801f26:	48 85 c0             	test   %rax,%rax
  801f29:	75 12                	jne    801f3d <fd_alloc+0x7c>
			*fd_store = fd;
  801f2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f2f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f33:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f36:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3b:	eb 1a                	jmp    801f57 <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  801f3d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f41:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f45:	7e 8f                	jle    801ed6 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  801f47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f4b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801f52:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801f57:	c9                   	leaveq 
  801f58:	c3                   	retq   

0000000000801f59 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f59:	55                   	push   %rbp
  801f5a:	48 89 e5             	mov    %rsp,%rbp
  801f5d:	48 83 ec 20          	sub    $0x20,%rsp
  801f61:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f64:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f68:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f6c:	78 06                	js     801f74 <fd_lookup+0x1b>
  801f6e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801f72:	7e 07                	jle    801f7b <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f74:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f79:	eb 6c                	jmp    801fe7 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801f7b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f7e:	48 98                	cltq   
  801f80:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f86:	48 c1 e0 0c          	shl    $0xc,%rax
  801f8a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f92:	48 c1 e8 15          	shr    $0x15,%rax
  801f96:	48 89 c2             	mov    %rax,%rdx
  801f99:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fa0:	01 00 00 
  801fa3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fa7:	83 e0 01             	and    $0x1,%eax
  801faa:	48 85 c0             	test   %rax,%rax
  801fad:	74 21                	je     801fd0 <fd_lookup+0x77>
  801faf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fb3:	48 c1 e8 0c          	shr    $0xc,%rax
  801fb7:	48 89 c2             	mov    %rax,%rdx
  801fba:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fc1:	01 00 00 
  801fc4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fc8:	83 e0 01             	and    $0x1,%eax
  801fcb:	48 85 c0             	test   %rax,%rax
  801fce:	75 07                	jne    801fd7 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fd0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fd5:	eb 10                	jmp    801fe7 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801fd7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fdb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801fdf:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801fe2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fe7:	c9                   	leaveq 
  801fe8:	c3                   	retq   

0000000000801fe9 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801fe9:	55                   	push   %rbp
  801fea:	48 89 e5             	mov    %rsp,%rbp
  801fed:	48 83 ec 30          	sub    $0x30,%rsp
  801ff1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ff5:	89 f0                	mov    %esi,%eax
  801ff7:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ffa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ffe:	48 89 c7             	mov    %rax,%rdi
  802001:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  802008:	00 00 00 
  80200b:	ff d0                	callq  *%rax
  80200d:	89 c2                	mov    %eax,%edx
  80200f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802013:	48 89 c6             	mov    %rax,%rsi
  802016:	89 d7                	mov    %edx,%edi
  802018:	48 b8 59 1f 80 00 00 	movabs $0x801f59,%rax
  80201f:	00 00 00 
  802022:	ff d0                	callq  *%rax
  802024:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802027:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80202b:	78 0a                	js     802037 <fd_close+0x4e>
	    || fd != fd2)
  80202d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802031:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802035:	74 12                	je     802049 <fd_close+0x60>
		return (must_exist ? r : 0);
  802037:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80203b:	74 05                	je     802042 <fd_close+0x59>
  80203d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802040:	eb 70                	jmp    8020b2 <fd_close+0xc9>
  802042:	b8 00 00 00 00       	mov    $0x0,%eax
  802047:	eb 69                	jmp    8020b2 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802049:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80204d:	8b 00                	mov    (%rax),%eax
  80204f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802053:	48 89 d6             	mov    %rdx,%rsi
  802056:	89 c7                	mov    %eax,%edi
  802058:	48 b8 b4 20 80 00 00 	movabs $0x8020b4,%rax
  80205f:	00 00 00 
  802062:	ff d0                	callq  *%rax
  802064:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802067:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80206b:	78 2a                	js     802097 <fd_close+0xae>
		if (dev->dev_close)
  80206d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802071:	48 8b 40 20          	mov    0x20(%rax),%rax
  802075:	48 85 c0             	test   %rax,%rax
  802078:	74 16                	je     802090 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  80207a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80207e:	48 8b 40 20          	mov    0x20(%rax),%rax
  802082:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802086:	48 89 d7             	mov    %rdx,%rdi
  802089:	ff d0                	callq  *%rax
  80208b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80208e:	eb 07                	jmp    802097 <fd_close+0xae>
		else
			r = 0;
  802090:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802097:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80209b:	48 89 c6             	mov    %rax,%rsi
  80209e:	bf 00 00 00 00       	mov    $0x0,%edi
  8020a3:	48 b8 dd 1a 80 00 00 	movabs $0x801add,%rax
  8020aa:	00 00 00 
  8020ad:	ff d0                	callq  *%rax
	return r;
  8020af:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8020b2:	c9                   	leaveq 
  8020b3:	c3                   	retq   

00000000008020b4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8020b4:	55                   	push   %rbp
  8020b5:	48 89 e5             	mov    %rsp,%rbp
  8020b8:	48 83 ec 20          	sub    $0x20,%rsp
  8020bc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8020c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020ca:	eb 41                	jmp    80210d <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8020cc:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8020d3:	00 00 00 
  8020d6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020d9:	48 63 d2             	movslq %edx,%rdx
  8020dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020e0:	8b 00                	mov    (%rax),%eax
  8020e2:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8020e5:	75 22                	jne    802109 <dev_lookup+0x55>
			*dev = devtab[i];
  8020e7:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8020ee:	00 00 00 
  8020f1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020f4:	48 63 d2             	movslq %edx,%rdx
  8020f7:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8020fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020ff:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802102:	b8 00 00 00 00       	mov    $0x0,%eax
  802107:	eb 60                	jmp    802169 <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  802109:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80210d:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802114:	00 00 00 
  802117:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80211a:	48 63 d2             	movslq %edx,%rdx
  80211d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802121:	48 85 c0             	test   %rax,%rax
  802124:	75 a6                	jne    8020cc <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802126:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80212d:	00 00 00 
  802130:	48 8b 00             	mov    (%rax),%rax
  802133:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802139:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80213c:	89 c6                	mov    %eax,%esi
  80213e:	48 bf 60 51 80 00 00 	movabs $0x805160,%rdi
  802145:	00 00 00 
  802148:	b8 00 00 00 00       	mov    $0x0,%eax
  80214d:	48 b9 64 05 80 00 00 	movabs $0x800564,%rcx
  802154:	00 00 00 
  802157:	ff d1                	callq  *%rcx
	*dev = 0;
  802159:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80215d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802164:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802169:	c9                   	leaveq 
  80216a:	c3                   	retq   

000000000080216b <close>:

int
close(int fdnum)
{
  80216b:	55                   	push   %rbp
  80216c:	48 89 e5             	mov    %rsp,%rbp
  80216f:	48 83 ec 20          	sub    $0x20,%rsp
  802173:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802176:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80217a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80217d:	48 89 d6             	mov    %rdx,%rsi
  802180:	89 c7                	mov    %eax,%edi
  802182:	48 b8 59 1f 80 00 00 	movabs $0x801f59,%rax
  802189:	00 00 00 
  80218c:	ff d0                	callq  *%rax
  80218e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802191:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802195:	79 05                	jns    80219c <close+0x31>
		return r;
  802197:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80219a:	eb 18                	jmp    8021b4 <close+0x49>
	else
		return fd_close(fd, 1);
  80219c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021a0:	be 01 00 00 00       	mov    $0x1,%esi
  8021a5:	48 89 c7             	mov    %rax,%rdi
  8021a8:	48 b8 e9 1f 80 00 00 	movabs $0x801fe9,%rax
  8021af:	00 00 00 
  8021b2:	ff d0                	callq  *%rax
}
  8021b4:	c9                   	leaveq 
  8021b5:	c3                   	retq   

00000000008021b6 <close_all>:

void
close_all(void)
{
  8021b6:	55                   	push   %rbp
  8021b7:	48 89 e5             	mov    %rsp,%rbp
  8021ba:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8021be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021c5:	eb 15                	jmp    8021dc <close_all+0x26>
		close(i);
  8021c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ca:	89 c7                	mov    %eax,%edi
  8021cc:	48 b8 6b 21 80 00 00 	movabs $0x80216b,%rax
  8021d3:	00 00 00 
  8021d6:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  8021d8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021dc:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8021e0:	7e e5                	jle    8021c7 <close_all+0x11>
}
  8021e2:	c9                   	leaveq 
  8021e3:	c3                   	retq   

00000000008021e4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8021e4:	55                   	push   %rbp
  8021e5:	48 89 e5             	mov    %rsp,%rbp
  8021e8:	48 83 ec 40          	sub    $0x40,%rsp
  8021ec:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8021ef:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8021f2:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8021f6:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8021f9:	48 89 d6             	mov    %rdx,%rsi
  8021fc:	89 c7                	mov    %eax,%edi
  8021fe:	48 b8 59 1f 80 00 00 	movabs $0x801f59,%rax
  802205:	00 00 00 
  802208:	ff d0                	callq  *%rax
  80220a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80220d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802211:	79 08                	jns    80221b <dup+0x37>
		return r;
  802213:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802216:	e9 70 01 00 00       	jmpq   80238b <dup+0x1a7>
	close(newfdnum);
  80221b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80221e:	89 c7                	mov    %eax,%edi
  802220:	48 b8 6b 21 80 00 00 	movabs $0x80216b,%rax
  802227:	00 00 00 
  80222a:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80222c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80222f:	48 98                	cltq   
  802231:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802237:	48 c1 e0 0c          	shl    $0xc,%rax
  80223b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80223f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802243:	48 89 c7             	mov    %rax,%rdi
  802246:	48 b8 96 1e 80 00 00 	movabs $0x801e96,%rax
  80224d:	00 00 00 
  802250:	ff d0                	callq  *%rax
  802252:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802256:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80225a:	48 89 c7             	mov    %rax,%rdi
  80225d:	48 b8 96 1e 80 00 00 	movabs $0x801e96,%rax
  802264:	00 00 00 
  802267:	ff d0                	callq  *%rax
  802269:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80226d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802271:	48 c1 e8 15          	shr    $0x15,%rax
  802275:	48 89 c2             	mov    %rax,%rdx
  802278:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80227f:	01 00 00 
  802282:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802286:	83 e0 01             	and    $0x1,%eax
  802289:	48 85 c0             	test   %rax,%rax
  80228c:	74 73                	je     802301 <dup+0x11d>
  80228e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802292:	48 c1 e8 0c          	shr    $0xc,%rax
  802296:	48 89 c2             	mov    %rax,%rdx
  802299:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022a0:	01 00 00 
  8022a3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022a7:	83 e0 01             	and    $0x1,%eax
  8022aa:	48 85 c0             	test   %rax,%rax
  8022ad:	74 52                	je     802301 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8022af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b3:	48 c1 e8 0c          	shr    $0xc,%rax
  8022b7:	48 89 c2             	mov    %rax,%rdx
  8022ba:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022c1:	01 00 00 
  8022c4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022c8:	25 07 0e 00 00       	and    $0xe07,%eax
  8022cd:	89 c1                	mov    %eax,%ecx
  8022cf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8022d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d7:	41 89 c8             	mov    %ecx,%r8d
  8022da:	48 89 d1             	mov    %rdx,%rcx
  8022dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8022e2:	48 89 c6             	mov    %rax,%rsi
  8022e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8022ea:	48 b8 7d 1a 80 00 00 	movabs $0x801a7d,%rax
  8022f1:	00 00 00 
  8022f4:	ff d0                	callq  *%rax
  8022f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022fd:	79 02                	jns    802301 <dup+0x11d>
			goto err;
  8022ff:	eb 57                	jmp    802358 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802301:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802305:	48 c1 e8 0c          	shr    $0xc,%rax
  802309:	48 89 c2             	mov    %rax,%rdx
  80230c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802313:	01 00 00 
  802316:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80231a:	25 07 0e 00 00       	and    $0xe07,%eax
  80231f:	89 c1                	mov    %eax,%ecx
  802321:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802325:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802329:	41 89 c8             	mov    %ecx,%r8d
  80232c:	48 89 d1             	mov    %rdx,%rcx
  80232f:	ba 00 00 00 00       	mov    $0x0,%edx
  802334:	48 89 c6             	mov    %rax,%rsi
  802337:	bf 00 00 00 00       	mov    $0x0,%edi
  80233c:	48 b8 7d 1a 80 00 00 	movabs $0x801a7d,%rax
  802343:	00 00 00 
  802346:	ff d0                	callq  *%rax
  802348:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80234b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80234f:	79 02                	jns    802353 <dup+0x16f>
		goto err;
  802351:	eb 05                	jmp    802358 <dup+0x174>

	return newfdnum;
  802353:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802356:	eb 33                	jmp    80238b <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802358:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80235c:	48 89 c6             	mov    %rax,%rsi
  80235f:	bf 00 00 00 00       	mov    $0x0,%edi
  802364:	48 b8 dd 1a 80 00 00 	movabs $0x801add,%rax
  80236b:	00 00 00 
  80236e:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802370:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802374:	48 89 c6             	mov    %rax,%rsi
  802377:	bf 00 00 00 00       	mov    $0x0,%edi
  80237c:	48 b8 dd 1a 80 00 00 	movabs $0x801add,%rax
  802383:	00 00 00 
  802386:	ff d0                	callq  *%rax
	return r;
  802388:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80238b:	c9                   	leaveq 
  80238c:	c3                   	retq   

000000000080238d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80238d:	55                   	push   %rbp
  80238e:	48 89 e5             	mov    %rsp,%rbp
  802391:	48 83 ec 40          	sub    $0x40,%rsp
  802395:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802398:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80239c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023a0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023a4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023a7:	48 89 d6             	mov    %rdx,%rsi
  8023aa:	89 c7                	mov    %eax,%edi
  8023ac:	48 b8 59 1f 80 00 00 	movabs $0x801f59,%rax
  8023b3:	00 00 00 
  8023b6:	ff d0                	callq  *%rax
  8023b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023bf:	78 24                	js     8023e5 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c5:	8b 00                	mov    (%rax),%eax
  8023c7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023cb:	48 89 d6             	mov    %rdx,%rsi
  8023ce:	89 c7                	mov    %eax,%edi
  8023d0:	48 b8 b4 20 80 00 00 	movabs $0x8020b4,%rax
  8023d7:	00 00 00 
  8023da:	ff d0                	callq  *%rax
  8023dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e3:	79 05                	jns    8023ea <read+0x5d>
		return r;
  8023e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023e8:	eb 76                	jmp    802460 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8023ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ee:	8b 40 08             	mov    0x8(%rax),%eax
  8023f1:	83 e0 03             	and    $0x3,%eax
  8023f4:	83 f8 01             	cmp    $0x1,%eax
  8023f7:	75 3a                	jne    802433 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8023f9:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802400:	00 00 00 
  802403:	48 8b 00             	mov    (%rax),%rax
  802406:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80240c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80240f:	89 c6                	mov    %eax,%esi
  802411:	48 bf 7f 51 80 00 00 	movabs $0x80517f,%rdi
  802418:	00 00 00 
  80241b:	b8 00 00 00 00       	mov    $0x0,%eax
  802420:	48 b9 64 05 80 00 00 	movabs $0x800564,%rcx
  802427:	00 00 00 
  80242a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80242c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802431:	eb 2d                	jmp    802460 <read+0xd3>
	}
	if (!dev->dev_read)
  802433:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802437:	48 8b 40 10          	mov    0x10(%rax),%rax
  80243b:	48 85 c0             	test   %rax,%rax
  80243e:	75 07                	jne    802447 <read+0xba>
		return -E_NOT_SUPP;
  802440:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802445:	eb 19                	jmp    802460 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802447:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80244b:	48 8b 40 10          	mov    0x10(%rax),%rax
  80244f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802453:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802457:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80245b:	48 89 cf             	mov    %rcx,%rdi
  80245e:	ff d0                	callq  *%rax
}
  802460:	c9                   	leaveq 
  802461:	c3                   	retq   

0000000000802462 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802462:	55                   	push   %rbp
  802463:	48 89 e5             	mov    %rsp,%rbp
  802466:	48 83 ec 30          	sub    $0x30,%rsp
  80246a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80246d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802471:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802475:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80247c:	eb 49                	jmp    8024c7 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80247e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802481:	48 98                	cltq   
  802483:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802487:	48 29 c2             	sub    %rax,%rdx
  80248a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80248d:	48 63 c8             	movslq %eax,%rcx
  802490:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802494:	48 01 c1             	add    %rax,%rcx
  802497:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80249a:	48 89 ce             	mov    %rcx,%rsi
  80249d:	89 c7                	mov    %eax,%edi
  80249f:	48 b8 8d 23 80 00 00 	movabs $0x80238d,%rax
  8024a6:	00 00 00 
  8024a9:	ff d0                	callq  *%rax
  8024ab:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8024ae:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024b2:	79 05                	jns    8024b9 <readn+0x57>
			return m;
  8024b4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024b7:	eb 1c                	jmp    8024d5 <readn+0x73>
		if (m == 0)
  8024b9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8024bd:	75 02                	jne    8024c1 <readn+0x5f>
			break;
  8024bf:	eb 11                	jmp    8024d2 <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  8024c1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024c4:	01 45 fc             	add    %eax,-0x4(%rbp)
  8024c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ca:	48 98                	cltq   
  8024cc:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8024d0:	72 ac                	jb     80247e <readn+0x1c>
	}
	return tot;
  8024d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024d5:	c9                   	leaveq 
  8024d6:	c3                   	retq   

00000000008024d7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8024d7:	55                   	push   %rbp
  8024d8:	48 89 e5             	mov    %rsp,%rbp
  8024db:	48 83 ec 40          	sub    $0x40,%rsp
  8024df:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024e2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8024e6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024ea:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024ee:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024f1:	48 89 d6             	mov    %rdx,%rsi
  8024f4:	89 c7                	mov    %eax,%edi
  8024f6:	48 b8 59 1f 80 00 00 	movabs $0x801f59,%rax
  8024fd:	00 00 00 
  802500:	ff d0                	callq  *%rax
  802502:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802505:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802509:	78 24                	js     80252f <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80250b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80250f:	8b 00                	mov    (%rax),%eax
  802511:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802515:	48 89 d6             	mov    %rdx,%rsi
  802518:	89 c7                	mov    %eax,%edi
  80251a:	48 b8 b4 20 80 00 00 	movabs $0x8020b4,%rax
  802521:	00 00 00 
  802524:	ff d0                	callq  *%rax
  802526:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802529:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80252d:	79 05                	jns    802534 <write+0x5d>
		return r;
  80252f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802532:	eb 75                	jmp    8025a9 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802534:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802538:	8b 40 08             	mov    0x8(%rax),%eax
  80253b:	83 e0 03             	and    $0x3,%eax
  80253e:	85 c0                	test   %eax,%eax
  802540:	75 3a                	jne    80257c <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802542:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802549:	00 00 00 
  80254c:	48 8b 00             	mov    (%rax),%rax
  80254f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802555:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802558:	89 c6                	mov    %eax,%esi
  80255a:	48 bf 9b 51 80 00 00 	movabs $0x80519b,%rdi
  802561:	00 00 00 
  802564:	b8 00 00 00 00       	mov    $0x0,%eax
  802569:	48 b9 64 05 80 00 00 	movabs $0x800564,%rcx
  802570:	00 00 00 
  802573:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802575:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80257a:	eb 2d                	jmp    8025a9 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80257c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802580:	48 8b 40 18          	mov    0x18(%rax),%rax
  802584:	48 85 c0             	test   %rax,%rax
  802587:	75 07                	jne    802590 <write+0xb9>
		return -E_NOT_SUPP;
  802589:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80258e:	eb 19                	jmp    8025a9 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802590:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802594:	48 8b 40 18          	mov    0x18(%rax),%rax
  802598:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80259c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025a0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025a4:	48 89 cf             	mov    %rcx,%rdi
  8025a7:	ff d0                	callq  *%rax
}
  8025a9:	c9                   	leaveq 
  8025aa:	c3                   	retq   

00000000008025ab <seek>:

int
seek(int fdnum, off_t offset)
{
  8025ab:	55                   	push   %rbp
  8025ac:	48 89 e5             	mov    %rsp,%rbp
  8025af:	48 83 ec 18          	sub    $0x18,%rsp
  8025b3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025b6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025b9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025bd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025c0:	48 89 d6             	mov    %rdx,%rsi
  8025c3:	89 c7                	mov    %eax,%edi
  8025c5:	48 b8 59 1f 80 00 00 	movabs $0x801f59,%rax
  8025cc:	00 00 00 
  8025cf:	ff d0                	callq  *%rax
  8025d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025d8:	79 05                	jns    8025df <seek+0x34>
		return r;
  8025da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025dd:	eb 0f                	jmp    8025ee <seek+0x43>
	fd->fd_offset = offset;
  8025df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8025e6:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8025e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ee:	c9                   	leaveq 
  8025ef:	c3                   	retq   

00000000008025f0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8025f0:	55                   	push   %rbp
  8025f1:	48 89 e5             	mov    %rsp,%rbp
  8025f4:	48 83 ec 30          	sub    $0x30,%rsp
  8025f8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025fb:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025fe:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802602:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802605:	48 89 d6             	mov    %rdx,%rsi
  802608:	89 c7                	mov    %eax,%edi
  80260a:	48 b8 59 1f 80 00 00 	movabs $0x801f59,%rax
  802611:	00 00 00 
  802614:	ff d0                	callq  *%rax
  802616:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802619:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80261d:	78 24                	js     802643 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80261f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802623:	8b 00                	mov    (%rax),%eax
  802625:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802629:	48 89 d6             	mov    %rdx,%rsi
  80262c:	89 c7                	mov    %eax,%edi
  80262e:	48 b8 b4 20 80 00 00 	movabs $0x8020b4,%rax
  802635:	00 00 00 
  802638:	ff d0                	callq  *%rax
  80263a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80263d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802641:	79 05                	jns    802648 <ftruncate+0x58>
		return r;
  802643:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802646:	eb 72                	jmp    8026ba <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802648:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80264c:	8b 40 08             	mov    0x8(%rax),%eax
  80264f:	83 e0 03             	and    $0x3,%eax
  802652:	85 c0                	test   %eax,%eax
  802654:	75 3a                	jne    802690 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802656:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80265d:	00 00 00 
  802660:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802663:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802669:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80266c:	89 c6                	mov    %eax,%esi
  80266e:	48 bf b8 51 80 00 00 	movabs $0x8051b8,%rdi
  802675:	00 00 00 
  802678:	b8 00 00 00 00       	mov    $0x0,%eax
  80267d:	48 b9 64 05 80 00 00 	movabs $0x800564,%rcx
  802684:	00 00 00 
  802687:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802689:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80268e:	eb 2a                	jmp    8026ba <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802690:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802694:	48 8b 40 30          	mov    0x30(%rax),%rax
  802698:	48 85 c0             	test   %rax,%rax
  80269b:	75 07                	jne    8026a4 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80269d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026a2:	eb 16                	jmp    8026ba <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8026a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026a8:	48 8b 40 30          	mov    0x30(%rax),%rax
  8026ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026b0:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8026b3:	89 ce                	mov    %ecx,%esi
  8026b5:	48 89 d7             	mov    %rdx,%rdi
  8026b8:	ff d0                	callq  *%rax
}
  8026ba:	c9                   	leaveq 
  8026bb:	c3                   	retq   

00000000008026bc <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8026bc:	55                   	push   %rbp
  8026bd:	48 89 e5             	mov    %rsp,%rbp
  8026c0:	48 83 ec 30          	sub    $0x30,%rsp
  8026c4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026c7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026cb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026cf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026d2:	48 89 d6             	mov    %rdx,%rsi
  8026d5:	89 c7                	mov    %eax,%edi
  8026d7:	48 b8 59 1f 80 00 00 	movabs $0x801f59,%rax
  8026de:	00 00 00 
  8026e1:	ff d0                	callq  *%rax
  8026e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ea:	78 24                	js     802710 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f0:	8b 00                	mov    (%rax),%eax
  8026f2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026f6:	48 89 d6             	mov    %rdx,%rsi
  8026f9:	89 c7                	mov    %eax,%edi
  8026fb:	48 b8 b4 20 80 00 00 	movabs $0x8020b4,%rax
  802702:	00 00 00 
  802705:	ff d0                	callq  *%rax
  802707:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80270a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80270e:	79 05                	jns    802715 <fstat+0x59>
		return r;
  802710:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802713:	eb 5e                	jmp    802773 <fstat+0xb7>
	if (!dev->dev_stat)
  802715:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802719:	48 8b 40 28          	mov    0x28(%rax),%rax
  80271d:	48 85 c0             	test   %rax,%rax
  802720:	75 07                	jne    802729 <fstat+0x6d>
		return -E_NOT_SUPP;
  802722:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802727:	eb 4a                	jmp    802773 <fstat+0xb7>
	stat->st_name[0] = 0;
  802729:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80272d:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802730:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802734:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80273b:	00 00 00 
	stat->st_isdir = 0;
  80273e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802742:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802749:	00 00 00 
	stat->st_dev = dev;
  80274c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802750:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802754:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80275b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80275f:	48 8b 40 28          	mov    0x28(%rax),%rax
  802763:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802767:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80276b:	48 89 ce             	mov    %rcx,%rsi
  80276e:	48 89 d7             	mov    %rdx,%rdi
  802771:	ff d0                	callq  *%rax
}
  802773:	c9                   	leaveq 
  802774:	c3                   	retq   

0000000000802775 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802775:	55                   	push   %rbp
  802776:	48 89 e5             	mov    %rsp,%rbp
  802779:	48 83 ec 20          	sub    $0x20,%rsp
  80277d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802781:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802785:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802789:	be 00 00 00 00       	mov    $0x0,%esi
  80278e:	48 89 c7             	mov    %rax,%rdi
  802791:	48 b8 65 28 80 00 00 	movabs $0x802865,%rax
  802798:	00 00 00 
  80279b:	ff d0                	callq  *%rax
  80279d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a4:	79 05                	jns    8027ab <stat+0x36>
		return fd;
  8027a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a9:	eb 2f                	jmp    8027da <stat+0x65>
	r = fstat(fd, stat);
  8027ab:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8027af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b2:	48 89 d6             	mov    %rdx,%rsi
  8027b5:	89 c7                	mov    %eax,%edi
  8027b7:	48 b8 bc 26 80 00 00 	movabs $0x8026bc,%rax
  8027be:	00 00 00 
  8027c1:	ff d0                	callq  *%rax
  8027c3:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8027c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c9:	89 c7                	mov    %eax,%edi
  8027cb:	48 b8 6b 21 80 00 00 	movabs $0x80216b,%rax
  8027d2:	00 00 00 
  8027d5:	ff d0                	callq  *%rax
	return r;
  8027d7:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8027da:	c9                   	leaveq 
  8027db:	c3                   	retq   

00000000008027dc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8027dc:	55                   	push   %rbp
  8027dd:	48 89 e5             	mov    %rsp,%rbp
  8027e0:	48 83 ec 10          	sub    $0x10,%rsp
  8027e4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8027e7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8027eb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027f2:	00 00 00 
  8027f5:	8b 00                	mov    (%rax),%eax
  8027f7:	85 c0                	test   %eax,%eax
  8027f9:	75 1f                	jne    80281a <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8027fb:	bf 01 00 00 00       	mov    $0x1,%edi
  802800:	48 b8 e0 49 80 00 00 	movabs $0x8049e0,%rax
  802807:	00 00 00 
  80280a:	ff d0                	callq  *%rax
  80280c:	89 c2                	mov    %eax,%edx
  80280e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802815:	00 00 00 
  802818:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80281a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802821:	00 00 00 
  802824:	8b 00                	mov    (%rax),%eax
  802826:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802829:	b9 07 00 00 00       	mov    $0x7,%ecx
  80282e:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802835:	00 00 00 
  802838:	89 c7                	mov    %eax,%edi
  80283a:	48 b8 53 48 80 00 00 	movabs $0x804853,%rax
  802841:	00 00 00 
  802844:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802846:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80284a:	ba 00 00 00 00       	mov    $0x0,%edx
  80284f:	48 89 c6             	mov    %rax,%rsi
  802852:	bf 00 00 00 00       	mov    $0x0,%edi
  802857:	48 b8 15 48 80 00 00 	movabs $0x804815,%rax
  80285e:	00 00 00 
  802861:	ff d0                	callq  *%rax
}
  802863:	c9                   	leaveq 
  802864:	c3                   	retq   

0000000000802865 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802865:	55                   	push   %rbp
  802866:	48 89 e5             	mov    %rsp,%rbp
  802869:	48 83 ec 10          	sub    $0x10,%rsp
  80286d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802871:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  802874:	48 ba de 51 80 00 00 	movabs $0x8051de,%rdx
  80287b:	00 00 00 
  80287e:	be 4c 00 00 00       	mov    $0x4c,%esi
  802883:	48 bf f3 51 80 00 00 	movabs $0x8051f3,%rdi
  80288a:	00 00 00 
  80288d:	b8 00 00 00 00       	mov    $0x0,%eax
  802892:	48 b9 2b 03 80 00 00 	movabs $0x80032b,%rcx
  802899:	00 00 00 
  80289c:	ff d1                	callq  *%rcx

000000000080289e <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80289e:	55                   	push   %rbp
  80289f:	48 89 e5             	mov    %rsp,%rbp
  8028a2:	48 83 ec 10          	sub    $0x10,%rsp
  8028a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8028aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028ae:	8b 50 0c             	mov    0xc(%rax),%edx
  8028b1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028b8:	00 00 00 
  8028bb:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8028bd:	be 00 00 00 00       	mov    $0x0,%esi
  8028c2:	bf 06 00 00 00       	mov    $0x6,%edi
  8028c7:	48 b8 dc 27 80 00 00 	movabs $0x8027dc,%rax
  8028ce:	00 00 00 
  8028d1:	ff d0                	callq  *%rax
}
  8028d3:	c9                   	leaveq 
  8028d4:	c3                   	retq   

00000000008028d5 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8028d5:	55                   	push   %rbp
  8028d6:	48 89 e5             	mov    %rsp,%rbp
  8028d9:	48 83 ec 20          	sub    $0x20,%rsp
  8028dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8028e1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8028e5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  8028e9:	48 ba fe 51 80 00 00 	movabs $0x8051fe,%rdx
  8028f0:	00 00 00 
  8028f3:	be 6b 00 00 00       	mov    $0x6b,%esi
  8028f8:	48 bf f3 51 80 00 00 	movabs $0x8051f3,%rdi
  8028ff:	00 00 00 
  802902:	b8 00 00 00 00       	mov    $0x0,%eax
  802907:	48 b9 2b 03 80 00 00 	movabs $0x80032b,%rcx
  80290e:	00 00 00 
  802911:	ff d1                	callq  *%rcx

0000000000802913 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802913:	55                   	push   %rbp
  802914:	48 89 e5             	mov    %rsp,%rbp
  802917:	48 83 ec 20          	sub    $0x20,%rsp
  80291b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80291f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802923:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  802927:	48 ba 1b 52 80 00 00 	movabs $0x80521b,%rdx
  80292e:	00 00 00 
  802931:	be 7b 00 00 00       	mov    $0x7b,%esi
  802936:	48 bf f3 51 80 00 00 	movabs $0x8051f3,%rdi
  80293d:	00 00 00 
  802940:	b8 00 00 00 00       	mov    $0x0,%eax
  802945:	48 b9 2b 03 80 00 00 	movabs $0x80032b,%rcx
  80294c:	00 00 00 
  80294f:	ff d1                	callq  *%rcx

0000000000802951 <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802951:	55                   	push   %rbp
  802952:	48 89 e5             	mov    %rsp,%rbp
  802955:	48 83 ec 20          	sub    $0x20,%rsp
  802959:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80295d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802961:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802965:	8b 50 0c             	mov    0xc(%rax),%edx
  802968:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80296f:	00 00 00 
  802972:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802974:	be 00 00 00 00       	mov    $0x0,%esi
  802979:	bf 05 00 00 00       	mov    $0x5,%edi
  80297e:	48 b8 dc 27 80 00 00 	movabs $0x8027dc,%rax
  802985:	00 00 00 
  802988:	ff d0                	callq  *%rax
  80298a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80298d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802991:	79 05                	jns    802998 <devfile_stat+0x47>
		return r;
  802993:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802996:	eb 56                	jmp    8029ee <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802998:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80299c:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8029a3:	00 00 00 
  8029a6:	48 89 c7             	mov    %rax,%rdi
  8029a9:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  8029b0:	00 00 00 
  8029b3:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8029b5:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8029bc:	00 00 00 
  8029bf:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8029c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029c9:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8029cf:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8029d6:	00 00 00 
  8029d9:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8029df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029e3:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8029e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029ee:	c9                   	leaveq 
  8029ef:	c3                   	retq   

00000000008029f0 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8029f0:	55                   	push   %rbp
  8029f1:	48 89 e5             	mov    %rsp,%rbp
  8029f4:	48 83 ec 10          	sub    $0x10,%rsp
  8029f8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8029fc:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8029ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a03:	8b 50 0c             	mov    0xc(%rax),%edx
  802a06:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a0d:	00 00 00 
  802a10:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802a12:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a19:	00 00 00 
  802a1c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802a1f:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802a22:	be 00 00 00 00       	mov    $0x0,%esi
  802a27:	bf 02 00 00 00       	mov    $0x2,%edi
  802a2c:	48 b8 dc 27 80 00 00 	movabs $0x8027dc,%rax
  802a33:	00 00 00 
  802a36:	ff d0                	callq  *%rax
}
  802a38:	c9                   	leaveq 
  802a39:	c3                   	retq   

0000000000802a3a <remove>:

// Delete a file
int
remove(const char *path)
{
  802a3a:	55                   	push   %rbp
  802a3b:	48 89 e5             	mov    %rsp,%rbp
  802a3e:	48 83 ec 10          	sub    $0x10,%rsp
  802a42:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802a46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a4a:	48 89 c7             	mov    %rax,%rdi
  802a4d:	48 b8 92 10 80 00 00 	movabs $0x801092,%rax
  802a54:	00 00 00 
  802a57:	ff d0                	callq  *%rax
  802a59:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802a5e:	7e 07                	jle    802a67 <remove+0x2d>
		return -E_BAD_PATH;
  802a60:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802a65:	eb 33                	jmp    802a9a <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802a67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a6b:	48 89 c6             	mov    %rax,%rsi
  802a6e:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802a75:	00 00 00 
  802a78:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  802a7f:	00 00 00 
  802a82:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802a84:	be 00 00 00 00       	mov    $0x0,%esi
  802a89:	bf 07 00 00 00       	mov    $0x7,%edi
  802a8e:	48 b8 dc 27 80 00 00 	movabs $0x8027dc,%rax
  802a95:	00 00 00 
  802a98:	ff d0                	callq  *%rax
}
  802a9a:	c9                   	leaveq 
  802a9b:	c3                   	retq   

0000000000802a9c <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802a9c:	55                   	push   %rbp
  802a9d:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802aa0:	be 00 00 00 00       	mov    $0x0,%esi
  802aa5:	bf 08 00 00 00       	mov    $0x8,%edi
  802aaa:	48 b8 dc 27 80 00 00 	movabs $0x8027dc,%rax
  802ab1:	00 00 00 
  802ab4:	ff d0                	callq  *%rax
}
  802ab6:	5d                   	pop    %rbp
  802ab7:	c3                   	retq   

0000000000802ab8 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802ab8:	55                   	push   %rbp
  802ab9:	48 89 e5             	mov    %rsp,%rbp
  802abc:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802ac3:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802aca:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802ad1:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802ad8:	be 00 00 00 00       	mov    $0x0,%esi
  802add:	48 89 c7             	mov    %rax,%rdi
  802ae0:	48 b8 65 28 80 00 00 	movabs $0x802865,%rax
  802ae7:	00 00 00 
  802aea:	ff d0                	callq  *%rax
  802aec:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802aef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802af3:	79 28                	jns    802b1d <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802af5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af8:	89 c6                	mov    %eax,%esi
  802afa:	48 bf 39 52 80 00 00 	movabs $0x805239,%rdi
  802b01:	00 00 00 
  802b04:	b8 00 00 00 00       	mov    $0x0,%eax
  802b09:	48 ba 64 05 80 00 00 	movabs $0x800564,%rdx
  802b10:	00 00 00 
  802b13:	ff d2                	callq  *%rdx
		return fd_src;
  802b15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b18:	e9 74 01 00 00       	jmpq   802c91 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802b1d:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802b24:	be 01 01 00 00       	mov    $0x101,%esi
  802b29:	48 89 c7             	mov    %rax,%rdi
  802b2c:	48 b8 65 28 80 00 00 	movabs $0x802865,%rax
  802b33:	00 00 00 
  802b36:	ff d0                	callq  *%rax
  802b38:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802b3b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b3f:	79 39                	jns    802b7a <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802b41:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b44:	89 c6                	mov    %eax,%esi
  802b46:	48 bf 4f 52 80 00 00 	movabs $0x80524f,%rdi
  802b4d:	00 00 00 
  802b50:	b8 00 00 00 00       	mov    $0x0,%eax
  802b55:	48 ba 64 05 80 00 00 	movabs $0x800564,%rdx
  802b5c:	00 00 00 
  802b5f:	ff d2                	callq  *%rdx
		close(fd_src);
  802b61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b64:	89 c7                	mov    %eax,%edi
  802b66:	48 b8 6b 21 80 00 00 	movabs $0x80216b,%rax
  802b6d:	00 00 00 
  802b70:	ff d0                	callq  *%rax
		return fd_dest;
  802b72:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b75:	e9 17 01 00 00       	jmpq   802c91 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802b7a:	eb 74                	jmp    802bf0 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802b7c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b7f:	48 63 d0             	movslq %eax,%rdx
  802b82:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802b89:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b8c:	48 89 ce             	mov    %rcx,%rsi
  802b8f:	89 c7                	mov    %eax,%edi
  802b91:	48 b8 d7 24 80 00 00 	movabs $0x8024d7,%rax
  802b98:	00 00 00 
  802b9b:	ff d0                	callq  *%rax
  802b9d:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802ba0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802ba4:	79 4a                	jns    802bf0 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802ba6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802ba9:	89 c6                	mov    %eax,%esi
  802bab:	48 bf 69 52 80 00 00 	movabs $0x805269,%rdi
  802bb2:	00 00 00 
  802bb5:	b8 00 00 00 00       	mov    $0x0,%eax
  802bba:	48 ba 64 05 80 00 00 	movabs $0x800564,%rdx
  802bc1:	00 00 00 
  802bc4:	ff d2                	callq  *%rdx
			close(fd_src);
  802bc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc9:	89 c7                	mov    %eax,%edi
  802bcb:	48 b8 6b 21 80 00 00 	movabs $0x80216b,%rax
  802bd2:	00 00 00 
  802bd5:	ff d0                	callq  *%rax
			close(fd_dest);
  802bd7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bda:	89 c7                	mov    %eax,%edi
  802bdc:	48 b8 6b 21 80 00 00 	movabs $0x80216b,%rax
  802be3:	00 00 00 
  802be6:	ff d0                	callq  *%rax
			return write_size;
  802be8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802beb:	e9 a1 00 00 00       	jmpq   802c91 <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802bf0:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802bf7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bfa:	ba 00 02 00 00       	mov    $0x200,%edx
  802bff:	48 89 ce             	mov    %rcx,%rsi
  802c02:	89 c7                	mov    %eax,%edi
  802c04:	48 b8 8d 23 80 00 00 	movabs $0x80238d,%rax
  802c0b:	00 00 00 
  802c0e:	ff d0                	callq  *%rax
  802c10:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802c13:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c17:	0f 8f 5f ff ff ff    	jg     802b7c <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  802c1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802c21:	79 47                	jns    802c6a <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802c23:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c26:	89 c6                	mov    %eax,%esi
  802c28:	48 bf 7c 52 80 00 00 	movabs $0x80527c,%rdi
  802c2f:	00 00 00 
  802c32:	b8 00 00 00 00       	mov    $0x0,%eax
  802c37:	48 ba 64 05 80 00 00 	movabs $0x800564,%rdx
  802c3e:	00 00 00 
  802c41:	ff d2                	callq  *%rdx
		close(fd_src);
  802c43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c46:	89 c7                	mov    %eax,%edi
  802c48:	48 b8 6b 21 80 00 00 	movabs $0x80216b,%rax
  802c4f:	00 00 00 
  802c52:	ff d0                	callq  *%rax
		close(fd_dest);
  802c54:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c57:	89 c7                	mov    %eax,%edi
  802c59:	48 b8 6b 21 80 00 00 	movabs $0x80216b,%rax
  802c60:	00 00 00 
  802c63:	ff d0                	callq  *%rax
		return read_size;
  802c65:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c68:	eb 27                	jmp    802c91 <copy+0x1d9>
	}
	close(fd_src);
  802c6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c6d:	89 c7                	mov    %eax,%edi
  802c6f:	48 b8 6b 21 80 00 00 	movabs $0x80216b,%rax
  802c76:	00 00 00 
  802c79:	ff d0                	callq  *%rax
	close(fd_dest);
  802c7b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c7e:	89 c7                	mov    %eax,%edi
  802c80:	48 b8 6b 21 80 00 00 	movabs $0x80216b,%rax
  802c87:	00 00 00 
  802c8a:	ff d0                	callq  *%rax
	return 0;
  802c8c:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802c91:	c9                   	leaveq 
  802c92:	c3                   	retq   

0000000000802c93 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802c93:	55                   	push   %rbp
  802c94:	48 89 e5             	mov    %rsp,%rbp
  802c97:	48 81 ec 00 03 00 00 	sub    $0x300,%rsp
  802c9e:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  802ca5:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial rip and rsp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802cac:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  802cb3:	be 00 00 00 00       	mov    $0x0,%esi
  802cb8:	48 89 c7             	mov    %rax,%rdi
  802cbb:	48 b8 65 28 80 00 00 	movabs $0x802865,%rax
  802cc2:	00 00 00 
  802cc5:	ff d0                	callq  *%rax
  802cc7:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802cca:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802cce:	79 08                	jns    802cd8 <spawn+0x45>
		return r;
  802cd0:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802cd3:	e9 12 03 00 00       	jmpq   802fea <spawn+0x357>
	fd = r;
  802cd8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802cdb:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802cde:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  802ce5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802ce9:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  802cf0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802cf3:	ba 00 02 00 00       	mov    $0x200,%edx
  802cf8:	48 89 ce             	mov    %rcx,%rsi
  802cfb:	89 c7                	mov    %eax,%edi
  802cfd:	48 b8 62 24 80 00 00 	movabs $0x802462,%rax
  802d04:	00 00 00 
  802d07:	ff d0                	callq  *%rax
  802d09:	3d 00 02 00 00       	cmp    $0x200,%eax
  802d0e:	75 0d                	jne    802d1d <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  802d10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d14:	8b 00                	mov    (%rax),%eax
  802d16:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802d1b:	74 43                	je     802d60 <spawn+0xcd>
		close(fd);
  802d1d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802d20:	89 c7                	mov    %eax,%edi
  802d22:	48 b8 6b 21 80 00 00 	movabs $0x80216b,%rax
  802d29:	00 00 00 
  802d2c:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802d2e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d32:	8b 00                	mov    (%rax),%eax
  802d34:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802d39:	89 c6                	mov    %eax,%esi
  802d3b:	48 bf 98 52 80 00 00 	movabs $0x805298,%rdi
  802d42:	00 00 00 
  802d45:	b8 00 00 00 00       	mov    $0x0,%eax
  802d4a:	48 b9 64 05 80 00 00 	movabs $0x800564,%rcx
  802d51:	00 00 00 
  802d54:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802d56:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802d5b:	e9 8a 02 00 00       	jmpq   802fea <spawn+0x357>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802d60:	b8 07 00 00 00       	mov    $0x7,%eax
  802d65:	cd 30                	int    $0x30
  802d67:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802d6a:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802d6d:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802d70:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802d74:	79 08                	jns    802d7e <spawn+0xeb>
		return r;
  802d76:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802d79:	e9 6c 02 00 00       	jmpq   802fea <spawn+0x357>
	child = r;
  802d7e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802d81:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802d84:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802d87:	25 ff 03 00 00       	and    $0x3ff,%eax
  802d8c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802d93:	00 00 00 
  802d96:	48 98                	cltq   
  802d98:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802d9f:	48 01 c2             	add    %rax,%rdx
  802da2:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802da9:	48 89 d6             	mov    %rdx,%rsi
  802dac:	ba 18 00 00 00       	mov    $0x18,%edx
  802db1:	48 89 c7             	mov    %rax,%rdi
  802db4:	48 89 d1             	mov    %rdx,%rcx
  802db7:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  802dba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dbe:	48 8b 40 18          	mov    0x18(%rax),%rax
  802dc2:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  802dc9:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802dd0:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  802dd7:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  802dde:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802de1:	48 89 ce             	mov    %rcx,%rsi
  802de4:	89 c7                	mov    %eax,%edi
  802de6:	48 b8 4e 32 80 00 00 	movabs $0x80324e,%rax
  802ded:	00 00 00 
  802df0:	ff d0                	callq  *%rax
  802df2:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802df5:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802df9:	79 08                	jns    802e03 <spawn+0x170>
		return r;
  802dfb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802dfe:	e9 e7 01 00 00       	jmpq   802fea <spawn+0x357>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802e03:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e07:	48 8b 40 20          	mov    0x20(%rax),%rax
  802e0b:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  802e12:	48 01 d0             	add    %rdx,%rax
  802e15:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802e19:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802e20:	e9 a9 00 00 00       	jmpq   802ece <spawn+0x23b>
		if (ph->p_type != ELF_PROG_LOAD)
  802e25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e29:	8b 00                	mov    (%rax),%eax
  802e2b:	83 f8 01             	cmp    $0x1,%eax
  802e2e:	74 05                	je     802e35 <spawn+0x1a2>
			continue;
  802e30:	e9 90 00 00 00       	jmpq   802ec5 <spawn+0x232>
		perm = PTE_P | PTE_U;
  802e35:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802e3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e40:	8b 40 04             	mov    0x4(%rax),%eax
  802e43:	83 e0 02             	and    $0x2,%eax
  802e46:	85 c0                	test   %eax,%eax
  802e48:	74 04                	je     802e4e <spawn+0x1bb>
			perm |= PTE_W;
  802e4a:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802e4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e52:	48 8b 40 08          	mov    0x8(%rax),%rax
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802e56:	41 89 c1             	mov    %eax,%r9d
  802e59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e5d:	4c 8b 40 20          	mov    0x20(%rax),%r8
  802e61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e65:	48 8b 50 28          	mov    0x28(%rax),%rdx
  802e69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e6d:	48 8b 70 10          	mov    0x10(%rax),%rsi
  802e71:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802e74:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802e77:	48 83 ec 08          	sub    $0x8,%rsp
  802e7b:	8b 7d ec             	mov    -0x14(%rbp),%edi
  802e7e:	57                   	push   %rdi
  802e7f:	89 c7                	mov    %eax,%edi
  802e81:	48 b8 fa 34 80 00 00 	movabs $0x8034fa,%rax
  802e88:	00 00 00 
  802e8b:	ff d0                	callq  *%rax
  802e8d:	48 83 c4 10          	add    $0x10,%rsp
  802e91:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802e94:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802e98:	79 2b                	jns    802ec5 <spawn+0x232>
			goto error;
  802e9a:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802e9b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802e9e:	89 c7                	mov    %eax,%edi
  802ea0:	48 b8 6d 19 80 00 00 	movabs $0x80196d,%rax
  802ea7:	00 00 00 
  802eaa:	ff d0                	callq  *%rax
	close(fd);
  802eac:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802eaf:	89 c7                	mov    %eax,%edi
  802eb1:	48 b8 6b 21 80 00 00 	movabs $0x80216b,%rax
  802eb8:	00 00 00 
  802ebb:	ff d0                	callq  *%rax
	return r;
  802ebd:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802ec0:	e9 25 01 00 00       	jmpq   802fea <spawn+0x357>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802ec5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802ec9:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  802ece:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ed2:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  802ed6:	0f b7 c0             	movzwl %ax,%eax
  802ed9:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802edc:	0f 8f 43 ff ff ff    	jg     802e25 <spawn+0x192>
	close(fd);
  802ee2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802ee5:	89 c7                	mov    %eax,%edi
  802ee7:	48 b8 6b 21 80 00 00 	movabs $0x80216b,%rax
  802eee:	00 00 00 
  802ef1:	ff d0                	callq  *%rax
	fd = -1;
  802ef3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)
	if ((r = copy_shared_pages(child)) < 0)
  802efa:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802efd:	89 c7                	mov    %eax,%edi
  802eff:	48 b8 e6 36 80 00 00 	movabs $0x8036e6,%rax
  802f06:	00 00 00 
  802f09:	ff d0                	callq  *%rax
  802f0b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802f0e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802f12:	79 30                	jns    802f44 <spawn+0x2b1>
		panic("copy_shared_pages: %e", r);
  802f14:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f17:	89 c1                	mov    %eax,%ecx
  802f19:	48 ba b2 52 80 00 00 	movabs $0x8052b2,%rdx
  802f20:	00 00 00 
  802f23:	be 82 00 00 00       	mov    $0x82,%esi
  802f28:	48 bf c8 52 80 00 00 	movabs $0x8052c8,%rdi
  802f2f:	00 00 00 
  802f32:	b8 00 00 00 00       	mov    $0x0,%eax
  802f37:	49 b8 2b 03 80 00 00 	movabs $0x80032b,%r8
  802f3e:	00 00 00 
  802f41:	41 ff d0             	callq  *%r8
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802f44:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802f4b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802f4e:	48 89 d6             	mov    %rdx,%rsi
  802f51:	89 c7                	mov    %eax,%edi
  802f53:	48 b8 76 1b 80 00 00 	movabs $0x801b76,%rax
  802f5a:	00 00 00 
  802f5d:	ff d0                	callq  *%rax
  802f5f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802f62:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802f66:	79 30                	jns    802f98 <spawn+0x305>
		panic("sys_env_set_trapframe: %e", r);
  802f68:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802f6b:	89 c1                	mov    %eax,%ecx
  802f6d:	48 ba d4 52 80 00 00 	movabs $0x8052d4,%rdx
  802f74:	00 00 00 
  802f77:	be 85 00 00 00       	mov    $0x85,%esi
  802f7c:	48 bf c8 52 80 00 00 	movabs $0x8052c8,%rdi
  802f83:	00 00 00 
  802f86:	b8 00 00 00 00       	mov    $0x0,%eax
  802f8b:	49 b8 2b 03 80 00 00 	movabs $0x80032b,%r8
  802f92:	00 00 00 
  802f95:	41 ff d0             	callq  *%r8
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802f98:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802f9b:	be 02 00 00 00       	mov    $0x2,%esi
  802fa0:	89 c7                	mov    %eax,%edi
  802fa2:	48 b8 29 1b 80 00 00 	movabs $0x801b29,%rax
  802fa9:	00 00 00 
  802fac:	ff d0                	callq  *%rax
  802fae:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802fb1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802fb5:	79 30                	jns    802fe7 <spawn+0x354>
		panic("sys_env_set_status: %e", r);
  802fb7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802fba:	89 c1                	mov    %eax,%ecx
  802fbc:	48 ba ee 52 80 00 00 	movabs $0x8052ee,%rdx
  802fc3:	00 00 00 
  802fc6:	be 88 00 00 00       	mov    $0x88,%esi
  802fcb:	48 bf c8 52 80 00 00 	movabs $0x8052c8,%rdi
  802fd2:	00 00 00 
  802fd5:	b8 00 00 00 00       	mov    $0x0,%eax
  802fda:	49 b8 2b 03 80 00 00 	movabs $0x80032b,%r8
  802fe1:	00 00 00 
  802fe4:	41 ff d0             	callq  *%r8
	return child;
  802fe7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
}
  802fea:	c9                   	leaveq 
  802feb:	c3                   	retq   

0000000000802fec <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802fec:	55                   	push   %rbp
  802fed:	48 89 e5             	mov    %rsp,%rbp
  802ff0:	41 55                	push   %r13
  802ff2:	41 54                	push   %r12
  802ff4:	53                   	push   %rbx
  802ff5:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802ffc:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  803003:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  80300a:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803011:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  803018:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  80301f:	84 c0                	test   %al,%al
  803021:	74 26                	je     803049 <spawnl+0x5d>
  803023:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  80302a:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803031:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  803035:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  803039:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  80303d:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  803041:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  803045:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  803049:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803050:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803057:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  80305a:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803061:	00 00 00 
  803064:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  80306b:	00 00 00 
  80306e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803072:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803079:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803080:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803087:	eb 07                	jmp    803090 <spawnl+0xa4>
		argc++;
  803089:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	while(va_arg(vl, void *) != NULL)
  803090:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803096:	83 f8 30             	cmp    $0x30,%eax
  803099:	73 23                	jae    8030be <spawnl+0xd2>
  80309b:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  8030a2:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8030a8:	89 d2                	mov    %edx,%edx
  8030aa:	48 01 d0             	add    %rdx,%rax
  8030ad:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8030b3:	83 c2 08             	add    $0x8,%edx
  8030b6:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8030bc:	eb 12                	jmp    8030d0 <spawnl+0xe4>
  8030be:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8030c5:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8030c9:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8030d0:	48 8b 00             	mov    (%rax),%rax
  8030d3:	48 85 c0             	test   %rax,%rax
  8030d6:	75 b1                	jne    803089 <spawnl+0x9d>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8030d8:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8030de:	83 c0 02             	add    $0x2,%eax
  8030e1:	48 89 e2             	mov    %rsp,%rdx
  8030e4:	48 89 d3             	mov    %rdx,%rbx
  8030e7:	48 63 d0             	movslq %eax,%rdx
  8030ea:	48 83 ea 01          	sub    $0x1,%rdx
  8030ee:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  8030f5:	48 63 d0             	movslq %eax,%rdx
  8030f8:	49 89 d4             	mov    %rdx,%r12
  8030fb:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  803101:	48 63 d0             	movslq %eax,%rdx
  803104:	49 89 d2             	mov    %rdx,%r10
  803107:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  80310d:	48 98                	cltq   
  80310f:	48 c1 e0 03          	shl    $0x3,%rax
  803113:	48 8d 50 07          	lea    0x7(%rax),%rdx
  803117:	b8 10 00 00 00       	mov    $0x10,%eax
  80311c:	48 83 e8 01          	sub    $0x1,%rax
  803120:	48 01 d0             	add    %rdx,%rax
  803123:	be 10 00 00 00       	mov    $0x10,%esi
  803128:	ba 00 00 00 00       	mov    $0x0,%edx
  80312d:	48 f7 f6             	div    %rsi
  803130:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803134:	48 29 c4             	sub    %rax,%rsp
  803137:	48 89 e0             	mov    %rsp,%rax
  80313a:	48 83 c0 07          	add    $0x7,%rax
  80313e:	48 c1 e8 03          	shr    $0x3,%rax
  803142:	48 c1 e0 03          	shl    $0x3,%rax
  803146:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  80314d:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803154:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  80315b:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  80315e:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803164:	8d 50 01             	lea    0x1(%rax),%edx
  803167:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80316e:	48 63 d2             	movslq %edx,%rdx
  803171:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803178:	00 

	va_start(vl, arg0);
  803179:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803180:	00 00 00 
  803183:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  80318a:	00 00 00 
  80318d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803191:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803198:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  80319f:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  8031a6:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  8031ad:	00 00 00 
  8031b0:	eb 60                	jmp    803212 <spawnl+0x226>
		argv[i+1] = va_arg(vl, const char *);
  8031b2:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  8031b8:	8d 48 01             	lea    0x1(%rax),%ecx
  8031bb:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8031c1:	83 f8 30             	cmp    $0x30,%eax
  8031c4:	73 23                	jae    8031e9 <spawnl+0x1fd>
  8031c6:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  8031cd:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8031d3:	89 d2                	mov    %edx,%edx
  8031d5:	48 01 d0             	add    %rdx,%rax
  8031d8:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8031de:	83 c2 08             	add    $0x8,%edx
  8031e1:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8031e7:	eb 12                	jmp    8031fb <spawnl+0x20f>
  8031e9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8031f0:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8031f4:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8031fb:	48 8b 10             	mov    (%rax),%rdx
  8031fe:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803205:	89 c9                	mov    %ecx,%ecx
  803207:	48 89 14 c8          	mov    %rdx,(%rax,%rcx,8)
	for(i=0;i<argc;i++)
  80320b:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  803212:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803218:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  80321e:	77 92                	ja     8031b2 <spawnl+0x1c6>
	va_end(vl);
	return spawn(prog, argv);
  803220:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803227:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  80322e:	48 89 d6             	mov    %rdx,%rsi
  803231:	48 89 c7             	mov    %rax,%rdi
  803234:	48 b8 93 2c 80 00 00 	movabs $0x802c93,%rax
  80323b:	00 00 00 
  80323e:	ff d0                	callq  *%rax
  803240:	48 89 dc             	mov    %rbx,%rsp
}
  803243:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803247:	5b                   	pop    %rbx
  803248:	41 5c                	pop    %r12
  80324a:	41 5d                	pop    %r13
  80324c:	5d                   	pop    %rbp
  80324d:	c3                   	retq   

000000000080324e <init_stack>:
// On success, returns 0 and sets *init_rsp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_rsp)
{
  80324e:	55                   	push   %rbp
  80324f:	48 89 e5             	mov    %rsp,%rbp
  803252:	48 83 ec 50          	sub    $0x50,%rsp
  803256:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803259:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80325d:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803261:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803268:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803269:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803270:	eb 33                	jmp    8032a5 <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803272:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803275:	48 98                	cltq   
  803277:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80327e:	00 
  80327f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803283:	48 01 d0             	add    %rdx,%rax
  803286:	48 8b 00             	mov    (%rax),%rax
  803289:	48 89 c7             	mov    %rax,%rdi
  80328c:	48 b8 92 10 80 00 00 	movabs $0x801092,%rax
  803293:	00 00 00 
  803296:	ff d0                	callq  *%rax
  803298:	83 c0 01             	add    $0x1,%eax
  80329b:	48 98                	cltq   
  80329d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	for (argc = 0; argv[argc] != 0; argc++)
  8032a1:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8032a5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032a8:	48 98                	cltq   
  8032aa:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8032b1:	00 
  8032b2:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8032b6:	48 01 d0             	add    %rdx,%rax
  8032b9:	48 8b 00             	mov    (%rax),%rax
  8032bc:	48 85 c0             	test   %rax,%rax
  8032bf:	75 b1                	jne    803272 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8032c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032c5:	48 f7 d8             	neg    %rax
  8032c8:	48 05 00 10 40 00    	add    $0x401000,%rax
  8032ce:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8032d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032d6:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8032da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032de:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  8032e2:	48 89 c2             	mov    %rax,%rdx
  8032e5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032e8:	83 c0 01             	add    $0x1,%eax
  8032eb:	c1 e0 03             	shl    $0x3,%eax
  8032ee:	48 98                	cltq   
  8032f0:	48 f7 d8             	neg    %rax
  8032f3:	48 01 d0             	add    %rdx,%rax
  8032f6:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8032fa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032fe:	48 83 e8 10          	sub    $0x10,%rax
  803302:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803308:	77 0a                	ja     803314 <init_stack+0xc6>
		return -E_NO_MEM;
  80330a:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  80330f:	e9 e4 01 00 00       	jmpq   8034f8 <init_stack+0x2aa>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803314:	ba 07 00 00 00       	mov    $0x7,%edx
  803319:	be 00 00 40 00       	mov    $0x400000,%esi
  80331e:	bf 00 00 00 00       	mov    $0x0,%edi
  803323:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  80332a:	00 00 00 
  80332d:	ff d0                	callq  *%rax
  80332f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803332:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803336:	79 08                	jns    803340 <init_stack+0xf2>
		return r;
  803338:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80333b:	e9 b8 01 00 00       	jmpq   8034f8 <init_stack+0x2aa>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_rsp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803340:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803347:	e9 8a 00 00 00       	jmpq   8033d6 <init_stack+0x188>
		argv_store[i] = UTEMP2USTACK(string_store);
  80334c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80334f:	48 98                	cltq   
  803351:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803358:	00 
  803359:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80335d:	48 01 d0             	add    %rdx,%rax
  803360:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803365:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803369:	48 01 ca             	add    %rcx,%rdx
  80336c:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  803373:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  803376:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803379:	48 98                	cltq   
  80337b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803382:	00 
  803383:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803387:	48 01 d0             	add    %rdx,%rax
  80338a:	48 8b 10             	mov    (%rax),%rdx
  80338d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803391:	48 89 d6             	mov    %rdx,%rsi
  803394:	48 89 c7             	mov    %rax,%rdi
  803397:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  80339e:	00 00 00 
  8033a1:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  8033a3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033a6:	48 98                	cltq   
  8033a8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8033af:	00 
  8033b0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8033b4:	48 01 d0             	add    %rdx,%rax
  8033b7:	48 8b 00             	mov    (%rax),%rax
  8033ba:	48 89 c7             	mov    %rax,%rdi
  8033bd:	48 b8 92 10 80 00 00 	movabs $0x801092,%rax
  8033c4:	00 00 00 
  8033c7:	ff d0                	callq  *%rax
  8033c9:	83 c0 01             	add    $0x1,%eax
  8033cc:	48 98                	cltq   
  8033ce:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	for (i = 0; i < argc; i++) {
  8033d2:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8033d6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033d9:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8033dc:	0f 8c 6a ff ff ff    	jl     80334c <init_stack+0xfe>
	}
	argv_store[argc] = 0;
  8033e2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033e5:	48 98                	cltq   
  8033e7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8033ee:	00 
  8033ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033f3:	48 01 d0             	add    %rdx,%rax
  8033f6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8033fd:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803404:	00 
  803405:	74 35                	je     80343c <init_stack+0x1ee>
  803407:	48 b9 08 53 80 00 00 	movabs $0x805308,%rcx
  80340e:	00 00 00 
  803411:	48 ba 2e 53 80 00 00 	movabs $0x80532e,%rdx
  803418:	00 00 00 
  80341b:	be f1 00 00 00       	mov    $0xf1,%esi
  803420:	48 bf c8 52 80 00 00 	movabs $0x8052c8,%rdi
  803427:	00 00 00 
  80342a:	b8 00 00 00 00       	mov    $0x0,%eax
  80342f:	49 b8 2b 03 80 00 00 	movabs $0x80032b,%r8
  803436:	00 00 00 
  803439:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80343c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803440:	48 83 e8 08          	sub    $0x8,%rax
  803444:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803449:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80344d:	48 01 ca             	add    %rcx,%rdx
  803450:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  803457:	48 89 10             	mov    %rdx,(%rax)
	argv_store[-2] = argc;
  80345a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80345e:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803462:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803465:	48 98                	cltq   
  803467:	48 89 02             	mov    %rax,(%rdx)

	*init_rsp = UTEMP2USTACK(&argv_store[-2]);
  80346a:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  80346f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803473:	48 01 d0             	add    %rdx,%rax
  803476:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80347c:	48 89 c2             	mov    %rax,%rdx
  80347f:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803483:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803486:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803489:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80348f:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803494:	89 c2                	mov    %eax,%edx
  803496:	be 00 00 40 00       	mov    $0x400000,%esi
  80349b:	bf 00 00 00 00       	mov    $0x0,%edi
  8034a0:	48 b8 7d 1a 80 00 00 	movabs $0x801a7d,%rax
  8034a7:	00 00 00 
  8034aa:	ff d0                	callq  *%rax
  8034ac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034af:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034b3:	79 02                	jns    8034b7 <init_stack+0x269>
		goto error;
  8034b5:	eb 28                	jmp    8034df <init_stack+0x291>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8034b7:	be 00 00 40 00       	mov    $0x400000,%esi
  8034bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8034c1:	48 b8 dd 1a 80 00 00 	movabs $0x801add,%rax
  8034c8:	00 00 00 
  8034cb:	ff d0                	callq  *%rax
  8034cd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034d4:	79 02                	jns    8034d8 <init_stack+0x28a>
		goto error;
  8034d6:	eb 07                	jmp    8034df <init_stack+0x291>

	return 0;
  8034d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8034dd:	eb 19                	jmp    8034f8 <init_stack+0x2aa>

error:
	sys_page_unmap(0, UTEMP);
  8034df:	be 00 00 40 00       	mov    $0x400000,%esi
  8034e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8034e9:	48 b8 dd 1a 80 00 00 	movabs $0x801add,%rax
  8034f0:	00 00 00 
  8034f3:	ff d0                	callq  *%rax
	return r;
  8034f5:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8034f8:	c9                   	leaveq 
  8034f9:	c3                   	retq   

00000000008034fa <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  8034fa:	55                   	push   %rbp
  8034fb:	48 89 e5             	mov    %rsp,%rbp
  8034fe:	48 83 ec 50          	sub    $0x50,%rsp
  803502:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803505:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803509:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  80350d:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803510:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803514:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803518:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80351c:	25 ff 0f 00 00       	and    $0xfff,%eax
  803521:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803524:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803528:	74 21                	je     80354b <map_segment+0x51>
		va -= i;
  80352a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80352d:	48 98                	cltq   
  80352f:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803533:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803536:	48 98                	cltq   
  803538:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  80353c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80353f:	48 98                	cltq   
  803541:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803545:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803548:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80354b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803552:	e9 79 01 00 00       	jmpq   8036d0 <map_segment+0x1d6>
		if (i >= filesz) {
  803557:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80355a:	48 98                	cltq   
  80355c:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803560:	72 3c                	jb     80359e <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803562:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803565:	48 63 d0             	movslq %eax,%rdx
  803568:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80356c:	48 01 d0             	add    %rdx,%rax
  80356f:	48 89 c1             	mov    %rax,%rcx
  803572:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803575:	8b 55 10             	mov    0x10(%rbp),%edx
  803578:	48 89 ce             	mov    %rcx,%rsi
  80357b:	89 c7                	mov    %eax,%edi
  80357d:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  803584:	00 00 00 
  803587:	ff d0                	callq  *%rax
  803589:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80358c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803590:	0f 89 33 01 00 00    	jns    8036c9 <map_segment+0x1cf>
				return r;
  803596:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803599:	e9 46 01 00 00       	jmpq   8036e4 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80359e:	ba 07 00 00 00       	mov    $0x7,%edx
  8035a3:	be 00 00 40 00       	mov    $0x400000,%esi
  8035a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8035ad:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  8035b4:	00 00 00 
  8035b7:	ff d0                	callq  *%rax
  8035b9:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8035bc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8035c0:	79 08                	jns    8035ca <map_segment+0xd0>
				return r;
  8035c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035c5:	e9 1a 01 00 00       	jmpq   8036e4 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  8035ca:	8b 55 bc             	mov    -0x44(%rbp),%edx
  8035cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035d0:	01 c2                	add    %eax,%edx
  8035d2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8035d5:	89 d6                	mov    %edx,%esi
  8035d7:	89 c7                	mov    %eax,%edi
  8035d9:	48 b8 ab 25 80 00 00 	movabs $0x8025ab,%rax
  8035e0:	00 00 00 
  8035e3:	ff d0                	callq  *%rax
  8035e5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8035e8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8035ec:	79 08                	jns    8035f6 <map_segment+0xfc>
				return r;
  8035ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035f1:	e9 ee 00 00 00       	jmpq   8036e4 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8035f6:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  8035fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803600:	48 98                	cltq   
  803602:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803606:	48 29 c2             	sub    %rax,%rdx
  803609:	48 89 d0             	mov    %rdx,%rax
  80360c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803610:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803613:	48 63 d0             	movslq %eax,%rdx
  803616:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80361a:	48 39 c2             	cmp    %rax,%rdx
  80361d:	48 0f 47 d0          	cmova  %rax,%rdx
  803621:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803624:	be 00 00 40 00       	mov    $0x400000,%esi
  803629:	89 c7                	mov    %eax,%edi
  80362b:	48 b8 62 24 80 00 00 	movabs $0x802462,%rax
  803632:	00 00 00 
  803635:	ff d0                	callq  *%rax
  803637:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80363a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80363e:	79 08                	jns    803648 <map_segment+0x14e>
				return r;
  803640:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803643:	e9 9c 00 00 00       	jmpq   8036e4 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803648:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80364b:	48 63 d0             	movslq %eax,%rdx
  80364e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803652:	48 01 d0             	add    %rdx,%rax
  803655:	48 89 c2             	mov    %rax,%rdx
  803658:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80365b:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  80365f:	48 89 d1             	mov    %rdx,%rcx
  803662:	89 c2                	mov    %eax,%edx
  803664:	be 00 00 40 00       	mov    $0x400000,%esi
  803669:	bf 00 00 00 00       	mov    $0x0,%edi
  80366e:	48 b8 7d 1a 80 00 00 	movabs $0x801a7d,%rax
  803675:	00 00 00 
  803678:	ff d0                	callq  *%rax
  80367a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80367d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803681:	79 30                	jns    8036b3 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803683:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803686:	89 c1                	mov    %eax,%ecx
  803688:	48 ba 43 53 80 00 00 	movabs $0x805343,%rdx
  80368f:	00 00 00 
  803692:	be 24 01 00 00       	mov    $0x124,%esi
  803697:	48 bf c8 52 80 00 00 	movabs $0x8052c8,%rdi
  80369e:	00 00 00 
  8036a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8036a6:	49 b8 2b 03 80 00 00 	movabs $0x80032b,%r8
  8036ad:	00 00 00 
  8036b0:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  8036b3:	be 00 00 40 00       	mov    $0x400000,%esi
  8036b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8036bd:	48 b8 dd 1a 80 00 00 	movabs $0x801add,%rax
  8036c4:	00 00 00 
  8036c7:	ff d0                	callq  *%rax
	for (i = 0; i < memsz; i += PGSIZE) {
  8036c9:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  8036d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036d3:	48 98                	cltq   
  8036d5:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8036d9:	0f 82 78 fe ff ff    	jb     803557 <map_segment+0x5d>
		}
	}
	return 0;
  8036df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036e4:	c9                   	leaveq 
  8036e5:	c3                   	retq   

00000000008036e6 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  8036e6:	55                   	push   %rbp
  8036e7:	48 89 e5             	mov    %rsp,%rbp
  8036ea:	48 83 ec 08          	sub    $0x8,%rsp
  8036ee:	89 7d fc             	mov    %edi,-0x4(%rbp)
	// LAB 5: Your code here.
	return 0;
  8036f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036f6:	c9                   	leaveq 
  8036f7:	c3                   	retq   

00000000008036f8 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8036f8:	55                   	push   %rbp
  8036f9:	48 89 e5             	mov    %rsp,%rbp
  8036fc:	48 83 ec 20          	sub    $0x20,%rsp
  803700:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803703:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803707:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80370a:	48 89 d6             	mov    %rdx,%rsi
  80370d:	89 c7                	mov    %eax,%edi
  80370f:	48 b8 59 1f 80 00 00 	movabs $0x801f59,%rax
  803716:	00 00 00 
  803719:	ff d0                	callq  *%rax
  80371b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80371e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803722:	79 05                	jns    803729 <fd2sockid+0x31>
		return r;
  803724:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803727:	eb 24                	jmp    80374d <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803729:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80372d:	8b 10                	mov    (%rax),%edx
  80372f:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803736:	00 00 00 
  803739:	8b 00                	mov    (%rax),%eax
  80373b:	39 c2                	cmp    %eax,%edx
  80373d:	74 07                	je     803746 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80373f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803744:	eb 07                	jmp    80374d <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803746:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80374a:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80374d:	c9                   	leaveq 
  80374e:	c3                   	retq   

000000000080374f <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80374f:	55                   	push   %rbp
  803750:	48 89 e5             	mov    %rsp,%rbp
  803753:	48 83 ec 20          	sub    $0x20,%rsp
  803757:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80375a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80375e:	48 89 c7             	mov    %rax,%rdi
  803761:	48 b8 c1 1e 80 00 00 	movabs $0x801ec1,%rax
  803768:	00 00 00 
  80376b:	ff d0                	callq  *%rax
  80376d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803770:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803774:	78 26                	js     80379c <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803776:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80377a:	ba 07 04 00 00       	mov    $0x407,%edx
  80377f:	48 89 c6             	mov    %rax,%rsi
  803782:	bf 00 00 00 00       	mov    $0x0,%edi
  803787:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  80378e:	00 00 00 
  803791:	ff d0                	callq  *%rax
  803793:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803796:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80379a:	79 16                	jns    8037b2 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  80379c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80379f:	89 c7                	mov    %eax,%edi
  8037a1:	48 b8 5e 3c 80 00 00 	movabs $0x803c5e,%rax
  8037a8:	00 00 00 
  8037ab:	ff d0                	callq  *%rax
		return r;
  8037ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037b0:	eb 3a                	jmp    8037ec <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8037b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037b6:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8037bd:	00 00 00 
  8037c0:	8b 12                	mov    (%rdx),%edx
  8037c2:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8037c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8037cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037d3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8037d6:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8037d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037dd:	48 89 c7             	mov    %rax,%rdi
  8037e0:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  8037e7:	00 00 00 
  8037ea:	ff d0                	callq  *%rax
}
  8037ec:	c9                   	leaveq 
  8037ed:	c3                   	retq   

00000000008037ee <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8037ee:	55                   	push   %rbp
  8037ef:	48 89 e5             	mov    %rsp,%rbp
  8037f2:	48 83 ec 30          	sub    $0x30,%rsp
  8037f6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037f9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037fd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803801:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803804:	89 c7                	mov    %eax,%edi
  803806:	48 b8 f8 36 80 00 00 	movabs $0x8036f8,%rax
  80380d:	00 00 00 
  803810:	ff d0                	callq  *%rax
  803812:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803815:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803819:	79 05                	jns    803820 <accept+0x32>
		return r;
  80381b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80381e:	eb 3b                	jmp    80385b <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803820:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803824:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803828:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80382b:	48 89 ce             	mov    %rcx,%rsi
  80382e:	89 c7                	mov    %eax,%edi
  803830:	48 b8 3b 3b 80 00 00 	movabs $0x803b3b,%rax
  803837:	00 00 00 
  80383a:	ff d0                	callq  *%rax
  80383c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80383f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803843:	79 05                	jns    80384a <accept+0x5c>
		return r;
  803845:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803848:	eb 11                	jmp    80385b <accept+0x6d>
	return alloc_sockfd(r);
  80384a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80384d:	89 c7                	mov    %eax,%edi
  80384f:	48 b8 4f 37 80 00 00 	movabs $0x80374f,%rax
  803856:	00 00 00 
  803859:	ff d0                	callq  *%rax
}
  80385b:	c9                   	leaveq 
  80385c:	c3                   	retq   

000000000080385d <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80385d:	55                   	push   %rbp
  80385e:	48 89 e5             	mov    %rsp,%rbp
  803861:	48 83 ec 20          	sub    $0x20,%rsp
  803865:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803868:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80386c:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80386f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803872:	89 c7                	mov    %eax,%edi
  803874:	48 b8 f8 36 80 00 00 	movabs $0x8036f8,%rax
  80387b:	00 00 00 
  80387e:	ff d0                	callq  *%rax
  803880:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803883:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803887:	79 05                	jns    80388e <bind+0x31>
		return r;
  803889:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80388c:	eb 1b                	jmp    8038a9 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80388e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803891:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803895:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803898:	48 89 ce             	mov    %rcx,%rsi
  80389b:	89 c7                	mov    %eax,%edi
  80389d:	48 b8 ba 3b 80 00 00 	movabs $0x803bba,%rax
  8038a4:	00 00 00 
  8038a7:	ff d0                	callq  *%rax
}
  8038a9:	c9                   	leaveq 
  8038aa:	c3                   	retq   

00000000008038ab <shutdown>:

int
shutdown(int s, int how)
{
  8038ab:	55                   	push   %rbp
  8038ac:	48 89 e5             	mov    %rsp,%rbp
  8038af:	48 83 ec 20          	sub    $0x20,%rsp
  8038b3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038b6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038bc:	89 c7                	mov    %eax,%edi
  8038be:	48 b8 f8 36 80 00 00 	movabs $0x8036f8,%rax
  8038c5:	00 00 00 
  8038c8:	ff d0                	callq  *%rax
  8038ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038d1:	79 05                	jns    8038d8 <shutdown+0x2d>
		return r;
  8038d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d6:	eb 16                	jmp    8038ee <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8038d8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8038db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038de:	89 d6                	mov    %edx,%esi
  8038e0:	89 c7                	mov    %eax,%edi
  8038e2:	48 b8 1e 3c 80 00 00 	movabs $0x803c1e,%rax
  8038e9:	00 00 00 
  8038ec:	ff d0                	callq  *%rax
}
  8038ee:	c9                   	leaveq 
  8038ef:	c3                   	retq   

00000000008038f0 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8038f0:	55                   	push   %rbp
  8038f1:	48 89 e5             	mov    %rsp,%rbp
  8038f4:	48 83 ec 10          	sub    $0x10,%rsp
  8038f8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8038fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803900:	48 89 c7             	mov    %rax,%rdi
  803903:	48 b8 52 4a 80 00 00 	movabs $0x804a52,%rax
  80390a:	00 00 00 
  80390d:	ff d0                	callq  *%rax
  80390f:	83 f8 01             	cmp    $0x1,%eax
  803912:	75 17                	jne    80392b <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803914:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803918:	8b 40 0c             	mov    0xc(%rax),%eax
  80391b:	89 c7                	mov    %eax,%edi
  80391d:	48 b8 5e 3c 80 00 00 	movabs $0x803c5e,%rax
  803924:	00 00 00 
  803927:	ff d0                	callq  *%rax
  803929:	eb 05                	jmp    803930 <devsock_close+0x40>
	else
		return 0;
  80392b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803930:	c9                   	leaveq 
  803931:	c3                   	retq   

0000000000803932 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803932:	55                   	push   %rbp
  803933:	48 89 e5             	mov    %rsp,%rbp
  803936:	48 83 ec 20          	sub    $0x20,%rsp
  80393a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80393d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803941:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803944:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803947:	89 c7                	mov    %eax,%edi
  803949:	48 b8 f8 36 80 00 00 	movabs $0x8036f8,%rax
  803950:	00 00 00 
  803953:	ff d0                	callq  *%rax
  803955:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803958:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80395c:	79 05                	jns    803963 <connect+0x31>
		return r;
  80395e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803961:	eb 1b                	jmp    80397e <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803963:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803966:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80396a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80396d:	48 89 ce             	mov    %rcx,%rsi
  803970:	89 c7                	mov    %eax,%edi
  803972:	48 b8 8b 3c 80 00 00 	movabs $0x803c8b,%rax
  803979:	00 00 00 
  80397c:	ff d0                	callq  *%rax
}
  80397e:	c9                   	leaveq 
  80397f:	c3                   	retq   

0000000000803980 <listen>:

int
listen(int s, int backlog)
{
  803980:	55                   	push   %rbp
  803981:	48 89 e5             	mov    %rsp,%rbp
  803984:	48 83 ec 20          	sub    $0x20,%rsp
  803988:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80398b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80398e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803991:	89 c7                	mov    %eax,%edi
  803993:	48 b8 f8 36 80 00 00 	movabs $0x8036f8,%rax
  80399a:	00 00 00 
  80399d:	ff d0                	callq  *%rax
  80399f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039a6:	79 05                	jns    8039ad <listen+0x2d>
		return r;
  8039a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039ab:	eb 16                	jmp    8039c3 <listen+0x43>
	return nsipc_listen(r, backlog);
  8039ad:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8039b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039b3:	89 d6                	mov    %edx,%esi
  8039b5:	89 c7                	mov    %eax,%edi
  8039b7:	48 b8 ef 3c 80 00 00 	movabs $0x803cef,%rax
  8039be:	00 00 00 
  8039c1:	ff d0                	callq  *%rax
}
  8039c3:	c9                   	leaveq 
  8039c4:	c3                   	retq   

00000000008039c5 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8039c5:	55                   	push   %rbp
  8039c6:	48 89 e5             	mov    %rsp,%rbp
  8039c9:	48 83 ec 20          	sub    $0x20,%rsp
  8039cd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8039d1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039d5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8039d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039dd:	89 c2                	mov    %eax,%edx
  8039df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039e3:	8b 40 0c             	mov    0xc(%rax),%eax
  8039e6:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8039ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8039ef:	89 c7                	mov    %eax,%edi
  8039f1:	48 b8 2f 3d 80 00 00 	movabs $0x803d2f,%rax
  8039f8:	00 00 00 
  8039fb:	ff d0                	callq  *%rax
}
  8039fd:	c9                   	leaveq 
  8039fe:	c3                   	retq   

00000000008039ff <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8039ff:	55                   	push   %rbp
  803a00:	48 89 e5             	mov    %rsp,%rbp
  803a03:	48 83 ec 20          	sub    $0x20,%rsp
  803a07:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a0b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a0f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803a13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a17:	89 c2                	mov    %eax,%edx
  803a19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a1d:	8b 40 0c             	mov    0xc(%rax),%eax
  803a20:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803a24:	b9 00 00 00 00       	mov    $0x0,%ecx
  803a29:	89 c7                	mov    %eax,%edi
  803a2b:	48 b8 fb 3d 80 00 00 	movabs $0x803dfb,%rax
  803a32:	00 00 00 
  803a35:	ff d0                	callq  *%rax
}
  803a37:	c9                   	leaveq 
  803a38:	c3                   	retq   

0000000000803a39 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803a39:	55                   	push   %rbp
  803a3a:	48 89 e5             	mov    %rsp,%rbp
  803a3d:	48 83 ec 10          	sub    $0x10,%rsp
  803a41:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a45:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803a49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a4d:	48 be 65 53 80 00 00 	movabs $0x805365,%rsi
  803a54:	00 00 00 
  803a57:	48 89 c7             	mov    %rax,%rdi
  803a5a:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  803a61:	00 00 00 
  803a64:	ff d0                	callq  *%rax
	return 0;
  803a66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a6b:	c9                   	leaveq 
  803a6c:	c3                   	retq   

0000000000803a6d <socket>:

int
socket(int domain, int type, int protocol)
{
  803a6d:	55                   	push   %rbp
  803a6e:	48 89 e5             	mov    %rsp,%rbp
  803a71:	48 83 ec 20          	sub    $0x20,%rsp
  803a75:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a78:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803a7b:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803a7e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803a81:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803a84:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a87:	89 ce                	mov    %ecx,%esi
  803a89:	89 c7                	mov    %eax,%edi
  803a8b:	48 b8 b3 3e 80 00 00 	movabs $0x803eb3,%rax
  803a92:	00 00 00 
  803a95:	ff d0                	callq  *%rax
  803a97:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a9e:	79 05                	jns    803aa5 <socket+0x38>
		return r;
  803aa0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aa3:	eb 11                	jmp    803ab6 <socket+0x49>
	return alloc_sockfd(r);
  803aa5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aa8:	89 c7                	mov    %eax,%edi
  803aaa:	48 b8 4f 37 80 00 00 	movabs $0x80374f,%rax
  803ab1:	00 00 00 
  803ab4:	ff d0                	callq  *%rax
}
  803ab6:	c9                   	leaveq 
  803ab7:	c3                   	retq   

0000000000803ab8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803ab8:	55                   	push   %rbp
  803ab9:	48 89 e5             	mov    %rsp,%rbp
  803abc:	48 83 ec 10          	sub    $0x10,%rsp
  803ac0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803ac3:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803aca:	00 00 00 
  803acd:	8b 00                	mov    (%rax),%eax
  803acf:	85 c0                	test   %eax,%eax
  803ad1:	75 1f                	jne    803af2 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803ad3:	bf 02 00 00 00       	mov    $0x2,%edi
  803ad8:	48 b8 e0 49 80 00 00 	movabs $0x8049e0,%rax
  803adf:	00 00 00 
  803ae2:	ff d0                	callq  *%rax
  803ae4:	89 c2                	mov    %eax,%edx
  803ae6:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803aed:	00 00 00 
  803af0:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803af2:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803af9:	00 00 00 
  803afc:	8b 00                	mov    (%rax),%eax
  803afe:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803b01:	b9 07 00 00 00       	mov    $0x7,%ecx
  803b06:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803b0d:	00 00 00 
  803b10:	89 c7                	mov    %eax,%edi
  803b12:	48 b8 53 48 80 00 00 	movabs $0x804853,%rax
  803b19:	00 00 00 
  803b1c:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803b1e:	ba 00 00 00 00       	mov    $0x0,%edx
  803b23:	be 00 00 00 00       	mov    $0x0,%esi
  803b28:	bf 00 00 00 00       	mov    $0x0,%edi
  803b2d:	48 b8 15 48 80 00 00 	movabs $0x804815,%rax
  803b34:	00 00 00 
  803b37:	ff d0                	callq  *%rax
}
  803b39:	c9                   	leaveq 
  803b3a:	c3                   	retq   

0000000000803b3b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803b3b:	55                   	push   %rbp
  803b3c:	48 89 e5             	mov    %rsp,%rbp
  803b3f:	48 83 ec 30          	sub    $0x30,%rsp
  803b43:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b46:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b4a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803b4e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b55:	00 00 00 
  803b58:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b5b:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803b5d:	bf 01 00 00 00       	mov    $0x1,%edi
  803b62:	48 b8 b8 3a 80 00 00 	movabs $0x803ab8,%rax
  803b69:	00 00 00 
  803b6c:	ff d0                	callq  *%rax
  803b6e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b75:	78 3e                	js     803bb5 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803b77:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b7e:	00 00 00 
  803b81:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803b85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b89:	8b 40 10             	mov    0x10(%rax),%eax
  803b8c:	89 c2                	mov    %eax,%edx
  803b8e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803b92:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b96:	48 89 ce             	mov    %rcx,%rsi
  803b99:	48 89 c7             	mov    %rax,%rdi
  803b9c:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  803ba3:	00 00 00 
  803ba6:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803ba8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bac:	8b 50 10             	mov    0x10(%rax),%edx
  803baf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bb3:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803bb5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803bb8:	c9                   	leaveq 
  803bb9:	c3                   	retq   

0000000000803bba <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803bba:	55                   	push   %rbp
  803bbb:	48 89 e5             	mov    %rsp,%rbp
  803bbe:	48 83 ec 10          	sub    $0x10,%rsp
  803bc2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803bc5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803bc9:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803bcc:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bd3:	00 00 00 
  803bd6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bd9:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803bdb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803be2:	48 89 c6             	mov    %rax,%rsi
  803be5:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803bec:	00 00 00 
  803bef:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  803bf6:	00 00 00 
  803bf9:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803bfb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c02:	00 00 00 
  803c05:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c08:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803c0b:	bf 02 00 00 00       	mov    $0x2,%edi
  803c10:	48 b8 b8 3a 80 00 00 	movabs $0x803ab8,%rax
  803c17:	00 00 00 
  803c1a:	ff d0                	callq  *%rax
}
  803c1c:	c9                   	leaveq 
  803c1d:	c3                   	retq   

0000000000803c1e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803c1e:	55                   	push   %rbp
  803c1f:	48 89 e5             	mov    %rsp,%rbp
  803c22:	48 83 ec 10          	sub    $0x10,%rsp
  803c26:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c29:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803c2c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c33:	00 00 00 
  803c36:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c39:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803c3b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c42:	00 00 00 
  803c45:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c48:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803c4b:	bf 03 00 00 00       	mov    $0x3,%edi
  803c50:	48 b8 b8 3a 80 00 00 	movabs $0x803ab8,%rax
  803c57:	00 00 00 
  803c5a:	ff d0                	callq  *%rax
}
  803c5c:	c9                   	leaveq 
  803c5d:	c3                   	retq   

0000000000803c5e <nsipc_close>:

int
nsipc_close(int s)
{
  803c5e:	55                   	push   %rbp
  803c5f:	48 89 e5             	mov    %rsp,%rbp
  803c62:	48 83 ec 10          	sub    $0x10,%rsp
  803c66:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803c69:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c70:	00 00 00 
  803c73:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c76:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803c78:	bf 04 00 00 00       	mov    $0x4,%edi
  803c7d:	48 b8 b8 3a 80 00 00 	movabs $0x803ab8,%rax
  803c84:	00 00 00 
  803c87:	ff d0                	callq  *%rax
}
  803c89:	c9                   	leaveq 
  803c8a:	c3                   	retq   

0000000000803c8b <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803c8b:	55                   	push   %rbp
  803c8c:	48 89 e5             	mov    %rsp,%rbp
  803c8f:	48 83 ec 10          	sub    $0x10,%rsp
  803c93:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c96:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c9a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803c9d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ca4:	00 00 00 
  803ca7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803caa:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803cac:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803caf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cb3:	48 89 c6             	mov    %rax,%rsi
  803cb6:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803cbd:	00 00 00 
  803cc0:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  803cc7:	00 00 00 
  803cca:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803ccc:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cd3:	00 00 00 
  803cd6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cd9:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803cdc:	bf 05 00 00 00       	mov    $0x5,%edi
  803ce1:	48 b8 b8 3a 80 00 00 	movabs $0x803ab8,%rax
  803ce8:	00 00 00 
  803ceb:	ff d0                	callq  *%rax
}
  803ced:	c9                   	leaveq 
  803cee:	c3                   	retq   

0000000000803cef <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803cef:	55                   	push   %rbp
  803cf0:	48 89 e5             	mov    %rsp,%rbp
  803cf3:	48 83 ec 10          	sub    $0x10,%rsp
  803cf7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803cfa:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803cfd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d04:	00 00 00 
  803d07:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d0a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803d0c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d13:	00 00 00 
  803d16:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d19:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803d1c:	bf 06 00 00 00       	mov    $0x6,%edi
  803d21:	48 b8 b8 3a 80 00 00 	movabs $0x803ab8,%rax
  803d28:	00 00 00 
  803d2b:	ff d0                	callq  *%rax
}
  803d2d:	c9                   	leaveq 
  803d2e:	c3                   	retq   

0000000000803d2f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803d2f:	55                   	push   %rbp
  803d30:	48 89 e5             	mov    %rsp,%rbp
  803d33:	48 83 ec 30          	sub    $0x30,%rsp
  803d37:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d3a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d3e:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803d41:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803d44:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d4b:	00 00 00 
  803d4e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803d51:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803d53:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d5a:	00 00 00 
  803d5d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803d60:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803d63:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d6a:	00 00 00 
  803d6d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803d70:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803d73:	bf 07 00 00 00       	mov    $0x7,%edi
  803d78:	48 b8 b8 3a 80 00 00 	movabs $0x803ab8,%rax
  803d7f:	00 00 00 
  803d82:	ff d0                	callq  *%rax
  803d84:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d87:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d8b:	78 69                	js     803df6 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803d8d:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803d94:	7f 08                	jg     803d9e <nsipc_recv+0x6f>
  803d96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d99:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803d9c:	7e 35                	jle    803dd3 <nsipc_recv+0xa4>
  803d9e:	48 b9 6c 53 80 00 00 	movabs $0x80536c,%rcx
  803da5:	00 00 00 
  803da8:	48 ba 81 53 80 00 00 	movabs $0x805381,%rdx
  803daf:	00 00 00 
  803db2:	be 61 00 00 00       	mov    $0x61,%esi
  803db7:	48 bf 96 53 80 00 00 	movabs $0x805396,%rdi
  803dbe:	00 00 00 
  803dc1:	b8 00 00 00 00       	mov    $0x0,%eax
  803dc6:	49 b8 2b 03 80 00 00 	movabs $0x80032b,%r8
  803dcd:	00 00 00 
  803dd0:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803dd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dd6:	48 63 d0             	movslq %eax,%rdx
  803dd9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ddd:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803de4:	00 00 00 
  803de7:	48 89 c7             	mov    %rax,%rdi
  803dea:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  803df1:	00 00 00 
  803df4:	ff d0                	callq  *%rax
	}

	return r;
  803df6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803df9:	c9                   	leaveq 
  803dfa:	c3                   	retq   

0000000000803dfb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803dfb:	55                   	push   %rbp
  803dfc:	48 89 e5             	mov    %rsp,%rbp
  803dff:	48 83 ec 20          	sub    $0x20,%rsp
  803e03:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e06:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803e0a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803e0d:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803e10:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e17:	00 00 00 
  803e1a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e1d:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803e1f:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803e26:	7e 35                	jle    803e5d <nsipc_send+0x62>
  803e28:	48 b9 a2 53 80 00 00 	movabs $0x8053a2,%rcx
  803e2f:	00 00 00 
  803e32:	48 ba 81 53 80 00 00 	movabs $0x805381,%rdx
  803e39:	00 00 00 
  803e3c:	be 6c 00 00 00       	mov    $0x6c,%esi
  803e41:	48 bf 96 53 80 00 00 	movabs $0x805396,%rdi
  803e48:	00 00 00 
  803e4b:	b8 00 00 00 00       	mov    $0x0,%eax
  803e50:	49 b8 2b 03 80 00 00 	movabs $0x80032b,%r8
  803e57:	00 00 00 
  803e5a:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803e5d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e60:	48 63 d0             	movslq %eax,%rdx
  803e63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e67:	48 89 c6             	mov    %rax,%rsi
  803e6a:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803e71:	00 00 00 
  803e74:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  803e7b:	00 00 00 
  803e7e:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803e80:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e87:	00 00 00 
  803e8a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e8d:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803e90:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e97:	00 00 00 
  803e9a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803e9d:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803ea0:	bf 08 00 00 00       	mov    $0x8,%edi
  803ea5:	48 b8 b8 3a 80 00 00 	movabs $0x803ab8,%rax
  803eac:	00 00 00 
  803eaf:	ff d0                	callq  *%rax
}
  803eb1:	c9                   	leaveq 
  803eb2:	c3                   	retq   

0000000000803eb3 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803eb3:	55                   	push   %rbp
  803eb4:	48 89 e5             	mov    %rsp,%rbp
  803eb7:	48 83 ec 10          	sub    $0x10,%rsp
  803ebb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ebe:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803ec1:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803ec4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ecb:	00 00 00 
  803ece:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ed1:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803ed3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803eda:	00 00 00 
  803edd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ee0:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803ee3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803eea:	00 00 00 
  803eed:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803ef0:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803ef3:	bf 09 00 00 00       	mov    $0x9,%edi
  803ef8:	48 b8 b8 3a 80 00 00 	movabs $0x803ab8,%rax
  803eff:	00 00 00 
  803f02:	ff d0                	callq  *%rax
}
  803f04:	c9                   	leaveq 
  803f05:	c3                   	retq   

0000000000803f06 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803f06:	55                   	push   %rbp
  803f07:	48 89 e5             	mov    %rsp,%rbp
  803f0a:	53                   	push   %rbx
  803f0b:	48 83 ec 38          	sub    $0x38,%rsp
  803f0f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803f13:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803f17:	48 89 c7             	mov    %rax,%rdi
  803f1a:	48 b8 c1 1e 80 00 00 	movabs $0x801ec1,%rax
  803f21:	00 00 00 
  803f24:	ff d0                	callq  *%rax
  803f26:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f29:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f2d:	0f 88 bf 01 00 00    	js     8040f2 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f33:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f37:	ba 07 04 00 00       	mov    $0x407,%edx
  803f3c:	48 89 c6             	mov    %rax,%rsi
  803f3f:	bf 00 00 00 00       	mov    $0x0,%edi
  803f44:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  803f4b:	00 00 00 
  803f4e:	ff d0                	callq  *%rax
  803f50:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f53:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f57:	0f 88 95 01 00 00    	js     8040f2 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803f5d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803f61:	48 89 c7             	mov    %rax,%rdi
  803f64:	48 b8 c1 1e 80 00 00 	movabs $0x801ec1,%rax
  803f6b:	00 00 00 
  803f6e:	ff d0                	callq  *%rax
  803f70:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f73:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f77:	0f 88 5d 01 00 00    	js     8040da <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f7d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f81:	ba 07 04 00 00       	mov    $0x407,%edx
  803f86:	48 89 c6             	mov    %rax,%rsi
  803f89:	bf 00 00 00 00       	mov    $0x0,%edi
  803f8e:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  803f95:	00 00 00 
  803f98:	ff d0                	callq  *%rax
  803f9a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f9d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fa1:	0f 88 33 01 00 00    	js     8040da <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803fa7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fab:	48 89 c7             	mov    %rax,%rdi
  803fae:	48 b8 96 1e 80 00 00 	movabs $0x801e96,%rax
  803fb5:	00 00 00 
  803fb8:	ff d0                	callq  *%rax
  803fba:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803fbe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fc2:	ba 07 04 00 00       	mov    $0x407,%edx
  803fc7:	48 89 c6             	mov    %rax,%rsi
  803fca:	bf 00 00 00 00       	mov    $0x0,%edi
  803fcf:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  803fd6:	00 00 00 
  803fd9:	ff d0                	callq  *%rax
  803fdb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803fde:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fe2:	79 05                	jns    803fe9 <pipe+0xe3>
		goto err2;
  803fe4:	e9 d9 00 00 00       	jmpq   8040c2 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803fe9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fed:	48 89 c7             	mov    %rax,%rdi
  803ff0:	48 b8 96 1e 80 00 00 	movabs $0x801e96,%rax
  803ff7:	00 00 00 
  803ffa:	ff d0                	callq  *%rax
  803ffc:	48 89 c2             	mov    %rax,%rdx
  803fff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804003:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804009:	48 89 d1             	mov    %rdx,%rcx
  80400c:	ba 00 00 00 00       	mov    $0x0,%edx
  804011:	48 89 c6             	mov    %rax,%rsi
  804014:	bf 00 00 00 00       	mov    $0x0,%edi
  804019:	48 b8 7d 1a 80 00 00 	movabs $0x801a7d,%rax
  804020:	00 00 00 
  804023:	ff d0                	callq  *%rax
  804025:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804028:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80402c:	79 1b                	jns    804049 <pipe+0x143>
		goto err3;
  80402e:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80402f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804033:	48 89 c6             	mov    %rax,%rsi
  804036:	bf 00 00 00 00       	mov    $0x0,%edi
  80403b:	48 b8 dd 1a 80 00 00 	movabs $0x801add,%rax
  804042:	00 00 00 
  804045:	ff d0                	callq  *%rax
  804047:	eb 79                	jmp    8040c2 <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  804049:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80404d:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804054:	00 00 00 
  804057:	8b 12                	mov    (%rdx),%edx
  804059:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80405b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80405f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  804066:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80406a:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804071:	00 00 00 
  804074:	8b 12                	mov    (%rdx),%edx
  804076:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804078:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80407c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  804083:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804087:	48 89 c7             	mov    %rax,%rdi
  80408a:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  804091:	00 00 00 
  804094:	ff d0                	callq  *%rax
  804096:	89 c2                	mov    %eax,%edx
  804098:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80409c:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80409e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8040a2:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8040a6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040aa:	48 89 c7             	mov    %rax,%rdi
  8040ad:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  8040b4:	00 00 00 
  8040b7:	ff d0                	callq  *%rax
  8040b9:	89 03                	mov    %eax,(%rbx)
	return 0;
  8040bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8040c0:	eb 33                	jmp    8040f5 <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  8040c2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040c6:	48 89 c6             	mov    %rax,%rsi
  8040c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8040ce:	48 b8 dd 1a 80 00 00 	movabs $0x801add,%rax
  8040d5:	00 00 00 
  8040d8:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8040da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040de:	48 89 c6             	mov    %rax,%rsi
  8040e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8040e6:	48 b8 dd 1a 80 00 00 	movabs $0x801add,%rax
  8040ed:	00 00 00 
  8040f0:	ff d0                	callq  *%rax
err:
	return r;
  8040f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8040f5:	48 83 c4 38          	add    $0x38,%rsp
  8040f9:	5b                   	pop    %rbx
  8040fa:	5d                   	pop    %rbp
  8040fb:	c3                   	retq   

00000000008040fc <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8040fc:	55                   	push   %rbp
  8040fd:	48 89 e5             	mov    %rsp,%rbp
  804100:	53                   	push   %rbx
  804101:	48 83 ec 28          	sub    $0x28,%rsp
  804105:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804109:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80410d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804114:	00 00 00 
  804117:	48 8b 00             	mov    (%rax),%rax
  80411a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804120:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804123:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804127:	48 89 c7             	mov    %rax,%rdi
  80412a:	48 b8 52 4a 80 00 00 	movabs $0x804a52,%rax
  804131:	00 00 00 
  804134:	ff d0                	callq  *%rax
  804136:	89 c3                	mov    %eax,%ebx
  804138:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80413c:	48 89 c7             	mov    %rax,%rdi
  80413f:	48 b8 52 4a 80 00 00 	movabs $0x804a52,%rax
  804146:	00 00 00 
  804149:	ff d0                	callq  *%rax
  80414b:	39 c3                	cmp    %eax,%ebx
  80414d:	0f 94 c0             	sete   %al
  804150:	0f b6 c0             	movzbl %al,%eax
  804153:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804156:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80415d:	00 00 00 
  804160:	48 8b 00             	mov    (%rax),%rax
  804163:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804169:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80416c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80416f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804172:	75 05                	jne    804179 <_pipeisclosed+0x7d>
			return ret;
  804174:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804177:	eb 4a                	jmp    8041c3 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  804179:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80417c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80417f:	74 3d                	je     8041be <_pipeisclosed+0xc2>
  804181:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804185:	75 37                	jne    8041be <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804187:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80418e:	00 00 00 
  804191:	48 8b 00             	mov    (%rax),%rax
  804194:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80419a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80419d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041a0:	89 c6                	mov    %eax,%esi
  8041a2:	48 bf b3 53 80 00 00 	movabs $0x8053b3,%rdi
  8041a9:	00 00 00 
  8041ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8041b1:	49 b8 64 05 80 00 00 	movabs $0x800564,%r8
  8041b8:	00 00 00 
  8041bb:	41 ff d0             	callq  *%r8
	}
  8041be:	e9 4a ff ff ff       	jmpq   80410d <_pipeisclosed+0x11>
}
  8041c3:	48 83 c4 28          	add    $0x28,%rsp
  8041c7:	5b                   	pop    %rbx
  8041c8:	5d                   	pop    %rbp
  8041c9:	c3                   	retq   

00000000008041ca <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8041ca:	55                   	push   %rbp
  8041cb:	48 89 e5             	mov    %rsp,%rbp
  8041ce:	48 83 ec 30          	sub    $0x30,%rsp
  8041d2:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8041d5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8041d9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8041dc:	48 89 d6             	mov    %rdx,%rsi
  8041df:	89 c7                	mov    %eax,%edi
  8041e1:	48 b8 59 1f 80 00 00 	movabs $0x801f59,%rax
  8041e8:	00 00 00 
  8041eb:	ff d0                	callq  *%rax
  8041ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041f4:	79 05                	jns    8041fb <pipeisclosed+0x31>
		return r;
  8041f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041f9:	eb 31                	jmp    80422c <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8041fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041ff:	48 89 c7             	mov    %rax,%rdi
  804202:	48 b8 96 1e 80 00 00 	movabs $0x801e96,%rax
  804209:	00 00 00 
  80420c:	ff d0                	callq  *%rax
  80420e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804212:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804216:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80421a:	48 89 d6             	mov    %rdx,%rsi
  80421d:	48 89 c7             	mov    %rax,%rdi
  804220:	48 b8 fc 40 80 00 00 	movabs $0x8040fc,%rax
  804227:	00 00 00 
  80422a:	ff d0                	callq  *%rax
}
  80422c:	c9                   	leaveq 
  80422d:	c3                   	retq   

000000000080422e <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80422e:	55                   	push   %rbp
  80422f:	48 89 e5             	mov    %rsp,%rbp
  804232:	48 83 ec 40          	sub    $0x40,%rsp
  804236:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80423a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80423e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804242:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804246:	48 89 c7             	mov    %rax,%rdi
  804249:	48 b8 96 1e 80 00 00 	movabs $0x801e96,%rax
  804250:	00 00 00 
  804253:	ff d0                	callq  *%rax
  804255:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804259:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80425d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804261:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804268:	00 
  804269:	e9 92 00 00 00       	jmpq   804300 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80426e:	eb 41                	jmp    8042b1 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804270:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804275:	74 09                	je     804280 <devpipe_read+0x52>
				return i;
  804277:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80427b:	e9 92 00 00 00       	jmpq   804312 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804280:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804284:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804288:	48 89 d6             	mov    %rdx,%rsi
  80428b:	48 89 c7             	mov    %rax,%rdi
  80428e:	48 b8 fc 40 80 00 00 	movabs $0x8040fc,%rax
  804295:	00 00 00 
  804298:	ff d0                	callq  *%rax
  80429a:	85 c0                	test   %eax,%eax
  80429c:	74 07                	je     8042a5 <devpipe_read+0x77>
				return 0;
  80429e:	b8 00 00 00 00       	mov    $0x0,%eax
  8042a3:	eb 6d                	jmp    804312 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8042a5:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  8042ac:	00 00 00 
  8042af:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  8042b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042b5:	8b 10                	mov    (%rax),%edx
  8042b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042bb:	8b 40 04             	mov    0x4(%rax),%eax
  8042be:	39 c2                	cmp    %eax,%edx
  8042c0:	74 ae                	je     804270 <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8042c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8042c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042ca:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8042ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042d2:	8b 00                	mov    (%rax),%eax
  8042d4:	99                   	cltd   
  8042d5:	c1 ea 1b             	shr    $0x1b,%edx
  8042d8:	01 d0                	add    %edx,%eax
  8042da:	83 e0 1f             	and    $0x1f,%eax
  8042dd:	29 d0                	sub    %edx,%eax
  8042df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042e3:	48 98                	cltq   
  8042e5:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8042ea:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8042ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042f0:	8b 00                	mov    (%rax),%eax
  8042f2:	8d 50 01             	lea    0x1(%rax),%edx
  8042f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042f9:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  8042fb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804300:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804304:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804308:	0f 82 60 ff ff ff    	jb     80426e <devpipe_read+0x40>
	}
	return i;
  80430e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804312:	c9                   	leaveq 
  804313:	c3                   	retq   

0000000000804314 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804314:	55                   	push   %rbp
  804315:	48 89 e5             	mov    %rsp,%rbp
  804318:	48 83 ec 40          	sub    $0x40,%rsp
  80431c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804320:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804324:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804328:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80432c:	48 89 c7             	mov    %rax,%rdi
  80432f:	48 b8 96 1e 80 00 00 	movabs $0x801e96,%rax
  804336:	00 00 00 
  804339:	ff d0                	callq  *%rax
  80433b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80433f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804343:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804347:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80434e:	00 
  80434f:	e9 91 00 00 00       	jmpq   8043e5 <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804354:	eb 31                	jmp    804387 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804356:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80435a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80435e:	48 89 d6             	mov    %rdx,%rsi
  804361:	48 89 c7             	mov    %rax,%rdi
  804364:	48 b8 fc 40 80 00 00 	movabs $0x8040fc,%rax
  80436b:	00 00 00 
  80436e:	ff d0                	callq  *%rax
  804370:	85 c0                	test   %eax,%eax
  804372:	74 07                	je     80437b <devpipe_write+0x67>
				return 0;
  804374:	b8 00 00 00 00       	mov    $0x0,%eax
  804379:	eb 7c                	jmp    8043f7 <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80437b:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  804382:	00 00 00 
  804385:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804387:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80438b:	8b 40 04             	mov    0x4(%rax),%eax
  80438e:	48 63 d0             	movslq %eax,%rdx
  804391:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804395:	8b 00                	mov    (%rax),%eax
  804397:	48 98                	cltq   
  804399:	48 83 c0 20          	add    $0x20,%rax
  80439d:	48 39 c2             	cmp    %rax,%rdx
  8043a0:	73 b4                	jae    804356 <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8043a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043a6:	8b 40 04             	mov    0x4(%rax),%eax
  8043a9:	99                   	cltd   
  8043aa:	c1 ea 1b             	shr    $0x1b,%edx
  8043ad:	01 d0                	add    %edx,%eax
  8043af:	83 e0 1f             	and    $0x1f,%eax
  8043b2:	29 d0                	sub    %edx,%eax
  8043b4:	89 c6                	mov    %eax,%esi
  8043b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8043ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043be:	48 01 d0             	add    %rdx,%rax
  8043c1:	0f b6 08             	movzbl (%rax),%ecx
  8043c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8043c8:	48 63 c6             	movslq %esi,%rax
  8043cb:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8043cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043d3:	8b 40 04             	mov    0x4(%rax),%eax
  8043d6:	8d 50 01             	lea    0x1(%rax),%edx
  8043d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043dd:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  8043e0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8043e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043e9:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8043ed:	0f 82 61 ff ff ff    	jb     804354 <devpipe_write+0x40>
	}

	return i;
  8043f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8043f7:	c9                   	leaveq 
  8043f8:	c3                   	retq   

00000000008043f9 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8043f9:	55                   	push   %rbp
  8043fa:	48 89 e5             	mov    %rsp,%rbp
  8043fd:	48 83 ec 20          	sub    $0x20,%rsp
  804401:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804405:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804409:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80440d:	48 89 c7             	mov    %rax,%rdi
  804410:	48 b8 96 1e 80 00 00 	movabs $0x801e96,%rax
  804417:	00 00 00 
  80441a:	ff d0                	callq  *%rax
  80441c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804420:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804424:	48 be c6 53 80 00 00 	movabs $0x8053c6,%rsi
  80442b:	00 00 00 
  80442e:	48 89 c7             	mov    %rax,%rdi
  804431:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  804438:	00 00 00 
  80443b:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80443d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804441:	8b 50 04             	mov    0x4(%rax),%edx
  804444:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804448:	8b 00                	mov    (%rax),%eax
  80444a:	29 c2                	sub    %eax,%edx
  80444c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804450:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804456:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80445a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804461:	00 00 00 
	stat->st_dev = &devpipe;
  804464:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804468:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  80446f:	00 00 00 
  804472:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804479:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80447e:	c9                   	leaveq 
  80447f:	c3                   	retq   

0000000000804480 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804480:	55                   	push   %rbp
  804481:	48 89 e5             	mov    %rsp,%rbp
  804484:	48 83 ec 10          	sub    $0x10,%rsp
  804488:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80448c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804490:	48 89 c6             	mov    %rax,%rsi
  804493:	bf 00 00 00 00       	mov    $0x0,%edi
  804498:	48 b8 dd 1a 80 00 00 	movabs $0x801add,%rax
  80449f:	00 00 00 
  8044a2:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8044a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044a8:	48 89 c7             	mov    %rax,%rdi
  8044ab:	48 b8 96 1e 80 00 00 	movabs $0x801e96,%rax
  8044b2:	00 00 00 
  8044b5:	ff d0                	callq  *%rax
  8044b7:	48 89 c6             	mov    %rax,%rsi
  8044ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8044bf:	48 b8 dd 1a 80 00 00 	movabs $0x801add,%rax
  8044c6:	00 00 00 
  8044c9:	ff d0                	callq  *%rax
}
  8044cb:	c9                   	leaveq 
  8044cc:	c3                   	retq   

00000000008044cd <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8044cd:	55                   	push   %rbp
  8044ce:	48 89 e5             	mov    %rsp,%rbp
  8044d1:	48 83 ec 20          	sub    $0x20,%rsp
  8044d5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  8044d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8044dc:	75 35                	jne    804513 <wait+0x46>
  8044de:	48 b9 cd 53 80 00 00 	movabs $0x8053cd,%rcx
  8044e5:	00 00 00 
  8044e8:	48 ba d8 53 80 00 00 	movabs $0x8053d8,%rdx
  8044ef:	00 00 00 
  8044f2:	be 09 00 00 00       	mov    $0x9,%esi
  8044f7:	48 bf ed 53 80 00 00 	movabs $0x8053ed,%rdi
  8044fe:	00 00 00 
  804501:	b8 00 00 00 00       	mov    $0x0,%eax
  804506:	49 b8 2b 03 80 00 00 	movabs $0x80032b,%r8
  80450d:	00 00 00 
  804510:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804513:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804516:	25 ff 03 00 00       	and    $0x3ff,%eax
  80451b:	48 98                	cltq   
  80451d:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  804524:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80452b:	00 00 00 
  80452e:	48 01 d0             	add    %rdx,%rax
  804531:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804535:	eb 0c                	jmp    804543 <wait+0x76>
		sys_yield();
  804537:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  80453e:	00 00 00 
  804541:	ff d0                	callq  *%rax
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804543:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804547:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80454d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804550:	75 0e                	jne    804560 <wait+0x93>
  804552:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804556:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80455c:	85 c0                	test   %eax,%eax
  80455e:	75 d7                	jne    804537 <wait+0x6a>
}
  804560:	c9                   	leaveq 
  804561:	c3                   	retq   

0000000000804562 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804562:	55                   	push   %rbp
  804563:	48 89 e5             	mov    %rsp,%rbp
  804566:	48 83 ec 20          	sub    $0x20,%rsp
  80456a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80456d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804570:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804573:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804577:	be 01 00 00 00       	mov    $0x1,%esi
  80457c:	48 89 c7             	mov    %rax,%rdi
  80457f:	48 b8 e5 18 80 00 00 	movabs $0x8018e5,%rax
  804586:	00 00 00 
  804589:	ff d0                	callq  *%rax
}
  80458b:	c9                   	leaveq 
  80458c:	c3                   	retq   

000000000080458d <getchar>:

int
getchar(void)
{
  80458d:	55                   	push   %rbp
  80458e:	48 89 e5             	mov    %rsp,%rbp
  804591:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804595:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804599:	ba 01 00 00 00       	mov    $0x1,%edx
  80459e:	48 89 c6             	mov    %rax,%rsi
  8045a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8045a6:	48 b8 8d 23 80 00 00 	movabs $0x80238d,%rax
  8045ad:	00 00 00 
  8045b0:	ff d0                	callq  *%rax
  8045b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8045b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045b9:	79 05                	jns    8045c0 <getchar+0x33>
		return r;
  8045bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045be:	eb 14                	jmp    8045d4 <getchar+0x47>
	if (r < 1)
  8045c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045c4:	7f 07                	jg     8045cd <getchar+0x40>
		return -E_EOF;
  8045c6:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8045cb:	eb 07                	jmp    8045d4 <getchar+0x47>
	return c;
  8045cd:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8045d1:	0f b6 c0             	movzbl %al,%eax
}
  8045d4:	c9                   	leaveq 
  8045d5:	c3                   	retq   

00000000008045d6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8045d6:	55                   	push   %rbp
  8045d7:	48 89 e5             	mov    %rsp,%rbp
  8045da:	48 83 ec 20          	sub    $0x20,%rsp
  8045de:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8045e1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8045e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045e8:	48 89 d6             	mov    %rdx,%rsi
  8045eb:	89 c7                	mov    %eax,%edi
  8045ed:	48 b8 59 1f 80 00 00 	movabs $0x801f59,%rax
  8045f4:	00 00 00 
  8045f7:	ff d0                	callq  *%rax
  8045f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804600:	79 05                	jns    804607 <iscons+0x31>
		return r;
  804602:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804605:	eb 1a                	jmp    804621 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804607:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80460b:	8b 10                	mov    (%rax),%edx
  80460d:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804614:	00 00 00 
  804617:	8b 00                	mov    (%rax),%eax
  804619:	39 c2                	cmp    %eax,%edx
  80461b:	0f 94 c0             	sete   %al
  80461e:	0f b6 c0             	movzbl %al,%eax
}
  804621:	c9                   	leaveq 
  804622:	c3                   	retq   

0000000000804623 <opencons>:

int
opencons(void)
{
  804623:	55                   	push   %rbp
  804624:	48 89 e5             	mov    %rsp,%rbp
  804627:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80462b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80462f:	48 89 c7             	mov    %rax,%rdi
  804632:	48 b8 c1 1e 80 00 00 	movabs $0x801ec1,%rax
  804639:	00 00 00 
  80463c:	ff d0                	callq  *%rax
  80463e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804641:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804645:	79 05                	jns    80464c <opencons+0x29>
		return r;
  804647:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80464a:	eb 5b                	jmp    8046a7 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80464c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804650:	ba 07 04 00 00       	mov    $0x407,%edx
  804655:	48 89 c6             	mov    %rax,%rsi
  804658:	bf 00 00 00 00       	mov    $0x0,%edi
  80465d:	48 b8 2b 1a 80 00 00 	movabs $0x801a2b,%rax
  804664:	00 00 00 
  804667:	ff d0                	callq  *%rax
  804669:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80466c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804670:	79 05                	jns    804677 <opencons+0x54>
		return r;
  804672:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804675:	eb 30                	jmp    8046a7 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804677:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80467b:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804682:	00 00 00 
  804685:	8b 12                	mov    (%rdx),%edx
  804687:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804689:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80468d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804694:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804698:	48 89 c7             	mov    %rax,%rdi
  80469b:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  8046a2:	00 00 00 
  8046a5:	ff d0                	callq  *%rax
}
  8046a7:	c9                   	leaveq 
  8046a8:	c3                   	retq   

00000000008046a9 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8046a9:	55                   	push   %rbp
  8046aa:	48 89 e5             	mov    %rsp,%rbp
  8046ad:	48 83 ec 30          	sub    $0x30,%rsp
  8046b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8046b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8046b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8046bd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8046c2:	75 07                	jne    8046cb <devcons_read+0x22>
		return 0;
  8046c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8046c9:	eb 4b                	jmp    804716 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8046cb:	eb 0c                	jmp    8046d9 <devcons_read+0x30>
		sys_yield();
  8046cd:	48 b8 ef 19 80 00 00 	movabs $0x8019ef,%rax
  8046d4:	00 00 00 
  8046d7:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  8046d9:	48 b8 31 19 80 00 00 	movabs $0x801931,%rax
  8046e0:	00 00 00 
  8046e3:	ff d0                	callq  *%rax
  8046e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046ec:	74 df                	je     8046cd <devcons_read+0x24>
	if (c < 0)
  8046ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046f2:	79 05                	jns    8046f9 <devcons_read+0x50>
		return c;
  8046f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046f7:	eb 1d                	jmp    804716 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8046f9:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8046fd:	75 07                	jne    804706 <devcons_read+0x5d>
		return 0;
  8046ff:	b8 00 00 00 00       	mov    $0x0,%eax
  804704:	eb 10                	jmp    804716 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804706:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804709:	89 c2                	mov    %eax,%edx
  80470b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80470f:	88 10                	mov    %dl,(%rax)
	return 1;
  804711:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804716:	c9                   	leaveq 
  804717:	c3                   	retq   

0000000000804718 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804718:	55                   	push   %rbp
  804719:	48 89 e5             	mov    %rsp,%rbp
  80471c:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804723:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80472a:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804731:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804738:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80473f:	eb 76                	jmp    8047b7 <devcons_write+0x9f>
		m = n - tot;
  804741:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804748:	89 c2                	mov    %eax,%edx
  80474a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80474d:	29 c2                	sub    %eax,%edx
  80474f:	89 d0                	mov    %edx,%eax
  804751:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804754:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804757:	83 f8 7f             	cmp    $0x7f,%eax
  80475a:	76 07                	jbe    804763 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80475c:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804763:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804766:	48 63 d0             	movslq %eax,%rdx
  804769:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80476c:	48 63 c8             	movslq %eax,%rcx
  80476f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804776:	48 01 c1             	add    %rax,%rcx
  804779:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804780:	48 89 ce             	mov    %rcx,%rsi
  804783:	48 89 c7             	mov    %rax,%rdi
  804786:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  80478d:	00 00 00 
  804790:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804792:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804795:	48 63 d0             	movslq %eax,%rdx
  804798:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80479f:	48 89 d6             	mov    %rdx,%rsi
  8047a2:	48 89 c7             	mov    %rax,%rdi
  8047a5:	48 b8 e5 18 80 00 00 	movabs $0x8018e5,%rax
  8047ac:	00 00 00 
  8047af:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  8047b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8047b4:	01 45 fc             	add    %eax,-0x4(%rbp)
  8047b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047ba:	48 98                	cltq   
  8047bc:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8047c3:	0f 82 78 ff ff ff    	jb     804741 <devcons_write+0x29>
	}
	return tot;
  8047c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8047cc:	c9                   	leaveq 
  8047cd:	c3                   	retq   

00000000008047ce <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8047ce:	55                   	push   %rbp
  8047cf:	48 89 e5             	mov    %rsp,%rbp
  8047d2:	48 83 ec 08          	sub    $0x8,%rsp
  8047d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8047da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8047df:	c9                   	leaveq 
  8047e0:	c3                   	retq   

00000000008047e1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8047e1:	55                   	push   %rbp
  8047e2:	48 89 e5             	mov    %rsp,%rbp
  8047e5:	48 83 ec 10          	sub    $0x10,%rsp
  8047e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8047ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8047f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047f5:	48 be fd 53 80 00 00 	movabs $0x8053fd,%rsi
  8047fc:	00 00 00 
  8047ff:	48 89 c7             	mov    %rax,%rdi
  804802:	48 b8 fe 10 80 00 00 	movabs $0x8010fe,%rax
  804809:	00 00 00 
  80480c:	ff d0                	callq  *%rax
	return 0;
  80480e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804813:	c9                   	leaveq 
  804814:	c3                   	retq   

0000000000804815 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804815:	55                   	push   %rbp
  804816:	48 89 e5             	mov    %rsp,%rbp
  804819:	48 83 ec 20          	sub    $0x20,%rsp
  80481d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804821:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804825:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  804829:	48 ba 08 54 80 00 00 	movabs $0x805408,%rdx
  804830:	00 00 00 
  804833:	be 1d 00 00 00       	mov    $0x1d,%esi
  804838:	48 bf 21 54 80 00 00 	movabs $0x805421,%rdi
  80483f:	00 00 00 
  804842:	b8 00 00 00 00       	mov    $0x0,%eax
  804847:	48 b9 2b 03 80 00 00 	movabs $0x80032b,%rcx
  80484e:	00 00 00 
  804851:	ff d1                	callq  *%rcx

0000000000804853 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804853:	55                   	push   %rbp
  804854:	48 89 e5             	mov    %rsp,%rbp
  804857:	48 83 ec 20          	sub    $0x20,%rsp
  80485b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80485e:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804861:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  804865:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  804868:	48 ba 2b 54 80 00 00 	movabs $0x80542b,%rdx
  80486f:	00 00 00 
  804872:	be 2d 00 00 00       	mov    $0x2d,%esi
  804877:	48 bf 21 54 80 00 00 	movabs $0x805421,%rdi
  80487e:	00 00 00 
  804881:	b8 00 00 00 00       	mov    $0x0,%eax
  804886:	48 b9 2b 03 80 00 00 	movabs $0x80032b,%rcx
  80488d:	00 00 00 
  804890:	ff d1                	callq  *%rcx

0000000000804892 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  804892:	55                   	push   %rbp
  804893:	48 89 e5             	mov    %rsp,%rbp
  804896:	53                   	push   %rbx
  804897:	48 83 ec 48          	sub    $0x48,%rsp
  80489b:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  80489f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  8048a6:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  8048ad:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  8048b2:	75 0e                	jne    8048c2 <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  8048b4:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  8048bb:	00 00 00 
  8048be:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  8048c2:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8048c6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  8048ca:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8048d1:	00 
	a3 = (uint64_t) 0;
  8048d2:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  8048d9:	00 
	a4 = (uint64_t) 0;
  8048da:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  8048e1:	00 
	a5 = 0;
  8048e2:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  8048e9:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  8048ea:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8048ed:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8048f1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8048f5:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  8048f9:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  8048fd:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  804901:	4c 89 c3             	mov    %r8,%rbx
  804904:	0f 01 c1             	vmcall 
  804907:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  80490a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80490e:	7e 36                	jle    804946 <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  804910:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804913:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804916:	41 89 d0             	mov    %edx,%r8d
  804919:	89 c1                	mov    %eax,%ecx
  80491b:	48 ba 48 54 80 00 00 	movabs $0x805448,%rdx
  804922:	00 00 00 
  804925:	be 54 00 00 00       	mov    $0x54,%esi
  80492a:	48 bf 21 54 80 00 00 	movabs $0x805421,%rdi
  804931:	00 00 00 
  804934:	b8 00 00 00 00       	mov    $0x0,%eax
  804939:	49 b9 2b 03 80 00 00 	movabs $0x80032b,%r9
  804940:	00 00 00 
  804943:	41 ff d1             	callq  *%r9
	return ret;
  804946:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804949:	48 83 c4 48          	add    $0x48,%rsp
  80494d:	5b                   	pop    %rbx
  80494e:	5d                   	pop    %rbp
  80494f:	c3                   	retq   

0000000000804950 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804950:	55                   	push   %rbp
  804951:	48 89 e5             	mov    %rsp,%rbp
  804954:	53                   	push   %rbx
  804955:	48 83 ec 58          	sub    $0x58,%rsp
  804959:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  80495c:	89 75 b0             	mov    %esi,-0x50(%rbp)
  80495f:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  804963:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  804966:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  80496d:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  804974:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  804979:	75 0e                	jne    804989 <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  80497b:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  804982:	00 00 00 
  804985:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  804989:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  80498c:	48 98                	cltq   
  80498e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  804992:	8b 45 b0             	mov    -0x50(%rbp),%eax
  804995:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  804999:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80499d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  8049a1:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  8049a4:	48 98                	cltq   
  8049a6:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  8049aa:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  8049b1:	00 

	int r = -E_IPC_NOT_RECV;
  8049b2:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  8049b9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8049bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8049c0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8049c4:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  8049c8:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  8049cc:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8049d0:	4c 89 c3             	mov    %r8,%rbx
  8049d3:	0f 01 c1             	vmcall 
  8049d6:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  8049d9:	48 83 c4 58          	add    $0x58,%rsp
  8049dd:	5b                   	pop    %rbx
  8049de:	5d                   	pop    %rbp
  8049df:	c3                   	retq   

00000000008049e0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8049e0:	55                   	push   %rbp
  8049e1:	48 89 e5             	mov    %rsp,%rbp
  8049e4:	48 83 ec 18          	sub    $0x18,%rsp
  8049e8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8049eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8049f2:	eb 4e                	jmp    804a42 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8049f4:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8049fb:	00 00 00 
  8049fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a01:	48 98                	cltq   
  804a03:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804a0a:	48 01 d0             	add    %rdx,%rax
  804a0d:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804a13:	8b 00                	mov    (%rax),%eax
  804a15:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804a18:	75 24                	jne    804a3e <ipc_find_env+0x5e>
			return envs[i].env_id;
  804a1a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804a21:	00 00 00 
  804a24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a27:	48 98                	cltq   
  804a29:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804a30:	48 01 d0             	add    %rdx,%rax
  804a33:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804a39:	8b 40 08             	mov    0x8(%rax),%eax
  804a3c:	eb 12                	jmp    804a50 <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  804a3e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804a42:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804a49:	7e a9                	jle    8049f4 <ipc_find_env+0x14>
	}
	return 0;
  804a4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804a50:	c9                   	leaveq 
  804a51:	c3                   	retq   

0000000000804a52 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804a52:	55                   	push   %rbp
  804a53:	48 89 e5             	mov    %rsp,%rbp
  804a56:	48 83 ec 18          	sub    $0x18,%rsp
  804a5a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804a5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a62:	48 c1 e8 15          	shr    $0x15,%rax
  804a66:	48 89 c2             	mov    %rax,%rdx
  804a69:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804a70:	01 00 00 
  804a73:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804a77:	83 e0 01             	and    $0x1,%eax
  804a7a:	48 85 c0             	test   %rax,%rax
  804a7d:	75 07                	jne    804a86 <pageref+0x34>
		return 0;
  804a7f:	b8 00 00 00 00       	mov    $0x0,%eax
  804a84:	eb 53                	jmp    804ad9 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804a86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a8a:	48 c1 e8 0c          	shr    $0xc,%rax
  804a8e:	48 89 c2             	mov    %rax,%rdx
  804a91:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804a98:	01 00 00 
  804a9b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804a9f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804aa3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804aa7:	83 e0 01             	and    $0x1,%eax
  804aaa:	48 85 c0             	test   %rax,%rax
  804aad:	75 07                	jne    804ab6 <pageref+0x64>
		return 0;
  804aaf:	b8 00 00 00 00       	mov    $0x0,%eax
  804ab4:	eb 23                	jmp    804ad9 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804ab6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804aba:	48 c1 e8 0c          	shr    $0xc,%rax
  804abe:	48 89 c2             	mov    %rax,%rdx
  804ac1:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804ac8:	00 00 00 
  804acb:	48 c1 e2 04          	shl    $0x4,%rdx
  804acf:	48 01 d0             	add    %rdx,%rax
  804ad2:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804ad6:	0f b7 c0             	movzwl %ax,%eax
}
  804ad9:	c9                   	leaveq 
  804ada:	c3                   	retq   
