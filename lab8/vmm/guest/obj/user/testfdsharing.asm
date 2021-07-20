
vmm/guest/obj/user/testfdsharing:     formato del fichero elf64-x86-64


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
  80003c:	e8 fa 02 00 00       	callq  80033b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  800052:	be 00 00 00 00       	mov    $0x0,%esi
  800057:	48 bf 40 41 80 00 00 	movabs $0x804140,%rdi
  80005e:	00 00 00 
  800061:	48 b8 f8 28 80 00 00 	movabs $0x8028f8,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
  80006d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800070:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800074:	79 30                	jns    8000a6 <umain+0x63>
		panic("open motd: %e", fd);
  800076:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800079:	89 c1                	mov    %eax,%ecx
  80007b:	48 ba 45 41 80 00 00 	movabs $0x804145,%rdx
  800082:	00 00 00 
  800085:	be 0c 00 00 00       	mov    $0xc,%esi
  80008a:	48 bf 53 41 80 00 00 	movabs $0x804153,%rdi
  800091:	00 00 00 
  800094:	b8 00 00 00 00       	mov    $0x0,%eax
  800099:	49 b8 be 03 80 00 00 	movabs $0x8003be,%r8
  8000a0:	00 00 00 
  8000a3:	41 ff d0             	callq  *%r8
	seek(fd, 0);
  8000a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000a9:	be 00 00 00 00       	mov    $0x0,%esi
  8000ae:	89 c7                	mov    %eax,%edi
  8000b0:	48 b8 3e 26 80 00 00 	movabs $0x80263e,%rax
  8000b7:	00 00 00 
  8000ba:	ff d0                	callq  *%rax
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  8000bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000bf:	ba 00 02 00 00       	mov    $0x200,%edx
  8000c4:	48 be 40 72 80 00 00 	movabs $0x807240,%rsi
  8000cb:	00 00 00 
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	48 b8 f5 24 80 00 00 	movabs $0x8024f5,%rax
  8000d7:	00 00 00 
  8000da:	ff d0                	callq  *%rax
  8000dc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000df:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000e3:	7f 30                	jg     800115 <umain+0xd2>
		panic("readn: %e", n);
  8000e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000e8:	89 c1                	mov    %eax,%ecx
  8000ea:	48 ba 68 41 80 00 00 	movabs $0x804168,%rdx
  8000f1:	00 00 00 
  8000f4:	be 0f 00 00 00       	mov    $0xf,%esi
  8000f9:	48 bf 53 41 80 00 00 	movabs $0x804153,%rdi
  800100:	00 00 00 
  800103:	b8 00 00 00 00       	mov    $0x0,%eax
  800108:	49 b8 be 03 80 00 00 	movabs $0x8003be,%r8
  80010f:	00 00 00 
  800112:	41 ff d0             	callq  *%r8

	if ((r = fork()) < 0)
  800115:	48 b8 aa 1e 80 00 00 	movabs $0x801eaa,%rax
  80011c:	00 00 00 
  80011f:	ff d0                	callq  *%rax
  800121:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800124:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800128:	79 30                	jns    80015a <umain+0x117>
		panic("fork: %e", r);
  80012a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80012d:	89 c1                	mov    %eax,%ecx
  80012f:	48 ba 72 41 80 00 00 	movabs $0x804172,%rdx
  800136:	00 00 00 
  800139:	be 12 00 00 00       	mov    $0x12,%esi
  80013e:	48 bf 53 41 80 00 00 	movabs $0x804153,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	49 b8 be 03 80 00 00 	movabs $0x8003be,%r8
  800154:	00 00 00 
  800157:	41 ff d0             	callq  *%r8
	if (r == 0) {
  80015a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80015e:	0f 85 36 01 00 00    	jne    80029a <umain+0x257>
		seek(fd, 0);
  800164:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800167:	be 00 00 00 00       	mov    $0x0,%esi
  80016c:	89 c7                	mov    %eax,%edi
  80016e:	48 b8 3e 26 80 00 00 	movabs $0x80263e,%rax
  800175:	00 00 00 
  800178:	ff d0                	callq  *%rax
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80017a:	48 bf 80 41 80 00 00 	movabs $0x804180,%rdi
  800181:	00 00 00 
  800184:	b8 00 00 00 00       	mov    $0x0,%eax
  800189:	48 ba f7 05 80 00 00 	movabs $0x8005f7,%rdx
  800190:	00 00 00 
  800193:	ff d2                	callq  *%rdx
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800195:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800198:	ba 00 02 00 00       	mov    $0x200,%edx
  80019d:	48 be 40 70 80 00 00 	movabs $0x807040,%rsi
  8001a4:	00 00 00 
  8001a7:	89 c7                	mov    %eax,%edi
  8001a9:	48 b8 f5 24 80 00 00 	movabs $0x8024f5,%rax
  8001b0:	00 00 00 
  8001b3:	ff d0                	callq  *%rax
  8001b5:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8001b8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001bb:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8001be:	74 36                	je     8001f6 <umain+0x1b3>
			panic("read in parent got %d, read in child got %d", n, n2);
  8001c0:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8001c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001c6:	41 89 d0             	mov    %edx,%r8d
  8001c9:	89 c1                	mov    %eax,%ecx
  8001cb:	48 ba c8 41 80 00 00 	movabs $0x8041c8,%rdx
  8001d2:	00 00 00 
  8001d5:	be 17 00 00 00       	mov    $0x17,%esi
  8001da:	48 bf 53 41 80 00 00 	movabs $0x804153,%rdi
  8001e1:	00 00 00 
  8001e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e9:	49 b9 be 03 80 00 00 	movabs $0x8003be,%r9
  8001f0:	00 00 00 
  8001f3:	41 ff d1             	callq  *%r9
		if (memcmp(buf, buf2, n) != 0)
  8001f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001f9:	48 98                	cltq   
  8001fb:	48 89 c2             	mov    %rax,%rdx
  8001fe:	48 be 40 70 80 00 00 	movabs $0x807040,%rsi
  800205:	00 00 00 
  800208:	48 bf 40 72 80 00 00 	movabs $0x807240,%rdi
  80020f:	00 00 00 
  800212:	48 b8 00 16 80 00 00 	movabs $0x801600,%rax
  800219:	00 00 00 
  80021c:	ff d0                	callq  *%rax
  80021e:	85 c0                	test   %eax,%eax
  800220:	74 2a                	je     80024c <umain+0x209>
			panic("read in parent got different bytes from read in child");
  800222:	48 ba f8 41 80 00 00 	movabs $0x8041f8,%rdx
  800229:	00 00 00 
  80022c:	be 19 00 00 00       	mov    $0x19,%esi
  800231:	48 bf 53 41 80 00 00 	movabs $0x804153,%rdi
  800238:	00 00 00 
  80023b:	b8 00 00 00 00       	mov    $0x0,%eax
  800240:	48 b9 be 03 80 00 00 	movabs $0x8003be,%rcx
  800247:	00 00 00 
  80024a:	ff d1                	callq  *%rcx
		cprintf("read in child succeeded\n");
  80024c:	48 bf 2e 42 80 00 00 	movabs $0x80422e,%rdi
  800253:	00 00 00 
  800256:	b8 00 00 00 00       	mov    $0x0,%eax
  80025b:	48 ba f7 05 80 00 00 	movabs $0x8005f7,%rdx
  800262:	00 00 00 
  800265:	ff d2                	callq  *%rdx
		seek(fd, 0);
  800267:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80026a:	be 00 00 00 00       	mov    $0x0,%esi
  80026f:	89 c7                	mov    %eax,%edi
  800271:	48 b8 3e 26 80 00 00 	movabs $0x80263e,%rax
  800278:	00 00 00 
  80027b:	ff d0                	callq  *%rax
		close(fd);
  80027d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800280:	89 c7                	mov    %eax,%edi
  800282:	48 b8 fe 21 80 00 00 	movabs $0x8021fe,%rax
  800289:	00 00 00 
  80028c:	ff d0                	callq  *%rax
		exit();
  80028e:	48 b8 9b 03 80 00 00 	movabs $0x80039b,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
	}
	wait(r);
  80029a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80029d:	89 c7                	mov    %eax,%edi
  80029f:	48 b8 fb 3a 80 00 00 	movabs $0x803afb,%rax
  8002a6:	00 00 00 
  8002a9:	ff d0                	callq  *%rax
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8002ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002ae:	ba 00 02 00 00       	mov    $0x200,%edx
  8002b3:	48 be 40 70 80 00 00 	movabs $0x807040,%rsi
  8002ba:	00 00 00 
  8002bd:	89 c7                	mov    %eax,%edi
  8002bf:	48 b8 f5 24 80 00 00 	movabs $0x8024f5,%rax
  8002c6:	00 00 00 
  8002c9:	ff d0                	callq  *%rax
  8002cb:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8002ce:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002d1:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8002d4:	74 36                	je     80030c <umain+0x2c9>
		panic("read in parent got %d, then got %d", n, n2);
  8002d6:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8002d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002dc:	41 89 d0             	mov    %edx,%r8d
  8002df:	89 c1                	mov    %eax,%ecx
  8002e1:	48 ba 48 42 80 00 00 	movabs $0x804248,%rdx
  8002e8:	00 00 00 
  8002eb:	be 21 00 00 00       	mov    $0x21,%esi
  8002f0:	48 bf 53 41 80 00 00 	movabs $0x804153,%rdi
  8002f7:	00 00 00 
  8002fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ff:	49 b9 be 03 80 00 00 	movabs $0x8003be,%r9
  800306:	00 00 00 
  800309:	41 ff d1             	callq  *%r9
	cprintf("read in parent succeeded\n");
  80030c:	48 bf 6b 42 80 00 00 	movabs $0x80426b,%rdi
  800313:	00 00 00 
  800316:	b8 00 00 00 00       	mov    $0x0,%eax
  80031b:	48 ba f7 05 80 00 00 	movabs $0x8005f7,%rdx
  800322:	00 00 00 
  800325:	ff d2                	callq  *%rdx
	close(fd);
  800327:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80032a:	89 c7                	mov    %eax,%edi
  80032c:	48 b8 fe 21 80 00 00 	movabs $0x8021fe,%rax
  800333:	00 00 00 
  800336:	ff d0                	callq  *%rax
static __inline void read_gdtr (uint64_t *gdtbase, uint16_t *gdtlimit) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800338:	cc                   	int3   

	breakpoint();
}
  800339:	c9                   	leaveq 
  80033a:	c3                   	retq   

000000000080033b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80033b:	55                   	push   %rbp
  80033c:	48 89 e5             	mov    %rsp,%rbp
  80033f:	48 83 ec 10          	sub    $0x10,%rsp
  800343:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800346:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80034a:	48 b8 40 74 80 00 00 	movabs $0x807440,%rax
  800351:	00 00 00 
  800354:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80035b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80035f:	7e 14                	jle    800375 <libmain+0x3a>
		binaryname = argv[0];
  800361:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800365:	48 8b 10             	mov    (%rax),%rdx
  800368:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80036f:	00 00 00 
  800372:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800375:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800379:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80037c:	48 89 d6             	mov    %rdx,%rsi
  80037f:	89 c7                	mov    %eax,%edi
  800381:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800388:	00 00 00 
  80038b:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80038d:	48 b8 9b 03 80 00 00 	movabs $0x80039b,%rax
  800394:	00 00 00 
  800397:	ff d0                	callq  *%rax
}
  800399:	c9                   	leaveq 
  80039a:	c3                   	retq   

000000000080039b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80039b:	55                   	push   %rbp
  80039c:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80039f:	48 b8 49 22 80 00 00 	movabs $0x802249,%rax
  8003a6:	00 00 00 
  8003a9:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8003b0:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  8003b7:	00 00 00 
  8003ba:	ff d0                	callq  *%rax
}
  8003bc:	5d                   	pop    %rbp
  8003bd:	c3                   	retq   

00000000008003be <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003be:	55                   	push   %rbp
  8003bf:	48 89 e5             	mov    %rsp,%rbp
  8003c2:	53                   	push   %rbx
  8003c3:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8003ca:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8003d1:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8003d7:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8003de:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8003e5:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8003ec:	84 c0                	test   %al,%al
  8003ee:	74 23                	je     800413 <_panic+0x55>
  8003f0:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8003f7:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8003fb:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8003ff:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800403:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800407:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80040b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80040f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800413:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80041a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800421:	00 00 00 
  800424:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80042b:	00 00 00 
  80042e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800432:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800439:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800440:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800447:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80044e:	00 00 00 
  800451:	48 8b 18             	mov    (%rax),%rbx
  800454:	48 b8 46 1a 80 00 00 	movabs $0x801a46,%rax
  80045b:	00 00 00 
  80045e:	ff d0                	callq  *%rax
  800460:	89 c6                	mov    %eax,%esi
  800462:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800468:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80046f:	41 89 d0             	mov    %edx,%r8d
  800472:	48 89 c1             	mov    %rax,%rcx
  800475:	48 89 da             	mov    %rbx,%rdx
  800478:	48 bf 90 42 80 00 00 	movabs $0x804290,%rdi
  80047f:	00 00 00 
  800482:	b8 00 00 00 00       	mov    $0x0,%eax
  800487:	49 b9 f7 05 80 00 00 	movabs $0x8005f7,%r9
  80048e:	00 00 00 
  800491:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800494:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80049b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004a2:	48 89 d6             	mov    %rdx,%rsi
  8004a5:	48 89 c7             	mov    %rax,%rdi
  8004a8:	48 b8 4b 05 80 00 00 	movabs $0x80054b,%rax
  8004af:	00 00 00 
  8004b2:	ff d0                	callq  *%rax
	cprintf("\n");
  8004b4:	48 bf b3 42 80 00 00 	movabs $0x8042b3,%rdi
  8004bb:	00 00 00 
  8004be:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c3:	48 ba f7 05 80 00 00 	movabs $0x8005f7,%rdx
  8004ca:	00 00 00 
  8004cd:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004cf:	cc                   	int3   
  8004d0:	eb fd                	jmp    8004cf <_panic+0x111>

00000000008004d2 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8004d2:	55                   	push   %rbp
  8004d3:	48 89 e5             	mov    %rsp,%rbp
  8004d6:	48 83 ec 10          	sub    $0x10,%rsp
  8004da:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8004e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004e5:	8b 00                	mov    (%rax),%eax
  8004e7:	8d 48 01             	lea    0x1(%rax),%ecx
  8004ea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004ee:	89 0a                	mov    %ecx,(%rdx)
  8004f0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004f3:	89 d1                	mov    %edx,%ecx
  8004f5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004f9:	48 98                	cltq   
  8004fb:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8004ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800503:	8b 00                	mov    (%rax),%eax
  800505:	3d ff 00 00 00       	cmp    $0xff,%eax
  80050a:	75 2c                	jne    800538 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80050c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800510:	8b 00                	mov    (%rax),%eax
  800512:	48 98                	cltq   
  800514:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800518:	48 83 c2 08          	add    $0x8,%rdx
  80051c:	48 89 c6             	mov    %rax,%rsi
  80051f:	48 89 d7             	mov    %rdx,%rdi
  800522:	48 b8 78 19 80 00 00 	movabs $0x801978,%rax
  800529:	00 00 00 
  80052c:	ff d0                	callq  *%rax
        b->idx = 0;
  80052e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800532:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800538:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80053c:	8b 40 04             	mov    0x4(%rax),%eax
  80053f:	8d 50 01             	lea    0x1(%rax),%edx
  800542:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800546:	89 50 04             	mov    %edx,0x4(%rax)
}
  800549:	c9                   	leaveq 
  80054a:	c3                   	retq   

000000000080054b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80054b:	55                   	push   %rbp
  80054c:	48 89 e5             	mov    %rsp,%rbp
  80054f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800556:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80055d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800564:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80056b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800572:	48 8b 0a             	mov    (%rdx),%rcx
  800575:	48 89 08             	mov    %rcx,(%rax)
  800578:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80057c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800580:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800584:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800588:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80058f:	00 00 00 
    b.cnt = 0;
  800592:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800599:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80059c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005a3:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005aa:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005b1:	48 89 c6             	mov    %rax,%rsi
  8005b4:	48 bf d2 04 80 00 00 	movabs $0x8004d2,%rdi
  8005bb:	00 00 00 
  8005be:	48 b8 96 09 80 00 00 	movabs $0x800996,%rax
  8005c5:	00 00 00 
  8005c8:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8005ca:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8005d0:	48 98                	cltq   
  8005d2:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8005d9:	48 83 c2 08          	add    $0x8,%rdx
  8005dd:	48 89 c6             	mov    %rax,%rsi
  8005e0:	48 89 d7             	mov    %rdx,%rdi
  8005e3:	48 b8 78 19 80 00 00 	movabs $0x801978,%rax
  8005ea:	00 00 00 
  8005ed:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8005ef:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8005f5:	c9                   	leaveq 
  8005f6:	c3                   	retq   

00000000008005f7 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8005f7:	55                   	push   %rbp
  8005f8:	48 89 e5             	mov    %rsp,%rbp
  8005fb:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800602:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800609:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800610:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800617:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80061e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800625:	84 c0                	test   %al,%al
  800627:	74 20                	je     800649 <cprintf+0x52>
  800629:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80062d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800631:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800635:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800639:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80063d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800641:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800645:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800649:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800650:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800657:	00 00 00 
  80065a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800661:	00 00 00 
  800664:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800668:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80066f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800676:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80067d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800684:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80068b:	48 8b 0a             	mov    (%rdx),%rcx
  80068e:	48 89 08             	mov    %rcx,(%rax)
  800691:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800695:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800699:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80069d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8006a1:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006a8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006af:	48 89 d6             	mov    %rdx,%rsi
  8006b2:	48 89 c7             	mov    %rax,%rdi
  8006b5:	48 b8 4b 05 80 00 00 	movabs $0x80054b,%rax
  8006bc:	00 00 00 
  8006bf:	ff d0                	callq  *%rax
  8006c1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8006c7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8006cd:	c9                   	leaveq 
  8006ce:	c3                   	retq   

00000000008006cf <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006cf:	55                   	push   %rbp
  8006d0:	48 89 e5             	mov    %rsp,%rbp
  8006d3:	48 83 ec 30          	sub    $0x30,%rsp
  8006d7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8006db:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8006df:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8006e3:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8006e6:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8006ea:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006ee:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8006f1:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8006f5:	77 42                	ja     800739 <printnum+0x6a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006f7:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8006fa:	8d 78 ff             	lea    -0x1(%rax),%edi
  8006fd:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800700:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800704:	ba 00 00 00 00       	mov    $0x0,%edx
  800709:	48 f7 f6             	div    %rsi
  80070c:	49 89 c2             	mov    %rax,%r10
  80070f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800712:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800715:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800719:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80071d:	41 89 c9             	mov    %ecx,%r9d
  800720:	41 89 f8             	mov    %edi,%r8d
  800723:	89 d1                	mov    %edx,%ecx
  800725:	4c 89 d2             	mov    %r10,%rdx
  800728:	48 89 c7             	mov    %rax,%rdi
  80072b:	48 b8 cf 06 80 00 00 	movabs $0x8006cf,%rax
  800732:	00 00 00 
  800735:	ff d0                	callq  *%rax
  800737:	eb 1e                	jmp    800757 <printnum+0x88>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800739:	eb 12                	jmp    80074d <printnum+0x7e>
			putch(padc, putdat);
  80073b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80073f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800742:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800746:	48 89 ce             	mov    %rcx,%rsi
  800749:	89 d7                	mov    %edx,%edi
  80074b:	ff d0                	callq  *%rax
		while (--width > 0)
  80074d:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800751:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800755:	7f e4                	jg     80073b <printnum+0x6c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800757:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80075a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075e:	ba 00 00 00 00       	mov    $0x0,%edx
  800763:	48 f7 f1             	div    %rcx
  800766:	48 b8 b0 44 80 00 00 	movabs $0x8044b0,%rax
  80076d:	00 00 00 
  800770:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800774:	0f be d0             	movsbl %al,%edx
  800777:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80077b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80077f:	48 89 ce             	mov    %rcx,%rsi
  800782:	89 d7                	mov    %edx,%edi
  800784:	ff d0                	callq  *%rax
}
  800786:	c9                   	leaveq 
  800787:	c3                   	retq   

0000000000800788 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800788:	55                   	push   %rbp
  800789:	48 89 e5             	mov    %rsp,%rbp
  80078c:	48 83 ec 20          	sub    $0x20,%rsp
  800790:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800794:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800797:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80079b:	7e 4f                	jle    8007ec <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  80079d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a1:	8b 00                	mov    (%rax),%eax
  8007a3:	83 f8 30             	cmp    $0x30,%eax
  8007a6:	73 24                	jae    8007cc <getuint+0x44>
  8007a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ac:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b4:	8b 00                	mov    (%rax),%eax
  8007b6:	89 c0                	mov    %eax,%eax
  8007b8:	48 01 d0             	add    %rdx,%rax
  8007bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007bf:	8b 12                	mov    (%rdx),%edx
  8007c1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c8:	89 0a                	mov    %ecx,(%rdx)
  8007ca:	eb 14                	jmp    8007e0 <getuint+0x58>
  8007cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8007d4:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8007d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007dc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007e0:	48 8b 00             	mov    (%rax),%rax
  8007e3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007e7:	e9 9d 00 00 00       	jmpq   800889 <getuint+0x101>
	else if (lflag)
  8007ec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007f0:	74 4c                	je     80083e <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  8007f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f6:	8b 00                	mov    (%rax),%eax
  8007f8:	83 f8 30             	cmp    $0x30,%eax
  8007fb:	73 24                	jae    800821 <getuint+0x99>
  8007fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800801:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800805:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800809:	8b 00                	mov    (%rax),%eax
  80080b:	89 c0                	mov    %eax,%eax
  80080d:	48 01 d0             	add    %rdx,%rax
  800810:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800814:	8b 12                	mov    (%rdx),%edx
  800816:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800819:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081d:	89 0a                	mov    %ecx,(%rdx)
  80081f:	eb 14                	jmp    800835 <getuint+0xad>
  800821:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800825:	48 8b 40 08          	mov    0x8(%rax),%rax
  800829:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80082d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800831:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800835:	48 8b 00             	mov    (%rax),%rax
  800838:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80083c:	eb 4b                	jmp    800889 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  80083e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800842:	8b 00                	mov    (%rax),%eax
  800844:	83 f8 30             	cmp    $0x30,%eax
  800847:	73 24                	jae    80086d <getuint+0xe5>
  800849:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800851:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800855:	8b 00                	mov    (%rax),%eax
  800857:	89 c0                	mov    %eax,%eax
  800859:	48 01 d0             	add    %rdx,%rax
  80085c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800860:	8b 12                	mov    (%rdx),%edx
  800862:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800865:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800869:	89 0a                	mov    %ecx,(%rdx)
  80086b:	eb 14                	jmp    800881 <getuint+0xf9>
  80086d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800871:	48 8b 40 08          	mov    0x8(%rax),%rax
  800875:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800879:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80087d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800881:	8b 00                	mov    (%rax),%eax
  800883:	89 c0                	mov    %eax,%eax
  800885:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800889:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80088d:	c9                   	leaveq 
  80088e:	c3                   	retq   

000000000080088f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80088f:	55                   	push   %rbp
  800890:	48 89 e5             	mov    %rsp,%rbp
  800893:	48 83 ec 20          	sub    $0x20,%rsp
  800897:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80089b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80089e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008a2:	7e 4f                	jle    8008f3 <getint+0x64>
		x=va_arg(*ap, long long);
  8008a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a8:	8b 00                	mov    (%rax),%eax
  8008aa:	83 f8 30             	cmp    $0x30,%eax
  8008ad:	73 24                	jae    8008d3 <getint+0x44>
  8008af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bb:	8b 00                	mov    (%rax),%eax
  8008bd:	89 c0                	mov    %eax,%eax
  8008bf:	48 01 d0             	add    %rdx,%rax
  8008c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c6:	8b 12                	mov    (%rdx),%edx
  8008c8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008cf:	89 0a                	mov    %ecx,(%rdx)
  8008d1:	eb 14                	jmp    8008e7 <getint+0x58>
  8008d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8008db:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8008df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008e7:	48 8b 00             	mov    (%rax),%rax
  8008ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008ee:	e9 9d 00 00 00       	jmpq   800990 <getint+0x101>
	else if (lflag)
  8008f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008f7:	74 4c                	je     800945 <getint+0xb6>
		x=va_arg(*ap, long);
  8008f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fd:	8b 00                	mov    (%rax),%eax
  8008ff:	83 f8 30             	cmp    $0x30,%eax
  800902:	73 24                	jae    800928 <getint+0x99>
  800904:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800908:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80090c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800910:	8b 00                	mov    (%rax),%eax
  800912:	89 c0                	mov    %eax,%eax
  800914:	48 01 d0             	add    %rdx,%rax
  800917:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091b:	8b 12                	mov    (%rdx),%edx
  80091d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800920:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800924:	89 0a                	mov    %ecx,(%rdx)
  800926:	eb 14                	jmp    80093c <getint+0xad>
  800928:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800930:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800934:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800938:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80093c:	48 8b 00             	mov    (%rax),%rax
  80093f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800943:	eb 4b                	jmp    800990 <getint+0x101>
	else
		x=va_arg(*ap, int);
  800945:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800949:	8b 00                	mov    (%rax),%eax
  80094b:	83 f8 30             	cmp    $0x30,%eax
  80094e:	73 24                	jae    800974 <getint+0xe5>
  800950:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800954:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800958:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095c:	8b 00                	mov    (%rax),%eax
  80095e:	89 c0                	mov    %eax,%eax
  800960:	48 01 d0             	add    %rdx,%rax
  800963:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800967:	8b 12                	mov    (%rdx),%edx
  800969:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80096c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800970:	89 0a                	mov    %ecx,(%rdx)
  800972:	eb 14                	jmp    800988 <getint+0xf9>
  800974:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800978:	48 8b 40 08          	mov    0x8(%rax),%rax
  80097c:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800980:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800984:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800988:	8b 00                	mov    (%rax),%eax
  80098a:	48 98                	cltq   
  80098c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800990:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800994:	c9                   	leaveq 
  800995:	c3                   	retq   

0000000000800996 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800996:	55                   	push   %rbp
  800997:	48 89 e5             	mov    %rsp,%rbp
  80099a:	41 54                	push   %r12
  80099c:	53                   	push   %rbx
  80099d:	48 83 ec 60          	sub    $0x60,%rsp
  8009a1:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8009a5:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8009a9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009ad:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8009b1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009b5:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8009b9:	48 8b 0a             	mov    (%rdx),%rcx
  8009bc:	48 89 08             	mov    %rcx,(%rax)
  8009bf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8009c3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8009c7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8009cb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009cf:	eb 17                	jmp    8009e8 <vprintfmt+0x52>
			if (ch == '\0')
  8009d1:	85 db                	test   %ebx,%ebx
  8009d3:	0f 84 c5 04 00 00    	je     800e9e <vprintfmt+0x508>
				return;
			putch(ch, putdat);
  8009d9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009dd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009e1:	48 89 d6             	mov    %rdx,%rsi
  8009e4:	89 df                	mov    %ebx,%edi
  8009e6:	ff d0                	callq  *%rax
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009e8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009ec:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009f0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009f4:	0f b6 00             	movzbl (%rax),%eax
  8009f7:	0f b6 d8             	movzbl %al,%ebx
  8009fa:	83 fb 25             	cmp    $0x25,%ebx
  8009fd:	75 d2                	jne    8009d1 <vprintfmt+0x3b>
		}

		// Process a %-escape sequence
		padc = ' ';
  8009ff:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a03:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a0a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a11:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a18:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a1f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a23:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a27:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a2b:	0f b6 00             	movzbl (%rax),%eax
  800a2e:	0f b6 d8             	movzbl %al,%ebx
  800a31:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a34:	83 f8 55             	cmp    $0x55,%eax
  800a37:	0f 87 2e 04 00 00    	ja     800e6b <vprintfmt+0x4d5>
  800a3d:	89 c0                	mov    %eax,%eax
  800a3f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a46:	00 
  800a47:	48 b8 d8 44 80 00 00 	movabs $0x8044d8,%rax
  800a4e:	00 00 00 
  800a51:	48 01 d0             	add    %rdx,%rax
  800a54:	48 8b 00             	mov    (%rax),%rax
  800a57:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a59:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a5d:	eb c0                	jmp    800a1f <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a5f:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a63:	eb ba                	jmp    800a1f <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a65:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a6c:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a6f:	89 d0                	mov    %edx,%eax
  800a71:	c1 e0 02             	shl    $0x2,%eax
  800a74:	01 d0                	add    %edx,%eax
  800a76:	01 c0                	add    %eax,%eax
  800a78:	01 d8                	add    %ebx,%eax
  800a7a:	83 e8 30             	sub    $0x30,%eax
  800a7d:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a80:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a84:	0f b6 00             	movzbl (%rax),%eax
  800a87:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a8a:	83 fb 2f             	cmp    $0x2f,%ebx
  800a8d:	7e 0c                	jle    800a9b <vprintfmt+0x105>
  800a8f:	83 fb 39             	cmp    $0x39,%ebx
  800a92:	7f 07                	jg     800a9b <vprintfmt+0x105>
			for (precision = 0; ; ++fmt) {
  800a94:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
					break;
			}
  800a99:	eb d1                	jmp    800a6c <vprintfmt+0xd6>
			goto process_precision;
  800a9b:	eb 50                	jmp    800aed <vprintfmt+0x157>

		case '*':
			precision = va_arg(aq, int);
  800a9d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa0:	83 f8 30             	cmp    $0x30,%eax
  800aa3:	73 17                	jae    800abc <vprintfmt+0x126>
  800aa5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800aa9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aac:	89 d2                	mov    %edx,%edx
  800aae:	48 01 d0             	add    %rdx,%rax
  800ab1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ab4:	83 c2 08             	add    $0x8,%edx
  800ab7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aba:	eb 0c                	jmp    800ac8 <vprintfmt+0x132>
  800abc:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800ac0:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800ac4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ac8:	8b 00                	mov    (%rax),%eax
  800aca:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800acd:	eb 1e                	jmp    800aed <vprintfmt+0x157>

		case '.':
			if (width < 0)
  800acf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ad3:	79 07                	jns    800adc <vprintfmt+0x146>
				width = 0;
  800ad5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800adc:	e9 3e ff ff ff       	jmpq   800a1f <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800ae1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800ae8:	e9 32 ff ff ff       	jmpq   800a1f <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800aed:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800af1:	79 0d                	jns    800b00 <vprintfmt+0x16a>
				width = precision, precision = -1;
  800af3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800af6:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800af9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b00:	e9 1a ff ff ff       	jmpq   800a1f <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b05:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b09:	e9 11 ff ff ff       	jmpq   800a1f <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b0e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b11:	83 f8 30             	cmp    $0x30,%eax
  800b14:	73 17                	jae    800b2d <vprintfmt+0x197>
  800b16:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b1a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b1d:	89 d2                	mov    %edx,%edx
  800b1f:	48 01 d0             	add    %rdx,%rax
  800b22:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b25:	83 c2 08             	add    $0x8,%edx
  800b28:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b2b:	eb 0c                	jmp    800b39 <vprintfmt+0x1a3>
  800b2d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b31:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b35:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b39:	8b 10                	mov    (%rax),%edx
  800b3b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b3f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b43:	48 89 ce             	mov    %rcx,%rsi
  800b46:	89 d7                	mov    %edx,%edi
  800b48:	ff d0                	callq  *%rax
			break;
  800b4a:	e9 4a 03 00 00       	jmpq   800e99 <vprintfmt+0x503>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b4f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b52:	83 f8 30             	cmp    $0x30,%eax
  800b55:	73 17                	jae    800b6e <vprintfmt+0x1d8>
  800b57:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b5b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b5e:	89 d2                	mov    %edx,%edx
  800b60:	48 01 d0             	add    %rdx,%rax
  800b63:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b66:	83 c2 08             	add    $0x8,%edx
  800b69:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b6c:	eb 0c                	jmp    800b7a <vprintfmt+0x1e4>
  800b6e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b72:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b76:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b7a:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b7c:	85 db                	test   %ebx,%ebx
  800b7e:	79 02                	jns    800b82 <vprintfmt+0x1ec>
				err = -err;
  800b80:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b82:	83 fb 15             	cmp    $0x15,%ebx
  800b85:	7f 16                	jg     800b9d <vprintfmt+0x207>
  800b87:	48 b8 00 44 80 00 00 	movabs $0x804400,%rax
  800b8e:	00 00 00 
  800b91:	48 63 d3             	movslq %ebx,%rdx
  800b94:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b98:	4d 85 e4             	test   %r12,%r12
  800b9b:	75 2e                	jne    800bcb <vprintfmt+0x235>
				printfmt(putch, putdat, "error %d", err);
  800b9d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ba1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba5:	89 d9                	mov    %ebx,%ecx
  800ba7:	48 ba c1 44 80 00 00 	movabs $0x8044c1,%rdx
  800bae:	00 00 00 
  800bb1:	48 89 c7             	mov    %rax,%rdi
  800bb4:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb9:	49 b8 a7 0e 80 00 00 	movabs $0x800ea7,%r8
  800bc0:	00 00 00 
  800bc3:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bc6:	e9 ce 02 00 00       	jmpq   800e99 <vprintfmt+0x503>
				printfmt(putch, putdat, "%s", p);
  800bcb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bcf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd3:	4c 89 e1             	mov    %r12,%rcx
  800bd6:	48 ba ca 44 80 00 00 	movabs $0x8044ca,%rdx
  800bdd:	00 00 00 
  800be0:	48 89 c7             	mov    %rax,%rdi
  800be3:	b8 00 00 00 00       	mov    $0x0,%eax
  800be8:	49 b8 a7 0e 80 00 00 	movabs $0x800ea7,%r8
  800bef:	00 00 00 
  800bf2:	41 ff d0             	callq  *%r8
			break;
  800bf5:	e9 9f 02 00 00       	jmpq   800e99 <vprintfmt+0x503>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800bfa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bfd:	83 f8 30             	cmp    $0x30,%eax
  800c00:	73 17                	jae    800c19 <vprintfmt+0x283>
  800c02:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c06:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c09:	89 d2                	mov    %edx,%edx
  800c0b:	48 01 d0             	add    %rdx,%rax
  800c0e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c11:	83 c2 08             	add    $0x8,%edx
  800c14:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c17:	eb 0c                	jmp    800c25 <vprintfmt+0x28f>
  800c19:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c1d:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c21:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c25:	4c 8b 20             	mov    (%rax),%r12
  800c28:	4d 85 e4             	test   %r12,%r12
  800c2b:	75 0a                	jne    800c37 <vprintfmt+0x2a1>
				p = "(null)";
  800c2d:	49 bc cd 44 80 00 00 	movabs $0x8044cd,%r12
  800c34:	00 00 00 
			if (width > 0 && padc != '-')
  800c37:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c3b:	7e 3f                	jle    800c7c <vprintfmt+0x2e6>
  800c3d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c41:	74 39                	je     800c7c <vprintfmt+0x2e6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c43:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c46:	48 98                	cltq   
  800c48:	48 89 c6             	mov    %rax,%rsi
  800c4b:	4c 89 e7             	mov    %r12,%rdi
  800c4e:	48 b8 53 11 80 00 00 	movabs $0x801153,%rax
  800c55:	00 00 00 
  800c58:	ff d0                	callq  *%rax
  800c5a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c5d:	eb 17                	jmp    800c76 <vprintfmt+0x2e0>
					putch(padc, putdat);
  800c5f:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800c63:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c67:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c6b:	48 89 ce             	mov    %rcx,%rsi
  800c6e:	89 d7                	mov    %edx,%edi
  800c70:	ff d0                	callq  *%rax
				for (width -= strnlen(p, precision); width > 0; width--)
  800c72:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c76:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c7a:	7f e3                	jg     800c5f <vprintfmt+0x2c9>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c7c:	eb 37                	jmp    800cb5 <vprintfmt+0x31f>
				if (altflag && (ch < ' ' || ch > '~'))
  800c7e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c82:	74 1e                	je     800ca2 <vprintfmt+0x30c>
  800c84:	83 fb 1f             	cmp    $0x1f,%ebx
  800c87:	7e 05                	jle    800c8e <vprintfmt+0x2f8>
  800c89:	83 fb 7e             	cmp    $0x7e,%ebx
  800c8c:	7e 14                	jle    800ca2 <vprintfmt+0x30c>
					putch('?', putdat);
  800c8e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c92:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c96:	48 89 d6             	mov    %rdx,%rsi
  800c99:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c9e:	ff d0                	callq  *%rax
  800ca0:	eb 0f                	jmp    800cb1 <vprintfmt+0x31b>
				else
					putch(ch, putdat);
  800ca2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ca6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800caa:	48 89 d6             	mov    %rdx,%rsi
  800cad:	89 df                	mov    %ebx,%edi
  800caf:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cb1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cb5:	4c 89 e0             	mov    %r12,%rax
  800cb8:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800cbc:	0f b6 00             	movzbl (%rax),%eax
  800cbf:	0f be d8             	movsbl %al,%ebx
  800cc2:	85 db                	test   %ebx,%ebx
  800cc4:	74 10                	je     800cd6 <vprintfmt+0x340>
  800cc6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800cca:	78 b2                	js     800c7e <vprintfmt+0x2e8>
  800ccc:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800cd0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800cd4:	79 a8                	jns    800c7e <vprintfmt+0x2e8>
			for (; width > 0; width--)
  800cd6:	eb 16                	jmp    800cee <vprintfmt+0x358>
				putch(' ', putdat);
  800cd8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cdc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce0:	48 89 d6             	mov    %rdx,%rsi
  800ce3:	bf 20 00 00 00       	mov    $0x20,%edi
  800ce8:	ff d0                	callq  *%rax
			for (; width > 0; width--)
  800cea:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cee:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cf2:	7f e4                	jg     800cd8 <vprintfmt+0x342>
			break;
  800cf4:	e9 a0 01 00 00       	jmpq   800e99 <vprintfmt+0x503>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800cf9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cfd:	be 03 00 00 00       	mov    $0x3,%esi
  800d02:	48 89 c7             	mov    %rax,%rdi
  800d05:	48 b8 8f 08 80 00 00 	movabs $0x80088f,%rax
  800d0c:	00 00 00 
  800d0f:	ff d0                	callq  *%rax
  800d11:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d19:	48 85 c0             	test   %rax,%rax
  800d1c:	79 1d                	jns    800d3b <vprintfmt+0x3a5>
				putch('-', putdat);
  800d1e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d22:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d26:	48 89 d6             	mov    %rdx,%rsi
  800d29:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d2e:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d34:	48 f7 d8             	neg    %rax
  800d37:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d3b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d42:	e9 e5 00 00 00       	jmpq   800e2c <vprintfmt+0x496>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d47:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d4b:	be 03 00 00 00       	mov    $0x3,%esi
  800d50:	48 89 c7             	mov    %rax,%rdi
  800d53:	48 b8 88 07 80 00 00 	movabs $0x800788,%rax
  800d5a:	00 00 00 
  800d5d:	ff d0                	callq  *%rax
  800d5f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d63:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d6a:	e9 bd 00 00 00       	jmpq   800e2c <vprintfmt+0x496>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d6f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d73:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d77:	48 89 d6             	mov    %rdx,%rsi
  800d7a:	bf 58 00 00 00       	mov    $0x58,%edi
  800d7f:	ff d0                	callq  *%rax
			putch('X', putdat);
  800d81:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d85:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d89:	48 89 d6             	mov    %rdx,%rsi
  800d8c:	bf 58 00 00 00       	mov    $0x58,%edi
  800d91:	ff d0                	callq  *%rax
			putch('X', putdat);
  800d93:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d97:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d9b:	48 89 d6             	mov    %rdx,%rsi
  800d9e:	bf 58 00 00 00       	mov    $0x58,%edi
  800da3:	ff d0                	callq  *%rax
			break;
  800da5:	e9 ef 00 00 00       	jmpq   800e99 <vprintfmt+0x503>

			// pointer
		case 'p':
			putch('0', putdat);
  800daa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800db2:	48 89 d6             	mov    %rdx,%rsi
  800db5:	bf 30 00 00 00       	mov    $0x30,%edi
  800dba:	ff d0                	callq  *%rax
			putch('x', putdat);
  800dbc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dc0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dc4:	48 89 d6             	mov    %rdx,%rsi
  800dc7:	bf 78 00 00 00       	mov    $0x78,%edi
  800dcc:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800dce:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dd1:	83 f8 30             	cmp    $0x30,%eax
  800dd4:	73 17                	jae    800ded <vprintfmt+0x457>
  800dd6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dda:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ddd:	89 d2                	mov    %edx,%edx
  800ddf:	48 01 d0             	add    %rdx,%rax
  800de2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800de5:	83 c2 08             	add    $0x8,%edx
  800de8:	89 55 b8             	mov    %edx,-0x48(%rbp)
			num = (unsigned long long)
  800deb:	eb 0c                	jmp    800df9 <vprintfmt+0x463>
				(uintptr_t) va_arg(aq, void *);
  800ded:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800df1:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800df5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800df9:	48 8b 00             	mov    (%rax),%rax
			num = (unsigned long long)
  800dfc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e00:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e07:	eb 23                	jmp    800e2c <vprintfmt+0x496>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e09:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e0d:	be 03 00 00 00       	mov    $0x3,%esi
  800e12:	48 89 c7             	mov    %rax,%rdi
  800e15:	48 b8 88 07 80 00 00 	movabs $0x800788,%rax
  800e1c:	00 00 00 
  800e1f:	ff d0                	callq  *%rax
  800e21:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e25:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e2c:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e31:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e34:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e37:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e3b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e3f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e43:	45 89 c1             	mov    %r8d,%r9d
  800e46:	41 89 f8             	mov    %edi,%r8d
  800e49:	48 89 c7             	mov    %rax,%rdi
  800e4c:	48 b8 cf 06 80 00 00 	movabs $0x8006cf,%rax
  800e53:	00 00 00 
  800e56:	ff d0                	callq  *%rax
			break;
  800e58:	eb 3f                	jmp    800e99 <vprintfmt+0x503>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e5a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e5e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e62:	48 89 d6             	mov    %rdx,%rsi
  800e65:	89 df                	mov    %ebx,%edi
  800e67:	ff d0                	callq  *%rax
			break;
  800e69:	eb 2e                	jmp    800e99 <vprintfmt+0x503>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e6b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e6f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e73:	48 89 d6             	mov    %rdx,%rsi
  800e76:	bf 25 00 00 00       	mov    $0x25,%edi
  800e7b:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e7d:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e82:	eb 05                	jmp    800e89 <vprintfmt+0x4f3>
  800e84:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e89:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e8d:	48 83 e8 01          	sub    $0x1,%rax
  800e91:	0f b6 00             	movzbl (%rax),%eax
  800e94:	3c 25                	cmp    $0x25,%al
  800e96:	75 ec                	jne    800e84 <vprintfmt+0x4ee>
				/* do nothing */;
			break;
  800e98:	90                   	nop
		}
	}
  800e99:	e9 31 fb ff ff       	jmpq   8009cf <vprintfmt+0x39>
	va_end(aq);
}
  800e9e:	48 83 c4 60          	add    $0x60,%rsp
  800ea2:	5b                   	pop    %rbx
  800ea3:	41 5c                	pop    %r12
  800ea5:	5d                   	pop    %rbp
  800ea6:	c3                   	retq   

0000000000800ea7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ea7:	55                   	push   %rbp
  800ea8:	48 89 e5             	mov    %rsp,%rbp
  800eab:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800eb2:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800eb9:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800ec0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ec7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ece:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ed5:	84 c0                	test   %al,%al
  800ed7:	74 20                	je     800ef9 <printfmt+0x52>
  800ed9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800edd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ee1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ee5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ee9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800eed:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ef1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ef5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ef9:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f00:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f07:	00 00 00 
  800f0a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f11:	00 00 00 
  800f14:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f18:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f1f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f26:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f2d:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f34:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f3b:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f42:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f49:	48 89 c7             	mov    %rax,%rdi
  800f4c:	48 b8 96 09 80 00 00 	movabs $0x800996,%rax
  800f53:	00 00 00 
  800f56:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f58:	c9                   	leaveq 
  800f59:	c3                   	retq   

0000000000800f5a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f5a:	55                   	push   %rbp
  800f5b:	48 89 e5             	mov    %rsp,%rbp
  800f5e:	48 83 ec 10          	sub    $0x10,%rsp
  800f62:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f65:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f6d:	8b 40 10             	mov    0x10(%rax),%eax
  800f70:	8d 50 01             	lea    0x1(%rax),%edx
  800f73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f77:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f7e:	48 8b 10             	mov    (%rax),%rdx
  800f81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f85:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f89:	48 39 c2             	cmp    %rax,%rdx
  800f8c:	73 17                	jae    800fa5 <sprintputch+0x4b>
		*b->buf++ = ch;
  800f8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f92:	48 8b 00             	mov    (%rax),%rax
  800f95:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f99:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f9d:	48 89 0a             	mov    %rcx,(%rdx)
  800fa0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800fa3:	88 10                	mov    %dl,(%rax)
}
  800fa5:	c9                   	leaveq 
  800fa6:	c3                   	retq   

0000000000800fa7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fa7:	55                   	push   %rbp
  800fa8:	48 89 e5             	mov    %rsp,%rbp
  800fab:	48 83 ec 50          	sub    $0x50,%rsp
  800faf:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800fb3:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800fb6:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800fba:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800fbe:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800fc2:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800fc6:	48 8b 0a             	mov    (%rdx),%rcx
  800fc9:	48 89 08             	mov    %rcx,(%rax)
  800fcc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fd0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fd4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fd8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fdc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fe0:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800fe4:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800fe7:	48 98                	cltq   
  800fe9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800fed:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ff1:	48 01 d0             	add    %rdx,%rax
  800ff4:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ff8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800fff:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801004:	74 06                	je     80100c <vsnprintf+0x65>
  801006:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80100a:	7f 07                	jg     801013 <vsnprintf+0x6c>
		return -E_INVAL;
  80100c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801011:	eb 2f                	jmp    801042 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801013:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801017:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80101b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80101f:	48 89 c6             	mov    %rax,%rsi
  801022:	48 bf 5a 0f 80 00 00 	movabs $0x800f5a,%rdi
  801029:	00 00 00 
  80102c:	48 b8 96 09 80 00 00 	movabs $0x800996,%rax
  801033:	00 00 00 
  801036:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801038:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80103c:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80103f:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801042:	c9                   	leaveq 
  801043:	c3                   	retq   

0000000000801044 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801044:	55                   	push   %rbp
  801045:	48 89 e5             	mov    %rsp,%rbp
  801048:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80104f:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801056:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80105c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801063:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80106a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801071:	84 c0                	test   %al,%al
  801073:	74 20                	je     801095 <snprintf+0x51>
  801075:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801079:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80107d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801081:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801085:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801089:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80108d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801091:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801095:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80109c:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8010a3:	00 00 00 
  8010a6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8010ad:	00 00 00 
  8010b0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010b4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8010bb:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010c2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8010c9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8010d0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8010d7:	48 8b 0a             	mov    (%rdx),%rcx
  8010da:	48 89 08             	mov    %rcx,(%rax)
  8010dd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010e1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010e5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010e9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8010ed:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8010f4:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8010fb:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801101:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801108:	48 89 c7             	mov    %rax,%rdi
  80110b:	48 b8 a7 0f 80 00 00 	movabs $0x800fa7,%rax
  801112:	00 00 00 
  801115:	ff d0                	callq  *%rax
  801117:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80111d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801123:	c9                   	leaveq 
  801124:	c3                   	retq   

0000000000801125 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801125:	55                   	push   %rbp
  801126:	48 89 e5             	mov    %rsp,%rbp
  801129:	48 83 ec 18          	sub    $0x18,%rsp
  80112d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801131:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801138:	eb 09                	jmp    801143 <strlen+0x1e>
		n++;
  80113a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; *s != '\0'; s++)
  80113e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801143:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801147:	0f b6 00             	movzbl (%rax),%eax
  80114a:	84 c0                	test   %al,%al
  80114c:	75 ec                	jne    80113a <strlen+0x15>
	return n;
  80114e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801151:	c9                   	leaveq 
  801152:	c3                   	retq   

0000000000801153 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801153:	55                   	push   %rbp
  801154:	48 89 e5             	mov    %rsp,%rbp
  801157:	48 83 ec 20          	sub    $0x20,%rsp
  80115b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80115f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801163:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80116a:	eb 0e                	jmp    80117a <strnlen+0x27>
		n++;
  80116c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801170:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801175:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80117a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80117f:	74 0b                	je     80118c <strnlen+0x39>
  801181:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801185:	0f b6 00             	movzbl (%rax),%eax
  801188:	84 c0                	test   %al,%al
  80118a:	75 e0                	jne    80116c <strnlen+0x19>
	return n;
  80118c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80118f:	c9                   	leaveq 
  801190:	c3                   	retq   

0000000000801191 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801191:	55                   	push   %rbp
  801192:	48 89 e5             	mov    %rsp,%rbp
  801195:	48 83 ec 20          	sub    $0x20,%rsp
  801199:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80119d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8011a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8011a9:	90                   	nop
  8011aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ae:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011b2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011b6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011ba:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011be:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011c2:	0f b6 12             	movzbl (%rdx),%edx
  8011c5:	88 10                	mov    %dl,(%rax)
  8011c7:	0f b6 00             	movzbl (%rax),%eax
  8011ca:	84 c0                	test   %al,%al
  8011cc:	75 dc                	jne    8011aa <strcpy+0x19>
		/* do nothing */;
	return ret;
  8011ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011d2:	c9                   	leaveq 
  8011d3:	c3                   	retq   

00000000008011d4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8011d4:	55                   	push   %rbp
  8011d5:	48 89 e5             	mov    %rsp,%rbp
  8011d8:	48 83 ec 20          	sub    $0x20,%rsp
  8011dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8011e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e8:	48 89 c7             	mov    %rax,%rdi
  8011eb:	48 b8 25 11 80 00 00 	movabs $0x801125,%rax
  8011f2:	00 00 00 
  8011f5:	ff d0                	callq  *%rax
  8011f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8011fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011fd:	48 63 d0             	movslq %eax,%rdx
  801200:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801204:	48 01 c2             	add    %rax,%rdx
  801207:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80120b:	48 89 c6             	mov    %rax,%rsi
  80120e:	48 89 d7             	mov    %rdx,%rdi
  801211:	48 b8 91 11 80 00 00 	movabs $0x801191,%rax
  801218:	00 00 00 
  80121b:	ff d0                	callq  *%rax
	return dst;
  80121d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801221:	c9                   	leaveq 
  801222:	c3                   	retq   

0000000000801223 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801223:	55                   	push   %rbp
  801224:	48 89 e5             	mov    %rsp,%rbp
  801227:	48 83 ec 28          	sub    $0x28,%rsp
  80122b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80122f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801233:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801237:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80123b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80123f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801246:	00 
  801247:	eb 2a                	jmp    801273 <strncpy+0x50>
		*dst++ = *src;
  801249:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801251:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801255:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801259:	0f b6 12             	movzbl (%rdx),%edx
  80125c:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80125e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801262:	0f b6 00             	movzbl (%rax),%eax
  801265:	84 c0                	test   %al,%al
  801267:	74 05                	je     80126e <strncpy+0x4b>
			src++;
  801269:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
	for (i = 0; i < size; i++) {
  80126e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801273:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801277:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80127b:	72 cc                	jb     801249 <strncpy+0x26>
	}
	return ret;
  80127d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801281:	c9                   	leaveq 
  801282:	c3                   	retq   

0000000000801283 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801283:	55                   	push   %rbp
  801284:	48 89 e5             	mov    %rsp,%rbp
  801287:	48 83 ec 28          	sub    $0x28,%rsp
  80128b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80128f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801293:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801297:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80129b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80129f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012a4:	74 3d                	je     8012e3 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8012a6:	eb 1d                	jmp    8012c5 <strlcpy+0x42>
			*dst++ = *src++;
  8012a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ac:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012b0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012b4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012b8:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8012bc:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012c0:	0f b6 12             	movzbl (%rdx),%edx
  8012c3:	88 10                	mov    %dl,(%rax)
		while (--size > 0 && *src != '\0')
  8012c5:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8012ca:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012cf:	74 0b                	je     8012dc <strlcpy+0x59>
  8012d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012d5:	0f b6 00             	movzbl (%rax),%eax
  8012d8:	84 c0                	test   %al,%al
  8012da:	75 cc                	jne    8012a8 <strlcpy+0x25>
		*dst = '\0';
  8012dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e0:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8012e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012eb:	48 29 c2             	sub    %rax,%rdx
  8012ee:	48 89 d0             	mov    %rdx,%rax
}
  8012f1:	c9                   	leaveq 
  8012f2:	c3                   	retq   

00000000008012f3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012f3:	55                   	push   %rbp
  8012f4:	48 89 e5             	mov    %rsp,%rbp
  8012f7:	48 83 ec 10          	sub    $0x10,%rsp
  8012fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012ff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801303:	eb 0a                	jmp    80130f <strcmp+0x1c>
		p++, q++;
  801305:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80130a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (*p && *p == *q)
  80130f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801313:	0f b6 00             	movzbl (%rax),%eax
  801316:	84 c0                	test   %al,%al
  801318:	74 12                	je     80132c <strcmp+0x39>
  80131a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131e:	0f b6 10             	movzbl (%rax),%edx
  801321:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801325:	0f b6 00             	movzbl (%rax),%eax
  801328:	38 c2                	cmp    %al,%dl
  80132a:	74 d9                	je     801305 <strcmp+0x12>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80132c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801330:	0f b6 00             	movzbl (%rax),%eax
  801333:	0f b6 d0             	movzbl %al,%edx
  801336:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80133a:	0f b6 00             	movzbl (%rax),%eax
  80133d:	0f b6 c0             	movzbl %al,%eax
  801340:	29 c2                	sub    %eax,%edx
  801342:	89 d0                	mov    %edx,%eax
}
  801344:	c9                   	leaveq 
  801345:	c3                   	retq   

0000000000801346 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801346:	55                   	push   %rbp
  801347:	48 89 e5             	mov    %rsp,%rbp
  80134a:	48 83 ec 18          	sub    $0x18,%rsp
  80134e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801352:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801356:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80135a:	eb 0f                	jmp    80136b <strncmp+0x25>
		n--, p++, q++;
  80135c:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801361:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801366:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n > 0 && *p && *p == *q)
  80136b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801370:	74 1d                	je     80138f <strncmp+0x49>
  801372:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801376:	0f b6 00             	movzbl (%rax),%eax
  801379:	84 c0                	test   %al,%al
  80137b:	74 12                	je     80138f <strncmp+0x49>
  80137d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801381:	0f b6 10             	movzbl (%rax),%edx
  801384:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801388:	0f b6 00             	movzbl (%rax),%eax
  80138b:	38 c2                	cmp    %al,%dl
  80138d:	74 cd                	je     80135c <strncmp+0x16>
	if (n == 0)
  80138f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801394:	75 07                	jne    80139d <strncmp+0x57>
		return 0;
  801396:	b8 00 00 00 00       	mov    $0x0,%eax
  80139b:	eb 18                	jmp    8013b5 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80139d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a1:	0f b6 00             	movzbl (%rax),%eax
  8013a4:	0f b6 d0             	movzbl %al,%edx
  8013a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ab:	0f b6 00             	movzbl (%rax),%eax
  8013ae:	0f b6 c0             	movzbl %al,%eax
  8013b1:	29 c2                	sub    %eax,%edx
  8013b3:	89 d0                	mov    %edx,%eax
}
  8013b5:	c9                   	leaveq 
  8013b6:	c3                   	retq   

00000000008013b7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013b7:	55                   	push   %rbp
  8013b8:	48 89 e5             	mov    %rsp,%rbp
  8013bb:	48 83 ec 10          	sub    $0x10,%rsp
  8013bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013c3:	89 f0                	mov    %esi,%eax
  8013c5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013c8:	eb 17                	jmp    8013e1 <strchr+0x2a>
		if (*s == c)
  8013ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ce:	0f b6 00             	movzbl (%rax),%eax
  8013d1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013d4:	75 06                	jne    8013dc <strchr+0x25>
			return (char *) s;
  8013d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013da:	eb 15                	jmp    8013f1 <strchr+0x3a>
	for (; *s; s++)
  8013dc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e5:	0f b6 00             	movzbl (%rax),%eax
  8013e8:	84 c0                	test   %al,%al
  8013ea:	75 de                	jne    8013ca <strchr+0x13>
	return 0;
  8013ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013f1:	c9                   	leaveq 
  8013f2:	c3                   	retq   

00000000008013f3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013f3:	55                   	push   %rbp
  8013f4:	48 89 e5             	mov    %rsp,%rbp
  8013f7:	48 83 ec 10          	sub    $0x10,%rsp
  8013fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013ff:	89 f0                	mov    %esi,%eax
  801401:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801404:	eb 13                	jmp    801419 <strfind+0x26>
		if (*s == c)
  801406:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80140a:	0f b6 00             	movzbl (%rax),%eax
  80140d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801410:	75 02                	jne    801414 <strfind+0x21>
			break;
  801412:	eb 10                	jmp    801424 <strfind+0x31>
	for (; *s; s++)
  801414:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801419:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141d:	0f b6 00             	movzbl (%rax),%eax
  801420:	84 c0                	test   %al,%al
  801422:	75 e2                	jne    801406 <strfind+0x13>
	return (char *) s;
  801424:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801428:	c9                   	leaveq 
  801429:	c3                   	retq   

000000000080142a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80142a:	55                   	push   %rbp
  80142b:	48 89 e5             	mov    %rsp,%rbp
  80142e:	48 83 ec 18          	sub    $0x18,%rsp
  801432:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801436:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801439:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80143d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801442:	75 06                	jne    80144a <memset+0x20>
		return v;
  801444:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801448:	eb 69                	jmp    8014b3 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80144a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144e:	83 e0 03             	and    $0x3,%eax
  801451:	48 85 c0             	test   %rax,%rax
  801454:	75 48                	jne    80149e <memset+0x74>
  801456:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80145a:	83 e0 03             	and    $0x3,%eax
  80145d:	48 85 c0             	test   %rax,%rax
  801460:	75 3c                	jne    80149e <memset+0x74>
		c &= 0xFF;
  801462:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801469:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80146c:	c1 e0 18             	shl    $0x18,%eax
  80146f:	89 c2                	mov    %eax,%edx
  801471:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801474:	c1 e0 10             	shl    $0x10,%eax
  801477:	09 c2                	or     %eax,%edx
  801479:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80147c:	c1 e0 08             	shl    $0x8,%eax
  80147f:	09 d0                	or     %edx,%eax
  801481:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801484:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801488:	48 c1 e8 02          	shr    $0x2,%rax
  80148c:	48 89 c1             	mov    %rax,%rcx
		asm volatile("cld; rep stosl\n"
  80148f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801493:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801496:	48 89 d7             	mov    %rdx,%rdi
  801499:	fc                   	cld    
  80149a:	f3 ab                	rep stos %eax,%es:(%rdi)
  80149c:	eb 11                	jmp    8014af <memset+0x85>
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80149e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014a2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014a5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8014a9:	48 89 d7             	mov    %rdx,%rdi
  8014ac:	fc                   	cld    
  8014ad:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8014af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014b3:	c9                   	leaveq 
  8014b4:	c3                   	retq   

00000000008014b5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8014b5:	55                   	push   %rbp
  8014b6:	48 89 e5             	mov    %rsp,%rbp
  8014b9:	48 83 ec 28          	sub    $0x28,%rsp
  8014bd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014c1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014c5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8014c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014cd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8014d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8014d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014dd:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014e1:	0f 83 88 00 00 00    	jae    80156f <memmove+0xba>
  8014e7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ef:	48 01 d0             	add    %rdx,%rax
  8014f2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014f6:	76 77                	jbe    80156f <memmove+0xba>
		s += n;
  8014f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fc:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801500:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801504:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801508:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80150c:	83 e0 03             	and    $0x3,%eax
  80150f:	48 85 c0             	test   %rax,%rax
  801512:	75 3b                	jne    80154f <memmove+0x9a>
  801514:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801518:	83 e0 03             	and    $0x3,%eax
  80151b:	48 85 c0             	test   %rax,%rax
  80151e:	75 2f                	jne    80154f <memmove+0x9a>
  801520:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801524:	83 e0 03             	and    $0x3,%eax
  801527:	48 85 c0             	test   %rax,%rax
  80152a:	75 23                	jne    80154f <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80152c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801530:	48 83 e8 04          	sub    $0x4,%rax
  801534:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801538:	48 83 ea 04          	sub    $0x4,%rdx
  80153c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801540:	48 c1 e9 02          	shr    $0x2,%rcx
			asm volatile("std; rep movsl\n"
  801544:	48 89 c7             	mov    %rax,%rdi
  801547:	48 89 d6             	mov    %rdx,%rsi
  80154a:	fd                   	std    
  80154b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80154d:	eb 1d                	jmp    80156c <memmove+0xb7>
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80154f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801553:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801557:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155b:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
			asm volatile("std; rep movsb\n"
  80155f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801563:	48 89 d7             	mov    %rdx,%rdi
  801566:	48 89 c1             	mov    %rax,%rcx
  801569:	fd                   	std    
  80156a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80156c:	fc                   	cld    
  80156d:	eb 57                	jmp    8015c6 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80156f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801573:	83 e0 03             	and    $0x3,%eax
  801576:	48 85 c0             	test   %rax,%rax
  801579:	75 36                	jne    8015b1 <memmove+0xfc>
  80157b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80157f:	83 e0 03             	and    $0x3,%eax
  801582:	48 85 c0             	test   %rax,%rax
  801585:	75 2a                	jne    8015b1 <memmove+0xfc>
  801587:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158b:	83 e0 03             	and    $0x3,%eax
  80158e:	48 85 c0             	test   %rax,%rax
  801591:	75 1e                	jne    8015b1 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801593:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801597:	48 c1 e8 02          	shr    $0x2,%rax
  80159b:	48 89 c1             	mov    %rax,%rcx
			asm volatile("cld; rep movsl\n"
  80159e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015a2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015a6:	48 89 c7             	mov    %rax,%rdi
  8015a9:	48 89 d6             	mov    %rdx,%rsi
  8015ac:	fc                   	cld    
  8015ad:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015af:	eb 15                	jmp    8015c6 <memmove+0x111>
		else
			asm volatile("cld; rep movsb\n"
  8015b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015b9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015bd:	48 89 c7             	mov    %rax,%rdi
  8015c0:	48 89 d6             	mov    %rdx,%rsi
  8015c3:	fc                   	cld    
  8015c4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8015c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015ca:	c9                   	leaveq 
  8015cb:	c3                   	retq   

00000000008015cc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8015cc:	55                   	push   %rbp
  8015cd:	48 89 e5             	mov    %rsp,%rbp
  8015d0:	48 83 ec 18          	sub    $0x18,%rsp
  8015d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015d8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015dc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8015e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015e4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8015e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ec:	48 89 ce             	mov    %rcx,%rsi
  8015ef:	48 89 c7             	mov    %rax,%rdi
  8015f2:	48 b8 b5 14 80 00 00 	movabs $0x8014b5,%rax
  8015f9:	00 00 00 
  8015fc:	ff d0                	callq  *%rax
}
  8015fe:	c9                   	leaveq 
  8015ff:	c3                   	retq   

0000000000801600 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801600:	55                   	push   %rbp
  801601:	48 89 e5             	mov    %rsp,%rbp
  801604:	48 83 ec 28          	sub    $0x28,%rsp
  801608:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80160c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801610:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801614:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801618:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80161c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801620:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801624:	eb 36                	jmp    80165c <memcmp+0x5c>
		if (*s1 != *s2)
  801626:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162a:	0f b6 10             	movzbl (%rax),%edx
  80162d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801631:	0f b6 00             	movzbl (%rax),%eax
  801634:	38 c2                	cmp    %al,%dl
  801636:	74 1a                	je     801652 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801638:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80163c:	0f b6 00             	movzbl (%rax),%eax
  80163f:	0f b6 d0             	movzbl %al,%edx
  801642:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801646:	0f b6 00             	movzbl (%rax),%eax
  801649:	0f b6 c0             	movzbl %al,%eax
  80164c:	29 c2                	sub    %eax,%edx
  80164e:	89 d0                	mov    %edx,%eax
  801650:	eb 20                	jmp    801672 <memcmp+0x72>
		s1++, s2++;
  801652:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801657:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
	while (n-- > 0) {
  80165c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801660:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801664:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801668:	48 85 c0             	test   %rax,%rax
  80166b:	75 b9                	jne    801626 <memcmp+0x26>
	}

	return 0;
  80166d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801672:	c9                   	leaveq 
  801673:	c3                   	retq   

0000000000801674 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801674:	55                   	push   %rbp
  801675:	48 89 e5             	mov    %rsp,%rbp
  801678:	48 83 ec 28          	sub    $0x28,%rsp
  80167c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801680:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801683:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801687:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80168b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168f:	48 01 d0             	add    %rdx,%rax
  801692:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801696:	eb 15                	jmp    8016ad <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801698:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80169c:	0f b6 00             	movzbl (%rax),%eax
  80169f:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8016a2:	38 d0                	cmp    %dl,%al
  8016a4:	75 02                	jne    8016a8 <memfind+0x34>
			break;
  8016a6:	eb 0f                	jmp    8016b7 <memfind+0x43>
	for (; s < ends; s++)
  8016a8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b1:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8016b5:	72 e1                	jb     801698 <memfind+0x24>
	return (void *) s;
  8016b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016bb:	c9                   	leaveq 
  8016bc:	c3                   	retq   

00000000008016bd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016bd:	55                   	push   %rbp
  8016be:	48 89 e5             	mov    %rsp,%rbp
  8016c1:	48 83 ec 38          	sub    $0x38,%rsp
  8016c5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016c9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8016cd:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8016d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8016d7:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8016de:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016df:	eb 05                	jmp    8016e6 <strtol+0x29>
		s++;
  8016e1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
	while (*s == ' ' || *s == '\t')
  8016e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ea:	0f b6 00             	movzbl (%rax),%eax
  8016ed:	3c 20                	cmp    $0x20,%al
  8016ef:	74 f0                	je     8016e1 <strtol+0x24>
  8016f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f5:	0f b6 00             	movzbl (%rax),%eax
  8016f8:	3c 09                	cmp    $0x9,%al
  8016fa:	74 e5                	je     8016e1 <strtol+0x24>

	// plus/minus sign
	if (*s == '+')
  8016fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801700:	0f b6 00             	movzbl (%rax),%eax
  801703:	3c 2b                	cmp    $0x2b,%al
  801705:	75 07                	jne    80170e <strtol+0x51>
		s++;
  801707:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80170c:	eb 17                	jmp    801725 <strtol+0x68>
	else if (*s == '-')
  80170e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801712:	0f b6 00             	movzbl (%rax),%eax
  801715:	3c 2d                	cmp    $0x2d,%al
  801717:	75 0c                	jne    801725 <strtol+0x68>
		s++, neg = 1;
  801719:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80171e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801725:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801729:	74 06                	je     801731 <strtol+0x74>
  80172b:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80172f:	75 28                	jne    801759 <strtol+0x9c>
  801731:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801735:	0f b6 00             	movzbl (%rax),%eax
  801738:	3c 30                	cmp    $0x30,%al
  80173a:	75 1d                	jne    801759 <strtol+0x9c>
  80173c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801740:	48 83 c0 01          	add    $0x1,%rax
  801744:	0f b6 00             	movzbl (%rax),%eax
  801747:	3c 78                	cmp    $0x78,%al
  801749:	75 0e                	jne    801759 <strtol+0x9c>
		s += 2, base = 16;
  80174b:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801750:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801757:	eb 2c                	jmp    801785 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801759:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80175d:	75 19                	jne    801778 <strtol+0xbb>
  80175f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801763:	0f b6 00             	movzbl (%rax),%eax
  801766:	3c 30                	cmp    $0x30,%al
  801768:	75 0e                	jne    801778 <strtol+0xbb>
		s++, base = 8;
  80176a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80176f:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801776:	eb 0d                	jmp    801785 <strtol+0xc8>
	else if (base == 0)
  801778:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80177c:	75 07                	jne    801785 <strtol+0xc8>
		base = 10;
  80177e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801785:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801789:	0f b6 00             	movzbl (%rax),%eax
  80178c:	3c 2f                	cmp    $0x2f,%al
  80178e:	7e 1d                	jle    8017ad <strtol+0xf0>
  801790:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801794:	0f b6 00             	movzbl (%rax),%eax
  801797:	3c 39                	cmp    $0x39,%al
  801799:	7f 12                	jg     8017ad <strtol+0xf0>
			dig = *s - '0';
  80179b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179f:	0f b6 00             	movzbl (%rax),%eax
  8017a2:	0f be c0             	movsbl %al,%eax
  8017a5:	83 e8 30             	sub    $0x30,%eax
  8017a8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017ab:	eb 4e                	jmp    8017fb <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8017ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b1:	0f b6 00             	movzbl (%rax),%eax
  8017b4:	3c 60                	cmp    $0x60,%al
  8017b6:	7e 1d                	jle    8017d5 <strtol+0x118>
  8017b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bc:	0f b6 00             	movzbl (%rax),%eax
  8017bf:	3c 7a                	cmp    $0x7a,%al
  8017c1:	7f 12                	jg     8017d5 <strtol+0x118>
			dig = *s - 'a' + 10;
  8017c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c7:	0f b6 00             	movzbl (%rax),%eax
  8017ca:	0f be c0             	movsbl %al,%eax
  8017cd:	83 e8 57             	sub    $0x57,%eax
  8017d0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017d3:	eb 26                	jmp    8017fb <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8017d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d9:	0f b6 00             	movzbl (%rax),%eax
  8017dc:	3c 40                	cmp    $0x40,%al
  8017de:	7e 48                	jle    801828 <strtol+0x16b>
  8017e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e4:	0f b6 00             	movzbl (%rax),%eax
  8017e7:	3c 5a                	cmp    $0x5a,%al
  8017e9:	7f 3d                	jg     801828 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8017eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ef:	0f b6 00             	movzbl (%rax),%eax
  8017f2:	0f be c0             	movsbl %al,%eax
  8017f5:	83 e8 37             	sub    $0x37,%eax
  8017f8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8017fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017fe:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801801:	7c 02                	jl     801805 <strtol+0x148>
			break;
  801803:	eb 23                	jmp    801828 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801805:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80180a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80180d:	48 98                	cltq   
  80180f:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801814:	48 89 c2             	mov    %rax,%rdx
  801817:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80181a:	48 98                	cltq   
  80181c:	48 01 d0             	add    %rdx,%rax
  80181f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801823:	e9 5d ff ff ff       	jmpq   801785 <strtol+0xc8>

	if (endptr)
  801828:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80182d:	74 0b                	je     80183a <strtol+0x17d>
		*endptr = (char *) s;
  80182f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801833:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801837:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80183a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80183e:	74 09                	je     801849 <strtol+0x18c>
  801840:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801844:	48 f7 d8             	neg    %rax
  801847:	eb 04                	jmp    80184d <strtol+0x190>
  801849:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80184d:	c9                   	leaveq 
  80184e:	c3                   	retq   

000000000080184f <strstr>:

char * strstr(const char *in, const char *str)
{
  80184f:	55                   	push   %rbp
  801850:	48 89 e5             	mov    %rsp,%rbp
  801853:	48 83 ec 30          	sub    $0x30,%rsp
  801857:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80185b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80185f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801863:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801867:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80186b:	0f b6 00             	movzbl (%rax),%eax
  80186e:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801871:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801875:	75 06                	jne    80187d <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801877:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187b:	eb 6b                	jmp    8018e8 <strstr+0x99>

	len = strlen(str);
  80187d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801881:	48 89 c7             	mov    %rax,%rdi
  801884:	48 b8 25 11 80 00 00 	movabs $0x801125,%rax
  80188b:	00 00 00 
  80188e:	ff d0                	callq  *%rax
  801890:	48 98                	cltq   
  801892:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801896:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80189a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80189e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018a2:	0f b6 00             	movzbl (%rax),%eax
  8018a5:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8018a8:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8018ac:	75 07                	jne    8018b5 <strstr+0x66>
				return (char *) 0;
  8018ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b3:	eb 33                	jmp    8018e8 <strstr+0x99>
		} while (sc != c);
  8018b5:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8018b9:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8018bc:	75 d8                	jne    801896 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8018be:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018c2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8018c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ca:	48 89 ce             	mov    %rcx,%rsi
  8018cd:	48 89 c7             	mov    %rax,%rdi
  8018d0:	48 b8 46 13 80 00 00 	movabs $0x801346,%rax
  8018d7:	00 00 00 
  8018da:	ff d0                	callq  *%rax
  8018dc:	85 c0                	test   %eax,%eax
  8018de:	75 b6                	jne    801896 <strstr+0x47>

	return (char *) (in - 1);
  8018e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e4:	48 83 e8 01          	sub    $0x1,%rax
}
  8018e8:	c9                   	leaveq 
  8018e9:	c3                   	retq   

00000000008018ea <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8018ea:	55                   	push   %rbp
  8018eb:	48 89 e5             	mov    %rsp,%rbp
  8018ee:	53                   	push   %rbx
  8018ef:	48 83 ec 48          	sub    $0x48,%rsp
  8018f3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8018f6:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8018f9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018fd:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801901:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801905:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801909:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80190c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801910:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801914:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801918:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80191c:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801920:	4c 89 c3             	mov    %r8,%rbx
  801923:	cd 30                	int    $0x30
  801925:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801929:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80192d:	74 3e                	je     80196d <syscall+0x83>
  80192f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801934:	7e 37                	jle    80196d <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801936:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80193a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80193d:	49 89 d0             	mov    %rdx,%r8
  801940:	89 c1                	mov    %eax,%ecx
  801942:	48 ba 88 47 80 00 00 	movabs $0x804788,%rdx
  801949:	00 00 00 
  80194c:	be 23 00 00 00       	mov    $0x23,%esi
  801951:	48 bf a5 47 80 00 00 	movabs $0x8047a5,%rdi
  801958:	00 00 00 
  80195b:	b8 00 00 00 00       	mov    $0x0,%eax
  801960:	49 b9 be 03 80 00 00 	movabs $0x8003be,%r9
  801967:	00 00 00 
  80196a:	41 ff d1             	callq  *%r9

	return ret;
  80196d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801971:	48 83 c4 48          	add    $0x48,%rsp
  801975:	5b                   	pop    %rbx
  801976:	5d                   	pop    %rbp
  801977:	c3                   	retq   

0000000000801978 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801978:	55                   	push   %rbp
  801979:	48 89 e5             	mov    %rsp,%rbp
  80197c:	48 83 ec 10          	sub    $0x10,%rsp
  801980:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801984:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801988:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80198c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801990:	48 83 ec 08          	sub    $0x8,%rsp
  801994:	6a 00                	pushq  $0x0
  801996:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80199c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019a2:	48 89 d1             	mov    %rdx,%rcx
  8019a5:	48 89 c2             	mov    %rax,%rdx
  8019a8:	be 00 00 00 00       	mov    $0x0,%esi
  8019ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8019b2:	48 b8 ea 18 80 00 00 	movabs $0x8018ea,%rax
  8019b9:	00 00 00 
  8019bc:	ff d0                	callq  *%rax
  8019be:	48 83 c4 10          	add    $0x10,%rsp
}
  8019c2:	c9                   	leaveq 
  8019c3:	c3                   	retq   

00000000008019c4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019c4:	55                   	push   %rbp
  8019c5:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8019c8:	48 83 ec 08          	sub    $0x8,%rsp
  8019cc:	6a 00                	pushq  $0x0
  8019ce:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019da:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019df:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e4:	be 00 00 00 00       	mov    $0x0,%esi
  8019e9:	bf 01 00 00 00       	mov    $0x1,%edi
  8019ee:	48 b8 ea 18 80 00 00 	movabs $0x8018ea,%rax
  8019f5:	00 00 00 
  8019f8:	ff d0                	callq  *%rax
  8019fa:	48 83 c4 10          	add    $0x10,%rsp
}
  8019fe:	c9                   	leaveq 
  8019ff:	c3                   	retq   

0000000000801a00 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a00:	55                   	push   %rbp
  801a01:	48 89 e5             	mov    %rsp,%rbp
  801a04:	48 83 ec 10          	sub    $0x10,%rsp
  801a08:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a0e:	48 98                	cltq   
  801a10:	48 83 ec 08          	sub    $0x8,%rsp
  801a14:	6a 00                	pushq  $0x0
  801a16:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a1c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a22:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a27:	48 89 c2             	mov    %rax,%rdx
  801a2a:	be 01 00 00 00       	mov    $0x1,%esi
  801a2f:	bf 03 00 00 00       	mov    $0x3,%edi
  801a34:	48 b8 ea 18 80 00 00 	movabs $0x8018ea,%rax
  801a3b:	00 00 00 
  801a3e:	ff d0                	callq  *%rax
  801a40:	48 83 c4 10          	add    $0x10,%rsp
}
  801a44:	c9                   	leaveq 
  801a45:	c3                   	retq   

0000000000801a46 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a46:	55                   	push   %rbp
  801a47:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a4a:	48 83 ec 08          	sub    $0x8,%rsp
  801a4e:	6a 00                	pushq  $0x0
  801a50:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a56:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a5c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a61:	ba 00 00 00 00       	mov    $0x0,%edx
  801a66:	be 00 00 00 00       	mov    $0x0,%esi
  801a6b:	bf 02 00 00 00       	mov    $0x2,%edi
  801a70:	48 b8 ea 18 80 00 00 	movabs $0x8018ea,%rax
  801a77:	00 00 00 
  801a7a:	ff d0                	callq  *%rax
  801a7c:	48 83 c4 10          	add    $0x10,%rsp
}
  801a80:	c9                   	leaveq 
  801a81:	c3                   	retq   

0000000000801a82 <sys_yield>:

void
sys_yield(void)
{
  801a82:	55                   	push   %rbp
  801a83:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a86:	48 83 ec 08          	sub    $0x8,%rsp
  801a8a:	6a 00                	pushq  $0x0
  801a8c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a92:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a98:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a9d:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa2:	be 00 00 00 00       	mov    $0x0,%esi
  801aa7:	bf 0b 00 00 00       	mov    $0xb,%edi
  801aac:	48 b8 ea 18 80 00 00 	movabs $0x8018ea,%rax
  801ab3:	00 00 00 
  801ab6:	ff d0                	callq  *%rax
  801ab8:	48 83 c4 10          	add    $0x10,%rsp
}
  801abc:	c9                   	leaveq 
  801abd:	c3                   	retq   

0000000000801abe <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801abe:	55                   	push   %rbp
  801abf:	48 89 e5             	mov    %rsp,%rbp
  801ac2:	48 83 ec 10          	sub    $0x10,%rsp
  801ac6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ac9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801acd:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801ad0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ad3:	48 63 c8             	movslq %eax,%rcx
  801ad6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ada:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801add:	48 98                	cltq   
  801adf:	48 83 ec 08          	sub    $0x8,%rsp
  801ae3:	6a 00                	pushq  $0x0
  801ae5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aeb:	49 89 c8             	mov    %rcx,%r8
  801aee:	48 89 d1             	mov    %rdx,%rcx
  801af1:	48 89 c2             	mov    %rax,%rdx
  801af4:	be 01 00 00 00       	mov    $0x1,%esi
  801af9:	bf 04 00 00 00       	mov    $0x4,%edi
  801afe:	48 b8 ea 18 80 00 00 	movabs $0x8018ea,%rax
  801b05:	00 00 00 
  801b08:	ff d0                	callq  *%rax
  801b0a:	48 83 c4 10          	add    $0x10,%rsp
}
  801b0e:	c9                   	leaveq 
  801b0f:	c3                   	retq   

0000000000801b10 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b10:	55                   	push   %rbp
  801b11:	48 89 e5             	mov    %rsp,%rbp
  801b14:	48 83 ec 20          	sub    $0x20,%rsp
  801b18:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b1b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b1f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b22:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b26:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b2a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b2d:	48 63 c8             	movslq %eax,%rcx
  801b30:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b34:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b37:	48 63 f0             	movslq %eax,%rsi
  801b3a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b41:	48 98                	cltq   
  801b43:	48 83 ec 08          	sub    $0x8,%rsp
  801b47:	51                   	push   %rcx
  801b48:	49 89 f9             	mov    %rdi,%r9
  801b4b:	49 89 f0             	mov    %rsi,%r8
  801b4e:	48 89 d1             	mov    %rdx,%rcx
  801b51:	48 89 c2             	mov    %rax,%rdx
  801b54:	be 01 00 00 00       	mov    $0x1,%esi
  801b59:	bf 05 00 00 00       	mov    $0x5,%edi
  801b5e:	48 b8 ea 18 80 00 00 	movabs $0x8018ea,%rax
  801b65:	00 00 00 
  801b68:	ff d0                	callq  *%rax
  801b6a:	48 83 c4 10          	add    $0x10,%rsp
}
  801b6e:	c9                   	leaveq 
  801b6f:	c3                   	retq   

0000000000801b70 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b70:	55                   	push   %rbp
  801b71:	48 89 e5             	mov    %rsp,%rbp
  801b74:	48 83 ec 10          	sub    $0x10,%rsp
  801b78:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b7b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b7f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b86:	48 98                	cltq   
  801b88:	48 83 ec 08          	sub    $0x8,%rsp
  801b8c:	6a 00                	pushq  $0x0
  801b8e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b94:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b9a:	48 89 d1             	mov    %rdx,%rcx
  801b9d:	48 89 c2             	mov    %rax,%rdx
  801ba0:	be 01 00 00 00       	mov    $0x1,%esi
  801ba5:	bf 06 00 00 00       	mov    $0x6,%edi
  801baa:	48 b8 ea 18 80 00 00 	movabs $0x8018ea,%rax
  801bb1:	00 00 00 
  801bb4:	ff d0                	callq  *%rax
  801bb6:	48 83 c4 10          	add    $0x10,%rsp
}
  801bba:	c9                   	leaveq 
  801bbb:	c3                   	retq   

0000000000801bbc <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801bbc:	55                   	push   %rbp
  801bbd:	48 89 e5             	mov    %rsp,%rbp
  801bc0:	48 83 ec 10          	sub    $0x10,%rsp
  801bc4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bc7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801bca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bcd:	48 63 d0             	movslq %eax,%rdx
  801bd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bd3:	48 98                	cltq   
  801bd5:	48 83 ec 08          	sub    $0x8,%rsp
  801bd9:	6a 00                	pushq  $0x0
  801bdb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801be1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801be7:	48 89 d1             	mov    %rdx,%rcx
  801bea:	48 89 c2             	mov    %rax,%rdx
  801bed:	be 01 00 00 00       	mov    $0x1,%esi
  801bf2:	bf 08 00 00 00       	mov    $0x8,%edi
  801bf7:	48 b8 ea 18 80 00 00 	movabs $0x8018ea,%rax
  801bfe:	00 00 00 
  801c01:	ff d0                	callq  *%rax
  801c03:	48 83 c4 10          	add    $0x10,%rsp
}
  801c07:	c9                   	leaveq 
  801c08:	c3                   	retq   

0000000000801c09 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c09:	55                   	push   %rbp
  801c0a:	48 89 e5             	mov    %rsp,%rbp
  801c0d:	48 83 ec 10          	sub    $0x10,%rsp
  801c11:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c14:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c18:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c1f:	48 98                	cltq   
  801c21:	48 83 ec 08          	sub    $0x8,%rsp
  801c25:	6a 00                	pushq  $0x0
  801c27:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c2d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c33:	48 89 d1             	mov    %rdx,%rcx
  801c36:	48 89 c2             	mov    %rax,%rdx
  801c39:	be 01 00 00 00       	mov    $0x1,%esi
  801c3e:	bf 09 00 00 00       	mov    $0x9,%edi
  801c43:	48 b8 ea 18 80 00 00 	movabs $0x8018ea,%rax
  801c4a:	00 00 00 
  801c4d:	ff d0                	callq  *%rax
  801c4f:	48 83 c4 10          	add    $0x10,%rsp
}
  801c53:	c9                   	leaveq 
  801c54:	c3                   	retq   

0000000000801c55 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c55:	55                   	push   %rbp
  801c56:	48 89 e5             	mov    %rsp,%rbp
  801c59:	48 83 ec 10          	sub    $0x10,%rsp
  801c5d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c60:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c64:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c6b:	48 98                	cltq   
  801c6d:	48 83 ec 08          	sub    $0x8,%rsp
  801c71:	6a 00                	pushq  $0x0
  801c73:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c79:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c7f:	48 89 d1             	mov    %rdx,%rcx
  801c82:	48 89 c2             	mov    %rax,%rdx
  801c85:	be 01 00 00 00       	mov    $0x1,%esi
  801c8a:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c8f:	48 b8 ea 18 80 00 00 	movabs $0x8018ea,%rax
  801c96:	00 00 00 
  801c99:	ff d0                	callq  *%rax
  801c9b:	48 83 c4 10          	add    $0x10,%rsp
}
  801c9f:	c9                   	leaveq 
  801ca0:	c3                   	retq   

0000000000801ca1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ca1:	55                   	push   %rbp
  801ca2:	48 89 e5             	mov    %rsp,%rbp
  801ca5:	48 83 ec 20          	sub    $0x20,%rsp
  801ca9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cb0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801cb4:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801cb7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cba:	48 63 f0             	movslq %eax,%rsi
  801cbd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801cc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cc4:	48 98                	cltq   
  801cc6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cca:	48 83 ec 08          	sub    $0x8,%rsp
  801cce:	6a 00                	pushq  $0x0
  801cd0:	49 89 f1             	mov    %rsi,%r9
  801cd3:	49 89 c8             	mov    %rcx,%r8
  801cd6:	48 89 d1             	mov    %rdx,%rcx
  801cd9:	48 89 c2             	mov    %rax,%rdx
  801cdc:	be 00 00 00 00       	mov    $0x0,%esi
  801ce1:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ce6:	48 b8 ea 18 80 00 00 	movabs $0x8018ea,%rax
  801ced:	00 00 00 
  801cf0:	ff d0                	callq  *%rax
  801cf2:	48 83 c4 10          	add    $0x10,%rsp
}
  801cf6:	c9                   	leaveq 
  801cf7:	c3                   	retq   

0000000000801cf8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801cf8:	55                   	push   %rbp
  801cf9:	48 89 e5             	mov    %rsp,%rbp
  801cfc:	48 83 ec 10          	sub    $0x10,%rsp
  801d00:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d08:	48 83 ec 08          	sub    $0x8,%rsp
  801d0c:	6a 00                	pushq  $0x0
  801d0e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d14:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d1a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d1f:	48 89 c2             	mov    %rax,%rdx
  801d22:	be 01 00 00 00       	mov    $0x1,%esi
  801d27:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d2c:	48 b8 ea 18 80 00 00 	movabs $0x8018ea,%rax
  801d33:	00 00 00 
  801d36:	ff d0                	callq  *%rax
  801d38:	48 83 c4 10          	add    $0x10,%rsp
}
  801d3c:	c9                   	leaveq 
  801d3d:	c3                   	retq   

0000000000801d3e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801d3e:	55                   	push   %rbp
  801d3f:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801d42:	48 83 ec 08          	sub    $0x8,%rsp
  801d46:	6a 00                	pushq  $0x0
  801d48:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d4e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d54:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d59:	ba 00 00 00 00       	mov    $0x0,%edx
  801d5e:	be 00 00 00 00       	mov    $0x0,%esi
  801d63:	bf 0e 00 00 00       	mov    $0xe,%edi
  801d68:	48 b8 ea 18 80 00 00 	movabs $0x8018ea,%rax
  801d6f:	00 00 00 
  801d72:	ff d0                	callq  *%rax
  801d74:	48 83 c4 10          	add    $0x10,%rsp
}
  801d78:	c9                   	leaveq 
  801d79:	c3                   	retq   

0000000000801d7a <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801d7a:	55                   	push   %rbp
  801d7b:	48 89 e5             	mov    %rsp,%rbp
  801d7e:	48 83 ec 20          	sub    $0x20,%rsp
  801d82:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d85:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d89:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d8c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d90:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801d94:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d97:	48 63 c8             	movslq %eax,%rcx
  801d9a:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d9e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801da1:	48 63 f0             	movslq %eax,%rsi
  801da4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801da8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dab:	48 98                	cltq   
  801dad:	48 83 ec 08          	sub    $0x8,%rsp
  801db1:	51                   	push   %rcx
  801db2:	49 89 f9             	mov    %rdi,%r9
  801db5:	49 89 f0             	mov    %rsi,%r8
  801db8:	48 89 d1             	mov    %rdx,%rcx
  801dbb:	48 89 c2             	mov    %rax,%rdx
  801dbe:	be 00 00 00 00       	mov    $0x0,%esi
  801dc3:	bf 0f 00 00 00       	mov    $0xf,%edi
  801dc8:	48 b8 ea 18 80 00 00 	movabs $0x8018ea,%rax
  801dcf:	00 00 00 
  801dd2:	ff d0                	callq  *%rax
  801dd4:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801dd8:	c9                   	leaveq 
  801dd9:	c3                   	retq   

0000000000801dda <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801dda:	55                   	push   %rbp
  801ddb:	48 89 e5             	mov    %rsp,%rbp
  801dde:	48 83 ec 10          	sub    $0x10,%rsp
  801de2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801de6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801dea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801df2:	48 83 ec 08          	sub    $0x8,%rsp
  801df6:	6a 00                	pushq  $0x0
  801df8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dfe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e04:	48 89 d1             	mov    %rdx,%rcx
  801e07:	48 89 c2             	mov    %rax,%rdx
  801e0a:	be 00 00 00 00       	mov    $0x0,%esi
  801e0f:	bf 10 00 00 00       	mov    $0x10,%edi
  801e14:	48 b8 ea 18 80 00 00 	movabs $0x8018ea,%rax
  801e1b:	00 00 00 
  801e1e:	ff d0                	callq  *%rax
  801e20:	48 83 c4 10          	add    $0x10,%rsp
}
  801e24:	c9                   	leaveq 
  801e25:	c3                   	retq   

0000000000801e26 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801e26:	55                   	push   %rbp
  801e27:	48 89 e5             	mov    %rsp,%rbp
  801e2a:	48 83 ec 20          	sub    $0x20,%rsp
  801e2e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801e32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e36:	48 8b 00             	mov    (%rax),%rax
  801e39:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801e3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e41:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e45:	89 45 f4             	mov    %eax,-0xc(%rbp)
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  801e48:	48 ba b3 47 80 00 00 	movabs $0x8047b3,%rdx
  801e4f:	00 00 00 
  801e52:	be 26 00 00 00       	mov    $0x26,%esi
  801e57:	48 bf cb 47 80 00 00 	movabs $0x8047cb,%rdi
  801e5e:	00 00 00 
  801e61:	b8 00 00 00 00       	mov    $0x0,%eax
  801e66:	48 b9 be 03 80 00 00 	movabs $0x8003be,%rcx
  801e6d:	00 00 00 
  801e70:	ff d1                	callq  *%rcx

0000000000801e72 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801e72:	55                   	push   %rbp
  801e73:	48 89 e5             	mov    %rsp,%rbp
  801e76:	48 83 ec 10          	sub    $0x10,%rsp
  801e7a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e7d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	int r;

	// LAB 4: Your code here.
	panic("duppage not implemented");
  801e80:	48 ba d6 47 80 00 00 	movabs $0x8047d6,%rdx
  801e87:	00 00 00 
  801e8a:	be 3a 00 00 00       	mov    $0x3a,%esi
  801e8f:	48 bf cb 47 80 00 00 	movabs $0x8047cb,%rdi
  801e96:	00 00 00 
  801e99:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9e:	48 b9 be 03 80 00 00 	movabs $0x8003be,%rcx
  801ea5:	00 00 00 
  801ea8:	ff d1                	callq  *%rcx

0000000000801eaa <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801eaa:	55                   	push   %rbp
  801eab:	48 89 e5             	mov    %rsp,%rbp
	// LAB 4: Your code here.
	panic("fork not implemented");
  801eae:	48 ba ee 47 80 00 00 	movabs $0x8047ee,%rdx
  801eb5:	00 00 00 
  801eb8:	be 52 00 00 00       	mov    $0x52,%esi
  801ebd:	48 bf cb 47 80 00 00 	movabs $0x8047cb,%rdi
  801ec4:	00 00 00 
  801ec7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecc:	48 b9 be 03 80 00 00 	movabs $0x8003be,%rcx
  801ed3:	00 00 00 
  801ed6:	ff d1                	callq  *%rcx

0000000000801ed8 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801ed8:	55                   	push   %rbp
  801ed9:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  801edc:	48 ba 03 48 80 00 00 	movabs $0x804803,%rdx
  801ee3:	00 00 00 
  801ee6:	be 59 00 00 00       	mov    $0x59,%esi
  801eeb:	48 bf cb 47 80 00 00 	movabs $0x8047cb,%rdi
  801ef2:	00 00 00 
  801ef5:	b8 00 00 00 00       	mov    $0x0,%eax
  801efa:	48 b9 be 03 80 00 00 	movabs $0x8003be,%rcx
  801f01:	00 00 00 
  801f04:	ff d1                	callq  *%rcx

0000000000801f06 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801f06:	55                   	push   %rbp
  801f07:	48 89 e5             	mov    %rsp,%rbp
  801f0a:	48 83 ec 08          	sub    $0x8,%rsp
  801f0e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801f12:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f16:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801f1d:	ff ff ff 
  801f20:	48 01 d0             	add    %rdx,%rax
  801f23:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801f27:	c9                   	leaveq 
  801f28:	c3                   	retq   

0000000000801f29 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801f29:	55                   	push   %rbp
  801f2a:	48 89 e5             	mov    %rsp,%rbp
  801f2d:	48 83 ec 08          	sub    $0x8,%rsp
  801f31:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801f35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f39:	48 89 c7             	mov    %rax,%rdi
  801f3c:	48 b8 06 1f 80 00 00 	movabs $0x801f06,%rax
  801f43:	00 00 00 
  801f46:	ff d0                	callq  *%rax
  801f48:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801f4e:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801f52:	c9                   	leaveq 
  801f53:	c3                   	retq   

0000000000801f54 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801f54:	55                   	push   %rbp
  801f55:	48 89 e5             	mov    %rsp,%rbp
  801f58:	48 83 ec 18          	sub    $0x18,%rsp
  801f5c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f67:	eb 6b                	jmp    801fd4 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801f69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f6c:	48 98                	cltq   
  801f6e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f74:	48 c1 e0 0c          	shl    $0xc,%rax
  801f78:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801f7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f80:	48 c1 e8 15          	shr    $0x15,%rax
  801f84:	48 89 c2             	mov    %rax,%rdx
  801f87:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f8e:	01 00 00 
  801f91:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f95:	83 e0 01             	and    $0x1,%eax
  801f98:	48 85 c0             	test   %rax,%rax
  801f9b:	74 21                	je     801fbe <fd_alloc+0x6a>
  801f9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fa1:	48 c1 e8 0c          	shr    $0xc,%rax
  801fa5:	48 89 c2             	mov    %rax,%rdx
  801fa8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801faf:	01 00 00 
  801fb2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fb6:	83 e0 01             	and    $0x1,%eax
  801fb9:	48 85 c0             	test   %rax,%rax
  801fbc:	75 12                	jne    801fd0 <fd_alloc+0x7c>
			*fd_store = fd;
  801fbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fc2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fc6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801fc9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fce:	eb 1a                	jmp    801fea <fd_alloc+0x96>
	for (i = 0; i < MAXFD; i++) {
  801fd0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fd4:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801fd8:	7e 8f                	jle    801f69 <fd_alloc+0x15>
		}
	}
	*fd_store = 0;
  801fda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fde:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801fe5:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801fea:	c9                   	leaveq 
  801feb:	c3                   	retq   

0000000000801fec <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801fec:	55                   	push   %rbp
  801fed:	48 89 e5             	mov    %rsp,%rbp
  801ff0:	48 83 ec 20          	sub    $0x20,%rsp
  801ff4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ff7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ffb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801fff:	78 06                	js     802007 <fd_lookup+0x1b>
  802001:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802005:	7e 07                	jle    80200e <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802007:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80200c:	eb 6c                	jmp    80207a <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80200e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802011:	48 98                	cltq   
  802013:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802019:	48 c1 e0 0c          	shl    $0xc,%rax
  80201d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802021:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802025:	48 c1 e8 15          	shr    $0x15,%rax
  802029:	48 89 c2             	mov    %rax,%rdx
  80202c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802033:	01 00 00 
  802036:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80203a:	83 e0 01             	and    $0x1,%eax
  80203d:	48 85 c0             	test   %rax,%rax
  802040:	74 21                	je     802063 <fd_lookup+0x77>
  802042:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802046:	48 c1 e8 0c          	shr    $0xc,%rax
  80204a:	48 89 c2             	mov    %rax,%rdx
  80204d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802054:	01 00 00 
  802057:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80205b:	83 e0 01             	and    $0x1,%eax
  80205e:	48 85 c0             	test   %rax,%rax
  802061:	75 07                	jne    80206a <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802063:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802068:	eb 10                	jmp    80207a <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80206a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80206e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802072:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802075:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80207a:	c9                   	leaveq 
  80207b:	c3                   	retq   

000000000080207c <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80207c:	55                   	push   %rbp
  80207d:	48 89 e5             	mov    %rsp,%rbp
  802080:	48 83 ec 30          	sub    $0x30,%rsp
  802084:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802088:	89 f0                	mov    %esi,%eax
  80208a:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80208d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802091:	48 89 c7             	mov    %rax,%rdi
  802094:	48 b8 06 1f 80 00 00 	movabs $0x801f06,%rax
  80209b:	00 00 00 
  80209e:	ff d0                	callq  *%rax
  8020a0:	89 c2                	mov    %eax,%edx
  8020a2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8020a6:	48 89 c6             	mov    %rax,%rsi
  8020a9:	89 d7                	mov    %edx,%edi
  8020ab:	48 b8 ec 1f 80 00 00 	movabs $0x801fec,%rax
  8020b2:	00 00 00 
  8020b5:	ff d0                	callq  *%rax
  8020b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020be:	78 0a                	js     8020ca <fd_close+0x4e>
	    || fd != fd2)
  8020c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020c4:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8020c8:	74 12                	je     8020dc <fd_close+0x60>
		return (must_exist ? r : 0);
  8020ca:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8020ce:	74 05                	je     8020d5 <fd_close+0x59>
  8020d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020d3:	eb 70                	jmp    802145 <fd_close+0xc9>
  8020d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020da:	eb 69                	jmp    802145 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8020dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020e0:	8b 00                	mov    (%rax),%eax
  8020e2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8020e6:	48 89 d6             	mov    %rdx,%rsi
  8020e9:	89 c7                	mov    %eax,%edi
  8020eb:	48 b8 47 21 80 00 00 	movabs $0x802147,%rax
  8020f2:	00 00 00 
  8020f5:	ff d0                	callq  *%rax
  8020f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020fe:	78 2a                	js     80212a <fd_close+0xae>
		if (dev->dev_close)
  802100:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802104:	48 8b 40 20          	mov    0x20(%rax),%rax
  802108:	48 85 c0             	test   %rax,%rax
  80210b:	74 16                	je     802123 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  80210d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802111:	48 8b 40 20          	mov    0x20(%rax),%rax
  802115:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802119:	48 89 d7             	mov    %rdx,%rdi
  80211c:	ff d0                	callq  *%rax
  80211e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802121:	eb 07                	jmp    80212a <fd_close+0xae>
		else
			r = 0;
  802123:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80212a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80212e:	48 89 c6             	mov    %rax,%rsi
  802131:	bf 00 00 00 00       	mov    $0x0,%edi
  802136:	48 b8 70 1b 80 00 00 	movabs $0x801b70,%rax
  80213d:	00 00 00 
  802140:	ff d0                	callq  *%rax
	return r;
  802142:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802145:	c9                   	leaveq 
  802146:	c3                   	retq   

0000000000802147 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802147:	55                   	push   %rbp
  802148:	48 89 e5             	mov    %rsp,%rbp
  80214b:	48 83 ec 20          	sub    $0x20,%rsp
  80214f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802152:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802156:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80215d:	eb 41                	jmp    8021a0 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80215f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802166:	00 00 00 
  802169:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80216c:	48 63 d2             	movslq %edx,%rdx
  80216f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802173:	8b 00                	mov    (%rax),%eax
  802175:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802178:	75 22                	jne    80219c <dev_lookup+0x55>
			*dev = devtab[i];
  80217a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802181:	00 00 00 
  802184:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802187:	48 63 d2             	movslq %edx,%rdx
  80218a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80218e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802192:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802195:	b8 00 00 00 00       	mov    $0x0,%eax
  80219a:	eb 60                	jmp    8021fc <dev_lookup+0xb5>
	for (i = 0; devtab[i]; i++)
  80219c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021a0:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8021a7:	00 00 00 
  8021aa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8021ad:	48 63 d2             	movslq %edx,%rdx
  8021b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021b4:	48 85 c0             	test   %rax,%rax
  8021b7:	75 a6                	jne    80215f <dev_lookup+0x18>
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8021b9:	48 b8 40 74 80 00 00 	movabs $0x807440,%rax
  8021c0:	00 00 00 
  8021c3:	48 8b 00             	mov    (%rax),%rax
  8021c6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021cc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8021cf:	89 c6                	mov    %eax,%esi
  8021d1:	48 bf 20 48 80 00 00 	movabs $0x804820,%rdi
  8021d8:	00 00 00 
  8021db:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e0:	48 b9 f7 05 80 00 00 	movabs $0x8005f7,%rcx
  8021e7:	00 00 00 
  8021ea:	ff d1                	callq  *%rcx
	*dev = 0;
  8021ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021f0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8021f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8021fc:	c9                   	leaveq 
  8021fd:	c3                   	retq   

00000000008021fe <close>:

int
close(int fdnum)
{
  8021fe:	55                   	push   %rbp
  8021ff:	48 89 e5             	mov    %rsp,%rbp
  802202:	48 83 ec 20          	sub    $0x20,%rsp
  802206:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802209:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80220d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802210:	48 89 d6             	mov    %rdx,%rsi
  802213:	89 c7                	mov    %eax,%edi
  802215:	48 b8 ec 1f 80 00 00 	movabs $0x801fec,%rax
  80221c:	00 00 00 
  80221f:	ff d0                	callq  *%rax
  802221:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802224:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802228:	79 05                	jns    80222f <close+0x31>
		return r;
  80222a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80222d:	eb 18                	jmp    802247 <close+0x49>
	else
		return fd_close(fd, 1);
  80222f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802233:	be 01 00 00 00       	mov    $0x1,%esi
  802238:	48 89 c7             	mov    %rax,%rdi
  80223b:	48 b8 7c 20 80 00 00 	movabs $0x80207c,%rax
  802242:	00 00 00 
  802245:	ff d0                	callq  *%rax
}
  802247:	c9                   	leaveq 
  802248:	c3                   	retq   

0000000000802249 <close_all>:

void
close_all(void)
{
  802249:	55                   	push   %rbp
  80224a:	48 89 e5             	mov    %rsp,%rbp
  80224d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802251:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802258:	eb 15                	jmp    80226f <close_all+0x26>
		close(i);
  80225a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80225d:	89 c7                	mov    %eax,%edi
  80225f:	48 b8 fe 21 80 00 00 	movabs $0x8021fe,%rax
  802266:	00 00 00 
  802269:	ff d0                	callq  *%rax
	for (i = 0; i < MAXFD; i++)
  80226b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80226f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802273:	7e e5                	jle    80225a <close_all+0x11>
}
  802275:	c9                   	leaveq 
  802276:	c3                   	retq   

0000000000802277 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802277:	55                   	push   %rbp
  802278:	48 89 e5             	mov    %rsp,%rbp
  80227b:	48 83 ec 40          	sub    $0x40,%rsp
  80227f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802282:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802285:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802289:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80228c:	48 89 d6             	mov    %rdx,%rsi
  80228f:	89 c7                	mov    %eax,%edi
  802291:	48 b8 ec 1f 80 00 00 	movabs $0x801fec,%rax
  802298:	00 00 00 
  80229b:	ff d0                	callq  *%rax
  80229d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022a4:	79 08                	jns    8022ae <dup+0x37>
		return r;
  8022a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022a9:	e9 70 01 00 00       	jmpq   80241e <dup+0x1a7>
	close(newfdnum);
  8022ae:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022b1:	89 c7                	mov    %eax,%edi
  8022b3:	48 b8 fe 21 80 00 00 	movabs $0x8021fe,%rax
  8022ba:	00 00 00 
  8022bd:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8022bf:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022c2:	48 98                	cltq   
  8022c4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022ca:	48 c1 e0 0c          	shl    $0xc,%rax
  8022ce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8022d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022d6:	48 89 c7             	mov    %rax,%rdi
  8022d9:	48 b8 29 1f 80 00 00 	movabs $0x801f29,%rax
  8022e0:	00 00 00 
  8022e3:	ff d0                	callq  *%rax
  8022e5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8022e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ed:	48 89 c7             	mov    %rax,%rdi
  8022f0:	48 b8 29 1f 80 00 00 	movabs $0x801f29,%rax
  8022f7:	00 00 00 
  8022fa:	ff d0                	callq  *%rax
  8022fc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802300:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802304:	48 c1 e8 15          	shr    $0x15,%rax
  802308:	48 89 c2             	mov    %rax,%rdx
  80230b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802312:	01 00 00 
  802315:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802319:	83 e0 01             	and    $0x1,%eax
  80231c:	48 85 c0             	test   %rax,%rax
  80231f:	74 73                	je     802394 <dup+0x11d>
  802321:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802325:	48 c1 e8 0c          	shr    $0xc,%rax
  802329:	48 89 c2             	mov    %rax,%rdx
  80232c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802333:	01 00 00 
  802336:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80233a:	83 e0 01             	and    $0x1,%eax
  80233d:	48 85 c0             	test   %rax,%rax
  802340:	74 52                	je     802394 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802342:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802346:	48 c1 e8 0c          	shr    $0xc,%rax
  80234a:	48 89 c2             	mov    %rax,%rdx
  80234d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802354:	01 00 00 
  802357:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80235b:	25 07 0e 00 00       	and    $0xe07,%eax
  802360:	89 c1                	mov    %eax,%ecx
  802362:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802366:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80236a:	41 89 c8             	mov    %ecx,%r8d
  80236d:	48 89 d1             	mov    %rdx,%rcx
  802370:	ba 00 00 00 00       	mov    $0x0,%edx
  802375:	48 89 c6             	mov    %rax,%rsi
  802378:	bf 00 00 00 00       	mov    $0x0,%edi
  80237d:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  802384:	00 00 00 
  802387:	ff d0                	callq  *%rax
  802389:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80238c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802390:	79 02                	jns    802394 <dup+0x11d>
			goto err;
  802392:	eb 57                	jmp    8023eb <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802394:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802398:	48 c1 e8 0c          	shr    $0xc,%rax
  80239c:	48 89 c2             	mov    %rax,%rdx
  80239f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023a6:	01 00 00 
  8023a9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023ad:	25 07 0e 00 00       	and    $0xe07,%eax
  8023b2:	89 c1                	mov    %eax,%ecx
  8023b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023bc:	41 89 c8             	mov    %ecx,%r8d
  8023bf:	48 89 d1             	mov    %rdx,%rcx
  8023c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8023c7:	48 89 c6             	mov    %rax,%rsi
  8023ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8023cf:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  8023d6:	00 00 00 
  8023d9:	ff d0                	callq  *%rax
  8023db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e2:	79 02                	jns    8023e6 <dup+0x16f>
		goto err;
  8023e4:	eb 05                	jmp    8023eb <dup+0x174>

	return newfdnum;
  8023e6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8023e9:	eb 33                	jmp    80241e <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8023eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023ef:	48 89 c6             	mov    %rax,%rsi
  8023f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8023f7:	48 b8 70 1b 80 00 00 	movabs $0x801b70,%rax
  8023fe:	00 00 00 
  802401:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802403:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802407:	48 89 c6             	mov    %rax,%rsi
  80240a:	bf 00 00 00 00       	mov    $0x0,%edi
  80240f:	48 b8 70 1b 80 00 00 	movabs $0x801b70,%rax
  802416:	00 00 00 
  802419:	ff d0                	callq  *%rax
	return r;
  80241b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80241e:	c9                   	leaveq 
  80241f:	c3                   	retq   

0000000000802420 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802420:	55                   	push   %rbp
  802421:	48 89 e5             	mov    %rsp,%rbp
  802424:	48 83 ec 40          	sub    $0x40,%rsp
  802428:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80242b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80242f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802433:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802437:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80243a:	48 89 d6             	mov    %rdx,%rsi
  80243d:	89 c7                	mov    %eax,%edi
  80243f:	48 b8 ec 1f 80 00 00 	movabs $0x801fec,%rax
  802446:	00 00 00 
  802449:	ff d0                	callq  *%rax
  80244b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80244e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802452:	78 24                	js     802478 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802454:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802458:	8b 00                	mov    (%rax),%eax
  80245a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80245e:	48 89 d6             	mov    %rdx,%rsi
  802461:	89 c7                	mov    %eax,%edi
  802463:	48 b8 47 21 80 00 00 	movabs $0x802147,%rax
  80246a:	00 00 00 
  80246d:	ff d0                	callq  *%rax
  80246f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802472:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802476:	79 05                	jns    80247d <read+0x5d>
		return r;
  802478:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80247b:	eb 76                	jmp    8024f3 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80247d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802481:	8b 40 08             	mov    0x8(%rax),%eax
  802484:	83 e0 03             	and    $0x3,%eax
  802487:	83 f8 01             	cmp    $0x1,%eax
  80248a:	75 3a                	jne    8024c6 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80248c:	48 b8 40 74 80 00 00 	movabs $0x807440,%rax
  802493:	00 00 00 
  802496:	48 8b 00             	mov    (%rax),%rax
  802499:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80249f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024a2:	89 c6                	mov    %eax,%esi
  8024a4:	48 bf 3f 48 80 00 00 	movabs $0x80483f,%rdi
  8024ab:	00 00 00 
  8024ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b3:	48 b9 f7 05 80 00 00 	movabs $0x8005f7,%rcx
  8024ba:	00 00 00 
  8024bd:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024c4:	eb 2d                	jmp    8024f3 <read+0xd3>
	}
	if (!dev->dev_read)
  8024c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ca:	48 8b 40 10          	mov    0x10(%rax),%rax
  8024ce:	48 85 c0             	test   %rax,%rax
  8024d1:	75 07                	jne    8024da <read+0xba>
		return -E_NOT_SUPP;
  8024d3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024d8:	eb 19                	jmp    8024f3 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8024da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024de:	48 8b 40 10          	mov    0x10(%rax),%rax
  8024e2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024e6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024ea:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024ee:	48 89 cf             	mov    %rcx,%rdi
  8024f1:	ff d0                	callq  *%rax
}
  8024f3:	c9                   	leaveq 
  8024f4:	c3                   	retq   

00000000008024f5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8024f5:	55                   	push   %rbp
  8024f6:	48 89 e5             	mov    %rsp,%rbp
  8024f9:	48 83 ec 30          	sub    $0x30,%rsp
  8024fd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802500:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802504:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802508:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80250f:	eb 49                	jmp    80255a <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802511:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802514:	48 98                	cltq   
  802516:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80251a:	48 29 c2             	sub    %rax,%rdx
  80251d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802520:	48 63 c8             	movslq %eax,%rcx
  802523:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802527:	48 01 c1             	add    %rax,%rcx
  80252a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80252d:	48 89 ce             	mov    %rcx,%rsi
  802530:	89 c7                	mov    %eax,%edi
  802532:	48 b8 20 24 80 00 00 	movabs $0x802420,%rax
  802539:	00 00 00 
  80253c:	ff d0                	callq  *%rax
  80253e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802541:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802545:	79 05                	jns    80254c <readn+0x57>
			return m;
  802547:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80254a:	eb 1c                	jmp    802568 <readn+0x73>
		if (m == 0)
  80254c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802550:	75 02                	jne    802554 <readn+0x5f>
			break;
  802552:	eb 11                	jmp    802565 <readn+0x70>
	for (tot = 0; tot < n; tot += m) {
  802554:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802557:	01 45 fc             	add    %eax,-0x4(%rbp)
  80255a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80255d:	48 98                	cltq   
  80255f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802563:	72 ac                	jb     802511 <readn+0x1c>
	}
	return tot;
  802565:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802568:	c9                   	leaveq 
  802569:	c3                   	retq   

000000000080256a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80256a:	55                   	push   %rbp
  80256b:	48 89 e5             	mov    %rsp,%rbp
  80256e:	48 83 ec 40          	sub    $0x40,%rsp
  802572:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802575:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802579:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80257d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802581:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802584:	48 89 d6             	mov    %rdx,%rsi
  802587:	89 c7                	mov    %eax,%edi
  802589:	48 b8 ec 1f 80 00 00 	movabs $0x801fec,%rax
  802590:	00 00 00 
  802593:	ff d0                	callq  *%rax
  802595:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802598:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80259c:	78 24                	js     8025c2 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80259e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025a2:	8b 00                	mov    (%rax),%eax
  8025a4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025a8:	48 89 d6             	mov    %rdx,%rsi
  8025ab:	89 c7                	mov    %eax,%edi
  8025ad:	48 b8 47 21 80 00 00 	movabs $0x802147,%rax
  8025b4:	00 00 00 
  8025b7:	ff d0                	callq  *%rax
  8025b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025c0:	79 05                	jns    8025c7 <write+0x5d>
		return r;
  8025c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025c5:	eb 75                	jmp    80263c <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025cb:	8b 40 08             	mov    0x8(%rax),%eax
  8025ce:	83 e0 03             	and    $0x3,%eax
  8025d1:	85 c0                	test   %eax,%eax
  8025d3:	75 3a                	jne    80260f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8025d5:	48 b8 40 74 80 00 00 	movabs $0x807440,%rax
  8025dc:	00 00 00 
  8025df:	48 8b 00             	mov    (%rax),%rax
  8025e2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025e8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025eb:	89 c6                	mov    %eax,%esi
  8025ed:	48 bf 5b 48 80 00 00 	movabs $0x80485b,%rdi
  8025f4:	00 00 00 
  8025f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fc:	48 b9 f7 05 80 00 00 	movabs $0x8005f7,%rcx
  802603:	00 00 00 
  802606:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802608:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80260d:	eb 2d                	jmp    80263c <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80260f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802613:	48 8b 40 18          	mov    0x18(%rax),%rax
  802617:	48 85 c0             	test   %rax,%rax
  80261a:	75 07                	jne    802623 <write+0xb9>
		return -E_NOT_SUPP;
  80261c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802621:	eb 19                	jmp    80263c <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802623:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802627:	48 8b 40 18          	mov    0x18(%rax),%rax
  80262b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80262f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802633:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802637:	48 89 cf             	mov    %rcx,%rdi
  80263a:	ff d0                	callq  *%rax
}
  80263c:	c9                   	leaveq 
  80263d:	c3                   	retq   

000000000080263e <seek>:

int
seek(int fdnum, off_t offset)
{
  80263e:	55                   	push   %rbp
  80263f:	48 89 e5             	mov    %rsp,%rbp
  802642:	48 83 ec 18          	sub    $0x18,%rsp
  802646:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802649:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80264c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802650:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802653:	48 89 d6             	mov    %rdx,%rsi
  802656:	89 c7                	mov    %eax,%edi
  802658:	48 b8 ec 1f 80 00 00 	movabs $0x801fec,%rax
  80265f:	00 00 00 
  802662:	ff d0                	callq  *%rax
  802664:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802667:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80266b:	79 05                	jns    802672 <seek+0x34>
		return r;
  80266d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802670:	eb 0f                	jmp    802681 <seek+0x43>
	fd->fd_offset = offset;
  802672:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802676:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802679:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80267c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802681:	c9                   	leaveq 
  802682:	c3                   	retq   

0000000000802683 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802683:	55                   	push   %rbp
  802684:	48 89 e5             	mov    %rsp,%rbp
  802687:	48 83 ec 30          	sub    $0x30,%rsp
  80268b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80268e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802691:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802695:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802698:	48 89 d6             	mov    %rdx,%rsi
  80269b:	89 c7                	mov    %eax,%edi
  80269d:	48 b8 ec 1f 80 00 00 	movabs $0x801fec,%rax
  8026a4:	00 00 00 
  8026a7:	ff d0                	callq  *%rax
  8026a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026b0:	78 24                	js     8026d6 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026b6:	8b 00                	mov    (%rax),%eax
  8026b8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026bc:	48 89 d6             	mov    %rdx,%rsi
  8026bf:	89 c7                	mov    %eax,%edi
  8026c1:	48 b8 47 21 80 00 00 	movabs $0x802147,%rax
  8026c8:	00 00 00 
  8026cb:	ff d0                	callq  *%rax
  8026cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026d4:	79 05                	jns    8026db <ftruncate+0x58>
		return r;
  8026d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026d9:	eb 72                	jmp    80274d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8026db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026df:	8b 40 08             	mov    0x8(%rax),%eax
  8026e2:	83 e0 03             	and    $0x3,%eax
  8026e5:	85 c0                	test   %eax,%eax
  8026e7:	75 3a                	jne    802723 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8026e9:	48 b8 40 74 80 00 00 	movabs $0x807440,%rax
  8026f0:	00 00 00 
  8026f3:	48 8b 00             	mov    (%rax),%rax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8026f6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026fc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026ff:	89 c6                	mov    %eax,%esi
  802701:	48 bf 78 48 80 00 00 	movabs $0x804878,%rdi
  802708:	00 00 00 
  80270b:	b8 00 00 00 00       	mov    $0x0,%eax
  802710:	48 b9 f7 05 80 00 00 	movabs $0x8005f7,%rcx
  802717:	00 00 00 
  80271a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80271c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802721:	eb 2a                	jmp    80274d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802723:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802727:	48 8b 40 30          	mov    0x30(%rax),%rax
  80272b:	48 85 c0             	test   %rax,%rax
  80272e:	75 07                	jne    802737 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802730:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802735:	eb 16                	jmp    80274d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802737:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80273b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80273f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802743:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802746:	89 ce                	mov    %ecx,%esi
  802748:	48 89 d7             	mov    %rdx,%rdi
  80274b:	ff d0                	callq  *%rax
}
  80274d:	c9                   	leaveq 
  80274e:	c3                   	retq   

000000000080274f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80274f:	55                   	push   %rbp
  802750:	48 89 e5             	mov    %rsp,%rbp
  802753:	48 83 ec 30          	sub    $0x30,%rsp
  802757:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80275a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80275e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802762:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802765:	48 89 d6             	mov    %rdx,%rsi
  802768:	89 c7                	mov    %eax,%edi
  80276a:	48 b8 ec 1f 80 00 00 	movabs $0x801fec,%rax
  802771:	00 00 00 
  802774:	ff d0                	callq  *%rax
  802776:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802779:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80277d:	78 24                	js     8027a3 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80277f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802783:	8b 00                	mov    (%rax),%eax
  802785:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802789:	48 89 d6             	mov    %rdx,%rsi
  80278c:	89 c7                	mov    %eax,%edi
  80278e:	48 b8 47 21 80 00 00 	movabs $0x802147,%rax
  802795:	00 00 00 
  802798:	ff d0                	callq  *%rax
  80279a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80279d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a1:	79 05                	jns    8027a8 <fstat+0x59>
		return r;
  8027a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a6:	eb 5e                	jmp    802806 <fstat+0xb7>
	if (!dev->dev_stat)
  8027a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027ac:	48 8b 40 28          	mov    0x28(%rax),%rax
  8027b0:	48 85 c0             	test   %rax,%rax
  8027b3:	75 07                	jne    8027bc <fstat+0x6d>
		return -E_NOT_SUPP;
  8027b5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027ba:	eb 4a                	jmp    802806 <fstat+0xb7>
	stat->st_name[0] = 0;
  8027bc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027c0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8027c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027c7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8027ce:	00 00 00 
	stat->st_isdir = 0;
  8027d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027d5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8027dc:	00 00 00 
	stat->st_dev = dev;
  8027df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8027e7:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8027ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027f2:	48 8b 40 28          	mov    0x28(%rax),%rax
  8027f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8027fa:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8027fe:	48 89 ce             	mov    %rcx,%rsi
  802801:	48 89 d7             	mov    %rdx,%rdi
  802804:	ff d0                	callq  *%rax
}
  802806:	c9                   	leaveq 
  802807:	c3                   	retq   

0000000000802808 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802808:	55                   	push   %rbp
  802809:	48 89 e5             	mov    %rsp,%rbp
  80280c:	48 83 ec 20          	sub    $0x20,%rsp
  802810:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802814:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802818:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80281c:	be 00 00 00 00       	mov    $0x0,%esi
  802821:	48 89 c7             	mov    %rax,%rdi
  802824:	48 b8 f8 28 80 00 00 	movabs $0x8028f8,%rax
  80282b:	00 00 00 
  80282e:	ff d0                	callq  *%rax
  802830:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802833:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802837:	79 05                	jns    80283e <stat+0x36>
		return fd;
  802839:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80283c:	eb 2f                	jmp    80286d <stat+0x65>
	r = fstat(fd, stat);
  80283e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802842:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802845:	48 89 d6             	mov    %rdx,%rsi
  802848:	89 c7                	mov    %eax,%edi
  80284a:	48 b8 4f 27 80 00 00 	movabs $0x80274f,%rax
  802851:	00 00 00 
  802854:	ff d0                	callq  *%rax
  802856:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802859:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80285c:	89 c7                	mov    %eax,%edi
  80285e:	48 b8 fe 21 80 00 00 	movabs $0x8021fe,%rax
  802865:	00 00 00 
  802868:	ff d0                	callq  *%rax
	return r;
  80286a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80286d:	c9                   	leaveq 
  80286e:	c3                   	retq   

000000000080286f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80286f:	55                   	push   %rbp
  802870:	48 89 e5             	mov    %rsp,%rbp
  802873:	48 83 ec 10          	sub    $0x10,%rsp
  802877:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80287a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80287e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802885:	00 00 00 
  802888:	8b 00                	mov    (%rax),%eax
  80288a:	85 c0                	test   %eax,%eax
  80288c:	75 1f                	jne    8028ad <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80288e:	bf 01 00 00 00       	mov    $0x1,%edi
  802893:	48 b8 0e 40 80 00 00 	movabs $0x80400e,%rax
  80289a:	00 00 00 
  80289d:	ff d0                	callq  *%rax
  80289f:	89 c2                	mov    %eax,%edx
  8028a1:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028a8:	00 00 00 
  8028ab:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8028ad:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028b4:	00 00 00 
  8028b7:	8b 00                	mov    (%rax),%eax
  8028b9:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8028bc:	b9 07 00 00 00       	mov    $0x7,%ecx
  8028c1:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8028c8:	00 00 00 
  8028cb:	89 c7                	mov    %eax,%edi
  8028cd:	48 b8 81 3e 80 00 00 	movabs $0x803e81,%rax
  8028d4:	00 00 00 
  8028d7:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8028d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8028e2:	48 89 c6             	mov    %rax,%rsi
  8028e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8028ea:	48 b8 43 3e 80 00 00 	movabs $0x803e43,%rax
  8028f1:	00 00 00 
  8028f4:	ff d0                	callq  *%rax
}
  8028f6:	c9                   	leaveq 
  8028f7:	c3                   	retq   

00000000008028f8 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8028f8:	55                   	push   %rbp
  8028f9:	48 89 e5             	mov    %rsp,%rbp
  8028fc:	48 83 ec 10          	sub    $0x10,%rsp
  802900:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802904:	89 75 f4             	mov    %esi,-0xc(%rbp)
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.

	// LAB 5: Your code here
	panic ("open not implemented");
  802907:	48 ba 9e 48 80 00 00 	movabs $0x80489e,%rdx
  80290e:	00 00 00 
  802911:	be 4c 00 00 00       	mov    $0x4c,%esi
  802916:	48 bf b3 48 80 00 00 	movabs $0x8048b3,%rdi
  80291d:	00 00 00 
  802920:	b8 00 00 00 00       	mov    $0x0,%eax
  802925:	48 b9 be 03 80 00 00 	movabs $0x8003be,%rcx
  80292c:	00 00 00 
  80292f:	ff d1                	callq  *%rcx

0000000000802931 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802931:	55                   	push   %rbp
  802932:	48 89 e5             	mov    %rsp,%rbp
  802935:	48 83 ec 10          	sub    $0x10,%rsp
  802939:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80293d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802941:	8b 50 0c             	mov    0xc(%rax),%edx
  802944:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80294b:	00 00 00 
  80294e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802950:	be 00 00 00 00       	mov    $0x0,%esi
  802955:	bf 06 00 00 00       	mov    $0x6,%edi
  80295a:	48 b8 6f 28 80 00 00 	movabs $0x80286f,%rax
  802961:	00 00 00 
  802964:	ff d0                	callq  *%rax
}
  802966:	c9                   	leaveq 
  802967:	c3                   	retq   

0000000000802968 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802968:	55                   	push   %rbp
  802969:	48 89 e5             	mov    %rsp,%rbp
  80296c:	48 83 ec 20          	sub    $0x20,%rsp
  802970:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802974:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802978:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_READ request to the file system server after
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	panic("devfile_read not implemented");
  80297c:	48 ba be 48 80 00 00 	movabs $0x8048be,%rdx
  802983:	00 00 00 
  802986:	be 6b 00 00 00       	mov    $0x6b,%esi
  80298b:	48 bf b3 48 80 00 00 	movabs $0x8048b3,%rdi
  802992:	00 00 00 
  802995:	b8 00 00 00 00       	mov    $0x0,%eax
  80299a:	48 b9 be 03 80 00 00 	movabs $0x8003be,%rcx
  8029a1:	00 00 00 
  8029a4:	ff d1                	callq  *%rcx

00000000008029a6 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8029a6:	55                   	push   %rbp
  8029a7:	48 89 e5             	mov    %rsp,%rbp
  8029aa:	48 83 ec 20          	sub    $0x20,%rsp
  8029ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8029b2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8029b6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	panic("devfile_write not implemented");
  8029ba:	48 ba db 48 80 00 00 	movabs $0x8048db,%rdx
  8029c1:	00 00 00 
  8029c4:	be 7b 00 00 00       	mov    $0x7b,%esi
  8029c9:	48 bf b3 48 80 00 00 	movabs $0x8048b3,%rdi
  8029d0:	00 00 00 
  8029d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d8:	48 b9 be 03 80 00 00 	movabs $0x8003be,%rcx
  8029df:	00 00 00 
  8029e2:	ff d1                	callq  *%rcx

00000000008029e4 <devfile_stat>:
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8029e4:	55                   	push   %rbp
  8029e5:	48 89 e5             	mov    %rsp,%rbp
  8029e8:	48 83 ec 20          	sub    $0x20,%rsp
  8029ec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029f0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8029f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029f8:	8b 50 0c             	mov    0xc(%rax),%edx
  8029fb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a02:	00 00 00 
  802a05:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802a07:	be 00 00 00 00       	mov    $0x0,%esi
  802a0c:	bf 05 00 00 00       	mov    $0x5,%edi
  802a11:	48 b8 6f 28 80 00 00 	movabs $0x80286f,%rax
  802a18:	00 00 00 
  802a1b:	ff d0                	callq  *%rax
  802a1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a20:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a24:	79 05                	jns    802a2b <devfile_stat+0x47>
		return r;
  802a26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a29:	eb 56                	jmp    802a81 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a2b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a2f:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a36:	00 00 00 
  802a39:	48 89 c7             	mov    %rax,%rdi
  802a3c:	48 b8 91 11 80 00 00 	movabs $0x801191,%rax
  802a43:	00 00 00 
  802a46:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a48:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a4f:	00 00 00 
  802a52:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a58:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a5c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a62:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a69:	00 00 00 
  802a6c:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a72:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a76:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a81:	c9                   	leaveq 
  802a82:	c3                   	retq   

0000000000802a83 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802a83:	55                   	push   %rbp
  802a84:	48 89 e5             	mov    %rsp,%rbp
  802a87:	48 83 ec 10          	sub    $0x10,%rsp
  802a8b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a8f:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802a92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a96:	8b 50 0c             	mov    0xc(%rax),%edx
  802a99:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802aa0:	00 00 00 
  802aa3:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802aa5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802aac:	00 00 00 
  802aaf:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802ab2:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802ab5:	be 00 00 00 00       	mov    $0x0,%esi
  802aba:	bf 02 00 00 00       	mov    $0x2,%edi
  802abf:	48 b8 6f 28 80 00 00 	movabs $0x80286f,%rax
  802ac6:	00 00 00 
  802ac9:	ff d0                	callq  *%rax
}
  802acb:	c9                   	leaveq 
  802acc:	c3                   	retq   

0000000000802acd <remove>:

// Delete a file
int
remove(const char *path)
{
  802acd:	55                   	push   %rbp
  802ace:	48 89 e5             	mov    %rsp,%rbp
  802ad1:	48 83 ec 10          	sub    $0x10,%rsp
  802ad5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802ad9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802add:	48 89 c7             	mov    %rax,%rdi
  802ae0:	48 b8 25 11 80 00 00 	movabs $0x801125,%rax
  802ae7:	00 00 00 
  802aea:	ff d0                	callq  *%rax
  802aec:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802af1:	7e 07                	jle    802afa <remove+0x2d>
		return -E_BAD_PATH;
  802af3:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802af8:	eb 33                	jmp    802b2d <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802afa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802afe:	48 89 c6             	mov    %rax,%rsi
  802b01:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802b08:	00 00 00 
  802b0b:	48 b8 91 11 80 00 00 	movabs $0x801191,%rax
  802b12:	00 00 00 
  802b15:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802b17:	be 00 00 00 00       	mov    $0x0,%esi
  802b1c:	bf 07 00 00 00       	mov    $0x7,%edi
  802b21:	48 b8 6f 28 80 00 00 	movabs $0x80286f,%rax
  802b28:	00 00 00 
  802b2b:	ff d0                	callq  *%rax
}
  802b2d:	c9                   	leaveq 
  802b2e:	c3                   	retq   

0000000000802b2f <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802b2f:	55                   	push   %rbp
  802b30:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802b33:	be 00 00 00 00       	mov    $0x0,%esi
  802b38:	bf 08 00 00 00       	mov    $0x8,%edi
  802b3d:	48 b8 6f 28 80 00 00 	movabs $0x80286f,%rax
  802b44:	00 00 00 
  802b47:	ff d0                	callq  *%rax
}
  802b49:	5d                   	pop    %rbp
  802b4a:	c3                   	retq   

0000000000802b4b <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802b4b:	55                   	push   %rbp
  802b4c:	48 89 e5             	mov    %rsp,%rbp
  802b4f:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802b56:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802b5d:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802b64:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802b6b:	be 00 00 00 00       	mov    $0x0,%esi
  802b70:	48 89 c7             	mov    %rax,%rdi
  802b73:	48 b8 f8 28 80 00 00 	movabs $0x8028f8,%rax
  802b7a:	00 00 00 
  802b7d:	ff d0                	callq  *%rax
  802b7f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802b82:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b86:	79 28                	jns    802bb0 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802b88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b8b:	89 c6                	mov    %eax,%esi
  802b8d:	48 bf f9 48 80 00 00 	movabs $0x8048f9,%rdi
  802b94:	00 00 00 
  802b97:	b8 00 00 00 00       	mov    $0x0,%eax
  802b9c:	48 ba f7 05 80 00 00 	movabs $0x8005f7,%rdx
  802ba3:	00 00 00 
  802ba6:	ff d2                	callq  *%rdx
		return fd_src;
  802ba8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bab:	e9 74 01 00 00       	jmpq   802d24 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802bb0:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802bb7:	be 01 01 00 00       	mov    $0x101,%esi
  802bbc:	48 89 c7             	mov    %rax,%rdi
  802bbf:	48 b8 f8 28 80 00 00 	movabs $0x8028f8,%rax
  802bc6:	00 00 00 
  802bc9:	ff d0                	callq  *%rax
  802bcb:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802bce:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802bd2:	79 39                	jns    802c0d <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802bd4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bd7:	89 c6                	mov    %eax,%esi
  802bd9:	48 bf 0f 49 80 00 00 	movabs $0x80490f,%rdi
  802be0:	00 00 00 
  802be3:	b8 00 00 00 00       	mov    $0x0,%eax
  802be8:	48 ba f7 05 80 00 00 	movabs $0x8005f7,%rdx
  802bef:	00 00 00 
  802bf2:	ff d2                	callq  *%rdx
		close(fd_src);
  802bf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf7:	89 c7                	mov    %eax,%edi
  802bf9:	48 b8 fe 21 80 00 00 	movabs $0x8021fe,%rax
  802c00:	00 00 00 
  802c03:	ff d0                	callq  *%rax
		return fd_dest;
  802c05:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c08:	e9 17 01 00 00       	jmpq   802d24 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c0d:	eb 74                	jmp    802c83 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802c0f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c12:	48 63 d0             	movslq %eax,%rdx
  802c15:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c1c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c1f:	48 89 ce             	mov    %rcx,%rsi
  802c22:	89 c7                	mov    %eax,%edi
  802c24:	48 b8 6a 25 80 00 00 	movabs $0x80256a,%rax
  802c2b:	00 00 00 
  802c2e:	ff d0                	callq  *%rax
  802c30:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802c33:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802c37:	79 4a                	jns    802c83 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802c39:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c3c:	89 c6                	mov    %eax,%esi
  802c3e:	48 bf 29 49 80 00 00 	movabs $0x804929,%rdi
  802c45:	00 00 00 
  802c48:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4d:	48 ba f7 05 80 00 00 	movabs $0x8005f7,%rdx
  802c54:	00 00 00 
  802c57:	ff d2                	callq  *%rdx
			close(fd_src);
  802c59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c5c:	89 c7                	mov    %eax,%edi
  802c5e:	48 b8 fe 21 80 00 00 	movabs $0x8021fe,%rax
  802c65:	00 00 00 
  802c68:	ff d0                	callq  *%rax
			close(fd_dest);
  802c6a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c6d:	89 c7                	mov    %eax,%edi
  802c6f:	48 b8 fe 21 80 00 00 	movabs $0x8021fe,%rax
  802c76:	00 00 00 
  802c79:	ff d0                	callq  *%rax
			return write_size;
  802c7b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c7e:	e9 a1 00 00 00       	jmpq   802d24 <copy+0x1d9>
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802c83:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802c8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c8d:	ba 00 02 00 00       	mov    $0x200,%edx
  802c92:	48 89 ce             	mov    %rcx,%rsi
  802c95:	89 c7                	mov    %eax,%edi
  802c97:	48 b8 20 24 80 00 00 	movabs $0x802420,%rax
  802c9e:	00 00 00 
  802ca1:	ff d0                	callq  *%rax
  802ca3:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802ca6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802caa:	0f 8f 5f ff ff ff    	jg     802c0f <copy+0xc4>
		}		
	}
	if (read_size < 0) {
  802cb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802cb4:	79 47                	jns    802cfd <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802cb6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cb9:	89 c6                	mov    %eax,%esi
  802cbb:	48 bf 3c 49 80 00 00 	movabs $0x80493c,%rdi
  802cc2:	00 00 00 
  802cc5:	b8 00 00 00 00       	mov    $0x0,%eax
  802cca:	48 ba f7 05 80 00 00 	movabs $0x8005f7,%rdx
  802cd1:	00 00 00 
  802cd4:	ff d2                	callq  *%rdx
		close(fd_src);
  802cd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cd9:	89 c7                	mov    %eax,%edi
  802cdb:	48 b8 fe 21 80 00 00 	movabs $0x8021fe,%rax
  802ce2:	00 00 00 
  802ce5:	ff d0                	callq  *%rax
		close(fd_dest);
  802ce7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cea:	89 c7                	mov    %eax,%edi
  802cec:	48 b8 fe 21 80 00 00 	movabs $0x8021fe,%rax
  802cf3:	00 00 00 
  802cf6:	ff d0                	callq  *%rax
		return read_size;
  802cf8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802cfb:	eb 27                	jmp    802d24 <copy+0x1d9>
	}
	close(fd_src);
  802cfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d00:	89 c7                	mov    %eax,%edi
  802d02:	48 b8 fe 21 80 00 00 	movabs $0x8021fe,%rax
  802d09:	00 00 00 
  802d0c:	ff d0                	callq  *%rax
	close(fd_dest);
  802d0e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d11:	89 c7                	mov    %eax,%edi
  802d13:	48 b8 fe 21 80 00 00 	movabs $0x8021fe,%rax
  802d1a:	00 00 00 
  802d1d:	ff d0                	callq  *%rax
	return 0;
  802d1f:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802d24:	c9                   	leaveq 
  802d25:	c3                   	retq   

0000000000802d26 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802d26:	55                   	push   %rbp
  802d27:	48 89 e5             	mov    %rsp,%rbp
  802d2a:	48 83 ec 20          	sub    $0x20,%rsp
  802d2e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802d31:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d35:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d38:	48 89 d6             	mov    %rdx,%rsi
  802d3b:	89 c7                	mov    %eax,%edi
  802d3d:	48 b8 ec 1f 80 00 00 	movabs $0x801fec,%rax
  802d44:	00 00 00 
  802d47:	ff d0                	callq  *%rax
  802d49:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d50:	79 05                	jns    802d57 <fd2sockid+0x31>
		return r;
  802d52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d55:	eb 24                	jmp    802d7b <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802d57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d5b:	8b 10                	mov    (%rax),%edx
  802d5d:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802d64:	00 00 00 
  802d67:	8b 00                	mov    (%rax),%eax
  802d69:	39 c2                	cmp    %eax,%edx
  802d6b:	74 07                	je     802d74 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802d6d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d72:	eb 07                	jmp    802d7b <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802d74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d78:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802d7b:	c9                   	leaveq 
  802d7c:	c3                   	retq   

0000000000802d7d <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802d7d:	55                   	push   %rbp
  802d7e:	48 89 e5             	mov    %rsp,%rbp
  802d81:	48 83 ec 20          	sub    $0x20,%rsp
  802d85:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802d88:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802d8c:	48 89 c7             	mov    %rax,%rdi
  802d8f:	48 b8 54 1f 80 00 00 	movabs $0x801f54,%rax
  802d96:	00 00 00 
  802d99:	ff d0                	callq  *%rax
  802d9b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802da2:	78 26                	js     802dca <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802da4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802da8:	ba 07 04 00 00       	mov    $0x407,%edx
  802dad:	48 89 c6             	mov    %rax,%rsi
  802db0:	bf 00 00 00 00       	mov    $0x0,%edi
  802db5:	48 b8 be 1a 80 00 00 	movabs $0x801abe,%rax
  802dbc:	00 00 00 
  802dbf:	ff d0                	callq  *%rax
  802dc1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dc8:	79 16                	jns    802de0 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802dca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dcd:	89 c7                	mov    %eax,%edi
  802dcf:	48 b8 8c 32 80 00 00 	movabs $0x80328c,%rax
  802dd6:	00 00 00 
  802dd9:	ff d0                	callq  *%rax
		return r;
  802ddb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dde:	eb 3a                	jmp    802e1a <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802de0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de4:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802deb:	00 00 00 
  802dee:	8b 12                	mov    (%rdx),%edx
  802df0:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802df2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802df6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802dfd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e01:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802e04:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802e07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e0b:	48 89 c7             	mov    %rax,%rdi
  802e0e:	48 b8 06 1f 80 00 00 	movabs $0x801f06,%rax
  802e15:	00 00 00 
  802e18:	ff d0                	callq  *%rax
}
  802e1a:	c9                   	leaveq 
  802e1b:	c3                   	retq   

0000000000802e1c <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802e1c:	55                   	push   %rbp
  802e1d:	48 89 e5             	mov    %rsp,%rbp
  802e20:	48 83 ec 30          	sub    $0x30,%rsp
  802e24:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e27:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e2b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e2f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e32:	89 c7                	mov    %eax,%edi
  802e34:	48 b8 26 2d 80 00 00 	movabs $0x802d26,%rax
  802e3b:	00 00 00 
  802e3e:	ff d0                	callq  *%rax
  802e40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e47:	79 05                	jns    802e4e <accept+0x32>
		return r;
  802e49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e4c:	eb 3b                	jmp    802e89 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802e4e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e52:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802e56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e59:	48 89 ce             	mov    %rcx,%rsi
  802e5c:	89 c7                	mov    %eax,%edi
  802e5e:	48 b8 69 31 80 00 00 	movabs $0x803169,%rax
  802e65:	00 00 00 
  802e68:	ff d0                	callq  *%rax
  802e6a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e71:	79 05                	jns    802e78 <accept+0x5c>
		return r;
  802e73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e76:	eb 11                	jmp    802e89 <accept+0x6d>
	return alloc_sockfd(r);
  802e78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e7b:	89 c7                	mov    %eax,%edi
  802e7d:	48 b8 7d 2d 80 00 00 	movabs $0x802d7d,%rax
  802e84:	00 00 00 
  802e87:	ff d0                	callq  *%rax
}
  802e89:	c9                   	leaveq 
  802e8a:	c3                   	retq   

0000000000802e8b <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802e8b:	55                   	push   %rbp
  802e8c:	48 89 e5             	mov    %rsp,%rbp
  802e8f:	48 83 ec 20          	sub    $0x20,%rsp
  802e93:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e96:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e9a:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e9d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ea0:	89 c7                	mov    %eax,%edi
  802ea2:	48 b8 26 2d 80 00 00 	movabs $0x802d26,%rax
  802ea9:	00 00 00 
  802eac:	ff d0                	callq  *%rax
  802eae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eb1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eb5:	79 05                	jns    802ebc <bind+0x31>
		return r;
  802eb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eba:	eb 1b                	jmp    802ed7 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802ebc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ebf:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802ec3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec6:	48 89 ce             	mov    %rcx,%rsi
  802ec9:	89 c7                	mov    %eax,%edi
  802ecb:	48 b8 e8 31 80 00 00 	movabs $0x8031e8,%rax
  802ed2:	00 00 00 
  802ed5:	ff d0                	callq  *%rax
}
  802ed7:	c9                   	leaveq 
  802ed8:	c3                   	retq   

0000000000802ed9 <shutdown>:

int
shutdown(int s, int how)
{
  802ed9:	55                   	push   %rbp
  802eda:	48 89 e5             	mov    %rsp,%rbp
  802edd:	48 83 ec 20          	sub    $0x20,%rsp
  802ee1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ee4:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ee7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802eea:	89 c7                	mov    %eax,%edi
  802eec:	48 b8 26 2d 80 00 00 	movabs $0x802d26,%rax
  802ef3:	00 00 00 
  802ef6:	ff d0                	callq  *%rax
  802ef8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802efb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eff:	79 05                	jns    802f06 <shutdown+0x2d>
		return r;
  802f01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f04:	eb 16                	jmp    802f1c <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802f06:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f0c:	89 d6                	mov    %edx,%esi
  802f0e:	89 c7                	mov    %eax,%edi
  802f10:	48 b8 4c 32 80 00 00 	movabs $0x80324c,%rax
  802f17:	00 00 00 
  802f1a:	ff d0                	callq  *%rax
}
  802f1c:	c9                   	leaveq 
  802f1d:	c3                   	retq   

0000000000802f1e <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802f1e:	55                   	push   %rbp
  802f1f:	48 89 e5             	mov    %rsp,%rbp
  802f22:	48 83 ec 10          	sub    $0x10,%rsp
  802f26:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802f2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f2e:	48 89 c7             	mov    %rax,%rdi
  802f31:	48 b8 80 40 80 00 00 	movabs $0x804080,%rax
  802f38:	00 00 00 
  802f3b:	ff d0                	callq  *%rax
  802f3d:	83 f8 01             	cmp    $0x1,%eax
  802f40:	75 17                	jne    802f59 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802f42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f46:	8b 40 0c             	mov    0xc(%rax),%eax
  802f49:	89 c7                	mov    %eax,%edi
  802f4b:	48 b8 8c 32 80 00 00 	movabs $0x80328c,%rax
  802f52:	00 00 00 
  802f55:	ff d0                	callq  *%rax
  802f57:	eb 05                	jmp    802f5e <devsock_close+0x40>
	else
		return 0;
  802f59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f5e:	c9                   	leaveq 
  802f5f:	c3                   	retq   

0000000000802f60 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802f60:	55                   	push   %rbp
  802f61:	48 89 e5             	mov    %rsp,%rbp
  802f64:	48 83 ec 20          	sub    $0x20,%rsp
  802f68:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f6b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f6f:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f72:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f75:	89 c7                	mov    %eax,%edi
  802f77:	48 b8 26 2d 80 00 00 	movabs $0x802d26,%rax
  802f7e:	00 00 00 
  802f81:	ff d0                	callq  *%rax
  802f83:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f8a:	79 05                	jns    802f91 <connect+0x31>
		return r;
  802f8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f8f:	eb 1b                	jmp    802fac <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802f91:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f94:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f9b:	48 89 ce             	mov    %rcx,%rsi
  802f9e:	89 c7                	mov    %eax,%edi
  802fa0:	48 b8 b9 32 80 00 00 	movabs $0x8032b9,%rax
  802fa7:	00 00 00 
  802faa:	ff d0                	callq  *%rax
}
  802fac:	c9                   	leaveq 
  802fad:	c3                   	retq   

0000000000802fae <listen>:

int
listen(int s, int backlog)
{
  802fae:	55                   	push   %rbp
  802faf:	48 89 e5             	mov    %rsp,%rbp
  802fb2:	48 83 ec 20          	sub    $0x20,%rsp
  802fb6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fb9:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fbc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fbf:	89 c7                	mov    %eax,%edi
  802fc1:	48 b8 26 2d 80 00 00 	movabs $0x802d26,%rax
  802fc8:	00 00 00 
  802fcb:	ff d0                	callq  *%rax
  802fcd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fd0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fd4:	79 05                	jns    802fdb <listen+0x2d>
		return r;
  802fd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fd9:	eb 16                	jmp    802ff1 <listen+0x43>
	return nsipc_listen(r, backlog);
  802fdb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802fde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fe1:	89 d6                	mov    %edx,%esi
  802fe3:	89 c7                	mov    %eax,%edi
  802fe5:	48 b8 1d 33 80 00 00 	movabs $0x80331d,%rax
  802fec:	00 00 00 
  802fef:	ff d0                	callq  *%rax
}
  802ff1:	c9                   	leaveq 
  802ff2:	c3                   	retq   

0000000000802ff3 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802ff3:	55                   	push   %rbp
  802ff4:	48 89 e5             	mov    %rsp,%rbp
  802ff7:	48 83 ec 20          	sub    $0x20,%rsp
  802ffb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802fff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803003:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803007:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80300b:	89 c2                	mov    %eax,%edx
  80300d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803011:	8b 40 0c             	mov    0xc(%rax),%eax
  803014:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803018:	b9 00 00 00 00       	mov    $0x0,%ecx
  80301d:	89 c7                	mov    %eax,%edi
  80301f:	48 b8 5d 33 80 00 00 	movabs $0x80335d,%rax
  803026:	00 00 00 
  803029:	ff d0                	callq  *%rax
}
  80302b:	c9                   	leaveq 
  80302c:	c3                   	retq   

000000000080302d <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80302d:	55                   	push   %rbp
  80302e:	48 89 e5             	mov    %rsp,%rbp
  803031:	48 83 ec 20          	sub    $0x20,%rsp
  803035:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803039:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80303d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803041:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803045:	89 c2                	mov    %eax,%edx
  803047:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80304b:	8b 40 0c             	mov    0xc(%rax),%eax
  80304e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803052:	b9 00 00 00 00       	mov    $0x0,%ecx
  803057:	89 c7                	mov    %eax,%edi
  803059:	48 b8 29 34 80 00 00 	movabs $0x803429,%rax
  803060:	00 00 00 
  803063:	ff d0                	callq  *%rax
}
  803065:	c9                   	leaveq 
  803066:	c3                   	retq   

0000000000803067 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803067:	55                   	push   %rbp
  803068:	48 89 e5             	mov    %rsp,%rbp
  80306b:	48 83 ec 10          	sub    $0x10,%rsp
  80306f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803073:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803077:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80307b:	48 be 57 49 80 00 00 	movabs $0x804957,%rsi
  803082:	00 00 00 
  803085:	48 89 c7             	mov    %rax,%rdi
  803088:	48 b8 91 11 80 00 00 	movabs $0x801191,%rax
  80308f:	00 00 00 
  803092:	ff d0                	callq  *%rax
	return 0;
  803094:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803099:	c9                   	leaveq 
  80309a:	c3                   	retq   

000000000080309b <socket>:

int
socket(int domain, int type, int protocol)
{
  80309b:	55                   	push   %rbp
  80309c:	48 89 e5             	mov    %rsp,%rbp
  80309f:	48 83 ec 20          	sub    $0x20,%rsp
  8030a3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030a6:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8030a9:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8030ac:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8030af:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8030b2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030b5:	89 ce                	mov    %ecx,%esi
  8030b7:	89 c7                	mov    %eax,%edi
  8030b9:	48 b8 e1 34 80 00 00 	movabs $0x8034e1,%rax
  8030c0:	00 00 00 
  8030c3:	ff d0                	callq  *%rax
  8030c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030cc:	79 05                	jns    8030d3 <socket+0x38>
		return r;
  8030ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d1:	eb 11                	jmp    8030e4 <socket+0x49>
	return alloc_sockfd(r);
  8030d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d6:	89 c7                	mov    %eax,%edi
  8030d8:	48 b8 7d 2d 80 00 00 	movabs $0x802d7d,%rax
  8030df:	00 00 00 
  8030e2:	ff d0                	callq  *%rax
}
  8030e4:	c9                   	leaveq 
  8030e5:	c3                   	retq   

00000000008030e6 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8030e6:	55                   	push   %rbp
  8030e7:	48 89 e5             	mov    %rsp,%rbp
  8030ea:	48 83 ec 10          	sub    $0x10,%rsp
  8030ee:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8030f1:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8030f8:	00 00 00 
  8030fb:	8b 00                	mov    (%rax),%eax
  8030fd:	85 c0                	test   %eax,%eax
  8030ff:	75 1f                	jne    803120 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803101:	bf 02 00 00 00       	mov    $0x2,%edi
  803106:	48 b8 0e 40 80 00 00 	movabs $0x80400e,%rax
  80310d:	00 00 00 
  803110:	ff d0                	callq  *%rax
  803112:	89 c2                	mov    %eax,%edx
  803114:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80311b:	00 00 00 
  80311e:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803120:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803127:	00 00 00 
  80312a:	8b 00                	mov    (%rax),%eax
  80312c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80312f:	b9 07 00 00 00       	mov    $0x7,%ecx
  803134:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80313b:	00 00 00 
  80313e:	89 c7                	mov    %eax,%edi
  803140:	48 b8 81 3e 80 00 00 	movabs $0x803e81,%rax
  803147:	00 00 00 
  80314a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80314c:	ba 00 00 00 00       	mov    $0x0,%edx
  803151:	be 00 00 00 00       	mov    $0x0,%esi
  803156:	bf 00 00 00 00       	mov    $0x0,%edi
  80315b:	48 b8 43 3e 80 00 00 	movabs $0x803e43,%rax
  803162:	00 00 00 
  803165:	ff d0                	callq  *%rax
}
  803167:	c9                   	leaveq 
  803168:	c3                   	retq   

0000000000803169 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803169:	55                   	push   %rbp
  80316a:	48 89 e5             	mov    %rsp,%rbp
  80316d:	48 83 ec 30          	sub    $0x30,%rsp
  803171:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803174:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803178:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80317c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803183:	00 00 00 
  803186:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803189:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80318b:	bf 01 00 00 00       	mov    $0x1,%edi
  803190:	48 b8 e6 30 80 00 00 	movabs $0x8030e6,%rax
  803197:	00 00 00 
  80319a:	ff d0                	callq  *%rax
  80319c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80319f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031a3:	78 3e                	js     8031e3 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8031a5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031ac:	00 00 00 
  8031af:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8031b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031b7:	8b 40 10             	mov    0x10(%rax),%eax
  8031ba:	89 c2                	mov    %eax,%edx
  8031bc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8031c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031c4:	48 89 ce             	mov    %rcx,%rsi
  8031c7:	48 89 c7             	mov    %rax,%rdi
  8031ca:	48 b8 b5 14 80 00 00 	movabs $0x8014b5,%rax
  8031d1:	00 00 00 
  8031d4:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8031d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031da:	8b 50 10             	mov    0x10(%rax),%edx
  8031dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031e1:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8031e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8031e6:	c9                   	leaveq 
  8031e7:	c3                   	retq   

00000000008031e8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8031e8:	55                   	push   %rbp
  8031e9:	48 89 e5             	mov    %rsp,%rbp
  8031ec:	48 83 ec 10          	sub    $0x10,%rsp
  8031f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8031f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8031f7:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8031fa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803201:	00 00 00 
  803204:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803207:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803209:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80320c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803210:	48 89 c6             	mov    %rax,%rsi
  803213:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80321a:	00 00 00 
  80321d:	48 b8 b5 14 80 00 00 	movabs $0x8014b5,%rax
  803224:	00 00 00 
  803227:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803229:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803230:	00 00 00 
  803233:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803236:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803239:	bf 02 00 00 00       	mov    $0x2,%edi
  80323e:	48 b8 e6 30 80 00 00 	movabs $0x8030e6,%rax
  803245:	00 00 00 
  803248:	ff d0                	callq  *%rax
}
  80324a:	c9                   	leaveq 
  80324b:	c3                   	retq   

000000000080324c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80324c:	55                   	push   %rbp
  80324d:	48 89 e5             	mov    %rsp,%rbp
  803250:	48 83 ec 10          	sub    $0x10,%rsp
  803254:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803257:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80325a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803261:	00 00 00 
  803264:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803267:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803269:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803270:	00 00 00 
  803273:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803276:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803279:	bf 03 00 00 00       	mov    $0x3,%edi
  80327e:	48 b8 e6 30 80 00 00 	movabs $0x8030e6,%rax
  803285:	00 00 00 
  803288:	ff d0                	callq  *%rax
}
  80328a:	c9                   	leaveq 
  80328b:	c3                   	retq   

000000000080328c <nsipc_close>:

int
nsipc_close(int s)
{
  80328c:	55                   	push   %rbp
  80328d:	48 89 e5             	mov    %rsp,%rbp
  803290:	48 83 ec 10          	sub    $0x10,%rsp
  803294:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803297:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80329e:	00 00 00 
  8032a1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032a4:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8032a6:	bf 04 00 00 00       	mov    $0x4,%edi
  8032ab:	48 b8 e6 30 80 00 00 	movabs $0x8030e6,%rax
  8032b2:	00 00 00 
  8032b5:	ff d0                	callq  *%rax
}
  8032b7:	c9                   	leaveq 
  8032b8:	c3                   	retq   

00000000008032b9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8032b9:	55                   	push   %rbp
  8032ba:	48 89 e5             	mov    %rsp,%rbp
  8032bd:	48 83 ec 10          	sub    $0x10,%rsp
  8032c1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032c4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8032c8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8032cb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032d2:	00 00 00 
  8032d5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032d8:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8032da:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e1:	48 89 c6             	mov    %rax,%rsi
  8032e4:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8032eb:	00 00 00 
  8032ee:	48 b8 b5 14 80 00 00 	movabs $0x8014b5,%rax
  8032f5:	00 00 00 
  8032f8:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8032fa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803301:	00 00 00 
  803304:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803307:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80330a:	bf 05 00 00 00       	mov    $0x5,%edi
  80330f:	48 b8 e6 30 80 00 00 	movabs $0x8030e6,%rax
  803316:	00 00 00 
  803319:	ff d0                	callq  *%rax
}
  80331b:	c9                   	leaveq 
  80331c:	c3                   	retq   

000000000080331d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80331d:	55                   	push   %rbp
  80331e:	48 89 e5             	mov    %rsp,%rbp
  803321:	48 83 ec 10          	sub    $0x10,%rsp
  803325:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803328:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80332b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803332:	00 00 00 
  803335:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803338:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80333a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803341:	00 00 00 
  803344:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803347:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80334a:	bf 06 00 00 00       	mov    $0x6,%edi
  80334f:	48 b8 e6 30 80 00 00 	movabs $0x8030e6,%rax
  803356:	00 00 00 
  803359:	ff d0                	callq  *%rax
}
  80335b:	c9                   	leaveq 
  80335c:	c3                   	retq   

000000000080335d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80335d:	55                   	push   %rbp
  80335e:	48 89 e5             	mov    %rsp,%rbp
  803361:	48 83 ec 30          	sub    $0x30,%rsp
  803365:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803368:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80336c:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80336f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803372:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803379:	00 00 00 
  80337c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80337f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803381:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803388:	00 00 00 
  80338b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80338e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803391:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803398:	00 00 00 
  80339b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80339e:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8033a1:	bf 07 00 00 00       	mov    $0x7,%edi
  8033a6:	48 b8 e6 30 80 00 00 	movabs $0x8030e6,%rax
  8033ad:	00 00 00 
  8033b0:	ff d0                	callq  *%rax
  8033b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033b9:	78 69                	js     803424 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8033bb:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8033c2:	7f 08                	jg     8033cc <nsipc_recv+0x6f>
  8033c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033c7:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8033ca:	7e 35                	jle    803401 <nsipc_recv+0xa4>
  8033cc:	48 b9 5e 49 80 00 00 	movabs $0x80495e,%rcx
  8033d3:	00 00 00 
  8033d6:	48 ba 73 49 80 00 00 	movabs $0x804973,%rdx
  8033dd:	00 00 00 
  8033e0:	be 61 00 00 00       	mov    $0x61,%esi
  8033e5:	48 bf 88 49 80 00 00 	movabs $0x804988,%rdi
  8033ec:	00 00 00 
  8033ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f4:	49 b8 be 03 80 00 00 	movabs $0x8003be,%r8
  8033fb:	00 00 00 
  8033fe:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803401:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803404:	48 63 d0             	movslq %eax,%rdx
  803407:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80340b:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803412:	00 00 00 
  803415:	48 89 c7             	mov    %rax,%rdi
  803418:	48 b8 b5 14 80 00 00 	movabs $0x8014b5,%rax
  80341f:	00 00 00 
  803422:	ff d0                	callq  *%rax
	}

	return r;
  803424:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803427:	c9                   	leaveq 
  803428:	c3                   	retq   

0000000000803429 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803429:	55                   	push   %rbp
  80342a:	48 89 e5             	mov    %rsp,%rbp
  80342d:	48 83 ec 20          	sub    $0x20,%rsp
  803431:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803434:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803438:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80343b:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80343e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803445:	00 00 00 
  803448:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80344b:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80344d:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803454:	7e 35                	jle    80348b <nsipc_send+0x62>
  803456:	48 b9 94 49 80 00 00 	movabs $0x804994,%rcx
  80345d:	00 00 00 
  803460:	48 ba 73 49 80 00 00 	movabs $0x804973,%rdx
  803467:	00 00 00 
  80346a:	be 6c 00 00 00       	mov    $0x6c,%esi
  80346f:	48 bf 88 49 80 00 00 	movabs $0x804988,%rdi
  803476:	00 00 00 
  803479:	b8 00 00 00 00       	mov    $0x0,%eax
  80347e:	49 b8 be 03 80 00 00 	movabs $0x8003be,%r8
  803485:	00 00 00 
  803488:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80348b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80348e:	48 63 d0             	movslq %eax,%rdx
  803491:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803495:	48 89 c6             	mov    %rax,%rsi
  803498:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80349f:	00 00 00 
  8034a2:	48 b8 b5 14 80 00 00 	movabs $0x8014b5,%rax
  8034a9:	00 00 00 
  8034ac:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8034ae:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034b5:	00 00 00 
  8034b8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034bb:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8034be:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034c5:	00 00 00 
  8034c8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8034cb:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8034ce:	bf 08 00 00 00       	mov    $0x8,%edi
  8034d3:	48 b8 e6 30 80 00 00 	movabs $0x8030e6,%rax
  8034da:	00 00 00 
  8034dd:	ff d0                	callq  *%rax
}
  8034df:	c9                   	leaveq 
  8034e0:	c3                   	retq   

00000000008034e1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8034e1:	55                   	push   %rbp
  8034e2:	48 89 e5             	mov    %rsp,%rbp
  8034e5:	48 83 ec 10          	sub    $0x10,%rsp
  8034e9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034ec:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8034ef:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8034f2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034f9:	00 00 00 
  8034fc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034ff:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803501:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803508:	00 00 00 
  80350b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80350e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803511:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803518:	00 00 00 
  80351b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80351e:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803521:	bf 09 00 00 00       	mov    $0x9,%edi
  803526:	48 b8 e6 30 80 00 00 	movabs $0x8030e6,%rax
  80352d:	00 00 00 
  803530:	ff d0                	callq  *%rax
}
  803532:	c9                   	leaveq 
  803533:	c3                   	retq   

0000000000803534 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803534:	55                   	push   %rbp
  803535:	48 89 e5             	mov    %rsp,%rbp
  803538:	53                   	push   %rbx
  803539:	48 83 ec 38          	sub    $0x38,%rsp
  80353d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803541:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803545:	48 89 c7             	mov    %rax,%rdi
  803548:	48 b8 54 1f 80 00 00 	movabs $0x801f54,%rax
  80354f:	00 00 00 
  803552:	ff d0                	callq  *%rax
  803554:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803557:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80355b:	0f 88 bf 01 00 00    	js     803720 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803561:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803565:	ba 07 04 00 00       	mov    $0x407,%edx
  80356a:	48 89 c6             	mov    %rax,%rsi
  80356d:	bf 00 00 00 00       	mov    $0x0,%edi
  803572:	48 b8 be 1a 80 00 00 	movabs $0x801abe,%rax
  803579:	00 00 00 
  80357c:	ff d0                	callq  *%rax
  80357e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803581:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803585:	0f 88 95 01 00 00    	js     803720 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80358b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80358f:	48 89 c7             	mov    %rax,%rdi
  803592:	48 b8 54 1f 80 00 00 	movabs $0x801f54,%rax
  803599:	00 00 00 
  80359c:	ff d0                	callq  *%rax
  80359e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035a5:	0f 88 5d 01 00 00    	js     803708 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035af:	ba 07 04 00 00       	mov    $0x407,%edx
  8035b4:	48 89 c6             	mov    %rax,%rsi
  8035b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8035bc:	48 b8 be 1a 80 00 00 	movabs $0x801abe,%rax
  8035c3:	00 00 00 
  8035c6:	ff d0                	callq  *%rax
  8035c8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035cf:	0f 88 33 01 00 00    	js     803708 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8035d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035d9:	48 89 c7             	mov    %rax,%rdi
  8035dc:	48 b8 29 1f 80 00 00 	movabs $0x801f29,%rax
  8035e3:	00 00 00 
  8035e6:	ff d0                	callq  *%rax
  8035e8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035f0:	ba 07 04 00 00       	mov    $0x407,%edx
  8035f5:	48 89 c6             	mov    %rax,%rsi
  8035f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8035fd:	48 b8 be 1a 80 00 00 	movabs $0x801abe,%rax
  803604:	00 00 00 
  803607:	ff d0                	callq  *%rax
  803609:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80360c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803610:	79 05                	jns    803617 <pipe+0xe3>
		goto err2;
  803612:	e9 d9 00 00 00       	jmpq   8036f0 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803617:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80361b:	48 89 c7             	mov    %rax,%rdi
  80361e:	48 b8 29 1f 80 00 00 	movabs $0x801f29,%rax
  803625:	00 00 00 
  803628:	ff d0                	callq  *%rax
  80362a:	48 89 c2             	mov    %rax,%rdx
  80362d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803631:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803637:	48 89 d1             	mov    %rdx,%rcx
  80363a:	ba 00 00 00 00       	mov    $0x0,%edx
  80363f:	48 89 c6             	mov    %rax,%rsi
  803642:	bf 00 00 00 00       	mov    $0x0,%edi
  803647:	48 b8 10 1b 80 00 00 	movabs $0x801b10,%rax
  80364e:	00 00 00 
  803651:	ff d0                	callq  *%rax
  803653:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803656:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80365a:	79 1b                	jns    803677 <pipe+0x143>
		goto err3;
  80365c:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80365d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803661:	48 89 c6             	mov    %rax,%rsi
  803664:	bf 00 00 00 00       	mov    $0x0,%edi
  803669:	48 b8 70 1b 80 00 00 	movabs $0x801b70,%rax
  803670:	00 00 00 
  803673:	ff d0                	callq  *%rax
  803675:	eb 79                	jmp    8036f0 <pipe+0x1bc>
	fd0->fd_dev_id = devpipe.dev_id;
  803677:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80367b:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803682:	00 00 00 
  803685:	8b 12                	mov    (%rdx),%edx
  803687:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803689:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80368d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
	fd1->fd_dev_id = devpipe.dev_id;
  803694:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803698:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80369f:	00 00 00 
  8036a2:	8b 12                	mov    (%rdx),%edx
  8036a4:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8036a6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036aa:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
	pfd[0] = fd2num(fd0);
  8036b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036b5:	48 89 c7             	mov    %rax,%rdi
  8036b8:	48 b8 06 1f 80 00 00 	movabs $0x801f06,%rax
  8036bf:	00 00 00 
  8036c2:	ff d0                	callq  *%rax
  8036c4:	89 c2                	mov    %eax,%edx
  8036c6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8036ca:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8036cc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8036d0:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8036d4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036d8:	48 89 c7             	mov    %rax,%rdi
  8036db:	48 b8 06 1f 80 00 00 	movabs $0x801f06,%rax
  8036e2:	00 00 00 
  8036e5:	ff d0                	callq  *%rax
  8036e7:	89 03                	mov    %eax,(%rbx)
	return 0;
  8036e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8036ee:	eb 33                	jmp    803723 <pipe+0x1ef>
err2:
	sys_page_unmap(0, fd1);
  8036f0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036f4:	48 89 c6             	mov    %rax,%rsi
  8036f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8036fc:	48 b8 70 1b 80 00 00 	movabs $0x801b70,%rax
  803703:	00 00 00 
  803706:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803708:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80370c:	48 89 c6             	mov    %rax,%rsi
  80370f:	bf 00 00 00 00       	mov    $0x0,%edi
  803714:	48 b8 70 1b 80 00 00 	movabs $0x801b70,%rax
  80371b:	00 00 00 
  80371e:	ff d0                	callq  *%rax
err:
	return r;
  803720:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803723:	48 83 c4 38          	add    $0x38,%rsp
  803727:	5b                   	pop    %rbx
  803728:	5d                   	pop    %rbp
  803729:	c3                   	retq   

000000000080372a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80372a:	55                   	push   %rbp
  80372b:	48 89 e5             	mov    %rsp,%rbp
  80372e:	53                   	push   %rbx
  80372f:	48 83 ec 28          	sub    $0x28,%rsp
  803733:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803737:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80373b:	48 b8 40 74 80 00 00 	movabs $0x807440,%rax
  803742:	00 00 00 
  803745:	48 8b 00             	mov    (%rax),%rax
  803748:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80374e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803751:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803755:	48 89 c7             	mov    %rax,%rdi
  803758:	48 b8 80 40 80 00 00 	movabs $0x804080,%rax
  80375f:	00 00 00 
  803762:	ff d0                	callq  *%rax
  803764:	89 c3                	mov    %eax,%ebx
  803766:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80376a:	48 89 c7             	mov    %rax,%rdi
  80376d:	48 b8 80 40 80 00 00 	movabs $0x804080,%rax
  803774:	00 00 00 
  803777:	ff d0                	callq  *%rax
  803779:	39 c3                	cmp    %eax,%ebx
  80377b:	0f 94 c0             	sete   %al
  80377e:	0f b6 c0             	movzbl %al,%eax
  803781:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803784:	48 b8 40 74 80 00 00 	movabs $0x807440,%rax
  80378b:	00 00 00 
  80378e:	48 8b 00             	mov    (%rax),%rax
  803791:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803797:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80379a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80379d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8037a0:	75 05                	jne    8037a7 <_pipeisclosed+0x7d>
			return ret;
  8037a2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8037a5:	eb 4a                	jmp    8037f1 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  8037a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037aa:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8037ad:	74 3d                	je     8037ec <_pipeisclosed+0xc2>
  8037af:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8037b3:	75 37                	jne    8037ec <_pipeisclosed+0xc2>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8037b5:	48 b8 40 74 80 00 00 	movabs $0x807440,%rax
  8037bc:	00 00 00 
  8037bf:	48 8b 00             	mov    (%rax),%rax
  8037c2:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8037c8:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8037cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037ce:	89 c6                	mov    %eax,%esi
  8037d0:	48 bf a5 49 80 00 00 	movabs $0x8049a5,%rdi
  8037d7:	00 00 00 
  8037da:	b8 00 00 00 00       	mov    $0x0,%eax
  8037df:	49 b8 f7 05 80 00 00 	movabs $0x8005f7,%r8
  8037e6:	00 00 00 
  8037e9:	41 ff d0             	callq  *%r8
	}
  8037ec:	e9 4a ff ff ff       	jmpq   80373b <_pipeisclosed+0x11>
}
  8037f1:	48 83 c4 28          	add    $0x28,%rsp
  8037f5:	5b                   	pop    %rbx
  8037f6:	5d                   	pop    %rbp
  8037f7:	c3                   	retq   

00000000008037f8 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8037f8:	55                   	push   %rbp
  8037f9:	48 89 e5             	mov    %rsp,%rbp
  8037fc:	48 83 ec 30          	sub    $0x30,%rsp
  803800:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803803:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803807:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80380a:	48 89 d6             	mov    %rdx,%rsi
  80380d:	89 c7                	mov    %eax,%edi
  80380f:	48 b8 ec 1f 80 00 00 	movabs $0x801fec,%rax
  803816:	00 00 00 
  803819:	ff d0                	callq  *%rax
  80381b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80381e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803822:	79 05                	jns    803829 <pipeisclosed+0x31>
		return r;
  803824:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803827:	eb 31                	jmp    80385a <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803829:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80382d:	48 89 c7             	mov    %rax,%rdi
  803830:	48 b8 29 1f 80 00 00 	movabs $0x801f29,%rax
  803837:	00 00 00 
  80383a:	ff d0                	callq  *%rax
  80383c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803840:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803844:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803848:	48 89 d6             	mov    %rdx,%rsi
  80384b:	48 89 c7             	mov    %rax,%rdi
  80384e:	48 b8 2a 37 80 00 00 	movabs $0x80372a,%rax
  803855:	00 00 00 
  803858:	ff d0                	callq  *%rax
}
  80385a:	c9                   	leaveq 
  80385b:	c3                   	retq   

000000000080385c <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80385c:	55                   	push   %rbp
  80385d:	48 89 e5             	mov    %rsp,%rbp
  803860:	48 83 ec 40          	sub    $0x40,%rsp
  803864:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803868:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80386c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803870:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803874:	48 89 c7             	mov    %rax,%rdi
  803877:	48 b8 29 1f 80 00 00 	movabs $0x801f29,%rax
  80387e:	00 00 00 
  803881:	ff d0                	callq  *%rax
  803883:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803887:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80388b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80388f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803896:	00 
  803897:	e9 92 00 00 00       	jmpq   80392e <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80389c:	eb 41                	jmp    8038df <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80389e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8038a3:	74 09                	je     8038ae <devpipe_read+0x52>
				return i;
  8038a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038a9:	e9 92 00 00 00       	jmpq   803940 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8038ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8038b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038b6:	48 89 d6             	mov    %rdx,%rsi
  8038b9:	48 89 c7             	mov    %rax,%rdi
  8038bc:	48 b8 2a 37 80 00 00 	movabs $0x80372a,%rax
  8038c3:	00 00 00 
  8038c6:	ff d0                	callq  *%rax
  8038c8:	85 c0                	test   %eax,%eax
  8038ca:	74 07                	je     8038d3 <devpipe_read+0x77>
				return 0;
  8038cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8038d1:	eb 6d                	jmp    803940 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8038d3:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  8038da:	00 00 00 
  8038dd:	ff d0                	callq  *%rax
		while (p->p_rpos == p->p_wpos) {
  8038df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038e3:	8b 10                	mov    (%rax),%edx
  8038e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038e9:	8b 40 04             	mov    0x4(%rax),%eax
  8038ec:	39 c2                	cmp    %eax,%edx
  8038ee:	74 ae                	je     80389e <devpipe_read+0x42>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8038f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8038f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038f8:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8038fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803900:	8b 00                	mov    (%rax),%eax
  803902:	99                   	cltd   
  803903:	c1 ea 1b             	shr    $0x1b,%edx
  803906:	01 d0                	add    %edx,%eax
  803908:	83 e0 1f             	and    $0x1f,%eax
  80390b:	29 d0                	sub    %edx,%eax
  80390d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803911:	48 98                	cltq   
  803913:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803918:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80391a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80391e:	8b 00                	mov    (%rax),%eax
  803920:	8d 50 01             	lea    0x1(%rax),%edx
  803923:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803927:	89 10                	mov    %edx,(%rax)
	for (i = 0; i < n; i++) {
  803929:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80392e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803932:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803936:	0f 82 60 ff ff ff    	jb     80389c <devpipe_read+0x40>
	}
	return i;
  80393c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803940:	c9                   	leaveq 
  803941:	c3                   	retq   

0000000000803942 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803942:	55                   	push   %rbp
  803943:	48 89 e5             	mov    %rsp,%rbp
  803946:	48 83 ec 40          	sub    $0x40,%rsp
  80394a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80394e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803952:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803956:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80395a:	48 89 c7             	mov    %rax,%rdi
  80395d:	48 b8 29 1f 80 00 00 	movabs $0x801f29,%rax
  803964:	00 00 00 
  803967:	ff d0                	callq  *%rax
  803969:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80396d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803971:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803975:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80397c:	00 
  80397d:	e9 91 00 00 00       	jmpq   803a13 <devpipe_write+0xd1>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803982:	eb 31                	jmp    8039b5 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803984:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803988:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80398c:	48 89 d6             	mov    %rdx,%rsi
  80398f:	48 89 c7             	mov    %rax,%rdi
  803992:	48 b8 2a 37 80 00 00 	movabs $0x80372a,%rax
  803999:	00 00 00 
  80399c:	ff d0                	callq  *%rax
  80399e:	85 c0                	test   %eax,%eax
  8039a0:	74 07                	je     8039a9 <devpipe_write+0x67>
				return 0;
  8039a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8039a7:	eb 7c                	jmp    803a25 <devpipe_write+0xe3>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8039a9:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  8039b0:	00 00 00 
  8039b3:	ff d0                	callq  *%rax
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8039b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039b9:	8b 40 04             	mov    0x4(%rax),%eax
  8039bc:	48 63 d0             	movslq %eax,%rdx
  8039bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039c3:	8b 00                	mov    (%rax),%eax
  8039c5:	48 98                	cltq   
  8039c7:	48 83 c0 20          	add    $0x20,%rax
  8039cb:	48 39 c2             	cmp    %rax,%rdx
  8039ce:	73 b4                	jae    803984 <devpipe_write+0x42>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8039d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d4:	8b 40 04             	mov    0x4(%rax),%eax
  8039d7:	99                   	cltd   
  8039d8:	c1 ea 1b             	shr    $0x1b,%edx
  8039db:	01 d0                	add    %edx,%eax
  8039dd:	83 e0 1f             	and    $0x1f,%eax
  8039e0:	29 d0                	sub    %edx,%eax
  8039e2:	89 c6                	mov    %eax,%esi
  8039e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039ec:	48 01 d0             	add    %rdx,%rax
  8039ef:	0f b6 08             	movzbl (%rax),%ecx
  8039f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039f6:	48 63 c6             	movslq %esi,%rax
  8039f9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8039fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a01:	8b 40 04             	mov    0x4(%rax),%eax
  803a04:	8d 50 01             	lea    0x1(%rax),%edx
  803a07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a0b:	89 50 04             	mov    %edx,0x4(%rax)
	for (i = 0; i < n; i++) {
  803a0e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a17:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a1b:	0f 82 61 ff ff ff    	jb     803982 <devpipe_write+0x40>
	}

	return i;
  803a21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a25:	c9                   	leaveq 
  803a26:	c3                   	retq   

0000000000803a27 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803a27:	55                   	push   %rbp
  803a28:	48 89 e5             	mov    %rsp,%rbp
  803a2b:	48 83 ec 20          	sub    $0x20,%rsp
  803a2f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a33:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803a37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a3b:	48 89 c7             	mov    %rax,%rdi
  803a3e:	48 b8 29 1f 80 00 00 	movabs $0x801f29,%rax
  803a45:	00 00 00 
  803a48:	ff d0                	callq  *%rax
  803a4a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803a4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a52:	48 be b8 49 80 00 00 	movabs $0x8049b8,%rsi
  803a59:	00 00 00 
  803a5c:	48 89 c7             	mov    %rax,%rdi
  803a5f:	48 b8 91 11 80 00 00 	movabs $0x801191,%rax
  803a66:	00 00 00 
  803a69:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803a6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a6f:	8b 50 04             	mov    0x4(%rax),%edx
  803a72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a76:	8b 00                	mov    (%rax),%eax
  803a78:	29 c2                	sub    %eax,%edx
  803a7a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a7e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803a84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a88:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803a8f:	00 00 00 
	stat->st_dev = &devpipe;
  803a92:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a96:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803a9d:	00 00 00 
  803aa0:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803aa7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803aac:	c9                   	leaveq 
  803aad:	c3                   	retq   

0000000000803aae <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803aae:	55                   	push   %rbp
  803aaf:	48 89 e5             	mov    %rsp,%rbp
  803ab2:	48 83 ec 10          	sub    $0x10,%rsp
  803ab6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803aba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803abe:	48 89 c6             	mov    %rax,%rsi
  803ac1:	bf 00 00 00 00       	mov    $0x0,%edi
  803ac6:	48 b8 70 1b 80 00 00 	movabs $0x801b70,%rax
  803acd:	00 00 00 
  803ad0:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803ad2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ad6:	48 89 c7             	mov    %rax,%rdi
  803ad9:	48 b8 29 1f 80 00 00 	movabs $0x801f29,%rax
  803ae0:	00 00 00 
  803ae3:	ff d0                	callq  *%rax
  803ae5:	48 89 c6             	mov    %rax,%rsi
  803ae8:	bf 00 00 00 00       	mov    $0x0,%edi
  803aed:	48 b8 70 1b 80 00 00 	movabs $0x801b70,%rax
  803af4:	00 00 00 
  803af7:	ff d0                	callq  *%rax
}
  803af9:	c9                   	leaveq 
  803afa:	c3                   	retq   

0000000000803afb <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803afb:	55                   	push   %rbp
  803afc:	48 89 e5             	mov    %rsp,%rbp
  803aff:	48 83 ec 20          	sub    $0x20,%rsp
  803b03:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  803b06:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b0a:	75 35                	jne    803b41 <wait+0x46>
  803b0c:	48 b9 bf 49 80 00 00 	movabs $0x8049bf,%rcx
  803b13:	00 00 00 
  803b16:	48 ba ca 49 80 00 00 	movabs $0x8049ca,%rdx
  803b1d:	00 00 00 
  803b20:	be 09 00 00 00       	mov    $0x9,%esi
  803b25:	48 bf df 49 80 00 00 	movabs $0x8049df,%rdi
  803b2c:	00 00 00 
  803b2f:	b8 00 00 00 00       	mov    $0x0,%eax
  803b34:	49 b8 be 03 80 00 00 	movabs $0x8003be,%r8
  803b3b:	00 00 00 
  803b3e:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  803b41:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b44:	25 ff 03 00 00       	and    $0x3ff,%eax
  803b49:	48 98                	cltq   
  803b4b:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  803b52:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803b59:	00 00 00 
  803b5c:	48 01 d0             	add    %rdx,%rax
  803b5f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803b63:	eb 0c                	jmp    803b71 <wait+0x76>
		sys_yield();
  803b65:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  803b6c:	00 00 00 
  803b6f:	ff d0                	callq  *%rax
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803b71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b75:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803b7b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803b7e:	75 0e                	jne    803b8e <wait+0x93>
  803b80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b84:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803b8a:	85 c0                	test   %eax,%eax
  803b8c:	75 d7                	jne    803b65 <wait+0x6a>
}
  803b8e:	c9                   	leaveq 
  803b8f:	c3                   	retq   

0000000000803b90 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803b90:	55                   	push   %rbp
  803b91:	48 89 e5             	mov    %rsp,%rbp
  803b94:	48 83 ec 20          	sub    $0x20,%rsp
  803b98:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803b9b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b9e:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803ba1:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803ba5:	be 01 00 00 00       	mov    $0x1,%esi
  803baa:	48 89 c7             	mov    %rax,%rdi
  803bad:	48 b8 78 19 80 00 00 	movabs $0x801978,%rax
  803bb4:	00 00 00 
  803bb7:	ff d0                	callq  *%rax
}
  803bb9:	c9                   	leaveq 
  803bba:	c3                   	retq   

0000000000803bbb <getchar>:

int
getchar(void)
{
  803bbb:	55                   	push   %rbp
  803bbc:	48 89 e5             	mov    %rsp,%rbp
  803bbf:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803bc3:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803bc7:	ba 01 00 00 00       	mov    $0x1,%edx
  803bcc:	48 89 c6             	mov    %rax,%rsi
  803bcf:	bf 00 00 00 00       	mov    $0x0,%edi
  803bd4:	48 b8 20 24 80 00 00 	movabs $0x802420,%rax
  803bdb:	00 00 00 
  803bde:	ff d0                	callq  *%rax
  803be0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803be3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803be7:	79 05                	jns    803bee <getchar+0x33>
		return r;
  803be9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bec:	eb 14                	jmp    803c02 <getchar+0x47>
	if (r < 1)
  803bee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bf2:	7f 07                	jg     803bfb <getchar+0x40>
		return -E_EOF;
  803bf4:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803bf9:	eb 07                	jmp    803c02 <getchar+0x47>
	return c;
  803bfb:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803bff:	0f b6 c0             	movzbl %al,%eax
}
  803c02:	c9                   	leaveq 
  803c03:	c3                   	retq   

0000000000803c04 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803c04:	55                   	push   %rbp
  803c05:	48 89 e5             	mov    %rsp,%rbp
  803c08:	48 83 ec 20          	sub    $0x20,%rsp
  803c0c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c0f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803c13:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c16:	48 89 d6             	mov    %rdx,%rsi
  803c19:	89 c7                	mov    %eax,%edi
  803c1b:	48 b8 ec 1f 80 00 00 	movabs $0x801fec,%rax
  803c22:	00 00 00 
  803c25:	ff d0                	callq  *%rax
  803c27:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c2e:	79 05                	jns    803c35 <iscons+0x31>
		return r;
  803c30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c33:	eb 1a                	jmp    803c4f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803c35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c39:	8b 10                	mov    (%rax),%edx
  803c3b:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803c42:	00 00 00 
  803c45:	8b 00                	mov    (%rax),%eax
  803c47:	39 c2                	cmp    %eax,%edx
  803c49:	0f 94 c0             	sete   %al
  803c4c:	0f b6 c0             	movzbl %al,%eax
}
  803c4f:	c9                   	leaveq 
  803c50:	c3                   	retq   

0000000000803c51 <opencons>:

int
opencons(void)
{
  803c51:	55                   	push   %rbp
  803c52:	48 89 e5             	mov    %rsp,%rbp
  803c55:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803c59:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803c5d:	48 89 c7             	mov    %rax,%rdi
  803c60:	48 b8 54 1f 80 00 00 	movabs $0x801f54,%rax
  803c67:	00 00 00 
  803c6a:	ff d0                	callq  *%rax
  803c6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c73:	79 05                	jns    803c7a <opencons+0x29>
		return r;
  803c75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c78:	eb 5b                	jmp    803cd5 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803c7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c7e:	ba 07 04 00 00       	mov    $0x407,%edx
  803c83:	48 89 c6             	mov    %rax,%rsi
  803c86:	bf 00 00 00 00       	mov    $0x0,%edi
  803c8b:	48 b8 be 1a 80 00 00 	movabs $0x801abe,%rax
  803c92:	00 00 00 
  803c95:	ff d0                	callq  *%rax
  803c97:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c9e:	79 05                	jns    803ca5 <opencons+0x54>
		return r;
  803ca0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ca3:	eb 30                	jmp    803cd5 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803ca5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ca9:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803cb0:	00 00 00 
  803cb3:	8b 12                	mov    (%rdx),%edx
  803cb5:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803cb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cbb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803cc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cc6:	48 89 c7             	mov    %rax,%rdi
  803cc9:	48 b8 06 1f 80 00 00 	movabs $0x801f06,%rax
  803cd0:	00 00 00 
  803cd3:	ff d0                	callq  *%rax
}
  803cd5:	c9                   	leaveq 
  803cd6:	c3                   	retq   

0000000000803cd7 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803cd7:	55                   	push   %rbp
  803cd8:	48 89 e5             	mov    %rsp,%rbp
  803cdb:	48 83 ec 30          	sub    $0x30,%rsp
  803cdf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ce3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ce7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803ceb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803cf0:	75 07                	jne    803cf9 <devcons_read+0x22>
		return 0;
  803cf2:	b8 00 00 00 00       	mov    $0x0,%eax
  803cf7:	eb 4b                	jmp    803d44 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803cf9:	eb 0c                	jmp    803d07 <devcons_read+0x30>
		sys_yield();
  803cfb:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  803d02:	00 00 00 
  803d05:	ff d0                	callq  *%rax
	while ((c = sys_cgetc()) == 0)
  803d07:	48 b8 c4 19 80 00 00 	movabs $0x8019c4,%rax
  803d0e:	00 00 00 
  803d11:	ff d0                	callq  *%rax
  803d13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d1a:	74 df                	je     803cfb <devcons_read+0x24>
	if (c < 0)
  803d1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d20:	79 05                	jns    803d27 <devcons_read+0x50>
		return c;
  803d22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d25:	eb 1d                	jmp    803d44 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803d27:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803d2b:	75 07                	jne    803d34 <devcons_read+0x5d>
		return 0;
  803d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  803d32:	eb 10                	jmp    803d44 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803d34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d37:	89 c2                	mov    %eax,%edx
  803d39:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d3d:	88 10                	mov    %dl,(%rax)
	return 1;
  803d3f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803d44:	c9                   	leaveq 
  803d45:	c3                   	retq   

0000000000803d46 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d46:	55                   	push   %rbp
  803d47:	48 89 e5             	mov    %rsp,%rbp
  803d4a:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803d51:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803d58:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803d5f:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d6d:	eb 76                	jmp    803de5 <devcons_write+0x9f>
		m = n - tot;
  803d6f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803d76:	89 c2                	mov    %eax,%edx
  803d78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d7b:	29 c2                	sub    %eax,%edx
  803d7d:	89 d0                	mov    %edx,%eax
  803d7f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803d82:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d85:	83 f8 7f             	cmp    $0x7f,%eax
  803d88:	76 07                	jbe    803d91 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803d8a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803d91:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d94:	48 63 d0             	movslq %eax,%rdx
  803d97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d9a:	48 63 c8             	movslq %eax,%rcx
  803d9d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803da4:	48 01 c1             	add    %rax,%rcx
  803da7:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803dae:	48 89 ce             	mov    %rcx,%rsi
  803db1:	48 89 c7             	mov    %rax,%rdi
  803db4:	48 b8 b5 14 80 00 00 	movabs $0x8014b5,%rax
  803dbb:	00 00 00 
  803dbe:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803dc0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dc3:	48 63 d0             	movslq %eax,%rdx
  803dc6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803dcd:	48 89 d6             	mov    %rdx,%rsi
  803dd0:	48 89 c7             	mov    %rax,%rdi
  803dd3:	48 b8 78 19 80 00 00 	movabs $0x801978,%rax
  803dda:	00 00 00 
  803ddd:	ff d0                	callq  *%rax
	for (tot = 0; tot < n; tot += m) {
  803ddf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803de2:	01 45 fc             	add    %eax,-0x4(%rbp)
  803de5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803de8:	48 98                	cltq   
  803dea:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803df1:	0f 82 78 ff ff ff    	jb     803d6f <devcons_write+0x29>
	}
	return tot;
  803df7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803dfa:	c9                   	leaveq 
  803dfb:	c3                   	retq   

0000000000803dfc <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803dfc:	55                   	push   %rbp
  803dfd:	48 89 e5             	mov    %rsp,%rbp
  803e00:	48 83 ec 08          	sub    $0x8,%rsp
  803e04:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803e08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e0d:	c9                   	leaveq 
  803e0e:	c3                   	retq   

0000000000803e0f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803e0f:	55                   	push   %rbp
  803e10:	48 89 e5             	mov    %rsp,%rbp
  803e13:	48 83 ec 10          	sub    $0x10,%rsp
  803e17:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e1b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803e1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e23:	48 be ef 49 80 00 00 	movabs $0x8049ef,%rsi
  803e2a:	00 00 00 
  803e2d:	48 89 c7             	mov    %rax,%rdi
  803e30:	48 b8 91 11 80 00 00 	movabs $0x801191,%rax
  803e37:	00 00 00 
  803e3a:	ff d0                	callq  *%rax
	return 0;
  803e3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e41:	c9                   	leaveq 
  803e42:	c3                   	retq   

0000000000803e43 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803e43:	55                   	push   %rbp
  803e44:	48 89 e5             	mov    %rsp,%rbp
  803e47:	48 83 ec 20          	sub    $0x20,%rsp
  803e4b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e4f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803e53:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  803e57:	48 ba f8 49 80 00 00 	movabs $0x8049f8,%rdx
  803e5e:	00 00 00 
  803e61:	be 1d 00 00 00       	mov    $0x1d,%esi
  803e66:	48 bf 11 4a 80 00 00 	movabs $0x804a11,%rdi
  803e6d:	00 00 00 
  803e70:	b8 00 00 00 00       	mov    $0x0,%eax
  803e75:	48 b9 be 03 80 00 00 	movabs $0x8003be,%rcx
  803e7c:	00 00 00 
  803e7f:	ff d1                	callq  *%rcx

0000000000803e81 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803e81:	55                   	push   %rbp
  803e82:	48 89 e5             	mov    %rsp,%rbp
  803e85:	48 83 ec 20          	sub    $0x20,%rsp
  803e89:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e8c:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803e8f:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  803e93:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  803e96:	48 ba 1b 4a 80 00 00 	movabs $0x804a1b,%rdx
  803e9d:	00 00 00 
  803ea0:	be 2d 00 00 00       	mov    $0x2d,%esi
  803ea5:	48 bf 11 4a 80 00 00 	movabs $0x804a11,%rdi
  803eac:	00 00 00 
  803eaf:	b8 00 00 00 00       	mov    $0x0,%eax
  803eb4:	48 b9 be 03 80 00 00 	movabs $0x8003be,%rcx
  803ebb:	00 00 00 
  803ebe:	ff d1                	callq  *%rcx

0000000000803ec0 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803ec0:	55                   	push   %rbp
  803ec1:	48 89 e5             	mov    %rsp,%rbp
  803ec4:	53                   	push   %rbx
  803ec5:	48 83 ec 48          	sub    $0x48,%rsp
  803ec9:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  803ecd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
	int num = VMX_VMCALL_IPCRECV;
  803ed4:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%rbp)

	if(!pg)
  803edb:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
  803ee0:	75 0e                	jne    803ef0 <ipc_host_recv+0x30>
		pg = (void*) KERNBASE;
  803ee2:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803ee9:	00 00 00 
  803eec:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

	a1 = (uint64_t) pg;
  803ef0:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803ef4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a2 = (uint64_t) 0;
  803ef8:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803eff:	00 
	a3 = (uint64_t) 0;
  803f00:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  803f07:	00 
	a4 = (uint64_t) 0;
  803f08:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803f0f:	00 
	a5 = 0;
  803f10:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
  803f17:	00 

	//doubt : do we require what the site says ?

	asm volatile("vmcall\n"
  803f18:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803f1b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803f1f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803f23:	4c 8b 45 d0          	mov    -0x30(%rbp),%r8
  803f27:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  803f2b:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  803f2f:	4c 89 c3             	mov    %r8,%rbx
  803f32:	0f 01 c1             	vmcall 
  803f35:	89 45 ec             	mov    %eax,-0x14(%rbp)
			  "b" (a3),
			  "D" (a4),
			  "S" (a5)
			: "cc", "memory");

	if (ret > 0)
  803f38:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f3c:	7e 36                	jle    803f74 <ipc_host_recv+0xb4>
	    panic("vmcall %d returned %d (> 0) in ipc_host_send", num, ret);
  803f3e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803f41:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803f44:	41 89 d0             	mov    %edx,%r8d
  803f47:	89 c1                	mov    %eax,%ecx
  803f49:	48 ba 38 4a 80 00 00 	movabs $0x804a38,%rdx
  803f50:	00 00 00 
  803f53:	be 54 00 00 00       	mov    $0x54,%esi
  803f58:	48 bf 11 4a 80 00 00 	movabs $0x804a11,%rdi
  803f5f:	00 00 00 
  803f62:	b8 00 00 00 00       	mov    $0x0,%eax
  803f67:	49 b9 be 03 80 00 00 	movabs $0x8003be,%r9
  803f6e:	00 00 00 
  803f71:	41 ff d1             	callq  *%r9
	return ret;
  803f74:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803f77:	48 83 c4 48          	add    $0x48,%rsp
  803f7b:	5b                   	pop    %rbx
  803f7c:	5d                   	pop    %rbp
  803f7d:	c3                   	retq   

0000000000803f7e <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803f7e:	55                   	push   %rbp
  803f7f:	48 89 e5             	mov    %rsp,%rbp
  803f82:	53                   	push   %rbx
  803f83:	48 83 ec 58          	sub    $0x58,%rsp
  803f87:	89 7d b4             	mov    %edi,-0x4c(%rbp)
  803f8a:	89 75 b0             	mov    %esi,-0x50(%rbp)
  803f8d:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  803f91:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	uint64_t a1;
	uint64_t a2;
	uint64_t a3;
	uint64_t a4;
	uint64_t a5;
	int ret = 0;
  803f94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	int num = VMX_VMCALL_IPCSEND;
  803f9b:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%rbp)

	if (!pg)
  803fa2:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  803fa7:	75 0e                	jne    803fb7 <ipc_host_send+0x39>
		pg = (void*)KERNBASE;
  803fa9:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  803fb0:	00 00 00 
  803fb3:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	a1 = (uint64_t)to_env;
  803fb7:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  803fba:	48 98                	cltq   
  803fbc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	a2 = (uint64_t)val;
  803fc0:	8b 45 b0             	mov    -0x50(%rbp),%eax
  803fc3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	a3 = (uint64_t)pg;
  803fc7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803fcb:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	a4 = (uint64_t)perm;
  803fcf:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  803fd2:	48 98                	cltq   
  803fd4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	a5 = 0;
  803fd8:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803fdf:	00 

	int r = -E_IPC_NOT_RECV;
  803fe0:	c7 45 c4 f8 ff ff ff 	movl   $0xfffffff8,-0x3c(%rbp)
	asm volatile("vmcall\n"
  803fe7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803fea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803fee:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803ff2:	4c 8b 45 d8          	mov    -0x28(%rbp),%r8
  803ff6:	48 8b 7d d0          	mov    -0x30(%rbp),%rdi
  803ffa:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  803ffe:	4c 89 c3             	mov    %r8,%rbx
  804001:	0f 01 c1             	vmcall 
  804004:	89 45 f4             	mov    %eax,-0xc(%rbp)
			       "D" (a4),
			       "S" (a5)
			     : "cc", "memory");


}
  804007:	48 83 c4 58          	add    $0x58,%rsp
  80400b:	5b                   	pop    %rbx
  80400c:	5d                   	pop    %rbp
  80400d:	c3                   	retq   

000000000080400e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80400e:	55                   	push   %rbp
  80400f:	48 89 e5             	mov    %rsp,%rbp
  804012:	48 83 ec 18          	sub    $0x18,%rsp
  804016:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804019:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804020:	eb 4e                	jmp    804070 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  804022:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804029:	00 00 00 
  80402c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80402f:	48 98                	cltq   
  804031:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804038:	48 01 d0             	add    %rdx,%rax
  80403b:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804041:	8b 00                	mov    (%rax),%eax
  804043:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804046:	75 24                	jne    80406c <ipc_find_env+0x5e>
			return envs[i].env_id;
  804048:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80404f:	00 00 00 
  804052:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804055:	48 98                	cltq   
  804057:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80405e:	48 01 d0             	add    %rdx,%rax
  804061:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804067:	8b 40 08             	mov    0x8(%rax),%eax
  80406a:	eb 12                	jmp    80407e <ipc_find_env+0x70>
	for (i = 0; i < NENV; i++) {
  80406c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804070:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804077:	7e a9                	jle    804022 <ipc_find_env+0x14>
	}
	return 0;
  804079:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80407e:	c9                   	leaveq 
  80407f:	c3                   	retq   

0000000000804080 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804080:	55                   	push   %rbp
  804081:	48 89 e5             	mov    %rsp,%rbp
  804084:	48 83 ec 18          	sub    $0x18,%rsp
  804088:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80408c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804090:	48 c1 e8 15          	shr    $0x15,%rax
  804094:	48 89 c2             	mov    %rax,%rdx
  804097:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80409e:	01 00 00 
  8040a1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040a5:	83 e0 01             	and    $0x1,%eax
  8040a8:	48 85 c0             	test   %rax,%rax
  8040ab:	75 07                	jne    8040b4 <pageref+0x34>
		return 0;
  8040ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8040b2:	eb 53                	jmp    804107 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8040b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040b8:	48 c1 e8 0c          	shr    $0xc,%rax
  8040bc:	48 89 c2             	mov    %rax,%rdx
  8040bf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8040c6:	01 00 00 
  8040c9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040cd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8040d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040d5:	83 e0 01             	and    $0x1,%eax
  8040d8:	48 85 c0             	test   %rax,%rax
  8040db:	75 07                	jne    8040e4 <pageref+0x64>
		return 0;
  8040dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8040e2:	eb 23                	jmp    804107 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8040e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040e8:	48 c1 e8 0c          	shr    $0xc,%rax
  8040ec:	48 89 c2             	mov    %rax,%rdx
  8040ef:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8040f6:	00 00 00 
  8040f9:	48 c1 e2 04          	shl    $0x4,%rdx
  8040fd:	48 01 d0             	add    %rdx,%rax
  804100:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804104:	0f b7 c0             	movzwl %ax,%eax
}
  804107:	c9                   	leaveq 
  804108:	c3                   	retq   
